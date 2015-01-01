# --
# FAQ.t - FAQ tests
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;

use vars qw($Self);

use Kernel::System::FAQ;

my $FAQObject   = $Kernel::OM->Get('Kernel::System::FAQ');
my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

my $FAQID = $FAQObject->FAQAdd(
    Title      => 'Some Text',
    CategoryID => 1,
    StateID    => 1,
    LanguageID => 1,
    Keywords   => 'some keywords',
    Field1     => 'Problem...',
    Field2     => 'Solution...',
    UserID     => 1,
);

$Self->True(
    $FAQID,
    "FAQAdd() - 1",
);

my %FAQ = $FAQObject->FAQGet(
    ItemID     => $FAQID,
    ItemFields => 1,
    UserID     => 1,
);

my %FAQTest = (
    Title      => 'Some Text',
    CategoryID => 1,
    StateID    => 1,
    LanguageID => 1,
    Keywords   => 'some keywords',
    Field1     => 'Problem...',
    Field2     => 'Solution...',
);

for my $Test ( sort keys %FAQTest ) {
    $Self->Is(
        $FAQ{$Test},
        $FAQTest{$Test},
        "FAQGet() - $Test",
    );
}

my $FAQUpdate = $FAQObject->FAQUpdate(
    ItemID     => $FAQID,
    CategoryID => 1,
    StateID    => 2,
    LanguageID => 2,
    Approved   => 1,
    Title      => 'Some Text2',
    Keywords   => 'some keywords2',
    Field1     => 'Problem...2',
    Field2     => 'Solution found...2',
    UserID     => 1,
);

%FAQ = $FAQObject->FAQGet(
    ItemID     => $FAQID,
    ItemFields => 1,
    UserID     => 1,
);

%FAQTest = (
    Title      => 'Some Text2',
    CategoryID => 1,
    StateID    => 2,
    LanguageID => 2,
    Keywords   => 'some keywords2',
    Field1     => 'Problem...2',
    Field2     => 'Solution found...2',
);

for my $Test ( sort keys %FAQTest ) {
    $Self->Is(
        $FAQTest{$Test},
        $FAQ{$Test},
        "FAQGet() - $Test",
    );
}

my $Ok = $FAQObject->VoteAdd(
    CreatedBy => 'Some Text',
    ItemID    => $FAQID,
    IP        => '54.43.30.1',
    Interface => '2',
    Rate      => 100,
    UserID    => 1,
);

$Self->True(
    $Ok,
    "VoteAdd()",
);

my $Vote = $FAQObject->VoteGet(
    CreateBy  => 'Some Text',
    ItemID    => $FAQID,
    IP        => '54.43.30.1',
    Interface => '2',
    UserID    => 1,
);

$Self->Is(
    $Vote->{IP},
    '54.43.30.1',
    "VoteGet() - IP",
);

my $FAQID2 = $FAQObject->FAQAdd(
    Title      => 'Title',
    CategoryID => 1,
    StateID    => 1,
    LanguageID => 1,
    Keywords   => '',
    Field1     => 'Problem Description 1...',
    Field2     => 'Solution not found1...',
    UserID     => 1,
);

$Self->True(
    $FAQID2,
    "FAQAdd() - 2",
);

my $Home            = $Kernel::OM->Get('Kernel::Config')->Get('Home');
my @AttachmentTests = (
    {
        File => 'FAQ-Test1.pdf',
        MD5  => '5ee767f3b68f24a9213e0bef82dc53e5',
    },
    {
        File => 'FAQ-Test1.doc',
        MD5  => '2e520036a0cda6a806a8838b1000d9d7',
    },
);

# get main object
my $MainObject = $Kernel::OM->Get('Kernel::System::Main');

for my $AttachmentTest (@AttachmentTests) {
    my $ContentSCALARRef = $MainObject->FileRead(
        Location => $Home . '/scripts/test/sample/' . $AttachmentTest->{File},
    );
    my $Add = $FAQObject->AttachmentAdd(
        ItemID      => $FAQID2,
        Content     => ${$ContentSCALARRef},
        ContentType => 'text/xml',
        Filename    => $AttachmentTest->{File},
        UserID      => 1,
    );
    $Self->True(
        $Add,
        "AttachmentAdd() - $AttachmentTest->{File}",
    );
    my @AttachmentIndex = $FAQObject->AttachmentIndex(
        ItemID => $FAQID2,
        UserID => 1,
    );
    my %File = $FAQObject->AttachmentGet(
        ItemID => $FAQID2,
        FileID => $AttachmentIndex[0]->{FileID},
        UserID => 1,
    );
    $Self->Is(
        $File{Filename},
        $AttachmentTest->{File},
        "AttachmentGet() - Filename $AttachmentTest->{File}",
    );
    my $MD5 = $MainObject->MD5sum(
        String => \$File{Content},
    );
    $Self->Is(
        $MD5,
        $AttachmentTest->{MD5},
        "AttachmentGet() - MD5 $AttachmentTest->{File}",
    );

    my $Delete = $FAQObject->AttachmentDelete(
        ItemID => $FAQID2,
        FileID => $AttachmentIndex[0]->{FileID},
        UserID => 1,
    );
    $Self->True(
        $Delete,
        "AttachmentDelete() - $AttachmentTest->{File}",
    );
}

my $VoteIDsRef = $FAQObject->VoteSearch(
    ItemID => $FAQID,
    UserID => 1,
);

for my $VoteID ( @{$VoteIDsRef} ) {
    my $VoteDelete = $FAQObject->VoteDelete(
        VoteID => 1,
        UserID => 1,
    );
    $Self->True(
        $VoteDelete,
        "VoteDelete()",
    );
}

# add FAQ article to log
my $Success = $FAQObject->FAQLogAdd(
    ItemID    => $FAQID,
    Interface => 'internal',
    UserID    => 1,
);
$Self->True(
    $Success,
    "FAQLogAdd() - $FAQID",
);

# try to add same FAQ article to log again (must return false)
$Success = $FAQObject->FAQLogAdd(
    ItemID    => $FAQID,
    Interface => 'internal',
    UserID    => 1,
);
$Self->False(
    $Success,
    "FAQLogAdd() - $FAQID",
);

# add another FAQ article to log
$Success = $FAQObject->FAQLogAdd(
    ItemID    => $FAQID2,
    Interface => 'internal',
    UserID    => 1,
);
$Self->True(
    $Success,
    "FAQLogAdd() - $FAQID2",
);

# get FAQ Top-10
my $Top10IDsRef = $FAQObject->FAQTop10Get(
    Interface => 'internal',
    Limit     => 10,
    UserID    => 1,
) || [];
$Self->True(
    scalar @{$Top10IDsRef},
    "FAQTop10Get()",
);

# test LanguageLookup()
my $LanguageName = $FAQObject->LanguageLookup(
    LanguageID => 1,
    UserID     => 1,
);
$Self->True(
    $LanguageName,
    "LanguageLookup() for LanguageID '1' is '$LanguageName'",
);

my $LanguageID = $FAQObject->LanguageLookup(
    Name   => $LanguageName,
    UserID => 1,
);
$Self->Is(
    $LanguageID,
    1,
    "LanguageLookup() for LanguageName '$LanguageName'",
);

my $FAQDelete = $FAQObject->FAQDelete(
    ItemID => $FAQID,
    UserID => 1,
);
$Self->True(
    $FAQDelete,
    "FAQDelete() - FAQID: $FAQID",
);

my $FAQDelete2 = $FAQObject->FAQDelete(
    ItemID => $FAQID2,
    UserID => 1,
);
$Self->True(
    $FAQDelete2,
    "FAQDelete() - FAQID: $FAQID2",
);

my $CategoryID = $FAQObject->CategoryAdd(
    Name     => 'TestCategory',
    Comment  => 'Category for testing',
    ParentID => 0,
    ValidID  => 1,
    UserID   => 1,
);

$Self->True(
    $CategoryID,
    "CategoryAdd() - Root Category",
);

# set ParentID to empty to make it fail
my $CategoryIDFail = $FAQObject->CategoryAdd(
    Name     => 'TestCategory',
    Comment  => 'Category for testing',
    ParentID => '',
    ValidID  => 1,
    UserID   => 1,
);

$Self->False(
    $CategoryIDFail,
    "CategoryAdd() - Root Category",
);

my $CategoryUpdate = $FAQObject->CategoryUpdate(
    CategoryID => $CategoryID,
    ParentID   => 0,
    Name       => 'RootCategory',
    Comment    => 'Root Category for testing',
    ValidID    => 1,
    UserID     => 1,
);

$Self->True(
    $CategoryUpdate,
    "CategoryUpdate() - Root Category",
);

# set ParentID to empty to make it fail
my $CategoryUpdateFail = $FAQObject->CategoryUpdate(
    CategoryID => $CategoryID,
    ParentID   => '',
    Name       => 'RootCategory',
    Comment    => 'Root Category for testing',
    ValidID    => 1,
    UserID     => 1,
);

$Self->False(
    $CategoryUpdateFail,
    "CategoryUpdate() - Root Category",
);

my $ChildCategoryID = $FAQObject->CategoryAdd(
    Name     => 'ChildCategory',
    Comment  => 'Child Category for testing',
    ParentID => $CategoryID,
    ValidID  => 1,
    UserID   => 1,
);

$Self->True(
    $ChildCategoryID,
    "CategoryAdd() - Child Category",
);

my $ChildCategoryDelete = $FAQObject->CategoryDelete(
    CategoryID => $ChildCategoryID,
    UserID     => 1,
);

$Self->True(
    $ChildCategoryDelete,
    "CategoryDelete() - Child Category",
);

my $CategoryDelete = $FAQObject->CategoryDelete(
    CategoryID => $CategoryID,
    UserID     => 1,
);

$Self->True(
    $CategoryDelete,
    "CategoryDelete() - Root Category",
);

#ItemFieldGet Tests
my %TestFields = (
    Field1 => 'Symptom...',
    Field2 => 'Problem...',
    Field3 => 'Solution...',
    Field4 => 'User Field4...',
    Field5 => 'User Field5...',
    Field6 => 'Comment...',
);

$FAQID = $FAQObject->FAQAdd(
    Title      => 'Some Text',
    CategoryID => 1,
    StateID    => 1,
    LanguageID => 1,
    Keywords   => 'some keywords',
    %TestFields,
    UserID => 1,
);

$Self->True(
    $FAQID,
    "FAQAdd() for ItemFieldGet with True",
);

my %ResultFields;

my $CheckFields = sub {
    my %Param = @_;

    for my $FieldCount ( 1 .. 6 ) {
        my $Field = "Field$FieldCount";

        # check that cache is clean
        my $Cache = $CacheObject->Get(
            Type => 'FAQ',
            Key  => "ItemFieldGet::ItemID::$FAQID",
        );

        # on before first Get cache should be undef, after firs cache exist, but the Field key must be
        # undef
        if ( ref $Cache eq 'HASH' ) {
            $Self->Is(
                $Cache->{$Field},
                undef,
                "Cache before ItemFieldGet(): $Field",
            );
        }
        else {
            $Self->Is(
                $Cache,
                undef,
                "Cache before ItemFieldGet(): Complete cache",
            );
        }

        # get the field
        $ResultFields{$Field} = $FAQObject->ItemFieldGet(
            ItemID => $FAQID,
            Field  => $Field,
            UserID => 1,
        );

        # check cache is set
        $Cache = $CacheObject->Get(
            Type => 'FAQ',
            Key  => "ItemFieldGet::ItemID::$FAQID",
        );

        $Self->Is(
            ref $Cache,
            'HASH',
            "Cache after ItemFieldGet(): ref",
        );
        $Self->Is(
            $Cache->{$Field},
            $Param{CompareFields}->{$Field},
            "Cache after ItemFieldGet(): $Field matched with original field data",
        );
    }
};

$CheckFields->( CompareFields => \%TestFields );

$Self->IsDeeply(
    \%ResultFields,
    \%TestFields,
    "ItemFieldGet(): for all fields match expected data",
);

# update the FAQ item
my %UpdatedTestFields = (
    Field1 => 'Updated Symptom...',
    Field2 => 'Updated Problem...',
    Field3 => 'Updated Solution...',
    Field4 => 'Updated User Field4...',
    Field5 => 'Updated User Field5...',
    Field6 => 'Updated Comment...',
);

$FAQUpdate = $FAQObject->FAQUpdate(
    ItemID     => $FAQID,
    Title      => 'Some Text',
    CategoryID => 1,
    StateID    => 1,
    LanguageID => 1,
    Keywords   => 'some keywords',
    %UpdatedTestFields,
    UserID => 1,
);

$Self->True(
    $FAQUpdate,
    "FAQUpdate() for ItemFieldGet with True",
);

$CheckFields->( CompareFields => \%UpdatedTestFields );

$FAQDelete = $FAQObject->FAQDelete(
    ItemID => $FAQID,
    UserID => 1,
);

$Self->True(
    $FAQDelete,
    "FAQDelete() for ItemFieldGet: with True",
);

# check that cache is clean
my $Cache = $CacheObject->Get(
    Type => 'FAQ',
    Key  => "ItemFieldGet::ItemID::$FAQID",
);

$Self->Is(
    $Cache,
    undef,
    "Cache for ItemFieldGet() after FAQDelete: Complete cache",
);

# FAQ item cache tests
$FAQID = $FAQObject->FAQAdd(
    Title      => 'Some Text',
    CategoryID => 1,
    StateID    => 1,
    LanguageID => 1,
    Keywords   => 'some keywords',
    %TestFields,
    UserID => 1,
);

# check that cache is clean
$Cache = $CacheObject->Get(
    Type => 'FAQ',
    Key  => 'FAQGet::ItemID::' . $FAQID . '::ItemFields::0',
);
$Self->Is(
    $Cache,
    undef,
    "Cache for FAQ No ItemFields Before FAQGet(): Complete cache",
);
$Cache = $CacheObject->Get(
    Type => 'FAQ',
    Key  => 'FAQGet::ItemID::' . $FAQID . '::ItemFields::1',
);
$Self->Is(
    $Cache,
    undef,
    "Cache for FAQ With ItemFields Before FAQGet(): Complete cache",
);

# get FAQ no Item Fields
my %FAQData = $FAQObject->FAQGet(
    ItemID     => $FAQID,
    ItemFields => 0,
    UserID     => 1
);

$Self->Is(
    $FAQData{ItemID},
    $FAQID,
    "Sanity Check for FAQGet(): match ItemID"
);

# sanity check Item Fields
for my $FieldCount ( 1 .. 6 ) {
    my $Field = "Field$FieldCount";

    $Self->Is(
        $FAQData{$Field},
        undef,
        "Sanity Check for FAQGet(): no ItemFields $Field",
    );
}
$Cache = $CacheObject->Get(
    Type => 'FAQ',
    Key  => 'FAQGet::ItemID::' . $FAQID . '::ItemFields::0',
);
$Self->Is(
    ref $Cache,
    'HASH',
    "Cache for FAQ No ItemFields After FAQGet(): Complete cache ref",
);
$Cache = $CacheObject->Get(
    Type => 'FAQ',
    Key  => 'FAQGet::ItemID::' . $FAQID . '::ItemFields::1',
);
$Self->Is(
    $Cache,
    undef,
    "Cache for FAQ With ItemFields After FAQGet(): Complete cache",
);

# get FAQ with Item Fields
%FAQData = $FAQObject->FAQGet(
    ItemID     => $FAQID,
    ItemFields => 1,
    UserID     => 1
);

$Self->Is(
    $FAQData{ItemID},
    $FAQID,
    "Sanity Check for FAQGet(): match ItemID"
);

# sanity check Item Fields
for my $FieldCount ( 1 .. 6 ) {
    my $Field = "Field$FieldCount";

    $Self->IsNot(
        $FAQData{$Field},
        undef,
        "Sanity Check for FAQGet(): with ItemFields $Field",
    );
}
$Cache = $CacheObject->Get(
    Type => 'FAQ',
    Key  => 'FAQGet::ItemID::' . $FAQID . '::ItemFields::0',
);
$Self->Is(
    ref $Cache,
    'HASH',
    "Cache for FAQ No ItemFields After FAQGet(): Complete cache ref",
);
$Cache = $CacheObject->Get(
    Type => 'FAQ',
    Key  => 'FAQGet::ItemID::' . $FAQID . '::ItemFields::1',
);
$Self->Is(
    ref $Cache,
    'HASH',
    "Cache for FAQ With ItemFields After FAQGet(): Complete cache ref",
);

# -------------------------
# FAQ State tests
# -------------------------
my %States = $FAQObject->StateList(
    UserID => 1,
);

$Self->IsNot(
    scalar keys %States,
    0,
    "StateList() number of elements should not be 0"
);

for my $StateID ( sort keys %States ) {
    my %State = $FAQObject->StateGet(
        StateID => $StateID,
        UserID  => 1,
    );

    $Self->IsNot(
        $State{StateID},
        undef,
        "StateGet() StateID for StateID: '$StateID' should not be undef"
    );
    $Self->IsNot(
        $State{Name},
        undef,
        "StateGet() Name for StateID:    '$StateID' should not be undef"
    );
    $Self->IsNot(
        $State{TypeID},
        undef,
        "StateGet() TypeID for StateID:  '$StateID' should not be undef"
    );
}

my $StateTypeList = $FAQObject->StateTypeList(
    UserID => 1,
);

$Self->Is(
    ref $StateTypeList,
    'HASH',
    "StateTypeList() returns hashref",
);

$Self->Is(
    scalar keys %{$StateTypeList},
    3,
    "StateTypeList() has 3 keys",
);

$Self->Is(
    $StateTypeList->{1},
    'internal',
    "StateTypeList() 1 is internal",
);

$Self->Is(
    $StateTypeList->{2},
    'external',
    "StateTypeList() 2 is external",
);

$Self->Is(
    $StateTypeList->{3},
    'public',
    "StateTypeList() 3 is public",
);

$StateTypeList = $FAQObject->StateTypeList(
    Types  => [ 'public', 'external' ],
    UserID => 1,
);

$Self->Is(
    scalar keys %{$StateTypeList},
    2,
    "StateTypeList() has 2 keys",
);

$Self->Is(
    $StateTypeList->{2},
    'external',
    "StateTypeList() 2 is external",
);

$Self->Is(
    $StateTypeList->{3},
    'public',
    "StateTypeList() 3 is public",
);

$StateTypeList = $FAQObject->StateTypeList(
    Types  => ['internal'],
    UserID => 1,
);

$Self->Is(
    scalar keys %{$StateTypeList},
    1,
    "StateTypeList() has 1 key",
);

$Self->Is(
    $StateTypeList->{1},
    'internal',
    "StateTypeList() 1 is internal",
);

# -------------------------

# clean the system
$FAQDelete = $FAQObject->FAQDelete(
    ItemID => $FAQID,
    UserID => 1,
);

$Self->True(
    $FAQDelete,
    "FAQDelete() for ItemFieldGet: with True",
);

# check that cache is clean
$Cache = $CacheObject->Get(
    Type => 'FAQ',
    Key  => 'FAQGet::ItemID::' . $FAQID . '::ItemFields::0',
);
$Self->Is(
    $Cache,
    undef,
    "Cache for FAQ No ItemFields After FAQDelete(): Complete cache",
);
$Cache = $CacheObject->Get(
    Type => 'FAQ',
    Key  => 'FAQGet::ItemID::' . $FAQID . '::ItemFields::1',
);
$Self->Is(
    $Cache,
    undef,
    "Cache for FAQ With ItemFields After FAQDelete(): Complete cache",
);

1;
