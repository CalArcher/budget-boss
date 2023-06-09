
require_relative '../helpers/time_helper'

class UpdateSheetService
  include TimeHelper

  def initialize(user_id:, amount:, bill_name:)
    @user_id = user_id
    @amount = amount
    @bill_name = bill_name
  end

  def user_table_prefix
    "user_#{@user_id}"
  end

  def find_current_sheet
    Sheet.find_or_create_sheet(month, year)
  end

  def find_next_month_sheet
    Sheet.find_or_create_sheet(next_month, update_year)
  end

  def new_transaction(name, type, amount)
    Transaction.create!(
      tx_name: name,
      tx_type: type,
      tx_amount: amount,
      user_id: @user_id
    )
  end

  def send_sms(message)
    OutgoingSmsService.new(to_user_id: @user_id, body: message).send
  end

  def user_transaction_spend
    binding.pry # check this for working
    column_budget = "#{user_table_prefix}_budget"
    column_spent = "#{user_table_prefix}_spent"

    add_to_sheet_column_value(column_budget, -@amount)
    add_to_sheet_column_value(column_spent, @amount)
    
    new_transaction(user_table_prefix, 'spend', @amount)
    reply = "Success, added a spend transaction for $#{@amount} during #{month}/#{year}."
    send_sms(reply)
  end

  def user_transaction_save
    binding.pry # check this for working
    add_to_sheet_column_value('income', @amount)
    
    new_transaction(user_table_prefix, 'save', @amount)
  end

  def add_to_sheet_column_value(column_name, tx_amount)
    begin
      sheet = find_current_sheet
      binding.pry # check tx amnt

      new_column_value = sheet[column_name] + tx_amount
      find_current_sheet.update!(column_name => new_column_value)
    rescue StandardError => e
      error_message = "Failed to log spend. Error: #{e.message}"
      send_sms(error_message)
    end
  end

  # update to handle geting paid late
  # right now users need to ensure all 4 paydays are entered between
  # 1st and last day of the month. Not ideal.
  def payday
    target_sheet = find_current_sheet

    # 2 people x 2 paydays per month == 4
    if target_sheet.payday_count > 3
      target_sheet = find_next_month_sheet
      if day < 27
        message = "This is the 5th payday entered this month. Your " \
          "paycheck was added to next month's (#{next_month}/#{update_year}) income."
        send_sms(message)
      end
    end
    
    updated_income = target_sheet.income + @amount
    updated_payday_count = target_sheet.payday_count + 1
    transaction_name = "#{user_table_prefix} payday"

    begin
      target_sheet.update!(
        income: updated_income,
        payday_count: updated_payday_count,
      )
      new_transaction(transaction_name, 'save', @amount)
    rescue StandardError => e
      error_message = "Failed up update balance, error: #{e.message}"
      send_sms(error_message)
    end
    message = "Balance updated, the total for #{target_sheet.month}/#{target_sheet.year} is now #{updated_income}. " \
      "#{updated_payday_count} paydays have been logged this month."
    send_sms(message)
  end
end