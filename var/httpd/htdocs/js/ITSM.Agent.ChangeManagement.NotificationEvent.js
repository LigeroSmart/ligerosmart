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
 * @namespace ITSM.Agent.ChangeManagement.NotificationEvent
 * @memberof ITSM.Agent.ChangeManagement
 * @author OTRS AG
 * @description
 *      This namespace contains the special module functions for the Notification Event module.
 */
ITSM.Agent.ChangeManagement.NotificationEvent = (function (TargetNS) {

    /**
     * @name Init
     * @memberof ITSM.Agent.ChangeManagement.NotificationEvent
     * @function
     * @param {Object} Params - Initialization and internationalization parameters.
     * @description
     *      This function initialize correctly all other function according to the local language.
     */
    TargetNS.Init = function (Params) {

        TargetNS.Localization = Params.Localization;

        // bind click function to add button
        $('.LanguageAdd').off('change.LanguageAdd').on('change.LanguageAdd', function(){
            TargetNS.AddLanguage($(this), $(this).val(), $(this).find('option:selected').text());
            return false;
        });

        // bind click function to remove button
        $('.LanguageRemove').off('click.LanguageRemove').on('click.LanguageRemove', function(){
            if (window.confirm(TargetNS.Localization.DeleteNotificationLanguageMsg)) {
                TargetNS.RemoveLanguage($(this));
            }
            return false;
        });
    };

   /**
     * @name AddLanguage
     * @memberof ITSM.Agent.ChangeManagement.NotificationEvent
     * @function
     * @param {jQueryObject} Object - JQuery object used to remove the language block
     * @param {string} LanguageID - short name of the language like es_MX.
     * @param {string} Language - full name of the language like Spanish (Mexico).
     * @param {string} Type - Agent or Customer.
     * @returns {Bool} Returns false to prevent event bubbling.
     * @description
     *      This function add a new notification event language.
     */
    TargetNS.AddLanguage = function(Object, LanguageID, Language){

        var $Clone = $('.Template').clone(),
            Type;

        if (Language === '-'){
            return false;
        }

        if (Object.attr('id') === 'AgentLanguageAdd') {
            Type = 'Agent';
        }
        else if (Object.attr('id') === 'CustomerLanguageAdd') {
            Type = 'Customer';
        }

        // remove unnecessary classes
        $Clone.removeClass('Hidden Template');

        // add title
        $Clone.find('.Title').html(Language);

        // update remove link
        $Clone.find('#Template_Language_Remove').addClass(Type + 'LanguageRemove');
        $Clone.find('#Template_Language_Remove').attr('name', Type + '_' + LanguageID + '_Language_Remove');
        $Clone.find('#Template_Language_Remove').attr('id', Type + '_' + LanguageID + '_Language_Remove');

        // set hidden language field
        $Clone.find('.LanguageID').attr('name', Type + '_' + 'LanguageID');
        $Clone.find('.LanguageID').val(LanguageID);

        // update subject label
        $Clone.find('#Template_Label_Subject').attr('for', Type + '_' + LanguageID + '_Subject');
        $Clone.find('#Template_Label_Subject').attr('id', Type + '_' + LanguageID + '_Label_Subject');

        // update subject field
        $Clone.find('#Template_Subject').attr('name', Type + '_' + LanguageID + '_Subject');
        $Clone.find('#Template_Subject').addClass('Validate_Required');
        $Clone.find('#Template_Subject').attr('id', Type + '_' + LanguageID + '_Subject');
        $Clone.find('#Template_SubjectError').attr('id', Type + '_' + LanguageID + '_SubjectError');

        // update body label
        $Clone.find('#Template_Label_Body').attr('for', Type + '_' + LanguageID + '_Body');
        $Clone.find('#Template_Label_Body').attr('id', Type + '_' + LanguageID + '_Label_Body');

        // update body field
        $Clone.find('#Template_Body').attr('name', Type + '_' + LanguageID + '_Body');
        $Clone.find('#Template_Body').addClass('RichText');
        $Clone.find('#Template_Body').addClass('Validate_RequiredRichText');
        $Clone.find('#Template_Body').attr('id', Type + '_' + LanguageID + '_Body');
        $Clone.find('#Template_BodyError').attr('id', Type + '_' + LanguageID + '_BodyError');

        // append to container
        $('#' + Type + 'NotificationLanguageContainer').append($Clone);

        // initialize the rich text editor if set
        if (parseInt(Core.Config.Get('RichTextSet'), 10) === 1) {
            Core.UI.RichTextEditor.InitAllEditors();
        }

        // bind click function to remove button
        $('.LanguageRemove').off('click.LanguageRemove').on('click.LanguageRemove', function(){

            if (window.confirm(TargetNS.Localization.DeleteNotificationLanguageMsg)) {
                TargetNS.RemoveLanguage($(this));
            }
            return false;
        });

        TargetNS.LanguageSelectionRebuild(Type);

        Core.UI.InitWidgetActionToggle();

        return false;
    };

    /**
     * @name RemoveLanguage
     * @memberof ITSM.Agent.ChangeManagement.NotificationEvent
     * @function
     * @param {jQueryObject} Object - JQuery object used to remove the language block
     * @description
     *      This function removes a notification event language.
     */
    TargetNS.RemoveLanguage = function (Object) {

        var Type;

        Object.closest('.NotificationLanguage').remove();

        if (Object.hasClass('AgentLanguageRemove')) {
            Type = 'Agent';
        }
        else if (Object.hasClass('CustomerLanguageRemove')) {
            Type = 'Customer';
        }

        TargetNS.LanguageSelectionRebuild(Type);
    };

    /**
     * @name LanguageSelectionRebuild
     * @memberof ITSM.Agent.ChangeManagement.NotificationEvent
     * @function
     * @param {string} Type - Agent or Customer.
     * @returns {Boolean} Returns true.
     * @description
     *      This function rebuilds language selection, only show available languages.
     */
    TargetNS.LanguageSelectionRebuild = function (Type) {

        var $OrigOptions = $('#' + Type + 'LanguageOrig option').clone();

        // Remove the existing options in order to rebuild it from the original list of options.
        $('#' + Type + 'LanguageAdd option').remove();
        $.each($OrigOptions, function() {
            if (!$('#' + Type + 'NotificationLanguageContainer label#' + Type + '_' + $(this).val() + '_Label_Subject').length) {
                $('#' + Type + 'LanguageAdd').append($(this));
            }
        });

        $('#' + Type + 'LanguageAdd').trigger('redraw.InputField');

        return true;
    };

    return TargetNS;
}(ITSM.Agent.ChangeManagement.NotificationEvent || {}));
