# --
# ITSMCondition.t - Condition tests
# Copyright (C) 2003-2009 OTRS AG, http://otrs.com/
# --
# $Id: ITSMCondition.t,v 1.4 2009-12-23 14:14:08 mae Exp $
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
    ConditionAdd
    ConditionDelete
    ConditionGet
    ConditionList
    ConditionUpdate
    AttributeAdd
    AttributeDelete
    AttributeGet
    AttributeList
    AttributeLookup
    AttributeUpdate
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
my @ConditionObjects = qw(Change Workorder ChangeStateLock WorkorderStateLock);

# check condition objects
for my $ConditionObject (@ConditionObjects) {

    # make lookup to get object id
    my $ObjectID = $Self->{ConditionObject}->ObjectLookup(
        UserID => 1,
        Name   => $ConditionObject,
    );

    # check on return value
    $Self->True(
        $ObjectID,
        'Test ' . $TestCount++ . " - ObjectLookup on '$ConditionObject' -> '$ObjectID'",
    );

    # get object data with object id
    my $ObjectData = $Self->{ConditionObject}->ObjectGet(
        UserID   => 1,
        ObjectID => $ObjectID,
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
        UserID => 1,
        Name   => 'ObjectName' . $Counter . int rand 1_000_000,
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

# check for object delete
for my $ObjectID (@ConditionObjectCreated) {
    $Self->True(
        $Self->{ConditionObject}->ObjectDelete(
            UserID   => 1,
            ObjectID => $ObjectID,
        ),
        'Test ' . $TestCount++ . " - ObjectDelete -> '$ObjectID'",
    );
}

1;
