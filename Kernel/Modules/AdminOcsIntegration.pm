# --
# Copyright (C) 2001-2018 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AdminOcsIntegration;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);
use Kernel::Language qw(Translatable);

our $ObjectManagerDisabled = 1;

our @ObjectDependencies = (
    'Kernel::Output::HTML::Layout',
    'Kernel::System::CustomerUser',
    'Kernel::System::DynamicField',
    'Kernel::System::Encode',
    'Kernel::System::GeneralCatalog',
    'Kernel::System::ITSMConfigItem',
    'Kernel::System::Log',
    'Kernel::System::Ticket',
    'Kernel::System::Web::Request',
    'Kernel::System::OcsIntegrationSnmp',
    'Kernel::System::OcsIntegrationComputer',
    'Kernel::System::JSON',
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # get the dynamic fields for ticket object
    $Self->{DynamicField} = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldListGet(
        Valid      => 1,
        ObjectType => ['Ticket'],
    );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # get layout object
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # secure mode message (don't allow this action till secure mode is enabled)
    if ( !$Kernel::OM->Get('Kernel::Config')->Get('SecureMode') ) {
        return $LayoutObject->SecureMode();
    }

    # get param object
    my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');

    # get config data
    $Self->{Profile}    = $ParamObject->GetParam( Param => 'Profile' )    || '';
    $Self->{OldProfile} = $ParamObject->GetParam( Param => 'OldProfile' ) || '';
    $Self->{Subaction}  = $ParamObject->GetParam( Param => 'Subaction' )  || '';

    # get needed objects
    my $CheckItemObject    = $Kernel::OM->Get('Kernel::System::CheckItem');
    my $GenericAgentObject = $Kernel::OM->Get('Kernel::System::GenericAgent');

    my $OcsIntegrationSnmpObject = $Kernel::OM->Get("Kernel::System::OcsIntegrationSnmp");
    my $OcsIntegrationComputerObject = $Kernel::OM->Get("Kernel::System::OcsIntegrationComputer");
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my $JSONObject = $Kernel::OM->Get('Kernel::System::JSON');

    if ($Self->{Subaction} eq 'SNMPUpdateStructure'){
        my $ClassId = $ParamObject->GetParam( Param => 'ClassID' )  || '';

        my $JSON = $LayoutObject->JSONEncode(
            Data => GenerateStructureSNMP($ClassId),
        );

        return $LayoutObject->Attachment(
            ContentType => 'application/json; charset=utf8',
            Content     => $JSON || '',
            Type        => 'inline',
            NoCache     => 1,
        );
    }

    if ($Self->{Subaction} eq 'SNMPGetClasses'){
        my $JSON = $LayoutObject->JSONEncode(
            Data => {
                result => "success",
                data =>  $OcsIntegrationSnmpObject->SnmpTypeToOtrsClassList(),
            },
        );
        return $LayoutObject->Attachment(
            ContentType => 'application/json; charset=utf8',
            Content     => $JSON || '',
            Type        => 'inline',
            NoCache     => 1,
        );
    }

    if ($Self->{Subaction} eq 'SNMPGetStructure'){
        my $ClassId = $ParamObject->GetParam( Param => 'ClassId' )  || '';

        if(!$ClassId || int($ClassId) == 0){
            my $snmpDefaultClass = $ConfigObject->Get("OcsIntegration::SnmpDefaultClass")||"";
            my $JSON = $LayoutObject->JSONEncode(
                Data => {
                    result => "success",
                    data =>  {
                        OtrsClass => $snmpDefaultClass,
                        SnmpData => $OcsIntegrationSnmpObject->SnmpMappingList()
                    }
                },
            );
            return $LayoutObject->Attachment(
                ContentType => 'application/json; charset=utf8',
                Content     => $JSON || '',
                Type        => 'inline',
                NoCache     => 1,
            );
        }
        else{

            my $Class = $OcsIntegrationSnmpObject->SnmpTypeToOtrsClassGet(
                ID => $ClassId,
            );
            my $JSON = $LayoutObject->JSONEncode(
                Data => {
                    result => "success",
                    data => {
                        OtrsClass => $Class->{OtrsClass},
                        OcsType => $Class->{OcsType},
                        ClassId => $Class->{ID},
                        SnmpData => $OcsIntegrationSnmpObject->SnmpMappingList(
                            SnmpClassTypeId => $ClassId,
                        )
                    } 
                    
                },
            );
            return $LayoutObject->Attachment(
                ContentType => 'application/json; charset=utf8',
                Content     => $JSON || '',
                Type        => 'inline',
                NoCache     => 1,
            );
        }
        
    }

    if ($Self->{Subaction} eq 'ComputerGetStructure'){
        
        my $computerDefaultClass = $ConfigObject->Get("OcsIntegration::ComputerClass")||"";
        my $JSON = $LayoutObject->JSONEncode(
            Data => {
                result => "success",
                data =>  {
                    OtrsClass => $computerDefaultClass,
                    ComputerData => $OcsIntegrationComputerObject->ComputerMappingList()
                }
            },
        );
        return $LayoutObject->Attachment(
            ContentType => 'application/json; charset=utf8',
            Content     => $JSON || '',
            Type        => 'inline',
            NoCache     => 1,
        );
        
        
    }


    if ($Self->{Subaction} eq 'ComputerUpdateStructure'){
        my $JSON = $LayoutObject->JSONEncode(
            Data => GenerateStructureComputer(),
        );
        return $LayoutObject->Attachment(
            ContentType => 'application/json; charset=utf8',
            Content     => $JSON || '',
            Type        => 'inline',
            NoCache     => 1,
        );
    }

    # ---------------------------------------------------------- #
    # run a generic agent job -> "run now"
    # ---------------------------------------------------------- #
    if ( $Self->{Subaction} eq '' || $Self->{Subaction} eq 'SNMP' ) {
        $LayoutObject->Block(
            Name => 'SNMP',
        );
    }

    if ($Self->{Subaction} eq 'AddClassSNMP' ) {
        
        $LayoutObject->Block(
            Name => 'AddClassSNMP',
        );
    }

    if ($Self->{Subaction} eq 'ActionAddClassSNMP' ) {

        my $ocsType = $ParamObject->GetParam( Param => 'OcsType' )  || '';
        my $otrsClass = $ParamObject->GetParam( Param => 'OtrsClass' )  || '';

        my $ClassID = $OcsIntegrationSnmpObject->SnmpTypeToOtrsClassAdd(
            OcsType => $ocsType,
            OtrsClass => $otrsClass
        );

        #my $genericStructure = $OcsIntegrationSnmpObject->SnmpMappingList();

        #for(my $i = 0; $i < scalar(@$genericStructure); $i++){
        #    $OcsIntegrationSnmpObject->SnmpMappingAdd(
        #        Active => $genericStructure->[$i]->{Active},
        #        KeyField => $genericStructure->[$i]->{KeyField},
        #        Type => $genericStructure->[$i]->{Type},
        #        OcsField => $genericStructure->[$i]->{OcsField},
        #        OcsPath => $genericStructure->[$i]->{OcsPath},
        #        ParentId => $genericStructure->[$i]->{ParentId},
        #        Order => $genericStructure->[$i]->{Order},
        #        SnmpClassTypeId => $ClassID
        #    );
        #}
        
        $LayoutObject->Block(
            Name => 'SNMP',
        );
    }

    if ($Self->{Subaction} eq 'RemoveClassSNMP' ) {

        my $ClassID = $ParamObject->GetParam( Param => 'ClassID' )  || '';

        my $structure = $OcsIntegrationSnmpObject->SnmpMappingList(SnmpClassTypeId=>$ClassID);

        for(my $i = 0; $i < scalar(@$structure); $i++){
            $OcsIntegrationSnmpObject->SnmpMappingDelete(
                ID => $structure->[$i]->{ID},
            );
        }

        $OcsIntegrationSnmpObject->SnmpTypeToOtrsClassDelete(
            ID => $ClassID
        );
        
        $LayoutObject->Block(
            Name => 'SNMP',
        );
    }

    if ($Self->{Subaction} eq 'AddItemMap' ) {

        my $ParentId = $ParamObject->GetParam( Param => 'ParentId' )  || '';
        my $ClassId = $ParamObject->GetParam( Param => 'ClassID' )  || '';

        my $ParentDescription = "";
        if(!$ParentId || $ParentId == 0){
            $ParentDescription = "Raiz";
        }
        else{
            my $ParentData  = $OcsIntegrationSnmpObject->SnmpMappingGet(ID=>$ParentId);
            $ParentDescription = $ParentData->{OcsPath};
        }

        my $ClassDescription = "";
        if(!$ClassId || $ClassId == 0){
            $ClassDescription = "Default";
        }
        else{
            my $ClassData  = $OcsIntegrationSnmpObject->SnmpTypeToOtrsClassGet(
                ID => $ClassId,
            );
            $ClassDescription = $ClassData->{OtrsClass};
        }

        #my %ValidList        = $Kernel::OM->Get('Kernel::System::Valid')->ValidList();
        my %TypeOcsList;
        $TypeOcsList{ 'master' } = 'master';
        $TypeOcsList{ 'detail' } = 'detail';
        $TypeOcsList{ 'simplelist' } = 'simplelist';
        $TypeOcsList{ 'objectlist' } = 'objectlist';
        my %TypeOcsListReverse = reverse %TypeOcsList;
        
        $LayoutObject->Block(
            Name => 'AddItemMap',
            Data => {
                ParentId => $ParentId,
                ParentDescription => $ParentDescription,
                ClassId => $ClassId,
                ClassDescription => $ClassDescription,
                TypeOcsOption => $LayoutObject->BuildSelection(
                    Data       => \%TypeOcsList,
                    Name       => 'TypeOcsID',
                    SelectedID => $Param{TypeOcsID} || $TypeOcsListReverse{typeOcs},
                    Class      => 'Modernize Validate_Required ' . ( $Param{Errors}->{'TypeOcsIDInvalid'} || '' ),
                ),
            }
        );
    }

    if ($Self->{Subaction} eq 'AddItemMapComputer' ) {

        my $ParentId = $ParamObject->GetParam( Param => 'ParentId' )  || '';

        my $ParentDescription = "";
        if(!$ParentId || $ParentId == 0){
            $ParentDescription = "Raiz";
        }
        else{
            my $ParentData  = $OcsIntegrationComputerObject->ComputerMappingGet(ID=>$ParentId);
            $ParentDescription = $ParentData->{OcsPath};
        }

        
        #my %ValidList        = $Kernel::OM->Get('Kernel::System::Valid')->ValidList();
        my %TypeOcsList;
        $TypeOcsList{ 'master' } = 'master';
        $TypeOcsList{ 'detail' } = 'detail';
        $TypeOcsList{ 'simplelist' } = 'simplelist';
        $TypeOcsList{ 'objectlist' } = 'objectlist';
        my %TypeOcsListReverse = reverse %TypeOcsList;
        
        $LayoutObject->Block(
            Name => 'AddItemMapComputer',
            Data => {
                ParentId => $ParentId,
                ParentDescription => $ParentDescription,
                TypeOcsOption => $LayoutObject->BuildSelection(
                    Data       => \%TypeOcsList,
                    Name       => 'TypeOcsID',
                    SelectedID => $Param{TypeOcsID} || $TypeOcsListReverse{typeOcs},
                    Class      => 'Modernize Validate_Required ' . ( $Param{Errors}->{'TypeOcsIDInvalid'} || '' ),
                ),
            }
        );
    }

    if ($Self->{Subaction} eq 'ActionAddItemMap' ) {

        my $ParentId = $ParamObject->GetParam( Param => 'ParentId' )  || '';
        my $ClassId = $ParamObject->GetParam( Param => 'ClassID' )  || '';
        my $TypeOcsID = $ParamObject->GetParam( Param => 'TypeOcsID' )  || '';
        my $OcsTitle = $ParamObject->GetParam( Param => 'OcsTitle' )  || '';
        my $OcsPath = "";

        if($ParentId == 0){
            $OcsPath = $OcsTitle;
            $ParentId = undef;
        }
        else{
            my $ParentData  = $OcsIntegrationSnmpObject->SnmpMappingGet(ID=>$ParentId);
            $OcsPath = $ParentData->{OcsPath}."::".$OcsTitle;
        }

        if(!$ClassId || $ClassId == 0){
            $ClassId = undef;
        }

        $OcsIntegrationSnmpObject->SnmpMappingAdd(
            Active => 0,
            KeyField => 0,
            Type => $TypeOcsID,
            OcsField => $OcsTitle,
            OcsPath => $OcsPath,
            ParentId => $ParentId,
            SnmpClassTypeId => $ClassId
        );
        
        $LayoutObject->Block(
            Name => 'SNMP',
        );
    }

    if ($Self->{Subaction} eq 'ActionAddItemMapComputer' ) {

        my $ParentId = $ParamObject->GetParam( Param => 'ParentId' )  || '';
        my $TypeOcsID = $ParamObject->GetParam( Param => 'TypeOcsID' )  || '';
        my $OcsTitle = $ParamObject->GetParam( Param => 'OcsTitle' )  || '';
        my $OcsPath = "";

        if($ParentId == 0){
            $OcsPath = $OcsTitle;
            $ParentId = undef;
        }
        else{
            my $ParentData  = $OcsIntegrationComputerObject->ComputerMappingGet(ID=>$ParentId);
            $OcsPath = $ParentData->{OcsPath}."::".$OcsTitle;
        }

        $OcsIntegrationComputerObject->ComputerMappingAdd(
            Active => 0,
            KeyField => 0,
            Type => $TypeOcsID,
            OcsField => $OcsTitle,
            OcsPath => $OcsPath,
            ParentId => $ParentId,
        );
        
        $LayoutObject->Block(
            Name => 'Computers',
        );
    }

    if ($Self->{Subaction} eq 'RemoveItemMap' ) {
        my $ID = $ParamObject->GetParam( Param => 'ID' )  || '';

        $OcsIntegrationSnmpObject->SnmpMappingDelete(ID =>$ID);

        $LayoutObject->Block(
            Name => 'SNMP',
        );
    }

    if ($Self->{Subaction} eq 'RemoveItemMapComputer' ) {
        my $ID = $ParamObject->GetParam( Param => 'ID' )  || '';

        $OcsIntegrationComputerObject->ComputerMappingDelete(ID =>$ID);

        $LayoutObject->Block(
            Name => 'Computers',
        );
    }

    if ($Self->{Subaction} eq 'SaveMapSnmp' ) {
        #my $ID = $ParamObject->GetParam( Param => 'ID' )  || '';
        

        my $JSOND = $JSONObject->Decode(
            Data => $ParamObject->GetParam( Param => 'Structure' ),
        );

        my $Data = $JSOND->{SnmpData};

        if($JSOND->{ClassId}){
            $OcsIntegrationSnmpObject->SnmpTypeToOtrsClassUpdate(
                ID => $JSOND->{ClassId},
                OcsType => $JSOND->{OcsType},
                OtrsClass => $JSOND->{OtrsClass},
            );
        }
        
        for(my $i = 0; $i < scalar(@$Data); $i++){
            $OcsIntegrationSnmpObject->SnmpMappingUpdate(
                ID => $Data->[$i]->{ID},
                Active => $Data->[$i]->{Active},
                Order => $Data->[$i]->{Order},
                KeyField => $Data->[$i]->{KeyField},
                Type => $Data->[$i]->{Type},
                OcsField => $Data->[$i]->{OcsField},
                OcsPath => $Data->[$i]->{OcsPath},
                ParentId => $Data->[$i]->{ParentId},
                OtrsTranslate => $Data->[$i]->{OtrsTranslate},
                SnmpClassTypeId => $Data->[$i]->{SnmpClassTypeId}
            );
        }

        $LayoutObject->Block(
            Name => 'SNMP',
        );
    }

    if ($Self->{Subaction} eq 'SaveMapComputer' ) {
        #my $ID = $ParamObject->GetParam( Param => 'ID' )  || '';
        

        my $JSOND = $JSONObject->Decode(
            Data => $ParamObject->GetParam( Param => 'Structure' ),
        );

        my $Data = $JSOND->{ComputerData};
        
        for(my $i = 0; $i < scalar(@$Data); $i++){
            $OcsIntegrationComputerObject->ComputerMappingUpdate(
                ID => $Data->[$i]->{ID},
                Active => $Data->[$i]->{Active},
                KeyField => $Data->[$i]->{KeyField},
                Type => $Data->[$i]->{Type},
                OcsField => $Data->[$i]->{OcsField},
                OcsPath => $Data->[$i]->{OcsPath},
                ParentId => $Data->[$i]->{ParentId},
                Order => $Data->[$i]->{Order},
                OtrsTranslate => $Data->[$i]->{OtrsTranslate}
            );
        }

        $LayoutObject->Block(
            Name => 'Computers',
        );
    }

    if ($Self->{Subaction} eq 'AddSnmpFilter' || $Self->{Subaction} eq 'SaveSnmpFilter' || $Self->{Subaction} eq 'RemoveSnmpFilter' ) {

        my $ID = $ParamObject->GetParam( Param => 'ID' )  || '';
        my $ClassId = $ParamObject->GetParam( Param => 'ClassID' )  || '';

        my $Description = "";
        if(!$ID || int($ID) == 0){
            $Description = "Raiz";
            $ID = undef;
        }
        else{
            my $ParentData  = $OcsIntegrationSnmpObject->SnmpMappingGet(ID=>$ID);
            $Description = $ParentData->{OcsPath};
        }

        if($Self->{Subaction} eq 'SaveSnmpFilter'){
            my $Type = $ParamObject->GetParam( Param => 'TypeFilter' )  || '';
            my $Field = $ParamObject->GetParam( Param => 'OcsField' )  || '';
            my $Condition = $ParamObject->GetParam( Param => 'Condition' )  || '';
            my $Content = $ParamObject->GetParam( Param => 'Content' )  || '';
            my $ClassId = $ParamObject->GetParam( Param => 'ClassID' )  || '';

            if(!$ClassId || int($ClassId) == 0){
                $ClassId = undef;
            }

            $OcsIntegrationSnmpObject->SnmpFilterAdd(
                Type => $Type,
                Field => $Field,
                Condition => $Condition,
                Content => $Content,
                OcsPathId => $ID,
                SnmpClassTypeId => $ClassId,
            );
        }        

        if(!$ClassId || int($ClassId) == 0){
            $ClassId = undef;
        }

        if($Self->{Subaction} eq 'RemoveSnmpFilter'){
            my $RemoveID = $ParamObject->GetParam( Param => 'RemoveID' )  || '';
            $OcsIntegrationSnmpObject->SnmpFilterDelete(
                ID => $RemoveID
            );
        }        

        

        my $ClassDescription = "";
        if(!$ClassId || $ClassId == 0){
            $ClassDescription = "Default";
        }
        else{
            my $ClassData  = $OcsIntegrationSnmpObject->SnmpTypeToOtrsClassGet(
                ID => $ClassId,
            );
            $ClassDescription = $ClassData->{OtrsClass};
        }
        
        my %TypeFilterList;
        $TypeFilterList{ 'AND' } = 'AND';
        $TypeFilterList{ 'OR' } = 'OR';
        my %TypeFilterListReverse = reverse %TypeFilterList;

        my $FiltersValueData  = $OcsIntegrationSnmpObject->SnmpMappingListToFilter(
            SnmpClassTypeId => $ClassId,
            ParentId => $ID
        );
        my %OcsFieldList;
        for(my $i = 0; $i < scalar(@$FiltersValueData);$i++){
            $OcsFieldList{ $FiltersValueData->[$i]->{OcsPath} } = $FiltersValueData->[$i]->{OcsPath};
        }
        my %OcsFieldListReverse = reverse %OcsFieldList;

        my %ConditionList;
        $ConditionList{ '=' } = '=';
        $ConditionList{ '>' } = '>';
        $ConditionList{ '<' } = '<';
        $ConditionList{ '>=' } = '>=';
        $ConditionList{ '<=' } = '>=';
        $ConditionList{ '!=' } = '!=';
        $ConditionList{ 'contem' } = 'contem';
        $ConditionList{ 'nao contem' } = 'nao contem';
        my %ConditionListReverse = reverse %ConditionList;
        
        $LayoutObject->Block(
            Name => 'AddSnmpFilter',
            Data => {
                ID => $ID,
                Description => $Description,
                TypeFilterOption => $LayoutObject->BuildSelection(
                    Data       => \%TypeFilterList,
                    Name       => 'TypeFilter',
                    SelectedID => $Param{TypeFilter} || $TypeFilterListReverse{TypeFilter},
                    Class      => 'Modernize Validate_Required ' . ( $Param{Errors}->{'TypeFilterInvalid'} || '' ),
                ),
                OcsFieldOption => $LayoutObject->BuildSelection(
                    Data       => \%OcsFieldList,
                    Name       => 'OcsField',
                    SelectedID => $Param{OcsField} || $OcsFieldListReverse{OcsField},
                    Class      => 'Modernize Validate_Required ' . ( $Param{Errors}->{'OcsFieldInvalid'} || '' ),
                ),
                ConditionOption => $LayoutObject->BuildSelection(
                    Data       => \%ConditionList,
                    Name       => 'Condition',
                    SelectedID => $Param{Condition} || $ConditionListReverse{Condition},
                    Class      => 'Modernize Validate_Required ' . ( $Param{Errors}->{'ConditionInvalid'} || '' ),
                ),
                ClassDescription => $ClassDescription,
                ClassId => $ClassId
            }
        );


        my $filterList = $OcsIntegrationSnmpObject->SnmpFilterList(
            OcsPathId=>$ID,
            SnmpClassTypeId=>$ClassId,
        );
        if(scalar(@$filterList) == 0){
            $LayoutObject->Block(
                Name => 'NoDataFoundFilterMsg',
            );
        }
        else{
            for(my $i = 0; $i < scalar(@$filterList); $i++){
                $LayoutObject->Block(
                    Name => 'FilterResultRow',
                    Data => {
                        Type => $filterList->[$i]->{Type},
                        Field => $filterList->[$i]->{Field},
                        Condition => $filterList->[$i]->{Condition},
                        Content => $filterList->[$i]->{Content},
                        ID => $filterList->[$i]->{ID},
                        OcsPathId => $filterList->[$i]->{OcsPathId},
                        ClassId => $ClassId,
                    }
                );
            }
        }
    }

    if ($Self->{Subaction} eq 'AddComputerFilter' || $Self->{Subaction} eq 'SaveComputerFilter' || $Self->{Subaction} eq 'RemoveComputerFilter' ) {

        my $ID = $ParamObject->GetParam( Param => 'ID' )  || '';

        my $Description = "";
        if(!$ID || int($ID) == 0){
            $Description = "Raiz";
            $ID = undef;
        }
        else{
            my $ParentData  = $OcsIntegrationComputerObject->ComputerMappingGet(ID=>$ID);
            $Description = $ParentData->{OcsPath};
        }

        if($Self->{Subaction} eq 'SaveComputerFilter'){
            my $Type = $ParamObject->GetParam( Param => 'TypeFilter' )  || '';
            my $Field = $ParamObject->GetParam( Param => 'OcsField' )  || '';
            my $Condition = $ParamObject->GetParam( Param => 'Condition' )  || '';
            my $Content = $ParamObject->GetParam( Param => 'Content' )  || '';

            $OcsIntegrationComputerObject->ComputerFilterAdd(
                Type => $Type,
                Field => $Field,
                Condition => $Condition,
                Content => $Content,
                OcsPathId => $ID
            );
        }        

        if($Self->{Subaction} eq 'RemoveComputerFilter'){
            my $RemoveID = $ParamObject->GetParam( Param => 'RemoveID' )  || '';
            $OcsIntegrationComputerObject->ComputerFilterDelete(
                ID => $RemoveID
            );
        } 
        
        my %TypeFilterList;
        $TypeFilterList{ 'AND' } = 'AND';
        $TypeFilterList{ 'OR' } = 'OR';
        my %TypeFilterListReverse = reverse %TypeFilterList;

        my $FiltersValueData  = $OcsIntegrationComputerObject->ComputerMappingListToFilter(
            ParentId => $ID
        );
        my %OcsFieldList;
        for(my $i = 0; $i < scalar(@$FiltersValueData);$i++){
            $OcsFieldList{ $FiltersValueData->[$i]->{OcsPath} } = $FiltersValueData->[$i]->{OcsPath};
        }
        my %OcsFieldListReverse = reverse %OcsFieldList;

        my %ConditionList;
        $ConditionList{ '=' } = '=';
        $ConditionList{ '>' } = '>';
        $ConditionList{ '<' } = '<';
        $ConditionList{ '>=' } = '>=';
        $ConditionList{ '<=' } = '>=';
        $ConditionList{ '!=' } = '!=';
        $ConditionList{ 'contem' } = 'contem';
        $ConditionList{ 'nao contem' } = 'nao contem';
        my %ConditionListReverse = reverse %ConditionList;
        
        $LayoutObject->Block(
            Name => 'AddComputerFilter',
            Data => {
                ID => $ID,
                Description => $Description,
                TypeFilterOption => $LayoutObject->BuildSelection(
                    Data       => \%TypeFilterList,
                    Name       => 'TypeFilter',
                    SelectedID => $Param{TypeFilter} || $TypeFilterListReverse{TypeFilter},
                    Class      => 'Modernize Validate_Required ' . ( $Param{Errors}->{'TypeFilterInvalid'} || '' ),
                ),
                OcsFieldOption => $LayoutObject->BuildSelection(
                    Data       => \%OcsFieldList,
                    Name       => 'OcsField',
                    SelectedID => $Param{OcsField} || $OcsFieldListReverse{OcsField},
                    Class      => 'Modernize Validate_Required ' . ( $Param{Errors}->{'OcsFieldInvalid'} || '' ),
                ),
                ConditionOption => $LayoutObject->BuildSelection(
                    Data       => \%ConditionList,
                    Name       => 'Condition',
                    SelectedID => $Param{Condition} || $ConditionListReverse{Condition},
                    Class      => 'Modernize Validate_Required ' . ( $Param{Errors}->{'ConditionInvalid'} || '' ),
                ),
            }
        );


        my $filterList = $OcsIntegrationComputerObject->ComputerFilterList(OcsPathId=>$ID);
        if(scalar(@$filterList) == 0){
            $LayoutObject->Block(
                Name => 'NoDataFoundFilterComputerMsg',
            );
        }
        else{
            for(my $i = 0; $i < scalar(@$filterList); $i++){
                $LayoutObject->Block(
                    Name => 'FilterResultComputerRow',
                    Data => {
                        Type => $filterList->[$i]->{Type},
                        Field => $filterList->[$i]->{Field},
                        Condition => $filterList->[$i]->{Condition},
                        Content => $filterList->[$i]->{Content},
                        ID => $filterList->[$i]->{ID},
                        OcsPathId => $filterList->[$i]->{OcsPathId}
                    }
                );
            }
        }
    }

    if ( $Self->{Subaction} eq 'Computers' ) {
        $LayoutObject->Block(
            Name => 'Computers',
        );
    }

    $LayoutObject->Block(
        Name => 'ActionList',
    );
    
    

    # generate search mask
    my $Output = $LayoutObject->Header();
    $Output .= $LayoutObject->NavigationBar();
    $Output .= $LayoutObject->Output(
        TemplateFile => 'AdminOcsIntegration',
        Data         => \%Param,
    );
    $Output .= $LayoutObject->Footer();
    return $Output;
}

sub GenerateStructureSNMP{
    my ($snmpClassId) = @_;


    if(!$snmpClassId && $snmpClassId == 0){
        $snmpClassId = undef;
    }
    
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my $OcsIntegrationSnmpObject = $Kernel::OM->Get("Kernel::System::OcsIntegrationSnmp");

    my $ServerAddress = $ConfigObject->Get('OcsIntegration::ServerAddress');
    if (!$ServerAddress){
		return {
            result => "fail",
            message => "Endereço do servidor OCS não configurado",
            data => "",
        };
	}
    my $DoubleJsonDecode = $ConfigObject->Get('OcsIntegration::DoubleJsonDecode')||'0';
    my $User="";
    if ($ConfigObject->Get('OcsIntegration::Authentication')){
		$User = $ConfigObject->Get('OcsIntegration::Authentication')->{User};
	}
    my $Pass = "";
    if ($ConfigObject->Get('OcsIntegration::Authentication')){
		$Pass = $ConfigObject->Get('OcsIntegration::Authentication')->{Password};
	}

    my $snmps = $OcsIntegrationSnmpObject->GetSmnps(
        ServerAddress=>$ServerAddress,
        User=>$User,
        Pass=>$Pass,
        DoubleJsonDecode=>$DoubleJsonDecode,
    );

    $OcsIntegrationSnmpObject->SnmpMappingDeleteByClass(
        SnmpClassTypeId=>$snmpClassId
    );

    my $result="";
    while (my ($key, $value) = each (%$snmps)){
        $value->{"SNMP_OCS_ID"} = $key;
        my $parent;
        SaveSnmpStructure($value,$parent,$snmpClassId);
    }
    

    return {
        result => "success",
        data =>  $OcsIntegrationSnmpObject->SnmpMappingList(SnmpClassTypeId=>$snmpClassId),
    };
}

sub SaveSnmpStructure{
    my ($levelDefinition,$parent,$snmpClassId) = @_;    

    if(!$snmpClassId && $snmpClassId == 0){
        $snmpClassId = undef;
    }

    my $OcsIntegrationSnmpObject = $Kernel::OM->Get("Kernel::System::OcsIntegrationSnmp");

    my $parentData;
    if($parent){
        $parentData = $OcsIntegrationSnmpObject->SnmpMappingGetByPath(OcsPath=>$parent,SnmpClassTypeId=>$snmpClassId);
    }    

    my $parentPath = "";
    my $parentPathN = "";
    my $parentName = "";
    my $parentId;
    my $parParentId;
    my $parentOrder = 0;
    if($parentData){
        $parentName = $parentData->{OcsField};
        $parentPathN = $parentData->{OcsPath};
        $parentPath = $parentData->{OcsPath}."::";
        $parentId = $parentData->{ID};
        $parParentId = $parentData->{ParentId};
        $parentOrder = $parentData->{Order};
    }

    if(ref $levelDefinition eq 'ARRAY'){
        for(my $i = 0; $i < (scalar @$levelDefinition);$i++){
            SaveSnmpStructure($levelDefinition->[$i],$parentPathN,$snmpClassId)
        }
    }

    if(ref $levelDefinition eq '' && $parentPathN ne ""){
            my $hashParent = $OcsIntegrationSnmpObject->SnmpMappingGetByPath(OcsPath=>$parentPathN,SnmpClassTypeId=>$snmpClassId);
            my $active = 0;

            if($parentName eq 'SNMP_OCS_ID'){
                $active = 1;
            }

            if(!$hashParent){
                my $ID = $OcsIntegrationSnmpObject->SnmpMappingAdd(
                    Active => $active,
                    KeyField => 0,
                    OcsField => $parentName,
                    OcsPath => $parentPathN,
                    ParentId => $parParentId,
                    Type => 'detail',
                    SnmpClassTypeId => $snmpClassId,
                    Order => $parentOrder+1,
                );

                $hashParent = $OcsIntegrationSnmpObject->SnmpMappingGet(ID=>$ID);
            }
            else{
                $OcsIntegrationSnmpObject->SnmpMappingUpdate(
                    ID => $hashParent->{ID},
                    Active => $active,
                    KeyField => 0,
                    OcsField => $parentName,
                    OcsPath => $parentPathN,
                    ParentId => $parParentId,
                    Type => 'detail',
                    Order => $hashParent->{Order},
                    SnmpClassTypeId => $snmpClassId,
                );
            }
        
    }
    else{
        if(ref $levelDefinition eq 'HASH'){
            while (my ($key, $value) = each (%$levelDefinition)){
                if($key ne ""){
                    my $hashParent = $OcsIntegrationSnmpObject->SnmpMappingGetByPath(OcsPath=>$parentPath.$key,SnmpClassTypeId=>$snmpClassId);
                    my $type = "";
                    if(ref $value eq 'ARRAY'){
                        $type = "objectlist";
                    }
                    else{
                        if(ref $value eq 'HASH'){
                            $type = "master";
                        }
                        else{
                            $type = "detail";
                        }
                    }
                    my $active = 0;

                    if($key eq 'SNMP_OCS_ID'){
                        $active = 1;
                    }
                    if(!$hashParent){
                        my $ID = $OcsIntegrationSnmpObject->SnmpMappingAdd(
                            Active => $active,
                            KeyField => 0,
                            OcsField => $key,
                            OcsPath => $parentPath.$key,
                            ParentId => $parentId,
                            Type => $type,
                            SnmpClassTypeId => $snmpClassId,
                            Order => $parentOrder+1,
                        );

                        $hashParent = $OcsIntegrationSnmpObject->SnmpMappingGet(ID=>$ID);
                    }
                    else{
                        $OcsIntegrationSnmpObject->SnmpMappingUpdate(
                            ID => $hashParent->{ID},
                            Active => $active,
                            KeyField => 0,
                            OcsField => $key,
                            OcsPath => $parentPath.$key,
                            ParentId => $parentId,
                            Type => $type,
                            Order => $hashParent->{Order},
                            SnmpClassTypeId => $snmpClassId,
                        );
                    }
                }   
                if(ref $value eq 'ARRAY'){
                    for(my $i = 0; $i < (scalar @$value);$i++){
                        SaveSnmpStructure($value->[$i],$parentPath.$key,$snmpClassId)
                    }
                }
                else{
                    SaveSnmpStructure($value,$parentPath.$key,$snmpClassId)
                }                
            }
        }
    }    
}

sub GenerateStructureComputer{
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my $OcsIntegrationComputerObject = $Kernel::OM->Get("Kernel::System::OcsIntegrationComputer");

    my $ServerAddress = $ConfigObject->Get('OcsIntegration::ServerAddress');
    if (!$ServerAddress){
		return {
            result => "fail",
            message => "Endereço do servidor OCS não configurado",
            data => "",
        };
	}
    my $DoubleJsonDecode = $ConfigObject->Get('OcsIntegration::DoubleJsonDecode')||'0';
    my $User="";
    if ($ConfigObject->Get('OcsIntegration::Authentication')){
		$User = $ConfigObject->Get('OcsIntegration::Authentication')->{User};
	}
    my $Pass = "";
    if ($ConfigObject->Get('OcsIntegration::Authentication')){
		$Pass = $ConfigObject->Get('OcsIntegration::Authentication')->{Password};
	}

    my $computers = $OcsIntegrationComputerObject->GetComputers(
        ServerAddress=>$ServerAddress,
        User=>$User,
        Pass=>$Pass,
        DoubleJsonDecode=>$DoubleJsonDecode,
    );

    $OcsIntegrationComputerObject->ComputerMappingDeleteAll();

    my $result="";
    while (my ($key, $value) = each (%$computers)){
        $value->{"COMPUTER_OCS_ID"} = $key;
        my $parent;
        SaveComputerStructure($value,$parent);
    }
    

    return {
        result => "success",
        data =>  $OcsIntegrationComputerObject->ComputerMappingList(),
    };
}

sub SaveComputerStructure{
    my ($levelDefinition,$parent) = @_;

    my $OcsIntegrationComputerObject = $Kernel::OM->Get("Kernel::System::OcsIntegrationComputer");

    my $parentData;
    if($parent){
        $parentData = $OcsIntegrationComputerObject->ComputerMappingGetByPath(OcsPath=>$parent);
    }    

    my $parentPath = "";
    my $parentPathN = "";
    my $parentName = "";
    my $parentId;
    my $parParentId;
    my $parentOrder = 0;
    if($parentData){
        $parentName = $parentData->{OcsField};
        $parentPathN = $parentData->{OcsPath};
        $parentPath = $parentData->{OcsPath}."::";
        $parentId = $parentData->{ID};
        $parParentId = $parentData->{ParentId};
        $parentOrder = $parentData->{Order};
    }

    if(ref $levelDefinition eq 'ARRAY'){
        for(my $i = 0; $i < (scalar @$levelDefinition);$i++){
            SaveComputerStructure($levelDefinition->[$i],$parentPathN)
        }
    }

    if(ref $levelDefinition eq '' && $parentPathN ne ""){
            my $hashParent = $OcsIntegrationComputerObject->ComputerMappingGetByPath(OcsPath=>$parentPathN);
            my $active = 0;

            if($parentName eq 'COMPUTER_OCS_ID'){
                $active = 1;
            }

            if(!$hashParent){
                my $ID = $OcsIntegrationComputerObject->ComputerMappingAdd(
                    Active => $active,
                    KeyField => 0,
                    OcsField => $parentName,
                    OcsPath => $parentPathN,
                    ParentId => $parParentId,
                    Type => 'detail',
                    Order => $parentOrder+1,
                );

                $hashParent = $OcsIntegrationComputerObject->ComputerMappingGet(ID=>$ID);
            }
            else{
                $OcsIntegrationComputerObject->ComputerMappingUpdate(
                    ID => $hashParent->{ID},
                    Active => $active,
                    KeyField => 0,
                    OcsField => $parentName,
                    OcsPath => $parentPathN,
                    ParentId => $parParentId,
                    Type => 'detail',
                    Order => $hashParent->{Order},
                );
            }
        
    }
    else{
        if(ref $levelDefinition eq 'HASH'){
            while (my ($key, $value) = each (%$levelDefinition)){
                if($key ne ""){
                    my $hashParent = $OcsIntegrationComputerObject->ComputerMappingGetByPath(OcsPath=>$parentPath.$key);
                    my $type = "";
                    if(ref $value eq 'ARRAY'){
                        $type = "objectlist";
                    }
                    else{
                        if(ref $value eq 'HASH'){
                            $type = "master";
                        }
                        else{
                            $type = "detail";
                        }
                    }
                    my $active = 0;

                    if($key eq 'COMPUTER_OCS_ID'){
                        $active = 1;
                    }
                    if(!$hashParent){
                        my $ID = $OcsIntegrationComputerObject->ComputerMappingAdd(
                            Active => $active,
                            KeyField => 0,
                            OcsField => $key,
                            OcsPath => $parentPath.$key,
                            ParentId => $parentId,
                            Type => $type,
                            Order => $parentOrder+1,
                        );

                        $hashParent = $OcsIntegrationComputerObject->ComputerMappingGet(ID=>$ID);
                    }
                    else{
                        $OcsIntegrationComputerObject->ComputerMappingUpdate(
                            ID => $hashParent->{ID},
                            Active => $active,
                            KeyField => 0,
                            OcsField => $key,
                            OcsPath => $parentPath.$key,
                            ParentId => $parentId,
                            Type => $type,
                            Order => $hashParent->{Order},
                        );
                    }
                }   
                if(ref $value eq 'ARRAY'){
                    for(my $i = 0; $i < (scalar @$value);$i++){
                        SaveComputerStructure($value->[$i],$parentPath.$key)
                    }
                }
                else{
                    SaveComputerStructure($value,$parentPath.$key)
                }                
            }
        }
    }    
}



1;
