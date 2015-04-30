# encoding: UTF-8

require 'rubygems'
require 'nokogiri'
require 'csv'
Dir.foreach('/home/colson/Documents/scripts/2014-Games') do |file|


  #release_date = ""

      page = Nokogiri::HTML(open("#{file}"))
      #page = Nokogiri::HTML(open(page).read, nil, 'utf-8')
      #page.encoding = 'utf-8'
      data = page.css('tr td').collect {|node| node.text.strip}
      image = page.css('img src').collect {|node| node['src']}
      #puts node['src']
      #north_release = page.css(".hproduct li").collect {|node| node.text.strip}
      #select{|link| link['title'] == "North America"}
      
      #news_links = page.css("td").select{|link| link['title'] == "North America"}
      #news_links.each{|link| puts link['href'] }
      #data = data.to_s
      #puts data
      # if data.include?('Release date(s)') then puts "Exists" else puts "Not exist" end
      #box_art = data[image]
      developer = data.index('Developer(s)')
      publisher = data.index('Publisher(s)')
      director = data.index('Director(s)')
      series = data.index('Series')
      engine = data.index('Engine')
       rel_index = data.index('Release date(s)')
      # if rel_index.nil? then puts "Index is nil" else "not nill" end
       genre = data.index('Genre(s)')
       technology = data.index('Technology')
       platform = data.index('Platform(s)')
       #na_index = north_release.index('NA')
      # rel_value = rel_index + 1
       if rel_index.nil? then release_date = 0 else
       rel_value = rel_index + 1
       release_date = data[rel_value] end
       #if release_date.include? "Release date(s)" then result = "Match!" else result = "No Match" end
    # else   
    #   release_date = "No data"
    # end
#      return release_date
    #puts data
                            # puts "Developer: "
                          #  puts developer
    #puts "Publisher: "
    #puts publisher
    #puts "Director: "
    #puts director
    #puts "Series: "
    #puts series
    #puts "Engine: "
    #puts engine
    #release_date_test = if release_date.nil? then "NIL" else "NOT NIL" end
    #puts release_date_test
    #if data[rel_value].include?('Release date(s)') then puts "Exists" else puts "Not exist" end
                        # puts "Release Index: "
                        #puts rel_index
  #  puts result
                       #puts release_date
                        #puts "Image URL: "
    puts image
    #puts rel_value
    #puts "Genre: "
    #puts genre
    #puts "Technology: "
    #puts technology
    #puts "Platform: "
    #puts platform
    #puts "NA Release Date: "
    #puts north_release
    #puts "NA location: "
    #puts na_index
    #puts news_links
end