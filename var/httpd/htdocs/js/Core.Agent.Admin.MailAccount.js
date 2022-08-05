// --
// OTOBO is a web-based ticketing system for service organisations.
// --
// Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
// Copyright (C) 2019-2021 Rother OSS GmbH, https://otobo.de/
// --
// This program is free software: you can redistribute it and/or modify it under
// the terms of the GNU General Public License as published by the Free Software
// Foundation, either version 3 of the License, or (at your option) any later version.
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
// You should have received a copy of the GNU General Public License
// along with this program. If not, see <https://www.gnu.org/licenses/>.
// --

"use strict";

var Core = Core || {};
Core.Agent = Core.Agent || {};
Core.Agent.Admin = Core.Agent.Admin || {};

/**
 * @namespace Core.Agent.Admin.MailAccount
 * @memberof Core.Agent.Admin
 * @author
 * @description
 *      This namespace contains the special module functions for MailAccount module.
 */
 Core.Agent.Admin.MailAccount = (function (TargetNS) {

    /**
     * @name MailAccountDelete
     * @memberof Core.Agent.Admin.MailAccount
     * @function
     * @description
     *      Bind event on mail account delete button.
     */
    TargetNS.MailAccountDelete = function() {
        $('.MailAccountDelete').on('click', function () {
            var MailAccountDelete = $(this);

            Core.UI.Dialog.ShowContentDialog(
                $('#DeleteMailAccountDialogContainer'),
                Core.Language.Translate('Delete this Mail Account'),
                '240px',
                'Center',
                true,
                [
                    {
                        Class: 'Primary',
                        Label: Core.Language.Translate("Confirm"),
                        Function: function() {
                            $('.Dialog .InnerContent .Center').text(Core.Language.Translate("Deleting the mail account and its data. This may take a while..."));
                            $('.Dialog .Content .ContentFooter').remove();

                            Core.AJAX.FunctionCall(
                                Core.Config.Get('Baselink'),
                                MailAccountDelete.data('query-string'),
                                function() {
                                   Core.App.InternalRedirect({
                                       Action: 'AdminMailAccount'
                                   });
                                }
                            );
                        }
                    },
                    {
                        Label: Core.Language.Translate("Cancel"),
                        Function: function () {
                            Core.UI.Dialog.CloseDialog($('#DeleteMailAccountDialog'));
                        }
                    }
                ]
            );
            return false;
        });
    };

    /*
    * @name Init
    * @memberof Core.Agent.Admin.MailAccount
    * @function
    * @description
    *      This function registers onchange events for showing IMAP Folder and Queue field
    */
    TargetNS.Init = function () {

        // Show IMAP Folder selection only for IMAP backends
        $('select#TypeAdd, select#Type').on('change', function(){
            if (/IMAP/.test($(this).val())) {
                $('.Row_IMAPFolder').show();
            }
            else {
                $('.Row_IMAPFolder').hide();
            }
// Rother OSS / eyazi@efflux / MailAccount-OAuth2
            if (/OAuth2/.test($(this).val())) {
                $('.Row_Profile').show();
                Core.UI.InputFields.Activate();
                $('#Profile').addClass('Validate_Required');
                $('.Row_Password, .Row_Host').hide();
                $('#PasswordAdd, #PasswordUpdate, #HostAdd, #HostUpdate').removeClass('Validate_Required');
            }
            else {
                $('.Row_Profile').hide();
                $('#Profile').removeClass('Validate_Required');
                $('.Row_Password, .Row_Host').show();
                $('#PasswordAdd, #PasswordUpdate, #HostAdd, #HostUpdate').addClass('Validate_Required');
            }
// EO MailAccount-OAuth2
        }).trigger('change');

// Rother OSS / eyazi@efflux / MailAccount-OAuth2
        let QueryString = window.location.search;
        if (/&state=|&code=|&error=|&error_description=/.test(QueryString)) {
            const ChallengeToken = Core.Config.Get('ChallengeToken');
            QueryString = QueryString.replace(/&/g, ';');  // Turn query strings into params.
            QueryString += ';ChallengeToken=' + ChallengeToken + ';Subaction=ProcessActionOAuth2';
            window.location.search = QueryString;
        }

        // Prevent resending on reload by remove all params. Fixme: Don't even show response in URL (no security issue).
        if (/;state=|;code=|;error|;error_description/.test(QueryString)) {
            const Seperator = 'AdminMailAccount';
            const ClearURL = window.location.href.split(Seperator)[0] + Seperator;
            window.history.pushState("", "", ClearURL);
        }
// EO MailAccount-OAuth2

        // Show Queue field only if Dispatch By Queue is selected
        $('select#DispatchingBy').on('change', function(){
            if (/Queue/.test($(this).val())) {
                $('.Row_Queue').show();
                Core.UI.InputFields.Activate();
            }
            else {
                $('.Row_Queue').hide();
            }
        }).trigger('change');

        Core.UI.Table.InitTableFilter($("#FilterMailAccounts"), $("#MailAccounts"));

        TargetNS.MailAccountDelete();
    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(Core.Agent.Admin.MailAccount || {}));
