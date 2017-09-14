// --
// Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (AGPL). If you
// did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
// --

"use strict";

var TimeAccounting = TimeAccounting || {};

/**
 * @namespace TimeAccounting.Agent.Reporting
 * @author OTRS AG
 * @description
 *      This namespace contains the special module functions for TimeAccounting.
 */
TimeAccounting.Agent.Reporting = (function (TargetNS) {

    TargetNS.Init = function () {

        var $MasterActionLink;

        $('#NavigationSelect').bind('click', function(){
            $('#DateSelectionForm').submit();
        });

        $('.MasterAction').bind('click', function (Event) {
            $MasterActionLink = $(this).parents().find('.MasterActionLink' + $(this).attr('data-project-id'));
            // only act if the link was not clicked directly
            if (Event.target !== $MasterActionLink.get(0)) {
                window.location = $MasterActionLink.attr('href');
                return false;
            }
        });

        $('.MasterActionUser').bind('click', function (Event) {
            $MasterActionLink = $(this).find('.MasterActionLink');
            // only act if the link was not clicked directly
            if (Event.target !== $MasterActionLink.get(0)) {
                window.location = $MasterActionLink.attr('href');
                return false;
            }
        });
    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;

}(TimeAccounting.Agent.Reporting || {}));
