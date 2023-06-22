module SmsHelper
  def send_sms(to_user, message)
    OutgoingSmsService.new(to_user: to_user, body: message).send
  end
end

