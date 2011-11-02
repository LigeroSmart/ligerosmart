# --
# Kernel/System/MasterSlave.pm - to handle ticket master slave tasks
# Copyright (C) 2003-2011 OTRS AG, http://otrs.com/
# --
# $Id: MasterSlave.pm,v 1.2 2011-11-02 23:32:01 te Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::MasterSlave;

use strict;
use warnings;

use Kernel::System::LinkObject;

use vars qw(@ISA $VERSION);
$VERSION = qw($Revision: 1.2 $) [1];

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

    $Self->{LinkObject} = Kernel::System::LinkObject->new(%Param);

    return $Self;
}

=item MasterSlave()

handles all the ticket master slave tasks
    my $True = $MasterSlaveObject->MasterSlave(
        MasterSlaveTicketFreeTextID           => '12',
        MasterSlaveTicketFreeTextContent      => 'Master',
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
        qw(MasterSlaveTicketFreeTextID MasterSlaveTicketFreeTextContent TicketID UserID)
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

    my $MasterSlaveTicketFreeTextFieldName = 'TicketFreeText' . $Param{MasterSlaveTicketFreeTextID};
    my %Ticket
        = $Param{Ticket}
        ? %{ $Param{Ticket} }
        : $Self->{TicketObject}->TicketGet( TicketID => $Param{TicketID} );

    if (
        $Param{MasterSlaveTicketFreeTextContent} eq 'Master'
        && (
            !$Ticket{$MasterSlaveTicketFreeTextFieldName}
            || $Ticket{$MasterSlaveTicketFreeTextFieldName} ne 'Master'
        )
        )
    {

        if (
            $Ticket{$MasterSlaveTicketFreeTextFieldName}
            && $Ticket{$MasterSlaveTicketFreeTextFieldName} =~ /^SlaveOf:(\d+)$/
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

        $Self->{TicketObject}->TicketFreeTextSet(
            Counter  => $Param{MasterSlaveTicketFreeTextID},
            Key      => 'MasterSlave',
            Value    => 'Master',
            TicketID => $Param{TicketID},
            UserID   => $Param{UserID},
        );
    }
    elsif (
        $Param{MasterSlaveTicketFreeTextContent} =~ /^SlaveOf:(\d+)$/
        && (
            !$Ticket{$MasterSlaveTicketFreeTextFieldName}
            || $Ticket{$MasterSlaveTicketFreeTextFieldName} ne
            $Param{MasterSlaveTicketFreeTextContent}
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
            my %Ticket = $Self->{TicketObject}->TicketGet( TicketID => $LinkedTicketID );
            next if !$Ticket{$MasterSlaveTicketFreeTextFieldName};
            next if $Ticket{$MasterSlaveTicketFreeTextFieldName} !~ /^SlaveOf:(\d+)$/;

            # remember ticket id
            push @SlaveTicketIDs, $LinkedTicketID;
        }

        if (
            $Ticket{$MasterSlaveTicketFreeTextFieldName}
            && $Ticket{$MasterSlaveTicketFreeTextFieldName} eq 'Master'
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
            $Ticket{$MasterSlaveTicketFreeTextFieldName}
            && $Ticket{$MasterSlaveTicketFreeTextFieldName} =~ /^SlaveOf:(\d+)$/
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

        $Self->{TicketObject}->TicketFreeTextSet(
            Counter  => $Param{MasterSlaveTicketFreeTextID},
            Key      => 'MasterSlave',
            Value    => $Param{MasterSlaveTicketFreeTextContent},
            TicketID => $Param{TicketID},
            UserID   => $Param{UserID},
        );
    }
    elsif (
        $Param{MasterSlaveTicketFreeTextContent} =~ /^(?:UnsetMaster|UnsetSlave)$/
        && $Ticket{$MasterSlaveTicketFreeTextFieldName}
        )
    {

        if (
            $Param{MasterSlaveTicketFreeTextContent} eq 'UnsetMaster'
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
                my %Ticket = $Self->{TicketObject}->TicketGet( TicketID => $LinkedTicketID );
                next if !$Ticket{$MasterSlaveTicketFreeTextFieldName};
                next if $Ticket{$MasterSlaveTicketFreeTextFieldName} !~ /^SlaveOf:(\d+)$/;

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
            $Param{MasterSlaveTicketFreeTextContent} eq 'UnsetSlave'
            && !$Param{MasterSlaveKeepParentChildAfterUnset}
            && $Ticket{$MasterSlaveTicketFreeTextFieldName} =~ /^SlaveOf:(\d+)$/
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

        $Self->{TicketObject}->TicketFreeTextSet(
            Counter  => $Param{MasterSlaveTicketFreeTextID},
            Key      => '',
            Value    => '',
            TicketID => $Param{TicketID},
            UserID   => $Param{UserID},
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

$Revision: 1.2 $ $Date: 2011-11-02 23:32:01 $

=cut
