require_relative "../lib/init"

require "sinatra"
require "json"
require "pry"
require "email_reply_parser"
require "logger"
require "sinatra/content_for"
require "raven"
require "active_support"
require "active_support/core_ext"

require_relative "./../lib/services/email_response"
require_relative "./../lib/services/register"
require_relative "./../lib/utils/gravatar"
require_relative "./../lib/services/high_score_calculator"


if ENV["RACK_ENV"] == "production"
  Raven.configure do |config|
    config.dsn = Settings.urls.sentry
  end
end

::Logger.class_eval { alias :write :'<<' }
access_log = ::File.join(::File.dirname(::File.expand_path(__FILE__)),'..','logs','access.log')
access_logger = ::Logger.new(access_log)
error_logger = ::File.new(::File.join(::File.dirname(::File.expand_path(__FILE__)),'..','logs','error.log'),"a+")
error_logger.sync = true

configure do
  use Rack::Attack
  use ::Rack::CommonLogger, access_logger

  if ENV["RACK_ENV"] == "production"
    use Raven::Rack
  end
end

before {
  env["rack.errors"] =  error_logger
}

set :static_cache_control, [:public, max_age: 0]

get "/" do
  erb :index, layout: false
end

post "/register" do
  body = request.body.read
  email = JSON.parse(body)["email"]
  timezone = JSON.parse(body)["timezone"]

  begin
    RegisterService.call(email, timezone)
  rescue Sequel::UniqueConstraintViolation, RegisterService::EmailAlreadyTaken => ex
    if ex.message =~ /email.*already exists|email.*is already taken/
      status 409
      return { error: "Email already taken, try another one." }.to_json
    end

    raise ex
  end

  { success: true }.to_json
end

get '/register/:token' do
  @current_user = User.find(token: params[:token])

  if !@current_user
    return erb(:not_found)
  end

  @current_user.make_paying!

  erb :register
end

get '/unsubscribe/:token' do
  @current_user = User.find(token: params[:token])

  if !@current_user
    return erb(:not_found)
  end

  erb :unsubscribe
end

post '/unsubscribe/:token' do
  @current_user = User.find(token: params[:token])

  if !@current_user
    status 401
    return {error: "User not found"}.to_json
  end

  @current_user.unsubscribe!

  {}.to_json
end

get '/history/:token' do
  @current_user = User.find(token: params[:token])

  if !@current_user
    return erb(:not_found)
  end

  @log_entries = @current_user.log_entries_dataset.
    order(Sequel.desc(:created_at)).all
  @streak = @current_user.streak

  if Utils::Gravatar.exists?(@current_user.email)
    @image_url = Utils::Gravatar.url(@current_user.email)
  end

  erb :history
end

get '/download/csv/:token' do
  @current_user = User.find(token: params[:token])

  if !@current_user
    return erb(:not_found)
  end

  content_type 'application/csv'
  attachment   'journmail.csv'

  LogEntry.to_csv(instances: @current_user.log_entries)
end

get '/download/xlsx/:token' do
  @current_user = User.find(token: params[:token])

  if !@current_user
    return erb(:not_found)
  end

  content_type 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
  attachment   'journmail.xlsx'

  LogEntry.to_xlsx(instances: @current_user.log_entries)
end

get '/highscore' do
  @score = HighScoreCalculator.call

  erb :score
end

post '/inbound' do
  postmark_hash = Postmark::Json.decode(request.body.read)
  ruby_hash = Postmark::Inbound.to_ruby_hash(postmark_hash)
  body = EmailReplyParser.parse_reply(ruby_hash[:text_body])

  EmailResponseService.call(ruby_hash[:mailbox_hash], body)

  "Thanks for sending message"
end

get '/privacy' do
  erb :privacy
end

get '/terms' do
  erb :terms
end

not_found do
  status 404
  erb :not_found
end

def h(html)
  CGI.escapeHTML(html)
end

def humanize_time(time)
  "#{time.strftime("%d %B at %H:%M")} • #{time.strftime("%A")}"
end
