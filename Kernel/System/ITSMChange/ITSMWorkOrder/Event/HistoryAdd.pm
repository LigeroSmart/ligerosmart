# --
# Kernel/System/ITSMChange/ITSMWorkOrder/Event/HistoryAdd.pm - HistoryAdd event module for WorkOrder
# Copyright (C) 2003-2010 OTRS AG, http://otrs.com/
# --
# $Id: HistoryAdd.pm,v 1.21 2010-01-12 19:39:29 ub Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::ITSMChange::ITSMWorkOrder::Event::HistoryAdd;

use strict;
use warnings;

use Kernel::System::ITSMChange::History;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.21 $) [1];

=head1 NAME

Kernel::System::ITSMChange::ITSMWorkOrder::HistoryAdd - WorkOrder history add lib

=head1 SYNOPSIS

Event handler module for history add in WorkOrder.

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
    use Kernel::System::ITSMChange::ITSMWorkOrder;
    use Kernel::System::ITSMChange::ITSMWorkOrder::Event::HistoryAdd;

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
    my $WorkOrderObject = Kernel::System::ITSMChange::ITSMWorkOrder->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
        DBObject     => $DBObject,
        TimeObject   => $TimeObject,
        MainObject   => $MainObject,
    );
    my $HistoryObject = Kernel::System::ITSMChange::ITSMWorkOrder::Event::HistoryAdd->new(
        ConfigObject    => $ConfigObject,
        EncodeObject    => $EncodeObject,
        LogObject       => $LogObject,
        DBObject        => $DBObject,
        TimeObject      => $TimeObject,
        MainObject      => $MainObject,
        WorkOrderObject => $WorkOrderObject,
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get needed objects
    for my $Object (
        qw(DBObject ConfigObject EncodeObject LogObject MainObject TimeObject WorkOrderObject)
        )
    {
        $Self->{$Object} = $Param{$Object} || die "Got no $Object!";
    }

    # create additional objects
    $Self->{HistoryObject} = Kernel::System::ITSMChange::History->new( %{$Self} );

    return $Self;
}

=item Run()

The C<Run()> method handles the events and adds/deletes the history entries for
the given workorder object.

It returns 1 on success, C<undef> otherwise.

    my $Success = $HistoryObject->Run(
        Event => 'WorkOrderUpdatePost',
        Data => {
            WorkOrderID    => 123,
            WorkOrderTitle => 'test',
            ChangeID       => 456,
        },
        Config => {
            Event       => '(WorkOrderAddPost|WorkOrderUpdatePost|WorkOrderDeletePost)',
            Module      => 'Kernel::System::ITSMChange::ITSMWorkOrder::Event::HistoryAdd',
            Transaction => '0',
        },
        UserID => 1,
    );

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(Data Event Config UserID)) {
        if ( !$Param{$Needed} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    # in history we use event name without 'Post'
    my $HistoryType = $Param{Event};
    $HistoryType =~ s{ Post \z }{}xms;

    # do history stuff
    if ( $HistoryType eq 'WorkOrderAdd' ) {

        # tell history that a change was added
        return if !$Self->{HistoryObject}->HistoryAdd(
            HistoryType => $HistoryType,
            WorkOrderID => $Param{Data}->{WorkOrderID},
            UserID      => $Param{UserID},
            ContentNew  => $Param{Data}->{WorkOrderID},
            ChangeID    => $Param{Data}->{ChangeID},
        );
    }
    elsif ( $HistoryType eq 'WorkOrderUpdate' ) {

        # get old data
        my $OldData = $Param{Data}->{OldWorkOrderData};

        FIELD:
        for my $Field ( keys %{ $Param{Data} } ) {

            # avoid recursion
            next FIELD if $Field eq 'OldWorkOrderData';

            # we do not track the user id and "plain" columns
            next FIELD if $Field eq 'UserID';
            next FIELD if $Field eq 'ReportPlain';
            next FIELD if $Field eq 'InstructionPlain';

            # check if field has changed
            my $FieldHasChanged = $Self->_HasFieldChanged(
                New => $Param{Data}->{$Field},
                Old => $OldData->{$Field},
            );

            # save history if field changed
            if ($FieldHasChanged) {

                my $Success = $Self->{HistoryObject}->HistoryAdd(
                    WorkOrderID => $Param{Data}->{WorkOrderID},
                    Fieldname   => $Field,
                    ContentNew  => $Param{Data}->{$Field},
                    ContentOld  => $OldData->{$Field},
                    UserID      => $Param{UserID},
                    HistoryType => $HistoryType,
                    ChangeID    => $OldData->{ChangeID},
                );

                next FIELD if !$Success;
            }
        }
    }
    elsif ( $HistoryType eq 'WorkOrderDelete' ) {

        # get old data
        my $OldData = $Param{Data}->{OldWorkOrderData};

        # get existing history entries for this workorder
        my $HistoryEntries = $Self->{HistoryObject}->WorkOrderHistoryGet(
            WorkOrderID => $OldData->{WorkOrderID},
            UserID      => $Param{UserID},
        );

        # update history entries: delete workorder id
        HISTORYENTRY:
        for my $HistoryEntry ( @{$HistoryEntries} ) {
            $Self->{HistoryObject}->HistoryUpdate(
                HistoryEntryID => $HistoryEntry->{HistoryEntryID},
                WorkOrderID    => undef,
                UserID         => $Param{UserID},
            );
        }

        # add history entry for WorkOrder deletion
        return if !$Self->{HistoryObject}->HistoryAdd(
            ChangeID    => $OldData->{ChangeID},
            ContentNew  => $OldData->{WorkOrderID},
            HistoryType => $HistoryType,
            UserID      => $Param{UserID},
        );
    }

    # handle link events
    elsif ( $HistoryType eq 'WorkOrderLinkAdd' || $HistoryType eq 'WorkOrderLinkDelete' ) {

        # get workorder
        my $WorkOrder = $Self->{WorkOrderObject}->WorkOrderGet(
            WorkOrderID => $Param{Data}->{WorkOrderID},
            UserID      => $Param{UserID},
        );

        return if !$WorkOrder;

        # tell history that a link was added
        return if !$Self->{HistoryObject}->HistoryAdd(
            HistoryType => $HistoryType,
            WorkOrderID => $Param{Data}->{WorkOrderID},
            ChangeID    => $WorkOrder->{ChangeID},
            UserID      => $Param{UserID},
            ContentNew  => join( '%%', $Param{Data}->{SourceObject}, $Param{Data}->{SourceKey} ),
        );
    }

    # handle attachment events
    elsif (
        $HistoryType eq 'WorkOrderAttachmentAdd'
        || $HistoryType eq 'WorkOrderAttachmentDelete'
        )
    {

        # tell history that an attachment event was triggered
        return if !$Self->{HistoryObject}->HistoryAdd(
            HistoryType => $HistoryType,
            ChangeID    => $Param{Data}->{ChangeID},
            UserID      => $Param{UserID},
            ContentNew  => $Param{Data}->{Filename},
            WorkOrderID => $Param{Data}->{WorkOrderID},
        );
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

=item _HasFieldChanged()

This method checks whether a field was changed or not. It returns 1 when field
was changed, 0 otherwise

    my $FieldHasChanged = $HistoryObject->_HasFieldChanged(
        Old => 'old value', # can be array reference or hash reference as well
        New => 'new value', # can be array reference or hash reference as well
    );

=cut

sub _HasFieldChanged {
    my ( $Self, %Param ) = @_;

    # field has changed when either 'new' or 'old is not set
    return 1 if !( $Param{New} && $Param{Old} ) && ( $Param{New} || $Param{Old} );

    # field has not changed when both values are empty
    return if !$Param{New} && !$Param{Old};

    # return result of 'eq' when both params are scalars
    return $Param{New} ne $Param{Old} if !ref( $Param{New} ) && !ref( $Param{Old} );

    # a field has changed when 'ref' is different
    return 1 if ref( $Param{New} ) ne ref( $Param{Old} );

    # check hashes
    if ( ref $Param{New} eq 'HASH' ) {

        # field has changed when number of keys are different
        return 1 if scalar keys %{ $Param{New} } != scalar keys %{ $Param{Old} };

        # check the values for each key
        for my $Key ( keys %{ $Param{New} } ) {
            return 1 if $Param{New}->{$Key} ne $Param{Old}->{$Key};
        }
    }

    # check arrays
    if ( ref $Param{New} eq 'ARRAY' ) {

        # changed when number of elements differ
        return 1 if scalar @{ $Param{New} } != scalar @{ $Param{Old} };

        # check each element
        for my $Index ( 0 .. $#{ $Param{New} } ) {
            return 1 if $Param{New}->[$Index] ne $Param{Old}->[$Index];
        }
    }

    # field has not been changed
    return 0;
}

1;

=end Internal:

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (http://otrs.org/).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see http://www.gnu.org/licenses/agpl.txt.

=cut

=head1 VERSION

$Revision: 1.21 $ $Date: 2010-01-12 19:39:29 $

=cut
