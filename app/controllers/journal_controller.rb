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

        gratitudes = params[:journal][:gratitudes]

        gratitudes.each do |details|
            gratitude = Gratitude.create(details)
            journal.gratitudes << gratitude
        end

        redirect to "/journals/#{journal.id}"
    end

    get '/journals/:id' do
        @journal = Journal.find(params[:id])
        erb :'journals/show'
    end

    get '/journals/:id/edit' do
        @journal = Journal.find(params[:id])
        erb :'journals/edit'
    end

    patch '/journals/:id' do
        @journal = Journal.find(params[:id])
        @journal.update(
            title: params[:journal][:title],
            date: params[:journal][:date],
            content: params[:journal][:content]
        )

        gratitudes = params[:journal][:gratitudes]

        # update gratitude in database by replacing content or deleting object if content is empty
        gratitudes.each do |details|
            gratitude = Gratitude.find(details[:id])
            if details[:content] == ""
                gratitude.delete
            else
                gratitude.update(details)
            end
        end

        redirect to "/journals/#{@journal.id}"
    end

    delete '/journals/:id' do
        @journal = Journal.find(params[:id])

        @journal.gratitudes.each do |gratitude|
            gratitude.delete
        end
        
        @journal.delete
        
        redirect to '/journals'
    end

    helpers do
        def break_lines(text)
            text.to_s.gsub(/\r\n/, '<br/>')
        end
    end

end