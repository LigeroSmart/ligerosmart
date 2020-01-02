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
 * @namespace ITSM.Agent.ChangeManagement.Template
 * @memberof ITSM.Agent.ChangeManagement
 * @author OTRS AG
 * @description
 *      This namespace contains the special module functions for the change template overview.
 */
ITSM.Agent.ChangeManagement.TemplateOverview = (function (TargetNS) {

    /**
     * @name Init
     * @namespace ITSM.Agent.ChangeManagement.TemplateOverview
     * @function
     * @description
     *      This function initializes some behaviours for the template overview screen.
     */
    TargetNS.Init = function () {
        var ITSMChangeTemplateOverviewConfirmDialog = Core.Config.Get(
            'ITSMChangeTemplateOverviewConfirmDialog'
        );

        // bind 'Delete' and 'EditContent' buttons
        $.each(ITSMChangeTemplateOverviewConfirmDialog, function(Key, Data) {
            Data = $.extend(true, {}, Data, {
                DialogTitle: Core.Language.Translate(Data.DialogTitle),
                TranslatedText: {
                    Yes: Core.Language.Translate("Yes"),
                    No:  Core.Language.Translate("No")
                }
            });

            ITSM.Agent.ConfirmDialog.BindConfirmDialog(Data);
        });

        // bind links to open the template edit popup
        $('tbody tr td a.AsPopup').on('click.ITSMChangeMangement.TemplateEdit', function () {
            Core.UI.Popup.OpenPopup($(this).attr('href'), 'Action');
            return false;
        });
    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;

}(ITSM.Agent.ChangeManagement.Overview || {}));
