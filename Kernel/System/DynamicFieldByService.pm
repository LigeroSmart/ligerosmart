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

package Kernel::System::DynamicFieldByService;

use Data::Dumper;

use strict;
use warnings;
use utf8;
our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Encode',
    'Kernel::System::Cache',
    'Kernel::System::DB',
    'Kernel::System::Group',
    'Kernel::System::Log',
    'Kernel::System::Valid',
    'Kernel::System::Type',
    'Kernel::System::YAML',
);
use Kernel::System::VariableCheck qw(:all);


use vars qw($VERSION);
$VERSION = qw($Revision: 1.2 $) [1];


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


sub DynamicTemplateAdd {

    my ( $Self, %Param ) = @_;
    my $ServiceObject = $Kernel::OM->Get('Kernel::System::Service');

    # check needed stuff
    for my $Key (qw(Name Config UserID)) {
        if ( !$Param{$Key} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Key!",
            );
            return;
        }
    }

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    my $Config='';

    if ($Param{Config}->{Fields}) {

        if ( !IsHashRefWithData( $Param{Config} ) ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Config needs to be a valid Hash reference!",
            );
            return;
        }


        # check config formats

        if ( ref $Param{Config}->{Fields} ne 'HASH' ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Config Fields must be a Hash!",
            );
            return;
        }
        if ( ref $Param{Config}->{FieldOrder} ne 'ARRAY' ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Config Fields must be an Array!",
            );
            return;
        }

		$Param{Config}->{HideArticle} = $Param{HideArticle}||0;
        # dump layout and config as string
        $Config = $Kernel::OM->Get('Kernel::System::YAML')->Dump( Data => $Param{Config} );
    }
    $Param{WorkflowID} = 1 if (!$Param{WorkflowID});
 
    # Make sure the resulting string has the UTF-8 flag. YAML only sets it if
    #   part of the data already had it.
    utf8::upgrade($Config);
	
    return if !$DBObject->Do(
        SQL => '
            INSERT INTO dfs ( name, comments, valid_id, content_type, create_time, create_by, change_time, change_by, subject, body, type_id, workflow_id, frontend, config)
            VALUES (?, ?, ?, ?, current_timestamp, ?, current_timestamp, ?, ?, ?, ?, ?, ?, ?)',
        Bind => [
            \$Param{Name}, \$Param{Comments}, \$Param{ValidID}, \$Param{ContetType},\$Param{UserID},\$Param{UserID},\$Param{Subject},\$Param{Message},\$Param{TypeID},\$Param{WorkflowID},\$Param{Frontend}, \$Config
        ],
    );

    return if !$DBObject->Prepare(
        SQL  => 'SELECT id FROM dfs WHERE name = ?',
        Bind => [ \$Param{Name} ],
    );
    my $ID;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $ID = $Row[0];
    }
    my $ServiceID = $Param{ServiceID};
    for(@{$ServiceID}){
    	my $IDService = $_;
 	if(defined($ID)){
   		$ServiceObject->ServicePreferencesSet(
		        ServiceID => $IDService,
		        Key       => 'Forms',
		        Value     => $ID,
		        UserID    => 1,
		);

      	}
    }
    # delete cache
    return if !$ID;

    return $ID;
}

sub DynamicTemplateUpdate{
	my ( $Self, %Param ) = @_;
	my $ServiceObject = $Kernel::OM->Get('Kernel::System::Service');
	for my $Key (qw(Name Config UserID)) {
	        if ( !$Param{$Key} ) {	
	            $Kernel::OM->Get('Kernel::System::Log')->Log(
	                Priority => 'error',
	                Message  => "Need $Key!",
	            );
	            return;
	        }
	}

	# get database object
	my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    my $Config='';

	if (  $Param{Config}->{Fields} ) {
	    if ( !IsHashRefWithData( $Param{Config} ) ) {
            	$Kernel::OM->Get('Kernel::System::Log')->Log(
	                Priority => 'error',
	                Message  => "Config needs to be a valid Hash reference!",
            	);
            	return;
	    }
        	# check config formats
        	if ( ref $Param{Config}->{Fields} ne 'HASH' ) {
            	$Kernel::OM->Get('Kernel::System::Log')->Log(
                		Priority => 'error',
                		Message  => "Config Fields must be a Hash!",
            	);
            	return;
        	}
	    if ( ref $Param{Config}->{FieldOrder} eq 'ARRAY' ) {
			$Param{Config}->{HideArticle} = $Param{HideArticle}||0;
        	$Config = $Kernel::OM->Get('Kernel::System::YAML')->Dump( Data => $Param{Config} );
    	}
	}
	# Make sure the resulting string has the UTF-8 flag. YAML only sets it if
	#   part of the data already had it.
	utf8::upgrade($Config);
	# sql
	return if !$DBObject->Do(
        	SQL => '
			UPDATE dfs set name = ?, comments = ?, valid_id = ?, change_time = current_timestamp, change_by = ?, subject = ?, body = ?, type_id = ?, frontend = ?, config = ?
			Where id = ?' ,
		Bind => [
            		\$Param{Name}, \$Param{Comments}, \$Param{ValidID},\$Param{UserID}, \$Param{Subject},\$Param{Message},\$Param{TypeID},\$Param{Frontend}, \$Config, \$Param{ID},
        	],

    	);
	my $ServiceID = $Param{ServiceID};
	return if !$DBObject->Do(
        	SQL => "DELETE FROM service_preferences WHERE "
	            . "preferences_key = 'Forms' AND preferences_value = ?",
        	Bind => [\$Param{ID} ],
    	);
        for(@{$ServiceID}){
    		my $IDService = $_;
 		if(defined($Param{ID})){
	   		$ServiceObject->ServicePreferencesSet(
				ServiceID => $IDService,
				Key       => 'Forms',
				Value     => $Param{ID},
				UserID    => 1,
			);

      		}
    	}
	$Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
        	Type => 'ServicePreferencesDB',  
    	);
   	return 1;
	
}
sub DynamicFieldByServiceGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{ID} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need ID!' );
        return;
    }

    # sql
    return if !$Self->{DBObject}->Prepare(
        SQL => '
            SELECT
                distinct name, 
                comments,
                valid_id, 
                content_type,
                create_time,
                create_by,
                change_time,
                change_by,
                subject,
                body, 
                type_id,
                workflow_id, 
                frontend, 
                config
            FROM dfs
            WHERE dfs.id = ?',
        Bind => [ \$Param{ID} ],
    );
    my %Data;
	
    my $YAMLObject = $Kernel::OM->Get('Kernel::System::YAML');
    while ( my @Data = $Self->{DBObject}->FetchrowArray() ) {

        my %Type;
        if (!defined($Data[10]) || $Data[10] eq '') {
           $Type{Name} = '';
        } else {
            %Type = $Kernel::OM->Get('Kernel::System::Type')->TypeGet(
                ID => $Data[10],
            );
        }

        my $Config = '';
        my $HideArticle = 0;
        if ($Data[13] ) {
            $Config = $YAMLObject->Load( Data => $Data[13] );
            $HideArticle = $Config->{HideArticle} || 0;
        }
        %Data = (
            ID            => $Param{ID},
            Name          => $Data[0],
	    Comments 	  => $Data[1],
	    ValidID  	  => $Data[2],
	    ContetType	  => $Data[3], 
	    CreateTime	  => $Data[4], 
   	    CreateBy	  => $Data[5], 
	    ChangeTime    => $Data[6], 
	    ChangeBy   	  => $Data[7], 
	    Subject 	  => $Data[8], 
	    Body	  => $Data[9], 
	    Type          => $Type{Name}, 
	    TypeID        => $Data[10],
	    WorkflowId	  => $Data[11], 
	    Frontend	  => $Data[12], 
	    Config	  => $Config,
	    HideArticle   => $HideArticle
        );
    }

    return %Data;
}


sub DynamicFieldByServiceDelete{
	 my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{ID} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need ID!' );
        return;
    }
#	 return if !$Self->{DBObject}->Do(
#        SQL  => 'DELETE FROM dfs_service WHERE id = ?',
#        Bind => [ \$Param{ID} ],
#    );

    return if !$Self->{DBObject}->Do(
        SQL  => 'DELETE FROM dfs WHERE id = ?',
        Bind => [ \$Param{ID} ],
    );
    return 1;


}

sub GetDynamicFieldByServiceAndInterface {
	my ( $Self, %Param ) = @_;
	my $ServiceObject = $Kernel::OM->Get("Kernel::System::Service");
   	# check needed stuff
   	if ( !$Param{ServiceID} && !$Param{InterfaceName} ) {
		$Self->{LogObject}->Log( Priority => 'error', Message => 'Need ID!' );
        return;
	}
	my %Preferences = $ServiceObject->ServicePreferencesGet(
		ServiceID => $Param{ServiceID},
		UserID    => 1,
	);
	my $FormID;
	if( defined($Preferences{Forms})){
		$FormID = $Preferences{Forms};
	}
	if($Param{InterfaceName} eq 'NewCustomerTicket'){
		$Param{Interface} = 'CustomerInterface';
	}else{
		$Param{Interface} = 'AgentInterface';
	}
   	return if !$Self->{DBObject}->Prepare(
		SQL => 'SELECT  distinct name, 
			comments, 
			valid_id, 
			content_type,
			create_time,
			create_by,
			change_time,
			change_by,
			subject,
			body, 
			type_id,
			workflow_id,
			frontend, 
			config,
			dfs.id
			FROM dfs 
			WHERE dfs.id = ?',
        	Bind => [ \$FormID ],
    	);

   	 my %Data;
	
   	 my $YAMLObject = $Kernel::OM->Get('Kernel::System::YAML');
	 while ( my @Data = $Self->{DBObject}->FetchrowArray() ) {
	 	my %Type;
		%Type = $Kernel::OM->Get('Kernel::System::Type')->TypeGet(
        		ID => $Data[10],
	 	) if $Data[10];
	
		if( $Data[12] ne 'BothInterfaces'){
			if($Param{Interface} ne $Data[12]){
				return;
			}
		} 
	
		my $Config = { HideArticle => 0 };
		if ($Data[13] ){
    		$Config = $YAMLObject->Load( Data => $Data[13] );
		}

       	%Data = (
            ID            => $Data[14],
            Name          => $Data[0],
		    Comments 	  => $Data[1],
		    ValidID	  	  => $Data[2],
		    ContetType	  => $Data[3], 
		    CreateTime	  => $Data[4], 
	   	    CreateBy	  => $Data[5], 
		    ChangeTime    => $Data[6], 
		    ChangeBy   	  => $Data[7], 
		    Subject 	  => $Data[8], 
		    Body	 	  => $Data[9], 
		    Type	  	  => $Type{Name},
            TypeID  	  => $Data[10],
		    WorkflowId	  => $Data[11], 
	        Frontend	  => $Data[12], 
		    ServiceID	  => $Param{ServiceID}, 
    	    Config	  	  => $Config,
			HideArticle   => $Config->{HideArticle}||0,
        );
    }


    return \%Data;
}


sub GetDynamicFieldByService {
	my ( $Self, %Param ) = @_;
	my $ServiceObject = $Kernel::OM->Get("Kernel::System::Service");
	# check needed stuff
	if ( !$Param{ServiceID} ) {
		$Self->{LogObject}->Log( Priority => 'error', Message => 'Need ID!' );
		return;
	}
	
	my %Preferences = $ServiceObject->ServicePreferencesGet(
		        ServiceID => $Param{ServiceID},
		        UserID    => 1,
	);
	my $FormID;
	if( defined($Preferences{Forms})){
		$FormID = $Preferences{Forms};
	
	}
    	# sql
    	return if !$Self->{DBObject}->Prepare(
		SQL => 'SELECT  distinct 
			name, 
			comments, 
			valid_id, 
			content_type,
			create_time,
			create_by,
			change_time,
			change_by,
			subject,
			body, 
			type_id,
			workflow_id, 
			frontend, 
			config,
			dfs.id
			FROM dfs 
			WHERE dfs.id = ?',
        	Bind => [ \$FormID ],
   	);
	my %Data;

	my $YAMLObject = $Kernel::OM->Get('Kernel::System::YAML');

	my %Type;
	while ( my @Data = $Self->{DBObject}->FetchrowArray() ) {
		%Type = $Kernel::OM->Get('Kernel::System::Type')->TypeGet(
			ID => $Data[10],
		) if $Data[10];

		my $Config = { HideArticle => 0 };
		if ($Data[13] ){
			$Config = $YAMLObject->Load( Data => $Data[13] );
		}

		%Data = (
			ID            => $Data[14],
			Name          => $Data[0],
			Comments 	  => $Data[1],
			ValidID	  	  => $Data[2],
			ContetType	  => $Data[3], 
			CreateTime	  => $Data[4], 
			CreateBy	  => $Data[5], 
			ChangeTime    => $Data[6], 
			ChangeBy   	  => $Data[7], 
			Subject 	  => $Data[8], 
			Body		  => $Data[9], 
			Type	 	  => $Type{Name},
			TypeID        =>  $Data[10],
			WorkflowId	  => $Data[11], 
					Frontend	  => $Data[12], 
			ServiceID	  => $Param{ServiceID}, 
			Config	      => $Config,
			HideArticle   => $Config->{HideArticle}||0,
		);
    }

#    return if !$Self->{DBObject}->Prepare(
#        SQL => 'SELECT * FROM autoticket_dynamic_field_value WHERE autoticket_id = ?',
#        Bind => [ \$Param{ID} ],
#    );
    
#    while ( my @Data = $Self->{DBObject}->FetchrowArray() ) {
#            
 #       $Data{$Data[1]} = $Data[2];
 #   };

    return \%Data;
}

sub DynamicFieldByServiceList {
    my ( $Self, %Param ) = @_;

    # if ( !defined $Param{Valid} ) {
    #     $Param{Valid} = 1;
    # }

    # return data
    my $Table = $Self->{DBObject}->SelectAll(
        SQL => 'select * from dfs'
    );

	return if ! scalar @$Table;

	my %Result;
	for my $Row (@$Table){
		$Result{$Row->[0]} = $Row->[1];
	}

	return %Result;
}


1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut

=head1 VERSION

$Revision: 1.2 $ $Date: 2011/03/15 23:04:51 $

=cut
