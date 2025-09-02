# --
# Copyright (C) 2011 - 2017 Complemento - Liberdade e Tecnologia http://www.complemento.net.br
# --
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::FilterElementPost::MultiCustomerCompanyInfo;

use strict;
use warnings;
use Data::Dumper;
#----------------------------------------
our @ObjectDependencies = (
    'Kernel::System::Log',
    'Kernel::Config',
    'Kernel::System::Ticket',
    'Kernel::System::Main',
    'Kernel::Output::HTML::Layout',
    'Kernel::System::CustomerCompany',
);


sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );
    my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');
    $Self->{UserID} = $ParamObject->GetParam( Param => 'UserID' ) ;

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;
    # get template name
    my $Templatename = $Param{TemplateFile} || '';
    return 1 if !$Templatename;
    # get param object
    my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    if($Templatename eq 'AgentTicketZoom'){
        my $TicketID = $ParamObject->GetParam(Param => 'TicketID');

        my %Ticket = $TicketObject->TicketGet(
            TicketID => $TicketID
        );

        $Kernel::OM->Get('Kernel::Output::HTML::Layout')->Block(
            Name => 'AgentTicketZoom',
            Data => {
            },
        );
        $Kernel::OM->Get('Kernel::Output::HTML::Layout')->Block(
            Name => 'AgentTicketZoomCustomerInfo',
            Data => {
                CustomerID => $Ticket{CustomerID},
                CustomerUserID => $Ticket{CustomerUserID},
            },
        );
        $Kernel::OM->Get('Kernel::Output::HTML::Layout')->Block(
            Name => 'AgentTicketZoomCustomerInfoPre',
            Data => {
            },
        );
    }

    $Kernel::OM->Get('Kernel::Output::HTML::Layout')->Block(
        Name => 'Title',
        Data => {
            'Title' => $Kernel::OM->Get('Kernel::Config')->Get('MultiCustomerCompany::CompanyWidget::Title')
        },
    );    

    my  $Snippet = $Kernel::OM->Get('Kernel::Output::HTML::Layout')->Output(
        TemplateFile => 'ShowMultiCustomerCompanyInfo',
        Data         => {

        },
    ); 
    
    ${ $Param{Data} } =~ s{(<div \s+ class="SidebarColumn">)}{$1 $Snippet}xsm;

}

1;