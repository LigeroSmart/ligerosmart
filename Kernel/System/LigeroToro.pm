package Kernel::System::LigeroToro;

use strict;
use warnings;
use utf8;

use base qw(Kernel::System::EventHandler);

our @ObjectDependencies = (
    'Kernel::System::CustomerUser',
    'Kernel::Output::HTML::Layout',
    'Kernel::System::Ticket::Article',
    'Kernel::System::Ticket',
    'Kernel::System::Log',
    'Kernel::System::Main',
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );
    return $Self;
}

sub GenerateCustomerUserReport {
    my ( $Self, %Param ) = @_;

    my $CustomerUserObject  = $Kernel::OM->Get('Kernel::System::CustomerUser');
    my $LayoutObject        = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $ArticleObject       = $Kernel::OM->Get('Kernel::System::Ticket::Article');
    my $TicketObject        = $Kernel::OM->Get('Kernel::System::Ticket');

    my %User = $CustomerUserObject->CustomerUserDataGet (
      User => $Param{CustomerUserID}
    );

    $LayoutObject->Block(
      Name => "UserDataTemplate",
      Data => {
        UserDataTemplate => $LayoutObject->Output(
            Template => $Param{UserDataTemplate},
            Data         => {
              UserData => \%User
            },
        )
      }
    );

    $LayoutObject->Block(
      Name => "CompanyDataTemplate",
      Data => {
        CompanyDataTemplate => $LayoutObject->Output(
            Template => $Param{CompanyDataTemplate},
            Data         => {
              UserData => \%User
            },
        )
      }
    );


    $LayoutObject->Block(
      Name => "TicketTableHeaderTemplate",
      Data => {
        TicketTableHeaderTemplate => $LayoutObject->Output(
            Template => $Param{TicketTableHeaderTemplate},
        )
      }
    );

    

    my @TicketList = $TicketObject->TicketSearch(
        Result      =>  'ARRAY',
        CustomerUserLogin => $Param{CustomerUserID},
        UserID => 1
    );

    foreach my $key (@TicketList) {

      my %TicketContent = $TicketObject->TicketGet(
          TicketID      => $key,
          DynamicFields => 1,
          Extended      => 1,
          UserID        => 1,
      );

      $LayoutObject->Block(
        Name => "TicketRow",
        Data => {
          TicketTableContentTemplate => $LayoutObject->Output(
              Template => $Param{TicketTableContentTemplate},
              Data => \%TicketContent
          )
        }
      );

    }

    my $HtmlContent = $LayoutObject->Output(
        TemplateFile => 'CustomerDataExport',
    );
    
    return $HtmlContent;
}

sub DESTROY {
    my $Self = shift;

    # execute all transaction events
    $Self->EventHandlerTransaction();

    return 1;
}

1;