class SessionController < ApplicationController

    get '/signup' do
        erb :"sessions/signup", :layout => :noheader
    end

    post '/signup' do

        user = User.new(params)

        if user.save
            session[:user_id] = user.id
            redirect to '/journals'
        else
            "failure"
        end

    end

    get '/login' do
        erb :"sessions/login", :layout => :noheader
    end

    post '/login' do
        user = User.find_by(username: params[:username])

        if user && user.authenticate(params[:password])
            session[:user_id] = user.id
            redirect to '/journals'
        else
            "failure"
        end
    end

    get '/logout' do
        session.clear
        redirect to '/'
    end

end