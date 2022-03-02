package Kernel::System::GenericAgent::RecalculateContract;

use Data::Dumper;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::System::Log',
    'Kernel::System::Ticket'
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # 0=off; 1=on;
    $Self->{Debug} = $Param{Debug} || 0;

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

    my %Ticket = $TicketObject->TicketGet(
        TicketID => $Param{TicketID},
        Extended => 1,
        DynamicFields => 1,
        UserID => 1,
    );

    $Param{Data}->{Ticket} = \%Ticket;
    $Param{Data}->{TicketID} = $Param{TicketID};

    my $ArticleBackendObject;
    my $ArticleObject = $Kernel::OM->Get('Kernel::System::Ticket::Article');

    # get all articles of this ticket
    my @ArticleList = $ArticleObject->ArticleList(
        TicketID             => $Param{TicketID},
    );

    ARTICLEMETADATA:
    for my $ArticleMetaData (@ArticleList) {

        next ARTICLEMETADATA if !$ArticleMetaData;
	next ARTICLEMETADATA if !IsHashRefWithData($ArticleMetaData);

        $ArticleBackendObject = $ArticleObject->BackendForArticle( %{$ArticleMetaData} );

        my %ArticleData = $ArticleBackendObject->ArticleGet(
            TicketID  => $Param{TicketID},
            ArticleID => $ArticleMetaData->{ArticleID},
            RealNames => 1,
        );

        $Kernel::OM->Get('Kernel::System::CustomerContract')->CalculateContract(
            TicketID  => $Param{TicketID},
            ArticleID => $ArticleMetaData->{ArticleID},
            UserID    => 1
        );

    }

    return 1;

}

1;
