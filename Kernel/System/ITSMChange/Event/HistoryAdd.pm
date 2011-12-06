# --
# Kernel/System/ITSMChange/Event/HistoryAdd.pm - HistoryAdd event module for ITSMChange
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: HistoryAdd.pm,v 1.50 2011-12-06 12:40:25 ub Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::ITSMChange::Event::HistoryAdd;

use strict;
use warnings;

use Kernel::System::ITSMChange::ITSMWorkOrder;
use Kernel::System::ITSMChange::History;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.50 $) [1];

=head1 NAME

Kernel::System::ITSMChange::Event::HistoryAdd - Change and workorder history add lib

=head1 SYNOPSIS

Event handler module for history add in change management.

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
    use Kernel::System::ITSMChange::Event::HistoryAdd;

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
    my $EventObject = Kernel::System::ITSMChange::Event::HistoryAdd->new(
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
    $Self->{WorkOrderObject} = Kernel::System::ITSMChange::ITSMWorkOrder->new( %{$Self} );
    $Self->{HistoryObject}   = Kernel::System::ITSMChange::History->new( %{$Self} );

    return $Self;
}

=item Run()

The C<Run()> method handles the events and adds/deletes the history entries for
the given change or workorder.

It returns 1 on success, C<undef> otherwise.

    my $Success = $EventObject->Run(
        Event => 'ChangeUpdatePost',
        Data => {
            ChangeID       => 123,
            ChangeTitle    => 'test',
        },
        Config => {
            Event       => '(ChangeAddPost|ChangeUpdatePost|ChangeCABUpdatePost|ChangeCABDeletePost)',
            Module      => 'Kernel::System::ITSMChange::Event::HistoryAdd',
            Transaction => '0',
        },
        UserID => 1,
    );

For workorder events the C<WorkOrderID> is expected.

    my $Success = $EventObject->Run(
        Event => 'WorkOrderUpdatePost',
        Data => {
            WorkOrderID    => 456,
            WorkOrderTitle => 'test',
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

    # do not modify the original event, because we need this unmodified in later event modules
    my $Event = $Param{Event};

    # in history event handling we use Event name without the trailing 'Post'
    $Event =~ s{ Post \z }{}xms;

    # distinguish between Change and WorkOrder events, based on naming convention
    my ($Type) = $Event =~ m{ \A ( Change | WorkOrder | Condition | Expression | Action ) }xms;
    if ( !$Type ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Could not determine the object type for the event '$Event'!"
        );
        return;
    }

    # do history stuff
    if ( $Event eq 'ChangeAdd' || $Event eq 'WorkOrderAdd' ) {

        # tell history that a change was added
        return if !$Self->{HistoryObject}->HistoryAdd(
            ChangeID    => $Param{Data}->{ChangeID},
            WorkOrderID => $Param{Data}->{WorkOrderID},
            HistoryType => $Event,
            ContentNew  => $Param{Data}->{ $Type . 'ID' },
            UserID      => $Param{UserID},
        );
    }

    elsif ( $Event eq 'ChangeUpdate' || $Event eq 'WorkOrderUpdate' ) {

        # get old data, either from change or workorder
        my $OldData  = $Param{Data}->{"Old${Type}Data"};
        my $ChangeID = $OldData->{ChangeID};               # works for change and workorder events

        FIELD:
        for my $Field ( sort keys %{ $Param{Data} } ) {

            # do not track special fields 'OldChangeData' or 'OldWorkOrderData'
            next FIELD if $Field eq "Old${Type}Data";

            # we do not track the user id
            next FIELD if $Field eq 'UserID';

            # we do not the "plain" columns, only the non-plain columns
            next FIELD if $Field eq 'JustificationPlain';    # change
            next FIELD if $Field eq 'DescriptionPlain';      # change
            next FIELD if $Field eq 'ReportPlain';           # workorder
            next FIELD if $Field eq 'InstructionPlain';      # workorder

            # we do no want to track the internal field "NoNumberCalc"
            next FIELD if $Field eq 'NoNumberCalc';          # workorder

            # The history of CAB updates is not tracked here,
            # but in the handler for ChangeCABUpdate.
            next FIELD if $Field eq 'CABAgents';             # change
            next FIELD if $Field eq 'CABCustomers';          # change

            # special handling for accounted time
            if ( $Type eq 'WorkOrder' && $Field eq 'AccountedTime' ) {

                # we do not track if accounted time was empty
                next FIELD if !$Param{Data}->{$Field};

                # if accounted time is not empty, we always track the history

                # get workorder data
                my $WorkOrder = $Self->{WorkOrderObject}->WorkOrderGet(
                    WorkOrderID => $Param{Data}->{WorkOrderID},
                    UserID      => $Param{UserID},
                );

                # save history if accounted time has changed
                $Self->{HistoryObject}->HistoryAdd(
                    ChangeID    => $ChangeID,
                    WorkOrderID => $Param{Data}->{WorkOrderID},
                    HistoryType => $Event,
                    Fieldname   => $Field,
                    ContentNew  => $WorkOrder->{$Field},
                    ContentOld  => $OldData->{$Field},
                    UserID      => $Param{UserID},
                );

                next FIELD;
            }

            # check if field has changed
            my $FieldHasChanged = $Self->_HasFieldChanged(
                New => $Param{Data}->{$Field},
                Old => $OldData->{$Field},
            );

            # save history if field changed
            if ($FieldHasChanged) {

                my $Success = $Self->{HistoryObject}->HistoryAdd(
                    ChangeID    => $ChangeID,
                    WorkOrderID => $Param{Data}->{WorkOrderID},
                    HistoryType => $Event,
                    Fieldname   => $Field,
                    ContentNew  => $Param{Data}->{$Field},
                    ContentOld  => $OldData->{$Field},
                    UserID      => $Param{UserID},
                );

                next FIELD if !$Success;
            }
        }
    }

    elsif ( $Event eq 'WorkOrderDelete' ) {

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
            HistoryType => $Event,
            ContentNew  => $OldData->{WorkOrderID},
            UserID      => $Param{UserID},
        );
    }

    # handle ChangeCAB events
    elsif ( $Event eq 'ChangeCABUpdate' || $Event eq 'ChangeCABDelete' ) {

        # get old data
        my $OldData = $Param{Data}->{OldChangeCABData};

        FIELD:
        for my $Field (qw(CABAgents CABCustomers)) {

            # we do not track when the param has not been passed
            next FIELD if !$Param{Data}->{$Field};

            # check if field has changed
            my $FieldHasChanged = $Self->_HasFieldChanged(
                New => $Param{Data}->{$Field},
                Old => $OldData->{$Field},
            );

            # save history if field changed
            if ($FieldHasChanged) {

                my $Success = $Self->{HistoryObject}->HistoryAdd(
                    ChangeID    => $Param{Data}->{ChangeID},
                    HistoryType => $Event,
                    Fieldname   => $Field,
                    ContentNew  => join( '%%', @{ $Param{Data}->{$Field} } ),
                    ContentOld  => join( '%%', @{ $OldData->{$Field} } ),
                    UserID      => $Param{UserID},
                );

                next FIELD if !$Success;
            }
        }
    }

    # handle link events
    elsif (
        $Event    eq 'ChangeLinkAdd'
        || $Event eq 'ChangeLinkDelete'
        || $Event eq 'WorkOrderLinkAdd'
        || $Event eq 'WorkOrderLinkDelete'
        )
    {

        # for  workorder links get the change id
        if ( $Param{Data}->{WorkOrderID} ) {
            my $WorkOrder = $Self->{WorkOrderObject}->WorkOrderGet(
                WorkOrderID => $Param{Data}->{WorkOrderID},
                UserID      => $Param{UserID},
            );

            $Param{Data}->{ChangeID} = $WorkOrder->{ChangeID};
        }

        my $ContentNew = join '%%',
            $Param{Data}->{SourceObject} || $Param{Data}->{TargetObject},
            $Param{Data}->{SourceKey} || $Param{Data}->{TargetKey};

        # tell history that a link was added
        return if !$Self->{HistoryObject}->HistoryAdd(
            ChangeID    => $Param{Data}->{ChangeID},
            WorkOrderID => $Param{Data}->{WorkOrderID},
            HistoryType => $Event,
            ContentNew  => $ContentNew,
            UserID      => $Param{UserID},
        );
    }

    # handle attachment events
    elsif (
        $Event    eq 'ChangeAttachmentAdd'
        || $Event eq 'ChangeAttachmentDelete'
        || $Event eq 'WorkOrderAttachmentAdd'
        || $Event eq 'WorkOrderAttachmentDelete'
        )
    {

        # tell history that an attachment event was triggered
        return if !$Self->{HistoryObject}->HistoryAdd(
            ChangeID    => $Param{Data}->{ChangeID},
            WorkOrderID => $Param{Data}->{WorkOrderID},
            HistoryType => $Event,
            ContentNew  => $Param{Data}->{Filename},
            UserID      => $Param{UserID},
        );
    }

    # handle xxxTimeReached events
    elsif ( $Event =~ m{ TimeReached \z }xms ) {
        my $ID = $Param{Data}->{WorkOrderID} || $Param{Data}->{ChangeID};

        return if !$Self->{HistoryObject}->HistoryAdd(
            ChangeID    => $Param{Data}->{ChangeID},
            WorkOrderID => $Param{Data}->{WorkOrderID},
            HistoryType => $Event,
            ContentNew  => $ID . '%%Notification Sent',
            UserID      => $Param{UserID},
        );
    }

    # add history entry when notification was sent
    elsif ( $Event =~ m{ NotificationSent \z }xms ) {
        my $ID = $Param{Data}->{WorkOrderID} || $Param{Data}->{ChangeID};

        return if !$Self->{HistoryObject}->HistoryAdd(
            ChangeID    => $Param{Data}->{ChangeID},
            WorkOrderID => $Param{Data}->{WorkOrderID},
            HistoryType => $Event,
            ContentNew  => $Param{Data}->{To} . '%%' . $Param{Data}->{EventType},
            UserID      => $Param{UserID},
        );
    }

    # handle condition events
    elsif ( $Event eq 'ConditionAdd' ) {

        # create history for id
        $Self->{HistoryObject}->HistoryAdd(
            ChangeID    => $Param{Data}->{ChangeID},
            HistoryType => $Event,
            ContentNew  => $Param{Data}->{ConditionID},
            UserID      => $Param{UserID},
        );

        # create history for all condition fields
        my @ConditionStatic = qw(ConditionID UserID ChangeID);
        CONDITIONFIELD:
        for my $ConditionField ( keys %{ $Param{Data} } ) {

            # check for static fields
            next CONDITIONFIELD if grep { $_ eq $ConditionField } @ConditionStatic;

            # do not add empty fields to history
            next CONDITIONFIELD if !$Param{Data}->{$ConditionField};

            $Self->{HistoryObject}->HistoryAdd(
                ChangeID    => $Param{Data}->{ChangeID},
                HistoryType => $Event,
                Fieldname   => $ConditionField,
                ContentNew  => $Param{Data}->{$ConditionField},
                UserID      => $Param{UserID},
            );
        }
    }

    # handle condition update events
    elsif ( $Event eq 'ConditionUpdate' ) {

        # get old data
        my $OldData = $Param{Data}->{OldConditionData};

        # create history for all condition fields
        my @ConditionStatic = qw(ConditionID UserID ChangeID OldConditionData);
        CONDITIONFIELD:
        for my $ConditionField ( keys %{ $Param{Data} } ) {

            # check for static fields
            next CONDITIONFIELD if grep { $_ eq $ConditionField } @ConditionStatic;

            # do not add empty fields to history
            next CONDITIONFIELD if !$Param{Data}->{$ConditionField};

            # check if field has changed
            my $FieldHasChanged = $Self->_HasFieldChanged(
                New => $Param{Data}->{$ConditionField},
                Old => $OldData->{$ConditionField},
            );

            # create history only for changed fields
            next CONDITIONFIELD if !$FieldHasChanged;

            $Self->{HistoryObject}->HistoryAdd(
                ChangeID    => $OldData->{ChangeID},
                HistoryType => $Event,
                Fieldname   => $ConditionField,
                ContentNew  => $Param{Data}->{ConditionID} . '%%' . $Param{Data}->{$ConditionField},
                ContentOld  => $Param{Data}->{ConditionID} . '%%' . $OldData->{$ConditionField},
                UserID      => $Param{UserID},
            );
        }
    }

    # handle condition delete events
    elsif ( $Event eq 'ConditionDelete' ) {

        # get old data
        my $OldData = $Param{Data}->{OldConditionData};

        return if !$Self->{HistoryObject}->HistoryAdd(
            ChangeID    => $OldData->{ChangeID},
            HistoryType => $Event,
            ContentNew  => $OldData->{ConditionID},
            UserID      => $Param{UserID},
        );
    }

    # handle condition delete events
    elsif ( $Event eq 'ConditionDeleteAll' ) {

        return if !$Self->{HistoryObject}->HistoryAdd(
            ChangeID    => $Param{Data}->{ChangeID},
            HistoryType => $Event,
            ContentNew  => $Param{Data}->{ChangeID},
            UserID      => $Param{UserID},
        );
    }

    # handle expression events
    elsif ( $Event eq 'ExpressionAdd' ) {

        # create history for id
        $Self->{HistoryObject}->HistoryAdd(
            ChangeID    => $Param{Data}->{ChangeID},
            HistoryType => $Event,
            ContentNew  => $Param{Data}->{ExpressionID},
            UserID      => $Param{UserID},
        );

        # create history for all expression fields
        my @ExpressionStatic = qw( ExpressionID UserID ChangeID);
        EXPRESSIONFIELD:
        for my $ExpressionField ( keys %{ $Param{Data} } ) {

            # check for static fields
            next EXPRESSIONFIELD if grep { $_ eq $ExpressionField } @ExpressionStatic;

            # do not add empty fields to history
            next EXPRESSIONFIELD if !$Param{Data}->{$ExpressionField};

            $Self->{HistoryObject}->HistoryAdd(
                ChangeID    => $Param{Data}->{ChangeID},
                HistoryType => $Event,
                Fieldname   => $ExpressionField,
                ContentNew  => $Param{Data}->{$ExpressionField},
                UserID      => $Param{UserID},
            );
        }
    }

    # handle expression update events
    elsif ( $Event eq 'ExpressionUpdate' ) {

        # get old data
        my $OldData = $Param{Data}->{OldExpressionData};

        # create history for all expression fields
        my @ExpressionStatic = qw( ExpressionID UserID ChangeID OldExpressionData );
        EXPRESSIONFIELD:
        for my $ExpressionField ( keys %{ $Param{Data} } ) {

            # check for static fields
            next EXPRESSIONFIELD if grep { $_ eq $ExpressionField } @ExpressionStatic;

            # do not add empty fields to history
            next EXPRESSIONFIELD if !$Param{Data}->{$ExpressionField};

            # check if field has changed
            my $FieldHasChanged = $Self->_HasFieldChanged(
                New => $Param{Data}->{$ExpressionField},
                Old => $OldData->{$ExpressionField},
            );

            # create history only for changed fields
            next EXPRESSIONFIELD if !$FieldHasChanged;

            $Self->{HistoryObject}->HistoryAdd(
                ChangeID    => $Param{Data}->{ChangeID},
                HistoryType => $Event,
                Fieldname   => $ExpressionField,
                ContentNew  => $Param{Data}->{ExpressionID} . '%%'
                    . $Param{Data}->{$ExpressionField},
                ContentOld => $Param{Data}->{ExpressionID} . '%%' . $OldData->{$ExpressionField},
                UserID     => $Param{UserID},
            );
        }
    }

    # handle expression delete events
    elsif ( $Event eq 'ExpressionDelete' ) {

        return if !$Self->{HistoryObject}->HistoryAdd(
            ChangeID    => $Param{Data}->{ChangeID},
            HistoryType => $Event,
            ContentNew  => $Param{Data}->{ExpressionID},
            UserID      => $Param{UserID},
        );
    }

    # handle delete all expressions events
    elsif ( $Event eq 'ExpressionDeleteAll' ) {

        return if !$Self->{HistoryObject}->HistoryAdd(
            ChangeID    => $Param{Data}->{ChangeID},
            HistoryType => $Event,
            ContentNew  => $Param{Data}->{ConditionID},
            UserID      => $Param{UserID},
        );
    }

    # handle action events
    elsif ( $Event eq 'ActionAdd' ) {

        # create history for id
        $Self->{HistoryObject}->HistoryAdd(
            ChangeID    => $Param{Data}->{ChangeID},
            HistoryType => $Event,
            ContentNew  => $Param{Data}->{ActionID},
            UserID      => $Param{UserID},
        );

        # create history for all action fields
        my @ActionStatic = qw( ActionID UserID ChangeID);
        ACTIONFIELD:
        for my $ActionField ( keys %{ $Param{Data} } ) {

            # check for static fields
            next ACTIONFIELD if grep { $_ eq $ActionField } @ActionStatic;

            # do not add empty fields to history
            next ACTIONFIELD if !$Param{Data}->{$ActionField};

            $Self->{HistoryObject}->HistoryAdd(
                ChangeID    => $Param{Data}->{ChangeID},
                HistoryType => $Event,
                Fieldname   => $ActionField,
                ContentNew  => $Param{Data}->{$ActionField},
                UserID      => $Param{UserID},
            );
        }
    }

    # handle action update events
    elsif ( $Event eq 'ActionUpdate' ) {

        # get old data
        my $OldData = $Param{Data}->{OldActionData};

        # create history for all expression fields
        my @ActionStatic = qw( ActionID UserID ChangeID OldActionData );
        ACTIONFIELD:
        for my $ActionField ( keys %{ $Param{Data} } ) {

            # check for static fields
            next ACTIONFIELD if grep { $_ eq $ActionField } @ActionStatic;

            # do not add empty fields to history
            next ACTIONFIELD if !$Param{Data}->{$ActionField};

            # check if field has changed
            my $FieldHasChanged = $Self->_HasFieldChanged(
                New => $Param{Data}->{$ActionField},
                Old => $OldData->{$ActionField},
            );

            # create history only for changed fields
            next ACTIONFIELD if !$FieldHasChanged;

            $Self->{HistoryObject}->HistoryAdd(
                ChangeID    => $Param{Data}->{ChangeID},
                HistoryType => $Event,
                Fieldname   => $ActionField,
                ContentNew  => $Param{Data}->{ActionID} . '%%' . $Param{Data}->{$ActionField},
                ContentOld  => $Param{Data}->{ActionID} . '%%' . $OldData->{$ActionField},
                UserID      => $Param{UserID},
            );
        }
    }

    # handle action delete events
    elsif ( $Event eq 'ActionDelete' ) {

        return if !$Self->{HistoryObject}->HistoryAdd(
            ChangeID    => $Param{Data}->{ChangeID},
            HistoryType => $Event,
            ContentNew  => $Param{Data}->{ActionID},
            UserID      => $Param{UserID},
        );
    }

    # handle delete all actions events
    elsif ( $Event eq 'ActionDeleteAll' ) {

        return if !$Self->{HistoryObject}->HistoryAdd(
            ChangeID    => $Param{Data}->{ChangeID},
            HistoryType => $Event,
            ContentNew  => $Param{Data}->{ConditionID},
            UserID      => $Param{UserID},
        );
    }

    # handle action execute events
    elsif ( $Event eq 'ActionExecute' ) {

        return if !$Self->{HistoryObject}->HistoryAdd(
            ChangeID    => $Param{Data}->{ChangeID},
            HistoryType => $Event,
            ContentNew  => $Param{Data}->{ActionID} . '%%' . $Param{Data}->{ActionResult},
            UserID      => $Param{UserID},
        );
    }

    # error
    else {

        # an unknown event
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "$Event is an unknown event!",
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
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut

=head1 VERSION

$Revision: 1.50 $ $Date: 2011-12-06 12:40:25 $

=cut
