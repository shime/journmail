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
      NotificationMailer.deliver(user)
    end
  end
end
