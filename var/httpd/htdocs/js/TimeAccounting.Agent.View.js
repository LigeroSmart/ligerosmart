// --
// Copyright (C) 2001-2018 OTRS AG, http://otrs.com/
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (AGPL). If you
// did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
// --

"use strict";

var TimeAccounting = TimeAccounting || {};

/**
 * @namespace TimeAccounting.Agent.View
 * @author OTRS AG
 * @description
 *      This namespace contains the special module functions for TimeAccounting.
 */
TimeAccounting.Agent.View = (function (TargetNS) {

    TargetNS.Init = function () {

        $('#NavigationSelect').bind('click', function(){
            $('#DateSelectionForm').submit();
        });
    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;

}(TimeAccounting.Agent.View || {}));
