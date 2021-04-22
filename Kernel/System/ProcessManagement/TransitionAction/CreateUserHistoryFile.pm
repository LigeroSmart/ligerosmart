package Kernel::System::ProcessManagement::TransitionAction::CreateUserHistoryFile;

use strict;
use warnings;
use utf8;
use Safe;

use Kernel::System::VariableCheck qw(:all);

use parent qw(Kernel::System::ProcessManagement::TransitionAction::Base);

our @ObjectDependencies = (
  'Kernel::System::DynamicField',
  'Kernel::System::DynamicField::Backend',
  'Kernel::System::Log',
  'Kernel::Output::HTML::Layout',
  'Kernel::System::LigeroToro',
  'Kernel::System::Ticket::Article'
);

sub new {
  my ( $Type, %Param ) = @_;

  my $Self = {};
  bless( $Self, $Type );

  return $Self;
}

sub Run {
  my ( $Self, %Param ) = @_;

  my $LigeroToroObject  = $Kernel::OM->Get('Kernel::System::LigeroToro');
  my $ArticleObject       = $Kernel::OM->Get('Kernel::System::Ticket::Article');
  my $ArticleBackendObject= $ArticleObject->BackendForChannel(ChannelName => 'Phone');

  if($Param{Ticket}->{CustomerUserID}){
    

    my $HtmlContent = $LigeroToroObject->GenerateCustomerUserReport(
        CustomerUserID => $Param{Ticket}->{CustomerUserID},
        UserDataTemplate => $Param{Config}->{UserDataTemplate},
        CompanyDataTemplate => $Param{Config}->{CompanyDataTemplate},
        TicketTableHeaderTemplate => $Param{Config}->{TicketTableHeaderTemplate},
        TicketTableContentTemplate => $Param{Config}->{TicketTableContentTemplate},
    );

    my $ArticleID = $ArticleBackendObject->ArticleCreate(
      TicketID  =>  $Param{Ticket}->{TicketID},
      SenderType => 'agent',
      IsVisibleForCustomer => $Param{Config}->{ShowUser},
      UserID => 1,
      Subject => $Param{Config}->{ArticleTitle},
      Body => $Param{Config}->{ArticleContent},
      HistoryType => 'OwnerUpdate',
      HistoryComment => 'Some free text!',
      ContentType    => 'text/html; charset=utf8',
      Attachment => [
        {
          Content => $HtmlContent,
          ContentType => 'text/html; charset=utf8',
          Charset => 'utf8',
          Filename => 'userdata.html'
        }
      ]
    );
    
  }

  return 1;
}

1;