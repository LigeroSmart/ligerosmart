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
     *      This function checks the value of a hidden input field containing the state of the article:
     *      untouched (= not yet loaded), true or false. If the article is already loaded (-> true), and
     *      user calls this function by clicking on the message head, the article gets hidden by removing
     *      the class 'Visible' and the status changes to false. If the message head is clicked while the
     *      status is false (e.g. the article is hidden), the article gets the class 'Visible' again and
     *      the status gets changed to true.
     */

    function ToggleMessage($Message){
        var $Status = $('> input[name=FieldState]', $Message);
        switch ($Status.val()){
            case "true":
                $Message.removeClass('Visible');
                $Status.val("false");
            break;
            case "false":
                $Message.addClass('Visible');
                $Status.val("true");
            break;
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
