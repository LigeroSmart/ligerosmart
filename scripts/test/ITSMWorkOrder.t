# --
# ITSMWorkOrder.t - workorder tests
# Copyright (C) 2003-2009 OTRS AG, http://otrs.com/
# --
# $Id: ITSMWorkOrder.t,v 1.12 2009-10-15 12:48:53 bes Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use utf8;

use vars qw($Self);

#use Data::Dumper;
use Kernel::System::User;

#use Kernel::System::CustomerUser;
#use Kernel::System::GeneralCatalog;
#use Kernel::System::ITSMChange;
use Kernel::System::ITSMChange::WorkOrder;

# ------------------------------------------------------------ #
# make preparations
# ------------------------------------------------------------ #
my $TestCount = 1;

# create common objects
$Self->{UserObject}      = Kernel::System::User->new( %{$Self} );
$Self->{ChangeObject}    = Kernel::System::ITSMChange->new( %{$Self} );
$Self->{WorkOrderObject} = Kernel::System::ITSMChange::WorkOrder->new( %{$Self} );
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

# create invalid user IDs
for ( 1 .. 2 ) {
    LPC:
    for my $LoopProtectionCounter ( 1 .. 100 ) {
        my $TempInvalidUserID = int rand 1_000_000;
        next LPC
            if (
            defined $Self->{UserObject}->GetUserData(
                UserID => $TempInvalidUserID,
            )
            );

        # we got unused user ID
        push @NonExistingUserIDs, $TempInvalidUserID;
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

# define public interface
my @ObjectMethods = qw(
    WorkOrderAdd
    WorkOrderDelete
    WorkOrderGet
    WorkOrderList
    WorkOrderSearch
    WorkOrderUpdate
    WorkOrderChangeStartGet
    WorkOrderChangeEndGet
);

# check if subs are available
for my $ObjectMethod (@ObjectMethods) {
    $Self->True(
        $Self->{WorkOrderObject}->can($ObjectMethod),
        "Test " . $TestCount++ . " - check 'can $ObjectMethod'"
    );
}

# ------------------------------------------------------------ #
# Define the changes that are needed for testing workorders
# ------------------------------------------------------------ #

# store current TestCount for better test case recognition
my $TestCountMisc   = $TestCount;
my $UniqueSignature = 'UnitTest-ITSMChange::WorkOrder-' . int( rand 1_000_000 ) . '_' . time;
my @ChangeTests     = (

    # change contains all date - (all attributes)
    {
        Description => 'First change for testing workorders.',
        SourceData  => {
            ChangeAdd => {
                Title         => 'Change 1 - ' . $UniqueSignature,
                Description   => 'Description 1',
                Justification => 'Justification 1',
                UserID        => $UserIDs[0],
            },
        },
        ReferenceData => {
            ChangeGet => {
                Title         => 'Change 1 - ' . $UniqueSignature,
                Description   => 'Description 1',
                Justification => 'Justification 1',
            },
        },
    },
);

# ------------------------------------------------------------ #
# Create the changes that are needed for testing workorders
# ------------------------------------------------------------ #

my %TestedChangeID;           # change ids of created changes
my %ChangeIDForSearchTest;    # change ids that are expected to be found by a search test

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
        }

        # change CreateTime
        if ( $ChangeID && $SourceData->{ChangeAddChangeTime} ) {
            SetChangeTimes(
                ChangeID   => $ChangeID,
                CreateTime => $SourceData->{ChangeAddChangeTime}->{CreateTime},
            );
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
            qw(ChangeID WorkOrderNumber WorkOrderAgentID CreateTime ChangeTime)
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
# Define the general workorder tests
# ------------------------------------------------------------ #

my ($WorkOrderAddTestID) = keys %TestedChangeID;

my @WorkOrderTests = (

    #------------------------------#
    # Tests on WorkOrderAdd
    #------------------------------#

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
    },

    {
        Description => 'WorkOrderAdd() with string parameters.',
        SourceData  => {
            WorkOrderAdd => {
                UserID      => 1,
                ChangeID    => $WorkOrderAddTestID,
                Title       => 'Replacement of mail server',
                Instruction => 'Install the the new server',
                Report      => 'Installed new server without problems',
            },
        },
        ReferenceData => {
            WorkOrderGet => {
                ChangeID    => $WorkOrderAddTestID,
                Title       => 'Replacement of mail server',
                Instruction => 'Install the the new server',
                Report      => 'Installed new server without problems',
            },
        },
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
    },
);

# ------------------------------------------------------------ #
# execute the general workorder tests
# ------------------------------------------------------------ #

my %TestedWorkOrderID;         # ids of all created workorders
my %WorkOrderIDForChangeID;    # keep track of the workorders that are attached to a change

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
        }

        # change CreateTime
        if ( $WorkOrderID && $SourceData->{WorkOrderAddChangeTime} ) {
            SetTimes(
                WorkOrderID => $WorkOrderID,
                CreateTime  => $SourceData->{WorkOrderAddChangeTime}->{CreateTime},
            );
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

    # get a change and compare the retrieved data with the reference
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
                "Test $TestCount: |- $ReferenceAttribute",
            );
        }
    }    # end if 'WorkOrderGet'
}
continue {

    # increase the test count, even on next
    $TestCount++;
}

# ------------------------------------------------------------ #
# test WorkOrderList()
# ------------------------------------------------------------ #

# Test whether WorkOrderList returns at least as many workorder as we created.
# We cannot test for a specific number as these tests can be run in existing environments
# where other changes already exist.
for my $ChangeID ( sort keys %WorkOrderIDForChangeID ) {
    my $WorkOrderList = $Self->{WorkOrderObject}->WorkOrderList(
        UserID   => 1,
        ChangeID => $ChangeID
    ) || [];
    my %WorkOrderListMap = map { $_ => 1 } @{$WorkOrderList};

    # check whether the created workorders were found by WorkOrderList()
    for my $WorkOrderID ( sort keys %{ $WorkOrderIDForChangeID{$ChangeID} } ) {
        $Self->True(
            $WorkOrderListMap{$WorkOrderID},
            'Test ' . $TestCount++ . ": WorkOrderList() - WorkOrderID $WorkOrderID in list.",
        );
    }
}

# count all tests that are required to and planned for fail
my $Fails = scalar grep { $_->{Fails} } @WorkOrderTests;
my $NrCreateWorkOrders = ( scalar @WorkOrderTests ) - $Fails;

# test if the changes were created
$Self->Is(
    scalar keys %TestedWorkOrderID || 0,
    $NrCreateWorkOrders,
    'Test ' . $TestCount++ . ': amount of workorder objects and test cases.',
);

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

# delete the test changes
for my $WorkOrderID ( keys %TestedWorkOrderID ) {
    $Self->True(
        $Self->{WorkOrderObject}->WorkOrderDelete(
            WorkOrderID => $WorkOrderID,
            UserID      => 1,
        ),
        "Test " . $TestCount++ . ": WorkOrderDelete()",
    );
}

=over 4

=item SetTimes()

Set new values for CreateTime and ChangeTime for a given workorder.

    my $UpdateSuccess = SetTimes(
        WorkOrderID => 123,
        CreateTime => '2009-10-30 01:00:15',
        ChangeTime => '2009-10-30 01:00:15',
    );

=back

=cut

sub SetTimes {
    my (%Param) = @_;

    # check parameters
    if ( !$Param{CreateTime} && !$Param{ChangeTime} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need parameter CreateTime or ChangeTime!',
        );
        return;
    }

    my @Bind;
    my $SQL = 'UPDATE change_workorder SET ';

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
