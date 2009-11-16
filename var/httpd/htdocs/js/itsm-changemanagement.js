function CheckTime( id_base ) {

    /* check the planned end time */
    var Year   = document.getElementById( id_base + 'Year' ).value * 1;
    var Month  = document.getElementById( id_base + 'Month' ).value * 1;
    var Day    = document.getElementById( id_base + 'Day' ).value * 1;
    var Hour   = document.getElementById( id_base + 'Hour' ).value * 1;
    var Minute = document.getElementById( id_base + 'Minute' ).value * 1;

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

function CheckStartBeforeEnd ( StartPrefix, EndPrefix, ErrorMsg ) {

    var StartYear   = document.getElementById( StartPrefix + 'Year' ).value * 1;
    var StartMonth  = document.getElementById( StartPrefix + 'Month' ).value * 1;
    var StartDay    = document.getElementById( StartPrefix + 'Day' ).value * 1;
    var StartHour   = document.getElementById( StartPrefix + 'Hour' ).value * 1;
    var StartMinute = document.getElementById( StartPrefix + 'Minute' ).value * 1;

    var EndYear   = document.getElementById( EndPrefix + 'Year' ).value * 1;
    var EndMonth  = document.getElementById( EndPrefix + 'Month' ).value * 1;
    var EndDay    = document.getElementById( EndPrefix + 'Day' ).value * 1;
    var EndHour   = document.getElementById( EndPrefix + 'Hour' ).value * 1;
    var EndMinute = document.getElementById( EndPrefix + 'Minute' ).value * 1;

    if ( StartYear < EndYear ) {
        return true;
    }
    if ( StartYear > EndYear ) {
        alert(ErrorMsg);

        return false;
    }

    if ( StartMonth < EndMonth ) {
        return true;
    }
    if ( StartMonth > EndMonth ) {
        alert(ErrorMsg);

        return false;
    }

    if ( StartDay < EndDay ) {
        return true;
    }
    if ( StartDay > EndDay ) {
        alert(ErrorMsg);

        return false;
    }

    if ( StartHour < EndHour ) {
        return true;
    }
    if ( StartHour > EndHour ) {
        alert(ErrorMsg);

        return false;
    }

    if ( StartMinute < EndMinute ) {
        return true;
    }
    if ( StartMinute > EndMinute ) {
        alert(ErrorMsg);

        return false;
    }

    /* the times are equal */
    alert(ErrorMsg);

    return false;
}