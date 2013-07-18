// --
// FAQ.Agent.ConfirmationDialog.js - provides the special module functions for the
// confirmation dialogs
// Copyright (C) 2001-2010 OTRS AG, http://otrs.org/\n";
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (AGPL). If you
// did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
// --

"use strict";

var FAQ = FAQ || {};
FAQ.Agent = FAQ.Agent || {};

/**
 * @namespace
 * @exports TargetNS as FAQ.Agent.ConfirmationDialog
 * @description
 *      This namespace contains the special module functions for ConfirmationDialog.
 */
FAQ.Agent.ConfirmationDialog = (function (TargetNS) {

    /**
     * @variable
     * @private
     *     This variable stores the parameters that are passed from the DTL and contain all the data that the dialog needs.
     */
    var DialogData = [];

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

        var LocalDialogData,
            PositionTop,
            Data,
            Buttons;

        // get global saved DialogData for this function
        LocalDialogData = DialogData[$(Event.target).attr('id')];

        // define the position of the dialog
        PositionTop = $(window).scrollTop() + ($(window).height() * 0.3);

        // show waiting dialog
        ShowWaitingDialog(PositionTop);

        // ajax call to the module that deletes the template
        Data = LocalDialogData.DialogContentQueryString;
        Core.AJAX.FunctionCall(Core.Config.Get('Baselink'), Data, function (Response) {

            // 'Confirmation' opens a dialog with 2 buttons: Yes and No
            if (Response.DialogType === 'Confirmation') {

                // define yes and no buttons
                Buttons = [{
                    Label: LocalDialogData.TranslatedText.Yes,
                    Class: "Primary",

                    // define the function that is called when the 'Yes' button is pressed
                    Function: function(){

                        // disable Yes and No buttons to prevent multiple submits
                        $('div.Dialog:visible div.ContentFooter button').attr('disabled', 'disabled');

                        // redirect to the module that does the confirmed action after pressing the Yes button
                        location.href = Core.Config.Get('Baselink') + LocalDialogData.ConfirmedActionQueryString;
                    }
                }, {
                    Label: LocalDialogData.TranslatedText.No,
                    Type: "Close"
                }];
            }

            // 'Message' opens a dialog with 1 button: Ok
            else if (Response.DialogType === 'Message') {

                // define Ok button
                Buttons = [{
                    Label: LocalDialogData.TranslatedText.Ok,
                    Class: "Primary",
                    Type: "Close"
                }];
            }

            // show the confirmation dialog to confirm the action
            Core.UI.Dialog.ShowContentDialog(Response.HTML, LocalDialogData.DialogTitle, PositionTop, "Center", true, Buttons);
        }, 'json');
        return false;
    };

    /**
     * @function
     * @param {EventObject} event object of the clicked element.
     * @return nothing
     *      This function shows a confirmation dialog with 2 buttons: Yes and No
     */
    TargetNS.BindConfirmationDialog = function (Data) {
        DialogData[Data.ElementID] = Data;

        // binding a click event to the defined element
        $(DialogData[Data.ElementID].ElementSelector).bind('click', FAQ.Agent.ConfirmationDialog.ShowConfirmationDialog);
    };

    return TargetNS;
}(FAQ.Agent.ConfirmationDialog || {}));
