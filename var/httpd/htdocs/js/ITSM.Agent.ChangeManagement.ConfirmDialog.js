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
 * @namespace ITSM.Agent.ChangeManagement.ConfirmDialog
 * @memberof ITSM.Agent.ChangeManagement
 * @author OTRS AG
 * @description
 *      This namespace contains the special module functions for the change-management add/edit screen.
 */
ITSM.Agent.ChangeManagement.ConfirmDialog = (function (TargetNS) {

    /**
     * @name Init
     * @namespace ITSM.Agent.ChangeManagement.ConfirmDialog
     * @function
     * @description
     *      This function initializes the menu items that should show a confirmation dialog
     *      in Zoom and WorkOrder Zoom.
     */
    TargetNS.Init = function () {
        var ITSMShowConfirmDialog = Core.Config.Get('ITSMShowConfirmDialog') || {};
        $.each(ITSMShowConfirmDialog, function(Key, Data) {
            ITSM.Agent.ConfirmDialog.BindConfirmDialog({
                ElementID:                  Data.MenuID,
                ElementSelector:            Data.ElementSelector,
                DialogContentQueryString:   Data.DialogContentQueryString,
                ConfirmedActionQueryString: Data.ConfirmedActionQueryString,
                DialogTitle:                Data.DialogTitle,
                TranslatedText:             {
                    Yes: Core.Language.Translate("Yes"),
                    No:  Core.Language.Translate("No"),
                    Ok:  Core.Language.Translate("Ok")
                }
            });
        });
    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;

}(ITSM.Agent.ChangeManagement.ConfirmDialog || {}));
