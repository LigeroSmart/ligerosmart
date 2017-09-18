// --
// Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (AGPL). If you
// did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
// --

"use strict";

var ITSM = ITSM || {};
ITSM.Agent = ITSM.Agent || {};


/**
 * @namespace ITSM.Agent.UserSearch
 * @memberof ITSM.Agent.UserSearch
 * @author OTRS AG
 * @description
 *      This namespace contains the special module functions for the user search.
 */
ITSM.Agent.UserSearch = (function (TargetNS) {

    /**
     * @name Init
     * @namespace ITSM.Agent.UserAgent
     * @function
     * @param {jQueryObject} $UserSearches elements to add autocomplete behaviour (optional)
     *      if not given, will search for all inputs with the class '.UserSearch'
     * @description
     *      This function initializes the special module functions
     */
    TargetNS.Init = function ($UserSearches) {
        $UserSearches = $UserSearches || $('input.UserSearch');

        $UserSearches.each(function() {
            var $Element = $(this);

            Core.UI.Autocomplete.Init(
                $Element,
                function (Request, Response) {
                    var URL = Core.Config.Get('Baselink'), Data = {
                        Action: 'AgentITSMUserSearch',
                        Term: Request.term + '*',
                        Groups : $Element.data('autocompletegroups'),
                        MaxResults: Core.UI.Autocomplete.GetConfig('MaxResultsDisplayed')
                    };

                    $Element.data('AutoCompleteXHR', Core.AJAX.FunctionCall(URL, Data, function (Result) {
                        var Data = [];
                        $.each(Result, function () {
                            Data.push({
                                label: this.UserValue + " (" + this.UserKey + ")",
                                value: this.UserKey,
                                show : this.UserValue
                            });
                        });
                        Response(Data);
                    }));
                },
                function (Event, UI) {
                    $Element.val(UI.item.show);

                    // set hidden field SelectedUser
                    $('#' + Core.App.EscapeSelector($Element.attr('id')) + 'Selected').val(UI.item.value);

                    return false;
                },
                'CustomerSearch'
            );
        });

        //$UserSearches.on('click.UserSearch', function() {
        //    $(this).val('');
        //});

        // On unload remove old selected data. If the page is reloaded (with F5)
        // this data stays in the field and invokes an ajax request otherwise
        $(window).on('beforeunload.UserSearch', function () {
            $('input.UserSearchSelected').val('');
            return;
        });
    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(ITSM.Agent.UserSearch || {}));
