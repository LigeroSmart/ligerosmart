// --
// Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (GPL). If you
// did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
// --

"use strict";

var ITSM = ITSM || {};
ITSM.GeneralCatalog = ITSM.GeneralCatalog || {};


/**
 * @namespace GeneralCatalog
 * @author OTRS AG
 * @description
 *      This namespace contains the special module function for the General Catalog Color Picker module.
 */
 ITSM.GeneralCatalog.JSColorPicker = (function (TargetNS) {

    /**
     * @name Init
     * @memberof GeneralCatalog.ColorPicker
     * @function
     * @description
     *      This function initializes actions for General Catalog.
     */
    TargetNS.Init = function() {

        /*global jscolor: true */
        jscolor.dir = Core.Config.Get('GeneralCatalog::Frontend::JSColorPickerPath');
        jscolor.bindClass = 'JSColorPicker';
        jscolor.install();
    };

    Core.Init.RegisterNamespace(TargetNS, 'JS_LOADED');

    return TargetNS;
}(ITSM.GeneralCatalog.JSColorPicker || {}));
