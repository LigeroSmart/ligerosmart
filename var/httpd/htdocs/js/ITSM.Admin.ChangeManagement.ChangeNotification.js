// --
// Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (GPL). If you
// did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
// --

"use strict";

var ITSM = ITSM || {};
ITSM.Admin = ITSM.Admin || {};
ITSM.Admin.ChangeManagement = ITSM.Admin.ChangeManagement || {};


/**
 * @namespace ITSM.Admin.ChangeManagement.ChangeNotification
 * @memberof ITSM.Admin.ChangeManagement
 * @author OTRS AG
 * @description
 *      This namespace contains the special module functions for the Change Notification
 */
ITSM.Admin.ChangeManagement.ChangeNotification = (function (TargetNS) {

    /**
     * @name Init
     * @memberof ITSM.Admin.ChangeManagement.ChangeNotification
     * @function
     * @description
            This function initializes the special module functions.
     */
    TargetNS.Init = function () {

        if (Core.Config.Get('OverviewResult')) {
            $('.NotificationDelete').on('click', function (Event) {

                if (window.confirm(Core.Language.Translate('Do you really want to delete this notification?'))) {
                    window.location = $(this).attr('href');
                }

                // don't interfere with MasterAction
                Event.stopPropagation();
                Event.preventDefault();
                return false;
            });
        }

        if (Core.Config.Get('OverviewUpdate')) {
            if (ITSM.Agent && ITSM.Agent.ChangeManagement && ITSM.Agent.ChangeManagement.NotificationEvent) {
                ITSM.Agent.ChangeManagement.NotificationEvent.Init({
                    Localization: {
                        DeleteNotificationLanguageMsg: Core.Language.Translate('Do you really want to delete this notification language?')
                    }
                });
            }
        }
    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(ITSM.Admin.ChangeManagement.ChangeNotification || {}));
