// --
// Copyright (C) 2001-2018 OTRS AG, http://otrs.com/
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (AGPL). If you
// did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
// --

"use strict";

var ITSM = ITSM || {};
ITSM.Admin = ITSM.Admin || {};


/**
 * @namespace Admin
 * @author OTRS AG
 * @description
 *      This namespace contains the special module behaviours for ITSM Service Zoom.
 */
 ITSM.Admin.ImportExport = (function (TargetNS) {

    /**
     * @name Init
     * @memberof Admin.ImportExport
     * @function
     * @description
     *      This function initializes actions for ITSM Service Zoom.
     */
    TargetNS.Init = function() {

        var $NextButton, $FirstColumn;

        if (Core.Config.Get('TemplateEdit4')) {

            // find the next button and get the first column dropdown
            $NextButton = $("button.Primary[name='SubmitNextButton']").first();
            $FirstColumn = $('#Object\\:\\:0\\:\\:Key');

            // handle changes to the first column selector
            $FirstColumn.bind('change', function () {

                // check if there is at least one column with a value
                if ($FirstColumn.val()) {
                    // we remove the disabled attribute
                    $NextButton.removeAttr("disabled");
                }
                else {
                    // we add the disabled attribute
                    $NextButton.attr("disabled", "disabled");
                }

            }).trigger('change');

            // set the hidden field to delete this column and submit the form
            $('.DeleteColumn').unbind('click').bind('click', function() {
                $(this).closest('td').find('input[type="hidden"]').val(1);
                $(this).closest('form').submit();
                return true;
            });

            $('#MappingAddButton').bind('click', function () {
                $('input[name=MappingAdd]').val('1');
                $('input[name=SubmitNext]').val('0');
            });

            $('#SubmitNextButton').bind('click', function () {
                $('input[name=MappingAdd]').val('0');
                $('input[name=SubmitNext]').val('1');
            });
        }

        if (Core.Config.Get('TemplateOverview')) {

            $('button.Back').bind('click', function () {
                location.href = Core.Config.Get('Baselink') + Core.Config.Get('BackURL');
            });

            Core.Form.Validate.AddMethod("Validate_NumberBiggerThanZero", function(Value) {
                var Number = parseInt(Value, 10);
                if (isNaN(Number)) {
                    return false;
                }

                if (Number > 0) {
                    return true;
                }
                return false;

            });

            Core.Form.Validate.AddMethod("Validate_NumberInteger", function(Value) {
                return (Value.match(/^[0-9]+$/)) ? true : false;

            });

            Core.Form.Validate.AddRule("Validate_NumberBiggerThanZero", { Validate_NumberBiggerThanZero: true });
            Core.Form.Validate.AddRule("Validate_NumberInteger", { Validate_NumberInteger: true });
            Core.Form.Validate.AddRule("Validate_NumberIntegerBiggerThanZero", { Validate_NumberInteger: true, Validate_NumberBiggerThanZero: true });

        }

    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(ITSM.Admin.ImportExport || {}));
