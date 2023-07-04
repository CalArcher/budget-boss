class TwilioController < ApplicationController

  # skip_before_action :verify_authenticity_token

  before_action :authenticate_twilio_request, only: [:receive_text]

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

  def authenticate_twilio_request
    twilio_signature = request.headers['X-Twilio-Signature']
    validator = Twilio::Security::RequestValidator.new(ENV['TWILIO_AUTH_TOKEN'])

    url = url_for(only_path: false, action: 'receive_text')

    unless validator.validate(url, request.parameters, twilio_signature)
      head :unauthorized
      return
    end
  end
end