# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Language::en;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # http://en.wikipedia.org/wiki/Date_and_time_notation_by_country#United_States
    # month-day-year (e.g., "12/31/99")

    # $$START$$
    # Last translation file sync: Fri Jan 12 14:50:51 2018

    # possible charsets
    $Self->{Charset} = ['utf-8'];

    # date formats (%A=WeekDay;%B=LongMonth;%T=Time;%D=Day;%M=Month;%Y=Year;)
    $Self->{DateFormat}          = '%M/%D/%Y %T';
    $Self->{DateFormatLong}      = '%T - %M/%D/%Y';
    $Self->{DateFormatShort}     = '%M/%D/%Y';
    $Self->{DateInputFormat}     = '%M/%D/%Y';
    $Self->{DateInputFormatLong} = '%M/%D/%Y - %T';
    $Self->{Separator}           = ',';
    $Self->{DecimalSeparator}    = '.';
    $Self->{ThousandSeparator}   = ',';

    $Self->{Translation} = {
        'May_long' => 'May',
        'Configuration Item Access Request' => 'Configuration Item Access Request',
        'Please provide a reason for accessing this Configuration Item' => 'Please provide a reason for accessing this Configuration Item',
        'Reason for access' => 'Reason for access',
        'This field is required.' => 'This field is required.',
        'Submit' => 'Submit',
        'No reason provided!' => 'No reason provided!',
        'Please provide a reason for accessing the ConfigItem.' => 'Please provide a reason for accessing the ConfigItem.',
        'Could not create tracking ticket!' => 'Could not create tracking ticket!',
        'Could not create article in tracking ticket!' => 'Could not create article in tracking ticket!',
        'For security and tracking purposes, you must provide a reason for accessing configuration items.' => 'For security and tracking purposes, you must provide a reason for accessing configuration items.',
        'Your request will be logged for audit purposes.' => 'Your request will be logged for audit purposes.',
    };

    $Self->{JavaScriptStrings} = [
        'May_long',
        'This field is required.',
    ];

    # $$STOP$$
    return;
}

1;
