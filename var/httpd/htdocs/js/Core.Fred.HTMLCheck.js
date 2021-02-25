// --
// Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (GPL). If you
// did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
// --

"use strict";
/*global $: false, jQuery: false */

var Core = Core || {};
Core.Fred = Core.Fred || {};

/**
 * @namespace
 * @exports TargetNS as Core.Fred.HTMLCheck
 * @description
 *      This namespace contains all logic for the Fred module HTMLCHeck
 */
Core.Fred.HTMLCheck = (function (TargetNS) {

    var CheckFunctions = [],
        ErrorsFound = false;

    function htmlEncode(Text){
        return Text.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;');
    }

    function escapeSelector (Selector) {
        return Selector.replace(/(#|:|\.|\[|\])/g, '\\$1');
    }

    function outputError($Element, ErrorType, ErrorDescription, Hint){
        var $Container,
            Code,
            Message;

        $('#FredHTMLCheckRunning').remove();
        ErrorsFound = true;

        // Get element HTML by wrapping it in a div and calling .html() on that
        $Container = $('<div></div>');
        $Container.append($Element.clone());

        Code = $Container.html();
        if (Code.length > 160) {
            Code = Code.substring(0, 160) + '...';
        }

        Message = $('<p class="Small"></p>');
        Message.append('<span class="Error">Error:</span> <strong>' + ErrorDescription + '</strong><div>' + Hint + '</div><div><code>' + htmlEncode(Code) + '</code></div>');
        $('#FredHTMLCheckResults').append(Message);
    }

    /**
     * @function
     * @description
     *      Performs various accessibility checks to see if the HTML code
     *      violates some of our guidelines.
     *      Returns nothing, but calls OutputError if an error was found.
     */

    function CheckAccessibility() {
        /*
         * check if input elements either have a label or an assigned title text
         */
        $('input:text:visible, input:password:visible, input:checkbox:visible, input:radio:visible, select:visible, textarea:visible').each(function(){
            var $this = $(this),
                $Label = $([]),
                Title;

            // Ignore elements which have a placeholder text
            if ($this.attr('placeholder') && $this.attr('placeholder').length) {
                return;
            }

            // first look for labels which refer to this element by id
            if ($this.attr('id') && $this.attr('id').length) {
                $Label = $('label[for=' + escapeSelector($this.attr('id')) + ']');
            }
            // then look for labels which surround the current element
            if (!$Label.length) {
                $Label = $this.parents('label');
            }

            if ($Label.length > 1) {
                outputError(
                    $this,
                    'AccessibilityMultipleLabel',
                    'Input element with more than one assigned labels',
                    'Please make sure that only one label is present for this input element.'
                );
            }

            // first check if a title attribute is present, that is also ok for accessibility
            Title = $this.attr('title');
            if (Title && Title.length) {
                return;
            }

            // ok, no title available, now look for an assigned label element
            if (!$Label || !$Label.length) {
                outputError(
                    $this,
                    'AccessibilityMissingLabel',
                    'Input element without a describing label, placeholder or title attribute',
                    'Please add a placeholder or title attribute or a label element with a "speaking" description for this element.'
                );
            }
        });

        /*
         * check if links have either a text or a title
         */
        $('a').each(function(){
            var $this = $(this);

            // ignore if it's a "a name" and no "a href"
            if ($this.attr('name') && !$this.attr('href')) {
                return;
            }

            // log if an attribute title extists but nothing is in there, something missed somebody (e. g. title="")
            $.each($this[0].attributes, function () {
                if (this.name === 'title' && !this.value.length) {
                    outputError(
                        $this,
                        'AccessibilityInaccessibleLink',
                        'Link with title but without value',
                        'Please make sure that every link has a title attribute not empty.'
                    );
                }
            });

            // everything is ok, if text in a href exists
            if ($this.text() && $this.text().length) {
                return;
            }

            // everything is ok, if title in a href exists
            if ($this.attr('title') && $this.attr('title').length) {
                return;
            }

            outputError(
                $this,
                'AccessibilityInaccessibleLink',
                'Link without text or title',
                'Please make sure that every link has either a text content or a title attribute that can be used by a screenreader to identify the link.'
            );

        });
    }
    CheckFunctions.push(CheckAccessibility);

    /**
     * @function
     * @description
     *      Performs various checks for bad HTML practice.
     *      Returns nothing, but calls OutputError if an error was found.
     */

    function CheckBadPractice() {
        var ObsoleteElement2Replacement,
            UsedIDs = [];

        // check for inputs which should be buttons
        $('input:button, input:submit, input:reset').each(function(){
            var $this = $(this);
            outputError(
                $this,
                'BadPracticeInputButton',
                'Old input with type button, submit or reset detected',
                'Please replace this element with a <code>&lt;button&gt;</code> with the same type. Input fields must not be used for this purpose any more.'
            );
        });

        /*
        TODO: look for a fix for chrome. In Chrome, the size attribute has a value of 20 if
            it was not specified.
        // check for inputs with size attributes
        $('input:not(:file)').each(function(){
            var $this = $(this);
            if ($this.attr('size') && $this.attr('size') > 0) {
                outputError(
                    $this,
                    'BadPracticeInputSize',
                    'Input element with size attribute',
                    'Please remove the size attribute (this is only allowed for file upload fields). Maybe a class like W25pc, W33pc or W50pc would achieve a similar effect.'
                );
            }
        });
        */

        // check for obsolete elements
        ObsoleteElement2Replacement = {
            b: '<code>&lt;strong&gt;</code>',
            i: '<code>&lt;em&gt;</code>',
            font: '<code>&lt;span&gt;</code> with a CSS class',
            nobr: 'a proper substitute (depends on context)'
        };

        // check for inputs with size attributes
        $('font, nobr').each(function(){
            var $this = $(this);
            outputError(
                    $this,
                    'BadPracticeObsoleteElement',
                    'Obsolete element <code>&lt;' + this.tagName + '&gt;</code> used',
                    'Please replace it with: ' + ObsoleteElement2Replacement[this.tagName.toLowerCase()] + '.'
            );
        });

        // check for multiple usage of one ID
        $('div, span, ul, ol, li, a, h1, h2, h3, h4, h5, input, select').each(function() {
            var $this = $(this),
                ID = $this.attr('id') || '';

            if (ID) {
                if ($.inArray(ID, UsedIDs) > 0) {
                    outputError(
                            $this,
                            'BadPracticeMultipleIDUsage',
                            'ID used multiple times: ' + ID,
                            'Please make sure to use an ID only once!'
                    );
                    return true;
                }
                UsedIDs.push($(this).attr('id'));
            }
        });

        function obsoleteClassError(ClassName) {
            // Return a function that can be used as a callback by each().
            return function() {
                var $this = $(this);
                outputError(
                        $this,
                        'BadPracticeObsoleteClass',
                        'Obsolete class <code>"' + ClassName + '"</code> used',
                        'Please remove it and replace it with a proper substitute.'
                );
            };
        }

        // check for inputs with size attributes
        $('.mainbody').each(obsoleteClassError('mainbody'));
        $('.contentkey').each(obsoleteClassError('contentkey'));
        $('.contentvalue').each(obsoleteClassError('contentvalue'));
        $('.searchactive').each(obsoleteClassError('searchactive'));
        $('.searchpassive').each(obsoleteClassError('searchpassive'));

        // check for events
        $("div").each(function(){

            var $this = $(this),
                $Container,
                Code,
                Events,
                Event;

            // Don't output this error for fred itself.
            // We also currently need onclick events in the main menu.
            if ($this.closest('.DevelFredContainer, #NavigationContainer').length) {
                return;
            }

            // Get element HTML by wrapping it in a div and calling .html() on that
            $Container = $('<div></div>');
            $Container.append($this.clone());

            // onload attribute is sometimes needed for iframes, so we just remove it for the check
            $Container.find('iframe').removeAttr('onload');

            Code = $Container.html();

            // search for events in html element code
            Events = Code.match(/\s+on\w+=/ig);

            // send error to output
            if (Events !== null){
                // clean leading space and equals sign from the RegEx matching
                for (Event in Events){
                    if (Events.hasOwnProperty(Event)) {
                        Events[Event] = Events[Event].toString().match(/on\w+/);
                    }
                }
                outputError(
                    $this,
                    'BadPracticeEvent',
                    'Event <code>"' + Events + '"</code> used',
                    'Please remove it and replace it with a proper substitute.'
                );
            }
        });

    }
    CheckFunctions.push(CheckBadPractice);

    /**
     * @function
     * @description
     *      This function checks if HTMLCheck can be started (jQuery is loaded).
     */
    TargetNS.CheckForStart = function () {
        if (jQuery) {
            $(document).ready(function(){
                Core.Fred.HTMLCheck.Run();
            });
        }
        else {
            setTimeout(function(){
                Core.Fred.HTMLCheck.CheckForStart();
            }, 250);
        }
    };

    /**
     * @function
     * @description
     *      Runs all available check functions
     */
    TargetNS.Run = function(){
        $.each(CheckFunctions, function(){
            this();
        });
        $('#FredHTMLCheckRunning').remove();
        if (!ErrorsFound) {
            $('#FredHTMLCheckResults').html('<p class="FredJSLintSuccessful">All checks ok.</p>');
        }
    };

    return TargetNS;
}(Core.Fred.HTMLCheck || {}));
