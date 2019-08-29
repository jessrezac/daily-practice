class JournalController < ApplicationController

    get '/journals' do
        @journals = current_user.journals
        erb :'journals/index'
    end

    get '/journals/new' do
        erb :'journals/new'
    end

    post '/journals' do
        journal = Journal.create(
            title: params[:journal][:title], 
            date: params[:journal][:date], 
            content: params[:journal][:content],
            user_id: current_user.id )
        redirect to "/journals/#{journal.id}"
    end

    get '/journals/:id' do
        @journal = Journal.find(params[:id])
        erb :'journals/show'
    end

    helpers do
        def break_lines(text)
            text.to_s.gsub(/\\n/, '<br/>')
        end
    end

end