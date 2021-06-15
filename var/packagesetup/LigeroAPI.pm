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
  DebugThreshold: error
  TestMode: '0'
Description: ''
FrameworkVersion: 6.1.7
Provider:
  Operation:
    Admin::Generic:
      Description: ''
      IncludeTicketData: '0'
      Type: Admin::Generic
    ConfigItem::ConfigItemCreate:
      Description: ''
      IncludeTicketData: '0'
      Type: ConfigItem::ConfigItemCreate
    ConfigItem::ConfigItemDelete:
      Description: ''
      IncludeTicketData: '0'
      Type: ConfigItem::ConfigItemDelete
    ConfigItem::ConfigItemGet:
      Description: ''
      IncludeTicketData: '0'
      Type: ConfigItem::ConfigItemGet
    ConfigItem::ConfigItemSearch:
      Description: ''
      IncludeTicketData: '0'
      Type: ConfigItem::ConfigItemSearch
    ConfigItem::ConfigItemUpdate:
      Description: ''
      IncludeTicketData: '0'
      Type: ConfigItem::ConfigItemUpdate
    FAQ::LanguageList:
      Description: ''
      IncludeTicketData: '0'
      Type: FAQ::LanguageList
    FAQ::PublicCategoryList:
      Description: ''
      IncludeTicketData: '0'
      Type: FAQ::PublicCategoryList
    FAQ::PublicFAQGet:
      Description: ''
      IncludeTicketData: '0'
      Type: FAQ::PublicFAQGet
    FAQ::PublicFAQSearch:
      Description: ''
      IncludeTicketData: '0'
      Type: FAQ::PublicFAQSearch
    GeneralCatalogLigero::GeneralCatalogGetValues:
      Description: ''
      IncludeTicketData: '0'
      Type: GeneralCatalogLigero::GeneralCatalogGetValues
    Ligero::LigeroEasyConnector:
      Description: ''
      IncludeTicketData: '0'
      Type: Ligero::LigeroEasyConnector
    LigeroSmart::Search:
      Description: ''
      IncludeTicketData: '0'
      Type: LigeroSmart::Search
    MiscLigero::LinkObject:
      Description: ''
      IncludeTicketData: '0'
      Type: MiscLigero::LinkObject
    MiscLigero::SurveySearch:
      Description: ''
      IncludeTicketData: '0'
      Type: MiscLigero::SurveySearch
    MiscLigero::SurveyVote:
      Description: ''
      IncludeTicketData: '0'
      Type: MiscLigero::SurveyVote
    Session::SessionGet:
      Description: ''
      IncludeTicketData: '0'
      Type: Session::SessionGet
    SessionLigero::SessionCreate:
      Description: ''
      IncludeTicketData: '0'
      Type: SessionLigero::SessionCreate
    Ticket::TicketCreate:
      Description: ''
      IncludeTicketData: '0'
      Type: Ticket::TicketCreate
    Ticket::TicketGet:
      Description: ''
      IncludeTicketData: '0'
      Type: Ticket::TicketGet
    Ticket::TicketHistoryGet:
      Description: ''
      IncludeTicketData: '0'
      Type: Ticket::TicketHistoryGet
    Ticket::TicketSearch:
      Description: ''
      IncludeTicketData: '0'
      Type: Ticket::TicketSearch
    Ticket::TicketUpdate:
      Description: ''
      IncludeTicketData: '0'
      Type: Ticket::TicketUpdate
    TicketLigero::ArticleAttachmentGet:
      Description: ''
      IncludeTicketData: '0'
      Type: TicketLigero::ArticleAttachmentGet
    TicketLigero::PrioritySearch:
      Description: ''
      IncludeTicketData: '0'
      Type: TicketLigero::PrioritySearch
    TicketLigero::QueueSearch:
      Description: ''
      IncludeTicketData: '0'
      Type: TicketLigero::QueueSearch
    TicketLigero::StateSearch:
      Description: ''
      IncludeTicketData: '0'
      Type: TicketLigero::StateSearch
    TicketLigero::TicketSearch:
      Description: ''
      IncludeTicketData: '0'
      Type: TicketLigero::TicketSearch
    TicketLigero::TypeSearch:
      Description: ''
      IncludeTicketData: '0'
      Type: TicketLigero::TypeSearch
  Transport:
    Config:
      AdditionalHeaders: ~
      KeepAlive: ''
      MaxLength: '9999999999'
      RouteOperationMapping:
        Admin::Generic:
          Route: /admin
        ConfigItem::ConfigItemCreate:
          Route: /cmdb/create
        ConfigItem::ConfigItemDelete:
          Route: /cmdb/delete
        ConfigItem::ConfigItemGet:
          Route: /cmdb/get
        ConfigItem::ConfigItemSearch:
          Route: /cmdb/search
        ConfigItem::ConfigItemUpdate:
          Route: /cmdb/update
        FAQ::LanguageList:
          Route: /faq/languages
        FAQ::PublicCategoryList:
          Route: /faq/categories
        FAQ::PublicFAQGet:
          Route: /faq/get
        FAQ::PublicFAQSearch:
          Route: /faq/search
        GeneralCatalogLigero::GeneralCatalogGetValues:
          Route: /generalcatalog/get
        Ligero::LigeroEasyConnector:
          Route: /ticket/createorupdate
        LigeroSmart::Search:
          Route: /kb/search
        MiscLigero::LinkObject:
          Route: /objects/link
        MiscLigero::SurveySearch:
          Route: /survey/search
        MiscLigero::SurveyVote:
          Route: /survey/vote
        Session::SessionGet:
          Route: /session/get
        SessionLigero::SessionCreate:
          Route: /session/create
        Ticket::TicketCreate:
          Route: /ticket/create
        Ticket::TicketGet:
          Route: /ticket/get
        Ticket::TicketHistoryGet:
          Route: /ticket/history/get
        Ticket::TicketSearch:
          Route: /ticket/search
        Ticket::TicketUpdate:
          Route: /ticket/update
        TicketLigero::ArticleAttachmentGet:
          Route: /ticket/attachment/get
        TicketLigero::PrioritySearch:
          Route: /priority/search
        TicketLigero::QueueSearch:
          Route: /queue/search
        TicketLigero::StateSearch:
          Route: /state/search
        TicketLigero::TicketSearch:
          Route: /ticket/search/fullcontent
        TicketLigero::TypeSearch:
          Route: /type/search
    Type: LigeroEasyConnector::REST
RemoteSystem: ''
Requester:
  Transport:
    Type: ''
_END_

    my $Config = $Kernel::OM->Get('Kernel::System::YAML')->Load( Data => $YAML );

    #Verify if it already exists
    my $List             = $Kernel::OM->Get('Kernel::System::GenericInterface::Webservice')->WebserviceList();
    my %WebServiceLookup = reverse %{$List};
    my $Name = 'v1.0';
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
          Name    => $Name,
          Config  => $Config,
          ValidID => 1,
          UserID  => 1,
      );
    }

    

    return 1;   
}
