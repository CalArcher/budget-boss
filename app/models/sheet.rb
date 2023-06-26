class Sheet < ApplicationRecord
  include TimeHelper
  include SmsHelper

  def self.find_or_create_sheet(month, year)
    existing_sheet = Sheet.find_by(month: month, year: year)
    existing_sheet || begin
      new_sheet = Sheet.create!(
        month: month,
        year: year,
        income: 0,
        bill_totals: 0,
        user_1_spent: 0,
        user_2_spent: 0,
        user_3_spent: 0,
        payday_count: 0,
        saved: 0,
      )
      set_starting_values(new_sheet)
      new_sheet
    end
  end

  def last_month_valid_sheet
    Sheet.find_by(payday_count: 4, month: last_month, year: year_of_last_month)
  end

  # Each new month, your starting budget/income is all 4 paychecks from last month
  def self.new_starting_income
    last_sheet = last_month_valid_sheet
    if last_sheet.nil?
      error_message = 'Starting income not set, could not find last month sheet'
      admin_message(error_message)
      return
    end

    starting_income = last_sheet.income
  end

  def self.set_starting_values(sheet)
    last_sheet = last_month_valid_sheet

    starting_income = new_starting_income.to_f
    bill_totals = Bill.bill_totals
    savings_amount = ENV['MONTHLY_SAVINGS'].to_f
    leftover_income = starting_income - (bill_totals + savings_amount)

    user_1_value = (leftover_income / 4) + last_sheet.user_1_budget.to_f
    user_2_value = (leftover_income / 4) + last_sheet.user_2_budget.to_f
    user_3_value = (leftover_income / 2) + last_sheet.user_3_budget.to_f

    sheet.update!(
      income: starting_income,
      bill_totals: bill_totals
      user_3_budget: user_3_value,
      user_1_budget: user_1_value,
      user_2_budget: user_2_value,
    )
  end
end
