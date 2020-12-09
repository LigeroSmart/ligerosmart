// --
// Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (GPL). If you
// did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
// --

"use strict";

var ITSM = ITSM || {};

/**
 * @namespace GeneralCatalog
 * @author OTRS AG
 * @description
 *      This namespace contains the special module function for General Catalog.
 */
 ITSM.GeneralCatalog = (function (TargetNS) {

    /**
     * @name Init
     * @memberof GeneralCatalog
     * @function
     * @description
     *      This function initializes actions for General Catalog.
     */
    TargetNS.Init = function() {

        if (typeof Core.Config.Get('WarningIncidentState') !== 'undefined'
            && parseInt(Core.Config.Get('WarningIncidentState'), 10) === 1
        ) {
            $('#Submit').click(function(Event){
                var Functionality = $('#Functionality').val(),
                    ValidID       = $('#ValidID').val();

                Event.preventDefault();

                if (Functionality === 'warning' && ValidID != '1') {
                    Core.UI.Dialog.ShowDialog({
                        Modal: true,
                        Title: Core.Language.Translate('Warning'),
                        HTML: '<p>' + Core.Language.Translate('Warning incident state can not be set to invalid.') + '</p>',
                        PositionTop: '15%',
                        PositionLeft: 'Center',
                        CloseOnEscape: false,
                        CloseOnClickOutside: false,
                        Buttons: [
                            {
                                Label: Core.Language.Translate('Cancel'),
                                Function: function () {
                                    Core.UI.Dialog.CloseDialog($('.Dialog:visible'));
                                }
                            },
                        ]
                    });

                }
                else {
                    $(this).closest('form').trigger('submit');
                }
            });
        }
    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(ITSM.GeneralCatalog || {}));
