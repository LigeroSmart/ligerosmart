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
my $RandomID   = $Helper->GetRandomID();

my $TestUserLogin = $Helper->TestUserCreate(
    Groups => [ 'admin', 'users' ],
);
my $UserID = $UserObject->UserLookup(
    UserLogin => $TestUserLogin,
);

my $FAQObject = $Kernel::OM->Get('Kernel::System::FAQ');

my $CategoryID1 = $FAQObject->CategoryAdd(
    Name     => "Category1$RandomID",
    Comment  => 'Some comment',
    ParentID => 0,
    ValidID  => 1,
    UserID   => $UserID,
);
$Self->IsNot(
    $CategoryID1 // 0,
    '0',
    "CategoryAdd for Category 1",
);
my $CategoryID2 = $FAQObject->CategoryAdd(
    Name     => "Category2$RandomID",
    Comment  => 'Some comment',
    ParentID => 0,
    ValidID  => 1,
    UserID   => $UserID,
);
$Self->IsNot(
    $CategoryID2 // 0,
    '0',
    "CategoryAdd for Category 2",
);
my $CategoryID3 = $FAQObject->CategoryAdd(
    Name     => "Category3$RandomID",
    Comment  => 'Some comment',
    ParentID => 0,
    ValidID  => 1,
    UserID   => $UserID,
);
$Self->IsNot(
    $CategoryID3 // 0,
    '0',
    "CategoryAdd for Category 3",
);

my $CategoryID11 = $FAQObject->CategoryAdd(
    Name     => "Category1-1$RandomID",
    Comment  => 'Some comment',
    ParentID => $CategoryID1,
    ValidID  => 1,
    UserID   => $UserID,
);
$Self->IsNot(
    $CategoryID11 // 0,
    '0',
    "CategoryAdd for Category 1-1",
);
my $CategoryID12 = $FAQObject->CategoryAdd(
    Name     => "Category1-2$RandomID",
    Comment  => 'Some comment',
    ParentID => $CategoryID1,
    ValidID  => 1,
    UserID   => $UserID,
);
$Self->IsNot(
    $CategoryID12 // 0,
    '0',
    "CategoryAdd for Category 1-2",
);
my $CategoryID121 = $FAQObject->CategoryAdd(
    Name     => "Category1-2-1$RandomID",
    Comment  => 'Some comment',
    ParentID => $CategoryID12,
    ValidID  => 1,
    UserID   => $UserID,
);
$Self->IsNot(
    $CategoryID121 // 0,
    '0',
    "CategoryAdd for Category 1-2-1",
);

my $GroupID = $Kernel::OM->Get('Kernel::System::Group')->GroupLookup(
    Group => 'users',
);

for my $CategoryID ( $CategoryID1, $CategoryID2, $CategoryID11, $CategoryID12, $CategoryID121 ) {

    my $Success = $FAQObject->SetCategoryGroup(
        CategoryID => $CategoryID,
        GroupIDs   => [$GroupID],
        UserID     => 1,
    );

    $Self->True(
        $Success,
        "CategoryID $CategoryID added to GroupID $GroupID",
    );
}

my @Tests = (
    {
        Name    => 'No Params',
        Config  => {},
        Success => 0,
    },
    {
        Name   => 'Missing UserID',
        Config => {
            Parent => 0,
        },
        Success => 0,
    },
    {
        Name   => 'No Parent W/Subs',
        Config => {
            GetSubCategories => 1,
            UserID           => $UserID,
        },
        Success            => 1,
        ExpectedResults    => [ $CategoryID1, $CategoryID2, $CategoryID11, $CategoryID12, $CategoryID121 ],
        NotExpectedResults => [$CategoryID3],
    },
    {
        Name   => 'ParentID 0 W/Subs',
        Config => {
            ParentID         => 0,
            GetSubCategories => 1,
            UserID           => $UserID,
        },
        Success            => 1,
        ExpectedResults    => [ $CategoryID1, $CategoryID2, $CategoryID11, $CategoryID12, $CategoryID121 ],
        NotExpectedResults => [$CategoryID3],
    },
    {
        Name   => 'ParentID Category 1 W/Subs',
        Config => {
            ParentID         => $CategoryID1,
            GetSubCategories => 1,
            UserID           => $UserID,
        },
        Success            => 1,
        ExpectedResults    => [ $CategoryID11, $CategoryID12, $CategoryID121 ],
        NotExpectedResults => [ $CategoryID1, $CategoryID2, $CategoryID3 ],
    },
    {
        Name   => 'ParentID Category 2 W/Subs',
        Config => {
            ParentID         => $CategoryID2,
            GetSubCategories => 1,
            UserID           => $UserID,
        },
        Success => 1,
        NotExpectedResults =>
            [ $CategoryID1, $CategoryID2, $CategoryID3, $CategoryID11, $CategoryID12, $CategoryID121 ],
    },
    {
        Name   => 'ParentID Category 1-1 W/Subs',
        Config => {
            ParentID         => $CategoryID11,
            GetSubCategories => 1,
            UserID           => $UserID,
        },
        Success => 1,
        NotExpectedResults =>
            [ $CategoryID1, $CategoryID2, $CategoryID3, $CategoryID11, $CategoryID12, $CategoryID121 ],
    },
    {
        Name   => 'ParentID Category 1-2 W/Subs',
        Config => {
            ParentID         => $CategoryID12,
            GetSubCategories => 1,
            UserID           => $UserID,
        },
        Success            => 1,
        ExpectedResults    => [$CategoryID121],
        NotExpectedResults => [ $CategoryID1, $CategoryID2, $CategoryID3, $CategoryID11, $CategoryID12 ],
    },

    {
        Name   => 'No Parent WO/Subs',
        Config => {
            UserID => $UserID,
        },
        Success            => 1,
        ExpectedResults    => [ $CategoryID1, $CategoryID2, ],
        NotExpectedResults => [ $CategoryID3, $CategoryID11, $CategoryID12, $CategoryID121 ],
    },
    {
        Name   => 'ParentID 0 WO/Subs',
        Config => {
            ParentID => 0,
            UserID   => $UserID,
        },
        Success => 1,
    },
    {
        Name   => 'ParentID Category 1 WO/Subs',
        Config => {
            ParentID => $CategoryID1,
            UserID   => $UserID,
        },
        Success            => 1,
        ExpectedResults    => [ $CategoryID11, $CategoryID12, ],
        NotExpectedResults => [ $CategoryID1, $CategoryID2, $CategoryID3, $CategoryID121 ],
    },
    {
        Name   => 'ParentID Category 2 WO/Subs',
        Config => {
            ParentID => $CategoryID2,
            UserID   => $UserID,
        },
        Success => 1,
        NotExpectedResults =>
            [ $CategoryID1, $CategoryID2, $CategoryID3, $CategoryID11, $CategoryID12, $CategoryID121 ],
    },
    {
        Name   => 'ParentID Category 1-1 WO/Subs',
        Config => {
            ParentID => $CategoryID11,
            UserID   => $UserID,
        },
        Success => 1,
        NotExpectedResults =>
            [ $CategoryID1, $CategoryID2, $CategoryID3, $CategoryID11, $CategoryID12, $CategoryID121 ],
    },
    {
        Name   => 'ParentID Category 1-2 WO/Subs',
        Config => {
            ParentID => $CategoryID12,
            UserID   => $UserID,
        },
        Success            => 1,
        ExpectedResults    => [$CategoryID121],
        NotExpectedResults => [ $CategoryID1, $CategoryID2, $CategoryID3, $CategoryID11, $CategoryID12 ],
    },

);

TEST:
for my $Test (@Tests) {

    my $CategoryIDs = $FAQObject->AgentCategorySearch( %{ $Test->{Config} } );

    if ( !$Test->{Success} ) {
        $Self->False(
            $CategoryIDs,
            "$Test->{Name} AgentCategorySearch() - With false",
        );
        next TEST;
    }

    for my $ExpectedResult ( @{ $Test->{ExpectedResults} } ) {
        my $Count = grep { $_ eq $ExpectedResult } @{$CategoryIDs};
        $Self->Is(
            $Count,
            1,
            "$Test->{Name} AgentCategorySearch() CategoryID $ExpectedResult found 1 time",
        );
    }
    for my $NotExpectedResult ( @{ $Test->{NotExpectedResults} } ) {
        my $Count = grep { $_ eq $NotExpectedResult } @{$CategoryIDs};
        $Self->Is(
            $Count // 0,
            0,
            "$Test->{Name} AgentCategorySearch() CategoryID $NotExpectedResult found 0 times",
        );
    }

}
1;
