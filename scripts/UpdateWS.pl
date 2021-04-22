#!/usr/bin/perl

use strict;
use warnings;

# use ../../ as lib location
use FindBin qw($Bin);
use lib "/opt/otrs";
use lib "/opt/otrs/Kernel/cpan-lib";
use lib "/opt/otrs/Custom";

use Kernel::System::ObjectManager;

local $Kernel::OM = Kernel::System::ObjectManager->new(
	'Kernel::System::Log' => {
		LogPrefix => 'LIGERO-DOCKER-SETUP',
	},
);

my $node = $ARGV[0] || 'localhost';
my $customer = $ARGV[1] || 'companyname';

my %CommonObject;

$CommonObject{ConfigObject}          = $Kernel::OM->Get('Kernel::Config');
$CommonObject{CustomerCompanyObject} = $Kernel::OM->Get('Kernel::System::CustomerCompany');
$CommonObject{CustomerUserObject}    = $Kernel::OM->Get('Kernel::System::CustomerUser');
$CommonObject{EncodeObject}          = $Kernel::OM->Get('Kernel::System::Encode');
$CommonObject{GroupObject}           = $Kernel::OM->Get('Kernel::System::Group');
$CommonObject{LinkObject}            = $Kernel::OM->Get('Kernel::System::LinkObject');
$CommonObject{LogObject}             = $Kernel::OM->Get('Kernel::System::Log');
$CommonObject{MainObject}            = $Kernel::OM->Get('Kernel::System::Main');
$CommonObject{PIDObject}             = $Kernel::OM->Get('Kernel::System::PID');
$CommonObject{QueueObject}           = $Kernel::OM->Get('Kernel::System::Queue');
$CommonObject{SessionObject}         = $Kernel::OM->Get('Kernel::System::AuthSession');
$CommonObject{TicketObject}          = $Kernel::OM->Get('Kernel::System::Ticket');
$CommonObject{TimeObject}            = $Kernel::OM->Get('Kernel::System::Time');
$CommonObject{UserObject}            = $Kernel::OM->Get('Kernel::System::User');

_UpdateWS();

sub _UpdateWS {
    my ( $Self, %Param ) = @_;

    # if doesn't exists
    my $YAML = <<"_END_";
---
Debugger:
  DebugThreshold: error
  TestMode: '0'
Description: ''
FrameworkVersion: 6.0.18
Provider:
  Operation:
    Search:
      Description: ''
      IncludeTicketData: '0'
      MappingInbound:
        Config:
          DataInclude: []
          PostRegExFilter: ~
          PostRegExValueCounter: ~
          PreRegExFilter: ~
          PreRegExValueCounter: ~
          Template: "<xsl:stylesheet version=\\"1.0\\"\\r\\n                xmlns:xsl=\\"http://www.w3.org/1999/XSL/Transform\\">\\r\\n
            \\   <xsl:output omit-xml-declaration=\\"yes\\" indent=\\"yes\\"/>\\r\\n    <xsl:template
            match=\\"RootElement\\">\\r\\n        <xsl:copy>\\r\\n             <xsl:apply-templates
            select=\\"//SessionID\\"/>\\r\\n             <xsl:apply-templates select=\\"//UserLogin\\"/>\\r\\n
            \\            <xsl:apply-templates select=\\"//Password\\"/>\\r\\n            <params>\\r\\n
            \\               <Query>\\r\\n                  <xsl:value-of select=\\"//Query\\"
            />\\r\\n                </Query>\\r\\n                <KBs>FAQ-Misc</KBs>\\r\\n
            \\               <KBs>FAQ-IT Service</KBs>\\r\\n                <KBs>MicrosoftSupport</KBs>\\r\\n
            \\               <xsl:apply-templates select=\\"//Language\\"/>\\r\\n            </params>\\r\\n
            \\           <source>\\r\\n                <size>1</size>\\r\\n                <from>0</from>\\r\\n
            \\               <_source>Title</_source>\\r\\n                <_source>Description</_source>\\r\\n
            \\               <_source>URL</_source>\\r\\n                <query>\\r\\n
            \\                   <bool>\\r\\n                        <must>\\r\\n                            <terms>\\r\\n
            \\                               <Object.raw>{{#KBs}}</Object.raw>\\r\\n
            \\                               <Object.raw>{{.}}</Object.raw>\\r\\n                                <Object.raw>{{/KBs}}</Object.raw>\\r\\n
            \\                           </terms>\\r\\n                        </must>\\r\\n
            \\                       <should>\\r\\n                            <prefix>\\r\\n
            \\                               <Title>\\r\\n                                    <value>{{Query}}</value>\\r\\n
            \\                                   <boost>20</boost>\\r\\n                                </Title>\\r\\n
            \\                           </prefix>\\r\\n                        </should>\\r\\n
            \\                       <should>\\r\\n                            <match>\\r\\n
            \\                               <Title>\\r\\n                                    <query>{{Query}}</query>\\r\\n
            \\                                   <boost>10</boost>\\r\\n                                </Title>\\r\\n
            \\                           </match>\\r\\n                        </should>\\r\\n
            \\                       <should>\\r\\n                            <match>\\r\\n
            \\                               <SearchBody>{{Query}}</SearchBody>\\r\\n
            \\                           </match>\\r\\n                        </should>\\r\\n
            \\                   </bool>\\r\\n                </query>\\r\\n            </source>\\r\\n
            \\       </xsl:copy>\\r\\n    </xsl:template>\\r\\n            <xsl:template
            match=\\"//SessionID\\">\\r\\n                <SessionID>\\r\\n                    <xsl:value-of
            select=\\"//SessionID\\" />\\r\\n                </SessionID>\\r\\n            </xsl:template>\\r\\n
            \\           <xsl:template match=\\"//UserLogin\\">\\r\\n                <UserLogin>\\r\\n
            \\                   <xsl:value-of select=\\"//UserLogin\\" />\\r\\n                </UserLogin>\\r\\n
            \\           </xsl:template>\\r\\n            <xsl:template match=\\"//Password\\">\\r\\n
            \\               <Password>\\r\\n                    <xsl:value-of select=\\"//Password\\"
            />\\r\\n                </Password>\\r\\n            </xsl:template>\\r\\n            <xsl:template
            match=\\"//Language\\">\\r\\n                <Language>\\r\\n                    <xsl:value-of
            select=\\"//Language\\" />\\r\\n                </Language>\\r\\n            </xsl:template>\\r\\n</xsl:stylesheet>"
        Type: XSLT
      Type: LigeroSmart::Search
  Transport:
    Config:
      AdditionalHeaders: ~
      KeepAlive: ''
      MaxLength: '9999999999'
      RouteOperationMapping:
        Search:
          Route: /Search
    Type: HTTP::REST
RemoteSystem: ''
Requester:
  Invoker:
    LigeroTicketIndexer:
      Description: ''
      Events:
      - Asynchronous: '1'
        Event: TicketServiceUpdate
      - Asynchronous: '1'
        Event: TicketTitleUpdate
      - Asynchronous: '1'
        Event: TicketQueueUpdate
      - Asynchronous: '1'
        Event: ArticleCreate
      MappingInbound:
        Type: Simple
      MappingOutbound:
        Type: Simple
      Type: LigeroSmart::LigeroSmartIndexer
  Transport:
    Config:
      DefaultCommand: PUT
      Host: http://$node:9200
      InvokerControllerMapping:
        LigeroTicketIndexer:
          Command: PUT
          Controller: /:Index/doc/:TicketID?pipeline=:pipeline
      Proxy:
        UseProxy: No
      SSL:
        UseSSL: No
      Timeout: '300'
    Type: HTTP::REST
_END_

    my $Config = $Kernel::OM->Get('Kernel::System::YAML')->Load( Data => $YAML );

    # add new web service
    my $ID = $Kernel::OM->Get('Kernel::System::GenericInterface::Webservice')->WebserviceUpdate(
		ID      => 1,
        Name    => 'LigeroTicketIndexer',
        Config  => $Config,
        ValidID => 1,
        UserID  => 1,
    );

    $Kernel::OM->Get('Kernel::System::SysConfig')->SettingsSet(
            UserID   => 1,                                      # (required) UserID
            Comments => 'LigeroServiceCatalog',                   # (optional) Comment
            Settings => [                                       # (required) List of settings to update.
                {
                    Name                   => 'LigeroSmart###Nodes',  # (required)
                    EffectiveValue         => [$node.':9200'],          # (optional)
                    IsValid                => 1,                # (optional)
                }
            ],
        );
    
    $Kernel::OM->Get('Kernel::System::SysConfig')->SettingsSet(
            UserID   => 1,                                      # (required) UserID
            Comments => 'LigeroServiceCatalog',                   # (optional) Comment
            Settings => [                                       # (required) List of settings to update.
                {
                    Name                   => 'LigeroSmart::Index',  # (required)
                    EffectiveValue         => $customer,          # (optional)
                    IsValid                => 1,                # (optional)
                }
            ],
        );

    return 1;   
}
	
1;
