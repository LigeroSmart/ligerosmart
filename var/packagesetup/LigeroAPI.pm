# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package var::packagesetup::LigeroAPI;

use strict;
use warnings;

use Kernel::Output::Template::Provider;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::DB',
    'Kernel::System::DynamicField',
    'Kernel::System::Log',
    'Kernel::System::State',
    'Kernel::System::Stats',
    'Kernel::System::SysConfig',
    'Kernel::System::Type',
    'Kernel::System::Valid',
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}


sub CodeInstall {
    my ( $Self, %Param ) = @_;

    #$Self->_CreateDynamicFields();
	#$Self->_UpdateConfig();
    $Self-> _CreateWebServices();
    return 1;
}

sub CodeUpgrade {
    my ( $Self, %Param ) = @_;

    #$Self->_CreateDynamicFields();
    $Self->_CreateWebServices();
    #$Self->_UpdateConfig();
	
    return 1;
}

sub _UpdateConfig {
    my ( $Self, %Param ) = @_;

    my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');
#    my @Configs = (
#        {
#            ConfigItem => 'CustomerFrontend::CommonParam###Action',
#            Value 	   => 'CustomerServiceCatalog'
#        },
#    );

#    CONFIGITEM:
#    for my $Config (@Configs) {
#        # set new setting,
#        my $Success = $SysConfigObject->ConfigItemUpdate(
#            Valid => 1,
#            Key   => $Config->{ConfigItem},
#            Value => $Config->{Value},
#        );

#    }

    return 1;
}

sub _CreateWebServices {
    my ( $Self, %Param ) = @_;

    

    # if doesn't exists
    my $YAML = <<"_END_";
---
Debugger:
  DebugThreshold: debug
  TestMode: '0'
Description: ''
FrameworkVersion: 6.0.12
Provider:
  Operation:
    Login:
      Description: ''
      IncludeTicketData: '0'
      Type: SessionLigero::SessionCreate
    QueueList:
      Description: ''
      IncludeTicketData: '0'
      Type: TicketLigero::QueueSearch
    TicketCreate:
      Description: ''
      IncludeTicketData: '0'
      Type: Ticket::TicketCreate
    TicketList:
      Description: ''
      IncludeTicketData: '0'
      Type: TicketLigero::TicketSearch
    TicketUpdate:
      Description: ''
      IncludeTicketData: '0'
      Type: Ticket::TicketUpdate
    LinkObject:
      Description: ''
      IncludeTicketData: '0'
      Type: MiscLigero::LinkObject
    TypeList:
      Description: ''
      IncludeTicketData: '0'
      Type: TicketLigero::TypeSearch
    StateList:
      Description: ''
      IncludeTicketData: '0'
      Type: TicketLigero::StateSearch
    SurveyList:
      Description: ''
      IncludeTicketData: '0'
      Type: MiscLigero::SurveySearch
    SurveyVote:
      Description: ''
      IncludeTicketData: '0'
      Type: MiscLigero::SurveyVote
    Generic:
      Description: ''
      IncludeTicketData: '0'
      Type: Admin::Generic
  Transport:
    Config:
      AdditionalHeaders: ~
      KeepAlive: ''
      MaxLength: '9999999999'
      RouteOperationMapping:
        Login:
          Route: /Login
        QueueList:
          Route: /QueueList
        TicketCreate:
          Route: /TicketCreate
        TicketList:
          Route: /TicketList
        TicketUpdate:
          Route: /TicketUpdate
        LinkObject:
          Route: /LinkObject
        TypeList:
          Route: /TypeList
        StateList:
          Route: /StateList
        SurveyList:
          Route: /SurveyList
        SurveyVote:
          Route: /SurveyVote
        Generic:
          Route: /Generic
    Type: HTTP::REST
RemoteSystem: ''
Requester:
  Transport:
    Type: ''
_END_

    my $Config = $Kernel::OM->Get('Kernel::System::YAML')->Load( Data => $YAML );

    #Verify if it already exists
    my $List             = $Kernel::OM->Get('Kernel::System::GenericInterface::Webservice')->WebserviceList();
    my %WebServiceLookup = reverse %{$List};
    my $Name = 'ligero';
    if ( $WebServiceLookup{$Name} ) {
        my $Success = $Kernel::OM->Get('Kernel::System::GenericInterface::Webservice')->WebserviceUpdate(
          ID      => $WebServiceLookup{$Name},
          Name    => $Name,
          Config  => $Config,
          ValidID => 1,
          UserID  => 1,
      );
    } else {
      # add new web service
      my $ID = $Kernel::OM->Get('Kernel::System::GenericInterface::Webservice')->WebserviceAdd(
          Name    => 'ligero',
          Config  => $Config,
          ValidID => 1,
          UserID  => 1,
      );
    }

    

    return 1;   
}
