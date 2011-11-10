# --
# Kernel/System/LinkObject/ITSMWorkOrder.pm - to link workorder objects
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: ITSMWorkOrder.pm,v 1.17 2011-11-10 11:20:35 ub Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::LinkObject::ITSMWorkOrder;

use strict;
use warnings;

use Kernel::System::User;
use Kernel::System::Group;
use Kernel::System::ITSMChange;
use Kernel::System::ITSMChange::ITSMWorkOrder;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.17 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for my $Object (
        qw(DBObject ConfigObject EncodeObject LogObject MainObject TimeObject)
        )
    {
        $Self->{$Object} = $Param{$Object} || die "Got no $Object!";
    }

    # create additional objects
    $Self->{UserObject}      = Kernel::System::User->new( %{$Self} );
    $Self->{GroupObject}     = Kernel::System::Group->new( %{$Self} );
    $Self->{WorkOrderObject} = Kernel::System::ITSMChange::ITSMWorkOrder->new( %{$Self} );
    $Self->{ChangeObject}    = Kernel::System::ITSMChange->new( %{$Self} );

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

            WORKORDERID:
            for my $WorkOrderID ( keys %{ $Param{LinkList}->{$LinkType}->{$Direction} } ) {

                # get workorder data
                my $WorkOrderData = $Self->{WorkOrderObject}->WorkOrderGet(
                    WorkOrderID => $WorkOrderID,
                    UserID      => $Param{UserID},
                );

                # remove id from hash if WorkOrderGet() returns no results
                if ( !$WorkOrderData ) {
                    delete $Param{LinkList}->{$LinkType}->{$Direction}->{$WorkOrderID};
                    next WORKORDERID;
                }

                # get change data for this workorder
                my $ChangeData = $Self->{ChangeObject}->ChangeGet(
                    ChangeID => $WorkOrderData->{ChangeID},
                    UserID   => $Param{UserID},
                );

                # remove workorder id from hash if change for this workorder returns no results
                if ( !$ChangeData ) {
                    delete $Param{LinkList}->{$LinkType}->{$Direction}->{$WorkOrderID};
                    next WORKORDERID;
                }

                # add the change data to workorder data
                my %Data = (
                    %{$WorkOrderData},
                    ChangeData => $ChangeData,
                );

                # add workorder data
                $Param{LinkList}->{$LinkType}->{$Direction}->{$WorkOrderID} = \%Data;
            }
        }
    }

    return 1;
}

=item ObjectDescriptionGet()

return a hash of object descriptions

Return
    %Description = (
        Normal => "Workorder# 2009102110001674-1",
        Long   => "Workorder# 2009102110001674-1: The Workorder Title",
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

    # create description
    my %Description = (
        Normal => 'Workorder',
        Long   => 'Workorder',
    );

    return %Description if $Param{Mode} && $Param{Mode} eq 'Temporary';

    # get workorder data
    my $WorkOrderData = $Self->{WorkOrderObject}->WorkOrderGet(
        WorkOrderID => $Param{Key},
        UserID      => $Param{UserID},
    );

    return if !$WorkOrderData;
    return if !%{$WorkOrderData};

    # get change data for this workorder
    my $ChangeData = $Self->{ChangeObject}->ChangeGet(
        ChangeID => $WorkOrderData->{ChangeID},
        UserID   => $Param{UserID},
    );

    return if !$ChangeData;
    return if !%{$ChangeData};

    # define description text
    my $WorkOrderHook = $Self->{ConfigObject}->Get('ITSMWorkOrder::Hook');
    my $DescriptionText
        = "$WorkOrderHook $ChangeData->{ChangeNumber}-$WorkOrderData->{WorkOrderNumber}";

    # create description
    %Description = (
        Normal => $DescriptionText,
        Long   => "$DescriptionText: $WorkOrderData->{WorkOrderTitle}",
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
        SearchParams => $HashRef,    # (optional)
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

    # add wildcards
    my %Search;
    for my $Element (qw(ChangeNumber ChangeTitle WorkOrderTitle)) {
        if ( $Param{SearchParams}->{$Element} ) {
            $Search{$Element} = '*' . $Param{SearchParams}->{$Element} . '*';
        }
    }

    # search the workorders
    # no need to use OrderBy here, because it is sorted in TableCreateComplex and TableCreatSimple
    my $WorkOrderIDsRef = $Self->{WorkOrderObject}->WorkOrderSearch(
        %{ $Param{SearchParams} },
        %Search,
        UsingWildcards => 1,
        MirrorDB       => 1,

        # TODO:
        # use sysconfig option for 'limit' instead, decide wheater this option would be only
        # valid for linking workorders, or just use a global setting for all linking stuff
        Limit => 200,

        UserID => $Param{UserID},
    );

    my %SearchList;
    WORKORDERID:
    for my $WorkOrderID ( @{$WorkOrderIDsRef} ) {

        # get workorder data
        my $WorkOrderData = $Self->{WorkOrderObject}->WorkOrderGet(
            WorkOrderID => $WorkOrderID,
            UserID      => $Param{UserID},
        );

        next WORKORDERID if !$WorkOrderData;

        # get change data for this workorder
        my $ChangeData = $Self->{ChangeObject}->ChangeGet(
            ChangeID => $WorkOrderData->{ChangeID},
            UserID   => $Param{UserID},
        );

        next WORKORDERID if !$ChangeData;

        # add the change data to workorder data
        my %Data = (
            %{$WorkOrderData},
            ChangeData => $ChangeData,
        );

        # add workorder data
        $SearchList{NOTLINKED}->{Source}->{$WorkOrderID} = \%Data;
    }

    return \%SearchList;
}

=item LinkAddPre()

link add pre event module

    $True = $LinkObject->LinkAddPre(
        Key          => 123,
        SourceObject => 'ITSMWorkOrder',
        SourceKey    => 321,
        Type         => 'Normal',
        State        => 'Valid',
        UserID       => 1,
    );

    or

    $True = $LinkObject->LinkAddPre(
        Key          => 123,
        TargetObject => 'ITSMWorkOrder',
        TargetKey    => 321,
        Type         => 'Normal',
        State        => 'Valid',
        UserID       => 1,
    );

=cut

sub LinkAddPre {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(Key Type State UserID)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # do not trigger event for temporary links
    return 1 if $Param{State} eq 'Temporary';

    return 1;
}

=item LinkAddPost()

link add pre event module

    $True = $LinkObject->LinkAddPost(
        Key          => 123,
        SourceObject => 'ITSMWorkOrder',
        SourceKey    => 321,
        Type         => 'Normal',
        State        => 'Valid',
        UserID       => 1,
    );

    or

    $True = $LinkObject->LinkAddPost(
        Key          => 123,
        TargetObject => 'ITSMWorkOrder',
        TargetKey    => 321,
        Type         => 'Normal',
        State        => 'Valid',
        UserID       => 1,
    );

=cut

sub LinkAddPost {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(Key Type State UserID)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # do not trigger event for temporary links
    return 1 if $Param{State} eq 'Temporary';

    # get information about linked object
    my $ID     = $Param{TargetKey}    || $Param{SourceKey};
    my $Object = $Param{TargetObject} || $Param{SourceObject};

    # trigger WorkOrderLinkAddPost-Event
    $Self->{WorkOrderObject}->EventHandler(
        Event => 'WorkOrderLinkAddPost',
        Data  => {
            WorkOrderID => $Param{Key},
            Object      => $Object,         # the other object of the link
            ID          => $ID,             # id of the other object
            Type        => $Param{Type},    # the link type
            %Param,
        },
        UserID => $Param{UserID},
    );

    return 1;
}

=item LinkDeletePre()

link delete pre event module

    $True = $LinkObject->LinkDeletePre(
        Key          => 123,
        SourceObject => 'ITSMWorkOrder',
        SourceKey    => 321,
        Type         => 'Normal',
        State        => 'Valid',
        UserID       => 1,
    );

    or

    $True = $LinkObject->LinkDeletePre(
        Key          => 123,
        TargetObject => 'ITSMWorkOrder',
        TargetKey    => 321,
        Type         => 'Normal',
        State        => 'Valid',
        UserID       => 1,
    );

=cut

sub LinkDeletePre {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(Key Type State UserID)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # do not trigger event for temporary links
    return 1 if $Param{State} eq 'Temporary';

    return 1;
}

=item LinkDeletePost()

link delete post event module

    $True = $LinkObject->LinkDeletePost(
        Key          => 123,
        SourceObject => 'ITSMWorkOrder',
        SourceKey    => 321,
        Type         => 'Normal',
        State        => 'Valid',
        UserID       => 1,
    );

    or

    $True = $LinkObject->LinkDeletePost(
        Key          => 123,
        TargetObject => 'ITSMWorkOrder',
        TargetKey    => 321,
        Type         => 'Normal',
        State        => 'Valid',
        UserID       => 1,
    );

=cut

sub LinkDeletePost {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(Key Type State UserID)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # do not trigger event for temporary links
    return 1 if $Param{State} eq 'Temporary';

    # get information about linked object
    my $ID     = $Param{TargetKey}    || $Param{SourceKey};
    my $Object = $Param{TargetObject} || $Param{SourceObject};

    # trigger WorkOrderLinkDeletePost-Event
    $Self->{WorkOrderObject}->EventHandler(
        Event => 'WorkOrderLinkDeletePost',
        Data  => {
            WorkOrderID => $Param{Key},
            Object      => $Object,         # the other object of the link
            ID          => $ID,             # id of the other object
            Type        => $Param{Type},    # the link type
            %Param,
        },
        UserID => $Param{UserID},
    );

    return 1;
}

1;
