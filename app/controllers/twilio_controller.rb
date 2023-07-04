class TwilioController < ApplicationController

  def receive_text
    logger.info params
    puts params
    account_sid = ENV['ACCOUNT_SID']
    return unless account_sid == params["AccountSid"]
    body = params["Body"]
    sender_number = params["From"]
    IncomingSmsService.new(body: body, from_number: sender_number).process_incoming_message
    head :ok
  end
end