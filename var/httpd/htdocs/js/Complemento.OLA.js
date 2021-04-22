//Verifica o nome do Arquivo
//
// --
// Complemento.OLA.js - provides the special module functions for the Multiselect Dynamic Fields.
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (AGPL). If you
// did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
// --

"use strict";
var Complemento = Complemento || {};
Complemento.OLA = Complemento.OLA || {};
/**
 * @namespace
 * @exports TargetNS as Complemento.OLA
 * @description
 *      This namespace contains the special module functions for OLA monitoring
 */
Complemento.OLA = (function (TargetNS) {
    // Hide JSON Fields
    $('#OLA_Queues').parent().hide();
    $('label[for=OLA_Queues]').hide();
    /**
     * @function
     * @param {string} IDSelector, id of the pressed remove value button.
     * @return nothing
     *      This function removes a value from possible values list and creates a stub input so
     *      the server can identify if a value is empty or deleted (useful for server validation)
     *      It also deletes the Value from the DefaultValues list
     */
    TargetNS.RemoveValue = function (IDSelector){

        // copy HTML code for an input replacement for the deleted value
        var $Clone = $('.DeletedValue').clone(),

        // get the index of the value to delete (its always the second element (1) in this RegEx
        $ObjectIndex = IDSelector.match(/.+_(\d+)/)[1],

        // get the key name to remove it from the defaults select
        $Key = $('#Key_' + $ObjectIndex).val();

        // set the input replacement attributes to match the deleted original value
        // new value and other controls are not needed anymore
        $Clone.attr('id', 'Key' + '_' + $ObjectIndex);
        $Clone.attr('name', 'Key' + '_' + $ObjectIndex);
        $Clone.removeClass('DeletedValue');

        // add the input replacement to the mapping type so it can be parsed and distinguish from
        // empty values by the server
        $('#'+ IDSelector).closest('fieldset').append($Clone);

        // remove the value from default list
        if ($Key !== ''){
            $('#DefaultValue').find("option[value='"+ $Key +"']").remove();
        }

        // remove possible value
        $('#'+ IDSelector).parent().remove();

        return false;
    };

    /**
     * @function
     * @param {Object} ValueInsert, HTML container of the value mapping row
     * @return nothing
     *      This function add a new value to the possible values list
     */
    TargetNS.AddValue = function (ValueInsert) {

        // clone key dialog
        var $Clone = $('.ValueTemplate').clone(),
            ValueCounter = $('#ValueCounter').val();

        // increment key counter
        ValueCounter ++;

        // remove unnecessary classes
        $Clone.removeClass('Hidden ValueTemplate');

        // add needed class
        $Clone.addClass('ValueRow');

        // copy values and change ids and names
        $Clone.find(':input, a.RemoveButton').each(function(){
            var ID = $(this).attr('id');
            $(this).attr('id', ID + '_' + ValueCounter);
            $(this).attr('name', ID + '_' + ValueCounter);
			if( ID != "UpdateNotify" ){  
	            $(this).addClass('Validate_Required');

            // set error controls

	            $(this).parent().find('#' + ID + 'Error').attr('id', ID + '_' + ValueCounter + 'Error');
	            $(this).parent().find('#' + ID + 'Error').attr('name', ID + '_' + ValueCounter + 'Error');
	
	            $(this).parent().find('#' + ID + 'ServerError').attr('id', ID + '_' + ValueCounter + 'ServerError');
	            $(this).parent().find('#' + ID + 'ServerError').attr('name', ID + '_' + ValueCounter + 'ServerError');
			}
            // add event handler to remove button
            if( $(this).hasClass('RemoveButton') ) {

                // bind click function to remove button
                $(this).bind('click', function () {
                    TargetNS.RemoveValue($(this).attr('id'));
                    return false;
                });
            }
        });

        $Clone.find('label').each(function(){
            var FOR = $(this).attr('for');
            $(this).attr('for', FOR + '_' + ValueCounter);
        });

        // append to container
        ValueInsert.append($Clone);

        // set new value for KeyName
        $('#ValueCounter').val(ValueCounter);

        $('.DefaultValueKeyItem,.DefaultValueItem').bind('keyup', function () {
            Complemento.OLA.RecreateDefaultValueList();
        });
        return false;
    };

    /**
     * @function
     * @return nothing
     *      This function re-creates and sort the Default Values list taking the Possible Values
     *      as source, all deleted values will not be part of the re-created value list
     */
    TargetNS.RecreateDefaultValueList = function() {

        // get the selected default value
        var SelectedValue = $("#DefaultValue option:selected").val(),

        // define other variables
        ValueIndex, Key, Value, KeyID, SelectOptions;

        // delete all elements
        $('#DefaultValue').empty();

        // add the default "possible none" element
        $('#DefaultValue').append($('<option>', { value : '' }).text('-'));

        // find all active possible values keys (this will omit all previously deleted keys)
        $('.ValueRow > .DefaultValueKeyItem').each(function(){

            // for each key:
            // Get the ID
            KeyID = $(this).attr('id');

            // extract the index
            ValueIndex = KeyID.match(/.+_(\d+)/)[1];

            // get the Key and Value
            Key = $(this).val();
            Value = $('#Value_' + ValueIndex).val();

            // check if both are none empty and add them to the default values list
            if (Key !== '' && Value !== '') {
                $('#DefaultValue').append($('<option>', { value : Key }).text(Value));

            }
        });

        // extract the new value list into an array
        SelectOptions = $("#DefaultValue option");

        // sort the array by the text (this means the Value)
        SelectOptions.sort(function(a,b) {
            if (a.text > b.text) {
                return 1;
            }
            else if (a.text < b.text) {
                return -1;
            }
            else {
                return 0;
            }
        });

        // clear the list again and re-populate it with the sorted list
        $("#DefaultValue").empty().append( SelectOptions );

        // set the selected value as it was before, this will not apply if the key name was
        // changed
        $('#DefaultValue').val(SelectedValue);

        return false;
    };
    TargetNS.RecreateFields = function(ObjectText) {
		var JSONTextBox = JSON.parse(ObjectText.val());
		for(var queue in JSONTextBox) {
	  		var Time = JSONTextBox[queue].Time;
      var Notify = JSONTextBox[queue].Notify;
      var Calendar = JSONTextBox[queue].Calendar;
			var Queue  = queue;
		     // clone key dialog
	        var $Clone = $('.ValueTemplate').clone(),
            ValueCounter = $('#ValueCounter').val();

      		  // increment key counter
	         ValueCounter ++;

     	   // remove unnecessary classes
        	$Clone.removeClass('Hidden ValueTemplate');

    	    // add needed class
	        $Clone.addClass('ValueRow');

	        // copy values and change ids and names
	        $Clone.find(':input, a.RemoveButton').each(function(){
	            var ID = $(this).attr('id');
    	        $(this).attr('id', ID + '_' + ValueCounter);
        	    $(this).attr('name', ID + '_' + ValueCounter);
				$(this).parent().find('#TimeValue_' + ValueCounter ).val(Time);
        $(this).parent().find('#UpdateNotify_' + ValueCounter ).val(Notify);
        $(this).parent().find('#Calendar_' + ValueCounter ).val(Calendar);
				$(this).parent().find('#Queue_' + ValueCounter ).val(Queue);

            	if( ID != "UpdateNotify" ){
	            	$(this).addClass('Validate_Required');
            // set error controls
	    	        $(this).parent().find('#' + ID + 'Error').attr('id', ID + '_' + ValueCounter + 'Error');
	    	        $(this).parent().find('#' + ID + 'Error').attr('name', ID + '_' + ValueCounter + 'Error');
		
	    	        $(this).parent().find('#' + ID + 'ServerError').attr('id', ID + '_' + ValueCounter + 'ServerError');
	        	    $(this).parent().find('#' + ID + 'ServerError').attr('name', ID + '_' + ValueCounter + 'ServerError');
				}
	            // add event handler to remove button
    	        if( $(this).hasClass('RemoveButton') ) {
	
    	            // bind click function to remove button
        	        $(this).bind('click', function () {
            	        TargetNS.RemoveValue($(this).attr('id'));
                	    return false;
	                });
    	        }

				$(this).find("#TimeValue_"+ValueCounter).val(Time);
	        });

	        $Clone.find('label').each(function(){
	            var FOR = $(this).attr('for');
    	        $(this).attr('for', FOR + '_' + ValueCounter);
	        });

	        // append to container
	        $(".ValueInsert").append($Clone);

	        // set new value for KeyName
	        $('#ValueCounter').val(ValueCounter);

	        $('.DefaultValueKeyItem,.DefaultValueItem').bind('keyup', function () {
        	    Complemento.OLA.RecreateDefaultValueList();
    	    });

	    };
	};
    return TargetNS;
}(Complemento.OLA || {}));


