require "erb"

require_relative "../../init"

class RegistrationView
  def initialize(user, product_name = "Journmail", company_name = "Vedran & Hrvoje")
    @user = user
    @product_name = product_name
    @company_name = company_name
    @action_url = link_to_registration(user)
  end

  def to_html
    erb = ERB.new(File.read(File.join(File.dirname(__FILE__),
                                      "/templates/register.erb")))
    erb.result(binding)
  end

  private

    def link_to_registration(user)
      "#{Settings.urls.registration}/#{@user.token}"
    end
end
