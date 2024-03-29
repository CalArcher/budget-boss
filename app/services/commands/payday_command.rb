module Commands
  class PaydayCommand < BaseCommand
    def initialize(command:, to_user:)
      # format for this command to be valid = "payday #{amount}"
      @command = command
      @to_user = to_user
    end

    def self.command_key
      'payday'
    end

    def split_command
      @_split_command ||= @command.downcase.split(' ')
    end

    def correct_length?
      split_command.length == 2
    end

    def payday_amount
      @_payday_amount ||= clean_amount&.to_f&.round(2)
    end

    def clean_amount
      @_clean_amount ||= strip_leading_dollars(split_command.last)
    end

    def reasonable_payday?
      (payday_amount > ENV['MIN_PAYDAY'].to_f) && (payday_amount < ENV['MAX_PAYDAY'].to_f)
    end

    def valid_command?
      [
        correct_length?,
        numeric?(clean_amount),
        reasonable_payday?,
      ].all?
    end

    def notify_validation_error
      if !reasonable_payday?
        error_message = "Paydays must be **greater** than #{ENV['MIN_PAYDAY']} and **less** than #{ENV['MAX_PAYDAY']}"
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
      process_payday
    end

    private

    def process_payday
      description = "payday from #{@to_user.name}"
      UpdateSheetService.new(to_user: @to_user, amount: payday_amount, description: description).payday
    end
  end
end