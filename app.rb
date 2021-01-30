#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

def get_db
	db = SQLite3::Database.new 'barbershop.db'
	db.results_as_hash = true
	return db	
end

configure do
	db = get_db
	db.execute 'CREATE  TABLE IF NOT EXISTS
		"Users"
		(
			"id" INTEGER PRIMARY KEY  AUTOINCREMENT  UNIQUE,
			"username" TEXT,
			"phone" TEXT,
			"datestamp" TEXT,
			"barber" TEXT,
			"color" TEXT
		)'
end	

get '/' do
	erb "Здравствуйте! Добро пожаловать на сайт нашей парикмахерской \"Barber Shop\". Для записи перейдите по <a href=\"/visit\">ссылке</a>."			
end

get '/about' do
	erb :about
end

get '/visit' do
	erb :visit
end

post '/visit' do

	@username = params[:username]
	@phone = params[:phone]
	@date_time = params[:date_time]
	@barber = params[:barber]
	@color = params[:color]


	hh = { 	:username => 'Введите имя',
			:phone => 'Введите телефон',
			:date_time => 'Введите дату и время' }

	@error = hh.select {|key,_| params[key] == ""}.values.join(", ")

	if @error != ''
		return erb :visit
	end

	#f = File.open "./public/users.txt", "a"
	#f.write "User: #{@username}, Phone: #{@userphone}, Date and time: #{@date_time}, Barber: #{@barber}, Color: #{@color}<br />\n"
	#f.close

	db = get_db
	db.execute 'INSERT INTO
		Users
		(
			username,
			phone,
			datestamp,
			barber,
			color
		)
		VALUES
		( ?, ?, ?, ? , ? )', [@username, @userphone, @date_time, @barber, @color]

	erb "Спасибо! #{@username.capitalize}, мы будем ждать вас #{@date_time}"

end



get '/contacts' do
	erb :contacts
end

post '/contacts' do
	@client_email = params[:client_email]
	@client_text = params[:client_text]

	hh = { :client_email => "Введите Ваш адрес e-mail", 
		   :client_text => "Введите текст сообщения" }

	@error = hh.select {|key,_| params[key] == ""}.values.join(", ")

	if @error != ''
		return erb :contacts
	end

end

get '/message' do
	erb :message
end


get '/admin' do
	erb :admin
end


post '/admin' do
	@login = params[:login]
	@password = params[:password]

	if @login == "admin" && @password == "secret"
		@title = "User data:"
		@message = File.read("./public/users.txt",  :encoding => "utf-8")
		@title2 = "User contacts:"
		@message2 = File.read("./public/contacts.txt",  :encoding => "utf-8")
		erb :message
	else
		@error = "Wrong login or password!"
		erb :admin 
	end
end

get '/showusers' do
  erb :showusers
end 
