# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2021 Centuran Consulting, https://centuran.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::Stats::Static::Agent_Date_Send_Mail;
## nofilter(TidyAll::Plugin::OTRS::Perl::Time)

use strict;
use warnings;

use Data::Dumper;

use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::Language',
    'Kernel::System::DB',
    'Kernel::System::DateTime',
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

sub GetObjectBehaviours {
    my ( $Self, %Param ) = @_;

    my %Behaviours = (
        ProvidesDashboardWidget => 1,
    );

    return %Behaviours;
}

sub Param {
    my $Self = shift;

    my $LanguageObject = $Kernel::OM->Get('Kernel::Language'); 
    my $UserObject   = $Kernel::OM->Get('Kernel::System::User');

    my %List = $UserObject->UserList(
        Type          => 'Short', # Short|Long, default Short
        Valid         => 1,       # default 1
    );    

    my %PeriodType = (
        1 => $LanguageObject->Translate( 'Opening Period' ),
        2 => $LanguageObject->Translate( 'Closing Period' ),
    );

    my @Params = (       
       {
            Frontend   => $LanguageObject->Translate( 'Start date' ),
            TypeField  => 'Date',
            Name       => 'StartDate',
        },
        {
            Frontend   => $LanguageObject->Translate( 'End date' ),
            TypeField  => 'Date',
            Name       => 'EndDate',
        },	
        {
            Frontend   => $LanguageObject->Translate( 'Filter for Agents' ),
            Name       => 'Agents',
            Multiple   => 1,
            Size       => 5,
            Data       => \%List,
        },          
	);
    return @Params;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # get language object
    my $LanguageObject = $Kernel::OM->Get('Kernel::Language');
	my $ParamObject    = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $TicketObject   = $Kernel::OM->Get('Kernel::System::Ticket');
	
    for my $Key (
        qw(StartDateYear StartDateMonth StartDateDay EndDateYear EndDateMonth EndDateDay)
        )
    {
        $Param{$Key} = $ParamObject->GetParam( Param => $Key );
        if ( !$Param{$Key} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Key!"
            );
            return;
        }		
    }

    my @AgentIDs;
    # get array params
    for my $Key (
        qw(Agents)
        )
    {
        # get search array params (get submitted params)
        if ( $Param{$Key} ) {
            my @Array = $ParamObject->GetArray( Param => $Key );            
            if ( IsArrayRefWithData(\@Array) ) {
                @AgentIDs = \@Array;
            }
        }
    }   

    my $YearStart  = $Param{StartDateYear};
    my $MonthStart = $Param{StartDateMonth};
    my $DayStart   = $Param{StartDateDay};
    my $YearStop   = $Param{EndDateYear};
    my $MonthStop  = $Param{EndDateMonth};
    my $DayStop    = $Param{EndDateDay};

    my $TimeStart = sprintf( "%04d-%02d-%02d %02d:%02d:%02d", $YearStart, $MonthStart, $DayStart, 0, 0, 0 );
    my $TimeStop  = sprintf( "%04d-%02d-%02d %02d:%02d:%02d", $YearStop, $MonthStop, $DayStop, 23, 59, 59 );    

    my @Headers;

    $Headers[0] = $LanguageObject->Translate( 'Ticket Number' );    
    $Headers[1] = $LanguageObject->Translate( 'Users' );    
    $Headers[2] = $LanguageObject->Translate( 'Send Mail Date' );        
    $Headers[3] = $LanguageObject->Translate( 'Send Mail Hour' ); 
    $Headers[4] = $LanguageObject->Translate( 'To' ); 
    $Headers[5] = $LanguageObject->Translate( 'Queue' );
    $Headers[6] = $LanguageObject->Translate( 'Service' );

    my @Data = $Self->_TicketGetSendAgentMail(
        DateStart => $TimeStart,
        DateStop => $TimeStop,
        Agents   => @AgentIDs,
    );    
    
    my $Title = $LanguageObject->Translate( 'General report of average time indicators for first response and solution by Agents.' );
    return ( [$Title], [@Headers] , @Data );
        

}

=head2 _LogError()

Helper Method for logging.

$Self->_LogError("Couldn't create a backend object for transport '${ Transport }'!");

=cut

sub _LogError {
    my ( $Self, $Message ) = @_;

    $Kernel::OM->Get('Kernel::System::Log')->Log(
        Priority => 'error',
        Message  => $Message,
    );

    return;
}

=head2 _TicketGetSendAgentMail()

Collect attributes of first response for given ticket.

    my @DataSemdAgentMail = $TicketObject->_TicketGetSendAgentMail(
        DateStart => $Param{DateIni},
        DateStop => $Param{DateIni},
        Agents   => \@AgentIDs,
    );

=cut

sub _TicketGetSendAgentMail {
    my ( $Self, %Param ) = @_;

    my $TicketObject   = $Kernel::OM->Get('Kernel::System::Ticket');

    # check needed stuff
    for my $Needed (qw(DateStart DateStop)) {
        if ( !defined $Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!"
            );
            return;
        }
    }

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # check if first response is already done
    my $SQL = '
            SELECT
                (SELECT tn from ticket where id = a.ticket_id limit 1) as "TN",
                (SELECT CONCAT(u.first_name, " ",u.last_name) from users u where u.id = a.create_by limit 1) as "Users",
                DATE_FORMAT(SUBSTRING_INDEX(a.create_time, " ", 1),"%d/%m/%Y") as "Send_Date",
                SUBSTRING_INDEX(a.create_time, " ", -1) as "Send_Hour",
                adm.a_to as "To",	
                (SELECT q.name from ticket t1, queue q where t1.id = a.ticket_id and t1.queue_id = q.id  limit 1) as "Queue",	
                (SELECT s.name from ticket t1, service s where t1.id = a.ticket_id and t1.service_id = s.id  limit 1) as "Service"
            FROM 
                article_data_mime adm
            RIGHT JOIN	
                article a 
                    ON adm.article_id = a.id 
                    AND a.article_sender_type_id = 1 
                    AND a.communication_channel_id = 1' . "\n";

    if ( IsArrayRefWithData($Param{Agents}) ) {

        my $AgentsIDs = join(",",@{ $Param{Agents} });
        $SQL .= "                    AND a.create_by IN (". $AgentsIDs .") \n";

    }                    

    $SQL.= "RIGHT JOIN 	
                ticket t 
                    ON a.ticket_id = t.id 
                    AND adm.a_to like (CONCAT('%', t.customer_user_id,'%'))	
            where 1=1
                AND adm.create_time >= \"$Param{DateStart}\"
                AND adm.create_time <= \"$Param{DateStop}\"
            order by a.create_time asc";

    return if !$DBObject->Prepare(
        SQL => $SQL,
    );

    my @Data;

    while ( my @Row = $DBObject->FetchrowArray() ) {
        push @Data, \@Row;        
    }

    return if !IsArrayRefWithData( \@Data );     

    return @Data;
}

1;