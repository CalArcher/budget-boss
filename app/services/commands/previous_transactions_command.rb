module Commands
  class PreviousTransactionsCommand < BaseCommand
    def initialize(command:, to_user:)
      # format for this command to be valid = "previous #{number} transactions"
      @command = command
      @to_user = to_user
    end

    def self.command_key
      'previous'
    end

    def correct_length?
      split_command.length == 3
    end

    def split_command
      @_split_command ||= @command.downcase.split(' ')
    end

    def valid_number?
      numeric?(split_command[1])
    end

    def correct_first_last?
      split_command[0] == 'previous' && split_command[2] == 'transactions'
    end

    def is_valid_list_command?
      [
        valid_number?,
        correct_length?,
        correct_first_last?,
      ].all?
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
      send_last_x_transactions
    end

    private

    def send_last_x_transactions
      requested_number = split_command[1]&.to_i
      max_num = [35, requested_number].min

      last_x = ::Transaction.where(tx_type: 'spend').order(created_at: :desc).limit(requested_number)

      formatted_transactions = last_x.map do |tx|
        tx_user_name = ::User.find_by(key: tx.tx_name)&.name&.capitalize
        "- **#{tx.created_at.day}/#{tx.created_at.month}:** #{tx_user_name} spent $#{tx.tx_amount} on \"#{tx.tx_description}\""
      end.join("\n")

      reply = "**The last #{requested_number} transactions are:**\n#{formatted_transactions}"
      send_message(@to_user, reply)
    end
  end
end