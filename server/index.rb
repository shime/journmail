require_relative "../lib/init"

require "sinatra"
require "json"
require "pry"
require "email_reply_parser"
require "action_view"
require "action_view/helpers"
require "logger"
require "httparty"

include ActionView::Helpers::DateHelper

require_relative "./../lib/services/email_response"
require_relative "./../lib/services/register"
require_relative "./../lib/models/paypal_subscription"
require_relative "./../lib/utils/paypal"

::Logger.class_eval { alias :write :'<<' }
access_log = ::File.join(::File.dirname(::File.expand_path(__FILE__)),'..','logs','access.log')
access_logger = ::Logger.new(access_log)
error_logger = ::File.new(::File.join(::File.dirname(::File.expand_path(__FILE__)),'..','logs','error.log'),"a+")
error_logger.sync = true

configure do
  use ::Rack::CommonLogger, access_logger
end

before {
  env["rack.errors"] =  error_logger
}

set :static_cache_control, [:public, max_age: 0]
set :server_settings, timeout: 60

get "/" do
  erb :index
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

  subscription = @current_user.paypal_subscription

  if subscription&.active?
    paypal = Utils::Paypal::Sandbox.new
    paypal.unsubscribe(subscription.agreement_id)
    subscription.unsubscribe!
  end

  @current_user.unsubscribe!

  {}.to_json
end

get '/subscribe/:token' do
  @current_user = User.find(token: params[:token])

  if !@current_user
    return erb(:not_found)
  end

  erb :subscribe
end

get '/history/:token' do
  @current_user = User.find(token: params[:token])

  if !@current_user
    return erb(:not_found)
  end

  @log_entries = @current_user.log_entries_dataset.
    order(Sequel.desc(:created_at)).all
  @streak = @current_user.streak

  erb :history
end

post '/pay/month/:token' do
  @current_user = User.find(token: params[:token])

  if !@current_user
    return erb(:not_found)
  end

  paypal = Utils::Paypal::Sandbox.new
  plan = paypal.make_infinite_monthly_plan(token: params[:token])
  plan.activate
  billing_agreement = paypal.make_billing_agreement(plan)

  redirect_url = billing_agreement.urls[0]["href"]

  @current_user.paypal_subscription = PaypalSubscription.
    create(token: CGI.parse(URI.parse(redirect_url).query)["token"][0],
           status: "pending",
           plan: "monthly",
           execute_url: billing_agreement.urls[1]["href"],
           agreement_id: billing_agreement.id)

  return { url: redirect_url }.to_json
end

post '/pay/year/:token' do
  @current_user = User.find(token: params[:token])

  if !@current_user
    return erb(:not_found)
  end

  paypal = Utils::Paypal::Sandbox.new
  plan = paypal.make_infinite_yearly_plan(token: params[:token])
  plan.activate
  billing_agreement = paypal.make_billing_agreement(plan)

  redirect_url = billing_agreement.urls[0]["href"]

  @current_user.paypal_subscription = PaypalSubscription.
    create(token: CGI.parse(URI.parse(redirect_url).query)["token"][0],
           status: "pending",
           plan: "yearly",
           execute_url: billing_agreement.urls[1]["href"])

  return { url: redirect_url }.to_json
end


get '/activate-subscription/:token' do
  paypal_token = CGI.parse(request.query_string)["token"][0]

  paypal = Utils::Paypal::Sandbox.new
  paypal.execute_agreement(paypal_token)

  PaypalSubscription.find(token: paypal_token).update(status: "active")

  @token = params[:token]

  erb :thanks_for_paying
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
  "#{time.strftime("%d %B at %H:%M")} (#{time.strftime("%A")})"
end
