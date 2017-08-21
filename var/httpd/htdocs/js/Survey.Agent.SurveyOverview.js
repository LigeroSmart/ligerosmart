// --
// Copyright (C) 2001-2017 OTRS AG, http://otrs.com/\n";
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (AGPL). If you
// did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
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
        $('#SurveySearch').on('click', function () {
            Core.Agent.Search.OpenSearchDialog('AgentSurveySearch', Core.Config.Get("JSData.Profile"));
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
    };

    return TargetNS;
}(Survey.Agent.SurveyOverview || {}));
