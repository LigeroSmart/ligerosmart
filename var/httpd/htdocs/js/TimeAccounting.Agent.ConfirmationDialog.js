// --
// Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (GPL). If you
// did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
// --

"use strict";

var TimeAccounting = TimeAccounting || {};
TimeAccounting.Agent = TimeAccounting.Agent || {};


/**
 * @namespace TimeAccounting.Agent.ConfirmationDialog
 * @memberof TimeAccounting.Agent
 * @author OTRS AG
 * @description
 *      This namespace contains the special module functions for ConfirmationDialog.
 */
TimeAccounting.Agent.ConfirmationDialog = (function (TargetNS) {

    /**
     * @private
     * @name DialogData
     * @memberof TimeAccounting.Agent.ConfirmationDialog
     * @member {Array}
     * @description
     *      This variable stores the parameters that are passed from the DTL and contain all the data that the dialog needs.
     */
    var DialogData = [];

    /**
     * @private
     * @name ShowWaitingDialog
     * @memberof TimeAccounting.Agent.ConfirmationDialog
     * @function
     * @param {String} PositionTop - vertical position of the dialog.
     * @description Shows waiting dialog until search screen is ready.
     */
    function ShowWaitingDialog(PositionTop){
        Core.UI.Dialog.ShowContentDialog('<div class="Spacing Center"><span class="AJAXLoader" title="' + Core.Config.Get('LoadingMsg') + '"></span></div>', '', PositionTop, 'Center', true);
    }

    /**
     * @name ShowConfirmationDialog
     * @memberof TimeAccounting.Agent.ConfirmationDialog
     * @function
     * @returns {Boolean} false.
     * @param {EventObject} Event - event object of the clicked element.
     * @description
     *      This function shows a confirmation dialog with 2 buttons: Yes and No or a message dialog with one button: Ok.
     */
    TargetNS.ShowConfirmationDialog = function (Event) {

        var LocalDialogData,
            PositionTop,
            Data,
            Buttons;

        // get global saved DialogData for this function
        LocalDialogData = DialogData[$(Event.target).attr('id')];

        // define the position of the dialog
        PositionTop = $(window).height() * 0.3;

        // show waiting dialog
        ShowWaitingDialog(PositionTop);

        // ajax call to the module that executes the action when pressing the confirmation button
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
     * @name BindConfirmationDialog
     * @memberof TimeAccounting.Agent.ConfirmationDialog
     * @function
     * @param {Object} Data - DialogData.
     * @description  Binds conformation dialog to an element
     */
    TargetNS.BindConfirmationDialog = function (Data) {
        DialogData[Data.ElementID] = Data;

        // binding a click event to the defined element
        $(DialogData[Data.ElementID].ElementSelector)
            .off('click.TimeAccounting.BindConfirmationDialog')
            .on('click.TimeAccounting.BindConfirmationDialog', TimeAccounting.Agent.ConfirmationDialog.ShowConfirmationDialog);
    };

    return TargetNS;
}(TimeAccounting.Agent.ConfirmationDialog || {}));
