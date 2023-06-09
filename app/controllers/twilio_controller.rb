class TwilioController < ApplicationController
  protect_from_forgery except: :receive_text

  # TODO
  
  # def receive_text
  #   body = params["Body"]
  #   sender_number = params["From"]
  #   IncomingSmsService.new(body: body, from_number: sender_number).handle_reply
  #   head :ok
  # end
end