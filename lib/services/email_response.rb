require_relative '../init'
require_relative '../models/user'
require_relative '../models/log_entry'

class EmailResponseService
  class UserNotFoundError < StandardError; end
  def self.call(*args)
    new(*args).call
  end

  def initialize(token, body)
    @user = User.find(token: token) || raise(UserNotFoundError.new)
    @body = body
  end

  def call
    LogEntry.create(body: @body, user_id: @user.id)
  end
end
