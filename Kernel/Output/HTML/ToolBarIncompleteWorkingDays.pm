# --
# Kernel/Output/HTML/ToolBarIncompleteWorkingDays.pm
# Copyright (C) 2001-2013 OTRS AG, http://otrs.org/
# --
# $Id: ToolBarIncompleteWorkingDays.pm,v 1.5 2013-01-03 22:53:33 cr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::ToolBarIncompleteWorkingDays;

use strict;
use warnings;

use Kernel::System::TimeAccounting;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.5 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get needed objects
    for (
        qw(ConfigObject LogObject DBObject TicketObject UserObject GroupObject LayoutObject UserID TimeObject)
        )
    {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    # create needed objects
    $Self->{TimeAccountingObject} = Kernel::System::TimeAccounting->new(%Param);

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # define action, group, label, image and prio
    my $Action    = 'AgentTimeAccounting';
    my $Subaction = 'Edit';
    my $Group     = 'time_accounting';

    # do not show icon if frontend module is not registered
    return if !$Self->{ConfigObject}->Get('Frontend::Module')->{$Action};

    # get the group id
    my $GroupID = $Self->{GroupObject}->GroupLookup( Group => $Group );

    # deny access, when the group is not found
    return if !$GroupID;

    # get user groups, where the user has the appropriate privilege
    my %Groups = $Self->{GroupObject}->GroupMemberList(
        UserID => $Self->{UserID},
        Type   => 'rw',
        Result => 'HASH',
    );

    # deny access if the agent doesn't have the appropriate type in the appropriate group
    return if !$Groups{$GroupID};

    my ( $Sec, $Min, $Hour, $Day, $Month, $Year ) = $Self->{TimeObject}->SystemTime2Date(
        SystemTime => $Self->{TimeObject}->SystemTime(),
    );

    my %UserCurrentPeriod = $Self->{TimeAccountingObject}->UserCurrentPeriodGet(
        Year  => $Year,
        Month => $Month,
        Day   => $Day,
    );

    # deny access, if user has no valid period
    return if !$UserCurrentPeriod{ $Self->{UserID} };

    # get the number of incomplete working days
    my $Count                 = 0;
    my %IncompleteWorkingDays = $Self->{TimeAccountingObject}->WorkingUnitsCompletnessCheck();

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

    # remove current day because it makes no sense to show the current day as incompleted
    if ( $Count > 0 ) {
        $Count--;
    }

    # get ToolBar object parameters
    my $Class = $Param{Config}->{CssClass};
    my $Text  = $Self->{LayoutObject}->{LanguageObject}->Get('Incomplete working days');
    my $URL   = $Self->{LayoutObject}->{Baselink};
    my $Icon  = $Param{Config}->{Icon};

    return () if !$Count;

    my %Return = (
        1000810 => {
            Block       => 'ToolBarItem',
            Description => $Text,
            Count       => $Count,
            Class       => $Class,
            Icon        => $Icon,
            Link        => $URL . 'Action=' . $Action . ';Subaction=' . $Subaction,
            AccessKey   => '',
            }
    );

    return %Return;
}

1;
