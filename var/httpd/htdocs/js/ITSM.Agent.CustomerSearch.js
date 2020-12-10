// --
// Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (GPL). If you
// did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
// --

"use strict";

var ITSM = ITSM || {};
ITSM.Agent = ITSM.Agent || {};

/**
 * @namespace ITSM.Agent.CustomerSearch
 * @memberof ITSM.Agent
 * @author OTRS AG
 * @description
 *      This namespace contains the special module functions for the customer search.
 */
ITSM.Agent.CustomerSearch = (function (TargetNS) {

    /**
     * @name Init
     * @memberof ITSM.Agent.CustomerSearch
     * @function
     * @param {jQueryObject} $Element - The jQuery object of the input field with autocomplete.
     * @description
     *      Initializes the special module functions.
     */
    TargetNS.Init = function ($Element) {

        if (isJQueryObject($Element)) {

            Core.UI.Autocomplete.Init($Element, function (Request, Response) {
                    var URL = Core.Config.Get('Baselink'),
                        Data = {
                            Action: 'AgentCustomerSearch',
                            Term: Request.term,
                            MaxResults: Core.UI.Autocomplete.GetConfig('MaxResultsDisplayed')
                        };

                    $Element.data('AutoCompleteXHR', Core.AJAX.FunctionCall(URL, Data, function (Result) {
                        var ValueData = [];
                        $Element.removeData('AutoCompleteXHR');
                        $.each(Result, function () {
                            ValueData.push({
                                label: this.Label + " (" + this.Value + ")",
                                value: this.Value,
                                show : this.Label
                            });
                        });
                        Response(ValueData);
                    }));
                },
                function (Event, UI) {
                    $Element.val(UI.item.show);

                    // set hidden field SelectedCustomerUser
                    // escape possible colons (:) in element id because jQuery can not handle it in id attribute selectors
                    $('#' + Core.App.EscapeSelector($Element.attr('id')) + 'Selected').val(UI.item.value);

                    return false;
                },
                'CustomerSearch'
            );
        }

        // before unload remove old selected data. If the page is reloaded (with F5) this data stays in the field and invokes an ajax request otherwise
        $(window).on('beforeunload.CustomerSearch', function () {
            // escape possible colons (:) in element id because jQuery can not handle it in id attribute selectors
            $('#' + Core.App.EscapeSelector($Element.attr('id')) + 'Selected').val('');
            return;
        });
    };

    return TargetNS;
}(ITSM.Agent.CustomerSearch || {}));
