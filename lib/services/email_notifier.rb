require 'postmark'

require_relative "../init"
require_relative "../models/user"
require_relative '../constants'

class EmailNotifierService
  def self.call(*args)
    new(*args).call
  end
  
  def initialize(client = Postmark::ApiClient.new(Settings.postmark.api_key))
    @client = client
  end

  def call
    User.paying.each do |user|
      if user.time_to_send_notification?
        @client.deliver_with_template(from: "shime@twobucks.co",
                                      to: user.email,
                                      reply_to: "user+#{user.token}@inbound.twobucks.co",
                                      template_id: Constants::NOTIFICATION_TEMPLATE_ID,
                                      template_model: {
                                        company_name: 'Vedran & Hrvoje',
                                        help_url: "https://github.com/shime/one-sentence-per-day",
                                        support_email: "hrvoje@twobucks.co",
                                        product_name: "One Sentence Per Day"
                                      })
      end
    end
  end
end
