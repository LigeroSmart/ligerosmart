package Kernel::Modules::AgentMultiCustomerCompany;
## nofilter(TidyAll::Plugin::OTRS::Perl::DBObject)

use strict;
use warnings;

use Data::Dumper;

use Kernel::Language qw(Translatable);

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $JSON = '';

    # get needed objects
    my $ParamObject        = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $EncodeObject       = $Kernel::OM->Get('Kernel::System::Encode');
    my $LayoutObject       = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $CustomerUserObject = $Kernel::OM->Get('Kernel::System::CustomerUser');
    my $ConfigObject       = $Kernel::OM->Get('Kernel::Config');
    my $TicketObject       = $Kernel::OM->Get('Kernel::System::Ticket');
    my $CustomerCompanyObject = $Kernel::OM->Get('Kernel::System::CustomerCompany');

    # get config for frontend
    $Self->{Config} = $ConfigObject->Get("Ticket::Frontend::$Self->{Action}");

    if ( $Self->{Subaction} eq 'CompanyInfo' ) {

        # get params
        my $CustomerID              = $ParamObject->GetParam( Param => 'CustomerID' );
        my $CustomerUserID          = $ParamObject->GetParam( Param => 'CustomerUserID' );
        
        my $CustomerTableHTMLString = '';

        # Pega informações do usuário e as configurações gerais dos backends de cliente
        my %CustomerData = $CustomerUserObject->CustomerUserDataGet(
            User => $CustomerUserID,
        );

        # Pega campos que precisam ser blocados
        my @Fields = @{$ConfigObject->Get('MultiCustomerCompany::CompanyWidget::Fields')};

        
        # Informações que interessam da empresa ##########################################
        my @newCompanyMap;
        my @CompanyMap = @{$CustomerData{CompanyConfig}->{Map}};
        for my $Field (@CompanyMap){
            if (grep /^$Field->[0]$/, @Fields) {
                $Field->[3] = 1;
                push @newCompanyMap, $Field;
            }
        }        
        delete $CustomerData{CompanyConfig}->{Map};
        $CustomerData{CompanyConfig}->{Map} = \@newCompanyMap || ();


        # Informações que interessam do usuário ##########################################
        my @newMap;
        my @Map = @{$CustomerData{Config}->{Map}};
        for my $Field (@Map){
            if (grep /^$Field->[0]$/, @Fields) {
                $Field->[3] = 1;
                push @newMap, $Field;
            }
            
        }        
        delete $CustomerData{Config}->{Map};
        $CustomerData{Config}->{Map} = \@newMap || ();

        # Pega informações da empresa selecionada, para sobrescrevermos a empresa padrão
        my %CustomerCompany = $CustomerCompanyObject->CustomerCompanyGet(
               CustomerID => $CustomerID,
        );

        # Desabilita temporariamente os módulos frontend
        my $ConfigRef = $ConfigObject->Get("Frontend::CustomerUser::Item");
        $ConfigObject->Set(
            Key   => "Frontend::CustomerUser::Item",
            Value => {}
        );
    
        my $CustomerTable = $LayoutObject->AgentCustomerViewTable(
            Data   => {
                %CustomerData,
                %CustomerCompany,
            },
        );

        $ConfigObject->Set(
            Key   => "Frontend::CustomerUser::Item",
            Value => $ConfigRef
        );
                
        $CustomerTableHTMLString=$CustomerTable;

        # build JSON output
        $JSON = $LayoutObject->JSONEncode(
            Data => {
                CustomerTableHTMLString => $CustomerTableHTMLString,
            },
        );
    }

    # send JSON response
    return $LayoutObject->Attachment(
        ContentType => 'application/json; charset=' . $LayoutObject->{Charset},
        Content     => $JSON || '',
        Type        => 'inline',
        NoCache     => 1,
    );

}

1;