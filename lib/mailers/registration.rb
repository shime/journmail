require_relative './views/registration'

class RegistrationMailer 
  def self.deliver(user)
    message = Mail.new do
      from          "do-not-reply@twobucks.co"
      to            user.email
      reply_to      "user+#{user.token}@inbound.twobucks.co"
      subject       "One more step required to register"
      content_type  'text/html; charset=UTF-8'
      body          RegistrationView.new(user).to_html
    end

    message.deliver
  end
end
