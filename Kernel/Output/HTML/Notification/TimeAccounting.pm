# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Output::HTML::Notification::TimeAccounting;

use strict;
use warnings;

use Kernel::Language qw(Translatable);

our @ObjectDependencies = (
    'Kernel::System::DateTime',
    'Kernel::System::TimeAccounting',
    'Kernel::Output::HTML::Layout',
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get UserID param
    $Self->{UserID} = $Param{UserID} || die "Got no UserID!";

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $DateTimeObject   = $Kernel::OM->Create('Kernel::System::DateTime');
    my $DateTimeSettings = $DateTimeObject->Get();

    # get time accounting object
    my $TimeAccountingObject = $Kernel::OM->Get('Kernel::System::TimeAccounting');

    my %User = $TimeAccountingObject->UserCurrentPeriodGet(
        Year  => $DateTimeSettings->{Year},
        Month => $DateTimeSettings->{Month},
        Day   => $DateTimeSettings->{Day},
    );
    if ( $User{ $Self->{UserID} } ) {
        my %IncompleteWorkingDays = $TimeAccountingObject->WorkingUnitsCompletnessCheck(
            UserID => $Self->{UserID},
        );

        # redirect if incomplete working day are out of range
        my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
        my $Priority     = ( $IncompleteWorkingDays{EnforceInsert} ) ? 'Error' : 'Warning';
        if ( $IncompleteWorkingDays{Warning} || $IncompleteWorkingDays{EnforceInsert} ) {
            return $Kernel::OM->Get('Kernel::Output::HTML::Layout')->Notify(
                Priority => $Priority,
                Link     => $LayoutObject->{Baselink} . 'Action=AgentTimeAccountingEdit',
                Info     => Translatable('Please insert your working hours!'),
            );
        }
    }

    return '';
}

1;
