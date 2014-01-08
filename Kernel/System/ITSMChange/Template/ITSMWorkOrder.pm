# --
# Kernel/System/ITSMChange/Template/ITSMWorkOrder.pm - all template functions for workorders
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::ITSMChange::Template::ITSMWorkOrder;

use strict;
use warnings;

use Kernel::System::ITSMChange::ITSMWorkOrder;
use Kernel::System::ITSMChange::ITSMStateMachine;
use Kernel::System::LinkObject;
use Kernel::System::Valid;

## nofilter(TidyAll::Plugin::OTRS::Perl::Dumper)
use Data::Dumper;

=head1 NAME

Kernel::System::ITSMChange::Template::ITSMChange - all template functions for workorders

=head1 SYNOPSIS

All functions for workorder templates in ITSMChangeManagement.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create an object

    use Kernel::Config;
    use Kernel::System::Encode;
    use Kernel::System::Log;
    use Kernel::System::DB;
    use Kernel::System::Main;
    use Kernel::System::Time;
    use Kernel::System::ITSMChange::Template::ITSMWorkOrder;

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
    my $TemplateObject = Kernel::System::ITSMChange::Template::ITSMWorkOrder->new(
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

    # check needed objects
    for my $Object (
        qw(DBObject ConfigObject EncodeObject LogObject UserObject GroupObject MainObject TimeObject)
        )
    {
        $Self->{$Object} = $Param{$Object} || die "Got no $Object!";
    }

    # set the debug flag
    $Self->{Debug} = $Param{Debug} || 0;

    # create additional objects
    $Self->{WorkOrderObject}    = Kernel::System::ITSMChange::ITSMWorkOrder->new( %{$Self} );
    $Self->{StateMachineObject} = Kernel::System::ITSMChange::ITSMStateMachine->new( %{$Self} );
    $Self->{LinkObject}         = Kernel::System::LinkObject->new( %{$Self} );
    $Self->{ValidObject}        = Kernel::System::Valid->new( %{$Self} );

    return $Self;
}

=item Serialize()

Serialize a workorder. This is done with Data::Dumper. It returns
a serialized string of the datastructure. The workorder actions
are "wrapped" within a hashreference...

    my $TemplateString = $TemplateObject->Serialize(
        WorkOrderID => 1,
        StateReset  => 1, # (optional) reset to default state
        UserID      => 1,
        Return      => 'HASH', # (optional) HASH|STRING default 'STRING'
    );

returns

    '{WorkOrderAdd => { ChangeID => 123, ... }}'

If parameter C<Return> is set to C<HASH>, the Perl datastructure
is returned

    {
        WorkOrderAdd => { ... },
        Children     => [ ... ],
    }

=cut

sub Serialize {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(UserID WorkOrderID)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # set default value for 'Return'
    $Param{Return} ||= 'STRING';

    # get workorder
    my $WorkOrder = $Self->{WorkOrderObject}->WorkOrderGet(
        WorkOrderID => $Param{WorkOrderID},
        UserID      => $Param{UserID},
    );

    return if !$WorkOrder;

    # keep just wanted attributes
    my $CleanWorkOrder;
    for my $Attribute (
        qw(
        WorkOrderID ChangeID WorkOrderNumber WorkOrderTitle Instruction
        Report WorkOrderStateID WorkOrderTypeID WorkOrderAgentID
        PlannedStartTime PlannedEndTime ActualStartTime ActualEndTime AccountedTime PlannedEffort
        CreateTime CreateBy ChangeTime ChangeBy)
        )
    {
        $CleanWorkOrder->{$Attribute} = $WorkOrder->{$Attribute};
    }

    # reset workorder state to default if requested
    if ( $Param{StateReset} ) {

        # get initial workorder state id
        my $NextStateIDs = $Self->{StateMachineObject}->StateTransitionGet(
            StateID => 0,
            Class   => 'ITSM::ChangeManagement::WorkOrder::State',
        );
        $CleanWorkOrder->{WorkOrderStateID} = $NextStateIDs->[0];

        # reset actual start and end time
        $CleanWorkOrder->{ActualStartTime} = undef;
        $CleanWorkOrder->{ActualEndTime}   = undef;
    }

    # add workorder freekey and freetext fields to list of wanted attributes
    ATTRIBUTE:
    for my $Attribute ( sort keys %{$WorkOrder} ) {

        # find the workorder freekey and freetext attributes
        if ( $Attribute =~ m{ \A ( WorkOrderFreeKey | WorkOrderFreeText ) }xms ) {

            $CleanWorkOrder->{$Attribute} = $WorkOrder->{$Attribute};
        }
    }

    # templates have to be an array reference;
    my $OriginalData = { WorkOrderAdd => $CleanWorkOrder };

    # get attachments
    my @WorkOrderAttachments = $Self->{WorkOrderObject}->WorkOrderAttachmentList(
        WorkOrderID => $WorkOrder->{WorkOrderID},
    );

    for my $Filename (@WorkOrderAttachments) {

        # save attachments to this template
        push @{ $OriginalData->{Children} }, { AttachmentAdd => { Filename => $Filename } };
    }

    # get links to other object
    my $LinkListWithData = $Self->{LinkObject}->LinkListWithData(
        Object => 'ITSMWorkOrder',
        Key    => $WorkOrder->{WorkOrderID},
        State  => 'Valid',
        UserID => $Param{UserID},
    );

    for my $TargetObject ( sort keys %{$LinkListWithData} ) {
        for my $Type ( sort keys %{ $LinkListWithData->{$TargetObject} } ) {
            for my $Key ( sort keys %{ $LinkListWithData->{$TargetObject}->{$Type} } ) {
                for my $TargetID (
                    sort keys %{ $LinkListWithData->{$TargetObject}->{$Type}->{$Key} }
                    )
                {
                    my $LinkInfo = {
                        SourceObject => 'ITSMWorkOrder',
                        SourceKey    => $WorkOrder->{WorkOrderID},
                        TargetObject => $TargetObject,
                        TargetKey    => $TargetID,
                        Type         => $Type,
                        State        => 'Valid',
                        UserID       => $Param{UserID},
                    };
                    push @{ $OriginalData->{Children} }, { LinkAdd => $LinkInfo };
                }
            }
        }
    }

    if ( $Param{Return} eq 'HASH' ) {
        return $OriginalData;
    }

    # no indentation (saves space)
    local $Data::Dumper::Indent = 0;

    # do not use cross-referencing
    local $Data::Dumper::Deepcopy = 1;

    # serialize the data (do not use $VAR1, but $TemplateData for Dumper output)
    my $SerializedData = $Self->{MainObject}->Dump( $OriginalData, 'binary' );

    return $SerializedData;
}

=item DeSerialize()

DeSerialize() is a wrapper for all the _XXXAdd methods.

    my %Info = $TemplateObject->DeSerialize(
        Data => {
            # ... Params for WorkOrderAdd
        },
        ChangeID => 1,
        UserID   => 1,
        Method   => 'WorkOrderAdd',
    );

=cut

sub DeSerialize {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(UserID Method Data)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # dispatch table
    my %Method2Sub = (
        WorkOrderAdd  => '_WorkOrderAdd',
        AttachmentAdd => '_AttachmentAdd',
        LinkAdd       => '_LinkAdd',
    );

    my $Sub = $Method2Sub{ $Param{Method} };

    if ( !$Sub ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Invalid Methodname!',
        );
        return;
    }

    return $Self->$Sub(%Param);
}

=item _WorkOrderAdd()

Creates a new workorder based on a template. It returns the
change id it was created for and the new workorder id.

    my ( $ChangeID, $WorkOrderID ) = $TemplateObject->_WorkOrderAdd(
        Data => {
            WorkOrderTitle => 'test',
        },
        ChangeID       => 1,
        UserID         => 1,
    );

=cut

sub _WorkOrderAdd {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(UserID ChangeID Data)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # make a local copy
    my %Data = %{ $Param{Data} };

    # we need the old change id for expressions
    my $OldWorkOrderID = $Data{WorkOrderID};

    # these attributes are generated automatically, so don't pass them to WorkOrderAdd()
    delete @Data{qw(WorkOrderID CreateTime CreateBy ChangeTime ChangeBy)};
    delete @Data{qw(InstructionPlain ReportPlain)};

    # delete all parameters whose values are 'undef'
    # _CheckWorkOrderParams throws an error otherwise
    for my $Parameter ( sort keys %Data ) {
        delete $Data{$Parameter} if !defined $Data{$Parameter};
    }

    # xxx(?:Start|End)Times are empty strings on WorkOrderGet when
    # no time value is set. This confuses _CheckTimestamps. Thus
    # delete these parameters.
    for my $Prefix (qw(Actual Planned)) {
        for my $Suffix (qw(Start End)) {
            if ( !$Data{"$Prefix${Suffix}Time"} ) {
                delete $Data{"$Prefix${Suffix}Time"};
            }
        }
    }

    # move time slot for workorder if neccessary
    my $Difference = $Param{TimeDifference};
    if ( $Difference || $Param{NewTimeInEpoche} ) {

        # calc new values for start and end time
        for my $Suffix (qw(Start End)) {

            if ( $Data{"Planned${Suffix}Time"} ) {

                # get difference if not already calculated (allow zero difference)
                if ( !defined $Difference && $Param{NewTimeInEpoche} ) {

                    # time needs to be corrected if the move time type is the planned end time
                    my $WorkOrderLengthInSeconds = 0;
                    if ( $Param{MoveTimeType} eq 'PlannedEndTime' ) {

                        # calculate the old planned start time into epoch seconds
                        my $OldPlannedStartTimeInSeconds
                            = $Self->{TimeObject}->TimeStamp2SystemTime(
                            String => $Data{PlannedStartTime},
                            );

                        # calculate the old planned end time into epoch seconds
                        my $OldPlannedEndTimeInSeconds = $Self->{TimeObject}->TimeStamp2SystemTime(
                            String => $Data{PlannedEndTime},
                        );

                        # the time length of the workorder in seconds
                        $WorkOrderLengthInSeconds
                            = $OldPlannedEndTimeInSeconds - $OldPlannedStartTimeInSeconds;
                    }

                    # calculate the time difference
                    $Difference = $Self->_GetTimeDifference(
                        CurrentTime     => $Data{"Planned${Suffix}Time"},
                        NewTimeInEpoche => $Param{NewTimeInEpoche} - $WorkOrderLengthInSeconds,
                    );
                }

                # get new value
                $Data{"Planned${Suffix}Time"} = $Self->_MoveTime(
                    CurrentTime => $Data{"Planned${Suffix}Time"},
                    Difference  => $Difference,
                );
            }
        }
    }

    # override the change id from the template
    my $WorkOrderID = $Self->{WorkOrderObject}->WorkOrderAdd(
        %Data,
        NoNumberCalc => $Param{NoNumberCalc},
        ChangeID     => $Param{ChangeID},
        UserID       => $Param{UserID},
    );

    # we need a mapping "old id" to "new id" for the conditions
    my $OldIDs2NewIDs = {
        %{ $Param{OldWorkOrderIDs} || {} },
        $OldWorkOrderID => $WorkOrderID,
    };

    my %Info = (
        ID              => $WorkOrderID,
        WorkOrderID     => $WorkOrderID,
        ChangeID        => $Param{ChangeID},
        OldWorkOrderIDs => $OldIDs2NewIDs,
    );

    return %Info;
}

=begin Internal:

=item _GetTimeDifference()

If a new planned start/end time was given, the difference is needed
to move all time values

    my $DiffInSeconds = $TemplateObject->_GetTimeDifference(
        CurrentTime     => '2010-01-12 00:00:00',
        NewTimeInEpoche => 1234567890,
    );

=cut

sub _GetTimeDifference {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(CurrentTime NewTimeInEpoche)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # get current time as timestamp
    my $CurrentSystemTime = $Self->{TimeObject}->TimeStamp2SystemTime(
        String => $Param{CurrentTime},
    );

    my $DiffSeconds = $Param{NewTimeInEpoche} - $CurrentSystemTime;

    return $DiffSeconds;
}

=item _MoveTime()

This method returns the new value for a time column based on the
difference.

    my $TimeValue = $TemplateObject->_MoveTime(
        CurrentTime => '2010-01-12 00:00:00',
        Difference  => 135,                     # in seconds
    );

=cut

sub _MoveTime {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    # need to check for defined, because 0 is allowed for Difference
    for my $Argument (qw(CurrentTime Difference)) {
        if ( !defined $Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # get current time as timestamp
    my $CurrentSystemTime = $Self->{TimeObject}->TimeStamp2SystemTime(
        String => $Param{CurrentTime},
    );

    # get planned time as timestamp
    my $NewTime = $Self->{TimeObject}->SystemTime2TimeStamp(
        SystemTime => $CurrentSystemTime + $Param{Difference},
    );

    return $NewTime;
}

=item _AttachmentAdd()

Creates new attachments for a change or a workorder based on the given template.
It returns a hash of information (with just one key - "Success")

    my %Info = $TemplateObject->_AttachmentAdd(
        Data => {
            # ... Params for AttachmentAdd
        },
        ChangeID => 1,
        UserID   => 1,
    );

=cut

sub _AttachmentAdd {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(UserID ChangeID Data)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # build a lookup hash from new workorder id to old workorder id
    my %NewWorkOrderID2OldWorkOrderID = reverse %{ $Param{OldWorkOrderIDs} };

    my $OldWorkOrderID = $NewWorkOrderID2OldWorkOrderID{ $Param{WorkOrderID} };

    my $Attachment = $Self->{WorkOrderObject}->WorkOrderAttachmentGet(
        WorkOrderID => $OldWorkOrderID,
        Filename    => $Param{Data}->{Filename},
    );

    my $Success = $Self->{WorkOrderObject}->WorkOrderAttachmentAdd(
        %{$Attachment},
        ChangeID    => $Param{ChangeID},
        WorkOrderID => $Param{WorkOrderID},
        UserID      => $Param{UserID},
    );

    my %Info = (
        Success => $Success,
    );

    return %Info;
}

=item _LinkAdd()

Creates new links for a change or a workorder based on the given template. It
returns a hash of information (with just one key - "Success")

    my %Info = $TemplateObject->_LinkAdd(
        Data => {
            # ... Params for LinkAdd
        },
        ChangeID    => 1,
        WorkOrderID => 123, # optional
        UserID      => 1,
    );

=cut

sub _LinkAdd {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(UserID Data)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    my $SourceKey;

    if ( $Param{Data}->{SourceObject} eq 'ITSMChange' ) {
        $SourceKey = $Param{ChangeID};
    }
    elsif ( $Param{Data}->{SourceObject} eq 'ITSMWorkOrder' ) {
        $SourceKey = $Param{WorkOrderID};
    }

    if ( !$SourceKey ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need WorkOrderID or ChangeID!',
        );
        return;
    }

    my $Success = $Self->{LinkObject}->LinkAdd(
        %{ $Param{Data} },
        SourceKey => $SourceKey,
        UserID    => $Param{UserID},
    );

    my %Info = (
        Success => $Success,
    );

    return %Info;
}

1;

=end Internal:

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
