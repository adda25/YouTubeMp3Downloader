## Youtube Mp3 Downloader 
Chrome extension that allow the user to download songs
from *YouTube* with a click. The system use the *youtube-dl* library
for download *mp3* from YouTube.

## Usage
Launch in the console the Ruby script:

```Ruby
ruby downloader-youtube-dl.rb
```

Now when you are listening a good song on *YouTube* (using *Chrome* as web browser)
click on the extension button:


![Extension button](readme_button_to_click.png)


and than in few seconds you will have your song in the specified directory.

## Notes
This project require *Ruby* and the <a href="https://rg3.github.io/youtube-dl/" <b>http://youtube-dl</b></a> library.
The system has been tested on OSX El Capitan 10.11.6, macOS Sierra 10.12,
Linux Mint 64bit.

# YouTube Mp3 Downloader [Old Selenium Version]
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

  * Download and install the *youtube-dl* library.

  * Launch in the terminal ruby deamon:

    ```Bash
    ruby daemon_downloader.rb
    ```


## Notes
This project require *Chrome* and *Ruby*.
The system has been tested on OSX El Capitan 10.11.6.

You can use the Ruby side without daemonize it:


```Ruby
ruby downloader-youtube-dl.rb
```






