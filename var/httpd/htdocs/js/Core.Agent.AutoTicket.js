// --
// Core.Agent.CustomerInformationCenterSearch.js - provides the special module functions for the CIC search
// Copyright (C) 2001-2012 OTRS AG, http://otrs.org/
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (AGPL). If you
// did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
// --

"use strict";

var Core = Core || {};
Core.Agent = Core.Agent || {};

///**
// * @namespace
// * @exports TargetNS as Core.Agent.CustomerInformationCenterSearch
// * @description
// *      This namespace contains the special module functions for the search.
// */
Core.Agent.AutoTicketCustomerID = (function (TargetNS) {

    /**
     * @function
     * @private
     * @return nothing
     * @description Shows waiting dialog until screen is ready.
     */
    function ShowWaitingDialog(){
        Core.UI.Dialog.ShowContentDialog('<div class="Spacing Center"><span class="AJAXLoader" title="' + Core.Config.Get('LoadingMsg') + '"></span></div>', Core.Config.Get('LoadingMsg'), '10px', 'Center', true);
    }

    /**
     * @function
     * @param {jQueryObject} $Input Input element to add auto complete to
     * @param {String} Subaction Subaction to execute, "SearchCustomerID" or "SearchCustomerUser"
     * @return nothing
     */
    TargetNS.InitAutocomplete = function ($Input, Subaction) {
        $Input.autocomplete({
            minLength: Core.Config.Get('Autocomplete.MinQueryLength'),
            delay: Core.Config.Get('Autocomplete.QueryDelay'),
            open: function() {
                // force a higher z-index than the overlay/dialog
                $(this).autocomplete('widget').addClass('ui-overlay-autocomplete');
                return false;
            },
            source: function (Request, Response) {
                var URL = Core.Config.Get('Baselink'), Data = {
                    Action: 'AgentCustomerInformationCenterSearch',
                    Subaction: Subaction,
                    Term: Request.term,
                    MaxResults: Core.Config.Get('Autocomplete.MaxResultsDisplayed')
                };

                // if an old ajax request is already running, stop the old request and start the new one
                if ($Input.data('AutoCompleteXHR')) {
                    $Input.data('AutoCompleteXHR').abort();
                    $Input.removeData('AutoCompleteXHR');
                    // run the response function to hide the request animation
                    Response({});
                }

                $Input.data('AutoCompleteXHR', Core.AJAX.FunctionCall(URL, Data, function (Result) {
                    var Data = [];
                    $Input.removeData('AutoCompleteXHR');
                    $.each(Result, function () {
                        Data.push({
                            label: this.Label,
                            value: this.Value
                        });
                    });
                    Response(Data);
                }));
            },
            select: function (Event, UI) {
//                    alert(UI.item.value);
//                Redirect(UI.item.value, Event);
            }
        });
    };

    /**
     * @function
     * @param {String} Action which is used in framework right now.
     * @param {String} Used profile name.
     * @return nothing
     *      This function open the search dialog after clicking on "search" button in nav bar.
     */

    TargetNS.OpenSearchDialog = function () {

        var Data = {
            Action: 'AgentCustomerInformationCenterSearch'
        };

        ShowWaitingDialog();

        Core.AJAX.FunctionCall(
            Core.Config.Get('CGIHandle'),
            Data,
            function (HTML) {
                // if the waiting dialog was cancelled, do not show the search
                //  dialog as well
                if (!$('.Dialog:visible').length) {
                    return;
                }

                Core.UI.Dialog.ShowContentDialog(HTML, Core.Config.Get('SearchMsg'), '10px', 'Center', true, undefined, true);
                TargetNS.InitAutocomplete( $("#CustomerID"), 'SearchCustomerID' );
                TargetNS.InitAutocomplete( $("#AgentCustomerInformationCenterSearchCustomerUser"), 'SearchCustomerUser' );

            }, 'html'
        );
    };

    return TargetNS;
}(Core.Agent.AutoTicketCustomerID || {}));





/**
 * @namespace
 * @exports TargetNS as ITSM.Agent.CustomerSearch
 * @description
 *      This namespace contains the special module functions for the customer search.
 */
Core.Agent.AutoTicketCustomerSearch = (function (TargetNS) {
    var BackupData = {
        CustomerInfo: '',
        CustomerEmail: '',
        CustomerKey: ''
    };


    /**
     * @function
     * @param {jQueryObject} $Element The jQuery object of the input field with autocomplete
     * @param {Boolean} ActiveAutoComplete Set to false, if autocomplete should only be started by click on a button next to the input field
     * @return nothing
     *      This function initializes the special module functions
     */
    TargetNS.Init = function ($Element, ActiveAutoComplete) {

        if (typeof ActiveAutoComplete === 'undefined') {
            ActiveAutoComplete = true;
        }
        else {
            ActiveAutoComplete = !!ActiveAutoComplete;
        }

        if (isJQueryObject($Element)) {
            $Element.autocomplete({
                minLength: ActiveAutoComplete ? Core.Config.Get('CustomerAutocomplete.MinQueryLength') : 500,
                delay: Core.Config.Get('CustomerAutocomplete.QueryDelay'),
                source: function (Request, Response) {
                    var URL = Core.Config.Get('Baselink'), Data = {
                        Action: 'AgentCustomerSearch',
                        Term: Request.term,
                        MaxResults: Core.Config.Get('CustomerAutocomplete.MaxResultsDisplayed')
                    };
                    Core.AJAX.FunctionCall(URL, Data, function (Result) {
                        var Data = [];
                        $.each(Result, function () {
                            Data.push({
                                label: this.Label + " (" + this.Value + ")",
                                value: this.Value
                            });
                        });
                        Response(Data);
                    });
                },
                select: function (Event, UI) {

                    var CustomerKey = UI.item.label.replace(/.*\((.*)\)$/, '$1');

                    $Element.val(CustomerKey);

                    // set hidden field SelectedCustomerUser
                    // escape : with two leading backslashes in front of each :
                    // this is necessary because jQuery can not handle a colon (:) in id attributes
                    $('#' + $Element.attr('id').replace(/:/g, '\\:') + 'Selected').val(CustomerKey);

                    return false;
                }
            });

            if (!ActiveAutoComplete) {

                $Element.after('<button id="' + $Element.attr('id') + 'Search" type="button">' + Core.Config.Get('CustomerAutocomplete.SearchButtonText') + '</button>');
                // escape : with two leading backslashes in front of each :
                // this is necessary because jQuery can not handle a colon (:) in id attributes
                $('#' + $Element.attr('id').replace(/:/g, '\\:') + 'Search').click(function () {
                    $Element.autocomplete("option", "minLength", 0);
                    $Element.autocomplete("search");
                    $Element.autocomplete("option", "minLength", 500);
                });
            }
        }

        // On unload remove old selected data. If the page is reloaded (with F5) this data stays in the field and invokes an ajax request otherwise
        $(window).bind('unload', function () {
            // escape : with two leading backslashes in front of each :
            // this is necessary because jQuery can not handle a colon (:) in id attributes
            $('#' + $Element.attr('id').replace(/:/g, '\\:') + 'Selected').val('');
        });
    };

    return TargetNS;
}(Core.Agent.AutoTicketCustomerSearch || {}));

$( document ).ready(function() {
   checkNwd();
});

$( '#Nwd' ).change(function() {
   checkNwd();
});

function checkNwd(){
	$('label.SLAIDREQ').removeClass('Mandatory');
	$('#SLAID').removeClass('Validate_Required');
	$('span.SLAIDREQ').removeClass('Marker');
	$('span.SLAIDREQ').html('');
	
	if($('#Nwd').val()!=5){
		$('#SLAID').addClass('Validate_Required');
		$('label.SLAIDREQ').addClass('Mandatory');
		$('span.SLAIDREQ').addClass('Marker');
		$('span.SLAIDREQ').html('*');
	}
}


