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
 * @namespace ITSM.Agent.ChangeManagement.Add
 * @memberof ITSM.Agent.ChangeManagement
 * @author OTRS AG
 * @description
 *      This namespace contains the special module functions for the change-management add screen.
 */
ITSM.Agent.ChangeManagement.CABTemplateEdit = (function (TargetNS) {

    /**
     * @private
     * @name DeleteCABMember
     * @namespace ITSM.Agent
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
     * @namespace ITSM.Agent.ChangeManagement.CABTemplateEdit
     * @function
     * @description
     *      This function initializes some behaviours for the add screen.
     */
    TargetNS.Init = function () {

        // Bind elements with class '.DeleteCABMember' to delete the cab member.
        $('.DeleteCABMember').off('click.CAB.TemplateEdit').on('click.CAB.TemplateEdit', DeleteCABMember);

        $('#BtnAddCABMember').off('click.AgentITSMTemplateEditCABAddCABMember').on('click.AgentITSMTemplateEditCABAddCABMember', function () {

            var $Form = $('#AddCABMember').closest('form');
            Core.Form.Validate.DisableValidation($Form);

            $('input[name=AddCABMember]', $Form).val('Add');

        });
    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;

}(ITSM.Agent.ChangeManagement.CABTemplateEdit || {}));
