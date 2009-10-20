# --
# ITSMWorkOrder.t - workorder tests
# Copyright (C) 2003-2009 OTRS AG, http://otrs.com/
# --
# $Id: ITSMWorkOrder.t,v 1.57 2009-10-20 09:17:22 reb Exp $
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
use Kernel::System::GeneralCatalog;
use Kernel::System::ITSMChange;
use Kernel::System::ITSMChange::WorkOrder;

# ------------------------------------------------------------ #
# make preparations
# ------------------------------------------------------------ #
my $TestCount = 1;

# create common objects
$Self->{GeneralCatalogObject} = Kernel::System::GeneralCatalog->new( %{$Self} );
$Self->{UserObject}           = Kernel::System::User->new( %{$Self} );
$Self->{ChangeObject}         = Kernel::System::ITSMChange->new( %{$Self} );
$Self->{WorkOrderObject}      = Kernel::System::ITSMChange::WorkOrder->new( %{$Self} );

# test if workorder object was created successfully
$Self->True(
    $Self->{WorkOrderObject},
    "Test " . $TestCount++ . ' - construction of workorder object'
);
$Self->Is(
    ref $Self->{WorkOrderObject},
    'Kernel::System::ITSMChange::WorkOrder',
    "Test " . $TestCount++ . ' - class of workorder object'
);

# create needed users
my @UserIDs;               # a list of existing and valid user ids
my @InvalidUserIDs;        # a list of existing but invalid user ids
my @NonExistingUserIDs;    # a list of non-existion user ids

# disable email checks to create new user
my $CheckEmailAddressesOrg = $Self->{ConfigObject}->Get('CheckEmailAddresses') || 1;
$Self->{ConfigObject}->Set(
    Key   => 'CheckEmailAddresses',
    Value => 0,
);

for my $Counter ( 1 .. 3 ) {

    # create new users for the tests
    my $UserID = $Self->{UserObject}->UserAdd(
        UserFirstname => 'ITSMChange::Workorder' . $Counter,
        UserLastname  => 'UnitTest',
        UserLogin     => 'UnitTest-ITSMChange::Workorder-' . $Counter . int rand 1_000_000,
        UserEmail     => 'UnitTest-ITSMChange::Workorder-' . $Counter . '@localhost',
        ValidID       => 1,
        ChangeUserID  => 1,
    );
    push @UserIDs, $UserID;
}

# sort the user and customer user arrays
@UserIDs = sort @UserIDs;

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
    ValidID => $Self->{ChangeObject}->{ValidObject}->ValidLookup(
        Valid => 'invalid',
    ),
    ChangeUserID => 1,
);
push @InvalidUserIDs, pop @UserIDs;

# restore original email check param
$Self->{ConfigObject}->Set(
    Key   => 'CheckEmailAddresses',
    Value => $CheckEmailAddressesOrg,
);

# ------------------------------------------------------------ #
# test WorkOrder API
# ------------------------------------------------------------ #

# define public interface (in alphabetical order)
my @ObjectMethods = qw(
    WorkOrderAdd
    WorkOrderChangeTimeGet
    WorkOrderDelete
    WorkOrderGet
    WorkOrderList
    WorkOrderSearch
    WorkOrderUpdate
);

# check if subs are available
for my $ObjectMethod (@ObjectMethods) {
    $Self->True(
        $Self->{WorkOrderObject}->can($ObjectMethod),
        "Test " . $TestCount++ . " - check 'can $ObjectMethod'"
    );
}

# ------------------------------------------------------------ #
# search for default ITSMWorkOrder States
# ------------------------------------------------------------ #
# define default ITSMWorkOrder States
# can't use qw due to spaces in states
my @DefaultWorkOrderStates = (
    'accepted',
    'ready',
    'in progress',
    'closed',
    'canceled',
);

# get class list with swapped keys and values
my %ReverseStatesList = reverse %{
    $Self->{GeneralCatalogObject}->ItemList(
        Class => 'ITSM::ChangeManagement::WorkOrder::State',
        ) || {}
    };

# check if states are in GeneralCatalog
for my $DefaultWorkOrderState (@DefaultWorkOrderStates) {
    $Self->True(
        $ReverseStatesList{$DefaultWorkOrderState},
        "Test " . $TestCount++ . " - check state '$DefaultWorkOrderState'"
    );
}

# ------------------------------------------------------------ #
# search for default ITSMWorkOrder-types
# ------------------------------------------------------------ #
# define default ITSMWorkOrder-states
# can't use qw due to spaces in states
my @DefaultWorkOrderTypes = (
    'approval',
    'workorder',
    'backout',
    'decision',
    'pir',
);

# get class list with swapped keys and values
my %ReverseTypesList = reverse %{
    $Self->{GeneralCatalogObject}->ItemList(
        Class => 'ITSM::ChangeManagement::WorkOrder::Type',
        ) || {}
    };

# check if states are in GeneralCatalog
for my $DefaultWorkOrderType (@DefaultWorkOrderTypes) {
    $Self->True(
        $ReverseTypesList{$DefaultWorkOrderType},
        "Test " . $TestCount++ . " - check type '$DefaultWorkOrderType'"
    );
}

# ------------------------------------------------------------ #
# Define the changes that are needed for testing workorders
# ------------------------------------------------------------ #

# store current TestCount for better test case recognition
my $TestCountMisc   = $TestCount;
my $UniqueSignature = 'UnitTest-ITSMChange::WorkOrder-' . int( rand 1_000_000 ) . '_' . time;
my @ChangeTests     = (

    # change contains all data - (all attributes)
    {
        Description => 'First change for general testing of workorders.',
        SourceData  => {
            ChangeAdd => {
                Title  => 'Change 1 - Title - ' . $UniqueSignature,
                UserID => $UserIDs[0],
            },
        },
        ReferenceData => {
            ChangeGet => {
                Title => 'Change 1 - Title - ' . $UniqueSignature,
            },
        },
    },
);

# ------------------------------------------------------------ #
# Create the changes that are needed for testing workorders
# ------------------------------------------------------------ #

# change ids of created changes
my %TestedChangeID;

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

    # add a new change
    if ( $SourceData->{ChangeAdd} ) {

        # add the change
        $ChangeID = $Self->{ChangeObject}->ChangeAdd(
            %{ $SourceData->{ChangeAdd} }
        );

        # remember current ChangeID
        if ($ChangeID) {
            $TestedChangeID{$ChangeID} = 1;
        }

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
    }    # end if 'ChangeAdd'

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
        for my $ChangeAttributes (
            qw(ChangeID ChangeNumber ChangeBuilderID CreateTime ChangeTime)
            )
        {
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
                "Test $TestCount: |- $ReferenceAttribute",
            );
        }
    }    # end if 'ChangeGet'
}
continue {

    # increase the test count, even on next
    $TestCount++;
}

# ------------------------------------------------------------ #
# Define the workorder tests
# ------------------------------------------------------------ #
my @WorkOrderTests;

my ( $WorkOrderAddTestID, $TimesTestID ) = keys %TestedChangeID;

# tests with only WorkOrderAdd();
push @WorkOrderTests, (

    # Tests where the workorder doesn't contain all data (required attributes)
    {
        Description => 'Test contains no params for WorkOrderAdd().',
        Fails       => 1,                                              # we expect this test to fail
        SourceData  => {
            WorkOrderAdd => {},    # UserID and ChangeID are missing
        },
        ReferenceData => {
            WorkOrderGet => undef,
        },
    },
    {
        Description => 'Test contains no UserID for WorkOrderAdd().',
        Fails       => 1,                                              # we expect this test to fail
        SourceData  => {
            WorkOrderAdd => {                                          # UserID is missing
                ChangeID => $WorkOrderAddTestID,
            },
        },
        ReferenceData => {
            WorkOrderGet => undef,
        },
    },
    {
        Description => 'Test contains no ChangeID for WorkOrderAdd().',
        Fails       => 1,                                              # we expect this test to fail
        SourceData  => {
            WorkOrderAdd => {                                          # ChangeID is missing
                UserID => 1,
            },
        },
        ReferenceData => {
            WorkOrderGet => undef,
        },
    },

    # First test of WorkOrderAdd() with all required arguments.
    {
        Description => 'Test contains ChangeID and ChangeID for WorkOrderAdd().',
        SourceData  => {
            WorkOrderAdd => {
                UserID   => 1,
                ChangeID => $WorkOrderAddTestID,
            },
        },
        ReferenceData => {
            WorkOrderGet => {
                ChangeID => $WorkOrderAddTestID,
            },
        },
        SearchTest => [ 2, 8 ],
    },

    # First test of WorkOrderAdd() with all required arguments, not UserID => 1.
    {
        Description =>
            'Test contains ChangeID and ChangeID for WorkOrderAdd(), other user than UserID => 1.',
        SourceData => {
            WorkOrderAdd => {
                UserID   => $UserIDs[0],
                ChangeID => $WorkOrderAddTestID,
            },
        },
        ReferenceData => {
            WorkOrderGet => {
                ChangeID => $WorkOrderAddTestID,
                CreateBy => $UserIDs[0],
                ChangeBy => $UserIDs[0]
            },
        },
        SearchTest => [ 2, 8 ],
    },

    {
        Description => 'WorkOrderAdd() with string parameters.',
        SourceData  => {
            WorkOrderAdd => {
                UserID      => 1,
                ChangeID    => $WorkOrderAddTestID,
                Title       => 'WorkOrder 1 - Title - ' . $UniqueSignature,
                Instruction => 'WorkOrder 1 - Instruction - ' . $UniqueSignature,
                Report      => 'WorkOrder 1 - Report - ' . $UniqueSignature,
            },
        },
        ReferenceData => {
            WorkOrderGet => {
                ChangeID    => $WorkOrderAddTestID,
                Title       => 'WorkOrder 1 - Title - ' . $UniqueSignature,
                Instruction => 'WorkOrder 1 - Instruction - ' . $UniqueSignature,
                Report      => 'WorkOrder 1 - Report - ' . $UniqueSignature,
            },
        },
        SearchTest => [ 2, 3, 4, 5, 6, 8, 11 ],
    },

    # TODO:
    # Add somewhere some test cases for WorkOrderAdd with WorkOrderStateID and WorkOrderTypeID
    #

    {
        Description => 'WorkOrderAdd() with WorkOrderStateID.',
        SourceData  => {
            WorkOrderAdd => {
                UserID           => 1,
                ChangeID         => $WorkOrderAddTestID,
                WorkOrderStateID => $ReverseStatesList{ready},
                Title       => 'WorkOrderAdd with WorkOrderStateID - Title - ' . $UniqueSignature,
                Instruction => 'WorkOrderAdd with WorkOrderStateID - Instruction - '
                    . $UniqueSignature,
                Report => 'WorkOrderAdd with WorkOrderStateID - Report - ' . $UniqueSignature,
            },
        },
        ReferenceData => {
            WorkOrderGet => {
                ChangeID         => $WorkOrderAddTestID,
                WorkOrderStateID => $ReverseStatesList{ready},
                Title       => 'WorkOrderAdd with WorkOrderStateID - Title - ' . $UniqueSignature,
                Instruction => 'WorkOrderAdd with WorkOrderStateID - Instruction - '
                    . $UniqueSignature,
                Report => 'WorkOrderAdd with WorkOrderStateID - Report - ' . $UniqueSignature,
            },
        },
        SearchTest => [ 2, 8 ],
    },
    {
        Description => 'WorkOrderAdd() with WorkOrderTypeID.',
        SourceData  => {
            WorkOrderAdd => {
                UserID          => 1,
                ChangeID        => $WorkOrderAddTestID,
                WorkOrderTypeID => $ReverseTypesList{approval},
                Title       => 'WorkOrderAdd with WorkOrderTypeID - Title - ' . $UniqueSignature,
                Instruction => 'WorkOrderAdd with WorkOrderTypeID - Instruction - '
                    . $UniqueSignature,
                Report => 'WorkOrderAdd with WorkOrderTypeID - Report - ' . $UniqueSignature,
            },
        },
        ReferenceData => {
            WorkOrderGet => {
                ChangeID        => $WorkOrderAddTestID,
                WorkOrderTypeID => $ReverseTypesList{approval},
                Title       => 'WorkOrderAdd with WorkOrderTypeID - Title - ' . $UniqueSignature,
                Instruction => 'WorkOrderAdd with WorkOrderTypeID - Instruction - '
                    . $UniqueSignature,
                Report => 'WorkOrderAdd with WorkOrderTypeID - Report - ' . $UniqueSignature,
            },
        },
        SearchTest => [ 2, 8, 13 ],
    },
    {
        Description => 'WorkOrderAdd() with WorkOrderTypeID and WorkOrderStateID.',
        SourceData  => {
            WorkOrderAdd => {
                UserID           => 1,
                ChangeID         => $WorkOrderAddTestID,
                WorkOrderTypeID  => $ReverseTypesList{pir},
                WorkOrderStateID => $ReverseStatesList{closed},
                Title => 'WorkOrderAdd with WorkOrderTypeID and WorkOrderStateID - Title - '
                    . $UniqueSignature,
                Instruction =>
                    'WorkOrderAdd with WorkOrderTypeID and WorkOrderStateID - Instruction - '
                    . $UniqueSignature,
                Report => 'WorkOrderAdd with WorkOrderTypeID and WorkOrderStateID - Report - '
                    . $UniqueSignature,
            },
        },
        ReferenceData => {
            WorkOrderGet => {
                ChangeID         => $WorkOrderAddTestID,
                WorkOrderTypeID  => $ReverseTypesList{pir},
                WorkOrderStateID => $ReverseStatesList{closed},
                Title => 'WorkOrderAdd with WorkOrderTypeID and WorkOrderStateID - Title - '
                    . $UniqueSignature,
                Instruction =>
                    'WorkOrderAdd with WorkOrderTypeID and WorkOrderStateID - Instruction - '
                    . $UniqueSignature,
                Report => 'WorkOrderAdd with WorkOrderTypeID and WorkOrderStateID - Report - '
                    . $UniqueSignature,
            },
        },
        SearchTest => [ 2, 8, 13 ],
    },
    {
        Description =>
            'WorkOrderAdd() and WorkOrderUpdate() with WorkOrderTypeID and WorkOrderStateID.',
        SourceData => {
            WorkOrderAdd => {
                UserID           => 1,
                ChangeID         => $WorkOrderAddTestID,
                WorkOrderTypeID  => $ReverseTypesList{pir},
                WorkOrderStateID => $ReverseStatesList{closed},
                Title       => 'WorkOrderAdd with WorkOrderStateID - Title - ' . $UniqueSignature,
                Instruction => 'WorkOrderAdd with WorkOrderStateID - Instruction - '
                    . $UniqueSignature,
                Report => 'WorkOrderAdd with WorkOrderStateID - Report - ' . $UniqueSignature,
            },
            WorkOrderUpdate => {
                UserID           => 1,
                WorkOrderTypeID  => $ReverseTypesList{decision},
                WorkOrderStateID => $ReverseStatesList{canceled},
            },
        },
        ReferenceData => {
            WorkOrderGet => {
                ChangeID         => $WorkOrderAddTestID,
                WorkOrderTypeID  => $ReverseTypesList{decision},
                WorkOrderStateID => $ReverseStatesList{canceled},
                Title       => 'WorkOrderAdd with WorkOrderStateID - Title - ' . $UniqueSignature,
                Instruction => 'WorkOrderAdd with WorkOrderStateID - Instruction - '
                    . $UniqueSignature,
                Report => 'WorkOrderAdd with WorkOrderStateID - Report - ' . $UniqueSignature,
            },
        },
        SearchTest => [ 2, 8 ],
    },

    {
        Description => 'WorkOrderAdd() with empty string parameters.',
        SourceData  => {
            WorkOrderAdd => {
                UserID      => 1,
                ChangeID    => $WorkOrderAddTestID,
                Title       => '',
                Instruction => '',
                Report      => '',
            },
        },
        ReferenceData => {
            WorkOrderGet => {
                ChangeID    => $WorkOrderAddTestID,
                Title       => '',
                Instruction => '',
                Report      => '',
            },
        },
        SearchTest => [ 2, 8 ],
    },
);

# tests for WorkOrderUpdate();
push @WorkOrderTests, (
    {
        Description => 'Test contains no params for WorkOrderUpdate().',
        Fails      => 1,    # we expect this test to fail
        SourceData => {
            WorkOrderUpdate => {},
        },
        ReferenceData => {
            WorkOrderUpdate => undef,
        },
    },

    {
        Description => 'Test for max string length for WorkOrderUpdate.',
        SourceData  => {
            WorkOrderAdd => {
                UserID   => $UserIDs[0],
                ChangeID => $WorkOrderAddTestID,
            },
            WorkOrderUpdate => {
                UserID      => 1,
                Title       => 'T' x 250,
                Instruction => 'I' x 3800,
                Report      => 'R' x 3800,
            },
        },
        ReferenceData => {
            ChangeGet => {
                Title       => 'T' x 250,
                Instruction => 'I' x 3800,
                Report      => 'R' x 3800,
                CreateBy    => $UserIDs[0],
                ChangeBy    => 1,
            },
        },
        SearchTest => [ 1, 8 ],
    },

    {
        Description => 'Test for max+1 string length for WorkOrderUpdate.',
        UpdateFails => 1,
        SourceData  => {
            WorkOrderAdd => {
                UserID   => $UserIDs[0],
                ChangeID => $WorkOrderAddTestID,
            },
            WorkOrderUpdate => {
                UserID      => 1,
                Title       => 'T' x 251,
                Instruction => 'I' x 3801,
                Report      => 'R' x 3801,
            },
        },
        ReferenceData => {
            WorkOrderGet => {
                Title       => q{},
                Instruction => q{},
                Report      => q{},
            },
        },
        SearchTest => [8],
    },

    {
        Description => 'Test create_by and change_by for WorkOrderUpdate.',
        SourceData  => {
            WorkOrderAdd => {
                UserID   => $UserIDs[0],
                ChangeID => $WorkOrderAddTestID,
            },
            WorkOrderUpdate => {
                UserID      => 1,
                Title       => 'T' x 25,
                Instruction => 'I' x 38,
                Report      => 'R' x 38,
            },
        },
        ReferenceData => {
            WorkOrderGet => {
                Title       => 'T' x 25,
                Instruction => 'I' x 38,
                Report      => 'R' x 38,
                CreateBy    => $UserIDs[0],
                ChangeBy    => 1,
            },
        },
        SearchTest => [ 2, 8 ],
    },

    {
        Description => 'Test create_by and change_by for WorkOrderUpdate.',
        SourceData  => {
            WorkOrderAdd => {
                UserID   => $UserIDs[0],
                ChangeID => $WorkOrderAddTestID,
            },
            WorkOrderUpdate => {
                UserID      => 1,
                Title       => 'T' x 25,
                Instruction => 'I' x 38,
                Report      => 'R' x 38,
            },
        },
        ReferenceData => {
            WorkOrderGet => {
                Title       => 'T' x 25,
                Instruction => 'I' x 38,
                Report      => 'R' x 38,
                CreateBy    => $UserIDs[0],
                ChangeBy    => 1,
            },
        },
        SearchTest => [ 2, 8 ],
    },

    {
        Description => 'Test for max+1 string length - title - for WorkOrderUpdate.',
        UpdateFails => 1,
        SourceData  => {
            WorkOrderAdd => {
                UserID   => $UserIDs[0],
                ChangeID => $WorkOrderAddTestID,
            },
            WorkOrderUpdate => {
                UserID      => 1,
                Title       => 'T' x 251,
                Instruction => 'I',
                Report      => 'R',
            },
        },
        ReferenceData => {
            WorkOrderGet => {
                Title       => q{},
                Instruction => q{},
                Report      => q{},
            },
        },
        SearchTest => [8],
    },

    {
        Description => 'Test for max+1 string length - Instruction - for WorkOrderUpdate.',
        UpdateFails => 1,
        SourceData  => {
            WorkOrderAdd => {
                UserID   => $UserIDs[0],
                ChangeID => $WorkOrderAddTestID,
            },
            WorkOrderUpdate => {
                UserID      => 1,
                Title       => 'T',
                Instruction => 'I' x 3801,
                Report      => 'R',
            },
        },
        ReferenceData => {
            WorkOrderGet => {
                Title       => q{},
                Instruction => q{},
                Report      => q{},
            },
        },
        SearchTest => [8],
    },

    {
        Description => 'Test for max+1 string length - Report - for WorkOrderUpdate.',
        UpdateFails => 1,
        SourceData  => {
            WorkOrderAdd => {
                UserID   => $UserIDs[0],
                ChangeID => $WorkOrderAddTestID,
            },
            WorkOrderUpdate => {
                UserID      => 1,
                Title       => 'T',
                Instruction => 'I',
                Report      => 'R' x 3801,
            },
        },
        ReferenceData => {
            WorkOrderGet => {
                Title       => q{},
                Instruction => q{},
                Report      => q{},
            },
        },
        SearchTest => [8],
    },

    {
        Description => 'Test for TimeChanges - just PlannedStartTime - for WorkOrderUpdate.',
        UpdateFails => 1,
        SourceData  => {
            WorkOrderAdd => {
                UserID   => $UserIDs[0],
                ChangeID => $WorkOrderAddTestID,
                Report   => 'Report - just PlannedStartTime',
            },
            WorkOrderUpdate => {
                PlannedStartTime => '2009-03-20 13:25:09',
                Title            => 'Test',
                UserID           => 1,
            },
        },
        ReferenceData => {
            WorkOrderGet => {
                Title       => q{},
                Instruction => q{},
                Report      => 'Report - just PlannedStartTime',
                ChangeBy    => $UserIDs[0],
                CreateBy    => $UserIDs[0],
            },
        },
        SearchTest => [8],
    },

    {
        Description => 'Test for TimeChanges - just PlannedEndTime - for WorkOrderUpdate.',
        UpdateFails => 1,
        SourceData  => {
            WorkOrderAdd => {
                UserID   => $UserIDs[0],
                ChangeID => $WorkOrderAddTestID,
                Report   => 'Report - just PlannedEndTime',
            },
            WorkOrderUpdate => {
                PlannedEndTime => '2009-03-20 13:25:09',
                Title          => 'Test',
                UserID         => 1,
            },
        },
        ReferenceData => {
            WorkOrderGet => {
                Title       => q{},
                Instruction => q{},
                Report      => 'Report - just PlannedEndTime',
                ChangeBy    => $UserIDs[0],
                CreateBy    => $UserIDs[0],
            },
        },
        SearchTest => [8],
    },

    {
        Description => 'Test for TimeChanges - just ActualStartTime - for WorkOrderUpdate.',
        SourceData  => {
            WorkOrderAdd => {
                UserID   => $UserIDs[0],
                ChangeID => $WorkOrderAddTestID,
                Report   => 'Report - just ActualStartTime',
            },
            WorkOrderUpdate => {
                ActualStartTime => '2009-03-20 13:25:09',
                Title           => 'Test',
                UserID          => 1,
            },
        },
        ReferenceData => {
            WorkOrderGet => {
                Title           => 'Test',
                Instruction     => q{},
                Report          => 'Report - just ActualStartTime',
                ActualStartTime => '2009-03-20 13:25:09',
                ChangeBy        => 1,
                CreateBy        => $UserIDs[0],
            },
        },
        SearchTest => [8],
    },

    {
        Description => 'Test for TimeChanges - just ActualEndTime - for WorkOrderUpdate.',
        UpdateFails => 1,
        SourceData  => {
            WorkOrderAdd => {
                UserID   => $UserIDs[0],
                ChangeID => $WorkOrderAddTestID,
                Report   => 'Report - just ActualEndTime',
            },
            WorkOrderUpdate => {
                ActualEndTime => '2009-03-20 13:25:09',
                Title         => 'Test',
                UserID        => 1,
            },
        },
        ReferenceData => {
            WorkOrderGet => {
                Title       => q{},
                Instruction => q{},
                Report      => 'Report - just ActualEndTime',
                ChangeBy    => $UserIDs[0],
                CreateBy    => $UserIDs[0],
            },
        },
        SearchTest => [8],
    },

    {
        Description =>
            'Test for TimeChanges - ActualStartTime > ActualEndTime - for WorkOrderUpdate.',
        UpdateFails => 1,
        SourceData  => {
            WorkOrderAdd => {
                UserID   => $UserIDs[0],
                ChangeID => $WorkOrderAddTestID,
                Report   => 'Report - ActualStartTime > ActualEndTime',
            },
            WorkOrderUpdate => {
                ActualEndTime   => '2009-03-20 13:25:09',
                ActualStartTime => '2009-03-21 13:25:09',
                Title           => 'Test',
                UserID          => 1,
            },
        },
        ReferenceData => {
            WorkOrderGet => {
                Title       => q{},
                Instruction => q{},
                Report      => 'Report - ActualStartTime > ActualEndTime',
                ChangeBy    => $UserIDs[0],
                CreateBy    => $UserIDs[0],
            },
        },
        SearchTest => [8],
    },

    {
        Description =>
            'Test for TimeChanges - ActualStartTime < ActualEndTime - for WorkOrderUpdate.',
        SourceData => {
            WorkOrderAdd => {
                UserID   => $UserIDs[0],
                ChangeID => $WorkOrderAddTestID,
                Report   => 'Report - ActualStartTime < ActualEndTime',
            },
            WorkOrderUpdate => {
                ActualEndTime   => '2009-03-22 13:25:09',
                ActualStartTime => '2009-03-21 13:25:09',
                Title           => 'Test',
                UserID          => 1,
            },
        },
        ReferenceData => {
            WorkOrderGet => {
                Title           => 'Test',
                Instruction     => q{},
                Report          => 'Report - ActualStartTime < ActualEndTime',
                ChangeBy        => 1,
                CreateBy        => $UserIDs[0],
                ActualEndTime   => '2009-03-22 13:25:09',
                ActualStartTime => '2009-03-21 13:25:09',
            },
        },
        SearchTest => [8],
    },

    {
        Description => q{Test for '0' string handling for WorkOrderUpdate.},
        SourceData  => {
            WorkOrderAdd => {
                UserID   => 1,
                ChangeID => $WorkOrderAddTestID,
            },
            WorkOrderUpdate => {
                UserID      => 1,
                Title       => '0',
                Instruction => '0',
                Report      => '0',
            },
        },
        ReferenceData => {
            WorkOrderGet => {
                Title       => '0',
                Instruction => '0',
                Report      => '0',
            },
        },
        SearchTest => [8],
    },
);

# ------------------------------------------------------------ #
# execute the workorder tests
# ------------------------------------------------------------ #

my %TestedWorkOrderID;           # ids of all created workorders
my %WorkOrderIDForChangeID;      # keep track of the workorders that are attached to a change
my %WorkOrderIDForSearchTest;    # workorder ids that are expected to be found in a search

TEST:
for my $Test (@WorkOrderTests) {

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
    my $WorkOrderID;

    # add a new Change
    if ( $SourceData->{WorkOrderAdd} ) {

        # add the workorder
        $WorkOrderID = $Self->{WorkOrderObject}->WorkOrderAdd(
            %{ $SourceData->{WorkOrderAdd} }
        );

        # remember current WorkOrderID
        if ($WorkOrderID) {
            my $ChangeID = $SourceData->{WorkOrderAdd}->{ChangeID};

            # keep track of all created workorders
            $TestedWorkOrderID{$WorkOrderID} = 1;

            # keep track of the workorders attached to a change
            $WorkOrderIDForChangeID{$ChangeID} ||= {};
            $WorkOrderIDForChangeID{$ChangeID}->{$WorkOrderID} = 1;

            # save workorder id for use in search tests
            if ( exists $Test->{SearchTest} ) {
                my @SearchTests = @{ $Test->{SearchTest} };

                for my $SearchTestNr (@SearchTests) {
                    $WorkOrderIDForSearchTest{$SearchTestNr}->{$WorkOrderID} = 1;
                }
            }
        }

        if ( $Test->{Fails} ) {
            $Self->False(
                $WorkOrderID,
                "Test $TestCount: WorkOrderAdd() - Add workorder should fail.",
            );
        }
        else {
            $Self->True(
                $WorkOrderID,
                "Test $TestCount: WorkOrderAdd() - Add workorder.",
            );
        }
    }    # end if 'WorkOrderAdd'

    if ( $SourceData->{WorkOrderUpdate} ) {

        # update the change
        my $WorkOrderUpdateSuccess = $Self->{WorkOrderObject}->WorkOrderUpdate(
            WorkOrderID => $WorkOrderID,
            %{ $SourceData->{WorkOrderUpdate} },
        );

        if (
            $Test->{Fails}
            || $Test->{UpdateFails}
            )
        {
            $Self->False(
                $WorkOrderUpdateSuccess,
                "Test $TestCount: WorkOrderUpdate()",
            );
        }
        else {
            $Self->True(
                $WorkOrderUpdateSuccess,
                "Test $TestCount: WorkOrderUpdate()",
            );
        }
    }

    # get a workorder and compare the retrieved data with the reference
    if ( exists $ReferenceData->{WorkOrderGet} ) {

        my $WorkOrderGetReferenceData = $ReferenceData->{WorkOrderGet};

        my $WorkOrderData = $Self->{WorkOrderObject}->WorkOrderGet(
            WorkOrderID => $WorkOrderID,
            UserID      => 1,
        );

        # WorkOrderGet should not return anything
        if ( !defined $ReferenceData->{WorkOrderGet} ) {
            $Self->False(
                $WorkOrderData,
                "Test $TestCount: |- Get change returns undef.",
            );

            # check if we excpected to fail
            if ( $Test->{Fails} ) {
                $Self->Is(
                    !defined $WorkOrderData,
                    !defined $ReferenceData->{WorkOrderData},
                    "Test $TestCount: |- Should fail.",
                );
            }
            next TEST;
        }

        # check for always existing attributes
        for my $WorkOrderAttributes (
            qw(WorkOrderID WorkOrderNumber CreateTime ChangeTime)
            )
        {
            $Self->True(
                $WorkOrderData->{$WorkOrderAttributes},
                "Test $TestCount: |- has $WorkOrderAttributes.",
            );
        }

        for my $RequestedAttribute ( keys %{ $ReferenceData->{WorkOrderGet} } ) {

            # turn off all pretty print
            local $Data::Dumper::Indent = 0;
            local $Data::Dumper::Useqq  = 1;

            # dump the attribute from WorkOrderGet()
            my $WorkOrderAttribute = Data::Dumper::Dumper( $WorkOrderData->{$RequestedAttribute} );

            # dump the reference attribute
            my $ReferenceAttribute
                = Data::Dumper::Dumper( $ReferenceData->{WorkOrderGet}->{$RequestedAttribute} );

            $Self->Is(
                $WorkOrderAttribute,
                $ReferenceAttribute,
                "Test $TestCount: |- $RequestedAttribute (WorkOrderID: $WorkOrderID)",
            );
        }
    }    # end if 'WorkOrderGet'
}
continue {

    # increase the test count, even on next
    $TestCount++;
}

# ------------------------------------------------------------ #
# test WorkOrderList() and ChangeGet()
# ------------------------------------------------------------ #

# Test whether WorkOrderList() and ChangeGet() return the same workorders as we created.
for my $ChangeID ( sort keys %WorkOrderIDForChangeID ) {

    # ask the WorkOrder object for a list of workorders
    my $ListFromWorkOrderObject = $Self->{WorkOrderObject}->WorkOrderList(
        UserID   => 1,
        ChangeID => $ChangeID,
    ) || [];
    my %MapFromWorkOrderObject = map { $_ => 1 } @{$ListFromWorkOrderObject};

    # ask the Change object for a list of workorders
    my $Change = $Self->{ChangeObject}->ChangeGet(
        UserID   => 1,
        ChangeID => $ChangeID,
    ) || {};
    my $ListFromChangeObject = $Change->{WorkOrderIDs} || [];
    my %MapFromChangeObject = map { $_ => 1 } @{$ListFromChangeObject};

    # check whether the created workorders were found by WorkOrderList()
    for my $WorkOrderID ( sort keys %{ $WorkOrderIDForChangeID{$ChangeID} } ) {
        $Self->True(
            $MapFromWorkOrderObject{$WorkOrderID},
            'Test '
                . $TestCount++
                . ": WorkOrderList() - WorkOrderID $WorkOrderID in list from WorkOrder object.",
        );
        $Self->True(
            $MapFromChangeObject{$WorkOrderID},
            'Test '
                . $TestCount++
                . ": ChangeGet() - WorkOrderID $WorkOrderID in list from Change object.",
        );
    }

    # check the number of workorders for a change
    $Self->Is(
        scalar @{$ListFromWorkOrderObject},
        scalar keys %{ $WorkOrderIDForChangeID{$ChangeID} },
        'Test ' . $TestCount++ . ": WorkOrderList() - number of workorders for a change.",
    );
    $Self->Is(
        scalar @{$ListFromChangeObject},
        scalar keys %{ $WorkOrderIDForChangeID{$ChangeID} },
        'Test ' . $TestCount++ . ": ChangeGet() - number of workorders for a change.",
    );
}

# count all tests that are required to and planned for fail
my $Fails = scalar grep { $_->{Fails} } @WorkOrderTests;
my $NrCreateWorkOrders = ( scalar @WorkOrderTests ) - $Fails;

# test if the workorders were created
$Self->Is(
    scalar keys %TestedWorkOrderID || 0,
    $NrCreateWorkOrders,
    'Test ' . $TestCount++ . ': amount of workorder objects and test cases.',
);

# ------------------------------------------------------------ #
# define general workorder search tests
# ------------------------------------------------------------ #

my @WorkOrderSearchTests = (

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

    # Nr 2 - a simple check that should find all workorders
    {
        Description => 'Limit',
        SearchData  => {
        },
        ResultData => {
            TestExistence => 1,    # flag for check results that were marked with 'SearchTest'
        },
    },

    # Nr 3 - search for title
    {
        Description => 'Title',
        SearchData  => {
            Title => 'WorkOrder 1 - Title - ' . $UniqueSignature,
        },
        ResultData => {
            TestExistence => 1,
        },
    },

    # Nr 4 - search for instruction
    {
        Description => 'Instruction',
        SearchData  => {
            Instruction => 'WorkOrder 1 - Instruction - ' . $UniqueSignature,
        },
        ResultData => {
            TestExistence => 1,
        },
    },

    # Nr 5 - search for report
    {
        Description => 'Report',
        SearchData  => {
            Report => 'WorkOrder 1 - Report - ' . $UniqueSignature,
        },
        ResultData => {
            TestExistence => 1,
        },
    },

    # Nr 6 - search for title, instruction and report
    {
        Description => 'Title, Instruction, Report',
        SearchData  => {
            Title       => 'WorkOrder 1 - Title - ' . $UniqueSignature,
            Instruction => 'WorkOrder 1 - Instruction - ' . $UniqueSignature,
            Report      => 'WorkOrder 1 - Report - ' . $UniqueSignature,
        },
        ResultData => {
            TestExistence => 1,
        },
    },

    # Nr 7 - search for title, which is not in database
    {
        Description => 'Title does not exist',
        SearchData  => {
            Title => 'NOT IN DATABASE ' . $UniqueSignature,
        },
        ResultData => {
            TestCount => 1,
            Count     => 0,
        },
    },

    # Nr 8 - search for ChangeID
    {
        Description => 'ChangeID does exist',
        SearchData  => {
            ChangeIDs => [$WorkOrderAddTestID],
        },
        ResultData => {
            TestExistence => 1,
        },
    },

    # Nr 9 - search for change id, which is not in database
    {
        Description => 'All WorkOrders for Change 1_000_000',
        SearchData  => {
            ChangeIDs => [1_000_000],
        },
        ResultData => {
            TestCount => 1,
            Count     => 0,
        },
    },

    # Nr 10 - search for non-existing change id and existing title which is not in database
    {
        Description => 'All WorkOrders for Change 1_000_000 and an existing title',
        SearchData  => {
            ChangeIDs => [1_000_000],
            Title     => 'WorkOrder 1 - Title - ' . $UniqueSignature,
        },
        ResultData => {
            TestCount => 1,
            Count     => 0,
        },
    },

    # Nr 11 - search for existing ChangeID and existing Title
    {
        Description => 'ChangeID does exist, Title does exist',
        SearchData  => {
            ChangeIDs => [$WorkOrderAddTestID],
            Title     => 'WorkOrder 1 - Title - ' . $UniqueSignature,
        },
        ResultData => {
            TestExistence => 1,
        },
    },

    # Nr 12 - search for existing change id and for title, which is not in database
    {
        Description => 'ChangeID does exist, Title does not exist',
        SearchData  => {
            ChangeIDs => [$WorkOrderAddTestID],
            Title     => 'NOT IN DATABASE ' . $UniqueSignature,
        },
        ResultData => {
            TestCount => 1,
            Count     => 0,
        },
    },

    # Nr 13 - search for workorder types
    {
        Description => 'Search for WorkOrder type',
        SearchData  => {
            WorkOrderTypeIDs => [
                $ReverseTypesList{approval},
                $ReverseTypesList{pir},
            ],
            Title => '%' . $UniqueSignature,
        },
        ResultData => {
            TestCount => 1,
        },
    },

);

my $SearchTestCount = 1;

SEARCHTEST:
for my $SearchTest (@WorkOrderSearchTests) {

    # check SearchData attribute
    if ( !$SearchTest->{SearchData} || ref( $SearchTest->{SearchData} ) ne 'HASH' ) {

        $Self->True(
            0,
            "Test $TestCount: SearchData found for this test.",
        );

        next SEARCHTEST;
    }

    $Self->True(
        1,
        'call WorkOrderSearch with params: '
            . $SearchTest->{Description}
            . " (SearchTestCase: $SearchTestCount)",
    );

    my $WorkOrderIDs = $Self->{WorkOrderObject}->WorkOrderSearch(
        %{ $SearchTest->{SearchData} },
        UserID   => 1,
        ChangeID => $WorkOrderAddTestID,
    );

    $Self->True(
        defined($WorkOrderIDs) && ref($WorkOrderIDs) eq 'ARRAY',
        "Test $TestCount: |- array reference for WorkOrderIDs.",
    );

    $WorkOrderIDs ||= [];

    if ( $SearchTest->{ResultData}->{TestCount} ) {

        # get number of workorder ids WorkOrderSearch should return
        my $Count = scalar keys %{ $WorkOrderIDForSearchTest{$SearchTestCount} };

        # get defined expected result count (defined in search test case!)
        if ( exists $SearchTest->{ResultData}->{Count} ) {
            $Count = $SearchTest->{ResultData}->{Count}
        }

        $Self->Is(
            scalar @{$WorkOrderIDs},
            $Count,
            "Test $TestCount: |- Number of found workorders.",
        );
    }

    if ( $SearchTest->{ResultData}->{TestExistence} ) {

        # check if all ids that belongs to this searchtest are returned
        my @WorkOrderIDs = keys %{ $WorkOrderIDForSearchTest{$SearchTestCount} };

        my %ReturnedWorkOrderID = map { $_ => 1 } @{$WorkOrderIDs};
        for my $WorkOrderID (@WorkOrderIDs) {
            $Self->True(
                $ReturnedWorkOrderID{$WorkOrderID},
                "Test $TestCount: |- WorkOrderID $WorkOrderID found in returned list.",
            );
        }
    }
}
continue {
    $TestCount++;
    $SearchTestCount++;
}

# test sorting of changes (some have no workorder, others have severel workorders)
# ------------------------------------------------------------ #
my %IDsToDelete = (
    Change    => [],
    WorkOrder => [],
);
my $ChangesTitle       = 'ChangeSearchOrderByTimes - ' . $UniqueSignature;
my @ChangesForSortTest = (
    {
        Change => {
            Title  => $ChangesTitle,
            UserID => 1,
        },
        Workorders => [
            {
                ActualStartTime => '2009-06-30 09:33:12',
                ActualEndTime   => '2009-09-01 01:12:55',
                UserID          => 1,
            },
        ],
    },
    {
        Change => {
            Title  => $ChangesTitle,
            UserID => 1,
        },
        Workorders => [
            {
                PlannedStartTime => '2009-02-21 13:25:09',
                PlannedEndTime   => '2009-10-13 22:15:56',
                ActualStartTime  => '2009-05-31 09:33:12',
                ActualEndTime    => '2009-10-01 01:12:55',
                UserID           => 1,
            },
            {
                PlannedStartTime => '2009-03-25 13:25:09',
                PlannedEndTime   => '2009-09-13 22:15:56',
                ActualStartTime  => '2009-06-01 09:33:12',
                ActualEndTime    => '2009-11-01 01:12:55',
                UserID           => 1,
            },
        ],
    },
    {
        Change => {
            Title  => $ChangesTitle,
            UserID => 1,
        },
        Workorders => [],
    },
    {
        Change => {
            Title  => $ChangesTitle,
            UserID => 1,
        },
        Workorders => [
            {
                PlannedStartTime => '2009-03-21 13:25:09',
                PlannedEndTime   => '2009-10-13 22:15:56',
                ActualStartTime  => '2009-06-30 09:33:12',
                ActualEndTime    => '2009-09-01 01:12:55',
                UserID           => 1,
            },
            {
                PlannedStartTime => '2009-03-20 13:25:09',
                PlannedEndTime   => '2009-10-12 22:15:56',
                UserID           => 1,
            },
            {
                PlannedStartTime => '2009-03-22 13:25:09',
                PlannedEndTime   => '2009-10-11 22:15:56',
                UserID           => 1,
            },
        ],
    },
);

my @ChangeIDsForSortTest;
for my $Change (@ChangesForSortTest) {

    # create change
    my $ChangeID = $Self->{ChangeObject}->ChangeAdd( %{ $Change->{Change} } );

    $Self->True(
        $ChangeID,
        "Test $TestCount: Change for sort test created",
    );

    # store ChangeID
    push @ChangeIDsForSortTest, $ChangeID;
    push @{ $IDsToDelete{Change} }, $ChangeID;

    # add the workorders for the change
    my $WorkOrderCount = 1;
    for my $WorkOrder ( @{ $Change->{Workorders} } ) {
        my $WorkOrderID = $Self->{WorkOrderObject}->WorkOrderAdd(
            ChangeID => $ChangeID,
            %{$WorkOrder},
        );

        $Self->True(
            $WorkOrderID,
            "Test $TestCount: WorkOrder $WorkOrderCount for Change created",
        );

        push @{ $IDsToDelete{WorkOrder} }, $WorkOrderID;

        $WorkOrderCount++;
    }
}
continue {
    $TestCount++;
}

my @Testplan = (
    [ 0, 3, 1, 2 ],    # index of changes in @ChangeIDsForSortTest
    [ 0, 1, 3, 2 ],
    [ 0, 3, 1, 2 ],
    [ 3, 1, 0, 2 ],
);

# Do the testing
my $OrderByTestCount = 0;
for my $OrderByColumn (qw(PlannedStartTime PlannedEndTime ActualStartTime ActualEndTime)) {

    # turn off all pretty print
    local $Data::Dumper::Indent = 0;
    local $Data::Dumper::Useqq  = 1;

    # result what we expect
    my @ResultReference = map { $ChangeIDsForSortTest[$_] } @{ $Testplan[$OrderByTestCount] };

    # search with direction 'DOWN'
    my $SearchResult = $Self->{ChangeObject}->ChangeSearch(
        Title            => $ChangesTitle,
        OrderBy          => [ $OrderByColumn, 'ChangeID' ],
        OrderByDirection => [ 'Down', 'Up' ],
        UserID           => 1,

        #Huhu             => 'Haha',
    );

    $Self->Is(
        Data::Dumper::Dumper($SearchResult),
        Data::Dumper::Dumper( \@ResultReference ),
        "Test $TestCount: ChangeSearch OrderBy $OrderByColumn (Down)",
    );

    # search with direction 'UP'
    my $SearchResultUp = $Self->{ChangeObject}->ChangeSearch(
        Title            => $ChangesTitle,
        OrderBy          => [ $OrderByColumn, 'ChangeID' ],
        OrderByDirection => [ 'Up', 'Down' ],
        UserID           => 1,
    );

    $Self->Is(
        Data::Dumper::Dumper($SearchResultUp),
        Data::Dumper::Dumper( [ reverse @ResultReference ] ),
        "Test $TestCount: ChangeSearch OrderBy $OrderByColumn (Up)",
    );

    $OrderByTestCount++;
    $TestCount++;
}

# ------------------------------------------------------------ #
# test WorkOrderChangeTimeGet
# ------------------------------------------------------------ #
my @WOCTGTests = (
    {
        Description => 'test for WorkOrderChangeTimeGet without times.',
        SourceData  => {
            ChangeAdd => {
                UserID => 1,
            },
            WorkOrderAdd => {
                UserID => 1,
            },
        },
        ReferenceData => {
            WorkOrderChangeTimeGet => {
                UserID     => 1,
                ResultData => {
                    'PlannedStartTime' => '',
                    'PlannedEndTime'   => '',
                    'ActualStartTime'  => '',
                    'ActualEndTime'    => '',
                },
            },
        },
    },
    {
        Description => 'test for WorkOrderChangeTimeGet with all times',
        SourceData  => {
            ChangeAdd => {
                UserID => 1,
            },
            WorkOrderAdd => {
                UserID           => 1,
                PlannedStartTime => '2009-10-01 00:00:00',
                PlannedEndTime   => '2009-10-02 23:59:59',
                ActualStartTime  => '2009-10-01 00:08:00',
                ActualEndTime    => '2009-10-02 00:18:00',
            },
        },
        ReferenceData => {
            WorkOrderChangeTimeGet => {
                UserID     => 1,
                ResultData => {
                    'PlannedStartTime' => '2009-10-01 00:00:00',
                    'PlannedEndTime'   => '2009-10-02 23:59:59',
                    'ActualStartTime'  => '2009-10-01 00:08:00',
                    'ActualEndTime'    => '2009-10-02 00:18:00',
                },
            },
        },
    },
    {
        Description => 'test for WorkOrderChangeTimeGet only with planned times',
        SourceData  => {
            ChangeAdd => {
                UserID => 1,
            },
            WorkOrderAdd => {
                UserID           => 1,
                PlannedStartTime => '2009-10-01 00:00:00',
                PlannedEndTime   => '2009-10-02 23:59:59',
            },
        },
        ReferenceData => {
            WorkOrderChangeTimeGet => {
                UserID     => 1,
                ResultData => {
                    'PlannedStartTime' => '2009-10-01 00:00:00',
                    'PlannedEndTime'   => '2009-10-02 23:59:59',
                    'ActualStartTime'  => '',
                    'ActualEndTime'    => '',
                },
            },
        },
    },
    {
        Description =>
            'test for WorkOrderChangeTimeGet only with planned times PlannedStartTime = PlannedEndTime',
        SourceData => {
            ChangeAdd => {
                UserID => 1,
            },
            WorkOrderAdd => {
                UserID           => 1,
                PlannedStartTime => '2009-10-01 00:00:00',
                PlannedEndTime   => '2009-10-01 00:00:00',
            },
        },
        ReferenceData => {
            WorkOrderChangeTimeGet => {
                UserID     => 1,
                ResultData => {
                    'PlannedStartTime' => '',
                    'PlannedEndTime'   => '',
                    'ActualStartTime'  => '',
                    'ActualEndTime'    => '',
                },
            },
        },
    },
    {
        Description =>
            'test for WorkOrderChangeTimeGet only with planned times PlannedStartTime > PlannedEndTime',
        SourceData => {
            ChangeAdd => {
                UserID => 1,
            },
            WorkOrderAdd => {
                UserID           => 1,
                PlannedStartTime => '2009-10-01 00:00:01',
                PlannedEndTime   => '2009-10-01 00:00:00',
            },
        },
        ReferenceData => {
            WorkOrderChangeTimeGet => {
                UserID     => 1,
                ResultData => {
                    'PlannedStartTime' => '',
                    'PlannedEndTime'   => '',
                    'ActualStartTime'  => '',
                    'ActualEndTime'    => '',
                },
            },
        },
    },
    {
        Description => 'test for WorkOrderChangeTimeGet only with PlannedStartTime',
        SourceData  => {
            ChangeAdd => {
                UserID => 1,
            },
            WorkOrderAdd => {
                UserID           => 1,
                PlannedStartTime => '2009-10-01 00:00:00',
            },
        },
        ReferenceData => {
            WorkOrderChangeTimeGet => {
                UserID     => 1,
                ResultData => {
                    'PlannedStartTime' => '',
                    'PlannedEndTime'   => '',
                    'ActualStartTime'  => '',
                    'ActualEndTime'    => '',
                },
            },
        },
    },
    {
        Description => 'test for WorkOrderChangeTimeGet only with PlannedEndTime',
        SourceData  => {
            ChangeAdd => {
                UserID => 1,
            },
            WorkOrderAdd => {
                UserID         => 1,
                PlannedEndTime => '2009-10-02 23:59:59',
            },
        },
        ReferenceData => {
            WorkOrderChangeTimeGet => {
                UserID     => 1,
                ResultData => {
                    'PlannedStartTime' => '',
                    'PlannedEndTime'   => '',
                    'ActualStartTime'  => '',
                    'ActualEndTime'    => '',
                },
            },
        },
    },
    {
        Description => 'test for WorkOrderChangeTimeGet only with ActualStartTime',
        SourceData  => {
            ChangeAdd => {
                UserID => 1,
            },
            WorkOrderAdd => {
                UserID          => 1,
                ActualStartTime => '2009-10-01 00:08:00',
            },
        },
        ReferenceData => {
            WorkOrderChangeTimeGet => {
                UserID     => 1,
                ResultData => {
                    'PlannedStartTime' => '',
                    'PlannedEndTime'   => '',
                    'ActualStartTime'  => '2009-10-01 00:08:00',
                    'ActualEndTime'    => '',
                },
            },
        },
    },
    {
        Description => 'test for WorkOrderChangeTimeGet only with ActualEndTime',
        SourceData  => {
            ChangeAdd => {
                UserID => 1,
            },
            WorkOrderAdd => {
                UserID        => 1,
                ActualEndTime => '2009-10-01 00:08:00',
            },
        },
        ReferenceData => {
            WorkOrderChangeTimeGet => {
                UserID     => 1,
                ResultData => {
                    'PlannedStartTime' => '',
                    'PlannedEndTime'   => '',
                    'ActualStartTime'  => '',
                    'ActualEndTime'    => '',
                },
            },
        },
    },
    {
        Description => 'test for WorkOrderChangeTimeGet only with actual times',
        SourceData  => {
            ChangeAdd => {
                UserID => 1,
            },
            WorkOrderAdd => {
                UserID          => 1,
                ActualStartTime => '2009-10-01 00:00:00',
                ActualEndTime   => '2009-10-02 23:59:59',
            },
        },
        ReferenceData => {
            WorkOrderChangeTimeGet => {
                UserID     => 1,
                ResultData => {
                    'PlannedStartTime' => '',
                    'PlannedEndTime'   => '',
                    'ActualStartTime'  => '2009-10-01 00:00:00',
                    'ActualEndTime'    => '2009-10-02 23:59:59',
                },
            },
        },
    },
    {
        Description => 'test for WorkOrderChangeTimeGet only with ActualStartTime = ActualEndTime',
        SourceData  => {
            ChangeAdd => {
                UserID => 1,
            },
            WorkOrderAdd => {
                UserID          => 1,
                ActualStartTime => '2009-10-01 00:00:00',
                ActualEndTime   => '2009-10-01 00:00:00',
            },
        },
        ReferenceData => {
            WorkOrderChangeTimeGet => {
                UserID     => 1,
                ResultData => {
                    'PlannedStartTime' => '',
                    'PlannedEndTime'   => '',
                    'ActualStartTime'  => '',
                    'ActualEndTime'    => '',
                },
            },
        },
    },
    {
        Description => 'test for WorkOrderChangeTimeGet only with ActualStartTime > ActualEndTime',
        SourceData  => {
            ChangeAdd => {
                UserID => 1,
            },
            WorkOrderAdd => {
                UserID          => 1,
                ActualStartTime => '2009-10-01 00:00:01',
                ActualEndTime   => '2009-10-01 00:00:00',
            },
        },
        ReferenceData => {
            WorkOrderChangeTimeGet => {
                UserID     => 1,
                ResultData => {
                    'PlannedStartTime' => '',
                    'PlannedEndTime'   => '',
                    'ActualStartTime'  => '',
                    'ActualEndTime'    => '',
                },
            },
        },
    },
    {
        Description =>
            'test for WorkOrderChangeTimeGet with all times (with reserved time PlannedStartTime)',
        SourceData => {
            ChangeAdd => {
                UserID => 1,
            },
            WorkOrderAdd => {
                UserID           => 1,
                PlannedStartTime => '9999-01-01 00:00:00',
                PlannedStartTime => '9999-01-01 00:00:01',
                ActualStartTime  => '2009-10-01 00:08:00',
                ActualEndTime    => '2009-10-02 00:18:00',
            },
        },
        ReferenceData => {
            WorkOrderChangeTimeGet => {
                UserID     => 1,
                ResultData => {
                    'PlannedStartTime' => '',
                    'PlannedEndTime'   => '',
                    'ActualStartTime'  => '',
                    'ActualEndTime'    => '',
                },
            },
        },
    },
    {
        Description =>
            'test for WorkOrderChangeTimeGet with all times (with reserved time PlannedEndTime)',
        SourceData => {
            ChangeAdd => {
                UserID => 1,
            },
            WorkOrderAdd => {
                UserID           => 1,
                PlannedStartTime => '2009-10-01 01:01:00',
                PlannedStartTime => '9999-01-01 00:00:00',
                ActualStartTime  => '2009-10-01 00:08:00',
                ActualEndTime    => '2009-10-02 00:18:00',
            },
        },
        ReferenceData => {
            WorkOrderChangeTimeGet => {
                UserID     => 1,
                ResultData => {
                    'PlannedStartTime' => '',
                    'PlannedEndTime'   => '',
                    'ActualStartTime'  => '',
                    'ActualEndTime'    => '',
                },
            },
        },
    },
    {
        Description =>
            'test for WorkOrderChangeTimeGet with all times (with reserved time ActualStartTime)',
        SourceData => {
            ChangeAdd => {
                UserID => 1,
            },
            WorkOrderAdd => {
                UserID           => 1,
                PlannedStartTime => '2009-10-01 01:01:00',
                PlannedEndTime   => '2009-10-01 01:01:01',
                ActualStartTime  => '9990-01-01 00:00:00',
            },
        },
        ReferenceData => {
            WorkOrderChangeTimeGet => {
                UserID     => 1,
                ResultData => {
                    'PlannedStartTime' => '',
                    'PlannedEndTime'   => '',
                    'ActualStartTime'  => '',
                    'ActualEndTime'    => '',
                },
            },
        },
    },
    {
        Description =>
            'test for WorkOrderChangeTimeGet with all times (with reserved time ActualEndTime)',
        SourceData => {
            ChangeAdd => {
                UserID => 1,
            },
            WorkOrderAdd => {
                UserID           => 1,
                PlannedStartTime => '2009-10-01 01:01:00',
                PlannedEndTime   => '2009-10-01 01:01:01',
                ActualStartTime  => '2009-10-01 01:01:00',
                ActualEndTime    => '9999-01-01 00:00:00',
            },
        },
        ReferenceData => {
            WorkOrderChangeTimeGet => {
                UserID     => 1,
                ResultData => {
                    'PlannedStartTime' => '',
                    'PlannedEndTime'   => '',
                    'ActualStartTime'  => '',
                    'ActualEndTime'    => '',
                },
            },
        },
    },
);

my $WOCTGTestCount = 1;
for my $WOCTGTest (@WOCTGTests) {
    my $SourceData    = $WOCTGTest->{SourceData};
    my $ReferenceData = $WOCTGTest->{ReferenceData};

    my $ChangeID;
    my $WorkOrderID;

    $Self->True(
        1,
        "Test $TestCount: $WOCTGTest->{Description} (WOCTGTest case: $WOCTGTestCount)",
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

        push @{ $IDsToDelete{WorkOrder} }, $WorkOrderID;
    }

    if ( $ReferenceData->{WorkOrderChangeTimeGet} ) {
        my $Time = $Self->{WorkOrderObject}->WorkOrderChangeTimeGet(
            %{ $ReferenceData->{WorkOrderChangeTimeGet} },
            ChangeID => $ChangeID,
        );

        $Self->Is(
            ref $Time,
            'HASH',
            "Test $TestCount: |- WorkOrderChangeTimeGet()",
        );

        $Self->True(
            (
                ref $Time eq 'HASH'
                    && %{$Time}
            )
                || 0,
            "Test $TestCount: |- WorkOrderChangeTimeGet() - HashRef with content",
        );

        if (
            ref $Time eq 'HASH'
            && %{$Time}
            )
        {

            # Test for right values in result
            TIMEVALUE:
            for my $TimeType ( keys %{$Time} ) {
                $Self->Is(
                    $Time->{$TimeType},
                    $ReferenceData->{WorkOrderChangeTimeGet}->{ResultData}->{$TimeType},
                    "Test $TestCount: |- check TimeResult ($TimeType)",
                );
            }
        }
    }

    $TestCount++;
    $WOCTGTestCount++;
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
        ValidID => $Self->{ChangeObject}->{ValidObject}->ValidLookup(
            Valid => 'invalid',
        ),
        ChangeUserID => 1,
    );
}

# restore original email check param
$Self->{ConfigObject}->Set(
    Key   => 'CheckEmailAddresses',
    Value => $CheckEmailAddressesOrg,
);

# delete the test workorders
for my $WorkOrderID ( @{ $IDsToDelete{WorkOrder} }, keys %TestedWorkOrderID ) {
    my $Success = $Self->{WorkOrderObject}->WorkOrderDelete(
        WorkOrderID => $WorkOrderID,
        UserID      => 1,
    );

    $Self->True(
        $Success,
        "Test " . $TestCount++ . ": WorkOrderDelete()",
    );

    # double check WorkOrder it is really deleted
    my $WorkOrderData = $Self->{WorkOrderObject}->WorkOrderGet(
        WorkOrderID => $WorkOrderID,
        UserID      => 1,
    );

    $Self->Is(
        undef,
        $WorkOrderData->{WorkOrderID},
        "Test $TestCount: WorkOrderDelete() - double check",
    );
}

for my $ChangeID ( @{ $IDsToDelete{Change} }, keys %TestedChangeID ) {
    my $Success = $Self->{ChangeObject}->ChangeDelete(
        ChangeID => $ChangeID,
        UserID   => 1,
    );

    $Self->True(
        $Success,
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

    $TestCount++;
}

1;
