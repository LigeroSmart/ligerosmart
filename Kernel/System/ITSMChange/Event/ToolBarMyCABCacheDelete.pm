# --
# Kernel/System/ITSMChange/Event/ToolBarMyCABCacheDelete.pm - ToolBarMyCABCacheDelete event module for ITSMChange
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::ITSMChange::Event::ToolBarMyCABCacheDelete;

use strict;
use warnings;

use Kernel::System::Cache;

=head1 NAME

Kernel::System::ITSMChange::Event::ToolBarMyCABCacheDelete - cache cleanup lib

=head1 SYNOPSIS

Event handler module for the toolbar cache delete in change management.

=head1 PUBLIC INTERFACE

=over 4

=item new()

create an object

    use Kernel::Config;
    use Kernel::System::Encode;
    use Kernel::System::Log;
    use Kernel::System::DB;
    use Kernel::System::Main;
    use Kernel::System::Time;
    use Kernel::System::ITSMChange::Event::ToolBarMyCABCacheDelete;

    my $ConfigObject = Kernel::Config->new();
    my $EncodeObject = Kernel::System::Encode->new(
        ConfigObject => $ConfigObject,
    );
    my $LogObject = Kernel::System::Log->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
    );
    my $MainObject = Kernel::System::Main->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
    );
    my $TimeObject = Kernel::System::Time->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
    );
    my $DBObject = Kernel::System::DB->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
        MainObject   => $MainObject,
    );
    my $EventObject = Kernel::System::ITSMChange::Event::ToolBarMyCABCacheDelete->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
        DBObject     => $DBObject,
        TimeObject   => $TimeObject,
        MainObject   => $MainObject,
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get needed objects
    for my $Object (
        qw(DBObject ConfigObject EncodeObject LogObject UserObject GroupObject MainObject TimeObject)
        )
    {
        $Self->{$Object} = $Param{$Object} || die "Got no $Object!";
    }

    # create additional objects
    $Self->{CacheObject} = Kernel::System::Cache->new( %{$Self} );

    return $Self;
}

=item Run()

The C<Run()> method handles the events and deletes the caches for the toolbar.

It returns 1 on success, C<undef> otherwise.

    my $Success = $EventObject->Run(
        Event => 'ChangeCABUpdatePost',
        Data => {
            ChangeID  => 123,
            CABAgents => [ 1, 2, 4 ],
        },
        Config => {
            Event       => '(ChangeCABUpdatePost|ChangeCABDeletePost)',
            Module      => 'Kernel::System::ITSMChange::Event::ToolBarMyCABCacheDelete',
            Transaction => 0,
        },
        UserID => 1,
    );

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(Data Event Config UserID)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # set the cache type prefix
    my $CacheTypePrefix = 'ITSMChangeManagementToolBarMyCAB';

    # handle update of a CAB
    if ( $Param{Event} eq 'ChangeCABUpdatePost' ) {

        # do nothing if the CABAgents were not updated
        return 1 if !$Param{Data}->{CABAgents};

        # make sure the data is initialized
        $Param{Data}->{CABAgents} ||= [];
        $Param{Data}->{OldChangeCABData}->{CABAgents} ||= [];

        # build lookup hash for CABAgents from "new" and "old" Agents
        my %ChangedCABAgentsLookup;
        for my $CABAgent (
            @{ $Param{Data}->{CABAgents} },
            @{ $Param{Data}->{OldChangeCABData}->{CABAgents} }
            )
        {
            $ChangedCABAgentsLookup{$CABAgent}++;
        }

     # find the CABAgents which have been changed, which are only agents with a count of exactly one
        my @ChangedCABAgents;
        for my $CABAgent ( sort keys %ChangedCABAgentsLookup ) {
            if ( $ChangedCABAgentsLookup{$CABAgent} == 1 ) {
                push @ChangedCABAgents, $CABAgent;
            }
        }

        # delete cache for all changed CABAgents
        for my $CABAgent (@ChangedCABAgents) {

            # set the cache type
            my $CacheType = $CacheTypePrefix . $CABAgent;

            # delete the cache
            $Self->{CacheObject}->CleanUp(
                Type => $CacheType,
            );
        }

        return 1;
    }

    # handle deleting a CAB
    elsif ( $Param{Event} eq 'ChangeCABDeletePost' ) {

        # do nothing if there were no CABAgents set
        return 1 if !$Param{Data}->{OldChangeCABData}->{CABAgents};
        return 1 if !@{ $Param{Data}->{OldChangeCABData}->{CABAgents} };

        # delete cache for all CABAgents
        for my $CABAgent ( @{ $Param{Data}->{OldChangeCABData}->{CABAgents} } ) {

            # set the cache type
            my $CacheType = $CacheTypePrefix . $CABAgent;

            # delete the cache
            $Self->{CacheObject}->CleanUp(
                Type => $CacheType,
            );
        }

        return 1;
    }

    return 1;
}

=begin Internal:

=cut

1;

=end Internal:

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
