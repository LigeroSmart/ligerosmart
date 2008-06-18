# --
# ITSMLocation.t - location tests
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: ITSMLocation.t,v 1.1 2008-06-18 17:27:04 ub Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

use strict;
use warnings;
use utf8;

use vars qw($Self);

use Kernel::System::ITSMLocation;
use Kernel::System::User;

$Self->{LocationObject} = Kernel::System::ITSMLocation->new( %{$Self} );
$Self->{UserObject}     = Kernel::System::User->new( %{$Self} );

# ------------------------------------------------------------ #
# make preparations
# ------------------------------------------------------------ #

# create needed users
my @UserIDs;
{

    # disable email checks to create new user
    my $CheckEmailAddressesOrg = $Self->{ConfigObject}->Get('CheckEmailAddresses') || 1;
    $Self->{ConfigObject}->Set(
        Key   => 'CheckEmailAddresses',
        Value => 0,
    );

    for my $Counter ( 1 .. 2 ) {

        # create new users for the tests
        my $UserID = $Self->{UserObject}->UserAdd(
            UserFirstname => 'ITSMLocation' . $Counter,
            UserLastname  => 'UnitTest',
            UserLogin     => 'UnitTest-ITSMLocation-' . $Counter . int rand 1_000_000,
            UserEmail     => 'UnitTest-ITSMLocation-' . $Counter . '@localhost',
            ValidID       => 1,
            ChangeUserID  => 1,
        );

        push @UserIDs, $UserID;
    }

    # restore original email check param
    $Self->{ConfigObject}->Set(
        Key   => 'CheckEmailAddresses',
        Value => $CheckEmailAddressesOrg,
    );
}

# create needed random location names
my @LocationName;

for my $Counter ( 1 .. 11 ) {

    push @LocationName, 'UnitTest' . int rand 1_000_000;
}

# get original location list for later checks
my %LocationListOriginal = $Self->{LocationObject}->LocationList(
    Valid  => 0,
    UserID => 1,
);

# ------------------------------------------------------------ #
# define general tests
# ------------------------------------------------------------ #

my $ItemData = [

    # this location is NOT complete and must not be added
    {
        Add => {
            TypeID  => 1,
            ValidID => 1,
            UserID  => 1,
        },
    },

    # this location is NOT complete and must not be added
    {
        Add => {
            Name    => $LocationName[0],
            ValidID => 1,
            UserID  => 1,
        },
    },

    # this location is NOT complete and must not be added
    {
        Add => {
            Name   => $LocationName[0],
            TypeID => 1,
            UserID => 1,
        },
    },

    # this location is NOT complete and must not be added
    {
        Add => {
            Name    => $LocationName[0],
            TypeID  => 1,
            ValidID => 1,
        },
    },

    # this location must be inserted sucessfully
    {
        Add => {
            Name    => $LocationName[0],
            TypeID  => 1,
            ValidID => 1,
            UserID  => 1,
        },
        AddGet => {
            ParentID  => '',
            Name      => $LocationName[0],
            NameShort => $LocationName[0],
            TypeID    => 1,
            Phone1    => '',
            Phone2    => '',
            Fax       => '',
            Email     => '',
            Address   => '',
            ValidID   => 1,
            Comment   => '',
            CreateBy  => 1,
            ChangeBy  => 1,
        },
    },

    # this location have the same name as one test before and must not be added
    {
        Add => {
            Name    => $LocationName[0],
            TypeID  => 1,
            ValidID => 1,
            UserID  => 1,
        },
    },

    # the location one add-test before must be NOT updated (location is NOT complete)
    {
        Update => {
            TypeID  => 1,
            ValidID => 1,
            UserID  => 1,
        },
    },

    # the location one add-test before must be NOT updated (location is NOT complete)
    {
        Update => {
            Name    => $LocationName[0] . 'UPDATE1',
            ValidID => 1,
            UserID  => 1,
        },
    },

    # the location one add-test before must be NOT updated (location is NOT complete)
    {
        Update => {
            Name   => $LocationName[0] . 'UPDATE1',
            TypeID => 1,
            UserID => 1,
        },
    },

    # the location one add-test before must be NOT updated (location is NOT complete)
    {
        Update => {
            Name    => $LocationName[0] . 'UPDATE1',
            TypeID  => 1,
            ValidID => 1,
        },
    },

    # this location must be inserted sucessfully
    {
        Add => {
            Name    => $LocationName[1],
            TypeID  => 1,
            Phone1  => '+49 (0)9999 11111 1',
            Phone2  => '+49 (0)9999 11111 2',
            Fax     => '+49 (0)9999 11111 3',
            Email   => 'test@test.de',
            Address => "TestAdress\nTestAdress",
            ValidID => 1,
            Comment => 'TestComment',
            UserID  => 1,
        },
        AddGet => {
            ParentID  => '',
            Name      => $LocationName[1],
            NameShort => $LocationName[1],
            TypeID    => 1,
            Phone1    => '+49 (0)9999 11111 1',
            Phone2    => '+49 (0)9999 11111 2',
            Fax       => '+49 (0)9999 11111 3',
            Email     => 'test@test.de',
            Address   => "TestAdress\nTestAdress",
            ValidID   => 1,
            Comment   => 'TestComment',
            CreateBy  => 1,
            ChangeBy  => 1,
        },
    },

    # the location one add-test before must be NOT updated (location update arguments NOT complete)
    {
        Update => {
            TypeID  => 1,
            ValidID => 1,
            UserID  => 1,
        },
    },

    # the location one add-test before must be NOT updated (location update arguments NOT complete)
    {
        Update => {
            Name    => $LocationName[1] . 'UPDATE1',
            ValidID => 1,
            UserID  => 1,
        },
    },

    # the location one add-test before must be NOT updated (location update arguments NOT complete)
    {
        Update => {
            Name   => $LocationName[1] . 'UPDATE1',
            TypeID => 1,
            UserID => 1,
        },
    },

    # the location one add-test before must be NOT updated (location update arguments NOT complete)
    {
        Update => {
            Name    => $LocationName[1] . 'UPDATE1',
            TypeID  => 1,
            ValidID => 1,
        },
    },

    # the location one add-test before must be updated (location update arguments are complete)
    {
        Update => {
            Name    => $LocationName[1] . 'UPDATE2',
            TypeID  => 2,
            Phone1  => '+49 (0)9999 11111 4',
            Phone2  => '+49 (0)9999 11111 5',
            Fax     => '+49 (0)9999 11111 6',
            Email   => 'test2@test2.de',
            Address => "TestAdress2\nTestAdress2",
            ValidID => 1,
            Comment => 'TestCommentUPDATE2',
            UserID  => $UserIDs[0],
        },
        UpdateGet => {
            ParentID  => '',
            Name      => $LocationName[1] . 'UPDATE2',
            NameShort => $LocationName[1] . 'UPDATE2',
            TypeID    => 2,
            Phone1    => '+49 (0)9999 11111 4',
            Phone2    => '+49 (0)9999 11111 5',
            Fax       => '+49 (0)9999 11111 6',
            Email     => 'test2@test2.de',
            Address   => "TestAdress2\nTestAdress2",
            ValidID   => 1,
            Comment   => 'TestCommentUPDATE2',
            CreateBy  => 1,
            ChangeBy  => $UserIDs[0],
        },
    },

    # the location one add-test before must be updated (location update arguments are complete)
    {
        Update => {
            Name    => $LocationName[1] . 'UPDATE3',
            TypeID  => 3,
            Phone1  => '+49 (0)9999 11111 7',
            Phone2  => '+49 (0)9999 11111 8',
            Fax     => '+49 (0)9999 11111 9',
            Email   => 'test3@test3.de',
            Address => "TestAdress3\nTestAdress3",
            ValidID => 1,
            Comment => 'TestCommentUPDATE3',
            UserID  => $UserIDs[1],
        },
        UpdateGet => {
            ParentID  => '',
            Name      => $LocationName[1] . 'UPDATE3',
            NameShort => $LocationName[1] . 'UPDATE3',
            TypeID    => 3,
            Phone1    => '+49 (0)9999 11111 7',
            Phone2    => '+49 (0)9999 11111 8',
            Fax       => '+49 (0)9999 11111 9',
            Email     => 'test3@test3.de',
            Address   => "TestAdress3\nTestAdress3",
            ValidID   => 1,
            Comment   => 'TestCommentUPDATE3',
            CreateBy  => 1,
            ChangeBy  => $UserIDs[1],
        },
    },

    # this location has an invalid name and must be NOT inserted
    {
        Update => {
            Name    => $LocationName[1] . '::UPDATE4',
            TypeID  => 1,
            ValidID => 1,
            UserID  => 1,
        },
    },

    # this location has an invalid name and must be NOT inserted
    {
        Update => {
            Name    => $LocationName[1] . '::Test::UPDATE4',
            TypeID  => 1,
            ValidID => 1,
            UserID  => 1,
        },
    },

    # this location has an invalid name and must be NOT inserted
    {
        Add => {
            Name    => $LocationName[2] . '::Test',
            TypeID  => 1,
            ValidID => 1,
            UserID  => 1,
        },
    },

    # this location has an invalid name and must be NOT inserted
    {
        Add => {
            Name    => $LocationName[2] . '::Test::Test',
            TypeID  => 1,
            ValidID => 1,
            UserID  => 1,
        },
    },

    # this location must be inserted sucessfully (check string cleaner function)
    {
        Add => {
            Name    => " \t \n \r " . $LocationName[3] . " \t \n \r ",
            TypeID  => 1,
            Phone1  => " \t \n \r +49 (0)9999 \t \n \r 11111 1 \t \n \r ",
            Phone2  => " \t \n \r +49 (0)9999 \t \n \r 11111 2 \t \n \r ",
            Fax     => " \t \n \r +49 (0)9999 \t \n \r 11111 3 \t \n \r ",
            Email   => " \t \n \r test@ \t \n \r test .de \t \n \r ",
            Address => " \t \n \r Test Adress\nTest Adress \t \n \r ",
            ValidID => 1,
            Comment => " \t \n \r Test Comment \t \n \r ",
            UserID  => 1,
        },
        AddGet => {
            ParentID  => '',
            Name      => $LocationName[3],
            NameShort => $LocationName[3],
            TypeID    => 1,
            Phone1    => '+49 (0)9999    11111 1',
            Phone2    => '+49 (0)9999    11111 2',
            Fax       => '+49 (0)9999    11111 3',
            Email     => 'test@test.de',
            Address   => "Test Adress\nTest Adress",
            ValidID   => 1,
            Comment   => 'Test Comment',
            CreateBy  => 1,
            ChangeBy  => 1,
        },
    },

    # the location one add-test before must be updated sucessfully (check string cleaner function)
    {
        Update => {
            Name    => " \t \n \r " . $LocationName[3] . " UPDATE1 \t \n \r ",
            TypeID  => 2,
            Phone1  => " \t \n \r +49 (0)9999 \t \n \r 11111 1 UPDATE1 \t \n \r ",
            Phone2  => " \t \n \r +49 (0)9999 \t \n \r 11111 2 UPDATE1 \t \n \r ",
            Fax     => " \t \n \r +49 (0)9999 \t \n \r 11111 3 UPDATE1 \t \n \r ",
            Email   => " \t \n \r test2@ \t \n \r test2 .de \t \n \r ",
            Address => " \t \n \r Test Adress\nTest Adress UPDATE1 \t \n \r ",
            ValidID => 2,
            Comment => " \t \n \r Test Comment UPDATE1 \t \n \r ",
            UserID  => $UserIDs[1],
        },
        UpdateGet => {
            ParentID  => '',
            Name      => $LocationName[3] . ' UPDATE1',
            NameShort => $LocationName[3] . ' UPDATE1',
            TypeID    => 2,
            Phone1    => '+49 (0)9999    11111 1 UPDATE1',
            Phone2    => '+49 (0)9999    11111 2 UPDATE1',
            Fax       => '+49 (0)9999    11111 3 UPDATE1',
            Email     => 'test2@test2.de',
            Address   => "Test Adress\nTest Adress UPDATE1",
            ValidID   => 2,
            Comment   => 'Test Comment UPDATE1',
            CreateBy  => 1,
            ChangeBy  => $UserIDs[1],
        },
    },

    # this location must be inserted sucessfully (unicode checks)
    {
        Add => {
            Name    => $LocationName[4] . ' ϒ ϡ Ʃ Ϟ ',
            TypeID  => 1,
            Phone1  => ' δ Ψ +49 (0)9999 11111 1 Λ ά ',
            Phone2  => ' ε ζ +49 (0)9999 11111 2 ή β ',
            Fax     => ' λ μ +49 (0)9999 11111 3 Π ξ ',
            Email   => ' test π φ @test.de ',
            Address => " ό ώ TestAdress\nTestAdress ϒ ϓ ",
            ValidID => 1,
            Comment => ' Ѡ Ѥ TestComment Ϡ Ω ',
            UserID  => 1,
        },
        AddGet => {
            ParentID  => '',
            Name      => $LocationName[4] . ' ϒ ϡ Ʃ Ϟ',
            NameShort => $LocationName[4] . ' ϒ ϡ Ʃ Ϟ',
            TypeID    => 1,
            Phone1    => 'δ Ψ +49 (0)9999 11111 1 Λ ά',
            Phone2    => 'ε ζ +49 (0)9999 11111 2 ή β',
            Fax       => 'λ μ +49 (0)9999 11111 3 Π ξ',
            Email     => 'testπφ@test.de',
            Address   => "ό ώ TestAdress\nTestAdress ϒ ϓ",
            ValidID   => 1,
            Comment   => 'Ѡ Ѥ TestComment Ϡ Ω',
            CreateBy  => 1,
            ChangeBy  => 1,
        },
    },

    # the location one add-test before must be updated sucessfully (unicode checks)
    {
        Update => {
            Name    => $LocationName[4] . ' ϒ ϡ Ʃ Ϟ UPDATE1 ',
            TypeID  => 2,
            Phone1  => ' δ Ψ +49 (0)9999 11111 1 Λ ά UPDATE1 ',
            Phone2  => ' ε ζ +49 (0)9999 11111 2 ή β UPDATE1 ',
            Fax     => ' λ μ +49 (0)9999 11111 3 Π ξ UPDATE1 ',
            Email   => ' test π φ @test2.de ',
            Address => " ό ώ TestAdress\nTestAdress ϒ ϓ UPDATE1 ",
            ValidID => 2,
            Comment => ' Ѡ Ѥ TestComment Ϡ Ω UPDATE1',
            UserID  => $UserIDs[0],
        },
        UpdateGet => {
            ParentID  => '',
            Name      => $LocationName[4] . ' ϒ ϡ Ʃ Ϟ UPDATE1',
            NameShort => $LocationName[4] . ' ϒ ϡ Ʃ Ϟ UPDATE1',
            TypeID    => 2,
            Phone1    => 'δ Ψ +49 (0)9999 11111 1 Λ ά UPDATE1',
            Phone2    => 'ε ζ +49 (0)9999 11111 2 ή β UPDATE1',
            Fax       => 'λ μ +49 (0)9999 11111 3 Π ξ UPDATE1',
            Email     => 'testπφ@test2.de',
            Address   => "ό ώ TestAdress\nTestAdress ϒ ϓ UPDATE1",
            ValidID   => 2,
            Comment   => 'Ѡ Ѥ TestComment Ϡ Ω UPDATE1',
            CreateBy  => 1,
            ChangeBy  => $UserIDs[0],
        },
    },

    # this location must be inserted sucessfully (special character checks)
    {
        Add => {
            Name    => ' [test]%*\\ ' . $LocationName[8] . ' [test]%*\\ ',
            TypeID  => 1,
            ValidID => 1,
            Comment => ' [test]%*\\ Test Comment [test]%*\\ ',
            UserID  => 1,
        },
        AddGet => {
            ParentID  => '',
            Name      => '[test]%*\\ ' . $LocationName[8] . ' [test]%*\\',
            NameShort => '[test]%*\\ ' . $LocationName[8] . ' [test]%*\\',
            TypeID    => 1,
            ValidID   => 1,
            Comment   => '[test]%*\\ Test Comment [test]%*\\',
            CreateBy  => 1,
            ChangeBy  => 1,
        },
    },

    # the location one add-test before must be updated sucessfully (special character checks)
    {
        Update => {
            Name    => ' [test]%*\\ ' . $LocationName[8] . ' UPDATE1 [test]%*\\ ',
            TypeID  => 2,
            ValidID => 2,
            Comment => ' [test]%*\\ Test Comment UPDATE1 [test]%*\\ ',
            UserID  => $UserIDs[1],
        },
        UpdateGet => {
            ParentID  => '',
            Name      => '[test]%*\\ ' . $LocationName[8] . ' UPDATE1 [test]%*\\',
            NameShort => '[test]%*\\ ' . $LocationName[8] . ' UPDATE1 [test]%*\\',
            TypeID    => 2,
            ValidID   => 2,
            Comment   => '[test]%*\\ Test Comment UPDATE1 [test]%*\\',
            CreateBy  => 1,
            ChangeBy  => $UserIDs[1],
        },
    },

    # this location must be inserted sucessfully (used for the following tests)
    {
        Add => {
            Name    => $LocationName[5],
            TypeID  => 1,
            ValidID => 1,
            UserID  => 1,
        },
        AddGet => {
            ParentID  => '',
            Name      => $LocationName[5],
            NameShort => $LocationName[5],
            TypeID    => 1,
            ValidID   => 1,
            CreateBy  => 1,
            ChangeBy  => 1,
        },
    },

    # this location must be inserted sucessfully (parent location check)
    {
        Add => {
            ParentID => 'LASTADDID',
            Name     => $LocationName[6],
            TypeID   => 1,
            ValidID  => 1,
            UserID   => 1,
        },
        AddGet => {
            ParentID  => 'LASTADDID',
            Name      => $LocationName[5] . '::' . $LocationName[6],
            NameShort => $LocationName[6],
            TypeID    => 1,
            ValidID   => 1,
            CreateBy  => 1,
            ChangeBy  => 1,
        },
    },

    # this location must be inserted sucessfully (parent location check)
    {
        Add => {
            ParentID => 'LASTADDID',
            Name     => " \n \t " . $LocationName[7] . " \n \t ",
            TypeID   => 1,
            ValidID  => 1,
            UserID   => 1,
        },
        AddGet => {
            ParentID  => 'LASTADDID',
            Name      => $LocationName[5] . '::' . $LocationName[6] . '::' . $LocationName[7],
            NameShort => $LocationName[7],
            TypeID    => 1,
            ValidID   => 1,
            CreateBy  => 1,
            ChangeBy  => 1,
        },
    },

    # the location must be NOT updated (parent location id and parent id are identical)
    {
        Update => {
            ParentID => 'LASTADDID',
            Name     => $LocationName[7] . 'UPDATE1',
            TypeID   => 1,
            ValidID  => 1,
            UserID   => 1,
        },
    },

    # this location must be updated sucessfully (move location to the higherst level)
    {
        Update => {
            ParentID => '',
            Name     => $LocationName[7] . ' UPDATE1',
            TypeID   => 1,
            ValidID  => 1,
            UserID   => 1,
        },
        UpdateGet => {
            ParentID  => '',
            Name      => $LocationName[7] . ' UPDATE1',
            NameShort => $LocationName[7] . ' UPDATE1',
            TypeID    => 1,
            ValidID   => 1,
            CreateBy  => 1,
            ChangeBy  => 1,
        },
    },

    # this location must be updated sucessfully (move location back with the old parent location)
    {
        Update => {
            ParentID => 'LASTLASTADDID',
            Name     => $LocationName[7] . ' UPDATE2',
            TypeID   => 1,
            ValidID  => 1,
            UserID   => 1,
        },
        UpdateGet => {
            ParentID => 'LASTLASTADDID',
            Name     => $LocationName[5] . '::'
                . $LocationName[6] . '::'
                . $LocationName[7]
                . ' UPDATE2',
            NameShort => $LocationName[7] . ' UPDATE2',
            TypeID    => 1,
            ValidID   => 1,
            CreateBy  => 1,
            ChangeBy  => 1,
        },
    },
];

# ------------------------------------------------------------ #
# run general tests
# ------------------------------------------------------------ #

my $TestCount = 1;
my $LastAddedLocationID;
my $LastLastAddedLocationID;
my $AddedCounter = 0;

for my $Item ( @{$ItemData} ) {

    if ( $Item->{Add} ) {

        # prepare parent id
        if ( $Item->{Add}->{ParentID} && $Item->{Add}->{ParentID} eq 'LASTADDID' ) {
            $Item->{Add}->{ParentID} = $LastAddedLocationID;
        }
        elsif ( $Item->{Add}->{ParentID} && $Item->{Add}->{ParentID} eq 'LASTLASTADDID' ) {
            $Item->{Add}->{ParentID} = $LastLastAddedLocationID;
        }
        else {
            delete $Item->{Add}->{ParentID};
        }

        # add new location
        my $LocationID = $Self->{LocationObject}->LocationAdd(
            %{ $Item->{Add} },
        );

        # check if location was added successfully or not
        if ( $Item->{AddGet} ) {

            # prepare parent id
            if ( $Item->{AddGet}->{ParentID} && $Item->{AddGet}->{ParentID} eq 'LASTADDID' ) {
                $Item->{AddGet}->{ParentID} = $LastAddedLocationID;
            }
            elsif ( $Item->{AddGet}->{ParentID} && $Item->{AddGet}->{ParentID} eq 'LASTLASTADDID' )
            {
                $Item->{AddGet}->{ParentID} = $LastLastAddedLocationID;
            }

            $Self->True(
                $LocationID,
                "Test $TestCount: LocationAdd() - LocationID: $LocationID",
            );

            if ($LocationID) {

                # lookup location name
                my $LocationName = $Self->{LocationObject}->LocationLookup(
                    LocationID => $LocationID,
                );

                # lookup test
                $Self->Is(
                    $LocationName || '',
                    $Item->{AddGet}->{Name} || '',
                    "Test $TestCount: LocationLookup() - lookup",
                );

                # reverse lookup the location id
                my $LocationIDNew = $Self->{LocationObject}->LocationLookup(
                    Name => $LocationName || '',
                );

                # reverse lookup test
                $Self->Is(
                    $LocationIDNew || '',
                    $LocationID    || '',
                    "Test $TestCount: LocationLookup() - reverse lookup",
                );

                # set last location id variable
                $LastLastAddedLocationID = $LastAddedLocationID;
                $LastAddedLocationID     = $LocationID;

                # increment the added counter
                $AddedCounter++;
            }
        }
        else {
            $Self->False(
                $LocationID,
                "Test $TestCount: LocationAdd()",
            );
        }

        # get location data to check the values after creation of the location
        my %LocationGet = $Self->{LocationObject}->LocationGet(
            LocationID => $LocationID,
            UserID     => $Item->{Add}->{UserID},
        );

        # check location data after creation of the location
        for my $LocationAttribute ( keys %{ $Item->{AddGet} } ) {
            $Self->Is(
                $LocationGet{$LocationAttribute} || '',
                $Item->{AddGet}->{$LocationAttribute} || '',
                "Test $TestCount: LocationGet() - $LocationAttribute",
            );
        }
    }

    if ( $Item->{Update} ) {

        # check last location id varaible
        if ( !$LastAddedLocationID ) {
            $Self->False(
                1,
                "Test $TestCount: NO LAST SERVICE ID GIVEN",
            );
        }

        # prepare parent id
        if ( $Item->{Update}->{ParentID} && $Item->{Update}->{ParentID} eq 'LASTADDID' ) {
            $Item->{Update}->{ParentID} = $LastAddedLocationID;
        }
        elsif ( $Item->{Update}->{ParentID} && $Item->{Update}->{ParentID} eq 'LASTLASTADDID' ) {
            $Item->{Update}->{ParentID} = $LastLastAddedLocationID;
        }
        else {
            delete $Item->{Update}->{ParentID};
        }

        # update the location
        my $UpdateSucess = $Self->{LocationObject}->LocationUpdate(
            %{ $Item->{Update} },
            LocationID => $LastAddedLocationID,
        );

        # check if location was updated successfully or not
        if ( $Item->{UpdateGet} ) {
            $Self->True(
                $UpdateSucess,
                "Test $TestCount: LocationUpdate() - LocationID: $LastAddedLocationID",
            );
        }
        else {
            $Self->False(
                $UpdateSucess,
                "Test $TestCount: LocationUpdate()",
            );
        }

        # prepare parent id
        if ( $Item->{UpdateGet}->{ParentID} && $Item->{UpdateGet}->{ParentID} eq 'LASTADDID' ) {
            $Item->{UpdateGet}->{ParentID} = $LastAddedLocationID;
        }
        elsif (
            $Item->{UpdateGet}->{ParentID}
            && $Item->{UpdateGet}->{ParentID} eq 'LASTLASTADDID'
            )
        {
            $Item->{UpdateGet}->{ParentID} = $LastLastAddedLocationID;
        }

        # get location data to check the values after the update
        my %LocationGet2 = $Self->{LocationObject}->LocationGet(
            LocationID => $LastAddedLocationID,
            UserID     => $Item->{Update}->{UserID},
        );

        # check location data after update
        for my $LocationAttribute ( keys %{ $Item->{UpdateGet} } ) {
            $Self->Is(
                $LocationGet2{$LocationAttribute} || '',
                $Item->{UpdateGet}->{$LocationAttribute} || '',
                "Test $TestCount: LocationGet() - $LocationAttribute",
            );
        }

        # lookup location name
        my $LocationName = $Self->{LocationObject}->LocationLookup(
            LocationID => $LocationGet2{LocationID},
        );

        # lookup test
        $Self->Is(
            $LocationName || '',
            $LocationGet2{Name} || '',
            "Test $TestCount: LocationLookup() - lookup",
        );

        # reverse lookup the location id
        my $LocationIDNew = $Self->{LocationObject}->LocationLookup(
            Name => $LocationName || '',
        );

        # reverse lookup test
        $Self->Is(
            $LocationIDNew || '',
            $LocationGet2{LocationID} || '',
            "Test $TestCount: LocationLookup() - reverse lookup",
        );
    }

    $TestCount++;
}

# ------------------------------------------------------------ #
# LocationList test 1 (check general functionality)
# ------------------------------------------------------------ #

my %LocationList1 = $Self->{LocationObject}->LocationList(
    Valid  => 0,
    UserID => 1,
);
my %LocationList1Org = %LocationListOriginal;

for my $LocationID ( keys %LocationList1Org ) {

    if (
        $LocationList1{$LocationID}
        && $LocationList1Org{$LocationID} eq $LocationList1{$LocationID}
        )
    {
        delete $LocationList1{$LocationID};
    }
    else {
        $LocationList1{Dummy} = 1;
    }
}

my $LocationList1Count = scalar keys %LocationList1;

$Self->Is(
    $LocationList1Count || '',
    $AddedCounter       || '',
    "Test $TestCount: LocationList()",
);

$TestCount++;

# ------------------------------------------------------------ #
# LocationList test 2 (check cache)
# ------------------------------------------------------------ #

my %LocationList2 = $Self->{LocationObject}->LocationList(
    Valid  => 0,
    UserID => 1,
);

my $LocationList2LocationID = $Self->{LocationObject}->LocationAdd(
    Name    => $LocationName[9],
    TypeID  => 1,
    ValidID => 1,
    UserID  => 1,
);

my %LocationList2b = $Self->{LocationObject}->LocationList(
    Valid  => 0,
    UserID => 1,
);

for my $LocationID ( keys %LocationList2 ) {

    if (
        $LocationList2b{$LocationID}
        && $LocationList2{$LocationID} eq $LocationList2b{$LocationID}
        )
    {
        delete $LocationList2b{$LocationID};
    }
    else {
        $LocationList2b{Dummy} = 1;
    }
}

my @LocationList2IDs   = keys %LocationList2b;
my $LocationList2Count = scalar @LocationList2IDs;

$Self->Is(
    $LocationList2Count || '',
    1,
    "Test $TestCount: LocationList() - check number of locations",
);

$Self->Is(
    $LocationList2IDs[0] || '',
    $LocationList2LocationID || '',
    "Test $TestCount: LocationList() - check id of last location",
);

$TestCount++;

# ------------------------------------------------------------ #
# LocationSearch test 1 (check general functionality)
# ------------------------------------------------------------ #

my @LocationSearch1Search = $Self->{LocationObject}->LocationSearch(
    Valid  => 0,
    UserID => 1,
);

my %LocationSearch1List = $Self->{LocationObject}->LocationList(
    Valid  => 0,
    UserID => 1,
);

for my $LocationID (@LocationSearch1Search) {

    if ( $LocationSearch1List{$LocationID} ) {
        delete $LocationSearch1List{$LocationID};
    }
    else {
        $LocationSearch1List{Dummy} = 1;
    }
}

my $LocationSearch1Count = scalar keys %LocationSearch1List;

$Self->Is(
    $LocationSearch1Count,
    0,
    "Test $TestCount: LocationSearch()",
);

$TestCount++;

# ------------------------------------------------------------ #
# make preparations for later tests
# ------------------------------------------------------------ #

# add some needed locations for later tests
my @LocationNames = ( $LocationName[10] . 'Normal', $LocationName[10] . 'Ԉ Ӵ Ϫ Ͼ' );
my %LocationSearch2LocationID;

my $Counter1 = 0;
for my $LocationName (@LocationNames) {

    $LocationSearch2LocationID{$Counter1} = $Self->{LocationObject}->LocationAdd(
        Name    => $LocationName,
        TypeID  => 1,
        ValidID => 1,
        UserID  => 1,
    );

    $Counter1++;
}

# ------------------------------------------------------------ #
# LocationSearch test 2 (general name checks)
# ------------------------------------------------------------ #

my $Counter2 = 0;
for my $LocationName (@LocationNames) {

    my @PreparedNames = (
        $LocationName,
        '*' . $LocationName,
        $LocationName . '*',
        '*' . $LocationName . '*',
        '**' . $LocationName,
        $LocationName . '**',
        '**' . $LocationName . '**',
    );

    for my $PreparedName (@PreparedNames) {

        my @LocationList = $Self->{LocationObject}->LocationSearch(
            Name   => $LocationName,
            UserID => 1,
        );

        $Self->Is(
            $LocationList[0] || '',
            $LocationSearch2LocationID{$Counter2} || '',
            "Test $TestCount: LocationSearch() - general name check",
        );

        $TestCount++;
    }

    $Counter2++;
}

1;
