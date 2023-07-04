class OutgoingSmsService
  def initialize(to_user:, body:)
    @to_user = to_user
    @body = body
  end

  def send
    client = Twilio::REST::Client.new(ENV['ACCOUNT_SID'], ENV['AUTH_TOKEN'])

    from = ENV['TWILIO_NUMBER']
    to = @to_user.phone_number
    puts "sent to #{to}: #{@body}"
    # client.messages.create(
    #   from: from,
    #   to: to,
    #   body: @body
    # )
  end

end