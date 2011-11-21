// --
// Core.Agent.TicketZoom.js - provides the special module functions for TicketZoom
// Copyright (C) 2001-2011 OTRS AG, http://otrs.org/\n";
// --
// $Id: ITSM.Agent.Zoom.js,v 1.2 2011-11-21 11:45:24 ub Exp $
// $OldId: Core.Agent.TicketZoom.js,v 1.17 2010/08/11 15:23:23 martin Exp $
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (AGPL). If you
// did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
// --

"use strict";

var ITSM = ITSM || {};
ITSM.Agent = ITSM.Agent || {};

/**
 * @namespace
 * @exports TargetNS as Core.Agent.TicketZoom
 * @description
 *      This namespace contains the special module functions for TicketZoom.
 */
ITSM.Agent.Zoom = (function (TargetNS) {
    /**
     * @function
     * @param {jQueryObject} $Iframe The iframe which should be auto-heighted
     * @return nothing
     *      This function initializes the special module functions
     */
    TargetNS.IframeAutoHeight = function ($Iframe) {
        if (isJQueryObject($Iframe)) {
            var NewHeight = $Iframe.get(0).contentWindow.document.body.scrollHeight;
            if (!NewHeight || isNaN(NewHeight)) {
                NewHeight = Core.Config.Get('Ticket::Frontend::HTMLArticleHeightDefault');
            }
            else {
                if (NewHeight > Core.Config.Get('Ticket::Frontend::HTMLArticleHeightMax')) {
                    NewHeight = Core.Config.Get('Ticket::Frontend::HTMLArticleHeightMax');
                }
            }
            $Iframe.height(NewHeight + 'px');
        }
    };

    /**
     * @function
     * @return nothing
     *      This function initializes the special module functions
     */
    TargetNS.Init = function (ITSMTableHeight) {
        var $THead = $('#FixedTable thead'),
            $TBody = $('#FixedTable tbody'),
            ZoomExpand = !$('div.ITSMItemView a.OneITSMItem').hasClass('Active'),
            URLHash;
        Core.UI.Resizable.Init($('#ITSMTableBody'), ITSMTableHeight, function (event, ui, Height, Width) {

            // remember new height for next reload
            window.clearTimeout(TargetNS.ResizeTimeOutScraller);
            TargetNS.ResizeTimeOutScraller = window.setTimeout(function () {
                Core.Agent.PreferencesUpdate('UserConfigItemZoomTableHeight', Height);
            }, 1000);
        });
        Core.UI.InitTableHead($THead, $TBody);

        $(window).resize(function () {
            window.clearTimeout(TargetNS.ResizeTimeOut);
            TargetNS.ResizeTimeOut = window.setTimeout(function () {
                Core.UI.AdjustTableHead($THead, $TBody);
            }, 500);
        });
    };

    return TargetNS;
}(ITSM.Agent.Zoom || {}));
