class TweetsController < ApplicationController

    get '/tweets' do
        if logged_in?
            @tweets = Tweet.all
            @user = User.find_by(id: session[:id])
            erb :'tweets/tweets'
        else
            redirect '/login'
        end
    end

    get '/tweets/new' do
        if logged_in?
            erb :'tweets/new'
        else
            redirect '/login'
        end
    end

    post '/tweets' do
        if self.logged_in?
            if !params[:content].empty?
                tweet = current_user.tweets.create(params)
                redirect "/tweets/#{tweet.id}"
            else
                redirect '/tweets/new'
            end
        else
            redirect '/'
        end
    end

    get '/tweets/:id' do
        if self.logged_in?
            @tweet = Tweet.find_by_id(params[:id])
            erb :'tweets/show'
        else
            redirect '/login'
        end
    end

    delete '/tweets/:id' do
        if self.logged_in?
            tweet = Tweet.find_by_id(params[:id])
            tweet.destroy if tweet.user_id == session[:id]
            redirect "/tweets"
        else
            redirect "/tweets/#{params[:id]}/edit"
        end
    end

    patch '/tweets/:id' do
        if !params[:content].empty?
            tweet = Tweet.find_by_id(params[:id])
            tweet.update(content: params[:content]) if tweet.id == session[:id]
            redirect "/tweets/#{tweet.id}"
        else
            redirect "tweets/#{params[:id]}/edit"
        end
    end

    get '/tweets/:id/edit' do
        if logged_in?
            @tweet = Tweet.find_by_id(params[:id])
            erb :'tweets/edit'
        else
            redirect '/login'
        end
    end
end
