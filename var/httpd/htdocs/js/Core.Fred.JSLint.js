// --
// Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (GPL). If you
// did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
// --

"use strict";
/*global JSLINT: false, $: false, jQuery: false */

var Core = Core || {};
Core.Fred = Core.Fred || {};

/**
 * @namespace
 * @description
 *      This namespace contains all logic for the Fred module JSLint
 */
Core.Fred.JSLint = (function (TargetNS) {

    function htmlEscape(str) {
        return String(str)
            .replace(/&/g, '&amp;')
            .replace(/"/g, '&quot;')
            .replace(/'/g, '&#39;')
            .replace(/</g, '&lt;')
            .replace(/>/g, '&gt;');
    }

    /**
     * @function
     * @private
     * @description Start JSLint check.
     */
    function startJSLint() {
        var Result,
            ErrorsFound = false;

        // This func should not be started more than one time...
        if (TargetNS.Started) {
            return;
        }
        TargetNS.Started++;

        // Start JSLint for every script we found and output the result
        $.each(TargetNS.AllScripts, function () {
            var ErrorObject, Output, i;

            // Ignore invalid code that is injected by the google analytics opt-out plugin for browsers.
            if (this.Src === 'inline' && this.Script.match(/_gaUserPrefs/)) {
                return;
            }

            Result = JSLINT(this.Script, (this.Src === 'inline') ? TargetNS.InlineOptions : TargetNS.RemoteOptions);
            if (!Result) {
                for (i = 0; i < JSLINT.errors.length; i++) {
                    ErrorObject = JSLINT.errors[i];
                    if (ErrorObject) {
                        $('#FredJSLintRunning').remove();
                        Output = '<div class="FredJSLintError">';
                        Output += '<p><span class="Error">Error: </span><strong>' + ErrorObject.reason + '</strong> Source:     ' + this.Src + ':' + ErrorObject.line + ':' + ErrorObject.character + '</p>';
                        Output += '<code>' + htmlEscape(ErrorObject.evidence) + '</code>';
                        Output += '</div>';
                        $('#FredJSLintScripts').append(Output);
                        ErrorsFound = true;
                    }
                }
            }
            // activate else branch to see positive check results per file for fred debugging
            //else {
            //    $('#FredJSLintRunning').remove();
            //    $('#FredJSLintScripts').append('<p class="FredJSLintSuccessful">' + this.Src + ' ok</p>');
            //}
        });
        if (!ErrorsFound) {
            $('#FredJSLintRunning').remove();
            $('#FredJSLintScripts').append('<p class="FredJSLintSuccessful">All checks ok.</p>');
        }

        if (TargetNS.AllScripts.length === 0) {
            $('#FredJSLintScripts').append('<p>No scripts found!</p>').css('height', '15px');
        }
    }

    /**
     * @field
     * @description All options for JSLint.
     */
    TargetNS.CommonOptions = {
        browser: true,
        white: true,
        indent: 4,
        devel: true,
        onevar: true,
        undef: true,
        nomen: true,
        eqeqeq: true,
        plusplus: false,
        bitwise: true,
        strict: true,
        immed: true,
        predef: ['Core', 'isJQueryObject', '$', 'jQuery', 'CKEDITOR', 'window', 'document', 'printStackTrace']
    };
    TargetNS.RemoteOptions = $.extend(TargetNS.CommonOptions, {});
    TargetNS.InlineOptions = $.extend(TargetNS.CommonOptions, {
        white: false
    });

    TargetNS.AllScripts = TargetNS.AllScripts || [];
    TargetNS.Waiting = 0;
    TargetNS.Started = 0;
    TargetNS.Sources = {};

    /**
     * @function
     * @description
     *      This is the init function for JSLint.
     */
    TargetNS.Init = function () {
        // this module needs jQuery!
        if (typeof jQuery === 'undefined' || !jQuery) {
            window.alert('Fred JSLint module needs jQuery loaded');
            document.getElementById('FredJSLintScripts').style.height = '15px';
        }
        else {
            $(document).ready(function () {
                Core.Fred.JSLint.GetScripts();
            });
        }
    };

    /**
     * @function
     * @description Get all scripts to check.
     */
    TargetNS.GetScripts = function () {
        $(document).ready(function () {
            var Scripts, Source;

            $('script').each(function () {
                // Exclude the Fred JavaScript ;-)
                Scripts = $(this).text();

                if ($(this).is('[src]')) {
                    Source = $(this).attr('src');
                }
                else {
                    Source = 'inline';
                }

                if (Source === 'inline') {
                    TargetNS.AllScripts.push({Src: Source, Script: Scripts});
                }
                else {
                    // If external source is not a thirdparty script, load it!
                    if (!Source.match(/thirdparty/) && !Source.match(/chrome:\/\//) && !TargetNS.Sources[Source]) {
                        TargetNS.Waiting++;
                        TargetNS.Sources[Source] = 1;

                        $.get(Source, {}, function (data) {
                            TargetNS.AllScripts.push({Src: this.url, Script: data});
                            TargetNS.Waiting--;
                        }, 'text');
                    }
                }
            });

            // start jslint, if all ajax requests are ready
            setTimeout(function () {
                Core.Fred.JSLint.CheckForStart();
            }, 250);
        });
    };

    /**
     * @function
     * @description
     *      This function checks, if JSLint can be started (all scripts are loaded).
     */
    TargetNS.CheckForStart = function () {
        if (TargetNS.Waiting <= 0 && TargetNS.Started === 0) {
            startJSLint();
        }
        else {
            if (TargetNS.Started === 0) {
                setTimeout(function () {
                    Core.Fred.JSLint.CheckForStart();
                }, 250);
            }
        }
    };
    return TargetNS;
}(Core.Fred.JSLint || {}));
