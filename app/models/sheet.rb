class Sheet < ApplicationRecord

  # Each new month, your total budget/income is all 4 paychecks from last month
  def self.new_starting_income
    Sheet.where(payday_count: 4).order(year: :desc, month: :desc).first.income
  end
end
