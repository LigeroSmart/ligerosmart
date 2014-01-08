# --
# Kernel/System/Stats/Static/FAQAccess.pm.pm
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Stats::Static::FAQAccess;

use strict;
use warnings;
use Date::Pcalc qw(Days_in_Month);
use Kernel::System::FAQ;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check all needed objects
    for my $Object (qw(DBObject ConfigObject LogObject UserID)) {
        die "Got no $Object" if !$Self->{$Object};
    }

    # create needed object
    $Self->{FAQObject} = Kernel::System::FAQ->new(%Param);

    return $Self;
}

sub Param {

    my $Self = shift;

    my @Params = ();

    # get current time
    my ( $s, $m, $h, $D, $M, $Y ) = $Self->{TimeObject}->SystemTime2Date(
        SystemTime => $Self->{TimeObject}->SystemTime(),
    );
    $D = sprintf( "%02d", $D );
    $M = sprintf( "%02d", $M );
    $Y = sprintf( "%02d", $Y );

    # create possible time selections
    my %Year = map { $_, $_ } ( $Y - 10 .. $Y + 1 );
    my %Month = map { sprintf( "%02d", $_ ), sprintf( "%02d", $_ ) } ( 1 .. 12 );
    my %Day   = map { sprintf( "%02d", $_ ), sprintf( "%02d", $_ ) } ( 1 .. 31 );

    push @Params, {
        Frontend   => 'Start day',
        Name       => 'StartDay',
        Multiple   => 0,
        Size       => 0,
        SelectedID => '01',
        Data       => {
            %Day,
        },
    };
    push @Params, {
        Frontend   => 'Start month',
        Name       => 'StartMonth',
        Multiple   => 0,
        Size       => 0,
        SelectedID => $M,
        Data       => {
            %Month,
        },
    };
    push @Params, {
        Frontend   => 'Start year',
        Name       => 'StartYear',
        Multiple   => 0,
        Size       => 0,
        SelectedID => $Y,
        Data       => {
            %Year,
        },
    };
    push @Params, {
        Frontend   => 'End day',
        Name       => 'EndDay',
        Multiple   => 0,
        Size       => 0,
        SelectedID => $D,
        Data       => {
            %Day,
        },
    };
    push @Params, {
        Frontend   => 'End month',
        Name       => 'EndMonth',
        Multiple   => 0,
        Size       => 0,
        SelectedID => $M,
        Data       => {
            %Month,
        },
    };
    push @Params, {
        Frontend   => 'End year',
        Name       => 'EndYear',
        Multiple   => 0,
        Size       => 0,
        SelectedID => $Y,
        Data       => {
            %Year,
        },
    };

    return @Params;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $ParamName (qw(StartYear StartMonth StartDay EndYear EndMonth EndDay)) {
        if ( !$Param{$ParamName} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $ParamName!",
            );
            return;
        }
    }

    # correct start day of month if entered wrong by user
    my $StartDay = sprintf( "%02d", Days_in_Month( $Param{StartYear}, $Param{StartMonth} ) );
    if ( $Param{StartDay} < $StartDay ) {
        $StartDay = $Param{StartDay};
    }

    # correct end day of month if entered wrong by user
    my $EndDay = sprintf( "%02d", Days_in_Month( $Param{EndYear}, $Param{EndMonth} ) );
    if ( $Param{EndDay} < $EndDay ) {
        $EndDay = $Param{EndDay};
    }

    # set start and end date
    my $StartDate = "$Param{StartYear}-$Param{StartMonth}-$StartDay 00:00:00";
    my $EndDate   = "$Param{EndYear}-$Param{EndMonth}-$EndDay 23:59:59";

    # get a count of all faq articles
    my $Top10ItemIDsRef = $Self->{FAQObject}->FAQTop10Get(
        Interface => 'internal',
        StartDate => $StartDate,
        EndDate   => $EndDate,
        UserID    => $Self->{UserID},
    );

    # build result table
    my @Data;
    for my $ItemIDRef ( @{$Top10ItemIDsRef} ) {

        # get faq data
        my %FAQData = $Self->{FAQObject}->FAQGet(
            ItemID     => $ItemIDRef->{ItemID},
            ItemFields => 0,
            UserID     => $Self->{UserID},
        );

        # get vote data
        my $VoteData = $Self->{FAQObject}->ItemVoteDataGet(
            ItemID => $ItemIDRef->{ItemID},
            UserID => $Self->{UserID},
        );
        my $VoteResult = sprintf(
            "%0."
                . $Self->{ConfigObject}->Get(
                "FAQ::Explorer::ItemList::VotingResultDecimalPlaces"
                )
                . "f", $VoteData->{Result} || 0
        );
        my $Votes = $VoteData->{Votes} || 0;

        # build table row
        push @Data, [
            $FAQData{Number},
            $FAQData{Title},
            $ItemIDRef->{Count},
            $VoteResult,
            $Votes,
        ];
    }

    # set report title
    my $Title
        = "$Param{StartYear}-$Param{StartMonth}-$StartDay - $Param{EndYear}-$Param{EndMonth}-$EndDay";

    # table headlines
    my @HeadData = (
        'FAQ #',
        'Title',
        'Count',
        'Vote Result',
        'Votes',
    );

    my @Result = ( [$Title], [@HeadData], @Data );

    return @Result;
}

1;
