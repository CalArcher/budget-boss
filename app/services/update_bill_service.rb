require_relative '../helpers/time_helper'

class UpdateBillService
  include TimeHelper

  def initialize(user_id:, amount:, bill_name:)
    @user_id = user_id
    @amount = amount
    @bill_name = bill_name
  end

  def send_sms(message)
    OutgoingSmsService.new(to_user_id: @user_id, body: message).send
  end

  def create_bill
    begin
      Bill.create!(
        bill_name: @bill_name,
        bill_amount: @amount,
      )
      message = "Created new bill: #{@bill_name} at #{@amount} per month"
      send_sms(message)
    rescue StandardError => e
      error_message = "Failed to update bill. Error: #{e.message}"
      send_sms(error_message)
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
      send_sms(message)
    rescue StandardError => e
      error_message = "Failed up update bill. Error: #{e.message}"
      send_sms(error_message)
    end
  end
end