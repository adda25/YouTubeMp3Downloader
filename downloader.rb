require 'selenium/webdriver'
require 'find'
require 'pry'

# __   _______ ____                      _                 _           
# \ \ / /_   _|  _ \  _____      ___ __ | | ___   __ _  __| | ___ _ __ 
#  \ V /  | | | | | |/ _ \ \ /\ / / '_ \| |/ _ \ / _` |/ _` |/ _ \ '__|
#   | |   | | | |_| | (_) \ V  V /| | | | | (_) | (_| | (_| |  __/ |   
#   |_|   |_| |____/ \___/ \_/\_/ |_| |_|_|\___/ \__,_|\__,_|\___|_|   

class YTDownloader 
  attr_accessor :sleep_time_daemon_routine #seconds
  attr_accessor :music_url_download_path
  attr_reader   :browser
  attr_reader   :download_path 

  def initialize()
    @sleep_time_daemon_routine = 5 
    set_downloads_path
    set_browser
  end

  def set_downloads_path
    conf_path = __dir__ + "/conf.txt"
    File.foreach(conf_path).with_index do |line, line_num|
      if line_num == 0 
        @music_url_download_path = line.gsub("\n","")
      end
      if line_num == 1
        @download_path = line.gsub("\n","")
      end
    end
    puts "==> Chrome default downloads path: " + @music_url_download_path 
    puts "==> Download path: " + @download_path
  end

  def set_browser
    chromedriver_path = __dir__ + "/chromedriver" 
    Selenium::WebDriver::Chrome.driver_path = chromedriver_path
    prefs = {
      :download => {
        :prompt_for_download => false, 
        :default_directory => @download_path
      }
    }
    @browser = Selenium::WebDriver.for :chrome, :prefs => prefs
    @browser.manage.window.resize_to(0,0)
  end

  def daemon_routine
    loop do
      check_song_presence_and_download
      sleep(@sleep_time_daemon_routine)
    end
  end

  def check_song_presence_and_download
    music_file_paths = []
    Find.find(@music_url_download_path) do |path|
      music_file_paths << path if path =~ /._youtube_url_to_download_.txt$/
    end
    if music_file_paths.size() == 1 
      puts "\n==> YouTube download request received"
      File.open(music_file_paths[0], "r") do |f|
        File.delete(music_file_paths[0])
        f.each_line do |line|
          if line.include?("https://www.youtube.com/watch?")
            try_download(line)
          else
            puts "==> " + line + " is not a valid link"
          end
        end
      end
    end
  end

  def try_download(song_link)
    if !submit_request(song_link)
      return
    end
    song = download()
    if song == "undefined.mp3"
      puts '==> Something went wrong...download aborted'
      return
    end
    wait_download_complete(song)
  end

  ##################
  # Submit request #
  ##################
  private
  def submit_request(song_link)
    @browser.get 'http://www.youtube-mp3.org/it'
    wait = Selenium::WebDriver::Wait.new(:timeout => 10) # seconds
    wait.until { 
      element = browser.find_element(:id => 'youtube-url') 
      element.clear
      element.send_keys(song_link)
      element.submit
      puts '==> Submit: ' + song_link
      return true
    }
    return false
  end

  ##################
  # Download song  #
  ##################
  private
  def download()
    downloading = false
    song_filename = "undefined.mp3"
    for i in 0..100
      link   = browser.find_elements(:css => 'a')
      link_t = browser.find_elements(:id => 'title')
      link_e = browser.find_elements(:id => 'error_text')
      
      if link_e.size() > 0 && !link_e[0].text.empty?
        puts '==> Error detected, maybe the video lenght is greater than 20 minutes'
        return song_filename
      end
      
      link_t.each do |i|
        if i.text.include?('Titolo:')
          song_title = i.text[8..-1]
          song_filename = song_title + ".mp3"
          break
        end
      end
      
      link.each do |i|
        if i.text == 'Scarica'
          puts '==> Downloading song: ' + song_filename
          downloading = true
          i.click
          break
        end
      end
      if downloading
        break
      end
      sleep(1)
    
    end
    return song_filename
  end

  ##################
  # Wait download  #
  ##################
  private
  def wait_download_complete(song_filename)
    loop do 
      if File.file?(@download_path + "/" + song_filename)
        puts "==> Finish to download, song path: " + @download_path + "/" + song_filename
        puts "==> READY TO SING!"
        break
      end
    end
  end

end #End YTDownloader

# "/Users/adda/Downloads", "/Users/adda/Music/YTDMusic"
downloader = YTDownloader.new()
downloader.daemon_routine




