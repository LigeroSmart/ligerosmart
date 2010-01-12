# --
# ITSMCondition.t - Condition tests
# Copyright (C) 2003-2010 OTRS AG, http://otrs.com/
# --
# $Id: ITSMCondition.t,v 1.37 2010-01-12 11:53:23 ub Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use utf8;

use vars qw($Self);

use Data::Dumper;

use Kernel::System::ITSMChange;
use Kernel::System::ITSMChange::ITSMWorkOrder;
use Kernel::System::ITSMChange::ITSMCondition;

# ------------------------------------------------------------ #
# make preparations
# ------------------------------------------------------------ #

my $TestCount = 1;

# create common objects
$Self->{ChangeObject}    = Kernel::System::ITSMChange->new( %{$Self} );
$Self->{WorkOrderObject} = Kernel::System::ITSMChange::ITSMWorkOrder->new( %{$Self} );
$Self->{ConditionObject} = Kernel::System::ITSMChange::ITSMCondition->new( %{$Self} );

# test if change object was created successfully
$Self->True(
    $Self->{ChangeObject},
    'Test ' . $TestCount++ . ' - construction of change object',
);

# test if workorder object was created successfully
$Self->True(
    $Self->{WorkOrderObject},
    'Test ' . $TestCount++ . ' - construction of workorder object',
);

# test if condition object was created successfully
$Self->True(
    $Self->{ConditionObject},
    'Test ' . $TestCount++ . ' - construction of condition object',
);

# turn off notifications, in order to avoid a lot of useless mails
my $ChangeNotificationSettingsOrg;
{
    my $EventModule = $Self->{ConfigObject}->Get('ITSMChange::EventModule');
    $ChangeNotificationSettingsOrg = $EventModule->{'02-Notification'};
    $Self->{ConfigObject}->Set(
        Key => 'ITSMChange::EventModule###02-Notification',
    );
}

my $WorkOrderNotificationSettingsOrg;
{
    my $EventModule = $Self->{ConfigObject}->Get('ITSMWorkOrder::EventModule');
    $WorkOrderNotificationSettingsOrg = $EventModule->{'03-Notification'};
    $Self->{ConfigObject}->Set(
        Key => 'ITSMWorkOrder::EventModule###03-Notification',
    );
}

# ------------------------------------------------------------ #
# test Condition API
# ------------------------------------------------------------ #

# define public interface (in alphabetical order)
my @ObjectMethods = qw(
    AttributeAdd
    AttributeDelete
    AttributeGet
    AttributeList
    AttributeLookup
    AttributeUpdate
    ConditionAdd
    ConditionDelete
    ConditionGet
    ConditionList
    ConditionMatchExecute
    ConditionMatchExecuteAll
    ConditionUpdate
    ExpressionAdd
    ExpressionDelete
    ExpressionGet
    ExpressionList
    ExpressionMatch
    ExpressionUpdate
    ObjectAdd
    ObjectDelete
    ObjectGet
    ObjectList
    ObjectLookup
    ObjectUpdate
    OperatorAdd
    OperatorDelete
    OperatorExecute
    OperatorGet
    OperatorList
    OperatorLookup
    OperatorUpdate
);

# check if subs are available
for my $ObjectMethod (@ObjectMethods) {
    $Self->True(
        $Self->{ConditionObject}->can($ObjectMethod),
        'Test ' . $TestCount++ . " - check 'can $ObjectMethod'",
    );
}

#------------------------
# make some preparations
#------------------------

# create new change
my @ChangeIDs;
my @ChangeTitles;
CREATECHANGE:
for my $CreateChange ( 0 .. 9 ) {
    my $ChangeTitle = 'UnitTestChange' . $CreateChange;
    my $ChangeID    = $Self->{ChangeObject}->ChangeAdd(
        ChangeTitle => $ChangeTitle,
        UserID      => 1,
    );

    $Self->True(
        $ChangeID,
        'Test ' . $TestCount++ . " - ChangeAdd -> $ChangeID",
    );

    # do not store change id if add failed
    next CREATECHANGE if !$ChangeID;

    # store change id for further usage and deletion
    push @ChangeIDs,    $ChangeID;
    push @ChangeTitles, $ChangeTitle;
}

# create new workorders
my @WorkOrderIDs;
my @WorkOrderTitles;
CREATEWORKORDER:
for my $CreateWorkOrder ( 0 .. ( ( 3 * ( scalar @ChangeIDs ) ) - 1 ) ) {
    my $WorkOrderTitle = 'UnitTestWO' . $CreateWorkOrder;
    my $WorkOrderID    = $Self->{WorkOrderObject}->WorkOrderAdd(
        ChangeID => $ChangeIDs[ ( $CreateWorkOrder % scalar @ChangeIDs ) ],
        WorkOrderTitle => $WorkOrderTitle,
        UserID         => 1,
    );

    $Self->True(
        $WorkOrderID,
        'Test ' . $TestCount++ . ' - WorkOrderAdd (ChangeID: '
            . $ChangeIDs[ ( $CreateWorkOrder % scalar @ChangeIDs ) ] . ") -> $WorkOrderID",
    );

    # do not store workorder id if add failed
    next CREATEWORKORDER if !$WorkOrderID;

    # store workorder id for further usage and deletion
    push @WorkOrderIDs,    $WorkOrderID;
    push @WorkOrderTitles, $WorkOrderTitle;
}

#------------------------
# condition tests
#------------------------

# create new condition
my @ConditionIDs;
my %ConditionCount;
CHANGEID:
for my $ChangeID (@ChangeIDs) {

    # add some conditions to each change
    CONDITIONCOUNTER:
    for my $ConditionCounter ( 0 .. 5 ) {

        # build condition name
        my $ConditionName = "UnitTestConditionName_${ChangeID}_" . int rand 1_000_000;

        # add a condition
        my $ConditionID = $Self->{ConditionObject}->ConditionAdd(
            ChangeID              => $ChangeID,
            Name                  => $ConditionName,
            ExpressionConjunction => 'all',
            ValidID               => 1,
            UserID                => 1,
        );

        $Self->True(
            $ConditionID,
            'Test ' . $TestCount++ . " - ConditionAdd -> ConditionID: $ConditionID",
        );

        next CONDITIONCOUNTER if !$ConditionID;

        # remember change id for later tests
        $ConditionCount{$ChangeID}++;

        # get the added condition
        my $ConditionData = $Self->{ConditionObject}->ConditionGet(
            ConditionID => $ConditionID,
            UserID      => 1,
        );

        $Self->Is(
            $ConditionData->{ConditionID},
            $ConditionID,
            'Test ' . $TestCount++ . " - ConditionGet -> ConditionID: $ConditionID",
        );

        # remember all created conditions ids
        push @ConditionIDs, $ConditionID;

        # condition update tests
        my $Success = $Self->{ConditionObject}->ConditionUpdate(
            ConditionID           => $ConditionID,
            ExpressionConjunction => 'all',
            Comments              => 'An updated comment',
            UserID                => 1,
        );

        $Self->True(
            $Success,
            'Test ' . $TestCount++ . " - ConditionUpdate -> ConditionID: $ConditionID",
        );

        # get the updated condition
        $ConditionData = $Self->{ConditionObject}->ConditionGet(
            ConditionID => $ConditionID,
            UserID      => 1,
        );

        $Self->Is(
            $ConditionData->{Comments},
            'An updated comment',
            'Test ' . $TestCount++ . " - ConditionGet -> ConditionID: $ConditionID",
        );

        # try to add the same condition again (ChangeID and Name are the same) (must fail)
        $ConditionID = $Self->{ConditionObject}->ConditionAdd(
            ChangeID              => $ChangeID,
            Name                  => $ConditionName,
            ExpressionConjunction => 'all',
            ValidID               => 1,
            UserID                => 1,
        );

        $Self->False(
            $ConditionID,
            'Test ' . $TestCount++ . " - ConditionAdd",
        );

        # just in case if the condition could be added
        if ($ConditionID) {
            push @ConditionIDs, $ConditionID;
        }
    }
}

# condition list test
CHANGEID:
for my $ChangeID ( keys %ConditionCount ) {

    # get condition list
    my $ConditionIDsRef = $Self->{ConditionObject}->ConditionList(
        ChangeID => $ChangeID,
        Valid    => 1,
        UserID   => 1,
    );

    $Self->Is(
        scalar @{$ConditionIDsRef},
        $ConditionCount{$ChangeID},
        'Test ' . $TestCount++ . " - ConditionList -> Number of conditions for ChangeID: $ChangeID",
    );

    # if no conditions exist for this change
    next CHANGEID if !@{$ConditionIDsRef};

    # set the first condition of the current change invalid
    my $Success = $Self->{ConditionObject}->ConditionUpdate(
        ConditionID => $ConditionIDsRef->[0],
        ValidID     => 2,                       # invalid
        UserID      => 1,
    );

    $Self->True(
        $Success,
        'Test ' . $TestCount++ . " - ConditionUpdate -> ConditionID: $ConditionIDsRef->[0]",
    );

    # get condition list again
    $ConditionIDsRef = $Self->{ConditionObject}->ConditionList(
        ChangeID => $ChangeID,
        Valid    => 1,
        UserID   => 1,
    );

    $Self->Is(
        scalar @{$ConditionIDsRef},
        $ConditionCount{$ChangeID} - 1,
        'Test ' . $TestCount++ . " - ConditionList -> Number of conditions for ChangeID: $ChangeID",
    );

    # get condition list again, but now with also the invalid conditions
    $ConditionIDsRef = $Self->{ConditionObject}->ConditionList(
        ChangeID => $ChangeID,
        Valid    => 0,
        UserID   => 1,
    );

    $Self->Is(
        scalar @{$ConditionIDsRef},
        $ConditionCount{$ChangeID},
        'Test ' . $TestCount++ . " - ConditionList -> Number of conditions for ChangeID: $ChangeID",
    );

}

#------------------------
# condition object tests
#------------------------

# check for default condition objects
my @ConditionObjects = qw(ITSMChange ITSMWorkOrder);

# check condition objects
for my $ConditionObject (@ConditionObjects) {

    # make lookup to get object id
    my $ObjectID = $Self->{ConditionObject}->ObjectLookup(
        Name   => $ConditionObject,
        UserID => 1,
    ) || '';

    # check on return value
    $Self->True(
        $ObjectID,
        'Test ' . $TestCount++ . " - ObjectLookup on '$ConditionObject' -> ObjectID: $ObjectID",
    );

    # get object data with object id
    my $ObjectData = $Self->{ConditionObject}->ObjectGet(
        ObjectID => $ObjectID,
        UserID   => 1,
    );

    # check return parameters
    $Self->Is(
        $ObjectData->{Name},
        $ConditionObject,
        'Test ' . $TestCount++ . ' - ObjectGet() name check',
    );
}

# check for object add
my @ConditionObjectCreated;
for my $Counter ( 1 .. 3 ) {

    # add new objects
    my $ObjectID = $Self->{ConditionObject}->ObjectAdd(
        Name   => 'ObjectName' . $Counter . int rand 1_000_000,
        UserID => 1,
    );

    # check on return value
    $Self->True(
        $ObjectID,
        'Test ' . $TestCount++ . " - ObjectAdd -> ObjectID: $ObjectID",
    );

    # save object id for delete test
    push @ConditionObjectCreated, $ObjectID;
}

# check condition object list
my $ObjectList = $Self->{ConditionObject}->ObjectList(
    UserID => 1,
);

# check for object list
$Self->True(
    $ObjectList,
    'Test ' . $TestCount++ . " - ObjectList is not empty",
);

# check for object list as array ref
$Self->Is(
    ref $ObjectList,
    'ARRAY',
    'Test ' . $TestCount++ . " - ObjectList type",
);

# check update of condition object
my $ConditionObjectNewName = 'UnitTestUpdate' . int rand 1_000_000;
$Self->True(
    $Self->{ConditionObject}->ObjectUpdate(
        ObjectID => $ConditionObjectCreated[0],
        Name     => $ConditionObjectNewName,
        UserID   => 1,
    ),
    'Test ' . $TestCount++ . " - ObjectUpdate",
);
my $ConditionObjectUpdate = $Self->{ConditionObject}->ObjectGet(
    ObjectID => $ConditionObjectCreated[0],
    UserID   => 1,
);
$Self->Is(
    $ConditionObjectUpdate->{Name},
    $ConditionObjectNewName,
    'Test ' . $TestCount++ . " - ObjectUpdate verify update",
);

# check for object delete
for my $ObjectID (@ConditionObjectCreated) {
    $Self->True(
        $Self->{ConditionObject}->ObjectDelete(
            ObjectID => $ObjectID,
            UserID   => 1,
        ),
        'Test ' . $TestCount++ . " - ObjectDelete -> ObjectID: $ObjectID",
    );
}

#----------------------------
# condition attributes tests
#----------------------------

# check for default condition attributes
my @ConditionAttributes = qw(
    ChangeTitle      CategoryID      ImpactID PriorityID PlannedEffort    AccountedTime
    ChangeManagerID  ChangeBuilderID WorkOrderAgentID
    WorkOrderTitle   WorkOrderID     WorkOrderNumber     WorkOrderStateID WorkOrderTypeID
    PlannedStartTime PlannedEndTime  ActualStartTime     ActualEndTime
);

# check condition attributes
for my $ConditionAttribute (@ConditionAttributes) {

    # make lookup to get attribute id
    my $AttributeID = $Self->{ConditionObject}->AttributeLookup(
        UserID => 1,
        Name   => $ConditionAttribute,
    ) || '';

    # check on return value
    $Self->True(
        $AttributeID,
        'Test '
            . $TestCount++
            . " - AttributeLookup on '$ConditionAttribute' -> AttributeID: $AttributeID'",
    );

    # get attribute data with attribute id
    my $AttributeData = $Self->{ConditionObject}->AttributeGet(
        UserID      => 1,
        AttributeID => $AttributeID,
    );

    # check return parameters
    $Self->Is(
        $AttributeData->{Name},
        $ConditionAttribute,
        'Test ' . $TestCount++ . ' - AttributeGet() name check',
    );
}

# check for object add
my @ConditionAttributeCreated;
for my $Counter ( 1 .. 3 ) {

    # add new objects
    my $AttributeID = $Self->{ConditionObject}->AttributeAdd(
        UserID => 1,
        Name   => 'AttributeName' . $Counter . int rand 1_000_000,
    );

    # check on return value
    $Self->True(
        $AttributeID,
        'Test ' . $TestCount++ . " - AttributeAdd -> AttributeID: $AttributeID",
    );

    # save object it for delete test
    push @ConditionAttributeCreated, $AttributeID;
}

# check condition attribute list
my $AttributeList = $Self->{ConditionObject}->AttributeList(
    UserID => 1,
);

# check for attribute list
$Self->True(
    $AttributeList,
    'Test ' . $TestCount++ . " - AttributeList is not empty",
);

# check for attribute list as array ref
$Self->Is(
    ref $AttributeList,
    'ARRAY',
    'Test ' . $TestCount++ . " - AttributeList type",
);

# check update of attribute object
my $ConditionAttributeNewName = 'UnitTestUpdate' . int rand 1_000_000;
$Self->True(
    $Self->{ConditionObject}->AttributeUpdate(
        UserID      => 1,
        AttributeID => $ConditionAttributeCreated[0],
        Name        => $ConditionAttributeNewName,
    ),
    'Test ' . $TestCount++ . " - AttributeUpdate",
);
my $ConditionAttributeUpdate = $Self->{ConditionObject}->AttributeGet(
    UserID      => 1,
    AttributeID => $ConditionAttributeCreated[0],
);
$Self->Is(
    $ConditionAttributeUpdate->{Name},
    $ConditionAttributeNewName,
    'Test ' . $TestCount++ . " - AttributeUpdate verify update",
);

# check for attribute delete
for my $AttributeID (@ConditionAttributeCreated) {
    $Self->True(
        $Self->{ConditionObject}->AttributeDelete(
            UserID      => 1,
            AttributeID => $AttributeID,
        ),
        'Test ' . $TestCount++ . " - AttributeDelete -> AttributeID: $AttributeID",
    );
}

#-------------------------
# condition operator tests
#-------------------------

# check for default condition operators
my @ConditionOperators = (

    # common matching
    'is', 'is not', 'is empty', 'is not empty',

    # digit matching
    'is greater than', 'is less than',

    # date matching
    'is before', 'is after',

    # string matching
    'contains', 'begins with', 'ends with',

    # action operator
    'set', 'lock',
);

# check condition operators
for my $ConditionOperator (@ConditionOperators) {

    # make lookup to get operator id
    my $OperatorID = $Self->{ConditionObject}->OperatorLookup(
        UserID => 1,
        Name   => $ConditionOperator,
    ) || '';

    # check on return value
    $Self->True(
        $OperatorID,
        'Test '
            . $TestCount++
            . " - OperatorLookup on '$ConditionOperator' -> OperatorID: $OperatorID",
    );

    # get operator data with operator id
    my $OperatorData = $Self->{ConditionObject}->OperatorGet(
        UserID     => 1,
        OperatorID => $OperatorID,
    );

    # check return parameters
    $Self->Is(
        $OperatorData->{Name},
        $ConditionOperator,
        'Test ' . $TestCount++ . ' - OperatorGet() name check',
    );
}

# check for object add
my @ConditionOperatorCreated;
for my $Counter ( 1 .. 3 ) {

    # add new objects
    my $OperatorID = $Self->{ConditionObject}->OperatorAdd(
        UserID => 1,
        Name   => 'OperatorName' . $Counter . int rand 1_000_000,
    );

    # check on return value
    $Self->True(
        $OperatorID,
        'Test ' . $TestCount++ . " - OperatorAdd -> OperatorID: $OperatorID",
    );

    # save object it for delete test
    push @ConditionOperatorCreated, $OperatorID;
}

# check condition operator list
my $OperatorList = $Self->{ConditionObject}->OperatorList(
    UserID => 1,
);

# check for operator list
$Self->True(
    $OperatorList,
    'Test ' . $TestCount++ . " - OperatorList is not empty",
);

# check for operator list as array ref
$Self->Is(
    ref $OperatorList,
    'ARRAY',
    'Test ' . $TestCount++ . " - OperatorList type",
);

# check update of operator object
my $ConditionOperatorNewName = 'UnitTestUpdate' . int rand 1_000_000;
$Self->True(
    $Self->{ConditionObject}->OperatorUpdate(
        UserID     => 1,
        OperatorID => $ConditionOperatorCreated[0],
        Name       => $ConditionOperatorNewName,
    ),
    'Test ' . $TestCount++ . " - OperatorUpdate",
);
my $ConditionOperatorUpdate = $Self->{ConditionObject}->OperatorGet(
    UserID     => 1,
    OperatorID => $ConditionOperatorCreated[0],
);
$Self->Is(
    $ConditionOperatorUpdate->{Name},
    $ConditionOperatorNewName,
    'Test ' . $TestCount++ . " - OperatorUpdate verify update",
);

# check for operator delete
for my $OperatorID (@ConditionOperatorCreated) {
    $Self->True(
        $Self->{ConditionObject}->OperatorDelete(
            UserID     => 1,
            OperatorID => $OperatorID,
        ),
        'Test ' . $TestCount++ . " - OperatorDelete -> OperatorID: $OperatorID",
    );
}

#-------------------------
# condition expression tests
#-------------------------

# check for default condition expressions
my @ExpressionTests = (
    {
        MatchSuccess => 0,
        SourceData   => {
            ExpressionAdd => {
                ObjectID => {
                    ObjectLookup => {
                        Name   => 'ITSMChange',
                        UserID => 1,
                    },
                },
                AttributeID => {
                    AttributeLookup => {
                        Name   => 'ChangeTitle',
                        UserID => 1,
                    },
                },
                OperatorID => {
                    OperatorLookup => {
                        Name   => 'is',
                        UserID => 1,
                    },
                },

                # static fields
                ConditionID  => $ConditionIDs[0],
                Selector     => $ChangeIDs[0],
                CompareValue => 'DummyCompareValue1',
                UserID       => 1,
            },
        },
    },
    {
        SourceData => {
            ExpressionAdd => {
                ObjectID => {
                    ObjectLookup => {
                        Name   => 'ITSMChange',
                        UserID => 1,
                    },
                },
                AttributeID => {
                    AttributeLookup => {
                        Name   => 'ChangeManagerID',
                        UserID => 1,
                    },
                },
                OperatorID => {
                    OperatorLookup => {
                        Name   => 'is',
                        UserID => 1,
                    },
                },

                # static fields
                ConditionID  => $ConditionIDs[0],
                Selector     => $ChangeIDs[0],
                CompareValue => 'DummyCompareValue1',
                UserID       => 1,
            },
        },
    },
    {
        SourceData => {
            ExpressionAdd => {
                ObjectID => {
                    ObjectLookup => {
                        Name   => 'ITSMWorkOrder',
                        UserID => 1,
                    },
                },
                AttributeID => {
                    AttributeLookup => {
                        Name   => 'WorkOrderTitle',
                        UserID => 1,
                    },
                },
                OperatorID => {
                    OperatorLookup => {
                        Name   => 'is not',
                        UserID => 1,
                    },
                },

                # static fields
                ConditionID  => $ConditionIDs[1],
                Selector     => $WorkOrderIDs[1],
                CompareValue => 'DummyCompareValue2',
                UserID       => 1,
            },
            ExpressionUpdate => {
                ObjectID => {
                    ObjectLookup => {
                        Name   => 'ITSMChange',
                        UserID => 1,
                    },
                },
                AttributeID => {
                    AttributeLookup => {
                        Name   => 'ChangeTitle',
                        UserID => 1,
                    },
                },
                OperatorID => {
                    OperatorLookup => {
                        Name   => 'is',
                        UserID => 1,
                    },
                },

                # static fields
                Selector     => $ChangeIDs[0],
                CompareValue => 'NewDummyCompareValue' . int rand 1_000_000,
                UserID       => 1,
            },
        },
    },
    {
        MatchSuccess => 1,
        SourceData   => {
            ExpressionAdd => {
                ObjectID => {
                    ObjectLookup => {
                        Name   => 'ITSMWorkOrder',
                        UserID => 1,
                    },
                },
                AttributeID => {
                    AttributeLookup => {
                        Name   => 'WorkOrderTitle',
                        UserID => 1,
                    },
                },
                OperatorID => {
                    OperatorLookup => {
                        Name   => 'is not',
                        UserID => 1,
                    },
                },

                # static fields
                ConditionID  => $ConditionIDs[0],
                Selector     => $WorkOrderIDs[1],
                CompareValue => $WorkOrderTitles[0],
                UserID       => 1,
            },
            ExpressionUpdate => {
                UserID => 1,
            },
        },
    },
    {
        SourceData => {
            ExpressionAdd => {
                ObjectID => {
                    ObjectLookup => {
                        Name   => 'ITSMChange',
                        UserID => 1,
                    },
                },
                AttributeID => {
                    AttributeLookup => {
                        Name   => 'PlannedStartTime',
                        UserID => 1,
                    },
                },
                OperatorID => {
                    OperatorLookup => {
                        Name   => 'is greater than',
                        UserID => 1,
                    },
                },

                # static fields
                ConditionID  => $ConditionIDs[1],
                Selector     => $ChangeIDs[0],
                CompareValue => 'DummyCompareValue2',
                UserID       => 1,
            },
            ExpressionUpdate => {
                ObjectID => {
                    ObjectLookup => {
                        Name   => 'ITSMWorkOrder',
                        UserID => 1,
                    },
                },

                # static fields
                Selector => $WorkOrderIDs[1],
                UserID   => 1,
            },
        },
    },
    {
        MatchSuccess => 1,
        SourceData   => {
            ExpressionAdd => {
                ObjectID => {
                    ObjectLookup => {
                        Name   => 'ITSMChange',
                        UserID => 1,
                    },
                },
                AttributeID => {
                    AttributeLookup => {
                        Name   => 'ChangeTitle',
                        UserID => 1,
                    },
                },
                OperatorID => {
                    OperatorLookup => {
                        Name   => 'is',
                        UserID => 1,
                    },
                },

                # static fields
                ConditionID  => $ConditionIDs[0],
                Selector     => $ChangeIDs[0],
                CompareValue => $ChangeTitles[0],
                UserID       => 1,
            },
        },
    },
    {
        MatchSuccess => 0,
        SourceData   => {
            ExpressionAdd => {
                ObjectID => {
                    ObjectLookup => {
                        Name   => 'ITSMChange',
                        UserID => 1,
                    },
                },
                AttributeID => {
                    AttributeLookup => {
                        Name   => 'ChangeTitle',
                        UserID => 1,
                    },
                },
                OperatorID => {
                    OperatorLookup => {
                        Name   => 'is not',
                        UserID => 1,
                    },
                },

                # static fields
                ConditionID  => $ConditionIDs[0],
                Selector     => $ChangeIDs[0],
                CompareValue => $ChangeTitles[0],
                UserID       => 1,
            },
        },
    },
    {
        MatchSuccess => 1,
        SourceData   => {
            ExpressionAdd => {
                ObjectID => {
                    ObjectLookup => {
                        Name   => 'ITSMChange',
                        UserID => 1,
                    },
                },
                AttributeID => {
                    AttributeLookup => {
                        Name   => 'ChangeTitle',
                        UserID => 1,
                    },
                },
                OperatorID => {
                    OperatorLookup => {
                        Name   => 'is not',
                        UserID => 1,
                    },
                },

                # static fields
                ConditionID  => $ConditionIDs[0],
                Selector     => $ChangeIDs[0],
                CompareValue => $ChangeTitles[0] . int rand 1_000_000,
                UserID       => 1,
            },
        },
    },
    {
        MatchSuccess => 1,
        SourceData   => {
            ExpressionAdd => {
                ObjectID => {
                    ObjectLookup => {
                        Name   => 'ITSMWorkOrder',
                        UserID => 1,
                    },
                },
                AttributeID => {
                    AttributeLookup => {
                        Name   => 'WorkOrderTitle',
                        UserID => 1,
                    },
                },
                OperatorID => {
                    OperatorLookup => {
                        Name   => 'is',
                        UserID => 1,
                    },
                },

                # static fields
                ConditionID  => $ConditionIDs[0],
                Selector     => $WorkOrderIDs[0],
                CompareValue => $WorkOrderTitles[0],
                UserID       => 1,
            },
        },
    },
    {
        MatchSuccess => 0,
        SourceData   => {
            ExpressionAdd => {
                ObjectID => {
                    ObjectLookup => {
                        Name   => 'ITSMWorkOrder',
                        UserID => 1,
                    },
                },
                AttributeID => {
                    AttributeLookup => {
                        Name   => 'WorkOrderTitle',
                        UserID => 1,
                    },
                },
                OperatorID => {
                    OperatorLookup => {
                        Name   => 'is',
                        UserID => 1,
                    },
                },

                # static fields
                ConditionID  => $ConditionIDs[2],
                Selector     => 'all',
                CompareValue => $WorkOrderTitles[8],
                UserID       => 1,
            },
        },
    },
    {
        MatchSuccess => 1,
        SourceData   => {
            ExpressionAdd => {
                ObjectID => {
                    ObjectLookup => {
                        Name   => 'ITSMWorkOrder',
                        UserID => 1,
                    },
                },
                AttributeID => {
                    AttributeLookup => {
                        Name   => 'WorkOrderTitle',
                        UserID => 1,
                    },
                },
                OperatorID => {
                    OperatorLookup => {
                        Name   => 'is',
                        UserID => 1,
                    },
                },

                # static fields
                ConditionID  => $ConditionIDs[2],
                Selector     => 'any',
                CompareValue => $WorkOrderTitles[0],
                UserID       => 1,
            },
        },
    },
);

# check condition expressions
my @ExpressionIDs;
EXPRESSIONTEST:
for my $ExpressionTest (@ExpressionTests) {

    # store data of test cases locally
    my %SourceData;
    my $ExpressionID;
    my %ExpressionAddSourceData;
    my %ExpressionAddData;

    # extract source data
    if ( $ExpressionTest->{SourceData} ) {
        %SourceData = %{ $ExpressionTest->{SourceData} };
    }

    next EXPRESSIONTEST if !%SourceData;

    CREATEDATA:
    for my $CreateData ( keys %SourceData ) {

        # add expression
        if ( $CreateData eq 'ExpressionAdd' ) {

            # extract ExpressionAdd data
            %ExpressionAddSourceData = %{ $SourceData{$CreateData} };

            # set static fields
            my @StaticFields = qw( Selector CompareValue UserID ConditionID );

            STATICFIELD:
            for my $StaticField (@StaticFields) {

                # ommit static field if it is not set
                next STATICFIELD if !$ExpressionAddSourceData{$StaticField};

                # safe data
                $ExpressionAddData{$StaticField} = $ExpressionAddSourceData{$StaticField};
            }

            # get all fields for ExpressionAdd
            for my $ExpressionAddValue ( keys %ExpressionAddSourceData ) {

                # ommit static fields
                next if grep { $_ eq $ExpressionAddValue } @StaticFields;

                # get values for fields
                for my $FieldValue ( keys %{ $ExpressionAddSourceData{$ExpressionAddValue} } ) {

                    # store gathered information in hash for adding
                    $ExpressionAddData{$ExpressionAddValue} =
                        $Self->{ConditionObject}->$FieldValue(
                        %{ $ExpressionAddSourceData{$ExpressionAddValue}->{$FieldValue} },
                        );
                }
            }

            # add expression
            $ExpressionID = $Self->{ConditionObject}->ExpressionAdd(
                %ExpressionAddData,
            );

            $Self->True(
                $ExpressionID,
                'Test ' . $TestCount++ . " - $CreateData -> $ExpressionID",
            );

            next CREATEDATA if !$ExpressionID;

            # save created ID for deleting expressions
            push @ExpressionIDs, $ExpressionID;

            # check the added expression
            my $ExpressionGetData = $Self->{ConditionObject}->ExpressionGet(
                ExpressionID => $ExpressionID,
                UserID       => $ExpressionAddData{UserID},
            );
            $Self->True(
                $ExpressionGetData,
                'Test ' . $TestCount++ . ' - ExpressionAdd(): ExpressionGet',
            );

            # test values
            delete $ExpressionAddData{UserID};
            for my $TestValue ( keys %ExpressionAddData ) {
                $Self->Is(
                    $ExpressionGetData->{$TestValue},
                    $ExpressionAddData{$TestValue},
                    'Test ' . $TestCount++ . " - ExpressionAdd(): ExpressionGet -> $TestValue",
                );
            }
        }    # end if ( $CreateData eq 'ExpressionAdd' )

        # update expression
        if ( $CreateData eq 'ExpressionUpdate' ) {

            # extract ExpressionUpdate data
            my %ExpressionUpdateSourceData = %{ $SourceData{$CreateData} };
            my %ExpressionUpdateData;

            # set static fields
            my @StaticFields = qw( Selector CompareValue UserID ConditionID );

            STATICFIELD:
            for my $StaticField (@StaticFields) {

                # ommit static field if it is not set
                next STATICFIELD if !$ExpressionUpdateSourceData{$StaticField};

                # safe data
                $ExpressionUpdateData{$StaticField} = $ExpressionUpdateSourceData{$StaticField};
            }

            # get all fields for ExpressionUpdate
            for my $ExpressionUpdateValue ( keys %ExpressionUpdateSourceData ) {

                # ommit static fields
                next if grep { $_ eq $ExpressionUpdateValue } @StaticFields;

                # get values for fields
                for my $FieldValue ( keys %{ $ExpressionUpdateSourceData{$ExpressionUpdateValue} } )
                {

                    # store gathered information in hash for updating
                    $ExpressionUpdateData{$ExpressionUpdateValue} =
                        $Self->{ConditionObject}->$FieldValue(
                        %{ $ExpressionUpdateSourceData{$ExpressionUpdateValue}->{$FieldValue} },
                        );
                }
            }

            # update expression
            my $UpdateSuccess = $Self->{ConditionObject}->ExpressionUpdate(
                ExpressionID => $ExpressionID,
                %ExpressionUpdateData,
            );

            $Self->True(
                $UpdateSuccess,
                'Test ' . $TestCount++ . " - $CreateData",
            );

            next CREATEDATA if !$UpdateSuccess;

            # check the added expression
            my $ExpressionGetData = $Self->{ConditionObject}->ExpressionGet(
                ExpressionID => $ExpressionID,
                UserID       => $ExpressionUpdateData{UserID},
            );
            $Self->True(
                $ExpressionGetData,
                'Test ' . $TestCount++ . ' - ExpressionUpdate(): ExpressionGet',
            );

            # merge add and update data
            %ExpressionUpdateData = ( %ExpressionAddData, %ExpressionUpdateData );

            # test values
            delete $ExpressionUpdateData{UserID};
            for my $TestValue ( keys %ExpressionUpdateData ) {
                $Self->Is(
                    $ExpressionGetData->{$TestValue},
                    $ExpressionUpdateData{$TestValue},
                    'Test ' . $TestCount++ . " - ExpressionUpdate(): ExpressionGet -> $TestValue",
                );
            }
        }    # end if ( $CreateData eq 'ExpressionUpdate' )
    }
}

# check for expression list
CONDITIONID:
for my $ConditionID (@ConditionIDs) {

    # check for expressions of this condition id
    my $ExpressionTestCount = 0;
    EXPRESSIONTEST:
    for my $ExpressionTest (@ExpressionTests) {

        # ommit test case if no source data is available
        next EXPRESSIONTEST if !$ExpressionTest->{SourceData};

        # ommit test case if no expression shoul be added
        next EXPRESSIONTEST if !$ExpressionTest->{SourceData}->{ExpressionAdd};

        $ExpressionTestCount++
            if $ExpressionTest->{SourceData}->{ExpressionAdd}->{ConditionID} == $ConditionID;
    }

    my $ExpressionList = $Self->{ConditionObject}->ExpressionList(
        ConditionID => $ConditionID,
        UserID      => 1,
    );

    $Self->Is(
        ref $ExpressionList,
        'ARRAY',
        'Test ' . $TestCount++ . ' - ExpressionList return value',
    );

    # check for list type
    next CONDITIONID if ref $ExpressionList ne 'ARRAY';

    $Self->Is(
        scalar @{$ExpressionList},
        $ExpressionTestCount,
        'Test ' . $TestCount++ . " - ExpressionList -> $ConditionID",
    );
}

# test for matching
for my $ExpressionCounter ( 0 .. ( scalar @ExpressionIDs - 1 ) ) {
    my $ExpressionMatch = $Self->{ConditionObject}->ExpressionMatch(
        ExpressionID => $ExpressionIDs[$ExpressionCounter],
        UserID       => 1,
    );

    if ( $ExpressionTests[$ExpressionCounter]->{MatchSuccess} ) {
        $Self->True(
            $ExpressionMatch,
            'Test '
                . $TestCount++
                . " - ExpressionMatch return true -> ExpressionID: $ExpressionIDs[$ExpressionCounter]",
        );
    }
    else {
        $Self->False(
            $ExpressionMatch,
            'Test '
                . $TestCount++
                . " - ExpressionMatch return false -> ExpressionID: $ExpressionIDs[$ExpressionCounter]",
        );
    }
}

# check for expression delete
for my $ExpressionID (@ExpressionIDs) {
    $Self->True(
        $Self->{ConditionObject}->ExpressionDelete(
            UserID       => 1,
            ExpressionID => $ExpressionID,
        ),
        'Test ' . $TestCount++ . " - ExpressionDelete -> ExpressionID: $ExpressionID",
    );
}

# delete created conditions
for my $ConditionID (@ConditionIDs) {

    my $DeleteSuccess = $Self->{ConditionObject}->ConditionDelete(
        ConditionID => $ConditionID,
        UserID      => 1,
    );

    $Self->True(
        $DeleteSuccess,
        'Test ' . $TestCount++ . " - ConditionDelete -> ConditionID: $ConditionID",
    );

}

# delete created changes
for my $ChangeID (@ChangeIDs) {
    $Self->True(
        $Self->{ChangeObject}->ChangeDelete(
            ChangeID => $ChangeID,
            UserID   => 1,
        ),
        'Test ' . $TestCount++ . " - ChangeDelete -> ChangeID: $ChangeID",
    );
}

# set change notifications to their original value
if ($ChangeNotificationSettingsOrg) {
    $Self->{ConfigObject}->Set(
        Key   => 'ITSMChange::EventModule###02-Notification',
        Value => $ChangeNotificationSettingsOrg,
    );
}

# set workorder notifications to their original value
if ($WorkOrderNotificationSettingsOrg) {
    $Self->{ConfigObject}->Set(
        Key   => 'ITSMWorkOrder::EventModule###03-Notification',
        Value => $WorkOrderNotificationSettingsOrg,
    );
}

1;
