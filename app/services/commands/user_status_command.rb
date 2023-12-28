module Commands
  class UserStatusCommand < BaseCommand
    def initialize(command:, to_user:)
      # format for this command to be valid = "#{user_name} status"
      @command = command
      @to_user = to_user
    end

    def self.command_key
      'status'
    end

    def split_command
      @command.downcase.split(' ')
    end

    def user_name_from_command
      split_command[0]
    end

    def correct_length?
      split_command.length == 2
    end

    def status_request?
      split_command[1] == 'status'
    end

    def queried_user
      ::User.find_by(name: user_name_from_command)
    end
    
    def all_users?
      split_command.first == 'all'
    end

    def valid_command?
      [
        correct_length?,
        (queried_user.present? || all_users?),
        status_request?,
      ].all?
    end

    def notify_validation_error
      invalid_command(@to_user, @command)
    end

    def validate
      if valid_command?
        'valid!'
      else
        notify_validation_error
      end
    end

    def execute
      if all_users?
        get_all_user_status
      else
        get_status(queried_user)
      end
    end

    private

    def get_all_user_status
      sheet = ::Sheet.find_or_create_sheet(current_month, current_year)

      if sheet.nil?
        error_message = "Cannot find sheet, please try again"
        send_message(@to_user, error_message)
        return
      end

      reply_message = ['**So far this month:**']

      ::User.all.each do |user|
        user_budget_column = "#{user.key}_budget"
        user_spent_column = "#{user.key}_spent"

        spent_value = sheet[user_spent_column].to_i
        remaining_value = sheet[user_budget_column].to_i

        spent_message = "#{user.name.capitalize} spent: $#{spent_value}"
        remaining_message = "#{user.name.capitalize} remaining budget: $#{remaining_value}"

        reply_message << spent_message
        reply_message << remaining_message
      end
      send_message(@to_user, reply_message.join("\n- "))
    end

    def get_status(user)
      user_budget_column = "#{user.key}_budget" # column name to query
      user_spent_column = "#{user.key}_spent" # column name to query

      sheet = ::Sheet.find_or_create_sheet(current_month, current_year)

      if sheet.nil?
        error_message = "Cannot find sheet, please try again"
        send_message(@to_user, error_message)
        return
      end

      user_spent = sheet[user_spent_column]
      user_budget = sheet[user_budget_column]

      reply = "Remaining budget for **#{user.name.capitalize}** this " /
        "month: $#{user_budget}. Total spent this month: $#{user_spent}."
      send_message(@to_user, reply)
    end

  end
end