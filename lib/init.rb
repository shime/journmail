require "config"
require "sequel"
require "pry"
require "mail"
require "postmark"

ENV["RACK_ENV"] ||= "development"

Config.load_and_set_settings(Config.setting_files("./config", ENV.fetch("RACK_ENV")))
Sequel.connect(Settings.urls.db)

case ENV["RACK_ENV"]
when "production"
  Mail.defaults do
    delivery_method Mail::Postmark, api_token: Settings.postmark.api_key
  end
when "development"
  Mail.defaults do
    delivery_method :smtp, address: "localhost", port: 1025
  end
when "test"
  Mail.defaults do
    delivery_method :test
  end
end

