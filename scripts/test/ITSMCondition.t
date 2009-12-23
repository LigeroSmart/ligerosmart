# --
# ITSMCondition.t - Condition tests
# Copyright (C) 2003-2009 OTRS AG, http://otrs.com/
# --
# $Id: ITSMCondition.t,v 1.3 2009-12-23 10:44:32 mae Exp $
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

1;
