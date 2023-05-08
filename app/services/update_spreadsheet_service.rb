class UpdateSpreadsheetService

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

  def create_bill(name, amount)
    begin
      Bill.create!(
        bill_name: name,
        bill_amount: amount,
      )
      message = "Created new bill: #{name} at #{amount} per month"
      OutgoingSmsService.new(to_user_id: @user_id, body: message).send
    rescue StandardError => e
      error_message = "Failed to update bill. Error: #{e.message}"
      OutgoingSmsService.new(to_user_id: @user_id, body: error_message).send
    end
  end

  def update_bill(name, amount)
    begin
      bill = Bill.find_by(bill_name: name)
      previous_amount = bill.bill_amount
      bill.update!(
        bill_amount: amount,
      )
      message = "#{name} bill updated from #{previous_amount} to #{amount} per month"
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
      income: 0,
      bill_totals: bill_totals,
    )

  end

  def find_next_month_sheet
    current_sheet = Sheet.find_by(month: next_month, year: update_year)
    current_sheet || Sheet.create!(
      month: next_month,
      year: update_year,
      income: 0,
      bill_totals: bill_totals,
    )
  end

  def got_paid
    binding.pry
    update_sheet_send_text(@amount)
  end


  # updates next month income when user gets a paycheck, send confirm text.
  def update_sheet_send_text(amount)

    current_sheet = find_next_month_sheet
    
    new_income = current_sheet.income + amount

    begin
      current_sheet.update!(
        income: new_income
      )
    rescue StandardError => e
      error_message = "Failed up update balance, error: #{e.message}"
      OutgoingSmsService.new(to_user_id: @user_id, body: error_message, @user_id).send
    end
    message = "Balance updated, #{next_month}/#{update_year} is now #{new_income}"
    OutgoingSmsService.new(to_user_id: @user_id, body: message).send
  end
end