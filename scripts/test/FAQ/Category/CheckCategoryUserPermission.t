# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

## no critic (Modules::RequireExplicitPackage)
use strict;
use warnings;

use vars qw($Self);

$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);

my $Helper     = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $UserObject = $Kernel::OM->Get('Kernel::System::User');

# create test user
my $UserLogin = $Helper->TestUserCreate();
my $UserID    = $UserObject->UserLookup( UserLogin => $UserLogin );

$Self->True(
    $UserID,
    "Test user $UserID created",
);

my $RandomID = $Helper->GetRandomID();

my $GroupObject = $Kernel::OM->Get('Kernel::System::Group');

my $GID = $GroupObject->GroupAdd(
    Name    => 'CheckCategoryUserPermission-' . $RandomID,
    Comment => 'comment describing the group',
    ValidID => 1,
    UserID  => 1,
);
$Self->True(
    $GID,
    "GroupAdd()",
);

my $FAQObject = $Kernel::OM->Get('Kernel::System::FAQ');

my $CategoryID = $FAQObject->CategoryAdd(
    Name     => 'CheckCategoryUserPermission-' . $RandomID,
    Comment  => 'Some comment',
    ParentID => 0,
    ValidID  => 1,
    UserID   => 1,
);
$Self->True(
    $CategoryID,
    "CategoryAdd()",
);

my $Success = $FAQObject->SetCategoryGroup(
    CategoryID => $CategoryID,
    GroupIDs   => [$GID],
    UserID     => 1,
);
$Self->True(
    $Success,
    "SetCategoryGroup()",
);

my @Tests = (
    {
        Name       => 'Missing CategoryID',
        Permission => {},
        Config     => {
            UserID => $UserID,
        },
        Success => 0,
    },
    {
        Name       => 'Missing UserID',
        Permission => {},
        Config     => {
            CategoryID => $CategoryID,
        },
        Success => 0,
    },
    {
        Name       => 'No permissions',
        Permission => {},
        Config     => {
            CategoryID => $CategoryID,
            UserID     => $UserID,
        },
        ExpectedResult => {
            ''   => '',
            'ro' => '',
            'rw' => '',
        },
        Success => 1,
    },
    {
        Name       => "'ro' permissions",
        Permission => {
            ro => 1,
        },
        Config => {
            CategoryID => $CategoryID,
            UserID     => $UserID,
        },
        ExpectedResult => {
            ''   => 'ro',
            'ro' => 'ro',
            'rw' => '',
        },
        Success => 1,
    },
    {
        Name       => "'move_into' permissions",
        Permission => {
            move_into => 1,
        },
        Config => {
            CategoryID => $CategoryID,
            UserID     => $UserID,
        },
        ExpectedResult => {
            ''   => '',
            'ro' => '',
            'rw' => '',
        },
        Success => 1,
    },
    {
        Name       => "'rw' permissions",
        Permission => {
            rw => 1,
        },
        Config => {
            CategoryID => $CategoryID,
            UserID     => $UserID,
        },
        ExpectedResult => {
            ''   => 'ro',
            'ro' => 'ro',
            'rw' => 'rw',
        },
        Success => 1,
    },
);

TEST:
for my $Test (@Tests) {

    # Set new permissions
    if ( $Test->{Permission} ) {
        $GroupObject->PermissionGroupUserAdd(
            GID        => $GID,
            UID        => $UserID,
            Permission => $Test->{Permission},
            UserID     => 1,
        );
    }

    for my $Type ( '', 'ro', 'rw' ) {

        my $PermissionString = $FAQObject->CheckCategoryUserPermission(
            %{ $Test->{Config} },
            Type => $Type,
        );

        if ( !$Test->{Success} ) {
            $Self->Is(
                $PermissionString,
                undef,
                "$Test->{Name} - CheckCategoryUserPermission() failure"
            );
            next TEST;
        }

        $Self->Is(
            $PermissionString,
            $Test->{ExpectedResult}->{$Type},
            "$Test->{Name} - CheckCategoryUserPermission() for type $Type",
        );
    }
}
continue {

    # Remove all permissions
    $GroupObject->PermissionGroupUserAdd(
        GID        => $GID,
        UID        => $UserID,
        Permission => {},
        UserID     => 1,
    );
}

# cleanup is done by restore database

1;
