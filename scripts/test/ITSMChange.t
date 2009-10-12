# --
# ITSMChange.t - change tests
# Copyright (C) 2003-2009 OTRS AG, http://otrs.com/
# --
# $Id: ITSMChange.t,v 1.2 2009-10-12 16:33:14 mae Exp $
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

$Self->{GeneralCatalogObject} = Kernel::System::GeneralCatalog->new( %{$Self} );
$Self->{ChangeObject}         = Kernel::System::ITSMChange->new( %{$Self} );
$Self->{UserObject}           = Kernel::System::User->new( %{$Self} );

# ------------------------------------------------------------ #
# make preparations
# ------------------------------------------------------------ #
my $TestCount = 1;

# create needed users
my @UserIDs;

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

    # extract source data
    my $SourceData = $Test->{SourceData};

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
    if ( $SourceData->{ReferenceData} )
    {
        if ( $SourceData->{ReferenceData} eq "ChangeGet" ) {
            my $ChangeData = $Self->{ChangeObject}->ChangeGet(
                ChangeID => $ChangeID,
            );

            if ( !$ChangeData ) {
                $Self->True(
                    0,
                    "Test $TestCount: ChangeGet() - Get change.",
                );
            }
        }
    }    # end if 'ReferenceData'
    ++$TestCount;
}

$Self->Is(
    keys %TestedChangeID || 0,
    scalar @ChangeTests - 1,    # don't count the first test case, it should not return a change!
    'Test ' . $TestCount++ . ': amount of change objects and test cases.',
);

1;
