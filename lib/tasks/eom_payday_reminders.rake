namespace :reminder do
  desc "Send reminders"
  task send_eom_payday_reminders: :environment do
    PaydayReminderService.new.send_eom_payday_reminders
  end
end