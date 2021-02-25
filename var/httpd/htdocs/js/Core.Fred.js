// --
// Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (GPL). If you
// did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
// --

/* eslint no-window:0 */

"use strict";

var Core = Core || {};
Core.Fred = Core.Fred || {};

/**
 * @namespace
 * @description
 *      This namespace contains all logic for Fred
 */
Core.Fred = (function (TargetNS) {

    var DevelFredToggleContainerLinkProccess = 0;

    /**
     * @function
     * @description
     *      This function inits generic fred functions
     */
    TargetNS.Init = function () {

        var WidgetStatus = {},
            Key;

        // get status of Fred widgets
        if (window && window.localStorage) {
            WidgetStatus = window.localStorage.getItem('FRED_widget_status');

            try {
                WidgetStatus = JSON.parse(WidgetStatus);
                if (WidgetStatus === null) {
                    WidgetStatus = {};
                }
            }
            catch (Exception) {
                WidgetStatus = {};
            }

            for (Key in WidgetStatus) {
                if (WidgetStatus.hasOwnProperty(Key)) {
                    $('.DevelFredBoxContent#' + Key).removeClass('Expanded Collapsed');
                    if (WidgetStatus[Key] === 'Collapsed' || WidgetStatus[Key] === 'Expanded') {
                        $('#' + Key)
                            .addClass(WidgetStatus[Key])
                            .closest('.DevelFredBox')
                            .addClass(WidgetStatus[Key]);
                    }
                }
            }
        }

        // all Fred widgets without a saved widget status are now expanded
        $('.DevelFredBoxContent').filter(':not(.Collapsed, .Expanded)').addClass('Expanded');

        // Toolbar items
        $('.FredSearch').bind('click', function() {
            $(this).closest('.DevelFredBox').find('.FredQuickSearch').toggle();
        });
        $('.FredMinimize').bind('click', function() {
            var $WidgetElement = $(this).closest('.DevelFredBox').find('.DevelFredBoxContent');

            $WidgetElement
                .slideToggle('fast')
                .toggleClass('Collapsed')
                .toggleClass('Expanded');

            $WidgetElement
                .closest('.DevelFredBox')
                .removeClass('Expanded Collapsed')
                .addClass($WidgetElement.hasClass('Expanded') ? 'Expanded' : 'Collapsed');

            WidgetStatus[$WidgetElement.attr('id')] = $WidgetElement.hasClass('Collapsed') ? 'Collapsed' : 'Expanded';
            if (window && window.localStorage) {
                window.localStorage.setItem('FRED_widget_status', JSON.stringify(WidgetStatus));
            }
        });
        $('.FredClose').bind('click', function() {
            $(this).closest('.DevelFredBox').hide();
        });
        $('.FredCloseAll').bind('click', function() {
            $('.DevelFredBox').hide();
        });

        // empty the search field
        $('.FredQuickSearch i').bind('click', function() {
            $(this).prev('input').val('').trigger('keydown');
        });

        // register the table filter on the quicksearch fields (only if Core.UI.Table is available)
        if (Core.Debug.CheckDependency('Fred', 'Core.UI.Table', 'Core.UI.Table', true)) {
            $('.FredQuickSearch input').each(function() {
                Core.UI.Table.InitTableFilter($(this), $(this).closest('.DevelFredBox').find('.FredTableDefault'));
            });
        }
        else {
            $('.FredQuickSearch, .FredSearch').hide();
        }

        // register new popup profile as needed by fred
        Core.UI.Popup.ProfileAdd('FredSettings', {
            WindowURLParams: "dependent=yes,location=no,menubar=no,resizable=yes,scrollbars=yes,status=no,toolbar=no",
            Left: 100,
            Top: 100,
            Width: 400,
            Height: 500
        });

        // open the settings popup
        $('.FredSettings').bind('click', function() {
            Core.UI.Popup.OpenPopup($(this).data('url'), 'FredSettings', 'FredSettings');
        });

        // SQL log: Show bind parameters on click of 'show' link
        $('.ShowBindParameters').bind('click', function() {
            $(this).next('.Hidden').toggle();
            return false;
        });

        $('.FredSettingsLink').bind('click', function() {
            window.close();
        });

        // make the fred box draggable
        $('#DevelFredContainer').draggable({
            handle: 'h1',
            stop: function(event, ui) {
                var Top = ui.offset.top,
                    Left = ui.offset.left;

                if (window && window.localStorage !== undefined) {
                    /*eslint-disable camelcase*/
                    window.localStorage.FRED_console_left = Left;
                    window.localStorage.FRED_console_top = Top;
                    /*eslint-enable camelcase*/
                }
            }
        });

        // save fred's window position
        (function(){
            var SavedLeft, SavedTop, FredWidth, FredHeight;

            if (window && window.localStorage !== undefined && window.localStorage.FRED_console_left && window.localStorage.FRED_console_top) {

                SavedLeft = window.localStorage.FRED_console_left;
                SavedTop = window.localStorage.FRED_console_top;
                FredWidth = $('#DevelFredContainer').width();
                FredHeight = $('#DevelFredContainer').height();

                if (SavedLeft > $('body').width()) {
                    SavedLeft = $('body').width() - FredWidth;
                }
                if (SavedTop > $('body').height()) {
                    SavedTop = $('body').height() - FredHeight;
                }

                if (SavedLeft && SavedTop) {
                    $('#DevelFredContainer').css('left', SavedLeft + 'px');
                    $('#DevelFredContainer').css('top', SavedTop + 'px');
                }
            }
        }());

        if (!$('body').hasClass('FredActive')) {
            $('.DevelFredBox').hide();
        }

        $('#DevelFredToggleContainerLink').on('click', function() {
            var Data = {
                Action: 'DevelFred',
                Subaction: 'ConfigSwitchAJAX',
                Key: 'Fred::Active',
                Value: $('body').hasClass('FredActive') ? 1 : 0
            };

            if (DevelFredToggleContainerLinkProccess) return;

            DevelFredToggleContainerLinkProccess = 1;

            $('body').toggleClass('FredActive');
            $('#DevelFredToggleContainerLink').toggleClass('FredActive');

            if (!$('.DevelFredBox').is(":visible") && $('body').hasClass('FredActive')) {
                $('.DevelFredBox').show();
            }
            else {
                $('.DevelFredBox').hide();
            }

            Core.AJAX.FunctionCall(Core.Config.Get('CGIHandle'), Data, function () {
                DevelFredToggleContainerLinkProccess = 0;
            }, 'json');
        });
    };

    TargetNS.Init();

    return TargetNS;
}(Core.Fred.JSLint || {}));
