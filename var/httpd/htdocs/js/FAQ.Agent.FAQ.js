// --
// Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (GPL). If you
// did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
// --

"use strict";

var FAQ = FAQ || {};
FAQ.Agent = FAQ.Agent || {};

/**
 * @namespace
 * @exports TargetNS as FAQ.Agent.FAQ
 * @description
 *      This namespace contains the special module functions for FAQ.
 */
FAQ.Agent.FAQ = (function (TargetNS) {

    /**
     * @name Init
     * @memberof FAQ.Agent.FAQ
     * @function
     * @description
     *      This function initialize the FAQ module.
     */
    TargetNS.Init = function() {
        var FAQSearchProfile = Core.Config.Get('FAQSearchProfile');

        // Prevent too fast submitions that could lead into no changes sent to server,
        // due to RTE to textarea data transfer
        $('#FAQSubmit').on('click', function () {
            window.setTimeout(function () {
                $('#FAQSubmit').closest('form').submit();
            }, 250);
        });

        $('#AgentFAQSearch').on('click', function () {
            Core.Agent.Search.OpenSearchDialog('AgentFAQSearch');
            return false;
        });

        if (FAQSearchProfile !== 'undefined') {
            $('#FAQSearch').on('click', function () {
                Core.Agent.Search.OpenSearchDialog(Core.Config.Get('Action'), FAQSearchProfile);
                return false;
            });
        }

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

        if (Core.Config.Get('AgentFAQSearch') === 1) {
            Core.Agent.Search.OpenSearchDialog(Core.Config.Get('Action'), FAQSearchProfile);
        }
    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(FAQ.Agent.FAQ || {}));
