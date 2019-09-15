class JournalController < ApplicationController

    get '/journals' do
        @journals = current_user.journals
        @random_gratitude = current_user.random_gratitude
        erb :'journals/index'
    end

    get '/journals/new' do
        erb :'journals/new'
    end

    post '/journals' do

        @journal = Journal.create(
            title: params[:journal][:title],
            date: params[:journal][:date],
            content: params[:journal][:content],
            user_id: current_user.id )

        create_gratitudes(params[:journal][:gratitudes])
        create_forgivenesses(params[:journal][:forgivenesses])
        create_commitment(params[:journal][:commitment])

        redirect to "/journals/#{@journal.id}"
    end

    post '/search' do
        search = params[:search]
        @journals = current_user.journals.where("content like ?", "%#{search}%")
        erb :'/journals/index'
    end

    get '/journals/:id' do
        @journal = Journal.find(params[:id])
        
        if @journal.user == current_user
            @gratitudes = @journal.gratitudes
            @forgivenesses = @journal.forgivenesses
            @commitments = @journal.commitments
            erb :'journals/show', :layout => :noheader
        else
            redirect to '/journals'
        end
        
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

        update_gratitudes(params[:journal][:gratitudes])
        update_forgivenesses(params[:journal][:forgivenesses])
        update_commitment(params[:journal][:commitment])

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

        def create_gratitudes(gratitudes)
            gratitudes.each do |details|
                unless details[:content] == ""
                    gratitude = Gratitude.create(details)
                    @journal.gratitudes << gratitude
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
                        gratitude = Gratitude.create(details)
                        @journal.gratitudes << gratitude
                    end
                end
            end
        end


        def create_forgivenesses(forgivenesses)
            forgivenesses.each do |details|
                unless details[:content] == ""
                    forgiveness = Forgiveness.create(details)
                    @journal.forgivenesses << forgiveness
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
                        forgiveness = Forgiveness.create(details)
                        @journal.forgivenesses << forgiveness
                    end
                end
            end
        end

        def create_commitment(details)
            unless details == ""
                commitment = Commitment.create(content: details)
                @journal.commitments << commitment
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
                        commitment = Commitment.create(content: details[:content])
                        @journal.commitments << commitment
                    end
                end
            end
        end
    
    end

end