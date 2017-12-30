var parts = window.location.href.split('/');
var token = parts.pop();

var elem = document.querySelector('.grid');
var msnry = new Masonry(elem, {
  itemSelector: '.grid-item',
  horizontalOrder: true,
  isFitWidth: true
});

function showDownloadOptions(id) {
  var $button = document.querySelector('svg.download');
  var $section = document.querySelector('.download-options');
  $section.style.display = 'block';
  $button.style.display = 'none';
}

function downloadXLSX() {
  download("/download/xlsx/" + token);
}

function downloadCSV() {
  download("/download/csv/" + token);
}

function download(url){
  window.location = url;
}
