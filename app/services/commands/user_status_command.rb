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

    def validate
      if correct_length? && queried_user.present? && status_request?
        true
      else
        invalid_command(@to_user, @command)
      end
    end

    def execute
      get_status(queried_user)
    end

    private

    def get_status(user)
      user_budget_column = "#{user.key}_budget" # column name to query
      user_spent_column = "#{user.key}_spent" # column name to query

      sheet = ::Sheet.find_or_create_sheet(month, year)

      if sheet.nil?
        error_message = "Cannot find sheet, please try again"
        send_sms(@to_user, error_message)
        return
      end

      user_spent = sheet[user_spent_column]
      user_budget = sheet[user_budget_column]

      reply = "Remaining budget for #{user.name.capitalize} this month: $#{user_budget}. Total spent this month: $#{user_spent}."
      send_sms(@to_user, reply)
    end

  end
end