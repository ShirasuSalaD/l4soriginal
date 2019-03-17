require 'bundler/setup'
Bundler.require
require 'sinatra/reloader' if development?
require 'sinatra'
require 'sinatra/activerecord'
require './models'
require 'open-uri'
require 'net/http'
require 'json'
require 'rubygems'
require 'sinatra/json'


enable :sessions

helpers do
  def current_user
    User.find_by(id: session[:user])
  end
end


get '/' do
  @comments = Comment.all.order('updated_at DESC')
  erb :index
end


get '/signup' do
  erb :sign_up
end

get '/home' do
  @user_comments = Comment.where(user_id: current_user).order('updated_at DESC')
  erb :home
end

get '/comments/:id/edit' do
  @comment = Comment.find(params[:id])
  erb :edit
end

post '/comments/:id/edit' do
  comment = Comment.find(params[:id])
  comment.comment = CGI.escape_html(params[:updated_comment])
  comment.save
  redirect '/home'
end


post '/comments/:id/delete' do
  comment = Comment.find(params[:id])
  comment.destroy
  redirect '/home'
end

get '/signout' do
  session[:user] = nil
  redirect '/'
end

post '/signup' do
  user = User.create(
    name: params[:name],
    password: params[:password],
    icon_url: "",
    password_confirmation: params[:password_confirmation]
  )

  if params[:file]
    tempfile = params[:file][:tempfile]
    filename = params[:file][:filename]
    uploadfile =  Cloudinary::Uploader.upload(tempfile.path)
    new_user = User.last
    new_user.update_attribute(:icon_url, uploadfile['url'])
  end


  if user.persisted?
    session[:user] = user.id
    redirect '/search'
  end
  redirect '/'
end

post '/signin' do
  user = User.find_by(name: params[:name])
  if user && user.authenticate(params[:password])
    session[:user] = user.id
    redirect '/search'
  end
  redirect '/'
end

get '/search' do
  erb :search
end

post '/search' do
  # @lessons = Lesson.find_by(lesson: params[:keyword])
  @lessons = Lesson.all
  erb :search
end

post '/new' do
  if current_user
    current_user.comments.create(
      lesson: params[:lesson],
      teacher: params[:teacher],
      faculty:  params[:faculty],
      term: params[:term],
      comment: params[:comment],
      user_id: current_user.id
    )
    redirect '/home'
  else
    redirect '/signup'
  end
end
