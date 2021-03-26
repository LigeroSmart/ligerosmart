# --
# Copyright (C) 2001-2018 Complemento - Liberdade e Tecnologia http://www.complemento.net.br
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Console::Command::Maint::Ocs::OcsIntegration;

use strict;
use warnings;

use Time::HiRes();
use URI::Escape qw(uri_escape_utf8);
use Data::Dumper;
use base qw(Kernel::System::Console::BaseCommand);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Service',
    'Kernel::System::WebUserAgent',
    'Kernel::System::JSON',
    'Kernel::System::ITSMConfigItem',
    'Kernel::System::GeneralCatalog',
    'Kernel::System::OcsIntegrationSnmp',
    'Kernel::System::OcsIntegrationComputer' 
);

sub Configure {
    my ( $Self, %Param ) = @_;
    
    $Self->Description('Automatic import of OCS system data to the OTRS system.');
        
    $Self->AddOption(
        Name        => 'MicroSleep',
        Description => "Specify microseconds to sleep after every ticket to reduce system load (e.g. 1000).",
        Required    => 0,
        HasValue    => 1,
        ValueRegex  => qr/^\d+$/smx,
    );

    $Self->AddOption(
        Name        => 'ServerAddress',
        Description => "OCS Server Address.",
        Required    => 0,
        HasValue    => 1,
	    ValueRegex  => qr/.*/smx,
    );

    $Self->AddOption(
        Name        => 'PaginationSize',
        Description => "Pagination Size.",
        Required    => 0,
        HasValue    => 1,
        ValueRegex  => qr/.*/smx,
    );

    $Self->AddOption(
        Name        => 'User',
        Description => "User.",
        Required    => 0,
        HasValue    => 1,
        ValueRegex  => qr/.*/smx,
    );

    $Self->AddOption(
        Name        => 'Pass',
        Description => "Password.",
        Required    => 0,
        HasValue    => 1,
        ValueRegex  => qr/.*/smx,
    );

    return;
}

sub Run {
    my ( $Self, %Param ) = @_;
    
    my $JSONObject = $Kernel::OM->Get('Kernel::System::JSON');
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    my $ServerAddress = $Self->GetOption('ServerAddress');
    if (!$ServerAddress){
		$ServerAddress = $ConfigObject->Get('OcsIntegration::ServerAddress');
	}

    my $DoubleJsonDecode = $ConfigObject->Get('OcsIntegration::DoubleJsonDecode')||'0';

    #$Self->Print("<yellow>ServerAddress ".$ServerAddress."</yellow>\n");

    my $PaginationSize = $Self->GetOption('PaginationSize');
    if (!$PaginationSize){
		$PaginationSize = $ConfigObject->Get('OcsIntegration::PaginationSize');
	}

    #$Self->Print("<yellow>PaginationSize ".$PaginationSize."</yellow>\n");

    my $MicroSleep = $Self->GetOption('MicroSleep');
    if (!$MicroSleep){
		$MicroSleep = $ConfigObject->Get('OcsIntegration::MicroSleep');
	}

    #$Self->Print("<yellow>MicroSleep ".$MicroSleep."</yellow>\n");

    my $User = $Self->GetOption('User')||"";
    if (!$User && $ConfigObject->Get('OcsIntegration::Authentication')){
		$User = $ConfigObject->Get('OcsIntegration::Authentication')->{User};
	}

    #$Self->Print("<yellow>User ".$User."</yellow>\n");

    my $Pass = $Self->GetOption('Pass')||"";
    if (!$Pass && $ConfigObject->Get('OcsIntegration::Authentication')){
		$Pass = $ConfigObject->Get('OcsIntegration::Authentication')->{Password};
	}

    #$Self->Print("<yellow>Pass ".$Pass."</yellow>\n");

    my $OcsIntegrationSnmpObject = $Kernel::OM->Get("Kernel::System::OcsIntegrationSnmp");
    my $OcsIntegrationComputerObject = $Kernel::OM->Get("Kernel::System::OcsIntegrationComputer");
    my $GeneralCatalogObject = $Kernel::OM->Get('Kernel::System::GeneralCatalog');
    my $ConfigItemObject = $Kernel::OM->Get('Kernel::System::ITSMConfigItem');

    my $DeplStateID = $GeneralCatalogObject->ItemGet(
       Class => 'ITSM::ConfigItem::DeploymentState',
       Name  => 'Production',
    );

    my $InciStateID = $GeneralCatalogObject->ItemGet(
       Class => 'ITSM::Core::IncidentState',
       Name  => 'Operational',
    );

    my $start = 0;

    #Generate Class for all Structure SNMP

    #GetAllClasses
    my $snmpClasses = $OcsIntegrationSnmpObject->SnmpTypeToOtrsClassList();
    my %ClassesIDs;

    for(my $i = 0; $i < (scalar @$snmpClasses); $i++){
        my $snmpClassToWork = $snmpClasses->[$i];

        my $parentNodes = $OcsIntegrationSnmpObject->SnmpMappingActiveList(
            SnmpClassTypeId => $snmpClassToWork->{ID}
        );

        my $XmlStructure = [];

        for(my $u = 0; $u < (scalar @$parentNodes); $u++){
            push @{ $XmlStructure },GenerateClassStructureSNMPNode($parentNodes->[$u]);
        }

        my $ClassObj = $GeneralCatalogObject->ItemGet(
            Class => 'ITSM::ConfigItem::Class',
            Name  => $snmpClassToWork->{OtrsClass},
        );

        if(!$ClassObj){
            $GeneralCatalogObject->ItemAdd(
                Class => 'ITSM::ConfigItem::Class',
                Name  => $snmpClassToWork->{OtrsClass},
                ValidID => 1,
                UserID => 1,
            );

            $ClassObj = $GeneralCatalogObject->ItemGet(
                Class => 'ITSM::ConfigItem::Class',
                Name  => $snmpClassToWork->{OtrsClass},
            );
        }

        local $Data::Dumper::Terse = 30;
        my $strs = Dumper($XmlStructure);

        my $YAMLObject = $Kernel::OM->Get('Kernel::System::YAML');
        my $YAMLStr = $YAMLObject->Dump(
            Data => $XmlStructure,
        );

        my $LastDefinition = $ConfigItemObject->DefinitionGet(
            ClassID => $ClassObj->{ItemID},
        );

        # stop add, if definition was not changed
        if ( !$LastDefinition->{DefinitionID} || $LastDefinition->{Definition} ne $YAMLStr ) {
            $ConfigItemObject->DefinitionAdd(
                ClassID    => $ClassObj->{ItemID},
                Definition => $YAMLStr,
                UserID     => 1,
            );
        }
        

        my $DefinitionID = $ConfigItemObject->DefinitionGet(
            ClassID => $ClassObj->{ItemID},
        )->{DefinitionID};

        $ClassesIDs{$snmpClassToWork->{OcsType}} = {
            DefinitionID => $DefinitionID,
            ClassID => $ClassObj->{ItemID},
            DataKeyFields => $OcsIntegrationSnmpObject->SnmpMappingKeyFieldList(
                SnmpClassTypeId => $snmpClassToWork->{ID}
            ),
            OrFilters => $OcsIntegrationSnmpObject->SnmpFilterList(
                SnmpClassTypeId => $snmpClassToWork->{ID},
                Type => 'OR'
            ),
            AndFilters => $OcsIntegrationSnmpObject->SnmpFilterList(
                SnmpClassTypeId => $snmpClassToWork->{ID},
                Type => 'AND'
            ),
            Structure => $XmlStructure,
        };

        #$Self->Print("<yellow>DefinitionID ".$DefinitionID."</yellow>\n");
    }

    my $defaultClass = $ConfigObject->Get("OcsIntegration::SnmpDefaultClass")||"";

    my $parentNodes = $OcsIntegrationSnmpObject->SnmpMappingActiveList();

    my $XmlStructure = [];

    for(my $u = 0; $u < (scalar @$parentNodes); $u++){
        push @{ $XmlStructure },GenerateClassStructureSNMPNode($parentNodes->[$u]);
    }

    my $ClassObj = $GeneralCatalogObject->ItemGet(
        Class => 'ITSM::ConfigItem::Class',
        Name  => $defaultClass,
    );

    if(!$ClassObj){
        $GeneralCatalogObject->ItemAdd(
            Class => 'ITSM::ConfigItem::Class',
            Name  => $defaultClass,
            ValidID => 1,
            UserID => 1,
        );

        $ClassObj = $GeneralCatalogObject->ItemGet(
            Class => 'ITSM::ConfigItem::Class',
            Name  => $defaultClass,
        );
    }

    local $Data::Dumper::Terse = 30;
    my $strs = Dumper($XmlStructure);

    my $YAMLObject = $Kernel::OM->Get('Kernel::System::YAML');
    my $YAMLStr = $YAMLObject->Dump(
        Data => $XmlStructure,
    );

    my $LastDefinition = $ConfigItemObject->DefinitionGet(
        ClassID => $ClassObj->{ItemID},
    );

    # stop add, if definition was not changed
    if ( !$LastDefinition->{DefinitionID} || $LastDefinition->{Definition} ne $YAMLStr ) {
        $ConfigItemObject->DefinitionAdd(
            ClassID    => $ClassObj->{ItemID},
            Definition => $YAMLStr,
            UserID     => 1,
        );
    }

    my $DefinitionID = $ConfigItemObject->DefinitionGet(
        ClassID => $ClassObj->{ItemID},
    )->{DefinitionID};

    $ClassesIDs{$defaultClass} = {
        DefinitionID => $DefinitionID,
        ClassID => $ClassObj->{ItemID},
        DataKeyFields => $OcsIntegrationSnmpObject->SnmpMappingKeyFieldList(),
        Structure => $XmlStructure,
        OrFilters => $OcsIntegrationSnmpObject->SnmpFilterList(
            Type => 'OR'
        ),
        AndFilters => $OcsIntegrationSnmpObject->SnmpFilterList(
            Type => 'AND'
        ),
    };

    $strs = Dumper(\%ClassesIDs);

    #$Self->Print("<yellow>DefinitionID SNMP".$strs."</yellow>\n");
   

    #Import SNMP Data
    my $snmps = $OcsIntegrationSnmpObject->GetSmnps(
        ServerAddress=>$ServerAddress,
        PaginationSize=>$PaginationSize,
        Start=>$start,
        User=>$User,
        Pass=>$Pass,
        DoubleJsonDecode=>$DoubleJsonDecode,
    );

    while($snmps){

        while (my ($key, $value) = each (%$snmps)){
            $value->{"SNMP_OCS_ID"} = $key;

            my $useStructure;

            if($value->{snmp} && $value->{snmp}->{TYPE}){
                $useStructure = $ClassesIDs{$value->{snmp}->{TYPE}};
                if(!$useStructure){
                    $useStructure = $ClassesIDs{$defaultClass};
                }
            }
            else{
                $useStructure = $ClassesIDs{$defaultClass};
            }

            if(ValidFilterSnmp($value,$useStructure->{OrFilters},$useStructure->{AndFilters})){
                my $XmlData = [
                        undef,
                        {
                        'Version' => [
                            undef
                        ]
                        }
                    ];

                GenerateDataSNMPNode($value,$useStructure->{Structure},$XmlData->[1]->{'Version'});            

                my $KeyFields = ["[%]{'SNMP_OCS_ID'}[%]{'Content'}"];

                my $DataKeyFields = $useStructure->{DataKeyFields};

                if(scalar(@$DataKeyFields)>0){
                    $KeyFields = [];
                    for(my $i = 0; $i < scalar(@$DataKeyFields); $i++){
                        my $ocsPath = $DataKeyFields->[$i]; 
                        $ocsPath =~ s/::/\'}[%]{\'/ig; 
                        $ocsPath = "[%]{\'".$ocsPath."'}[%]{\'Content\'}";
                        #$Self->Print("<yellow>ocsPath ".$ocsPath."</yellow>\n");
                        push @{ $KeyFields }, $ocsPath;
                    }
                }            

                my $searchPathArray = [];
                my $xmlData = $XmlData->[1]->{'Version'}->[1];
                for(my $i = 0; $i < (scalar @$KeyFields); $i++){
                    my $searchPath = "\$xmlData".substr($KeyFields->[$i],3);

                    $searchPath =~ s/%/1/ig;
                    $searchPath =~ s/{/->{/ig;
                    $searchPath =~ s/\[/->\[/ig;

                    push @{ $searchPathArray }, {$KeyFields->[$i] => (eval $searchPath)};
                }

                my $ConfigItemIDs = $ConfigItemObject->ConfigItemSearchExtended(
                    ClassIDs     => [$useStructure->{ClassID}],
                    What => $searchPathArray
                );

                my $ConfigItemID;
                if((scalar @$ConfigItemIDs) > 0 ){
                    $Self->Print("<green>ConfigItemIDs Founded ".$ConfigItemIDs->[0].".</green>\n");
                    $ConfigItemID = $ConfigItemIDs->[0];

                    my %UpdateValues = $ConfigItemObject->_FindChangedXMLValues(
                        ConfigItemID => $ConfigItemID,
                        NewXMLData   => $XmlData
                    );

                    if(%UpdateValues){
                        $Self->Print("<green>Updates Founded ConfigItemID ".$ConfigItemID.".</green>\n");
                        
                        $ConfigItemObject->VersionAdd(
                            ConfigItemID => $ConfigItemID,
                            DefinitionID => $useStructure->{DefinitionID},
                            Name => 'OCS SNMP '.$key,
                            DeplStateID  => $DeplStateID->{ItemID},
                            InciStateID  => $InciStateID->{ItemID},
                            XMLData => $XmlData,
                            UserID       => 1,
                        );
                    }
                    else{
                        $Self->Print("<green>Updates NOT Founded ConfigItemID ".$ConfigItemID.". Nothing to do.</green>\n");
                    }
                }
                else{

                    $ConfigItemID = $ConfigItemObject->ConfigItemAdd(
                        ClassID => $useStructure->{ClassID},
                        UserID  => 1,
                    );

                    $ConfigItemObject->VersionAdd(
                        ConfigItemID => $ConfigItemID,
                        DefinitionID => $useStructure->{DefinitionID},
                        Name => 'OCS SNMP '.$key,
                        DeplStateID  => $DeplStateID->{ItemID},
                        InciStateID  => $InciStateID->{ItemID},
                        XMLData => $XmlData,
                        UserID       => 1,
                    );
                }
                
                $strs = Dumper($XmlData);

                #$Self->Print("<yellow>XmlData SNMP".$strs."</yellow>\n");
                
                #push $XmlData->[1]->{'Version'},GenerateDataSNMPNode($value,$useStructure->{Structure});
            }

            
        }

        $start = $start+$PaginationSize;

        Time::HiRes::usleep($MicroSleep) if $MicroSleep;

        $snmps = $OcsIntegrationSnmpObject->GetSmnps(
            ServerAddress=>$ServerAddress,
            PaginationSize=>$PaginationSize,
            Start=>$start,
            User=>$User,
            Pass=>$Pass,
            DoubleJsonDecode=>$DoubleJsonDecode,
        );
    }

    #Generate Class Structure Computer
    my $defaultClassComputer = $ConfigObject->Get("OcsIntegration::ComputerClass")||"";

    my $parentComputerNodes = $OcsIntegrationComputerObject->ComputerMappingActiveList();

    my $XmlComputerStructure = [];

    for(my $u = 0; $u < (scalar @$parentComputerNodes); $u++){
        push @{ $XmlComputerStructure },GenerateClassStructureComputerNode($parentComputerNodes->[$u]);
    }

    my $ClassComputerObj = $GeneralCatalogObject->ItemGet(
        Class => 'ITSM::ConfigItem::Class',
        Name  => $defaultClassComputer,
    );

    if(!$ClassComputerObj){
        $GeneralCatalogObject->ItemAdd(
            Class => 'ITSM::ConfigItem::Class',
            Name  => $defaultClassComputer,
            ValidID => 1,
            UserID => 1,
        );

        $ClassComputerObj = $GeneralCatalogObject->ItemGet(
            Class => 'ITSM::ConfigItem::Class',
            Name  => $defaultClassComputer,
        );
    }

    local $Data::Dumper::Terse = 30;
    $strs = Dumper($XmlComputerStructure);

    #my $ConfigItemListRef = $ConfigItemObject->ConfigItemResultList(
    #    ClassID => $ClassComputerObj->{ItemID},
    #    Start   => 0,
    #    Limit   => 500,
    #);
 
    #for my $ConfigItem ( values $ConfigItemListRef ){
    #   $ConfigItemObject->ConfigItemDelete(
    #        ConfigItemID  => $ConfigItem->{ConfigItemID},
    #        UserID  => 1,
    #    );

 
    #    $Self->Print("<green>Removed ConfigItem ".$ConfigItem->{ConfigItemID}.".</green>\n");
    #}

    $YAMLObject = $Kernel::OM->Get('Kernel::System::YAML');
    $YAMLStr = $YAMLObject->Dump(
        Data => $XmlComputerStructure,
    );

    
    $LastDefinition = $ConfigItemObject->DefinitionGet(
        ClassID => $ClassComputerObj->{ItemID},
    );

    # stop add, if definition was not changed
    my $return3;
    if ( !$LastDefinition->{DefinitionID} || $LastDefinition->{Definition} ne $YAMLStr ) {
        my $return3 = $ConfigItemObject->DefinitionAdd(
            ClassID    => $ClassComputerObj->{ItemID},
            Definition => $YAMLStr,
            UserID     => 1,
        );
    }

    my $DefinitionComputerID = $ConfigItemObject->DefinitionGet(
        ClassID => $ClassComputerObj->{ItemID},
    )->{DefinitionID};

    my $ComputerOrFilters = $OcsIntegrationComputerObject->ComputerFilterList(
            Type => 'OR'
        );

    my $ComputerAndFilters = $OcsIntegrationComputerObject->ComputerFilterList(
        Type => 'AND'
    );

    #Import Computer Data
    $start = 0;
    my $computers = $OcsIntegrationComputerObject->GetComputers(
        ServerAddress=>$ServerAddress,
        PaginationSize=>$PaginationSize,
        Start=>$start,
        User=>$User,
        Pass=>$Pass,
        DoubleJsonDecode=>$DoubleJsonDecode,
    );

    while($computers){
        while (my ($key, $value) = each (%$computers)){
            $value->{"COMPUTER_OCS_ID"} = $key;

            if(ValidFilterSnmp($value,$ComputerOrFilters,$ComputerAndFilters)){
                my $XmlData = [
                        undef,
                        {
                        'Version' => [
                            undef
                        ]
                        }
                    ];

                GenerateDataComputerNode($value,$XmlComputerStructure,$XmlData->[1]->{'Version'});

                my $KeyFields = ["[%]{'COMPUTER_OCS_ID'}[%]{'Content'}"];

                my $DataKeyFields = $OcsIntegrationComputerObject->ComputerMappingKeyFieldList();

                if(scalar(@$DataKeyFields)>0){
                    $KeyFields = [];
                    for(my $i = 0; $i < scalar(@$DataKeyFields); $i++){
                        my $ocsPath = $DataKeyFields->[$i]; 
                        $ocsPath =~ s/::/\'}\[%\]{\'/ig; 
                        $ocsPath = "[%]{'".$ocsPath."'}[%]{'Content'}";
                        my $value = $ocsPath;
                        #$Self->Print("<yellow>ocsPath ".$value."</yellow>\n");
                        push @{ $KeyFields }, $value;
                    }
                }

                my $searchPathArray = [];
                my $xmlData = $XmlData->[1]->{'Version'}->[1];
                for(my $i = 0; $i < (scalar @$KeyFields); $i++){
                    my $searchPath = "\$xmlData".substr($KeyFields->[$i],3);

                    $searchPath =~ s/%/1/ig;
                    $searchPath =~ s/{/->{/ig;
                    $searchPath =~ s/\[/->\[/ig;

                    #$Self->Print("<yellow>searchPath ".$searchPath.(eval $searchPath)."</yellow>\n");

                    push @{ $searchPathArray }, {$KeyFields->[$i] => (eval $searchPath)};
                }

                my $ConfigItemIDs = $ConfigItemObject->ConfigItemSearchExtended(
                    ClassIDs     => [$ClassComputerObj->{ItemID}],
                    What => $searchPathArray
                );

                my $ConfigItemID;
                if((scalar @$ConfigItemIDs) > 0 ){
                    $Self->Print("<green>ConfigItemIDs Founded ".$ConfigItemIDs->[0].".</green>\n");
                    $ConfigItemID = $ConfigItemIDs->[0];

                    my %UpdateValues = $ConfigItemObject->_FindChangedXMLValues(
                        ConfigItemID => $ConfigItemID,
                        NewXMLData   => $XmlData,
                        DefinitionID => $DefinitionComputerID
                    );

                    if(%UpdateValues){
                        $Self->Print("<green>Updates Founded ConfigItemID ".$ConfigItemID.".</green>\n");
                        
                        $ConfigItemObject->VersionAdd(
                            ConfigItemID => $ConfigItemID,
                            DefinitionID => $DefinitionComputerID,
                            Name => 'OCS COMPUTER '.$key,
                            DeplStateID  => $DeplStateID->{ItemID},
                            InciStateID  => $InciStateID->{ItemID},
                            XMLData => $XmlData,
                            UserID       => 1,
                        );
                    }
                    else{
                        $Self->Print("<green>Updates NOT Founded ConfigItemID ".$ConfigItemID.". Nothing to do.</green>\n");
                    }
                }
                else{

                    $ConfigItemID = $ConfigItemObject->ConfigItemAdd(
                        ClassID => $ClassComputerObj->{ItemID},
                        UserID  => 1,
                    );

                    $ConfigItemObject->VersionAdd(
                        ConfigItemID => $ConfigItemID,
                        DefinitionID => $DefinitionComputerID,
                        Name => 'OCS COMPUTER '.$key,
                        DeplStateID  => $DeplStateID->{ItemID},
                        InciStateID  => $InciStateID->{ItemID},
                        XMLData => $XmlData,
                        UserID       => 1,
                    );
                }
                
                $strs = Dumper($XmlData);

                #$Self->Print("<yellow>XmlData Computer".$strs."</yellow>\n");
                
                #push $XmlData->[1]->{'Version'},GenerateDataSNMPNode($value,$useStructure->{Structure});
            }

            
        }

        $start = $start+$PaginationSize;

        Time::HiRes::usleep($MicroSleep) if $MicroSleep;

        $computers = $OcsIntegrationComputerObject->GetComputers(
            ServerAddress=>$ServerAddress,
            PaginationSize=>$PaginationSize,
            Start=>$start,
            User=>$User,
            Pass=>$Pass,
            DoubleJsonDecode=>$DoubleJsonDecode,
        );
    }
    
    $Self->Print("<green>Done.</green>\n");
    return $Self->ExitCodeOk();
}

sub ValidFilterSnmp{
    my ($data,$OrFilters,$AndFilters) = @_;

    #Filter OR
    my $orResult = 0;
    for(my $i = 0; $i < scalar(@$OrFilters); $i++){
        my $Or = $OrFilters->[$i];
        
        my $orResultL = executeFilter($data,$Or->{Field},$Or->{Condition},$Or->{Content});
        
        $orResult = $orResult || $orResultL;
    }

    if(scalar(@$OrFilters) == 0){
        $orResult = 1;
    }

    #Filter AND
    my $andResult = 1;
    for(my $i = 0; $i < scalar(@$AndFilters); $i++){
        my $And = $AndFilters->[$i];
        
        my $andResultL = executeFilter($data,$And->{Field},$And->{Condition},$And->{Content});
        
        $andResult = $andResult && $andResultL;
    }

    return $orResult && $andResult;
}

sub executeFilter{
    my ($data,$Path,$Condition,$Content) = @_;
    my $hashField = $Path;
    if(index($Path,'::') > -1){
        $hashField = substr $Path,0, index($Path,'::');
    }
    if((ref $data) eq ''){
        #print $data." will be Validate \n";
        if(!$data){
            $data = '';
        }
        
        if($Condition eq '='){
            if($data eq $Content){
                #print $data." will be = 1\n";
                return 1;
            }
            #print $data." will be = 0\n";
            return 0;            
        }
        elsif($Condition eq '>'){
            if($data > $Content){
                #print $data." will be > 1\n";
                return 1;
            }
            #print $data." will be > 0\n";
            return 0;
        }
        elsif($Condition eq '<'){
            if($data < $Content){
                #print $data." will be < 1\n";
                return 1;
            }
            #print $data." will be < 0\n";
            return 0;
        }
        elsif($Condition eq '>='){
            if($data >= $Content){
                #print $data." will be >= 1\n";
                return 1;
            }
            #print $data." will be >= 0\n";
            return 0;
        }
        elsif($Condition eq '<='){
            if($data <= $Content){
                #print $data." will be <= 1\n";
                return 1;
            }
            #print $data." will be <= 0\n";
            return 0;
        }
        elsif($Condition eq '!='){
            if($data ne $Content){
                #print $data." will be != 1\n";
                return 1;
            }
            #print $data." will be != 0\n";
            return 0;
        }
        elsif($Condition eq 'contem'){
            if(index($data,$Content)>-1){
                #print $data." will be contem 1\n";
                return 1;
            }
            #print $data." will be contem 0\n";
            return 0;
        }
        elsif($Condition eq 'nao contem'){
            if(index($data,$Content)<0){
                #print $data." will be nao contem 1\n";
                return 1;
            }
            #print $data." will be nao contem 0\n";
            return 0;
        }

        return 1;
    }

    if(!$data->{$hashField}){
        #print $hashField." is null \n";
        return 1;
    }
    else{
        if((ref $data->{$hashField}) eq 'HASH'){
            my $nextPath = substr $Path, index($Path,':')+2;
            #print $hashField." is HASH next path ".$nextPath." \n";
            executeFilter($data->{$hashField},$nextPath,$Condition,$Content);            
        }
        else{
            if((ref $data->{$hashField}) eq 'ARRAY'){
                my $nextPath = substr $Path, index($Path,':')+2;
                my $array = $data->{$hashField};
                #print $hashField." is ARRAY next path ".$nextPath." array size ".scalar(@$array)." \n";
                for(my $i = 0; $i < scalar(@$array); $i++){
                    executeFilter($array->[$i],$nextPath,$Condition,$Content);
                }
            }
            else{
                executeFilter($data->{$hashField},"",$Condition,$Content);
            }
        }
    }

    

    #return 1;
}

sub GenerateClassStructureSNMPNode{
    my ($data) = @_;

    my $OcsIntegrationSnmpObject = $Kernel::OM->Get("Kernel::System::OcsIntegrationSnmp");

    my $name = $data->{OtrsTranslate};
    if(!$name || $name eq ""){
        $name =$data->{OcsField};
    }

    if($data->{Type} eq 'objectlist'){

        my $childList = $OcsIntegrationSnmpObject->SnmpMappingActiveList(
            SnmpClassTypeId => $data->{SnmpClassTypeId},
            ParentId => $data->{ID},
        );

        if(scalar(@$childList) > 0){
            my $structure =  {
                Key => $data->{OcsField},
                Name => $name,
                Searchable => 0,
                Input => {
                    Type => 'Text',
                    Size => 10,
                    MaxLength => 10,
                },
                Sub =>  
                    []
                , 
                CountMax => 9999,
            };

            for(my $i = 0; $i < scalar(@$childList); $i++){
                push @{ $structure->{Sub} }, GenerateClassStructureSNMPNode($childList->[$i]);
            }

            return $structure;
        }
        else{
            return  {
                Key => $data->{OcsField},
                Name => $name,
                Searchable => 0,
                Input => {
                    Type => 'Text',
                    Size => 10,
                    MaxLength => 10,
                },
                CountMax => 9999,
            };
        }

        
    }

    if($data->{Type} eq 'simplelist'){
        return  {
            Key => $data->{OcsField},
            Name => $name,
            Searchable => 0,
            Input => {
                Type => 'Text',
                Size => 200,
                MaxLength => 200,
            },
            CountMax => 9999,
        };
    }

    if($data->{Type} eq 'detail'){
        return {
            Key => $data->{OcsField},
            Name => $name,
            Searchable => 0,
            Input => {
                Type => 'Text',
                Size => 200,
                MaxLength => 200,
            },
        }; 
    }

    if($data->{Type} eq 'master'){
        my $childList = $OcsIntegrationSnmpObject->SnmpMappingActiveList(
            SnmpClassTypeId => $data->{SnmpClassTypeId},
            ParentId => $data->{ID},
        );

        if(scalar(@$childList) > 0){
            my $structure = {
                Key => $data->{OcsField},
                Name => $name,
                Searchable => 0,
                Input => {
                    Type => 'Text',
                    Size => 200,
                    MaxLength => 200,
                },
                Sub => []
            }; 

            for(my $i = 0; $i < scalar(@$childList); $i++){
                push @{ $structure->{Sub} }, GenerateClassStructureSNMPNode($childList->[$i]);
            }

            return $structure;
        }
        else{
            return {
                Key => $data->{OcsField},
                Name => $name,
                Searchable => 0,
                Input => {
                    Type => 'Text',
                    Size => 200,
                    MaxLength => 200,
                }
            };
        }        
    }
}

sub GenerateDataSNMPNode{
    my ($data,$structure,$array) = @_;

    my $object = {};

    for(my $i=0; $i<scalar(@$structure); $i++){
        my $structureItem = $structure->[$i];

        #objectlist
        if($structureItem->{CountMax} && $structureItem->{CountMax} > 1 && $structureItem->{Sub}){
            my $itemPath = substr $structureItem->{Key}, rindex($structureItem->{Key},':')+1;

            $object->{$structureItem->{Key}} = [undef];

            #print $structureItem->{Key}.' is objectlist key '.$data->{$itemPath}.'\n';

            my $arrayData = $data->{$itemPath};

            for(my $i = 0; $i < scalar(@$arrayData); $i++){
                my $arrayItem = $arrayData->[$i];
                GenerateDataSNMPNode($arrayItem,$structureItem->{Sub},$object->{$structureItem->{Key}});
            }            
        }

        #simplelist
        if($structureItem->{CountMax} && $structureItem->{CountMax} > 1 && !$structureItem->{Sub}){
            my $itemPath = substr $structureItem->{Key}, rindex($structureItem->{Key},':')+1;
            $object->{$structureItem->{Key}} = [undef];

            my $arrayData = $data->{$itemPath};

            for(my $i = 0; $i < scalar(@$arrayData); $i++){
                my $arrayItem = $arrayData->[$i];

                push @{ $object->{$structureItem->{Key}} }, {'Content' => $arrayItem};
            }

            #print $structureItem->{Key}.' is simplelist\n';
        }

        #detail
        if(!$structureItem->{CountMax} && !$structureItem->{Sub}){
            my $itemPath = substr $structureItem->{Key}, rindex($structureItem->{Key},':')+1;
            $object->{$structureItem->{Key}} = [
                undef,
                {
                    'Content' => $data->{$itemPath}
                }                
            ];
            #print $structureItem->{Key}.' is detail key '.$itemPath.'\n';
        }

        #master
        if(!$structureItem->{CountMax} && $structureItem->{Sub}){
            my $itemPath = substr $structureItem->{Key}, rindex($structureItem->{Key},':')+1;
            #print $structureItem->{Key}.' is master\n';   
            $object->{$structureItem->{Key}} = [undef];

            GenerateDataSNMPNode($data->{$itemPath},$structureItem->{Sub},$object->{$structureItem->{Key}}); 
        }
    }
    $object->{'Content'} = '';
    push @{ $array },$object;
}

sub GenerateClassStructureComputerNode{
    my ($data) = @_;

    my $OcsIntegrationComputerObject = $Kernel::OM->Get("Kernel::System::OcsIntegrationComputer");

    my $name = $data->{OtrsTranslate};
    if(!$name || $name eq ""){
        $name =$data->{OcsField};
    }

    if($data->{Type} eq 'objectlist'){

        my $childList = $OcsIntegrationComputerObject->ComputerMappingActiveList(
            ParentId => $data->{ID},
        );

        if(scalar(@$childList) > 0){
            my $structure =  {
                Key => $data->{OcsField},
                Name => $name,
                Searchable => 0,
                Input => {
                    Type => 'Text',
                    Size => 10,
                    MaxLength => 10,
                },
                Sub =>  
                    []
                , 
                CountMax => 9999,
            };

            for(my $i = 0; $i < scalar(@$childList); $i++){
                push @{ $structure->{Sub} }, GenerateClassStructureComputerNode($childList->[$i]);
            }

            return $structure;
        }
        else{
            return  {
                Key => $data->{OcsField},
                Name => $name,
                Searchable => 0,
                Input => {
                    Type => 'Text',
                    Size => 10,
                    MaxLength => 10,
                },
                CountMax => 9999,
            };
        }

        
    }

    if($data->{Type} eq 'simplelist'){
        return  {
            Key => $data->{OcsField},
            Name => $name,
            Searchable => 0,
            Input => {
                Type => 'Text',
                Size => 200,
                MaxLength => 200,
            },
            CountMax => 9999,
        };
    }

    if($data->{Type} eq 'detail'){
        return {
            Key => $data->{OcsField},
            Name => $name,
            Searchable => 0,
            Input => {
                Type => 'Text',
                Size => 200,
                MaxLength => 200,
            },
        }; 
    }

    if($data->{Type} eq 'master'){
        my $childList = $OcsIntegrationComputerObject->ComputerMappingActiveList(
            ParentId => $data->{ID},
        );

        if(scalar(@$childList) > 0){
            my $structure = {
                Key => $data->{OcsField},
                Name => $name,
                Searchable => 0,
                Input => {
                    Type => 'Text',
                    Size => 200,
                    MaxLength => 200,
                },
                Sub => []
            }; 

            for(my $i = 0; $i < scalar(@$childList); $i++){
                push @{ $structure->{Sub} }, GenerateClassStructureComputerNode($childList->[$i]);
            }

            return $structure;
        }
        else{
            return {
                Key => $data->{OcsField},
                Name => $name,
                Searchable => 0,
                Input => {
                    Type => 'Text',
                    Size => 200,
                    MaxLength => 200,
                }
            };
        }        
    }
}

sub GenerateDataComputerNode{
    my ($data,$structure,$array) = @_;

    my $object = {};

    for(my $i=0; $i<scalar(@$structure); $i++){
        my $structureItem = $structure->[$i];

        #objectlist
        if($structureItem->{CountMax} && $structureItem->{CountMax} > 1 && $structureItem->{Sub}){
            my $itemPath = substr $structureItem->{Key}, rindex($structureItem->{Key},':')+1;

            $object->{$structureItem->{Key}} = [undef];

            #print $structureItem->{Key}.' is objectlist key '.$data->{$itemPath}.'\n';

            my $arrayData = $data->{$itemPath};

            for(my $i = 0; $i < scalar(@$arrayData); $i++){
                my $arrayItem = $arrayData->[$i];
                GenerateDataSNMPNode($arrayItem,$structureItem->{Sub},$object->{$structureItem->{Key}});
            }            
        }

        #simplelist
        if($structureItem->{CountMax} && $structureItem->{CountMax} > 1 && !$structureItem->{Sub}){
            my $itemPath = substr $structureItem->{Key}, rindex($structureItem->{Key},':')+1;
            $object->{$structureItem->{Key}} = [undef];

            my $arrayData = $data->{$itemPath};

            for(my $i = 0; $i < scalar(@$arrayData); $i++){
                my $arrayItem = $arrayData->[$i];

                push @{ $object->{$structureItem->{Key}} }, {'Content' => $arrayItem};
            }

            #print $structureItem->{Key}.' is simplelist\n';
        }

        #detail
        if(!$structureItem->{CountMax} && !$structureItem->{Sub}){
            my $itemPath = substr $structureItem->{Key}, rindex($structureItem->{Key},':')+1;
            $object->{$structureItem->{Key}} = [
                undef,
                {
                    'Content' => $data->{$itemPath}
                }                
            ];
            #print $structureItem->{Key}.' is detail key '.$itemPath.'\n';
        }

        #master
        if(!$structureItem->{CountMax} && $structureItem->{Sub}){
            my $itemPath = substr $structureItem->{Key}, rindex($structureItem->{Key},':')+1;
            #print $structureItem->{Key}.' is master\n';   
            $object->{$structureItem->{Key}} = [undef];

            GenerateDataSNMPNode($data->{$itemPath},$structureItem->{Sub},$object->{$structureItem->{Key}}); 
        }
    }
    $object->{'Content'} = '';
    push @{ $array },$object;
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut