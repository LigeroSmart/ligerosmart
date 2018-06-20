// --
// Copyright (C) 2001-2018 OTRS AG, http://otrs.com/
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (AGPL). If you
// did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
// --

"use strict";

var TimeAccounting = TimeAccounting || {};

/**
 * @namespace TimeAccounting.Agent
 * @author OTRS AG
 * @description
 *      This namespace contains the special module functions for TimeAccounting.
 */
TimeAccounting.Agent = (function (TargetNS) {

    TargetNS.Init = function () {

        Core.UI.Table.InitTableFilter($('.FilterBox'), $('.DataTable'));

        TimeAccounting.Agent.EditTimeRecords.MassEntryInit();

        $('#NewUserID').on('change', function() {
            $(this).closest('form').submit();
        });

        $('#AddPeriod').off('click').on('click', function() {
            var $Form = $(this).closest('form');
            $('input[name="AddPeriod"]', $Form).val(1);
        });

        $('#SubmitUserData').off('click').on('click', function() {
            var $Form = $(this).closest('form');
            $('input[name="SubmitUserData"]', $Form).val(1);
        });

        $('#NavigationSelect').bind('click', function(){
            $('#DateSelectionForm').submit();
            return false;
        });

        $('#IncompleteWorkingDaysList').off('change.IncompleteWorkingDays').on('change.IncompleteWorkingDays', function () {
            var Date = $(this).val().split('-');
            if (Date[0] && Date[1] && Date[2]) {
                location.href = Core.Config.Get('Baselink') + "Action=" + Core.Config.Get('Action') + ";Year=" + Date[0] + ";Month=" + Date[1] + ";Day=" + Date[2];
            }
        });

        TimeAccounting.Agent.ConfirmationDialog.BindConfirmationDialog({
            ElementID:                  'DeleteTimeAccountingEntry',
            ElementSelector:            '#DeleteTimeAccountingEntry',
            DialogContentQueryString:   'Action=AgentTimeAccountingEdit;DeleteDialog=1;Year=' + Core.Config.Get('Year') + ';Month=' + Core.Config.Get('Month') + ';Day=' + Core.Config.Get('Day'),
            ConfirmedActionQueryString: 'Action=AgentTimeAccountingEdit;Subaction=Delete;Year=' + Core.Config.Get('Year') + ';Month=' + Core.Config.Get('Month') + ';Day=' + Core.Config.Get('Day'),
            DialogTitle:                Core.Language.Translate("Delete Time Accounting Entry"),
            TranslatedText:             {
                Yes: Core.Language.Translate('Yes'),
                No:  Core.Language.Translate('No')
            }
        });

        // show the confirmation dialog to confirm the action
        if (Core.Config.Get('BlockName')) {
            Core.UI.Dialog.ShowContentDialog(
                Core.Config.Get('BlockName'),
                Core.Language.Translate("Confirm insert"),
                '20%',
                'Center',
                true,
                [
                    {
                        Label: Core.Language.Translate('Yes'),
                        Class: "Primary",
                        Type: "Close",
                    },
                    {
                        Label: Core.Language.Translate('No'),

                        // define the function that is called when the 'No' button is pressed
                        Function: function(){

                            // disable Yes and No buttons to prevent multiple submits
                            $('div.Dialog:visible div.ContentFooter button').attr('disabled', 'disabled');

                            // redirect to the module that deletes the saved entry after pressing the No button
                            location.href = Core.Config.Get('Baselink') + 'Action=AgentTimeAccountingEdit;Subaction=Delete;Year=' +  Core.Config.Get('Year') + ';Month=' +  Core.Config.Get('Month') + ';Day=' +  Core.Config.Get('Day');
                        }
                    }
                ]
            );
        }

        $('.LeaveDays').on('change', function() {
            var FieldValue = $(this).val();

           // replace , with .
           FieldValue = FieldValue.replace(/,/g, ".");

           // check if the entered value only consists of allowed values
           // if not, we do not eval for security reasons
           if (FieldValue.match(/^[0-9.+\- ]+$/)) {
               // Calculation
               try {
                   /*eslint-disable no-eval */
                   FieldValue = eval(FieldValue);
                   /*eslint-enable no-eval */
               }
               catch (CalcError) {
                   FieldValue = 0;
               }

               // set new value
               $(this).val(FieldValue.toFixed(2));
           }
           else {
               $(this).val('');
           }
        });
    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;

}(TimeAccounting.Agent || {}));
