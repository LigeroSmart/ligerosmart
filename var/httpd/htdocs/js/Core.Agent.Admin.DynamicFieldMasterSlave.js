// --
// Copyright (C) 2001-2018 OTRS AG, https://otrs.com/
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (GPL). If you
// did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
// --

"use strict";

var Core = Core || {};
Core.Agent = Core.Agent || {};
Core.Agent.Admin = Core.Agent.Admin || {};

/**
 * @namespace Core.Agent.Admin.DynamicFieldMasterSlave
 * @memberof Core.Agent.Admin
 * @author OTRS AG
 * @description
 *      This namespace contains the special functions for SystemConfiguration module.
 */
 Core.Agent.Admin.DynamicFieldMasterSlave = (function (TargetNS) {

    $('.ShowWarning').bind('change keyup', function () {
        $('p.Warning').removeClass('Hidden');
    });
    Core.Agent.Admin.DynamicField.ValidationInit();

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(Core.Agent.Admin.DynamicFieldMasterSlave || {}));
