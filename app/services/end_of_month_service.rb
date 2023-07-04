class EndOfMonthService
  include TimeHelper
  include SmsHelper

  def end_of_month?
    current_day == 1 
  end

  def end_of_month_service
    return unless end_of_month?
    new_month_sheet = Sheet.find_or_create_sheet(current_month, current_year, true)

    # prevent service multiple times on first day of month
    return if new_month_sheet.monthly_service == 1 

    new_month_sheet.update!(
      monthly_service: 1,
    )

    last_month_sheet = Sheet.find_by(month: last_month, year: year_of_last_month)

    report_users.each do |user|
      send_report(user, last_month_sheet, new_month_sheet)
    end
  end

  def report_users
    ::User.where(id: 2)
    # ::User.where(send_report: 1)
  end

  def send_report(to_user, last_month_sheet, new_month_sheet)
    together_spent = last_month_sheet.user_3_spent
    together_remaining = last_month_sheet.user_3_budget
    together_new_budget = new_month_sheet.user_3_budget

    user_budget_column = "#{to_user.key}_budget"
    user_spent_column = "#{to_user.key}_spent"

    user_new_budget = new_month_sheet[user_budget_column]
    user_last_spent = last_month_sheet[user_spent_column]
    user_remaining = last_month_sheet[user_budget_column]
  
    user_name = to_user.name.capitalize

    operation = user_remaining > 0 ? 'added to' : 'subtracted from'

    message = "Hey #{user_name}, your end of month report is here!\n" \
      "You spent $#{user_last_spent}, and have $#{user_remaining} left that will be " \
      "#{operation} your new budget.\nThis month, your budget is $#{user_new_budget}.\n" \
      "Together, you spent #{together_spent}, and had #{together_remaining} left over\n" \
      "This month, your shared budget is $#{together_new_budget}."

    send_sms(to_user, message)
  end

end