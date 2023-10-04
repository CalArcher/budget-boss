class SheetCreateService
  include TimeHelper
  include SmsHelper

  def initialize(month, year, set_starting_values)
    @month = month
    @year = year
    @set_starting_values = set_starting_values
  end

  def find_or_create
    found_sheet = Sheet.find_by(month: @month, year: @year)
    found_sheet ||= Sheet.create!(
        month: @month,
        year: @year,
        payday_sum: 0,
        income: 0,
        bill_totals: 0,
        user_1_spent: 0,
        user_2_spent: 0,
        user_3_spent: 0,
        payday_count: 0,
        saved: 0,
    )
    if @set_starting_values == true
      set_starting_values(found_sheet)
    end
    found_sheet
  end

  def last_month_valid_sheet
    Sheet.find_by(payday_count: 4, month: last_month, year: year_of_last_month)
  end

  # Each new month, your starting budget/income is all 4 paychecks from last month
  def new_starting_income
    last_sheet = last_month_valid_sheet
    if last_sheet.blank?
      error_message = 'Starting income not set, could not find last month sheet'
      admin_message(error_message)
      return
    end

    starting_income = last_sheet.payday_sum
  end

  def set_starting_values(sheet)
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
      bill_totals: bill_totals,
      user_3_budget: user_3_value,
      user_1_budget: user_1_value,
      user_2_budget: user_2_value,
    )
  end
end