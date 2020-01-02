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
 * @exports TargetNS as Survey.Agent.CustomerUserConditions
 * @description
 *      This namespace contains the special module functions for CustomerUserConditions in AgentSurveyAdd and AgentSurveyEdit.
 */
Survey.Agent.CustomerUserConditions = (function (TargetNS) {
    var Action = $('input[name="Action"]').val();
    var DropdownID;
    var ErrorsObj;

    /**
     * @name Init
     * @memberof Survey.Agent.CustomerUserConditions
     * @function
     * @description
     *      Initialize building the send conditions.
     */
    TargetNS.Init = function () {
        var $Dropdown = $('#CustomerUserConditions'),
            CustomerUserConditions = Core.Config.Get("JSData.CustomerUserConditions"),
            Errors = Core.Config.Get("JSData.CustomerUserConditionErrors");

        if (isJQueryObject($Dropdown)) {

            DropdownID = $Dropdown.prop('id');

            $Dropdown.on('change', function () {
                var FieldName = $Dropdown.val();

                // Add new field for FieldName.
                TargetNS.AddCondition(FieldName);
            });

            $(document).on('click', 'span.RemoveButtonCustomerField', function () {
                // Get whole "container" and remove it.
                var $Field = $(this).parent().parent().parent();

                TargetNS.RemoveCondition($Field);
            });

            $(document).on('click', 'span.AddButtonCustomerCondition', function () {

                // Get first condition to clone it (empty).
                var $Field = $(this).parent().parent().children('li').first();
                var FieldName = $(this).parent().parent().parent().parent().parent().prop('id');
                TargetNS.AddConditionLine($Field);
                TargetNS.ResetListItemIDs(FieldName);
            });

            $(document).on('click', 'span.RemoveButtonCustomerCondition', function () {

                var $Field = $(this).parent();
                var FieldName = $(this).parent().parent().parent().parent().parent().prop('id');
                TargetNS.RemoveConditionLine($Field);
                TargetNS.ResetListItemIDs(FieldName);
            });

            $(document).on('click', 'input.CustomerUserConditionsCheckbox', function () {

                var $this = $(this);
                $this.prev('input[type="hidden"]').val((($this.prop('checked')) ? 1 : 0));
            });

            if (CustomerUserConditions) {

                if (Errors) {

                    ErrorsObj = Errors;
                }

                TargetNS.RestoreConditions(CustomerUserConditions);
            }
        }
    };

    /**
     * @name AddCondition
     * @memberof Survey.Agent.CustomerUserConditions
     * @function
     * @param {string} FieldName - The field that should be added
     * @param {Object} Conditions - The conditions for the field which should be inserted (for edit)
     * @description
     *      Adds a new field to the conditions and inserts saved conditions.
     */
    TargetNS.AddCondition = function (FieldName, Conditions) {

        var $Clone, $Checkbox, $Label, $Input;
        var NewName, NewCheckboxID, NewInputID;
        var Data;
        var SelectedValues;

        if (!FieldName) return;

        $('#CustomerUserConditionsFields').val($('#CustomerUserConditionsFields').val() + ',' + FieldName);

        $Clone = $('#TemplateLevel1').clone();

        // Change needed texts, IDs, ...
        $Clone.find('strong').text(FieldName);

        $Checkbox = $Clone.find('input[type="checkbox"]');
        $Label    = $Clone.find('label');
        $Input    = $Clone.find('input[type="text"]');

        NewName       = FieldName;
        NewCheckboxID = FieldName + 'Checkbox1';
        NewInputID    = FieldName + 'Input1';

        // The label should be able to check/uncheck the checkbox.
        $Checkbox
            .prop('id', NewCheckboxID)
            .prev('input[type="hidden"]').prop('name', NewName + 'Checkbox');
        $Label.prop('for', NewCheckboxID);

        $Input
            .prop('name', NewName)
            .prop('id', NewInputID);

        $Clone
            .prop('id', FieldName)
            .find('div.TooltipErrorMessage').prop('id', NewInputID + 'ServerError').end()
            .insertBefore('#TemplateLevel1.Field.Hidden');

        // Perform AJAX call to check whether the field is an input or select field.
        Data = {
            Action: Action,
            Subaction: 'AJAXRequest',
            FieldName: FieldName
        };

        // Add values from conditions as selected values for selection.
        if (typeof Conditions !== 'undefined') {
            SelectedValues = [];
            Object.keys(Conditions).forEach(function (Field) {

                Conditions[Field].forEach(function (Condition) {

                    if (typeof Data.CheckboxValue === 'undefined') {
                        Data.CheckboxValue = Condition.Negation;
                    }
                    SelectedValues.push(Condition.RegExpValue);
                });
            });

            Data.SelectedValues = SelectedValues;
        }

        // Call the AJAX function
        Core.AJAX.FunctionCall(Core.Config.Get('CGIHandle'), Data, function (Response) {

            if (Response.Success) {

                // Insert and modernize field.
                $(Response.SelectField)
                    .prop('name', NewName)
                    .prop('id', NewInputID)
                    .insertAfter($Checkbox);

                $Checkbox
                    .prop('checked', Data.CheckboxValue)
                    .prev('input[type="hidden"]').val(((Data.CheckboxValue) ? 1 : 0));

                $Input.remove();

                $Clone.find('.AddButtonCustomerCondition').addClass('Hidden').end();
            }
            else {
                // Add a new line for each condition (for input fields).
                if (typeof Conditions !== 'undefined') {

                    Object.keys(Conditions).forEach(function (Field) {

                        Conditions[Field].forEach(function (Condition) {

                            var $Field = $('#' + Field + ' ul.CustomerUserConditionsList li.DataItem ul li');
                            if (Condition.Clone) {
                                $Field = $Field.first();
                            }
                            else {
                                $Field = $Field.last();
                            }

                            TargetNS.AddConditionLine($Field, Condition);
                        });

                        // Reset the correct IDs for the entire field.
                        TargetNS.ResetListItemIDs(Field);
                    });
                }
            }

            $Clone.removeClass('Hidden');

            if (Response.Success) {
                Core.UI.InputFields.Activate($Clone);
            }

            if (ErrorsObj && ErrorsObj[FieldName]) {

                TargetNS.ShowErrors(FieldName, ErrorsObj[FieldName]);
            }
        }, 'json');

        // Remove FieldName from dropdown to prevent multiple entries.
        $('#' + DropdownID)
            .find("option[value='" + FieldName + "']").remove().end()
            .val('');
    };

    /**
     * @name RemoveCondition
     * @memberof Survey.Agent.CustomerUserConditions
     * @function
     * @param {jQueryObject} $Field - The field that should be removed
     * @description
     *      Removes the field from the conditions.
     */
    TargetNS.RemoveCondition = function ($Field) {

        var FieldName = $Field.find('strong').text();
        var FieldsVal = $('#CustomerUserConditionsFields').val();
        FieldsVal = FieldsVal.replace(',' + FieldName, '');
        $('#CustomerUserConditionsFields').val(FieldsVal);

        // Add FieldName to dropdown.
        $('#' + DropdownID).append(
            $('<option></option>').val(FieldName).html(FieldName)
        );

        $Field.remove();
    };

    /**
     * @name AddConditionLine
     * @memberof Survey.Agent.CustomerUserConditions
     * @function
     * @param {jQueryObject} $Field - The field for which a line should be added
     * @param {Object} Condition - The condition which should be added
     * @description
     *      Adds a new condition line for the specified field.
     */
    TargetNS.AddConditionLine = function ($Field, Condition) {

        var $Clone;
        var CloneField = true;
        var TextValue = '';
        var CheckboxValue = false;

        if (typeof Condition !== 'undefined') {

            CloneField = Condition.Clone;
            TextValue = Condition.RegExpValue;
            CheckboxValue = Condition.Negation;
        }

        if (CloneField) {
            $Clone = $Field.clone();
        }
        else {
            $Clone = $Field;
        }

        // Clear the cloned fields (or set the values from the given condition).
        $Clone
            .find('input[type="checkbox"]').prop('checked', CheckboxValue).end()
            .find('input[type="hidden"]').val((CheckboxValue ? 1 : 0)).end()
            .find('input[type="text"]').val(TextValue).show().end();

        if (CloneField) {
            $Clone.appendTo($Field.parent());
        }

        // Toggle buttons to add/remove the condition.
        if ($Field.parent().children('li').length !== 1) {

            $Clone
                .find('.RemoveButtonCustomerCondition').removeClass('Hidden').end()
                .find('.AddButtonCustomerCondition').removeClass('Hidden').end();

            // Hide the button to add a condition on the previous element.
            $Clone.prev().find('.AddButtonCustomerCondition').addClass('Hidden').end();
        }
        else {
            $Clone
                .find('.RemoveButtonCustomerCondition').addClass('Hidden').end()
                .find('.AddButtonCustomerCondition').removeClass('Hidden').end();
        }
    };

    /**
     * @name RemoveConditionLine
     * @memberof Survey.Agent.CustomerUserConditions
     * @function
     * @param {jQueryObject} $Field - The field for which the line should be removed
     * @description
     *      Removes a new condition line for the specified field.
     */
    TargetNS.RemoveConditionLine = function ($Field) {

        // Show the button for adding a condition on the previous element.
        if (!$Field.find('.AddButtonCustomerCondition').hasClass('Hidden')) {
            $Field.prev().find('.AddButtonCustomerCondition').removeClass('Hidden');
        }

        $Field.remove();
    };

    /**
     * @name ResetListItemIDs
     * @memberof Survey.Agent.CustomerUserConditions
     * @function
     * @param {String} FieldName - The field for which the listitems should be resetted
     * @description
     *      Resets the IDs of the listitems.
     */
    TargetNS.ResetListItemIDs = function (FieldName) {

        var $ListItems = $('#' + FieldName + ' ul.CustomerUserConditionsList li.DataItem ul li')

        // Set correct IDs for the listitems.
        var i = 1;
        $ListItems.each(function () {

            var $this = $(this);
            var CheckboxID = FieldName + 'Checkbox' + i;
            var InputID = FieldName + 'Input' + i;

            $this
                .find('label').prop('for', CheckboxID).end()
                .find('input[type="checkbox"]').prop('id', CheckboxID).end()
                .find('input[type="text"], select').prop('id', InputID).end()
                .find('div.TooltipErrorMessage').prop('id', InputID + 'ServerError').end();

            i++;
        });
    };

    /**
     * @name RestoreConditions
     * @memberof Survey.Agent.CustomerUserConditions
     * @function
     * @param {Array} Conditions - The conditions to display
     * @description
     *      Restores the conditions in case of an error or to edit them.
     */
    TargetNS.RestoreConditions = function (Conditions) {

        Object.keys(Conditions).forEach(function (Field) {

            var ConditionsObj = {};
            ConditionsObj[Field] = [];

            Conditions[Field].forEach(function (Condition, idx) {

                var ConditionObj = {
                    Clone: ((idx === 0) ? false : true),
                    RegExpValue: Condition.RegExpValue,
                    Negation: Boolean(parseInt(Condition.Negation, 10))
                };

                ConditionsObj[Field].push(ConditionObj);
            });

            // Add a condition container for the field and insert the given conditions.
            TargetNS.AddCondition(Field, ConditionsObj);
        });
    };

    /**
     * @name ShowErrors
     * @memberof Survey.Agent.CustomerUserConditions
     * @function
     * @param {String} Field - The selected field from the dropdown which has errors
     * @param {Object} Errors - Contains the index of the fields which are invalid
     * @description
     *      Display error messages.
     */
    TargetNS.ShowErrors = function (Field, Errors) {

        var Item;

        for (Item in Errors) {

            if(!Errors.hasOwnProperty(Item)) continue;

            $('#' + Field + ' ul.CustomerUserConditionsList li.DataItem ul li').eq(Item)
                .find('input[type="text"], select').addClass('ServerError');
        }

        Core.Form.Validate.Init();
    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(Survey.Agent.CustomerUserConditions || {}));
