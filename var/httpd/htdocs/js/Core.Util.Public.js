
"use strict";

if($("#checkAssoc").is(':checked')){
	$("#Assoc").parent().show();
}

//Show assoc Field
$("#checkAssoc").click(function(){
	if($(this).is(':checked')){
		$("#Assoc").parent().show();
	}else{
		$("#Assoc").parent().hide();

	}	
});

