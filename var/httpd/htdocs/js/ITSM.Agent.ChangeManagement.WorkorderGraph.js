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
ITSM.Agent.ChangeManagement = ITSM.Agent.ChangeManagement || {};

/**
 * @namespace ITSM.Agent.ChangeManagement.WorkorderGraph
 * @memberof ITSM.Agent.ChangeManagement
 * @author OTRS AG
 * @description
 *      This namespace contains the special module functions for the workorder graph.
 */
ITSM.Agent.ChangeManagement.WorkorderGraph = (function (TargetNS) {

    /**
     * @name Init
     * @namespace ITSM.Agent.ChangeManagement.WorkorderGraph
     * @function
     * @description
     *      This function initializes the workorder graph
     */
    TargetNS.Init = function () {
        function GetDetailPosition(Element, Event) {
            var $Details = $(Element).next('.WorkorderDetails'),
                MousePositionLeft = parseInt(Event.pageX, 10),
                MousePositionTop = parseInt(Event.pageY, 10),
                BoxPosition = $(Element).closest('div.WorkorderGraph').offset(),
                BoxWidth = $(Element).closest('div.WorkorderGraph').width(),
                DetailWidth = $Details.width(),
                DetailPositionLeft = MousePositionLeft - parseInt(BoxPosition.left, 10) + 15,
                DetailPositionTop = MousePositionTop - parseInt(BoxPosition.top, 10) + 15;

            // if there is not enough space to the right to show the detail box,
            // show it on the left side of the mouse cursor
            if (DetailPositionLeft + DetailWidth + 15 > BoxWidth) {
                DetailPositionLeft = DetailPositionLeft - 400 - 30; // 30 because we added 15 to the right and now want 15 to the left
            }

            return {
                Left: DetailPositionLeft,
                Top: DetailPositionTop
            };
        }

        $('div.Workorder a')
        .off('mouseenter.ITSMChangeManagement.WOGraph').on('mouseenter.ITSMChangeManagement.WOGraph', function (Event) {
            var DetailPosition = GetDetailPosition(this, Event);
            $(this).next('.WorkorderDetails')
                .css('left', DetailPosition.Left)
                .css('top', DetailPosition.Top)
                .show();
        })
        .off('mouseleave.ITSMChangeManagement.WOGraph').on('mouseleave.ITSMChangeManagement.WOGraph', function () {
            $(this).next('.WorkorderDetails').hide();
        })
        .off('mousemove.ITSMChangeManagement.WOGraph').on('mousemove.ITSMChangeManagement.WOGraph', function (Event) {
            var DetailPosition = GetDetailPosition(this, Event);
            $(this).next('.WorkorderDetails')
                .css('left', DetailPosition.Left)
                .css('top', DetailPosition.Top);
        });
    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(ITSM.Agent.ChangeManagement.WorkorderGraph || {}));
