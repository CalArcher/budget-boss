class TwilioController < ApplicationController

  # Removed after switching from Twilio to Discord.
  # Keeping if I want to use Twilio again

  # def receive_text
  #   logger.info params
  #   puts params
  #   account_sid = ENV['ACCOUNT_SID']
  #   return unless account_sid == params["AccountSid"]
  #   body = params["Body"]
  #   sender_number = params["From"]
  #   IncomingMessageService.new(body: body, from_number: sender_number).process_incoming_message
  #   head :ok
  # end
end