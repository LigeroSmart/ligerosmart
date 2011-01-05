// --
// TimeAccounting.Agent.EditTimeRecords.js - provides the special module functions for the
// edit screen
// Copyright (C) 2001-2011 OTRS AG, http://otrs.org/\n";
// --
// $Id: Core.UI.ComboBox.js,v 1.1 2011-01-05 11:48:56 mn Exp $
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (AGPL). If you
// did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
// --

"use strict";

var Core = Core || {};
Core.UI = Core.UI || {};

/**
 * @namespace
 * @exports TargetNS as Core.UI.ComboBox
 * @description
 *      This namespace contains the functions for the combobox element.
 */
Core.UI.ComboBox = (function (TargetNS) {
    /**
     * @function
     * @param {String} Selector The jQuery selector for the elements that should be initialized as comboboxes
     * @param {Object} Options The additional options for the combobox:
     *                      class: a string with the class(es) to be added to the input field of the combobox
     *                      lang: an object with key/value pairs of translations for the combobox
     * @description
     *      This function initializes the comboboxes
     * @return nothing
     */
    TargetNS.Init = function (Selector, Options) {
        Selector = Selector || 'select';
        $(Selector).combobox(Options);
    };

    return TargetNS;
}(Core.UI.ComboBox || {}));
