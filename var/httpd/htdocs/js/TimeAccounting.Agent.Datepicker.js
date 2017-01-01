// --
// Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (AGPL). If you
// did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
// --

"use strict";

var TimeAccounting = TimeAccounting || {};
TimeAccounting.Agent = TimeAccounting.Agent || {};

/**
 * @namespace TimeAccounting.Agent.Datepicker
 * @memberof TimeAccounting.Agent
 * @author OTRS AG
 * @description
 *      This namespace contains the special datepicker function for TA.
 */
TimeAccounting.Agent.Datepicker = (function (TargetNS) {

    var VacationDays,
        VacationDaysOneTime,
        LocalizationData,
        DatepickerCount = 0;

    if (!Core.Debug.CheckDependency('Core.UI.Datepicker', '$([]).datepicker', 'jQuery UI datepicker')) {
        return false;
    }

    /**
     * @private
     * @name CheckDate
     * @memberof TimeAccounting.Agent.Datepicker
     * @function
     * @returns {Object} - array with date data
     * @param {jQueryObject} DateObject - object that will be checked
     * @description Review if a date object have correct values
     *      If no callback function for the close is given (via the Button definition),
     *      the dialog is just closed. Otherwise the defined Close button is triggered,
     *      which invokes the callback and the closing of the dialog.
     */
    function CheckDate(DateObject) {
        var DayDescription = '',
            DayClass = '';

        // Get defined days from Config, if not done already
        if (typeof VacationDays === 'undefined') {
            VacationDays = Core.Config.Get('Datepicker.VacationDays').TimeVacationDays;
        }
        if (typeof VacationDaysOneTime === 'undefined') {
            VacationDaysOneTime = Core.Config.Get('Datepicker.VacationDays').TimeVacationDaysOneTime;
        }

        // Check if date is one of the vacation days
        if (typeof VacationDays[DateObject.getMonth() + 1] !== 'undefined' &&
            typeof VacationDays[DateObject.getMonth() + 1][DateObject.getDate()] !== 'undefined') {
            DayDescription += VacationDays[DateObject.getMonth() + 1][DateObject.getDate()];
            DayClass = 'Highlight ';
        }

        // Check if date is one of the one time vacation days
        if (typeof VacationDaysOneTime[DateObject.getFullYear()] !== 'undefined' &&
            typeof VacationDaysOneTime[DateObject.getFullYear()][DateObject.getMonth() + 1] !== 'undefined' &&
            typeof VacationDaysOneTime[DateObject.getFullYear()][DateObject.getMonth() + 1][DateObject.getDate()] !== 'undefined') {
            DayDescription += VacationDaysOneTime[DateObject.getFullYear()][DateObject.getMonth() + 1][DateObject.getDate()];
            DayClass = 'Highlight ';
        }

        if (DayClass.length) {
            return [true, DayClass, DayDescription];
        }
        else {
            return [true, ''];
        }
    }

    /**
     * @name Init
     * @memberof TimeAccounting.Agent.Datepicker
     * @function
     * @param {Object} $Element The jQuery object(s) of a text input field which should get a datepicker.
     * @param {Object} DatepickerOptions Object with two possible keys:
     *                      DateInFuture: true|false,
     *                      WeekDayStart: 0-7 (sunday - saturday)
     * @description
     *      This function initializes the datepicker on single elements for TA.
     *      This function is not yet available in the OTRS Core.
     *      If it will be implemented in OTRS Core we could remove this file here.
     */
    TargetNS.Init = function ($Element, DatepickerOptions) {
        var $DatepickerElement,
            Options;

        // TODO: check if this is still needed
        // function LeadingZero(Number) {
        //     if (Number.toString().length === 1) {
        //         return '0' + Number;
        //     }
        //     else {
        //         return Number;
        //     }
        // }

        if (typeof LocalizationData === 'undefined') {
            LocalizationData = Core.Config.Get('Datepicker.Localization');
            if (typeof LocalizationData === 'undefined') {
                throw new Core.Exception.ApplicationError('Datepicker localization data could not be found!', 'InternalError');
            }
        }

        // Define options hash
        Options = {
                beforeShowDay: function (DateObject) {
                    return CheckDate(DateObject);
                },
                showOn: 'focus',
                prevText: LocalizationData.PrevText,
                nextText: LocalizationData.NextText,
                showMonthAfterYear: 0,
                dateFormat: 'yy-mm-dd',
                monthNames: LocalizationData.MonthNames,
                monthNamesShort: LocalizationData.MonthNamesShort,
                dayNames: LocalizationData.DayNames,
                dayNamesShort: LocalizationData.DayNamesShort,
                dayNamesMin: LocalizationData.DayNamesMin,
                isRTL: LocalizationData.IsRTL
        };

        Options.beforeShow = function (Input) {
            var Value = $(Input).prevAll('input:text').val();
            $(Input).val('');
            return {
                defaultDate: new Date(Value)
            };
        };

        Options.onSelect = function (DateText) {
            $(this).prevAll('input:text').val(DateText);
        };

        if (isJQueryObject($Element)) {
            $Element.each(function () {
                var $SingleElement = $(this);
                if ($SingleElement.is('input:text')) {
                    // Increment number of initialized datepickers on this site
                    DatepickerCount++;

                    $DatepickerElement = $('<input>').attr('type', 'hidden').attr('id', 'Datepicker' + DatepickerCount);
                    $SingleElement.after($DatepickerElement);

                    Options.firstDay = DatepickerOptions.WeekDayStart;
                    $DatepickerElement.datepicker(Options);

                    // add datepicker icon and click event
                    $DatepickerElement.after('<a href="#" class="DatepickerIcon DatepickerNumber' + DatepickerCount + '" title="' + LocalizationData.IconText + '"><span><i class="fa fa-calendar"></i></span></a>');
                    $DatepickerElement.next('a.DatepickerIcon').click(function () {
                        var Classes = $(this).attr('class'),
                            DatepickerNumber = Classes.replace(/^.*DatepickerNumber([0-9]+).*/g, "$1");

                        $('#Datepicker' + DatepickerNumber).datepicker('show');
                        return false;
                    });

                    // do not show the datepicker container div.
                    $('#ui-datepicker-div').hide();
                }
            });
        }
    };

    return TargetNS;
}(TimeAccounting.Agent.Datepicker || {}));
