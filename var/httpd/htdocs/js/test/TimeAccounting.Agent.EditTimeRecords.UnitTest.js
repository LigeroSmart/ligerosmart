// --
// Copyright (C) 2001-2018 OTRS AG, http://otrs.com/
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (AGPL). If you
// did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
// --

"use strict";

var TimeAccounting = TimeAccounting || {};
TimeAccounting.Agent = TimeAccounting.Agent || {};

TimeAccounting.Agent.EditTimeRecords = (function (Namespace) {
    Namespace.RunUnitTests = function(){

        /*
         * Create a form container for the tests
         */
        var $TestForm = $('<form id="TestForm"></form>'),
            $Table;

        QUnit.module('TimeAccounting.Agent.EditTimeRecords');
        QUnit.test('client-side time period calculations', function(Assert){

            Assert.expect(20);

            $TestForm.append('<table><tr><td></td></tr><tr><td></td></tr><tr><td></td></tr></table>');
            $Table = $TestForm.find('tr:eq(0) td');
            $Table.append('<input type="text" value="" id="StartTime1" name="StartTime1" class="StartTime" />');
            $Table.append('<input type="text" value="" id="EndTime1" name="EndTime1" class="EndTime" />');
            $Table.append('<input type="text" value="" id="Period1" name="Period1" class="Period" />');
            $Table = $TestForm.find('tr:eq(1) td');
            $Table.append('<input type="text" value="" id="StartTime2" name="StartTime2" class="StartTime" />');
            $Table.append('<input type="text" value="" id="EndTime2" name="EndTime2" class="EndTime" />');
            $Table.append('<input type="text" value="" id="Period2" name="Period2" class="Period" />');
            $Table = $TestForm.find('tr:eq(2) td');
            $Table.append('<input type="text" value="" id="StartTime3" name="StartTime3" class="StartTime" />');
            $Table.append('<input type="text" value="" id="EndTime3" name="EndTime3" class="EndTime" />');
            $Table.append('<input type="text" value="" id="Period3" name="Period3" class="Period" />');
            $Table.append('<span id="TotalHours" name="TotalHours" class="TotalHours"></span>');
            $('body').append($TestForm);

            /*
             * Run the tests
             */

            TimeAccounting.Agent.EditTimeRecords.Init();

            // Test: time calculation on time period field
            $('#Period1').val('2');
            $('#Period1').trigger('change');
            Assert.equal($('#Period1').val(), '2.00', 'Normal number entry');

            $('#Period1').val('foobar');
            $('#Period1').trigger('change');
            Assert.equal($('#Period1').val(), '', 'Not a number (="foobar")');

            $('#Period1').val('2 + 3');
            $('#Period1').trigger('change');
            Assert.equal($('#Period1').val(), '5.00', 'Easy calculation');

            $('#Period1').val('alert("huhu");');
            $('#Period1').trigger('change');
            Assert.equal($('#Period1').val(), '', 'Evil javascript code');

            $('#Period1').val('2.23 + 1.09');
            $('#Period1').trigger('change');
            Assert.equal($('#Period1').val(), '3.32', 'Calculation with non-integers');

            $('#Period1').val('2.0001 + 1.5');
            $('#Period1').trigger('change');
            Assert.equal($('#Period1').val(), '3.50', 'Calculation with a number with more than 2 decimals');

            $('#Period1').val('1,2 + 1,3');
            $('#Period1').trigger('change');
            Assert.equal($('#Period1').val(), '2.50', 'Numbers with , instead of .');

            $('#Period1').val('5.8 - 1.2');
            $('#Period1').trigger('change');
            Assert.equal($('#Period1').val(), '4.60', 'Substraction');

            $('#Period1').val('');

            // Test: calculate period from entered start and end time
            $('#StartTime1').val('1');
            $('#StartTime1').trigger('change');
            $('#EndTime1').val('');
            $('#EndTime1').trigger('change');
            Assert.equal($('#Period1').val(), '', 'Only start time entered');

            $('#StartTime1').val('');
            $('#StartTime1').trigger('change');
            $('#EndTime1').val('2');
            $('#EndTime1').trigger('change');
            Assert.equal($('#Period1').val(), '', 'Only end time entered');

            $('#StartTime1').val('1');
            $('#StartTime1').trigger('change');
            $('#EndTime1').val('2');
            $('#EndTime1').trigger('change');
            Assert.equal($('#Period1').val(), '1.00', 'Both times entered');

            $('#StartTime1').val('9:06');
            $('#StartTime1').trigger('change');
            $('#EndTime1').val('10:00');
            $('#EndTime1').trigger('change');
            Assert.equal($('#Period1').val(), '0.90', 'Easy calculation with two times of the format HH:MM');

            $('#StartTime1').val('9:00');
            $('#StartTime1').trigger('change');
            $('#EndTime1').val('11:30');
            $('#EndTime1').trigger('change');
            Assert.equal($('#Period1').val(), '2.50', 'Easy calculation with two times of the format HH:MM');

            $('#StartTime1').val('9,5');
            $('#StartTime1').trigger('change');
            $('#EndTime1').val('10,5');
            $('#EndTime1').trigger('change');
            Assert.equal($('#Period1').val(), '', 'StartTime and EndTime format are wrong');

            $('#StartTime1').val('9:5');
            $('#StartTime1').trigger('change');
            $('#EndTime1').val('10:5');
            $('#EndTime1').trigger('change');
            Assert.equal($('#Period1').val(), '1.00', 'StartTime and EndTime format are slightly wrong');

            // Test: Calculation of total hours
            $('#StartTime1').val('9:5');
            $('#StartTime1').trigger('change');
            $('#EndTime1').val('10:5');
            $('#EndTime1').trigger('change');
            Assert.equal($('#TotalHours').text(), '1.00', 'Easy start');

            $('#Period2').val('2.5');
            $('#Period2').trigger('change');
            Assert.equal($('#TotalHours').text(), '3.50', 'Second period field');

            $('#Period2').val('1.5 + 9,5');
            $('#Period2').trigger('change');
            Assert.equal($('#TotalHours').text(), '12.00', 'Second period field gets an additional calculation with one wrong comma');

            $('#Period3').val('4.35');
            $('#Period3').trigger('change');
            Assert.equal($('#TotalHours').text(), '16.35', 'Third field');

            $('#StartTime1').val('14:00');
            $('#StartTime1').trigger('change');
            $('#EndTime1').val('openend');
            $('#EndTime1').trigger('change');
            Assert.equal($('#TotalHours').text(), '15.35', 'First row: starttime and endtime fields have wrong input');


            /*
             * Cleanup div container and contents
             */
            $('#TestForm').remove();
        });

    };

    return Namespace;
}(TimeAccounting.Agent.EditTimeRecords || {}));
