// --
// ITSM.Agent.CustomerSearch.js - provides the special module functions for the customer search
// Copyright (C) 2001-2011 OTRS AG, http://otrs.org/\n";
// --
// $Id: ITSM.Agent.CustomerSearch.js,v 1.4 2011-05-19 14:24:18 ub Exp $
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (AGPL). If you
// did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
// --

"use strict";

var ITSM = ITSM || {};
ITSM.Agent = ITSM.Agent || {};

/**
 * @namespace
 * @exports TargetNS as ITSM.Agent.CustomerSearch
 * @description
 *      This namespace contains the special module functions for the customer search.
 */
ITSM.Agent.CustomerSearch = (function (TargetNS) {
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
                                label: this.CustomerValue + " (" + this.CustomerKey + ")",
                                value: this.CustomerValue
                            });
                        });
                        Response(Data);
                    });
                },
                select: function (Event, UI) {
                    var CustomerKey = UI.item.label.replace(/.*\((.*)\)$/, '$1');

                    $Element.val(UI.item.value);

                    // get the element id
                    var ElementID = $Element.attr('id');

                    // escape :: with two leading backslashes in front of each :
                    // this is necessary because jQuery can not handle a colon (:) in id attributes
                    ElementID = ElementID.replace(/::/g, '\\:\\:');

                    // set hidden field SelectedCustomerUser
                    $('#' + ElementID + 'Selected').val(CustomerKey);

                    return false;
                }
            });

            if (!ActiveAutoComplete) {
                $Element.after('<button id="' + $Element.attr('id') + 'Search" type="button">' + Core.Config.Get('CustomerAutocomplete.SearchButtonText') + '</button>');
                $('#' + $Element.attr('id') + 'Search').click(function () {
                    $Element.autocomplete("option", "minLength", 0);
                    $Element.autocomplete("search");
                    $Element.autocomplete("option", "minLength", 500);
                });
            }
        }

        // On unload remove old selected data. If the page is reloaded (with F5) this data stays in the field and invokes an ajax request otherwise
        $(window).bind('unload', function () {
           $('#' + $Element.attr('id') + 'Selected').val('');
        });
    };

    return TargetNS;
}(ITSM.Agent.CustomerSearch || {}));
