class JournalController < ApplicationController

    get '/journals' do
        if is_logged_in?
            @journals = current_user.journals
            @random_gratitude = current_user.random_gratitude
            erb :'journals/index'
        else
            redirect to '/login'
        end
    end

    get '/journals/new' do
        if is_logged_in?
            erb :'journals/new'
        else
            redirect to '/login'
        end
    end

    post '/journals' do

        @journal = current_user.journals.create(
            title: params[:journal][:title],
            date: params[:journal][:date],
            content: params[:journal][:content])

        create_gratitudes(params[:journal][:gratitudes])
        create_forgivenesses(params[:journal][:forgivenesses])
        create_commitment(params[:journal][:commitment])

        redirect to "/journals/#{@journal.id}"
    end

    post '/search' do
        if is_logged_in?
            search = params[:search]
            @journals = current_user.journals.where("content like ?", "%#{search}%")
            erb :'/journals/index'
        else
            redirect to '/login'
        end
    end

    get '/journals/:id' do
        if is_logged_in?
            @journal = Journal.find(params[:id])

            if @journal.user == current_user
                @gratitudes = @journal.gratitudes
                @forgivenesses = @journal.forgivenesses
                @commitments = @journal.commitments
                erb :'journals/show', :layout => :noheader
            else
                redirect to '/journals'
            end
        else
            redirect to '/login'
        end

    end

    get '/journals/:id/edit' do
        if is_logged_in?
            @journal = Journal.find(params[:id])

            if @journal.user == current_user
                erb :'journals/edit'
            else
                redirect to '/journals'
            end
        else
            redirect to '/login'
        end
    end

    patch '/journals/:id' do
        if is_logged_in?
            @journal = Journal.find(params[:id])
            
            if @journal.user == current_user
                @journal.update(
                    title: params[:journal][:title],
                    date: params[:journal][:date],
                    content: params[:journal][:content]
                )   

                update_gratitudes(params[:journal][:gratitudes])
                update_forgivenesses(params[:journal][:forgivenesses])
                update_commitment(params[:journal][:commitment])

                redirect to "/journals/#{@journal.id}"
            else
                redirect to "/journals"
            end
        else
            redirect to "/login"
        end
    end

    delete '/journals/:id' do
        if is_logged_in?
            if @journal.user == curent_user
                @journal = Journal.find(params[:id])

                @journal.gratitudes.each do |gratitude|
                    gratitude.delete
                end

                @journal.forgivenesses.each do |forgiveness|
                    forgiveness.delete
                end

                @journal.commitments.each do |commitment|
                    commitment.delete
                end

                @journal.delete

                redirect to '/journals'
            else
                redirect to '/journals'
            end
        else
            redirect to '/login'
        end
    end

    helpers do
        def break_lines(text)
            text.to_s.gsub(/\r\n/, '<br/>')
        end

        def create_gratitudes(gratitudes)
            gratitudes.each do |details|
                unless details[:content] == ""
                    @journal.gratitudes.create(details)
                end
            end
        end

        def update_gratitudes(gratitudes)
            # update gratitude in database by replacing content or deleting object if content is empty
            gratitudes.each do |details|

                if details[:id]
                    gratitude = Gratitude.find(details[:id])
                    if details[:content] == ""
                        gratitude.delete
                    else
                        gratitude.update(details)
                    end
                else
                    unless details[:content] == ""
                        @journal.gratitudes.create(details)
                    end
                end
            end
        end


        def create_forgivenesses(forgivenesses)
            forgivenesses.each do |details|
                unless details[:content] == ""
                    @journal.forgivenesses.create(details)
                end
            end
        end


        def update_forgivenesses(forgivenesses)
            # update forgiveness in database by replacing content or deleting object if content is empty
            forgivenesses.each do |details|

                if details[:id]
                    forgiveness = Forgiveness.find(details[:id])
                    if details[:content] == ""
                        forgiveness.delete
                    else
                        forgiveness.update(details)
                    end
                else
                    unless details[:content] == ""
                        @journal.forgivenesses.create(details)
                    end
                end
            end
        end

        def create_commitment(details)
            unless details == ""
                @journal.commitments.create(content: details)
            end
        end


        def update_commitment(commitments)
            # update commitment in database by replacing content or deleting object if content is empty
            commitments.each do |details|
                if details[:id]
                    commitment = Commitment.find(details[:id])
                    if details[:content] == ""
                        commitment.delete
                    else
                        commitment.update(content: details[:content])
                    end
                else
                    unless details[:content] == ""
                        @journal.commitments.create(content: details[:content])
                    end
                end
            end
        end

    end

end