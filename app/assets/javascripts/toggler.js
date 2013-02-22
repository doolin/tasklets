function init() {
  var $toggle_links = $('.detail_toggle');
  $toggle_links.click(function(event) {
    $detail = $(this).siblings('.detail');
    $detail.toggleClass('hidden');
    event.preventDefault();
  });

  // Not the right place for this definition.
  getFirstLine = function(text) {
    return text.split(/[.!?]/)[0];
  }
}

$(function() {
  init();
});
