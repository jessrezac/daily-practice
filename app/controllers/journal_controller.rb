class JournalController < ApplicationController

    get '/journals' do
        @journals = current_user.journals
        erb :journals
    end

end