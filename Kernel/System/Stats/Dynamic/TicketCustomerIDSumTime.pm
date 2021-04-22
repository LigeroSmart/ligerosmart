# --
# Kernel/System/Stats/Dynamic/TicketListAccountedStateTime.pm - reporting via ticket lists
# Copyright (C) 2001-2012 OTRS AG, http://otrs.org/
# --
# $Id: TicketListAccountedStateTime.pm,v 1.19.2.1 2012/05/02 23:07:32 cr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Stats::Dynamic::TicketCustomerIDSumTime;

use strict;
use warnings;
use Data::Dumper;
use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::DB',
    'Kernel::System::CustomerUser',
    'Kernel::System::DynamicField',
    'Kernel::System::DynamicField::Backend',
    'Kernel::System::Lock',
    'Kernel::System::Log',
    'Kernel::System::Priority',
    'Kernel::System::Queue',
    'Kernel::System::Service',
    'Kernel::System::SLA',
    'Kernel::System::State',
    'Kernel::System::Ticket',
    'Kernel::System::Type',
    'Kernel::System::User',
);
use vars qw($VERSION);
$VERSION = qw($Revision: 1.19.2.1 $) [1];

sub new {

    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    $Self->{DBObject}        = $Kernel::OM->Get('Kernel::System::DB');
    $Self->{LogObject}        = $Kernel::OM->Get('Kernel::System::Log');
    $Self->{QueueObject}        = $Kernel::OM->Get('Kernel::System::Queue');
    $Self->{TicketObject}       = $Kernel::OM->Get('Kernel::System::Ticket');
    $Self->{StateObject}        = $Kernel::OM->Get('Kernel::System::State');
    $Self->{PriorityObject}     = $Kernel::OM->Get('Kernel::System::Priority');
    $Self->{LockObject}         = $Kernel::OM->Get('Kernel::System::Lock');
    $Self->{CustomerUser}       = $Kernel::OM->Get('Kernel::System::CustomerUser');
    $Self->{ServiceObject}      = $Kernel::OM->Get('Kernel::System::Service');
    $Self->{SLAObject}          = $Kernel::OM->Get('Kernel::System::SLA');
    $Self->{TypeObject}         = $Kernel::OM->Get('Kernel::System::Type');
    $Self->{UserObject}         = $Kernel::OM->Get('Kernel::System::User');
    $Self->{TimeObject}         = $Kernel::OM->Get('Kernel::System::Time');
    $Self->{ConfigObject}       = $Kernel::OM->Get('Kernel::Config');

    return $Self;
}

sub GetObjectName {
    my ( $Self, %Param ) = @_;

    return 'TicketCustomerIDSSumTime';
}

sub GetObjectAttributes {
    my ( $Self, %Param ) = @_;

    # get user list
    my %UserList = $Self->{UserObject}->UserList(
        Type  => 'Long',
        Valid => 0,
    );

    # get state list
    my %StateList = $Self->{StateObject}->StateList(
        UserID => 1,
    );

    # get queue list
    my %QueueList = $Self->{QueueObject}->GetAllQueues();

    my %Limit = (
        5         => 5,
        10        => 10,
        20        => 20,
        50        => 50,
        100       => 100,
        unlimited => 'unlimited',
    );

    # Here is where the system takes the attributes to be printed.
    my %TicketAttributes = %{ $Self->_Attributes() };

    my %OrderBy
        = map { $_ => $TicketAttributes{$_} } grep { $_ ne 'Number' } keys %TicketAttributes;

    # generate CalendarOptionStrg
    my %CalendarList;
    for my $CalendarNumber ( '', 1 .. 50 ) {
        if ( $Self->{ConfigObject}->Get("TimeVacationDays::Calendar$CalendarNumber") ) {
            $CalendarList{$CalendarNumber} = "Calendar $CalendarNumber - "
                . $Self->{ConfigObject}->Get( "TimeZone::Calendar" . $CalendarNumber . "Name" );
        }
    }

    my %SortSequence = (
        Up   => 'ascending',
        Down => 'descending',
    );
    my %YesNo = (
        Yes   => 'Yes',
        No => 'No',
    );


    my @ObjectAttributes = (
        {
            Name             => 'Attributes to be printed',
            UseAsXvalue      => 1,
            UseAsValueSeries => 0,
            UseAsRestriction => 0,
            Element          => 'TicketAttributes',
            Block            => 'MultiSelectField',
            Translation      => 1,
            Values           => \%TicketAttributes,
            Sort             => 'IndividualKey',
            SortIndividual   => $Self->_SortedAttributes(),

        },
        {
            Name             => 'Calendar to Use on Time Accounting (don\'t select to use the ticket information)',
            UseAsXvalue      => 0,
            UseAsValueSeries => 0,
            UseAsRestriction => 1,
            Element          => 'Calendar',
            Block            => 'SelectField',
            Translation      => 1,
            Values           => \%CalendarList,
            Sort             => 'IndividualKey',
        },
        {
            Name             => 'Queue',
            UseAsXvalue      => 0,
            UseAsValueSeries => 0,
            UseAsRestriction => 1,
            Element          => 'QueueIDs',
            Block            => 'MultiSelectField',
            Translation      => 0,
            Values           => \%QueueList,
        },
        {
            Name             => 'State',
            UseAsXvalue      => 0,
            UseAsValueSeries => 0,
            UseAsRestriction => 1,
            Element          => 'StateIDs',
            Block            => 'MultiSelectField',
            Values           => \%StateList,
        },

        {
            Name             => 'Create Time',
            UseAsXvalue      => 0,
            UseAsValueSeries => 0,
            UseAsRestriction => 1,
            Element          => 'CreateTime',
            TimePeriodFormat => 'DateInputFormat',    # 'DateInputFormatLong',
            Block            => 'Time',
            Values           => {
                TimeStart => 'TicketCreateTimeNewerDate',
                TimeStop  => 'TicketCreateTimeOlderDate',
            },
        },
		{
            Name             => 'Change Time',
            UseAsXvalue      => 0,
            UseAsValueSeries => 0,
            UseAsRestriction => 1,
            Element          => 'ChangeTime',
            TimePeriodFormat => 'DateInputFormat',    # 'DateInputFormatLong',
            Block            => 'Time',
            Values           => {
                TimeStart => 'TicketChangeTimeNewerDate',
                TimeStop  => 'TicketChangeTimeOlderDate',
            },
        },

        

    );

    if ( $Self->{ConfigObject}->Get('Ticket::Service') ) {

        # get service list
        my %Service = $Self->{ServiceObject}->ServiceList(
            UserID => 1,
        );

        # get sla list
        my %SLA = $Self->{SLAObject}->SLAList(
            UserID => 1,
        );

        my @ObjectAttributeAdd = (
            {
                Name             => 'Service',
                UseAsXvalue      => 0,
                UseAsValueSeries => 0,
                UseAsRestriction => 1,
                Element          => 'ServiceIDs',
                Block            => 'MultiSelectField',
                Translation      => 0,
                Values           => \%Service,
            },
            {
                Name             => 'SLA',
                UseAsXvalue      => 0,
                UseAsValueSeries => 0,
                UseAsRestriction => 1,
                Element          => 'SLAIDs',
                Block            => 'MultiSelectField',
                Translation      => 0,
                Values           => \%SLA,
            },
        );

        unshift @ObjectAttributes, @ObjectAttributeAdd;
    }

    if ( $Self->{ConfigObject}->Get('Ticket::Type') ) {

        # get ticket type list
        my %Type = $Self->{TypeObject}->TypeList(
            UserID => 1,
        );

        my %ObjectAttribute1 = (
            Name             => 'Type',
            UseAsXvalue      => 0,
            UseAsValueSeries => 0,
            UseAsRestriction => 1,
            Element          => 'TypeIDs',
            Block            => 'MultiSelectField',
            Translation      => 0,
            Values           => \%Type,
        );

        unshift @ObjectAttributes, \%ObjectAttribute1;
    }

    if ( $Self->{ConfigObject}->Get('Stats::UseAgentElementInStats') ) {

        my @ObjectAttributeAdd = (
            {
                Name             => 'Agent/Owner',
                UseAsXvalue      => 0,
                UseAsValueSeries => 0,
                UseAsRestriction => 1,
                Element          => 'OwnerIDs',
                Block            => 'MultiSelectField',
                Translation      => 0,
                Values           => \%UserList,
            },
            {
                Name             => 'Created by Agent/Owner',
                UseAsXvalue      => 0,
                UseAsValueSeries => 0,
                UseAsRestriction => 1,
                Element          => 'CreatedUserIDs',
                Block            => 'MultiSelectField',
                Translation      => 0,
                Values           => \%UserList,
            },
            {
                Name             => 'Responsible',
                UseAsXvalue      => 0,
                UseAsValueSeries => 0,
                UseAsRestriction => 1,
                Element          => 'ResponsibleIDs',
                Block            => 'MultiSelectField',
                Translation      => 0,
                Values           => \%UserList,
            },
        );

        push @ObjectAttributes, @ObjectAttributeAdd;
    }

    if ( $Self->{ConfigObject}->Get('Stats::CustomerIDAsMultiSelect') ) {

        # Get CustomerID
        # (This way also can be the solution for the CustomerUserID)
        $Self->{DBObject}->Prepare(
            SQL => "SELECT DISTINCT customer_id FROM ticket",
        );

        # fetch the result
        my %CustomerID;
        while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
            if ( $Row[0] ) {
                $CustomerID{ $Row[0] } = $Row[0];
            }
        }

        my %ObjectAttribute = (
            Name             => 'CustomerID',
            UseAsXvalue      => 0,
            UseAsValueSeries => 0,
            UseAsRestriction => 1,
            Element          => 'CustomerID',
            Block            => 'MultiSelectField',
            Values           => \%CustomerID,
        );

        push @ObjectAttributes, \%ObjectAttribute;
    }
    else {

        my %ObjectAttribute = (
            Name             => 'CustomerID',
            UseAsXvalue      => 0,
            UseAsValueSeries => 0,
            UseAsRestriction => 1,
            Element          => 'CustomerID',
            Block            => 'InputField',
        );

        push @ObjectAttributes, \%ObjectAttribute;
    }

    return @ObjectAttributes;
}



=item GetStatTable()

Return the data of the Report/Stat (wherever you prefer to call it =D)

    my @Data = $Self->GetStatTable();

=cut


sub GetStatTable {
    my ( $Self, %Param ) = @_;
    my %TicketAttributes = map { $_ => 1 } @{ $Param{XValue}{SelectedValues} };
    my $SortedAttributesRef = $Self->_SortedAttributes();

    # COMPLEMENTO: Restrictions
    my $Restriction='';

    if ($Param{Restrictions}->{QueueIDs}){
        if (ref $Param{Restrictions}->{QueueIDs} eq 'ARRAY' ){
           $Restriction.=" and t.queue_id in (".join(",",@{$Param{Restrictions}->{QueueIDs}}).") \n"
        } 
    }
    if ($Param{Restrictions}->{ServiceIDs}){
        if (ref $Param{Restrictions}->{ServiceIDs} eq 'ARRAY' ){
           $Restriction.=" and t.service_id in (".join(",",@{$Param{Restrictions}->{ServiceIDs}}).") \n"
        } 
    }
    if ($Param{Restrictions}->{SLAIDs}){
        if (ref $Param{Restrictions}->{SLAIDs} eq 'ARRAY' ){
           $Restriction.=" and t.sla_id in (".join(",",@{$Param{Restrictions}->{SLAIDs}}).") \n"
        } 
    }
    if ($Param{Restrictions}->{StateIDs}){
        if (ref $Param{Restrictions}->{StateIDs} eq 'ARRAY' ){
           $Restriction.=" and t.ticket_state_id in (".join(",",@{$Param{Restrictions}->{StateIDs}}).") \n"
        } 
    }
    if ($Param{Restrictions}->{OwnerIDs}){
        if (ref $Param{Restrictions}->{OwnerIDs} eq 'ARRAY' ){
           $Restriction.=" and t.user_id in (".join(",",@{$Param{Restrictions}->{OwnerIDs}}).") \n"
        } 
    }
    if ($Param{Restrictions}->{CreatedUserIDs}){
        if (ref $Param{Restrictions}->{CreatedUserIDs} eq 'ARRAY' ){
           $Restriction.=" and t.create_by in (".join(",",@{$Param{Restrictions}->{CreatedUserIDs}}).") \n"
        } 
    }
    if ($Param{Restrictions}->{ResponsibleIDs}){
        if (ref $Param{Restrictions}->{ResponsibleIDs} eq 'ARRAY' ){
           $Restriction.=" and t.responsible_user_id in (".join(",",@{$Param{Restrictions}->{ResponsibleIDs}}).") \n"
        } 
    }
    if ($Param{Restrictions}->{TypeIDs}){
        if (ref $Param{Restrictions}->{TypeIDs} eq 'ARRAY' ){
           $Restriction.=" and t.type_id in (".join(",",@{$Param{Restrictions}->{TypeIDs}}).") \n"
        } 
    }
    if ($Param{Restrictions}->{CustomerID}){
        if (ref $Param{Restrictions}->{CustomerID} eq 'ARRAY' ){
           $Restriction.=" and t.customer_id in ('".join("','",@{$Param{Restrictions}->{CustomerID}})."') \n"
        } 
    }
    if ($Param{Restrictions}->{TicketCreateTimeNewerDate}){
       $Restriction.=" and t.create_time between 
                              '$Param{Restrictions}{TicketCreateTimeNewerDate}'
                             and 
                              '$Param{Restrictions}{TicketCreateTimeOlderDate}' "
    }
     if ($Param{Restrictions}->{TicketChangeTimeNewerDate}){
       $Restriction.=" and a.change_time between 
                              '$Param{Restrictions}{TicketChangeTimeNewerDate}'
                             and 
                              '$Param{Restrictions}{TicketChangeTimeOlderDate}' "
    }



	my $SQL = "";	
 	my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
	my $Ini = $ConfigObject->Get('Ticket::Complemento::AccountedTime::DynamicFieldStartID');
	my $End = $ConfigObject->Get('Ticket::Complemento::AccountedTime::DynamicFieldEndID');
	my $Accredit = $ConfigObject->Get("Ticket::Complemento::AccountedTime::DynamicFieldAccredit");
	my $CustomerCompanyHiredHours = $ConfigObject->Get("Ticket::Complemento::AccountedTime::CustomerCountHours");	
	    # get config data
    $Self->{DSN}  = $ConfigObject->Get('DatabaseDSN');
	if ( $Self->{DSN} =~ /:mysql/i ) {  
    	# Construct SQL    
		$SQL = "
			 SELECT cc.customer_id as CustomerID,
			 sum(TIME_TO_SEC(TIMEDIFF(f.fim,i.inicio))/60) as HorasBrutas, 
			 sum(ab.abonadas) as HorasAbonadas
				from 
				 (SELECT field_id,object_id, value_date as inicio FROM dynamic_field_value as d where field_id= $Ini ) i  
				left join 
					(SELECT object_id, value_date as fim FROM dynamic_field_value as d where field_id= $End) f on i.object_id = f.object_id 
				LEFT JOIN article a 
				ON i.object_id = a.id 
					LEFT JOIN ticket t 
				ON   t.id = a.ticket_id 
				LEFT JOIN 
					(SELECT object_id, value_text as abonadas FROM dynamic_field_value as d where field_id = $Accredit) ab on ab.object_id = f.object_id
				LEFT JOIN 
					customer_company cc
				on 	cc.customer_id = t.customer_id
							
		";
	}
	$SQL .= " where  cc.customer_id != '' ";
    $SQL .= "  $Restriction  " if ($Restriction);
	$SQL .= " group by t.customer_id ";  

# $Self->{LogObject}->Log(
#     Priority=>'error',
 #    Message =>"jjjjjjjjjjjjjjjjjj \n$SQL",
#
 #);
# 
    $Self->{DBObject}->Prepare(
        SQL => $SQL,
    );

    # generate the ticket list
    my @DB;
	my $SumTotal = 0;
	my $SumFreeHours = 0;
	my $SumDescountHours = 0;
	my $HiredHours = 0;
    # Map SQL Columns into attributes
    my %SQLParameters = (
        CustomerID    => 0,
        HorasBrutas           => 1,
		HorasLiquidas	=> 3,
		HorasAbonadas => 2,
		HorasContratadas => 4,
		
    );

    my $SortedAttributes = $Self->_SortedAttributes();


    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        push @DB, \@Row;
    };

    my @StatArray;
    my $index=-1;
    for my $RowLine (@DB){

        my @Row=@{$RowLine};
	
        my @ResumeRow;
        my $i=0;
        
        ATTRIBUTE:
        for my $Attribute ( @{$SortedAttributes} ) {

            next ATTRIBUTE if !$TicketAttributes{$Attribute};
	 			if($Attribute eq 'CustomerID'){
	 				my $CustomerCompanyObject = $Kernel::OM->Get('Kernel::System::CustomerCompany');
     			   	$ResumeRow[0]=$Row[0];
	 			   	if($Row[0] ne ""){	
						 my %CustomerCompany = $CustomerCompanyObject->CustomerCompanyGet(
     			  	    	CustomerID => $ResumeRow[0],
	     			  	 );
		 			  	 my $TotalHours = $CustomerCompany{$CustomerCompanyHiredHours} || 0;
	 				  	 $ResumeRow[4] = $TotalHours;
						 $HiredHours += $TotalHours; 
	 			   }
				   
     			}
	 			if($Attribute eq 'HorasBrutas')
	 			{
	 			   	my $TempDatas =$SQLParameters{$Attribute}?$Row[$SQLParameters{$Attribute}]:'';
	 			   	$SumTotal += $TempDatas;
	 			   		
	 			   	$ResumeRow[1]=$SQLParameters{$Attribute}?$Row[$SQLParameters{$Attribute}]:'';
	 			   	$ResumeRow[1] = FormatDate($TempDatas);
	 			  	
					my $DescountHour = $SQLParameters{HorasAbonadas}?$Row[$SQLParameters{HorasAbonadas}]:'0';
					#Converte a horas para minuto.
					
					$DescountHour = $DescountHour * 60 if($DescountHour);


					$TempDatas = $SQLParameters{$Attribute}?$Row[$SQLParameters{$Attribute}]:'';
					my $Calc = $TempDatas - $DescountHour;
					$SumFreeHours += $Calc;
 					$ResumeRow[2] = FormatDate($Calc);
	 			}elsif($Attribute eq "HorasAbonadas"){
	 			   	my $TempDatas = $SQLParameters{$Attribute}?$Row[$SQLParameters{$Attribute}]:'';
	 			   	if($TempDatas ne ""){
	 			   		my $Temp = int($TempDatas);
	 			   		$Temp = "0".$Temp if(length $Temp eq 1);
	 			   		$TempDatas = $Temp;
	 			   	}else{
						$TempDatas = 0;
					}
					$SumDescountHours += $TempDatas;	 			   		
	 			   	$ResumeRow[3] = $TempDatas ;
				

				}

     			       
            $i++;
        }
        # Armazena a ultima linha verificada
        
        push @StatArray, \@ResumeRow;
    }
	my @Sum;
	$Sum[0] = "Total";
	$Sum[1] = FormatDate($SumTotal) ;
	$Sum[2] = FormatDate($SumFreeHours);
	$Sum[3] = $SumDescountHours;
	$Sum[4] = $HiredHours;
	push @StatArray, \@Sum;
    # add a enumeration in front of each row
    return @StatArray;
}

sub GetHeaderLine {
    my ( $Self, %Param ) = @_;
    my %SelectedAttributes = map { $_ => 1 } @{ $Param{XValue}{SelectedValues} };

    my $TicketAttributes    = $Self->_Attributes();
    my $SortedAttributesRef = $Self->_SortedAttributes();
    my @HeaderLine;

    ATTRIBUTE:
    for my $Attribute ( @{$SortedAttributesRef} ) {
        next ATTRIBUTE if !$SelectedAttributes{$Attribute};
        push @HeaderLine, $TicketAttributes->{$Attribute};
    }
    
    return \@HeaderLine;
}

sub ExportWrapper {
    my ( $Self, %Param ) = @_;

    # wrap ids to used spelling
    for my $Use (qw(UseAsValueSeries UseAsRestriction UseAsXvalue)) {
        ELEMENT:
        for my $Element ( @{ $Param{$Use} } ) {
            next ELEMENT if !$Element || !$Element->{SelectedValues};
            my $ElementName = $Element->{Element};
            my $Values      = $Element->{SelectedValues};

            if ( $ElementName eq 'QueueIDs' || $ElementName eq 'CreatedQueueIDs' ) {
                ID:
                for my $ID ( @{$Values} ) {
                    next ID if !$ID;
                    $ID->{Content} = $Self->{QueueObject}->QueueLookup( QueueID => $ID->{Content} );
                }
            }
            elsif ( $ElementName eq 'StateIDs' || $ElementName eq 'CreatedStateIDs' ) {
                my %StateList = $Self->{StateObject}->StateList( UserID => 1 );
                ID:
                for my $ID ( @{$Values} ) {
                    next ID if !$ID;
                    $ID->{Content} = $StateList{ $ID->{Content} };
                }
            }
            elsif ( $ElementName eq 'PriorityIDs' || $ElementName eq 'CreatedPriorityIDs' ) {
                my %PriorityList = $Self->{PriorityObject}->PriorityList( UserID => 1 );
                ID:
                for my $ID ( @{$Values} ) {
                    next ID if !$ID;
                    $ID->{Content} = $PriorityList{ $ID->{Content} };
                }
            }
            elsif (
                $ElementName    eq 'OwnerIDs'
                || $ElementName eq 'CreatedUserIDs'
                || $ElementName eq 'ResponsibleIDs'
                )
            {
                ID:
                for my $ID ( @{$Values} ) {
                    next ID if !$ID;
                    $ID->{Content} = $Self->{UserObject}->UserLookup( UserID => $ID->{Content} );
                }
            }

            # Locks and statustype don't have to wrap because they are never different
        }
    }
    return \%Param;
}

sub ImportWrapper {
    my ( $Self, %Param ) = @_;

    # wrap used spelling to ids
    for my $Use (qw(UseAsValueSeries UseAsRestriction UseAsXvalue)) {
        ELEMENT:
        for my $Element ( @{ $Param{$Use} } ) {
            next ELEMENT if !$Element || !$Element->{SelectedValues};
            my $ElementName = $Element->{Element};
            my $Values      = $Element->{SelectedValues};

            if ( $ElementName eq 'QueueIDs' || $ElementName eq 'CreatedQueueIDs' ) {
                ID:
                for my $ID ( @{$Values} ) {
                    next ID if !$ID;
                    if ( $Self->{QueueObject}->QueueLookup( Queue => $ID->{Content} ) ) {
                        $ID->{Content}
                            = $Self->{QueueObject}->QueueLookup( Queue => $ID->{Content} );
                    }
                    else {
                        $Self->{LogObject}->Log(
                            Priority => 'error',
                            Message  => "Import: Can' find the queue $ID->{Content}!"
                        );
                        $ID = undef;
                    }
                }
            }
            elsif ( $ElementName eq 'StateIDs' || $ElementName eq 'CreatedStateIDs' ) {
                ID:
                for my $ID ( @{$Values} ) {
                    next ID if !$ID;

                    my %State = $Self->{StateObject}->StateGet(
                        Name  => $ID->{Content},
                        Cache => 1,
                    );
                    if ( $State{ID} ) {
                        $ID->{Content} = $State{ID};
                    }
                    else {
                        $Self->{LogObject}->Log(
                            Priority => 'error',
                            Message  => "Import: Can' find state $ID->{Content}!"
                        );
                        $ID = undef;
                    }
                }
            }
            elsif ( $ElementName eq 'PriorityIDs' || $ElementName eq 'CreatedPriorityIDs' ) {
                my %PriorityList = $Self->{PriorityObject}->PriorityList( UserID => 1 );
                my %PriorityIDs;
                for my $Key ( keys %PriorityList ) {
                    $PriorityIDs{ $PriorityList{$Key} } = $Key;
                }
                ID:
                for my $ID ( @{$Values} ) {
                    next ID if !$ID;

                    if ( $PriorityIDs{ $ID->{Content} } ) {
                        $ID->{Content} = $PriorityIDs{ $ID->{Content} };
                    }
                    else {
                        $Self->{LogObject}->Log(
                            Priority => 'error',
                            Message  => "Import: Can' find priority $ID->{Content}!"
                        );
                        $ID = undef;
                    }
                }
            }
            elsif (
                $ElementName    eq 'OwnerIDs'
                || $ElementName eq 'CreatedUserIDs'
                || $ElementName eq 'ResponsibleIDs'
                )
            {
                ID:
                for my $ID ( @{$Values} ) {
                    next ID if !$ID;

                    if ( $Self->{UserObject}->UserLookup( UserLogin => $ID->{Content} ) ) {
                        $ID->{Content} = $Self->{UserObject}->UserLookup(
                            UserLogin => $ID->{Content}
                        );
                    }
                    else {
                        $Self->{LogObject}->Log(
                            Priority => 'error',
                            Message  => "Import: Can' find user $ID->{Content}!"
                        );
                        $ID = undef;
                    }
                }
            }

            # Locks and statustype don't have to wrap because they are never different
        }
    }
    return \%Param;
}

=item _Attributes()

Return the attributes that can be printed on this report

    my %Attributes = $Self->_Attributes();

=cut

sub _Attributes{
    my $Self = shift;

    my %Attributes;

    my @Properties = qw (
        CustomerID HorasBrutas HorasLiquidas HorasAbonadas HorasContratadas
    );
    %Attributes = map { $_ => $_ } @Properties;


    
    return \%Attributes;
}


sub _SortedAttributes {
    my $Self = shift;

    my @SortedAttributes = qw (
		CustomerID HorasBrutas HorasLiquidas  HorasAbonadas HorasContratadas
    );

    return \@SortedAttributes;
}

sub _OrderByIsValueOfTicketSearchSort {
    my ( $Self, %Param ) = @_;

    my %SortOptions = (
        CustomerID             => 'CustomerID',
		HorasBrutas		   	   => 'HorasBrutas',
		HorasLiquidas		   => 'HorasLiquidas',
		HorasContratadas	   => 'HorasContratadas',
		HorasAbonadas 		   => 'HorasAbonadas',
    );

    # cycle trought the Dynamic Fields
    DYNAMICFIELD:
    for my $DynamicFieldConfig ( @{ $Self->{DynamicField} } ) {
        next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);
        next DYNAMICFIELD if !$DynamicFieldConfig->{Name};

        # get dynamic field sortable condition
        my $IsSortable = $Self->{BackendObject}->IsSortable(
            DynamicFieldConfig => $DynamicFieldConfig
        );

        # add dynamic field if is sortable
        if ($IsSortable) {
            $SortOptions{ 'DynamicField_' . $DynamicFieldConfig->{Name} }
                = 'DynamicField_' . $DynamicFieldConfig->{Name};
        }
    }

    return $SortOptions{ $Param{OrderBy} } if $SortOptions{ $Param{OrderBy} };
    return;
}

sub _IndividualResultOrder {
    my ( $Self, %Param ) = @_;
    my @Unsorted = @{ $Param{StatArray} };
    my @Sorted;

    # find out the positon of the values which should be
    # used for the order
    my $Counter          = 0;
    my $SortedAttributes = $Self->_SortedAttributes();

    ATTRIBUTE:
    for my $Attribute ( @{$SortedAttributes} ) {
        next ATTRIBUTE if !$Param{SelectedAttributes}{$Attribute};
        last ATTRIBUTE if $Attribute eq $Param{OrderBy};
        $Counter++;
    }

    # order after a individual attribute
    if ( $Param{OrderBy} eq 'AccountedTime' ) {
        @Sorted = sort { $a->[$Counter] <=> $b->[$Counter] } @Unsorted;
    }
    elsif ( $Param{OrderBy} eq 'SolutionTime' ) {
        @Sorted = sort { $a->[$Counter] cmp $b->[$Counter] } @Unsorted;
    }
    elsif ( $Param{OrderBy} eq 'SolutionDiffInMin' ) {
        @Sorted = sort { $a->[$Counter] <=> $b->[$Counter] } @Unsorted;
    }
    elsif ( $Param{OrderBy} eq 'SolutionInMin' ) {
        @Sorted = sort { $a->[$Counter] <=> $b->[$Counter] } @Unsorted;
    }
    elsif ( $Param{OrderBy} eq 'SolutionTimeWorkingTime' ) {
        @Sorted = sort { $a->[$Counter] <=> $b->[$Counter] } @Unsorted;
    }
    elsif ( $Param{OrderBy} eq 'FirstResponse' ) {
        @Sorted = sort { $a->[$Counter] cmp $b->[$Counter] } @Unsorted;
    }
    elsif ( $Param{OrderBy} eq 'FirstResponseDiffInMin' ) {
        @Sorted = sort { $a->[$Counter] <=> $b->[$Counter] } @Unsorted;
    }
    elsif ( $Param{OrderBy} eq 'FirstResponseInMin' ) {
        @Sorted = sort { $a->[$Counter] <=> $b->[$Counter] } @Unsorted;
    }
    elsif ( $Param{OrderBy} eq 'FirstResponseTimeWorkingTime' ) {
        @Sorted = sort { $a->[$Counter] <=> $b->[$Counter] } @Unsorted;
    }
    elsif ( $Param{OrderBy} eq 'FirstLock' ) {
        @Sorted = sort { $a->[$Counter] cmp $b->[$Counter] } @Unsorted;
    }
    elsif ( $Param{OrderBy} eq 'StateType' ) {
        @Sorted = sort { $a->[$Counter] cmp $b->[$Counter] } @Unsorted;
    }
    elsif ( $Param{OrderBy} eq 'UntilTime' ) {
        @Sorted = sort { $a->[$Counter] <=> $b->[$Counter] } @Unsorted;
    }
    elsif ( $Param{OrderBy} eq 'UnlockTimeout' ) {
        @Sorted = sort { $a->[$Counter] <=> $b->[$Counter] } @Unsorted;
    }
    elsif ( $Param{OrderBy} eq 'EscalationResponseTime' ) {
        @Sorted = sort { $a->[$Counter] <=> $b->[$Counter] } @Unsorted;
    }
    elsif ( $Param{OrderBy} eq 'EscalationUpdateTime' ) {
        @Sorted = sort { $a->[$Counter] <=> $b->[$Counter] } @Unsorted;
    }
    elsif ( $Param{OrderBy} eq 'EscalationSolutionTime' ) {
        @Sorted = sort { $a->[$Counter] <=> $b->[$Counter] } @Unsorted;
    }
    elsif ( $Param{OrderBy} eq 'RealTillTimeNotUsed' ) {
        @Sorted = sort { $a->[$Counter] <=> $b->[$Counter] } @Unsorted;
    }
    elsif ( $Param{OrderBy} eq 'EscalationTimeWorkingTime' ) {
        @Sorted = sort { $a->[$Counter] <=> $b->[$Counter] } @Unsorted;
    }
    else {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message =>
                "There is no possibility to order the stats by $Param{OrderBy}! Sort it alpha numerical",
        );
        @Sorted = sort { $a->[$Counter] cmp $b->[$Counter] } @Unsorted;
    }

    # make a reverse sort if needed
    if ( $Param{Sort} eq 'Down' ) {
        @Sorted = reverse @Sorted;
    }

    # take care about the limit
    if ( $Param{Limit} && $Param{Limit} ne 'unlimited' ) {
        my $Count = 0;
        @Sorted = grep { ++$Count <= $Param{Limit} } @Sorted;
    }

    return @Sorted;
}
sub FormatDate{
	my $TempDatas = shift;
	if($TempDatas > 0){           
		my $HH = int($TempDatas/60);
		$HH = "0".$HH if(length $HH eq 1);
		my $MM = $TempDatas%60 ;
		$MM = "0".$MM if(length $MM eq 1);
		$TempDatas = "$HH:$MM";
		return $TempDatas;
	}
	return $TempDatas;

}
1;
