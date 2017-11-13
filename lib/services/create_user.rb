require_relative '../init'
require 'securerandom'

class CreateUserService
  def self.call(*args)
    new(*args).call
  end

  def initialize(attributes, save = false)
    @attributes = attributes

    @attributes[:token] ||= SecureRandom.uuid
    @save = save
  end

  def call
    User.new(@attributes).tap do |user|
      user.save if @save
    end
  end
end
