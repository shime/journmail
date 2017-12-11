require "erb"

require_relative "../../init"
require_relative "../../utils/streak_body"

class NotificationView
  def initialize(user, company_name = "Vedran & Hrvoje")
    @user = user
    @unsubscribe_link = link_to_unsubscribe(user)
    @history_link = link_to_history(user)
    @company_name = company_name
    @streak_body = StreakBody.call(user)
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

    def link_to_history(user)
      "#{Settings.urls.history}/#{user.token}"
    end
end
