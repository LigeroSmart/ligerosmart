# --
# Kernel/System/MasterSlave.pm - to handle ticket master slave tasks
# Copyright (C) 2003-2012 OTRS AG, http://otrs.com/
# --
# $Id: MasterSlave.pm,v 1.6 2012-05-04 11:51:23 te Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::MasterSlave;

use strict;
use warnings;

use Kernel::System::LinkObject;
use Kernel::System::DynamicField;
use Kernel::System::DynamicField::Backend;

use vars qw(@ISA $VERSION);
$VERSION = qw($Revision: 1.6 $) [1];

=head1 NAME

Kernel::System::MasterSlave - to handle all ticket master slave tasks ...

=head1 SYNOPSIS

All functions to handle ticket master slave tasks ...

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create an object

    use Kernel::System::LinkObject;

    my $LinkObject = Kernel::System::LinkObject->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
        DBObject     => $DBObject,
        TimeObject   => $TimeObject,
        MainObject   => $MainObject,
        EncodeObject => $EncodeObject,
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for (qw( LogObject TicketObject )) {
        $Self->{$_} = $Param{$_} || die;
    }

    # create extra needed objects
    $Self->{LinkObject}         = Kernel::System::LinkObject->new(%Param);
    $Self->{DynamicFieldObject} = Kernel::System::DynamicField->new(%Param);
    $Self->{BackendObject}      = Kernel::System::DynamicField::Backend->new(%Param);

    return $Self;
}

=item MasterSlave()

handles all the ticket master slave tasks
    my $True = $MasterSlaveObject->MasterSlave(
        MasterSlaveDynamicFieldName           => 'MasterSlave',
        MasterSlaveDynamicFieldValue          => 'Master',
        TicketID                              => 12345,
        UserID                                => 1,
        Ticket                                => %Ticket, # optional
        MasterSlaveKeepParentChildAfterUnset  => 0, # optional, default
        MasterSlaveFollowUpdatedMaster        => 0, # optional, default
        MasterSlaveKeepParentChildAfterUpdate => 0, # optional, default
    );

=cut

sub MasterSlave {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (
        qw(MasterSlaveDynamicFieldName MasterSlaveDynamicFieldValue TicketID UserID)
        )
    {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    my $MasterSlaveDynamicFieldName = $Param{MasterSlaveDynamicFieldName};
    my %Ticket
        = $Param{Ticket}
        ? %{ $Param{Ticket} }
        : $Self->{TicketObject}->TicketGet( TicketID => $Param{TicketID}, DynamicFields => 1 );

    # set a new master ticket
    # check if it is already a master ticket
    if (
        $Param{MasterSlaveDynamicFieldValue} eq 'Master'
        && (
            !$Ticket{ 'DynamicField_' . $MasterSlaveDynamicFieldName }
            || $Ticket{ 'DynamicField_' . $MasterSlaveDynamicFieldName } ne 'Master'
        )
        )
    {

        # check if it was a slave ticket before and if we have to delete
        # the old parent child link (MasterSlaveKeepParentChildAfterUnset)
        if (
            $Ticket{ 'DynamicField_' . $MasterSlaveDynamicFieldName }
            && $Ticket{ 'DynamicField_' . $MasterSlaveDynamicFieldName } =~ /^SlaveOf:(.*?)$/
            && !$Param{MasterSlaveKeepParentChildAfterUnset}
            )
        {
            my $SourceKey = $Self->{TicketObject}->TicketIDLookup(
                TicketNumber => $1,
                UserID       => $Param{UserID},
            );

            $Self->{LinkObject}->LinkDelete(
                Object1 => 'Ticket',
                Key1    => $SourceKey,
                Object2 => 'Ticket',
                Key2    => $Param{TicketID},
                Type    => 'ParentChild',
                UserID  => $Param{UserID},
            );
        }

        # get dynamic field config
        my $DynamicField = $Self->{DynamicFieldObject}->DynamicFieldGet(
            Name => $MasterSlaveDynamicFieldName,
        );

        # set new master ticket
        $Self->{BackendObject}->ValueSet(
            DynamicFieldConfig => $DynamicField,
            ObjectID           => $Param{TicketID},
            Value              => 'Master',
            UserID             => $Param{UserID},
        );
    }

    # set a new slave ticket
    # check if it's already the slave of the wished master ticket
    elsif (
        $Param{MasterSlaveDynamicFieldValue} =~ /^SlaveOf:(.*?)$/
        && (
            !$Ticket{ 'DynamicField_' . $MasterSlaveDynamicFieldName }
            || $Ticket{ 'DynamicField_' . $MasterSlaveDynamicFieldName } ne
            $Param{MasterSlaveDynamicFieldValue}
        )
        )
    {
        my $SourceKey = $Self->{TicketObject}->TicketIDLookup(
            TicketNumber => $1,
            UserID       => $Param{UserID},
        );

        $Self->{LinkObject}->LinkAdd(
            SourceObject => 'Ticket',
            SourceKey    => $SourceKey,
            TargetObject => 'Ticket',
            TargetKey    => $Param{TicketID},
            Type         => 'ParentChild',
            State        => 'Valid',
            UserID       => $Param{UserID},
        );

        my %Links = $Self->{LinkObject}->LinkKeyList(
            Object1   => 'Ticket',
            Key1      => $Param{TicketID},
            Object2   => 'Ticket',
            State     => 'Valid',
            Type      => 'ParentChild',      # (optional)
            Direction => 'Target',           # (optional) default Both (Source|Target|Both)
            UserID    => $Param{UserID},
        );
        my @SlaveTicketIDs;
        for my $LinkedTicketID ( keys %Links ) {
            next if !$Links{$LinkedTicketID};

            # just take ticket with slave attributes for action
            my %Ticket = $Self->{TicketObject}->TicketGet(
                TicketID      => $LinkedTicketID,
                DynamicFields => 1,
            );
            next if !$Ticket{ 'DynamicField_' . $MasterSlaveDynamicFieldName };
            next if $Ticket{ 'DynamicField_' . $MasterSlaveDynamicFieldName } !~ /^SlaveOf:(.*?)$/;

            # remember ticket id
            push @SlaveTicketIDs, $LinkedTicketID;
        }

        if (
            $Ticket{ 'DynamicField_' . $MasterSlaveDynamicFieldName }
            && $Ticket{ 'DynamicField_' . $MasterSlaveDynamicFieldName } eq 'Master'
            )
        {
            if ( $Param{MasterSlaveFollowUpdatedMaster} && @SlaveTicketIDs ) {
                for my $LinkedTicketID (@SlaveTicketIDs) {
                    $Self->{LinkObject}->LinkAdd(
                        SourceObject => 'Ticket',
                        SourceKey    => $SourceKey,
                        TargetObject => 'Ticket',
                        TargetKey    => $LinkedTicketID,
                        Type         => 'ParentChild',
                        State        => 'Valid',
                        UserID       => $Param{UserID},
                    );
                }
            }

            if ( !$Param{MasterSlaveKeepParentChildAfterUnset} ) {
                for my $LinkedTicketID (@SlaveTicketIDs) {
                    $Self->{LinkObject}->LinkDelete(
                        Object1 => 'Ticket',
                        Key1    => $Param{TicketID},
                        Object2 => 'Ticket',
                        Key2    => $LinkedTicketID,
                        Type    => 'ParentChild',
                        UserID  => $Param{UserID},
                    );
                }
            }
        }
        elsif (
            $Ticket{ 'DynamicField_' . $MasterSlaveDynamicFieldName }
            && $Ticket{ 'DynamicField_' . $MasterSlaveDynamicFieldName } =~ /^SlaveOf:(.*?)$/
            && !$Param{MasterSlaveKeepParentChildAfterUpdate}
            )
        {
            my $SourceKey = $Self->{TicketObject}->TicketIDLookup(
                TicketNumber => $1,
                UserID       => $Param{UserID},
            );

            $Self->{LinkObject}->LinkDelete(
                Object1 => 'Ticket',
                Key1    => $SourceKey,
                Object2 => 'Ticket',
                Key2    => $Param{TicketID},
                Type    => 'ParentChild',
                UserID  => $Param{UserID},
            );
        }

        # get dynamic field config
        my $DynamicField = $Self->{DynamicFieldObject}->DynamicFieldGet(
            Name => $MasterSlaveDynamicFieldName,
        );
        $Self->{BackendObject}->ValueSet(
            DynamicFieldConfig => $DynamicField,
            ObjectID           => $Param{TicketID},
            Value              => $Param{MasterSlaveDynamicFieldValue},
            UserID             => $Param{UserID},
        );
    }
    elsif (
        $Param{MasterSlaveDynamicFieldValue} =~ /^(?:UnsetMaster|UnsetSlave)$/
        && $Ticket{ 'DynamicField_' . $MasterSlaveDynamicFieldName }
        )
    {
        if (
            $Param{MasterSlaveDynamicFieldValue} eq 'UnsetMaster'
            && !$Param{MasterSlaveKeepParentChildAfterUnset}
            )
        {
            my %Links = $Self->{LinkObject}->LinkKeyList(
                Object1   => 'Ticket',
                Key1      => $Param{TicketID},
                Object2   => 'Ticket',
                State     => 'Valid',
                Type      => 'ParentChild',      # (optional)
                Direction => 'Target',           # (optional) default Both (Source|Target|Both)
                UserID    => $Param{UserID},
            );
            my @SlaveTicketIDs;
            for my $LinkedTicketID ( keys %Links ) {
                next if !$Links{$LinkedTicketID};

                # just take ticket with slave attributes for action
                my %Ticket = $Self->{TicketObject}->TicketGet(
                    TicketID      => $LinkedTicketID,
                    DynamicFields => 1,
                );
                next if !$Ticket{ 'DynamicField_' . $MasterSlaveDynamicFieldName };
                next
                    if $Ticket{ 'DynamicField_' . $MasterSlaveDynamicFieldName }
                        !~ /^SlaveOf:(.*?)$/;

                # remember ticket id
                push @SlaveTicketIDs, $LinkedTicketID;
            }

            for my $LinkedTicketID (@SlaveTicketIDs) {
                $Self->{LinkObject}->LinkDelete(
                    Object1 => 'Ticket',
                    Key1    => $Param{TicketID},
                    Object2 => 'Ticket',
                    Key2    => $LinkedTicketID,
                    Type    => 'ParentChild',
                    UserID  => $Param{UserID},
                );
            }
        }
        elsif (
            $Param{MasterSlaveDynamicFieldValue} eq 'UnsetSlave'
            && !$Param{MasterSlaveKeepParentChildAfterUnset}
            && $Ticket{ 'DynamicField_' . $MasterSlaveDynamicFieldName } =~ /^SlaveOf:(.*?)$/
            )
        {
            my $SourceKey = $Self->{TicketObject}->TicketIDLookup(
                TicketNumber => $1,
                UserID       => $Param{UserID},
            );

            $Self->{LinkObject}->LinkDelete(
                Object1 => 'Ticket',
                Key1    => $SourceKey,
                Object2 => 'Ticket',
                Key2    => $Param{TicketID},
                Type    => 'ParentChild',
                UserID  => $Param{UserID},
            );
        }

        # get dynamic field config
        my $DynamicField = $Self->{DynamicFieldObject}->DynamicFieldGet(
            Name => $MasterSlaveDynamicFieldName,
        );
        $Self->{BackendObject}->ValueSet(
            DynamicFieldConfig => $DynamicField,
            ObjectID           => $Param{TicketID},
            Value              => '',
            UserID             => $Param{UserID},
        );
    }

    return 1;
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut

=head1 VERSION

$Revision: 1.6 $ $Date: 2012-05-04 11:51:23 $

=cut
