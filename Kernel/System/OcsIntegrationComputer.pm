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

package Kernel::System::OcsIntegrationComputer;
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

#MAPPING CRUD

sub ComputerMappingAdd {
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
	#+-----------------+--------------+------+-----+---------+----------------+
	#sql
    
	my $existName;
    return if  !$Self->{DBObject}->Prepare(
        SQL => 'SELECT ocsPath FROM ocsIntegrationComputerMapping WHERE ocsPath = ?',
        Bind => [\$Param{OcsPath},],
    );
    while ( my @Row = $Self->{DBObject}->FetchrowArray()){
        $existName = $Row[0];
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
            SQL => 'SELECT MAX(it_order) FROM ocsIntegrationComputerMapping WHERE parentId = ?',
            Bind => [\$Param{ParentId}],
        );
        while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
            if($Row[0]){
                $LastOrder = $Row[0];
            }        
        }
    }
    
    if(!$Param{ParentId} || $LastOrder == 0){
        
        return if !$Self->{DBObject}->Prepare(
            SQL => 'SELECT MAX(it_order) FROM ocsIntegrationComputerMapping',
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

        return if !$Self->{DBObject}->Do(
            SQL => 'UPDATE ocsIntegrationComputerMapping '.
                    'SET it_order = (it_order+1) WHERE it_order > ?',
            Bind => [\$LastOrder],
        );
    }
    

    $LastOrder = $LastOrder+1;

    return if !$Self->{DBObject}->Do(
        SQL => 'insert into ocsIntegrationComputerMapping  ('
            . ' active, key_field, it_order, it_type, ocsField, ocsPath, otrsTranslate, parentId )'
            . ' VALUES (?,?,?,?,?,?,?,?)',
        Bind => [
            \$Param{Active},\$Param{KeyField},\$LastOrder,\$Param{Type},\$Param{OcsField},\$Param{OcsPath},\$Param{OtrsTranslate},\$Param{ParentId},
        ],
    );
    # sql
    my $ID;
    return if !$Self->{DBObject}->Prepare(
        SQL => 'SELECT id FROM ocsIntegrationComputerMapping WHERE ocsField = ?',
        Bind => [ \$Param{OcsField}, ],
    );
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $ID = $Row[0];
    }
    
    return $ID;
}

sub ComputerMappingUpdate {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(ID Active KeyField OcsField OcsPath Type)) {
        if ( !defined( $Param{$_} ) ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    my $existName;
    return 0 if  !$Self->{DBObject}->Prepare(
        SQL => 'SELECT ocsPath FROM ocsIntegrationComputerMapping WHERE ocsPath = ? AND ID <> ?',
        Bind => [\$Param{OcsPath},\$Param{ID},],
    );
    while ( my @Row = $Self->{DBObject}->FetchrowArray()){
        $existName = $Row[0];
    }
	
	if($existName){
		return 0;
	}

    # sql
    return if !$Self->{DBObject}->Do(
        SQL => ' UPDATE ocsIntegrationComputerMapping SET '
        	.' active = ? ,'
        	.' key_field = ? ,'
        	.' it_order = ? ,'
        	.' it_type = ? ,'
        	.' ocsField = ? ,'
        	.' ocsPath = ? ,'
        	.' otrsTranslate = ? ,'
        	.' parentId = ? '
            . ' WHERE id = ? ',
        Bind => [
            \$Param{Active},\$Param{KeyField},\$Param{Order},\$Param{Type},\$Param{OcsField},\$Param{OcsPath},\$Param{OtrsTranslate},\$Param{ParentId},
            \$Param{ID},
        ],
    );

    return 1;
}

sub ComputerMappingDelete {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{ID} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need ID!' );
        return;
    }

    my $Childs = $Self->ComputerMappingListByParent(ParentId => $Param{ID});

    for(my $i = 0 ; $i < scalar(@$Childs); $i++){
        $Self->ComputerMappingDelete(ID => $Childs->[$i]->{ID});
    }


    # sql
    return if !$Self->{DBObject}->Do(
        SQL  => 'DELETE FROM ocsIntegrationComputerMapping WHERE id = ?',
        Bind => [ \$Param{ID} ],
    );
    return 1;
}

sub ComputerMappingListToFilter {
    my ( $Self, %Param ) = @_;

    my $filter;
    my $filterValues = [];

    if($Param{ParentId}){
        $filter = $filter.' and parentId = ?';
        
        push $filterValues,\$Param{ParentId};
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
                parentId
                FROM ocsIntegrationComputerMapping WHERE it_type in (\'detail\',\'simplelist\') '.$filter.' order by it_order',
        Bind => $filterValues
    );
    
    
    my $RetData = [];
    
    while ( my @Data = $Self->{DBObject}->FetchrowArray() ) {
        push $RetData , {
            ID              => $Data[0],
            Active          => $Data[1],
            KeyField        => $Data[2],
            Order           => $Data[3],
            Type            => $Data[4],
            OcsField        => $Data[5],
            OcsPath         => $Data[6],
            OtrsTranslate   => $Data[7],
            ParentId        => $Data[8],
        };
    }

    return $RetData;
}

sub ComputerMappingActiveList {
    my ( $Self, %Param ) = @_;

    my $filter;
    my $filterValues = [];

    if($Param{ParentId}){
        $filter = $filter.' parentId = ?';
        
        push $filterValues,\$Param{ParentId};
    }
    else{
        $filter = $filter.' parentId IS NULL';
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
                parentId
                FROM ocsIntegrationComputerMapping WHERE '.$filter.' and active = 1 order by it_order',
        Bind => $filterValues
    );
    
    
    my $RetData = [];
    
    while ( my @Data = $Self->{DBObject}->FetchrowArray() ) {
        push $RetData , {
            ID              => $Data[0],
            Active          => $Data[1],
            KeyField        => $Data[2],
            Order           => $Data[3],
            Type            => $Data[4],
            OcsField        => $Data[5],
            OcsPath         => $Data[6],
            OtrsTranslate   => $Data[7],
            ParentId        => $Data[8],
        };
    }

    return $RetData;
}

sub ComputerMappingListByParent {
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
                parentId
                FROM ocsIntegrationComputerMapping WHERE parentId = ?',
        Bind => [ \$Param{ParentId} ]
    );
    
    
    my $RetData = [];
    
    while ( my @Data = $Self->{DBObject}->FetchrowArray() ) {
        push $RetData , {
            ID              => $Data[0],
            Active          => $Data[1],
            KeyField        => $Data[2],
            Order           => $Data[3],
            Type            => $Data[4],
            OcsField        => $Data[5],
            OcsPath         => $Data[6],
            OtrsTranslate   => $Data[7],
            ParentId        => $Data[8],
        };
    }

    return $RetData;
}

sub ComputerMappingGet {
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
                parentId
            	FROM ocsIntegrationComputerMapping WHERE id = ?',
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
        };
    }

    return $RetData;
}

sub ComputerMappingList {
    my ( $Self, %Param ) = @_;

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
                parentId
                FROM ocsIntegrationComputerMapping order by it_order',
    );
    
    my $RetData = [];
    
    while ( my @Data = $Self->{DBObject}->FetchrowArray() ) {
        push $RetData , {
            ID              => $Data[0],
            Active          => $Data[1],
            KeyField        => $Data[2],
            Order           => $Data[3],
            Type            => $Data[4],
            OcsField        => $Data[5],
            OcsPath         => $Data[6],
            OtrsTranslate   => $Data[7],
            ParentId        => $Data[8],
        };
    }

    return $RetData;
}

#FILTER CRUD

sub ComputerFilterAdd {
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
	#+-----------------+--------------+------+-----+---------+----------------+
	#sql

    my $filter;
    my $filterValues = [];
    if($Param{Field}){
        $filter = 'field = ?';
        push $filterValues,\$Param{Field};
    }
    else{
        $filter = 'field IS NULL';
    }

    if($Param{OcsPathId}){
        $filter = $filter.' AND ocsPathId = ?';
        
        push $filterValues,\$Param{OcsPathId};
    }
    else{
        $filter = $filter.' AND ocsPathId IS NULL';
    }

    if($Param{Type}){
        $filter = $filter.' AND type = ?';
        
        push $filterValues,\$Param{Type};
    }
    else{
        $filter = $filter.' AND type IS NULL';
    }

    if($Param{Content}){
        $filter = $filter.' AND content = ?';
        
        push $filterValues,\$Param{Content};
    }
    else{
        $filter = $filter.' AND content IS NULL';
    }

    if($Param{Condition}){
        $filter = $filter.' AND condition_filter = ?';
        
        push $filterValues,\$Param{Condition};
    }
    else{
        $filter = $filter.' AND condition_filter IS NULL';
    }
    
	my $existName;
    return if  !$Self->{DBObject}->Prepare(
        SQL => 'SELECT id FROM ocsIntegrationComputerFilter WHERE '.$filter,
        Bind => $filterValues,
    );
    while ( my @Row = $Self->{DBObject}->FetchrowArray()){
        $existName = $Row[0];
    }
	
	if($existName){
		return ;
	}
    return if !$Self->{DBObject}->Do(
        SQL => 'insert into ocsIntegrationComputerFilter  ('
            . ' type, field, condition_filter, content, ocsPathId )'
            . ' VALUES (?,?,?,?,?)',
        Bind => [
            \$Param{Type},\$Param{Field},\$Param{Condition},\$Param{Content},\$Param{OcsPathId},
        ],
    );
    # sql
    my $ID;
    return if !$Self->{DBObject}->Prepare(
        SQL => 'SELECT id FROM ocsIntegrationComputerFilter WHERE '.$filter,
        Bind => $filterValues,
    );
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $ID = $Row[0];
    }
    
   
    return $ID;
}

sub ComputerFilterUpdate {
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
        push $filterValues,\$Param{Field};
    }
    else{
        $filter = 'field IS NULL';
    }

    if($Param{OcsPathId}){
        $filter = $filter.' AND ocsPathId = ?';
        
        push $filterValues,\$Param{OcsPathId};
    }
    else{
        $filter = $filter.' AND ocsPathId IS NULL';
    }

    if($Param{Type}){
        $filter = $filter.' AND type = ?';
        
        push $filterValues,\$Param{Type};
    }
    else{
        $filter = $filter.' AND type IS NULL';
    }

    if($Param{Content}){
        $filter = $filter.' AND content = ?';
        
        push $filterValues,\$Param{Content};
    }
    else{
        $filter = $filter.' AND content IS NULL';
    }

    if($Param{Condition}){
        $filter = $filter.' AND condition_filter = ?';
        
        push $filterValues,\$Param{Condition};
    }
    else{
        $filter = $filter.' AND condition_filter IS NULL';
    }

    push $filterValues,\$Param{ID};

    my $existName;
    return 0 if  !$Self->{DBObject}->Prepare(
        SQL => 'SELECT id FROM ocsIntegrationComputerFilter WHERE '.$filter.' and ID <> ?',
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
        SQL => ' UPDATE ocsIntegrationComputerFilter SET '
        	.' type = ? ,'
        	.' field = ? ,'
        	.' condition_filter = ? ,'
        	.' content = ? ,'
        	.' ocsPathId = ? '
            . ' WHERE id = ? ',
        Bind => [
            \$Param{Type},\$Param{Field},\$Param{Condition},\$Param{Content},\$Param{OcsPathId},
            \$Param{ID},
        ],
    );

    return 1;
}

sub ComputerFilterDelete {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{ID} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need ID!' );
        return;
    }


    # sql
    return if !$Self->{DBObject}->Do(
        SQL  => 'DELETE FROM ocsIntegrationComputerFilter WHERE id = ?',
        Bind => [ \$Param{ID} ],
    );
    return 1;
}

sub ComputerFilterGet {
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
                ocsPathId
            	FROM ocsIntegrationComputerFilter WHERE id = ?',
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
        };
    }

    return $RetData;
}

sub ComputerFilterList {
    my ( $Self, %Param ) = @_;

    my $filter;
    my $filterValues = [];
    if($Param{OcsPathId}){
        $filter = 'ocsPathId = ? ';
        push $filterValues,\$Param{OcsPathId};
    }
    else{
        $filter = 'ocsPathId IS NULL ';
    }

    if($Param{Type}){
        $filter = $filter.'and type = ? ';
        push $filterValues,\$Param{Type};
    }

    # sql
    return if !$Self->{DBObject}->Prepare(
        SQL => 'SELECT id,
                type,
				field,
                condition_filter,
                content,
                ocsPathId
                FROM ocsIntegrationComputerFilter WHERE '.$filter,
        Bind => $filterValues
    );
    
    my $RetData = [];
    
    while ( my @Data = $Self->{DBObject}->FetchrowArray() ) {
        push $RetData , {
            ID              => $Data[0],
            Type            => $Data[1],
            Field           => $Data[2],
            Condition       => $Data[3],
            Content         => $Data[4],
            OcsPathId       => $Data[5]
        };
    }

    return $RetData;
}

sub ComputerMappingGetByPath {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{OcsPath} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need OcsPath!' );
        return;
    }

    #GET LAST ORDER

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
                parentId
            	FROM ocsIntegrationComputerMapping WHERE ocsPath = ? ',
        Bind => [\$Param{OcsPath}],
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
        };
    }

    return $RetData;
}

sub GetComputers{ 
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

    my $url = "http://".$ServerAddress."/ocsapi/v1/computers?start=".$Start."&limit=".$PaginationSize;

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

sub ComputerMappingDeleteAll {
    my ( $Self, %Param ) = @_;


    # sql
    return if !$Self->{DBObject}->Do(
        SQL  => 'DELETE FROM ocsIntegrationComputerMapping WHERE parentId is not null ',
    );

    return if !$Self->{DBObject}->Do(
        SQL  => 'DELETE FROM ocsIntegrationComputerMapping ',
    );
    return 1;
}

sub ComputerMappingKeyFieldList {
    my ( $Self, %Param ) = @_;

    return if !$Self->{DBObject}->Prepare(
        SQL => 'SELECT 
                ocsPath
                FROM ocsIntegrationComputerMapping WHERE Active = 1 and key_field = 1 order by it_order'
    );
    
    
    my $RetData = [];
    
    while ( my @Data = $Self->{DBObject}->FetchrowArray() ) {
        push $RetData , $Data[0];
    }

    return $RetData;
}