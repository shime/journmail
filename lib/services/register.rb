require 'postmark'
require_relative '../constants'
require_relative '../init'
require_relative './create_user'

class RegisterService
  def self.call(*args)
    new(*args).call
  end

  def initialize(email, client = Postmark::ApiClient.new(Settings.postmark.api_key))
    @email = email
    @client = client

    @user = CreateUserService.call({email: @email})
  end

  def call
    @client.deliver_with_template(from: "shime@twobucks.co",
                                  to: @user.email,
                                  reply_to: "user+#{@user.token}@inbound.twobucks.co",
                                  template_id: Constants::REGISTER_TEMPLATE_ID,
                                  template_model: {
                                    company_name: 'Vedran & Hrvoje',
                                    action_url: link_to_registration(@user),
                                    help_url: "https://github.com/shime/one-sentence-per-day",
                                    support_email: "hrvoje@twobucks.co",
                                    product_name: "One Sentence Per Day"
                                  })
  end

  private

    def link_to_registration(user)
      "#{Settings.urls.registration}/#{@user.token}"
    end
end
