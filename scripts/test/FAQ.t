# --
# FAQ.t - FAQ tests
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# --
# $Id: FAQ.t,v 1.14 2010-12-02 20:22:10 ub Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;

use vars qw($Self);

use Kernel::System::FAQ;

my $FAQObject = Kernel::System::FAQ->new( %{$Self} );

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
    ItemID => $FAQID,
    UserID => 1,
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
    Title      => 'Some Text2',
    Keywords   => 'some keywords2',
    Field1     => 'Problem...2',
    Field2     => 'Solution found...2',
    UserID     => 1,
);

%FAQ = $FAQObject->FAQGet(
    ItemID => $FAQID,
    UserID => 1,
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

my $Home            = $Self->{ConfigObject}->Get('Home');
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
for my $AttachmentTest (@AttachmentTests) {
    my $ContentSCALARRef = $Self->{MainObject}->FileRead(
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
    my $MD5 = $Self->{MainObject}->MD5sum(
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

my @FAQIDs = $FAQObject->FAQSearch(
    Number           => '*',
    What             => '*s*',
    Keyword          => 'some*',
    States           => [ 'public', 'internal' ],
    OrderBy          => ['Votes'],
    OrderByDirection => ['Up'],
    Limit            => 150,
    UserID           => 1,
);

my $FAQSearchFound  = 0;
my $FAQSearchFound2 = 0;
for my $FAQIDSearch (@FAQIDs) {
    if ( $FAQIDSearch eq $FAQID ) {
        $FAQSearchFound = 1;
    }
    if ( $FAQIDSearch eq $FAQID2 ) {
        $FAQSearchFound2 = 1;
    }
}
$Self->True(
    $FAQSearchFound,
    "FAQSearch() - $FAQID",
);
$Self->False(
    $FAQSearchFound2,
    "FAQSearch() - $FAQID2",
);

@FAQIDs = $FAQObject->FAQSearch(
    Number           => '*',
    Title            => 'tITLe',
    What             => 'l',
    States           => [ 'public', 'internal' ],
    OrderBy          => ['Created'],
    OrderByDirection => ['Up'],
    Limit            => 150,
    UserID           => 1,
);

$FAQSearchFound  = 0;
$FAQSearchFound2 = 0;
for my $FAQIDSearch (@FAQIDs) {
    if ( $FAQIDSearch eq $FAQID ) {
        $FAQSearchFound = 1;
    }
    if ( $FAQIDSearch eq $FAQID2 ) {
        $FAQSearchFound2 = 1;
    }
}
$Self->False(
    $FAQSearchFound,
    "FAQSearch() - $FAQID",
);
$Self->True(
    $FAQSearchFound2,
    "FAQSearch() - $FAQID2",
);

@FAQIDs = $FAQObject->FAQSearch(
    Number           => '*',
    Title            => '',
    What             => 'solution found',
    States           => [ 'public', 'internal' ],
    OrderBy          => ['Created'],
    OrderByDirection => ['Up'],
    Limit            => 150,
    UserID           => 1,
);

$FAQSearchFound  = 0;
$FAQSearchFound2 = 0;
for my $FAQIDSearch (@FAQIDs) {
    if ( $FAQIDSearch eq $FAQID ) {
        $FAQSearchFound = 1;
    }
    if ( $FAQIDSearch eq $FAQID2 ) {
        $FAQSearchFound2 = 1;
    }
}
$Self->True(
    $FAQSearchFound,
    "FAQSearch () literal text - $FAQID",
);
$Self->False(
    $FAQSearchFound2,
    "FAQSearch() literal text - $FAQID2",
);

@FAQIDs = $FAQObject->FAQSearch(
    Number           => '*',
    Title            => '',
    What             => 'solution+found',
    States           => [ 'public', 'internal' ],
    OrderBy          => ['Created'],
    OrderByDirection => ['Up'],
    Limit            => 150,
    UserID           => 1,
);

$FAQSearchFound  = 0;
$FAQSearchFound2 = 0;
for my $FAQIDSearch (@FAQIDs) {
    if ( $FAQIDSearch eq $FAQID ) {
        $FAQSearchFound = 1;
    }
    if ( $FAQIDSearch eq $FAQID2 ) {
        $FAQSearchFound2 = 1;
    }
}
$Self->True(
    $FAQSearchFound,
    "FAQSearch() AND - $FAQID",
);
$Self->True(
    $FAQSearchFound2,
    "FAQSearch() AND - $FAQID2",
);

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

# get FAQ Top10
my $Top10IDsRef = $FAQObject->FAQTop10Get(
    Interface => 'internal',
    Limit     => 10,
    UserID    => 1,
);
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

1;
