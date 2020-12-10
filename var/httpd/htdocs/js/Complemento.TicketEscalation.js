"use strict";

var Core = Core || {};
Core.TE = Core.TE || {};

/**
 * @namespace
 * @exports TargetNS as Core.TE.TicketEscalation
 * @description
 *      Provides functions to exclude ticket free time fields,
 *      if not relevant for currently selected ticket type
 */
Core.TE.TicketEscalation = (function (TargetNS) {
    // container and content for ticket escalation time (yes, it's a fixed time value)
    var $EscTimeP = $('fieldset.TableLike div.Value p'),
        $EscTimeDiv = $('td.EscalationTimeEntry div'),
        $EscTimeSpan = $('span.CustomST'),
        regexEscTimeStopped = new RegExp('(29.12.2025|12.30.2025|2025.12.30|12\/30\/2025|30\/12\/2025) [0-9][0-9]:00');

    // replacing in ticket zoom mask
    if ($EscTimeP.length) {
        $EscTimeP.each( function(){
            // check if ticket escalation time is stopped
            if (regexEscTimeStopped.test($(this).text())) {
                // reformat ticket escalation time into text
                $(this).text('(SLA SUSPENSO)').attr('title', 'Escalação Suspensa devido ao Estado do Chamado');
            }
        });
    }
    
    // replacing in customer ticket zoom mask
     if ($EscTimeSpan.length) {
        $EscTimeSpan.each( function(){
            // check if ticket escalation time is stopped
            if (regexEscTimeStopped.test($(this).text())) {
                // reformat ticket escalation time into text
                $(this).text('(SLA SUSPENSO)').attr('title', 'Escalação Suspensa devido ao Estado do Chamado');
            }
        });
    }

    // replacing in ticket overviews
    if ($EscTimeDiv.length) {
        $EscTimeDiv.each( function(){
            // check if ticket escalation time is stopped
            if (regexEscTimeStopped.test($(this).attr('title'))) {
                // reformat ticket escalation time into text
                $(this).text('(SLA SUSPENSO)').attr('title', 'Escalação Suspensa devido ao Estado do Chamado');
            }
        });
    }

    return TargetNS;
}(Core.TE.TicketEscalation || {}));
