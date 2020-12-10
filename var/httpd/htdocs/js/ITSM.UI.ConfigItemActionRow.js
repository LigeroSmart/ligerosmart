// --
// Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (GPL). If you
// did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
// --


// TODO:
//Remove this line and fix JSDoc
// nofilter(TidyAll::Plugin::OTRS::JavaScript::ESLint)


"use strict";

var ITSM = ITSM || {};
ITSM.UI = ITSM.UI || {};

/**
 * @namespace
 * @exports TargetNS as ITSM.UI.ConfigItemActionRow
 * @description
 *      Action row functionality
 * @requires
 *      Core.JSON
 *      Core.Data
 */
ITSM.UI.ConfigItemActionRow = (function (TargetNS) {

    if (!Core.Debug.CheckDependency('ITSM.UI.ConfigItemActionRow', 'Core.JSON', 'JSON API')) {
        return;
    }
    if (!Core.Debug.CheckDependency('ITSM.UI.ConfigItemActionRow', 'Core.Data', 'Data API')) {
        return;
    }

    var ConfigItemElementSelectors = {
            'Small': 'div.Overview table td input:checkbox[name=ConfigItemID]',
            'Medium': 'ul.Overview input:checkbox[name=ConfigItemID]',
            'Large': 'ul.Overview input:checkbox[name=ConfigItemID]'
        },
        ConfigItemView;

    /**
     * @function
     * @private
     * @param {Object} Data The data that should be converted
     * @return {string} query string of the data
     * @description Converts a given hash into a query string
     */
    function SerializeData(Data) {
        var QueryString = '';
        $.each(Data, function (Key, Value) {
            QueryString += ';' + encodeURIComponent(Key) + '=' + encodeURIComponent(Value);
        });
        return QueryString;
    }

    /**
     * @function
     * @description
     *      This functions adds information about the valid action of an element to the element.
     *      These information are used to generate the action row individually for this element.
     * @param {jQueryObject} $Element
     *      The element for which the data is stored
     * @param {String} JSONString
     *      The JSON string which contains the information about the valid actions of the element (generated by Perl module)
     *      Could also be an javascript object directly
     * @return nothing
     */
    TargetNS.AddActions = function ($Element, JSONString) {
        var Actions;
        // The element of the given ID must exist, JSONString must not be empty
        if (isJQueryObject($Element)) {
            if (typeof JSONString === 'String') {
                Actions = Core.JSON.Parse(JSONString);
            }
            else {
                Actions = JSONString;
            }

            // save action data to the given element
            Core.Data.Set($Element, 'Actions', Actions);
        }
        else {
            Core.Debug.Log('Element does not exist or no valid data structure passed.');
        }
    };

    /**
     * @function
     * @description
     *      This function is called on click on the checkbox of an ConfigItem element and updates the action row for this element.
     * @param {jQueryObject} $ClickedElement
     *      jQueryObject of the clicked element (normally $(this))
     * @param {jQueryObject} Checkboxes
     *      jQueryObject of the checkboxes of the different ConfigItems
     * @param {jQueryObject} $ActionRow
     *      The jQueryObject of the ActionRow wrapper (normally the <ul>-Element)
     * @return nothing
     */
    TargetNS.UpdateActionRow = function ($ClickedElement, $Checkboxes, $ActionRow) {
        var ConfigItemActionData,
            ActionRowElement;

        // Check, if one or more items are selected
        $Checkboxes = $Checkboxes.filter(':checked');
        // No checkbox is selected
        if (!$Checkboxes.length) {
            // Remove actions and deactivate bulk action
            $ActionRow
                .find('li').filter(':not(.Bulk)').remove()
                .end().end()
                .find('#ConfigItemBulkAction').addClass('Inactive')
                .end()
                .find('li.Last').removeClass('Last')
                .end()
                .find('li:last').addClass('Last');
        }
        // Exactly one checkbox is selected
        else if ($Checkboxes.length === 1 && !$('#SelectAllConfigItems').is(':checked') ) {
            // Update actions and activate bulk action
            $ActionRow.find('#ConfigItemBulkAction').removeClass('Inactive');

            // Find the element which is active (it must not be the clicked element!)
            // and get the data
            ConfigItemActionData = Core.Data.Get($Checkboxes.closest('li, tr'), 'Actions');
            if (typeof ConfigItemActionData !== 'undefined') {
                $.each(ConfigItemActionData, function (Index, Value) {
                    if (Value.HTML) {
                        $(Value.HTML).attr('id', Value.ID).appendTo($ActionRow);
                        ActionRowElement = $ActionRow.find('#' + Value.ID).find('a');
                        if (typeof Value.Target === 'undefined' || Value.Target === "") {
                            ActionRowElement.attr('href', Value.Link);
                        }
                        if (Value.PopupType) {
                            ActionRowElement.on('click.Popup', function () {
                                Core.UI.Popup.OpenPopup(Value.Link, Value.PopupType);
                                return false;
                            });
                        }
                    }
                });
            }

            // Apply the Last class to the right element
            $ActionRow
                .find('li.Last').removeClass('Last')
                .end()
                .find('li:last').addClass('Last');
        }
        // Two ore more checkboxes selected
        else {
            // Remove actions and activate bulk action
            $ActionRow
                .find('li').filter(':not(.Bulk)').remove()
                .end().end()
                .find('#ConfigItemBulkAction').removeClass('Inactive')
                .end()
                .find('li.Last').removeClass('Last')
                .end()
                .find('li:last').addClass('Last');
        }
    };

    /**
     * @function
     * @description
     *      This function initializes the complete ActionRow functionality and binds all click events.
     * @return nothing
     */
    TargetNS.Init = function () {
        // Get used ConfigItem view mode
        if ($('#ConfigItemOverviewMedium').length) {
            ConfigItemView = 'Medium';
        }
        else if ($('#ConfigItemOverviewLarge').length) {
            ConfigItemView = 'Large';
        }
        else {
            ConfigItemView = 'Small';
        }

        $('#SelectAllConfigItems').on('click', function () {
            var Status = $(this).prop('checked');
            $(ConfigItemElementSelectors[ConfigItemView]).prop('checked', Status).triggerHandler('click');
        });

        $(ConfigItemElementSelectors[ConfigItemView]).on('click', function (Event) {
            Event.stopPropagation();
            ITSM.UI.ConfigItemActionRow.UpdateActionRow($(this), $(ConfigItemElementSelectors[ConfigItemView]), $('div.OverviewActions ul.Actions'));
        });

        $('#ConfigItemBulkAction a').on('click', function () {
            var $Element = $(this),
                $SelectedConfigItems,
                ConfigItemIDParameter = "ConfigItemID=",
                ConfigItemIDs = "",
                URL;
            if ($Element.parent('li').hasClass('Inactive')) {
                return false;
            }
            else {
                $SelectedConfigItems = $(ConfigItemElementSelectors[ConfigItemView] + ':checked');
                $SelectedConfigItems.each(function () {
                    ConfigItemIDs += ConfigItemIDParameter + $(this).val() + ";";
                });
                URL = Core.Config.Get('Baselink') + "Action=AgentITSMConfigItemBulk;" + ConfigItemIDs;
                URL += SerializeData(Core.App.GetSessionInformation());
                Core.UI.Popup.OpenPopup(URL, 'ConfigItemAction');
            }
            return false;
        });
    };

    return TargetNS;
}(ITSM.UI.ConfigItemActionRow || {}));
