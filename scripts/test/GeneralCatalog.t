# --
# GeneralCatalog.t - general catalog tests
# Copyright (C) 2001-2007 OTRS GmbH, http://otrs.org/
# --
# $Id: GeneralCatalog.t,v 1.2 2007-10-05 15:03:21 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

use strict;
use warnings;

use Kernel::System::GeneralCatalog;

$Self->{GeneralCatalogObject} = Kernel::System::GeneralCatalog->new( %{$Self} );

# create some random numbers
my $Rand1 = int( rand(1_000_000) );
my $Rand2 = int( rand(1_000_000) );
my $Rand3 = int( rand(1_000_000) );
my $Rand4 = int( rand(1_000_000) );
my $Rand5 = int( rand(1_000_000) );
my $Rand6 = int( rand(1_000_000) );

my $ItemData = [

    # this item is NOT complete and must not be added
    {   Add => {
            Name    => 'TestItem' . $Rand1,
            ValidID => 1,
            UserID  => 1,
        },
    },

    # this item is NOT complete and must not be added
    {   Add => {
            Class   => 'UniTest::TestClass1',
            ValidID => 1,
            UserID  => 1,
        },
    },

    # this item is NOT complete and must not be added
    {   Add => {
            Class  => 'UniTest::TestClass1',
            Name   => 'TestItem' . $Rand2,
            UserID => 1,
        },
    },

    # this item is NOT complete and must not be added
    {   Add => {
            Class   => 'UniTest::TestClass1',
            Name    => 'TestItem' . $Rand3,
            ValidID => 1,
        },
    },

    # this item must be inserted sucessfully
    {   Add => {
            Class   => 'UniTest::TestClass1',
            Name    => 'TestItem' . $Rand4,
            ValidID => 1,
            UserID  => 1,
        },
        AddGet => {
            Class         => 'UniTest::TestClass1',
            Name          => 'TestItem' . $Rand4,
            Functionality => '',
            ValidID       => 1,
            Comment       => '',
            CreateBy      => 1,
            ChangeBy      => 1,
        },
    },

    # this item have the same name as one test before and must not be added
    {   Add => {
            Class   => 'UniTest::TestClass1',
            Name    => 'TestItem' . $Rand4,
            ValidID => 1,
            UserID  => 1,
        },
    },

    # this item must be inserted sucessfully
    {   Add => {
            Class         => 'UniTest::TestClass1',
            Name          => 'TestItem' . $Rand5,
            Functionality => 'Test1',
            ValidID       => 1,
            UserID        => 1,
        },
        AddGet => {
            Class         => 'UniTest::TestClass1',
            Name          => 'TestItem' . $Rand5,
            Functionality => 'Test1',
            ValidID       => 1,
            Comment       => '',
            CreateBy      => 1,
            ChangeBy      => 1,
        },
    },

    # the item one add-test before must be NOT updated (item update arguments NOT complete)
    {   Update => {
            ValidID => 2,
            UserID  => 2,
        },
    },

    # the item one add-test before must be NOT updated (item update arguments NOT complete)
    {   Update => {
            Name   => 'TestItem' . $Rand5 . 'Edit',
            UserID => 2,
        },
    },

    # the item one add-test before must be NOT updated (item update arguments NOT complete)
    {   Update => {
            Name    => 'TestItem' . $Rand5 . 'Edit',
            ValidID => 2,
        },
    },

    # the item one add-test before must be updated (item update arguments are complete)
    {   Update => {
            Name    => 'TestItem' . $Rand5 . 'Edit',
            ValidID => 2,
            UserID  => 2,
        },
        UpdateGet => {
            Name          => 'TestItem' . $Rand5 . 'Edit',
            Functionality => '',
            ValidID       => 2,
            Comment       => '',
            CreateBy      => 1,
            ChangeBy      => 2,
        },
    },

    # the item one add-test before must be updated (item update arguments are complete)
    {   Update => {
            Name          => 'TestItem' . $Rand5 . 'Edit',
            Functionality => 'Test1',
            ValidID       => 1,
            UserID        => 1,
        },
        UpdateGet => {
            Name          => 'TestItem' . $Rand5 . 'Edit',
            Functionality => 'Test1',
            ValidID       => 1,
            Comment       => '',
            CreateBy      => 1,
            ChangeBy      => 1,
        },
    },

    # the item one add-test before must be updated (item update arguments are complete)
    {   Update => {
            Name          => 'TestItem' . $Rand6 . 'Edit',
            Functionality => 'Test2',
            ValidID       => 1,
            Comment       => 'This is a comment.',
            UserID        => 1,
        },
        UpdateGet => {
            Name          => 'TestItem' . $Rand6 . 'Edit',
            Functionality => 'Test2',
            ValidID       => 1,
            Comment       => 'This is a comment.',
            CreateBy      => 1,
            ChangeBy      => 1,
        },
    },
];

my $TestCount = 1;
my $LastAddedItemID;
for my $Item ( @{$ItemData} ) {

    if ( $Item->{Add} ) {

        # add new item
        my $ItemID = $Self->{GeneralCatalogObject}->ItemAdd( %{ $Item->{Add} } );

        # check if item was added successfully or not
        if ( $ItemID && $Item->{AddGet} ) {
            $Self->True( $ItemID, "Test $TestCount: ItemAdd() - ItemKey: $ItemID", );

            # set last item id variable
            $LastAddedItemID = $ItemID;
        }
        else {
            $Self->False( $ItemID, "Test $TestCount: ItemAdd()", );
        }

        # get item data to check the values after creation of item
        my $ItemGet = $Self->{GeneralCatalogObject}->ItemGet(
            ItemID => $ItemID,
            UserID => $Item->{Add}->{UserID},
        );

        # check item data after creation of item
        for my $ItemAttribute ( keys %{ $Item->{AddGet} } ) {
            $Self->Is(
                $ItemGet->{$ItemAttribute}        || '',
                $Item->{AddGet}->{$ItemAttribute} || '',
                "Test $TestCount: ItemGet() - $ItemAttribute",
            );
        }
    }

    if ( $Item->{Update} ) {

        # check last item id varaible
        if ( !$LastAddedItemID ) {
            $Self->False( 1, "Test $TestCount: NO LAST ITEM ID GIVEN", );
        }

        # update the item
        my $UpdateSucess = $Self->{GeneralCatalogObject}
            ->ItemUpdate( %{ $Item->{Update} }, ItemID => $LastAddedItemID, );

        # check if item was updated successfully or not
        if ( $UpdateSucess && $Item->{UpdateGet} ) {
            $Self->True( $UpdateSucess, "Test $TestCount: ItemUpdate() - ItemKey: $LastAddedItemID",
            );
        }
        else {
            $Self->False( $UpdateSucess, "Test $TestCount: ItemUpdate()", );
        }

        # get item data to check the values after the update
        my $ItemGet2 = $Self->{GeneralCatalogObject}->ItemGet(
            ItemID => $LastAddedItemID,
            UserID => $Item->{Add}->{UserID},
        );

        # check item data after update
        for my $ItemAttribute ( keys %{ $Item->{UpdateGet} } ) {
            $Self->Is(
                $ItemGet2->{$ItemAttribute}          || '',
                $Item->{UpdateGet}->{$ItemAttribute} || '',
                "Test $TestCount: ItemGet() - $ItemAttribute",
            );
        }
    }

    # increment the counter
    $TestCount++;
}

1;
