// --
// Copyright (C) 2001-2016 OTRS AG, http://otrs.com/
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (AGPL). If you
// did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
// --

"use strict";

// Pesquisar nos Artigos ##############################################################
var $input = $('#LigeroServiceSearchMark');
var $context = $("#ServiceCatalog");
//setup before functions
var typingTimer;                //timer identifier
var doneTypingInterval = 500;  //time in ms

//on keyup, start the countdown
$input.on('keyup', function () {
	clearTimeout(typingTimer);
    // @TODO: Isso é realmente necessário:?
	typingTimer = setTimeout(doneTyping, doneTypingInterval);
});

//on keydown, clear the countdown 
$input.on('keydown', function () {
	clearTimeout(typingTimer);
});
$('#LigeroServiceSearch').on('keyup', function () {
    clearTimeout(typingTimer);
	if($(this).val() == ""){
		$("#ServiceCatalogResults").hide();
		$("#ServiceCatalogItens").show();
		$("#StartHit").val('0');
	}
});

$('#LigeroServiceSearch').on('keydown', function () {
    clearTimeout(typingTimer);
});

$( function() {
	var Data = {
		Action: 'CustomerServiceCatalog',
		Subaction: 'AjaxCustomerService',
	};
	$( "#LigeroServiceSearch" ).bind( "keydown", function( event ) {
	    }).autocomplete({
			     	minLength: 3,
		    	  	source: function( request, response){
						$.ajax({
							url: Core.Config.Get('CGIHandle'),
							data:  {
								Action: 'CustomerServiceCatalog',
								Subaction: 'AjaxCustomerService',
								Term: $("#LigeroServiceSearch").val(),
								StartHit: $("#StartHit").val(), 
							},
							success: function(Datas){
								$("#ServiceCatalogResults").html(Datas);
								$("#ServiceCatalogResults").show();
								$(".Tabs a").click(function(e){
									e.preventDefault();
									var linkPag = $(this).attr('href');
									var res = linkPag.split("=");
									$("#StartHit").val(res[5]);
									$( "#LigeroServiceSearch").trigger("keydown");	
								});	
								$("#StartHit").val('0');
							},
							error:  function(){	
								response([]);
							}
	
		
						});	
					}

    			} );
	 } );

function doneTyping () {
	var term = $input.val();
	$('.Need,.Category',$context).show().unmark();
	if (term) {

		$('.Need,.Category',$context).mark(term, {

		});

	    $('.Need',$context).each(function(){
			if($(this).contents().find("mark").length){
				$(this).show();
			} else {
				$(this).hide();
		
			}
		
	  	});
	    $('.Category',$context).each(function(){
			if($(this).contents().find("mark").length){
				$(this).show();
			} else {
				$(this).hide();
		    }
 	   });

	};
	if($('.Need:visible').length){
		$('.NeedMessage').show();
	} else {
		$('.NeedMessage').hide();
	}
	if($('.Category:visible').length){
		$('.MoreServices').show();
	} else {
		$('.MoreServices').hide();
	}
  	if($('.Need:visible').length == 0 && $('.Category:visible').length == 0){
		$("#NotFoundResult").show();
	}else{
		$("#NotFoundResult").hide();
	}	
};

// Quando começar a busca já apaga as informações da tela 
$( "#LigeroServiceSearch" ).on( "autocompletesearch", function( event, ui ) {
	$("#ServiceCatalogItens").hide();
} );			
