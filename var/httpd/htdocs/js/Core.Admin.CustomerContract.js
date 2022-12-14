// --
// Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (GPL). If you
// did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
// --

"use strict";

var Core = Core || {};
Core.Agent = Core.Agent || {};
Core.Agent.Admin = Core.Agent.Admin || {};

/**
 * @namespace Core.Agent.Admin
 * @memberof Core.Agent
 * @author OTRS AG
 */

/**
 * @namespace Core.Agent.Admin.CustomerContract
 * @memberof Core.Agent.Admin
 * @author OTRS AG
 * @description
 *      This namespace contains the special module functions for the ACL module.
 */
Core.Agent.Admin.CustomerContract = (function (TargetNS) {

    /**
     * @private
     * @name KeysWithoutSubkeys
     * @memberof Core.Agent.Admin.CustomerContract
     * @member {Array}
     * @description
     *      KeysWithoutSubkeys
     */
    var myForm = document.getElementById("formAddFranchiseRule"),
        elementRuleID =  myForm.elements.namedItem('RuleID'),
        ButtonAddPriceRole = $("button.Primary[id='btnNewPriceRule']").first();

    /**
     * @name Init
     * @memberof Core.Agent.Admin.CustomerContract
     * @function
     * @description
     *      This function initialize the module.
     */
    TargetNS.Init = function() {

        //alert("Alder");    

        $('a.AsPopup').on('click', function () {

            alert('Alder');
            var Matches,
                PopupType = 'Process';

            Matches = $(this).attr('class').match(/PopupType_(\w+)/);
            if (Matches) {
                PopupType = Matches[1];
            }

            if (PopupType !== 'ProcessOverview') {
                TargetNS.ShowOverlay();
            }

            Core.UI.Popup.OpenPopup($(this).attr('href'), PopupType);
            return false;
        });

    };

    /**
     * @name ShowOverlay
     * @memberof Core.Agent.Admin.ProcessManagement
     * @function
     * @description
     *      Opens overlay.
     */
    TargetNS.ShowOverlay = function () {
        $('<div id="Overlay" tabindex="-1">').appendTo('body');
        $('body').css({
            'overflow': 'hidden'
        });
        $('#Overlay').height($(document).height()).css('top', 0);

        // If the underlying page is perhaps to small, we extend the page to window height for the dialog
        $('body').css('min-height', $(window).height());
    };

    /**
     * @name HideOverlay
     * @memberof Core.Agent.Admin.ProcessManagement
     * @function
     * @description
     *      Closes overlay and restores normal view.
     */
    TargetNS.HideOverlay = function () {
        $('#Overlay').remove();
        $('body').css({
            'overflow': 'visible',
            'min-height': 0
        });
    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(Core.Agent.Admin.CustomerContract || {}));
