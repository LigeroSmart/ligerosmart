package Kernel::System::GenericAgent::WebServiceTrigger;

use Data::Dumper;

use strict;
use warnings;

use Kernel::System::GenericInterface::Webservice;
use Kernel::GenericInterface::Requester;

use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::System::Log',
    'Kernel::System::GenericInterface::Webservice',
    'Kernel::GenericInterface::Requester',
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
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    my %Ticket = $TicketObject->TicketGet(
        TicketID => $Param{TicketID},
        Extended => 1,
        DynamicFields => 1,
        UserID => 1,
    );

    # Verifies if must have some attribute filled
    if($Param{New}->{TicketMustHave} && !$Ticket{$Param{New}->{TicketMustHave}}){
        return 1;
    }

    $Param{Data}->{Ticket} = \%Ticket;
    $Param{Data}->{TicketID} = $Param{TicketID};

    my @ArticleBox;
    my $ArticleBackendObject;
    my $ArticleObject = $Kernel::OM->Get('Kernel::System::Ticket::Article');

    # get all articles of this ticket
    my @ArticleList = $ArticleObject->ArticleList(
        TicketID             => $Param{TicketID},
        IsVisibleForCustomer => 0,
        DynamicFields        => 0,
        OnlyLast             => 1,
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

        # Get channel specific fields
        my %ArticleFields = $LayoutObject->ArticleFields(
            TicketID  => $Param{TicketID},
            ArticleID => $ArticleMetaData->{ArticleID},
        );

        $ArticleData{Subject}      = $ArticleFields{Subject};
        $ArticleData{FromRealname} = $ArticleFields{Sender};

        push @ArticleBox, \%ArticleData;
    }

    # Verifies if it has ArticleType Filter
    if($Param{New}->{ArticleTypeFilter} && !$ArticleBox[0]->{ArticleType}){
        return 1;
    } elsif ($Param{New}->{ArticleTypeFilter} && !grep /^$ArticleBox[0]->{ArticleType}$/,split(/\|/,$Param{New}->{ArticleTypeFilter})) {
        return 1;
    }

    if($Param{New}->{IncludeLastArticle}){
        $Param{Data}->{Article} = $ArticleBox[0];
    }

    my $WebService = $Kernel::OM->Get('Kernel::System::GenericInterface::Webservice')->WebserviceGet(
        Name => $Param{New}->{WebServiceName},
    );

    $Kernel::OM->Get('Kernel::GenericInterface::Requester')->Run(
        WebserviceID => $WebService->{ID},
        Invoker      => $Param{New}->{Invoker},
        Data         => $Param{Data}
    );
}

1;