require "sinatra"
require "sinatra/activerecord"

set :database, {adapter: "sqlite3", database: "example.sqlite3"}

class User < ActiveRecord::Base
  validates_uniqueness_of :email
end

get "/" do
  if params[:order] == "ascending"
    @users = User.order(:first_name)
  elsif params[:order] == "descending"
    @users = User.order(first_name: :desc)
  elsif params[:query]
    @users = User.where(first_name: params[:query]) + User.where(last_name: params[:query]) 
  else
    @users = User.all.order(:first_name)
  end
  erb :index
end

get '/users/create' do
  erb :create
end

post "/users/create" do
  user = User.new first_name: params[:first_name], last_name: params[:last_name], email: params[:email], phone_number: params[:phone_number], address: params[:address] 
  user.save
  redirect "/"
end

get '/users/edit/:id' do
  @user = User.find(params[:id])
  erb :edit
end

post '/users/edit/:id' do
  User.update(params[:id], params.slice("first_name", "last_name", "email", "phone_number", "address"))
  # ou User.update(params[:id], {first_name: params[:first_name], last_name: params[:last_name], email: params[:email], phone_number: params[:phone_number], address: params[:address]})
  redirect '/'
end

get '/users/delete/:id' do
  User.destroy(params[:id])
  redirect '/'
end