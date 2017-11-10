require 'mailgun'

class RegisterService
  def self.call(user, mail_client = Mailgun::Client.new(ENV["MAILGUN_API_KEY"]))
    # Define your message parameters
    message_params =  {
      from: 'bob@sending_domain.com',
      to:   user.email,
      subject: 'The Ruby SDK is awesome!',
      text:    'It is really easy to send a message!'
    }

    # Send your message through the client
    mail_client.send_message 'mg.onesentenceperday.com', message_params
  end
end
