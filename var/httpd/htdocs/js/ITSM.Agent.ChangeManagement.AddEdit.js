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
 * @namespace ITSM.Agent.ChangeManagement.AddEdit
 * @memberof ITSM.Agent.ChangeManagement
 * @author OTRS AG
 * @description
 *      This namespace contains the special module functions for the change-management add/edit screen.
 */
ITSM.Agent.ChangeManagement.AddEdit = (function (TargetNS) {

    /**
     * @name Init
     * @namespace ITSM.Agent.ChangeManagement.AddEdit
     * @function
     * @description
     *      This function initializes some behaviours for the add/edit screen.
     */
    TargetNS.Init = function () {
        $('#CategoryID').on('change.ITSMChangeManagement.CategoryID', function () {
            Core.AJAX.FormUpdate($('#ChangeForm'), 'AJAXUpdate', 'CategoryID', ['ImpactID', 'PriorityID']);
        });
        $('#ImpactID').on('change.ITSMChangeManagement.ImpactID', function () {
            Core.AJAX.FormUpdate($('#ChangeForm'), 'AJAXUpdate', 'ImpactID', ['PriorityID']);
        });
    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;

}(ITSM.Agent.ChangeManagement.AddEdit || {}));
