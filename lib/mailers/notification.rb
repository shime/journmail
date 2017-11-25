require_relative './views/notification'

class NotificationMailer
  def self.deliver(user)
    message = Mail.new do
      from          "shime@twobucks.co"
      to            user.email
      reply_to      "user+#{user.token}@inbound.twobucks.co"
      subject       "Your daily one sentence reminder"
      content_type  'text/html; charset=UTF-8'
      body          NotificationView.new(user).to_html
    end

    message.deliver
  end
end
