// --
// Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
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
 * @namespace Core.Agent.Admin
 * @memberof Core.Agent
 * @author OTRS AG
 */

/**
 * @namespace Core.Agent.Admin.CustomerContract
 * @memberof Core.Agent.Admin
 * @author OTRS AG
 * @description
 *      This namespace contains the special module functions for the ACL module.
 */
Core.Agent.Admin.CustomerContract = (function (TargetNS) {

    /**
     * @name Init
     * @memberof Core.Agent.Admin.CustomerContract
     * @function
     * @description
     *      This function initialize the module.
     */
    TargetNS.Init = function() { 
        var Subaction = Core.Config.Get('Subaction');       

        InitCustomerContractsRules();        

        TargetNS.HideForms();
    };
    
    /**
     * @name HideForms
     * @memberof Core.Agent.Admin.CustomerContract
     * @function
     * @description
     *      Closes overlay and restores normal view.
     */
     TargetNS.HideForms = function () {
        $("form.formAddRule").css({
            'display': 'none'
        });      
    };    

    /**
     * @private
     * @name InitProcessPopups
     * @memberof Core.Agent.Admin.CustomerContract
     * @function
     * @description
     *      Initializes needed popup handler.
     */
    function InitCustomerContractsRules() {
        var BorrowedViewJS = Core.Config.Get('BorrowedViewJS'),
            OverviewUpdate = Core.Config.Get('OverviewUpdate'),
            EditFranchiseRole = Core.Config.Get('EditFranchiseRole'),
            EditPriceRole = Core.Config.Get('EditPriceRole');        

        $("#btnNewPriceRule").on("click",function(Event){
            $("#formAddPriceRule").show();
            $("#btnNewPriceRule").hide();

            Event.preventDefault();
            return false;
        });

        $("#btnCancelAddPriceRule").on("click",function(Event){
            $("#formAddPriceRule").hide();
            $("#btnNewPriceRule").show();

            Event.preventDefault();
            return false;
        });

        $("#btnNewFranchiseRule").on("click",function(Event){
            $("#formAddFranchiseRule").show();
            $("#btnNewFranchiseRule").hide();

            Event.preventDefault();
            return false;
        });

        $("#btnCancelAddFranchiseRule").on("click",function(Event){
            $("#formAddFranchiseRule").hide();
            $("#btnNewFranchiseRule").show();

            Event.preventDefault();
            return false;
        });
        
        $("#FromDateEdit").on("click",function(Event){
            $('div.FromDateEdit').css({'display':''});
            $('div.FromDateNoEdit').css({'display':'none'});

            Event.preventDefault();
            return false;
        }); 

        $("#ToDateEdit").on("click",function(Event){
            $('div.ToDateEdit').css({'display':''});
            $('div.ToDateNoEdit').css({'display':'none'});

            Event.preventDefault();
            return false;
        });         
        
        $("#ToDateEdit").on("click",function(Event){
            $("#formAddFranchiseRule").hide();
            $("#btnNewFranchiseRule").show();

            Event.preventDefault();
            return false;
        });         

        if (typeof EditFranchiseRole !== 'undefined') {
            $("#btnNewFranchiseRule").hide();
            $("#ZonePriceRule").hide();
            $("#ZoneCustomer").hide();
        } else if (typeof EditPriceRole !== 'undefined') {
            $("#btnNewPriceRule").hide();
            $("#ZoneFranchiseRule").hide();
            $("#ZoneCustomer").hide();
        }         

        if (typeof BorrowedViewJS !== 'undefined') {
            $('#CustomerTable a').bind('click', function (Event) {
                Core.Agent.TicketAction.UpdateCustomer($(this).text());

                Event.preventDefault();
                return false;
            });
        }

        if (typeof OverviewUpdate !== 'undefined') {
            TargetNS.SetViewDateType();
            $('input[name=DateType]').on('change',function(){TargetNS.SetViewDateType();});        
        }

        $('span.Actions').css({
            'white-space':'nowrap'
        });  
        
        $('div.ToDateEdit').css({
            'display':'none'
        });

        $('div.FromDateEdit').css({
            'display':'none'
        });        

    };

    /**
     * @name SetViewDateType
     * @memberof Core.Agent.Admin.CustomerContract
     * @function
     * @description
     *      Closes overlay and restores normal view.
     */
     TargetNS.SetViewDateType = function (){
        if($('input[name=DateType]:checked').val() == 0){
            $(".relativePeriodContent").hide();
            $(".absolutPeriodContent").show();
        }
        else{
            $(".relativePeriodContent").show();
            $(".absolutPeriodContent").hide();
        }
    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(Core.Agent.Admin.CustomerContract || {}));
