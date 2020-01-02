// --
// Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
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
 * @namespace ITSM.Agent.ChangeManagement.InvolvedPersons
 * @memberof ITSM.Agent.ChangeManagement
 * @author OTRS AG
 * @description
 *      This namespace contains the special module functions for the Involved Persons module.
 */
ITSM.Agent.ChangeManagement.InvolvedPersons = (function (TargetNS) {

    /**
     * @private
     * @name SetFormAction
     * @namespace ITSM.Agent.ChangeManagement.InvolvedPersons
     * @function
     * @description
     *      This function sets the form action when the button is clicked.
     */
    function SetFormAction() {
        var $This = $(this);
        var $Form = $This.closest('form');
        var Actions = {
            'Submit'        : '0',
            'AddCABTemplate': '0',
            'NewTemplate'   : '0',
            'AddCABMember'  : '0'
        };

        var SetAction = $This.attr('id');
        SetAction = SetAction.replace(/Button$/i, '');
        if (SetAction !== 'Submit') {
            Core.Form.Validate.DisableValidation($Form);
        }

        if (!Actions.hasOwnProperty(SetAction)) {
            return;
        }

        Actions[SetAction] = '1';

        $.each(Actions, function(Action, Value) {
            $('input[name=' + Action + ']', $Form).val(Value);
        });
    }

    /**
     * @private
     * @name DeleteCABMember
     * @namespace ITSM.Agent.ChangeManagement.InvolvedPersons
     * @function
     * @returns {false} Returns false to cancel the default behaviour of anchor elements.
     * @description
     *      This function sets the cab member to delete when the button is clicked.
     */
    function DeleteCABMember() {
        var $This = $(this);
        var $Form = $This.closest('form');

        Core.Form.Validate.DisableValidation($Form);
        $('input[name=DeleteCABMember]', $Form).val($This.attr('id'));
        $Form.submit();
        return false;
    }

    /**
     * @name Init
     * @namespace ITSM.Agent.ChangeManagement.InvolvedPersons
     * @function
     * @description
     *      This function initializes some behaviours for the involved-persons screen.
     */
    TargetNS.Init = function () {

        // Bind elements with class '.CallForAction' to set the proper form action
        // before the form submits.
        $('.CallForAction').off('click.FormAction.InvolvedPersons').on('click.FormAction.InvolvedPersons', SetFormAction);

        // Bind elements with class '.DeleteCABMember' to delete the cab member.
        $('.DeleteCABMember').off('click.CAB.InvolvedPersons').on('click.CAB.InvolvedPersons', DeleteCABMember);

    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;

}(ITSM.Agent.ChangeManagement.InvolvedPersons || {}));
