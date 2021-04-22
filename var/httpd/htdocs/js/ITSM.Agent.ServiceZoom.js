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
 * @namespace Agent
 * @author OTRS AG
 * @description
 *      This namespace contains the special module behaviours for ITSM Service Zoom.
 */
 ITSM.Agent.ServiceZoom = (function (TargetNS) {

    /**
     * @name Init
     * @memberof Agent.Service
     * @function
     * @description
     *      This function initializes actions for ITSM Service Zoom.
     */
    TargetNS.Init = function() {

        $('ul.Actions a.AsPopup').bind('click', function () {
            Core.UI.Popup.OpenPopup($(this).attr('href'), 'Action');
            return false;
        });

        $('ul.Actions a.HistoryBack').bind('click', function () {
            history.back();
            return false;
        });

        // Initialize allocation list for link object table.
        Core.Agent.TableFilters.SetAllocationList();
    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(ITSM.Agent.ServiceZoom || {}));
