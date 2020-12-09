# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::AccountedTime;

use strict;
use warnings;
use POSIX;
use Data::Dumper;
use Kernel::System::VariableCheck qw(:all);
use Kernel::Language qw(Translatable);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::CustomerCompany',
    'Kernel::System::DB',
    'Kernel::System::Log',
    'Kernel::System::Main',
);
sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');


    return $Self;
}

=item GetAccountedTimeQuotasPerMonth()

Returns the accounted time per month in quotas "UnderContract" and "ExtraScope",
According to the defined ticket types

    my %AccountedTimeQuotas = $AccountedTime->GetAccountedTimeQuotasPerMonth(
        CustomerID => '1234567890123456',  # Required
        Months     => '12',  # Optional - NOT IMPLEMENTED YET 
    );


    %Result = {
        "Under Contract" => [
            30,
            333,
            12,
            .
            .
        ],
        "Extra Scope" => [
            22,
            31,
            13
            .
            .
        ]
            
    }
=cut

sub GetAccountedTimeQuotasPerMonth{
	my ( $Self, %Param) = @_;
    if ( !$Param{CustomerID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Got no CustomerID!'
        );
        return;
    }

	my $DBObject = $Kernel::OM->Get("Kernel::System::DB");

    # Pega os Tipos de Ticket "UnderContract"
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my @UnderContractTypes = @{$ConfigObject->Get("Ticket::Complemento::AccountedTime::UnderContractTicketTypes")};

    # Faz um loop para os últimos 12 meses
    #my $TimeObject = $Kernel::OM->Get('Kernel::System::Time');
    my @t = localtime();
    my $c = 0;
    my @ResultUnderContract;
    my @ResultExtraScope;
    my %Result;
    
    MONTH:
    while ($c < 12){
        # Mês em Análise
        my $newmonth = mktime(@t);
        my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime($newmonth);
        my $Month = $mon+1;
        my $Year  = $year+1900;
		if(length $Month eq 1){
            $Month = "0".$Month;
    	    $Month = "01" if ($Month eq 0);
        }
        # Mês seguinte (para podermos obter o dia 1 do proximo mes)
        my @nt = @t;
        $nt[4] ++;
        my $nextmonth = mktime(@nt);
        my ($nsec,$nmin,$nhour,$nmday,$nmon,$nyear,$nwday,$nyday,$nisdst) = localtime($nextmonth);
        my $NMonth = $nmon+1;
        my $NYear  = $nyear+1900;
		if(length $NMonth eq 1){
            $NMonth = "0".$NMonth;
    	    $NMonth = "01" if ($NMonth eq 0);
        }

        $t[4] --;  # $t[4] is tm_mon
        $c++;

        # Para cada mês, seleciona tempo contabilizado pelo banco
        my $SQL = "SELECT i.customer_id, y.name as ticket_type, sum(t.time_unit) FROM time_accounting t 
                    inner join ticket i on t.ticket_id = i.id
                    inner join ticket_type y on i.type_id = y.id
                    where t.create_time between '$Year-$Month-01 00:00:00' and '$NYear-$NMonth-01 00:00:00'
                    and i.customer_id = '$Param{CustomerID}'
                    group by i.customer_id, y.name";

        return if !$DBObject->Prepare(
            SQL  => $SQL,
            #Bind => [  \$Param{CustomerID}  ],
        );
        
        # Para cada linha soma a categoria (UnderContract ExtraScope)
        my $UnderContract = 0;
        my $ExtraScope = 0; 
        
        while ( my @Row = $DBObject->FetchrowArray() ) {
            if ( grep /$Row[1]/, @UnderContractTypes ) {
                $UnderContract += ($Row[2]/60);
            } else {
                $ExtraScope += ($Row[2]/60);
            }
        }

        # Dá um push da Categoria em seu array
        push @ResultUnderContract,$UnderContract;
        push @ResultExtraScope,$ExtraScope;
    }
    
    @ResultUnderContract = reverse @ResultUnderContract;
    @ResultExtraScope = reverse @ResultExtraScope;
    
    $Result{"Under Contract"} = \@ResultUnderContract;
    $Result{"Extra Scope"} = \@ResultExtraScope;
    return %Result;
}

=item GetAccountedTimeInMonth()

Returns the accounted time in the month. You can use + or - signals to seek
for months ahead or behind

    my $AccountedTime = $AccountedTime->GetAccountedTimeInMonth(
        CustomerID => '1234567890123456',  # Required
        Month     => -1 || -2 || 3 || 0,  # Optional, default is 0
    );

    $Result = 123
=cut

sub GetAccountedInMonth{
	my ( $Self, %Param) = @_;
    if ( !$Param{CustomerID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Got no CustomerID!'
        );
        return;
    }

	my $DBObject = $Kernel::OM->Get("Kernel::System::DB");

    # Pega os Tipos de Ticket "UnderContract"
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my @UnderContractTypes = @{$ConfigObject->Get("Ticket::Complemento::AccountedTime::UnderContractTicketTypes")};
    
    my @t = localtime();
    my @ResultUnderContract;

    $t[4] = $t[4] + $Param{Month};

    # Mês em Análise
    my $newmonth = mktime(@t);
    my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime($newmonth);
    my $Month = $mon+1;
    my $Year  = $year+1900;
    if(length $Month eq 1){
        $Month = "0".$Month;
        $Month = "01" if ($Month eq 0);
    }
    # Mês seguinte (para podermos obter o dia 1 do proximo mes)
    my @nt = @t;
    $nt[4] ++;
    my $nextmonth = mktime(@nt);
    my ($nsec,$nmin,$nhour,$nmday,$nmon,$nyear,$nwday,$nyday,$nisdst) = localtime($nextmonth);
    my $NMonth = $nmon+1;
    my $NYear  = $nyear+1900;
    if(length $NMonth eq 1){
        $NMonth = "0".$NMonth;
        $NMonth = "01" if ($NMonth eq 0);
    }

    # seleciona tempo contabilizado pelo banco
    my $SQL = "SELECT i.customer_id, y.name as ticket_type, sum(t.time_unit) FROM time_accounting t 
                inner join ticket i on t.ticket_id = i.id
                inner join ticket_type y on i.type_id = y.id
                where t.create_time between '$Year-$Month-01 00:00:00' and '$NYear-$NMonth-01 00:00:00'
                and i.customer_id = '$Param{CustomerID}'
                group by i.customer_id, y.name";

    return if !$DBObject->Prepare(
        SQL  => $SQL,
        #Bind => [  \$Param{CustomerID}  ],
    );
    
    # Para cada linha soma a categoria (UnderContract ExtraScope)
    my $UnderContract = 0;

    while ( my @Row = $DBObject->FetchrowArray() ) {
        if ( grep /^$Row[1]$/, @UnderContractTypes ) {
            $UnderContract += ($Row[2]);
        }
    }
    
    $UnderContract =  sprintf("%02d:%02d", $UnderContract/60, $UnderContract%60);

    return $UnderContract;
}


sub getUsedTimeByTicket{
	my ( $Self, %Param) = @_;
	if(!$Param{CustomerID} or !$Param{TicketID}){	
	    $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need Params!'
        );
        return;

	}	
	my $Smaller = $Param{Smaller};
	my $Greater = $Param{Greater};
	my $SQL = "";	
 	my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # get config data
    $Self->{DSN}  = $ConfigObject->Get('DatabaseDSN');

	$SQL = "SELECT time_unit as Minutes, MONTHNAME(c.create_time), c.article_id, c.ticket_id ";
	$SQL .= " FROM time_accounting as c";
	$SQL .= " left join article a on c.article_id = a.id LEFT JOIN ticket t ON   t.id = a.ticket_id"; 
	$SQL .= " WHERE  1 = 1 ";

	$SQL .=  " AND create_time >= "."\' $Greater\' " if($Greater);
	$SQL .=  " AND create_time <= " ." \' $Smaller \' " if($Smaller);
	$SQL .=  " AND t.customer_id = ? AND a.ticket_id = ? ";

	my %HashTime;
	my $DBObject = $Kernel::OM->Get("Kernel::System::DB");
	return if !$DBObject->Prepare(
		SQL  => $SQL,
		Bind => [ \$Param{CustomerID},  \$Param{TicketID} ],
	);
	my $Total = 0;
	while ( my @Row = $DBObject->FetchrowArray() ) {
		$HashTime{Horas} += $Row[0];
	}
	if(defined($HashTime{Horas})){
		$HashTime{Horas}  = sprintf("%dh %dm", $HashTime{Horas}/60, $HashTime{Horas}%60);
	}else{
		$HashTime{Horas} = 0;
	}

	return %HashTime;

}

sub getMonthUsedTime{
    my $TimeObject = $Kernel::OM->Get('Kernel::System::Time');

	#Return In Minutes
	my ( $Self, %Param) = @_;
	if(!$Param{Ini} or  !$Param{End} or !$Param{CustomerID} or !$Param{Month} or !$Param{Year}){
	    $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need Params!'
        );
        return;
	}
	
	my $Year = $Param{Year};
	my $Month = $Param{Month};

    my $SystemTime = $TimeObject->TimeStamp2SystemTime(
        String => "$Year-$Month-01 00:00:00",
    );
    my @t = localtime($SystemTime);
    $t[4] ++;  # $t[4] is tm_mon
    $t[3] ++;
    my $newmonth = mktime(@t);
    my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime($newmonth);

	my $NextYear = $year+1900;
	my $NextMonth = $mon+1;
	my $SQL = "";	
 	my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # get config data
    $Self->{DSN}  = $ConfigObject->Get('DatabaseDSN');
	$SQL = "SELECT c.time_unit as time_unit ";
	$SQL .= "FROM  time_accounting as c ";
	$SQL .= " left join article a on c.article_id = a.id LEFT JOIN ticket t ON   t.id = a.ticket_id"; 
	$SQL .=  " WHERE t.customer_id = ? ";
	$SQL .=  " AND c.create_time between '$Year-$Month-01 00:00:00' and '$NextYear-$NextMonth-01 00:00:00' ";
	my $DBObject = $Kernel::OM->Get("Kernel::System::DB");
	return if !$DBObject->Prepare(
		SQL  => $SQL,
		Bind => [ \$Param{CustomerID}],
	);
	my $Time=0;
	while ( my @Row = $DBObject->FetchrowArray() ) {
	        $Row[0] =~ s/,/./g;
	        $Time += $Row[0];
	}
	return $Time;
}
sub getUsedTime{
	#Return In Minutes
	my ( $Self, %Param) = @_;
	if(!$Param{Ini} or  !$Param{End} or !$Param{CustomerID}){	
		$Kernel::OM->Get('Kernel::System::Log')->Log(
			Priority => 'error',
			Message  => 'Need Params!'
		);
		return;

	}	
	my $SQL = "";	
	my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

	# get config data
	$Self->{DSN}  = $ConfigObject->Get('DatabaseDSN');
	if ( $Self->{DSN} =~ /:mysql/i ) {

		$SQL = "SELECT time_unit as Minutes, MONTHNAME(c.create_time), c.article_id, c.ticket_id ";
		$SQL .= " FROM time_accounting as c";
		$SQL .= " left join article a on c.article_id = a.id LEFT JOIN ticket t ON   t.id = a.ticket_id"; 
		$SQL .= " WHERE  1 = 1 ";

#		$SQL .=  " AND create_time >= "."\' $Greater\' " if($Greater);
#		$SQL .=  " AND create_time <= " ." \' $Smaller \' " if($Smaller);
		$SQL .=  " AND t.customer_id = ?";

#		$SQL = "SELECT (TIME_TO_SEC(d.value_date))/60 as Minutes, MONTHNAME(d.value_date) as month,field_id,object_id, d.value_date FROM  dynamic_field_value d LEFT JOIN article a  ON  d.object_id = a.id LEFT JOIN ticket t ON   t.id = a.ticket_id where d.field_id in (?,?) and t.customer_id = ? ";			
	}elsif ( $Self->{DSN} =~ /:pg/i ) {
#		$SQL = "Select extract (epoch from (d.value_date))::integer/60 as Minutes, select to_char ( TIMESTAMP d.value_date) as month,field_id,object_id, d.value_date FROM  dynamic_field_value d LEFT JOIN article a  ON  d.object_id = a.id LEFT JOIN ticket t ON   t.id = a.ticket_id where d.field_id in (?,?) and t.customer_id = ? ";			

	}
	#my $SQL = "SELECT (TIME_TO_SEC(d.value_date))/60 as Minutes, MONTHNAME(d.value_date) as month,field_id,object_id, d.value_date FROM  dynamic_field_value d LEFT JOIN article a  ON  d.object_id = a.id LEFT JOIN ticket t ON   t.id = a.ticket_id where d.field_id in (?,?) and t.customer_id = ? ";			
	my %HashTime =(
				January 	=> 0,
				February	=> 0,
				March		=> 0,
				April		=> 0,
				May   		=> 0,
				June 		=> 0,
				July		=> 0,
				August          => 0,
				September 	=> 0,
				October		=> 0,
				November 	=> 0,
				December	=> 0, 
	);
	my $DBObject = $Kernel::OM->Get("Kernel::System::DB");
	return if !$DBObject->Prepare(
		SQL  => $SQL,
		Bind => [  \$Param{CustomerID}  ],
	);
	while ( my @Row = $DBObject->FetchrowArray() ) {
		if($Param{Ini} eq $Row[2]){
			$HashTime{$Row[1]} -= $Row[0]; 		
		}else{
			$HashTime{$Row[1]} += $Row[0];
		}
	}

	return %HashTime;
}

1;
