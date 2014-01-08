# --
# Kernel/System/ITSMChange/Event/Condition.pm - a event module to match conditions
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::ITSMChange::Event::Condition;

use strict;
use warnings;

use Kernel::System::ITSMChange::ITSMWorkOrder;
use Kernel::System::ITSMChange::ITSMCondition;

=head1 NAME

Kernel::System::ITSMChange::Event::Condition - ITSM change management condition event lib

=head1 SYNOPSIS

Event handler module for condition matching for changes and workorders.

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
    use Kernel::System::ITSMChange::Event::Condition;

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
    my $EventObject = Kernel::System::ITSMChange::Event::Condition->new(
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
    $Self->{ConditionObject} = Kernel::System::ITSMChange::ITSMCondition->new( %{$Self} );

    return $Self;
}

=item Run()

The C<Run()> method handles the events and matches and executes all conditions that are
defined for the current change.

It returns 1 on success, C<undef> otherwise.

    my $Success = $EventObject->Run(
        Event => 'ChangeUpdatePost',
        Data => {
            ChangeID    => 123,
            ChangeTitle => 'test',
        },
        Config => {
            Event       => '(ChangeAddPost|ChangeUpdatePost)',
            Module      => 'Kernel::System::ITSMChange::Event::Condition',
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
                Message  => "Need $Argument!"
            );
            return;
        }
    }

    # to store the change id
    my $ChangeID;

    # to store the object were the data comes from
    my $Object;

    # handle change events
    if ( $Param{Event} =~ m{ \A Change }xms ) {

        # set the change id
        $ChangeID = $Param{Data}->{ChangeID};

        # set the object
        $Object = 'ITSMChange';
    }

    # handle workorder events
    elsif ( $Param{Event} =~ m{ \A WorkOrder }xms ) {

        # get workorder
        my $WorkOrder = $Self->{WorkOrderObject}->WorkOrderGet(
            WorkOrderID => $Param{Data}->{WorkOrderID},
            UserID      => $Param{UserID},
        );

        # set the change id from workorder data
        $ChangeID = $WorkOrder->{ChangeID};

        # set the object
        $Object = 'ITSMWorkOrder';
    }

    # show error for unknown events
    else {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Can not handle event '$Param{Event}'!"
        );
        return;
    }

    # in case of an update event or a time reached event, store the updated attributes
    my @AttributesChanged;
    if ( $Param{Event} eq 'ChangeUpdatePost' ) {

        # get old data
        my $OldData = $Param{Data}->{OldChangeData};

        FIELD:
        for my $Field ( sort keys %{ $Param{Data} } ) {

            # avoid recursion
            next FIELD if $Field eq 'OldChangeData';

            # we do not track the user id and "plain" columns
            next FIELD if $Field eq 'UserID';
            next FIELD if $Field eq 'JustificationPlain';
            next FIELD if $Field eq 'DescriptionPlain';

            # check if field has changed
            my $FieldHasChanged = $Self->_HasFieldChanged(
                New => $Param{Data}->{$Field},
                Old => $OldData->{$Field},
            );

            next FIELD if !$FieldHasChanged;

            # remember changed field name
            push @AttributesChanged, $Field;
        }
    }
    elsif ( $Param{Event} eq 'WorkOrderUpdatePost' ) {

        # get old data
        my $OldData = $Param{Data}->{OldWorkOrderData};

        FIELD:
        for my $Field ( sort keys %{ $Param{Data} } ) {

            # avoid recursion
            next FIELD if $Field eq 'OldWorkOrderData';

            # we do not track the user id and "plain" columns
            next FIELD if $Field eq 'UserID';
            next FIELD if $Field eq 'ReportPlain';
            next FIELD if $Field eq 'InstructionPlain';

            # special handling for accounted time
            if ( $Field eq 'AccountedTime' ) {

                # we do not track if accounted time was empty or zero
                next FIELD if !$Param{Data}->{AccountedTime};

                # remember changed field name
                push @AttributesChanged, $Field;

                next FIELD;
            }

            # check if field has changed
            my $FieldHasChanged = $Self->_HasFieldChanged(
                New => $Param{Data}->{$Field},
                Old => $OldData->{$Field},
            );

            next FIELD if !$FieldHasChanged;

            # remember changed field name
            push @AttributesChanged, $Field;
        }
    }

    # all kind of change and workorder time reached events
    elsif ( $Param{Event} =~ m{ \A (?: Change | WorkOrder ) ( .+ Time ) ReachedPost \z }xms ) {

        # get the name of the reached time field
        my $Field = $1;

        # remember changed field name
        push @AttributesChanged, $Field;
    }

    # match all conditions for this change and execute all actions
    my $Success = $Self->{ConditionObject}->ConditionMatchExecuteAll(
        ChangeID          => $ChangeID,
        AttributesChanged => { $Object => \@AttributesChanged },
        Event             => $Param{Event},
        UserID            => $Param{UserID},
    );

    # check errors
    if ( !$Success ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "ConditionMatchExecuteAll could not be "
                . "executed successfully for event '$Param{Event}' on ChangeID '$ChangeID'!"
        );
        return;
    }

    return 1;
}

=begin Internal:

=item _HasFieldChanged()

This method checks whether a field was changed or not. It returns 1 when field
was changed, 0 otherwise

    my $FieldHasChanged = $ConditionObject->_HasFieldChanged(
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
        for my $Key ( sort keys %{ $Param{New} } ) {
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
