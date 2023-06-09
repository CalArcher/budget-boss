class Sheet < ApplicationRecord

  def self.find_or_create_sheet(month, year)
    existing_sheet = Sheet.find_by(month: month, year: year)
    existing_sheet || begin
      existing_sheet = Sheet.create!(
        month: month,
        year: year,
        # income: new_starting_income,
        income: 6200,
        bill_totals: Bill.bill_totals,
        user_1_spent: 0,
        user_2_spent: 0,
        user_3_spent: 0,
        payday_count: 0,
      )
      set_starting_values(existing_sheet)
      existing_sheet
    end
  end

  # Each new month, your starting budget/income is all 4 paychecks from last month
  def self.new_starting_income
    Sheet.where(payday_count: 4).order(year: :desc, month: :desc).first.income
  end

  def self.set_starting_values(sheet)
    starting_income = sheet.income
    bill_totals = sheet.bill_totals
    savings_amount = ENV['MONTHLY_SAVINGS'].to_i
    leftovers = starting_income - bill_totals - savings_amount
    together_value = leftovers / 2
    user_1_value = leftovers / 4
    user_2_value = leftovers / 4
    sheet.update!(
      user_3_budget: together_value,
      user_1_budget: user_1_value,
      user_2_budget: user_2_value,
    )
  end
end
