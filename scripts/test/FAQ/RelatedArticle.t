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
my $Helper       = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
my $UserObject   = $Kernel::OM->Get('Kernel::System::User');
my $FAQObject    = $Kernel::OM->Get('Kernel::System::FAQ');

# set config options
$ConfigObject->Set(
    Key   => 'FAQ::ApprovalRequired',
    Value => 0,
);

$ConfigObject->Set(
    Key   => 'CustomerGroupSupport',
    Value => 0,
);

my $TestUserLogin = $Helper->TestUserCreate(
    Groups => [ 'users', ],
);
my $TestUserID = $UserObject->UserLookup(
    UserLogin => $TestUserLogin,
);

my $AdminUserLogin = $Helper->TestUserCreate(
    Groups => [ 'admin', 'users' ],
);
my $AdminUserID = $UserObject->UserLookup(
    UserLogin => $AdminUserLogin,
);

# create some customer users
my @CustomerUsers;
for ( 0 .. 1 ) {
    my $TestUserLogin = $Helper->TestCustomerUserCreate();
    push @CustomerUsers, $TestUserLogin;
}

my $RandomNumber = $Helper->GetRandomNumber();

my %StateList = $FAQObject->StateList(
    UserID => $AdminUserID,
);
my %ReverseStateList = reverse %StateList;

# Call this function at the beginning, to check if the cache cleanup works correctly after new article was created.
$FAQObject->FAQKeywordArticleList(
    CustomerUser => $CustomerUsers[0],
    UserID       => $AdminUserID,
);

# define the tickets for the statistic result tests
my @FAQItems = (
    {
        Title      => 'Some Text',
        CategoryID => 1,
        StateID    => $ReverseStateList{'external (customer)'},    # 'external'
        LanguageID => 1,                                           # 'en'
        Keywords =>
            "ticket$RandomNumber keyword$RandomNumber itsm$RandomNumber example$RandomNumber $RandomNumber.$RandomNumber",
        Field1      => 'Problem...',
        Field2      => 'Solution...',
        ContentType => 'text/html',
        UserID      => $AdminUserID,
    },
    {
        Title       => 'Some Text Example',
        CategoryID  => 1,
        StateID     => $ReverseStateList{'external (customer)'},    # 'external'
        LanguageID  => 1,                                           # 'en'
        Keywords    => "faq$RandomNumber keyword$RandomNumber",
        Field1      => 'Problem...',
        Field2      => 'Solution...',
        ContentType => 'text/html',
        UserID      => $AdminUserID,
    },
    {
        Title       => 'Some Text Example',
        CategoryID  => 1,
        StateID     => $ReverseStateList{'external (customer)'},                    # 'external'
        LanguageID  => 2,                                                           # 'de'
        Keywords    => "faq$RandomNumber keyword$RandomNumber ItSm$RandomNumber",
        Field1      => 'Problem...',
        Field2      => 'Solution...',
        ContentType => 'text/html',
        UserID      => $AdminUserID,
    },
    {
        Title       => 'Some Text Public',
        CategoryID  => 1,
        StateID     => $ReverseStateList{'public (all)'},                             # 'public'
        LanguageID  => 1,                                                             # 'en'
        Keywords    => "FAQ$RandomNumber keyword$RandomNumber public$RandomNumber",
        Field1      => 'Problem...',
        Field2      => 'Solution...',
        ContentType => 'text/html',
        UserID      => $AdminUserID,
    },
    {
        Title       => 'Some Text Internal',
        CategoryID  => 1,
        StateID     => $ReverseStateList{'internal (agent)'},                                               # 'internal'
        LanguageID  => 1,                                                                                   # 'en'
        Keywords    => "ticket$RandomNumber KeyWord$RandomNumber iTsm$RandomNumber internal$RandomNumber",
        Field1      => 'Problem...',
        Field2      => 'Solution...',
        ContentType => 'text/html',
        UserID      => $AdminUserID,
    },
    {
        Title       => 'Some Text Internal',
        CategoryID  => 1,
        StateID     => $ReverseStateList{'internal (agent)'},                                               # 'internal'
        LanguageID  => 2,                                                                                   # 'en'
        Keywords    => "ticket$RandomNumber KeyWord$RandomNumber iTsm$RandomNumber internal$RandomNumber",
        Field1      => 'Problem...',
        Field2      => 'Solution...',
        ContentType => 'text/html',
        UserID      => $AdminUserID,
    },
    {
        Title       => 'Some Text Internal',
        CategoryID  => 1,
        StateID     => $ReverseStateList{'internal (agent)'},                                               # 'internal'
        LanguageID  => 1,                                                                                   # 'en'
        Keywords    => "faq$RandomNumber",
        Field1      => 'Problem...',
        Field2      => 'Solution...',
        ContentType => 'text/html',
        UserID      => $AdminUserID,
    },
);

# Create some faq items for the test.
my @FAQItemIDs;

FAQITEM:
for my $FAQItem (@FAQItems) {

    my $FAQItemID = $FAQObject->FAQAdd(
        %{$FAQItem},
    );

    $Self->True(
        $FAQItemID,
        "FAQAdd() successful for test - FAQItemID $FAQItemID",
    );

    push @FAQItemIDs, $FAQItemID;
}

# Define some test for the function 'FAQKeywordArticleList'.
my @Tests = (
    {
        Description           => 'Test does not contain all necessary data for FAQKeywordArticleList',
        Fails                 => 1,
        FAQKeywordArticleList => {},
        ReferenceData         => {},
    },
    {
        Description           => 'Test with a customer user for FAQKeywordArticleList',
        FAQKeywordArticleList => {
            CustomerUser => $CustomerUsers[0],
            UserID       => $AdminUserID,
        },
        ReferenceData => {
            "$RandomNumber.$RandomNumber" => [
                $FAQItemIDs[0],
            ],
            "example$RandomNumber" => [
                $FAQItemIDs[0],
            ],
            "faq$RandomNumber" => [
                $FAQItemIDs[3],
                $FAQItemIDs[2],
                $FAQItemIDs[1],
            ],
            "itsm$RandomNumber" => [
                $FAQItemIDs[2],
                $FAQItemIDs[0],
            ],
            "keyword$RandomNumber" => [
                $FAQItemIDs[3],
                $FAQItemIDs[2],
                $FAQItemIDs[1],
                $FAQItemIDs[0],
            ],
            "public$RandomNumber" => [
                $FAQItemIDs[3],
            ],
            "ticket$RandomNumber" => [
                $FAQItemIDs[0],
            ],
        },
    },
    {
        Description           => "Test with a customer user, but only with language 'en' for FAQKeywordArticleList",
        FAQKeywordArticleList => {
            CustomerUser => $CustomerUsers[0],
            Languages    => ['en'],
            UserID       => $AdminUserID,
        },
        ReferenceData => {
            "example$RandomNumber" => [
                $FAQItemIDs[0],
            ],
            "faq$RandomNumber" => [
                $FAQItemIDs[3],
                $FAQItemIDs[1],
            ],
            "itsm$RandomNumber" => [
                $FAQItemIDs[0],
            ],
            "keyword$RandomNumber" => [
                $FAQItemIDs[3],
                $FAQItemIDs[1],
                $FAQItemIDs[0],
            ],
            "public$RandomNumber" => [
                $FAQItemIDs[3],
            ],
            "ticket$RandomNumber" => [
                $FAQItemIDs[0],
            ],
        },
    },
    {
        Description           => "Test with a customer user, but only with language 'de' for FAQKeywordArticleList",
        FAQKeywordArticleList => {
            CustomerUser => $CustomerUsers[0],
            Languages    => ['de'],
            UserID       => $AdminUserID,
        },
        ReferenceData => {
            "faq$RandomNumber" => [
                $FAQItemIDs[2],
            ],
            "itsm$RandomNumber" => [
                $FAQItemIDs[2],
            ],
            "keyword$RandomNumber" => [
                $FAQItemIDs[2],
            ],
        },
    },
    {
        Description           => "Test with a customer user with language 'en' and 'de' for FAQKeywordArticleList",
        FAQKeywordArticleList => {
            CustomerUser => $CustomerUsers[0],
            Languages    => [ 'en', 'de' ],
            UserID       => $AdminUserID,
        },
        ReferenceData => {
            "example$RandomNumber" => [
                $FAQItemIDs[0],
            ],
            "faq$RandomNumber" => [
                $FAQItemIDs[3],
                $FAQItemIDs[2],
                $FAQItemIDs[1],
            ],
            "itsm$RandomNumber" => [
                $FAQItemIDs[2],
                $FAQItemIDs[0],
            ],
            "keyword$RandomNumber" => [
                $FAQItemIDs[3],
                $FAQItemIDs[2],
                $FAQItemIDs[1],
                $FAQItemIDs[0],
            ],
            "public$RandomNumber" => [
                $FAQItemIDs[3],
            ],
            "ticket$RandomNumber" => [
                $FAQItemIDs[0],
            ],
        },
    },
    {
        Description           => "Test with a test user, but only with language 'en' for FAQKeywordArticleList",
        FAQKeywordArticleList => {
            Languages => ['en'],
            UserID    => $TestUserID,
        },
        ReferenceData => {
            "$RandomNumber.$RandomNumber" => [
                $FAQItemIDs[0],
            ],
            "example$RandomNumber" => [
                $FAQItemIDs[0],
            ],
            "faq$RandomNumber" => [
                $FAQItemIDs[6],
                $FAQItemIDs[3],
                $FAQItemIDs[1],
            ],
            "itsm$RandomNumber" => [
                $FAQItemIDs[4],
                $FAQItemIDs[0],
            ],
            "keyword$RandomNumber" => [
                $FAQItemIDs[4],
                $FAQItemIDs[3],
                $FAQItemIDs[1],
                $FAQItemIDs[0],
            ],
            "public$RandomNumber" => [
                $FAQItemIDs[3],
            ],
            "internal$RandomNumber" => [
                $FAQItemIDs[4],
            ],
            "ticket$RandomNumber" => [
                $FAQItemIDs[4],
                $FAQItemIDs[0],
            ],
        },
    },
    {
        Description           => "Test with a test user, but only with language 'de' for FAQKeywordArticleList",
        FAQKeywordArticleList => {
            Languages => ['de'],
            UserID    => $TestUserID,
        },
        ReferenceData => {
            "faq$RandomNumber" => [
                $FAQItemIDs[2],
            ],
            "itsm$RandomNumber" => [
                $FAQItemIDs[5],
                $FAQItemIDs[2],
            ],
            "keyword$RandomNumber" => [
                $FAQItemIDs[5],
                $FAQItemIDs[2],
            ],
            "internal$RandomNumber" => [
                $FAQItemIDs[5],
            ],
            "ticket$RandomNumber" => [
                $FAQItemIDs[5],
            ],
        },
    },
    {
        Description           => "Test with a test user with language 'en' and 'de' for FAQKeywordArticleList",
        FAQKeywordArticleList => {
            Languages => [ 'en', 'de' ],
            UserID    => $AdminUserID,
        },
        ReferenceData => {
            "example$RandomNumber" => [
                $FAQItemIDs[0],
            ],
            "faq$RandomNumber" => [
                $FAQItemIDs[6],
                $FAQItemIDs[3],
                $FAQItemIDs[2],
                $FAQItemIDs[1],
            ],
            "itsm$RandomNumber" => [
                $FAQItemIDs[5],
                $FAQItemIDs[4],
                $FAQItemIDs[2],
                $FAQItemIDs[0],
            ],
            "keyword$RandomNumber" => [
                $FAQItemIDs[5],
                $FAQItemIDs[4],
                $FAQItemIDs[3],
                $FAQItemIDs[2],
                $FAQItemIDs[1],
                $FAQItemIDs[0],
            ],
            "public$RandomNumber" => [
                $FAQItemIDs[3],
            ],
            "internal$RandomNumber" => [
                $FAQItemIDs[5],
                $FAQItemIDs[4],
            ],
            "ticket$RandomNumber" => [
                $FAQItemIDs[5],
                $FAQItemIDs[4],
                $FAQItemIDs[0],
            ],
        },
    },
);

# define test counter
my $TestCount = 1;

TEST:
for my $Test (@Tests) {

    # check FAQKeywordArticleList attribute
    if ( !$Test->{FAQKeywordArticleList} || ref $Test->{FAQKeywordArticleList} ne 'HASH' ) {

        $Self->True(
            0,
            "Test $TestCount: No FAQKeywordArticleList found for this test.",
        );

        next TEST;
    }

    # print test case description
    if ( $Test->{Description} ) {
        $Self->True(
            1,
            "Test $TestCount: $Test->{Description}",
        );
    }

    my %FAQKeywordArticleList = $FAQObject->FAQKeywordArticleList(
        %{ $Test->{FAQKeywordArticleList} },
    );

    if ( $Test->{Fails} ) {
        $Self->False(
            %FAQKeywordArticleList ? 1 : 0,
            "Test $TestCount: FAQKeywordArticleList() - should fail.",
        );
    }
    else {

        for my $Keyword ( sort keys %{ $Test->{ReferenceData} } ) {

            $Self->IsDeeply(
                $FAQKeywordArticleList{$Keyword} || [],
                $Test->{ReferenceData}->{$Keyword},
                "Test $TestCount: FAQKeywordArticleList() - $Keyword - test the result",
            );
        }
    }
}
continue {
    $TestCount++;
}

# Check if the cache exists for the last function call.
my @LanguageIDs;

LANGUAGENAME:
for my $LanguageName ( @{ $Tests[-1]->{FAQKeywordArticleList}->{Languages} } ) {
    my $LanguageID = $FAQObject->LanguageLookup(
        Name => $LanguageName,
    );
    next LANGUAGENAME if !$LanguageID;

    push @LanguageIDs, $LanguageID;
}

my $CategoryIDs = $FAQObject->AgentCategorySearch(
    GetSubCategories => 1,
    UserID           => $TestUserID,
);

my $CacheKey = 'FAQKeywordArticleList';

if (@LanguageIDs) {
    $CacheKey .= '::Language' . join '::', sort @LanguageIDs;
}
$CacheKey .= '::CategoryIDs' . join '::', sort @{$CategoryIDs};
$CacheKey .= '::Interface::internal';

my $LastFAQKeywordArticleListCache = $Kernel::OM->Get('Kernel::System::Cache')->Get(
    Type => 'FAQKeywordArticleList',
    Key  => $CacheKey,
);

$Self->True(
    1,
    "Test $TestCount: Test the cache for last function call",
);

for my $Keyword ( sort keys %{ $Tests[-1]->{ReferenceData} } ) {

    $Self->IsDeeply(
        $LastFAQKeywordArticleListCache->{$Keyword} || [],
        $Tests[-1]->{ReferenceData}->{$Keyword},
        "Test $TestCount: Cache - FAQKeywordArticleList() - $Keyword - test the result",
    );
}

# Define some test for the function 'RelatedCustomerArticleList'.
@Tests = (
    {
        Description                => 'Test does not contain all necessary data for RelatedCustomerArticleList',
        Fails                      => 1,
        RelatedCustomerArticleList => {
            Subject => '',
            Body    => '',
        },
        ReferenceData => {},
    },

    {
        Description                => 'Test with a keyword in the subject for RelatedCustomerArticleList',
        RelatedCustomerArticleList => {
            Subject => "itsm$RandomNumber",
            Body    => "$RandomNumber",
            UserID  => $CustomerUsers[0],
        },
        ReferenceData => [
            $FAQItemIDs[2],
            $FAQItemIDs[0],
        ],
    },

    # E.g.
    # Given Keyword from text (with counter):
    #   - itsm (3)
    #   - ticket (1)
    #   - keyword (1)
    # Result (FAQArticleID => Calculated Quantifier and ordering by change time and create time):
    #   - FAQArticle 1 => 5
    #   - FAQArticle 2 => 4
    #   - FAQArticle 4 => 1
    #   - FAQArticle 3 => 1
    {
        Description                => 'Test with some keywords in the subject and body for RelatedCustomerArticleList',
        RelatedCustomerArticleList => {
            Subject => "itsm$RandomNumber",
            Body    => "itsm$RandomNumber, ticket$RandomNumber keyword$RandomNumber ITSM$RandomNumber.",
            UserID  => $CustomerUsers[0],
        },
        ReferenceData => [
            $FAQItemIDs[0],
            $FAQItemIDs[2],
            $FAQItemIDs[3],
            $FAQItemIDs[1],
        ],
    },

    # E.g.
    # Given Keyword from text (with counter):
    #   - itsm (3)
    #   - ticket (1)
    #   - keyword (1)
    # Result (FAQArticleID => Calculated Quantifier and ordering by change time and create time):
    #   - FAQArticle 1 => 5
    #   - FAQArticle 2 => 4
    #   - FAQArticle 4 => 1
    #   - FAQArticle 3 => 1
    {
        Description =>
            'Test with some html keywords in the subject and body (with html and link) for RelatedCustomerArticleList',
        RelatedCustomerArticleList => {
            Subject => "itsm$RandomNumber",
            Body =>
                "$RandomNumber itsm$RandomNumber ticket$RandomNumber <br />keyword$RandomNumber ITSM$RandomNumber. [1] https://faq.com/",
            UserID => $CustomerUsers[0],
        },
        ReferenceData => [
            $FAQItemIDs[0],
            $FAQItemIDs[2],
            $FAQItemIDs[3],
            $FAQItemIDs[1],
        ],
    },

    # E.g.
    # Given Keyword from text (with counter):
    #   - itsm (3)
    #   - ticket (1)
    #   - keyword (1)
    # Result (FAQArticleID => Calculated Quantifier and ordering by change time and create time):
    #   - FAQArticle 2 => 1
    {
        Description                => "Test only for the language 'de' for RelatedCustomerArticleList",
        RelatedCustomerArticleList => {
            Subject   => "FAQ$RandomNumber.",
            Body      => "$RandomNumber",
            Languages => ['de'],
            UserID    => $CustomerUsers[0],
        },
        ReferenceData => [
            $FAQItemIDs[2],
        ],
    },

    # E.g.
    # Given Keyword from text (with counter):
    #   - itsm (3)
    #   - ticket (1)
    #   - keyword (1)
    # Result (FAQArticleID => Calculated Quantifier and ordering by change time and create time):
    #   - FAQArticle 1 => 5
    #   - FAQArticle 2 => 4
    {
        Description => 'Test with some keywords in the subject and body and a limit for RelatedCustomerArticleList',
        RelatedCustomerArticleList => {
            Subject => "itsm$RandomNumber",
            Body    => "itsm$RandomNumber; ticket$RandomNumber keyword$RandomNumber ITSM$RandomNumber.",
            Limit   => 2,
            UserID  => $CustomerUsers[0],
        },
        ReferenceData => [
            $FAQItemIDs[0],
            $FAQItemIDs[2],
        ],
    },

    # E.g.
    # Given Keyword from text (with counter):
    #   - RandomNumner.RandomNumer (2)
    #   - faq (1)
    # Result (FAQArticleID => Calculated Quantifier and ordering by change time and create time):
    #   - FAQArticle 1 => 2
    #   - FAQArticle 4 => 1
    {
        Description => 'Test with some keywords in the subject and body and a limit for RelatedCustomerArticleList',
        RelatedCustomerArticleList => {
            Subject => "$RandomNumber",
            Body    => "$RandomNumber.$RandomNumber faq$RandomNumber $RandomNumber.$RandomNumber.",
            Limit   => 2,
            UserID  => $CustomerUsers[0],
        },
        ReferenceData => [
            $FAQItemIDs[0],
            $FAQItemIDs[3],
        ],
    },

    {
        Description             => 'Test with a keyword in the subject for RelatedAgentArticleList (for agent)',
        RelatedAgentArticleList => {
            Subject => "itsm$RandomNumber",
            Body    => "$RandomNumber",
            UserID  => $TestUserID,
        },
        ReferenceData => [
            $FAQItemIDs[5],
            $FAQItemIDs[4],
            $FAQItemIDs[2],
            $FAQItemIDs[0],
        ],
    },

    # E.g.
    # Given Keyword from text (with counter):
    #   - itsm (3)
    #   - ticket (1)
    #   - keyword (1)
    # Result (FAQArticleID => Calculated Quantifier and ordering by change time and create time):
    #   - FAQArticle 1 => 5
    #   - FAQArticle 2 => 4
    #   - FAQArticle 4 => 1
    #   - FAQArticle 3 => 1
    {
        Description             => 'Test with some keywords in the subject and body for RelatedAgentArticleList',
        RelatedAgentArticleList => {
            Subject => "itsm$RandomNumber",
            Body    => "itsm$RandomNumber, ticket$RandomNumber keyword$RandomNumber ITSM$RandomNumber.",
            UserID  => $TestUserID,
        },
        ReferenceData => [
            $FAQItemIDs[5],
            $FAQItemIDs[4],
            $FAQItemIDs[0],
            $FAQItemIDs[2],
            $FAQItemIDs[3],
            $FAQItemIDs[1],
        ],
    },

    # E.g.
    # Given Keyword from text (with counter):
    #   - itsm (3)
    #   - ticket (1)
    #   - keyword (1)
    # Result (FAQArticleID => Calculated Quantifier and ordering by change time and create time):
    #   - FAQArticle 1 => 5
    #   - FAQArticle 2 => 4
    #   - FAQArticle 4 => 1
    #   - FAQArticle 3 => 1
    {
        Description =>
            'Test with some html keywords in the subject and body (with html and link) for RelatedAgentArticleList',
        RelatedAgentArticleList => {
            Subject => "itsm$RandomNumber",
            Body =>
                "$RandomNumber itsm$RandomNumber ticket$RandomNumber <br />keyword$RandomNumber ITSM$RandomNumber. [1] https://faq.com/",
            UserID => $TestUserID,
        },
        ReferenceData => [
            $FAQItemIDs[5],
            $FAQItemIDs[4],
            $FAQItemIDs[0],
            $FAQItemIDs[2],
            $FAQItemIDs[3],
            $FAQItemIDs[1],
        ],
    },

    # E.g.
    # Given Keyword from text (with counter):
    #   - itsm (3)
    #   - ticket (1)
    #   - keyword (1)
    # Result (FAQArticleID => Calculated Quantifier and ordering by change time and create time):
    #   - FAQArticle 2 => 1
    {
        Description             => "Test only for the language 'de' for RelatedAgentArticleList",
        RelatedAgentArticleList => {
            Subject   => "FAQ$RandomNumber.",
            Body      => "$RandomNumber",
            Languages => ['de'],
            UserID    => $TestUserID,
        },
        ReferenceData => [
            $FAQItemIDs[2],
        ],
    },

    # E.g.
    # Given Keyword from text (with counter):
    #   - itsm (3)
    #   - ticket (1)
    #   - keyword (1)
    # Result (FAQArticleID => Calculated Quantifier and ordering by change time and create time):
    #   - FAQArticle 1 => 5
    #   - FAQArticle 2 => 4
    {
        Description => 'Test with some keywords in the subject and body and a limit for RelatedAgentArticleList',
        RelatedAgentArticleList => {
            Subject => "itsm$RandomNumber",
            Body    => "itsm$RandomNumber; ticket$RandomNumber keyword$RandomNumber ITSM$RandomNumber.",
            Limit   => 2,
            UserID  => $TestUserID,
        },
        ReferenceData => [
            $FAQItemIDs[5],
            $FAQItemIDs[4],
        ],
    },

    # E.g.
    # Given Keyword from text (with counter):
    #   - RandomNumner.RandomNumer (2)
    #   - faq (1)
    # Result (FAQArticleID => Calculated Quantifier and ordering by change time and create time):
    #   - FAQArticle 1 => 2
    #   - FAQArticle 7 => 1
    {
        Description => 'Test with some keywords in the subject and body and a limit for RelatedAgentArticleList',
        RelatedAgentArticleList => {
            Subject => "$RandomNumber",
            Body    => "$RandomNumber.$RandomNumber faq$RandomNumber $RandomNumber.$RandomNumber.",
            Limit   => 2,
            UserID  => $TestUserID,
        },
        ReferenceData => [
            $FAQItemIDs[0],
            $FAQItemIDs[6],
        ],
    },
);

TEST:
for my $Test (@Tests) {

    # check RelatedCustomerArticleList attribute
    if (
        ( !$Test->{RelatedCustomerArticleList} || ref $Test->{RelatedCustomerArticleList} ne 'HASH' )
        && ( !$Test->{RelatedAgentArticleList} || ref $Test->{RelatedAgentArticleList} ne 'HASH' )
        )
    {

        $Self->True(
            0,
            "Test $TestCount: No RelatedAgentArticleList or RelatedCustomerArticleList found for this test.",
        );

        next TEST;
    }

    my $RelatedArticleFunction;

    if ( $Test->{RelatedCustomerArticleList} ) {
        $RelatedArticleFunction = 'RelatedCustomerArticleList';
    }
    else {
        $RelatedArticleFunction = 'RelatedAgentArticleList';
    }

    # print test case description
    if ( $Test->{Description} ) {
        $Self->True(
            1,
            "Test $TestCount: $Test->{Description}",
        );
    }

    my @RelatedArticleList;

    if ( $Test->{RelatedCustomerArticleList} ) {

        @RelatedArticleList = $FAQObject->$RelatedArticleFunction(
            %{ $Test->{RelatedCustomerArticleList} },
        );
    }
    else {
        @RelatedArticleList = $FAQObject->$RelatedArticleFunction(
            %{ $Test->{RelatedAgentArticleList} },
        );
    }

    if ( $Test->{Fails} ) {
        $Self->False(
            @RelatedArticleList ? 1 : 0,
            "Test $TestCount: $RelatedArticleFunction() - should fail.",
        );
    }
    else {

        my @RelatedFAQArticleIDs = map { $_->{ItemID} } @RelatedArticleList;

        $Self->IsDeeply(
            \@RelatedFAQArticleIDs,
            $Test->{ReferenceData},
            "Test $TestCount: $RelatedArticleFunction() - test the result",
        );
    }
}
continue {
    $TestCount++;
}

# cleanup is done by restore database

1;
