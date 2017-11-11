require 'sinatra'
require_relative './../lib/models/user'

get '/register/:email' do
  @current_user = User.find(email: params[:email])

  if !@current_user
    return "User not found"
  end

  @current_user.status = 'paying'
  @current_user.save

  "Thanks for registering"
end
