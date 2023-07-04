module Commands
  class UserSpentCommand < BaseCommand
    def initialize(command:, to_user:)
      # format for this command to be valid = "#{user_name} spent #{amount}"
      @command = command
      @to_user = to_user
    end

    def self.command_key
      'spent'
    end

    def command_user
      ::User.find_by(name: split_command[0])
    end

    def split_command
      @_split_command ||= @command.downcase.split(' ')
    end

    def amount
      split_command.last&.to_f&.round(2)
    end

    def is_spent_command?
      split_command[1] == 'spent'
    end

    def correct_length?
      split_command.length == 3
    end

    def transaction_amount
      @_transaction_amount ||= split_command.last&.to_f
    end

    def valid_tx_amount?
      transaction_amount > 0
    end

    def valid_command?
      [
        correct_length?,
        is_spent_command?,
        is_reasonable_tx_amount?(transaction_amount),
        command_user.present?,
        numeric?(split_command.last),
        valid_tx_amount?,
      ].all?
    end

    def notify_validation_error
      if command_user.nil?
        error_message = "#{split_command[0]} is not a recognized user."
        send_sms(@to_user, error_message)
      elsif transaction_amount <= 0
        error_message = "Failed to log spend. Amount must be greater than 0."
        send_sms(@to_user, error_message)
      elsif !is_reasonable_tx_amount?(transaction_amount)
        error_message = "Oops! $#{transaction_amount} seems a bit high."
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
      puts('execute called 76')
      create_user_spend_transaction(@to_user, amount, command_user)
    end

    private

    def create_user_spend_transaction(to_user, amount, command_user)
      puts('ln 83')
      UpdateSheetService.new(to_user: to_user, amount: amount, command_user: command_user).user_transaction_spend
    end
 
  end
end