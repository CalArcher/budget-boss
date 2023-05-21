class UpdateDbService

  def initialize(user_id:, amount:, bill_name:)
    @user_id = user_id
    @amount = amount
    @bill_name = bill_name
  end

  def time
    @_time ||= Time.now
  end

  def year
    @_year ||= time.year
  end

  def month
    @_month ||= time.month
  end

  def day
    @_day ||= time.day
  end

  def next_month
    @_next_month ||= (month % 12) + 1
  end

  def update_year
    if next_month == 1
      year + 1
    else
      year
    end
  end

  def create_bill
    begin
      Bill.create!(
        bill_name: @bill_name,
        bill_amount: @amount,
      )
      message = "Created new bill: #{@bill_name} at #{@amount} per month"
      OutgoingSmsService.new(to_user_id: @user_id, body: message).send
    rescue StandardError => e
      error_message = "Failed to update bill. Error: #{e.message}"
      OutgoingSmsService.new(to_user_id: @user_id, body: error_message).send
    end
  end

  def update_bill
    begin
      bill = Bill.find_by(bill_name: @bill_name)
      previous_amount = bill.bill_amount
      bill.update!(
        bill_amount: @amount,
      )
      message = "#{@bill_name} bill updated from #{previous_amount} to #{@amount} per month"
      OutgoingSmsService.new(to_user_id: @user_id, body: message).send
    rescue StandardError => e
      error_message = "Failed up update bill. Error: #{e.message}"
      OutgoingSmsService.new(to_user_id: @user_id, body: error_message).send
    end
  end

  def find_current_sheet
    current_sheet = Sheet.find_by(month: month, year: year)
    current_sheet || Sheet.create!(
      month: month,
      year: year,
      income: Sheet.new_starting_income,
      bill_totals: bill_totals,
      payday_count: 0
    )

  end

  def find_next_month_sheet
    current_sheet = Sheet.find_by(month: next_month, year: update_year)
    current_sheet || Sheet.create!(
      month: next_month,
      year: update_year,
      income: Sheet.new_starting_income,
      bill_totals: bill_totals,
      payday_count: 0
    )
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
        OutgoingSmsService.new(to_user_id: @user_id, body: message).send
      end
    end
    
    updated_income = target_sheet.income + @amount
    updated_payday_count = target_sheet.payday_count + 1

    begin
      target_sheet.update!(
        income: updated_income,
        payday_count: updated_payday_count,
      )
    rescue StandardError => e
      error_message = "Failed up update balance, error: #{e.message}"
      OutgoingSmsService.new(to_user_id: @user_id, body: error_message).send
    end
    message = "Balance updated, the total for #{target_sheet.month}/#{target_sheet.year} is now #{updated_income}. " \
      "#{updated_payday_count} paydays have been logged this month."
    OutgoingSmsService.new(to_user_id: @user_id, body: message).send
  end
end