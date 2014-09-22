# --
# Kernel/Output/HTML/NotificationTimeAccounting.pm
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::NotificationTimeAccounting;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::System::Time',
    'Kernel::System::TimeAccounting',
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get needed objects
    for my $Needed (qw(LayoutObject UserID)) {
        $Self->{$Needed} = $Param{$Needed} || die "Got no $Needed!";
    }

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # get time object
    my $TimeObject = $Kernel::OM->Get('Kernel::System::Time');

    my ( $Sec, $Min, $Hour, $Day, $Month, $Year ) = $TimeObject->SystemTime2Date(
        SystemTime => $TimeObject->SystemTime()
    );

    # get time accounting object
    my $TimeAccountingObject = $Kernel::OM->Get('Kernel::System::TimeAccounting');

    my %User = $TimeAccountingObject->UserCurrentPeriodGet(
        Year  => $Year,
        Month => $Month,
        Day   => $Day,
    );
    if ( $User{ $Self->{UserID} } ) {
        my %IncompleteWorkingDays = $TimeAccountingObject->WorkingUnitsCompletnessCheck(
            UserID => $Self->{UserID},
        );

        # redirect if incomplete working day are out of range
        if ( $IncompleteWorkingDays{Warning} ) {

            return $Self->{LayoutObject}->Notify(
                Info     => 'Please insert your working hours!',
                Priority => 'Error'
            );
        }
    }

    return '';
}

1;
