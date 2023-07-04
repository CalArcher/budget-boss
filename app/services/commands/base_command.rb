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

    # because regex is boring :) recursively remove only leading $
    # better performance than .sub(/\A\$+/, "")
    def strip_leading_dollars(str)
      if str[0] == '$'
        n_str = str.slice(1..-1)
        strip_leading_dollars(n_str)
      else
        str
      end
    end

    def is_reasonable_tx_amount?(amount)
      amount <= 2000
    end

    def self.command_key
      raise NotImplementedError, 'This method should be overridden in a child class'
    end
      
  end
end