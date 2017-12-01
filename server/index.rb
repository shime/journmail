require_relative "../lib/init"

require "sinatra"
require "json"
require "pry"
require "postmark"
require "email_reply_parser"
require "time-lord"
require "action_view"
require "action_view/helpers"

include ActionView::Helpers::DateHelper

require_relative "./../lib/services/email_response"
require_relative "./../lib/services/register"

get "/" do
  erb :index
end

post "/register" do
  email = JSON.parse(request.body.read)["email"]

  begin
    RegisterService.call(email)
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

  @current_user.unsubscribe!

  erb :unsubscribe
end

get '/history/:token' do
  @current_user = User.find(token: params[:token])

  if !@current_user
    return erb(:not_found)
  end

  @log_entries = @current_user.log_entries

  erb :history
end

post '/inbound' do
  postmark_hash = Postmark::Json.decode(request.body.read)
  ruby_hash = Postmark::Inbound.to_ruby_hash(postmark_hash)
  body = EmailReplyParser.parse_reply(ruby_hash[:text_body])

  EmailResponseService.call(ruby_hash[:mailbox_hash], body)

  "Thanks for sending message"
end
