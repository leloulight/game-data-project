
require 'rubygems'
require 'nokogiri'
require 'csv'

  # prepopulate CSV file with column headings
  #csv << ["title", "developer"]
  def valid(page)
      page = Nokogiri::HTML(open(page))
      data = page.css('tr td').collect {|node| node.text.strip}
      if data.include?('Developer(s)') then
        check = "Valid"
        return check
        else
        check = "Invalid"
        return check
      end
  end


  def get_file_as_string(filename)
    file = File.open(filename,"rb")
    contents = file.read
    return contents
  end


  #   data = ''
  #   f = File.open(filename, "r")
  #   f.each_line do |line|
  #     data += line
  #   end
  #   return data
  # end



  status = ""
  # def dupe(title,list) 
  #      if list.any? {|s| s.include?(title) }
  #         then status = "Duplicate"
  #         return status
  #       else
  #         status = "Original"
  #         return status
  #       end
      
  #     end
      
  #end

  title = ""
  def name(page)
  doc = Nokogiri::HTML(open(page))   #Instead of hardcoding filename use iterator variable.
  puts "#{page}" + " is being scanned.."  # => Nokogiri::HTML::Document

   # search elements via css and collect contents in arrays
   title = doc.css('.fn').collect {|node| node.text.strip}
   return title
  end


 #game_list = ""
 #def list(title)
  #current_time = Time.now.strftime("%m/%d/%Y")
  #title_file = File.new("game_titles_#{current_time}.txt", "w+")
  #title_file = File.new("game_titles.txt", "w+")
  #title_file.puts(title)
#end





  developer = ""
   def dev(page)
      page = Nokogiri::HTML(open(page))
      data = page.css('tr td').collect {|node| node.text.strip}
      

      dev_index = data.index('Developer(s)')
      dev_value = dev_index + 1
      

        developer = data[dev_value]

      if developer =~ /^This article/ then
          developer = "No Data"
      else developer
      end
      return developer
    end



   publisher = ""
      def pub(page)
      page = Nokogiri::HTML(open(page))
      data = page.css('tr td').collect {|node| node.text.strip}
      


      if data.include?('Publisher(s)') then

         pub_index = data.index('Publisher(s)')
         pub_value = pub_index + 1
         publisher = data[pub_value]
      else 
        publisher = "No data"
      end


      return publisher
    end


  release_date = ""
   def rel(page)
      page = Nokogiri::HTML(open(page))
      data = page.css('tr td').collect {|node| node.text.strip}
      

      #data = data.to_s
      if data.include?('Release date(s)') then

      rel_index = data.index('Release date(s)')
      rel_value = rel_index + 1
      release_date = data[rel_value]
    else
      release_date = "No data"
    end

      return release_date
    end


   def mode(page)
      page = Nokogiri::HTML(open(page))
      data = page.css('tr td').collect {|node| node.text.strip}
      
      if data.include?('Mode(s)') then

      mod_index = data.index('Mode(s)')
      mod_value = mod_index + 1
      mode = data[mod_value]
    else
      mode = "No data"
    end

      return mode
    end








  CSV.open("games_2014.csv", "ab:UTF-8") do |csv|          #Change to ab to append to games_2014 file instead of overwrite
  # prepopulate CSV file with column headings
  csv << ["title", "developer","publisher", "release_date", "mode"]
  end



Dir.foreach('/home/colson/Documents/scripts/ruby-game') do |file|
   

   verification = valid("#{file}")
    if verification == "Invalid"
      then next
    end
    
    title = name("#{file}")
    

    # file = File.open("game_titles.txt", "rb")
    # contents = file.read
    # #games_on_file = get_file_as_string(contents)
    # #puts games_on_file

    #    if contents.include?(title)
    #       then next
    #     end


    # status = dupe(title,contents)
    #  if status == "Duplicate"
    #   then next
    # end
    # puts status

    

   developer = dev("#{file}")
   

   publisher = pub("#{file}")

   release_date = rel("#{file}")
   mode = mode("#{file}")
  #current_time = Time.now.strftime("%m/%d/%Y")
  #file.puts current_time



#File.open("game_titles.txt", "w") { |f| f.puts title.shift}
  # generate CSV file games_2014.csv and force UTF-8
  CSV.open("games_2014.csv", "ab:UTF-8") do |csv|          #Change to ab to append to games_2014 file instead of overwrite

  # repeat extraction process until title array returns nothing i.e. no more elements on page
  until title.empty?
    File.open("game_titles.txt", "a+b") { |f| f.puts title}
    # write everything to CSV file
    csv << [title.shift, developer, publisher, release_date, mode]

  
 
end
end
end
#end