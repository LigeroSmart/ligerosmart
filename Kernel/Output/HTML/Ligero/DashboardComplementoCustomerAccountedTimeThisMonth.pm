# --
# Kernel/Output/HTML/DashboardComplementoDouble.pm
# --
# $Id:
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::Ligero::DashboardComplementoCustomerAccountedTimeThisMonth;

use strict;
use warnings;
use Time::Local;
use vars qw($VERSION);

use Date::Pcalc
    qw(Add_Delta_YMD Add_Delta_DHMS Add_Delta_Days Days_in_Month Day_of_Week Day_of_Week_Abbreviation Day_of_Week_to_Text Monday_of_Week Week_of_Year);

$VERSION = qw($Revision: 1.2 $) [1];

use POSIX;
use Data::Dumper;

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # get needed objects
   

    return $Self;
}

sub Preferences {
    my ( $Self, %Param ) = @_;

    return;
}

sub Config {
    my ( $Self, %Param ) = @_;

    return (
        %{ $Self->{Config} }
    );
}

sub Run {
    no warnings 'uninitialized';

    my ( $Self, %Param ) = @_;

    my $Title = $Param{Title} || '';

    if($Title){
        $Kernel::OM->Get('Kernel::Output::HTML::Layout')->Block(
            Name => 'Title',
            Data => {
                Title => $Title,
            },
        );
    }

    my %Filter = %{ $Param{'Filter'} };
    
    # Get need objects
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout'); 
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');
    my $TimeObject = $Kernel::OM->Get('Kernel::System::Time');
	my $DBObject =	$Kernel::OM->Get("Kernel::System::DB");
	my $CustomerCompanyObject =	$Kernel::OM->Get("Kernel::System::CustomerCompany");

    # Months Back
    my $MonthsBack = $Param{MonthsBack} || 0;

    # Company Field where contract quota is stored
    my $QuotaField = $ConfigObject->Get('Ticket::Complemento::AccountedTime::CompanyQuotaField') || 'CustomerCompanyComment';

    my $TimeStamp = $TimeObject->CurrentTimestamp();

    my $SystemTime = $TimeObject->TimeStamp2SystemTime(
        String => $TimeStamp,
    );

    my ( $s, $m, $h, $D, $M, $Y ) = $TimeObject->SystemTime2Date(
        SystemTime => $SystemTime,
    );
    
    ( $Y, $M, $D ) = Add_Delta_YMD( $Y, $M, $D, 0, -$MonthsBack, 0 );
    my $TimeEndDate = sprintf(
        "%04d-%02d-%02d %02d:%02d:%02d",
        $Y, $M, Days_in_Month( $Y, $M ),
        23, 59, 59
    );
    #( $Y, $M, $D ) = Add_Delta_YMD( $Y, $M, $D, 0, -$MonthsBack, 0 );
    my $TimeNewerDate = sprintf( "%04d-%02d-%02d %02d:%02d:%02d", $Y, $M, 1, 0, 0, 0 );
    
    # Ticket Types which account time
    my @TicketTypesArray = @{$ConfigObject->Get('Ticket::Complemento::AccountedTime::UnderContractTicketTypes')};
    my $TicketTypes;
    for (@TicketTypesArray){
        $TicketTypes.="'$_',";
    }
    chop($TicketTypes);
    
    my %Data;
    
    my $SqlWhere='';
    for (keys %Filter){
        $SqlWhere .= " and $_ = '$Filter{$_}'";
    }
    
    my $SQL = "select c.customer_id, a1.total from customer_company c
                left join (
					SELECT i.customer_id, sum(t.time_unit) as total FROM time_accounting t 
						inner join ticket i on t.ticket_id = i.id
                        inner join ticket_type y on i.type_id = y.id
                        -- Tipos de Ticket
						and y.name in ($TicketTypes)
						and t.create_time between ? and ?
                group by i.customer_id) a1 on c.customer_id=a1.customer_id
                where c.valid_id in (1) $SqlWhere";


	return if !$DBObject->Prepare(
		SQL => $SQL,
		Bind => [\$TimeNewerDate, \$TimeEndDate],
	);
        
	my $TotalOverbalance = 0;
	my $TotalMonth = 0;

    my %Contracts;
    my %Stat;
    
    ## Obtem Empresa e horas contratadas    
	while (my @Row = $DBObject->FetchrowArray() ){
        $Contracts{$Row[0]}->{UsedMinutes} = $Row[1] || 0;
    }
	for my $Contract (keys %Contracts ){
        my %CustomerCompany = $CustomerCompanyObject->CustomerCompanyGet(
            CustomerID => $Contract,
        );
        
        my $ContractedHours = $CustomerCompany{$QuotaField};
        my $ContractedMinutes = $ContractedHours * 60;
        my $Overbalance=0;
        my $UsedPercentual = 0;
        if($ContractedMinutes>0){
            $UsedPercentual = int($Contracts{$Contract}->{UsedMinutes}*100/$ContractedMinutes);
        }
        if ($UsedPercentual>100){
             $Overbalance = $Contracts{$Contract}->{UsedMinutes} - $ContractedMinutes;
        }
		$TotalOverbalance += $Overbalance;
		$TotalMonth += $Contracts{$Contract}->{UsedMinutes};
        
        $Stat{$Contract}->{FullName}    = $Contract;
        $Stat{$Contract}->{Quota}       = convert_to_hhmmss($ContractedMinutes);
        $Stat{$Contract}->{Percentual}  = $UsedPercentual;
        $Stat{$Contract}->{Month}       = convert_to_hhmmss($Contracts{$Contract}->{UsedMinutes});
        $Stat{$Contract}->{Overbalance} = convert_to_hhmmss($Overbalance);
	}

    # Mostra tabela, ordenando pelo percentual de uso no mês
    for my $Item ( reverse sort { $Stat{$a}->{Percentual} <=> $Stat{$b}->{Percentual} } keys %Stat ){
        $LayoutObject->Block(
			Name => 'TrItem',
			Data => {
                %{$Stat{$Item}}
            },
		);	
    }

	$LayoutObject->Block(
		Name => 'TrTotal',
		Data => {
			Total => 'Total',
			TotalOverbalance => convert_to_hhmmss(($TotalOverbalance || 0)),
			TotalMonth => convert_to_hhmmss(($TotalMonth || 0))
		});
    my $Content = $LayoutObject->Output(
        TemplateFile => 'AgentDashboardComplementoCustomerAccountedTimeThisMonth',
        Data         => {
			%Data,
           # Title => $Title,
           # Container => $Param{"Container"},
            %Param,
        },
    );
    
    return $Content;
}
 sub convert_to_hhmmss {

    if($_[0]){
        my $hourz=int($_[0]/60);
        my $minz=$_[0] % 60;
        my $secz=int($minz % 60);
        return sprintf ("%02d:%02d:%02d", $hourz,$minz,$secz);
    } else {
        return "00:00:00";
    }


 

 }
1;
