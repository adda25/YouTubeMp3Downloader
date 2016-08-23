
function download(text, name, type) {
  var a = document.createElement("a");
  var file = new Blob([text], {type: type});
  a.href = URL.createObjectURL(file);
  a.download = name;
  a.click();
}

chrome.browserAction.onClicked.addListener(function(tab) {
  chrome.tabs.query({'active': true, 'windowId': chrome.windows.WINDOW_ID_CURRENT},
    function(tabs){
      download(tabs[0].url, "_youtube_url_to_download_.txt", "text/plain")
    }
  );
});

