# --
# Kernel/System/ITSMChange/Event/ToolBarChangeManagerCacheDelete.pm - ToolBarChangeManagerCacheDelete event module for ITSMChange
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::ITSMChange::Event::ToolBarChangeManagerCacheDelete;

use strict;
use warnings;

use Kernel::System::Cache;

=head1 NAME

Kernel::System::ITSMChange::Event::ToolBarChangeManagerCacheDelete - cache cleanup lib

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
    use Kernel::System::ITSMChange::Event::ToolBarChangeManagerCacheDelete;

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
    my $EventObject = Kernel::System::ITSMChange::Event::ToolBarChangeManagerCacheDelete->new(
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
        Event => 'ChangeUpdatePost',
        Data => {
            ChangeID        => 123,
            ChangeManagerID => 5,
        },
        Config => {
            Event       => '(ChangeAddPost|ChangeUpdatePost||ChangeDeletePost)',
            Module      => 'Kernel::System::ITSMChange::Event::ToolBarChangeManagerCacheDelete',
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
    my $CacheTypePrefix = 'ITSMChangeManagementToolBarChangeManager';

    # handle adding of a change
    if ( $Param{Event} eq 'ChangeAddPost' ) {

        # do nothing if the ChangeManagerID was not set
        return 1 if !$Param{Data}->{ChangeManagerID};

        # set the cache type
        my $CacheType = $CacheTypePrefix . $Param{Data}->{ChangeManagerID};

        # delete the cache
        $Self->{CacheObject}->CleanUp(
            Type => $CacheType,
        );

        return 1;
    }

    # handle update of a change
    elsif ( $Param{Event} eq 'ChangeUpdatePost' ) {

        # make sure the data is initialized
        $Param{Data}->{ChangeManagerID} ||= '';
        $Param{Data}->{OldChangeData}->{ChangeManagerID} ||= '';

        # do nothing if the ChangeManagerID did not change
        return 1
            if $Param{Data}->{ChangeManagerID} eq $Param{Data}->{OldChangeData}->{ChangeManagerID};

        # set the cache type postfix
        my @CacheTypePostfixes = (
            $Param{Data}->{ChangeManagerID},
            $Param{Data}->{OldChangeData}->{ChangeManagerID},
        );

        # delete the cache for the old and the current change manager
        CACHETYPEPOSTFIX:
        for my $CacheTypePostfix (@CacheTypePostfixes) {

            # do nothing if the ChangeManagerID was not set
            next CACHETYPEPOSTFIX if !$CacheTypePostfix;

            # set the cache type
            my $CacheType = $CacheTypePrefix . $CacheTypePostfix;

            # delete the cache
            $Self->{CacheObject}->CleanUp(
                Type => $CacheType,
            );
        }

        return 1;
    }

    # handle deleting a change
    elsif ( $Param{Event} eq 'ChangeDeletePost' ) {

        # do nothing if the ChangeManagerID was not set
        return 1 if !$Param{Data}->{OldChangeData}->{ChangeManagerID};

        # set the cache type
        my $CacheType = $CacheTypePrefix . $Param{Data}->{OldChangeData}->{ChangeManagerID};

        # delete the cache
        $Self->{CacheObject}->CleanUp(
            Type => $CacheType,
        );

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
