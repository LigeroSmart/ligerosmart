// Make all links inside "wiki" div open in new window/tab
// $(".Wiki a").attr("target","_blank");

"use strict";

var LigeroFix = LigeroFix || {};

LigeroFix.GetCounter = function(index, module) {

  const urlParams = this.getAllUrlParams(';');
  //alert('Teste do LigeroFIX '+index+' module '+module + 'ssss '+ Core.Config.Get('CGIHandle'));
  var Data = {
    Action: module,
    Subaction: 'GetCounter',
    TicketID: urlParams.ticketid
  };

  Core.AJAX.FunctionCall(Core.Config.Get('CGIHandle'), Data, function (Response) {
    if (!Response) {
      console.log(Response);
      return;
    }

    $('#_lfw'+index).html(Response.Quantity);

  }, 'json');
}

LigeroFix.getAllUrlParams = function(separator) {

  // get query string from url (optional) or window
  var queryString = window.location.search.slice(1);

  // we'll store the parameters here
  var obj = {};

  // if query string exists
  if (queryString) {

    // stuff after # is not part of query string, so get rid of it
    queryString = queryString.split('#')[0];

    // split our query string into its component parts
    var arr = queryString.split(separator);

    for (var i = 0; i < arr.length; i++) {
      // separate the keys and the values
      var a = arr[i].split('=');

      // set parameter name and value (use 'true' if empty)
      var paramName = a[0];
      var paramValue = typeof (a[1]) === 'undefined' ? true : a[1];

      // (optional) keep case consistent
      paramName = paramName.toLowerCase();
      if (typeof paramValue === 'string') paramValue = paramValue.toLowerCase();

      // if the paramName ends with square brackets, e.g. colors[] or colors[2]
      if (paramName.match(/\[(\d+)?\]$/)) {

        // create key if it doesn't exist
        var key = paramName.replace(/\[(\d+)?\]/, '');
        if (!obj[key]) obj[key] = [];

        // if it's an indexed array e.g. colors[2]
        if (paramName.match(/\[\d+\]$/)) {
          // get the index value and add the entry at the appropriate position
          var index = /\[(\d+)\]/.exec(paramName)[1];
          obj[key][index] = paramValue;
        } else {
          // otherwise add the value to the end of the array
          obj[key].push(paramValue);
        }
      } else {
        // we're dealing with a string
        if (!obj[paramName]) {
          // if it doesn't exist, create property
          obj[paramName] = paramValue;
        } else if (obj[paramName] && typeof obj[paramName] === 'string'){
          // if property does exist and it's a string, convert it to an array
          obj[paramName] = [obj[paramName]];
          obj[paramName].push(paramValue);
        } else {
          // otherwise add the property
          obj[paramName].push(paramValue);
        }
      }
    }
  }

  return obj;
}

LigeroFix.OpenModal = function(Event,module) {

  const urlParams = this.getAllUrlParams(';');
  //alert('Teste do LigeroFIX '+index+' module '+module + 'ssss '+ Core.Config.Get('CGIHandle'));
  var Data = {
    Action: module,
    Subaction: 'GetModal',
    TicketID: urlParams.ticketid
  };

  //Core.UI.Dialog.ShowWaitingDialog(Core.Config.Get('LoadingMsg'), Core.Config.Get('LoadingMsg'));

  Core.AJAX.FunctionCall(Core.Config.Get('CGIHandle'), Data, function (Response) { 
    $("#ligeroFixContent").html(Response);
    /*Core.UI.Dialog.ShowContentDialog(
      Response,
      'Title',
      '10px',
      'Center'
    );*/
  },'html');

  
  
  Event.preventDefault();
  Event.stopPropagation();
  return;
  //Core.UI.Dialog.ShowWaitingDialog(Core.Config.Get('LoadingMsg'), Core.Config.Get('LoadingMsg'));

  
}

LigeroFix.CloseModal = function() {
  $("#ligeroFixContent").html("");
}

LigeroFix.LinkToTheTicket = function(module,objectId){
  const urlParams = this.getAllUrlParams(';');
  //alert('Teste do LigeroFIX '+index+' module '+module + 'ssss '+ Core.Config.Get('CGIHandle'));
  var Data = {
    Action: module,
    Subaction: 'LinkToTheTicket',
    TicketID: urlParams.ticketid,
    ObjectID: objectId
  };

  Core.AJAX.FunctionCall(Core.Config.Get('CGIHandle'), Data, function (Response) {
    if (!Response || !Response.Result) {
      console.log(Response);
      return;
    }

    if(Response.Result == 0){
      alert("Erro ao tentar linkar objeto ao ticket.")
    }
    else{
      window.location.reload();
    }

  }, 'json');
}