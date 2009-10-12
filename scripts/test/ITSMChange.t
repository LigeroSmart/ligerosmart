# --
# ITSMChange.t - change tests
# Copyright (C) 2003-2009 OTRS AG, http://otrs.com/
# --
# $Id: ITSMChange.t,v 1.11 2009-10-12 20:37:00 reb Exp $
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
use Kernel::System::CustomerUser;
use Kernel::System::GeneralCatalog;
use Kernel::System::ITSMChange;

$Self->{GeneralCatalogObject} = Kernel::System::GeneralCatalog->new( %{$Self} );
$Self->{ChangeObject}         = Kernel::System::ITSMChange->new( %{$Self} );
$Self->{UserObject}           = Kernel::System::User->new( %{$Self} );
$Self->{CustomerUserObject}   = Kernel::System::CustomerUser->new( %{$Self} );

# ------------------------------------------------------------ #
# make preparations
# ------------------------------------------------------------ #
my $TestCount = 1;

# create needed users
my @UserIDs;

# create needed users
my @CustomerUserIDs;

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
        ValidID       => 1,
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
        ValidID => 1,
        UserID  => 1,
    );
    push @CustomerUserIDs, $CustomerUserID;
}

# set 3rd user invalid
my %User = $Self->{UserObject}->GetUserData(
    UserID => $UserIDs[2],
);

# set user invalid
$User{ValidID} = $Self->{ChangeObject}->{ValidObject}->ValidLookup(
    Valid => 'invalid',
);
$User{ChangeUserID} = 1;

# update user
$Self->{UserObject}->UserUpdate(
    %User,
);

# restore original email check param
$Self->{ConfigObject}->Set(
    Key   => 'CheckEmailAddresses',
    Value => $CheckEmailAddressesOrg,
);

# ------------------------------------------------------------ #
# test ITSMChange api
# ------------------------------------------------------------ #
my @ObjectMethods = qw(ChangeAdd ChangeDelete ChangeGet ChangeList ChangeSearch ChangeUpdate
    ChangeCABDelete ChangeCABGet ChangeCABUpdate);
for my $ObjectMethod (@ObjectMethods) {
    my $Sub = $Self->{ChangeObject}->can($ObjectMethod);

    $Self->True(
        $Sub,
        "Test " . $TestCount++ . " - check 'can $ObjectMethod'"
    );
}

# ------------------------------------------------------------ #
# search for default ITSMChange-states
# ------------------------------------------------------------ #
# get class list
# can't use qw due to spaces in states
my @DefaultChangeStates = (
    'requested', 'pending approval', 'rejected', 'approved', 'in progress',
    'successful', 'failed', 'retracted'
);
my $ClassList = $Self->{GeneralCatalogObject}->ItemList(
    Class => 'ITSM::ChangeManagement::Change::State',
);
my %ReverseClassList = reverse %{$ClassList};

for my $DefaultChangeState (@DefaultChangeStates) {
    $Self->True(
        $ReverseClassList{$DefaultChangeState},
        "Test " . $TestCount++ . " - check state '$DefaultChangeState'"
    );
}

# ------------------------------------------------------------ #
# define general change tests
# ------------------------------------------------------------ #
my @ChangeTests = (

    # Change doesn't contain all data (required attributes)
    {
        SourceData => {
            ChangeAdd => {},
        },
        Fails => 1,    # we expect this test to fail
    },

    # Change contains only required data - default user (required attributes)
    {
        SourceData => {
            ChangeAdd => {
                UserID => 1,
            },
        },
        ReferenceData => {
            ChangeGet => {
                Title           => undef,
                Description     => undef,
                Justification   => undef,
                ChangeManagerID => 1,
                ChangeBuilderID => 1,
                WorkOrderIDs    => [],
                CABAgents       => [],
                CABCustomers    => [],
                CreateBy        => 1,
                ChangeBy        => 1,
            },
        },
    },

    # Change contains only required data - default user (required attributes)
    {
        SourceData => {
            ChangeAdd => {
                UserID => $UserIDs[0],
            },
        },
        ReferenceData => {
            ChangeGet => {
                Title           => undef,
                Description     => undef,
                Justification   => undef,
                ChangeManagerID => $UserIDs[0],
                ChangeBuilderID => $UserIDs[0],
                WorkOrderIDs    => [],
                CABAgents       => [],
                CABCustomers    => [],
                CreateBy        => $UserIDs[0],
                ChangeBy        => $UserIDs[0],
            },
        },
    },

    # change contains all date - (all attributes)
    {
        SourceData => {
            ChangeAdd => {
                Title           => 'Change 1',
                Description     => 'Description 1',
                Justification   => 'Justification 1',
                ChangeManagerID => $UserIDs[0],
                ChangeBuilder   => $UserIDs[0],
                ChangeBuilder   => $UserIDs[0],
                CABAgents       => [
                    $UserIDs[0],
                    $UserIDs[1]
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
                Title           => 'Change 1',
                Description     => 'Description 1',
                Justification   => 'Justification 1',
                ChangeManagerID => $UserIDs[0],
                ChangeBuilder   => $UserIDs[0],
                ChangeBuilder   => $UserIDs[0],
                CABAgents       => [
                    $UserIDs[0],
                    $UserIDs[1]
                ],
                CABCustomers => [
                    $CustomerUserIDs[0],
                    $CustomerUserIDs[1],
                ],
            },
        },
    },

    # change contains all date - wrong CAB - (wrong CAB attributes)
    {
        SourceData => {
            ChangeAdd => {
                Title           => 'Change 1',
                Description     => 'Description 1',
                Justification   => 'Justification 1',
                ChangeManagerID => $UserIDs[0],
                ChangeBuilder   => $UserIDs[0],
                ChangeBuilder   => $UserIDs[0],
                CABAgents       => [
                    $CustomerUserIDs[0],
                    $CustomerUserIDs[1],
                ],
                CABCustomers => [
                    $UserIDs[0],
                    $UserIDs[1]
                ],
                UserID => $UserIDs[1],
            },
        },
        Fails => 1,
    },

    # Update change without required params (required attributes)
    {
        SourceData => {
            ChangeUpdate => {},
        },
        ReferenceData => {
            ChangeUpdate => undef,
        },
        Fails => 1,    # we expect this test to fail
    },

);

my %TestedChangeID;
TEST:
for my $Test (@ChangeTests) {

    # check SourceData attribute
    if ( !$Test->{SourceData} || ref $Test->{SourceData} ne 'HASH' ) {

        $Self->True(
            0,
            "Test $TestCount: No SourceData found for this test.",
        );

        next TEST;
    }

    # extract test data
    my $SourceData    = $Test->{SourceData};
    my $ReferenceData = $Test->{ReferenceData};

    # add a new Change
    my $ChangeID;
    if ( $SourceData->{ChangeAdd} ) {
        $ChangeID = $Self->{ChangeObject}->ChangeAdd(
            %{ $SourceData->{ChangeAdd} }
        );

        $TestedChangeID{$ChangeID} = 1 if ($ChangeID);

        if ( !$SourceData->{ChangeAdd}->{UserID} ) {
            $Self->False(
                $ChangeID,
                "Test $TestCount: ChangeAdd() - Don't add change without given UserID.",
            );
        }

        if ( $SourceData->{ChangeAdd}->{UserID} ) {
            $Self->True(
                $ChangeID,
                "Test $TestCount: ChangeAdd() - Add change with given UserID.",
            );
        }
    }    # end if 'SourceData'

    if ($ReferenceData) {

        if ( $ReferenceData->{ChangeGet} ) {

            my $ChangeGetReferenceData = $ReferenceData->{ChangeGet};

            my $ChangeData = $Self->{ChangeObject}->ChangeGet(
                ChangeID => $ChangeID,
            );

            $Self->True(
                $ChangeData,
                "Test $TestCount: ChangeGet() - Get change.",
            );

            for my $ChangeAttributes (qw(ChangeID CreateTime ChangeTime)) {
                $Self->True(
                    $ChangeData->{$ChangeAttributes},
                    "Test $TestCount: has $ChangeAttributes.",
                );
            }

            for my $Key ( keys %{$ChangeGetReferenceData} ) {

                # turn off all pretty print
                $Data::Dumper::Indent = 0;

                # dump the attribute from VersionGet()
                my $ChangeAttribute = Data::Dumper::Dumper( $ChangeData->{$Key} );

                # dump the reference attribute
                my $ReferenceAttribute = Data::Dumper::Dumper( $ChangeGetReferenceData->{$Key} );

                $Self->Is(
                    $ChangeAttribute,
                    $ReferenceAttribute,
                    "Test $TestCount: $Key",
                );
            }
        }    # end ChangeGet

        if ( exists $ReferenceData->{ChangeUpdate} ) {
            my $ChangeUpdateSuccess = $Self->{ChangeObject}->ChangeUpdate(
                ChangeID => $ChangeID,
                %{ $SourceData->{ChangeUpdate} },
            );

            $Self->Is(
                $ReferenceData->{ChangeUpdate},
                $ChangeUpdateSuccess,
                "Test $TestCount: ChangeUpdate() - update change.",
            );

        }    # end if ChangeUpdate
    }    # end if 'ReferenceData'
}
continue {
    $TestCount++;
}

# test if ChangeList returns at least as many changes as we created
# we cannot test for a specific number as these tests can be run in existing environments
# where other changes already exist
my $ChangeList = $Self->{ChangeObject}->ChangeList() || [];
$Self->True(
    @{$ChangeList} >= ( keys %TestedChangeID || 0 ),
    'Test ' . $TestCount++ . ': ChangeList() returns at least as many changes as we created',
);

# count all tests that are required to and planned for fail
my $Fails = grep { $_->{Fails} } @ChangeTests;

# test if the changes where created
$Self->Is(
    scalar @ChangeTests - $Fails,
    keys %TestedChangeID || 0,
    'Test ' . $TestCount++ . ': amount of change objects and test cases.',
);

# ------------------------------------------------------------ #
# define general config item search tests
# ------------------------------------------------------------ #

my @ChangeSearchTests = (

    # a simple check if the search functions takes care of "Limit"
    {
        SearchData => {
            Limit => 1,
        },
        ResultData => {
            Count => 1,
            }
    },

    # search for all changes created by our first user
    {
        SearchData => {
            Title         => 'Change 1',
            Justification => 'Justification 1',
        },
        ResultData => {
            Count => 2,
        },
    },

    # search for all changes created by our first user
    #{
    #    Title => '',
    #    Justification => '',
    #},
);

SEARCHTEST:
for my $SearchTest (@ChangeSearchTests) {

    # check SearchData attribute
    if ( ( !$SearchTest->{SearchData} ) || ref( $SearchTest->{SearchData} ) ne 'HASH' ) {

        $Self->True(
            0,
            "Test $TestCount: SearchData found for this test.",
        );

        next SEARCHTEST;
    }

    my $ChangeIDs = $Self->{ChangeObject}->ChangeSearch(
        %{ $SearchTest->{SearchData} },
    );

    $Self->True(
        defined($ChangeIDs) && ref($ChangeIDs) eq 'ARRAY',
        "Test $TestCount: array reference for ChangeIDs.",
    );

    $ChangeIDs ||= [];

    $Self->Is(
        scalar @{$ChangeIDs},
        $SearchTest->{ResultData}->{Count},
        "Test $TestCount: Number of found changes.",
    );
}
continue {
    $TestCount++;
}

# ------------------------------------------------------------ #
# clean the system
# ------------------------------------------------------------ #

# disable email checks to create new user
my $CheckEmailAddressesOrig = $Self->{ConfigObject}->Get('CheckEmailAddresses') || 1;
$Self->{ConfigObject}->Set(
    Key   => 'CheckEmailAddresses',
    Value => 0,
);

# set unittest users invalid
ITEMID:
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
        ChangeUserID => 1
    );
}

# restore original email check param
$Self->{ConfigObject}->Set(
    Key   => 'CheckEmailAddresses',
    Value => $CheckEmailAddressesOrg,
);

# delete the test config items
for my $ChangeID ( keys %TestedChangeID ) {
    $Self->{ChangeObject}->ChangeDelete(
        ChangeID => $ChangeID,
        UserID   => 1,
    );
}

1;
