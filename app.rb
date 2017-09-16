require 'bundler/setup'
Bundler.require
require 'sinatra/reloader' if development?

require 'sinatra/activerecord'
require './models'

enable :sessions

helpers do
    def current_user
        User.find_by(id: session[:user]) 
    end
end

before '/books' do
    if current_user.nil?
        redirect '/'
    end
end

get '/' do
    if current_user.nil?
        @books = Book.none
        @lists = List.none
    # elsif params[:list].nil? then
    #     @books = current_user.books
        # @lists = List.none
    else
        @books = Book.had_by(current_user)
        @lists = List.had_by(current_user)
    end
    erb :index
end

get '/signup' do
    erb :sign_up
end

post '/signup' do
    user = User.create(
       name: params[:name],
       password: params[:password],
       password_confirmation: params[:password_confirmation]
       )
    if user.persisted?
        session[:user] = user.id
    end
    redirect '/'
end

get '/signin' do
    erb :sign_in
end

post '/singin' do
    user = User.find_by(name: params[:name])
    if user && user.authenticate(params[:password])
       session[:user] = user.id
    end
    redirect '/'
end

get '/signout' do
    session[:user] = nil
    redirect '/'
end

#ここからアプリの中身

get '/books/new' do
    erb :new
end

post '/books' do
    list = List.find(params[:list])
    if Date.valid_date?(params[:year].to_i, params[:month].to_i, params[:day].to_i)
        current_user.books.create(
            title: params[:title],
            author: params[:author],
            date: Date.parse(params[:year]+"-"+params[:month]+"-"+params[:day]),
            rate: params[:rate],
            comment: params[:comment],
            list_id: list.id
        )
        redirect '/'
    else
        redirect '/books/new'
    end
end

get '/books/:id/delete' do
    book =Book.find(params[:id])
    book.destroy
    redirect '/'
end

get '/books/:id/star' do
    book = Book.find(params[:id])
    book.star = !book.star
    book.save
    redirect '/'
end

get '/books/:id/edit' do
    @book = Book.find(params[:id])
    @list = List.had_by(current_user)
    erb :edit
end

post '/books/:id' do                                                            
    book = Book.find(params[:id])
    list = List.find(params[:list])
    date = params[:date].split('-')
    
    if Date.valid_date?(date[0].to_i, date[1].to_i, date[2].to_i)
        book.title = CGI.escapeHTML(params[:title])
        book.author = params[:author]
        book.date = Date.parse(params[:date])
        book.rate = params[:rate]
        book.comment = params[:comment]
        book.list_id = list.id
        book.save
        redirect '/'
    else
        redirect '/books/#{book.id}/edit'
    end
end

get '/books/star' do
    @lists = List.all
    @books = current_user.books.where(star: [true])
    erb :index
end

get '/list/:id' do
    @lists = List.all
    list = List.find(params[:id])
    @books = list.books.had_by(current_user)
    erb :index
end

get '/lists/new' do
    erb :new_list
end

post '/lists' do
    current_user.lists.create(
        name: params[:name]
    )
    redirect '/'
end