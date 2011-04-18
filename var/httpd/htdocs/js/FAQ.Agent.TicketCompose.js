// --
// FAQ.Agent.TicketCompose.js - provides the special module functions for AgentFAQZoom
// Copyright (C) 2001-2011 OTRS AG, http://otrs.org/\n";
// --
// $Id: FAQ.Agent.TicketCompose.js,v 1.7 2011-04-18 10:53:53 mn Exp $
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (AGPL). If you
// did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
// --

"use strict";

var FAQ = FAQ || {};
FAQ.Agent = FAQ.Agent || {};

/**
 * @namespace
 * @exports TargetNS as FAQ.Agent.TicketCompose
 * @description
 *      This namespace contains the special module functions for TicketCompose.
 */
FAQ.Agent.TicketCompose = (function (TargetNS) {

    /**
     * @function
     * @param {jQueryObject} $Element The editor
     * @return nothing
     *      Initialize the needed stuff for the FAQ functionality of the ticket screens.
     */
    TargetNS.InitFAQTicketCompose = function ($Element) {
        function GetCursorPosition() {
            var Element = $Element[0],
                ElementValue = $Element.val(),
                Range,
                TextRange,
                TextRangeDuplicate,
                StartRange = 0,
                EndRange = 0;
            // Firefox
            if (Element.selectionStart) {
                StartRange = Element.selectionStart;
                EndRange = Element.selectionEnd;
            }
            // IE
            else if (document.selection) {
                Range = document.selection.createRange().duplicate();
                TextRange = Element.createTextRange();
                TextRangeDuplicate = TextRange.duplicate();
                TextRange.moveToBookmark(Range.getBookmark());
                TextRangeDuplicate.setEndPoint('EndToStart', TextRange);
                StartRange = EndRange = TextRangeDuplicate.text.length;
            }

            // Save cursor position for later usage
            $Element.data('Cursor', {
                StartRange: StartRange,
                EndRange: EndRange
            });
        }

        var InstanceName = $Element.attr('id');
        // Register RTE events for saving the cursor position
        if (typeof CKEDITOR !== 'undefined' && CKEDITOR && CKEDITOR.instances.RichText) {
            // Get last cursor position and save it (on focus we come back to this position)
            CKEDITOR.instances[InstanceName].on('contentDom', function() {
                CKEDITOR.instances[InstanceName].document.on('click', function () {
                    $('#' + InstanceName).data('RTECursor', CKEDITOR.instances[InstanceName].getSelection().getRanges());
                });
                CKEDITOR.instances[InstanceName].document.on('keyup', function () {
                    $('#' + InstanceName).data('RTECursor', CKEDITOR.instances[InstanceName].getSelection().getRanges());
                });
            });

            // needed for client-side validation and inserting data into RTE
            CKEDITOR.instances[InstanceName].on('focus', function () {
                // if a saved cursor position exists, set this position now
                var RTECursorRange = $('#' + InstanceName).data('RTECursor'),
                    Selection;
                if (RTECursorRange) {
                    Selection = new CKEDITOR.dom.selection(CKEDITOR.instances[InstanceName].document);
                    Selection.selectRanges(RTECursorRange);
                    // delete saved cursor position (to not keep old stuff)
                    $('#' + InstanceName).data('RTECursor', undefined);
                }
            });
        }
        // Register events for saving the cursor position of textarea
        else {
            $Element.unbind('click.FAQComposing').bind('click.FAQComposing', function () {
                GetCursorPosition();
            });
            $Element.unbind('keyup.FAQComposing').bind('keyup.FAQComposing', function () {
                GetCursorPosition();
            });
        }
    };


    /**
     * @function
     * @param {String} Title of a FAQ article to be returned into ticket Subject
     * @param {String} Fields of a FAQ article and or Link to the public interface in plain text
     * @param {String} Fields of a FAQ article and or Link to the public interface in HTML
     * @return nothing
     *      Mark an article as seen in frontend and backend.
     */
    TargetNS.SetData = function (FAQTitle, FAQContent, FAQHTMLContent) {
        if ($('#Subject', parent.document).length && $('#RichText', parent.document).length) {
            var $ParentSubject = $('#Subject', parent.document),
                $ParentBody = $('#RichText', parent.document),
                ParentBody = $ParentBody[0],
                ParentBodyValue = $ParentBody.val(),
                Range,
                StartRange = 0,
                EndRange = 0,
                NewPosition = 0,
                NewHTML;

            // copy subject
            if ($ParentSubject.val() === '') {
                $ParentSubject.val(FAQTitle);
            }
            else {
                $ParentSubject.val($ParentSubject.val() + ' - ' + FAQTitle);
            }

            // add FAQ text and/or link to WYSIWYG editor in parent window
            if (parent.CKEDITOR && parent.CKEDITOR.instances.RichText) {
                parent.CKEDITOR.instances.RichText.focus();
                window.setTimeout( function () {
                    // In some circumstances, this command throws an error (although inserting the HTML works)
                    // Because the intended functionality also works, we just wrap it in a try-catch-statement
                    try {
                        parent.CKEDITOR.instances.RichText.insertHtml(FAQHTMLContent);
                    }
                    catch (Error) {
                        $.noop();
                    }
                    window.setTimeout(function () {
                        parent.Core.UI.Dialog.CloseDialog($('.Dialog', parent.document));
                    }, 50);
                }, 100);
                return;
            }

            // insert body and/or link to textarea (if possible to cursor position otherwise to the top)
            else {
                // Get previously saved cursor position of textarea
                if (parent.$('#RichText', parent.document).data('Cursor')) {
                    StartRange = parent.$('#RichText', parent.document).data('Cursor').StartRange;
                    EndRange = parent.$('#RichText', parent.document).data('Cursor').EndRange;
                }

                // Add new text to textarea
                $ParentBody.val(ParentBodyValue.substr(0, StartRange) + FAQContent + ParentBodyValue.substr(EndRange, ParentBodyValue.length));
                NewPosition = StartRange + FAQContent.length;

                // Jump to new cursor position (after inserted text)
                if (ParentBody.selectionStart) {
                    ParentBody.selectionStart = NewPosition;
                    ParentBody.selectionEnd = NewPosition;
                }
                else if (document.selection) {
                    Range = document.selection.createRange().duplicate();
                    Range.moveStart('character', NewPosition);
                    Range.select();
                }

                parent.Core.UI.Dialog.CloseDialog($('.Dialog', parent.document));
                return;
            }
        }
        else {
            alert('$JSText{"This window must be called from compose window"}');
            parent.Core.UI.Dialog.CloseDialog($('.Dialog', parent.document));
            return;
        }
    };

    return TargetNS;
}(FAQ.Agent.TicketCompose || {}));
