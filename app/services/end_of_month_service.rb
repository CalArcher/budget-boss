class EndOfMonthService
  include TimeHelper
  include SmsHelper

  def end_of_month?
    day == 1
  end

  def end_of_month_service
    return unless end_of_month?
    new_month_sheet = Sheet.find_or_create_sheet(month: month, yea: yearr)

    return if new_month_sheet.monthly_service == 1

    new_month_sheet.update!(
      monthly_service: 1,
    )

    build_and_send_reports
  end

  def user_1
    ::User.find(1)
  end

  def user_2
    ::User.find(2)
  end

  def build_and_send_reports
    last_month_sheet = Sheet.find_by(month: last_month, year: year_of_last_month)


    user_1_spent = last_month_sheet.user_1_spent
    user_1_remaining = last_month_sheet.user_1_budget

    user_2_spent = last_month_sheet.user_2_spent
    user_2_remaining = last_month_sheet.user_2_budget

    message = "Your end of month report is here! \n " \
      "#{user_1.name}, you spent #{user_1_spent}, and have #{user_1_remaining} left that will be " \
      "added your budget"
  end

  # def send_report(to_user, user_spent, user_remaining, last_month_sheet)
  #   together_spent = last_month_sheet.user_3_spent
  #   together_remaining = last_month_sheet.user_3_budget

  #   saved = last_month_sheet.saved

  #   user_budget_column = "#{to_user.key}_budget"

  #   together_budget_column = "#{to_user.key}_budget"


  #   starting_budget = Sheet.find_by(month: month, year: year)[user_budget_column]
  
  #   user_name = to_user.name.capitalize

  #   operation = user_remaining > 0 ? 'added to' : 'subtracted from'

  #   message = "Hey #{user_name}, your end of month report is here! \n " \
  #   "You spent #{user_spent}, and have #{user_remaining} left that will be " \
  #   "#{operation} your new budget.\n This month, your budget is #{starting_budget}.\n" \
  #   "Together, you spent #{together_spent}, and had #{together_remaining} left over" \
  #   "This month, your shared budget is "
  # end

end