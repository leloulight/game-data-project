# encoding: UTF-8

require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'csv'
require 'htmlentities'
require 'time'
require 'sequel'

@start_time = Time.now
# database connection
@db = Sequel.connect(:adapter => 'postgres', :host=>'localhost', :user=>'colson', :password=>'5346488k', :database=>'gamedata')

puts "Fetch new HTML files? (y/n)"
fetch_answer = gets.chomp
if fetch_answer == "y"
  then
    puts "Enter year of game releases to download: "
    year = gets.chomp



    
    DATA_DIR = "#{year}-Games"
    Dir.mkdir(DATA_DIR) unless File.exists?(DATA_DIR)

    BASE_WIKIPEDIA_URL = "http://en.wikipedia.org"
    LIST_URL = "#{BASE_WIKIPEDIA_URL}/wiki/#{year}_in_video_gaming"

    HEADERS_HASH = {"User-Agent" => "Ruby/#{RUBY_VERSION}"}

    page = Nokogiri::HTML(open(LIST_URL))
    rows = page.css('div.mw-content-ltr table.wikitable tr')

    rows[1..-2].each do |row|
      
      hrefs = row.css("td a").map{ |a| 
        a['href'] if a['href'] =~ /^\/wiki\// 
      }.compact.uniq
      
      hrefs.each do |href|
        remote_url = BASE_WIKIPEDIA_URL + href
        local_fname = "#{DATA_DIR}/#{File.basename(href)}.html"
        unless File.exists?(local_fname)
          puts "Fetching #{remote_url}..."
          begin
            wiki_content = open(remote_url, HEADERS_HASH).read
          rescue Exception=>e
            puts "Error: #{e}"
            sleep 5
          else
            File.open(local_fname, 'w'){|file| file.write(wiki_content)}
            puts "\t...Success, saved to #{local_fname}"
          ensure
            sleep 1.0 + rand
          end  # done: begin/rescue
        end # done: unless File.exists?
        
      end # done: hrefs.each
    end # done: rows.each
  elsif fetch_answer == "n"
    then 
    puts "Enter year of game releases to extract: "
    year = gets.chomp

###########################################################################################################
puts "Beginning data extraction..."
    # Make sure to use this and move script elsewhere
    @game_directory = '/home/colson/Documents/scripts/'+year+'-Games/'



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
            release_date = "01/01/01"
          elsif release_date == ""
            release_date = "01/01/01"
          else

          release_date = Time.parse(release_date).strftime("%m/%d/%y")
          end

        else
         release_date = "01/01/01"
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

      CSV.open("games_"+year+".csv", "ab:UTF-8") do |csv|          #Change to ab to append to games_2014 file instead of overwrite
      # prepopulate CSV file with column headings
      csv << ["title", "developer","publisher", "release_date", "mode","box_art_url"]
      end



    Dir.foreach(@game_directory) do |file|
       

       verification = valid(@game_directory+"#{file}")
        if verification == "Invalid"
          then next
        end
        
       title = name(@game_directory+"#{file}")
       #sql_friendly_title = title[0].gsub("'", %q(\\\'))
       #sql_friendly_title = title[0].gsub(/'/, "''")

       developer = dev(@game_directory+"#{file}")
       
       publisher = pub(@game_directory+"#{file}")

       release_date = rel(@game_directory+"#{file}")
      
       mode = mode(@game_directory+"#{file}")
        
       box_art_url = art(@game_directory+"#{file}")
       art_url_raw = box_art_url.string_between_markers('"src", "', '"]')
        if art_url_raw.nil?
          then art_url_refined = "No URL Found"
        else
        art_url_refined=art_url_raw.prepend('https:')
        end
    #File.open("game_titles.txt", "w") { |f| f.puts title.shift}
      # generate CSV file games_2014.csv and force UTF-8
      CSV.open("games_"+year+".csv", "ab:UTF-8") do |csv|          #Change to ab to append to games_2014 file instead of overwrite

      # repeat extraction process until title array returns nothing i.e. no more elements on page
      until title.empty?
        File.open("game_titles.txt", "a+b") { |f| f.puts title}
        # write everything to CSV file
        csv << [title.shift, developer, publisher, release_date, mode, art_url_refined]


      schema = "(name, developer, publisher, release_date, mode, box_art_url)"

      #Decommissioned due to strange apostrophe issue. Gsub backslash didn't seem to work
      #sql = "INSERT INTO game_data #{schema} VALUES ('#{sql_friendly_title}', '#{developer}', '#{publisher}','#{release_date}','#{mode}','#{box_art_url}')"
      #@db.run(sql)
      
     
    end
    end
    end

  
    puts "Importing CSV into database"
    #Import CSV into database
    import_cmd = `psql -v csv="'/home/colson/Documents/scripts/games_#{year}.csv'" -f csv_only_import.sql gamedata`
    puts import_cmd

    time_diff = Time.now - @start_time
    
    puts 'Deleting CSVs...'
    Dir.glob('/home/colson/Documents/scripts/*.csv').each { |f| File.delete(f) }
    
    puts "Script complete, duration: #{readablize(time_diff)}"
  


  else
    puts "Not a valid response. Exiting run..."
  end