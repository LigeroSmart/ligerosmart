function textboxHint(id, options) {
    var o = { selector: 'input:text[title]', blurClass:'Blur' };
    $e = $('#'+id);
    $.extend(true, o, options || {});

    if ($e.is(':text')) {
      if (!$e.attr('title')) $e = null;
    } else {
      $e = $e.find(o.selector);
    }
    if ($e) {
      $e.each(function() {
      var $t = $(this);
      if ($.trim($t.val()).length == 0) { $t.val($t.attr('title')); }
      if ($t.val() == $t.attr('title')) {
	$t.addClass(o.blurClass);
      } else {
        $t.removeClass(o.blurClass);
      }

     $t.focus(function() {
	if ($.trim($t.val()) == $t.attr('title')) {
	  $t.val('');
	  $t.removeClass(o.blurClass);
	}
	}).blur(function() {
	  var val = $.trim($t.val());
	  if (val.length == 0 || val == $t.attr('title')) {
	    $t.val($t.attr('title'));
	    $t.addClass(o.blurClass);
	  }
	});

         // empty the text box on form submit
	$(this.form).submit(function(){
	  if ($.trim($t.val()) == $t.attr('title')) $t.val('');
	});
   });
 }
}
