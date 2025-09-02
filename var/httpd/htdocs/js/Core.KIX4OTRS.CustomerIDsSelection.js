// --
// Core.KIX4OTRS.CustomerIDsSelection.js - provides special functions for 
// customer IDs selection in the agents frontend
// Copyright (C) 2006-2011 c.a.p.e. IT GmbH, http://www.cape-it.de
//
// written/edited by:
//   Martin(dot)Balzarek(at)cape-it.de
//   Stefan(dot)Mehlig(at)cape-it.de
//   Rene(dot)Boehm(at)cape-it.de
// --
// $Id: Core.KIX4OTRS.CustomerIDsSelection.js,v 1.1 2011-08-24 14:02:17 maba Exp $
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (AGPL). If you
// did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
// --

"use strict";

var Core = Core || {};
Core.KIX4OTRS = Core.KIX4OTRS || {};

/**
 * @namespace
 * @exports TargetNS as Core.KIX4OTRS.CustomerIDsSelection
 * @description
 *      This namespace contains special functions for customer IDs selection in the agents frontend.
 */
Core.KIX4OTRS.CustomerIDsSelection = (function (TargetNS) {
	
    /**
     * @function
     * @return nothing
     *      This function initializes the customer ID selection
     */
    TargetNS.Init = function () {
        var $CustomerIDs = $('.SelectedCustomerIDRadio'),
            $CustomerID  = $('#CustomerID');

        if (!$CustomerIDs.length || !$CustomerID.length) return; 

        $CustomerIDs.bind('click', function () {
            $CustomerID.val( $(this).val() );
        });
    };

    // init
    $(document).ready( function() {
        if ($('.SelectedCustomerIDRadio').length) Core.KIX4OTRS.CustomerIDsSelection.Init();
    });

    return TargetNS;
}(Core.KIX4OTRS.CustomerIDsSelection || {}));