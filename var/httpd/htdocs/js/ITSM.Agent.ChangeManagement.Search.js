// --
// Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (GPL). If you
// did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
// --

"use strict";

var ITSM = ITSM || {};
ITSM.Agent = ITSM.Agent || {};
ITSM.Agent.ChangeManagement = ITSM.Agent.ChangeManagement || {};

/**
 * @namespace ITSM.Agent.ChangeManagement.Search
 * @memberof ITSM.Agent.ChangeManagement
 * @author OTRS AG
 * @description
 *      This namespace contains the special module functions for the ChangeManagement search.
 */
ITSM.Agent.ChangeManagement.Search = (function (TargetNS) {

    /**
     * @name AdditionalAttributeSelectionRebuild
     * @namespace ITSM.Agent.ChangeManagement.Search
     * @function
     * @returns {Boolean} Returns true.
     * @description
     *      This function rebuilds the selection dropdown after choosing or deleting an additional selection.
     */
    TargetNS.AdditionalAttributeSelectionRebuild = function () {

        // get original selection with all possible fields and clone it
        var $AttributeClone = $('#AttributeOrig option').clone(),
            $AttributeSelection = $('#Attribute').empty(),
            Value;

        // strip all already used attributes
        $AttributeClone.each(function () {
            Value = Core.App.EscapeSelector($(this).attr('value'));
            if (!$('#SearchInsert label#Label' + Value).length) {
                $AttributeSelection.append($(this));
            }
        });

        $AttributeSelection.trigger('redraw.InputField');

        return true;
    };

    /**
     * @name SearchAttributeAdd
     * @namespace ITSM.Agent.ChangeManagement.Search
     * @function
     * @param {String} Attribute to add.
     * @returns {Bool} returns False to cancel default link behaviour
     * @description
     *      This function adds one attributes for the search.
     */
    TargetNS.SearchAttributeAdd = function (Attribute) {
        var $Label = $('#SearchAttributesHidden label#Label' + Attribute);

        if ($Label.length) {
            $Label.prev().clone().appendTo('#SearchInsert');
            $Label.clone().appendTo('#SearchInsert');
            $Label.next().clone().appendTo('#SearchInsert')

                // bind click function to remove button now
                .find('.RemoveButton').off('click.RemoveSearchAttribute').on('click.RemoveSearchAttribute', function () {
                    var $Element = $(this).parent();
                    TargetNS.SearchAttributeRemove($Element);

                    // rebuild selection
                    TargetNS.AdditionalAttributeSelectionRebuild();

                    return false;
                });

            // set autocomple to customer type fields
            $('#SearchInsert').find('.ITSMCustomerSearch').each(function(){
                var InputID = $(this).attr('name') + 'CustomerAutocomplete';
                $(this).removeClass('ITSMCustomerSearch');
                $(this).attr('id', InputID);
                $(this).prev().attr('id', InputID + 'Selected');
                ITSM.Agent.CustomerSearch.Init($('#' + Core.App.EscapeSelector(InputID)));

                // prevent dialog closure when select a customer from the list
                $('ul.ui-autocomplete').off('click.ITSMCustomerSearch').on('click.ITSMCustomerSearch', function(Event){
                    Event.stopPropagation();
                    return false;
                });
            });

            // set autocomple to user type fields
            $('#SearchInsert').find('.ITSMUserSearch').each(function(){
                var InputID = $(this).attr('name') + 'UserAutocomplete';
                $(this).removeClass('ITSMUserSearch');
                $(this).attr('id', InputID);
                $(this).prev().attr('id', InputID + 'Selected');
                ITSM.Agent.ChangeManagement.UserSearch.Init($('#' + Core.App.EscapeSelector(InputID)));

                // prevent dialog closure when select a customer from the list
                $('ul.ui-autocomplete').off('click.ITSMUserSearch').on('click.ITSMUserSearch', function(Event){
                    Event.stopPropagation();
                    return false;
                });
            });

            // Modernize fields
            Core.UI.InputFields.Activate($('#SearchInsert'));

            // Register event for tree selection dialog
            Core.UI.TreeSelection.InitTreeSelection();

            // Initially display dynamic fields with TreeMode = 1 correctly
            Core.UI.TreeSelection.InitDynamicFieldTreeViewRestore();
        }

        return false;
    };

    /**
     * @name SearchAttributeRemove
     * @namespace ITSM.Agent.ChangeManagement.Search
     * @function
     * @param {jQueryObject} $Element The jQuery object of the form  or any element
     *      within this form check.
     * @description
     *      This function remove attributes from an element.
     */
    TargetNS.SearchAttributeRemove = function ($Element) {
        $Element.prev().prev().remove();
        $Element.prev().remove();
        $Element.remove();
    };

    /**
     * @private
     * @name SearchProfileDelete
     * @namespace ITSM.Agent.ChangeManagement.Search
     * @function
     * @param {String} Profile The profile name that will be delete.
     * @description
     *      Delete a profile via an ajax request.
     */
    function SearchProfileDelete(Profile) {
        var Data = {
            Action: 'AgentITSMChangeSearch',
            Subaction: 'AJAXProfileDelete',
            Profile: Profile
        };
        Core.AJAX.FunctionCall(
            Core.Config.Get('CGIHandle'),
            Data,
            function () {}
        );
    }

    /**
     * @private
     * @name CheckForSearchedValues
     * @namespace ITSM.Agent.ChangeManagement.Search
     * @function
     * @returns {Int} 0 if no values were found, 1 if values where there
     * @description
     *      Checks if any values were entered in the search.
     *      If nothing at all exists, it alerts with translated:
     *      "Please enter at least one search value or * to find anything"
     */
    function CheckForSearchedValues() {
        // loop through the SearchForm labels
        var SearchValueFlag = false;
        $('#SearchForm label').each(function () {
            var ElementName,
                $Element;

            // those with ID's are used for searching
            if ($(this).attr('id')) {
                    // substring "Label" (e.g. first five characters ) from the
                    // label id, use the remaining name as name string for accessing
                    // the form input's value
                    ElementName = $(this).attr('id').substring(5);
                    $Element = $('#SearchForm input[name=' + ElementName + ']');
                    // If there's no input element with the selected name
                    // find the next "select" element and use that one for checking
                    if (!$Element.length) {
                        $Element = $(this).next().find('select');
                    }
                    if ($Element.length) {
                        if ($Element.val() && $Element.val() !== '') {
                            SearchValueFlag = true;
                        }
                    }
            }
        });
        if (!SearchValueFlag) {
           alert(Core.Language.Translate('Please enter at least one search value or * to find anything.'));
        }
        return SearchValueFlag;
    }

    /**
     * @private
     * @name ShowWaitingDialog
     * @namespace ITSM.Agent.ChangeManagement.Search
     * @function
     * @description
     *      Shows waiting dialog until search screen is ready.
     */
    function ShowWaitingDialog() {
        var Content = Core.Template.Render(
            'Agent/ITSMCore/LoadingDialog',
            {
                SpanTitle: Core.Config.Get('LoadingMsg')
            }
        );

        Core.UI.Dialog.ShowContentDialog(
            Content,
            Core.Config.Get('LoadingMsg'),
            '10px',
            'Center',
            true
        );
    }

    /**
     * @name OpenSearchDialog
     * @namespace ITSM.Agent.ChangeManagement.Search
     * @function
     * @param {String} Action which is used in framework right now.
     * @param {String} Profile name.
     * @param {String} EmptySearch empty search.
     * @description
     *      This function open the search dialog after clicking on "search" button in nav bar.
     */
    TargetNS.OpenSearchDialog = function (Action, Profile, EmptySearch) {

        var Referrer = Core.Config.Get('Action'),
            Data;

        if (!Action) {
            Action = 'AgentSearch';
        }

        Data = {
            Action: Action,
            Referrer: Referrer,
            Profile: Profile,
            EmptySearch: EmptySearch,
            Subaction: 'AJAX'
        };

        ShowWaitingDialog();

        Core.AJAX.FunctionCall(
            Core.Config.Get('CGIHandle'),
            Data,
            function (HTML) {
                var Attributes;

                // if the waiting dialog was cancelled, do not show the search
                //  dialog as well
                if (!$('.Dialog:visible').length) {
                    return;
                }

                Core.UI.Dialog.ShowContentDialog(HTML, Core.Config.Get('SearchMsg'), '10px', 'Center', true, undefined, true);

                // add the search attribute fields
                Attributes = Core.Config.Get('ITSMChangeManagementSearch.Attribute') || {};
                $.each(Attributes, function(Attribute) {
                    ITSM.Agent.ChangeManagement.Search.SearchAttributeAdd(Core.App.EscapeSelector(Attribute));
                    ITSM.Agent.ChangeManagement.Search.AdditionalAttributeSelectionRebuild();
                });

                // hide add template block
                $('#SearchProfileAddBlock').hide();

                // hide save changes in template block
                $('#SaveProfile').parent().hide().prev().hide().prev().hide();

                // search profile is selected
                if ($('#SearchProfile').val() && $('#SearchProfile').val() !== 'last-search') {

                    // show delete button
                    $('#SearchProfileDelete').show();

                    // show profile link
                    $('#SearchProfileAsLink').show();

                    // show save changes in template block
                    $('#SaveProfile').parent().show().prev().show().prev().show();

                    // set SaveProfile to 0
                    $('#SaveProfile').prop('checked', false);
                }

                Core.UI.InputFields.Activate($('.Dialog:visible'));

                // register add of attribute
                $('#Attribute').on('change', function () {

                    var Attribute = $('#Attribute').val();
                    TargetNS.SearchAttributeAdd(Attribute);
                    TargetNS.AdditionalAttributeSelectionRebuild();

                    // Register event for tree selection dialog
                    $('.ShowTreeSelection').off('click.TreeSelection').on('click.TreeSelection', function () {
                        Core.UI.TreeSelection.ShowTreeSelection($(this));
                        return false;
                    });

                    return false;
                });

                // register return key
                $('#SearchForm').off('keypress.FilterInput').on('keypress.FilterInput', function (Event) {
                    if ((Event.charCode || Event.keyCode) === 13) {
                        if (!CheckForSearchedValues()) {
                            return false;
                        }
                        else {
                            $('#SearchFormSubmit').trigger('click');
                        }
                        return false;
                    }
                });

                // register submit
                $('#SearchFormSubmit').off('click.DoSearch').on('click.DoSearch', function () {
                    var ShownAttributes = '';

                    // remember shown attributes
                    $('#SearchInsert label').each(function () {
                        if ($(this).attr('id')) {
                            ShownAttributes = ShownAttributes + ';' + $(this).attr('id');
                        }
                    });
                    $('#SearchForm #ShownAttributes').val(ShownAttributes);

                    // Normal results mode will return HTML in the same window
                    if ($('#SearchForm #ResultForm').val() === 'Normal') {
                        if (!CheckForSearchedValues()) {
                            return false;
                        }
                        else {
                           $('#SearchForm').submit();
                           ShowWaitingDialog();
                        }
                    }
                    else { // Print and CSV should open in a new window, no waiting dialog
                        $('#SearchForm').attr('target', 'SearchResultPage');
                        if (!CheckForSearchedValues()) {
                            return false;
                        }
                        else {
                           $('#SearchForm').submit();
                           $('#SearchForm').attr('target', '');
                        }
                    }
                    return false;
                });

                // load profile
                $('#SearchProfile').off('change.LoadProfile').on('change.LoadProfile', function () {
                    var Profile = $('#SearchProfile').val(),
                        EmptySearch = $('#EmptySearch').val(),
                        Action = $('#SearchAction').val();

                    TargetNS.OpenSearchDialog(Action, Profile, EmptySearch);
                    return false;
                });

                // show add profile block or not
                $('#SearchProfileNew').off('click.Profile').on('click.Profile', function (Event) {
                    $('#SearchProfileAddBlock').toggle();
                    $('#SearchProfileAddName').focus();
                    Event.preventDefault();
                    return false;
                });

                // add new profile
                $('#SearchProfileAddAction').off('click.AddProfile').on('click.AddProfile', function () {
                    var Name, $Element1;

                    // get name
                    Name = $('#SearchProfileAddName').val();
                    if (!Name) {
                        return false;
                    }

                    // add name to profile selection
                    $Element1 = $('#SearchProfile').children().first().clone();
                    $Element1.text(Name);
                    $Element1.attr('value', Name);
                    $Element1.prop('selected', true);
                    $('#SearchProfile').append($Element1).trigger('redraw.InputField');

                    // set input box to empty
                    $('#SearchProfileAddName').val('');

                    // hide add template block
                    $('#SearchProfileAddBlock').hide();

                    // hide save changes in template block
                    $('#SaveProfile').parent().hide().prev().hide().prev().hide();

                    // set SaveProfile to 1
                    $('#SaveProfile').prop('checked', true);

                    // show delete button
                    $('#SearchProfileDelete').show();

                    // show profile link
                    $('#SearchProfileAsLink').show();

                    return false;
                });

                // direct link to profile
                $('#SearchProfileAsLink').off('click.ShowProfile').on('click.ShowProfile', function () {
                    var Profile = $('#SearchProfile').val(),
                        Action = $('#SearchAction').val();

                    window.location.href = Core.Config.Get('Baselink') + 'Action=' + Action +
                    ';Subaction=Search;TakeLastSearch=1;SaveProfile=1;Profile=' + encodeURIComponent(Profile);
                    return false;
                });

                // delete profile
                $('#SearchProfileDelete').off('click.DeleteProfile').on('click.DeleteProfile', function (Event) {

                    // strip all already used attributes
                    $('#SearchProfile').find('option:selected').each(function () {
                        if ($(this).attr('value') !== 'last-search') {

                            // rebuild attributes
                            $('#SearchInsert').text('');

                            // remove remote
                            SearchProfileDelete($(this).val());

                            // remove local
                            $(this).remove();

                            // show fulltext
                            TargetNS.SearchAttributeAdd('Fulltext');

                            // rebuild selection
                            TargetNS.AdditionalAttributeSelectionRebuild();
                        }
                    });

                    if ($('#SearchProfile').val() && $('#SearchProfile').val() === 'last-search') {

                        // hide delete link
                        $('#SearchProfileDelete').hide();

                        // hide profile link
                        $('#SearchProfileAsLink').hide();
                    }

                    Event.preventDefault();
                    return false;
                });

            }, 'html'
        );
    };

    /**
     * @name Init
     * @namespace ITSM.Agent.ChangeManagement.Search
     * @function
     * @description
     *      This function initializes some behaviours for the search dialog.
     */
    TargetNS.Init = function () {
        var OpenDialog = Core.Config.Get('ITSMChangeManagementSearch.Open');
        if (OpenDialog) {
            TargetNS.OpenSearchDialog('AgentITSMChangeSearch');
        }
    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(ITSM.Agent.ChangeManagement.Search || {}));
