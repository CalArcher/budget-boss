module Commands
  class UserSpentCommand < BaseCommand
    def initialize(command:, to_user:)
      # format for this command to be valid = "#{user_name} spent #{amount} "${description}""
      @command = command.gsub(/“|”/, '"')
      @to_user = to_user
    end

    def self.command_key
      'spent'
    end

    def length_minus_description
      @command.gsub(/".*?"/, '').split(' ').length
    end

    def command_user
      ::User.find_by(name: split_command[0])
    end

    def split_command
      @_split_command ||= @command.downcase.split(' ')
    end

    def is_spent_command?
      split_command[1] == 'spent'
    end

    def correct_length?
      length_minus_description == 3
    end

    # finds text between first set of double quotes
    def parsed_description
        description = ''
        quote_count = 0
        @command.chars.each do |letter|
          if letter == '"' 
            quote_count += 1
          end
          if quote_count.between?(1, 2)
            description << letter
          end
        end
        quote_count == 2 ? description[1..-2] : nil
    end

    def valid_and_present_description
      parsed_description&.length&.between?(1, 40)
    end

    def clean_amount
      @_clean_amount ||= strip_leading_dollars(split_command[2])
    end

    def transaction_amount
      @_transaction_amount ||= clean_amount&.to_f&.round(2)
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
        numeric?(clean_amount),
        valid_tx_amount?,
        valid_and_present_description,
      ].all?
    end

    # TODO: DRY
    def notify_validation_error
      if command_user.nil?
        error_message = "**#{split_command[0]}** is not a recognized user."
        send_message(@to_user, error_message)
      elsif transaction_amount <= 0 && numeric?(clean_amount)
        error_message = "**Failed** to log spend. Amount must be greater than 0."
        send_message(@to_user, error_message)
      elsif !is_reasonable_tx_amount?(transaction_amount)
        error_message = "**Oops!** $#{transaction_amount} seems a bit high."
        send_message(@to_user, error_message)
      elsif valid_and_present_description.nil?
        error_message = "**Invalid description**. Description must be between double " \
          "quotes and less than 40 characters."
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
      create_user_spend_transaction(@to_user, transaction_amount, command_user, parsed_description)
    end

    private

    def create_user_spend_transaction(to_user, amount, command_user, description)
      puts description
      UpdateSheetService.new(
        to_user: to_user,
        amount: amount,
        command_user: command_user,
        description: description
        ).user_transaction_spend
    end
 
  end
end