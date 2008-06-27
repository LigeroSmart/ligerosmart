# --
# Kernel/System/LinkObject/ITSMLocation.pm - to link location objects
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: ITSMLocation.pm,v 1.3 2008-06-27 08:29:05 ub Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::System::LinkObject::ITSMLocation;

use strict;
use warnings;

use Kernel::System::ITSMLocation;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.3 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for (qw(DBObject ConfigObject LogObject MainObject TimeObject LinkObject)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    $Self->{LocationObject}       = Kernel::System::ITSMLocation->new( %{$Self} );
    $Self->{GeneralCatalogObject} = Kernel::System::GeneralCatalog->new( %{$Self} );

    return $Self;
}

=item LinkListWithData()

fill up the link list with data

    $Success = $LinkObjectBackend->LinkListWithData(
        LinkList => $HashRef,
        UserID   => 1,
    );

=cut

sub LinkListWithData {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(LinkList UserID)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # check link list
    if ( ref $Param{LinkList} ne 'HASH' ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'LinkList must be a hash reference!',
        );
        return;
    }

    for my $LinkType ( keys %{ $Param{LinkList} } ) {

        for my $Direction ( keys %{ $Param{LinkList}->{$LinkType} } ) {

            LOCATIONID:
            for my $LocationID ( keys %{ $Param{LinkList}->{$LinkType}->{$Direction} } ) {

                # get location data
                my %LocationData = $Self->{LocationObject}->LocationGet(
                    LocationID => $LocationID,
                    UserID     => $Param{UserID},
                );

                # remove id from hash if ticket can not get
                if ( !%LocationData ) {
                    delete $Param{LinkList}->{$LinkType}->{$Direction}->{$LocationID};
                    next LOCATIONID;
                }

                # add location data
                $Param{LinkList}->{$LinkType}->{$Direction}->{$LocationID} = \%LocationData;
            }
        }
    }

    return 1;
}

=item ObjectDescriptionGet()

return a hash of object descriptions

Return
    %Description = (
        Normal => "Location: XYZ",
        Long   => "Location: XYZ ABCD",
    );

    %Description = $LinkObject->ObjectDescriptionGet(
        Key     => 123,
        UserID  => 1,
    );

=cut

sub ObjectDescriptionGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(Object Key UserID)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # get location
    my %Location = $Self->{LocationObject}->LocationGet(
        LocationID => $Param{Key},
        UserID     => $Param{UserID},
    );

    return if !%Location;

    # create description
    my %Description = (
        Normal => "Location: '$Location{NameShort}'",
        Long   => "Location: '$Location{Name}'",
    );

    return %Description;
}

=item ObjectSearch()

return a hash list of the search results

Return
    $SearchList = {
        NOTLINKED => {
            Source => {
                12  => $DataOfItem12,
                212 => $DataOfItem212,
                332 => $DataOfItem332,
            },
        },
    };

    $SearchList = $LinkObjectBackend->ObjectSearch(
        SearchParams => $HashRef,  # (optional)
        UserID       => 1,
    );

=cut

sub ObjectSearch {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{UserID} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need UserID!',
        );
        return;
    }

    # set default params
    $Param{SearchParams} ||= {};

    # set focus
    my %Search;
    for my $Argument (qw(Name Phone1 Email Address)) {
        if ( $Param{SearchParams}->{$Argument} ) {
            $Search{$Argument} = '*' . $Param{SearchParams}->{$Argument} . '*';
        }
    }

    my @LocationList = $Self->{LocationObject}->LocationSearch(
        %{ $Param{SearchParams} },
        %Search,
        Limit  => 100,
        UserID => $Param{UserID},
    );

    my %SearchList;
    LOCATIONID:
    for my $LocationID (@LocationList) {

        # get location data
        my %LocationData = $Self->{LocationObject}->LocationGet(
            LocationID => $LocationID,
            UserID     => $Param{UserID},
        );

        next LOCATIONID if !%LocationData;

        # add location data
        $SearchList{NOTLINKED}->{Source}->{$LocationID} = \%LocationData;
    }

    return \%SearchList;
}

=item LinkAddPre()

link add pre event module

    $True = $LinkObject->LinkAddPre(
        Key          => 123,
        SourceObject => 'ITSMLocation',
        SourceKey    => 321,
        Type         => 'Normal',
        UserID       => 1,
    );

    or

    $True = $LinkObject->LinkAddPre(
        Key          => 123,
        TargetObject => 'ITSMLocation',
        TargetKey    => 321,
        Type         => 'Normal',
        UserID       => 1,
    );

=cut

sub LinkAddPre {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(Key Type UserID)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    return 1;
}

=item LinkAddPost()

link add pre event module

    $True = $LinkObject->LinkAddPost(
        Key          => 123,
        SourceObject => 'ITSMLocation',
        SourceKey    => 321,
        Type         => 'Normal',
        UserID       => 1,
    );

    or

    $True = $LinkObject->LinkAddPost(
        Key          => 123,
        TargetObject => 'ITSMLocation',
        TargetKey    => 321,
        Type         => 'Normal',
        UserID       => 1,
    );

=cut

sub LinkAddPost {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(Key Type UserID)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    return 1;
}

=item LinkDeletePre()

link delete pre event module

    $True = $LinkObject->LinkDeletePre(
        Key     => 123,
        Object2 => 'ITSMLocation',
        Key2    => 321,
        Type    => 'Normal',
        UserID  => 1,
    );

=cut

sub LinkDeletePre {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(Key Object2 Key2 Type UserID)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    return 1;
}

=item LinkDeletePost()

link delete post event module

    $True = $LinkObject->LinkDeletePost(
        Key     => 123,
        Object2 => 'ITSMLocation',
        Key2    => 321,
        Type    => 'Normal',
        UserID  => 1,
    );

=cut

sub LinkDeletePost {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(Key Object2 Key2 Type UserID)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    return 1;
}

1;
