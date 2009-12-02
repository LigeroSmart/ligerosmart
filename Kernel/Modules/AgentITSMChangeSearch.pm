# --
# Kernel/Modules/AgentITSMChangeSearch.pm - module for change search
# Copyright (C) 2003-2009 OTRS AG, http://otrs.com/
# --
# $Id: AgentITSMChangeSearch.pm,v 1.4 2009-12-02 10:30:14 reb Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentITSMChangeSearch;

use strict;
use warnings;

use Kernel::System::CSV;
use Kernel::System::ITSMChange;
use Kernel::System::SearchProfile;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.4 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check needed objects
    for my $Object (
        qw(ParamObject DBObject LayoutObject LogObject ConfigObject MainObject EncodeObject)
        )
    {
        if ( !$Self->{$Object} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $Object!" );
        }
    }

    # create needed objects
    $Self->{ChangeObject}        = Kernel::System::ITSMChange->new(%Param);
    $Self->{CSVObject}           = Kernel::System::CSV->new(%Param);
    $Self->{SearchProfileObject} = Kernel::System::SearchProfile->new(%Param);

    # get config for frontend
    $Self->{Config} = $Self->{ConfigObject}->Get("ITSMChange::Frontend::$Self->{Action}");

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # get confid data
    $Self->{StartHit} = $Self->{ParamObject}->GetParam( Param => 'StartHit' ) || 1;
    $Self->{SearchLimit} = $Self->{Config}->{SearchLimit} || 500;
    $Self->{SortBy} = $Self->{ParamObject}->GetParam( Param => 'SortBy' )
        || $Self->{Config}->{'SortBy::Default'}
        || 'Age';
    $Self->{OrderBy} = $Self->{ParamObject}->GetParam( Param => 'OrderBy' )
        || $Self->{Config}->{'Order::Default'}
        || 'Down';
    $Self->{TakeLastSearch} = $Self->{ParamObject}->GetParam( Param => 'TakeLastSearch' ) || '';

    # search parameters
    my %GetParam;

    # load profiles string params (press load profile)
    if ( $Self->{TakeLastSearch} ) {
        %GetParam = $Self->{SearchProfileObject}->SearchProfileGet(
            Base      => 'ITSMChangeSearch',
            Name      => $Self->{Profile},
            UserLogin => $Self->{UserLogin},
        );
    }

    # get search string params (get submitted params)
    else {
        for my $SearchParam (
            qw(ChangeNumber)
            )
        {

            # get search string params (get submitted params)
            $GetParam{$SearchParam} = $Self->{ParamObject}->GetParam( Param => $SearchParam );

            # remove white space on the start and end
            if ( $GetParam{$SearchParam} ) {
                $GetParam{$SearchParam} =~ s/\s+$//g;
                $GetParam{$SearchParam} =~ s/^\s+//g;
            }
        }

        # get array params
        for my $SearchParam (
            qw( ChangeManagerID )
            )
        {

            # get search array params (get submitted params)
            my @Array = $Self->{ParamObject}->GetArray( Param => $SearchParam );
            if (@Array) {
                $GetParam{$SearchParam} = \@Array;
            }
        }
    }

    # TODO: process in loop
    # get time search params
    if ( !$GetParam{ArticleTimeSearchType} ) {
        $GetParam{'ArticleTimeSearchType::None'} = 'checked';
    }
    elsif ( $GetParam{ArticleTimeSearchType} eq 'TimePoint' ) {
        $GetParam{'ArticleTimeSearchType::TimePoint'} = 'checked';
    }
    elsif ( $GetParam{ArticleTimeSearchType} eq 'TimeSlot' ) {
        $GetParam{'ArticleTimeSearchType::TimeSlot'} = 'checked';
    }

    # get create time option
    if ( !$GetParam{TimeSearchType} ) {
        $GetParam{'TimeSearchType::None'} = 'checked';
    }
    elsif ( $GetParam{TimeSearchType} eq 'TimePoint' ) {
        $GetParam{'TimeSearchType::TimePoint'} = 'checked';
    }
    elsif ( $GetParam{TimeSearchType} eq 'TimeSlot' ) {
        $GetParam{'TimeSearchType::TimeSlot'} = 'checked';
    }

    # get change time option
    if ( !$GetParam{ChangeTimeSearchType} ) {
        $GetParam{'ChangeTimeSearchType::None'} = 'checked';
    }
    elsif ( $GetParam{ChangeTimeSearchType} eq 'TimePoint' ) {
        $GetParam{'ChangeTimeSearchType::TimePoint'} = 'checked';
    }
    elsif ( $GetParam{ChangeTimeSearchType} eq 'TimeSlot' ) {
        $GetParam{'ChangeTimeSearchType::TimeSlot'} = 'checked';
    }

    # get close time option
    if ( !$GetParam{CloseTimeSearchType} ) {
        $GetParam{'CloseTimeSearchType::None'} = 'checked';
    }
    elsif ( $GetParam{CloseTimeSearchType} eq 'TimePoint' ) {
        $GetParam{'CloseTimeSearchType::TimePoint'} = 'checked';
    }
    elsif ( $GetParam{CloseTimeSearchType} eq 'TimeSlot' ) {
        $GetParam{'CloseTimeSearchType::TimeSlot'} = 'checked';
    }

    # set result form env
    if ( !$GetParam{ResultForm} ) {
        $GetParam{ResultForm} = '';
    }

    # show result site
    if ( $Self->{Subaction} eq 'Search' ) {

        # fill up profile name (e.g. with last-search)
        if ( !$Self->{Profile} ) {
            $Self->{Profile} = 'last-search';
        }

        # store last queue screen
        my $URL
            = "Action=ITSMChangeSearch&Subaction=Search&Profile=$Self->{Profile}&SortBy=$Self->{SortBy}"
            . "&OrderBy=$Self->{OrderBy}&TakeLastSearch=1&StartHit=$Self->{StartHit}";
        $Self->{SessionObject}->UpdateSessionID(
            SessionID => $Self->{SessionID},
            Key       => 'LastScreenOverview',
            Value     => $URL,
        );
        $Self->{SessionObject}->UpdateSessionID(
            SessionID => $Self->{SessionID},
            Key       => 'LastScreenView',
            Value     => $URL,
        );

        # get create time settings
        if ( !$GetParam{ArticleTimeSearchType} ) {

            # do nothing on time stuff
        }
        elsif ( $GetParam{ArticleTimeSearchType} eq 'TimeSlot' ) {
            for (qw(Month Day)) {
                $GetParam{"ArticleCreateTimeStart$_"}
                    = sprintf( "%02d", $GetParam{"ArticleCreateTimeStart$_"} );
            }
            for (qw(Month Day)) {
                $GetParam{"ArticleCreateTimeStop$_"}
                    = sprintf( "%02d", $GetParam{"ArticleCreateTimeStop$_"} );
            }
            if (
                $GetParam{ArticleCreateTimeStartDay}
                && $GetParam{ArticleCreateTimeStartMonth}
                && $GetParam{ArticleCreateTimeStartYear}
                )
            {
                $GetParam{ArticleCreateTimeNewerDate}
                    = $GetParam{ArticleCreateTimeStartYear} . '-'
                    . $GetParam{ArticleCreateTimeStartMonth} . '-'
                    . $GetParam{ArticleCreateTimeStartDay}
                    . ' 00:00:01';
            }
            if (
                $GetParam{ArticleCreateTimeStopDay}
                && $GetParam{ArticleCreateTimeStopMonth}
                && $GetParam{ArticleCreateTimeStopYear}
                )
            {
                $GetParam{ArticleCreateTimeOlderDate}
                    = $GetParam{ArticleCreateTimeStopYear} . '-'
                    . $GetParam{ArticleCreateTimeStopMonth} . '-'
                    . $GetParam{ArticleCreateTimeStopDay}
                    . ' 23:59:59';
            }
        }
        elsif ( $GetParam{ArticleTimeSearchType} eq 'TimePoint' ) {
            if (
                $GetParam{ArticleCreateTimePoint}
                && $GetParam{ArticleCreateTimePointStart}
                && $GetParam{ArticleCreateTimePointFormat}
                )
            {
                my $Time = 0;
                if ( $GetParam{ArticleCreateTimePointFormat} eq 'minute' ) {
                    $Time = $GetParam{ArticleCreateTimePoint};
                }
                elsif ( $GetParam{ArticleCreateTimePointFormat} eq 'hour' ) {
                    $Time = $GetParam{ArticleCreateTimePoint} * 60;
                }
                elsif ( $GetParam{ArticleCreateTimePointFormat} eq 'day' ) {
                    $Time = $GetParam{ArticleCreateTimePoint} * 60 * 24;
                }
                elsif ( $GetParam{ArticleCreateTimePointFormat} eq 'week' ) {
                    $Time = $GetParam{ArticleCreateTimePoint} * 60 * 24 * 7;
                }
                elsif ( $GetParam{ArticleCreateTimePointFormat} eq 'month' ) {
                    $Time = $GetParam{ArticleCreateTimePoint} * 60 * 24 * 30;
                }
                elsif ( $GetParam{ArticleCreateTimePointFormat} eq 'year' ) {
                    $Time = $GetParam{ArticleCreateTimePoint} * 60 * 24 * 365;
                }
                if ( $GetParam{ArticleCreateTimePointStart} eq 'Before' ) {
                    $GetParam{ArticleCreateTimeOlderMinutes} = $Time;
                }
                else {
                    $GetParam{ArticleCreateTimeNewerMinutes} = $Time;
                }
            }
        }

        # get create time settings
        if ( !$GetParam{TimeSearchType} ) {

            # do noting ont time stuff
        }
        elsif ( $GetParam{TimeSearchType} eq 'TimeSlot' ) {
            for (qw(Month Day)) {
                $GetParam{"TicketCreateTimeStart$_"}
                    = sprintf( "%02d", $GetParam{"TicketCreateTimeStart$_"} );
            }
            for (qw(Month Day)) {
                $GetParam{"TicketCreateTimeStop$_"}
                    = sprintf( "%02d", $GetParam{"TicketCreateTimeStop$_"} );
            }
            if (
                $GetParam{TicketCreateTimeStartDay}
                && $GetParam{TicketCreateTimeStartMonth}
                && $GetParam{TicketCreateTimeStartYear}
                )
            {
                $GetParam{TicketCreateTimeNewerDate}
                    = $GetParam{TicketCreateTimeStartYear} . '-'
                    . $GetParam{TicketCreateTimeStartMonth} . '-'
                    . $GetParam{TicketCreateTimeStartDay}
                    . ' 00:00:01';
            }
            if (
                $GetParam{TicketCreateTimeStopDay}
                && $GetParam{TicketCreateTimeStopMonth}
                && $GetParam{TicketCreateTimeStopYear}
                )
            {
                $GetParam{TicketCreateTimeOlderDate}
                    = $GetParam{TicketCreateTimeStopYear} . '-'
                    . $GetParam{TicketCreateTimeStopMonth} . '-'
                    . $GetParam{TicketCreateTimeStopDay}
                    . ' 23:59:59';
            }
        }
        elsif ( $GetParam{TimeSearchType} eq 'TimePoint' ) {
            if (
                $GetParam{TicketCreateTimePoint}
                && $GetParam{TicketCreateTimePointStart}
                && $GetParam{TicketCreateTimePointFormat}
                )
            {
                my $Time = 0;
                if ( $GetParam{TicketCreateTimePointFormat} eq 'minute' ) {
                    $Time = $GetParam{TicketCreateTimePoint};
                }
                elsif ( $GetParam{TicketCreateTimePointFormat} eq 'hour' ) {
                    $Time = $GetParam{TicketCreateTimePoint} * 60;
                }
                elsif ( $GetParam{TicketCreateTimePointFormat} eq 'day' ) {
                    $Time = $GetParam{TicketCreateTimePoint} * 60 * 24;
                }
                elsif ( $GetParam{TicketCreateTimePointFormat} eq 'week' ) {
                    $Time = $GetParam{TicketCreateTimePoint} * 60 * 24 * 7;
                }
                elsif ( $GetParam{TicketCreateTimePointFormat} eq 'month' ) {
                    $Time = $GetParam{TicketCreateTimePoint} * 60 * 24 * 30;
                }
                elsif ( $GetParam{TicketCreateTimePointFormat} eq 'year' ) {
                    $Time = $GetParam{TicketCreateTimePoint} * 60 * 24 * 365;
                }
                if ( $GetParam{TicketCreateTimePointStart} eq 'Before' ) {
                    $GetParam{TicketCreateTimeOlderMinutes} = $Time;
                }
                else {
                    $GetParam{TicketCreateTimeNewerMinutes} = $Time;
                }
            }
        }

        # get close time settings
        if ( !$GetParam{ChangeTimeSearchType} ) {

            # do noting ont time stuff
        }
        elsif ( $GetParam{ChangeTimeSearchType} eq 'TimeSlot' ) {
            for (qw(Month Day)) {
                $GetParam{"TicketChangeTimeStart$_"}
                    = sprintf( "%02d", $GetParam{"TicketChangeTimeStart$_"} );
            }
            for (qw(Month Day)) {
                $GetParam{"TicketChangeTimeStop$_"}
                    = sprintf( "%02d", $GetParam{"TicketChangeTimeStop$_"} );
            }
            if (
                $GetParam{TicketChangeTimeStartDay}
                && $GetParam{TicketChangeTimeStartMonth}
                && $GetParam{TicketChangeTimeStartYear}
                )
            {
                $GetParam{TicketChangeTimeNewerDate}
                    = $GetParam{TicketChangeTimeStartYear} . '-'
                    . $GetParam{TicketChangeTimeStartMonth} . '-'
                    . $GetParam{TicketChangeTimeStartDay}
                    . ' 00:00:01';
            }
            if (
                $GetParam{TicketChangeTimeStopDay}
                && $GetParam{TicketChangeTimeStopMonth}
                && $GetParam{TicketChangeTimeStopYear}
                )
            {
                $GetParam{TicketChangeTimeOlderDate}
                    = $GetParam{TicketChangeTimeStopYear} . '-'
                    . $GetParam{TicketChangeTimeStopMonth} . '-'
                    . $GetParam{TicketChangeTimeStopDay}
                    . ' 23:59:59';
            }
        }
        elsif ( $GetParam{ChangeTimeSearchType} eq 'TimePoint' ) {
            if (
                $GetParam{TicketChangeTimePoint}
                && $GetParam{TicketChangeTimePointStart}
                && $GetParam{TicketChangeTimePointFormat}
                )
            {
                my $Time = 0;
                if ( $GetParam{TicketChangeTimePointFormat} eq 'minute' ) {
                    $Time = $GetParam{TicketChangeTimePoint};
                }
                elsif ( $GetParam{TicketChangeTimePointFormat} eq 'hour' ) {
                    $Time = $GetParam{TicketChangeTimePoint} * 60;
                }
                elsif ( $GetParam{TicketChangeTimePointFormat} eq 'day' ) {
                    $Time = $GetParam{TicketChangeTimePoint} * 60 * 24;
                }
                elsif ( $GetParam{TicketChangeTimePointFormat} eq 'week' ) {
                    $Time = $GetParam{TicketChangeTimePoint} * 60 * 24 * 7;
                }
                elsif ( $GetParam{TicketChangeTimePointFormat} eq 'month' ) {
                    $Time = $GetParam{TicketChangeTimePoint} * 60 * 24 * 30;
                }
                elsif ( $GetParam{TicketChangeTimePointFormat} eq 'year' ) {
                    $Time = $GetParam{TicketChangeTimePoint} * 60 * 24 * 365;
                }
                if ( $GetParam{TicketChangeTimePointStart} eq 'Before' ) {
                    $GetParam{TicketChangeTimeOlderMinutes} = $Time;
                }
                else {
                    $GetParam{TicketChangeTimeNewerMinutes} = $Time;
                }
            }
        }

        # get close time settings
        if ( !$GetParam{CloseTimeSearchType} ) {

            # do noting ont time stuff
        }
        elsif ( $GetParam{CloseTimeSearchType} eq 'TimeSlot' ) {
            for (qw(Month Day)) {
                $GetParam{"TicketCloseTimeStart$_"}
                    = sprintf( "%02d", $GetParam{"TicketCloseTimeStart$_"} );
            }
            for (qw(Month Day)) {
                $GetParam{"TicketCloseTimeStop$_"}
                    = sprintf( "%02d", $GetParam{"TicketCloseTimeStop$_"} );
            }
            if (
                $GetParam{TicketCloseTimeStartDay}
                && $GetParam{TicketCloseTimeStartMonth}
                && $GetParam{TicketCloseTimeStartYear}
                )
            {
                $GetParam{TicketCloseTimeNewerDate}
                    = $GetParam{TicketCloseTimeStartYear} . '-'
                    . $GetParam{TicketCloseTimeStartMonth} . '-'
                    . $GetParam{TicketCloseTimeStartDay}
                    . ' 00:00:01';
            }
            if (
                $GetParam{TicketCloseTimeStopDay}
                && $GetParam{TicketCloseTimeStopMonth}
                && $GetParam{TicketCloseTimeStopYear}
                )
            {
                $GetParam{TicketCloseTimeOlderDate}
                    = $GetParam{TicketCloseTimeStopYear} . '-'
                    . $GetParam{TicketCloseTimeStopMonth} . '-'
                    . $GetParam{TicketCloseTimeStopDay}
                    . ' 23:59:59';
            }
        }
        elsif ( $GetParam{CloseTimeSearchType} eq 'TimePoint' ) {
            if (
                $GetParam{TicketCloseTimePoint}
                && $GetParam{TicketCloseTimePointStart}
                && $GetParam{TicketCloseTimePointFormat}
                )
            {
                my $Time = 0;
                if ( $GetParam{TicketCloseTimePointFormat} eq 'minute' ) {
                    $Time = $GetParam{TicketCloseTimePoint};
                }
                elsif ( $GetParam{TicketCloseTimePointFormat} eq 'hour' ) {
                    $Time = $GetParam{TicketCloseTimePoint} * 60;
                }
                elsif ( $GetParam{TicketCloseTimePointFormat} eq 'day' ) {
                    $Time = $GetParam{TicketCloseTimePoint} * 60 * 24;
                }
                elsif ( $GetParam{TicketCloseTimePointFormat} eq 'week' ) {
                    $Time = $GetParam{TicketCloseTimePoint} * 60 * 24 * 7;
                }
                elsif ( $GetParam{TicketCloseTimePointFormat} eq 'month' ) {
                    $Time = $GetParam{TicketCloseTimePoint} * 60 * 24 * 30;
                }
                elsif ( $GetParam{TicketCloseTimePointFormat} eq 'year' ) {
                    $Time = $GetParam{TicketCloseTimePoint} * 60 * 24 * 365;
                }
                if ( $GetParam{TicketCloseTimePointStart} eq 'Before' ) {
                    $GetParam{TicketCloseTimeOlderMinutes} = $Time;
                }
                else {
                    $GetParam{TicketCloseTimeNewerMinutes} = $Time;
                }
            }
        }

        # have a fulltext search per default
        for (qw(ChangeTitle)) {
            if ( defined( $GetParam{$_} ) && $GetParam{$_} ne '' ) {
                $GetParam{$_} = "*$GetParam{$_}*";
            }
        }

        # perform ticket search
        my @ViewableChangeIDs = $Self->{ChangeObject}->ChangeSearch(
            Result          => 'ARRAY',
            SortBy          => $Self->{SortBy},
            OrderBy         => $Self->{OrderBy},
            Limit           => $Self->{SearchLimit},
            UserID          => $Self->{UserID},
            ConditionInline => $Self->{Config}->{ExtendedSearchCondition},
            FullTextIndex   => 1,
            %GetParam,
        );

        if ( $GetParam{ResultForm} eq 'CSV' ) {

            # TODO: remove or implement
        }
        elsif ( $GetParam{ResultForm} eq 'Print' ) {

            # TODO: remove or implement
        }
        else {

            # start html page
            my $Output = $Self->{LayoutObject}->Header();
            $Output .= $Self->{LayoutObject}->NavigationBar();
            $Self->{LayoutObject}->Print( Output => \$Output );
            $Output = '';

            $Self->{Filter} = $Self->{ParamObject}->GetParam( Param => 'Filter' ) || '';
            $Self->{View}   = $Self->{ParamObject}->GetParam( Param => 'View' )   || '';

            # show ticket's
            my $LinkPage = 'Filter='
                . $Self->{LayoutObject}->Ascii2Html( Text => $Self->{Filter} )
                . '&View=' . $Self->{LayoutObject}->Ascii2Html( Text => $Self->{View} )
                . '&SortBy=' . $Self->{LayoutObject}->Ascii2Html( Text => $Self->{SortBy} )
                . '&OrderBy=' . $Self->{LayoutObject}->Ascii2Html( Text => $Self->{OrderBy} )
                . '&Profile=' . $Self->{Profile} . '&TakeLastSearch=1&Subaction=Search'
                . '&';
            my $LinkSort = 'Filter='
                . $Self->{LayoutObject}->Ascii2Html( Text => $Self->{Filter} )
                . '&View=' . $Self->{LayoutObject}->Ascii2Html( Text => $Self->{View} )
                . '&Profile=' . $Self->{Profile} . '&TakeLastSearch=1&Subaction=Search'
                . '&';
            my $LinkFilter = 'TakeLastSearch=1&Subaction=Search&Profile='
                . $Self->{LayoutObject}->Ascii2Html( Text => $Self->{Profile} )
                . '&';
            my $LinkBack = 'Subaction=LoadProfile&Profile='
                . $Self->{LayoutObject}->Ascii2Html( Text => $Self->{Profile} )
                . '&TakeLastSearch=1&';

            my $FilterLink
                = 'SortBy=' . $Self->{LayoutObject}->Ascii2Html( Text => $Self->{SortBy} )
                . '&OrderBy=' . $Self->{LayoutObject}->Ascii2Html( Text => $Self->{OrderBy} )
                . '&View=' . $Self->{LayoutObject}->Ascii2Html( Text => $Self->{View} )
                . '&Profile=' . $Self->{Profile} . '&TakeLastSearch=1&Subaction=Search'
                . '&';
            $Output .= $Self->{LayoutObject}->ChangeListShow(
                ChangeIDs => \@ViewableChangeIDs,
                Total     => scalar @ViewableChangeIDs,

                View => $Self->{View},

                Env        => $Self,
                LinkPage   => $LinkPage,
                LinkSort   => $LinkSort,
                LinkFilter => $LinkFilter,
                LinkBack   => $LinkBack,

                TitleName => 'Search Result',
                Bulk      => 1,
                Limit     => $Self->{SearchLimit},

                Filter     => $Self->{Filter},
                FilterLink => $FilterLink,

            );

            # build footer
            $Output .= $Self->{LayoutObject}->Footer();
            return $Output;
        }
    }

    # empty search site
    else {

        # generate search mask
        my $Output = $Self->{LayoutObject}->Header();

        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Output .= $Self->MaskForm( %GetParam, Profile => $Self->{Profile}, );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
}

sub MaskForm {
    my ( $Self, %Param ) = @_;

    # TODO: get change-builders, get change-managers
    # get user of own groups
    my %ShownUsers = $Self->{UserObject}->UserList(
        Type  => 'Long',
        Valid => 1,
    );
    if ( !$Self->{ConfigObject}->Get('Ticket::ChangeOwnerToEveryone') ) {
        my %Involved = $Self->{GroupObject}->GroupMemberInvolvedList(
            UserID => $Self->{UserID},
            Type   => 'ro',
        );
        for my $UserID ( keys %ShownUsers ) {
            if ( !$Involved{$UserID} ) {
                delete $ShownUsers{$UserID};
            }
        }
    }
    $Param{'ChangeManagerSelectionStrg'} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data               => \%ShownUsers,
        Name               => 'OwnerIDs',
        Multiple           => 1,
        Size               => 5,
        SelectedIDRefArray => $Param{OwnerIDs},
    );
    $Param{'CreatedUserStrg'} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data               => \%ShownUsers,
        Name               => 'CreatedUserIDs',
        Multiple           => 1,
        Size               => 5,
        SelectedIDRefArray => $Param{CreatedUserIDs},
    );
    $Param{'ResultFormStrg'} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data => {
            Normal => 'Normal',
            Print  => 'Print',
            CSV    => 'CSV',
        },
        Name => 'ResultForm',
        SelectedID => $Param{ResultForm} || 'Normal',
    );
    $Param{'StatesStrg'} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data => {
            $Self->{StateObject}->StateList(
                UserID => $Self->{UserID},
                Action => $Self->{Action},
            ),
        },
        Name               => 'StateIDs',
        Multiple           => 1,
        Size               => 5,
        SelectedIDRefArray => $Param{StateIDs},
    );
    $Param{'PrioritiesStrg'} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data => {
            $Self->{PriorityObject}->PriorityList(
                UserID => $Self->{UserID},
                Action => $Self->{Action},
            ),
        },
        Name               => 'PriorityIDs',
        Multiple           => 1,
        Size               => 5,
        SelectedIDRefArray => $Param{PriorityIDs},
    );

    $Param{'ArticleCreateTimePoint'} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data => {
            1  => ' 1',
            2  => ' 2',
            3  => ' 3',
            4  => ' 4',
            5  => ' 5',
            6  => ' 6',
            7  => ' 7',
            8  => ' 8',
            9  => ' 9',
            10 => '10',
            11 => '11',
            12 => '12',
            13 => '13',
            14 => '14',
            15 => '15',
            16 => '16',
            17 => '17',
            18 => '18',
            19 => '19',
            20 => '20',
            21 => '21',
            22 => '22',
            23 => '23',
            24 => '24',
            25 => '25',
            26 => '26',
            27 => '27',
            28 => '28',
            29 => '29',
            30 => '30',
            31 => '31',
            32 => '32',
            33 => '33',
            34 => '34',
            35 => '35',
            36 => '36',
            37 => '37',
            38 => '38',
            39 => '39',
            40 => '40',
            41 => '41',
            42 => '42',
            43 => '43',
            44 => '44',
            45 => '45',
            46 => '46',
            47 => '47',
            48 => '48',
            49 => '49',
            50 => '50',
            51 => '51',
            52 => '52',
            53 => '53',
            54 => '54',
            55 => '55',
            56 => '56',
            57 => '57',
            58 => '58',
            59 => '59',
        },
        Name       => 'ArticleCreateTimePoint',
        SelectedID => $Param{ArticleCreateTimePoint},
    );
    $Param{'ArticleCreateTimePointStart'} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data => {
            'Last'   => 'last',
            'Before' => 'before',
        },
        Name => 'ArticleCreateTimePointStart',
        SelectedID => $Param{ArticleCreateTimePointStart} || 'Last',
    );
    $Param{'ArticleCreateTimePointFormat'} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data => {
            minute => 'minute(s)',
            hour   => 'hour(s)',
            day    => 'day(s)',
            week   => 'week(s)',
            month  => 'month(s)',
            year   => 'year(s)',
        },
        Name       => 'ArticleCreateTimePointFormat',
        SelectedID => $Param{ArticleCreateTimePointFormat},
    );
    $Param{ArticleCreateTimeStart} = $Self->{LayoutObject}->BuildDateSelection(
        %Param,
        Prefix   => 'ArticleCreateTimeStart',
        Format   => 'DateInputFormat',
        DiffTime => -( ( 60 * 60 * 24 ) * 30 ),
    );
    $Param{ArticleCreateTimeStop} = $Self->{LayoutObject}->BuildDateSelection(
        %Param,
        Prefix => 'ArticleCreateTimeStop',
        Format => 'DateInputFormat',
    );
    $Param{'TicketCreateTimePoint'} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data => {
            1  => ' 1',
            2  => ' 2',
            3  => ' 3',
            4  => ' 4',
            5  => ' 5',
            6  => ' 6',
            7  => ' 7',
            8  => ' 8',
            9  => ' 9',
            10 => '10',
            11 => '11',
            12 => '12',
            13 => '13',
            14 => '14',
            15 => '15',
            16 => '16',
            17 => '17',
            18 => '18',
            19 => '19',
            20 => '20',
            21 => '21',
            22 => '22',
            23 => '23',
            24 => '24',
            25 => '25',
            26 => '26',
            27 => '27',
            28 => '28',
            29 => '29',
            30 => '30',
            31 => '31',
            32 => '32',
            33 => '33',
            34 => '34',
            35 => '35',
            36 => '36',
            37 => '37',
            38 => '38',
            39 => '39',
            40 => '40',
            41 => '41',
            42 => '42',
            43 => '43',
            44 => '44',
            45 => '45',
            46 => '46',
            47 => '47',
            48 => '48',
            49 => '49',
            50 => '50',
            51 => '51',
            52 => '52',
            53 => '53',
            54 => '54',
            55 => '55',
            56 => '56',
            57 => '57',
            58 => '58',
            59 => '59',
        },
        Name       => 'TicketCreateTimePoint',
        SelectedID => $Param{TicketCreateTimePoint},
    );
    $Param{'TicketCreateTimePointStart'} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data => {
            'Last'   => 'last',
            'Before' => 'before',
        },
        Name => 'TicketCreateTimePointStart',
        SelectedID => $Param{TicketCreateTimePointStart} || 'Last',
    );
    $Param{'TicketCreateTimePointFormat'} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data => {
            minute => 'minute(s)',
            hour   => 'hour(s)',
            day    => 'day(s)',
            week   => 'week(s)',
            month  => 'month(s)',
            year   => 'year(s)',
        },
        Name       => 'TicketCreateTimePointFormat',
        SelectedID => $Param{TicketCreateTimePointFormat},
    );
    $Param{TicketCreateTimeStart} = $Self->{LayoutObject}->BuildDateSelection(
        %Param,
        Prefix   => 'TicketCreateTimeStart',
        Format   => 'DateInputFormat',
        DiffTime => -( ( 60 * 60 * 24 ) * 30 ),
    );
    $Param{TicketCreateTimeStop} = $Self->{LayoutObject}->BuildDateSelection(
        %Param,
        Prefix => 'TicketCreateTimeStop',
        Format => 'DateInputFormat',
    );

    for ( 1 .. 6 ) {
        $Param{ 'TicketFreeTime' . $_ . 'Start' } = $Self->{LayoutObject}->BuildDateSelection(
            %Param,
            Prefix   => 'TicketFreeTime' . $_ . 'Start',
            Format   => 'DateInputFormat',
            DiffTime => -( ( 60 * 60 * 24 ) * 30 ),
        );
        $Param{ 'TicketFreeTime' . $_ . 'Stop' } = $Self->{LayoutObject}->BuildDateSelection(
            %Param,
            Prefix   => 'TicketFreeTime' . $_ . 'Stop',
            Format   => 'DateInputFormat',
            DiffTime => +( ( 60 * 60 * 24 ) * 30 ),
        );
    }

    $Param{'TicketChangeTimePoint'} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data => {
            1  => ' 1',
            2  => ' 2',
            3  => ' 3',
            4  => ' 4',
            5  => ' 5',
            6  => ' 6',
            7  => ' 7',
            8  => ' 8',
            9  => ' 9',
            10 => '10',
            11 => '11',
            12 => '12',
            13 => '13',
            14 => '14',
            15 => '15',
            16 => '16',
            17 => '17',
            18 => '18',
            19 => '19',
            20 => '20',
            21 => '21',
            22 => '22',
            23 => '23',
            24 => '24',
            25 => '25',
            26 => '26',
            27 => '27',
            28 => '28',
            29 => '29',
            30 => '30',
            31 => '31',
            32 => '32',
            33 => '33',
            34 => '34',
            35 => '35',
            36 => '36',
            37 => '37',
            38 => '38',
            39 => '39',
            40 => '40',
            41 => '41',
            42 => '42',
            43 => '43',
            44 => '44',
            45 => '45',
            46 => '46',
            47 => '47',
            48 => '48',
            49 => '49',
            50 => '50',
            51 => '51',
            52 => '52',
            53 => '53',
            54 => '54',
            55 => '55',
            56 => '56',
            57 => '57',
            58 => '58',
            59 => '59',
        },
        Name       => 'TicketChangeTimePoint',
        SelectedID => $Param{TicketChangeTimePoint},
    );
    $Param{'TicketChangeTimePointStart'} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data => {
            'Last'   => 'last',
            'Before' => 'before',
        },
        Name => 'TicketChangeTimePointStart',
        SelectedID => $Param{TicketChangeTimePointStart} || 'Last',
    );
    $Param{'TicketChangeTimePointFormat'} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data => {
            minute => 'minute(s)',
            hour   => 'hour(s)',
            day    => 'day(s)',
            week   => 'week(s)',
            month  => 'month(s)',
            year   => 'year(s)',
        },
        Name       => 'TicketChangeTimePointFormat',
        SelectedID => $Param{TicketChangeTimePointFormat},
    );
    $Param{TicketChangeTimeStart} = $Self->{LayoutObject}->BuildDateSelection(
        %Param,
        Prefix   => 'TicketChangeTimeStart',
        Format   => 'DateInputFormat',
        DiffTime => -( ( 60 * 60 * 24 ) * 30 ),
    );
    $Param{TicketChangeTimeStop} = $Self->{LayoutObject}->BuildDateSelection(
        %Param,
        Prefix => 'TicketChangeTimeStop',
        Format => 'DateInputFormat',
    );

    $Param{'TicketCloseTimePoint'} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data => {
            1  => ' 1',
            2  => ' 2',
            3  => ' 3',
            4  => ' 4',
            5  => ' 5',
            6  => ' 6',
            7  => ' 7',
            8  => ' 8',
            9  => ' 9',
            10 => '10',
            11 => '11',
            12 => '12',
            13 => '13',
            14 => '14',
            15 => '15',
            16 => '16',
            17 => '17',
            18 => '18',
            19 => '19',
            20 => '20',
            21 => '21',
            22 => '22',
            23 => '23',
            24 => '24',
            25 => '25',
            26 => '26',
            27 => '27',
            28 => '28',
            29 => '29',
            30 => '30',
            31 => '31',
            32 => '32',
            33 => '33',
            34 => '34',
            35 => '35',
            36 => '36',
            37 => '37',
            38 => '38',
            39 => '39',
            40 => '40',
            41 => '41',
            42 => '42',
            43 => '43',
            44 => '44',
            45 => '45',
            46 => '46',
            47 => '47',
            48 => '48',
            49 => '49',
            50 => '50',
            51 => '51',
            52 => '52',
            53 => '53',
            54 => '54',
            55 => '55',
            56 => '56',
            57 => '57',
            58 => '58',
            59 => '59',
        },
        Name       => 'TicketCloseTimePoint',
        SelectedID => $Param{TicketCloseTimePoint},
    );
    $Param{'TicketCloseTimePointStart'} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data => {
            'Last'   => 'last',
            'Before' => 'before',
        },
        Name => 'TicketCloseTimePointStart',
        SelectedID => $Param{TicketCloseTimePointStart} || 'Last',
    );
    $Param{'TicketCloseTimePointFormat'} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data => {
            minute => 'minute(s)',
            hour   => 'hour(s)',
            day    => 'day(s)',
            week   => 'week(s)',
            month  => 'month(s)',
            year   => 'year(s)',
        },
        Name       => 'TicketCloseTimePointFormat',
        SelectedID => $Param{TicketCloseTimePointFormat},
    );
    $Param{TicketCloseTimeStart} = $Self->{LayoutObject}->BuildDateSelection(
        %Param,
        Prefix   => 'TicketCloseTimeStart',
        Format   => 'DateInputFormat',
        DiffTime => -( ( 60 * 60 * 24 ) * 30 ),
    );
    $Param{TicketCloseTimeStop} = $Self->{LayoutObject}->BuildDateSelection(
        %Param,
        Prefix => 'TicketCloseTimeStop',
        Format => 'DateInputFormat',
    );

    for ( 1 .. 6 ) {
        $Param{ 'TicketFreeTime' . $_ . 'Start' } = $Self->{LayoutObject}->BuildDateSelection(
            %Param,
            Prefix   => 'TicketFreeTime' . $_ . 'Start',
            Format   => 'DateInputFormat',
            DiffTime => -( ( 60 * 60 * 24 ) * 30 ),
        );
        $Param{ 'TicketFreeTime' . $_ . 'Stop' } = $Self->{LayoutObject}->BuildDateSelection(
            %Param,
            Prefix   => 'TicketFreeTime' . $_ . 'Stop',
            Format   => 'DateInputFormat',
            DiffTime => +( ( 60 * 60 * 24 ) * 30 ),
        );
    }

    # html search mask output
    $Self->{LayoutObject}->Block(
        Name => 'Search',
        Data => { %Param, },
    );

    # build type string
    if ( $Self->{ConfigObject}->Get('Ticket::Type') ) {
        my %Type = $Self->{TypeObject}->TypeList( UserID => $Self->{UserID}, );
        $Param{'TypesStrg'} = $Self->{LayoutObject}->BuildSelection(
            Data        => \%Type,
            Name        => 'TypeIDs',
            SelectedID  => $Param{TypeIDs},
            Sort        => 'AlphanumericValue',
            Size        => 3,
            Multiple    => 1,
            Translation => 0,
        );
        $Self->{LayoutObject}->Block(
            Name => 'TicketType',
            Data => {%Param},
        );
    }

    if (
        $Self->{ConfigObject}->Get('Ticket::Watcher')
        || $Self->{ConfigObject}->Get('Ticket::Responsible')
        )
    {
        $Self->{LayoutObject}->Block( Name => 'TicketResponsibleWatcher', );
        if ( $Self->{ConfigObject}->Get('Ticket::Watcher') ) {
            $Self->{LayoutObject}->Block(
                Name => 'TicketResponsibleWatcherHeaderOn',
                Data => { Headline => 'Watcher', },
            );
            my $SelectStrg = $Self->{LayoutObject}->BuildSelection(
                Data        => \%ShownUsers,
                Name        => 'WatchUserIDs',
                SelectedID  => $Param{WatchUserIDs},
                Sort        => 'AlphanumericValue',
                Size        => 5,
                Multiple    => 1,
                Translation => 0,
            );
            $Self->{LayoutObject}->Block(
                Name => 'TicketResponsibleWatcherBodyOn',
                Data => { %Param, SelectStrg => $SelectStrg, },
            );
        }
        else {
            $Self->{LayoutObject}->Block( Name => 'TicketResponsibleWatcherHeaderOff', );
            $Self->{LayoutObject}->Block( Name => 'TicketResponsibleWatcherBodyOff', );
        }
        if ( $Self->{ConfigObject}->Get('Ticket::Responsible') ) {
            $Self->{LayoutObject}->Block(
                Name => 'TicketResponsibleWatcherHeaderOn',
                Data => { Headline => 'Responsible', },
            );
            my $SelectStrg = $Self->{LayoutObject}->BuildSelection(
                Data        => \%ShownUsers,
                Name        => 'ResponsibleIDs',
                SelectedID  => $Param{ResponsibleIDs},
                Sort        => 'AlphanumericValue',
                Size        => 5,
                Multiple    => 1,
                Translation => 0,
            );
            $Self->{LayoutObject}->Block(
                Name => 'TicketResponsibleWatcherBodyOn',
                Data => { %Param, SelectStrg => $SelectStrg, },
            );
        }
        else {
            $Self->{LayoutObject}->Block( Name => 'TicketResponsibleWatcherHeaderOff', );
            $Self->{LayoutObject}->Block( Name => 'TicketResponsibleWatcherBodyOff', );
        }
    }
    for my $Count ( 1 .. 16 ) {
        if ( $Self->{Config}->{'TicketFreeText'}->{$Count} ) {
            $Self->{LayoutObject}->Block(
                Name => 'TicketFreeText',
                Data => {
                    TicketFreeKeyField  => $Param{ 'TicketFreeKeyField' . $Count },
                    TicketFreeTextField => $Param{ 'TicketFreeTextField' . $Count },
                    Count               => $Count,
                },
            );
            $Self->{LayoutObject}->Block(
                Name => 'TicketFreeText' . $Count,
                Data => { %Param, },
            );
        }
    }
    for my $Count ( 1 .. 6 ) {
        if ( $Self->{Config}->{'TicketFreeTime'}->{$Count} ) {
            $Self->{LayoutObject}->Block(
                Name => 'TicketFreeTime',
                Data => {
                    TicketFreeTimeKey => $Self->{ConfigObject}->Get( 'TicketFreeTimeKey' . $Count ),
                    TicketFreeTime    => $Param{ 'TicketFreeTime' . $Count },
                    TicketFreeTimeStart => $Param{ 'TicketFreeTime' . $Count . 'Start' },
                    TicketFreeTimeStop  => $Param{ 'TicketFreeTime' . $Count . 'Stop' },
                    Count               => $Count,
                },
            );
            $Self->{LayoutObject}->Block(
                Name => 'TicketFreeTime' . $Count,
                Data => { %Param, Count => $Count, },
            );
        }
    }
    if ( $Self->{Config}->{'ArticleCreateTime'} ) {
        $Self->{LayoutObject}->Block(
            Name => 'ArticleCreateTime',
            Data => {%Param},
        );
    }
    my $Output = $Self->{LayoutObject}->Output(
        TemplateFile => 'ITSMChangeSearch',
        Data         => \%Param,
    );
    return $Output;
}

1;
