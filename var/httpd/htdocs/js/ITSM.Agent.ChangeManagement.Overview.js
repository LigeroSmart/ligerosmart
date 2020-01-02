// --
// Copyright (C) 2001-2020 OTRS AG, https://otrs.com/\n";
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (GPL). If you
// did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
// --

"use strict";

var ITSM = ITSM || {};
ITSM.Agent = ITSM.Agent || {};
ITSM.Agent.ChangeManagement = ITSM.Agent.ChangeManagement || {};


/**
 * @namespace ITSM.Agent.ChangeManagement.Overview
 * @memberof ITSM.Agent.ChangeManagement
 * @author OTRS AG
 * @description
 *      This namespace contains the special module functions for the config item overview navbar.
 */
ITSM.Agent.ChangeManagement.Overview = (function (TargetNS) {

    /**
     * @name Init
     * @namespace ITSM.Agent.ChangeManagement.Overview
     * @function
     * @description
     *      This function initializes some behaviours for the serch and overview screens.
     */
    TargetNS.Init = function () {
        var ITSMChangeMgmtChangeSearch = Core.Config.Get('ITSMChangeMgmtChangeSearch');

        // Bind button to open the context settings dialog.
        $('#ShowContextSettingsDialog').on('click.ContextSettings', function (Event) {
            Core.UI.Dialog.ShowContentDialog($('#ContextSettingsDialogContainer'), Core.Language.Translate("Settings"), '20%', 'Center', true,
                [
                    {
                        Label: Core.Language.Translate("Submit"),
                        Type: 'Submit',
                        Class: 'Primary'
                    }
                ]
            );
            Event.preventDefault();
            Event.stopPropagation();
            return false;
        });

        // On row click go the change zoom.
        $('.MasterAction').on('click', function (Event) {
            var $MasterActionLink = $(this).find('.MasterActionLink');
            // only act if the link was not clicked directly
            if (Event.target !== $MasterActionLink.get(0)) {
                window.location = $MasterActionLink.attr('href');
                return false;
            }
        });

        // In search results bind the button 'Change search options' to open the search dialog.
        if (ITSMChangeMgmtChangeSearch) {
            $('#ChangeSearch').on('click.ChangeSearch', function () {
                ITSM.Agent.ChangeManagement.Search.OpenSearchDialog(
                    'AgentITSMChangeSearch',
                    Core.App.EscapeSelector(ITSMChangeMgmtChangeSearch.Profile)
                );
                return false;
            });
        }
    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;

}(ITSM.Agent.ChangeManagement.Overview || {}));
