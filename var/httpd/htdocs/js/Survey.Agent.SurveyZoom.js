// --
// Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (GPL). If you
// did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
// --

"use strict";

var Survey = Survey || {};
Survey.Agent = Survey.Agent || {};

/**
 * @namespace
 * @exports TargetNS as Survey.Agent.SurveyZoom
 * @description
 *      This namespace contains the special module functions for SurveyZoom.
 */
Survey.Agent.SurveyZoom = (function (TargetNS) {

    TargetNS.Init = function () {
        $('ul.Actions a.AsPopup').on('click', function () {
            Core.UI.Popup.OpenPopup ($(this).attr('href'), 'Action');
            return false;
        });

        $('#NewStatus').on('change', function () {
            $(this).closest('form').submit();
        });
    }

    /**
     * @name IframeAutoHeight
     * @memberof Survey.Agent.SurveyZoom
     * @function
     * @param {jQueryObject} $Iframe - The iframe which should be auto-heighted
     * @description
     *      Set iframe height automatically based on real content height and default config setting.
     */
    TargetNS.IframeAutoHeight = function ($Iframe) {
        var NewHeight;

        if (isJQueryObject($Iframe)) {
            NewHeight = $Iframe.contents().height();
            if (!NewHeight || isNaN(NewHeight)) {
                NewHeight = Core.Config.Get('Survey.HTMLRichTextHeightDefault');
            }
            else {
                if (NewHeight > Core.Config.Get('Survey.HTMLRichTextHeightMax')) {
                    NewHeight = Core.Config.Get('Survey.HTMLRichTextHeightMax');
                }
            }
            $Iframe.height(NewHeight + 'px');
        }
    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(Survey.Agent.SurveyZoom || {}));
