namespace :service do
  desc "EOM service"
  task end_of_month_service: :environment do
    Rails.env = 'production'
    EndOfMonthService.new.end_of_month_service
  end
end
