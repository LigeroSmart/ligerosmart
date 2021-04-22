// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (AGPL). If you
// did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
// --

"use strict";

var Core = Core || {};
Core.Agent = Core.Agent || {};

/**
 * @namespace Core.Agent.Popup
 * @memberof Core.Agent
 * @author Complemento
 * @description
 *      This namespace contains the special module functions for Maximize functionality.
 */
 Core.Agent.MaximizePopup = (function (TargetNS) {

    /**
     * @name Init
     * @memberof Core.Agent.MaximizePopup
     * @function
     * @description
     *      This function binds click event on checkbox.
     */
    TargetNS.Init = function () {
		// Actions which window should be maximized
		var myActions = ["AgentTicketCompose",
						 "AgentTicketNote",
						 "AgentTicketOwner",
						 "AgentTicketCustomer",
						 "AgentTicketFreeText",
						 "AgentTicketPhoneOutbound",
						 "AgentTicketPhoneInbound",
						 "AgentTicketAskApproval",
						 "AgentTicketDecisionMove",
						 "AgentTicketMove",
						 "AgentTicketEmailOutbound",
						 "AgentTicketPriority",
						 "AgentLinkObject",
						 "AgentTicketProcess",
						 "AgentTicketPending",
						 "AgentTicketClose"];
				
		if(myActions.indexOf(Core.Config.Get('Action'))>-1){
			window.moveTo(0,0);
			window.resizeTo(top.screen.availWidth, top.screen.availHeight);
		}
	};


    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
 }(Core.Agent.MaximizePopup || {}));




