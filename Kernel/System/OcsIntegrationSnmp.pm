# --
# Kernel/System/AutoTicket.pm - lib for auto tickets
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: AutoTicket.pm,v 1.2 2011/03/15 23:04:51 ep Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::OcsIntegrationSnmp;
use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Encode',
    'Kernel::System::Cache',
    'Kernel::System::DB',
    'Kernel::System::Group',
    'Kernel::System::Log',
    'Kernel::System::Valid',
    'Kernel::System::WebUserAgent',
    'Kernel::System::JSON',
);


sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    $Self->{ConfigObject}   = $Kernel::OM->Get('Kernel::Config');
    $Self->{LogObject}      = $Kernel::OM->Get('Kernel::System::Log');
    $Self->{DBObject}       = $Kernel::OM->Get('Kernel::System::DB');
    $Self->{EncodeObject}   = $Kernel::OM->Get('Kernel::System::Encode');
    $Self->{ValidObject}    = $Kernel::OM->Get('Kernel::System::Valid');

    return $Self;
}


sub SnmpTypeToOtrsClassAdd {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(OcsType OtrsClass)) {
        if ( !defined( $Param{$_} ) ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # +------------+--------------+------+-----+---------+----------------+
	#| Field      | Type         | Null | Key | Default | Extra          |
	#+------------+--------------+------+-----+---------+----------------+
	#| id         | int(11)      | NO   | PRI | NULL    | auto_increment |
	#| ocsType	  | varchar(255) | NO	| 	  | Null	| 				 |
	#| otrsClass  | varchar(255) | NO   |     | NULL    |                |
	#+------------+--------------+------+-----+---------+----------------+
	#sql
	my $ocsType	   = $Param{OcsType};
	my $otrsClas = $Param{OtrsClass};
	my $existName;
	return if  !$Self->{DBObject}->Prepare(
		SQL => 'SELECT ocsType FROM ocsIntegrationSnmpClassesType WHERE ocsType = ?',
		Bind => [\$ocsType,],
	);
	while ( my @Row = $Self->{DBObject}->FetchrowArray()){
		$existName = $Row[0];
	}
	if($existName){
		return ;
	}
    return if !$Self->{DBObject}->Do(
        SQL => 'insert into ocsIntegrationSnmpClassesType  ('
            . ' ocsType, otrsClass )'
            . ' VALUES (?,?)',
        Bind => [
            \$ocsType,\$otrsClas,
        ],
    );
    # sql
    my $ID;
    return if !$Self->{DBObject}->Prepare(
        SQL => 'SELECT id FROM ocsIntegrationSnmpClassesType WHERE ocsType = ?',
        Bind => [ \$ocsType, ],
    );
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $ID = $Row[0];
    }
    
   
    return $ID;
}


sub SnmpTypeToOtrsClassUpdate {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(ID OcsType OtrsClass)) {
        if ( !defined( $Param{$_} ) ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    my $existName;
	return 0 if  !$Self->{DBObject}->Prepare(
		SQL => 'SELECT ocsType FROM ocsIntegrationSnmpClassesType WHERE ocsType = ? and ID <> ?',
		Bind => [\$Param{OcsType},\$Param{ID}],
	);
	while ( my @Row = $Self->{DBObject}->FetchrowArray()){
		$existName = $Row[0];
	}
	if($existName){
		return 0;
	}

    # sql
    return if !$Self->{DBObject}->Do(
        SQL => ' UPDATE ocsIntegrationSnmpClassesType SET '
        	.' ocsType = ? ,'
        	.' otrsClass = ? '
            . ' WHERE id = ? ',
        Bind => [
            \$Param{OcsType}, \$Param{OtrsClass},
            \$Param{ID},
        ],
    );

    return 1;
}

sub SnmpTypeToOtrsClassDelete {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{ID} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need ID!' );
        return;
    }


    # sql
    return if !$Self->{DBObject}->Do(
        SQL  => 'DELETE FROM ocsIntegrationSnmpClassesType WHERE id = ?',
        Bind => [ \$Param{ID} ],
    );
    return 1;
}

sub SnmpTypeToOtrsClassGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{ID} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need ID!' );
        return;
    }

    # sql
    return if !$Self->{DBObject}->Prepare(
        SQL => 'SELECT ocsType,
				otrsClass
            	FROM ocsIntegrationSnmpClassesType WHERE id = ?',
        Bind => [ \$Param{ID} ],
    );
    my $RetData;
    
    while ( my @Data = $Self->{DBObject}->FetchrowArray() ) {
        $RetData = {
            ID            => $Param{ID},
            OcsType          => $Data[0],
            OtrsClass     => $Data[1],
        };
    }

    return $RetData;
}

sub SnmpTypeToOtrsClassList {
    my ( $Self, %Param ) = @_;

    # sql
    return if !$Self->{DBObject}->Prepare(
        SQL => 'SELECT 
                id,
                ocsType,
				otrsClass
            	FROM ocsIntegrationSnmpClassesType',                
    );
    my $RetData = [];
    
    while ( my @Data = $Self->{DBObject}->FetchrowArray() ) {
        push @{ $RetData },{
            ID            => $Data[0],
            OcsType          => $Data[1],
            OtrsClass     => $Data[2],
        };
    }

    return $RetData;
}

#MAPPING CRUD

sub SnmpMappingAdd {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Active KeyField OcsField OcsPath Type)) {
        if ( !defined( $Param{$_} ) ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # +----------------+--------------+------+-----+---------+----------------+
	#| Field           | Type         | Null | Key | Default | Extra          |
	#+-----------------+--------------+------+-----+---------+----------------+
	#| id              | int(11)      | NO   | PRI | NULL    | auto_increment |
	#| active	       | smallint     | NO   | 	   | Null	 | 				  |
	#| key_field       | smallint     | NO   | 	   | Null	 | 				  |
	#| it_order	       | int(11)      | NO   | 	   | Null	 | 				  |
	#| it_type	       | varchar(50)  | NO   | 	   | Null	 | 				  |
	#| ocsField        | varchar(255) | NO   |     | NULL    |                |
   	#| ocsPath         | varchar(255) | NO   |     | NULL    |                |
	#| otrsTranslate   | varchar(255) | YES  |     | NULL    |                |
	#| parentId        | int(11)      | YES  |     | NULL    |                |
	#| snmpClassTypeId | int(11)      | YES  |     | NULL    |                |
	#+-----------------+--------------+------+-----+---------+----------------+
	#sql
    
	my $existName;
    if($Param{SnmpClassTypeId}){
        return if  !$Self->{DBObject}->Prepare(
            SQL => 'SELECT ocsPath FROM ocsIntegrationSnmpMapping WHERE ocsPath = ? AND snmpClassTypeId = ?',
            Bind => [\$Param{ocsPath},\$Param{SnmpClassTypeId},],
        );
        while ( my @Row = $Self->{DBObject}->FetchrowArray()){
            $existName = $Row[0];
        }
    }
    else{
        return if  !$Self->{DBObject}->Prepare(
            SQL => 'SELECT ocsPath FROM ocsIntegrationSnmpMapping WHERE ocsPath = ? AND snmpClassTypeId IS NULL',
            Bind => [\$Param{ocsPath},],
        );
        while ( my @Row = $Self->{DBObject}->FetchrowArray()){
            $existName = $Row[0];
        }
    }
	
	if($existName){
		return ;
	}

    #GET LAST ORDER
    my $filter;
    my $filterValues = [];
    my $LastOrder = 0;
    if($Param{ParentId}){
        return if !$Self->{DBObject}->Prepare(
            SQL => 'SELECT MAX(it_order) FROM ocsIntegrationSnmpMapping WHERE parentId = ?',
            Bind => [\$Param{ParentId}],
        );
        while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
            if($Row[0]){
                $LastOrder = $Row[0];
            }        
        }
    }
    
    if(!$Param{ParentId} || $LastOrder == 0){
        $filterValues = [];
        if($Param{SnmpClassTypeId}){
            $filter = 'snmpClassTypeId = ?';
            push @{ $filterValues },\$Param{SnmpClassTypeId};
        }
        else{
            $filter = 'snmpClassTypeId IS NULL';
        }
        
        return if !$Self->{DBObject}->Prepare(
            SQL => 'SELECT MAX(it_order) FROM ocsIntegrationSnmpMapping WHERE '.$filter,
            Bind => $filterValues,
        );
        while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
            if($Row[0]){
                $LastOrder = $Row[0];
            }        
        }
    }

    #Update ORDERS
    if($LastOrder > 0){
        $filterValues = [];
        push @{ $filterValues },\$LastOrder;
        if($Param{SnmpClassTypeId}){
            $filter = 'snmpClassTypeId = ?';
            
            push @{ $filterValues },\$Param{SnmpClassTypeId};
        }
        else{
            $filter = 'snmpClassTypeId IS NULL';
        }

        return if !$Self->{DBObject}->Do(
            SQL => 'UPDATE ocsIntegrationSnmpMapping '.
                    'SET it_order = (it_order+1) WHERE it_order > ? AND '.$filter,
            Bind => $filterValues,
        );
    }
    

    $LastOrder = $LastOrder+1;

    return if !$Self->{DBObject}->Do(
        SQL => 'insert into ocsIntegrationSnmpMapping  ('
            . ' active, key_field, it_order, it_type, ocsField, ocsPath, otrsTranslate, parentId, snmpClassTypeId )'
            . ' VALUES (?,?,?,?,?,?,?,?,?)',
        Bind => [
            \$Param{Active},\$Param{KeyField},\$LastOrder,\$Param{Type},\$Param{OcsField},\$Param{OcsPath},\$Param{OtrsTranslate},\$Param{ParentId},\$Param{SnmpClassTypeId},
        ],
    );
    # sql
    my $ID;
    if($Param{SnmpClassTypeId}){
        return if !$Self->{DBObject}->Prepare(
            SQL => 'SELECT id FROM ocsIntegrationSnmpMapping WHERE ocsField = ? AND snmpClassTypeId = ?',
            Bind => [ \$Param{OcsField},\$Param{SnmpClassTypeId}, ],
        );
        while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
            $ID = $Row[0];
        }
    }
    else{
        return if !$Self->{DBObject}->Prepare(
            SQL => 'SELECT id FROM ocsIntegrationSnmpMapping WHERE ocsField = ? AND snmpClassTypeId IS NULL',
            Bind => [ \$Param{OcsField}, ],
        );
        while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
            $ID = $Row[0];
        }
    }
    
   
    return $ID;
}

sub SnmpMappingUpdate {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(ID Active KeyField OcsField OcsPath Type)) {
        if ( !defined( $Param{$_} ) ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    my $existName;
    if($Param{SnmpClassTypeId}){
        return 0 if  !$Self->{DBObject}->Prepare(
            SQL => 'SELECT ocsPath FROM ocsIntegrationSnmpMapping WHERE ocsPath = ? AND snmpClassTypeId = ? and ID <> ?',
            Bind => [\$Param{OcsPath},\$Param{SnmpClassTypeId},\$Param{ID},],
        );
        while ( my @Row = $Self->{DBObject}->FetchrowArray()){
            $existName = $Row[0];
        }
    }
    else{
        return 0 if  !$Self->{DBObject}->Prepare(
            SQL => 'SELECT ocsPath FROM ocsIntegrationSnmpMapping WHERE ocsPath = ? AND snmpClassTypeId IS NULL and ID <> ?',
            Bind => [\$Param{OcsPath},\$Param{ID},],
        );
        while ( my @Row = $Self->{DBObject}->FetchrowArray()){
            $existName = $Row[0];
        }
    }
	
	if($existName){
		return 0;
	}

    # sql
    return if !$Self->{DBObject}->Do(
        SQL => ' UPDATE ocsIntegrationSnmpMapping SET '
        	.' active = ? ,'
        	.' key_field = ? ,'
        	.' it_order = ? ,'
        	.' it_type = ? ,'
        	.' ocsField = ? ,'
        	.' ocsPath = ? ,'
        	.' otrsTranslate = ? ,'
        	.' parentId = ? ,'
        	.' snmpClassTypeId = ? '
            . ' WHERE id = ? ',
        Bind => [
            \$Param{Active},\$Param{KeyField},\$Param{Order},\$Param{Type},\$Param{OcsField},\$Param{OcsPath},\$Param{OtrsTranslate},\$Param{ParentId},\$Param{SnmpClassTypeId},
            \$Param{ID},
        ],
    );

    return 1;
}

sub SnmpMappingDelete {
    my ( $Self, %Param ) = @_;    

    # check needed stuff
    if ( !$Param{ID} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need ID!' );
        return;
    }

    my $Childs = $Self->SnmpMappingListByParent(ParentId => $Param{ID});

    for(my $i = 0 ; $i < scalar(@$Childs); $i++){
        $Self->SnmpMappingDelete(ID => $Childs->[$i]->{ID});
    }


    # sql
    return if !$Self->{DBObject}->Do(
        SQL  => 'DELETE FROM ocsIntegrationSnmpMapping WHERE id = ?',
        Bind => [ \$Param{ID} ],
    );
    return 1;
}

sub SnmpMappingDeleteByClass {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    my $filter;
    my $filterValues = [];
    if($Param{SnmpClassTypeId}){
        $filter = 'snmpClassTypeId = ?';
        push @{ $filterValues },\$Param{SnmpClassTypeId};
    }
    else{
        $filter = 'snmpClassTypeId IS NULL';
    }


    # sql
    return if !$Self->{DBObject}->Do(
        SQL  => 'DELETE FROM ocsIntegrationSnmpMapping WHERE parentId is not null and '.$filter,
        Bind => $filterValues,
    );

    return if !$Self->{DBObject}->Do(
        SQL  => 'DELETE FROM ocsIntegrationSnmpMapping WHERE '.$filter,
        Bind => $filterValues,
    );
    return 1;
}

sub SnmpMappingGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{ID} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need ID!' );
        return;
    }

    # sql
    return if !$Self->{DBObject}->Prepare(
        SQL => 'SELECT active,
                key_field,
                it_order,
                it_type,
				ocsField,
                ocsPath,
                otrsTranslate,
                parentId,
                snmpClassTypeId
            	FROM ocsIntegrationSnmpMapping WHERE id = ?',
        Bind => [ \$Param{ID} ],
    );
    my $RetData;
    
    while ( my @Data = $Self->{DBObject}->FetchrowArray() ) {
        $RetData = {
            ID              => $Param{ID},
            Active          => $Data[0],
            KeyField        => $Data[1],
            Order           => $Data[2],
            Type            => $Data[3],
            OcsField        => $Data[4],
            OcsPath         => $Data[5],
            OtrsTranslate   => $Data[6],
            ParentId        => $Data[7],
            SnmpClassTypeId => $Data[8],
        };
    }

    return $RetData;
}

sub SnmpMappingGetByPath {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{OcsPath} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need OcsPath!' );
        return;
    }

    #GET LAST ORDER
    my $filter;
    my $filterValues = [];
    if($Param{SnmpClassTypeId}){
        $filter = 'snmpClassTypeId = ?';
        push @{ $filterValues },\$Param{OcsPath};
        push @{ $filterValues },\$Param{SnmpClassTypeId};
    }
    else{
        $filter = 'snmpClassTypeId IS NULL';
        push @{ $filterValues },\$Param{OcsPath};
    }

    # sql
    return if !$Self->{DBObject}->Prepare(
        SQL => 'SELECT id,
                active,
                key_field,
                it_order,
                it_type,
				ocsField,
                ocsPath,
                otrsTranslate,
                parentId,
                snmpClassTypeId
            	FROM ocsIntegrationSnmpMapping WHERE ocsPath = ? AND '.$filter,
        Bind => $filterValues,
    );
    my $RetData;
    
    while ( my @Data = $Self->{DBObject}->FetchrowArray() ) {
        $RetData = {
            ID              => $Data[0],
            Active          => $Data[1],
            KeyField        => $Data[2],
            Order           => $Data[3],
            Type            => $Data[4],
            OcsField        => $Data[5],
            OcsPath         => $Data[6],
            OtrsTranslate   => $Data[7],
            ParentId        => $Data[8],
            SnmpClassTypeId => $Data[9],
        };
    }

    return $RetData;
}

sub SnmpMappingList {
    my ( $Self, %Param ) = @_;

    # sql
    if($Param{SnmpClassTypeId}){
        return if !$Self->{DBObject}->Prepare(
            SQL => 'SELECT id,
                    active,
                    key_field,
                    it_order,
                    it_type,
                    ocsField,
                    ocsPath,
                    otrsTranslate,
                    parentId,
                    snmpClassTypeId
                    FROM ocsIntegrationSnmpMapping WHERE snmpClassTypeId = ? order by it_order',
            Bind => [ \$Param{SnmpClassTypeId} ]
        );
    }
    else{
        return if !$Self->{DBObject}->Prepare(
            SQL => 'SELECT id,
                    active,
                    key_field,
                    it_order,
                    it_type,
                    ocsField,
                    ocsPath,
                    otrsTranslate,
                    parentId,
                    snmpClassTypeId
                    FROM ocsIntegrationSnmpMapping WHERE snmpClassTypeId IS NULL order by it_order',
        );
    }
    
    my $RetData = [];
    
    while ( my @Data = $Self->{DBObject}->FetchrowArray() ) {
        push @{ $RetData } , {
            ID              => $Data[0],
            Active          => $Data[1],
            KeyField        => $Data[2],
            Order           => $Data[3],
            Type            => $Data[4],
            OcsField        => $Data[5],
            OcsPath         => $Data[6],
            OtrsTranslate   => $Data[7],
            ParentId        => $Data[8],
            SnmpClassTypeId => $Data[9],
        };
    }

    return $RetData;
}

sub SnmpMappingListToFilter {
    my ( $Self, %Param ) = @_;

    my $filter;
    my $filterValues = [];
    if($Param{SnmpClassTypeId}){
        $filter = 'snmpClassTypeId = ?';
        push @{ $filterValues },\$Param{SnmpClassTypeId};
    }
    else{
        $filter = 'snmpClassTypeId IS NULL';
    }

    if($Param{ParentId}){
        $filter = $filter.' AND parentId = ?';
        
        push @{ $filterValues },\$Param{ParentId};
    }

    return if !$Self->{DBObject}->Prepare(
        SQL => 'SELECT id,
                active,
                key_field,
                it_order,
                it_type,
                ocsField,
                ocsPath,
                otrsTranslate,
                parentId,
                snmpClassTypeId
                FROM ocsIntegrationSnmpMapping WHERE '.$filter.' and it_type in (\'detail\',\'simplelist\') order by it_order',
        Bind => $filterValues
    );
    
    
    my $RetData = [];
    
    while ( my @Data = $Self->{DBObject}->FetchrowArray() ) {
        push @{ $RetData } , {
            ID              => $Data[0],
            Active          => $Data[1],
            KeyField        => $Data[2],
            Order           => $Data[3],
            Type            => $Data[4],
            OcsField        => $Data[5],
            OcsPath         => $Data[6],
            OtrsTranslate   => $Data[7],
            ParentId        => $Data[8],
            SnmpClassTypeId => $Data[9],
        };
    }

    return $RetData;
}

sub SnmpMappingActiveList {
    my ( $Self, %Param ) = @_;

    my $filter;
    my $filterValues = [];
    if($Param{SnmpClassTypeId}){
        $filter = 'snmpClassTypeId = ?';
        push @{ $filterValues },\$Param{SnmpClassTypeId};
    }
    else{
        $filter = 'snmpClassTypeId IS NULL';
    }

    if($Param{ParentId}){
        $filter = $filter.' AND parentId = ?';
        
        push @{ $filterValues },\$Param{ParentId};
    }
    else{
        $filter = $filter.' AND parentId IS NULL';
    }

    return if !$Self->{DBObject}->Prepare(
        SQL => 'SELECT id,
                active,
                key_field,
                it_order,
                it_type,
                ocsField,
                ocsPath,
                otrsTranslate,
                parentId,
                snmpClassTypeId
                FROM ocsIntegrationSnmpMapping WHERE '.$filter.' and Active = 1 order by it_order',
        Bind => $filterValues
    );
    
    
    my $RetData = [];
    
    while ( my @Data = $Self->{DBObject}->FetchrowArray() ) {
        push @{ $RetData } , {
            ID              => $Data[0],
            Active          => $Data[1],
            KeyField        => $Data[2],
            Order           => $Data[3],
            Type            => $Data[4],
            OcsField        => $Data[5],
            OcsPath         => $Data[6],
            OtrsTranslate   => $Data[7],
            ParentId        => $Data[8],
            SnmpClassTypeId => $Data[9],
        };
    }

    return $RetData;
}

sub SnmpMappingKeyFieldList {
    my ( $Self, %Param ) = @_;

    my $filter;
    my $filterValues = [];
    if($Param{SnmpClassTypeId}){
        $filter = 'snmpClassTypeId = ?';
        push @{ $filterValues },\$Param{SnmpClassTypeId};
    }
    else{
        $filter = 'snmpClassTypeId IS NULL';
    }

    return if !$Self->{DBObject}->Prepare(
        SQL => 'SELECT 
                ocsPath
                FROM ocsIntegrationSnmpMapping WHERE '.$filter.' and Active = 1 and key_field = 1 order by it_order',
        Bind => $filterValues
    );
    
    
    my $RetData = [];
    
    while ( my @Data = $Self->{DBObject}->FetchrowArray() ) {
        push @{ $RetData } , $Data[0];
    }

    return $RetData;
}

sub SnmpMappingListByParent {
    my ( $Self, %Param ) = @_;
    
    return if !$Self->{DBObject}->Prepare(
        SQL => 'SELECT id,
                active,
                key_field,
                it_order,
                it_type,
                ocsField,
                ocsPath,
                otrsTranslate,
                parentId,
                snmpClassTypeId
                FROM ocsIntegrationSnmpMapping WHERE parentId = ?',
        Bind => [ \$Param{ParentId} ]
    );
    
    
    my $RetData = [];
    
    while ( my @Data = $Self->{DBObject}->FetchrowArray() ) {
        push @{ $RetData } , {
            ID              => $Data[0],
            Active          => $Data[1],
            KeyField        => $Data[2],
            Order           => $Data[3],
            Type            => $Data[4],
            OcsField        => $Data[5],
            OcsPath         => $Data[6],
            OtrsTranslate   => $Data[7],
            ParentId        => $Data[8],
            SnmpClassTypeId => $Data[9],
        };
    }

    return $RetData;
}

#FILTER CRUD

sub SnmpFilterAdd {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Type Field Condition Content)) {
        if ( !defined( $Param{$_} ) ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # +----------------+--------------+------+-----+---------+----------------+
	#| Field           | Type         | Null | Key | Default | Extra          |
	#+-----------------+--------------+------+-----+---------+----------------+
	#| id              | int(11)      | NO   | PRI | NULL    | auto_increment |
	#| type 	       | varchar(20)  | NO   | 	   | Null	 | 				  |
	#| field           | varchar(250) | NO   |     | NULL    |                |
   	#| condition_filter| varchar(20)  | NO   |     | NULL    |                |
	#| content         | varchar(250) | NO   |     | NULL    |                |
	#| ocsPathId       | int(11)      | YES  |     | NULL    |                |
    #| snmpClassTypeId | int(11)      | YES  |     | NULL    |                |
	#+-----------------+--------------+------+-----+---------+----------------+
	#sql

    my $filter;
    my $filterValues = [];
    if($Param{Field}){
        $filter = 'field = ?';
        push @{ $filterValues },\$Param{Field};
    }
    else{
        $filter = 'field IS NULL';
    }

    if($Param{OcsPathId}){
        $filter = $filter.' AND ocsPathId = ?';
        
        push @{ $filterValues },\$Param{OcsPathId};
    }
    else{
        $filter = $filter.' AND ocsPathId IS NULL';
    }

    if($Param{Type}){
        $filter = $filter.' AND type = ?';
        
        push @{ $filterValues },\$Param{Type};
    }
    else{
        $filter = $filter.' AND type IS NULL';
    }

    if($Param{Content}){
        $filter = $filter.' AND content = ?';
        
        push @{ $filterValues },\$Param{Content};
    }
    else{
        $filter = $filter.' AND content IS NULL';
    }

    if($Param{Condition}){
        $filter = $filter.' AND condition_filter = ?';
        
        push @{ $filterValues },\$Param{Condition};
    }
    else{
        $filter = $filter.' AND condition_filter IS NULL';
    }

    if($Param{SnmpClassTypeId}){
        $filter = $filter.' AND snmpClassTypeId = ?';
        
        push @{ $filterValues },\$Param{SnmpClassTypeId};
    }
    else{
        $filter = $filter.' AND snmpClassTypeId IS NULL';
    }
    
	my $existName;
    return if  !$Self->{DBObject}->Prepare(
        SQL => 'SELECT id FROM ocsIntegrationSnmpFilter WHERE '.$filter,
        Bind => $filterValues,
    );
    while ( my @Row = $Self->{DBObject}->FetchrowArray()){
        $existName = $Row[0];
    }
	
	if($existName){
		return ;
	}
    return if !$Self->{DBObject}->Do(
        SQL => 'insert into ocsIntegrationSnmpFilter  ('
            . ' type, field, condition_filter, content, ocsPathId, snmpClassTypeId )'
            . ' VALUES (?,?,?,?,?,?)',
        Bind => [
            \$Param{Type},\$Param{Field},\$Param{Condition},\$Param{Content},\$Param{OcsPathId},\$Param{SnmpClassTypeId},
        ],
    );
    # sql
    my $ID;
    return if !$Self->{DBObject}->Prepare(
        SQL => 'SELECT id FROM ocsIntegrationSnmpFilter WHERE '.$filter,
        Bind => $filterValues,
    );
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $ID = $Row[0];
    }
    
   
    return $ID;
}

sub SnmpFilterUpdate {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(ID Type Field Condition Content)) {
        if ( !defined( $Param{$_} ) ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    my $filter;
    my $filterValues = [];
    if($Param{Field}){
        $filter = 'field = ?';
        push @{ $filterValues },\$Param{Field};
    }
    else{
        $filter = 'field IS NULL';
    }

    if($Param{OcsPathId}){
        $filter = $filter.' AND ocsPathId = ?';
        
        push @{ $filterValues },\$Param{OcsPathId};
    }
    else{
        $filter = $filter.' AND ocsPathId IS NULL';
    }

    if($Param{Type}){
        $filter = $filter.' AND type = ?';
        
        push @{ $filterValues },\$Param{Type};
    }
    else{
        $filter = $filter.' AND type IS NULL';
    }

    if($Param{Content}){
        $filter = $filter.' AND content = ?';
        
        push @{ $filterValues },\$Param{Content};
    }
    else{
        $filter = $filter.' AND content IS NULL';
    }

    if($Param{Condition}){
        $filter = $filter.' AND condition_filter = ?';
        
        push @{ $filterValues },\$Param{Condition};
    }
    else{
        $filter = $filter.' AND condition_filter IS NULL';
    }

    if($Param{SnmpClassTypeId}){
        $filter = $filter.' AND snmpClassTypeId = ?';
        
        push @{ $filterValues },\$Param{SnmpClassTypeId};
    }
    else{
        $filter = $filter.' AND snmpClassTypeId IS NULL';
    }

    push @{ $filterValues },\$Param{ID};

    my $existName;
    return 0 if  !$Self->{DBObject}->Prepare(
        SQL => 'SELECT id FROM ocsIntegrationSnmpFilter WHERE '.$filter.' and ID <> ?',
        Bind => $filterValues,
    );
    while ( my @Row = $Self->{DBObject}->FetchrowArray()){
        $existName = $Row[0];
    }
	
	if($existName){
		return 0;
	}

    # sql
    return if !$Self->{DBObject}->Do(
        SQL => ' UPDATE ocsIntegrationSnmpFilter SET '
        	.' type = ? ,'
        	.' field = ? ,'
        	.' condition_filter = ? ,'
        	.' content = ? ,'
        	.' ocsPathId = ?, '
            .' snmpClassTypeId = ? '
            . ' WHERE id = ? ',
        Bind => [
            \$Param{Type},\$Param{Field},\$Param{Condition},\$Param{Content},\$Param{OcsPathId},\$Param{SnmpClassTypeId},
            \$Param{ID},
        ],
    );

    return 1;
}

sub SnmpFilterDelete {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{ID} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need ID!' );
        return;
    }


    # sql
    return if !$Self->{DBObject}->Do(
        SQL  => 'DELETE FROM ocsIntegrationSnmpFilter WHERE id = ?',
        Bind => [ \$Param{ID} ],
    );
    return 1;
}

sub SnmpFilterGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{ID} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need ID!' );
        return;
    }

    # sql
    return if !$Self->{DBObject}->Prepare(
        SQL => 'SELECT type,
				field,
                condition_filter,
                content,
                ocsPathId,
                snmpClassTypeId
            	FROM ocsIntegrationSnmpFilter WHERE id = ?',
        Bind => [ \$Param{ID} ],
    );
    my $RetData;
    
    while ( my @Data = $Self->{DBObject}->FetchrowArray() ) {
        $RetData = {
            ID              => $Param{ID},
            Type            => $Data[0],
            Field           => $Data[1],
            Condition       => $Data[2],
            Content         => $Data[3],
            OcsPathId       => $Data[4],
            SnmpClassTypeId => $Data[5],
        };
    }

    return $RetData;
}

sub SnmpFilterList {
    my ( $Self, %Param ) = @_;

    my $filter;
    my $filterValues = [];
    if($Param{OcsPathId}){
        $filter = ' ocsPathId = ?';
        push @{ $filterValues },\$Param{OcsPathId};
    }
    else{
        $filter = 'ocsPathId IS NULL';
    }

    if($Param{Type}){
        $filter = $filter.' AND type = ?';
        
        push @{ $filterValues },\$Param{Type};
    }
    else{
        #$filter = $filter.' AND type IS NULL';
    }

    if($Param{SnmpClassTypeId}){
        $filter = $filter.' AND snmpClassTypeId = ?';
        push @{ $filterValues },\$Param{SnmpClassTypeId};
    }
    else{
        $filter = $filter.' AND snmpClassTypeId IS NULL';
    }

    # sql
    return if !$Self->{DBObject}->Prepare(
        SQL => 'SELECT id,
                type,
				field,
                condition_filter,
                content,
                ocsPathId,
                snmpClassTypeId
                FROM ocsIntegrationSnmpFilter WHERE '.$filter,
        Bind => $filterValues
    );
    
    my $RetData = [];
    
    while ( my @Data = $Self->{DBObject}->FetchrowArray() ) {
        push @{ $RetData } , {
            ID              => $Data[0],
            Type            => $Data[1],
            Field           => $Data[2],
            Condition       => $Data[3],
            Content         => $Data[4],
            OcsPathId       => $Data[5],
            snmpClassTypeId => $Data[6],
        };
    }

    return $RetData;
}

sub GetSmnps{ 
    my ( $Self, %Param ) = @_;
    my $ServerAddress = $Param{ServerAddress};
    my $User = $Param{User};
    my $Pass = $Param{Pass};
    my $Start = $Param{Start};
    my $PaginationSize = $Param{PaginationSize};
    my $DoubleJsonDecode = $Param{DoubleJsonDecode};

    if(!$Start){
        $Start = 0;
    }

    if(!$PaginationSize){
        $PaginationSize = 5;
    }

    my $WebUserAgentObject = $Kernel::OM->Get('Kernel::System::WebUserAgent');
    my $JSONObject = $Kernel::OM->Get('Kernel::System::JSON');

    my $url = "http://".$ServerAddress."/ocsapi/v1/snmp?start=".$Start."&limit=".$PaginationSize;

    my %Response = $WebUserAgentObject->Request(
        URL => $url,
        SkipSSLVerification => 1, # (optional)
        NoLog               => 1, # (optional)
        Credentials  => {
            User     => $User,
            Password => $Pass,
        }
    );

    my $ResponseData;

    if ( $Response{Status} ne '200 OK' ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'notice',
            Message  => "OcsIntegration - Can't connect to server - $Response{Status}",
        );

        return $ResponseData;
    }
    # check if we have content as a scalar ref
    if ( !$Response{Content} || ref $Response{Content} ne 'SCALAR' ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'notice',
            Message =>
                "OcsIntegration - No content received from public cloud service. Please try again later.'",
        );
        
        return $ResponseData;
    }

    $Kernel::OM->Get('Kernel::System::Encode')->EncodeInput(
        $Response{Content},
    );

    

    if(${ $Response{Content} } ne "null"){
        if ($DoubleJsonDecode eq '1' || $DoubleJsonDecode == 1){
            $ResponseData = $JSONObject->Decode(
                Data =>$JSONObject->Decode(
                Data => ${ $Response{Content} },
            ));
        } else {
            $ResponseData = $JSONObject->Decode(
                Data => ${ $Response{Content} },
            );
        }
    }

    return $ResponseData;
}