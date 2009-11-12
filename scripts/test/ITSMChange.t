# --
# ITSMChange.t - change tests
# Copyright (C) 2003-2009 OTRS AG, http://otrs.com/
# --
# $Id: ITSMChange.t,v 1.120 2009-11-12 14:34:43 bes Exp $
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
use Kernel::System::User;
use Kernel::System::Group;
use Kernel::System::CustomerUser;
use Kernel::System::GeneralCatalog;
use Kernel::System::ITSMChange;
use Kernel::System::ITSMChange::ITSMWorkOrder;

# ------------------------------------------------------------ #
# make preparations
# ------------------------------------------------------------ #
my $TestCount = 1;

# create common objects
$Self->{GeneralCatalogObject} = Kernel::System::GeneralCatalog->new( %{$Self} );
$Self->{UserObject}           = Kernel::System::User->new( %{$Self} );
$Self->{GroupObject}          = Kernel::System::Group->new( %{$Self} );
$Self->{CustomerUserObject}   = Kernel::System::CustomerUser->new( %{$Self} );
$Self->{ChangeObject}         = Kernel::System::ITSMChange->new( %{$Self} );
$Self->{WorkOrderObject}      = Kernel::System::ITSMChange::ITSMWorkOrder->new( %{$Self} );
$Self->{ValidObject}          = Kernel::System::Valid->new( %{$Self} );

# test if change object was created successfully
$Self->True(
    $Self->{ChangeObject},
    "Test " . $TestCount++ . ' - construction of change object'
);
$Self->Is(
    ref $Self->{ChangeObject},
    'Kernel::System::ITSMChange',
    "Test " . $TestCount++ . ' - class of change object'
);

# ------------------------------------------------------------ #
# create needed users and customer users
# ------------------------------------------------------------ #
my @UserIDs;               # a list of existing and valid user ids
my @InvalidUserIDs;        # a list of existing but invalid user ids
my @NonExistingUserIDs;    # a list of non-existion user ids
my @CustomerUserIDs;       # a list of existing and valid customer user ids, a list of strings

# disable email checks to create new user
my $CheckEmailAddressesOrg = $Self->{ConfigObject}->Get('CheckEmailAddresses') || 1;
$Self->{ConfigObject}->Set(
    Key   => 'CheckEmailAddresses',
    Value => 0,
);

for my $Counter ( 1 .. 3 ) {

    # create new users for the tests
    my $UserID = $Self->{UserObject}->UserAdd(
        UserFirstname => 'ITSMChange' . $Counter,
        UserLastname  => 'UnitTest',
        UserLogin     => 'UnitTest-ITSMChange-' . $Counter . int rand 1_000_000,
        UserEmail     => 'UnitTest-ITSMChange-' . $Counter . '@localhost',
        ValidID       => $Self->{ValidObject}->ValidLookup( Valid => 'valid' ),
        ChangeUserID  => 1,
    );
    push @UserIDs, $UserID;

    # create new customers for the tests
    my $CustomerUserID = $Self->{CustomerUserObject}->CustomerUserAdd(
        Source         => 'CustomerUser',
        UserFirstname  => 'ITSMChangeCustomer' . $Counter,
        UserLastname   => 'UnitTestCustomer',
        UserCustomerID => 'UCT' . $Counter . int rand 1_000_000,
        UserLogin      => 'UnitTest-ITSMChange-Customer-' . $Counter . int rand 1_000_000,
        UserEmail      => 'UnitTest-ITSMChange-Customer-'
            . $Counter
            . int( rand 1_000_000 )
            . '@localhost',
        ValidID => $Self->{ValidObject}->ValidLookup( Valid => 'valid' ),
        UserID => 1,
    );
    push @CustomerUserIDs, $CustomerUserID;
}

# sort the user and customer user arrays
@UserIDs         = sort @UserIDs;
@CustomerUserIDs = sort @CustomerUserIDs;

# create non existing user IDs
for ( 1 .. 2 ) {
    LPC:
    for my $LoopProtectionCounter ( 1 .. 100 ) {

        # create a random user id
        my $TempNonExistingUserID = int rand 1_000_000;

        # check if random user id exists already
        my %UserData = $Self->{UserObject}->GetUserData(
            UserID => $TempNonExistingUserID,
        );
        next LPC if %UserData;

        # we got an unused user ID
        push @NonExistingUserIDs, $TempNonExistingUserID;
        last LPC;
    }
}

# set 3rd user invalid
$Self->{UserObject}->UserUpdate(
    $Self->{UserObject}->GetUserData(
        UserID => $UserIDs[2],
    ),
    ValidID => $Self->{ValidObject}->ValidLookup( Valid => 'invalid' ),
    ChangeUserID => 1,
);
push @InvalidUserIDs, pop @UserIDs;

# restore original email check param
$Self->{ConfigObject}->Set(
    Key   => 'CheckEmailAddresses',
    Value => $CheckEmailAddressesOrg,
);

# ------------------------------------------------------------ #
# test ITSMChange API
# ------------------------------------------------------------ #

# define public interface (in alphabetical order)
my @ObjectMethods = qw(
    ChangeAdd
    ChangeCABDelete
    ChangeCABGet
    ChangeCABUpdate
    ChangeDelete
    ChangeGet
    ChangeList
    ChangeLookup
    ChangeSearch
    ChangeUpdate
    ChangeStateLookup
    Permission
);

# check if subs are available
for my $ObjectMethod (@ObjectMethods) {
    $Self->True(
        $Self->{ChangeObject}->can($ObjectMethod),
        "Test " . $TestCount++ . " - check 'can $ObjectMethod'"
    );
}

# ------------------------------------------------------------ #
# search for default ITSMChange-states
# ------------------------------------------------------------ #

# define default ITSMChange-states
# can't use qw due to spaces in states
my @DefaultChangeStates = (
    'requested',
    'pending approval',
    'rejected',
    'approved',
    'in progress',
    'successful',
    'failed',
    'retracted',
);

# get item list of the change states with swapped keys and values
my %ChangeStateName2ID = reverse %{
    $Self->{GeneralCatalogObject}->ItemList(
        Class => 'ITSM::ChangeManagement::Change::State',
        )
    };

# check if change states are in GeneralCatalog
for my $DefaultChangeState (@DefaultChangeStates) {
    $Self->True(
        $ChangeStateName2ID{$DefaultChangeState},
        "Test " . $TestCount++ . " - check state '$DefaultChangeState'"
    );
}

# test the lookup method
for my $State (@DefaultChangeStates) {
    my $StateID = $Self->{ChangeObject}->ChangeStateLookup(
        State => $State,
    );

    $Self->Is(
        $StateID,
        $ChangeStateName2ID{$State},
        "Lookup $State",
    );

    my $StateName = $Self->{ChangeObject}->ChangeStateLookup(
        StateID => $StateID,
    );

    $Self->Is(
        $StateName,
        $State,
        "Lookup $StateID",
    );
}

# ------------------------------------------------------------ #
# check existence of the groups that are used for Permission
# ------------------------------------------------------------ #

# get mapping of the group name to the group id
my %GroupName2ID = reverse $Self->{GroupObject}->GroupList( Valid => 1 );

# check wheter the groups were found
for my $Group (qw( itsm-change itsm-change-builder itsm-change-manager )) {
    $Self->True(
        $GroupName2ID{$Group},
        "Test " . $TestCount++ . " - check group '$Group'"
    );
}

# ------------------------------------------------------------ #
# define general change tests
# ------------------------------------------------------------ #

# store current TestCount for better test case recognition
my $TestCountMisc        = $TestCount;
my $UniqueSignature      = 'UnitTest-ITSMChange-' . int( rand 1_000_000 ) . '_' . time;
my $NoWildcardsTestTitle = 'UnitTest-ITSMChange-%NoWildcards%_' . time;

my @ChangeTests = (

    #------------------------------#
    # Tests on ChangeAdd
    #------------------------------#

    # Change doesn't contain all data (required attributes)
    {
        Description => 'Test contains no params for ChangeAdd.',
        Fails       => 1,                                          # we expect this test to fail
        SourceData  => {
            ChangeAdd => {},
        },
        ReferenceData => {
            ChangeGet => undef,
        },
    },

    # Change contains only required data - default user (required attributes)
    {
        Description => 'Test only needed params (UserID = 1) for ChangeAdd.',
        SourceData  => {
            ChangeAdd => {
                UserID => 1,
            },
        },
        ReferenceData => {
            ChangeGet => {
                ChangeTitle     => q{},
                Description     => q{},
                Justification   => q{},
                ChangeManagerID => undef,
                ChangeBuilderID => 1,
                WorkOrderIDs    => [],
                CABAgents       => [],
                CABCustomers    => [],
                CreateBy        => 1,
                ChangeBy        => 1,
            },
        },
        SearchTest => [ 25, 26 ],
        Label => 'ChangeLookupTest',    # this change will be used for testing ChangeLookup().
    },

    # Change contains only required data - default user (required attributes)
    {
        Description => 'Test only needed params (UserID != 1) for ChangeAdd.',
        SourceData  => {
            ChangeAdd => {
                UserID => $UserIDs[0],
            },
        },
        ReferenceData => {
            ChangeGet => {
                ChangeTitle     => q{},
                Description     => q{},
                Justification   => q{},
                ChangeManagerID => undef,
                ChangeBuilderID => $UserIDs[0],
                WorkOrderIDs    => [],
                CABAgents       => [],
                CABCustomers    => [],
                CreateBy        => $UserIDs[0],
                ChangeBy        => $UserIDs[0],
            },
        },
        SearchTest => [ 4, 25, 26 ],
    },

    # Change with named ChangeState
    {
        Description => 'Test for Statenames - ' . $UniqueSignature,
        SourceData  => {
            ChangeAdd => {
                UserID      => $UserIDs[0],
                Description => 'ChangeStates - ' . $UniqueSignature,
                ChangeState => 'requested',
            },
        },
        ReferenceData => {
            ChangeGet => {
                ChangeTitle     => q{},
                Description     => 'ChangeStates - ' . $UniqueSignature,
                Justification   => q{},
                ChangeManagerID => undef,
                ChangeBuilderID => $UserIDs[0],
                ChangeStateID   => $ChangeStateName2ID{requested},
                ChangeState     => 'requested',
                WorkOrderIDs    => [],
                CABAgents       => [],
                CABCustomers    => [],
                CreateBy        => $UserIDs[0],
                ChangeBy        => $UserIDs[0],
            },
        },
        SearchTest => [ 4, 25, 26, 33, 37 ],
    },

    # ChangeUpdate with named ChangeState
    {
        Description => 'Test for Statenames in ChangeUpdate - ' . $UniqueSignature,
        SourceData  => {
            ChangeAdd => {
                UserID      => $UserIDs[0],
                Description => 'ChangeStates - ' . $UniqueSignature,
                ChangeState => 'requested',
            },
            ChangeUpdate => {
                UserID      => $UserIDs[0],
                ChangeState => 'failed',
            },
        },
        ReferenceData => {
            ChangeGet => {
                ChangeTitle     => q{},
                Description     => 'ChangeStates - ' . $UniqueSignature,
                Justification   => q{},
                ChangeManagerID => undef,
                ChangeBuilderID => $UserIDs[0],
                ChangeStateID   => $ChangeStateName2ID{failed},
                ChangeState     => 'failed',
                WorkOrderIDs    => [],
                CABAgents       => [],
                CABCustomers    => [],
                CreateBy        => $UserIDs[0],
                ChangeBy        => $UserIDs[0],
            },
        },
        SearchTest => [ 4, 25, 26, 37, 38 ],
    },

    # change contains all data - (all attributes)
    {
        Description => 'Test contains all possible params for ChangeAdd.',
        SourceData  => {
            ChangeAdd => {
                ChangeTitle     => 'Change 1 - Title - ' . $UniqueSignature,
                Description     => 'Change 1 - Description - ' . $UniqueSignature,
                Justification   => 'Change 1 - Justification - ' . $UniqueSignature,
                ChangeManagerID => $UserIDs[0],
                ChangeBuilderID => $UserIDs[0],
                CABAgents       => [
                    $UserIDs[0],
                    $UserIDs[1],
                ],
                CABCustomers => [
                    $CustomerUserIDs[0],
                    $CustomerUserIDs[1],
                ],
                UserID => $UserIDs[1],
            },
        },
        ReferenceData => {
            ChangeGet => {
                ChangeTitle     => 'Change 1 - Title - ' . $UniqueSignature,
                Description     => 'Change 1 - Description - ' . $UniqueSignature,
                Justification   => 'Change 1 - Justification - ' . $UniqueSignature,
                ChangeManagerID => $UserIDs[0],
                ChangeBuilderID => $UserIDs[0],
                CABAgents       => [
                    $UserIDs[0],
                    $UserIDs[1],
                ],
                CABCustomers => [
                    $CustomerUserIDs[0],
                    $CustomerUserIDs[1],
                ],
            },
        },
        SearchTest => [ 2, 3, 4, 5, 6, 8, 9, 10, 12, 13, 23, 24, 27 ],
        Label => 'SearchTest',    # this test will be used for search tests
    },

    # change contains title, description, justification, changemanagerid and changebuilderid
    {
        Description => 'Test contains all possible params for ChangeAdd (Second try).',
        SourceData  => {
            ChangeAdd => {
                ChangeTitle     => 'Change 2 - Title - ' . $UniqueSignature,
                Description     => 'Change 2 - Description - ' . $UniqueSignature,
                Justification   => 'Change 2 - Justification - ' . $UniqueSignature,
                ChangeManagerID => $UserIDs[1],
                ChangeBuilderID => $UserIDs[1],
                CABAgents       => [
                    $UserIDs[1],
                ],
                CABCustomers => [
                    $CustomerUserIDs[1],
                ],
                UserID => $UserIDs[1],
            },
        },
        ReferenceData => {
            ChangeGet => {
                ChangeTitle     => 'Change 2 - Title - ' . $UniqueSignature,
                Description     => 'Change 2 - Description - ' . $UniqueSignature,
                Justification   => 'Change 2 - Justification - ' . $UniqueSignature,
                ChangeManagerID => $UserIDs[1],
                ChangeBuilderID => $UserIDs[1],
                CABAgents       => [ $UserIDs[1] ],
                CABCustomers    => [ $CustomerUserIDs[1] ],
                CreateBy        => $UserIDs[1]
            },
        },
        SearchTest => [ 23, 24 ],
    },

    # change contains all data - wrong CAB - (wrong CAB attributes)
    {
        Description => 'Test contains invalid CAB members for ChangeAdd.',
        SourceData  => {
            ChangeAdd => {
                ChangeTitle     => 'Change 3 - Title - ' . $UniqueSignature,
                Description     => 'Change 3 - Description - ' . $UniqueSignature,
                Justification   => 'Change 3 - Justification - ' . $UniqueSignature,
                ChangeManagerID => $UserIDs[0],
                ChangeBuilderID => $UserIDs[0],
                CABAgents       => [
                    $CustomerUserIDs[0],
                    $CustomerUserIDs[1],
                ],
                CABCustomers => [
                    $UserIDs[0],
                    $UserIDs[1],
                ],
                UserID => $UserIDs[1],
            },
        },
        ReferenceData => {
            ChangeGet => undef,
        },
        Fails => 1,
    },

    # change contains required data - duplicate CAB entries - (duplicate CAB entries)
    {
        Description => 'Test contains duplicate CAB members for ChangeAdd.',
        SourceData  => {
            ChangeAdd => {
                CABAgents => [
                    $UserIDs[0],
                    $UserIDs[1],
                    $UserIDs[0],
                    $UserIDs[1],
                ],
                CABCustomers => [
                    $CustomerUserIDs[0],
                    $CustomerUserIDs[1],
                    $CustomerUserIDs[0],
                    $CustomerUserIDs[1],
                ],
                UserID => 1,
            },
        },
        ReferenceData => {
            ChangeGet => {
                CABAgents => [
                    $UserIDs[0],
                    $UserIDs[1],
                ],
                CABCustomers => [
                    $CustomerUserIDs[0],
                    $CustomerUserIDs[1],
                ],
                CreateBy => 1,
                ChangeBy => 1,
            },
        },
    },

    # test on max long params  (required attributes)
    {
        Description => 'Test for max string length for ChangeAdd.',
        SourceData  => {
            ChangeAdd => {
                UserID        => $UserIDs[0],
                ChangeTitle   => 'T' x 250,
                Description   => 'D' x 3800,
                Justification => 'J' x 3800,
            },
        },
        ReferenceData => {
            ChangeGet => {
                ChangeTitle     => 'T' x 250,
                Description     => 'D' x 3800,
                Justification   => 'J' x 3800,
                ChangeManagerID => undef,
                ChangeBuilderID => $UserIDs[0],
                WorkOrderIDs    => [],
                CABAgents       => [],
                CABCustomers    => [],
                CreateBy        => $UserIDs[0],
                ChangeBy        => $UserIDs[0],
            },
        },
        SearchTest => [ 11, 12, 13 ],
    },

    # test on max+1 long params  (required attributes)
    {
        Description => 'Test for max+1 string length for ChangeAdd.',
        Fails       => 1,
        SourceData  => {
            ChangeAdd => {
                UserID        => $UserIDs[0],
                ChangeTitle   => 'T' x 251,
                Description   => 'D' x 3801,
                Justification => 'J' x 3801,
            },
        },
        ReferenceData => {
            ChangeGet => undef,
        },
    },

    # test on max+1 long params - title  (required attributes)
    {
        Description => 'Test for max+1 string - title - length for ChangeAdd.',
        Fails       => 1,
        SourceData  => {
            ChangeAdd => {
                UserID        => $UserIDs[0],
                ChangeTitle   => 'T' x 251,
                Description   => 'D',
                Justification => 'J',
            },
        },
        ReferenceData => {
            ChangeGet => undef,
        },
    },

    # test on max+1 long params - description (required attributes)
    {
        Description => 'Test for max+1 string - description - length for ChangeAdd.',
        Fails       => 1,
        SourceData  => {
            ChangeAdd => {
                UserID        => $UserIDs[0],
                ChangeTitle   => 'T',
                Description   => 'D' x 3801,
                Justification => 'J',
            },
        },
        ReferenceData => {
            ChangeGet => undef,
        },
    },

    # test on max+1 long params - justification (required attributes)
    {
        Description => 'Test for max+1 string - justification - length for ChangeAdd.',
        Fails       => 1,
        SourceData  => {
            ChangeAdd => {
                UserID        => $UserIDs[0],
                ChangeTitle   => 'T',
                Description   => 'D',
                Justification => 'J' x 3801,
            },
        },
        ReferenceData => {
            ChangeGet => undef,
        },
    },

    # test on '0' strings - default user  (required attributes)
    {
        Description => q{Test for '0' string handling for ChangeAdd.},
        SourceData  => {
            ChangeAdd => {
                UserID        => 1,
                ChangeTitle   => '0',
                Description   => '0',
                Justification => '0',
            },
        },
        ReferenceData => {
            ChangeGet => {
                ChangeTitle   => '0',
                Description   => '0',
                Justification => '0',
            },
        },
        SearchTest => [ 18, 19, 20, 21 ],
    },

    # Test title with leading whitespace
    {
        Description => 'Test for title with leading whitespace',
        SourceData  => {
            ChangeAdd => {
                UserID      => $UserIDs[0],
                ChangeTitle => "  \t \n  Title with leading whitespace - " . $UniqueSignature,
            },
        },
        ReferenceData => {
            ChangeGet => {
                ChangeTitle     => "Title with leading whitespace - " . $UniqueSignature,
                ChangeBuilderID => $UserIDs[0],
            },
        },
        SearchTest => [ 6, 45 ],
    },

    # Test title with trailing whitespace
    {
        Description => 'Test for title with trailing whitespace',
        SourceData  => {
            ChangeAdd => {
                UserID      => $UserIDs[0],
                ChangeTitle => "Title with trailing whitespace - " . $UniqueSignature . "  \t \n  ",
            },
        },
        ReferenceData => {
            ChangeGet => {
                ChangeTitle     => "Title with trailing whitespace - " . $UniqueSignature,
                ChangeBuilderID => $UserIDs[0],
            },
        },
        SearchTest => [ 6, 46 ],
    },

    # Test title with leading and trailing whitespace
    {
        Description => 'Test for title with leading and trailing whitespace',
        SourceData  => {
            ChangeAdd => {
                UserID      => $UserIDs[0],
                ChangeTitle => "  \t \n  Title with leading and trailing whitespace - "
                    . $UniqueSignature
                    . "  \t \n  ",
            },
        },
        ReferenceData => {
            ChangeGet => {
                ChangeTitle => "Title with leading and trailing whitespace - " . $UniqueSignature,
                ChangeBuilderID => $UserIDs[0],
            },
        },
        SearchTest => [ 6, 47 ],
    },

    # Test title with only whitespace
    {
        Description => 'Test for title with only whitespace',
        SourceData  => {
            ChangeAdd => {
                UserID      => $UserIDs[0],
                ChangeTitle => qq{  \t \n  },
            },
        },
        ReferenceData => {
            ChangeGet => {
                ChangeTitle     => q{},
                ChangeBuilderID => $UserIDs[0],
            },
        },
        SearchTest => [],
    },

    # a change for the 'UsingWildcards => 0' test
    {
        Description => q{A change for the 'UsingWildcards => 0' test.},
        SourceData  => {
            ChangeAdd => {
                UserID        => 1,
                ChangeTitle   => $NoWildcardsTestTitle,
                Description   => $NoWildcardsTestTitle,
                Justification => $NoWildcardsTestTitle,
            },
        },
        ReferenceData => {
            ChangeGet => {
                ChangeTitle   => $NoWildcardsTestTitle,
                Description   => $NoWildcardsTestTitle,
                Justification => $NoWildcardsTestTitle,
            },
        },
    },

    # test on mixed valid and invalid CABAgents  (required attributes)
    {
        Description => 'Test on mixed valid and invalid CABAgents for ChangeAdd.',
        Fails       => 1,
        SourceData  => {
            ChangeAdd => {
                UserID    => 1,
                CABAgents => [
                    $UserIDs[0],
                    $NonExistingUserIDs[1],
                    $UserIDs[1],
                    $NonExistingUserIDs[0],
                ],
            },
        },
        ReferenceData => {
            ChangeGet => undef,
        },
    },

    # test on mixed valid and invalid CABCustomers  (required attributes)
    {
        Description => 'Test on mixed valid and invalid CABCustomers for ChangeAdd.',
        Fails       => 1,
        SourceData  => {
            ChangeAdd => {
                UserID       => 1,
                CABCustomers => [
                    $CustomerUserIDs[0],
                    $CustomerUserIDs[1],
                    'ThisIsAnInvalidCustomerUserId',
                ],
            },
        },
        ReferenceData => {
            ChangeGet => undef,
        },
    },

    # test on invalid IDs for ChangeManagerID and ChangeBuilderID
    {
        Description => 'Test on invalid IDs for ChangeManagerID and ChangeBuilderID for ChangeAdd.',
        Fails       => 1,
        SourceData  => {
            ChangeAdd => {
                UserID          => 1,
                ChangeManagerID => $NonExistingUserIDs[0],
                ChangeBuilderID => $NonExistingUserIDs[0],
            },
        },
        ReferenceData => {
            ChangeGet => undef,
        },
    },

    # test on invalid IDs for ChangeManagerID
    {
        Description => 'Test on invalid ID for ChangeManagerID for ChangeAdd.',
        Fails       => 1,
        SourceData  => {
            ChangeAdd => {
                UserID          => 1,
                ChangeManagerID => $NonExistingUserIDs[0],
                ChangeBuilderID => $UserIDs[0],
            },
        },
        ReferenceData => {
            ChangeGet => undef,
        },
    },

    # test on invalid IDs for ChangeBuilderID
    {
        Description => 'Test on invalid ID for ChangeBuilderID for ChangeAdd.',
        Fails       => 1,
        SourceData  => {
            ChangeAdd => {
                UserID          => 1,
                ChangeManagerID => $UserIDs[0],
                ChangeBuilderID => $NonExistingUserIDs[0],
            },
        },
        ReferenceData => {
            ChangeGet => undef,
        },
    },

    # test on invalid RealizeTime
    {
        Description => 'Test on invalid RealizeTime for ChangeAdd.',
        Fails       => 1,
        SourceData  => {
            ChangeAdd => {
                UserID      => 1,
                RealizeTime => 'anything invalid',
            },
        },
        ReferenceData => {
            ChangeGet => undef,
        },
    },

    # test on valid RealizeTime
    {
        Description => 'Test on valid RealizeTime for ChangeAdd.',
        SourceData  => {
            ChangeAdd => {
                UserID      => 1,
                RealizeTime => '2009-10-29 13:33:33',
                Description => 'RealizeTime - ' . $UniqueSignature,
            },
        },
        ReferenceData => {
            ChangeGet => {
                CreateBy    => 1,
                ChangeBy    => 1,
                ChangeTitle => q{},
                RealizeTime => '2009-10-29 13:33:33',
                Description => 'RealizeTime - ' . $UniqueSignature,
            },
        },
        SearchTest => [ 42, 43 ],
    },

    #------------------------------#
    # Tests on ChangeUpdate
    #------------------------------#

    # Update change without required params (required attributes)
    {
        Description => 'Test contains no params for ChangeUpdate().',
        Fails       => 1,                                              # we expect this test to fail
        SourceData  => {
            ChangeUpdate => {},
        },
        ReferenceData => {
            ChangeUpdate => undef,
        },
    },

    # test on max long params  (required attributes)
    {
        Description => 'Test for max string length for ChangeUpdate.',
        SourceData  => {
            ChangeAdd => {
                UserID => $UserIDs[0],
            },
            ChangeUpdate => {
                UserID        => 1,
                ChangeTitle   => 'T' x 250,
                Description   => 'D' x 3800,
                Justification => 'J' x 3800,
            },
        },
        ReferenceData => {
            ChangeGet => {
                ChangeTitle     => 'T' x 250,
                Description     => 'D' x 3800,
                Justification   => 'J' x 3800,
                ChangeManagerID => undef,
                ChangeBuilderID => $UserIDs[0],
                WorkOrderIDs    => [],
                CABAgents       => [],
                CABCustomers    => [],
                CreateBy        => $UserIDs[0],
                ChangeBy        => 1,
            },
        },
        SearchTest => [ 11, 14, 15, 16, 17 ],
    },

    # test on max+1 long params  (required attributes)
    {
        Description => 'Test for max+1 string length for ChangeUpdate.',
        UpdateFails => 1,
        SourceData  => {
            ChangeAdd => {
                UserID => $UserIDs[0],
            },
            ChangeUpdate => {
                UserID        => 1,
                ChangeTitle   => 'T' x 251,
                Description   => 'D' x 3801,
                Justification => 'J' x 3801,
            },
        },
        ReferenceData => {
            ChangeGet => {
                ChangeTitle   => q{},
                Description   => q{},
                Justification => q{},
            },
        },
    },

    # test on max+1 long params - title  (required attributes)
    {
        Description => 'Test for max+1 string length - title - for ChangeUpdate.',
        UpdateFails => 1,
        SourceData  => {
            ChangeAdd => {
                UserID => $UserIDs[0],
            },
            ChangeUpdate => {
                UserID        => 1,
                ChangeTitle   => 'T' x 251,
                Description   => 'D',
                Justification => 'J',
            },
        },
        ReferenceData => {
            ChangeGet => {
                ChangeTitle   => q{},
                Description   => q{},
                Justification => q{},
            },
        },
    },    # test on max+1 long params - description  (required attributes)
    {
        Description => 'Test for max+1 string length - description - for ChangeUpdate.',
        UpdateFails => 1,
        SourceData  => {
            ChangeAdd => {
                UserID => $UserIDs[0],
            },
            ChangeUpdate => {
                UserID        => 1,
                ChangeTitle   => 'T',
                Description   => 'D' x 3801,
                Justification => 'J',
            },
        },
        ReferenceData => {
            ChangeGet => {
                ChangeTitle   => q{},
                Description   => q{},
                Justification => q{},
            },
        },
    },    # test on max+1 long params  - justification - (required attributes)
    {
        Description => 'Test for max+1 string length - justification - for ChangeUpdate.',
        UpdateFails => 1,
        SourceData  => {
            ChangeAdd => {
                UserID => $UserIDs[0],
            },
            ChangeUpdate => {
                UserID        => 1,
                ChangeTitle   => 'T',
                Description   => 'D',
                Justification => 'J' x 3801,
            },
        },
        ReferenceData => {
            ChangeGet => {
                ChangeTitle   => q{},
                Description   => q{},
                Justification => q{},
            },
        },
    },

    # test on '0' strings - default user  (required attributes)
    {
        Description => q{Test for '0' string handling for ChangeUpdate.},
        SourceData  => {
            ChangeAdd => {
                UserID => 1,
            },
            ChangeUpdate => {
                UserID        => 1,
                ChangeTitle   => '0',
                Description   => '0',
                Justification => '0',
            },
        },
        ReferenceData => {
            ChangeGet => {
                ChangeTitle   => '0',
                Description   => '0',
                Justification => '0',
            },
        },
    },

    # test on valid RealizeTime
    {
        Description => 'Test on valid RealizeTime for ChangeUpdate.',
        SourceData  => {
            ChangeAdd => {
                UserID      => 1,
                RealizeTime => '2009-10-29 13:33:33',
                Description => 'RealizeTime - ' . $UniqueSignature,
            },
            ChangeUpdate => {
                RealizeTime => '2009-11-06 08:15:22',
                UserID      => $UserIDs[0],
            },
        },
        ReferenceData => {
            ChangeGet => {
                CreateBy    => 1,
                ChangeBy    => $UserIDs[0],
                ChangeTitle => q{},
                RealizeTime => '2009-11-06 08:15:22',
                Description => 'RealizeTime - ' . $UniqueSignature,
            },
        },
        SearchTest => [43],
    },

    # test on invalid RealizeTime
    {
        Description => 'Test on invalid RealizeTime for ChangeUpdate.',
        UpdateFails => 1,
        SourceData  => {
            ChangeAdd => {
                UserID      => 1,
                RealizeTime => '2009-10-29 13:33:33',
                Description => 'RealizeTime - ' . $UniqueSignature,
            },
            ChangeUpdate => {
                RealizeTime => 'anything',
                UserID      => $UserIDs[0],
            },
        },
        ReferenceData => {
            ChangeGet => {
                CreateBy    => 1,
                ChangeBy    => 1,
                ChangeTitle => q{},
                RealizeTime => '2009-10-29 13:33:33',
                Description => 'RealizeTime - ' . $UniqueSignature,
            },
        },
        SearchTest => [ 42, 43 ],
    },

    #------------------------------#
    # Tests on ChangeCAB*
    #------------------------------#

    # Test for ChangeCABGet
    {
        Description =>
            'Test checks empty ARRAY-ref on ChangeCABGet with no given CAB for ChangeCABGet.',
        SourceData => {
            ChangeAdd => {
                UserID => $UserIDs[0],
            },
        },
        ReferenceData => {
            ChangeCABGet => {
                CABAgents    => [],
                CABCustomers => [],
            },
        },
        SearchTest => [ 4, 12, 13 ],
    },

    # Test for ChangeCABUpdate and ChangeCABGet
    {
        Description => 'Test checks removment of duplicate CAB members for ChangeCABUpdate',
        SourceData  => {
            ChangeAdd => {
                UserID      => $UserIDs[0],
                ChangeTitle => 'CABUpdate and CABGet - Title - ' . $UniqueSignature,
            },
            ChangeCABUpdate => {
                CABAgents => [
                    $UserIDs[0],
                    $UserIDs[0],
                    $UserIDs[0],
                    $UserIDs[1],
                ],
                CABCustomers => [
                    $CustomerUserIDs[0],
                    $CustomerUserIDs[1],
                    $CustomerUserIDs[1],
                    $CustomerUserIDs[1],
                    $CustomerUserIDs[1],
                    $CustomerUserIDs[1],
                ],
            },
        },
        ReferenceData => {
            ChangeCABGet => {
                CABAgents => [
                    $UserIDs[0],
                    $UserIDs[1],
                ],
                CABCustomers => [
                    $CustomerUserIDs[0],
                    $CustomerUserIDs[1],
                ],
            },
        },
        SearchTest => [ 6, 8, 9, 10, 22, 28, 29, 33, 34, 35 ],
    },

    # Test for ChangeCABUpdate and ChangeCABGet
    {
        Description => 'Test checks invalid CABAgents param for ChangeCABUpdate.',
        SourceData  => {
            ChangeAdd => {
                UserID => $UserIDs[0],
            },
            ChangeCABUpdate => {
                CABAgents => [
                    $CustomerUserIDs[0],
                ],
            },
            ChangeCABUpdateFail => 1,
        },
        ReferenceData => {
            ChangeCABGet => {
                CABAgents    => [],
                CABCustomers => [],
            },
        },
    },

    # Test for ChangeCABUpdate and ChangeCABGet
    {
        Description => 'Test checks deaktivated CABAgents param for ChangeCABUpdate.',
        SourceData  => {
            ChangeAdd => {
                UserID => $UserIDs[0],
            },
            ChangeCABUpdate => {
                CABAgents => [
                    $InvalidUserIDs[0],
                ],
            },
            ChangeCABUpdateFail => 1,
        },
        ReferenceData => {
            ChangeCABGet => {
                CABAgents    => [],
                CABCustomers => [],
            },
        },
    },

    # Test for ChangeCABUpdate and ChangeCABGet
    {
        Description => 'Test checks invalid CABCustomers param for ChangeCABUpdate.',
        SourceData  => {
            ChangeAdd => {
                UserID => $UserIDs[0],
            },
            ChangeCABUpdate => {
                CABCustomers => [
                    $UserIDs[0],
                ],
            },
            ChangeCABUpdateFail => 1,
        },
        ReferenceData => {
            ChangeCABGet => {
                CABAgents    => [],
                CABCustomers => [],
            },
        },
    },

    # Test for ChangeCABUpdate and ChangeCABGet
    {
        Description => 'Test checks valid ChangeAdd and ChangeCABUpdate.',
        SourceData  => {
            ChangeAdd => {
                UserID    => $UserIDs[0],
                CABAgents => [
                    $UserIDs[0],
                ],
                CABCustomers => [
                    $CustomerUserIDs[0],
                ],
            },
            ChangeCABUpdate => {
                CABCustomers => [
                    $UserIDs[0],
                ],
                CABAgents => [
                    $UserIDs[0],
                    $UserIDs[1],
                ],
                CABCustomers => [
                    $CustomerUserIDs[0],
                    $CustomerUserIDs[1],
                ],
            },
        },
        ReferenceData => {
            ChangeCABGet => {
                CABAgents => [
                    $UserIDs[0],
                    $UserIDs[1],
                ],
                CABCustomers => [
                    $CustomerUserIDs[0],
                    $CustomerUserIDs[1],
                ],
            },
        },
    },

    # Test for ChangeCABDelete
    {
        Description => 'Test checks ChangeCABDelete with valid params.',
        SourceData  => {
            ChangeAdd => {
                UserID    => $UserIDs[0],
                CABAgents => [
                    $UserIDs[0],
                    $UserIDs[1]
                ],
                CABCustomers => [
                    $CustomerUserIDs[0],
                    $CustomerUserIDs[1],
                ],
            },
            ChangeCABDelete => 1,
        },
        ReferenceData => {
            ChangeCABGet => {
                CABAgents    => [],
                CABCustomers => [],
            },
        },
    },

    # Test for ChangeCABDelete - in the executiion of the, no ChangeID will be given
    {
        Description => 'Test checks ChangeCABDelete with invalid params.',
        SourceData  => {
            ChangeAdd => {
                UserID      => $UserIDs[0],
                ChangeTitle => 'CABDelete (invalid params) - Title - ' . $UniqueSignature,
                CABAgents   => [
                    $UserIDs[0],
                    $UserIDs[1]
                ],
                CABCustomers => [
                    $CustomerUserIDs[0],
                    $CustomerUserIDs[1],
                ],
            },
            ChangeCABDelete     => 1,
            ChangeCABDeleteFail => 1,
        },
        ReferenceData => {
            ChangeCABGet => {
                CABAgents => [
                    $UserIDs[0],
                    $UserIDs[1]
                ],
                CABCustomers => [
                    $CustomerUserIDs[0],
                    $CustomerUserIDs[1],
                ],
            },
        },
        SearchTest => [ 6, 8, 9, 10 ],
    },

    # add change and update changestateid
    {
        Description => q{Test setting new ChangeStateID in ChangeUpdate.},
        SourceData  => {
            ChangeAdd => {
                UserID => 1,
            },
            ChangeUpdate => {
                UserID        => 1,
                ChangeStateID => $ChangeStateName2ID{rejected},
            },
        },
        ReferenceData => {
            ChangeGet => {
                ChangeStateID => $ChangeStateName2ID{rejected},
            },
        },
        SearchTest => [ 29, 35 ],
    },

    #----------------------------------------#
    # Changes for 'OrderBy' search tests
    #----------------------------------------#

    #
    {
        Description => q{Change for 'OrderBy' tests (1).},
        SourceData  => {
            ChangeAdd => {
                UserID      => 1,
                ChangeTitle => 'OrderByChange - Title - ' . $UniqueSignature,
            },
            ChangeUpdate => {
                UserID          => $UserIDs[0],
                ChangeStateID   => $ChangeStateName2ID{successful},
                ChangeManagerID => $UserIDs[1],
            },
            ChangeAddChangeTime => {
                CreateTime => '2009-10-01 01:00:00',
            },
        },
        ReferenceData => {
            ChangeGet => {
                ChangeStateID => $ChangeStateName2ID{successful},
            },
        },
        Label => 'OrderBySearchTest',    # this change will be used in order by search tests
    },

    #
    {
        Description => q{Change for 'OrderBy' tests (2).},
        SourceData  => {
            ChangeAdd => {
                UserID      => $UserIDs[1],
                ChangeTitle => 'OrderByChange - Title - ' . $UniqueSignature,
            },
            ChangeUpdate => {
                UserID          => $UserIDs[1],
                ChangeStateID   => $ChangeStateName2ID{rejected},
                ChangeManagerID => 1,
            },
            ChangeAddChangeTime => {
                CreateTime => '2009-10-30 01:00:00',
            },
            ChangeUpdateChangeTime => {
                ChangeTime => '2009-10-30 01:00:15',
            },
        },
        ReferenceData => {
            ChangeGet => {
                ChangeStateID => $ChangeStateName2ID{rejected},
            },
        },
        Label => 'OrderBySearchTest',    # this change will be used in order by search tests
    },

    #
    {
        Description => q{Change for 'OrderBy' tests (3).},
        SourceData  => {
            ChangeAdd => {
                UserID      => $UserIDs[0],
                ChangeTitle => 'OrderByChange - Title - ' . $UniqueSignature,
            },
            ChangeUpdate => {
                UserID          => 1,
                ChangeStateID   => $ChangeStateName2ID{failed},
                ChangeManagerID => $UserIDs[0],
            },
            ChangeAddChangeTime => {
                CreateTime => '2009-01-30 00:00:00',
            },
            ChangeUpdateChangeTime => {
                ChangeTime => '2009-01-30 23:59:59',
            },
        },
        ReferenceData => {
            ChangeGet => {
                ChangeStateID => $ChangeStateName2ID{failed},
            },
        },
        SearchTest => [6],
        Label      => 'OrderBySearchTest',    # this change will be used in order by search tests
    },

    # Change for Permission tests.
    {
        Description => q{Change for 'Permission' tests.},
        SourceData  => {
            ChangeAdd => {
                UserID      => $UserIDs[0],
                ChangeTitle => 'Permission - Title - ' . $UniqueSignature,
            },
        },
        ReferenceData => {
            ChangeGet => {
                ChangeTitle => 'Permission - Title - ' . $UniqueSignature,
            },
            ChangeCABGet => {
                CABAgents => [
                ],
                CABCustomers => [
                ],
            },
        },
        SearchTest => [6],
        Label      => 'PermissionTest',    # this change will be used in permission tests
    },

);

# ------------------------------------------------------------ #
# execute the general change tests
# ------------------------------------------------------------ #

my %TestedChangeID;           # change ids of created changes
my %ChangeIDForSearchTest;    # change ids that are expected to be found by a search test
my %Label2ChangeIDs;          # change ids that are used for special tests

TEST:
for my $Test (@ChangeTests) {

    # check SourceData attribute
    if ( !$Test->{SourceData} || ref $Test->{SourceData} ne 'HASH' ) {

        $Self->True(
            0,
            "Test $TestCount: No SourceData found for this test (test case: "
                . ( $TestCount - $TestCountMisc ) . ").",
        );

        next TEST;
    }

    # print test case description
    if ( $Test->{Description} ) {
        $Self->True(
            1,
            "Test $TestCount: $Test->{Description} (test case: "
                . ( $TestCount - $TestCountMisc ) . ").",
        );
    }

    # extract test data
    my $SourceData    = $Test->{SourceData};
    my $ReferenceData = $Test->{ReferenceData};

    # the change id will be used for several calls
    my $ChangeID;

    # add a new Change
    if ( $SourceData->{ChangeAdd} ) {

        # add the change
        $ChangeID = $Self->{ChangeObject}->ChangeAdd(
            %{ $SourceData->{ChangeAdd} }
        );

        # remember current ChangeID
        if ($ChangeID) {
            $TestedChangeID{$ChangeID} = 1;

            # save changeid for use in search tests
            if ( exists $Test->{SearchTest} ) {
                my @SearchTests = @{ $Test->{SearchTest} };

                for my $SearchTestNr (@SearchTests) {
                    $ChangeIDForSearchTest{$SearchTestNr}->{$ChangeID} = 1;
                }
            }

            # save changeid for special tests
            if ( exists $Test->{Label} ) {
                $Label2ChangeIDs{ $Test->{Label} } ||= [];
                push @{ $Label2ChangeIDs{ $Test->{Label} } }, $ChangeID;
            }
        }

        # change CreateTime
        if ( $ChangeID && $SourceData->{ChangeAddChangeTime} ) {
            SetTimes(
                ChangeID   => $ChangeID,
                CreateTime => $SourceData->{ChangeAddChangeTime}->{CreateTime},
            );
        }

        # UserID is the only required parameter
        if ( !$SourceData->{ChangeAdd}->{UserID} ) {
            $Self->False(
                $ChangeID,
                "Test $TestCount: ChangeAdd() - Don't add change without given UserID.",
            );
        }

        if ( $SourceData->{ChangeAdd}->{UserID} ) {
            if ( $Test->{Fails} ) {
                $Self->False(
                    $ChangeID,
                    "Test $TestCount: ChangeAdd() - Add change should fail.",
                );
            }
            else {
                $Self->True(
                    $ChangeID,
                    "Test $TestCount: ChangeAdd() - Add change.",
                );
            }
        }
    }    # end if 'ChangeAdd'

    if ( exists $SourceData->{ChangeUpdate} ) {

        # update the change
        my $ChangeUpdateSuccess = $Self->{ChangeObject}->ChangeUpdate(
            ChangeID => $ChangeID,
            %{ $SourceData->{ChangeUpdate} },
        );

        # change ChangeTime
        if ( $ChangeID && $SourceData->{ChangeUpdateChangeTime} ) {
            SetTimes(
                ChangeID   => $ChangeID,
                ChangeTime => $SourceData->{ChangeUpdateChangeTime}->{ChangeTime},
            );
        }

        if (
            $Test->{Fails}
            || $Test->{UpdateFails}
            )
        {
            $Self->False(
                $ChangeUpdateSuccess,
                "Test $TestCount: ChangeUpdate()",
            );
        }
        else {
            $Self->True(
                $ChangeUpdateSuccess,
                "Test $TestCount: ChangeUpdate()",
            );
        }
    }    # end if ChangeUpdate

    if ( $SourceData->{ChangeCABUpdate} && $ChangeID ) {
        my $CABUpdateSuccess = $Self->{ChangeObject}->ChangeCABUpdate(
            %{ $SourceData->{ChangeCABUpdate} },
            ChangeID => $ChangeID,
            UserID   => 1,
        );

        if ( $SourceData->{ChangeCABUpdateFail} ) {
            $Self->False(
                $CABUpdateSuccess,
                "Test $TestCount: |- ChangeCABUpdate",
                )
        }
        else {
            $Self->True(
                $CABUpdateSuccess,
                "Test $TestCount: |- ChangeCABUpdate",
            );
        }
    }    # end if 'ChangeCABUpdate'

    if ( $SourceData->{ChangeCABDelete} && $ChangeID ) {
        my %CABDeleteParams = (
            UserID   => 1,
            ChangeID => $ChangeID,
        );

        # special handling for fail tests
        if ( $SourceData->{ChangeCABDeleteFail} ) {

            # test void context
            $Self->False(
                $Self->{ChangeObject}->ChangeCABDelete() || 0,
                "Test $TestCount: |- ChangeCABDelete",
            );

            my @DeleteTests = (
                { UserID   => 1 },
                { ChangeID => $ChangeID },
            );
            for my $FailTest (@DeleteTests) {
                $Self->False(
                    $Self->{ChangeObject}->ChangeCABDelete( %{$FailTest} ) || 0,
                    "Test $TestCount: |- ChangeCABDelete",
                );
            }
        }
        else {

            # Delete with all params
            $Self->True(
                $Self->{ChangeObject}->ChangeCABDelete(%CABDeleteParams),
                "Test $TestCount: |- ChangeCABDelete",
            );
        }
    }    # end if 'ChangeCABDelete'

    # get a change and compare the retrieved data with the reference
    if ( exists $ReferenceData->{ChangeGet} ) {

        my $ChangeGetReferenceData = $ReferenceData->{ChangeGet};

        my $ChangeData = $Self->{ChangeObject}->ChangeGet(
            ChangeID => $ChangeID,
            UserID   => 1,
        );

        # ChangeGet should not return anything
        if ( !defined $ReferenceData->{ChangeGet} ) {
            $Self->False(
                $ChangeData,
                "Test $TestCount: |- Get change returns undef.",
            );

            # check if we excpected to fail
            if ( $Test->{Fails} ) {
                $Self->Is(
                    !defined $ChangeData,
                    !defined $ReferenceData->{ChangeData},
                    "Test $TestCount: |- Should fail.",
                );
            }
            next TEST;
        }

        # check for always existing attributes
        for my $ChangeAttributes (qw(ChangeID ChangeNumber ChangeBuilderID CreateTime ChangeTime)) {
            $Self->True(
                $ChangeData->{$ChangeAttributes},
                "Test $TestCount: |- has $ChangeAttributes.",
            );
        }

        for my $RequestedAttribute ( keys %{ $ReferenceData->{ChangeGet} } ) {

            # turn off all pretty print
            local $Data::Dumper::Indent = 0;
            local $Data::Dumper::Useqq  = 1;

            # dump the attribute from ChangeGet()
            my $ChangeAttribute = Data::Dumper::Dumper( $ChangeData->{$RequestedAttribute} );

            # dump the reference attribute
            my $ReferenceAttribute
                = Data::Dumper::Dumper( $ReferenceData->{ChangeGet}->{$RequestedAttribute} );

            $Self->Is(
                $ChangeAttribute,
                $ReferenceAttribute,
                "Test $TestCount: |- $RequestedAttribute (ChangeID: $ChangeID)",
            );
        }
    }    # end if 'ChangeGet'

    if ( $ReferenceData->{ChangeCABGet} ) {
        my $CABData = $Self->{ChangeObject}->ChangeCABGet(
            %{ $ReferenceData->{ChangeCABGet} },
            UserID   => 1,
            ChangeID => $ChangeID,
        );

        for my $RequestedAttribute ( keys %{ $ReferenceData->{ChangeCABGet} } ) {

            # turn off all pretty print
            local $Data::Dumper::Indent = 0;
            local $Data::Dumper::Useqq  = 1;

            # dump the attribute from ChangeGet()
            my $ChangeAttribute = Data::Dumper::Dumper( $CABData->{$RequestedAttribute} );

            # dump the reference attribute
            my $ReferenceAttribute
                = Data::Dumper::Dumper( $ReferenceData->{ChangeCABGet}->{$RequestedAttribute} );

            $Self->Is(
                $ChangeAttribute,
                $ReferenceAttribute,
                "Test $TestCount: |- ChangeCABGet ( $RequestedAttribute )",
            );
        }
    }    # end if 'ChangeCABGet'
}

# get executed each loop, even on next
continue {
    $TestCount++;
}

# test for ChangeLookup
my ($ChangeLookupTestChangeID) = @{ $Label2ChangeIDs{ChangeLookupTest} };

if ($ChangeLookupTestChangeID) {
    my $ChangeData = $Self->{ChangeObject}->ChangeGet(
        ChangeID => $ChangeLookupTestChangeID,
        UserID   => 1,
    );

    my $ChangeID = $Self->{ChangeObject}->ChangeLookup(
        ChangeNumber => $ChangeData->{ChangeNumber},
        UserID       => 1,
    );

    $Self->Is(
        $ChangeID,
        $ChangeData->{ChangeID},
        'Test ' . $TestCount++ . ': ChangeLookup with ChangeNumber '
            . $ChangeData->{ChangeNumber} . ' successful.',
    );

    my $ChangeNumber = $Self->{ChangeObject}->ChangeLookup(
        ChangeID => $ChangeLookupTestChangeID,
        UserID   => 1,
    );

    $Self->Is(
        $ChangeNumber,
        $ChangeData->{ChangeNumber},
        'Test '
            . $TestCount++
            . ": ChangeLookup with ChangeID $ChangeLookupTestChangeID successful.",
    );
}

# test if ChangeList returns at least as many changes as we created
# we cannot test for a specific number as these tests can be run in existing environments
# where other changes already exist
my $ChangeList = $Self->{ChangeObject}->ChangeList( UserID => 1 ) || [];
my %ChangeListMap = map { $_ => 1 } @{$ChangeList};

# check whether the created changes were found by ChangeList()
for my $KeyTestedChangeID ( keys %TestedChangeID ) {
    $Self->True(
        $ChangeListMap{$KeyTestedChangeID},
        'Test ' . $TestCount++ . ": ChangeList() - ChangeID $KeyTestedChangeID in list.",
    );
}

# count all tests that are required to and planned for fail
my $Fails = scalar grep { $_->{Fails} } @ChangeTests;
my $NrCreateChanges = ( scalar @ChangeTests ) - $Fails;

# test if the changes were created
$Self->Is(
    scalar keys %TestedChangeID || 0,
    $NrCreateChanges,
    'Test ' . $TestCount++ . ': amount of change objects and test cases.',
);

# ------------------------------------------------------------ #
# define general change search tests
# ------------------------------------------------------------ #
my $SystemTime = $Self->{TimeObject}->SystemTime();

my @ChangeSearchTests = (

    # Nr 1 - a simple check if the search functions takes care of "Limit"
    {
        Description => 'Limit',
        SearchData  => {
            Limit => 3,    # expect only 3 results
        },
        ResultData => {
            TestCount => 1,    # flag for check result amount
            Count     => 3,    # check on 3 results
        },
    },

    # Nr 2 - search for all changes created by our first user
    {
        Description => 'ChangeTitle, Justification',
        SearchData  => {
            ChangeTitle   => 'Change 1 - Title - ' . $UniqueSignature,
            Justification => 'Change 1 - Justification - ' . $UniqueSignature,
        },
        ResultData => {
            TestExistence => 1,
        },
    },

    # Nr 3 - test createtimenewerdate
    {
        Description => 'CreateTimeNewerDate',
        SearchData  => {
            CreateTimeNewerDate => $Self->{TimeObject}->SystemTime2TimeStamp(
                SystemTime => $SystemTime - ( 60 * 60 ),
            ),
        },
        ResultData => {
            TestExistence => 1,
        },
    },

    # Nr 4 - test createtimeolderdate
    {
        Description => 'CreateTimeOlderDate',
        SearchData  => {
            CreateTimeOlderDate => $Self->{TimeObject}->SystemTime2TimeStamp(
                SystemTime => $SystemTime + ( 60 * 60 ),
            ),
        },
        ResultData => {
            TestExistence => 1,
        },
    },

    # Nr 5 - test changeMANAGERid
    {
        Description => 'ChangeManagerID',
        SearchData  => {
            ChangeManagerIDs => [ $UserIDs[0] ],
        },
        ResultData => {
            TestExistence => 1,
        },
    },

    # Nr 6 - test changeBUILDERid and ChangeTitle with wildcard
    {
        Description => 'ChangeBuilderID',
        SearchData  => {
            ChangeBuilderIDs => [ $UserIDs[0] ],
            ChangeTitle      => '%' . $UniqueSignature,
        },
        ResultData => {
            TestCount     => 1,
            TestExistence => 1,
        },
    },

    # Nr 7 - test ChangeManagerID and ChangeBuilderID
    {
        Description => 'ChangeBuilderID, ChangeManagerID',
        SearchData  => {
            ChangeBuilderIDs => [ $UserIDs[0] ],
            ChangeManagerIDs => [ $InvalidUserIDs[0] ],
            ChangeTitle      => '%' . $UniqueSignature,
        },
        ResultData => {
            TestCount => 1,
            Count     => 0,
        },
    },

    # Nr 8 - test CABAgent
    {
        Description => 'CABAgent',
        SearchData  => {
            CABAgents   => [ $UserIDs[0] ],
            ChangeTitle => '%' . $UniqueSignature,
        },
        ResultData => {
            TestCount     => 1,
            TestExistence => 1,
        },
    },

    # Nr 9 - test CABCustomer
    {
        Description => 'CABCustomer',
        SearchData  => {
            CABCustomers => [ $CustomerUserIDs[0] ],
            ChangeTitle  => '%' . $UniqueSignature,
        },
        ResultData => {
            TestCount     => 1,
            TestExistence => 1,
        },
    },

    # Nr 10 - test CABAgent and CABCustomer
    {
        Description => 'CABAgent, CABCustomer',
        SearchData  => {
            CABAgents    => [ $UserIDs[0] ],
            CABCustomers => [ $CustomerUserIDs[1] ],
            ChangeTitle  => '%' . $UniqueSignature,
        },
        ResultData => {
            TestCount     => 1,
            TestExistence => 1,
        },
    },

    # Nr 11 - test Justification
    {
        Description => 'Justification',
        SearchData  => {
            Justification => 'J' x 3800,
        },
        ResultData => {
            TestExistence => 1,
        },
    },

    # Nr 12 - test changetimenewerdate
    {
        Description => 'ChangeTimeNewerDate',
        SearchData  => {
            ChangeTimeNewerDate => $Self->{TimeObject}->SystemTime2TimeStamp(
                SystemTime => $SystemTime - ( 60 * 60 ),
            ),
        },
        ResultData => {
            TestExistence => 1,
        },
    },

    # Nr 13 - test changetimeolderdate
    {
        Description => 'ChangeTimeOlderDate',
        SearchData  => {
            ChangeTimeOlderDate => $Self->{TimeObject}->SystemTime2TimeStamp(
                SystemTime => $SystemTime + ( 60 * 60 ),
            ),
        },
        ResultData => {
            TestExistence => 1,
        },
    },

    # Nr 14 - ChangeTitle with wildcard
    {
        Description => 'ChangeTitle with wildcard',
        SearchData  => {
            ChangeTitle => ( 'T' x 250 ) . '%',
        },
        ResultData => {
            TestExistence => 1,
        },
    },

    # Nr 15 - Description with wildcard
    {
        Description => 'Description with wildcard',
        SearchData  => {
            Description => ( 'D' x 250 ) . '%',
        },
        ResultData => {
            TestExistence => 1,
        },
    },

    # Nr 16 - Justification with wildcard
    {
        Description => 'Justification with wildcard',
        SearchData  => {
            Justification => ( 'J' x 250 ) . '%',
        },
        ResultData => {
            TestExistence => 1,
        },
    },

    # Nr 17 - ChangeTitle, Description, Justification with wildcard
    {
        Description => 'ChangeTitle, Description, Justification with wildcard',
        SearchData  => {
            ChangeTitle   => ( 'T' x 250 ) . '%',
            Description   => ( 'D' x 250 ) . '%',
            Justification => ( 'J' x 250 ) . '%',
        },
        ResultData => {
            TestExistence => 1,
        },
    },

    # Nr 18 - ChangeTitle with '0'
    {
        Description => q{ChangeTitle with '0'},
        SearchData  => {
            ChangeTitle => '0',
        },
        ResultData => {
            TestExistence => 1,
        },
    },

    # Nr 19 - Description with '0'
    {
        Description => q{Description with '0'},
        SearchData  => {
            Description => '0',
        },
        ResultData => {
            TestExistence => 1,
        },
    },

    # Nr 20 - Justification with '0'
    {
        Description => q{Justification with '0'},
        SearchData  => {
            Justification => '0',
        },
        ResultData => {
            TestExistence => 1,
        },
    },

    # Nr 21 - ChangeTitle, Description, Justification with '0'
    {
        Description => q{ChangeTitle, Description, Justification with '0'},
        SearchData  => {
            ChangeTitle   => '0',
            Description   => '0',
            Justification => '0',
        },
        ResultData => {
            TestExistence => 1,
        },
    },

    # Nr 22 - ChangeStateID
    {
        Description => q{ChangeStateID},
        SearchData  => {
            ChangeStateIDs => [ $ChangeStateName2ID{requested} ],
        },
        ResultData => {
            TestExistence => 1,
        },
    },

    # Nr 23 - ChangeBuilderID
    {
        Description => q{ChangeBuilderID (two builders)},
        SearchData  => {
            ChangeBuilderIDs => [ $UserIDs[0], $UserIDs[1] ],
        },
        ResultData => {
            TestExistence => 1,
        },
    },

    # Nr 24 - ChangeManagerID
    {
        Description => q{ChangeManagerID (two manager)},
        SearchData  => {
            ChangeManagerIDs => [ $UserIDs[0], $UserIDs[1] ],
        },
        ResultData => {
            TestExistence => 1,
        },
    },

    # Nr 25 - CreateBy
    {
        Description => q{CreateBy (two creators)},
        SearchData  => {
            CreateBy => [ 1, $UserIDs[0] ],
        },
        ResultData => {
            TestExistence => 1,
        },
    },

    # Nr 26 - ChangeBy
    {
        Description => q{ChangeBy (two creators)},
        SearchData  => {
            ChangeBy => [ 1, $UserIDs[0] ],
        },
        ResultData => {
            TestExistence => 1,
        },
    },

    # Nr 27 - test changetimenewerdate and changetimeolderdate
    {
        Description => 'ChangeTimeNewerDate, ChangeTimeOlderDate',
        SearchData  => {
            ChangeTimeNewerDate => $Self->{TimeObject}->SystemTime2TimeStamp(
                SystemTime => $SystemTime - ( 60 * 60 ),
            ),
            ChangeTimeOlderDate => $Self->{TimeObject}->SystemTime2TimeStamp(
                SystemTime => $SystemTime + ( 60 * 60 ),
            ),
        },
        ResultData => {
            TestExistence => 1,
        },
    },

    # Nr 28 - ChangeStateID (same ID three times)
    {
        Description => q{ChangeStateID (same ID three times)},
        SearchData  => {
            ChangeStateIDs => [
                $ChangeStateName2ID{requested},
                $ChangeStateName2ID{requested},
                $ChangeStateName2ID{requested},
            ],
        },
        ResultData => {
            TestExistence => 1,
        },
    },

    # Nr 29 - ChangeStateID (three different IDs)
    {
        Description => q{ChangeStateID (three different IDs)},
        SearchData  => {
            ChangeStateIDs => [
                $ChangeStateName2ID{requested},
                $ChangeStateName2ID{approved},
                $ChangeStateName2ID{rejected},
            ],
        },
        ResultData => {
            TestExistence => 1,
        },
    },

    # Nr 30 - UsingWildcards => 0, ChangeTitle
    {
        Description => q{UsingWildcards => 0, ChangeTitle},
        SearchData  => {
            UsingWildcards => 0,
            ChangeTitle    => 'UnitTest-ITSMChange-%NoWildcards%',
        },
        ResultData => {
            TestCount => 1,
            Count     => 0,
        },
    },

    # Nr 31 - UsingWildcards => 0, Description
    {
        Description => q{UsingWildcards => 0, Description},
        SearchData  => {
            UsingWildcards => 0,
            Description    => 'UnitTest-ITSMChange-%NoWildcards%',
        },
        ResultData => {
            TestCount => 1,
            Count     => 0,
        },
    },

    # Nr 32 - UsingWildcards => 0, Description
    {
        Description => q{UsingWildcards => 0, Description},
        SearchData  => {
            UsingWildcards => 0,
            Description    => $NoWildcardsTestTitle,
        },
        ResultData => {
            TestCount => 1,
            Count     => 1,
        },
    },

    # Nr 33 - ChangeState (names, not IDs)
    {
        Description => q{ChangeState (names, not IDs)},
        SearchData  => {
            ChangeStates => [qw(requested)],
        },
        ResultData => {
            TestExistence => 1,
        },
    },

    # Nr 34 - ChangeState (same name three times)
    {
        Description => q{ChangeState (same name three times)},
        SearchData  => {
            ChangeStates => [qw(requested requested requested)],
        },
        ResultData => {
            TestExistence => 1,
        },
    },

    # Nr 35 - ChangeState (three different names)
    {
        Description => q{ChangeState (three different names)},
        SearchData  => {
            ChangeStates => [qw(requested approved rejected)],
        },
        ResultData => {
            TestExistence => 1,
        },
    },

    # Nr 36 - ChangeState (non-existent state)
    {
        Description => q{ChangeState (non-existent state)},
        SearchData  => {
            ChangeStates => [qw(requested approved rejected non-existent)],
        },
        SearchFails => 1,
    },

    # Nr 37 - ChangeStates (names not ids)
    {
        Description => q{ChangeStates (names not ids) - failed + requested},
        SearchData  => {
            Description  => 'ChangeStates - ' . $UniqueSignature,
            ChangeStates => [qw(requested failed)],
        },
        ResultData => {
            TestCount => 1,
        },
    },

    # Nr 38 - ChangeStates (names not ids)
    {
        Description => q{ChangeStates (names not ids) - failed},
        SearchData  => {
            Description  => 'ChangeStates - ' . $UniqueSignature,
            ChangeStates => ['failed'],
        },
        ResultData => {
            TestCount => 1,
        },
    },

    # Nr 39 - ChangeState (non-existent state only)
    {
        Description => q{ChangeState (non-existent state)},
        SearchData  => {
            ChangeStates => [qw(non-existent)],
        },
        SearchFails => 1,
    },

    # Nr 40 - Search for an invalid change state id
    {
        Description => 'Search for an invalid change state id',
        SearchData  => {
            ChangeStateIDs => [-11],
            Description    => 'ChangeStates - ' . $UniqueSignature,
        },
        SearchFails => 1,
    },

    # Nr 41 - Search for an invalid change RealizeTimeOlderDate
    {
        Description => 'Search for an invalid RealizeTime',
        SearchData  => {
            RealizeTimeOlderDate => 'anything',
        },
        SearchFails => 1,
    },

    # Nr 42 - Search for an valid change RealizeTimeOlderDate
    {
        Description => 'Search for an valid RealizeTime',
        SearchData  => {
            RealizeTimeOlderDate => '2009-10-29 13:33:33',
            Description          => 'RealizeTime - ' . $UniqueSignature,
        },
        ResultData => {
            TestCount => 1,
        },
    },

    # Nr 43 - Search for an valid change RealizeTimeNewerDate
    {
        Description => 'Search for an valid RealizeTime',
        SearchData  => {
            RealizeTimeNewerDate => '2009-10-29 13:33:33',
            Description          => 'RealizeTime - ' . $UniqueSignature,
        },
        ResultData => {
            TestCount => 1,
        },
    },

    # Nr 44 - Search for an invalid change RealizeTimeNewerDate
    {
        Description => 'Search for an invalid RealizeTime',
        SearchData  => {
            RealizeTimeNewerDate => 'anything',
        },
        SearchFails => 1,
    },

    # Nr 45 - Search for normalized title, leading whitespace
    {
        Description => 'Search for normalized title, leading whitespace',
        SearchData  => {
            ChangeTitle    => "Title with leading whitespace - " . $UniqueSignature,
            UsingWildcards => 0,
        },
        ResultData => {
            TestExistence => 1,
            TestCount     => 1,
        },
    },

    # Nr 46 - Search for normalized title, trailing whitespace
    {
        Description => 'Search for normalized title, trailing whitespace',
        SearchData  => {
            ChangeTitle    => "Title with trailing whitespace - " . $UniqueSignature,
            UsingWildcards => 0,
        },
        ResultData => {
            TestExistence => 1,
            TestCount     => 1,
        },
    },

    # Nr 47 - Search for normalized title, leading and trailing whitespace
    {
        Description => 'Search for normalized title, leading and trailing whitespace',
        SearchData  => {
            ChangeTitle    => "Title with leading and trailing whitespace - " . $UniqueSignature,
            UsingWildcards => 0,
        },
        ResultData => {
            TestExistence => 1,
            TestCount     => 1,
        },
    },
);

# get a sample change we created above for some 'special' test cases
my ($SearchTestChangeID) = @{ $Label2ChangeIDs{SearchTest} };
my $NrOfGeneralSearchTests = scalar @ChangeSearchTests;

if ($SearchTestChangeID) {
    my $SearchTestChange = $Self->{ChangeObject}->ChangeGet(
        ChangeID => $SearchTestChangeID,
        UserID   => 1,
    );

    push @ChangeSearchTests, (
        {
            Description => 'ChangeNumber',
            SearchData  => {
                ChangeNumber => $SearchTestChange->{ChangeNumber},
            },
            ResultData => {
                TestCount => 1,
                Count     => 1,
            },
        },
        {
            Description => 'ChangeNumber, PlannedStartTimeNewerDate',
            SearchData  => {
                ChangeNumber              => $SearchTestChange->{ChangeNumber},
                PlannedStartTimeNewerDate => $SearchTestChange->{PlannedStartTime},
            },
            ResultData => {
                TestCount => 1,
                Count     => 1,
            },
        },
        {
            Description => 'ChangeNumber, PlannedStartTimeOlderDate',
            SearchData  => {
                ChangeNumber              => $SearchTestChange->{ChangeNumber},
                PlannedStartTimeOlderDate => $SearchTestChange->{PlannedStartTime},
            },
            ResultData => {
                TestCount => 1,
                Count     => 1,
            },
        },
        {
            Description => 'ChangeNumber, PlannedEndTimeNewerDate',
            SearchData  => {
                ChangeNumber            => $SearchTestChange->{ChangeNumber},
                PlannedEndTimeNewerDate => $SearchTestChange->{PlannedEndTime},
            },
            ResultData => {
                TestCount => 1,
                Count     => 1,
            },
        },
        {
            Description => 'ChangeNumber, PlannedEndTimeOlderDate',
            SearchData  => {
                ChangeNumber            => $SearchTestChange->{ChangeNumber},
                PlannedEndTimeOlderDate => $SearchTestChange->{PlannedEndTime},
            },
            ResultData => {
                TestCount => 1,
                Count     => 1,
            },
        },
        {
            Description => 'ChangeNumber, PlannedEndTimeOlderDate, PlannedEndTimeNewerDate',
            SearchData  => {
                ChangeNumber            => $SearchTestChange->{ChangeNumber},
                PlannedEndTimeOlderDate => $SearchTestChange->{PlannedEndTime},
                PlannedEndTimeNewerDate => $SearchTestChange->{PlannedEndTime},
            },
            ResultData => {
                TestCount => 1,
                Count     => 1,
            },
        },
        {
            Description => 'ChangeNumber, PlannedEndTimeOlderDate, PlannedEndTimeNewerDate'
                . ', PlannedStartTimeNewerDate, PlannedStartTimeOlderDate',
            SearchData => {
                ChangeNumber              => $SearchTestChange->{ChangeNumber},
                PlannedEndTimeOlderDate   => $SearchTestChange->{PlannedEndTime},
                PlannedEndTimeNewerDate   => $SearchTestChange->{PlannedEndTime},
                PlannedStartTimeOlderDate => $SearchTestChange->{PlannedStartTime},
                PlannedStartTimeNewerDate => $SearchTestChange->{PlannedStartTime},
                PlannedStartTimeOlderDate => $SearchTestChange->{PlannedStartTime},
            },
            ResultData => {
                TestCount => 1,
                Count     => 1,
            },
        },
        {
            Description => 'ChangeNumber with wildcard',
            SearchData  => {
                ChangeNumber => substr( $SearchTestChange->{ChangeNumber}, 0, 10 ) . '%',
            },
            ResultData => {
                TestExistence => 1,
            },
        },
        {
            Description => 'ChangeNumber, ChangeTitle with wildcard',
            SearchData  => {
                ChangeNumber => substr( $SearchTestChange->{ChangeNumber}, 0, 10 ) . '%',
                ChangeTitle  => substr( $SearchTestChange->{Title},        0, 1 ) . '%',
            },
            ResultData => {
                TestExistence => 1,
            },
        },
        {
            Description => 'ChangeNumber, two creators',
            SearchData  => {
                ChangeNumber => $SearchTestChange->{ChangeNumber},
                CreateBy => [ $SearchTestChange->{CreateBy}, $SearchTestChange->{CreateBy} + 1 ],
            },
            ResultData => {
                TestCount => 1,
                Count     => 1,
            },
        },
        {
            Description => 'ChangeNumber (with wildcard), two creators',
            SearchData  => {
                ChangeNumber => substr( $SearchTestChange->{ChangeNumber}, 0, 10 ) . '%',
                CreateBy => [ $SearchTestChange->{CreateBy}, $SearchTestChange->{CreateBy} + 1 ],
            },
            ResultData => {
                TestExistence => 1,
            },
        },
        {
            Description => 'ChangeTitle, ChangeNumber, two creators',
            SearchData  => {
                ChangeNumber => $SearchTestChange->{ChangeNumber},
                CreateBy => [ $SearchTestChange->{CreateBy}, $SearchTestChange->{CreateBy} + 1 ],
                ChangeTitle => substr( $SearchTestChange->{ChangeTitle}, 0, 1 ) . '%',
            },
            ResultData => {
                TestCount => 1,
                Count     => 1,
            },
        },
        {
            Description => 'ChangeNumber, ActualEndTimeNewerDate',
            SearchData  => {
                ChangeNumber           => $SearchTestChange->{ChangeNumber},
                ActualEndTimeNewerDate => $SearchTestChange->{ActualEndTime},
            },
            ResultData => {
                TestCount => 1,
                Count     => 1,
            },
        },
        {
            Description => 'ChangeNumber, ActualEndTimeOlderDate',
            SearchData  => {
                ChangeNumber           => $SearchTestChange->{ChangeNumber},
                ActualEndTimeOlderDate => $SearchTestChange->{ActualEndTime},
            },
            ResultData => {
                TestExistence => 1,
            },
        },
        {
            Description => 'ChangeNumber, ActualEndTimeNewerDate, ActualEndTimeOlderDate',
            SearchData  => {
                ActualEndTimeNewerDate => $SearchTestChange->{ActualEndTime},
                ActualEndTimeOlderDate => $SearchTestChange->{ActualEndTime},
            },
            ResultData => {
                TestExistence => 1,
            },
        },
        {
            Description => 'ChangeNumber, ActualStartTimeNewerDate',
            SearchData  => {
                ActualStartTimeNewerDate => $SearchTestChange->{ActualStartTime},
            },
            ResultData => {
                TestExistence => 1,
            },
        },
        {
            Description => 'ChangeNumber, ActualStartTimeOlderDate',
            SearchData  => {
                ActualStartTimeOlderDate => $SearchTestChange->{ActualStartTime},
            },
            ResultData => {
                TestExistence => 1,
            },
        },
        {
            Description => 'ChangeNumber, ActualStartTimeNewerDate, ActualStartTimeOlderDate',
            SearchData  => {
                ActualStartTimeNewerDate => $SearchTestChange->{ActualStartTime},
                ActualStartTimeOlderDate => $SearchTestChange->{ActualStartTime},
            },
            ResultData => {
                TestExistence => 1,
            },
        },
    );

    my $NrOfAllSearchTests = scalar @ChangeSearchTests;

    for my $TestNumber ( ( $NrOfGeneralSearchTests + 1 ) .. $NrOfAllSearchTests ) {
        $ChangeIDForSearchTest{$TestNumber}->{ $SearchTestChange->{ChangeID} } = 1;
    }
}

my $SearchTestCount = 1;

SEARCHTEST:
for my $Test (@ChangeSearchTests) {

    # check SearchData attribute
    if ( !$Test->{SearchData} || ref( $Test->{SearchData} ) ne 'HASH' ) {

        $Self->True(
            0,
            "Test $TestCount: SearchData found for this test.",
        );

        next SEARCHTEST;
    }

    $Self->True(
        1,
        'call ChangeSearch with params: '
            . $Test->{Description}
            . " (SearchTestCase: $SearchTestCount)",
    );

    my $ChangeIDs = $Self->{ChangeObject}->ChangeSearch(
        %{ $Test->{SearchData} },
        UserID => 1,
    );

    if ( $Test->{SearchFails} ) {
        $Self->True(
            !defined($ChangeIDs),
            "Test $TestCount: ChangeSearch() is expected to fail",
        );
    }
    else {
        $Self->True(
            defined($ChangeIDs) && ref($ChangeIDs) eq 'ARRAY',
            "Test $TestCount: |- array reference for ChangeIDs.",
        );
    }

    $ChangeIDs ||= [];

    if ( $Test->{ResultData}->{TestCount} ) {

        # get number of change ids ChangeSearch should return
        my $Count = scalar keys %{ $ChangeIDForSearchTest{$SearchTestCount} };

        # get defined expected result count (defined in search test case!)
        if ( exists $Test->{ResultData}->{Count} ) {
            $Count = $Test->{ResultData}->{Count}
        }

        $Self->Is(
            scalar @{$ChangeIDs},
            $Count,
            "Test $TestCount: |- Number of found changes.",
        );
    }

    if ( $Test->{ResultData}->{TestExistence} ) {

        # check if all ids that belongs to this searchtest are returned
        my @ChangeIDs = keys %{ $ChangeIDForSearchTest{$SearchTestCount} };
        my %ReturnedChangeID = map { $_ => 1 } @{$ChangeIDs};
        for my $ChangeID (@ChangeIDs) {
            $Self->True(
                $ReturnedChangeID{$ChangeID},
                "Test $TestCount: |- ChangeID $ChangeID found in returned list.",
            );
        }
    }
}
continue {
    $TestCount++;
    $SearchTestCount++;
}

# ------------------------------------------------------------ #
# define change search tests for 'OrderBy' searches
# ------------------------------------------------------------ #

# get three change ids. Then get the data. That is needed for sorting
my @OrderBySearchTestChangeIDs = @{ $Label2ChangeIDs{OrderBySearchTest} };
my @OrderBySearchTestChanges;

for my $ChangeIDForOrderByTests (@OrderBySearchTestChangeIDs) {
    my $ChangeData = $Self->{ChangeObject}->ChangeGet(
        ChangeID => $ChangeIDForOrderByTests,
        UserID   => 1,
    );

    # convert time string to numbers - that's better for the comparisons
    for my $TimeColumn (qw(CreateTime ChangeTime)) {
        $ChangeData->{$TimeColumn} =~ s{ \D }{}xmsg;
    }

    push @OrderBySearchTestChanges, $ChangeData;
}

my @OrderByColumns = qw(
    ChangeID
    ChangeNumber
    ChangeStateID
    ChangeManagerID
    ChangeBuilderID
    CreateBy
    ChangeBy
    CreateTime
    ChangeTime
    PlannedStartTime
    PlannedEndTime
    ActualStartTime
    ActualEndTime
);

for my $OrderByColumn (@OrderByColumns) {

    # turn off all pretty print
    local $Data::Dumper::Indent = 0;
    local $Data::Dumper::Useqq  = 1;

    my @SortedChanges
        = sort {
        $a->{$OrderByColumn} <=> $b->{$OrderByColumn}
            || $b->{ChangeID} <=> $a->{ChangeID}
        } @OrderBySearchTestChanges;
    my @SortedIDs = map { $_->{ChangeID} } @SortedChanges;

    # dump the reference attribute
    my $ReferenceList = Data::Dumper::Dumper( \@SortedIDs );

    my $SearchResult = $Self->{ChangeObject}->ChangeSearch(
        ChangeTitle      => 'OrderByChange - Title - ' . $UniqueSignature,
        OrderBy          => [$OrderByColumn],
        OrderByDirection => ['Up'],
        UserID           => 1,
    );

    # dump the attribute from ChangeGet()
    my $SearchList = Data::Dumper::Dumper($SearchResult);

    $Self->Is(
        $SearchList,
        $ReferenceList,
        'Test ' . $TestCount++ . ": ChangeSearch() OrderBy $OrderByColumn (Up)."
    );

    my @SortedChangesDown
        = sort {
        $b->{$OrderByColumn} <=> $a->{$OrderByColumn}
            || $b->{ChangeID} <=> $a->{ChangeID}
        } @OrderBySearchTestChanges;
    my @SortedIDsDown = map { $_->{ChangeID} } @SortedChangesDown;

    # dump the reference attribute
    my $ReferenceListDown = Data::Dumper::Dumper( \@SortedIDsDown );

    my $SearchResultDown = $Self->{ChangeObject}->ChangeSearch(
        ChangeTitle => 'OrderByChange - Title - ' . $UniqueSignature,
        OrderBy     => [$OrderByColumn],
        UserID      => 1,
    );

    # dump the attribute from ChangeGet()
    my $SearchListDown = Data::Dumper::Dumper($SearchResultDown);

    $Self->Is(
        $SearchListDown,
        $ReferenceListDown,
        'Test ' . $TestCount++ . ": ChangeSearch() OrderBy $OrderByColumn (Down)."
    );

    # check if ITSMChange.pm handles non-existent OrderByDirection criteria correct
    my $SearchResultFooBar = $Self->{ChangeObject}->ChangeSearch(
        ChangeTitle => 'OrderByChange - Title - ' . $UniqueSignature,
        OrderBy     => [$OrderByColumn],
        OrderBy     => ['FooBar'],
        UserID      => 1,
    );

    $Self->Is(
        $SearchResultFooBar,
        undef,
        'Test ' . $TestCount++ . ": ChangeSearch() OrderBy $OrderByColumn (FooBar)."
    );
}

# create an extra block as we use "local"
{

    # check for 'OrderBy' with non-existent column
    my $SearchResultFooBarColumn = $Self->{ChangeObject}->ChangeSearch(
        ChangeTitle => 'OrderByChange - Title - ' . $UniqueSignature,
        OrderBy     => ['FooBar'],
        UserID      => 1,
    );

    $Self->Is(
        $SearchResultFooBarColumn,
        undef,
        'Test ' . $TestCount++ . ": ChangeSearch() OrderBy FooBar (Down)."
    );

    # check for 'OrderBy' with non-existent column
    my $SearchResultFooBarColumnDirection = $Self->{ChangeObject}->ChangeSearch(
        ChangeTitle      => 'OrderByChange - Title - ' . $UniqueSignature,
        OrderBy          => ['FooBar'],
        OrderByDirection => ['FooBar'],
        UserID           => 1,
    );

    $Self->Is(
        $SearchResultFooBarColumnDirection,
        undef,
        'Test ' . $TestCount++ . ": ChangeSearch() OrderBy FooBar (FooBar)."
    );

    # check for 'OrderBy' with non-existent column
    my $SearchResultFooBarDoubleColumn = $Self->{ChangeObject}->ChangeSearch(
        ChangeTitle => 'OrderByChange - Title - ' . $UniqueSignature,
        OrderBy     => [ 'ChangeID', 'ChangeID' ],
        UserID      => 1,
    );

    $Self->Is(
        $SearchResultFooBarDoubleColumn,
        undef,
        'Test ' . $TestCount++ . ": ChangeSearch() Doubled OrderBy FooBar."
    );
}

# change the create time for the second test case we defined above for the orderby tests
# we do this to have two changes with the same create time. this is needed to test
# the 'orderby' with two columns
SetTimes(
    ChangeID   => ( sort @OrderBySearchTestChangeIDs )[1],
    CreateTime => '2009-10-01 01:00:00',
);

my @ChangesForSecondOrderByTests;
for my $ChangeIDForSecondOrderByTests (@OrderBySearchTestChangeIDs) {
    my $ChangeData = $Self->{ChangeObject}->ChangeGet(
        ChangeID => $ChangeIDForSecondOrderByTests,
        UserID   => 1,
    );

    # convert time string to numbers - that's better for the comparisons
    for my $TimeColumn (qw(CreateTime ChangeTime)) {
        $ChangeData->{$TimeColumn} =~ s{ \D }{}xmsg;
    }

    push @ChangesForSecondOrderByTests, $ChangeData;
}

# create an extra block as we use "local"
{
    my @SortedChanges = sort {
        $a->{CreateTime} <=> $b->{CreateTime}       # createtime is sorted ascending
            || $a->{ChangeID} <=> $b->{ChangeID}    # changeid is sorted ascending
    } @ChangesForSecondOrderByTests;
    my @SortedIDs = map { $_->{ChangeID} } @SortedChanges;

    # turn off all pretty print
    local $Data::Dumper::Indent = 0;
    local $Data::Dumper::Useqq  = 1;

    my $SearchResult = $Self->{ChangeObject}->ChangeSearch(
        ChangeTitle      => 'OrderByChange - Title - ' . $UniqueSignature,
        OrderBy          => [ 'CreateTime', 'ChangeID' ],
        OrderByDirection => [ 'Up', 'Up' ],
        UserID           => 1,
    );

    # dump the attribute from ChangeGet()
    my $SearchList = Data::Dumper::Dumper($SearchResult);

    # dump the reference attribute
    my $ReferenceList = Data::Dumper::Dumper( \@SortedIDs );

    $Self->Is(
        $SearchList,
        $ReferenceList,
        'Test ' . $TestCount++ . ": ChangeSearch() OrderBy CreateTime (Down) and ChangeID (Up)."
    );
}

# ------------------------------------------------------------ #
# advanced search by tests for times
# ------------------------------------------------------------ #
my $TSTChangeTitle = 'TimeSearchTest - Title - ' . $UniqueSignature;
my @TSTChangeIDs;
my @TimeSearchTests = (
    {
        Description => 'Insert change with one workorder in the 11th century.',
        SourceData  => {
            ChangeAdd => {
                ChangeTitle => $TSTChangeTitle,
                UserID      => 1,
            },
            WorkOrderAdd => {
                UserID           => 1,
                PlannedStartTime => '1009-01-01 00:00:00',
                PlannedEndTime   => '1009-01-30 00:00:00',
                ActualStartTime  => '1009-01-02 00:00:00',
                ActualEndTime    => '1009-01-29 00:00:00',
            },
        },
    },
    {
        Description => 'Insert change with one workorder in the 11th century.',
        SourceData  => {
            ChangeAdd => {
                ChangeTitle => $TSTChangeTitle,
                UserID      => 1,
            },
            WorkOrderAdd => {
                UserID           => 1,
                PlannedStartTime => '1009-01-10 00:00:00',
                PlannedEndTime   => '1009-01-20 00:00:00',
                ActualStartTime  => '1009-01-11 00:00:00',
                ActualEndTime    => '1009-01-19 00:00:00',
            },
        },
    },
    {
        Description => 'Insert change with one workorder in the 11th century.',
        SourceData  => {
            ChangeAdd => {
                ChangeTitle => $TSTChangeTitle,
                UserID      => 1,
            },
            WorkOrderAdd => {
                UserID           => 1,
                PlannedStartTime => '1009-02-01 00:00:00',
                PlannedEndTime   => '1009-02-27 00:00:00',
                ActualStartTime  => '1009-02-02 00:00:00',
                ActualEndTime    => '1009-02-26 00:00:00',
            },
        },
    },
    {
        Description => 'Insert change with one workorder in the 11th century.',
        SourceData  => {
            ChangeAdd => {
                ChangeTitle => $TSTChangeTitle,
                UserID      => 1,
            },
            WorkOrderAdd => {
                UserID           => 1,
                PlannedStartTime => '1009-03-01 00:00:00',
                PlannedEndTime   => '1009-04-07 00:00:00',
                ActualStartTime  => '1009-02-20 00:00:00',
                ActualEndTime    => '1009-05-01 00:00:00',
            },
        },
    },

    #---------------------------------#
    # test for planned start time
    #---------------------------------#
    {
        Description => 'Search for PlannedStartTimeNewerDate and PlannedStartTimeOlderDate.',
        SourceData  => {
            ChangeSearch => {
                ChangeTitle               => $TSTChangeTitle,
                UserID                    => 1,
                PlannedStartTimeNewerDate => '1009-01-01 00:00:00',
                PlannedStartTimeOlderDate => '1009-01-02 00:00:00',
            },
        },
        ReferenceData => [
            0,
        ],
    },
    {
        Description => 'Search for PlannedStartTimeNewerDate and PlannedStartTimeOlderDate.',
        SourceData  => {
            ChangeSearch => {
                ChangeTitle               => $TSTChangeTitle,
                UserID                    => 1,
                PlannedStartTimeNewerDate => '1008-12-01 00:00:00',
                PlannedStartTimeOlderDate => '1008-12-31 00:00:00',
            },
        },
        ReferenceData => [],
    },
    {
        Description => 'Search for PlannedStartTimeNewerDate.',
        SourceData  => {
            ChangeSearch => {
                ChangeTitle               => $TSTChangeTitle,
                UserID                    => 1,
                PlannedStartTimeNewerDate => '1009-02-01 00:00:00',
            },
        },
        ReferenceData => [ 2, 3, ],
    },
    {
        Description => 'Search for PlannedStartTimeNewerDate.',
        SourceData  => {
            ChangeSearch => {
                ChangeTitle               => $TSTChangeTitle,
                UserID                    => 1,
                PlannedStartTimeNewerDate => '1009-12-01 00:00:00',
            },
        },
        ReferenceData => [],
    },
    {
        Description => 'Search for PlannedStartTimeOlderDate.',
        SourceData  => {
            ChangeSearch => {
                ChangeTitle               => $TSTChangeTitle,
                UserID                    => 1,
                PlannedStartTimeOlderDate => '1009-01-10 00:00:00',
            },
        },
        ReferenceData => [ 0, 1, ],
    },
    {
        Description => 'Search for PlannedStartTimeOlderDate.',
        SourceData  => {
            ChangeSearch => {
                ChangeTitle               => $TSTChangeTitle,
                UserID                    => 1,
                PlannedStartTimeOlderDate => '1008-01-31 00:00:00',
            },
        },
        ReferenceData => [],
    },
    {
        Description => 'Search for PlannedStartTimeNewerDate and PlannedStartTimeOlderDate.',
        SourceData  => {
            ChangeSearch => {
                ChangeTitle               => $TSTChangeTitle,
                UserID                    => 1,
                PlannedStartTimeNewerDate => '1009-12-01 00:00:00',
                PlannedStartTimeOlderDate => '1008-12-01 00:00:00',
            },
        },
        ReferenceData => [],
    },

    #---------------------------------#
    # test for planned end time
    #---------------------------------#
    {
        Description => 'Search for PlannedEndTimeNewerDate and PlannedEndTimeOlderDate.',
        SourceData  => {
            ChangeSearch => {
                ChangeTitle             => $TSTChangeTitle,
                UserID                  => 1,
                PlannedEndTimeNewerDate => '1009-01-30 00:00:00',
                PlannedEndTimeOlderDate => '1009-01-31 00:00:00',
            },
        },
        ReferenceData => [
            0,
        ],
    },
    {
        Description => 'Search for PlannedEndTimeNewerDate and PlannedEndTimeOlderDate.',
        SourceData  => {
            ChangeSearch => {
                ChangeTitle             => $TSTChangeTitle,
                UserID                  => 1,
                PlannedEndTimeNewerDate => '1008-12-01 00:00:00',
                PlannedEndTimeOlderDate => '1008-12-31 00:00:00',
            },
        },
        ReferenceData => [],
    },
    {
        Description => 'Search for PlannedEndTimeNewerDate.',
        SourceData  => {
            ChangeSearch => {
                ChangeTitle             => $TSTChangeTitle,
                UserID                  => 1,
                PlannedEndTimeNewerDate => '1009-02-27 00:00:00',
            },
        },
        ReferenceData => [ 2, 3, ],
    },
    {
        Description => 'Search for PlannedEndTimeNewerDate.',
        SourceData  => {
            ChangeSearch => {
                ChangeTitle             => $TSTChangeTitle,
                UserID                  => 1,
                PlannedEndTimeNewerDate => '1009-05-01 00:00:00',
            },
        },
        ReferenceData => [],
    },
    {
        Description => 'Search for PlannedEndTimeOlderDate.',
        SourceData  => {
            ChangeSearch => {
                ChangeTitle             => $TSTChangeTitle,
                UserID                  => 1,
                PlannedEndTimeOlderDate => '1009-01-25 00:00:00',
            },
        },
        ReferenceData => [ 1, ],
    },
    {
        Description => 'Search for PlannedEndTimeOlderDate.',
        SourceData  => {
            ChangeSearch => {
                ChangeTitle             => $TSTChangeTitle,
                UserID                  => 1,
                PlannedEndTimeOlderDate => '1008-01-31 00:00:00',
            },
        },
        ReferenceData => [],
    },
    {
        Description => 'Search for PlannedEndTimeNewerDate and PlannedEndTimeOlderDate.',
        SourceData  => {
            ChangeSearch => {
                ChangeTitle             => $TSTChangeTitle,
                UserID                  => 1,
                PlannedEndTimeNewerDate => '1009-05-01 00:00:00',
                PlannedEndTimeOlderDate => '1008-12-01 00:00:00',
            },
        },
        ReferenceData => [],
    },

    #---------------------------------#
    # test for actual start time
    #---------------------------------#
    {
        Description => 'Search for ActualStartTimeNewerDate and ActualStartTimeOlderDate.',
        SourceData  => {
            ChangeSearch => {
                ChangeTitle              => $TSTChangeTitle,
                UserID                   => 1,
                ActualStartTimeNewerDate => '1009-01-02 00:00:00',
                ActualStartTimeOlderDate => '1009-01-02 00:00:00',
            },
        },
        ReferenceData => [
            0,
        ],
    },
    {
        Description => 'Search for ActualStartTimeNewerDate and ActualStartTimeOlderDate.',
        SourceData  => {
            ChangeSearch => {
                ChangeTitle              => $TSTChangeTitle,
                UserID                   => 1,
                ActualStartTimeNewerDate => '1008-12-01 00:00:00',
                ActualStartTimeOlderDate => '1008-12-31 00:00:00',
            },
        },
        ReferenceData => [],
    },
    {
        Description => 'Search for ActualStartTimeNewerDate.',
        SourceData  => {
            ChangeSearch => {
                ChangeTitle              => $TSTChangeTitle,
                UserID                   => 1,
                ActualStartTimeNewerDate => '1009-02-01 00:00:00',
            },
        },
        ReferenceData => [ 2, 3, ],
    },
    {
        Description => 'Search for ActualStartTimeNewerDate.',
        SourceData  => {
            ChangeSearch => {
                ChangeTitle              => $TSTChangeTitle,
                UserID                   => 1,
                ActualStartTimeNewerDate => '1009-12-30 00:00:00',
            },
        },
        ReferenceData => [],
    },
    {
        Description => 'Search for ActualStartTimeOlderDate.',
        SourceData  => {
            ChangeSearch => {
                ChangeTitle              => $TSTChangeTitle,
                UserID                   => 1,
                ActualStartTimeOlderDate => '1009-01-12 00:00:00',
            },
        },
        ReferenceData => [ 0, 1, ],
    },
    {
        Description => 'Search for ActualStartTimeOlderDate.',
        SourceData  => {
            ChangeSearch => {
                ChangeTitle              => $TSTChangeTitle,
                UserID                   => 1,
                ActualStartTimeOlderDate => '1008-01-31 00:00:00',
            },
        },
        ReferenceData => [],
    },
    {
        Description => 'Search for ActualStartTimeNewerDate and ActualStartTimeOlderDate.',
        SourceData  => {
            ChangeSearch => {
                ChangeTitle              => $TSTChangeTitle,
                UserID                   => 1,
                ActualStartTimeNewerDate => '1009-12-01 00:00:00',
                ActualStartTimeOlderDate => '1008-12-01 00:00:00',
            },
        },
        ReferenceData => [],
    },

    #---------------------------------#
    # test for actual end time
    #---------------------------------#
    {
        Description => 'Search for ActualEndTimeNewerDate and ActualEndTimeOlderDate.',
        SourceData  => {
            ChangeSearch => {
                ChangeTitle            => $TSTChangeTitle,
                UserID                 => 1,
                ActualEndTimeNewerDate => '1009-01-28 00:00:00',
                ActualEndTimeOlderDate => '1009-01-29 00:00:00',
            },
        },
        ReferenceData => [
            0,
        ],
    },
    {
        Description => 'Search for ActualEndTimeNewerDate and ActualEndTimeOlderDate.',
        SourceData  => {
            ChangeSearch => {
                ChangeTitle            => $TSTChangeTitle,
                UserID                 => 1,
                ActualEndTimeNewerDate => '1008-12-01 00:00:00',
                ActualEndTimeOlderDate => '1008-12-31 00:00:00',
            },
        },
        ReferenceData => [],
    },
    {
        Description => 'Search for ActualEndTimeNewerDate.',
        SourceData  => {
            ChangeSearch => {
                ChangeTitle            => $TSTChangeTitle,
                UserID                 => 1,
                ActualEndTimeNewerDate => '1009-02-26 00:00:00',
            },
        },
        ReferenceData => [ 2, 3, ],
    },
    {
        Description => 'Search for ActualEndTimeNewerDate.',
        SourceData  => {
            ChangeSearch => {
                ChangeTitle            => $TSTChangeTitle,
                UserID                 => 1,
                ActualEndTimeNewerDate => '1009-12-01 00:00:00',
            },
        },
        ReferenceData => [],
    },
    {
        Description => 'Search for ActualEndTimeOlderDate.',
        SourceData  => {
            ChangeSearch => {
                ChangeTitle            => $TSTChangeTitle,
                UserID                 => 1,
                ActualEndTimeOlderDate => '1009-01-29 00:00:00',
            },
        },
        ReferenceData => [ 0, 1, ],
    },
    {
        Description => 'Search for ActualEndTimeOlderDate.',
        SourceData  => {
            ChangeSearch => {
                ChangeTitle            => $TSTChangeTitle,
                UserID                 => 1,
                ActualEndTimeOlderDate => '1008-12-01 00:00:00',
            },
        },
        ReferenceData => [],
    },
    {
        Description => 'Search for ActualEndTimeNewerDate and ActualEndTimeOlderDate.',
        SourceData  => {
            ChangeSearch => {
                ChangeTitle            => $TSTChangeTitle,
                UserID                 => 1,
                ActualEndTimeNewerDate => '1009-12-01 00:00:00',
                ActualEndTimeOlderDate => '1008-12-31 00:00:00',
            },
        },
        ReferenceData => [],
    },

);

my $TSTCounter = 1;
my @TSTWorkOrderIDs;
TSTEST:
for my $Test (@TimeSearchTests) {
    my $SourceData    = $Test->{SourceData};
    my $ReferenceData = $Test->{ReferenceData};

    my $ChangeID;
    my $WorkOrderID;

    $Self->True(
        1,
        "Test $TestCount: $Test->{Description} (TSTest case: $TSTCounter)",
    );

    if ( $SourceData->{ChangeAdd} ) {
        $ChangeID = $Self->{ChangeObject}->ChangeAdd(
            %{ $SourceData->{ChangeAdd} },
        );

        $Self->True(
            $ChangeID,
            "Test $TestCount: |- ChangeAdd",
        );

        if ($ChangeID) {
            $TestedChangeID{$ChangeID} = 1;
            push @TSTChangeIDs, $ChangeID;
        }
    }

    if ( $SourceData->{WorkOrderAdd} ) {
        $WorkOrderID = $Self->{WorkOrderObject}->WorkOrderAdd(
            %{ $SourceData->{WorkOrderAdd} },
            ChangeID => $ChangeID,
        );

        $Self->True(
            $WorkOrderID,
            "Test $TestCount: |- WorkOrderAdd",
        );

        push @TSTWorkOrderIDs, $WorkOrderID;
    }

    my $SearchResult;
    if ( $SourceData->{ChangeSearch} ) {
        $SearchResult = $Self->{ChangeObject}->ChangeSearch(
            %{ $SourceData->{ChangeSearch} },
        );

        $Self->True(
            $SearchResult && ref $SearchResult eq 'ARRAY',
            "Test $TestCount: ChangeSearch() - List is an array reference.",
        );

        next TSTEST if !$SearchResult;

        # check number of founded change
        $Self->Is(
            scalar @{$SearchResult},
            scalar @{$ReferenceData},
            "Test $TestCount: ChangeSearch() - correct number of found changes",
        );

        # map array index to ChangeID
        my @ResultChangeIDs;
        for my $ResultChangeID ( @{$ReferenceData} ) {
            push @ResultChangeIDs, $TSTChangeIDs[$ResultChangeID];
        }

        # turn off all pretty print
        local $Data::Dumper::Indent = 0;
        local $Data::Dumper::Useqq  = 1;

        # dump the attribute from ChangeSearch()
        my $SearchResultDump = Data::Dumper::Dumper( sort @{$SearchResult} );

        # dump the reference attribute
        my $ReferenceDump
            = Data::Dumper::Dumper( sort @ResultChangeIDs );

        $Self->Is(
            $SearchResultDump,
            $ReferenceDump,
            "Test $TestCount: |- ChangeSearch(): "
                . Data::Dumper::Dumper( $SourceData->{ChangeSearch} )
                . $SearchResultDump,
        );
    }

    $TestCount++;
    $TSTCounter++;
}

# ------------------------------------------------------------ #
# advanced search by tests for strings
# ------------------------------------------------------------ #
my @StringSearchTests = (

    {
        Description => 'Insert change with one workorder and with set string fields.',
        SourceData  => {
            ChangeAdd => {
                UserID => 1,
            },
            WorkOrderAdd => {
                UserID         => 1,
                WorkOrderTitle => 'String Test 1 - Title - ' . $UniqueSignature,
                Instruction    => 'String Test 1 - Instruction - ' . $UniqueSignature,
                Report         => 'String Test 1 - Report - ' . $UniqueSignature,
            },
        },
    },

    {
        Description => 'Search for WorkOrderTitle',
        SourceData  => {
            ChangeSearch => {
                UserID         => 1,
                WorkOrderTitle => 'String Test 1 - Title - ' . $UniqueSignature,
            },
        },
        ReferenceData => [0],
    },

    {
        Description => 'Search for non-existing WorkOrderTitle',
        SourceData  => {
            ChangeSearch => {
                UserID         => 1,
                WorkOrderTitle => 'NONEXISTENT String Test 1 - Title - ' . $UniqueSignature,
            },
        },
        ReferenceData => [],
    },

    {
        Description => 'Search for WorkOrder Instruction',
        SourceData  => {
            ChangeSearch => {
                UserID               => 1,
                WorkOrderInstruction => 'String Test 1 - Instruction - ' . $UniqueSignature,
            },
        },
        ReferenceData => [0],
    },

    {
        Description => 'Search for non-existing WorkOrder Instruction',
        SourceData  => {
            ChangeSearch => {
                UserID               => 1,
                WorkOrderInstruction => 'NONEXISTENT String Test 1 - Instruction - '
                    . $UniqueSignature,
            },
        },
        ReferenceData => [],
    },

    {
        Description => 'Search for WorkOrder Report',
        SourceData  => {
            ChangeSearch => {
                UserID          => 1,
                WorkOrderReport => 'String Test 1 - Report - ' . $UniqueSignature,
            },
        },
        ReferenceData => [0],
    },

    {
        Description => 'Search for non-existing WorkOrder Report',
        SourceData  => {
            ChangeSearch => {
                UserID          => 1,
                WorkOrderReport => 'NONEXISTENT String Test 1 - Report - ' . $UniqueSignature,
            },
        },
        ReferenceData => [],
    },
);

my $SSTCounter = 1;
my @SSTChangeIDs;       # string search test change ids
my @SSTWorkOrderIDs;    # string search test workorder ids
SSTEST:
for my $Test (@StringSearchTests) {
    my $SourceData    = $Test->{SourceData};
    my $ReferenceData = $Test->{ReferenceData};

    my $ChangeID;
    my $WorkOrderID;

    $Self->True(
        1,
        "Test $TestCount: $Test->{Description} (SSTest case: $SSTCounter)",
    );

    if ( $SourceData->{ChangeAdd} ) {
        $ChangeID = $Self->{ChangeObject}->ChangeAdd(
            %{ $SourceData->{ChangeAdd} },
        );

        $Self->True(
            $ChangeID,
            "Test $TestCount: |- ChangeAdd",
        );

        if ($ChangeID) {
            $TestedChangeID{$ChangeID} = 1;
            push @SSTChangeIDs, $ChangeID;
        }
    }

    if ( $SourceData->{WorkOrderAdd} ) {
        $WorkOrderID = $Self->{WorkOrderObject}->WorkOrderAdd(
            %{ $SourceData->{WorkOrderAdd} },
            ChangeID => $ChangeID,
        );

        $Self->True(
            $WorkOrderID,
            "Test $TestCount: |- WorkOrderAdd",
        );

        push @SSTWorkOrderIDs, $WorkOrderID;
    }

    my $SearchResult;
    if ( $SourceData->{ChangeSearch} ) {
        $SearchResult = $Self->{ChangeObject}->ChangeSearch(
            %{ $SourceData->{ChangeSearch} },
        );

        $Self->True(
            $SearchResult && ref $SearchResult eq 'ARRAY',
            "Test $TestCount: ChangeSearch() - List is an array reference.",
        );

        next SSTEST if !$SearchResult;

        # check number of founded change
        $Self->Is(
            scalar @{$SearchResult},
            scalar @{$ReferenceData},
            "Test $TestCount: ChangeSearch() - correct number of found changes",
        );

        # map array index to ChangeID
        my @ResultChangeIDs;
        for my $ResultChangeID ( @{$ReferenceData} ) {
            push @ResultChangeIDs, $SSTChangeIDs[$ResultChangeID];
        }

        # turn off all pretty print
        local $Data::Dumper::Indent = 0;
        local $Data::Dumper::Useqq  = 1;

        # dump the attribute from ChangeSearch()
        my $SearchResultDump = Data::Dumper::Dumper( sort @{$SearchResult} );

        # dump the reference attribute
        my $ReferenceDump
            = Data::Dumper::Dumper( sort @ResultChangeIDs );

        $Self->Is(
            $SearchResultDump,
            $ReferenceDump,
            "Test $TestCount: |- ChangeSearch(): "
                . Data::Dumper::Dumper( $SourceData->{ChangeSearch} )
                . $SearchResultDump,
        );
    }

    $TestCount++;
    $SSTCounter++;
}

# ------------------------------------------------------------ #
# testing the method Permission()
# ------------------------------------------------------------ #

my ($PermissionTestChangeID) = @{ $Label2ChangeIDs{PermissionTest} };
my @PermissionTests = (

    # Permission test No. 1
    {
        Description => 'Initially no priv in any group',
        SourceData  => {
        },
        ReferenceData => {
            Permissions => {
                0 => { ro => 0, rw => 0 },
                1 => { ro => 0, rw => 0 },
            },
        },
    },

    # Permission test No. 2
    {
        Description => 'ro in itsm-change',
        SourceData  => {
            GroupMemberAdd => [
                {
                    GID        => $GroupName2ID{'itsm-change'},
                    UID        => $UserIDs[0],
                    Permission => { ro => 1, rw => 0, },
                },
            ],
        },
        ReferenceData => {
            Permissions => {
                0 => { ro => 1, rw => 0, },
                1 => { ro => 0, rw => 0, },
            },
        },
    },

    # Permission test No. 3
    {

        # The type 'rw' implies all other types. See Kernel::System::Group_GetTypeString()
        # Therefore User1 effectively has 'ro' in 'itsm-change' and
        # the ChangeAgentCheck Permission module gives 'ro' access.
        # Note that the ChangeAgentCheck Permission module never gives 'rw' access.
        Description => 'rw in itsm-change only grants ro',
        SourceData  => {
            GroupMemberAdd => [
                {
                    GID        => $GroupName2ID{'itsm-change'},
                    UID        => $UserIDs[0],
                    Permission => { ro => 0, rw => 1, },
                },
            ],
        },
        ReferenceData => {
            Permissions => {
                0 => { ro => 1, rw => 0, },
                1 => { ro => 0, rw => 0, },
            },
        },
    },

    # Permission test No. 4
    {
        Description => 'ro in itsm-change-manager',
        SourceData  => {
            GroupMemberAdd => [
                {
                    GID        => $GroupName2ID{'itsm-change'},
                    UID        => $UserIDs[0],
                    Permission => { ro => 0, rw => 0, },
                },
                {
                    GID        => $GroupName2ID{'itsm-change-manager'},
                    UID        => $UserIDs[0],
                    Permission => { ro => 1, rw => 0, },
                },
            ],
        },
        ReferenceData => {
            Permissions => {
                0 => { ro => 1, rw => 0, },
                1 => { ro => 0, rw => 0, },
            },
        },
    },

    # Permission test No. 5
    {
        Description => 'rw in itsm-change-manager',
        SourceData  => {
            GroupMemberAdd => [
                {
                    GID        => $GroupName2ID{'itsm-change'},
                    UID        => $UserIDs[0],
                    Permission => { ro => 0, rw => 0, },
                },
                {
                    GID        => $GroupName2ID{'itsm-change-manager'},
                    UID        => $UserIDs[0],
                    Permission => { ro => 1, rw => 1, },
                },
            ],
        },
        ReferenceData => {
            Permissions => {
                0 => { ro => 1, rw => 1, },
                1 => { ro => 0, rw => 0, },
            },
        },
    },

    # Permission test No. 6
    {
        Description => 'ro in itsm-change-builder, User 0 is the builder',
        SourceData  => {
            GroupMemberAdd => [
                {
                    GID        => $GroupName2ID{'itsm-change'},
                    UID        => $UserIDs[0],
                    Permission => { ro => 0, rw => 0, },
                },
                {
                    GID        => $GroupName2ID{'itsm-change-manager'},
                    UID        => $UserIDs[0],
                    Permission => { ro => 0, rw => 0, },
                },
                {
                    GID        => $GroupName2ID{'itsm-change-builder'},
                    UID        => $UserIDs[0],
                    Permission => { ro => 1, rw => 0, },
                },
            ],
        },
        ReferenceData => {
            Permissions => {
                0 => { ro => 1, rw => 0, },
                1 => { ro => 0, rw => 0, },
            },
        },
    },

    # Permission test No. 7
    {
        Description => 'rw in itsm-change-builder, Agent is the builder',
        SourceData  => {
            GroupMemberAdd => [
                {
                    GID        => $GroupName2ID{'itsm-change'},
                    UID        => $UserIDs[0],
                    Permission => { ro => 0, rw => 0, },
                },
                {
                    GID        => $GroupName2ID{'itsm-change-manager'},
                    UID        => $UserIDs[0],
                    Permission => { ro => 0, rw => 0, },
                },
                {
                    GID        => $GroupName2ID{'itsm-change-builder'},
                    UID        => $UserIDs[0],
                    Permission => { ro => 0, rw => 1, },
                },
            ],
        },
        ReferenceData => {
            Permissions => {
                0 => { ro => 1, rw => 1, },
                1 => { ro => 0, rw => 0, },
            },
        },
    },

    # Permission test No. 8
    {
        Description => q{ro in itsm-change-builder, user 1 isn't the builder},
        SourceData  => {
            GroupMemberAdd => [
                {
                    GID        => $GroupName2ID{'itsm-change'},
                    UID        => $UserIDs[0],
                    Permission => { ro => 0, rw => 0, },
                },
                {
                    GID        => $GroupName2ID{'itsm-change-manager'},
                    UID        => $UserIDs[0],
                    Permission => { ro => 0, rw => 0, },
                },
                {
                    GID        => $GroupName2ID{'itsm-change-builder'},
                    UID        => $UserIDs[0],
                    Permission => { ro => 0, rw => 0, },
                },
                {
                    GID        => $GroupName2ID{'itsm-change-builder'},
                    UID        => $UserIDs[1],
                    Permission => { ro => 1, rw => 0, },
                },
            ],
        },
        ReferenceData => {
            Permissions => {
                0 => { ro => 0, rw => 0, },
                1 => { ro => 0, rw => 0, },
            },
        },
    },

    # Permission test No. 9
    {
        Description => q{rw in itsm-change-builder, user 1 isn't the builder},
        SourceData  => {
            GroupMemberAdd => [
                {
                    GID        => $GroupName2ID{'itsm-change'},
                    UID        => $UserIDs[0],
                    Permission => { ro => 0, rw => 0, },
                },
                {
                    GID        => $GroupName2ID{'itsm-change-manager'},
                    UID        => $UserIDs[0],
                    Permission => { ro => 0, rw => 0, },
                },
                {
                    GID        => $GroupName2ID{'itsm-change-builder'},
                    UID        => $UserIDs[0],
                    Permission => { ro => 0, rw => 0, },
                },
                {
                    GID        => $GroupName2ID{'itsm-change-builder'},
                    UID        => $UserIDs[1],
                    Permission => { ro => 0, rw => 0, },
                },
            ],
        },
        ReferenceData => {
            Permissions => {
                0 => { ro => 0, rw => 0, },
                1 => { ro => 0, rw => 0, },
            },
        },
    },

);

my $PermissionTestCounter = 1;
for my $Test (@PermissionTests) {
    my $SourceData    = $Test->{SourceData};
    my $ReferenceData = $Test->{ReferenceData};

    $Self->True(
        1,
        "Test $TestCount: $Test->{Description} (Permission Test case: $PermissionTestCounter)",
    );

    # execute the source modifications
    $SourceData->{GroupMemberAdd} ||= [];
    for my $Params ( @{ $SourceData->{GroupMemberAdd} } ) {

        # modify the group membership
        my $Success = $Self->{GroupObject}->GroupMemberAdd(
            %{$Params},
            UserID => 1,
        );
        $Self->True( $Success, "Permission test $PermissionTestCounter: GroupMemberAdd()", );
    }

    # check the result
    if ( $ReferenceData->{Permissions} ) {
        for my $UserIndex ( sort keys %{ $ReferenceData->{Permissions} } ) {
            my $Privs = $ReferenceData->{Permissions}->{$UserIndex};
            for my $Type ( keys %{$Privs} ) {
                $Self->{ChangeObject}->{Debug} = 10;
                my $Access = $Self->{ChangeObject}->Permission(
                    Type     => $Type,
                    ChangeID => $PermissionTestChangeID,
                    UserID   => $UserIDs[$UserIndex],
                    Cached   => 0,
                );
                if ( $Privs->{$Type} ) {
                    $Self->True(
                        $Access,
                        "Permission test $PermissionTestCounter: User $UserIndex, with UserUD $UserIDs[$UserIndex], has $Type access",
                    );
                }
                else {
                    $Self->False(
                        $Access,
                        "Permission test $PermissionTestCounter: User $UserIndex, with UserID $UserIDs[$UserIndex], has no $Type access",
                    );
                }
            }
        }
    }
}
continue {
    $PermissionTestCounter++;
    $TestCount++;
}

# ------------------------------------------------------------ #
# clean the system
# ------------------------------------------------------------ #

# disable email checks to change the newly added users
$CheckEmailAddressesOrg = $Self->{ConfigObject}->Get('CheckEmailAddresses') || 1;
$Self->{ConfigObject}->Set(
    Key   => 'CheckEmailAddresses',
    Value => 0,
);

# set unittest users invalid
for my $UnittestUserID (@UserIDs) {

    # get user data
    my %User = $Self->{UserObject}->GetUserData(
        UserID => $UnittestUserID,
    );

    # update user
    $Self->{UserObject}->UserUpdate(
        %User,
        ValidID => $Self->{ValidObject}->ValidLookup( Valid => 'invalid' ),
        ChangeUserID => 1,
    );
}

# restore original email check param
$Self->{ConfigObject}->Set(
    Key   => 'CheckEmailAddresses',
    Value => $CheckEmailAddressesOrg,
);

# delete the test changes
for my $ChangeID ( keys %TestedChangeID ) {
    $Self->True(
        $Self->{ChangeObject}->ChangeDelete(
            ChangeID => $ChangeID,
            UserID   => 1,
        ),
        "Test $TestCount: ChangeDelete()",
    );

    # double check if change is really deleted
    my $ChangeData = $Self->{ChangeObject}->ChangeGet(
        ChangeID => $ChangeID,
        UserID   => 1,
    );

    $Self->Is(
        undef,
        $ChangeData->{ChangeID},
        "Test $TestCount: ChangeDelete() - double check",
    );
}
continue {
    $TestCount++;
}

=over 4

=item SetTimes()

Set new values for CreateTime and ChangeTime for a given ChangeID.

    my $UpdateSuccess = SetTimes(
        ChangeID => 123,
        CreateTime => '2009-10-30 01:00:15',
        ChangeTime => '2009-10-30 01:00:15',
    );

=back

=cut

sub SetTimes {
    my (%Param) = @_;

    # check change id
    if ( !$Param{ChangeID} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need ChangeID!',
        );
        return;
    }

    # check parameters
    if ( !$Param{CreateTime} && !$Param{ChangeTime} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need parameter CreateTime or ChangeTime!',
        );
        return;
    }

    my @Bind;
    my $SQL = 'UPDATE change_item SET ';

    if ( $Param{CreateTime} ) {
        $SQL .= 'create_time = ? ';
        push @Bind, \$Param{CreateTime};
    }

    if ( $Param{CreateTime} && $Param{ChangeTime} ) {
        $SQL .= ', ';
    }

    if ( $Param{ChangeTime} ) {
        $SQL .= 'change_time = ? ';
        push @Bind, \$Param{ChangeTime};
    }

    $SQL .= 'WHERE id = ? ';
    push @Bind, \$Param{ChangeID};

    return if !$Self->{DBObject}->Do(
        SQL  => $SQL,
        Bind => \@Bind,
    );
    return 1;
}

1;
