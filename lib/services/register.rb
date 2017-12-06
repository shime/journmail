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
    @old_user = User.find(email: email)
  end

  def call
    if @old_user && @old_user.unsubscribed?
      resubscribe_old_user
      return
    end

    raise EmailAlreadyTaken.new("email is already taken") unless @user.valid?

    RegistrationMailer.deliver(@user)

    @user.save
  end

  private

    def resubscribe_old_user
      @old_user.make_paying!
      RegistrationMailer.deliver(@old_user)
    end
end
