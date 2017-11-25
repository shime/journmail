require 'postmark'

require_relative '../init'
require_relative './create_user'
require_relative '../mailers/registration'

class RegisterService
  class EmailAlreadyTaken < StandardError; end

  def self.call(*args)
    new(*args).call
  end

  def initialize(email, timezone = "Europe/London")
    @email = email
    @user = CreateUserService.call({ email: @email, timezone: timezone })
  end

  def call
    raise EmailAlreadyTaken.new("email is already taken") unless @user.valid?

    RegistrationMailer.deliver(@user)

    @user.save
  end

  private

end
