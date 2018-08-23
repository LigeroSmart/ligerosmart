// --
// Copyright (C) 2001-2018 OTRS AG, https://otrs.com/
// --
// $origin: otrs - 4fe218beccdb926a29dd7bed9de48211430d69d0 - var/httpd/htdocs/js/Core.Agent.TicketActionCommon.js
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (GPL). If you
// did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
// --

"use strict";

var Core = Core || {};
Core.Agent = Core.Agent || {};

// ---
// OTRSMasterSlave
// ---
///**
// * @namespace Core.Agent.TicketActionCommon
// * @memberof Core.Agent
// * @author OTRS AG
// * @description
// *      This namespace contains special module functions for AgentTicketActionCommon.
// */
//Core.Agent.TicketActionCommon = (function (TargetNS) {
/**
 * @namespace Core.Agent.TicketMasterSlave
 * @memberof Core.Agent
 * @author OTRS AG
 * @description
 *      This namespace contains special module functions for TicketMasterSlave.
 */
Core.Agent.TicketMasterSlave = (function (TargetNS) {
// ---

    /**
     * @name Init
     * @memberof Core.Agent.TicketActionCommon
     * @function
     * @description
     *      This function initializes the module functionality.
     */
    TargetNS.Init = function () {

        var DynamicFieldNames = Core.Config.Get('DynamicFieldNames'),
            Fields = ['TypeID', 'ServiceID', 'SLAID', 'NewOwnerID', 'NewResponsibleID', 'NewStateID', 'NewPriorityID'],
            ModifiedFields;

        // Bind events to specific fields
        $.each(Fields, function(Index, Value) {
            ModifiedFields = Core.Data.CopyObject(Fields).concat(DynamicFieldNames);
            ModifiedFields.splice(Index, 1);

            FieldUpdate(Value, ModifiedFields);
        });

        // Bind event to Queue field.
        $('#NewQueueID').on('change', function () {
            Core.AJAX.FormUpdate($('#Compose'), 'AJAXUpdate', 'NewQueueID', ['TypeID', 'ServiceID', 'NewOwnerID', 'NewResponsibleID', 'NewStateID', 'NewPriorityID', 'StandardTemplateID'].concat(DynamicFieldNames));
        });

        // Bind event to StandardTemplate field.
        $('#StandardTemplateID').on('change', function () {
            Core.Agent.TicketAction.ConfirmTemplateOverwrite('RichText', $(this), function () {
                Core.AJAX.FormUpdate($('#Compose'), 'AJAXUpdate', 'StandardTemplateID', ['RichTextField']);
            });
            return false;
        });

        // Bind click event to CreateArticle checkbox and toggle widget.
        $('#CreateArticle, #WidgetArticle .WidgetAction.Toggle').on('click', function () {
            $('#WidgetArticle .Validate_DependingRequiredAND.Validate_Depending_CreateArticle').each(function (Index, Element) {
                var $Element = $(Element);
                var ClosestClass = 'Field';
                if ($Element.attr('id') === 'RichText') {
                    ClosestClass = 'RichTextField';
                }
                if ($('#CreateArticle').prop('checked') && $('#WidgetArticle').hasClass('Expanded')) {
                    $Element.closest('.' + ClosestClass)
                        .prev('label')
                        .addClass('Mandatory')
                        .prepend('<span class="Marker">*</span>');
                }
                else {
                    $Element.closest('.' + ClosestClass)
                        .prev('label')
                        .removeClass('Mandatory')
                        .find('span')
                        .remove();
                    Core.Form.Validate.UnHighlightError(Element);
                }
            });
        });

        // Initialize the ticket action popup.
        Core.Agent.TicketAction.Init();
    };

    /**
     * @private
     * @name FieldUpdate
     * @memberof Core.Agent.TicketActionCommon
     * @function
     * @param {String} Value - FieldID
     * @param {Array} ModifiedFields - Fields
     * @description
     *      Create on change event handler
     */
    function FieldUpdate (Value, ModifiedFields) {
        $('#' + Value).on('change', function () {
            Core.AJAX.FormUpdate($('#Compose'), 'AJAXUpdate', Value, ModifiedFields);
        });
    }

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
// ---
// OTRSMasterSlave
// ---
//}(Core.Agent.TicketActionCommon || {}));
}(Core.Agent.TicketMasterSlave || {}));
// ---
