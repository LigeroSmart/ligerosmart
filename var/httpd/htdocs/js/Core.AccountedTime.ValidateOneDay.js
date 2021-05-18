// --
// Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (AGPL). If you
// did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
// --

"use strict";

var Core = Core || {};


/**
 * @namespace Core.AccountedTimeOneDay
 * @memberof Core.AccountedTimeOneDay
 * @author OTRS AG
 * @description
 *      This namespace contains all form functions.
 */
Core.AccountedTimeOneDay = (function (TargetNS) {

	var count = 0;
    /**
     * @name Valid
     * @memberof Core.AccountedTimeOneDay
     * @function
     * @param {jQueryObject} $Form - The form object that should be disabled.
     * @description
     *      This function is used to disable all the elements of a Form object.
     */
    TargetNS.Valid = function ($Form) {
	        // If no form is given, disable validation in all form elements on the complete site
	        //
	
		var Ini = "";
		var End = "";
	 	var AJAXData = {
			Action : 'CustomFields',
			Subaction :'AjaxFields'
		};
		Core.AJAX.FunctionCall(Core.Config.Get('CGIHandle'),AJAXData, function (Response) {
			Ini = Response.Ini;
			End = Response.End;
	
			$('form').find("[id^=DynamicField_"+End+"]").addClass("Validate_DateInSameDay_Compare");

			if($('form').find("#DynamicField_"+Ini+"Month").length > 0 && $('form').find("#DynamicField_"+End+"Month").size()> 0 )
			{
				 Core.Form.Validate.AddRule("Validate_DateInSameDay_Compare",{Validate_DateInSameDay_Compare:true});
		
				 Core.Form.Validate.AddMethod("Validate_DateInSameDay_Compare", function (Value, Element, Element2) {
					var selectField = ["Month","Day","Year","Hour","Minute"];
					var dateIni = "";
					var dateEnd = "";
					var dataCompare = "";
					for(var i=0;i<selectField.length;i++){
						var separator = "/";
						if(selectField[i] == 'Hour'){
							separator = ":";
						}else if(selectField[i] == 'Year' || selectField[i] == 'Minute'){
							separator = " ";
						}
						dateIni += $("#DynamicField_"+Ini+""+selectField[i]).val() + "" + separator;
						dateEnd += $("#DynamicField_"+End+""+selectField[i]).val() + "" + separator;	
						if(i == '3'){
							dataCompare += '23' + separator; 	
						}else if(i == '4'){
							dataCompare += '59' + separator;
						}else{
							dataCompare += $("#DynamicField_"+Ini+""+selectField[i]).val() + "" + separator;	

						}
					}
	
					//Capture datetime ini
					var startTime = Date.parse(dateIni);
					var endTime =  Date.parse(dateEnd);
					var compareTime = Date.parse(dataCompare);
					if( endTime > compareTime){
					  return false;
					}
					return true;
	    		}, "");
			}	
		});	
	};
	if($("form").find(".Validate_DateDay").length > 0){
			TargetNS.Valid(this);
	}
    return TargetNS;
}(Core.AccountedTimeOneDay || {}));
