module Commands
  class ListCommand < BaseCommand
    def initialize(command:, to_user:)
      @command = command
      @to_user = to_user
    end

    def self.command_key
      'list'
    end

    def is_valid_list_command?
      all_list_commands = [
        'list commands',
        'list bills',
        'list paydays'
      ]
      all_list_commands.include?(@command.downcase)
    end

    def notify_validation_error
      invalid_command(@to_user, @command)
    end

    def validate
      if is_valid_list_command?
        'valid!'
      else
        notify_validation_error
      end
    end

    def execute
      run_list_command
    end

    private

    def all_bill_names
      @_all_bill_name ||= ::Bill.bill_names
    end

    def run_list_command
      case @command.downcase
      when 'list commands'
        list_commands
      when 'list bills'
        list_bills
      when 'list paydays'
        list_paydays
      end
    end

    def all_command_names
      [
        'update bill (bill_name) (amount)',
        'create bill (new_bill_name) (amount)',
        'cal status',
        'sabrina status',
        'together status',
        'payday (amount)',
        'cal spent (amount)',
        'sabrina spent (amount)',
        'together spent (amount)',
        'list commands',
        'list bills',
      ]
    end

    def list_paydays
      sheet = Sheet.find_or_create_sheet(current_month, current_year)
      paydays = sheet&.payday_count 
      total = sheet&.payday_sum

      count_text =  case paydays
                    when 0 then 'have been no paydays'
                    when 1 then 'has been 1 payday'
                    else "have been #{paydays} paydays"
                    end

      reply = "There #{count_text} this month totalling $#{total}."
      send_message(@to_user, reply)
    end
 
    def list_bills
      all_bills_formatted = ::Bill.all.order(:bill_name).map do |bill|
        "- #{bill.bill_name}: $#{bill.bill_amount}/month"
      end.join(",\n")
      reply = "Here are the names of your bills and their amounts:\n\n#{all_bills_formatted}."
      send_message(@to_user, reply)
    end

    def list_commands
      md_format_commands = all_command_names.map do |command|
        "- #{command}\n"
      end.join('')
      reply = "**Valid commands:** \n#{md_format_commands}"
      send_message(@to_user, reply)
    end

  end
end