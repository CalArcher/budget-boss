class UpdateBillService
  include SmsHelper

  def initialize(to_user:, amount:, bill_name:)
    @to_user = to_user
    @amount = amount
    @bill_name = bill_name
  end

  def create_bill
    begin
      Bill.create!(
        bill_name: @bill_name,
        bill_amount: @amount,
      )
      message = "Created new bill **#{@bill_name}** at $#{@amount} per month"
      send_message(@to_user, message)
    rescue StandardError => e
      error_message = "Failed to update bill. Error: #{e.message}"
      send_message(@to_user, error_message)
    end
  end

  def update_bill
    begin
      bill = Bill.find_by!(bill_name: @bill_name)
      previous_amount = bill.bill_amount
      bill.update!(
        bill_amount: @amount,
      )
      message = "Bill **#{@bill_name}** updated from $#{previous_amount} to $#{@amount} per month"
      send_message(@to_user, message)
    rescue StandardError => e
      error_message = "Failed up update bill. Error: #{e.message}"
      send_message(@to_user, error_message)
    end
  end
end