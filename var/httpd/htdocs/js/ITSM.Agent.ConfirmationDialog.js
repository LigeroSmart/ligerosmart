// --
// ITSM.Agent.ConfirmationDialog.js - provides the special module functions for the
// confirmation dialogs
// Copyright (C) 2001-2010 OTRS AG, http://otrs.org/\n";
// --
// $Id: ITSM.Agent.ConfirmationDialog.js,v 1.1 2010-10-18 14:55:32 en Exp $
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
 * @exports TargetNS as ITSM.Agent.ConfirmationDialog
 * @description
 *      This namespace contains the special module functions for ConfirmationDialog.
 */
ITSM.Agent.ConfirmationDialog = (function (TargetNS) {

    /**
     * @variable
     * @private
     *     This variable stores the parameters that are passed from the DTL and contain all the data that the dialog needs.
     */
    var DialogData;

    /**
     * @function
     * @private
     * @return nothing
     * @description Shows waiting dialog until search screen is ready.
     */
    function ShowWaitingDialog(PositionTop){
        Core.UI.Dialog.ShowContentDialog('<div class="Spacing Center"><span class="AJAXLoader" title="' + Core.Config.Get('LoadingMsg') + '"></span></div>', '', PositionTop, 'Center', true);
    }

    /**
     * @function
     * @param {EventObject} event object of the clicked element.
     * @return nothing
     *      This function shows a confirmation dialog with 2 buttons: Yes and No
     */
    TargetNS.ShowConfirmationDialog = function (Event) {

        // define the position of the dialog
        var PositionTop = $(window).scrollTop() + ($(window).height() * 0.3);

        // show waiting dialog
        ShowWaitingDialog(PositionTop);

        // ajax call to the module that deletes the template
        var Data = DialogData.DialogContentQueryString;
        Core.AJAX.FunctionCall(Core.Config.Get('Baselink'), Data, function (HTML) {

            // define yes and no buttons
            var Buttons = [
                {
                    Label: DialogData.TranslatedText.Yes,
                    Class: "Primary",

                    // define the function that is called when the 'Yes' button is pressed
                    Function: function () {

                        // disable Yes and No buttons to prevent multiple submits
                        $('div.Dialog:visible div.ContentFooter button').attr('disabled', 'disabled');

                        // redirect to the module that does the confirmed action after pressing the Yes button
                        location.href = DialogData.ConfirmedActionQueryString;
                    }
                },
                {
                    Label: DialogData.TranslatedText.No,
                    Type: "Close"
                }
            ];

            // show the confirmation dialog to confirm the action
            Core.UI.Dialog.ShowContentDialog(HTML, DialogData.DialogTitle, PositionTop, "Center", true, Buttons);
        }, 'html');
        return false;
    };

    /**
     * @function
     * @param {EventObject} event object of the clicked element.
     * @return nothing
     *      This function shows a confirmation dialog with 2 buttons: Yes and No
     */
    TargetNS.BindConfirmationDialog = function (Data) {
        DialogData = Data;
        // binding a click event to the defined element
        $(DialogData.ElementSelector).bind('click', ITSM.Agent.ConfirmationDialog.ShowConfirmationDialog);
    };

    return TargetNS;
}(ITSM.Agent.ConfirmationDialog || {}));
