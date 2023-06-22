class TwilioController < ApplicationController

  # TODO
  # def receive_text
  #   body = params["Body"]
  #   sender_number = params["From"]
  #   IncomingSmsService.new(body: body, from_number: sender_number).process_incoming_message
  #   head :ok
  # or can try render(json: {ok: true})
  # end
end