# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2021 Centuran Consulting, https://centuran.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::Stats::Static::General_Ticket_Stats;
## nofilter(TidyAll::Plugin::OTRS::Perl::Time)

use strict;
use warnings;

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
           Frontend   => $LanguageObject->Translate( 'Period Type' ),
           Name       => 'PeriodType',
           Multiple   => 0,
           Size       => 0,
           SelectedID => 1,
           Data       => \%PeriodType,
       },        
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
        qw(StartDateYear StartDateMonth StartDateDay EndDateYear EndDateMonth EndDateDay PeriodType)
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

    # get array params
    for my $Key (
        qw(Agents)
        )
    {

        # get search array params (get submitted params)
        my @Array = $ParamObject->GetArray( Param => $Key );
        if (@Array) {
            $Param{$Key} = \@Array;
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

    my %TicketSearch;

    if ( $Param{PeriodType} == 2 ) {
        $TicketSearch{'TicketCloseTimeNewerDate'} = $TimeStart;
        $TicketSearch{'TicketCloseTimeOlderDate'} = $TimeStop; 
    } elsif ( $Param{PeriodType} == 1 ) {
        $TicketSearch{'TicketCreateTimeNewerDate'} = $TimeStart;
        $TicketSearch{'TicketCreateTimeOlderDate'} = $TimeStop; 
    }

    if ( IsArrayRefWithData($Param{Agents}) ) {

        $TicketSearch{'OwnerIDs'} = \@{$Param{Agents}};

    }

    %TicketSearch = (
        %TicketSearch,
        Permission => 'ro',
        UserID => 1,
    );

    my @Tickets =$TicketObject->TicketSearch(
                %TicketSearch,
                Result => 'ARRAY',
                );    

    my $len = @Tickets;
    
    my @Data = ();
    my @Headers = ();

    $Headers[0] = $LanguageObject->Translate( 'TicketNumber' );    
    $Headers[1] = $LanguageObject->Translate( 'Title' );    
    $Headers[2] = $LanguageObject->Translate( 'Type' );    
    $Headers[3] = $LanguageObject->Translate( 'Service' );    
    $Headers[4] = $LanguageObject->Translate( 'Queue' );    
    $Headers[5] = $LanguageObject->Translate( 'State' ); 
    $Headers[6] = $LanguageObject->Translate( 'FirstResponseInMin' );    
    $Headers[7] = $LanguageObject->Translate( 'FirstResponse' );  
    $Headers[8] = $LanguageObject->Translate( 'SolutionInMin' );  
    $Headers[9] = $LanguageObject->Translate( 'Solution' );
    
    for (my $b = 0; $b < $len; $b = $b + 1)
    {
        my $TicketID = $Tickets[$b];

        # Get ticket data.
        my %Ticket = $TicketObject->TicketGet(
            TicketID      => $TicketID,
            DynamicFields => 0,
            Extended      => 0,
            UserID        => 1,
        );  

        if ( IsHashRefWithData( \%Ticket ) ) {
            
            $Data[$b][0] = $Ticket{TicketNumber};
            $Data[$b][1] = $Ticket{Title};
            $Data[$b][2] = $LanguageObject->Translate( $Ticket{Type} );
            $Data[$b][3] = $Ticket{Service};
            $Data[$b][4] = $Ticket{Queue};
            $Data[$b][5] = $LanguageObject->Translate( $Ticket{State} );

        }

        my %FirstResponse = $Self->_TicketGetFirstResponse(
            TicketID => $TicketID,
            Ticket   => \%Ticket,
        );        

        if ( IsHashRefWithData( \%FirstResponse ) ) {
            
            $Data[$b][6] = $FirstResponse{FirstResponseInMin};
            $Data[$b][7] = $FirstResponse{HumanReadable};

        } else {
            $Data[$b][6] = 0;
            $Data[$b][7] = 0;
        }         

        my %TicketGetClosed = $Self->_TicketGetClosed(
            TicketID => $TicketID,
            Ticket   => \%Ticket,
        );        

        if ( IsHashRefWithData( \%TicketGetClosed ) ) {
            
            $Data[$b][8] = $TicketGetClosed{SolutionInMin};
            $Data[$b][9] = $TicketGetClosed{HumanReadable};

        } else {
            $Data[$b][8] = 0;
            $Data[$b][9] = 0;
        }                  

    }

    my $Title = $LanguageObject->Translate( 'General report of indicators for first response and solution times.' );
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

=head2 _TicketGetFirstResponse()

Collect attributes of first response for given ticket.

    my %FirstResponse = $TicketObject->_TicketGetFirstResponse(
        TicketID => $Param{TicketID},
        Ticket   => \%Ticket,
    );

=cut

sub _TicketGetFirstResponse {
    my ( $Self, %Param ) = @_;

    my $TicketObject   = $Kernel::OM->Get('Kernel::System::Ticket');

    # check needed stuff
    for my $Needed (qw(TicketID Ticket)) {
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
    return if !$DBObject->Prepare(
        SQL => '
            SELECT 
                a.create_time
                , a.id
            FROM 
                article a, 
                article_sender_type ast, 
                article_data_mime adm, 
                ticket t, 
                customer_user cu
            WHERE 1=1
                AND a.article_sender_type_id = ast.id
                AND a.id = adm.article_id
                AND a.ticket_id = t.id
                AND a.ticket_id = ?
                AND ast.name = ?
                AND ((t.customer_user_id = cu.login
                    AND adm.a_to like concat("%",cu.email,"%")) 
                    OR adm.a_to like concat("%",t.customer_user_id,"%"))
            ORDER BY a.create_time',
        Bind  => [ \$Param{TicketID}, \'agent' ],
    );

    my %Data;
    my $count;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        if (!$count) {
            $Data{FirstResponse} = $Row[0];

            # cleanup time stamps (some databases are using e. g. 2008-02-25 22:03:00.000000
            # and 0000-00-00 00:00:00 time stamps)
            $Data{FirstResponse} =~ s/^(\d\d\d\d-\d\d-\d\d\s\d\d:\d\d:\d\d)\..+?$/$1/;
        }
        $count++;
    }

    return if !$Data{FirstResponse};     

    # get escalation properties
    my %Escalation = $TicketObject->TicketEscalationPreferences(
        Ticket => $Param{Ticket},
        UserID => $Param{UserID} || 1,
    );          


    if ( $Escalation{FirstResponseTime} ) {

        # create datetime object
        my $DateTimeObject = $Kernel::OM->Create(
            'Kernel::System::DateTime',
            ObjectParams => {
                String => $Param{Ticket}->{Created},
            }
        );

        my $FirstResponseTimeObj = $DateTimeObject->Clone();
        $FirstResponseTimeObj->Set(
            String => $Data{FirstResponse}
        );

        my $DeltaObj = $DateTimeObject->Delta(
            DateTimeObject => $FirstResponseTimeObj,
            ForWorkingTime => 0,
        );

        my $WorkingTime = $DeltaObj ? $DeltaObj->{AbsoluteSeconds} : 0;

        $Data{FirstResponseInMin} = int( $WorkingTime / 60 );

        $Data{HumanReadable} = $Kernel::OM->Get('Kernel::System::Stats')->_HumanReadableAgeGet(
            Age => int $WorkingTime,
        ); 

        my $EscalationFirstResponseTime = $Escalation{FirstResponseTime} * 60;
        $Data{FirstResponseDiffInMin} =
            int( ( $EscalationFirstResponseTime - $WorkingTime ) / 60 );
    }

    $Data{TotalEmailSendToCustomerUser} = $count;    

    return %Data;
}

=head2 _TicketGetClosed()

Collect attributes of (last) closing for given ticket.

    my %TicketGetClosed = $TicketObject->_TicketGetClosed(
        TicketID => $Param{TicketID},
        Ticket   => \%Ticket,
    );

=cut

sub _TicketGetClosed {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(TicketID Ticket)) {
        if ( !defined $Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!"
            );
            return;
        }
    }

    my $TicketObject   = $Kernel::OM->Get('Kernel::System::Ticket');    

    # get close state types
    my @List = $Kernel::OM->Get('Kernel::System::State')->StateGetStatesByType(
        StateType => ['closed'],
        Result    => 'ID',
    );
    return if !@List;

    # Get id for history types
    my @HistoryTypeIDs;
    for my $HistoryType (qw(StateUpdate NewTicket)) {
        push @HistoryTypeIDs, $TicketObject->HistoryTypeLookup( Type => $HistoryType );
    }

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    return if !$DBObject->Prepare(
        SQL => "
            SELECT MAX(create_time)
            FROM ticket_history
            WHERE ticket_id = ?
               AND state_id IN (${\(join ', ', sort @List)})
               AND history_type_id IN  (${\(join ', ', sort @HistoryTypeIDs)})
            ",
        Bind => [ \$Param{TicketID} ],
    );

    my %Data;
    ROW:
    while ( my @Row = $DBObject->FetchrowArray() ) {
        last ROW if !defined $Row[0];
        $Data{Closed} = $Row[0];

        # cleanup time stamps (some databases are using e. g. 2008-02-25 22:03:00.000000
        # and 0000-00-00 00:00:00 time stamps)
        $Data{Closed} =~ s/^(\d\d\d\d-\d\d-\d\d\s\d\d:\d\d:\d\d)\..+?$/$1/;
    }

    return if !$Data{Closed};

    # get escalation properties
    my %Escalation = $TicketObject->TicketEscalationPreferences(
        Ticket => $Param{Ticket},
        UserID => $Param{UserID} || 1,
    );

    # create datetime object
    my $DateTimeObject = $Kernel::OM->Create(
        'Kernel::System::DateTime',
        ObjectParams => {
            String => $Param{Ticket}->{Created},
        }
    );

    my $SolutionTimeObj = $Kernel::OM->Create(
        'Kernel::System::DateTime',
        ObjectParams => {
            String => $Data{Closed},
        }
    );

    my $DeltaObj = $DateTimeObject->Delta(
        DateTimeObject => $SolutionTimeObj,
        ForWorkingTime => 0,
    );

    my $WorkingTime = $DeltaObj ? $DeltaObj->{AbsoluteSeconds} : 0;

    $Data{SolutionInMin} = int( $WorkingTime / 60 );

    $Data{HumanReadable} = $Kernel::OM->Get('Kernel::System::Stats')->_HumanReadableAgeGet(
        Age => int $WorkingTime,
    ); 

    if ( $Escalation{SolutionTime} ) {
        my $EscalationSolutionTime = $Escalation{SolutionTime} * 60;
        $Data{SolutionDiffInMin} =
            int( ( $EscalationSolutionTime - $WorkingTime ) / 60 );
    }

    return %Data;
}

1;