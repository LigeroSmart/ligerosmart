# --
# FAQ.t - FAQ tests
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: FAQ.t,v 1.2 2008-03-02 22:26:14 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

use Kernel::System::FAQ;

$Self->{FAQObject} = Kernel::System::FAQ->new(%{$Self}, UserID => 1);

my $FAQID = $Self->{FAQObject}->FAQAdd(
    Title => 'Some Text',
    CategoryID => 1,
    StateID => 1,
    LanguageID => 1,
    Keywords => 'some keywords',
    Field1 => 'Problem...',
    Field2 => 'Solution...',
    FreeKey1 => 'Software',
    FreeText1 => 'Apache 3.4.2',
    FreeKey2 => 'OS',
    FreeText2 => 'OpenBSD 4.2.2',
    FreeKey3 => 'Key3',
    FreeText3 => 'Value3',
    FreeKey4 => 'Key4',
    FreeText4 => 'Value4',
);

$Self->True(
    $FAQID || 0,
    "FAQAdd() - FAQAdd()",
);

my %FAQ = $Self->{FAQObject}->FAQGet(
    ItemID => $FAQID,
);

my %FAQTest = (
    Title => 'Some Text',
    CategoryID => 1,
    StateID => 1,
    LanguageID => 1,
    Keywords => 'some keywords',
    Field1 => 'Problem...',
    Field2 => 'Solution...',
    FreeKey1 => 'Software',
    FreeText1 => 'Apache 3.4.2',
    FreeKey2 => 'OS',
    FreeText2 => 'OpenBSD 4.2.2',
    FreeKey3 => 'Key3',
    FreeText3 => 'Value3',
    FreeKey4 => 'Key4',
    FreeText4 => 'Value4',
);

for my $Test ( sort keys %FAQTest ) {
    $Self->Is(
        $FAQ{$Test} || 0,
        $FAQTest{$Test} || '',
        "FAQGet() - $Test",
    );
}

my $FAQUpdate = $Self->{FAQObject}->FAQUpdate(
    ItemID => $FAQID,
    CategoryID => 1,
    StateID => 2,
    LanguageID => 2,
    Title => 'Some Text2',
    Keywords => 'some keywords2',
    Field1 => 'Problem...2',
    Field2 => 'Solution...2',
    FreeKey1 => 'Software2',
    FreeText1 => 'Apache 3.4.22',
    FreeKey2 => 'OS2',
    FreeText2 => 'OpenBSD 4.2.22',
    FreeKey3 => 'Key32',
    FreeText3 => 'Value32',
    FreeKey4 => 'Key42',
    FreeText4 => 'Value42',
);

%FAQ = $Self->{FAQObject}->FAQGet(
    ItemID => $FAQID,
);

%FAQTest = (
    Title => 'Some Text2',
    CategoryID => 1,
    StateID => 2,
    LanguageID => 2,
    Keywords => 'some keywords2',
    Field1 => 'Problem...2',
    Field2 => 'Solution...2',
    FreeKey1 => 'Software2',
    FreeText1 => 'Apache 3.4.22',
    FreeKey2 => 'OS2',
    FreeText2 => 'OpenBSD 4.2.22',
    FreeKey3 => 'Key32',
    FreeText3 => 'Value32',
    FreeKey4 => 'Key42',
    FreeText4 => 'Value42',
);

for my $Test ( sort keys %FAQTest ) {
    $Self->Is(
        $FAQTest{$Test} || '',
        $FAQ{$Test} || 0,
        "FAQGet() - $Test",
    );
}

my $Ok = $Self->{FAQObject}->VoteAdd(
    CreatedBy => 'Some Text',
    ItemID => $FAQID,
    IP => '54.43.30.1',
    Interface => '2',
    Rate => 100,
);

$Self->True(
    $Ok || 0,
    "VoteAdd()",
);

my $Vote = $Self->{FAQObject}->VoteGet(
    CreateBy => 'Some Text',
    ItemID => $FAQID,
    IP => '54.43.30.1',
    Interface => '2',
);

$Self->Is(
    $Vote->{IP} || 0,
    '54.43.30.1',
    "VoteGet() - IP",
);

my @FAQIDs = $Self->{FAQObject}->FAQSearch(
    Number => '*',
    What => '*s*',
    Keywords => 'some*',
    States => ['public', 'internal'],
    Order => 'Votes',
    Sort => 'ASC',
    Limit => 150,
);

my $FAQSearchFound = 0;
for my $FAQIDSearch ( @FAQIDs ) {
    if ( $FAQIDSearch eq $FAQID ) {
        $FAQSearchFound = 1;
        last;
    }
}
$Self->True(
    $FAQSearchFound,
    "FAQSearch()",
);

my @VoteIDs = @{$Self->{FAQObject}->VoteSearch(
    ItemID => $FAQID,
)};

for my $VoteID ( @VoteIDs ) {
    my $VoteDelete = $Self->{FAQObject}->VoteDelete(
        VoteID => 1,
    );
    $Self->True(
        $VoteDelete || 0,
        "VoteDelete()",
    );
}

my $FAQDelete = $Self->{FAQObject}->FAQDelete(
    ItemID => $FAQID,
);
$Self->True(
    $FAQDelete || 0,
    "FAQDelete()",
);

1;
