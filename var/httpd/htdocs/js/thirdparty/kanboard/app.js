// Ligero
function refreshColumnCardsCount(){
    $('#board th').each(function(){
        var $cards = $(this).closest('table').find('td').eq($(this).index()).find('div.draggable-item');
        $(this).find('.task-count > span').text($cards.length);
    });
}
// Common functions
var Kanboard = (function() {

    return {

        // Display a popup
        Popover: function(e, callback) {
            e.preventDefault();
            e.stopPropagation();

            var link = e.target.getAttribute("href");

            if (! link) {
                link = e.target.getAttribute("data-href");
            }

            if (link) {
                $.get(link, function(content) {

                    $("body").append('<div id="popover-container"><div id="popover-content">' + content + '</div></div>');

                    $("#popover-container").click(function() {
                        $(this).remove();
                    });

                    $("#popover-content").click(function(e) {
                        e.stopPropagation();
                    });

                    if (callback) {
                        callback();
                    }
                });
            }
        },

        // Return true if the page is visible
        IsVisible: function() {

            var property = "";

            if (typeof document.hidden !== "undefined") {
                property = "visibilityState";
            } else if (typeof document.mozHidden !== "undefined") {
                property = "mozVisibilityState";
            } else if (typeof document.msHidden !== "undefined") {
                property = "msVisibilityState";
            } else if (typeof document.webkitHidden !== "undefined") {
                property = "webkitVisibilityState";
            }

            if (property != "") {
                return document[property] == "visible";
            }

            return true;
        },

        // Common init
        Before: function() {

            // Datepicker
            $(".form-date").datepicker({
                showOtherMonths: true,
                selectOtherMonths: true,
                dateFormat: 'yy-mm-dd'
            });
        }
    };

})();


// Board related functions
Kanboard.Board = (function() {

    var checkInterval = null;

    // Stop events
    function board_unload_events()
    {
        $("[data-task-id]").off();
        clearInterval(checkInterval);
    }

    // Save and refresh the board
    function board_save(taskId, columnId, position)
    {
        var boardSelector = $("#board");
        var projectId = boardSelector.attr("data-project-id");

        board_unload_events();

//		alert('Comp task:'+taskId + ' col '+columnId);
	
	var data = {};
        data.Action = "AgentTicketQueueKanban";
        data.Subaction = "StateUpdate";
        data.TicketID  = taskId;
        data.QueueID   = projectId;
        data.State     = columnId;
        data.position  = position;
        data.csrf_token =  boardSelector.attr("data-csrf-token");
        if (!Core.Config.Get('SessionIDCookie')) {
            data[Core.Config.Get('SessionName')] = Core.Config.Get('SessionID');
            data[Core.Config.Get('CustomerPanelSessionName')] = Core.Config.Get('SessionID');
        }
        data.ChallengeToken = Core.Config.Get('ChallengeToken');

        $.ajax({
            cache: false,
            // COMPLEMENTO: HERE WE SHOULD AJAX TICKET UPDATE
            url: "?Action=AgentTicketQueueKanban;Subaction=StateUpdate;project_id=" + projectId,
            data: data,
            type: "POST",
            success: function(data) {
                if($(data).find("#eventResult")[0].value === "1"){
                    doFilter(false);
                } else {
                    Core.UI.Dialog.ShowDialog({
                        Modal: true,
                        Type: 'Alert',
                        Text: $(data).find("#errorMove")[0].value,
                        PositionTop: '70px',
                        PositionLeft: 'Center',
                        CloseOnEscape: true,
                        CloseOnClickOutside: true
                    });
                    doFilter(false);
                }
            }
        });
    }

    // Change Priority
//    function PriorityChange(NextPriority, QueueID, TicketID)
    function PriorityChange(Priority,TicketID,QueueID)
    {
        board_unload_events();
        var data = {};
        data.Action = "AgentTicketQueueKanban";
        data.Subaction = "PriorityUpdate";
        data.TicketID  = TicketID;
        data.QueueID   = QueueID;
        data.Priority  = Priority;
	  if (!Core.Config.Get('SessionIDCookie')) {
            data[Core.Config.Get('SessionName')] = Core.Config.Get('SessionID');
            data[Core.Config.Get('CustomerPanelSessionName')] = Core.Config.Get('SessionID');
        }
        data.ChallengeToken = Core.Config.Get('ChallengeToken');

	
//        alert('oi...'+QueueID);
        $.ajax({
            cache: false,
            // COMPLEMENTO: HERE WE SHOULD AJAX TICKET UPDATE
            url: "?Action=AgentTicketQueueKanban;Subaction=PriorityUpdate;project_id=" + QueueID,
            data: data,
            type: "POST",
            success: function(data) {
                if($(data).find("#eventResult")[0].value === "1"){
                    doFilter(false);
                } else {
                    Core.UI.Dialog.ShowDialog({
                        Modal: true,
                        Type: 'Alert',
                        Text: $(data).find("#errorPriority")[0].value,
                        PositionTop: '70px',
                        PositionLeft: 'Center',
                        CloseOnEscape: true,
                        CloseOnClickOutside: true
                    });
                    doFilter(false);
                }
            }
        });
    }

    // Check if a board have been changed by someone else
    function board_check()
    {
        var boardSelector = $("#board");
        var projectId = boardSelector.attr("data-project-id");
        var timestamp = boardSelector.attr("data-time");

        if (Kanboard.IsVisible() && projectId != undefined && timestamp != undefined) {
            $.ajax({
                cache: false,
                url: "?controller=board&action=check&project_id=" + projectId + "&timestamp=" + timestamp,
                statusCode: {
                    200: function(data) {
                        boardSelector.remove();
                        $("#main").append(data);
                        board_unload_events();
                        board_load_events();
                        filter_apply();
                    }
                }
            });
        }
    }

    function doFilter(showLoading){
        $("#kanban_filters").submit(function(event){
            event.preventDefault(); //prevent default action 
            var post_url = $(this).attr("action"); //get form action url
            var request_method = $(this).attr("method"); //get form GET/POST method
            var form_data = $(this).serialize(); //Encode form elements for submission
            if(showLoading)
                $(".loading").fadeIn();
            $.ajax({
                url : post_url,
                type: request_method,
                data : form_data
            }).done(function(response){ //
                $(".loading").fadeOut();
                $("#kanban_filters").remove();
                $(response).find("#kanban_filters").appendTo("#mainFilter");
                Core.UI.InputFields.InitSelect($('.Modernize'));

                 $("#board").remove();
                $(response).find("#board").appendTo("#main");
                board_load_events();

                 $('#kanban_filters').unbind("submit");
            });
        });



         $('#kanban_filters').submit();
    }

     // Setup the board
    function board_load_events()
    {
        // Drag and drop
        $(".column").sortable({
            delay: 300,
            distance: 5,
            connectWith: ".column",
            placeholder: "draggable-placeholder",
            stop: function(event, ui) {
                board_save(
                    ui.item.attr('data-task-id'),
                    ui.item.parent().attr("data-column-id"),
                    ui.item.index() + 1
                );
            }
        });

         // Assignee change
        $(".assignee-popover").click(Kanboard.Popover);

         // Category change
        $(".category-popover").click(Kanboard.Popover);

         // Complemento - Priority Change
        $(".prioButton").click(function(e) {
            e.preventDefault();
            var Priority=$(this).attr('data-next-priority');
            var TicketID=$(this).attr('data-ticket-id');
            var QueueID =$(this).attr('data-queue-id');
            PriorityChange(Priority,TicketID,QueueID);
            });

         // Task edit popover
        $(".task-edit-popover").click(function(e) {
            Kanboard.Popover(e, Kanboard.Task.Init);
        });

         // Description popover
        $(".task-description-popover").click(Kanboard.Popover);

     //        // Redirect to the task details page
    //        $("[data-task-id]").each(function() {
    //            $(this).click(function() {
    //                window.location = "?controller=task&action=show&task_id=" + $(this).attr("data-task-id");
    //            });
    //        });

         // Automatic refresh
        var interval = parseInt($("#board").attr("data-check-interval"));

         if (interval > 0) {
        // COMPLEMENTO : DISABLE WINDOW REFRESH
    //            checkInterval = window.setInterval(board_check, interval * 1000);
        }
        // Ligero:
        refreshColumnCardsCount();


         $('a.AsPopup').bind('click', function (Event) {
            var Matches,
                PopupType = 'TicketAction';

             Matches = $(this).attr('class').match(/PopupType_(\w+)/);
            if (Matches) {
                PopupType = Matches[1];
            }

             Core.UI.Popup.OpenPopup($(this).attr('href'), PopupType);
            return false;
        });


     }

    // Apply user or date filter (change tasks opacity)
    function filter_apply()
    {
        var selectedUserId = $("#form-user_id").val();
        var selectedCategoryId = $("#form-category_id").val();
        var filterDueDate = $("#filter-due-date").hasClass("filter-on");

        $("[data-task-id]").each(function(index, item) {

            var ownerId = item.getAttribute("data-owner-id");
            var dueDate = item.getAttribute("data-due-date");
            var categoryId = item.getAttribute("data-category-id");

            if (ownerId != selectedUserId && selectedUserId != -1) {
                item.style.opacity = "0.2";
            }
            else {
                item.style.opacity = "1.0";
            }

            if (filterDueDate && (dueDate == "" || dueDate == "0")) {
                item.style.opacity = "0.2";
            }

            if (categoryId != selectedCategoryId && selectedCategoryId != -1) {
                item.style.opacity = "0.2";
            }
        });
    }

    // Load filter events
    function filter_load_events()
    {
        $("#form-user_id").change(filter_apply);

        $("#form-category_id").change(filter_apply);

        $("#filter-due-date").click(function(e) {
            $(this).toggleClass("filter-on");
            filter_apply();
            e.preventDefault();
        });
    }

    return {
        Init: function() {
            board_load_events();
            filter_load_events();

            // Project select box
            $("#board-selector").chosen({
                width: 180
            });

            $("#board-selector").change(function() {
                window.location = "?controller=board&action=show&project_id=" + $(this).val();
            });
        },
        Filter: function() {
            doFilter(true);
        }		        
    };

})();


// Task related functions
Kanboard.Task = (function() {

    return {
        Init: function() {

            Kanboard.Before();

            // Image preview for attachments
            $(".file-popover").click(Kanboard.Popover);
        }
    };

})();


// Project related functions
Kanboard.Project = (function() {

    return {
        Init: function() {
            Kanboard.Before();
        }
    };

})();


// Initialization
$(function() {
//alert($(window).width());
    if ($("#board").length) {
        Kanboard.Board.Init();
    }
    else if ($("#task-section").length) {
        Kanboard.Task.Init();
    }
    else if ($("#project-section").length) {
        Kanboard.Project.Init();
    }

});

