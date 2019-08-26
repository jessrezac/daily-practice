class SessionController < ApplicationController

    get '/signup' do
        erb :signup
    end

    post '/signup' do

        user = User.new(params)

        if user.save
            session[:user_id] = user.id
            redirect to "/journals"
        else
            erb :signup
        end

    end

    get '/login' do
        "login"
    end

    
end