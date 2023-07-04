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

    # todo
#     Jul 2 11:23:06 PM  I, [2023-07-03T03:23:06.402091 #71]  INFO -- : [ae6f243f-2e33-4cc8-a46b-8b7d9b672359] Started POST "/receive_text" for 172.71.147.129 at 2023-07-03 03:23:06 +0000
# Jul 2 11:23:06 PM  I, [2023-07-03T03:23:06.403006 #71]  INFO -- : [ae6f243f-2e33-4cc8-a46b-8b7d9b672359] Processing by TwilioController#receive_text as */*
# Jul 2 11:23:06 PM  I, [2023-07-03T03:23:06.403082 #71]  INFO -- : [ae6f243f-2e33-4cc8-a46b-8b7d9b672359]   Parameters: {"ToCountry"=>"US", "ToState"=>"", "SmsMessageSid"=>"SM8067394425f4ca2de63c18116b81875f", "NumMedia"=>"0", "ToCity"=>"", "FromZip"=>"", "SmsSid"=>"SM8067394425f4ca2de63c18116b81875f", "FromState"=>"CO", "SmsStatus"=>"received", "FromCity"=>"", "Body"=>"Update bill money_machine 0", "FromCountry"=>"US", "To"=>"+18773461420", "ToZip"=>"", "NumSegments"=>"1", "MessageSid"=>"SM8067394425f4ca2de63c18116b81875f", "AccountSid"=>"AC31a8e50dd62ffbe4636c760dda4ad63c", "From"=>"+17206267560", "ApiVersion"=>"2010-04-01"}
# Jul 2 11:23:06 PM  I, [2023-07-03T03:23:06.403236 #71]  INFO -- : [ae6f243f-2e33-4cc8-a46b-8b7d9b672359] {"ToCountry"=>"US", "ToState"=>"", "SmsMessageSid"=>"SM8067394425f4ca2de63c18116b81875f", "NumMedia"=>"0", "ToCity"=>"", "FromZip"=>"", "SmsSid"=>"SM8067394425f4ca2de63c18116b81875f", "FromState"=>"CO", "SmsStatus"=>"received", "FromCity"=>"", "Body"=>"Update bill money_machine 0", "FromCountry"=>"US", "To"=>"+18773461420", "ToZip"=>"", "NumSegments"=>"1", "MessageSid"=>"SM8067394425f4ca2de63c18116b81875f", "AccountSid"=>"AC31a8e50dd62ffbe4636c760dda4ad63c", "From"=>"+17206267560", "ApiVersion"=>"2010-04-01", "controller"=>"twilio", "action"=>"receive_text"}
# Jul 2 11:23:06 PM  {"ToCountry"=>"US", "ToState"=>"", "SmsMessageSid"=>"SM8067394425f4ca2de63c18116b81875f", "NumMedia"=>"0", "ToCity"=>"", "FromZip"=>"", "SmsSid"=>"SM8067394425f4ca2de63c18116b81875f", "FromState"=>"CO", "SmsStatus"=>"received", "FromCity"=>"", "Body"=>"Update bill money_machine 0", "FromCountry"=>"US", "To"=>"+18773461420", "ToZip"=>"", "NumSegments"=>"1", "MessageSid"=>"SM8067394425f4ca2de63c18116b81875f", "AccountSid"=>"AC31a8e50dd62ffbe4636c760dda4ad63c", "From"=>"+17206267560", "ApiVersion"=>"2010-04-01", "controller"=>"twilio", "action"=>"receive_text"}
# Jul 2 11:23:06 PM  sent to +17206267560: "update bill money_machine 0" is an invalid command. Reply "List commands" to show valid commands
# Jul 2 11:23:07 PM  sent to +17206267560: Bill 'money_machine' updated from $-100.0 to $0.0 per month

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

    def notify_validation_error
      if bill_protected_name?
        error_message = "#{bill_name.capitalize} is a protected word. Please choose " \
          "a different name for your new bill"
        send_sms(@to_user, error_message)
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