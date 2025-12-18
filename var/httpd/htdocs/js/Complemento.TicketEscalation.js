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
    var $EscTimeP = $('fieldset.TableLike div.Value p');
    var $EscTimeDiv = $('td.EscalationTimeEntry div');
    var $EscTimeSpan = $('span.CustomST');
    var $EscTableColumn = $('tr.MasterAction > td > div');
    var regexEscTimeStopped = new RegExp('(29.12.2025|12.30.2025|2025.12.30|12\/30\/2025|30\/12\/2025) [0-9][0-9]:00');
    // Improved regex to catch very large time values (indicating paused SLA)
    // Matches patterns like "1157407407 d 9 h 46 m" or "20434 d 20 h 22 m"
    // Any value with 4+ digits of days (>= 10000 days = ~27 years) indicates paused SLA
    // Also matches formats like "1157407407 d" or very large numbers followed by "d" (days)
    var regexSlaStop = /[0-9]{4,}\s+d(\s+[0-9]{1,2}\s+h(\s+[0-9]{1,2}\s+m)?)?/ig;

    /**
     * Function to check if a text indicates paused SLA
     * Checks for date patterns or very large time values
     */
    function isSLAStopped(text) {
        if (!text) return false;
        var textStr = String(text).trim();
        
        // Skip if already marked as suspended
        if (textStr === '(SLA SUSPENSO)') {
            return false;
        }
        
        // Check for date patterns
        if (regexEscTimeStopped.test(textStr)) {
            return true;
        }
        
        // Check for very large time values (4+ digits before 'd' indicating paused SLA)
        // Values like "20434 d 20 h 22 m" or "1157407407 d 9 h 46 m" indicate paused SLA
        // Reset regex lastIndex to ensure test works correctly in loop
        regexSlaStop.lastIndex = 0;
        if (regexSlaStop.test(textStr)) {
            return true;
        }
        
        // Additional check: Look for any number >= 10000 followed by 'd' (days)
        // This catches cases where formatting might vary (e.g., "10000d" or "10,000 d")
        var largeDaysPattern = /([0-9]{4,}|[0-9]{1,3}[,\.][0-9]{3,})\s*d/i;
        if (largeDaysPattern.test(textStr)) {
            // Extract the number and verify it's >= 10000
            var match = textStr.match(/([0-9]{1,3}[,\.]?[0-9]*)/);
            if (match) {
                var numStr = match[1].replace(/[,\.]/g, '');
                var num = parseInt(numStr, 10);
                if (num >= 10000) {
                    return true;
                }
            }
        }
        
        return false;
    }

    /**
     * Process elements that might contain SLA time information
     * This function handles both FirstResponse and Solution time fields
     */
    function processSLAFields($elements) {
        $elements.each(function(){
            var $this = $(this);
            var currentText = $this.text().trim();
            var titleText = ($this.attr('title') || '').trim();
            
            // Check if this element should show (SLA SUSPENSO)
            // Check both text content and title attribute
            var shouldSuspend = isSLAStopped(currentText) || isSLAStopped(titleText);
            
            if (shouldSuspend && currentText !== '(SLA SUSPENSO)') {
                // reformat ticket escalation time into text
                $this.text('(SLA SUSPENSO)').attr('title', 'Escalação Suspensa devido ao Estado do Chamado');
            }
        });
    }

    // replacing in ticket zoom mask - Process all p elements in Value divs
    // This handles both FirstResponseTime and SolutionTime fields
    if ($EscTimeP.length) {
        processSLAFields($EscTimeP);
    }
    
    // replacing in customer ticket zoom mask
    if ($EscTimeSpan.length) {
        processSLAFields($EscTimeSpan);
    }

    // replacing in ticket overviews
    if ($EscTimeDiv.length) {
        processSLAFields($EscTimeDiv);
    }

    // search all divs inside table columns
    if ($EscTableColumn.length) {
        processSLAFields($EscTableColumn);
    }

    // Additional check: Look for SLA fields by checking adjacent fields
    // If a field shows a very large time value (paused), mark related destination date fields
    $('fieldset.TableLike div.Value').each(function() {
        var $valueDiv = $(this);
        var $pElement = $valueDiv.find('p');
        
        if ($pElement.length) {
            var valueText = $pElement.text().trim();
            var titleText = ($pElement.attr('title') || '').trim();
            
            // Check if this field shows paused SLA (large time value)
            if (isSLAStopped(valueText) || isSLAStopped(titleText)) {
                if (valueText !== '(SLA SUSPENSO)') {
                    $pElement.text('(SLA SUSPENSO)').attr('title', 'Escalação Suspensa devido ao Estado do Chamado');
                }
            }
        }
    });
    
    // First pass: Find all fields with large WorkingTime values (indicating paused SLA)
    var pausedSLAFields = [];
    $('fieldset.TableLike tr').each(function() {
        var $row = $(this);
        var $valueCell = $row.find('.Value');
        var $pElement = $valueCell.find('p');
        
        if ($pElement.length) {
            var valueText = $pElement.text().trim();
            if (isSLAStopped(valueText)) {
                // Found a paused SLA field - store reference to mark related fields
                pausedSLAFields.push({
                    $row: $row,
                    $pElement: $pElement,
                    valueText: valueText
                });
                // Mark this field immediately
                if (valueText !== '(SLA SUSPENSO)') {
                    $pElement.text('(SLA SUSPENSO)').attr('title', 'Escalação Suspensa devido ao Estado do Chamado');
                }
            }
        }
    });
    
    // Second pass: Check all rows for SLA deadline fields and mark them if paused
    $('fieldset.TableLike tr').each(function() {
        var $row = $(this);
        var $label = $row.find('label');
        var $valueCell = $row.find('.Value');
        var $pElement = $valueCell.find('p');
        
        if ($label.length && $pElement.length) {
            var labelText = $label.text().trim();
            var valueText = $pElement.text().trim();
            var titleText = ($pElement.attr('title') || '').trim();
            
            // Check if this is a SLA deadline field (Prazo de Resposta, Prazo de Solução, etc.)
            var deadlineMatch = /prazo\s+(de\s+)?(resposta|solu[cç][ãa]o|atualiza[cç][ãa]o)/i.exec(labelText);
            var isDeadlineField = !!deadlineMatch;
            var slaType = deadlineMatch ? deadlineMatch[2].toLowerCase() : null;
            
            if (isDeadlineField) {
                var shouldMarkAsSuspended = false;
                
                // Check if this specific field value indicates paused SLA
                if (isSLAStopped(valueText) || isSLAStopped(titleText)) {
                    shouldMarkAsSuspended = true;
                }
                
                // Also check if there's a paused WorkingTime field in the same fieldset
                // If any field in the same fieldset shows paused SLA, all related deadline fields should show it
                var $fieldset = $row.closest('fieldset');
                $fieldset.find('tr').each(function() {
                    var $checkRow = $(this);
                    var $checkValue = $checkRow.find('.Value p');
                    if ($checkValue.length) {
                        var checkText = $checkValue.text().trim();
                        if (isSLAStopped(checkText)) {
                            // Found a paused field in same fieldset - mark this deadline field too
                            shouldMarkAsSuspended = true;
                            return false; // break
                        }
                    }
                });
                
                if (shouldMarkAsSuspended && valueText !== '(SLA SUSPENSO)') {
                    $pElement.text('(SLA SUSPENSO)').attr('title', 'Escalação Suspensa devido ao Estado do Chamado');
                }
            }
        }
    });

    // Check ticket overview tables (Dashboard, Queue, etc.)
    // These use table cells (td) instead of fieldset structure
    function processOverviewTables() {
        // Process all tables on the page
        $('table').each(function() {
            var $table = $(this);
            var $headers = $table.find('thead th, thead td, tr:first th, tr:first td');
            
            // Build map of column indices to header text
            var columnMap = {};
            $headers.each(function(index) {
                var headerText = $(this).text().trim().toLowerCase();
                var isSLAColumn = /prazo\s+(de\s+)?(resposta|solu[cç][ãa]o|atualiza[cç][ãa]o|escala)/i.test(headerText) ||
                                 /escalation.*time|escala.*tempo|tempo.*escala|tempo\s+de\s+servi[cç]o/i.test(headerText);
                if (isSLAColumn) {
                    columnMap[index] = true;
                }
            });
            
            // Process each row in the table body
            $table.find('tbody tr, tr:not(:first)').each(function() {
                var $row = $(this);
                
                // Skip header rows
                if ($row.find('th').length && !$row.closest('tbody').length) {
                    return;
                }
                
                // Check each cell in SLA columns
                $row.find('td').each(function(cellIndex) {
                    if (columnMap[cellIndex]) {
                        var $cell = $(this);
                        var cellText = $cell.text().trim();
                        
                        // Skip if already marked or empty
                        if (cellText === '(SLA SUSPENSO)' || !cellText || cellText === '-') {
                            return;
                        }
                        
                        // Check if cell contains large time values (indicating paused SLA)
                        var shouldSuspend = isSLAStopped(cellText);
                        
                        // Also check nested elements (spans, divs, links, etc.)
                        if (!shouldSuspend) {
                            $cell.find('span, div, p, a, strong, em').each(function() {
                                var $child = $(this);
                                var childText = $child.text().trim();
                                if (isSLAStopped(childText)) {
                                    shouldSuspend = true;
                                    return false; // break
                                }
                            });
                        }
                        
                        if (shouldSuspend) {
                            // Replace content with (SLA SUSPENSO)
                            $cell.html('(SLA SUSPENSO)').attr('title', 'Escalação Suspensa devido ao Estado do Chamado');
                        }
                    }
                });
            });
        });
        
        // Alternative approach: Check all table cells that contain large time values
        // This is a fallback for cases where column detection might fail
        // Also processes cells with large time values that indicate paused SLA
        $('table tbody td, table td').each(function() {
            var $cell = $(this);
            var cellText = $cell.text().trim();
            
            // Skip if already marked, empty, or just a dash
            if (cellText === '(SLA SUSPENSO)' || !cellText || cellText === '-') {
                return;
            }
            
            // Check nested elements first (spans, divs, links, etc.)
            var foundLargeValue = false;
            var checkText = cellText;
            $cell.find('span, div, p, a, strong, em').each(function() {
                var $child = $(this);
                var childText = $child.text().trim();
                if (isSLAStopped(childText)) {
                    checkText = childText;
                    foundLargeValue = true;
                    return false; // break
                }
            });
            
            // Check if this cell contains a large time value
            if (!foundLargeValue && isSLAStopped(cellText)) {
                foundLargeValue = true;
            }
            
            if (foundLargeValue || isSLAStopped(checkText)) {
                // Verify it's likely in a SLA column by checking if it's in a table with SLA headers
                var $table = $cell.closest('table');
                var hasSLAHeaders = false;
                $table.find('thead th, thead td, tr:first th, tr:first td').each(function() {
                    var headerText = $(this).text().trim().toLowerCase();
                    if (/prazo\s+(de\s+)?(resposta|solu[cç][ãa]o|atualiza[cç][ãa]o|escala)/i.test(headerText) ||
                        /escalation.*time|escala.*tempo|tempo.*escala|tempo\s+de\s+servi[cç]o/i.test(headerText)) {
                        hasSLAHeaders = true;
                        return false; // break
                    }
                });
                
                // If table has SLA headers OR cell contains very large time value (>= 10000 days),
                // mark this cell as suspended
                // This ensures we catch EscalationTime even if header detection fails
                if (hasSLAHeaders || /[0-9]{4,}\s+d/i.test(checkText || cellText)) {
                    $cell.html('(SLA SUSPENSO)').attr('title', 'Escalação Suspensa devido ao Estado do Chamado');
                }
            }
        });
    }

    // Process overview tables immediately
    processOverviewTables();

    // Re-run check after a delay to catch dynamically loaded content
    // This ensures SLA suspension is detected even if elements load after initial page render
    setTimeout(function() {
        // Re-process ticket zoom fields
        if ($EscTimeP.length) {
            processSLAFields($EscTimeP);
        }
        if ($EscTimeSpan.length) {
            processSLAFields($EscTimeSpan);
        }
        if ($EscTimeDiv.length) {
            processSLAFields($EscTimeDiv);
        }
        
        // Re-check table rows after delay
        $('fieldset.TableLike tr').each(function() {
            var $row = $(this);
            var $label = $row.find('label');
            var $valueCell = $row.find('.Value');
            var $pElement = $valueCell.find('p');
            
            if ($label.length && $pElement.length) {
                var labelText = $label.text().trim();
                var valueText = $pElement.text().trim();
                var titleText = ($pElement.attr('title') || '').trim();
                
                var isDeadlineField = /prazo\s+(de\s+)?(resposta|solu[cç][ãa]o|atualiza[cç][ãa]o)/i.test(labelText);
                
                if (isDeadlineField && (isSLAStopped(valueText) || isSLAStopped(titleText))) {
                    if (valueText !== '(SLA SUSPENSO)') {
                        $pElement.text('(SLA SUSPENSO)').attr('title', 'Escalação Suspensa devido ao Estado do Chamado');
                    }
                }
            }
        });
        
        // Re-process overview tables
        processOverviewTables();
    }, 500);
    
        // Also process tables when AJAX content is loaded (for dynamic updates)
    $(document).ajaxComplete(function() {
        setTimeout(processOverviewTables, 100);
    });
    
    // Use MutationObserver to watch for dynamically added table content
    // This catches content loaded via AJAX or JavaScript after page load
    if (typeof MutationObserver !== 'undefined') {
        var observerTimeout = null;
        var observer = new MutationObserver(function(mutations) {
            var shouldProcess = false;
            mutations.forEach(function(mutation) {
                if (mutation.addedNodes.length) {
                    $(mutation.addedNodes).each(function() {
                        if ($(this).is('table') || $(this).find('table').length || 
                            $(this).is('td, th') || $(this).closest('table').length) {
                            shouldProcess = true;
                            return false; // break
                        }
                    });
                }
            });
            if (shouldProcess) {
                // Debounce to avoid processing too frequently
                clearTimeout(observerTimeout);
                observerTimeout = setTimeout(function() {
                    processOverviewTables();
                }, 200);
            }
        });
        
        // Observe document body for changes
        function startObserver() {
            if (document.body) {
                observer.observe(document.body, {
                    childList: true,
                    subtree: true
                });
            }
        }
        
        // Start observer when document is ready
        if (document.body) {
            startObserver();
        } else {
            $(document).ready(startObserver);
        }
    }

    return TargetNS;
}(Core.TE.TicketEscalation || {}));
