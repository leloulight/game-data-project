require 'rubygems'
require 'sinatra'
require 'data_mapper'
require 'date'


DataMapper::setup(:default, "postgres://admin:5346488k@localhost/gamedata")


class Game
  include DataMapper::Resource
  property :name, Text, :required => true, :key => true
  property :developer, Text, :required => true
  property :publisher, Text, :required => true
  property :release_date, Text, :required => true
  property :mode, Text, :required => true

end

#DataMapper.finalize.auto_upgrade!
DataMapper.finalize.auto_upgrade!


get '/' do
	@current_day = Date.today.strftime("%A")
	
	@gameinfo = DataMapper.repository(:default).adapter.select("select name from games order by name")
  @devinfo = DataMapper.repository(:default).adapter.select("select developer from games order by name")
  @pubinfo = DataMapper.repository(:default).adapter.select("select publisher from games order by name")
  # @game = File.open(@gameinfo) { |f| f.puts(@gameinfo) }
  #@sites = Allsites_va.all
  @title = 'Facts'
  erb :gameview
end

post '/' do
  #@update = params[:message]
  #n = Fun_fact.new
  @current_day = Date.today.strftime("%A")
  #n.day = @current_day
  #n.fact = params[:message]
  Game.first(:day => @current_day).update(:game => params[:message])
  #n.save
  #Fun_fact.all(:day => @current_day).update(:fact => params[:message])
  redirect '/'
end 