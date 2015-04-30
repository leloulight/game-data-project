require 'rubygems'
require 'sinatra'
require 'data_mapper'

DataMapper::setup(:default, "postgres://ruby:i4R3CEcN^uW\@D@localhost/va_only")


class Allsites_va
  include DataMapper::Resource
  property :site_name, Text, :required => true, :key => true

end

#DataMapper.finalize.auto_upgrade!
DataMapper.finalize


get '/' do
	@sites = DataMapper.repository(:default).adapter.select("select * from allsites_va")
  #@sites = Allsites_va.all
  @title = 'VA Only Sites'
  erb :sites
end