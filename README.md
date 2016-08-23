# YouTube Mp3 Downloader
Chrome extension that allow the user to download songs
from *YouTube* with a click. The system automatically submit requests
to 
<a href="http://www.youtube-mp3.org/it" <b>http://www.youtube-mp3.org/it</b></a>, and download the songs
in a specified folder. The system use *Selenium* and Ruby to automatically
navigate and download the songs selected during an *YouTube* session.

## Usage
Launch in the console the Ruby daemon:


```Ruby
ruby daemon_downloader.rb start
```

Now when you are listening a good song on *YouTube* (using *Chrome* as web browser)
click on the extension button:


![Extension button](readme_button_to_click.png)


and than in few seconds you will have your song in the specified directory.

The max lenght of the song must be 20 minutes, according to <a href="http://www.youtube-mp3.org/it" <b>http://www.youtube-mp3.org/it</b></a>. Some songs cannot be downloaded for copyright infrangement issues.

To stop the daemon:

```Ruby
ruby daemon_downloader.rb stop
```


## Installation
  * Clone the repository.
  * Install the *Chrome* extension as explained in this link: 
     <a href="https://developer.chrome.com/extensions/getstarted#unpacked" <b>https://developer.chrome.com/extensions/getstarted#unpacked</b></a>

  * Than be sure to have installed on your system the following Ruby gems:


    ```Bash
    gem install selenium-webdriver
    gem install daemons
    ```

  * You also need the *Chrome* driver: you can find it at this link:
    <a href="https://sites.google.com/a/chromium.org/chromedriver/downloads" <b>ChromeDriver</b></a>.
   Once upon you have downloaded the driver for your architecture, put it in 
   the directory where you cloned the project.
   
  * Run ./configure.sh in the shell, and enter the default Chrome downloads path
    and where you want to save your songs.
 

## Notes
This project require *Chrome* and *Ruby*.
The system has been tested on OSX El Capitan 10.11.6.

You can use the Ruby side without daemonize it:


```Ruby
ruby downloader.rb
```






