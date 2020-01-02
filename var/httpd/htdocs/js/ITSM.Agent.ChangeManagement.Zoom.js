// --
// Copyright (C) 2001-2020 OTRS AG, https://otrs.com/\n";
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
 * @namespace ITSM.Agent.ChangeManagement.Zoom
 * @memberof ITSM.Agent.ChangeManagement
 * @author OTRS AG
 * @description
 *      This namespace contains the special module functions for the Zoom (change and workorder zoom).
 */
ITSM.Agent.ChangeManagement.Zoom = (function (TargetNS) {

    /**
     * @name Init
     * @namespace ITSM.Agent.ChangeManagement.Zoom
     * @function
     * @description
     *      This function initializes the special module functions
     */
    TargetNS.Init = function () {
        // init browser link message close button
        if ($('.ITSMMessageBrowser').length) {
            $('.ITSMMessageBrowser a.Close').off('ITSMMessageBrowser').on('click.ITSMMessageBrowser', function () {
                $('.ITSMMessageBrowser').fadeOut("slow");
                Core.Agent.PreferencesUpdate('UserAgentDoNotShowBrowserLinkMessage', 1);
                return false;
            });
        }

        // copy data-src attribute to src attribute for all iframes to
        //  correctly display its contents after JS is fully loaded
        $('iframe').each(function(){
            $(this).attr("src", $(this).attr("data-src"));
        });

        $('ul.Actions a.AsPopup')
        .off('click.ITSMChangeManagementZoom.ActionPopup')
        .on('click.ITSMChangeManagementZoom.ActionPopup', function () {
            Core.UI.Popup.OpenPopup($(this).attr('href'), 'Action');
            return false;
        });

        $('ul.Actions a.HistoryBack')
        .off('click.ITSMChangeManagementZoom.HistoryBack')
        .on('click.ITSMChangeManagementZoom.HistoryBack', function () {
            // if we have a referrer we use it, so the previous page will be loaded from the server
            // and if the referer is not the current page (AgentITSMWorkOrderZoom)
            if (document.referrer && !document.referrer.match(/AgentITSMWorkOrderZoom/)) {
                window.location.href = document.referrer;
                return false;
            }

            // if the page was loaded from clicking a link in an email there is no referer
            // and then we want to follow the original link target (which is the change zoom )
            return true;
        });

        // Initialize allocation list for link object table.
        Core.Agent.TableFilters.SetAllocationList();
    };

    /**
     * @name IframeAutoHeight
     * @namespace ITSM.Agent.ChangeManagement.Zoom
     * @function
     * @param {jQueryObject} $Iframe The iframe which should be auto-heighted
     * @description
     *      This function initializes the special module functions
     */
    TargetNS.IframeAutoHeight = function ($Iframe) {
        var NewHeight;

        if (!isJQueryObject($Iframe)) {
            return;
        }

        NewHeight = $Iframe
            .contents()
            .find('html')
            .height();

        // IE8 needs some more space due to incorrect height calculation
        if (NewHeight > 0 && $.browser.msie && $.browser.version === '8.0') {
            NewHeight = NewHeight + 4;
        }

        // if the iFrames height is 0, we collapse the widget
        if (NewHeight === 0) {
            $Iframe.closest('.WidgetSimple').removeClass('Expanded').addClass('Collapsed');
        }

        if (!NewHeight || isNaN(NewHeight)) {
            NewHeight = Core.Config.Get('ITSMChange::Frontend::AgentHTMLFieldHeightDefault');
        }
        else {
            if (NewHeight > Core.Config.Get('ITSMChange::Frontend::AgentHTMLFieldHeightMax')) {
                NewHeight = Core.Config.Get('ITSMChange::Frontend::AgentHTMLFieldHeightMax');
            }
        }
        $Iframe.height(NewHeight + 'px');
    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(ITSM.Agent.ChangeManagement.Zoom || {}));
