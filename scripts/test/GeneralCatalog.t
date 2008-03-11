# --
# GeneralCatalog.t - general catalog tests
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: GeneralCatalog.t,v 1.13 2008-03-11 09:33:28 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

use strict;
use warnings;
use utf8;

use vars qw($Self);

use Kernel::System::GeneralCatalog;
use Kernel::System::User;

$Self->{GeneralCatalogObject} = Kernel::System::GeneralCatalog->new( %{$Self} );
$Self->{UserObject}           = Kernel::System::User->new( %{$Self} );

# disable email checks to create new user
my $CheckEmailAddressesOrg = $Self->{ConfigObject}->Get('CheckEmailAddresses') || 1;
$Self->{ConfigObject}->Set(
    Key   => 'CheckEmailAddresses',
    Value => 0,
);

# create new users for the tests
my $UserID1 = $Self->{UserObject}->UserAdd(
    UserFirstname => 'GeneralCatalog1',
    UserLastname  => 'UnitTest',
    UserLogin     => 'UnitTest-GeneralCatalog-1' . int( rand(1_000_000) ),
    UserEmail     => 'UnitTest-GeneralCatalog-1@localhost',
    ValidID       => 1,
    ChangeUserID  => 1,
);
my $UserID2 = $Self->{UserObject}->UserAdd(
    UserFirstname => 'GeneralCatalog2',
    UserLastname  => 'UnitTest',
    UserLogin     => 'UnitTest-GeneralCatalog-2' . int( rand(1_000_000) ),
    UserEmail     => 'UnitTest-GeneralCatalog-2@localhost',
    ValidID       => 1,
    ChangeUserID  => 1,
);

# restore original email check param
$Self->{ConfigObject}->Set(
    Key   => 'CheckEmailAddresses',
    Value => $CheckEmailAddressesOrg,
);

# create some random numbers for the classes
my $ClassRand1 = int( rand(1_000_000) );
my $ClassRand2 = int( rand(1_000_000) );
my $ClassRand3 = int( rand(1_000_000) );

my $ItemData = [

    # this item is NOT complete and must not be added
    {
        Add => {
            Name    => 'TestItem1',
            ValidID => 1,
            UserID  => 1,
        },
    },

    # this item is NOT complete and must not be added
    {
        Add => {
            Class   => 'UnitTest::TestClass' . $ClassRand1,
            ValidID => 1,
            UserID  => 1,
        },
    },

    # this item is NOT complete and must not be added
    {
        Add => {
            Class  => 'UnitTest::TestClass' . $ClassRand1,
            Name   => 'TestItem2',
            UserID => 1,
        },
    },

    # this item is NOT complete and must not be added
    {
        Add => {
            Class   => 'UnitTest::TestClass' . $ClassRand1,
            Name    => 'TestItem3',
            ValidID => 1,
        },
    },

    # this item must be inserted sucessfully
    {
        Add => {
            Class   => 'UnitTest::TestClass' . $ClassRand1,
            Name    => 'TestItem4',
            ValidID => 1,
            UserID  => 1,
        },
        AddGet => {
            Class         => 'UnitTest::TestClass' . $ClassRand1,
            Name          => 'TestItem4',
            Functionality => '',
            ValidID       => 1,
            Comment       => '',
            CreateBy      => 1,
            ChangeBy      => 1,
        },
    },

    # this item have the same name as one test before and must not be added
    {
        Add => {
            Class   => 'UnitTest::TestClass' . $ClassRand1,
            Name    => 'TestItem4',
            ValidID => 1,
            UserID  => 1,
        },
    },

    # the item one add-test before must be NOT updated (Func '' is the last in this class)
    {
        Update => {
            Name          => 'TestItem4UPDATE1',
            Functionality => 'Test',
            ValidID       => $UserID1,
            UserID        => $UserID1,
        },
    },

    # this item must be inserted sucessfully
    {
        Add => {
            Class         => 'UnitTest::TestClass' . $ClassRand1,
            Name          => 'TestItem5',
            Functionality => 'Test1',
            ValidID       => 1,
            UserID        => 1,
        },
        AddGet => {
            Class         => 'UnitTest::TestClass' . $ClassRand1,
            Name          => 'TestItem5',
            Functionality => 'Test1',
            ValidID       => 1,
            Comment       => '',
            CreateBy      => 1,
            ChangeBy      => 1,
        },
    },

    # the item one add-test before must be NOT updated (item update arguments NOT complete)
    {
        Update => {
            ValidID => $UserID1,
            UserID  => $UserID1,
        },
    },

    # the item one add-test before must be NOT updated (item update arguments NOT complete)
    {
        Update => {
            Name   => 'TestItem5UPDATE1',
            UserID => $UserID1,
        },
    },

    # the item one add-test before must be NOT updated (item update arguments NOT complete)
    {
        Update => {
            Functionality => 'Test1',
            ValidID       => $UserID1,
        },
    },

    # the item one add-test before must be NOT updated (Func 'test1' is the last in this class)
    {
        Update => {
            Name    => 'TestItem5',
            ValidID => $UserID1,
            UserID  => $UserID1,
        },
    },

    # the item one add-test before must be NOT updated (Func 'test1' is the last in this class)
    {
        Update => {
            Name          => 'TestItem5',
            Functionality => 'Test2',
            ValidID       => $UserID1,
            UserID        => $UserID1,
        },
    },

    # the item one add-test before must be updated (item update arguments are complete)
    {
        Update => {
            Name          => 'TestItem5UPDATE2',
            Functionality => 'Test1',
            ValidID       => $UserID1,
            UserID        => $UserID1,
        },
        UpdateGet => {
            Name          => 'TestItem5UPDATE2',
            Functionality => 'Test1',
            ValidID       => $UserID1,
            Comment       => '',
            CreateBy      => 1,
            ChangeBy      => $UserID1,
        },
    },

    # the item one add-test before must be updated (item update arguments are complete)
    {
        Update => {
            Name          => 'TestItem5UPDATE3',
            Functionality => 'Test1',
            ValidID       => 1,
            UserID        => 1,
        },
        UpdateGet => {
            Name          => 'TestItem5UPDATE3',
            Functionality => 'Test1',
            ValidID       => 1,
            Comment       => '',
            CreateBy      => 1,
            ChangeBy      => 1,
        },
    },

    # this template must be inserted sucessfully (check string cleaner function)
    {
        Add => {
            Class         => " \t \n \r Unit Test :: Test Class \t \n \r " . $ClassRand1,
            Name          => " \t \n \r Test Item \t \n \r ",
            Functionality => " \t \n \r Test Functionality \t \n \r ",
            ValidID       => 1,
            Comment       => " \t \n \r Test Comment \t \n \r ",
            UserID        => 1,
        },
        AddGet => {
            Class         => 'UnitTest::TestClass' . $ClassRand1,
            Name          => 'Test Item',
            Functionality => 'TestFunctionality',
            ValidID       => 1,
            Comment       => 'Test Comment',
            CreateBy      => 1,
            ChangeBy      => 1,
        },
    },

    # the item one add-test before must be updated sucessfully (check string cleaner function)
    {
        Update => {
            Name          => " \t \n \r Test Item UPDATED \t \n \r ",
            Functionality => " \t \n \r Test Func tiona lity \t \n \r ",
            ValidID       => $UserID1,
            Comment       => " \t \n \r Test Comment UPDATED \t \n \r ",
            UserID        => $UserID1,
        },
        UpdateGet => {
            Name          => 'Test Item UPDATED',
            Functionality => 'TestFunctionality',
            ValidID       => $UserID1,
            Comment       => 'Test Comment UPDATED',
            CreateBy      => 1,
            ChangeBy      => $UserID1,
        },
    },

    # this item must be inserted sucessfully (unicode checks)
    {
        Add => {
            Class         => 'UnitTest::TestClass©' . $ClassRand2,
            Name          => ' ϒ ϡ Test Item Ʃ Ϟ ',
            Functionality => ' Ѡ Ѥ TestFunctionality Ϡ Ω ',
            ValidID       => 1,
            Comment       => ' Ϡ Я Test Comment Ѭ Ѡ ',
            UserID        => 1,
        },
        AddGet => {
            Class         => 'UnitTest::TestClass©' . $ClassRand2,
            Name          => 'ϒ ϡ Test Item Ʃ Ϟ',
            Functionality => 'ѠѤTestFunctionalityϠΩ',
            ValidID       => 1,
            Comment       => 'Ϡ Я Test Comment Ѭ Ѡ',
            CreateBy      => 1,
            ChangeBy      => 1,
        },
    },

    # the item one add-test before must be updated sucessfully (unicode checks)
    {
        Update => {
            Name          => 'Test Item Ʃ ɤ UPDATED',
            Functionality => ' Ѡ Ѥ TestFunctionality Ϡ Ω ',
            ValidID       => $UserID2,
            Comment       => ' Test Comment љ ђ UPDATED ',
            UserID        => $UserID2,
        },
        UpdateGet => {
            Name          => 'Test Item Ʃ ɤ UPDATED',
            Functionality => 'ѠѤTestFunctionalityϠΩ',
            ValidID       => $UserID2,
            Comment       => 'Test Comment љ ђ UPDATED',
            CreateBy      => 1,
            ChangeBy      => $UserID2,
        },
    },

    # this item must be inserted sucessfully (a second item with Functionality 'test1')
    {
        Add => {
            Class         => 'UnitTest::TestClass' . $ClassRand1,
            Name          => 'TestItem6',
            Functionality => 'Test1',
            ValidID       => 1,
            UserID        => 1,
        },
        AddGet => {
            Class         => 'UnitTest::TestClass' . $ClassRand1,
            Name          => 'TestItem6',
            Functionality => 'Test1',
            ValidID       => 1,
            Comment       => '',
            CreateBy      => 1,
            ChangeBy      => 1,
        },
    },

    # the item one add-test before must be updated (set functionality to '')
    {
        Update => {
            Name          => 'TestItem6UPDATE1',
            Functionality => '',
            ValidID       => 1,
            UserID        => 1,
        },
        UpdateGet => {
            Name          => 'TestItem6UPDATE1',
            Functionality => '',
            ValidID       => 1,
            Comment       => '',
            CreateBy      => 1,
            ChangeBy      => 1,
        },
    },
];

my $TestCount = 1;
my $LastAddedItemID;
my %AddedItemCounter;

for my $Item ( @{$ItemData} ) {

    if ( $Item->{Add} ) {

        # add new item
        my $ItemID = $Self->{GeneralCatalogObject}->ItemAdd(
            %{ $Item->{Add} },
        );

        # check if item was added successfully or not
        if ( $Item->{AddGet} ) {

            $Self->True(
                $ItemID,
                "Test $TestCount: ItemAdd() - ItemKey: $ItemID",
            );

            if ($ItemID) {

                # set last item id variable
                $LastAddedItemID = $ItemID;

                # increment the added item counter
                $AddedItemCounter{ $Item->{AddGet}->{Class} }++;
            }
        }
        else {
            $Self->False(
                $ItemID,
                "Test $TestCount: ItemAdd()",
            );
        }

        # get item data to check the values after creation of item
        my $ItemGet = $Self->{GeneralCatalogObject}->ItemGet(
            ItemID => $ItemID,
            UserID => $Item->{Add}->{UserID},
        );

        # check item data after creation of item
        for my $ItemAttribute ( keys %{ $Item->{AddGet} } ) {
            $Self->Is(
                $ItemGet->{$ItemAttribute} || '',
                $Item->{AddGet}->{$ItemAttribute} || '',
                "Test $TestCount: ItemGet() - $ItemAttribute",
            );
        }
    }

    if ( $Item->{Update} ) {

        # check last item id varaible
        if ( !$LastAddedItemID ) {
            $Self->False(
                1,
                "Test $TestCount: NO LAST ITEM ID GIVEN",
            );
        }

        # update the item
        my $UpdateSucess = $Self->{GeneralCatalogObject}->ItemUpdate(
            %{ $Item->{Update} },
            ItemID => $LastAddedItemID,
        );

        # check if item was updated successfully or not
        if ( $Item->{UpdateGet} ) {
            $Self->True(
                $UpdateSucess,
                "Test $TestCount: ItemUpdate() - ItemKey: $LastAddedItemID",
            );
        }
        else {
            $Self->False(
                $UpdateSucess,
                "Test $TestCount: ItemUpdate()",
            );
        }

        # get item data to check the values after the update
        my $ItemGet2 = $Self->{GeneralCatalogObject}->ItemGet(
            ItemID => $LastAddedItemID,
            UserID => $Item->{Update}->{UserID},
        );

        # check item data after update
        for my $ItemAttribute ( keys %{ $Item->{UpdateGet} } ) {
            $Self->Is(
                $ItemGet2->{$ItemAttribute} || '',
                $Item->{UpdateGet}->{$ItemAttribute} || '',
                "Test $TestCount: ItemGet() - $ItemAttribute",
            );
        }
    }

    $TestCount++;
}

# create needed arrays
my %ExistingClassesTmp;
ITEM:
for my $Item ( @{$ItemData} ) {
    next ITEM if !$Item->{AddGet}->{Class};
    $ExistingClassesTmp{ $Item->{AddGet}->{Class} } = 1;
}
my @ExistingClasses = sort keys %ExistingClassesTmp;

my %ExistingFunctionalitiesTmp;
ITEM:
for my $Item ( @{$ItemData} ) {
    $Item->{UpdateGet}->{Functionality} ||= '';
    $ExistingFunctionalitiesTmp{ $Item->{UpdateGet}->{Functionality} } = 1;
}
my @ExistingFunctionalities = sort keys %ExistingFunctionalitiesTmp;

my @NonExistingClasses = ( 'UnitTest::NoExistingClass1', 'UnitTest::NoExistingClass2' );

# ClassList test 1
my $ClassList1 = $Self->{GeneralCatalogObject}->ClassList();

for my $Class (@ExistingClasses) {

    my $ClassCount = 0;
    if ( $ClassList1 && ref $ClassList1 eq 'ARRAY' ) {
        $ClassCount = grep { $_ eq $Class } @{$ClassList1};
    }

    $Self->Is(
        $ClassCount,
        1,
        "Test $TestCount: ClassList() - $Class listed",
    );

    $TestCount++;
}

# ItemList test 1
for my $Class (@NonExistingClasses) {

    my $ItemList = $Self->{GeneralCatalogObject}->ItemList(
        Class => $Class,
        Valid => 0,
    );

    $Self->False(
        $ItemList,
        "Test $TestCount: ItemList() - $Class not exists",
    );

    $TestCount++;
}

# ItemList test 2
for my $Class (@ExistingClasses) {

    my $ItemList = $Self->{GeneralCatalogObject}->ItemList(
        Class => $Class,
        Valid => 0,
    );

    my $ListCount = 'NULL';
    if ( defined $ItemList && ref $ItemList eq 'HASH' ) {
        $ListCount = keys %{$ItemList};
    }

    $Self->Is(
        $ListCount,
        $AddedItemCounter{$Class},
        "Test $TestCount: ItemList() - $Class correct number of items",
    );

    $TestCount++;
}

# FunctionalityList test 1
my %FunctionalityList1;
map { $FunctionalityList1{$_} = 1 } @ExistingFunctionalities;

for my $Class (@ExistingClasses) {

    my $FunctionalityList = $Self->{GeneralCatalogObject}->FunctionalityList(
        Class => $Class,
    );

    $Self->True(
        $FunctionalityList && ref $FunctionalityList eq 'ARRAY',
        "Test $TestCount: FunctionalityList() - return a array reference",
    );

    for my $Functionality ( @{$FunctionalityList} ) {
        delete $FunctionalityList1{$Functionality};
    }

    $TestCount++;
}

$Self->True(
    !keys %FunctionalityList1,
    "Test $TestCount: FunctionalityList()",
);

$TestCount++;

# ClassRename test 1 (check normal rename)
CLASS:
for my $Class (@ExistingClasses) {

    my $OldItemList = $Self->{GeneralCatalogObject}->ItemList(
        Class => $Class,
        Valid => 0,
    );

    my $Success = $Self->{GeneralCatalogObject}->ClassRename(
        ClassOld => $Class,
        ClassNew => $Class . 'RENAME1',
    );

    if ( !$Success ) {
        $Self->False(
            1,
            "Test $TestCount: ClassRename() - Rename failed",
        );
        next CLASS;
    }

    my $NewItemList = $Self->{GeneralCatalogObject}->ItemList(
        Class => $Class . 'RENAME1',
        Valid => 0,
    );

    if (
        !$OldItemList
        || !$NewItemList
        || ref $OldItemList ne 'HASH'
        || ref $NewItemList ne 'HASH'
        )
    {
        $Self->False(
            1,
            "Test $TestCount: ClassRename() - ItemList failed",
        );
        next CLASS;
    }

    OLDKEY:
    for my $OldKey ( keys %{$OldItemList} ) {

        if ( !exists $NewItemList->{$OldKey} ) {
            $NewItemList->{FailedDummy} = 1;
            next OLDKEY;
        }

        next OLDKEY if $OldItemList->{$OldKey} ne $NewItemList->{$OldKey};

        delete $NewItemList->{$OldKey};
    }

    $Self->True(
        !keys %{$NewItemList},
        "Test $TestCount: ClassRename()",
    );

    $TestCount++;
}

# ClassRename test 2 (check string cleaner function)
CLASS:
for my $Class (@ExistingClasses) {

    my $OldItemList = $Self->{GeneralCatalogObject}->ItemList(
        Class => $Class . 'RENAME1',
        Valid => 0,
    );

    my $Success = $Self->{GeneralCatalogObject}->ClassRename(
        ClassOld => $Class . 'RENAME1',
        ClassNew => ' ' . $Class . "RE NA ME 2 \n \r \t ",
    );

    if ( !$Success ) {
        $Self->False(
            1,
            "Test $TestCount: ClassRename() - Rename failed",
        );
        next CLASS;
    }

    my $NewItemList = $Self->{GeneralCatalogObject}->ItemList(
        Class => $Class . 'RENAME2',
        Valid => 0,
    );

    if (
        !$OldItemList
        || !$NewItemList
        || ref $OldItemList ne 'HASH'
        || ref $NewItemList ne 'HASH'
        )
    {
        $Self->False(
            1,
            "Test $TestCount: ClassRename() - ItemList failed",
        );
        next CLASS;
    }

    OLDKEY:
    for my $OldKey ( keys %{$OldItemList} ) {

        if ( !exists $NewItemList->{$OldKey} ) {
            $NewItemList->{FailedDummy} = 1;
            next OLDKEY;
        }

        next OLDKEY if $OldItemList->{$OldKey} ne $NewItemList->{$OldKey};

        delete $NewItemList->{$OldKey};
    }

    $Self->True(
        !keys %{$NewItemList},
        "Test $TestCount: ClassRename()",
    );

    $TestCount++;
}

# ClassRename test 2 (identical name test)
for my $Class (@ExistingClasses) {

    my $Success = $Self->{GeneralCatalogObject}->ClassRename(
        ClassOld => $Class . 'RENAME2',
        ClassNew => $Class . 'RENAME2',
    );

    $Self->True(
        $Success,
        "Test $TestCount: ClassRename() - oldname and newname identical",
    );

    $TestCount++;
}

# ClassRename test 3 (new class name already exists)
$Self->{GeneralCatalogObject}->ItemAdd(
    Class         => 'UnitTest::TestClass' . $ClassRand3,
    Name          => 'Dummy',
    Functionality => '',
    ValidID       => 1,
    UserID        => 1,
);

for my $Class (@ExistingClasses) {

    my $Success = $Self->{GeneralCatalogObject}->ClassRename(
        ClassOld => $Class . 'RENAME2',
        ClassNew => 'UnitTest::TestClass' . $ClassRand3,
    );

    $Self->False(
        $Success,
        "Test $TestCount: ClassRename() - new class name already exists",
    );

    $TestCount++;
}

# clean the general catalog table
$Self->{DBObject}->Do(
    SQL => "DELETE FROM general_catalog WHERE general_catalog_class LIKE 'UnitTest%'",
);

1;
