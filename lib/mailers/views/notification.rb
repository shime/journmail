require "erb"

require_relative "../../init"

class NotificationView
  def initialize(user, company_name = "Vedran & Hrvoje")
    @user = user
    @unsubscribe_link = link_to_unsubscribe(user)
    @company_name = company_name
  end

  def to_html
    erb = ERB.new(File.read(File.join(File.dirname(__FILE__),
                                      "/templates/notify.erb")))
    erb.result(binding)
  end

  private

    def link_to_unsubscribe(user)
      "#{Settings.urls.unsubscribe}/#{user.token}"
    end
end
