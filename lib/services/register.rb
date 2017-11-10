require 'mail'
require 'pry'
require 'postmark'

Mail.defaults do
  delivery_method Mail::Postmark, api_token: ENV['POSTMARK_API_KEY']
end

class RegisterService
  def self.call(user)
    new(user).call
  end

  def initialize(user)
    @user = user
  end

  def call
    user = @user
    registration_link = link_to_registration(user)

    Mail.deliver do
      from     'shime@twobucks.co'
      to       user.email
      subject  'Please register your account'
      text_part do
        body "Thanks for sigining up for ONE SENTENCE PER DAY. Please confirm your subscription on the following link: #{registration_link}."
      end

      html_part do
        content_type 'text/html; charset=UTF-8'
        body     %Q(<p> Thanks for signing up for ONE SENTENCE PER DAY. </p>
                  <p>
                    <a href=#{registration_link}> Start your 7 day free trial </a>
                  </p>)
      end
    end
  end

  private

    def link_to_registration(user)
      # TODO
      "https://google.com"
    end
end
