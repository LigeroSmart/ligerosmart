# --
# Copyright (C) 2001-2018 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
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
        if ( $IncompleteWorkingDays{Warning} ) {

            return $Kernel::OM->Get('Kernel::Output::HTML::Layout')->Notify(
                Priority => 'Error',
                Info     => Translatable('Please insert your working hours!'),
            );
        }
    }

    return '';
}

1;
