package Kernel::System::Stats::Dynamic::ArticleListAndTimeCalculation;

use strict;
use warnings;

use List::Util qw( first );
use Kernel::System::VariableCheck qw(:all);
#use Data::Dumper;

if ($Kernel::OM) {
    # OTRS 4    
} else {
    # OTRS 3
use Kernel::System::Queue;
use Kernel::System::Service;
use Kernel::System::SLA;
use Kernel::System::Ticket;
use Kernel::System::Type;
use Kernel::System::DynamicField;
use Kernel::System::DynamicField::Backend;
}

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Time',
    'Kernel::System::Type',
    'Kernel::System::DB',
    'Kernel::System::CustomerUser',
    'Kernel::System::User',
    'Kernel::System::DynamicField',
    'Kernel::System::DynamicField::Backend',
    'Kernel::System::ITSMChange',
    'Kernel::System::Log',
    'Kernel::System::Time',
    'Kernel::System::Ticket',
    'Kernel::System::Queue',
    'Kernel::System::Service',
    'Kernel::System::SLA',
    'Kernel::System::Ticket'
);

use vars qw($VERSION);
$VERSION = qw($Revision: 1.19.2.1 $) [1];

sub new {

    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    if ($Kernel::OM) {
        # OTRS > 4
        $Self->{DBObject}           = $Kernel::OM->Get('Kernel::System::DB');
        $Self->{QueueObject}        = $Kernel::OM->Get('Kernel::System::Queue');
        $Self->{UserObject}         = $Kernel::OM->Get('Kernel::System::User');
        $Self->{ConfigObject}       = $Kernel::OM->Get('Kernel::Config');
        $Self->{TicketObject}       = $Kernel::OM->Get('Kernel::System::Ticket');
        $Self->{StateObject}        = $Kernel::OM->Get('Kernel::System::State');
        $Self->{PriorityObject}     = $Kernel::OM->Get('Kernel::System::Priority');
        $Self->{LockObject}         = $Kernel::OM->Get('Kernel::System::Lock');
        $Self->{CustomerUser}       = $Kernel::OM->Get('Kernel::System::CustomerUser');
        $Self->{ServiceObject}      = $Kernel::OM->Get('Kernel::System::Service');
        $Self->{SLAObject}          = $Kernel::OM->Get('Kernel::System::SLA');
        $Self->{TypeObject}         = $Kernel::OM->Get('Kernel::System::Type');
        $Self->{TimeObject}         = $Kernel::OM->Get('Kernel::System::Time');
        $Self->{DynamicFieldObject} = $Kernel::OM->Get('Kernel::System::DynamicField');
        $Self->{BackendObject}      = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

    } else {
        # OTRS 3
        # check needed objects
        for my $Object (
            qw(DBObject ConfigObject LogObject UserObject TimeObject MainObject EncodeObject)
        )
        {
            $Self->{$Object} = $Param{$Object} || die "Got no $Object!";
        }

        $Self->{QueueObject}        = Kernel::System::Queue->new( %{$Self} );
        $Self->{TicketObject}       = Kernel::System::Ticket->new( %{$Self} );
        $Self->{StateObject}        = Kernel::System::State->new( %{$Self} );
        $Self->{PriorityObject}     = Kernel::System::Priority->new( %{$Self} );
        $Self->{LockObject}         = Kernel::System::Lock->new( %{$Self} );
        $Self->{CustomerUser}       = Kernel::System::CustomerUser->new( %{$Self} );
        $Self->{ServiceObject}      = Kernel::System::Service->new( %{$Self} );
        $Self->{SLAObject}          = Kernel::System::SLA->new( %{$Self} );
        $Self->{TypeObject}         = Kernel::System::Type->new( %{$Self} );
        $Self->{DynamicFieldObject} = Kernel::System::DynamicField->new(%Param);
        $Self->{BackendObject}      = Kernel::System::DynamicField::Backend->new(%Param);

    }
    
    # get the dynamic fields for ticket and article object
    $Self->{DynamicField} = $Self->{DynamicFieldObject}->DynamicFieldListGet(
        Valid      => 1,
        ObjectType => ['Ticket','Article'],
    );

    # get the dynamic fields for article object
    $Self->{TicketDynamicField} = $Self->{DynamicFieldObject}->DynamicFieldListGet(
        Valid      => 1,
        ObjectType => ['Ticket'],
    );

    # get the dynamic fields for article object
    $Self->{ArticleDynamicField} = $Self->{DynamicFieldObject}->DynamicFieldListGet(
        Valid      => 1,
        ObjectType => ['Article'],
    );

    $Self->{Config} = $Self->{ConfigObject}->Get( "Stats::ArticleListAndTimeCalculation" );

    return $Self;
}

sub GetObjectName {
    my ( $Self, %Param ) = @_;

    return 'ArticleListAndTimeCalculation';
}

sub GetObjectBehaviours {
    my ( $Self, %Param ) = @_;

    my %Behaviours = (
        ProvidesDashboardWidget => 0,
    );

    return %Behaviours;
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
    my %TicketAttributes = %{$Self->_ArticleAttributes()};
    
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

    # Obtem todos os campos dinamicos
    my %TicketDF = %{$Self->_TicketDF()};
    my %ArticleDF = %{$Self->_ArticleDF()};

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
            Name             => "One of these article's dynamic fields must not be empty (can reduce server load when generate this stat)",
            UseAsXvalue      => 0,
            UseAsValueSeries => 0,
            UseAsRestriction => 1,
            Element          => 'PreNotNullADF',
            Block            => 'MultiSelectField',
            Translation      => 1,
            Values           => \%ArticleDF,
            Sort             => 'IndividualKey',


        },
        {
            Name             => "One of these ticket's dynamic fields must not be empty (can reduce server load when generate this stat)",
            UseAsXvalue      => 0,
            UseAsValueSeries => 0,
            UseAsRestriction => 1,
            Element          => 'PreNotNullTDF',
            Block            => 'MultiSelectField',
            Translation      => 1,
            Values           => \%TicketDF,
            Sort             => 'IndividualKey',


        },
        {
            Name             => 'Fields that must not be empty after process fields calculations',
            UseAsXvalue      => 0,
            UseAsValueSeries => 0,
            UseAsRestriction => 1,
            Element          => 'PostNotNull',
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
            Name             => 'Only with Accounted Time > 0',
            UseAsXvalue      => 0,
            UseAsValueSeries => 0,
            UseAsRestriction => 1,
            Element          => 'PositiveAccountedTime',
            Block            => 'SelectField',
            Translation      => 1,
            Values           => {
                0 => "No",
                1 => "Yes"
            },
            Sort             => 'IndividualKey',
            SortIndividual   => [1,0],
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
            Name             => 'Task Start Time',
            UseAsXvalue      => 0,
            UseAsValueSeries => 0,
            UseAsRestriction => 1,
            Element          => 'TaskStart',
            TimePeriodFormat => 'DateInputFormat',    # 'DateInputFormatLong',
            Block            => 'Time',
            Values           => {
                TimeStart => 'TaskStartNewerDate',
                TimeStop  => 'TaskStartOlderDate',
            },
        },
        {
            Name             => 'Ticket Creation Time',
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
            Name             => 'Article Creation Time',
            UseAsXvalue      => 0,
            UseAsValueSeries => 0,
            UseAsRestriction => 1,
            Element          => 'ArticleCreateTime',
            TimePeriodFormat => 'DateInputFormat',    # 'DateInputFormatLong',
            Block            => 'Time',
            Values           => {
                TimeStart => 'ArticleCreateTimeNewerDate',
                TimeStop  => 'ArticleCreateTimeOlderDate',
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
            {
                Name             => 'Time Unit Registered By',
                UseAsXvalue      => 0,
                UseAsValueSeries => 0,
                UseAsRestriction => 1,
                Element          => 'RegisteredBy',
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

    my $ArticleObject = $Kernel::OM->Get('Kernel::System::Ticket::Article');
    
    my %TicketAttributes = map { $_ => 1 } @{ $Param{XValue}{SelectedValues} };

    my $DatabaseType = $Self->{DBObject}->{'DB::Type'};

    if ( $DatabaseType =~ /ODBC/i ) {
        $DatabaseType = $Self->{ConfigObject}->Get('Database::Type');
    }

    # check if a enumeration is requested
    my $AddEnumeration = 0;
    if ( $TicketAttributes{Number} ) {
        $AddEnumeration = 1;
        delete $TicketAttributes{Number};
    }

    my %AdditionalFields;
    if ($Self->{ConfigObject}->Get( "Stats::ArticleListAndTimeCalculation::AdditionalFieldName" )) {
        %AdditionalFields = %{$Self->{ConfigObject}->Get( "Stats::ArticleListAndTimeCalculation::AdditionalFieldName" )};
    }

    my %AdditionalFieldsCode;
    if ($Self->{ConfigObject}->Get( "Stats::ArticleListAndTimeCalculation::AdditionalFieldCode" )) {
        %AdditionalFieldsCode = %{$Self->{ConfigObject}->Get( "Stats::ArticleListAndTimeCalculation::AdditionalFieldCode" )};
    }

    # Construct SQL 
    my $SQL = "";   
    if(lc $DatabaseType == 'oracle'){
        $SQL = "select t.id, t.tn, t.customer_id, t.title, ts.name, a.id, 
                a.a_subject, i.inicio,  f.fim, ((f.fim-i.inicio)*24*60) as minutos, ac.time_unit, aco.login ";
    }
    else{
        $SQL = "select t.id, t.tn, t.customer_id, t.title, ts.name, a.id, 
                a.a_subject, i.inicio,  f.fim, TIME_TO_SEC(TIMEDIFF(f.fim,i.inicio))/60 as minutos, ac.time_unit, aco.login ";
    }
   
    # COMPLEMENTO: Restrictions
    my $Restriction = ' ';

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
    if ($Param{Restrictions}->{RegisteredBy}){
        if (ref $Param{Restrictions}->{RegisteredBy} eq 'ARRAY' ){
#           $Restriction.=" and ac.create_by in (".join(",",@{$Param{Restrictions}->{RegisteredBy}}).") \n"
# COMPLEMENTO: FILTER BY AGENT IN ARTICLE TABLE
           $Restriction.=" and a.create_by in (".join(",",@{$Param{Restrictions}->{RegisteredBy}}).") \n"
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
    if ($Param{Restrictions}->{ArticleCreateTimeNewerDate}){
       $Restriction.=" and a.create_time between 
                              '$Param{Restrictions}{ArticleCreateTimeNewerDate}'
                             and 
                              '$Param{Restrictions}{ArticleCreateTimeOlderDate}' "
    }
    if ($Param{Restrictions}->{PositiveAccountedTime}){
       if(lc $DatabaseType == 'oracle'){
            $Restriction.=" and ((f.fim-i.inicio)*24*60)>0 \n"
        }
        else{
            $Restriction.=" and TIME_TO_SEC(TIMEDIFF(f.fim,i.inicio))/60>0 \n"
        }
    }

    # COMPLEMENTO: Action Start Restriction
    my $ActionStartFilter="";
    if($Param{Restrictions}{TaskStartNewerDate}){
        
       $Restriction.=" and ac.create_time between 
                              '$Param{Restrictions}{TaskStartNewerDate}'
                             and 
                              '$Param{Restrictions}{TaskStartOlderDate}' "

        
        #$ActionStartFilter=" and value_date between 
                              #'$Param{Restrictions}{DynamicField_AtendIniNewerDate}'
                             #and 
                              #'$Param{Restrictions}{DynamicField_AtendIniOlderDate}' ";
    };
    
    # Ticket DynamicField not null restriction
    if ($Param{Restrictions}->{PreNotNullTDF}) {
       $Restriction.=" and a.ticket_id in (SELECT dfv.object_id FROM dynamic_field_value dfv
        where dfv.field_id in (SELECT id FROM dynamic_field df where df.name in ('".join("','",@{$Param{Restrictions}->{PreNotNullTDF}})."'))) \n"

    }

    # Article DynamicField not null restriction
    if ($Param{Restrictions}->{PreNotNullADF}) {
       $Restriction.=" and a.id in (SELECT dfv.object_id FROM dynamic_field_value dfv
        where dfv.field_id in (SELECT id FROM dynamic_field df where df.name in ('".join("','",@{$Param{Restrictions}->{PreNotNullADF}})."'))) \n"
    }

#COMPLEMENTO
# WE CHANGED THE LINE "left join users aco on ac.create_by = aco.id" TO "left join users aco on a.create_by = aco.id"
    $SQL.=" from article a
            left join article_data_mime ad on a.id = ad.article_id
            left join (SELECT object_id, value_date as inicio 
                    FROM dynamic_field_value where field_id=$Self->{Config}->{AtendIniID} 
                    $ActionStartFilter
            ) i  on a.id = i.object_id 
left join (SELECT object_id, value_date as fim FROM dynamic_field_value where field_id=$Self->{Config}->{AtendFimID}) f
            on i.object_id=f.object_id 
left join ticket t on a.ticket_id = t.id
left join ticket_state ts on t.ticket_state_id=ts.id
left join time_accounting ac on a.id=ac.article_id
left join users aco on a.create_by = aco.id
where 1=1 
    $Restriction
ORDER BY t.tn, a.id";

    $Self->{DBObject}->Prepare(
        SQL => $SQL,
    );


#$Self->{LogObject}->Log( Priority => 'error', Message => "aaaaaaaaaaaaaaa\n$SQL" );
    # generate the ticket list
    my @DB;

    my %SQLParameters = (
        id             => 0,
        ArticleID      => 5,
        ActionStart    => 7,
        ActionStop     => 8,
        Minutes        => 9,
        TimeUnit              => 10,
        RegisteredBy  => 11,
    );

    # COMPLEMENTO
    my $SortedAttributesRef = $Self->_SortedAttributes();
    my @Order = @{$SortedAttributesRef};

    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        push @DB, \@Row;
    };
    my @StatArray;    
    ROWLINE:
    for my $RowLine (@DB){

        my @Row=@{$RowLine};
        my @ResumeRow;
        my $i=0;
        
        my $TicketID = $Row[$SQLParameters{id}];
        
        my %Ticket = $Self->{TicketObject}->TicketGet(
            TicketID      => $TicketID,
            DynamicFields => 1,
            Extended => 1,
        );

        my $ArticleBackendObject = $ArticleObject->BackendForArticle(
                TicketID  => $TicketID,
                ArticleID => $Row[$SQLParameters{ArticleID}],
        );

        my %ArticleTemp = $ArticleBackendObject->ArticleGet(
                TicketID      => $TicketID,
                ArticleID     => $Row[$SQLParameters{ArticleID}],
                RealNames     => 1,
                DynamicFields => 1,
                Extended => 1,
        );
        
        my %Article =(%ArticleTemp, %Ticket);

        ATTRIBUTE:
        for my $Attribute ( @Order ) {
            next ATTRIBUTE if !$TicketAttributes{$Attribute};
            
            if($Attribute eq 'HC'){
                NH_C: {
                    # Check if we have task start and stop time, return if not to reduce cpu consume
                    last NH_C if !$Row[$SQLParameters{ActionStart}];
                    last NH_C if !$Row[$SQLParameters{ActionStop}];
                    
                    # Variavel para armazenar o Calendario a ser utilizado para contabilização
                    my $Calendar;

                    #Decidimos qual calendário utilizaremos, o selecionado ou o do proprio chamado/sla/fila
                    if($Param{Restrictions}->{Calendar}){
                        $Calendar = $Param{Restrictions}->{Calendar};
                    } else {
                        # get escalation properties of this ticket
                        my %Escalation = $Self->{TicketObject}->TicketEscalationPreferences(
                            Ticket => \%Article,
                            UserID => 1,
                        );
                        $Calendar = $Escalation{Calendar} || '';
                    };
                    
                    # Calculamos a quantidade de minutos executados no horario comercial
                    $ResumeRow[$i] = int(
                        $Self->{TimeObject}->WorkingTime(
                            StartTime => $Self->{TimeObject}->TimeStamp2SystemTime(String => $Row[$SQLParameters{ActionStart}]),
                            StopTime  => $Self->{TimeObject}->TimeStamp2SystemTime(String => $Row[$SQLParameters{ActionStop}]),
                            Calendar  => $Calendar,
                        )/60);
                    # Armazenamos esta informação para trabalhar com campos addicionais
                    $Article{HC} = $ResumeRow[$i];
                
                }
                
            } elsif ($Attribute eq 'FHC') {
                N_FHC:{
                    # Check if we have task start and stop time, return if not to reduce cpu consume
                    last N_FHC if !$Row[$SQLParameters{ActionStart}];
                    last N_FHC if !$Row[$SQLParameters{ActionStop}];
                    
                    # Variavel para armazenar o Calendario a ser utilizado para contabilização
                    my $Calendar;

                    #Decidimos qual calendário utilizaremos, o selecionado ou o do proprio chamado/sla/fila
                    if($Param{Restrictions}->{Calendar}){
                        $Calendar = $Param{Restrictions}->{Calendar};
                    } else {
                        # get escalation properties of this ticket
                        my %Escalation = $Self->{TicketObject}->TicketEscalationPreferences(
                            Ticket => \%Article,
                            UserID => 1,
                        );
                        $Calendar = $Escalation{Calendar}||'';
                    };
                    # Calculamos a quantidade de minutos executados no horario comercial
                    my $WorkingTime = int(
                        $Self->{TimeObject}->WorkingTime(
                            StartTime => $Self->{TimeObject}->TimeStamp2SystemTime(String => $Row[$SQLParameters{ActionStart}]),
                            StopTime  => $Self->{TimeObject}->TimeStamp2SystemTime(String => $Row[$SQLParameters{ActionStop}]),
                            Calendar  => $Calendar,
                        )/60);
                    
                    my $Ini = $Self->{TimeObject}->TimeStamp2SystemTime(
                            String => $Row[$SQLParameters{ActionStart}],
                    );
                    my $Fim = $Self->{TimeObject}->TimeStamp2SystemTime(
                            String => $Row[$SQLParameters{ActionStop}],
                    );
                    my $TimeMin = int(($Fim-$Ini)/60);
                    $ResumeRow[$i] = $TimeMin - $WorkingTime;

                    # Armazenamos esta informação para trabalhar com campos addicionais
                    $Article{FHC} = $ResumeRow[$i];
                
                }

            } elsif ($Attribute eq 'Minutes') {
                if ($SQLParameters{$Attribute}) {
                    if ($Row[$SQLParameters{$Attribute}]) {
                        $ResumeRow[$i]=int($Row[$SQLParameters{$Attribute}]);
                    } else {
                        $ResumeRow[$i]=0;
                    }
                } else {
                    $ResumeRow[$i]=0;
                }
                # Armazenamos esta informação para trabalhar com campos addicionais
                $Article{Minutes} = $ResumeRow[$i];
                
            } elsif (exists($SQLParameters{$Attribute})) {
                # Campo vindo do SQL/DB
                $ResumeRow[$i]=$SQLParameters{$Attribute}?$Row[$SQLParameters{$Attribute}]:'';
                $Article{$Attribute} = $ResumeRow[$i];
            } elsif (exists($AdditionalFields{$Attribute})) {
                # Campo Adicional processado
                eval $AdditionalFieldsCode{$Attribute};
                
            } else {
                # Campo do Artigo ou Ticket, vindo do ArticleGet
                $ResumeRow[$i]=$Article{$Attribute};
            }
            
            $i++;
        }

        # Verify if we have the "not null restriction".
        if ($Param{Restrictions}->{PostNotNull}) {
            my @notnull = @{$Param{Restrictions}->{PostNotNull}};
            foreach (@notnull){
                next ROWLINE if !$Article{$_};
            }
        }
        push @StatArray, \@ResumeRow;
    }

    # add a enumeration in front of each row
    if ($AddEnumeration) {
        my $Counter = 0;
        for my $Row (@StatArray) {
            unshift @{$Row}, ++$Counter;
        }
    };

    return @StatArray;
}

sub GetHeaderLine {
    my ( $Self, %Param ) = @_;
    my %SelectedAttributes = map { $_ => 1 } @{ $Param{XValue}{SelectedValues} };

    my $TicketAttributes    = $Self->_ArticleAttributes();
 
    my $SortedAttributesRef = $Self->_SortedAttributes();

    my @Order = @{$SortedAttributesRef};

    my @HeaderLine;

    ATTRIBUTE:
    for my $Attribute ( @Order ) {
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

=item _ArticleAttributes()

Return the attributes that can be printed on this report

    my %Attributes = $Self->_ArticleAttributes();

=cut

sub _ArticleAttributes{
    my $Self = shift;

    my %ArticleAttributes;

    my @TicketProperties = qw (
        TicketID
        TicketNumber
        Title
        State
        StateID
        StateType
        Priority
        PriorityID
        Lock
        LockID
        Queue
        QueueID
        CustomerID
        CustomerUserID
        Owner
        OwnerID
        Type
        TypeID
        SLA
        SLAID
        Service
        ServiceID
        Responsible
        ResponsibleID
        Age
        Created
        CreateTimeUnix
        CreateBy
        Changed
        ChangeBy
        ArchiveFlag
        EscalationResponseTime
        EscalationUpdateTime
        EscalationSolutionTime
        EscalationDestinationIn
        EscalationDestinationTime
        EscalationDestinationDate
        EscalationTimeWorkingTime
        EscalationTime
        FirstResponseTimeEscalation
        FirstResponseTimeNotification
        FirstResponseTimeDestinationTime
        FirstResponseTimeDestinationDate
        FirstResponseTimeWorkingTime
        FirstResponseTime
        UpdateTimeEscalation
        UpdateTimeNotification
        UpdateTimeDestinationTime
        UpdateTimeDestinationDate
        UpdateTimeWorkingTime
        UpdateTime
        SolutionTimeEscalation
        SolutionTimeNotification
        SolutionTimeDestinationTime
        SolutionTimeDestinationDate
        SolutionTimeWorkingTime
        SolutionTime
        FirstResponse
        FirstResponseInMin
        FirstResponseDiffInMin
        SolutionTime
        SolutionInMin
        SolutionDiffInMin
        FirstLock
        ArticleID From To Cc Subject Body ReplyTo MessageID InReplyTo References SenderType SenderTypeID ArticleType ArticleTypeID ContentType Charset MimeType IncomingTime
        RegisteredBy
    );
    %ArticleAttributes = map { $_ => $_ } @TicketProperties;

    # Ticket Attributes, get from SQL
    $ArticleAttributes{Number}='Number';

    # Article relate Attributes, get from SQL
    $ArticleAttributes{Minutes}='Minutes';

    # Pos calculted Article attributes
    $ArticleAttributes{HC}='HC';
    $ArticleAttributes{FHC}='FHC';

    # Obtem todos os campos dinamicos
    DYNAMICFIELD:
    for my $DynamicFieldConfig ( @{ $Self->{DynamicField} } ) {
#        next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);
        next DYNAMICFIELD if !$DynamicFieldConfig->{Name};
        $ArticleAttributes{ 'DynamicField_' . $DynamicFieldConfig->{Name} }
            = $DynamicFieldConfig->{Label}
    }

    # Additional Fields
    my %AddFields;
    if ($Self->{ConfigObject}->Get( "Stats::ArticleListAndTimeCalculation::AdditionalFieldName" )) {
        %AddFields = %{$Self->{ConfigObject}->Get( "Stats::ArticleListAndTimeCalculation::AdditionalFieldName" )};
    }
    %ArticleAttributes = (%ArticleAttributes, %AddFields);
        
    return \%ArticleAttributes;
}

sub _SortedAttributes {
    my $Self = shift;
    my $order;

    $order = "
        Number 
        TicketID 
        TicketNumber
        CustomerID 
        Title 
        StateID
        State 
        ArticleID 
        Subject 
        StateType
        Priority
        PriorityID
        Lock
        LockID
        Queue
        QueueID
        CustomerUserID
        Owner
        OwnerID
        Type
        TypeID
        SLA
        SLAID
        Service
        ServiceID
        Responsible
        ResponsibleID
        Age
        Created
        CreateTimeUnix
        CreateBy
        Changed
        ChangeBy
        ArchiveFlag
        EscalationResponseTime
        EscalationUpdateTime
        EscalationSolutionTime
        EscalationDestinationIn
        EscalationDestinationTime
        EscalationDestinationDate
        EscalationTimeWorkingTime
        EscalationTime
        FirstResponseTimeEscalation
        FirstResponseTimeNotification
        FirstResponseTimeDestinationTime
        FirstResponseTimeDestinationDate
        FirstResponseTimeWorkingTime
        FirstResponseTime
        UpdateTimeEscalation
        UpdateTimeNotification
        UpdateTimeDestinationTime
        UpdateTimeDestinationDate
        UpdateTimeWorkingTime
        UpdateTime
        SolutionTimeEscalation
        SolutionTimeNotification
        SolutionTimeDestinationTime
        SolutionTimeDestinationDate
        SolutionTimeWorkingTime
        SolutionTime
        FirstResponse
        FirstResponseInMin
        FirstResponseDiffInMin
        SolutionTime
        SolutionInMin
        SolutionDiffInMin
        FirstLock
        From To Cc Body ReplyTo MessageID InReplyTo References SenderType SenderTypeID ArticleType ArticleTypeID ContentType Charset MimeType IncomingTime
        RegisteredBy
        DynamicField_Action 
        DynamicField_AtendIni 
        DynamicField_AtendFim
        DynamicField_hsaida 
        DynamicField_hchegada
        DynamicField_sretorno 
        DynamicField_hretorno
        Minutes
        HC
        FHC
    ";

    my @SortedAttributes = split " ", $order;

    # cycle trought the Dynamic Fields
    my %params = map { $_ => 1 } @SortedAttributes;

    DYNAMICFIELD:
    for my $DynamicFieldConfig ( @{ $Self->{DynamicField} } ) {
        next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);
        next DYNAMICFIELD if !$DynamicFieldConfig->{Name};
        next DYNAMICFIELD if exists($params{"DynamicField_".$DynamicFieldConfig->{Name}});

        push(@SortedAttributes, 'DynamicField_' . $DynamicFieldConfig->{Name});
    }
    
    
    # Additional Fields
    # Additional Fields
    my %AddFields;
    if ($Self->{ConfigObject}->Get( "Stats::ArticleListAndTimeCalculation::AdditionalFieldName" )) {
        %AddFields = %{$Self->{ConfigObject}->Get( "Stats::ArticleListAndTimeCalculation::AdditionalFieldName" )};
    }

    for my $Field (keys %AddFields){
       push(@SortedAttributes, $Field);
    };
    
    if($Self->{ConfigObject}->Get('Stats::ArticleListAndTimeCalculation::ColumnOrder')){
        @SortedAttributes = split " ", $Self->{ConfigObject}->Get('Stats::ArticleListAndTimeCalculation::ColumnOrder');
    }; 
    
    return \@SortedAttributes;
}

sub _OrderByIsValueOfTicketSearchSort {
    my ( $Self, %Param ) = @_;

    my %SortOptions = (
        Age                    => 'Age',
        Created                => 'Age',
        CustomerID             => 'CustomerID',
        EscalationResponseTime => 'EscalationResponseTime',
        EscalationSolutionTime => 'EscalationSolutionTime',
        EscalationTime         => 'EscalationTime',
        EscalationUpdateTime   => 'EscalationUpdateTime',
        Lock                   => 'Lock',
        Owner                  => 'Owner',
        Priority               => 'Priority',
        Queue                  => 'Queue',
        Responsible            => 'Responsible',
        SLA                    => 'SLA',
        Service                => 'Service',
        State                  => 'State',
        TicketNumber           => 'Ticket',
        TicketEscalation       => 'TicketEscalation',
        Title                  => 'Title',
        Type                   => 'Type',
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

sub _ArticleDF {
    my ( $Self, %Param ) = @_;
    my %ArticleDF;
    ADYNAMICFIELD:
    for my $aDynamicFieldConfig ( @{ $Self->{ArticleDynamicField} } ) {
#        next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);
        next ADYNAMICFIELD if !$aDynamicFieldConfig->{Name};
        $ArticleDF{ $aDynamicFieldConfig->{Name} }
            = $aDynamicFieldConfig->{Label}
    }
    return \%ArticleDF;
}

sub _TicketDF {
    my ( $Self, %Param ) = @_;
    my %TicketDF;
    TDYNAMICFIELD:
    for my $aDynamicFieldConfig ( @{ $Self->{TicketDynamicField} } ) {
        next TDYNAMICFIELD if !$aDynamicFieldConfig->{Name};
        $TicketDF{ $aDynamicFieldConfig->{Name} }
            = $aDynamicFieldConfig->{Label}
    }
    return \%TicketDF;
}

1;
