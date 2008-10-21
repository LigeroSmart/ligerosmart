# --
# FAQ.t - FAQ tests
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: FAQ.t,v 1.9 2008-10-21 14:51:54 ub Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

use Kernel::System::FAQ;

$Self->{FAQObject} = Kernel::System::FAQ->new( %{$Self}, UserID => 1 );

my $FAQID = $Self->{FAQObject}->FAQAdd(
    Title      => 'Some Text',
    CategoryID => 1,
    StateID    => 1,
    LanguageID => 1,
    Keywords   => 'some keywords',
    Field1     => 'Problem...',
    Field2     => 'Solution...',
    FreeKey1   => 'Software',
    FreeText1  => 'Apache 3.4.2',
    FreeKey2   => 'OS',
    FreeText2  => 'OpenBSD 4.2.2',
    FreeKey3   => 'Key3',
    FreeText3  => 'Value3',
    FreeKey4   => 'Key4',
    FreeText4  => 'Value4',
);

$Self->True(
    $FAQID || 0,
    "FAQAdd() - 1",
);

my %FAQ = $Self->{FAQObject}->FAQGet(
    ItemID => $FAQID,
);

my %FAQTest = (
    Title      => 'Some Text',
    CategoryID => 1,
    StateID    => 1,
    LanguageID => 1,
    Keywords   => 'some keywords',
    Field1     => 'Problem...',
    Field2     => 'Solution...',
    FreeKey1   => 'Software',
    FreeText1  => 'Apache 3.4.2',
    FreeKey2   => 'OS',
    FreeText2  => 'OpenBSD 4.2.2',
    FreeKey3   => 'Key3',
    FreeText3  => 'Value3',
    FreeKey4   => 'Key4',
    FreeText4  => 'Value4',
);

for my $Test ( sort keys %FAQTest ) {
    $Self->Is(
        $FAQ{$Test}     || 0,
        $FAQTest{$Test} || '',
        "FAQGet() - $Test",
    );
}

my $FAQUpdate = $Self->{FAQObject}->FAQUpdate(
    ItemID     => $FAQID,
    CategoryID => 1,
    StateID    => 2,
    LanguageID => 2,
    Title      => 'Some Text2',
    Keywords   => 'some keywords2',
    Field1     => 'Problem...2',
    Field2     => 'Solution...2',
    FreeKey1   => 'Software2',
    FreeText1  => 'Apache 3.4.22',
    FreeKey2   => 'OS2',
    FreeText2  => 'OpenBSD 4.2.22',
    FreeKey3   => 'Key32',
    FreeText3  => 'Value32',
    FreeKey4   => 'Key42',
    FreeText4  => 'Value42',
);

%FAQ = $Self->{FAQObject}->FAQGet(
    ItemID => $FAQID,
);

%FAQTest = (
    Title      => 'Some Text2',
    CategoryID => 1,
    StateID    => 2,
    LanguageID => 2,
    Keywords   => 'some keywords2',
    Field1     => 'Problem...2',
    Field2     => 'Solution...2',
    FreeKey1   => 'Software2',
    FreeText1  => 'Apache 3.4.22',
    FreeKey2   => 'OS2',
    FreeText2  => 'OpenBSD 4.2.22',
    FreeKey3   => 'Key32',
    FreeText3  => 'Value32',
    FreeKey4   => 'Key42',
    FreeText4  => 'Value42',
);

for my $Test ( sort keys %FAQTest ) {
    $Self->Is(
        $FAQTest{$Test} || '',
        $FAQ{$Test}     || 0,
        "FAQGet() - $Test",
    );
}

my $Ok = $Self->{FAQObject}->VoteAdd(
    CreatedBy => 'Some Text',
    ItemID    => $FAQID,
    IP        => '54.43.30.1',
    Interface => '2',
    Rate      => 100,
);

$Self->True(
    $Ok || 0,
    "VoteAdd()",
);

my $Vote = $Self->{FAQObject}->VoteGet(
    CreateBy  => 'Some Text',
    ItemID    => $FAQID,
    IP        => '54.43.30.1',
    Interface => '2',
);

$Self->Is(
    $Vote->{IP} || 0,
    '54.43.30.1',
    "VoteGet() - IP",
);

my $FAQID2 = $Self->{FAQObject}->FAQAdd(
    Title      => 'Title',
    CategoryID => 1,
    StateID    => 1,
    LanguageID => 1,
    Keywords   => '',
    Field1     => 'Problem1...',
    Field2     => 'Solution1...',
    FreeKey1   => 'Software1',
    FreeText1  => 'Apache 3.4.2',
    FreeKey2   => 'OS',
    FreeText2  => 'OpenBSD 4.2.2',
    FreeKey3   => 'Key3',
    FreeText3  => 'Value3',
    FreeKey4   => 'Key4',
    FreeText4  => 'Value4',
);

$Self->True(
    $FAQID2 || 0,
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
    my $Add = $Self->{FAQObject}->AttachmentAdd(
        ItemID      => $FAQID2,
        Content     => ${$ContentSCALARRef},
        ContentType => 'text/xml',
        Filename    => $AttachmentTest->{File},
    );
    $Self->True(
        $Add || 0,
        "AttachmentAdd() - $AttachmentTest->{File}",
    );
    my @AttachmentIndex = $Self->{FAQObject}->AttachmentIndex(
        ItemID => $FAQID2,
    );
    my %File = $Self->{FAQObject}->AttachmentGet(
        ItemID => $FAQID2,
        FileID => $AttachmentIndex[0]->{FileID},
    );
    $Self->Is(
        $File{Filename} || '',
        $AttachmentTest->{File},
        "AttachmentGet() - Filename $AttachmentTest->{File}",
    );
    my $MD5 = $Self->{MainObject}->MD5sum(
        String => \$File{Content},
    );
    $Self->Is(
        $MD5 || '',
        $AttachmentTest->{MD5},
        "AttachmentGet() - MD5 $AttachmentTest->{File}",
    );

    my $Delete = $Self->{FAQObject}->AttachmentDelete(
        ItemID => $FAQID2,
        FileID => $AttachmentIndex[0]->{FileID},
    );
    $Self->True(
        $Delete || 0,
        "AttachmentDelete() - $AttachmentTest->{File}",
    );

}

my @FAQIDs = $Self->{FAQObject}->FAQSearch(
    Number  => '*',
    What    => '*s*',
    Keyword => 'some*',
    States  => [ 'public', 'internal' ],
    Order   => 'Votes',
    Sort    => 'ASC',
    Limit   => 150,
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

@FAQIDs = $Self->{FAQObject}->FAQSearch(
    Number => '*',
    Title  => 'tITLe',
    What   => 'l',
    States => [ 'public', 'internal' ],
    Order  => 'Created',
    Sort   => 'ASC',
    Limit  => 150,
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

my @VoteIDs = @{
    $Self->{FAQObject}->VoteSearch(
        ItemID => $FAQID,
        )
    };

for my $VoteID (@VoteIDs) {
    my $VoteDelete = $Self->{FAQObject}->VoteDelete(
        VoteID => 1,
    );
    $Self->True(
        $VoteDelete || 0,
        "VoteDelete()",
    );
}

# add FAQ article to log
my $Success = $Self->{FAQObject}->FAQLogAdd(
    ItemID    => $FAQID,
    Interface => 'internal',
);
$Self->True(
    $Success,
    "FAQLogAdd() - $FAQID",
);

# try to add same FAQ article to log again (must return false)
$Success = $Self->{FAQObject}->FAQLogAdd(
    ItemID    => $FAQID,
    Interface => 'internal',
);
$Self->False(
    $Success,
    "FAQLogAdd() - $FAQID",
);

# add another FAQ article to log
$Success = $Self->{FAQObject}->FAQLogAdd(
    ItemID    => $FAQID2,
    Interface => 'internal',
);
$Self->True(
    $Success,
    "FAQLogAdd() - $FAQID2",
);

# get FAQ Top10
my $Top10IDsRef = $Self->{FAQObject}->FAQTop10Get(
    Interface => 'internal',
    Limit     => 10,
);
$Self->True(
    scalar @{ $Top10IDsRef },
    "FAQTop10Get()",
);

my $FAQDelete = $Self->{FAQObject}->FAQDelete(
    ItemID => $FAQID,
    UserID => 1,
);
$Self->True(
    $FAQDelete || 0,
    "FAQDelete()",
);

my $FAQDelete2 = $Self->{FAQObject}->FAQDelete(
    ItemID => $FAQID2,
    UserID => 1,
);
$Self->True(
    $FAQDelete2 || 0,
    "FAQDelete()",
);

1;
