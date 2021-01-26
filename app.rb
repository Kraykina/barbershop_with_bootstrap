#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'

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
	@datetime = params[:datetime]
	@barber = params[:barber]
	@color = params[:color]


	hh = { 	:username => 'Введите имя',
			:phone => 'Введите телефон',
			:datetime => 'Введите дату и время' }

	@error = hh.select {|key,_| params[key] == ""}.values.join(", ")

	if @error != ''
		return erb :visit
	end

	erb "OK, username is #{@username}, #{@phone}, #{@datetime}, #{@barber}, #{@color}"

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
