# --
# Kernel/Modules/AgentTicketComplementoView.pm - the queue view of all tickets
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# For commercial support, contact Complemento: http://www.complemento.net.br
# --

package Kernel::Modules::AgentTicketComplementoView;

use strict;
use warnings;

use Kernel::System::JSON;
use Kernel::System::State;
use Kernel::System::Lock;
use Kernel::System::CustomerCompany;
use URI::Escape;
use Encode;
use Kernel::System::DynamicField;
use Kernel::System::VariableCheck qw(:all);

use utf8;
 
use vars qw($VERSION);
$VERSION = qw($Revision: 1.79 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # set debug
    $Self->{Debug} = 0;

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $SessionObject = $Kernel::OM->Get('Kernel::System::AuthSession');
    my $UserObject =  $Kernel::OM->Get('Kernel::System::User');
    my $TimeObject = $Kernel::OM->Get('Kernel::System::Time');
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');
    
    # Get configurations from SysConfig
    $Self->{Config} = $ConfigObject->Get("Ticket::Frontend::$Self->{Action}");

    # instance new objects
    $Self->{StateObject} = Kernel::System::State->new(%Param);
    $Self->{LockObject}  = Kernel::System::Lock->new(%Param);
    $Self->{CustomerCompanyObject}  = Kernel::System::CustomerCompany->new(%Param);

    # get params
    $Self->{ViewAll} = $ParamObject->GetParam( Param => 'ViewAll' )  || 0;
    $Self->{Start}   = $ParamObject->GetParam( Param => 'StartHit' ) || 1;
    $Self->{Filter}  = $ParamObject->GetParam( Param => 'Filter' )   || 'All';
    $Self->{View}    = $ParamObject->GetParam( Param => 'View' )     || '';
    $Self->{JSONObject}         = $Kernel::OM->Get('Kernel::System::JSON');
    $Self->{DynamicFieldObject} = $Kernel::OM->Get('Kernel::System::DynamicField');
    
    # COMPLEMENTO: GET THE FILTERS SPECIFIED ON SYSCONFIG.
    $Self->{CompFilters}=$ConfigObject->Get("Ticket::Frontend::AgentTicketComplementoViewFilters");

    # Get Values of the filters from post or get
    for my $Filter (keys %{ $Self->{CompFilters} }){
            my @Values=$ParamObject->GetArray( Param => $Filter );
            if ($ParamObject->GetParam( Param => $Filter )){
                $Self->{$Filter}    =  \@Values;
            } elsif ($Self->{CompFilters}->{$Filter}->{Default}){
                # If could not get values and it's not the first run, assume the default 
                # This should heappen only on first time the page is accessed
                if(! $ParamObject->GetParam( Param => 'NotFirstRun' )){
                    my @Values=split /[;,]/ , $Self->{CompFilters}->{$Filter}->{Default};
                    $Self->{$Filter}    =  \@Values;
                }   
            }
    }

    # If we want to show all tickets in this module
    if ($Self->{Config}->{ViewAll}){
        $Self->{UserID} = 1;
    }

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $SessionObject = $Kernel::OM->Get('Kernel::System::AuthSession');
    my $UserObject =  $Kernel::OM->Get('Kernel::System::User');
    my $TimeObject = $Kernel::OM->Get('Kernel::System::Time');
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');
    
    # store last queue screen
    $SessionObject->UpdateSessionID(
        SessionID => $Self->{SessionID},
        Key       => 'LastScreenOverview',
        Value     => $Self->{RequestedURL},
    );

    # store last screen
    $SessionObject->UpdateSessionID(
        SessionID => $Self->{SessionID},
        Key       => 'LastScreenView',
        Value     => $Self->{RequestedURL},

    );







    # get filters stored in the user preferences
    my %Preferences = $UserObject->GetPreferences(
        UserID => $Self->{UserID},
    );
    my $StoredFiltersKey = 'UserStoredFilterColumns-' . $Self->{Action};
    my $StoredFilters    = $Self->{JSONObject}->Decode(
        Data => $Preferences{$StoredFiltersKey},
    );

    # delete stored filters if needed
    if ( $ParamObject->GetParam( Param => 'DeleteFilters' ) ) {
        $StoredFilters = {};
    }

    # get the column filters from the web request or user preferences
    my %ColumnFilter;
    my %GetColumnFilter;
    COLUMNNAME:
    for my $ColumnName (
        qw(Owner Responsible State Queue Priority Type Lock Service SLA CustomerID CustomerUserID)
        )
    {
        # get column filter from web request
        my $FilterValue = $ParamObject->GetParam( Param => 'ColumnFilter' . $ColumnName )
            || '';

        # if filter is not present in the web request, try with the user preferences
        if ( $FilterValue eq '' ) {
            if ( $ColumnName eq 'CustomerID' ) {
                $FilterValue = $StoredFilters->{$ColumnName}->[0] || '';
            }
            elsif ( $ColumnName eq 'CustomerUserID' ) {
                $FilterValue = $StoredFilters->{CustomerUserLogin}->[0] || '';
            }
            else {
                $FilterValue = $StoredFilters->{ $ColumnName . 'IDs' }->[0] || '';
            }
        }
        next COLUMNNAME if $FilterValue eq '';
        next COLUMNNAME if $FilterValue eq 'DeleteFilter';

        if ( $ColumnName eq 'CustomerID' ) {
            push @{ $ColumnFilter{$ColumnName} }, $FilterValue;
            $GetColumnFilter{$ColumnName} = $FilterValue;
        }
        elsif ( $ColumnName eq 'CustomerUserID' ) {
            push @{ $ColumnFilter{CustomerUserLogin} }, $FilterValue;
            $GetColumnFilter{$ColumnName} = $FilterValue;
        }
        else {
            push @{ $ColumnFilter{ $ColumnName . 'IDs' } }, $FilterValue;
            $GetColumnFilter{$ColumnName} = $FilterValue;
        }
    }

    # get all dynamic fields
    $Self->{DynamicField} = $Self->{DynamicFieldObject}->DynamicFieldListGet(
        Valid      => 1,
        ObjectType => ['Ticket'],
    );

    DYNAMICFIELD:
    for my $DynamicFieldConfig ( @{ $Self->{DynamicField} } ) {
        next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);
        next DYNAMICFIELD if !$DynamicFieldConfig->{Name};

        # get filter from web request
        my $FilterValue = $ParamObject->GetParam(
            Param => 'ColumnFilterDynamicField_' . $DynamicFieldConfig->{Name}
        );

        # if no filter from web request, try from user preferences
        if ( !defined $FilterValue || $FilterValue eq '' ) {
            $FilterValue = $StoredFilters->{ 'DynamicField_' . $DynamicFieldConfig->{Name} }->{Equals};
        }

        next DYNAMICFIELD if !defined $FilterValue;
        next DYNAMICFIELD if $FilterValue eq '';
        next DYNAMICFIELD if $FilterValue eq 'DeleteFilter';

        $ColumnFilter{ 'DynamicField_' . $DynamicFieldConfig->{Name} } = {
            Equals => $FilterValue,
        };
        $GetColumnFilter{ 'DynamicField_' . $DynamicFieldConfig->{Name} } = $FilterValue;
    }

    # build NavigationBar & to get the output faster!
    my $Refresh = '';
    if ( $Self->{UserRefreshTime} ) {
        $Refresh = 60 * $Self->{UserRefreshTime};
    }














    ############### SORT #####################################
    my $SortDefault = 1;
    my $SortBy = $Self->{Config}->{'SortBy::Default'} || 'Age';
    if ( $ParamObject->GetParam( Param => 'SortBy' ) ) {
        $SortBy = $ParamObject->GetParam( Param => 'SortBy' );
        $SortDefault = 0;
    }
    my $OrderBy;
    if ( $ParamObject->GetParam( Param => 'OrderBy' ) ) {
        $OrderBy = $ParamObject->GetParam( Param => 'OrderBy' );
        $SortDefault = 0;
    }
    if ( !$OrderBy ) {
        $OrderBy = $Self->{Config}->{'Order::Default'} || 'Up';
    }

    #COMPLEMENTO
    $Self->{SortBy} = $SortBy;    
    $Self->{OrderBy} = $OrderBy;    

    # build NavigationBar
    my $Refresh = '';
    if ( $Self->{UserRefreshTime} ) {
        $Refresh = 60 * $Self->{UserRefreshTime};
    }
#    my $Output = $LayoutObject->Header( Refresh => $Refresh, );
#    $Output .= $LayoutObject->NavigationBar();
#    $LayoutObject->Print( Output => \$Output );
#    $Output = '';

    # get permissions
    my $Permission = 'rw';
    if ( $Self->{Config}->{ViewAllPossibleTickets} ) {
        $Permission = 'ro';
    }

    # sort on default by using both (Priority, Age) else use only one sort argument
    my %Sort;
    if ( !$SortDefault ) {
        %Sort = (
            SortBy  => $SortBy,
            OrderBy => $OrderBy,
        );
    }
    else {
        %Sort = (
            SortBy  => [ 'Priority', $SortBy ],
            OrderBy => [ 'Down',     $OrderBy ],
        );
    }

    # Default Filter
    # @TODO: make only one HASH of filter
    my %Filters = (
        All => {
            Name   => 'All tickets',
            Prio   => 1000,
            Search => {
                %Sort,
                Permission => $Permission,
                UserID     => $Self->{UserID},
            },
        },
    );
    
    #######################################################################################
    # COMPLEMENTO Escalation Filter                                                       #

    # WHEN IS THE FIRST DAY OF "THIS WEEK" PERIOD (ACTUALY TOMORROW)
    my ( $Sec, $Min, $Hour, $Day, $Month, $Year ) = $TimeObject->SystemTime2Date(
        SystemTime => $TimeObject->SystemTime() + 60 * 60 * 24 * 2,
    );
    my $TimeStampNextWeekStart = "$Year-$Month-$Day 00:00:00";
    
    # WHEN THE "THIS WEEK" PERIOD FINISHS
    ( $Sec, $Min, $Hour, $Day, $Month, $Year ) = $TimeObject->SystemTime2Date(
        SystemTime => $TimeObject->SystemTime() + 60 * 60 * 24 * 7,
    );
    my $TimeStampNextWeekEnd = "$Year-$Month-$Day 23:59:59";
    
    # TOMORROW START AND TOMORROW END TIME
    ( $Sec, $Min, $Hour, $Day, $Month, $Year ) = $TimeObject->SystemTime2Date(
        SystemTime => $TimeObject->SystemTime() + 60 * 60 * 24,
    );
    my $TimeStampTomorrowStart = "$Year-$Month-$Day 00:00:00";
    my $TimeStampTomorrowEnd = "$Year-$Month-$Day 23:59:59";
    
    # TODAY START AND END TIME
    ( $Sec, $Min, $Hour, $Day, $Month, $Year ) = $TimeObject->SystemTime2Date(
        SystemTime => $TimeObject->SystemTime(),
    );
    my $TimeStampTodayStart = "$Year-$Month-$Day 00:00:00";
    my $TimeStampTodayEnd = "$Year-$Month-$Day 23:59:59";
    my $Now = "$Year-$Month-$Day $Hour:$Min:$Sec";
    
    my %EscalationFilters = (
        # ALREADY ESCALTED
        1 => {
            Name   => 'Escalated',
            Prio   => 1000,
            Search => {
                 TicketEscalationTimeOlderDate => $Now,
            },
        },
        2 => {
        # ESCALATES TODAY
            Name   => 'Today',
            Prio   => 1000,
            Search => {
                TicketEscalationTimeNewerDate => $Now,
                TicketEscalationTimeOlderDate => $TimeStampTodayEnd,
            },
        },
        3 => {
            Name   => 'Tomorrow',
            Prio   => 2000,
            Search => {
                    TicketEscalationTimeNewerDate => $TimeStampTomorrowStart,
                    TicketEscalationTimeOlderDate => $TimeStampTomorrowEnd,
            },
        },
        4 => {
            Name   => 'Next week',
            Prio   => 3000,
            Search => {
                    TicketEscalationTimeNewerDate => $TimeStampNextWeekStart,
                    TicketEscalationTimeOlderDate => $TimeStampNextWeekEnd,
            },
        },
        
        
        5 => {
            Name   => 'Solution Expired',
            Prio   => 1000,
            Search => {
                 TicketEscalationSolutionTimeOlderDate => $Now,
            },
        },
        6 => {
        # ESCALATES TODAY
            Name   => 'Solution Expires Today',
            Prio   => 1000,
            Search => {
                TicketEscalationSolutionTimeNewerDate => $Now,
                TicketEscalationSolutionTimeOlderDate => $TimeStampTodayEnd,
            },
        },
        7 => {
            Name   => 'Solution Expires Tomorrow',
            Prio   => 2000,
            Search => {
                    TicketEscalationSolutionTimeNewerDate => $TimeStampTomorrowStart,
                    TicketEscalationSolutionTimeOlderDate => $TimeStampTomorrowEnd,
            },
        },
        8 => {
            Name   => 'Solution Expires Next week',
            Prio   => 3000,
            Search => {
                    TicketEscalationSolutionTimeNewerDate => $TimeStampNextWeekStart,
                    TicketEscalationSolutionTimeOlderDate => $TimeStampNextWeekEnd,
            },
        },

        
        
        9 => {
            Name   => 'First Response Expired',
            Prio   => 1000,
            Search => {
                 TicketEscalationResponseTimeOlderDate => $Now,
            },
        },
       10 => {
        # ESCALATES TODAY
            Name   => 'First Response Expires Today',
            Prio   => 1000,
            Search => {
                TicketEscalationResponseTimeNewerDate => $Now,
                TicketEscalationResponseTimeOlderDate => $TimeStampTodayEnd,
            },
        },
       11 => {
            Name   => 'First Response Expires Tomorrow',
            Prio   => 2000,
            Search => {
                    TicketEscalationResponseTimeNewerDate => $TimeStampTomorrowStart,
                    TicketEscalationResponseTimeOlderDate => $TimeStampTomorrowEnd,
            },
        },
       12 => {
            Name   => 'First Response Expires Next week',
            Prio   => 3000,
            Search => {
                    TicketEscalationResponseTimeNewerDate => $TimeStampNextWeekStart,
                    TicketEscalationResponseTimeOlderDate => $TimeStampNextWeekEnd,
            },
        },

        
        
        
       13 => {
            Name   => 'Follow Up Expired',
            Prio   => 1000,
            Search => {
                 TicketEscalationUpdateTimeOlderDate => $Now,
            },
        },
       14 => {
        # ESCALATES TODAY
            Name   => 'Follow Up Expires Today',
            Prio   => 1000,
            Search => {
                TicketEscalationUpdateTimeNewerDate => $Now,
                TicketEscalationUpdateTimeOlderDate => $TimeStampTodayEnd,
            },
        },
       15 => {
            Name   => 'Follow Up Expires Tomorrow',
            Prio   => 2000,
            Search => {
                    TicketEscalationUpdateTimeNewerDate => $TimeStampTomorrowStart,
                    TicketEscalationUpdateTimeOlderDate => $TimeStampTomorrowEnd,
            },
        },
       16 => {
            Name   => 'Follow Up Expires Next week',
            Prio   => 3000,
            Search => {
                    TicketEscalationUpdateTimeNewerDate => $TimeStampNextWeekStart,
                    TicketEscalationUpdateTimeOlderDate => $TimeStampNextWeekEnd,
            },
        },

    );
#                                                                                        #
##########################################################################################

    # COMPLEMENTO FILTERS
    # ITERATE FILTERS, CHECK FILTER TYPE (TicketAttribute, Escalation or Agent) and prepare the Search Hash with posted values
    my %ComplementoFilter;
    for my $Filter(keys %{$Self->{CompFilters}}){
        if($Self->{$Filter}){
            if($Self->{CompFilters}->{$Filter}->{Type} eq 'TicketAttribute' ||
               $Self->{CompFilters}->{$Filter}->{Type} eq 'Agent'   ||
               $Self->{CompFilters}->{$Filter}->{Type} eq 'CustomerCompany'  
               ){
              
                $ComplementoFilter{$Self->{CompFilters}->{$Filter}->{FilterKey}}=$Self->{$Filter};
                
            } elsif ($Self->{CompFilters}->{$Filter}->{Type} eq 'Escalation'){
                # Join keys and values from EscaltionFilters on ComplementoFilter, according to the selected Escalation filter
                # Disable warnings for this context
                {
                    no warnings 'all';
                    @ComplementoFilter{keys %{ $EscalationFilters{ $Self->{$Filter}->[0] }->{Search} }} = values %{ $EscalationFilters{ $Self->{$Filter}->[0] }->{Search} };                
                }

            } elsif ($Self->{CompFilters}->{$Filter}->{Type} eq 'DynamicField'){
                # Join keys and values from EscaltionFilters on ComplementoFilter, according to the selected Escalation filter
                # Disable warnings for this context
                {
                    no warnings 'all';
                    $ComplementoFilter{$Self->{CompFilters}->{$Filter}->{FilterKey}}={
                        'Equals'=>$Self->{$Filter},
                    };
                }

            }
        }
    }

    # get data (viewable tickets...)
    # search all tickets
    my @ViewableTickets;
    @ViewableTickets = $TicketObject->TicketSearch(
        %{ $Filters{ All }->{Search} },
        %ComplementoFilter,
        Result => 'ARRAY',
    );

    my %Counters;
    
    # COMPLEMENTO: Let's Count How many tickets we have per Owner, State and other attributes
    for my $TicketID (@ViewableTickets){
        my %Ticket = $TicketObject->TicketGet(
            TicketID      => $TicketID,
            DynamicFields => 1,         # Optional, default 0. To include the dynamic field values for this ticket on the return structure.
            UserID        => $Self->{UserID},
            Silent        => 0,         # Optional, default 0. To suppress the warning if the ticket does not exist.
        );
        
        # COMPLEMENTO; COUNT HOW MANY REPETITIONS WE HAVE FOR EACH FILTER VALUE
        for my $Filter(keys %{$Self->{CompFilters}}){
            {
                no warnings 'all';
                $Counters{$Filter}->{$Ticket{  $Self->{CompFilters}->{$Filter}->{TicketKey}}}++;
            }
        }
    }

    # COMPLEMENTO: TRANSLATE VALUES AND ADD THE COUNT AT THE END. FOR EXAMPLE: Pending (5)
    for my $Filter(keys %{$Self->{CompFilters}}){
        for my $Value (keys %{$Counters{$Filter}}){
            if($Self->{CompFilters}->{$Filter}->{Type} eq 'Agent'){
                #COMPLEMENTO: GET AGENT's NAME
                my $Username='';
                # If not allocated (Admin OTRS), translate it
                $Username=
                    $Value==1?
                    '- '.$LayoutObject->{LanguageObject}->Translate('Without Owner').' -':
                    $UserObject->UserName( UserID=>$Value, );
                $Counters{$Filter}->{$Value}=$Username." ($Counters{$Filter}->{$Value})";
            } elsif($Self->{CompFilters}->{$Filter}->{Type} eq 'CustomerCompany'){
                #COMPLEMENTO: GET Company Name
                my %Company=$Self->{CustomerCompanyObject}->CustomerCompanyGet(
                    CustomerID => $Value,
                );
                my $CustomerCompanyName;
                # max width
                $Param{Max} = 35;
                if ( $Company{CustomerCompanyName} && $Param{Max} && length $Company{CustomerCompanyName} > $Param{Max} ) {
                    $CustomerCompanyName = substr( $Company{CustomerCompanyName}, 0, $Param{Max} - 5 ) . '[...]';
                } elsif ($Company{CustomerCompanyName}) {
                    $CustomerCompanyName = $Company{CustomerCompanyName};
                } else {    
                    $CustomerCompanyName = '- '.$LayoutObject->{LanguageObject}->Translate('Without Company').' -';
                };

                $Counters{$Filter}->{$Value}=$CustomerCompanyName." ($Counters{$Filter}->{$Value})";

            } else {
                if($Value eq ''){
                    no warnings 'all';
                    delete $Counters{$Filter}->{$_};
                } else {
                    $Counters{$Filter}->{$Value}=$LayoutObject->{LanguageObject}->Translate($Value)." ($Counters{$Filter}->{$Value})";
                }

            }
        }
    }
    
    my $CountTotal = scalar(@ViewableTickets)||0;
    my %NavBarFilter;

    my $LinkSort = 'NotFirstRun=1;View=' . $LayoutObject->Ascii2Html( Text => $Self->{View} );
    my $LinkPage = 'NotFirstRun=1;View=' . $LayoutObject->Ascii2Html( Text => $Self->{View} )
        . ';SortBy=' . $LayoutObject->Ascii2Html( Text => $SortBy )
        . ';OrderBy=' . $LayoutObject->Ascii2Html( Text => $OrderBy ).';';
    my $LinkFilter = 'NotFirstRun=1;';

    #COMPLEMENTO: COUNT TICKETS IN EACH ESCALATION STATE
    for my $i (1..4){
        $EscalationFilters{ $i }->{Count} = $TicketObject->TicketSearch(
            %{ $Filters{ $Self->{Filter} }->{Search} },
            %{ $EscalationFilters{ $i }->{Search} },
            %ComplementoFilter,
            Result => 'COUNT',
        );
    }

    # Resend current filters when sorting the list.
    for my $Filter(keys %{$Self->{CompFilters}}){
        if ($Self->{$Filter}){
            
            for my $Value (@{$Self->{$Filter}}){
                $LinkSort.=$LayoutObject->Ascii2Html( Text => ';'.$Filter."=".uri_escape(Encode::encode("utf-8",$Value)) );
                $LinkFilter.=$LayoutObject->Ascii2Html( Text => $Filter."=".uri_escape(Encode::encode("utf-8",$Value)).';' );
                $LinkPage.=$LayoutObject->Ascii2Html( Text => $Filter."=".uri_escape(Encode::encode("utf-8",$Value)).';' );
            }
        }
    }



    my %NavBar = $Self->BuildQueueView(
                                         Filter => $Self->{Filter}, 
                                         EscalationFilters => \%EscalationFilters,
                                         ComplementoFilter => \%ComplementoFilter,
                                         Counters => \%Counters,
                                         );

    my $Output;
    if ( $Self->{Subaction} ne 'AJAXFilterUpdate' ) {
        $Output = $LayoutObject->Header(
            Refresh => $Refresh,
        );
        $Output .= $LayoutObject->NavigationBar();
    }
    
    
    # show tickets
    $Output .= $LayoutObject->TicketListShow(
        Filter     => $Self->{Filter},
        Filters    => \%NavBarFilter,
        FilterLink => $LinkFilter,

        DataInTheMiddle => $LayoutObject->Output(
            TemplateFile => 'AgentTicketQueue',
            Data         => \%NavBar,
        ),

        TicketIDs => \@ViewableTickets,

#        OriginalTicketIDs => \@OriginalViewableTickets,
        GetColumnFilter   => \%GetColumnFilter,
#        LastColumnFilter  => $LastColumnFilter,
        Action            => 'AgentTicketComplementoView',
        Total             => $CountTotal,
        RequestedURL      => $Self->{RequestedURL},

        NavBar => \%NavBar,
        View   => $Self->{View},

        Bulk       => 1,

        TitleName  => 'Complemento View',
        TitleValue => '',

        Env        => $Self,
        LinkPage   => $LinkPage,
        LinkSort   => $LinkSort,
        LinkFilter => $LinkFilter,

        OrderBy             => $OrderBy,
        SortBy              => $SortBy,
        EnableColumnFilters => 1,
        ColumnFilterForm    => {
            QueueID => $Self->{QueueID} || '',
            Filter  => $Self->{Filter}  || '',
        },

        # do not print the result earlier, but return complete content
        Output => 1,
    );

    # get page footer
    $Output .= $LayoutObject->Footer() if $Self->{Subaction} ne 'AJAXFilterUpdate';
    return $Output;
}

sub BuildQueueView {
    my ( $Self, %Param ) = @_;
    return $Self->_MaskQueueView(
        ViewableTickets   => $Self->{ViewableTickets},
        Locks            => \%{$Param{Locks}},
        EscalationFilters => \%{$Param{EscalationFilters}},
        Counters => \%{$Param{Counters}},
    );
}

sub _MaskQueueView {
    my ( $Self, %Param ) = @_;
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $SessionObject = $Kernel::OM->Get('Kernel::System::AuthSession');
    my $UserObject =  $Kernel::OM->Get('Kernel::System::User');
    my $TimeObject = $Kernel::OM->Get('Kernel::System::Time');
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');
    
    my $QueueIDOfMaxAge = $Param{QueueIDOfMaxAge} || -1;

    my %Counter;

    # COMPLEMENTO: BUILD A FORM FOR THE FILTERS
    $Param{QueueStrg} = " 
        <form name=\"filters\" id=\"filters\" action=\"$LayoutObject->{Baselink}\">
             <input type=\"hidden\" name=\"Action\" value=\"AgentTicketComplementoView\">
             <input type=\"hidden\" name=\"View\" value=\"$Self->{View}\">
             <input type=\"hidden\" name=\"Filter\" value=\"$Self->{Filter}\">
             <input type=\"hidden\" name=\"SortBy\" value=\"$Self->{SortBy}\">
             <input type=\"hidden\" name=\"OrderBy\" value=\"$Self->{OrderBy}\">
             <input type=\"hidden\" name=\"NotFirstRun\" value=\"1\">
             <!-- input type=\"hidden\" name=\"StartHit\" value=\"$Self->{Start}\" -->
             <input type=\"hidden\" name=\"Session\" value=\"$Self->{SessionID}\">
             <input type=\"hidden\" name=\"OTRSAgentInterface\" value=\"$Self->{SessionID}\">
             <input type=\"hidden\" name=\"$LayoutObject->{SessionName}\" value=\"$LayoutObject->{SessionID}\">
             ";

    $Param{QueueStrg} .= "<div style='float:left'>";

    # Complemento Filters
    for my $Filter(sort keys %{$Self->{CompFilters}}){
        $Param{QueueStrg} .= "</div><div style='float:left;margin-left:20px;'>";
        my $label=$Self->{CompFilters}->{$Filter}->{Label}||$Self->{CompFilters}->{$Filter}->{TicketKey};
        $label=$LayoutObject->{LanguageObject}->Translate($label);
        my $jsMultiple='';
        my $onChange='';
        my $possibleNone=0;
        my $applyText='Apply';
        my $close ="
            close: function(){
              \$('#filters').submit();
            },
        ";
        if(!$Self->{CompFilters}->{$Filter}->{Multiple}){
            $jsMultiple   ="multiple: false,";        
            $onChange     ="\$('#filters').submit();";
            $possibleNone ="1";
            $applyText    ="select one bellow to apply";
            $close = '';
        };


        if($Self->{CompFilters}->{$Filter}->{Type} eq 'TicketAttribute' ||
           $Self->{CompFilters}->{$Filter}->{Type} eq 'Agent' ||
           $Self->{CompFilters}->{$Filter}->{Type} eq 'CustomerCompany' ||
           $Self->{CompFilters}->{$Filter}->{Type} eq 'DynamicField'
           ){
            $Param{QueueStrg} .= $LayoutObject->BuildSelection(
                Data => \%{$Param{Counters}->{   $Filter       }},
                Multiple => $Self->{CompFilters}->{$Filter}->{Multiple},
                Size => 4,
                Name => $Filter,
                ID   => $Filter,
                PossibleNone => $possibleNone,
                SelectedID => $Self->{$Filter},
                Class   => 'FilterSelect',
                OnChange      => $onChange,
            );
        } elsif ($Self->{CompFilters}->{$Filter}->{Type} eq 'Escalation'){
            my %Escalations;

            $Escalations{1} = $LayoutObject->{LanguageObject}->Translate('Escalated Tickets').' ('.$Param{EscalationFilters}->{1}->{Count}.')';
            $Escalations{2} = $LayoutObject->{LanguageObject}->Translate('Today').' ('.$Param{EscalationFilters}->{2}->{Count}.')';
            $Escalations{3} = $LayoutObject->{LanguageObject}->Translate('Tomorrow').' ('.$Param{EscalationFilters}->{3}->{Count}.')';
            $Escalations{4} = $LayoutObject->{LanguageObject}->Translate('Next Week').' ('.$Param{EscalationFilters}->{4}->{Count}.')';

            $Escalations{5} = $LayoutObject->{LanguageObject}->Translate('Solution Expired').' ('.$Param{EscalationFilters}->{5}->{Count}.')';
            $Escalations{6} = $LayoutObject->{LanguageObject}->Translate('Solution Expires Today').' ('.$Param{EscalationFilters}->{6}->{Count}.')';
            $Escalations{7} = $LayoutObject->{LanguageObject}->Translate('Solution Expires Tomorrow').' ('.$Param{EscalationFilters}->{7}->{Count}.')';
            $Escalations{8} = $LayoutObject->{LanguageObject}->Translate('Solution Expires Next Week').' ('.$Param{EscalationFilters}->{8}->{Count}.')';

            $Escalations{9} = $LayoutObject->{LanguageObject}->Translate('First Response Expired').' ('.$Param{EscalationFilters}->{9}->{Count}.')';
            $Escalations{10} = $LayoutObject->{LanguageObject}->Translate('First Response Expires Today').' ('.$Param{EscalationFilters}->{10}->{Count}.')';
            $Escalations{11} = $LayoutObject->{LanguageObject}->Translate('First Response Expires Tomorrow').' ('.$Param{EscalationFilters}->{11}->{Count}.')';
            $Escalations{12} = $LayoutObject->{LanguageObject}->Translate('First Response Expires Next Week').' ('.$Param{EscalationFilters}->{12}->{Count}.')';

            $Escalations{13} = $LayoutObject->{LanguageObject}->Translate('Follow Up Expired').' ('.$Param{EscalationFilters}->{13}->{Count}.')';
            $Escalations{14} = $LayoutObject->{LanguageObject}->Translate('Follow Up Expires Today').' ('.$Param{EscalationFilters}->{14}->{Count}.')';
            $Escalations{15} = $LayoutObject->{LanguageObject}->Translate('Follow Up Expires Tomorrow').' ('.$Param{EscalationFilters}->{15}->{Count}.')';
            $Escalations{16} = $LayoutObject->{LanguageObject}->Translate('Follow Up Expires Next Week').' ('.$Param{EscalationFilters}->{16}->{Count}.')';

            $Param{QueueStrg} .= $LayoutObject->BuildSelection(
                Data => \%Escalations,
                Name => $Filter,
                ID   => $Filter,
                PossibleNone => $possibleNone,
                Size     => 4,
                SelectedID => $Self->{$Filter},
                OnChange      => $onChange,
                Sort => 'NumericKey',
                Class   => 'FilterSelect',
            );
        }

        my $JS = "

        <script type=\"text/javascript\">//<![CDATA[
        \$('#$Filter').multiselect({
            noneSelectedText:'$label',
            selectedText    :'$label: # item(s) selecionado(s)',
            $jsMultiple
            applyText    :'".$LayoutObject->{LanguageObject}->Translate($applyText)."',
            uncheckAllText  :'".$LayoutObject->{LanguageObject}->Translate('Clear')."',
            uncheckAll: function(){
              \$('#filters').submit();
            },
            $close

            }).multiselectfilter(
            {
              label: '".$LayoutObject->{LanguageObject}->Translate('Filter').":',
              placeholder: '',
            });
        //]]></script>
";
$LayoutObject->AddJSOnDocumentComplete( Code => $JS );

                        
    }
    
    # Close the tags need    
    $Param{QueueStrg} .= "</div></form>";

    # Remove filters from overviewsmall columns
    my $JS = '
            <script type="text/javascript">//<![CDATA[
            $(\'.ColumnSettingsTrigger\').remove();
            $(\'.OverviewBox h1\').remove();
            $(\'.WidgetSimple\').css(\'margin-bottom\',\'0px\');
            //]]></script>


    ';
    $LayoutObject->AddJSOnDocumentComplete( Code => $JS );


        
    return (
        MainName      => 'Queues',
        MainContent   => $Param{QueueStrg},
        Total         => $Param{TicketsShown},
    );
}

1;
