require 'selenium/webdriver'
require 'find'
require 'pry'

class YTDownloader 
  attr_accessor :sleep_time_daemon_routine #seconds
  attr_accessor :music_url_download_path
  attr_reader   :browser
  attr_reader   :download_path 

  def initialize(music_url_download_path, download_path)
    @sleep_time_daemon_routine = 5 
    @music_url_download_path = music_url_download_path
    @download_path = download_path
    chromedriver_path = __dir__ + "/chromedriver" 
    Selenium::WebDriver::Chrome.driver_path = chromedriver_path
    prefs = {
      :download => {
        :prompt_for_download => false, 
        :default_directory => download_path
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
    Find.find(@music_url_download_path ) do |path|
      music_file_paths << path if path =~ /._youtube_url_to_download_.txt$/
    end
    if music_file_paths.size() == 1 
      puts "\n==> YouTube download request received"
      File.open(music_file_paths[0], "r") do |f|
        File.delete(music_file_paths[0])
        f.each_line do |line|
          if line.include?("https://www.youtube.com/watch?")
            download(line)
          else
            puts "==> " + line + " is not a valid link"
          end
        end
      end
    end
  end

  def download(song_link)
    ##################
    # Submit request #
    ##################
    @browser.get 'http://www.youtube-mp3.org/it'
    end_time = Time.now + 10 #seconds
    begin
      element = browser.find_element(:id => 'youtube-url')
      element.clear
      element.send_keys(song_link)
      element.submit
      puts '==> Submit: ' + song_link
    rescue Selenium::WebDriver::Error::NoSuchElementError
      if Time.now < end_time
        browser.navigate.refresh
        retry
      end
      puts "Submit not retry"
    end

    ##################
    # Download song  #
    ##################
    sleep(1)
    downloading = false
    song_filename = "undefined.mp3"
    for i in 0..100
      link   = browser.find_elements(:css => 'a')
      link_t = browser.find_elements(:id => 'title')
      link_e = browser.find_elements(:id => 'error_text')
      
      if link_e.size() > 0 && !link_e[0].text.empty?
        puts '==> Error detected, maybe the video lenght is greater than 20 minutes'
        return
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
      if i > 90 
        puts '==> Something went wrong...download aborted'
        return
      end
    end

    ##################
    # Wait download  #
    ##################
    if downloading
      loop do 
        if File.file?(@download_path + "/" + song_filename)
          puts "==> Finish to download, song path: " + @download_path + "/" + song_filename
          puts "==> READY TO SING!"
          break
        end
      end
    end
  end

end #End YTDownloader

downloader = YTDownloader.new("/Users/adda/Downloads", "/Users/adda/Music/YTDMusic")
downloader.daemon_routine




