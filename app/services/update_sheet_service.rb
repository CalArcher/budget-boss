
class UpdateSheetService
  include TimeHelper
  include SmsHelper

  def initialize(to_user:, amount:, command_user: nil, description:)
    @to_user = to_user
    @amount = amount
    @command_user = command_user
    @description = description
  end

  def user_table_prefix
    "#{@command_user&.key}"
  end

  def command_user_name
    @_command_user_name ||= @command_user.name.capitalize
  end

  def find_current_sheet
    @_find_current_sheet ||= Sheet.find_or_create_sheet(current_month, current_year)
  end

  def find_next_month_sheet
    Sheet.find_or_create_sheet(next_month, year_of_next_month)
  end

  def new_transaction(name:, type:, amount:, description:)
    Transaction.create!(
      tx_name: name,
      tx_type: type,
      tx_amount: amount,
      tx_description: description,
      user_id: @to_user.id,
    )
  end

  def check_over_budget(budget_column)
    sheet = find_current_sheet

    remaining_budget = sheet[budget_column] - @amount
    over_budget = remaining_budget <= 0

    if over_budget
      warning_message = "**#{command_user_name}** is over budget by **$#{remaining_budget}!**"
    end
  end

  def user_transaction_spend
    column_budget = "#{user_table_prefix}_budget"
    column_spent = "#{user_table_prefix}_spent"

    check_over_budget(column_budget)

    add_to_sheet_column_value(column_budget, -@amount)
    add_to_sheet_column_value(column_spent, @amount)
    
    new_transaction(name: user_table_prefix, type: 'spend', amount: @amount, description: @description)

    remaining_balance = find_current_sheet[column_budget]
    reply = "**Success**, #{command_user_name} added a spend transaction for $#{@amount} during #{current_month}/#{current_year}.\n" \
      "**Remaining balance**: $#{remaining_balance}."
    send_message(@to_user, reply)
  end

  def user_transaction_save
    add_to_sheet_column_value('saved', @amount)
    new_transaction(name: user_table_prefix, type: 'save', amount: @amount, description: @description)
    # TODO only send if transaction success
    reply = "**Success**, #{command_user_name} added a save transaction for $#{@amount} during #{current_month}/#{current_year}."
    send_message(@to_user, reply)
  end

  def add_to_sheet_column_value(column_name, tx_amount)
    begin
      sheet = find_current_sheet
      new_column_value = sheet[column_name] + tx_amount
      sheet.update!(column_name => new_column_value)
    rescue StandardError => e
      error_message = "**Failed** to log spend. Error: #{e.message}"
      send_message(@to_user, error_message)
    end
  end

  # update to handle getting paid late
  # right now users need to ensure all 4 paydays are entered between
  # 1st and last day of the month. Not ideal.
  def payday
    target_sheet = find_current_sheet
    # 2 people x 2 paydays per month == 4
    if target_sheet.payday_count > 3
      target_sheet = find_next_month_sheet
      if current_day < 27
        message = "This is the 5th payday entered this month.\nYour " \
          "paycheck was added to next month's (#{next_month}/#{year_of_next_month}) income."
        send_message(@to_user, message)
      end
    end
    
    updated_income = target_sheet.payday_sum + @amount
    updated_payday_count = target_sheet.payday_count + 1

    begin
      target_sheet.update!(
        payday_sum: updated_income,
        payday_count: updated_payday_count,
      )
      new_transaction(name: 'payday', type: 'save', amount: @amount, description: @description)
    rescue StandardError => e
      error_message = "Failed up update balance, error: #{e.message}"
      send_message(@to_user, error_message)
      return
    end
    message = "Balance updated, the total for #{target_sheet.month}/#{target_sheet.year} is now **$#{updated_income}**. " \
      "#{updated_payday_count} paydays have been logged this month."
    send_message(@to_user, message)
  end
end