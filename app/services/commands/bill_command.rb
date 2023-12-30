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

    def clean_amount
      @_clean_amount ||= strip_leading_dollars(split_command[3])
    end

    def correct_length?
      if command_type == 'delete'
        split_command.length == 3
      else
        split_command.length == 4
      end
    end

    def all_bill_names
      @_all_bill_name ||= ::Bill.bill_names
    end

    def bill_amount
      @_bill_amount ||= clean_amount&.to_f&.round(2)
    end

    def correct_command_type?
      (all_bill_names.include?(bill_name) && command_type == 'update') ||
        (!all_bill_names.include?(bill_name) && command_type == 'create') ||
        (all_bill_names.include?(bill_name) && command_type == 'delete')
    end

    def registered_commands
      CommandRegistry.list_registered_commands
    end

    def bill_protected_name?
      registered_commands.keys.include?(bill_name)
    end

    def valid_bill_amount?
      if command_type == 'delete'
        bill_amount.nil?
      else
        bill_amount > 0 && numeric?(clean_amount)
      end
    end

    def bill_correct_location?
      split_command[1] == 'bill'
    end

    def valid_command?
      [
        correct_length?,
        correct_command_type?,
        valid_bill_amount?,
        !bill_protected_name?,
        bill_correct_location?,
      ].all?
    end

    # TODO: DRY
    def notify_validation_error
      if bill_protected_name?
        error_message = "**#{bill_name.capitalize}** is a protected word. Please choose " \
          "a different name for your new bill"
        send_message(@to_user, error_message)
      elsif !correct_command_type? && (command_type == 'update' || command_type == 'delete')
        error_message = "**#{bill_name.capitalize}** does not exist"
        send_message(@to_user, error_message)
      elsif !correct_command_type? && command_type == 'create'
        error_message = "**#{bill_name.capitalize}** already exists"
        send_message(@to_user, error_message)
      else
        invalid_command(@to_user, @command)
      end
    end

    def validate
      if valid_command?
        'valid!'
      else
        notify_validation_error
      end
    end

    def execute
      case command_type
      when 'delete'
        destroy_bill
      when 'update', 'create'
        create_update_bill(name: bill_name, amount: bill_amount)
      end
    end

    private

    def destroy_bill
      found_bill = Bill.find_by(bill_name: bill_name)
      found_bill.destroy!
      reply = "**#{found_bill.bill_name}** has been deleted"
      send_message(@to_user, reply)
    end

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