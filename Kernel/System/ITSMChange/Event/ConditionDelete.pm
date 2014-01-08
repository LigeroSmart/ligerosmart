# --
# Kernel/System/ITSMChange/Event/ConditionDelete.pm - a event module for cleaning up conditions
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::ITSMChange::Event::ConditionDelete;

use strict;
use warnings;

use Kernel::System::ITSMChange::ITSMCondition;

=head1 NAME

Kernel::System::ITSMChange::Event::ConditionDelete - ITSM change management condition cleanup event lib

=head1 SYNOPSIS

Event handler module for cleaning up conditions, when a change is being deleted.

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
    use Kernel::System::ITSMChange::Event::ConditionDelete;

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
    my $EventObject = Kernel::System::ITSMChange::Event::ConditionDelete->new(
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
    $Self->{ConditionObject} = Kernel::System::ITSMChange::ITSMCondition->new( %{$Self} );

    return $Self;
}

=item Run()

The C<Run()> method handles the change delete event and deletes the conditions for
the given change.

It returns 1 on success, C<undef> otherwise.

    my $Success = $EventObject->Run(
        Event => 'ChangeDelete',
        Data => {
            ChangeID    => 123,
        },
        Config => {
            Event       => '(ChangeDeletePost)',
            Module      => 'Kernel::System::ITSMChange::Event::ConditionDelete',
            Transaction => '0',
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

    # handle deletion of a change
    if ( $Param{Event} eq 'ChangeDeletePost' ) {

        # delete all conditions (and expressions and actions) for this change id
        my $Success = $Self->{ConditionObject}->ConditionDeleteAll(
            ChangeID => $Param{Data}->{ChangeID},
            UserID   => $Param{UserID},
        );

        # handle error
        if ( !$Success ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "ConditionDeleteAll() failed for ChangeID '$Param{Data}->{ChangeID}'!"
            );
            return;
        }

        return 1;
    }

    # error
    else {

        # an unknown event
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "$Param{Event} is an unknown event!",
        );

        return;
    }

    return 1;
}

=begin Internal:

=cut

1;

=end Internal:

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (http://otrs.org/).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
