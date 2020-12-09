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

package Kernel::System::AutoTicket;

use strict;
use warnings;
use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Encode',
    'Kernel::System::Cache',
    'Kernel::System::DB',
    'Kernel::System::Group',
    'Kernel::System::Log',
    'Kernel::System::Valid',
);


use vars qw($VERSION);
$VERSION = qw($Revision: 1.2 $) [1];

=head1 NAME

Kernel::System::AutoTicket - autoticket lib

=head1 SYNOPSIS

All std autoticket functions. E. g. to add std autoticket or other functions.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create an object

    use Kernel::Config;
    use Kernel::System::Encode;
    use Kernel::System::Log;
    use Kernel::System::Main;
    use Kernel::System::DB;
    use Kernel::System::AutoTicket;

    my $ConfigObject = Kernel::Config->new();
    my $EncodeObject = Kernel::System::Encode->new(
        ConfigObject => $ConfigObject,
    );
    my $LogObject = Kernel::System::Log->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
    );
    my $MainObject = Kernel::System::Main->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
    );
    my $DBObject = Kernel::System::DB->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
        MainObject   => $MainObject,
    );
    my $AutoTicketObject = Kernel::System::AutoTicket->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
        DBObject     => $DBObject,
        MainObject   => $MainObject,
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    $Self->{ConfigObject}   = $Kernel::OM->Get('Kernel::Config');
    $Self->{LogObject}      = $Kernel::OM->Get('Kernel::System::Log');
    $Self->{DBObject}       = $Kernel::OM->Get('Kernel::System::DB');
    $Self->{EncodeObject}   = $Kernel::OM->Get('Kernel::System::Encode');
#    $Self->{MainObject}     = $Kernel::OM->Get('Kernel::System::DB');    
    $Self->{ValidObject}    = $Kernel::OM->Get('Kernel::System::Valid');

    return $Self;
}

=item AutoTicketAdd()

add new std autoticket

    my $ID = $AutoTicketObject->AutoTicketAdd(
        Name        => 'New Standard autoticket',
        autoticket    => 'Thank you for your email.',
        ContentType => 'text/plain; charset=utf-8',
        ValidID     => 1,
        UserID      => 123,
    );

=cut

sub AutoTicketAdd {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(ID Name TypeID ServiceID SLAID QueueID StateID Customer CustomerID PriorityID Title Message IsVisibleForCustomer NoAgentNotify Nwd Weekday Monthday Months Hour Minutes Comment ValidID UserID)) {
        if ( !defined( $Param{$_} ) ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }
    # sql
    $Param{NoAgentNotify} =  $Param{NoAgentNotify}  || 0;
    $Param{SLAID} =  $Param{SLAID}  || 0;
    $Param{IsVisibleForCustomer} = (lc($Param{IsVisibleForCustomer}) eq 'on') ? 1 : 0;
    return if !$Self->{DBObject}->Do(
        SQL => 'insert into autoticket  ('
        	.' name, type_id, service_id, sla_id, queue_id, ticket_state_id  ,'
        	.' ticket_priority_id, ticket_title, ticket_message, article_type_id, ticket_customer_user, ticket_customer_id, no_agent_notify  ,'
        	.' nwd, weekday, monthday, months, hour, minutes, comments ,'
            . ' valid_id , create_time, create_by, change_time, change_by)'
            . ' VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,current_timestamp,?,current_timestamp,?)',
        Bind => [
            \$Param{Name}, \$Param{TypeID}, \$Param{ServiceID}, \$Param{SLAID},
            \$Param{QueueID}, \$Param{StateID}, \$Param{PriorityID}, \$Param{Title},
            \$Param{Message},\$Param{IsVisibleForCustomer},\$Param{Customer},\$Param{CustomerID}, \$Param{NoAgentNotify}, \$Param{Nwd}, \$Param{Weekday}, \$Param{Monthday},
            \$Param{Months}, \$Param{Hour}, \$Param{Minutes}, \$Param{Comment},
            \$Param{ValidID}, \$Param{UserID}, \$Param{UserID},
        ],
    );
    # sql
    my $ID;
    return if !$Self->{DBObject}->Prepare(
        SQL => 'SELECT id FROM autoticket WHERE name = ? AND change_by = ?',
        Bind => [ \$Param{Name}, \$Param{UserID}, ],
    );
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $ID = $Row[0];
    }
    


    return if !$Self->{DBObject}->Do(
        SQL => 'delete from autoticket_dynamic_field_value '
            . ' WHERE autoticket_id = ?',
        Bind => [
             \$ID,
        ],
    );

    my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');
	my $List = $DynamicFieldObject->DynamicFieldListGet(
        ObjectType => ['Ticket', 'Article'],
    ) ;
	
    DYNAMICFIELD:
	for my $df (keys %Param){

        my $DynamicField;
    	next DYNAMICFIELD if ($df !~ m/^DynamicField_/);
        my $DFName = $df;
        $DFName =~ s/DynamicField_//g;
	    DFIELD:
    	for my $DynamicFieldConfig ( @{$List} ) {
	        next DFIELD if !IsHashRefWithData($DynamicFieldConfig);
    	    if ( $DynamicFieldConfig->{Name} eq $DFName and   $DynamicFieldConfig->{FieldType} eq "Multiselect" ) {
				$DynamicField->{FieldType} = "Multiselect";
        	}
	    }

	    #Se for  um campo Multiseleção deve ser tratado de forma diferente , pois se trata de um array de ref e o valores devem ser todos salvos em rows distintas 
	   
    	if ( $DynamicField->{FieldType} eq "Multiselect" ) {
	        for(@{$Param{$df}}){
    	        my $value = $_;
                if(defined($value)){
        	        return if !$Self->{DBObject}->Do(
            	        SQL => 'insert into autoticket_dynamic_field_value '
                	    . ' values(?,?,?)',
                        Bind => [
                    	    \$ID,\$df,\$value,
                        ],
                     );
                  }
              }
          }else{
	          return if !$Self->{DBObject}->Do(
    	          SQL => 'insert into autoticket_dynamic_field_value '
                  . ' values(?,?,?)',
                  Bind => [
        	          \$ID,\$df,\$Param{$df},
                  ],
              );
          }
    }
    return $ID;
}

=item AutoTicketGet()

get std autoticket attributes

    my %AutoTicket = $AutoTicketObject->AutoTicketGet(
        ID => 123,
    );

Returns:

    %AutoTicket = (
        ID                  => '123',
        Name                => 'Simple autoticket',
        Comment             => 'Some comment',
        autoticket            => 'autoticket content',
        ContentType         => 'text/plain',
        ValidID             => '1',
        CreateTime          => '2010-04-07 15:41:15',
        CreateBy            => '321',
        ChangeTime          => '2010-04-07 15:59:45',
        ChangeBy            => '223',
        DynamicField_XYZ    => '123'
        DynamicField_XPTO   => 'asdadasd'
        
    );

=cut

sub AutoTicketGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{ID} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need ID!' );
        return;
    }

    # sql
    return if !$Self->{DBObject}->Prepare(
        SQL => 'SELECT name,
        	type_id,
        	service_id,
        	sla_id,
        	queue_id,
        	ticket_state_id,
        	ticket_priority_id,
        	ticket_title,
        	ticket_message,
        	no_agent_notify,
        	nwd,
        	weekday,
        	monthday,
        	months,
        	hour,
        	minutes,
	        valid_id,
	        comments,
            	create_time,
            	create_by,
            	change_time,
            	change_by,
            	ticket_customer_user,
            	ticket_customer_id,
            	article_type_id
            	FROM autoticket WHERE id = ?',
        Bind => [ \$Param{ID} ],
    );
    my %Data;
    while ( my @Data = $Self->{DBObject}->FetchrowArray() ) {
        %Data = (
            ID            => $Param{ID},
            Name          => $Data[0],
            TypeID        => $Data[1],
            ServiceID     => $Data[2],
            SLAID         => $Data[3],
            QueueID       => $Data[4],
            StateID       => $Data[5],
            PriorityID    => $Data[6],
            Title     	  => $Data[7],
            Message    	  => $Data[8],
            NoAgentNotify => $Data[9],
            Nwd           => $Data[10],
            Weekday       => $Data[11],
            Monthday      => $Data[12],
            Months        => $Data[13],
            Hour          => $Data[14],
            Minutes       => $Data[15],
            ValidID       => $Data[16],
            Comment       => $Data[17],
            CreateTime    => $Data[18],
            CreateBy      => $Data[19],
            ChangeTime    => $Data[20],
            ChangeBy      => $Data[21],
            Customer      => $Data[22],
            CustomerID    => $Data[23],
            IsVisibleForCustomer    => $Data[24],
        );
    }

    my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');
	my $List = $DynamicFieldObject->DynamicFieldListGet(
        ObjectType => ['Ticket', 'Article'],
    ) ;

    $Self->{DBObject}->Prepare(
        SQL => 'SELECT * FROM autoticket_dynamic_field_value WHERE autoticket_id = ?',
        Bind => [ \$Param{ID} ],
    );
	
    while ( my @Data = $Self->{DBObject}->FetchrowArray() ) {

    	my $DynamicField;
		my $DFName = $Data[1];
    	$DFName =~ s/DynamicField_//g;
	    DYNAMICFIELD:
    	for my $DynamicFieldConfig ( @{$List} ) {
	        next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);
    	    if ( $DynamicFieldConfig->{Name} eq $DFName and   $DynamicFieldConfig->{FieldType} eq "Multiselect" ) {
				$DynamicField->{FieldType} = "Multiselect";
        	}
	    }
    	#Se for  um campo Multiseleção deve ser tratado de forma diferente , pois se trata de um array de ref e o valores devem ser todos salvos em rows distintas 
    	if ( defined  $DynamicField->{FieldType}  and $DynamicField->{FieldType} eq "Multiselect" ) {
    		push @{$Data{$Data[1]}}, $Data[2];
    	}else{
			$Data{$Data[1]} = $Data[2];
		}
    };

    return %Data;
}

=item AutoTicketDelete()

delete a standard autoticket

    $AutoTicketObject->AutoTicketDelete(
        ID => 123,
    );

=cut

sub AutoTicketDelete {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{ID} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need ID!' );
        return;
    }

    # delete queue<->std autoticket relation
#    return if !$Self->{DBObject}->Do(
#        SQL  => 'DELETE FROM queue_standard_autoticket WHERE standard_autoticket_id = ?',
#        Bind => [ \$Param{ID} ],
#    );

    # sql
    return if !$Self->{DBObject}->Do(
        SQL  => 'DELETE FROM autoticket WHERE id = ?',
        Bind => [ \$Param{ID} ],
    );
    return 1;
}

=item AutoTicketUpdate()

update std autoticket attributes

    $AutoTicketObject->AutoTicketUpdate(
        ID          => 123,
        Name        => 'New Standard autoticket',
        autoticket    => 'Thank you for your email.',
        ContentType => 'text/plain; charset=utf-8',
        ValidID     => 1,
        UserID      => 123,
    );

=cut

sub AutoTicketUpdate {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(ID Name TypeID ServiceID SLAID QueueID StateID PriorityID Customer CustomerID Title Message IsVisibleForCustomer NoAgentNotify Nwd Weekday Monthday Months Hour Minutes Comment ValidID UserID)) {
        if ( !defined( $Param{$_} ) ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }
	$Param{NoAgentNotify} =  $Param{NoAgentNotify}  || 0;  
    $Param{SLAID} =  $Param{SLAID}  || 0;
    # sql
    return if !$Self->{DBObject}->Do(
        SQL => 'UPDATE autoticket SET '
        	.' name = ?,'
        	.' type_id = ?,'
        	.' service_id = ?,'
        	.' sla_id = ?,'
        	.' queue_id = ?,'
        	.' ticket_state_id = ?,'
        	.' ticket_priority_id = ?,'
        	.' ticket_title = ?,'
        	.' ticket_message = ?,'
        	.' article_type_id = ?,'
        	.' ticket_customer_user = ?,'
        	.' ticket_customer_id = ?,'
        	.' no_agent_notify = ?,'
        	.' nwd = ?,'
        	.' weekday = ?,'
        	.' monthday = ?,'
        	.' months = ?,'
        	.' hour = ?,'
        	.' minutes = ?,'
	       . ' comments = ?,'
            . ' valid_id = ?, change_time = current_timestamp, change_by = ?'
            . ' WHERE id = ?',
        Bind => [
            \$Param{Name}, \$Param{TypeID}, \$Param{ServiceID}, \$Param{SLAID},
            \$Param{QueueID}, \$Param{StateID}, \$Param{PriorityID}, \$Param{Title},
            \$Param{Message},\$Param{IsVisibleForCustomer},\$Param{Customer},\$Param{CustomerID}, \$Param{NoAgentNotify}, \$Param{Nwd}, \$Param{Weekday}, \$Param{Monthday},
            \$Param{Months}, \$Param{Hour}, \$Param{Minutes}, \$Param{Comment},
            \$Param{ValidID}, \$Param{UserID}, \$Param{ID},
        ],
    );


    return if !$Self->{DBObject}->Do(
        SQL => 'delete from autoticket_dynamic_field_value '
            . ' WHERE autoticket_id = ?',
        Bind => [
             \$Param{ID},
        ],
    );

	my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');
   
    DYNAMICFIELD:
    for my $df (keys %Param){
        next DYNAMICFIELD if ($df !~ m/^DynamicField_/);
		my $DFName = $df;
        $DFName =~ s/DynamicField_//g;
        my $DynamicField = $DynamicFieldObject->DynamicFieldGet(
            Name => $DFName,
 		);
		#Se for  um campo Multiseleção deve ser tratado de forma diferente , pois se trata de um array de ref e o valores devem ser todos salvos em rows distintas 
		if ( $DynamicField->{FieldType} eq "Multiselect" ) {

        	for(@{$Param{$df}}){
                my $value = $_;
                if(defined($value)){
	                return if !$Self->{DBObject}->Do(
    	                SQL => 'insert into autoticket_dynamic_field_value '
        	            . ' values(?,?,?)',
            	        Bind => [
                	         \$Param{ID},\$df,\$value,
                    	],
                    );
                }
   	        }
        }else{
    	    return if !$Self->{DBObject}->Do(
	            SQL => 'insert into autoticket_dynamic_field_value '
        	        . 'values(?,?,?)',
            	Bind => [
                     \$Param{ID},\$df,\$Param{$df},
	            ],
    	    );
        }

    }
    
    return 1;
}

=item AutoTicketLookup()

return the name or the std autoticket id

    my $AutoTicketName = $AutoTicketObject->AutoTicketLookup(
        AutoTicketID => 123,
    );

    or

    my $AutoTicketID = $AutoTicketObject->AutoTicketLookup(
        AutoTicket => 'Std autoticket Name',
    );

=cut

sub AutoTicketLookup {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{AutoTicket} && !$Param{AutoTicketID} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Got no AutoTicket or AutoTicketID!'
        );
        return;
    }

    # check if we ask the same request?
    if ( $Param{AutoTicketID} && $Self->{"AutoTicketLookup$Param{AutoTicketID}"} )
    {
        return $Self->{"AutoTicketLookup$Param{AutoTicketID}"};
    }
    if ( $Param{AutoTicket} && $Self->{"AutoTicketLookup$Param{AutoTicket}"} ) {
        return $Self->{"AutoTicketLookup$Param{AutoTicket}"};
    }

    # get data
    my $SQL;
    my $Suffix;
    my @Bind;
    if ( $Param{AutoTicket} ) {
        $Suffix = 'AutoTicketID';
        $SQL    = 'SELECT id FROM standard_autoticket WHERE name = ?';
        @Bind   = ( \$Param{AutoTicket} );
    }
    else {
        $Suffix = 'AutoTicket';
        $SQL    = 'SELECT name FROM standard_autoticket WHERE id = ?';
        @Bind   = ( \$Param{AutoTicketID} );
    }
    return if !$Self->{DBObject}->Prepare( SQL => $SQL, Bind => \@Bind );
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {

        # store result
        $Self->{"AutoTicket$Suffix"} = $Row[0];
    }

    # check if data exists
    if ( !exists $Self->{"AutoTicket$Suffix"} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => "Found no \$$Suffix!" );
        return;
    }

    return $Self->{"AutoTicket$Suffix"};
}

=item AutoTicketList()

get all valid auto tickets

    my %AutoTickets = $AutoTicketObject->AutoTicketList();

get all auto tickets

    my %AutoTickets = $AutoTicketObject->AutoTicketList(
        Valid => 0,
    );

=cut

sub AutoTicketList {
    my ( $Self, %Param ) = @_;

    if ( !defined $Param{Valid} ) {
        $Param{Valid} = 1;
    }

    # return data

    $Self->{DBObject}->Prepare(
        SQL => 'SELECT id, name FROM autoticket WHERE valid_id = ?',
        Bind => [ \$Param{Valid} ]
    );

    # fetch the result
    my %AutoTicketList;

	while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $AutoTicketList{ $Row[0] }      = $Row[1];
    }

	return %AutoTicketList;

}


#=item GetCustomerIDAutoTicket()

#get CustomerIDs of a  AutoTicket

#    my %CustomerIDs = $AutoTicketObject->GetCustomerIDAutoTicket( AutoTicketID => 123 );

#    my %AutoTickets = $AutoTicketObject->GetCustomerIDAutoTicket( CustomerID => 123 );

#=cut
#sub GetCustomerIDAutoTicket {
#    my ( $Self, %Param ) = @_;

#    # check needed stuff
#    if ( !$Param{AutoTicketID} && !$Param{CustomerID} ) {
#        $Self->{LogObject}
#            ->Log( Priority => 'error', Message => 'Got no CustomerID or AutoTicketID!' );
#        return;
#    }

#    if ( $Param{AutoTicketID} ) {
#        # get CustomerIDs
#        my $SQL = "SELECT customer_company.customer_id, customer_company.name "
#            . " FROM customer_company, autoticket_customer_id ss WHERE "
#            . " ss.autoticket_id IN ("
#            . $Self->{DBObject}->Quote( $Param{AutoTicketID}, 'Integer' )
#            . ") AND "
#            . " ss.customer_id = customer_company.customer_id AND "
#            . " customer_company.valid_id IN ( ${\(join ', ', $Self->{ValidObject}->ValidIDsGet())} )"
#            . " ORDER BY customer_company.name";
#        return if !$Self->{DBObject}->Prepare( SQL => $SQL );
#        my %CustomerIDs;

#        while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
#            $CustomerIDs{ $Row[0] } = $Row[1];
#        }

#        # store CustomerIDs
#        $Self->{"CustomerIDs::$Param{AutoTicketID}"} = \%CustomerIDs;

#        # return responses
#        return %CustomerIDs;
#    }

#    else {
#        # get  AutoTickets
#        my $SQL = "SELECT q.id, q.name "
#            . " FROM autoticket q, autoticket_customer_id ss WHERE "
#            . " ss.customer_id = '"
#            . $Self->{DBObject}->Quote( $Param{CustomerID} )
#            . "' AND "
#            . " ss.autoticket_id = q.id AND "
#            . " q.valid_id IN ( ${\(join ', ', $Self->{ValidObject}->ValidIDsGet())} )"
#            . " ORDER BY q.name";
#        return if !$Self->{DBObject}->Prepare( SQL => $SQL );
#        my %AutoTickets;

#        while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
#            $AutoTickets{ $Row[0] } = $Row[1];
#        }

#        # store  AutoTickets
#        $Self->{"AutoTickets::$Param{CustomerID}"} = \%AutoTickets;

#        # return  AutoTickets
#        return %AutoTickets;

#    }
#}



#=item AutoTicketCustomerIDAdd()

#to add a CustomerID to a  AutoTicket

#    my $Success = $AutoTicketObject->AutoTicketCustomerIDAdd(
#        CustomerID    => 12,
#        AutoTicketID    => 6,
#        Active => 1,
#        UserID => 123,
#    );

#=cut

#sub AutoTicketCustomerIDAdd {
#    my ( $Self, %Param ) = @_;

#    # check needed stuff
#    for (qw(AutoTicketID CustomerID UserID)) {
#        if ( !$Param{$_} ) {
#            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
#            return;
#        }


#    }

#    # delete existing relation
#    return if !$Self->{DBObject}->Do(
#        SQL => 'DELETE FROM autoticket_customer_id WHERE autoticket_id = ? AND customer_ID = ?',
#        Bind => [ \$Param{AutoTicketID}, \$Param{CustomerID} ],
#    );

#    # return if AutoTicket is not longer in CustomerID
#    if ( !$Param{Active} ) {
#        return;
#    }

#    # debug
#    if ( $Self->{Debug} ) {
#        $Self->{LogObject}->Log(
#            Priority => 'error',
#            Message  => "Add CustomerID:$Param{CustomerID} to AutoTicketID:$Param{AutoTicketID}!",
#        );
#    }

#    # insert new permission
#    return if !$Self->{DBObject}->Do(
#        SQL => 'INSERT INTO autoticket_customer_id '
#            . '(customer_id, autoticket_id, create_time, create_by, change_time, change_by) '
#            . 'VALUES (?, ?, current_timestamp, ?, current_timestamp, ?)',
#        Bind => [ \$Param{CustomerID}, \$Param{AutoTicketID}, \$Param{UserID}, \$Param{UserID} ],
#    );
# 
#    return 1;
#}





#=item ListAllAutoTicketCustomerID()

#Gets a raw list from autoticket_customer_id table

#    my @list = $AutoTicketObject->ListAllAutoTicketCustomerID();
#    
#    return @list = {
#    	[
#    		autoticket_id => 1,
#    		customer_id=>'cutomer1'
#	],
#		[
#    		autoticket_id => 2,
#    		customer_id=>'cutomer1'
#	]}
#=cut

#sub ListAllAutoTicketCustomerID {
#    my ($Self, %Param ) = @_;

#	# create the valid list
#	my $ValidIDs = join ', ', $Self->{ValidObject}->ValidIDsGet();

#        # get the list
#        my $SQL = "SELECT * FROM autoticket_customer_id s "
#		." left join autoticket p on s.autoticket_id=p.id "
#		." left join customer_company c on s.customer_id=c.customer_id "
#		." where p.valid_id in ( $ValidIDs ) "
#		." and c.valid_id in  ( $ValidIDs ) order by s.customer_id";
#		
#        return if !$Self->{DBObject}->Prepare( SQL => $SQL );
#        my @list;

#        while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
#            push @list, {
#                autoticket_id  => $Row[0],
#                customer_id => $Row[1],
#            };

#        }

#        # return responses
#        return @list;
#}


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
