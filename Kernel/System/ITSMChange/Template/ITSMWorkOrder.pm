# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::ITSMChange::Template::ITSMWorkOrder;

use strict;
use warnings;

## nofilter(TidyAll::Plugin::OTRS::Perl::Dumper)
use Data::Dumper;

our @ObjectDependencies = (
    'Kernel::System::DateTime',
    'Kernel::System::ITSMChange::ITSMStateMachine',
    'Kernel::System::ITSMChange::ITSMWorkOrder',
    'Kernel::System::LinkObject',
    'Kernel::System::Log',
    'Kernel::System::Main',
    'Kernel::System::User',
);

=head1 NAME

Kernel::System::ITSMChange::Template::ITSMWorkOrder - all template functions for workorders

=head1 DESCRIPTION

All functions for work order templates in ITSMChangeManagement.

=head1 PUBLIC INTERFACE

=cut

=head2 new()

create an object

    use Kernel::System::ObjectManager;
    local $Kernel::OM = Kernel::System::ObjectManager->new();
    my $TemplateObject = $Kernel::OM->Get('Kernel::System::ITSMChange::Template::ITSMWorkOrder');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # set the debug flag
    $Self->{Debug} = $Param{Debug} || 0;

    return $Self;
}

=head2 Serialize()

Serialize a C<workorder>. This is done with Data::Dumper. It returns
a serialized string of the data structure. The C<workorder> actions
are "wrapped" within a hash reference...

    my $TemplateString = $TemplateObject->Serialize(
        WorkOrderID => 1,
        StateReset  => 1, # (optional) reset to default state
        UserID      => 1,
        Return      => 'HASH', # (optional) HASH|STRING default 'STRING'
    );

returns

    '{WorkOrderAdd => { ChangeID => 123, ... }}'

If parameter C<Return> is set to C<HASH>, the Perl data structure
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
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # set default value for 'Return'
    $Param{Return} ||= 'STRING';

    # get workorder
    my $WorkOrder = $Kernel::OM->Get('Kernel::System::ITSMChange::ITSMWorkOrder')->WorkOrderGet(
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
        my $NextStateIDs = $Kernel::OM->Get('Kernel::System::ITSMChange::ITSMStateMachine')->StateTransitionGet(
            StateID => 0,
            Class   => 'ITSM::ChangeManagement::WorkOrder::State',
        );
        $CleanWorkOrder->{WorkOrderStateID} = $NextStateIDs->[0];

        # reset actual start and end time
        $CleanWorkOrder->{ActualStartTime} = undef;
        $CleanWorkOrder->{ActualEndTime}   = undef;
    }

    # add workorder fields to list of wanted attribute
    ATTRIBUTE:
    for my $Attribute ( sort keys %{$WorkOrder} ) {

        # find the workorder dynamic field attributes
        if ( $Attribute =~ m{ \A DynamicField_.* \z }xms ) {

            $CleanWorkOrder->{$Attribute} = $WorkOrder->{$Attribute};
        }
    }

    # templates have to be an array reference;
    my $OriginalData = { WorkOrderAdd => $CleanWorkOrder };

    # get attachments
    my @WorkOrderAttachments = $Kernel::OM->Get('Kernel::System::ITSMChange::ITSMWorkOrder')->WorkOrderAttachmentList(
        WorkOrderID => $WorkOrder->{WorkOrderID},
    );

    for my $Filename (@WorkOrderAttachments) {

        # save attachments to this template
        push @{ $OriginalData->{Children} }, { AttachmentAdd => { Filename => $Filename } };
    }

    # get links to other object
    my $LinkListWithData = $Kernel::OM->Get('Kernel::System::LinkObject')->LinkListWithData(
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
    my $SerializedData = $Kernel::OM->Get('Kernel::System::Main')->Dump( $OriginalData, 'binary' );

    return $SerializedData;
}

=head2 DeSerialize()

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
            $Kernel::OM->Get('Kernel::System::Log')->Log(
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
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Invalid Methodname!',
        );
        return;
    }

    return $Self->$Sub(%Param);
}

=head2 _WorkOrderAdd()

Creates a new C<workorder> based on a template. It returns the
change id it was created for and the new C<workorder> id.

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
            $Kernel::OM->Get('Kernel::System::Log')->Log(
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
                        my $OldPlannedStartTimeInSeconds = $Kernel::OM->Create(
                            'Kernel::System::DateTime',
                            ObjectParams => {
                                String => $Data{PlannedStartTime},
                            },
                        )->ToEpoch();

                        # calculate the old planned end time into epoch seconds
                        my $OldPlannedEndTimeInSeconds = $Kernel::OM->Create(
                            'Kernel::System::DateTime',
                            ObjectParams => {
                                String => $Data{PlannedEndTime},
                            },
                        )->ToEpoch();

                        # the time length of the workorder in seconds
                        $WorkOrderLengthInSeconds = $OldPlannedEndTimeInSeconds - $OldPlannedStartTimeInSeconds;
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

    if ( $Data{WorkOrderAgentID} ) {

        # Check if the workorder agent is still valid, leave empty if not
        my %UserData = $Kernel::OM->Get('Kernel::System::User')->GetUserData(
            UserID => $Data{WorkOrderAgentID},
            Valid  => 1,
        );

        if ( !$UserData{UserID} ) {
            delete $Data{WorkOrderAgentID};
        }
    }

    # override the change id from the template
    my $WorkOrderID = $Kernel::OM->Get('Kernel::System::ITSMChange::ITSMWorkOrder')->WorkOrderAdd(
        %Data,
        NoNumberCalc => $Param{NoNumberCalc},
        ChangeID     => $Param{ChangeID},
        UserID       => $Param{UserID},
    );

    if ( !$WorkOrderID ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Could not create Workorder from Template!",
        );
        return;
    }

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

=head1 PRIVATE INTERFACE

=head2 _GetTimeDifference()

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
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # get current time as timestamp
    my $CurrentSystemTime = $Kernel::OM->Create(
        'Kernel::System::DateTime',
        ObjectParams => {
            String => $Param{CurrentTime},
        }
    )->ToEpoch();

    my $DiffSeconds = $Param{NewTimeInEpoche} - $CurrentSystemTime;

    return $DiffSeconds;
}

=head2 _MoveTime()

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
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # get current time as timestamp
    my $CurrentSystemTime = $Kernel::OM->Create(
        'Kernel::System::DateTime',
        ObjectParams => {
            String => $Param{CurrentTime},
        },
    )->ToEpoch();

    # get planned time as timestamp
    my $NewTime = $Kernel::OM->Create(
        'Kernel::System::DateTime',
        ObjectParams => {
            Epoch => $CurrentSystemTime + $Param{Difference},
        },
    )->ToString();

    return $NewTime;
}

=head2 _AttachmentAdd()

Creates new attachments for a change or a C<workorder> based on the given template.
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
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # build a lookup hash from new workorder id to old workorder id
    my %NewWorkOrderID2OldWorkOrderID = reverse %{ $Param{OldWorkOrderIDs} };

    my $OldWorkOrderID = $NewWorkOrderID2OldWorkOrderID{ $Param{WorkOrderID} };

    my $Attachment = $Kernel::OM->Get('Kernel::System::ITSMChange::ITSMWorkOrder')->WorkOrderAttachmentGet(
        WorkOrderID => $OldWorkOrderID,
        Filename    => $Param{Data}->{Filename},
    );

    my $Success = $Kernel::OM->Get('Kernel::System::ITSMChange::ITSMWorkOrder')->WorkOrderAttachmentAdd(
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

=head2 _LinkAdd()

Creates new links for a change or a C<workorder> based on the given template. It
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
            $Kernel::OM->Get('Kernel::System::Log')->Log(
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
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need WorkOrderID or ChangeID!',
        );
        return;
    }

    my $Success = $Kernel::OM->Get('Kernel::System::LinkObject')->LinkAdd(
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

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<https://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
