require_relative '../init'
require 'securerandom'

class CreateUserService
  def self.call(*args)
    new(*args).call
  end

  def initialize(attributes)
    @attributes = attributes

    @attributes[:token] ||= SecureRandom.uuid
  end

  def call
    User.create(@attributes)
  end
end
