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

            var NewHeight = $Iframe
                .contents()
                .find('body')
                .css({
                    'margin': '0px', // we remove margins and paddings from the body in order to get the real height
                    'padding': '0px'
                })
                .height();

            // IE8 needs some more space due to incorrect height calculation
            if (NewHeight > 0 && $.browser.msie && $.browser.version === '8.0') {
                NewHeight = NewHeight + 4;
            }

            // if the iFrames height is 0, we collapse the widget
            if (NewHeight === 0) {
                $Iframe.closest('li.Customer').removeClass('Visible');
            }

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

    /**
     * @function
     * @description
     *      This function checks the class of a FAQ field:
     *      user calls this function by clicking on the field head, field gets hidden by removing
     *      the class 'Visible'. If the field head is clicked while it does not contain the class
     *      'Visible', the field gets the class 'Visible' again and it will be shown.
     */
    function ToggleMessage($Message){
        if ($Message.hasClass('Visible')) {
            $Message.removeClass('Visible');
        }
        else {
            $Message.addClass('Visible');
        }
    }

    /**
     * @function
     * @description
     *      This function binds functions to the 'MessageHeader'
     *      to toggle the visibility of the MessageBody and the reply form.
     */
    TargetNS.Init = function(){
        var $Messages = $('#Messages > li'),
            $VisibleMessage = $Messages.last(),
            $MessageHeaders = $('.MessageHeader', $Messages);

        $MessageHeaders.click(function(Event){
            ToggleMessage($(this).parent());
            Event.preventDefault();
        });
    };

    return TargetNS;
}(FAQ.Customer.FAQZoom || {}));
