require 'find'

class YTDownloader 
  attr_accessor :sleep_time_daemon_routine #seconds
  attr_accessor :music_url_download_path
  attr_reader   :browser
  attr_reader   :download_path 

  def initialize()
    @sleep_time_daemon_routine = 5 
    set_downloads_path
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
            download(line)
          else
            puts "==> " + line + " is not a valid link"
          end
        end
      end
    end
  end

  def download(song_link)
    system 'youtube-dl --extract-audio --audio-format mp3 ' + song_link   
  end

end #End YTDownloader


downloader = YTDownloader.new()
downloader.daemon_routine




