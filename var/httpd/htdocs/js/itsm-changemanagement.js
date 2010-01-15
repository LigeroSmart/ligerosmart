// --
// itsm-changemanagement.js - provides JavaScript functions
// Copyright (C) 2003-2010 OTRS AG, http://otrs.com/\n";
// --
// $Id: itsm-changemanagement.js,v 1.7 2010-01-15 16:52:25 bes Exp $
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (AGPL). If you
// did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
// --


// Check if the time could be valid.
// Beware that days like 2010-02-29 are allowed.
function CheckTime( id_base ) {

    // check the planned end time
    var Year   = parseInt( document.getElementById( id_base + 'Year' ).value );
    var Month  = parseInt( document.getElementById( id_base + 'Month' ).value );
    var Day    = parseInt( document.getElementById( id_base + 'Day' ).value );
    var Hour   = parseInt( document.getElementById( id_base + 'Hour' ).value );
    var Minute = parseInt( document.getElementById( id_base + 'Minute' ).value );

    if (
        0
        || isNaN(Year) || isNaN(Month) || isNaN(Day) || isNaN(Hour) || isNaN(Minute)
        || ( Year   < 999 || Year   > 10000 )
        || ( Month  < 1   || Month  > 12 )
        || ( Day    < 1   || Day    > 31 )
        || ( Hour   < 0   || Hour   > 23 )
        || ( Minute < 0   || Minute > 59 )
        )
    {
        return false;
    }

    return true;
}

// check if start time is before end time
function CheckStartBeforeEnd ( StartPrefix, EndPrefix, ErrorMsg ) {

    // get start time values
    var StartYear   = parseInt( document.getElementById( StartPrefix + 'Year' ).value );
    var StartMonth  = parseInt( document.getElementById( StartPrefix + 'Month' ).value );
    var StartDay    = parseInt( document.getElementById( StartPrefix + 'Day' ).value );
    var StartHour   = parseInt( document.getElementById( StartPrefix + 'Hour' ).value );
    var StartMinute = parseInt( document.getElementById( StartPrefix + 'Minute' ).value );

    // get end time values
    var EndYear   = parseInt( document.getElementById( EndPrefix + 'Year' ).value );
    var EndMonth  = parseInt( document.getElementById( EndPrefix + 'Month' ).value );
    var EndDay    = parseInt( document.getElementById( EndPrefix + 'Day' ).value );
    var EndHour   = parseInt( document.getElementById( EndPrefix + 'Hour' ).value );
    var EndMinute = parseInt( document.getElementById( EndPrefix + 'Minute' ).value );

    // check year
    if ( StartYear < EndYear ) {
        return true;
    }
    if ( StartYear > EndYear ) {
        alert(ErrorMsg);

        return false;
    }

    // check month
    if ( StartMonth < EndMonth ) {
        return true;
    }
    if ( StartMonth > EndMonth ) {
        alert(ErrorMsg);

        return false;
    }

    // check day
    if ( StartDay < EndDay ) {
        return true;
    }
    if ( StartDay > EndDay ) {
        alert(ErrorMsg);

        return false;
    }

    // check hour
    if ( StartHour < EndHour ) {
        return true;
    }
    if ( StartHour > EndHour ) {
        alert(ErrorMsg);

        return false;
    }

    // check minute
    if ( StartMinute < EndMinute ) {
        return true;
    }
    if ( StartMinute > EndMinute ) {
        alert(ErrorMsg);

        return false;
    }

    // the times are equal
    alert(ErrorMsg);

    return false;
}
