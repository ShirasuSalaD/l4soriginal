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

get '/signup' do
  erb :sign_up
end

def image_upload(icon_url)
  logger.info "upload now"
  tempfile = icon_url[:tempfile]
  upload = Cloudinary::Uploader.upload(tempfile.path)
  contents = User.last
  contents.update_attribute(:icon_url, upload['url'])
end

post '/signup' do
  user=User.create(
  name: params[:name],
  password: params[:password],
  password_confirmation: params[:password_confirmation],
  icon_url: params[:file]
  )

  if params[:file]
    image_upload(params[:file])
  end


  if user.persisted?
    session[:user] = user.id
    redirect '/search'
  end
  redirect '/'
end

get '/signin' do
  erb:sign_in
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
  @lessons = Lesson.where("lesson LIKE ?", "%#{params[:keyword]}%")
  erb :search
end

post '/new' do
  if current_user
    current_user.comments.create(
      # lesson: params[:lesson],
      # teacher: params[:teacher],
      # faculty:  params[:faculty],
      # term: params[:term],
      comment: params[:comment],
      lesson_id: params[:lesson_id],
      user_id: current_user.id
    )
    redirect '/home'
  else
    redirect '/signup'
  end
end
