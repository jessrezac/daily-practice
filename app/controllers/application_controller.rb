class ApplicationController < Sinatra::Base
    SESSION_SECRET = ""
    
    configure do
        set :public_folder, 'public'
        set :views, 'app/views'
        enable :sessions
        set :session_secret, "baj7fAZLR/RD3UjfAq59WOSHz2Y=" 
    end

    get '/' do
        erb :index
    end


    helpers do
        def is_logged_in?
            !!session[:user_id]
        end

        def current_user
            User.find(session[:user_id])
        end

    end

end