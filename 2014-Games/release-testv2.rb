
# encoding: UTF-8

require 'rubygems'
require 'nokogiri'
require 'csv'
require 'htmlentities'

Dir.foreach('/home/colson/Documents/scripts/2014-Games') do |file|
release_date = ""
   def rel(page)
      page = Nokogiri::HTML(open(page))
      data = page.css('tr td').collect {|node| node.text.strip}
      data_refine = data.each do |s| s.gsub!(/\u00a0/, ' ') end

      #data = data.to_s
      if data_refine.include?('Release date(s)') then

      rel_index = data_refine.index('Release date(s)')
      rel_value = rel_index + 1
      release_date = data[rel_value]
      release_date = release_date.match(/^(?:(((Jan(uary)?|Ma(r(ch)?|y)|Jul(y)?|Aug(ust)?|Oct(ober)?|Dec(ember)?)\ 31)|((Jan(uary)?|Ma(r(ch)?|y)|Apr(il)?|Ju((ly?)|(ne?))|Aug(ust)?|Oct(ober)?|(Sept|Nov|Dec)(ember)?)\ (0?[1-9]|([12]\d)|30))|(Feb(ruary)?\ (0?[1-9]|1\d|2[0-8]|(29(?=,\ ((1[6-9]|[2-9]\d)(0[48]|[2468][048]|[13579][26])|((16|[2468][048]|[3579][26])00)))))))\,\ ((1[6-9]|[2-9]\d)\d{2}))/)
    	    else
     release_date = "No data"
     
    	end
    	return release_date
    	#puts a
	end
    
	def data(page)
		page = Nokogiri::HTML(open(page))
      data = page.css('.hproduct img').collect {|node| node.first(2)}
      return data.to_s



  end

  	class String
  def string_between_markers marker1, marker2
    self[/#{Regexp.escape(marker1)}(.*?)#{Regexp.escape(marker2)}/m, 1]
  end
end




    release_date = rel("#{file}")

      data = data("#{file}")
      # puts "Data:"
      # puts data=end
      #puts data.each_with_index {|val, index| puts "#{val} => #{index}" }
     # str1_marker='"src", "'
     # str2_marker='"]'
      #puts data[/#{str1_marker}(.*?)#{str2_marker}/m, 1]

    art_url_raw = data.string_between_markers('"src", "', '"]')
    if art_url_raw.nil?
    	then art_url_refined = "No URL Found"
    else
    art_url_refined=art_url_raw.prepend('https:')
    puts art_url_refined
    end
end

