module SmsHelper
  extend ActiveSupport::Concern

  module SmsMethods
    def send_message(to_user, message)
      OutgoingMessageService.new(to_user: to_user, body: message).send
    end
  
    def admin_message(message)
      admin_user = ::User.find(1)
      OutgoingMessageService.new(to_user: admin_user, body: message).send
    end
  end

  class_methods do 
    include SmsMethods
  end

  included do
    include SmsMethods
  end
end

