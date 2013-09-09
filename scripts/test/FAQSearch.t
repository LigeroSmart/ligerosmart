# --
# FAQSearch.t - FAQ search tests
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;

use vars qw($Self);

use Kernel::System::FAQ;
use Kernel::System::UnitTest::Helper;
use Kernel::Config;

my $ConfigObject = Kernel::Config->new( %{$Self} );

# set config optiuons
$ConfigObject->Set(
    Key   => 'FAQ::ApprovalRequired',
    Value => 0,
);

# create additional objects
my $FAQObject = Kernel::System::FAQ->new(
    %{$Self},
    ConfigObject => $ConfigObject,
);

my $HelperObject = Kernel::System::UnitTest::Helper->new(
    %$Self,
    ConfigObject   => $ConfigObject,
    UnitTestObject => $Self,
);

my $RandomID = $HelperObject->GetRandomID();
my @AddedFAQs;

# add some FAQs
my %FAQAddTemplate = (
    Title      => "Some Text $RandomID",
    CategoryID => 1,
    StateID    => 1,
    LanguageID => 1,
    Keywords   => $RandomID,
    Field1     => 'Problem...',
    Field2     => 'Solution...',
    UserID     => 1,
);
for my $Counter ( 1 .. 2 ) {
    my $FAQID = $FAQObject->FAQAdd(%FAQAddTemplate);

    $Self->IsNot(
        undef,
        $FAQID,
        "FAQAdd() FAQID:'$FAQID' for FAQSearch()",
    );

    push @AddedFAQs, $FAQID;
}

# add some votes
my @VotesToAdd = (
    {
        CreatedBy => 'Some Text',
        ItemID    => $AddedFAQs[0],
        IP        => '54.43.30.1',
        Interface => '2',
        Rate      => 100,
        UserID    => 1,
    },
    {
        CreatedBy => 'Some Text',
        ItemID    => $AddedFAQs[0],
        IP        => '54.43.30.2',
        Interface => '2',
        Rate      => 50,
        UserID    => 1,
    },
    {
        CreatedBy => 'Some Text',
        ItemID    => $AddedFAQs[0],
        IP        => '54.43.30.3',
        Interface => '2',
        Rate      => 50,
        UserID    => 1,
    },
    {
        CreatedBy => 'Some Text',
        ItemID    => $AddedFAQs[1],
        IP        => '54.43.30.1',
        Interface => '2',
        Rate      => 50,
        UserID    => 1,
    },
    {
        CreatedBy => 'Some Text',
        ItemID    => $AddedFAQs[1],
        IP        => '54.43.30.2',
        Interface => '2',
        Rate      => 50,
        UserID    => 1,
    },

);
for my $Vote (@VotesToAdd) {
    my $Success = $FAQObject->VoteAdd( %{$Vote} );

    $Self->True(
        $Success,
        "VoteAdd(): FAQID:'$Vote->{ItemID}' IP:'$Vote->{IP}' Rate:'$Vote->{Rate}' with true",
    );
}

# do vote search tests
my %SearchConfigTemplate = (
    Keyword          => "$RandomID",
    States           => [ 'public', 'internal' ],
    OrderBy          => ['FAQID'],
    OrderByDirection => ['Up'],
    Limit            => 150,
    UserID           => 1,

);
my @Tests = (

    # votes tests
    {
        Name   => 'Votes, Simple Equals Operator',
        Config => {
            %SearchConfigTemplate,
            Votes => {
                Equals => 3,
            },
        },
        ExpectedResults => [
            $AddedFAQs[0],
        ],
    },
    {
        Name   => 'Votes, Simple GreaterThan Operator',
        Config => {
            %SearchConfigTemplate,
            Votes => {
                GreaterThan => 2,
            },
        },
        ExpectedResults => [
            $AddedFAQs[0],
        ],
    },
    {
        Name   => 'Votes, Simple GreaterThanEquals Operator',
        Config => {
            %SearchConfigTemplate,
            Votes => {
                GreaterThanEquals => 2,
            },
        },
        ExpectedResults => [
            $AddedFAQs[0],
            $AddedFAQs[1],
        ],
    },
    {
        Name   => 'Votes, Simple SmallerThan Operator',
        Config => {
            %SearchConfigTemplate,
            Votes => {
                SmallerThan => 3,
            },
        },
        ExpectedResults => [
            $AddedFAQs[1],
        ],
    },
    {
        Name   => 'Votes, Simple SmallerThanEquals Operator',
        Config => {
            %SearchConfigTemplate,
            Votes => {
                SmallerThanEquals => 3,
            },
        },
        ExpectedResults => [
            $AddedFAQs[0],
            $AddedFAQs[1],
        ],
    },
    {
        Name   => 'Votes, Multiple Equals Operator',
        Config => {
            %SearchConfigTemplate,
            Votes => {
                Equals => [ 2, 3 ],
            },
        },
        ExpectedResults => [
            $AddedFAQs[0],
            $AddedFAQs[1],
        ],
    },
    {
        Name   => 'Votes, Multiple GreaterThan Operator',
        Config => {
            %SearchConfigTemplate,
            Votes => {
                GreaterThan => [ 1, 2 ],
            },
        },
        ExpectedResults => [
            $AddedFAQs[0],
            $AddedFAQs[1],
        ],
    },
    {
        Name   => 'Votes, Multiple GreaterThanEquals Operator',
        Config => {
            %SearchConfigTemplate,
            Votes => {
                GreaterThanEquals => [ 2, 3 ]
            },
        },
        ExpectedResults => [
            $AddedFAQs[0],
            $AddedFAQs[1],
        ],
    },
    {
        Name   => 'Votes, Multiple SmallerThan Operator',
        Config => {
            %SearchConfigTemplate,
            Votes => {
                SmallerThan => [ 3, 2 ]
            },
        },
        ExpectedResults => [
            $AddedFAQs[1],
        ],
    },
    {
        Name   => 'Votes, Multiple SmallerThanEquals Operator',
        Config => {
            %SearchConfigTemplate,
            Votes => {
                SmallerThanEquals => [ 2, 3 ]
            },
        },
        ExpectedResults => [
            $AddedFAQs[0],
            $AddedFAQs[1],
        ],
    },
    {
        Name   => 'Votes, Wrong Operator',
        Config => {
            %SearchConfigTemplate,
            Votes => {
                LessThanEquals => [4]
            },
        },
        ExpectedResults => [
            $AddedFAQs[0],
            $AddedFAQs[1],
        ],
    },
    {
        Name   => 'Votes, Complex Operator',
        Config => {
            %SearchConfigTemplate,
            Votes => {
                GreaterThan       => 2,
                SmallerThanEquals => 3,
            },
        },
        ExpectedResults => [
            $AddedFAQs[0],
        ],
    },

    {
        Name   => 'Rate, Simple Equals Operator',
        Config => {
            %SearchConfigTemplate,
            Rate => {
                Equals => 50,
            },
        },
        ExpectedResults => [
            $AddedFAQs[1],
        ],
    },

    # Rate tests
    {
        Name   => 'Rate, Simple GreaterThan Operator',
        Config => {
            %SearchConfigTemplate,
            Rate => {
                GreaterThan => 50,
            },
        },
        ExpectedResults => [
            $AddedFAQs[0],
        ],
    },
    {
        Name   => 'Rate, Simple GreaterThanEquals Operator',
        Config => {
            %SearchConfigTemplate,
            Rate => {
                GreaterThanEquals => 50,
            },
        },
        ExpectedResults => [
            $AddedFAQs[0],
            $AddedFAQs[1],
        ],
    },
    {
        Name   => 'Rate, Simple SmallerThan Operator',
        Config => {
            %SearchConfigTemplate,
            Rate => {
                SmallerThan => 66,
            },
        },
        ExpectedResults => [
            $AddedFAQs[1],
        ],
    },
    {
        Name   => 'Rate, Simple SmallerThanEquals Operator',
        Config => {
            %SearchConfigTemplate,
            Rate => {
                SmallerThanEquals => 67,
            },
        },
        ExpectedResults => [
            $AddedFAQs[0],
            $AddedFAQs[1],
        ],
    },
    {
        Name   => 'Rate, Multiple Equals Operator',
        Config => {
            %SearchConfigTemplate,
            Rate => {
                Equals => [ 50, 66.67 ],
            },
        },
        ExpectedResults => [
            $AddedFAQs[1],
        ],
    },
    {
        Name   => 'Rate, Multiple GreaterThan Operator',
        Config => {
            %SearchConfigTemplate,
            Rate => {
                GreaterThan => [ 20, 40 ],
            },
        },
        ExpectedResults => [
            $AddedFAQs[0],
            $AddedFAQs[1],
        ],
    },
    {
        Name   => 'Rate, Multiple GreaterThanEquals Operator',
        Config => {
            %SearchConfigTemplate,
            Rate => {
                GreaterThanEquals => [ 50, 66 ]
            },
        },
        ExpectedResults => [
            $AddedFAQs[0],
            $AddedFAQs[1],
        ],
    },
    {
        Name   => 'Rate, Multiple SmallerThan Operator',
        Config => {
            %SearchConfigTemplate,
            Rate => {
                SmallerThan => [ 66, 60 ]
            },
        },
        ExpectedResults => [
            $AddedFAQs[1],
        ],
    },
    {
        Name   => 'Rate, Multiple SmallerThanEquals Operator',
        Config => {
            %SearchConfigTemplate,
            Rate => {
                SmallerThanEquals => [ 50, 67 ]
            },
        },
        ExpectedResults => [
            $AddedFAQs[0],
            $AddedFAQs[1],
        ],
    },
    {
        Name   => 'Rate, Wrong Operator',
        Config => {
            %SearchConfigTemplate,
            Rate => {
                LessThanEquals => [10]
            },
        },
        ExpectedResults => [
            $AddedFAQs[0],
            $AddedFAQs[1],
        ],
    },
    {
        Name   => 'Rate, Complex Operator',
        Config => {
            %SearchConfigTemplate,
            Rate => {
                GreaterThan => [ 50, 60 ],
                SmallerThanEquals => 67,
            },
        },
        ExpectedResults => [
            $AddedFAQs[0],
        ],
    },

    # complex tests
    {
        Name   => 'Votes, Rate, Complex + Wrong Operator',
        Config => {
            %SearchConfigTemplate,
            Votes => {
                Equals => [ 2, 3, 4 ],
                GreaterThanEquals => [3],
            },
            Rate => {
                GreaterThan => [ 20,  50 ],
                SmallerThan => [ 100, 120 ],
                LowerThan   => [99],
            },
        },
        ExpectedResults => [
            $AddedFAQs[0],
        ],
    },
);

# execute the tests
for my $Test (@Tests) {
    my @FAQIDs = $FAQObject->FAQSearch( %{ $Test->{Config} } );

    $Self->IsDeeply(
        \@FAQIDs,
        $Test->{ExpectedResults},
        "$Test->{Name} FAQSearch()",
    );
}

# clean the system
for my $FAQID (@AddedFAQs) {
    my $Success = $FAQObject->FAQDelete(
        ItemID => $FAQID,
        UserID => 1,
    );

    $Self->True(
        $Success,
        "FAQDelete() for FAQID:'$FAQID' with True",
    );
}

1;
