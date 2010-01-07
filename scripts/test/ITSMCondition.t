# --
# ITSMCondition.t - Condition tests
# Copyright (C) 2003-2010 OTRS AG, http://otrs.com/
# --
# $Id: ITSMCondition.t,v 1.12 2010-01-07 09:33:00 mae Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use utf8;

use vars qw($Self);

use Kernel::System::ITSMChange::ITSMCondition;

# ------------------------------------------------------------ #
# make preparations
# ------------------------------------------------------------ #

my $TestCount = 1;

# create common objects
$Self->{ConditionObject} = Kernel::System::ITSMChange::ITSMCondition->new( %{$Self} );

# test if statemachine object was created successfully
$Self->True(
    $Self->{ConditionObject},
    'Test ' . $TestCount++ . ' - construction of condition object',
);

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
    ConditionUpdate
    ObjectAdd
    ObjectDelete
    ObjectGet
    ObjectList
    ObjectLookup
    ObjectUpdate
    OperatorAdd
    OperatorDelete
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
# condition object tests
#------------------------

# check for default condition objects
my @ConditionObjects = qw(ITSMChange ITSMWorkOrder ChangeStateLock WorkOrderStateLock);

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
        'Test ' . $TestCount++ . " - ObjectLookup on '$ConditionObject' -> '$ObjectID'",
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
        'Test ' . $TestCount++ . " - ObjectAdd -> '$ObjectID'",
    );

    # save object it for delete test
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
    'ARRAY',
    ref $ObjectList,
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
    $ConditionObjectNewName,
    $ConditionObjectUpdate->{Name},
    'Test ' . $TestCount++ . " - ObjectUpdate verify update",
);

# check for object delete
for my $ObjectID (@ConditionObjectCreated) {
    $Self->True(
        $Self->{ConditionObject}->ObjectDelete(
            ObjectID => $ObjectID,
            UserID   => 1,
        ),
        'Test ' . $TestCount++ . " - ObjectDelete -> '$ObjectID'",
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
        'Test ' . $TestCount++ . " - AttributeLookup on '$ConditionAttribute' -> '$AttributeID'",
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
        'Test ' . $TestCount++ . " - AttributeAdd -> '$AttributeID'",
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
    'ARRAY',
    ref $AttributeList,
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
    $ConditionAttributeNewName,
    $ConditionAttributeUpdate->{Name},
    'Test ' . $TestCount++ . " - AttributeUpdate verify update",
);

# check for attribute delete
for my $AttributeID (@ConditionAttributeCreated) {
    $Self->True(
        $Self->{ConditionObject}->AttributeDelete(
            UserID      => 1,
            AttributeID => $AttributeID,
        ),
        'Test ' . $TestCount++ . " - AttributeDelete -> '$AttributeID'",
    );
}

#-------------------------
# condition operator tests
#-------------------------

# check for default condition operators
my @ConditionOperators = (

    # commong matching
    'is', 'is not',

    # digit matching
    'is greater than', 'is less than',

    # date matching
    'is before', 'is after',

    # string matching
    'contains', 'begins with', 'ends with',
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
        'Test ' . $TestCount++ . " - OperatorLookup on '$ConditionOperator' -> '$OperatorID'",
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
        'Test ' . $TestCount++ . " - OperatorAdd -> '$OperatorID'",
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
    'ARRAY',
    ref $OperatorList,
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
    $ConditionOperatorNewName,
    $ConditionOperatorUpdate->{Name},
    'Test ' . $TestCount++ . " - OperatorUpdate verify update",
);

# check for operator delete
for my $OperatorID (@ConditionOperatorCreated) {
    $Self->True(
        $Self->{ConditionObject}->OperatorDelete(
            UserID     => 1,
            OperatorID => $OperatorID,
        ),
        'Test ' . $TestCount++ . " - OperatorDelete -> '$OperatorID'",
    );
}

1;
