// --
// Copyright (C) 2001-2017 OTRS AG, http://otrs.com/\n";
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (AGPL). If you
// did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
// --

"use strict";

var ITSM = ITSM || {};
ITSM.Agent = ITSM.Agent || {};
ITSM.Agent.ChangeManagement = ITSM.Agent.ChangeManagement || {};


/**
 * @namespace ITSM.Agent.ChangeManagement.Add
 * @memberof ITSM.Agent.ChangeManagement
 * @author OTRS AG
 * @description
 *      This namespace contains the special module functions for the change-management add screen.
 */
ITSM.Agent.ChangeManagement.Add = (function (TargetNS) {

    /**
     * @name Init
     * @namespace ITSM.Agent.ChangeManagement.Add
     * @function
     * @description
     *      This function initializes some behaviours for the add screen.
     */
    TargetNS.Init = function () {
        $('#CategoryID').on('change.ITSMChangeManagementAdd.CategoryID', function () {
            Core.AJAX.FormUpdate($('#ChangeAddForm'), 'AJAXUpdate', 'CategoryID', ['ImpactID', 'PriorityID']);
        });
        $('#ImpactID').on('change.ITSMChangeManagementAdd.ImpactID', function () {
            Core.AJAX.FormUpdate($('#ChangeAddForm'), 'AJAXUpdate', 'ImpactID', ['PriorityID']);
        });
    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;

}(ITSM.Agent.ChangeManagement.Add || {}));
