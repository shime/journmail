require 'postmark'

require_relative "../init"
require_relative "../models/user"
require_relative '../constants'
require_relative "../mailers/notification"

class EmailNotifierService
  def self.call(*args)
    new(*args).call
  end

  def call
    User.paying.each do |user|
      if user.time_to_send_notification?
        NotificationMailer.deliver(user)
      end
    end
  end
end
