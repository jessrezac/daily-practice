class JournalController < ApplicationController

    get '/journals' do
        erb :journals
    end

end