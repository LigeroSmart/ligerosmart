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
 *      This namespace contains the special module behaviours for ITSM SLA.
 */
 ITSM.Agent.SLA = (function (TargetNS) {

    /**
     * @name Init
     * @memberof Agent.SLA
     * @function
     * @description
     *      This function initializes actions for ITSM SLA.
     */
    TargetNS.Init = function() {

        $('.MasterAction').bind('click', function (Event) {
            var $MasterActionLink = $(this).find('.MasterActionLink');
            // only act if the link was not clicked directly
            if (Event.target !== $MasterActionLink.get(0)) {
                window.location = $MasterActionLink.attr('href');
                return false;
            }
        });
    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(ITSM.Agent.SLA || {}));
