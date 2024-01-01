module Commands
  class CategoryChargeCommand < BaseCommand
    def initialize(command:, to_user:)
      # format for this command to be valid = "charge #{category name} #{amount} "description""
      @command = command.gsub(/“|”/, '"')
      @to_user = to_user
    end

    def self.command_key
      'charge'
    end

    def length_minus_description
      @command.gsub(/".*?"/, '').split(' ').length
    end

    def split_command
      @_split_command ||= @command.downcase.split(' ')
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

    def matching_category
      @_matching_category ||= Category.find_by(name: split_command[1])
    end

    def matching_category_name
      @_matching_category_name ||= matching_category.name.capitalize
    end

    def valid_command?
      [
        correct_length?,
        is_reasonable_tx_amount?(transaction_amount),
        numeric?(clean_amount),
        valid_tx_amount?,
        valid_and_present_description,
        matching_category.present?
      ].all?
    end

    # TODO: DRY
    def notify_validation_error
      if transaction_amount <= 0 && numeric?(clean_amount)
        error_message = "**Failed** to log charge. Amount must be greater than 0."
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
      message = ''
      begin
        ActiveRecord::Base.transaction do
          update_category
          create_user_spend_transaction
          notify_if_over_budget
        end
        message = "Category **#{matching_category_name}** charge logged for $#{transaction_amount}. " \
          "Total spent this month for **#{matching_category_name}** is $#{matching_category.spent}"
      rescue StandardError => e
        message = "Error updating category **#{matching_category_name}**. Error: #{e.message}"
      end

      send_message(@to_user, message)
    end

    private

    def update_category
      matching_category.add_expense(transaction_amount)
    end

    def notify_if_over_budget
      over_budget = matching_category.spent - matching_category.budget
      if over_budget.positive?
        message = "**Attention**: Category **#{matching_category_name}** is over budget by $#{over_budget}."
        send_message(@to_user, message)
      end
    end

    def create_user_spend_transaction
      full_description = "#{matching_category_name}: #{parsed_description}"
      Transaction.create!(
        tx_name: 'charge',
        tx_type: 'spend',
        tx_amount: transaction_amount,
        tx_description: full_description,
        user_id: @to_user.id,
      )
    end
 
  end
end