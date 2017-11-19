require "sinatra"
require "json"
require "pry"
require "postmark"
require "email_reply_parser"

require_relative "./../lib/services/email_response"
require_relative "./../lib/services/register"

get "/" do
  erb :index2
end

post "/register" do
  email = JSON.parse(request.body.read)["email"]

  begin
    RegisterService.call(email)
  rescue Sequel::UniqueConstraintViolation => ex
    if ex.message =~ /email.*already exists/
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
    return "User not found"
  end

  @current_user.make_paying!

  "Thanks for registering"
end

get '/unsubscribe/:token' do
  @current_user = User.find(token: params[:token])

  if !@current_user
    return "User not found"
  end

  @current_user.unsubscribe!

  "Sorry to see you go"
end

post '/inbound' do
  postmark_hash = Postmark::Json.decode(request.body.read)
  ruby_hash = Postmark::Inbound.to_ruby_hash(postmark_hash)
  body = EmailReplyParser.parse_reply(ruby_hash[:text_body])

  EmailResponseService.call(ruby_hash[:mailbox_hash], body)

  "Thanks for sending message"
end
