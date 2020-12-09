// --
// Copyright (C) 2001-2020 OTRS AG, https://otrs.com/\n";
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (GPL). If you
// did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
// --

"use strict";

var ITSM = ITSM || {};
ITSM.Agent = ITSM.Agent || {};
ITSM.Agent.ChangeManagement = ITSM.Agent.ChangeManagement || {};


/**
 * @namespace ITSM.Agent.ChangeManagement.Condition
 * @memberof ITSM.Agent.ChangeManagement
 * @author OTRS AG
 * @description
 *      This namespace contains the special module functions for the change-management condition screen.
 */
ITSM.Agent.ChangeManagement.Condition = (function (TargetNS) {

    /**
     * @private
     * @name ExpressionActionDropdown
     * @memberof ITSM.Agent.ChangeManagement.Condition
     * @function
     * @param {Object} Event object of mouse click.
     * @description
     *      This function initializes behaviours of the condition action/expression dropdowns.
     */
     function ExpressionActionDropdown(Event) {
        var AttrID   = $(this).attr('id');
        var Sections = AttrID.match(/^(.*-\w+)-(\w+)$/i);
        var ID       = Sections[1];
        var Dropdown = Sections[2];

        var ValidDropdowns = [
            'ObjectID',
            'Selector',
            'AttributeID',
        ];

        var RefreshDropdowns = [
            ID + '-OperatorID'
        ];

        var NotSerialize,
            FormSerialized,
            URLString;

        if (ValidDropdowns.indexOf(Dropdown) === -1) {
            return;
        }

        if (Dropdown === 'ObjectID') {
            RefreshDropdowns.unshift(ID + '-AttributeID');
            RefreshDropdowns.unshift(ID + '-Selector');
        }
        else if (Dropdown === 'Selector') {
            RefreshDropdowns.unshift(ID + '-AttributeID');
        }

        Core.AJAX.FormUpdate(
            $('#NewCondition'),
            'AJAXUpdate',
            AttrID,
            RefreshDropdowns
        );

        if (Dropdown === 'AttributeID') {

            NotSerialize = Array;
            NotSerialize.Subaction = 'Subaction';
            FormSerialized         = Core.AJAX.SerializeForm($('#NewCondition'), NotSerialize);
            URLString = [
                window.location.pathname + '?',
                FormSerialized,
                'Subaction=AJAXContentUpdate;',
                'UpdateDivName=' + ID + '-' + Event.data.AttributeIDUpdateDivName + ';',
                'ElementChanged=' + ID + '-AttributeID;'
            ].join('');

            Core.AJAX.ContentUpdate(
                $('#' + ID + '-' + Event.data.AttributeIDUpdateDivName),
                URLString,
                function () {}
            );
        }

        $(this).parent().next('td').find('select').focus();
    }

    /**
     * @private
     * @name SetSubmitAction
     * @memberof ITSM.Agent.ChangeManagement.Condition
     * @function
     * @param {Object} Event object of mouse click.
     * @description
     *      This function sets the action of the clicked button before the form is submitted.
     */
    function SetSubmitAction() {
        var $This   = $(this);
        var Actions = {
            'AddExpression': '0',
            'AddAction'    : '0',
            'Save'         : '0'
        };

        var SetAction = $This.attr('id');
        SetAction = SetAction.replace(/Button$/i, '');
        if (!Actions.hasOwnProperty(SetAction)) {
            return;
        }

        Actions[SetAction] = '1';

        $.each(Actions, function(Action, Value) {
            $('input[name=' + Action + ']').val(Value);
        });
    }

    /**
     * @name Init
     * @namespace ITSM.Agent.ChangeManagement.Condition
     * @function
     * @description
     *      This function initializes some behaviours for the add screen.
     */
    TargetNS.Init = function () {
        // Bind Expression dropdowns
        $('select[name^="ExpressionID-"]').on(
            'change.ConditionExpression',
            {
                'AttributeIDUpdateDivName': 'CompareValue-Div'
            },
            ExpressionActionDropdown
        );

        // Bind Action dropdowns
        $('select[name^="ActionID-"]').on(
            'change.ConditionAction',
            {
                'AttributeIDUpdateDivName': 'ActionValue-Div'
            },
            ExpressionActionDropdown
        );

        $('.CallForAction').on('click.SubmitAction', SetSubmitAction);

        $('.DeleteExpression').on('click.ConditionDeleteExpression', function() {

            if (!window.confirm(Core.Language.Translate('Do you really want to delete this expression?'))) {
               return false;
            }

            $('#DeleteExpressionID').val($(this).attr('id').replace(/DeleteExpressionID-/, ''));
            $(this).closest('form').submit();
            return false;
        });

        $('.DeleteAction').on('click.ConditionDeleteAction', function() {

            if (!window.confirm(Core.Language.Translate('Do you really want to delete this action?'))) {
               return false;
            }

            $('#DeleteActionID').val($(this).attr('id').replace(/DeleteActionID-/, ''));
            $(this).closest('form').submit();
            return false;
        });

        $('.DeleteCondition').on('click.ConditionDelete', function() {

            if (!window.confirm(Core.Language.Translate('Do you really want to delete this condition?'))) {
               return false;
            }

            return true;
        });

    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;

}(ITSM.Agent.ChangeManagement.Condition || {}));
