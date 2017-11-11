require 'sinatra'
require_relative './../lib/models/user'
require 'pry'
require 'postmark'
require 'email_reply_parser'

get '/register/:token' do
  @current_user = User.find(token: params[:token])

  if !@current_user
    return "User not found"
  end

  @current_user.status = 'paying'
  @current_user.save

  "Thanks for registering"
end

post '/inbound' do
  postmark_hash = Postmark::Json.decode(request.body.read)
  ruby_hash = Postmark::Inbound.to_ruby_hash(postmark_hash)
  body = EmailReplyParser.parse_reply(ruby_hash[:text_body])

  EmailResponseService.call(ruby_hash[:mailbox_hash], body)

  "Thanks for sending message"
end
