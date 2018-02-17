require 'bundler/setup'
Bundler.require
require 'sinatra/reloader' if development?

require 'sinatra/activerecord'
require './models'
require 'base64'
require 'tempfile'

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
    else
        @books = Book.had_by(current_user)
        @lists = List.had_by(current_user)
        @title = '全ての投稿'
    end
    erb :index
end

get '/index' do
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

get '/user' do
    erb :user
end

get '/user_edit' do
    erb :user_edit
end

post '/user/edit' do
    user = current_user
    
    user.name = params[:name]
    user.description = params[:description]
    auth = {
    cloud_name: "dkbvz4tou",
    api_key:    "687247844292951",
    api_secret: "VUJLyQ0Hn_qWjnoXFOafUTtlblA"
    }
    w = Tempfile.open
    original = Base64.urlsafe_decode64(params[:image].split(',').last)
    w.write(original)
    user.image = Cloudinary::Uploader.upload(w.path, auth)['secure_url']
    user.save
    w.close
    redirect '/'
end

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

get '/book/:id/delete' do
    book = Book.find(params[:id])
    book.destroy
    content_type :json
    data = {}
    data.to_json
end

get '/books/:id/star' do
    book = Book.find(params[:id])
    book.star = !book.star
    book.save
    content_type :json
    data = {star: book.star}
    data.to_json
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
        # ¥n -> <br>
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
    @title = 'お気に入り'
    erb :index
end

get '/list/:id' do
    @lists = List.all
    list = List.find(params[:id])
    @books = list.books.had_by(current_user)
    @title = list.name
    erb :index
end

get '/lists/new' do
    erb :new_list
end

get '/list/:id/delete' do
    list = List.find(params[:id])
    list.destroy
    content_type :json
    data = {}
    data.to_json
end


post '/lists' do
    current_user.lists.create(
        name: params[:name]
    )
    redirect '/'
end