var elem = document.querySelector('.grid');
var msnry = new Masonry(elem, {
  itemSelector: '.grid-item',
  horizontalOrder: true,
  isFitWidth: true
});
