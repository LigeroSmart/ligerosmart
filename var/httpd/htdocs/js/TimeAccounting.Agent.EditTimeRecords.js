// --
// TimeAccounting.Agent.EditTimeRecords.js - provides the special module functions for the
// edit screen
// Copyright (C) 2001-2010 OTRS AG, http://otrs.org/\n";
// --
// $Id: TimeAccounting.Agent.EditTimeRecords.js,v 1.1 2010-12-29 14:19:10 mn Exp $
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

    /**
     * @function
     * @param {String} the regular expression for the remark validation check
     * @return nothing
     *      This function initializes all needed JS for the Edit screen
     */
    TargetNS.Init = function (RemarkRegExpContent) {
        // Add some special validation methods for the edit screen
        // Define all available elements (only the prefixes) in a row
        var ElementPrefixes = ['ProjectID', 'ActionID', 'Remark', 'StartTime', 'EndTime', 'Period'];

        // Validates the project: if some other field in this row is filled, the project select must be filled, too
        Core.Form.Validate.AddMethod('Validate_TimeAccounting_Project', function (Value, Element) {
            var ID = $(Element).attr('id').replace('ProjectID', ''),
                Result = true;

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
    }

    return TargetNS;
}(TimeAccounting.Agent.EditTimeRecords || {}));
