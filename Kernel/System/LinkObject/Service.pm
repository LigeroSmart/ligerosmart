# --
# Kernel/System/LinkObject/Service.pm - to link service objects
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::LinkObject::Service;

use strict;
use warnings;

use Kernel::System::Group;
use Kernel::System::Service;

=head1 NAME

Kernel::System::LinkObject::Service

=head1 SYNOPSIS

Ticket backend for the ticket link object.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create an object

    use Kernel::Config;
    use Kernel::System::Encode;
    use Kernel::System::Log;
    use Kernel::System::Time;
    use Kernel::System::Main;
    use Kernel::System::DB;
    use Kernel::System::LinkObject::Service;

    my $ConfigObject = Kernel::Config->new();
    my $EncodeObject = Kernel::System::Encode->new(
        ConfigObject => $ConfigObject,
    );
    my $LogObject = Kernel::System::Log->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
    );
    my $TimeObject = Kernel::System::Time->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
    );
    my $MainObject = Kernel::System::Main->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
    );
    my $DBObject = Kernel::System::DB->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
        MainObject   => $MainObject,
    );
    my $LinkBackendObject = Kernel::System::LinkObject::Service->new(
        ConfigObject       => $ConfigObject,
        LogObject          => $LogObject,
        DBObject           => $DBObject,
        MainObject         => $MainObject,
        TimeObject         => $TimeObject,
        EncodeObject       => $EncodeObject,
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for my $Object (qw(DBObject ConfigObject LogObject MainObject EncodeObject TimeObject)) {
        $Self->{$Object} = $Param{$Object} || die "Got no $Object!";
    }

    # create additional objects
    $Self->{GroupObject}   = Kernel::System::Group->new( %{$Self} );
    $Self->{ServiceObject} = Kernel::System::Service->new( %{$Self} );

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

    for my $LinkType ( sort keys %{ $Param{LinkList} } ) {

        for my $Direction ( sort keys %{ $Param{LinkList}->{$LinkType} } ) {

            SERVICEID:
            for my $ServiceID ( sort keys %{ $Param{LinkList}->{$LinkType}->{$Direction} } ) {

                # get service data
                my %ServiceData = $Self->{ServiceObject}->ServiceGet(
                    ServiceID     => $ServiceID,
                    IncidentState => 1,
                    UserID        => $Param{UserID},
                );

                # remove id from hash if no service data was found
                if ( !%ServiceData ) {
                    delete $Param{LinkList}->{$LinkType}->{$Direction}->{$ServiceID};
                    next SERVICEID;
                }

                # add service data
                $Param{LinkList}->{$LinkType}->{$Direction}->{$ServiceID} = \%ServiceData;
            }
        }
    }

    return 1;
}

=item ObjectPermission()

checks read permission for a given object and UserID.

    $Permission = $LinkObject->ObjectPermission(
        Object  => 'Service',
        Key     => 123,
        UserID  => 1,
    );

=cut

sub ObjectPermission {
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

    # check module registry of AgentITSMServiceZoom
    my $ModuleReg = $Self->{ConfigObject}->Get('Frontend::Module')->{AgentITSMServiceZoom};

    # do not grant access if frontend module is not registered
    return if !$ModuleReg;

    # grant access if module permisson has no Group or GroupRo defined
    if ( !$ModuleReg->{GroupRo} && !$ModuleReg->{Group} ) {
        return 1;
    }

    PERMISSION:
    for my $Permission (qw(GroupRo Group)) {

        next PERMISSION if !$ModuleReg->{$Permission};
        next PERMISSION if ref $ModuleReg->{$Permission} ne 'ARRAY';

        for my $Group ( @{ $ModuleReg->{$Permission} } ) {

            # get the group id
            my $GroupID = $Self->{GroupObject}->GroupLookup( Group => $Group );

            my $Type;
            if ( $Permission eq 'GroupRo' ) {
                $Type = 'ro';
            }
            elsif ( $Permission eq 'Group' ) {
                $Type = 'rw';
            }

            # get user groups, where the user has the appropriate privilege
            my %Groups = $Self->{GroupObject}->GroupMemberList(
                UserID => $Param{UserID},
                Type   => $Type,
                Result => 'HASH',
            );

            # grant access if agent is a member in the group
            return 1 if $Groups{$GroupID};
        }
    }

    return;
}

=item ObjectDescriptionGet()

return a hash of object descriptions

Return
    %Description = (
        Normal => "Service ServiceName",
        Long   => "Service ParentService::ServiceName",
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
        Normal => 'Service',
        Long   => 'Service',
    );

    return %Description if $Param{Mode} && $Param{Mode} eq 'Temporary';

    # get service
    my %Service = $Self->{ServiceObject}->ServiceGet(
        ServiceID     => $Param{Key},
        IncidentState => 0,
        UserID        => 1,
    );

    return if !%Service;

    # create description
    %Description = (
        Normal => "Service '$Service{NameShort}'",
        Long   => "Service '$Service{Name}'",
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

    # add wildcards
    my %Search;
    if ( $Param{SearchParams}->{Name} ) {
        $Search{Name} = '*' . $Param{SearchParams}->{Name} . '*';
    }

    # search the services
    my @ServiceIDs = $Self->{ServiceObject}->ServiceSearch(
        %{ $Param{SearchParams} },
        %Search,
        Limit  => 50,
        UserID => $Param{UserID},
    );

    my %SearchList;
    SERVICEID:
    for my $ServiceID (@ServiceIDs) {

        # get service data
        my %ServiceData = $Self->{ServiceObject}->ServiceGet(
            ServiceID     => $ServiceID,
            IncidentState => 1,
            UserID        => $Param{UserID},
        );

        next SERVICEID if !%ServiceData;

        # add service data
        $SearchList{NOTLINKED}->{Source}->{$ServiceID} = \%ServiceData;
    }

    return \%SearchList;
}

=item LinkAddPre()

link add pre event module

    $True = $LinkObject->LinkAddPre(
        Key          => 123,
        SourceObject => 'Service',
        SourceKey    => 321,
        Type         => 'Normal',
        State        => 'Valid',
        UserID       => 1,
    );

    or

    $True = $LinkObject->LinkAddPre(
        Key          => 123,
        TargetObject => 'Service',
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

    return 1 if $Param{State} eq 'Temporary';

    return 1;
}

=item LinkAddPost()

link add pre event module

    $True = $LinkObject->LinkAddPost(
        Key          => 123,
        SourceObject => 'Service',
        SourceKey    => 321,
        Type         => 'Normal',
        State        => 'Valid',
        UserID       => 1,
    );

    or

    $True = $LinkObject->LinkAddPost(
        Key          => 123,
        TargetObject => 'Service',
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

    return 1 if $Param{State} eq 'Temporary';

    return 1;
}

=item LinkDeletePre()

link delete pre event module

    $True = $LinkObject->LinkDeletePre(
        Key          => 123,
        SourceObject => 'Service',
        SourceKey    => 321,
        Type         => 'Normal',
        State        => 'Valid',
        UserID       => 1,
    );

    or

    $True = $LinkObject->LinkDeletePre(
        Key          => 123,
        TargetObject => 'Service',
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

    return 1 if $Param{State} eq 'Temporary';

    return 1;
}

=item LinkDeletePost()

link delete post event module

    $True = $LinkObject->LinkDeletePost(
        Key          => 123,
        SourceObject => 'Service',
        SourceKey    => 321,
        Type         => 'Normal',
        State        => 'Valid',
        UserID       => 1,
    );

    or

    $True = $LinkObject->LinkDeletePost(
        Key          => 123,
        TargetObject => 'Service',
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

    return 1 if $Param{State} eq 'Temporary';

    # update the current incident state type from CIs of the service
    # in order to ensure that the dynamic incident calculation is reset after
    # unlinking a CI which has been in an incident state
    $Self->{ServiceObject}->ServicePreferencesSet(
        ServiceID => $Param{Key},
        Key       => 'CurInciStateTypeFromCIs',
        Value     => '',
        UserID    => 1,
    );

    return 1;
}

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut

1;
