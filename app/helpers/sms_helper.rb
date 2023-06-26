module SmsHelper
  def send_sms(to_user, message)
    OutgoingSmsService.new(to_user: to_user, body: message).send
  end

  def admin_message(message)
    admin_user = ::User.find(1)
    OutgoingSmsService.new(to_user: admin_user, body: message).send
  end
end

