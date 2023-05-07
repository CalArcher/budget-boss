class OutgoingSmsService
  def initialize(to_user_id:, body:)
    @to_user_id = to_user_id
    @body = body
  end


  def send
    client = Twilio::REST::Client.new(ENV['ACCOUNT_SID'], ENV['AUTH_TOKEN'])


    from = ENV['TWILIO_NUMBER']
    to = ENV[@to_user_id.to_s]
    puts "sent to #{to}: #{@body}"
    # client.messages.create(
      # from: from,
      # to: to,
      # body: fun
    # )
  end

end