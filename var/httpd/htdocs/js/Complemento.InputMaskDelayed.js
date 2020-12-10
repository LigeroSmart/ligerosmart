var inputMaskDelayed = ( typeof inputMaskDelayed != 'undefined' && inputMaskDelayed instanceof Array ) ? inputMaskDelayed : [];
for(var f in inputMaskDelayed){inputMaskDelayed[f]();}
if (window.location.href.match(/AdminGenericAgent/ig) !== null) {
	setTimeout( function() {
		$('[data-inputmask]').each( function() {
			$(this).inputmask('remove').val('');
		});
	}, 1000);
}
