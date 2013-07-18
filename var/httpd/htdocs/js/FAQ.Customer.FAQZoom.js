// --
// FAQ.Customer.FAQZoom.js - provides the special module functions for FAQZoom
// Copyright (C) 2001-2012 OTRS AG, http://otrs.org/
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (AGPL). If you
// did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
// --

"use strict";

var FAQ = FAQ || {};
FAQ.Customer = FAQ.Customer || {};

/**
 * @namespace
 * @exports TargetNS as FAQ.Customer.TicketZoom
 * @description
 *      This namespace contains the special module functions for TicketZoom.
 */
FAQ.Customer.FAQZoom = (function (TargetNS) {

    /**
     * @function
     * @param {jQueryObject} $Iframe The iframe which should be auto-heighted
     * @return nothing
     *      This function initializes the special module functions
     */
    TargetNS.IframeAutoHeight = function ($Iframe) {
        if (isJQueryObject($Iframe)) {
            var NewHeight = $Iframe.contents().height();
            if (!NewHeight || isNaN(NewHeight)) {
                NewHeight = Core.Config.Get('FAQ::Frontend::CustomerHTMLFieldHeightDefault');
            }
            else {
                if (NewHeight > Core.Config.Get('FAQ::Frontend::CustomerHTMLFieldHeightMax')) {
                    NewHeight = Core.Config.Get('FAQ::Frontend::CustomerHTMLFieldHeightMax');
                }
            }
            $Iframe.height(NewHeight + 'px');
        }
    };



    return TargetNS;
}(FAQ.Customer.FAQZoom || {}));
