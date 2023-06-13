class OutgoingSmsService
  def initialize(to_user_key:, body:)
    @to_user_key = to_user_key
    @body = body
  end

  def to_user
    ::User.find_by!(key: to_user_key)
  end

  def send
    client = Twilio::REST::Client.new(ENV['ACCOUNT_SID'], ENV['AUTH_TOKEN'])

    from = ENV['TWILIO_NUMBER']
    to = to_user.phone_number
    puts "sent to #{to}: #{@body}"
    # client.messages.create(
      # from: from,
      # to: to,
      # body: fun
    # )
  end

end