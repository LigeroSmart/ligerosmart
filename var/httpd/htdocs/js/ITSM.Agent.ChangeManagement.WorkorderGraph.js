// --
// ITSM.Agent.ChangeManagement.WorkorderGraph.js - provides the special module functions for the
// workorder graph
// Copyright (C) 2001-2010 OTRS AG, http://otrs.org/\n";
// --
// $Id: ITSM.Agent.ChangeManagement.WorkorderGraph.js,v 1.1 2010-12-08 09:36:39 mn Exp $
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (AGPL). If you
// did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
// --

"use strict";

var ITSM = ITSM || {};
ITSM.Agent = ITSM.Agent || {};
ITSM.Agent.ChangeManagement = ITSM.Agent.ChangeManagement || {};
ITSM.Agent.ChangeManagement.WorkorderGraph = ITSM.Agent.ChangeManagement.WorkorderGraph || {};

/**
 * @namespace
 * @exports TargetNS as ITSM.Agent.ChangeManagement.WorkorderGraph
 * @description
 *      This namespace contains the special module functions for the workorder graph.
 */
ITSM.Agent.ChangeManagement.WorkorderGraph = (function (TargetNS) {

    /**
     * @function
     * @return nothing
     *      This function initializes the workorder graph
     */
    TargetNS.Init = function () {
        $('div.Workorder a')
        .unbind('mouseenter').bind('mouseenter', function (Event) {
            var $Details = $(this).next('.WorkorderDetails'),
                MousePositionLeft = parseInt(Event.pageX, 10),
                MousePositionTop = parseInt(Event.pageY, 10),
                BoxPosition = $(this).closest('div.WorkorderGraph').offset();

            $Details
                .css('left', MousePositionLeft - parseInt(BoxPosition.left, 10) + 15)
                .css('top', MousePositionTop - parseInt(BoxPosition.top, 10) + 15)
                .show();
        })
        .unbind('mouseleave').bind('mouseleave', function (Event) {
            $(this).next('.WorkorderDetails').hide();
        })
        .unbind('mousemove').bind('mousemove', function (Event) {
            var $Details = $(this).next('.WorkorderDetails'),
                MousePositionLeft = parseInt(Event.pageX, 10),
                MousePositionTop = parseInt(Event.pageY, 10),
                BoxPosition = $(this).closest('div.WorkorderGraph').offset();

            $Details
                .css('left', MousePositionLeft - parseInt(BoxPosition.left, 10) + 15)
                .css('top', MousePositionTop - parseInt(BoxPosition.top, 10) + 15);
        });
    };

    return TargetNS;
}(ITSM.Agent.ChangeManagement.WorkorderGraph || {}));
