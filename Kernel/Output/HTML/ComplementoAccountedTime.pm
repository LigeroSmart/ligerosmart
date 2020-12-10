# --
# Kernel/Output/HTML/SubscriptionPlanWidget.pm
# Copyright (C) 2001-2009 OTRS AG, http://otrs.org/
# --
# $Id: CustomerUserGeneric.pm,v 1.5 2009/07/01 07:31:38 ub Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::ComplementoAccountedTime;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.5 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get needed objects
#    for (qw(ConfigObject LogObject DBObject LayoutObject UserID TicketObject)) {
#        $Self->{$_} = $Param{$_} || die "Got no $_!";
#    }
	
    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;
                    
	###	
	#
	#  Accounted time
	#'

	my $Out_d = 0;
	my $Text_out = 0;
	my $Out_d_t = 0;
	my $Text_out_t = 0;
    my $Total = 0;	
	my $Text_c = 0;
 	$Self->{DSN}  = $Kernel::OM->Get('Kernel::Config')->Get('DatabaseDSN');
    my $Ini = $Kernel::OM->Get('Kernel::Config')->Get('Ticket::Complemento::AccountedTime::DynamicFieldStartID');
    my $End = $Kernel::OM->Get('Kernel::Config')->Get('Ticket::Complemento::AccountedTime::DynamicFieldEndID');
	my $DBObject = $Kernel::OM->Get('Kernel::System::DB');
	my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

	## Out Commercial Time ##
	if($Param{Config}->{AccountedTimeOut} == 1) {
		  if ( $Self->{DSN} =~ /:mysql/i ) {  
			return if !$DBObject->Prepare(
				SQL  => "
					SELECT 
						TIME_TO_SEC(TIMEDIFF(f.fim, i.inicio))/60 as time 
							FROM
								(
								 SELECT object_id, value_date as inicio 
								 	FROM
										(
										 SELECT object_id, value_date, field_id FROM dynamic_field_value
											WHERE value_date
												 BETWEEN
														CONCAT(
														   year(now()),'/',month(now()),'/01') 
													AND 
														CONCAT( 
															year(now() + INTERVAL 1 MONTH),'/',month(now() + INTERVAL 1 MONTH),'/01')
										) 
										 AS i
											WHERE field_id = ?
												AND 
													HOUR(value_date) 
														BETWEEN
															? AND ?
												 OR
													HOUR(value_date)
														BETWEEN
															 ? AND ?
								)
							AS i
								INNER JOIN
											(
											 SELECT object_id, value_date as fim 
													FROM dynamic_field_value 
														WHERE field_id = ?
											)
							AS f
								ON i.object_id = f.object_id
									INNER JOIN
										article 
							AS a
								ON i.object_id = a.id
									INNER JOIN
										ticket
							AS t
								ON a.ticket_id = t.id
									WHERE customer_id = ?",
			
			Bind => [ \$Ini, \$Param{Config}->{TimeIntervalOne_1}, \$Param{Config}->{TimeIntervalOne_2}, 
					  \$Param{Config}->{TimeIntervalTwo_1}, \$Param{Config}->{TimeIntervalTwo_2},
					  \$End, \$Param{Data}->{"UserCustomerID"} ],
		);

			} elsif ( $Self->{DSN} =~ /:pg/i ) { 

		                                       
				return if !$DBObject->Prepare(
							SQL  => "	select extract (epoch from ( f.fim - i.inicio))::integer/60 as time from 
                            	                 FROM
                                            (
                                             SELECT object_id, value_date as ini	cio 
                                                    FROM
                                                            (
                                                                 SELECT object_id, value_date, field_id FROM dynamic_field_value
                                                                        WHERE value_date
																				 value_date >=   CONCAT(EXTRACT(YEAR FROM TIMESTAMP 'now()'),'/', EXTRACT(MONTH FROM TIMESTAMP 'now()'),'/01')::DATE  AND value_date <= CONCAT(EXTRACT(YEAR FROM TIMESTAMP 'now()  + INTERVAL 1 MONTH'),'/', EXTRACT(MONTH FROM TIMESTAMP 'now()  + INTERVAL 1 MONTH'),'/01')::DATE
                                                                ) 
                                                                 AS i
                                                                    WHERE field_id = ?
                                                                            AND 
																			 EXTRACT(HOUR FROM TIMESTAMP 'value_date') >= ?
																					AND 
																			 EXTRACT(HOUR FROM TIMESTAMP 'value_date') <= ?																
                                                                                    
                                                                             OR
                                                                       		 EXTRACT(HOUR FROM TIMESTAMP 'value_date') >= ?
																					AND 
																				EXTRACT(HOUR FROM TIMESTAMP 'value_date') <= ?		
                                            )
                                    AS i
                                            INNER JOIN
                                                                    (
                                                                     SELECT object_id, value_date as fim 
                                                                                    FROM dynamic_field_value 
                                                                                            WHERE field_id = ?
                                                                    )
                                    AS f
                                            ON i.object_id = f.object_id
                                                    INNER JOIN
                                                            article 
                                    AS a
                                            ON i.object_id = a.id
                                                    INNER JOIN
                                                            ticket
                                    AS t
                                            ON a.ticket_id = t.id
                                                        WHERE customer_id = ?",
			
			Bind => [ \$Ini, \$Param{Config}->{TimeIntervalOne_1}, \$Param{Config}->{TimeIntervalOne_2}, 
					  \$Param{Config}->{TimeIntervalTwo_1}, \$Param{Config}->{TimeIntervalTwo_2},
					  \$End, \$Param{Data}->{"UserCustomerID"} ],
			);

			
		}
		 my $ErrorMessage  =   "SELECT 
						TIME_TO_SEC(TIMEDIFF(f.fim, i.inicio))/60 as time 
							FROM
								(
								 SELECT object_id, value_date as inicio 
								 	FROM
										(
										 SELECT object_id, value_date, field_id FROM dynamic_field_value
											WHERE value_date
												 BETWEEN
														CONCAT(
														   year(now()),'/',month(now()),'/01') 
													AND 
														CONCAT( 
															year(now()  + INTERVAL 1 MONTH),'/',month(now() + INTERVAL 1 MONTH) ,'/01')
										) 
										 AS i
											WHERE field_id = ?
												AND 
													HOUR(value_date) 
														BETWEEN
															? AND ?
												 OR
													HOUR(value_date)
														BETWEEN
															 ? AND ?
								)
							AS i
								INNER JOIN
											(
											 SELECT object_id, value_date as fim 
													FROM dynamic_field_value 
														WHERE field_id = ?
											)
							AS f
								ON i.object_id = f.object_id
									INNER JOIN
										article 
							AS a
								ON i.object_id = a.id
									INNER JOIN
										ticket
							AS t
								ON a.ticket_id = t.id
									WHERE customer_id = ?";
		while ( my @Row = $DBObject->FetchrowArray() ) {
			$Row[0] =~ s/,/./g;
			$Out_d = $Out_d + $Row[0];
		}
		$Text_out  = sprintf("%dh %dm", $Out_d/60, $Out_d%60);

		## for ticket ##
	 	$Self->{DSN}  = $Kernel::OM->Get('Kernel::Config')->Get('DatabaseDSN');

		if ( $Self->{DSN} =~ /:mysql/i ) {
	
			return if !$DBObject->Prepare(
				SQL  => "
						select TIME_TO_SEC(TIMEDIFF(f.fim,i.inicio))/60 as time_unit from 
		            	(SELECT object_id, value_date as inicio FROM dynamic_field_value 
							where field_id=? and hour(value_date) between ? and ?
							or hour(value_date) between ? and ?	
						) i
		            	left join
		            	(SELECT object_id, value_date as fim FROM dynamic_field_value where field_id=?) f
		            	on i.object_id=f.object_id
		            	left join article a on i.object_id = a.id where a.ticket_id = ?",
					
						Bind => [ \$Ini, \$Param{Config}->{TimeIntervalOne_1}, \$Param{Config}->{TimeIntervalOne_2},
		                          \$Param{Config}->{TimeIntervalTwo_1}, \$Param{Config}->{TimeIntervalTwo_2},
								  \$End, \$Param{Data}->{"TicketID"} ],
			);
		} elsif ( $Self->{DSN} =~ /:pg/i ) {
			return if !$DBObject->Prepare(	
			SQL  => "Select extract (epoch from (d.value_date))::integer/60 as time_unit from ,
						(SELECT object_id, value_date as inicio FROM dynamic_field_value 
						where field_id=? and EXTRACT(HOUR FROM TIMESTAMP 'value_date') >= ?
												 	AND 
												 EXTRACT(HOUR FROM TIMESTAMP 'value_date') <= ?																
                                                 	OR
	                                                 EXTRACT(HOUR FROM TIMESTAMP 'value_date') >= ?
														AND 
													 EXTRACT(HOUR FROM TIMESTAMP 'value_date') <= ?	) i
		            	left join
		            	(SELECT object_id, value_date as fim FROM dynamic_field_value where field_id=?) f
		            	on i.object_id=f.object_id
		            	left join article a on i.object_id = a.id where a.ticket_id = ?",
				
					
						Bind => [ \$Ini, \$Param{Config}->{TimeIntervalOne_1}, \$Param{Config}->{TimeIntervalOne_2},
		                          \$Param{Config}->{TimeIntervalTwo_1}, \$Param{Config}->{TimeIntervalTwo_2},
								  \$End, \$Param{Data}->{"TicketID"} ],
			);
		}
		while ( my @Row = $DBObject->FetchrowArray() ) {
			$Row[0] =~ s/,/./g;
			$Out_d_t = $Out_d_t + $Row[0];
		}
		$Text_out_t  = sprintf("%dh %dm", $Out_d_t/60, $Out_d_t%60);
		
	}
	## Out Commercial Time ##
	#
	##
	
	## Commercial time ##
	if ($Param{Config}->{AccountedTime} == 1) {

	
		if ( $Self->{DSN} =~ /:mysql/i ) {

			return if !$DBObject->Prepare(
				SQL  => "select sum(TIME_TO_SEC(TIMEDIFF(f.fim,i.inicio))/60) as minutes
					 from (SELECT object_id, value_date as inicio 
							FROM dynamic_field_value where field_id= ?
							and value_date between concat(year(now()),'/',month(now()),'/01') and concat(year(now() + INTERVAL 1 MONTH ),'/',month(now() + INTERVAL 1 MONTH),'/01')) i 
					left join (SELECT object_id, value_date as fim FROM dynamic_field_value where field_id= ?) f
					 on i.object_id=f.object_id 
					left join article a on i.object_id = a.id
					left join ticket t on a.ticket_id = t.id
					where customer_id = ? ",
				Bind => [ \$Ini, \$End, \$Param{Data}->{"UserCustomerID"} ],
			);
	my $SQL = "select sum(TIME_TO_SEC(TIMEDIFF(f.fim,i.inicio))/60) as minutes
                     from (SELECT object_id, value_date as inicio 
                            FROM dynamic_field_value where field_id= ?
                            and value_date between concat(year(now()),'/',month(now()),'/01') and concat(year(now() + INTERVAL 1 MONTH),'/',month(now()  + INTERVAL 1 MONTH),'/01')) i 
                    left join (SELECT object_id, value_date as fim FROM dynamic_field_value where field_id= ?) f
                     on i.object_id=f.object_id 
                    left join article a on i.object_id = a.id
                    left join ticket t on a.ticket_id = t.id
                    where customer_id = ? ";
		}elsif ( $Self->{DSN} =~ /:pg/i ) {

				return if !$DBObject->Prepare(
				SQL  => "select sum( extract (epoch from ( f.fim - i.inicio))::integer/60) as minutes
					 from (SELECT object_id, value_date as inicio 
							FROM dynamic_field_value where field_id= ?
								and 
								 value_date >=   CONCAT(EXTRACT(YEAR FROM TIMESTAMP 'now()'),'/', EXTRACT(MONTH FROM TIMESTAMP 'now()'),'/01')::DATE 
									 AND 
								value_date <= CONCAT(EXTRACT(YEAR FROM TIMESTAMP 'now()  + INTERVAL 1 MONTH'),'/', EXTRACT(MONTH FROM TIMESTAMP 'now()  + INTERVAL 1 MONTH'),'/01')::DATE 
						  )i 
		  			      left join (SELECT object_id, value_date as fim FROM dynamic_field_value where field_id= ?) f
					 on i.object_id=f.object_id 
					left join article a on i.object_id = a.id
					left join ticket t on a.ticket_id = t.id
					where customer_id = ? ",
				Bind => [ \$Ini, \$End, \$Param{Data}->{"UserCustomerID"} ],
			);

		}
	my $SQL = "select sum( extract (epoch from ( f.fim - i.inicio))::integer/60) as minutes
					 from (SELECT object_id, value_date as inicio 
							FROM dynamic_field_value where field_id= ?
								and 
								 value_date >=   CONCAT(EXTRACT(YEAR FROM TIMESTAMP 'now()'),'/', EXTRACT(MONTH FROM TIMESTAMP 'now()'),'/01')::DATE 
									 AND 
								value_date <= CONCAT(EXTRACT(YEAR FROM TIMESTAMP 'now()  + INTERVAL 1 MONTH' ),'/', EXTRACT(MONTH FROM TIMESTAMP 'now()  + INTERVAL 1 MONTH'),'/01')::DATE
						  )i 
		  			      left join (SELECT object_id, value_date as fim FROM dynamic_field_value where field_id= ?) f
					 on i.object_id=f.object_id 
					left join article a on i.object_id = a.id
					left join ticket t on a.ticket_id = t.id
					where customer_id = ? ";

		while ( my @Row = $DBObject->FetchrowArray() ) {
			if(defined $Row[0] ){
				$Row[0] =~ s/,/./g;
				$Total += $Row[0];
			}
		}

		$Total -= $Out_d;
		$Text_c  = sprintf("%dh %dm", $Total/60, $Total%60);
		
		## generate block ##
		$LayoutObject->Block(
			Name => 'CustomerRow',
			Data => {
				%{ $Param{Config} },
				Key => $Param{Config}->{AccountedTimeText},
				ValueShort => $Text_c,
			},
		);
		
		## generate block ##
		if ( $Out_d != 0 ) {
			## generate block for client ##
			$LayoutObject->Block(
				Name => 'CustomerRow',
				Data => {
					%{ $Param{Config} },
					Key => $Param{Config}->{AccountedTimeOutText},
					ValueShort => $Text_out,
				},
			);
		}		
		## generate block ##
		if ( $Out_d_t != 0 ) {
			## generate block for ticket ##
			$LayoutObject->Block(
				Name => 'TotalAccountedTimeOut',
				Data => {
					%{ $Param{Config} },
					Key => $Param{Config}->{AccountedTimeOutText},
					ValueShort => $Text_out_t,
				},
			);
		}
	}
	## Commercial Time ##

	#
	#


    return 1;
}

1;
