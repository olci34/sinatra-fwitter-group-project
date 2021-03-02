class UsersController < ApplicationController

  get '/signup' do
    if !logged_in?
        erb :'users/create_user'
    else
        redirect '/tweets'
    end
  end

  get '/login' do
    if !logged_in?
        erb :'users/login'
    else
        redirect '/tweets'
    end
  end

  post '/signup' do
    if !params.values.any? {|v| v == ""}
        user = User.create(params)
        session[:id] = user.id
        redirect '/tweets'
    else
        redirect '/signup'
    end
  end

  post '/login' do
    user = User.find_by(username: params[:username])
    if user && user.authenticate(params[:password])
        session[:id] = user.id
        redirect '/tweets'
    else
        redirect '/login'
    end
  end

  get '/logout' do
    if logged_in?
        session.clear
        redirect '/login'
    else
        redirect '/'
    end
  end

  get '/users/:slug' do
      @user = User.find_by_slug(params[:slug])
      erb :'show'
  end

end
