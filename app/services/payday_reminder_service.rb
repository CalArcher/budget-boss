class PaydayReminderService
  include TimeHelper
  include SmsHelper

  def end_of_month?
    current_day >= 27
  end

  def send_eom_payday_reminders
    return unless end_of_month?
    current_sheet = Sheet.find_by(month: current_month, year: current_year)

    payday_count = current_sheet.payday_count
    return if payday_count == 4

    payday_text = "only #{payday_count}"
    if payday_count == 0
      payday_text = "no"
    end

    report_users.each do |user|
      message = "Its the end of the month and #{payday_text} paydays have been logged. " \
        'Please remember to log your paydays by replying "Payday (amount)".'
      send_message(user, message)
    end
  end

  def report_users
    ::User.where(send_report: 1)
  end
end