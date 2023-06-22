module Commands
  class BaseCommand
    include TimeHelper
    include SmsHelper

    def initialize(command:, user_key:)
      @command = command
      @user_key = user_key
    end

    def validate
      raise NotImplementedError, 'This method should be overridden in a child class'
    end

    def execute
      raise NotImplementedError, 'This method should be overridden in a child class'
    end

    protected

    def invalid_command(to_user, original_command)
      error_message = "\"#{original_command}\" is an invalid command. Reply \"List commands\" to show valid commands"
      send_sms(to_user, error_message)
    end

    def numeric?(input)
      Float(input) != nil rescue false
    end

    def is_reasonable_amount?(amount)
      amount <= 2000
    end

    def current_sheet
      ::Sheet.find_or_create_sheet(month, year)
    end

    def self.command_key
      raise NotImplementedError, 'This method should be overridden in a child class'
    end
      
  end
end