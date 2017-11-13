ENV['RACK_ENV'] = 'test'

Dir['./lib/**/*.rb'].each {|file| require file }

require 'cucumber/rspec/doubles'

require 'rubygems'
require 'rack/test'
require 'rspec/expectations'
require 'webrat'
require 'timecop'

require_relative './../../lib/init'
require_relative './../../server/index'
require_relative './database_cleaner'

Webrat.configure do |config|
  config.mode = :rack
end

class WebratMixinExample
  include Rack::Test::Methods
  include Webrat::Methods
  include Webrat::Matchers

  Webrat::Methods.delegate_to_session :response_code, :response_body

  def app
    Sinatra::Application
  end
end

World{WebratMixinExample.new}
