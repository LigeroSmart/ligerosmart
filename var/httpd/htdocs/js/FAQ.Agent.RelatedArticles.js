// --
// Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (GPL). If you
// did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
// --

"use strict";

var FAQ = FAQ || {};
FAQ.Agent = FAQ.Agent || {};

/**
 * @namespace
 * @exports TargetNS as FAQ.Agent.RelatedArticles
 * @description
 *      This namespace contains the special module functions for FAQ.
 */
FAQ.Agent.RelatedArticles = (function (TargetNS) {

    /**
     * @name Init
     * @memberof FAQ.Agent.RelatedArticles
     * @function
     * @description
     *      This function initialize the FAQ module (functionality for related articles).
     */
    TargetNS.Init = function() {
        var WidgetPosition = Core.Config.Get('AgentFAQRelatedArticlesPosition'),
            QueuesEnabled  = Core.Config.Get('AgentFAQRelatedArticlesQueues'),
            LastData,
            LastResponse,
            SlideDuration  = 400,
            HelpText       = Core.Language.Translate('This might be helpful'),
            $Widget        = $('<label id="FAQRelatedArticlesLabel" for="FAQRelatedArticles">' + HelpText + ':</label><div id="FAQRelatedArticles" class="Field" style="min-height: 0px;"></div><div class="Clear"></div>'),
            $AJAXLoader    = $('<span id="AJAXLoaderFAQRelatedArticles" class="AJAXLoader"></span>');

        // Widget position below subject.
        if (WidgetPosition == 1) {

            $('#Subject')
                .parent()
                .next()
                .after($Widget);
        }
        // Widget position below text.
        else if (WidgetPosition == 2) {

            $('#RichText')
                .parent()
                .next()
                .after($Widget);
        }

        // Hide the widget by default.
        $('#FAQRelatedArticlesLabel').hide();
        $('#FAQRelatedArticles').hide();

        // Create and hide AJAXLoader.
        $('#Subject').after($AJAXLoader);
        $AJAXLoader.hide();

        Core.App.Subscribe('Event.UI.RichTextEditor.InstanceReady', function() {

            $('#Dest').on('change.RelatedFAQArticle', function () {
                var SelectedQueue = $(this).val(),
                    SelectedQueueName = SelectedQueue.replace(/\d*\|\|-?/, '');

                if ((!QueuesEnabled.length || !SelectedQueueName || $.inArray(SelectedQueueName, QueuesEnabled) > -1)) {

                    if ($('#Subject').val() || CKEDITOR.instances['RichText'].getData()) {
                        $('#Subject').trigger('change');
                    }
                }
                else if (!SelectedQueueName || (QueuesEnabled.length && $.inArray(SelectedQueueName, QueuesEnabled) == -1)) {

                    if ($('#FAQRelatedArticles').html()) {

                        // Hide label + field.
                        $('#FAQRelatedArticlesLabel').hide();

                        $('#FAQRelatedArticles').slideUp(SlideDuration, function () {

                            $('#FAQRelatedArticles')
                                .empty()
                                .css('padding-top', '0px')
                                .css('padding-bottom', '0px');
                        });
                    }
                }
            });

            $('#Subject').on('change', function () {
                var SelectedQueue = $('#Dest').val(),
                    SelectedQueueName,
                    Data;

                if (SelectedQueue) {
                    SelectedQueueName = SelectedQueue.replace(/\d*\|\|-?/, '');
                }

                if (!QueuesEnabled.length || !SelectedQueueName || $.inArray(SelectedQueueName, QueuesEnabled) > -1) {

                    Data = {
                        Action: 'AgentFAQRelatedArticles',
                        Subject: $('#Subject').val(),
                        Body: CKEDITOR.instances['RichText'].getData()
                    };

                    if (!LastData || LastData.Subject != Data.Subject || LastData.Body != Data.Body) {

                        $AJAXLoader.show();

                        if ($('#Subject').data('RelatedFAQArticlesXHR')) {

                            $('#Subject').data('RelatedFAQArticlesXHR').abort();
                            $('#Subject').removeData('RelatedFAQArticlesXHR');
                        }

                        $('#Subject').data('RelatedFAQArticlesXHR', Core.AJAX.FunctionCall(Core.Config.Get('Baselink'), Data, function (Response) {

                            var AmountOldElements = 0,
                                AmountNewElements = 0;

                            $('#Subject').removeData('RelatedFAQArticlesXHR');

                            // Remember the last data to execute the ajax request only if necessary.
                            LastData = Data;

                            if ($('#FAQRelatedArticles').length) {

                                if (Response && Response.Success) {

                                    // Only change the content, if we got new content.
                                    if (!LastResponse || LastResponse != Response.AgentRelatedFAQArticlesHTMLString) {

                                        // If there are previous found FAQ articles, do not start with page flickering.
                                        // Instead we are going to replace only the table very smoothly.
                                        if ($('#FAQRelatedArticles').html()) {

                                            AmountOldElements = $('#FAQRelatedArticles table tr').length;
                                            AmountNewElements = $(Response.AgentRelatedFAQArticlesHTMLString).find('tr').length;

                                            // Only use slide effect, if it is really needed.
                                            if (AmountOldElements != AmountNewElements) {

                                                $('#FAQRelatedArticles').slideUp(SlideDuration, function () {

                                                    $('#FAQRelatedArticles')
                                                        .empty()
                                                        .html(Response.AgentRelatedFAQArticlesHTMLString)
                                                        .css('padding-top', '3px')
                                                        .css('padding-bottom', '3px')
                                                        .slideDown(SlideDuration);

                                                    $('#FAQRelatedArticlesLabel').show();
                                                });
                                            }
                                            else {

                                                $('#FAQRelatedArticles')
                                                    .empty()
                                                    .html(Response.AgentRelatedFAQArticlesHTMLString)
                                                    .css('padding-top', '3px')
                                                    .css('padding-bottom', '3px');
                                            }
                                        }
                                        else {

                                            $('#FAQRelatedArticles')
                                                .html(Response.AgentRelatedFAQArticlesHTMLString)
                                                .css('padding-top', '3px')
                                                .css('padding-bottom', '3px')
                                                .slideDown(SlideDuration, function () {

                                                    $('#FAQRelatedArticlesLabel').show();
                                                });
                                        }
                                    }

                                    // Remember last html string from response.
                                    LastResponse = Response.AgentRelatedFAQArticlesHTMLString;
                                }
                                else {

                                    // Hide label + field.
                                    $('#FAQRelatedArticlesLabel').hide();

                                    $('#FAQRelatedArticles').slideUp(SlideDuration, function () {

                                        $('#FAQRelatedArticles')
                                            .empty()
                                            .css('padding-top', '0px')
                                            .css('padding-bottom', '0px');
                                    });

                                    // Remember last html string (empty).
                                    LastResponse = undefined;
                                }

                                // Remove loading class.
                                $AJAXLoader.hide();
                            }
                        }));
                    }
                }
            });

            $('#Subject').on('paste keydown', function (Event) {
                var Value = $('#Subject').val();

                // trigger only the change event for the subject, if space or enter was pressed
                if ((Event.type === 'keydown' && (Event.which == 32 || Event.which == 13) && (Value.length > 10 || CKEDITOR.instances['RichText'].getData())) || Event.type !== 'keydown') {
                    $('#Subject').trigger('change');
                }
            });

            // The "change" event is fired whenever a change is made in the editor.
            CKEDITOR.instances['RichText'].on('key', function (Event) {

                // trigger only the change event for the subject, if space or enter was pressed
                if (Event.data.keyCode == 32 || Event.data.keyCode == 13) {
                    $('#Subject').trigger('change');
                }
            });

            // The "paste" event is fired whenever a paste is made in the editor.
            CKEDITOR.instances['RichText'].on('paste', function () {

                // trigger only the change event for the subject
                $('#Subject').trigger('change');
            });

            // The "blur" event is fired whenever a blur is made in the editor.
            CKEDITOR.instances['RichText'].on('blur', function () {

                // trigger only the change event for the subject
                $('#Subject').trigger('change');
            });

            // Trigger the 'RelatedFAQArticle' change event to hide/show the related faq article widget for the case
            //  that the queue is already selected at the page load or show the widget always if the queue selection is disabled.
            if (!$('#Dest').length) {

                if ($('#Subject').val() || CKEDITOR.instances['RichText'].getData()) {
                    $('#Subject').trigger('change');
                }
            }
            else {
                $('#Dest').trigger('change.RelatedFAQArticle');
            }
        });
    };

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(FAQ.Agent.RelatedArticles || {}));
