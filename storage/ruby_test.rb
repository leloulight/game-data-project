require 'mechanize'

mechanize = Mechanize.new

page = mechanize.get('http://en.wikipedia.org/wiki/2014_in_video_gaming')
puts page.title
#puts page.at('#wikitable sortable jquery-tablesorter').text.strip
#puts page.parser.css('#content').text.include? 'Title'
puts page.parser.css('#content').text.strip
#result_page.search("//table[@class='wikitable sortable jquery-tablesorter']//tr").each do |row|