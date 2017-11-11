require 'mail'
require 'postmark'
require_relative '../constants'
require_relative '../init'

class RegisterService

  def self.call(*args)
    new(*args).call
  end

  def initialize(user, client = Postmark::ApiClient.new(ENV["POSTMARK_API_KEY"]))
    @user = user
    @client = client
  end

  def call
    @client.deliver_with_template(from: 'shime@twobucks.co',
                                  to: 'shime.ferovac@gmail.com',
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
      "#{Settings.urls.registration}/#{@user.email}"
    end
end
