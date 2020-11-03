require './my_user_model.rb'
require 'json'

require 'sinatra'
require 'sinatra/reloader'

set :bind, '0.0.0.0'
set :port, 8080

enable :sessions


post '/users' do
    info = []
    params.each{|k,v| info << v.to_s}
    User.create(info).to_s
end

get '/users' do
    User.all_no_password.to_s
    # users.each{ |user| puts user.to_s }
end

post '/sign_in' do
    email = params[:email]
    password = params[:password]
    user = User.sign_in(email, password)
    if user
        session['user_id'] = user['Id']
        "Login successful"
    else
        "Invalid user login"
    end
end

put '/users' do
    if session['user_id']
        User.update(session['user_id'], 'password', params[:password]).to_s
        User.get(session['user_id']).to_s
    else
        "You must login first"
    end
end

delete '/sign_out' do
    if session['user_id']
        session['user_id'] = nil
        "You successfully logged out"
    else
        "You must login first"
    end
end

delete '/users' do
    if session['user_id']
        User.destroy(session['user_id']).to_s
        session['user_id'] = nil
        "You successfully logged out and destroy user record"
    else
        "You must login first"
    end
end

get '/' do
    # send_file 'views/index.html'
    @users = User.all_no_password
    erb :index
end

