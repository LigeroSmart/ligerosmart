// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (AGPL). If you
// did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
// --
"use strict";

var Core = Core || {};
Core.Agent = Core.Agent || {};
Core.Agent.DynamicFieldByServicePreLoad = {};
Core.Agent.DynamicFieldByServiceLastFocus = null;
Core.Agent.DynamicFieldByServiceLastChangedElement = null;
Core.Agent.DynamicFieldByServiceLastKey = null;
Core.Agent.checkLigeroForms;
Core.Agent.DynamicFieldByService = (function (TargetNS) {

	/**
	 * @name Init
	 * @memberof Core.Agent.TicketProcess
	 * @function
	 * @description
	 *      This function initializes the special module functions.
	 */
	TargetNS.Init = function () {
		// Aux variables to control form flow
		var arrayJSON;
		var objectJSON;
		var reloadFields = "";
		var uploadFields = {};

		// Trigger service change event in order to auto load form definitions for the given Service ID
		$('#ServiceID').trigger("change");

		// Function responsible to monitor Ligero Forms fields 
		var checkLigeroForms = function(webAction) {
			return function() {
				// If Service was defined
				if ($('#ServiceID').val()) {
					$('.InputField_Search').attr("aria-expanded","true");
					// Core.UI.InputFields.Deactivate();
					// Identify interfaceName ( used to detect which fields will be visible per interface )
					var formID = "";
					$("form").each(function () {
						if ($(this).attr("name") == "compose") {
							formID = $(this).attr("id");
						}

					});

					// Prepare Data to be sent on AJAX requests
					var Data = {
						Action:           'DynamicFieldByService',
						OriginalAction:   Core.Config.Get('Action'),
						Subaction:        webAction,
						ServiceDynamicID: $('#ServiceID').val(),
						InterfaceName:    formID,
						IsAjaxRequest:    1,
						IsMainWindow:     1
					};
					if (!Core.Config.Get('SessionIDCookie')) {
						Data[Core.Config.Get('SessionName')] = Core.Config.Get('SessionID');
						Data[Core.Config.Get('CustomerPanelSessionName')] = Core.Config.Get('SessionID');
					}
					Data.ChallengeToken = Core.Config.Get('ChallengeToken');

					// If ACL check, use a different POST format
					if (webAction == 'HideAndShowDynamicFields') {
						var QueryString = '';
						$.each(Data, function (Key, Value) {
							QueryString += ';' + encodeURIComponent(Key) + '=' + encodeURIComponent(Value);
						});
						Data = Core.AJAX.SerializeForm($('#' + formID), Data) + QueryString;
					}

					// Request form content
					Core.AJAX.FunctionCall(
						Core.Config.Get('CGIHandle'),
						Data,
						function (Response) {
							// No data? bye bye
							if (Response == 0) {
								cleanOldLigeroFormFields();
								Core.UI.InputFields.Deactivate();
								Core.UI.InputFields.Activate();
								return;
							}

							// Get values/attributes for current fields to keep already filled data
							try {
								$(Response).find('.AddDFS').each(function() {
									var dfsID = $(this).attr('id');
									$('#' + dfsID).not('.AddDFS').each(function() {
										Core.Agent.DynamicFieldByServicePreLoad[ dfsID ] = {
											value: $(this).val(),
											attr:  $(this).attr('class')
										};
										$(this).parent().parent().remove();
									});
								});
							} catch(e) {}
							Core.Agent.DynamicFieldByServicePreLoad[ 'Message' ] = {
								value: $('#RichText').val()
							};

							// Keep upload form fields
							$('.AddDFS').each(function () {
								var $that = $(this);
								if ($that.is(':file'))
									uploadFields[ $that.attr('id') ] = $that.clone();
							});

							// Parse ajax response
							var res    = Response.split(':$$:Add:$$:');
							Response   = res[0];
							arrayJSON  = res[1].split('@%@%@');

							// Define some local variables in order to insert the form fields inside de DOM
							var i;
							reloadFields              = "";
							var AgentFieldConfigInsert    = ".SpacingTop:first";
							var CustomerFieldConfigInsert = "#BottomActionRow";

							// Set default values for the Service Form fields,
							// before adding them to the DOM. Also add fields to reloadFields
							// variable
							for (i = 0; i < arrayJSON.length; i++) {
								objectJSON = $.parseJSON(arrayJSON[i]);
								$.each(objectJSON, function (key, val) {
									if (key && val) {
										if (key === "Message" && val.trim().length) {
											window.CKEDITOR.instances['RichText'].on('instanceReady', function() { 
												window.CKEDITOR.instances['RichText'].setData(val);
											});

											// The following line is needed because when the service is changed
											// the code above is not triggered since 'instanceReady' will not be
											// triggered again.
											window.CKEDITOR.instances['RichText'].setData(val);
											reloadFields += "" + key + ",";
										} else if (key === "HideArticle" && val === '1'&& Core.Config.Get('Action').search(/^Customer/)>-1 ) {
											$('#Subject').parent().hide();
											$('.RichTextHolder').hide();
											$('.DnDUploadBox').parent().parent().hide();
										} else if (key === "AgentFieldConfig") {
											AgentFieldConfigInsert = "" + val + "";
										} else if ($('#' + key).length > 0) {
											reloadFields += "" + key + ",";
											$('#' + key).val(val);
										}
										if (key === "CustomerFieldConfig") {
											CustomerFieldConfigInsert = "" + val + "";
										}
									}
								});
							}
							reloadFields = reloadFields.substring(0, reloadFields.length - 1);

							// Takes the placement for the fields
							var FieldConfigInsert = "";
							if (formID === "NewCustomerTicket"){
								FieldConfigInsert = CustomerFieldConfigInsert;
							}
							else {
								FieldConfigInsert = AgentFieldConfigInsert;
							}
							// Remove Form fields from last selected service
							cleanOldLigeroFormFields();

							// Insert fields on DOM and restore form fields
							var $ElementToUpdate = $(Response).insertBefore(FieldConfigInsert);
							Object.keys( uploadFields ).forEach( function(i,v) {
								$("#"+i).replaceWith( uploadFields[i] );
							});

							// Refresh DOM
							Core.UI.InputFields.Deactivate();
							Core.UI.InputFields.Activate();

							// Loop through updated elements to perform the following actions
							// 
							// 1) Execute additional JS code ( tag <script> )
							// 2) Apply visual effects ( fadeIn )
							// 3) Display errors ( if special field is available ) 
							// 4) Bind additional control events
							// 5) Fill preLoaded values/attributes
							var JavaScriptString = '';
							var ErrorMessage;
							if ($ElementToUpdate && isJQueryObject($ElementToUpdate) && $ElementToUpdate.length) {

								// JS Execution
								$ElementToUpdate.find('script').each(function () {
									JavaScriptString += $(this).html();
									$(this).remove();
								});
								try {
									/*eslint-disable no-eval */
									eval(JavaScriptString);
									/*eslint-enable no-eval */
								} catch (Event) {
									$.noop(Event);
								}

								// Handle errors
								if ($ElementToUpdate.children().first().hasClass('ServerError')) {
									ErrorMessage = $ElementToUpdate.children().first().data('message');
									// Add class ServerError to the process select element
									$('#ServiceID').addClass('ServerError');
									// Set a custom error message to the proccess select element
									$('#ProcessEntityIDServerError').children().first().text(ErrorMessage);
								}
								Core.Form.Validate.Init();

								// Bind additional control events
								Core.UI.TreeSelection.InitTreeSelection();

								// Move help triggers into field rows for dynamic fields
								$('.Row > .FieldHelpContainer').each(function () {
									if (!$(this).next('label').find('.Marker').length) {
										$(this).prependTo($(this).next('label'));
									} else {
										$(this).insertAfter($(this).next('label').find('.Marker'));
									}
								});

								// Bind Dynamic Fields control events and trigger responsive events
								Core.UI.TreeSelection.InitDynamicFieldTreeViewRestore();
								if (Core.App.Responsive.IsSmallerOrEqual(Core.App.Responsive.GetScreenSize(), 'ScreenL'))
									Core.App.Publish('Event.App.Responsive.SmallerOrEqualScreenL');

								// Fill preLoaded data
								jQuery.each( Core.Agent.DynamicFieldByServicePreLoad, function( oKey, oObj ) {
									if (oKey == 'Message' && oObj.value.length) {
										window.CKEDITOR.instances['RichText'].on('instanceReady', function() { 
											window.CKEDITOR.instances['RichText'].setData(oObj.value);
										});
										window.CKEDITOR.instances['RichText'].setData(oObj.value);
									} else {
										$( '#' + oKey ).val( oObj.value ).attr('class',oObj.attr);
									}
								});
								Core.Agent.DynamicFieldByServicePreLoad = {};

								// Bind change events for new fields in order to trigger form update
								$(".AddDFS").not('.RemoveDFS').each(function () {

									// Ignore some fields
									if ($(this).hasClass('DateSelection') || $(this).hasClass('Validate_MaxLength'))
										return true;

									// Get formID
									var formID = "";
									$("form").each(function () {
										if ($(this).attr("name") == "compose") {
											formID = $(this).attr("id");
										}
									});

									// Get all inputs inside the given form
									var $inputs = $('#' + formID + ' :input');
									var ids = [];
									$inputs.each(function (index) {
										if (typeof $(this).attr('id') != 'undefined' &&
											typeof $(this).attr('name') != 'undefined') {
											ids.push($(this).attr('id'));
										}
									});

									// Prevent fileUpload reset
									var index = ids.indexOf('FileUpload');
									if (index !== -1) ids.splice(index, 1);

									// Trigger field update event
									var id = $(this).attr('id');
									$("#" + id).bind('change',function(e) {
										Core.Agent.DynamicFieldByServiceLastChangedElement = id;
									});
								});
							} else {
								$('#AJAXLoader').addClass('Hidden');
							}

							// Restore last focused field
							//setTimeout(restoreLastFocus(), 100);

							// Bind change events on dynamic fields in order to check ACLs
							// Exclude Modernized fields search from our filter
							$("[id^='DynamicField_'][data-ligeroform!='ok']:not(.InputField_Search)").each(function () {
									$(this)
									.bind('change', checkLigeroForms('HideAndShowDynamicFields') )
							});
							$("[id^='DynamicField_'][data-ligeroform!='ok']").each(function () {
								$(this)
								.bind('focus.jstree',  storeLigeroFormLastFocus)
								.attr('data-ligeroform', 'ok');
						});
					}, 'html');
				} else {
					// No service was selected
					cleanOldLigeroFormFields();

					// Clean ( possible cached ) data for current fields
					if(reloadFields.length){
						var arrayFieldsClean = reloadFields.split(',');
						var i;
						for (i = 0; i < arrayFieldsClean.length; i++) {
							if (arrayFieldsClean[i] === "Message") {
								window.CKEDITOR.instances['RichText'].setData('');
							} else if ($('#' + arrayFieldsClean[i]).length > 0) {
								$('#' + arrayFieldsClean[i]).val('');
							}
						}
						// Trigger form update events
						Core.AJAX.FormUpdate($('#' + formID), 'AJAXUpdate', 'ServiceID', [reloadFields]);
						$('#Subject').parent().show();
						$('.RichTextHolder').show();
						$('.DnDUploadBox').parent().parent().show();
						$('#AJAXLoaderSubject\\,Message').hide();
					}
				}
				return false;
			};
		};

		// Clean old Ligero Form fields to prevent duplicated fields
		var cleanOldLigeroFormFields = function() {
			$('.AddDFS').each(function () {
				var $that = $(this);
				$that.parents('.Row').remove();
			}).addClass('RemoveDFS');
			window.CKEDITOR.instances['RichText'].setData('');
		};

		// Store last focused field
		var storeLigeroFormLastFocus = function(e) {
			if(typeof e !== 'undefined' && typeof e.target.id !== 'undefined'){
				var ModernizeSubelement = /_anchor$/;
				var NewFocus = ''
				if(ModernizeSubelement.test(e.target.id)){
					NewFocus = $('#'+e.target.id).parent().parent().parent().attr('id');
					NewFocus = NewFocus.replace('_Select','_Search');
				} else {
					NewFocus = e.target.id
				}
				Core.Agent.DynamicFieldByServiceLastFocus = NewFocus;
			}
		};

		var restoreLastFocus = function(e) {
			// @TODO: tratar a tecla TAB para casos onde há carregamento de novos campos a partir de ACLs
			//			do hide and show, para que o foco não pule o próximo campo
			// if (Core.Agent.DynamicFieldByServiceLastKey !== null
			// 	&& Core.Agent.DynamicFieldByServiceLastKey == 'TAB'){
			// 		console.log('TAB Key')
			// 	} else {
					// RR: Coloquei com o setTimeout para deixar essa função assincrona. O resultado foi melhor
					// pois chamando direto fazia com que o campo modernized ocultasse a caixa de seleção
					if(Core.Agent.DynamicFieldByServiceLastFocus !== null){
						$('.jstree').parent().parent().remove();
						console.log('olha ai '+Core.Agent.DynamicFieldByServiceLastFocus);

						var setFocus = function(element){
							$('#'+element).focus();
						}
						setTimeout(setFocus(Core.Agent.DynamicFieldByServiceLastFocus), 400);
					}
				// }
		}

		var restoreLastFocusFromCallBack = function(id){
			if(Core.Agent.DynamicFieldByServiceLastFocus !== null
				&& Core.Agent.DynamicFieldByServiceLastFocus.replace('_Search','').replace('_Select','') == id){
				// Restore last focused field
				setTimeout(restoreLastFocus(), 0);
			}
		}

		// Sotre the last elements
		var FormsKey = function(Event){
			if(
			typeof Event !== 'undefined'
			&& Event.which === $.ui.keyCode.TAB) {
				Core.Agent.DynamicFieldByServiceLastKey = 'TAB';
			} else {
				Core.Agent.DynamicFieldByServiceLastKey = '';
			}
			storeLigeroFormLastFocus(Event);
		};
		document.addEventListener('keyup', FormsKey, true);
		document.addEventListener('keydown', FormsKey, true);
		document.addEventListener('keydpress', FormsKey, true);

		// Bind event for Service fields
		$("#ServiceID[data-ligeroform!='ok']").each(function () {
			$(this)
				.bind('change', checkLigeroForms('DisplayActivityDialogAJAX'))
				.bind('focus',  storeLigeroFormLastFocus)
				.attr('data-ligeroform', 'ok');
		});

		//console.log("CHEGUEI AQUI");
		//checkLigeroForms('HideAndShowDynamicFields');
	};

	// Register Ligero Forms in the initialization of the Action
	Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE_LATE');

	return TargetNS;
}(Core.Agent.DynamicFieldByService || {}));
