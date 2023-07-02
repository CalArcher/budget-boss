module Commands
  class BillCommand < BaseCommand
    def initialize(command:, to_user:)
      # format for this command to be valid = "create bill #{bill_name} #{amount}"
      @command = command
      @to_user = to_user
    end

    def self.command_key
      'bill'
    end

    def split_command
      @_split_command ||= @command.downcase.split(' ')
    end

    def bill_name
      @_bill_name ||= split_command[2]
    end

    def command_type
      @_type_command ||= split_command[0]
    end

    def correct_length?
      split_command.length == 4
    end

    def all_bill_names
      @_all_bill_name ||= ::Bill.bill_names
    end

    def bill_amount
      @_bill_amount ||= split_command.last&.to_f&.round(2)
    end

    def correct_command_type?
      (all_bill_names.include?(bill_name) && command_type == 'update') ||
        (!all_bill_names.include?(bill_name) && command_type == 'create')
    end

    def registered_commands
      CommandRegistry.list_registered_commands
    end

    def bill_protected_name?
      registered_commands.keys.include?(bill_name)
    end

    def valid_bill_amount?
      bill_amount > 0
    end

    def valid_command?
      [
        correct_length?,
        correct_command_type?,
        valid_bill_amount?,
        !bill_protected_name?,
        numeric?(split_command.last),
      ].all?
    end

    def validate
      if valid_command?
        true
      else
        if bill_protected_name?
          error_message = "#{bill_name.capitalize} is a protected word. Please choose " \
            "a different name for your new bill"
          send_sms(@to_user, error_message)
        else
          invalid_command(@to_user, @command)
        end
      end
    end

    def execute
      create_update_bill(name: bill_name, amount: bill_amount)
    end

    private

    def create_update_bill(name:, amount:)
      bill_service = UpdateBillService.new(to_user: @to_user, amount: amount, bill_name: name)
      if command_type == 'create'
        bill_service.create_bill
      else
        bill_service.update_bill
      end
    end
 
  end
end