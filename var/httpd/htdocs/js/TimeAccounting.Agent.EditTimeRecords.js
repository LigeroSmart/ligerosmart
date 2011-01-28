// --
// TimeAccounting.Agent.EditTimeRecords.js - provides the special module functions for the
// edit screen
// Copyright (C) 2001-2011 OTRS AG, http://otrs.org/\n";
// --
// $Id: TimeAccounting.Agent.EditTimeRecords.js,v 1.10 2011-01-28 15:56:55 mn Exp $
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (AGPL). If you
// did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
// --

"use strict";

var TimeAccounting = TimeAccounting || {};
TimeAccounting.Agent = TimeAccounting.Agent || {};

/**
 * @namespace
 * @exports TargetNS as TimeAccounting.Agent.EditTimeRecords
 * @description
 *      This namespace contains the special module functions for the edit screen.
 */
TimeAccounting.Agent.EditTimeRecords = (function (TargetNS) {

    TargetNS.ActionList = "";
    TargetNS.ActionListConstraints = "";

    /**
     * @function
     * @param {String} The ID of the working unit we are in
     * @return nothing
     *      Fills options of action selection according to selected project
     */
    TargetNS.FillActionList = function (WorkingUnitID) {
        var ProjectName = $('#ProjectID' + WorkingUnitID + ' option:selected').text(),
            ActionList = TargetNS.ActionList,
            ActionListConstraints = TargetNS.ActionListConstraints,
            $ActionSelection = $("#ActionID" + WorkingUnitID),
            SelectedActionID = $ActionSelection.val(),
            OptionCount = 0;

        // remove previous actions, leave first element (empty element)
        $ActionSelection.find('option').filter(':not(:first)').remove();


        $.each(ActionList, function () {
            var ActionID = this[0],
                ActionName = this[1];

            $.each(ActionListConstraints, function () {
                var ProjectNameRegExp = new RegExp(this[0]);
                var ActionNameRegExp = new RegExp(this[1]);

                // add action to selection
                if (ProjectNameRegExp.test(ProjectName) && ActionNameRegExp.test(ActionName)) {
                    AddSelectionOption($ActionSelection, ActionName, ActionID, SelectedActionID);
                    OptionCount++;
                }
            });
        });

        // all actions will be added if no action was added above (possible misconfiguration)
        if (!OptionCount) {
            // ignore first element because it's the empty element which is already part of the list
            $.each(ActionList, function (Index) {
                var ActionID = this[0],
                    ActionName = this[1];
                if (Index > 0) {
                    AddSelectionOption($ActionSelection, ActionName, ActionID, SelectedActionID);
                }
            });
        }
    }

    // Adds option to a selection
    function AddSelectionOption($SelectionElement, OptionText, OptionValue, SelectedOption) {
        var $Option = $('<option value="' + OptionValue + '">' + OptionText + '</option>');

        if (OptionValue == SelectedOption) {
            $Option.attr('selected', 'selected');
        }

        $SelectionElement.append($Option);
    }

    function InitAutoCompletion(Language) {
        // Initialize ComboBox on Project dropdown
        Core.UI.ComboBox.Init('.ProjectSelection', {
            Class: "Validate_TimeAccounting_Project",
            Lang: {
                ShowAllItems: Language.ShowAllItems
            }
        });
        // Initialize ComboBox on task dropdown
        Core.UI.ComboBox.Init('.ActionSelection', {
            Class: "Validate_DependingRequiredAND",
            Lang: {
                ShowAllItems: Language.ShowAllItems
            }
        });
        // Add special validation class to ActionSelection
        $('.ActionSelection').next('input:text').each(function () {
            var ID = this.id.replace('Combo_ActionID', '');
            $(this).addClass('Validate_Depending_Combo_ProjectID' + ID);
        });
        // Remove validation classes from underlying select
        $('.ProjectSelection').removeClass('Validate_TimeAccounting_Project');
        $('.ActionSelection').removeClass('Validate_DependingRequiredAND');

        // Copy ServerError classes to according comboboxes
        $('.ProjectSelection.ServerError').next('input[id^=Combo_').addClass('ServerError');
        $('.ActionSelection.ServerError').next('input[id^=Combo_').addClass('ServerError');

        Core.Form.Validate.Init();
    }

    function InitAddRow(Language) {
        $('#MoreInputFields').unbind('click.MoreInputFields').bind('click.MoreInputFields', function () {
            var $LastRow = $('#InsertWorkingHours tbody tr.WorkingHours:last'),
                $NewRow = $LastRow.clone(),
                NewRowHTML = $NewRow.html(),
                RecordNumber = parseInt($('#RecordsNumber').val(), 10) + 1;

            // Now take the last row and replace all numbers with the new record number
            NewRowHTML = NewRowHTML.replace(/ProjectID[0-9]+/g, 'ProjectID' + RecordNumber);
            NewRowHTML = NewRowHTML.replace(/ProjectID\[[0-9]+/g, 'ProjectID[' + RecordNumber);
            NewRowHTML = NewRowHTML.replace(/FillActionList\([0-9]+/g, 'FillActionList(' + RecordNumber);
            NewRowHTML = NewRowHTML.replace(/ActionID[0-9]+/g, 'ActionID' + RecordNumber);
            NewRowHTML = NewRowHTML.replace(/ActionID\[[0-9]+/g, 'ActionID[' + RecordNumber);
            NewRowHTML = NewRowHTML.replace(/Remark[0-9]+/g, 'Remark' + RecordNumber);
            NewRowHTML = NewRowHTML.replace(/Remark\[[0-9]+/g, 'Remark[' + RecordNumber);
            NewRowHTML = NewRowHTML.replace(/StartTime[0-9]+/g, 'StartTime' + RecordNumber);
            NewRowHTML = NewRowHTML.replace(/StartTime\[[0-9]+/g, 'StartTime[' + RecordNumber);
            NewRowHTML = NewRowHTML.replace(/EndTime[0-9]+/g, 'EndTime' + RecordNumber);
            NewRowHTML = NewRowHTML.replace(/EndTime\[[0-9]+/g, 'EndTime[' + RecordNumber);
            NewRowHTML = NewRowHTML.replace(/Period[0-9]+/g, 'Period' + RecordNumber);
            NewRowHTML = NewRowHTML.replace(/Period\[[0-9]+/g, 'Period[' + RecordNumber);

            // Now write this HTML back to the jquery object
            $NewRow.html(NewRowHTML);

            // If last row contained values, these must be removed
            $NewRow
                .find('input:text').val('').end()
                .find('select option').removeAttr('selected');

            // Remove autocompletion from this row (will be re-initiated later)
            $NewRow
                .find('input[id^=Combo_]').remove().end()
                .find('button[id^=ComboBtn_]').remove();

            // Now add this row to the table
            $LastRow.after($NewRow);

            // Save new RecordNumber
            $('#RecordsNumber').val(RecordNumber);

            // Re-initiate the 'odd/even' colours of the table
            $('#InsertWorkingHours tbody tr')
                .removeClass('Even')
                .filter(':odd').addClass('Even');

            // Re-initiate autocompletion combobox
            InitAutoCompletion(Language);
        });
    }

    function RecalculateTotalHours() {
        var Total = 0;
        $('.Period').each(function () {
            var Value = parseFloat($(this).val());
            if (!isNaN(Value)) {
                Total += Value;
            }
        });
        $('.TotalHours').text(Total.toFixed(2));
    }

    function InitPeriodCalculation() {
        // init calculation of period field after working hours where added/substracted/whatever...
        $('.Period').unbind('change.PeriodCalculation').bind('change.PeriodCalculation', function () {
           var FieldValue = $(this).val();

           // replace , with .
           FieldValue = FieldValue.replace(/,/g, ".");

           // check if the entered value only consists of allowed values
           // if not, we do not eval for security reasons
           if (FieldValue.match(/^[0-9\.+\- ]+$/)) {
               // Calculation
               try {
                   FieldValue = eval(FieldValue);
               }
               catch (CalcError) {
                   FieldValue = 0;
               }

               // set new value
               $(this).val(FieldValue.toFixed(2));

               // now StartTime and EndTime will not match the period anymore
               // delete these entries
               $(this).closest('tr').find('.StartTime, .EndTime').val('');

           }
           else {
               $(this).val('');
           }

           // now re-calculate the total hours sum
           RecalculateTotalHours();
        });

        // init period calculation on starttime and endtime fields
        $('.StartTime, .EndTime').unbind('change.PeriodCalculation').bind('change.PeriodCalculation', function () {
            var $StartTime, $EndTime,
                StartTimeHour, StartTimeMinute, EndTimeHour, EndTimeMinute,
                StartDate, EndDate, Today,
                Period, PeriodHour, PeriodMinute;

            if ($(this).hasClass('StartTime')) {
                $StartTime = $(this);
                $EndTime = $StartTime.closest('tr').find('.EndTime');
            }
            else {
                $StartTime = $(this).closest('tr').find('.StartTime');
                $EndTime = $(this);
            }

            // only calculate if both fields are filled
            if ($StartTime.val() && $EndTime.val()) {
                // extract hours and minutes
                StartTimeHour = $StartTime.val().split(/:/)[0] || 0;
                StartTimeMinute = $StartTime.val().split(/:/)[1] || 0;
                EndTimeHour = $EndTime.val().split(/:/)[0] || 0;
                EndTimeMinute = $EndTime.val().split(/:/)[1] || 0;

                // define date objects
                Today = new Date();
                StartDate = new Date(Today.getYear(), Today.getMonth(), Today.getDate(), StartTimeHour, StartTimeMinute, 0);
                EndDate = new Date(Today.getYear(), Today.getMonth(), Today.getDate(), EndTimeHour, EndTimeMinute, 0);

                // calculate differences
                Period = EndDate.getTime() - StartDate.getTime();
                Period = Period / (1000 * 60 * 60);

                // set new value
                if (!isNaN(Period)) {
                    $StartTime.closest('tr').find('.Period').val(Period.toFixed(2));
                }
                else {
                    $StartTime.closest('tr').find('.Period').val('');
                }

                RecalculateTotalHours();
            }
        });
    }

    /**
     * @function
     * @param {Object} Options thedifferent possible options:
     *                  RemarkRegExpContent - the regular expression for the remark validation check
     *                  Language - object with text translations
     *                  Autocompletion - boolean
     * @return nothing
     *      This function initializes all needed JS for the Edit screen
     */
    TargetNS.Init = function (Options) {
        var Options = Options || {},
            RemarkRegExpContent = Options.RemarkRegExpContent,
            Language = Options.Language;
        // Add some special validation methods for the edit screen
        // Define all available elements (only the prefixes) in a row
        var ElementPrefixes = ['ProjectID', 'ActionID', 'Remark', 'StartTime', 'EndTime', 'Period'];

        // Validates the project: if some other field in this row is filled, the project select must be filled, too
        Core.Form.Validate.AddMethod('Validate_TimeAccounting_Project', function (Value, Element) {
            var ID,
                Result = true;

            // Get ID
            // Our Element can be the select element or the autocompletion input field
            if ($(Element).is('select')) {
                ID = $(Element).attr('id').replace('ProjectID', '');
            }
            else {
                ID = $(Element).prev('select').attr('id').replace('ProjectID', '');
            }

            if (!Value) {
                $.each(ElementPrefixes, function () {
                    if (!Result) {
                        return;
                    }

                    if (this !== 'ProjectID' && $('#' + this + ID).val()) {
                        Result = false;
                    }
                });
            }

            return Result;
        });

        Core.Form.Validate.AddRule('Validate_TimeAccounting_Project', { Validate_TimeAccounting_Project: true });

        // Validates the remarks: depending on the project, remarks must be entered or not
        Core.Form.Validate.AddMethod('Validate_TimeAccounting_Remark', function (Value, Element) {
            var ID = $(Element).attr('id').replace('Remark', ''),
                RemarkRegExp = new RegExp("^(" + RemarkRegExpContent + ")$"),
                RemarkCheck = RemarkRegExp.test($('#ProjectID' + ID).val());

            if ($('#ProjectID' + ID).val()) {
                return !(RemarkCheck && Value.length < 8);
            }

            return true;
        });

        Core.Form.Validate.AddRule('Validate_TimeAccounting_Remark', { Validate_TimeAccounting_Remark: true });

        // Validates the start time: if a project is given and no time period is given, this field is required
        Core.Form.Validate.AddMethod('Validate_TimeAccounting_StartTime', function (Value, Element) {
            var ID = $(Element).attr('id').replace('StartTime', '');

            if (!Value && $('#ProjectID' + ID).val() && !$('#Period' + ID).val()) {
                return false;
            }

            return true;
        });

        Core.Form.Validate.AddRule('Validate_TimeAccounting_StartTime', { Validate_TimeAccounting_StartTime: true });

        // Validates the time period: if a project is given and no start time is given, this field is required
        Core.Form.Validate.AddMethod('Validate_TimeAccounting_Period', function (Value, Element) {
            var ID = $(Element).attr('id').replace('Period', '');

            if (!Value && $('#ProjectID' + ID).val() && !$('#StartTime' + ID).val()) {
                return false;
            }

            return true;
        });

        Core.Form.Validate.AddRule('Validate_TimeAccounting_Period', { Validate_TimeAccounting_Period: true });

        // Enable autocompletion, if configured
        if (Options.Autocompletion) {
            InitAutoCompletion(Language);
        }

        // initiate "more input fields" functionality
        InitAddRow(Language);

        // initiate period calculation
        InitPeriodCalculation();
    };

    /**
     * @function
     * @param {Object} Language object with text translations
     * @return nothing
     *      This function initializes the javascript for the mass entry functionality
     */
    TargetNS.MassEntryInit = function(Language) {
        $('#IncompleteWorkingDay-All').unbind('click.SelectAllDays').bind('click.SelectAllDays', function (Event) {
            var State = $(this).attr('checked');
            $('ul.IncompleteWorkingDays li input:checkbox').attr('checked', State);
        });
        $('#MassEntrySubmit').unbind('click.MassEntrySubmit').bind('click.MassEntrySubmit', function () {
            var $WorkingDayCheckboxes = $('ul.IncompleteWorkingDays li input:checkbox:checked').filter('[name!=IncompleteWorkingDay-All]');

            if (!$WorkingDayCheckboxes.length) {
                alert(Language.MsgChooseOneDay);
                return false;
            }

            // Show overlay
            Core.UI.Dialog.ShowContentDialog($('#MassEntryConfirmDialog'), Language.MassEntry, '150px', 'Center', true, [
                {
                    Label: Language.Submit,
                    Function: function () {
                        var $SelectedRadio = $('#MassEntryConfirmRadio li input:radio:checked'),
                            AbsenceReason,
                            CollectedDates = '';

                        if (!$SelectedRadio.length) {
                            alert(Language.MsgAbsenceReason);
                            return false;
                        }

                        // set absence reason
                        AbsenceReason = $SelectedRadio.attr('name');
                        if (AbsenceReason === 'LeaveDay') {
                            $('#MassEntry input[name=LeaveDay]').val(1);
                        }
                        else if (AbsenceReason === 'Sick') {
                            $('#MassEntry input[name=Sick]').val(1);
                        }
                        else if (AbsenceReason === 'Overtime') {
                            $('#MassEntry input[name=Overtime]').val(1);
                        }

                        // collect dates
                        $('ul.IncompleteWorkingDays li input:checkbox:checked').each(function () {
                            var Date = $(this).attr('name').replace(/IncompleteWorkingDay-/, "");
                            if (Date !== 'All') {
                                CollectedDates += Date + '|';
                            }
                        });
                        $('#MassEntry input[name=Dates]').val(CollectedDates);

                        // Show waiting icon
                        $('.Dialog:visible')
                        .find('.ContentFooter')
                        .empty()
                        .end()
                        .find('.InnerContent')
                        .width($('.Dialog:visible').find('.InnerContent').width())
                        .empty()
                        .append('<span class="AJAXLoader"></span>');

                        // Submit form
                        $('#MassEntry').submit();
                    },
                    Class: 'Primary'
                },
                {
                    Label: Language.Cancel,
                    Function: function () {
                        Core.UI.Dialog.CloseDialog($('.Dialog:visible'));
                    }
                },
            ]);
            return false;
        });
    };

    return TargetNS;
}(TimeAccounting.Agent.EditTimeRecords || {}));
