// --
// Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (GPL). If you
// did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
// --

"use strict";

var FAQ = FAQ || {};
FAQ.Agent = FAQ.Agent || {};

/**
 * @namespace
 * @exports TargetNS as FAQ.Agent.TicketZoom
 * @description
 *      This namespace contains the special module functions for TicketZoom.
 */
FAQ.Agent.FAQZoom = (function (TargetNS) {

    /**
     * @name IframeAutoHeight
     * @memberof FAQ.Agent.FAQZoom
     * @function
     * @param {jQueryObject} $Iframe - The iframe which should be auto-heighted
     * @description
     *      Set iframe height automatically based on real content height and default config setting.
     */
    TargetNS.IframeAutoHeight = function ($Iframe) {
        var NewHeight;

        if (isJQueryObject($Iframe)) {
            // slightly change the width of the iframe to not be exactly 100% width anymore
            // this prevents a double horizontal scrollbar (from iframe and surrounding div)
            $Iframe.width($Iframe.width() - 2);

            NewHeight = $Iframe.contents().find('body').height();

            // if the iFrames height is 0, we collapse the widget
            if (NewHeight === 0) {
                $Iframe.closest('.WidgetSimple').removeClass('Expanded').addClass('Collapsed');
            } else if (!NewHeight || isNaN(NewHeight)) {
                NewHeight = Core.Config.Get('FAQ::Frontend::AgentHTMLFieldHeightDefault');
            }
            else {
                if (NewHeight > Core.Config.Get('FAQ::Frontend::AgentHTMLFieldHeightMax')) {
                    NewHeight = Core.Config.Get('FAQ::Frontend::AgentHTMLFieldHeightMax');
                }
            }

            // add delta for scrollbar
            if (NewHeight > 0) {
                NewHeight = parseInt(NewHeight, 10) + 25;
            }
            $Iframe.height(NewHeight + 'px');
        }
    };

    /**
     * @name Init
     * @memberof FAQ.Agent.FAQZoom
     * @function
     * @description
     *      This function initialize the FAQZoom module.
     */
    TargetNS.Init = function() {

        // init browser link message close button
        if ($('.FAQMessageBrowser').length) {
            $('.FAQMessageBrowser a.Close').on('click', function () {
                $('.FAQMessageBrowser').fadeOut("slow");
                Core.Agent.PreferencesUpdate('UserAgentDoNotShowBrowserLinkMessage', 1);
                return false;
            });
        }

            $('ul.Actions a.AsPopup').on('click', function () {
            Core.UI.Popup.OpenPopup ($(this).attr('href'), 'Action');
            return false;
        });

        $('.RateButton').on('click', function () {
            var RateNumber = parseInt($(this).closest('li').attr('id').replace(/RateButton/, ''), 10);
            $('#RateValue').val(RateNumber);
            $('#RateSubmitButton').fadeIn(250);
            $('#FAQVoting').find('.RateButton').each(function() {
                var ItemRateNumber = parseInt($(this).closest('li').attr('id').replace(/RateButton/, ''), 10);
                if (ItemRateNumber <= RateNumber) {
                    $(this).addClass('RateChecked');
                    $(this).removeClass('RateUnChecked');
                }
                else {
                    $(this).addClass('RateUnChecked');
                    $(this).removeClass('RateChecked');
                }
            });
        });

        // Create events for AgentFAQZoomSmall screen.
        if (parseInt(Core.Config.Get('AgentFAQZoomSmall'), 10) === 1) {

            $('#Cancel').on('click', function () {
                parent.Core.UI.Dialog.CloseDialog($('.Dialog', parent.document));
            });

            $('#InsertText').on('click', function () {
                var InsertText = 1,
                    InsertLink = 0;

                FAQ.Agent.TicketCompose.SetText(InsertText, InsertLink);
            });

            $('#InsertLink').on('click', function () {
                var InsertText = 0,
                    InsertLink = 1;

                FAQ.Agent.TicketCompose.SetText(InsertText, InsertLink);
            });

            $('#InsertTextAndLink').on('click', function () {
                var InsertText = 1,
                    InsertLink = 1;

                FAQ.Agent.TicketCompose.SetText(InsertText, InsertLink);
            });

            $('#InsertFull').on('click', function () {
                var InsertText = 1,
                    InsertLink = 0;

                FAQ.Agent.TicketCompose.SetFullFAQ(InsertText, InsertLink);
            });

            $('#InsertFullAndLink').on('click', function () {
                var InsertText = 1,
                    InsertLink = 1;

                FAQ.Agent.TicketCompose.SetFullFAQ(InsertText, InsertLink);
            });
        }

        // Initialize allocation list for link object table.
        Core.Agent.TableFilters.SetAllocationList();
    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(FAQ.Agent.FAQZoom || {}));
