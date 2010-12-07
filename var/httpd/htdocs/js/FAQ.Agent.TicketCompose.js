// --
// FAQ.Agent.TicketCompose.js - provides the special module functions for AgentFAQZoom
// Copyright (C) 2001-2010 OTRS AG, http://otrs.org/\n";
// --
// $Id: FAQ.Agent.TicketCompose.js,v 1.3 2010-12-07 17:25:52 ub Exp $
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
     * @param {String} Title of a FAQ article to be returned into ticket Subject
     * @param {String} Fields of a FAQ article and or Link to the public interface in plain text
     * @param {String} Fields of a FAQ article and or Link to the public interface in HTML
     * @return nothing
     *      Mark an article as seen in frontend and backend.
     */
    TargetNS.SetData = function (FAQTitle, FAQContent, FAQHTMLContent) {
        if ($('#Subject', parent.document).length && $('#RichText', parent.document).length) {
            var $ParentSubject = $('#Subject', parent.document),
                $ParentBody    = $('#RichText', parent.document),
                NewHTML;

            /* copy subject */
            if ($ParentSubject.val() === '') {
                $ParentSubject.val(FAQTitle);
            }
            else {
                $ParentSubject.val($ParentSubject.val() + ' - ' + FAQTitle);
            }

            // add FAQ text and/or link to WYSIWYG editor in parent window
            if (parent.CKEDITOR && parent.CKEDITOR.instances.RichText) {
                NewHTML = parent.CKEDITOR.instances.RichText.getData();
                NewHTML += FAQHTMLContent;
                parent.CKEDITOR.instances.RichText.setData(NewHTML);
                window.setTimeout(function () {
                    parent.Core.UI.Dialog.CloseDialog($('.Dialog', parent.document));
                }, 50);
                return;
            }

            /* insert body and/or link on top */
            else {
                $ParentBody.val( FAQContent + $ParentBody.val());
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
