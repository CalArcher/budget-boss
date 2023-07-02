namespace :service do
  desc "EOM service"
  task end_of_month_service: :environment do
    EndOfMonthService.new.end_of_month_service
  end
end