# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::ToolBar::IncompleteWorkingDays;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Group',
    'Kernel::System::Time',
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

    # define action, group, label, image and prio
    my $Action = 'AgentTimeAccountingEdit';
    my $Group  = 'time_accounting';

    # do not show icon if frontend module is not registered
    return if !$Kernel::OM->Get('Kernel::Config')->Get('Frontend::Module')->{$Action};

    # get group object
    my $GroupObject = $Kernel::OM->Get('Kernel::System::Group');

    # get the group id
    my $GroupID = $GroupObject->GroupLookup(
        Group => $Group,
    );

    # deny access, when the group is not found
    return if !$GroupID;

    # get user groups, where the user has the appropriate privilege
    my %Groups = $GroupObject->GroupMemberList(
        UserID => $Self->{UserID},
        Type   => 'rw',
        Result => 'HASH',
    );

    # deny access if the agent doesn't have the appropriate type in the appropriate group
    return if !$Groups{$GroupID};

    # get time object
    my $TimeObject = $Kernel::OM->Get('Kernel::System::Time');

    my ( $Sec, $Min, $Hour, $Day, $Month, $Year ) = $TimeObject->SystemTime2Date(
        SystemTime => $TimeObject->SystemTime(),
    );

    # get time accounting object
    my $TimeAccountingObject = $Kernel::OM->Get('Kernel::System::TimeAccounting');

    my %UserCurrentPeriod = $TimeAccountingObject->UserCurrentPeriodGet(
        Year  => $Year,
        Month => $Month,
        Day   => $Day,
    );

    # deny access, if user has no valid period
    return if !$UserCurrentPeriod{ $Self->{UserID} };

    # get the number of incomplete working days
    my $Count                 = 0;
    my %IncompleteWorkingDays = $TimeAccountingObject->WorkingUnitsCompletnessCheck(
        UserID => $Self->{UserID},
    );

    YEARID:
    for my $YearID ( sort keys %{ $IncompleteWorkingDays{Incomplete} } ) {

        next YEARID if !$YearID;
        next YEARID if !$IncompleteWorkingDays{Incomplete}{$YearID};
        next YEARID if ref $IncompleteWorkingDays{Incomplete}{$YearID} ne 'HASH';

        # extract year
        my %Year = %{ $IncompleteWorkingDays{Incomplete}{$YearID} };

        MONTH:
        for my $MonthID ( sort keys %Year ) {

            next MONTH if !$MonthID;
            next MONTH if !$Year{$MonthID};
            next MONTH if ref $Year{$MonthID} ne 'HASH';

            # extract month
            my %Month = %{ $Year{$MonthID} };

            $Count += scalar keys %Month;
        }
    }

    # remove current day because it makes no sense to show the current day as incomplete
    if ( $Count > 0 ) {
        $Count--;
    }

    # get layout object
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # get ToolBar object parameters
    my $Class = $Param{Config}->{CssClass};
    my $Text  = $LayoutObject->{LanguageObject}->Translate('Incomplete working days');
    my $URL   = $LayoutObject->{Baselink};
    my $Icon  = $Param{Config}->{Icon};

    return () if !$Count;

    my %Return = (
        1000810 => {
            Block       => 'ToolBarItem',
            Description => $Text,
            Count       => $Count,
            Class       => $Class,
            Icon        => $Icon,
            Link        => $URL . 'Action=' . $Action,
            AccessKey   => '',
            }
    );

    return %Return;
}

1;
