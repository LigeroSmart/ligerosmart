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
 * @exports TargetNS as Survey.Agent.SurveyOverview
 * @description
 *      This namespace contains the special module functions for SurveyOverview.
 */
Survey.Agent.SurveyOverview = (function (TargetNS) {
    /**
     * @name Init
     * @memberof Survey.Agent.SurveyOverview
     * @function
     * @description
     *      Init edit survey screen.
     */
    TargetNS.Init = function () {
        $('#SurveySearch').bind('click', function (Event) {
            Core.UI.Dialog.ShowContentDialog($('#SurveyOverviewSettingsDialogContainer'),
                Core.Language.Translate("Settings"), '20%', 'Center', true,
                [
                    {
                        Label: Core.Language.Translate("Submit"),
                        Type: 'Submit',
                        Class: 'Primary'
                    }
                ]
            );

            Event.preventDefault();
            Event.stopPropagation();
            return false;
        });

        // bind the ContextSettingsDialogContainer
        $('#ShowContextSettingsDialog').on('click', function (Event) {
            Core.UI.Dialog.ShowContentDialog($('#ContextSettingsDialogContainer'), Core.Language.Translate("Settings"), '20%', 'Center', true,
                [
                    {
                        Label: Core.Language.Translate("Submit"),
                        Type: 'Submit',
                        Class: 'Primary'
                    }
                ]
            );
            Event.preventDefault();
            Event.stopPropagation();
            return false;
        });

        Core.UI.ActionRow.Init();

        $('.MasterAction').on('click', function (Event) {
            var $MasterActionLink = $(this).find('.MasterActionLink');
            // only act if the link was not clicked directly
            if (Event.target !== $MasterActionLink.get(0)) {
                window.location = $MasterActionLink.attr('href');
                return false;
            }
        });

        // bind the ContextSettingsDialogContainer
        $('#SurveySearch').on('click', function (Event) {
            Core.UI.Dialog.ShowContentDialog($('#SurveyOverviewSettingsDialogContainer'),
                Core.Language.Translate("Settings"), '20%', 'Center', true,
                [
                    {
                        Label: Core.Language.Translate("Submit"),
                        Type: 'Submit',
                        Class: 'Primary'
                    }
                ]
            );
            Event.preventDefault();
            Event.stopPropagation();
            return false;
        });
    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(Survey.Agent.SurveyOverview || {}));
