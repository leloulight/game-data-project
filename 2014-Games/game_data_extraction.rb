# encoding: UTF-8

require 'rubygems'
require 'nokogiri'
require 'csv'
require 'htmlentities'
require 'time'

@start_time = Time.now

# Make sure to use this and move script elsewhere
@game_directory = '/home/colson/Documents/scripts/2014-Games/'



# Makes human readable time delta- over 5 days will show up bold in morning report
def readablize(seconds,html='plain_readablize')
    if html == 'html_readablize' and seconds > 432000
        [[60, :second], [60, :minute], [24, :hour], [1000, :day]].map{ |count, name|

            if seconds > 0 then
                seconds, n = seconds.divmod(count)
                "<strong>#{n.to_i} #{name}(s)</strong>"
            end
      }.compact.reverse.join(' ')

    else
        [[60, :second], [60, :minute], [24, :hour], [1000, :day]].map{ |count, name|
                if seconds > 0 then
                            seconds, n = seconds.divmod(count)
                                        "#{n.to_i} #{name}(s)"
                end
        }.compact.reverse.join(' ')
    
    end
end

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


  title = ""
  def name(page)
  doc = Nokogiri::HTML(open(page))   #Instead of hardcoding filename use iterator variable.
  puts "#{page}" + " is being scanned.."  # => Nokogiri::HTML::Document

   # search elements via css and collect contents in arrays
   title = doc.css('.fn').collect {|node| node.text.strip}
   return title
  end

  developer = ""
   def dev(page)
      page = Nokogiri::HTML(open(page))
      data = page.css('tr td').collect {|node| node.text.strip} 

      dev_index = data.index('Developer(s)')
      dev_value = dev_index + 1
      developer = data[dev_value]
      developer = developer.gsub(/\[.*\]/, "")
      developer = developer.gsub(/\(.*\)/, "")

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
         publisher = publisher.gsub(/\[.*\]/, "")
         publisher = publisher.gsub(/\(.*\)/, "")
      else 
        publisher = "No data"
      end


      return publisher
    end

    def art(page)
      page = Nokogiri::HTML(open(page))
      data = page.css('.hproduct img').collect {|node| node.first(2)}
      return data.to_s
    end

      class String
        def string_between_markers marker1, marker2
        self[/#{Regexp.escape(marker1)}(.*?)#{Regexp.escape(marker2)}/m, 1]
        end
      end


   # def rel(page)
   #    coder = HTMLEntities.new


   #    page = Nokogiri::HTML(open(page))
   #    data = page.css('tr td').collect {|node| node.text.strip}
   #    coded = coder.decode(data)

   #    rel_index = coded.index('Release date(s)')
   #     if rel_index.nil? then release_date = 0 else
   #     rel_value = rel_index + 1
   #     release_date = data[rel_value] end

   #    return release_date
   #  end


    def rel(page)
      page = Nokogiri::HTML(open(page))
      data = page.css('tr td').collect {|node| node.text.strip}
      data_refine = data.each do |s| s.gsub!(/\u00a0/, ' ') end

    if data_refine.include?('Release date(s)') then

      rel_index = data_refine.index('Release date(s)')
      rel_value = rel_index + 1
      release_date = data[rel_value]
      release_date = release_date.match(/(\b\d{1,2}\D{0,3})?\b(?:Jan(?:uary)?|Feb(?:ruary)?|Mar(?:ch)?|Apr(?:il)?|May|Jun(?:e)?|Jul(?:y)?|Aug(?:ust)?|Sep(?:tember)?|Oct(?:ober)?|(Nov|Dec)(?:ember)?)\D?(\d{1,2}\D?)?\D?((19[7-9]\d|20\d{2})|\d{2})/).to_s
      

      if release_date.nil?
        release_date = "No data"
      elsif release_date == ""
        release_date = "No data"
      else

      release_date = Time.parse(release_date).strftime("%m/%d/%y")
      end

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
  csv << ["title", "developer","publisher", "release_date", "mode","box_art_url"]
  end



Dir.foreach('/home/colson/Documents/scripts/2014-Games/') do |file|
   

   verification = valid("#{file}")
    if verification == "Invalid"
      then next
    end
    
    title = name("#{file}")

   developer = dev("#{file}")
   
   publisher = pub("#{file}")

   release_date = rel("#{file}")
  
   mode = mode("#{file}")
    
   box_art_url = art("#{file}")
   art_url_raw = box_art_url.string_between_markers('"src", "', '"]')
    if art_url_raw.nil?
      then art_url_refined = "No URL Found"
    else
    art_url_refined=art_url_raw.prepend('https:')
    end
#File.open("game_titles.txt", "w") { |f| f.puts title.shift}
  # generate CSV file games_2014.csv and force UTF-8
  CSV.open("games_2014.csv", "ab:UTF-8") do |csv|          #Change to ab to append to games_2014 file instead of overwrite

  # repeat extraction process until title array returns nothing i.e. no more elements on page
  until title.empty?
    File.open("game_titles.txt", "a+b") { |f| f.puts title}
    # write everything to CSV file
    csv << [title.shift, developer, publisher, release_date, mode, art_url_refined]

  
 
end
end
end

time_diff = Time.now - @start_time
puts "Script complete, duration: #{readablize(time_diff)}"

