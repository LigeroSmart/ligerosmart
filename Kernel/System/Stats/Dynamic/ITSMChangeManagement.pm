# --
# Kernel/System/Stats/Dynamic/ITSMChangeManagement.pm - all advice functions
# Copyright (C) 2003-2010 OTRS AG, http://otrs.com/
# --
# $Id: ITSMChangeManagement.pm,v 1.2 2010-01-08 12:55:28 reb Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Stats::Dynamic::ITSMChangeManagement;

use strict;
use warnings;

use Kernel::System::ITSMChange;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.2 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for my $Object (
        qw(DBObject ConfigObject LogObject UserObject TimeObject MainObject EncodeObject)
        )
    {
        $Self->{$Object} = $Param{$Object} || die "Got no $Object!";
    }
    $Self->{ChangeObject} = Kernel::System::ITSMChange->new( %{$Self} );

    return $Self;
}

sub GetObjectName {
    my ( $Self, %Param ) = @_;

    return 'ITSMChangeManagement';
}

sub GetObjectAttributes {
    my ( $Self, %Param ) = @_;

    # get user list
    my %UserList = $Self->{UserObject}->UserList(
        Type  => 'Long',
        Valid => 0,
    );

    # get change state list
    my $ChangeStates = $Self->{ChangeObject}->ChangePossibleStatesGet(
        UserID => 1,
    );
    my %ChangeStateList = map { $_->{Key} => $_->{Value} } @{$ChangeStates};

    # get cip lists
    my $Categories = $Self->{ChangeObject}->ChangePossibleCIPGet(
        Type => 'Category',
    );
    my %CategoryList = map { $_->{Key} => $_->{Value} } @{$Categories};

    my $Impacts = $Self->{ChangeObject}->ChangePossibleCIPGet(
        Type => 'Impact',
    );
    my %ImpactList = map { $_->{Key} => $_->{Value} } @{$Impacts};

    my $Priorities = $Self->{ChangeObject}->ChangePossibleCIPGet(
        Type => 'Priority',
    );
    my %PriorityList = map { $_->{Key} => $_->{Value} } @{$Priorities};

    my @ObjectAttributes = (
        {
            Name             => 'Change State',
            UseAsXvalue      => 1,
            UseAsValueSeries => 1,
            UseAsRestriction => 1,
            Element          => 'StateIDs',
            Block            => 'MultiSelectField',
            Values           => \%ChangeStateList,
        },
        {
            Name             => 'Category',
            UseAsXvalue      => 1,
            UseAsValueSeries => 1,
            UseAsRestriction => 1,
            Element          => 'CategoryIDs',
            Block            => 'MultiSelectField',
            Values           => \%CategoryList,
        },
        {
            Name             => 'Priority',
            UseAsXvalue      => 1,
            UseAsValueSeries => 1,
            UseAsRestriction => 1,
            Element          => 'PriorityIDs',
            Block            => 'MultiSelectField',
            Values           => \%PriorityList,
        },
        {
            Name             => 'Impact',
            UseAsXvalue      => 1,
            UseAsValueSeries => 1,
            UseAsRestriction => 1,
            Element          => 'ImpactIDs',
            Block            => 'MultiSelectField',
            Translation      => 0,
            Values           => \%ImpactList,
        },
        {
            Name             => 'Timeperiod',
            UseAsXvalue      => 1,
            UseAsValueSeries => 1,
            UseAsRestriction => 1,
            Element          => 'TimePeriod',
            TimePeriodFormat => 'DateInputFormat',    # 'DateInputFormatLong',
            Block            => 'Time',
            Values           => {
                TimeStart => 'CreateTimeNewerDate',
                TimeStop  => 'CreateTimeOlderDate',
            },
        },

        # CI-Status
        # CI-Types
        # ChangeInitiators
    );

    return @ObjectAttributes;
}

sub GetStatElement {
    my ( $Self, %Param ) = @_;

    # search tickets
    return $Self->{ChangeObject}->ChangeSearch(
        UserID     => 1,
        Result     => 'COUNT',
        Permission => 'ro',
        Limit      => 100_000_000,
        %Param,
    );
}

sub ExportWrapper {
    my ( $Self, %Param ) = @_;

    # wrap ids to used spelling
    for my $Use (qw(UseAsValueSeries UseAsRestriction UseAsXvalue)) {
        ELEMENT:
        for my $Element ( @{ $Param{$Use} } ) {
            next ELEMENT if !$Element || !$Element->{SelectedValues};
            my $ElementName = $Element->{Element};
            my $Values      = $Element->{SelectedValues};

            if ( $ElementName eq 'StateIDs' ) {
                my $StateList = $Self->{ChangeObject}->ChangePossibleStatesGet( UserID => 1 );
                ID:
                for my $ID ( @{$Values} ) {
                    next ID if !$ID;

                    STATE:
                    for my $State ( @{$StateList} ) {
                        next STATE if $ID->{Content} ne $State->{Key};
                        $ID->{Content} = $State->{Value};
                    }
                }
            }

            #elsif ( $ElementName eq 'PriorityIDs' || $ElementName eq 'CreatedPriorityIDs' ) {
            #    my %PriorityList = $Self->{PriorityObject}->PriorityList( UserID => 1 );
            #    ID:
            #    for my $ID ( @{$Values} ) {
            #        next ID if !$ID;
            #        $ID->{Content} = $PriorityList{ $ID->{Content} };
            #    }
            #}

            # Locks and statustype don't have to wrap because they are never different
        }
    }
    return \%Param;
}

sub ImportWrapper {
    my ( $Self, %Param ) = @_;

    # wrap used spelling to ids
    for my $Use (qw(UseAsValueSeries UseAsRestriction UseAsXvalue)) {
        ELEMENT:
        for my $Element ( @{ $Param{$Use} } ) {
            next ELEMENT if !$Element || !$Element->{SelectedValues};
            my $ElementName = $Element->{Element};
            my $Values      = $Element->{SelectedValues};

            if ( $ElementName eq 'StateIDs' ) {
                ID:
                for my $ID ( @{$Values} ) {
                    next ID if !$ID;

                    my $StateID = $Self->{ChangeObject}->ChangeStateLookup(
                        ChangeState => $ID->{Content},
                        Cache       => 1,
                    );
                    if ($StateID) {
                        $ID->{Content} = $StateID;
                    }
                    else {
                        $Self->{LogObject}->Log(
                            Priority => 'error',
                            Message  => "Import: Can' find state $ID->{Content}!"
                        );
                        $ID = undef;
                    }
                }
            }

            #elsif ( $ElementName eq 'PriorityIDs' || $ElementName eq 'CreatedPriorityIDs' ) {
            #    my %PriorityList = $Self->{PriorityObject}->PriorityList( UserID => 1 );
            #    my %PriorityIDs;
            #    for my $Key ( keys %PriorityList ) {
            #        $PriorityIDs{ $PriorityList{$Key} } = $Key;
            #    }
            #    ID:
            #    for my $ID ( @{$Values} ) {
            #        next ID if !$ID;

            #        if ( $PriorityIDs{ $ID->{Content} } ) {
            #            $ID->{Content} = $PriorityIDs{ $ID->{Content} };
            #        }
            #        else {
            #            $Self->{LogObject}->Log(
            #                Priority => 'error',
            #                Message  => "Import: Can' find priority $ID->{Content}!"
            #            );
            #            $ID = undef;
            #        }
            #    }
            #}
            #elsif (
            #    $ElementName    eq 'OwnerIDs'
            #    || $ElementName eq 'CreatedUserIDs'
            #    || $ElementName eq 'ResponsibleIDs'
            #    )
            #{
            #    ID:
            #    for my $ID ( @{$Values} ) {
            #        next ID if !$ID;

            #        if ( $Self->{UserObject}->UserLookup( UserLogin => $ID->{Content} ) ) {
            #            $ID->{Content} = $Self->{UserObject}->UserLookup(
            #                UserLogin => $ID->{Content}
            #            );
            #        }
            #        else {
            #            $Self->{LogObject}->Log(
            #                Priority => 'error',
            #                Message  => "Import: Can' find user $ID->{Content}!"
            #            );
            #            $ID = undef;
            #        }
            #    }
            #}

            # Locks and statustype don't have to wrap because they are never different
        }
    }
    return \%Param;
}

1;
