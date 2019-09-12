class JournalController < ApplicationController

    get '/journals' do
        @journals = current_user.journals
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

    get '/journals/:id' do
        @journal = Journal.find(params[:id])
        @gratitudes = @journal.gratitudes
        @forgivenesses = @journal.forgivenesses
        @commitments = @journal.commitments
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


        def update_commitment(details)
            # update commitment in database by replacing content or deleting object if content is empty
            binding.pry
            if params[:journal][:commitment][:id]
                commitment = Commitment.find(details[:id])
                if params[:journal][:commitment][:content] == ""
                    commitment.delete
                else
                    commitment.update(content: params[:journal][:commitment][:content])
                end
            else
                unless params[:journal][:commitment] == ""
                    commitment = Commitment.create(content: params[:journal][:commitment])
                    @journal.commitments << commitment
                end
            end
        end
    
    end

end