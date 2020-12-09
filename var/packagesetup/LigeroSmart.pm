# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package var::packagesetup::LigeroSmart;

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

    # Try to remove log file
    unlink '/opt/otrs/var/tmp/ligerosearch.log';
	
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

sub _CreateDynamicFields {
    my ( $Self, %Param ) = @_;

    my $ValidID = $Kernel::OM->Get('Kernel::System::Valid')->ValidLookup(
        Valid => 'valid',
    );

    # get all current dynamic fields
    my $DynamicFieldList = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldListGet(
        Valid => 0,
    );

    # get the list of order numbers (is already sorted).
    my @DynamicfieldOrderList;
    for my $Dynamicfield ( @{$DynamicFieldList} ) {
        push @DynamicfieldOrderList, $Dynamicfield->{FieldOrder};
    }

    # get the last element from the order list and add 1
    my $NextOrderNumber = 1;
    if (@DynamicfieldOrderList) {
        $NextOrderNumber = $DynamicfieldOrderList[-1] + 1;
    }

    # get the definition for all dynamic fields for ITSM
    my @DynamicFields = $Self->_GetITSMDynamicFieldsDefinition();

    # create a dynamic fields lookup table
    my %DynamicFieldLookup;
    DYNAMICFIELD:
    for my $DynamicField ( @{$DynamicFieldList} ) {
        next DYNAMICFIELD if ref $DynamicField ne 'HASH';
        $DynamicFieldLookup{ $DynamicField->{Name} } = $DynamicField;
    }

    # create or update dynamic fields
    DYNAMICFIELD:
    for my $DynamicField (@DynamicFields) {

        my $CreateDynamicField;

        if ( ref $DynamicFieldLookup{ $DynamicField->{Name} } eq 'HASH' ) {
            # Deletes DF
            my $DynamicFieldID = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldGet(
                                       Name => $DynamicField->{Name},
                                    );
            if ($DynamicFieldID->{ID}){
                  my $Success = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldDelete(
                   ID      => $DynamicFieldID->{ID},
                   UserID  => 1,
                   Reorder => 1,               # or 0, to trigger reorder function, default 1
               );
            }
        }

        # check if new field has to be created
#        if ($CreateDynamicField) {


            # create a new field
            my $FieldID = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldAdd(
                InternalField => 1,
                Name          => $DynamicField->{Name},
                Label         => $DynamicField->{Label},
                FieldOrder    => $NextOrderNumber,
                FieldType     => $DynamicField->{FieldType},
                ObjectType    => $DynamicField->{ObjectType},
                Config        => $DynamicField->{Config},
                ValidID       => $ValidID,
                UserID        => 1,
            );
            next DYNAMICFIELD if !$FieldID;

            # increase the order number
            $NextOrderNumber++;
#        }
    }

    return 1;
}

sub _GetITSMDynamicFieldsDefinition {
    my ( $Self, %Param ) = @_;

    # define all dynamic fields for ITSM
    my @DynamicFields = (
        #{
            #Name       => 'LigeroIndexUpdate',
            #Label      => 'LigeroIndexUpdate',
            #FieldType  => 'Text',
            #ObjectType => 'Ticket',
            #Config     => {
                #DefaultValue   => '',
            #},
        #},
    );

    return @DynamicFields;
}

sub _CreateWebServices {
    my ( $Self, %Param ) = @_;

    #Verify if it already exists
    my $List             = $Kernel::OM->Get('Kernel::System::GenericInterface::Webservice')->WebserviceList();
    my %WebServiceLookup = reverse %{$List};
    my $Name = 'LigeroSmart';
    if ( $WebServiceLookup{$Name} ) {
        return 1;
    }

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
      Host: http://elasticsearch:9200
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
    my $ID = $Kernel::OM->Get('Kernel::System::GenericInterface::Webservice')->WebserviceAdd(
        Name    => 'LigeroSmart',
        Config  => $Config,
        ValidID => 1,
        UserID  => 1,
    );

    return 1;   
}
