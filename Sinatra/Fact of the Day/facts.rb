require 'rubygems'
require 'sinatra'
require 'data_mapper'
require 'date'

DataMapper::setup(:default, "postgres://ruby:i4R3CEcN^uW\@D@localhost/va_only")


class Fun_fact
  include DataMapper::Resource
  property :day, Text, :required => true, :key => true
  property :fact, Text, :required => true
end

#DataMapper.finalize.auto_upgrade!
DataMapper.finalize.auto_upgrade!


get '/' do
	@current_day = Date.today.strftime("%A")
	
	@fact = DataMapper.repository(:default).adapter.select("select fact from fun_facts where day = '#{@current_day}'")

  #@sites = Allsites_va.all
  @title = 'Facts'
  erb :factview
end

post '/' do
  #@update = params[:message]
  #n = Fun_fact.new
  @current_day = Date.today.strftime("%A")
  #n.day = @current_day
  #n.fact = params[:message]
  Fun_fact.first(:day => @current_day).update(:fact => params[:message])
  #n.save
  #Fun_fact.all(:day => @current_day).update(:fact => params[:message])
  redirect '/'
end 