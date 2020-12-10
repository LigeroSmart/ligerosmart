# Kernel/Modules/AgentTicketQueueKanban.pm - the queue view of all tickets
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentTicketQueueKanban;

use strict;
use warnings;
use Data::Dumper;
use Kernel::System::JSON;
use Kernel::System::CustomerCompany;
use Kernel::System::State;
use Kernel::System::Lock;
use Kernel::System::Lock;
use Kernel::System::DynamicField;
use Kernel::System::Priority;
use Kernel::System::VariableCheck qw(:all);

# COMPLEMENTO
use URI::Escape qw(uri_escape);
use Digest::MD5 qw(md5_hex);
use Kernel::System::ObjectManager;

our $ObjectManagerDisabled = 1;

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

    $Self->{Config} = $Kernel::OM->Get('Kernel::Config')->Get("Kanboard");
    $Self->{QueuesConfig} = $Kernel::OM->Get('Kernel::Config')->Get("Kanboard::QueuesConfig");
    $Self->{QueuesConfigStates} = $Kernel::OM->Get('Kernel::Config')->Get("Kanboard::QueuesConfigStates");
    $Self->{TypesAlias}	  = $Kernel::OM->Get('Kernel::Config')->Get("Kanboard::TypesAlias");

    # get config data
    $Self->{ViewableSenderTypes} = $Kernel::OM->Get('Kernel::Config')->Get('Ticket::ViewableSenderTypes')
        ||$Kernel::OM->Get('Kernel::Output::HTML::Layout')->FatalError(
        Message => 'No Config entry "Ticket::ViewableSenderTypes"!'
        );
    $Self->{CustomQueue} =$Kernel::OM->Get('Kernel::Config')->Get('Ticket::CustomQueue') || '???';

    # Get configurations from SysConfig
    #$Self->{Config} = $ConfigObject->Get("Ticket::Frontend::$Self->{Action}");

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

    # COMPLEMENTO
    $Self->{State}       =$ParamObject->GetParam( Param => 'State' )     || '';
    $Self->{Priority}    =$ParamObject->GetParam( Param => 'Priority' )     || '';
    $Self->{TicketID}    =$ParamObject->GetParam( Param => 'TicketID' )     || '';

    # COMPLEMENTO: GET THE FILTERS SPECIFIED ON SYSCONFIG.
    $Self->{CompFilters}=$ConfigObject->Get("Ticket::Frontend::AgentTicketQueueKanbanFilters");

    my %Preferences = $UserObject->GetPreferences(
        UserID => $Self->{UserID},
    );

    # Get Values of the filters from post or get
    for my $Filter (keys %{ $Self->{CompFilters} }){
        if($ParamObject->GetParam( Param => 'NotFirstRun' )){
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

            my $jsonData = $Kernel::OM->Get('Kernel::System::JSON')->Encode(
                Data => $Self->{$Filter}||'',
            );   

            $UserObject->SetPreferences(
                Key    => "Kanboard_$Filter",
                Value  => $jsonData,
                UserID => $Self->{UserID},
            );
        } else {
            if($Preferences{"Kanboard_$Filter"} && $Preferences{"Kanboard_$Filter"} ne "" && $Preferences{"Kanboard_$Filter"} ne "\"\""){

                $Self->{$Filter} = $Kernel::OM->Get('Kernel::System::JSON')->Decode(
                    Data => $Preferences{"Kanboard_$Filter"},
                );
            }
        }
        if((ref $Self->{$Filter}) ne 'HASH' && (ref $Self->{$Filter}) ne 'ARRAY'){
            $Self->{$Filter} = '';
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
    
	# COMPLEMENTO - UPDATE TICKET STATE ON COLUMN CHANGE
	if ($Self->{Subaction} eq "StateUpdate"){

		my $Success = $Kernel::OM->Get('Kernel::System::Ticket')->TicketStateSet(
			State  => $Self->{State},
			TicketID => $Self->{TicketID},
			UserID   => $Self->{UserID},
		);

        $Kernel::OM->Get('Kernel::Output::HTML::Layout')->Block(
            Name => 'event_result',
            Data => $Success,
        );
		
	    my %StateType =$Kernel::OM->Get('Kernel::System::State')->StateGet(
	        Name  => $Self->{State},
	    );
		
		if ($StateType{TypeName} eq 'pending auto' || $StateType{TypeName} eq 'pending reminder'){
			my $difftime =$Kernel::OM->Get('Kernel::Config')->Get('Ticket::Frontend::PendingDiffTime');
	    	my $Success = $Kernel::OM->Get('Kernel::System::Ticket')->TicketPendingTimeSet(
				Diff     => $difftime/60,
				TicketID => $Self->{TicketID},
				UserID   => $Self->{UserID},
			);
		}		

	}

	# COMPLEMENTO - UPDATE TICKET STATE ON COLUMN CHANGE
	if ($Self->{Subaction} eq "PriorityUpdate"){

		my $Success = $Kernel::OM->Get('Kernel::System::Ticket')->TicketPrioritySet(
			Priority  => $Self->{Priority},
			TicketID => $Self->{TicketID},
			UserID   => $Self->{UserID},
		);

        $Kernel::OM->Get('Kernel::Output::HTML::Layout')->Block(
            Name => 'event_result',
            Data => $Success,
        );
		
	    my %StateType =$Kernel::OM->Get('Kernel::System::State')->StateGet(
	        Name  => $Self->{State},
	    );
		
		if (($StateType{TypeName} && $StateType{TypeName} eq 'pending auto') ||
            ( $StateType{TypeName} && $StateType{TypeName} eq 'pending reminder')){
			my $difftime =$Kernel::OM->Get('Kernel::Config')->Get('Ticket::Frontend::PendingDiffTime');
	    	my $Success = $Kernel::OM->Get('Kernel::System::Ticket')->TicketPendingTimeSet(
				Diff     => $difftime/60,
				TicketID => $Self->{TicketID},
				UserID   => $Self->{UserID},
			);
		}		

	}

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
    
    my $URL = "Action=AgentTicketQueueKanban";

    $Kernel::OM->Get('Kernel::System::AuthSession')->UpdateSessionID(
        SessionID => $Self->{SessionID},
        Key       => 'LastScreenOverview',
        Value     => $URL,
    );

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

    # store last queue screen
    $Kernel::OM->Get('Kernel::System::AuthSession')->UpdateSessionID(
        SessionID => $Self->{SessionID},
        Key       => 'LastScreenOverview',
        Value     => $Self->{RequestedURL},
    );

    # store last screen
    $Kernel::OM->Get('Kernel::System::AuthSession')->UpdateSessionID(
        SessionID => $Self->{SessionID},
        Key       => 'LastScreenView',
        Value     => $Self->{RequestedURL},
    );

    # get filters stored in the user preferences
    my %Preferences = $Kernel::OM->Get('Kernel::System::User')->GetPreferences(
        UserID => $Self->{UserID},
    );
    
    my $StoredFilters = {};

    # delete stored filters if needed
    if ($ParamObject->GetParam( Param => 'DeleteFilters' ) ) {
        $StoredFilters = {};
    }

    # get the column filters from the web request or user preferences
    my %ColumnFilter;
    my %GetColumnFilter;

    COLUMNNAME:
    for my $ColumnName (
        qw(Owner Responsible Lock State Queue Priority Type Lock Service SLA CustomerID CustomerUserID)
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
    $Self->{DynamicField} =$Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldListGet(
        Valid      => 1,
        ObjectType => ['Ticket'],
    );

    DYNAMICFIELD:
    for my $DynamicFieldConfig ( @{ $Self->{DynamicField} } ) {
        next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);
        next DYNAMICFIELD if !$DynamicFieldConfig->{Name};

        # get filter from web request
        my $FilterValue =$ParamObject->GetParam(
            Param => 'ColumnFilterDynamicField_' . $DynamicFieldConfig->{Name}
        );

        # if no filter from web request, try from user preferences
        if ( !defined $FilterValue || $FilterValue eq '' ) {
            $FilterValue
                = $StoredFilters->{ 'DynamicField_' . $DynamicFieldConfig->{Name} }->{Equals};
        }

        next DYNAMICFIELD if !defined $FilterValue;
        next DYNAMICFIELD if $FilterValue eq '';
        next DYNAMICFIELD if $FilterValue eq 'DeleteFilter';

        $ColumnFilter{ 'DynamicField_' . $DynamicFieldConfig->{Name} } = {
            Equals => $FilterValue,
        };
        $GetColumnFilter{ 'DynamicField_' . $DynamicFieldConfig->{Name} } = $FilterValue;
    }

    # if we have only one queue, check if there
    # is a setting in Config.pm for sorting
    if ( !$OrderBy ) {
        if ( $Self->{Config}->{QueueSort} ) {
            if ( defined $Self->{Config}->{QueueSort}->{ $Self->{QueueID} } ) {
                if ( $Self->{Config}->{QueueSort}->{ $Self->{QueueID} } ) {
                    $OrderBy = 'Down';
                }
                else {
                    $OrderBy = 'Up';
                }
            }
        }
    }
    if ( !$OrderBy ) {
        $OrderBy = $Self->{Config}->{'Order::Default'} || 'Up';
    }

    # build NavigationBar & to get the output faster!
    my $Refresh = '';
    if ( $Self->{UserRefreshTime} ) {
        $Refresh = 60 * $Self->{UserRefreshTime};
    }

    my $Output;
    if ( $Self->{Subaction} ne 'AJAXFilterUpdate') {
        $Output =$Kernel::OM->Get('Kernel::Output::HTML::Layout')->Header( Refresh => $Refresh, );
        $Output .=$Kernel::OM->Get('Kernel::Output::HTML::Layout')->NavigationBar();
       $Kernel::OM->Get('Kernel::Output::HTML::Layout')->Print( Output => \$Output );
        $Output = '';
    }

    # viewable locks
    my @ViewableLockIDs =$Kernel::OM->Get('Kernel::System::Lock')->LockViewableLock( Type => 'ID' );

    # viewable states
    my @ViewableStateIDs =$Kernel::OM->Get('Kernel::System::State')->StateGetStatesByType(
        Type   => 'Viewable',
        Result => 'ID',
    );

    # get permissions
    my $Permission = 'rw';
    if ( $Self->{Config}->{ViewAllPossibleTickets} ) {
        $Permission = 'ro';
    }

    # sort on default by using both (Priority, Age) else use only one sort argument
    my %Sort;

    # get if search result should be pre-sorted by priority
    my $PreSortByPriority = $Self->{Config}->{'PreSort::ByPriority'};
    if ( !$PreSortByPriority ) {
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
               $Self->{CompFilters}->{$Filter}->{Type} eq 'Responsible'   ||
               $Self->{CompFilters}->{$Filter}->{Type} eq 'Lock'   ||
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

     my %Counters;

    # check if filter is valid
    if ( !$Filters{ $Self->{Filter} } ) {
       $Kernel::OM->Get('Kernel::Output::HTML::Layout')->FatalError( Message => "Invalid Filter: $Self->{Filter}!" );
    }

    # lookup latest used view mode
    if ( !$Self->{View} && $Self->{ 'UserTicketOverview' . $Self->{Action} } ) {
        $Self->{View} = $Self->{ 'UserTicketOverview' . $Self->{Action} };
    }

    # otherwise use Preview as default as in LayoutTicket
    $Self->{View} ||= 'Preview';

    # get personal page shown count
    my $PageShownPreferencesKey = 'UserTicketOverview' . $Self->{View} . 'PageShown';
    my $PageShown = $Self->{$PageShownPreferencesKey} || 10;

    # do shown tickets lookup
    my $Limit = 10_000;

    my $ElementChanged =$ParamObject->GetParam( Param => 'ElementChanged' ) || '';
    my $HeaderColumn = $ElementChanged;
    $HeaderColumn =~ s{\A ColumnFilter }{}msxg;

    # get data (viewable tickets...)
    # search all tickets
    my @ViewableTickets;
    my @OriginalViewableTickets;

    my $CountTotal = 0;
    my %NavBarFilter;

	# Check if there is a special config for this queue exibition
	my @queueconfig=(0);
    my @queueconfigstates=(0);

	if(exists $Self->{QueuesConfig}->{$Self->{QueueID}}){
		@queueconfig = ($Self->{QueueID});
    }

    if(exists $Self->{QueuesConfigStates}->{$Self->{QueueID}}){
        @queueconfigstates = ($Self->{QueueID});
    }

     if($ComplementoFilter{Queues}){
        @queueconfig = ();
        @queueconfigstates=();
        foreach my $val (@{$ComplementoFilter{Queues}}) {

             my %Queue = $Kernel::OM->Get('Kernel::System::Queue')->QueueGet(
                Name  => $val,
            );

             if(exists $Self->{QueuesConfig}->{int($Queue{QueueID})}){
                my $exists = 0;
                foreach my $qu (@queueconfig){
                    if($qu == int($Queue{QueueID})){
                        $exists = 1;
                    }
                }
                if(!$exists){
                    push @queueconfig,int($Queue{QueueID});
                }
            } else {
                my $exists = 0;
                foreach my $qu (@queueconfig){
                    if($qu == 0){
                        $exists = 1;
                    }
                }
                if(!$exists){
                    push @queueconfig,0;
                }
            }

             if(exists $Self->{QueuesConfigStates}->{int($Queue{QueueID})}){
                my $exists = 0;
                foreach my $qu (@queueconfigstates){
                    if($qu == int($Queue{QueueID})){
                        $exists = 1;
                    }
                }
                if(!$exists){
                    push @queueconfigstates,int($Queue{QueueID});
                }
            } else {
                my $exists = 0;
                foreach my $qu (@queueconfigstates){
                    if($qu == 0){
                        $exists = 1;
                    }
                }
                if(!$exists){
                    push @queueconfigstates,0;
                }
            }
        }
    } 	

	$Kernel::OM->Get('Kernel::Output::HTML::Layout')->Block(
		Name => 'queue_kanban',
		Data => {
            AdditionalClass => $Self->{Config}->{AdditionalClass} || '',
			QueueID => $Self->{QueueID},
		}
	);
	if($Self->{Config}->{RefreshPage}){
		my $Minutes = $Self->{Config}->{RefreshPageMinutes} || 1;
		$Minutes = $Minutes * 60000;
		
		$Kernel::OM->Get('Kernel::Output::HTML::Layout')->Block(
		Name => 'refresh_page',
		Data => {
			Minutes => $Minutes,
		}
	);
	
	}
	
    my %States = ();
    my $count = 0;
    foreach my $qu (@queueconfig) {
        foreach my $key (sort (keys(%{$Self->{QueuesConfig}->{$qu}}))) {
            my $exists = 0;
            while (my ($key1, $value1) = each (%States))
            {
                if($value1 eq ${$Self->{QueuesConfig}->{$qu}}{$key}){
                    $exists = 1;
                }
            }

             if(!$exists){
                $States{$count} = ${$Self->{QueuesConfig}->{$qu}}{$key};
                $count = $count+1;
            }
        }
    }
    my $ref = $Self->{QueuesConfigStates};
    if(keys %$ref){
        my $count = 0;
        %States = ();
        foreach my $qu (@queueconfigstates) {
            if(exists $Self->{QueuesConfigStates}->{$qu}){
                my @values = split(',',$Self->{QueuesConfigStates}->{$qu});


                 foreach my $val (@values) {
                    my $exists = 0;
                    while (my ($key1, $value1) = each (%States))
                    {
                        if($value1 eq $val){
                            $exists = 1;
                        }
                    }

                     if(!$exists){
                        $States{$count} = $val;
                        $count = $count+1;
                    }
                }
            }
        }
    }

	my %Limits;

	for my $st (keys %States){
	
		my ($name,$limit) = split(/\|/,$States{$st});
		$States{$st} = $name;
		$Limits{$name}=$limit||0;
	}

	# COMPLEMENTO - PRINT HEADER
    STATEVERIFY:
    for my $State ( sort keys %States ) {
	    my %StateType =$Kernel::OM->Get('Kernel::System::State')->StateGet(
	        Name  => $States{$State},
	    );

		$Kernel::OM->Get('Kernel::Output::HTML::Layout')->Block(
			Name => 'column_header',
			Data => {
				State => $States{$State},
				CountTickets => '0',
			}
		);
		
		if ($StateType{TypeName} && $StateType{TypeName} eq 'closed'){
			$Kernel::OM->Get('Kernel::Output::HTML::Layout')->Block(
				Name => 'last_tickets',
			);
		}		
	
		my %Out;    
		my %Closed;
		
		$Out{State}=$States{$State};
		
		if ($StateType{TypeName} && $StateType{TypeName} eq 'closed'){
			$Closed{TicketCloseTimeNewerMinutes}=1440;
		}		


    	# complemento - open column
	    my @Tickets = $Kernel::OM->Get('Kernel::System::Ticket')->TicketSearch(
	        %{ $Filters{ $Self->{Filter} }->{Search} },
	        %ComplementoFilter,
	        %Closed,
	        States => ["$States{$State}"],
	        SortBy => 'Priority',
	        OrderBy=> 'Down',
	        Result => 'ARRAY',
	    );

        if($ComplementoFilter{States}){
            if (grep $_ eq $States{$State}, @{$ComplementoFilter{States}}) {

             } else {
                @Tickets = ();
            }

         }

	    my $count=scalar(@Tickets);
	    my $warning;
		if (($Limits{$States{$State}} ne '0') && ($count > $Limits{$States{$State}})){
			$Out{warning}='task-limit-warning';
		}

		$Kernel::OM->Get('Kernel::Output::HTML::Layout')->Block(
			Name => 'column_content',
			Data => \%Out,
		);

        for my $Filter(keys %{$Self->{CompFilters}}){
            {
                no warnings 'all';
                if($Self->{CompFilters}->{$Filter}->{FilterKey} eq "Queues"){
                    my %Queues = $Kernel::OM->Get('Kernel::System::Queue')->QueueList( Valid => 1 );
                    for my $queue(values %Queues){
                        $Counters{$Filter}->{$queue} = $queue;
                    }

                 } 
            }
        }


		# SEARCH TICKETS AND OUTPUT
		for my $TicketID (@Tickets){
			my %Out;
			my %Ticket = $Kernel::OM->Get('Kernel::System::Ticket')->TicketGet(
				TicketID      => $TicketID,
				DynamicFields => 1,         # Optional, default 0. To include the dynamic field values for this ticket on the return structure.
				UserID        => 1,
				Silent        => 0,         # Optional, default 0. To suppress the warning if the ticket does not exist.
				Extended	  => 0,
				
			
			);

            # COMPLEMENTO; COUNT HOW MANY REPETITIONS WE HAVE FOR EACH FILTER VALUE
            for my $Filter(keys %{$Self->{CompFilters}}){
                {
                    no warnings 'all';
                    if($Self->{CompFilters}->{$Filter}->{FilterKey} ne "Queues"){
                        $Counters{$Filter}->{$Ticket{  $Self->{CompFilters}->{$Filter}->{TicketKey}}}++;
                    } 
                }
            }

			$Param{Name}='';
			$Param{Name} = $Kernel::OM->Get('Kernel::System::User')->UserName(
				UserID => $Ticket{OwnerID}
			);
			$Param{ResponsibleName} = $Kernel::OM->Get('Kernel::System::User')->UserName(
				UserID => $Ticket{ResponsibleID}
			);
			my %User = $Kernel::OM->Get('Kernel::System::User')->GetUserData(
				UserID => $Ticket{OwnerID}
			);

			$Param{EscalationText}='';
			$Param{EscalationClass}='';
		
			if (defined $Ticket{EscalationDestinationDate}){
				if( ($Ticket{FirstResponseTimeEscalation} && $Ticket{FirstResponseTimeEscalation} eq '1' )|| 
				    ($Ticket{UpdateTimeEscalation} && $Ticket{UpdateTimeEscalation} eq '1') || 
				    ($Ticket{SolutionTimeEscalation} && $Ticket{SolutionTimeEscalation} eq '1')){
					# Escalated
					$Param{EscalationText} =$Kernel::OM->Get('Kernel::Output::HTML::Layout')->{LanguageObject}->Translate( 'Escalated on' ).' '.
									$Kernel::OM->Get('Kernel::Output::HTML::Layout')->{LanguageObject}->FormatTimeString($Ticket{EscalationDestinationDate});
						$Param{EscalationClass}='escalation-red';
				} elsif ( 
                    exists $Ticket{FirstResponseTimeNotification} and $Ticket{FirstResponseTimeNotification} eq '1' || 
				    exists $Ticket{UpdateTimeNotification} and $Ticket{UpdateTimeNotification} eq '1' || 
				    exists $Ticket{SolutionTimeNotification} and $Ticket{SolutionTimeNotification} eq '1'
                    ){
			   		# Notify
					$Param{EscalationText} =$Kernel::OM->Get('Kernel::Output::HTML::Layout')->{LanguageObject}->Translate( 'Escalation in' ).': '.
									$Kernel::OM->Get('Kernel::Output::HTML::Layout')->{LanguageObject}->FormatTimeString($Ticket{EscalationDestinationDate});
					$Param{EscalationClass}='escalation-yellow';
				} else {
					# In time
					$Param{EscalationText} =$Kernel::OM->Get('Kernel::Output::HTML::Layout')->{LanguageObject}->Translate( 'Escalation in' ).': '.
									$Kernel::OM->Get('Kernel::Output::HTML::Layout')->{LanguageObject}->FormatTimeString($Ticket{EscalationDestinationDate});
					$Param{EscalationClass}='escalation-green';
				};
			}

			my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout'); 
			$Param{SessionName} = $LayoutObject->{SessionName} . '=' . $LayoutObject->{SessionID};

            # Prefix for Owner and Responsible
            $Param{OwnerPrefix} = $Self->{Config}->{OwnerPrefix};
            $Param{ResponsiblePrefix} = $Self->{Config}->{ResponsiblePrefix};

            # Customer Company Fullname
            if($Ticket{CustomerID} && $Self->{Config}->{UseCustomerCompanyName}){
                my %CustomerCompany = $Kernel::OM->Get('Kernel::System::CustomerCompany')->CustomerCompanyGet(
                    CustomerID => $Ticket{CustomerID}
                );
                $Param{CustomerName} = $CustomerCompany{CustomerCompanyName} || $Ticket{CustomerID};
            }

			$Kernel::OM->Get('Kernel::Output::HTML::Layout')->Block(
				Name => 'task',
				Data => {
					%Param,
					%Ticket,
				},
			);

            # Type Alias
			$Ticket{Type} = $Self->{TypesAlias}->{$Ticket{Type}} || $Ticket{Type};

            if(IsHashRefWithData($Self->{TypesAlias})){
                $Kernel::OM->Get('Kernel::Output::HTML::Layout')->Block(
                    Name => "TypesAlias",
                    Data => {
                        TypesAlias => $Ticket{Type}
                    },
                );
            }

            if($Kernel::OM->Get('Kernel::Config')->Get("Ticket::Responsible")){
                $Kernel::OM->Get('Kernel::Output::HTML::Layout')->Block(
                    Name => 'taskResponsible',
                    Data => {
                        %Param,
                        %Ticket,
                    },
                );
            }

#######################################################################
            # DynamicFields
            # get dynamic field config for frontend module
            my $DynamicFieldFilter = {
                %{ $Self->{Config}->{DynamicField} || {} },
            };

            # get the dynamic fields for ticket object
            my $DynamicField = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldListGet(
                Valid       => 1,
                ObjectType  => ['Ticket'],
                FieldFilter => $DynamicFieldFilter || {},
            );
            my $DynamicFieldBackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

            # cycle trough the activated Dynamic Fields for ticket object
            DYNAMICFIELD:
            for my $DynamicFieldConfig ( @{$DynamicField} ) {
                next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);
                next DYNAMICFIELD if !defined $Ticket{ 'DynamicField_' . $DynamicFieldConfig->{Name} };
                next DYNAMICFIELD if $Ticket{ 'DynamicField_' . $DynamicFieldConfig->{Name} } eq '';

                # use translation here to be able to reduce the character length in the template
                my $Label = $LayoutObject->{LanguageObject}->Translate( $DynamicFieldConfig->{Label} );
                my $ValueStrg = $DynamicFieldBackendObject->DisplayValueRender(
                    DynamicFieldConfig => $DynamicFieldConfig,
                    Value              => $Ticket{ 'DynamicField_' . $DynamicFieldConfig->{Name} },
                    LayoutObject       => $LayoutObject,
                );

                my $DynamicFieldClass;

                # ITSMDueDate Class
                if($DynamicFieldConfig->{Name} eq 'ITSMDueDate'){
                    if( $Kernel::OM->Get('Kernel::System::Time')->TimeStamp2SystemTime(
                            String => $Ticket{ 'DynamicField_ITSMDueDate' } 
                        ) < $Kernel::OM->Get('Kernel::System::Time')->SystemTime())
                    {
                        $DynamicFieldClass = 'task-board-footer escalation-red';
                    } else {
                        $DynamicFieldClass = 'task-board-footer escalation-green';
                    }
                }

                $LayoutObject->Block(
                    Name => 'DynamicField',
                    Data => {
                        Value => $ValueStrg->{Value},
                        Label => $Label,
                        DynamicFieldClass => $DynamicFieldClass
                    },
                );
            }
#########################################################################################################


            # Gravatar
			if($Self->{Config}->{UseGravatar}){
				my $email = $User{UserEmail};
				my $size = 30;
				my $grav_url = "https://www.gravatar.com/avatar/".md5_hex(lc $email)."?&s=".$size;

				$Kernel::OM->Get('Kernel::Output::HTML::Layout')->Block(
					Name => 'gravatar',
					Data => {
						grav_url => $grav_url,
					},
				);
			}
			# show pending until, if set:
			if ( $Ticket{UntilTime} ) {
				my %Out;
				if ( $Ticket{UntilTime} < -1 ) {
				    $Out{PendingUntilClass} = 'Warning';
				}
				
				$Out{UntilTimeHuman} = $TimeObject->SystemTime2TimeStamp(
				    SystemTime => ( $Ticket{UntilTime} + $TimeObject->SystemTime() ),
				);
				$Out{PendingUntil} .=$Kernel::OM->Get('Kernel::Output::HTML::Layout')->CustomerAge(
				    Age   => $Ticket{UntilTime},
				    Space => ' '
				);
				$Kernel::OM->Get('Kernel::Output::HTML::Layout')->Block(
					Name => 'pending',
					Data => \%Out,
				);

			}
			
			# Show Priority change buttons
			# @TODO not shure if this is the correct way to do this
			my %Priorities =$Kernel::OM->Get('Kernel::System::Priority')->PriorityList(
				Valid=>1,
			);
			my @priovals = sort values %Priorities;
			my( $index )= grep { $priovals[$_] eq $Ticket{Priority} } 0..$#priovals;
			if($Ticket{Priority} ne $priovals[-1]){
				$Kernel::OM->Get('Kernel::Output::HTML::Layout')->Block(
					Name => 'priorityUp',
					Data => {
						NextPriority => $priovals[$index+1],
						QueueID => $Self->{QueueID},
						TicketID=> $TicketID,
					},
				);
			}
			if($Ticket{Priority} ne $priovals[0]){
				$Kernel::OM->Get('Kernel::Output::HTML::Layout')->Block(
					Name => 'priorityDown',
					Data => {
						NextPriority => $priovals[$index-1],
						QueueID => $Self->{QueueID},
						TicketID=> $TicketID,

					},
				);
			}
		}
	}

    # COMPLEMENTO: TRANSLATE VALUES AND ADD THE COUNT AT THE END. FOR EXAMPLE: Pending (5)

     for my $Filter(keys %{$Self->{CompFilters}}){
        if($Self->{CompFilters}->{$Filter}->{FilterKey}||'' ne 'Queues'){
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
                } elsif($Self->{CompFilters}->{$Filter}->{Type} eq 'Responsible'){
                    #COMPLEMENTO: GET AGENT's NAME
                    my $Username='';
                    # If not allocated (Admin OTRS), translate it
                    $Username=
                        $Value==1?
                        '- '.$LayoutObject->{LanguageObject}->Translate('Without Responsible').' -':
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
                        $Counters{$Filter}->{$Value}=$LayoutObject->{LanguageObject}->Translate( $Value )." ($Counters{$Filter}->{$Value})";
                    }

                 }
            }
        }

     }

     $CountTotal = scalar(@ViewableTickets)||0;

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

    # get page footer and return
    if ( $Self->{Subaction} ne 'AJAXFilterUpdate') {
		my %NavBar = $Self->BuildQueueView( Filter => $Self->{Filter}, 
        EscalationFilters => \%EscalationFilters,
        ComplementoFilter => \%ComplementoFilter,
        Counters => \%Counters, );

        
		$Kernel::OM->Get('Kernel::Output::HTML::Layout')->Print(
			Output => \$Kernel::OM->Get('Kernel::Output::HTML::Layout')->Output(
							TemplateFile => 'AgentTicketQueueKanban',
							Data         => {
								%Param,
								%NavBar,
							},
						)

		);
       $Kernel::OM->Get('Kernel::Output::HTML::Layout')->Footer();

    } else {
        return$Kernel::OM->Get('Kernel::Output::HTML::Layout')->Attachment(
            ContentType => 'text/html; charset=' .$Kernel::OM->Get('Kernel::Output::HTML::Layout')->{Charset},
            Content     => $Output,
            Type        => 'inline',
            NoCache     => 1,
        );
    }
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
    $Kernel::OM->Get('Kernel::Output::HTML::Layout')->Block(
        Name => 'kanban_filters',
        Data => {
            Baselink => $LayoutObject->{Baselink},
            View => $Self->{View},
            Filter => $Self->{Filter},
            SortBy => $Self->{SortBy},
            OrderBy => $Self->{OrderBy},
            SessionID => $Self->{SessionID},
            SessionName => $LayoutObject->{SessionName}
        },
    );

    # Complemento Filters
    for my $Filter(sort keys %{$Self->{CompFilters}}){
        my $label=$Self->{CompFilters}->{$Filter}->{Label}||$Self->{CompFilters}->{$Filter}->{TicketKey};
        $label=$LayoutObject->{LanguageObject}->Translate($label);
        my $jsMultiple='';
         my $onChange='';
        my $possibleNone=0;
        my $applyText='Apply';

         if(!$Self->{CompFilters}->{$Filter}->{Multiple}){
            $jsMultiple   ="multiple: false,";        
            $onChange     ="\$('#kanban_filters').submit();";
            $possibleNone ="1";
            $applyText    ="select one bellow to apply";
        };

        if($Self->{CompFilters}->{$Filter}->{Type} eq 'TicketAttribute' ||
        $Self->{CompFilters}->{$Filter}->{Type} eq 'Agent' ||
           $Self->{CompFilters}->{$Filter}->{Type} eq 'Responsible' ||
           $Self->{CompFilters}->{$Filter}->{Type} eq 'Lock' ||
           $Self->{CompFilters}->{$Filter}->{Type} eq 'CustomerCompany' ||
           $Self->{CompFilters}->{$Filter}->{Type} eq 'DynamicField'
           ){
            my $FilterComp = $LayoutObject->BuildSelection(
                Data => \%{$Param{Counters}->{   $Filter       }},
                Multiple => $Self->{CompFilters}->{$Filter}->{Multiple},
                #Size => 4,
                Max => 200,
                Name => $Filter,
                ID   => $Filter,
                PossibleNone => $possibleNone,
                SelectedID => $Self->{$Filter},
                Class   => 'Modernize',
                OnChange      => "Kanboard.Board.Filter();",
            );

            $Kernel::OM->Get('Kernel::Output::HTML::Layout')->Block(
                Name => 'kanban_filter',
                Data => {
                    Filter => $FilterComp,
                    FilterLabel => $label
                },
            );

        } elsif ($Self->{CompFilters}->{$Filter}->{Type} eq 'Escalation'){
            my %Escalations;

            $Escalations{1} = $LayoutObject->{LanguageObject}->Translate('Escalated Tickets')||"".' ('.$Param{EscalationFilters}->{1}->{Count}||"".')';
            $Escalations{2} = $LayoutObject->{LanguageObject}->Translate('Today')||"".' ('.$Param{EscalationFilters}->{2}->{Count}||"".')';
            $Escalations{3} = $LayoutObject->{LanguageObject}->Translate('Tomorrow')||"".' ('.$Param{EscalationFilters}->{3}->{Count}||"".')';
            $Escalations{4} = $LayoutObject->{LanguageObject}->Translate('Next Week')||"".' ('.$Param{EscalationFilters}->{4}->{Count}||"".')';

             $Escalations{5} = $LayoutObject->{LanguageObject}->Translate('Solution Expired')||"".' ('.$Param{EscalationFilters}->{5}->{Count}||"".')';
            $Escalations{6} = $LayoutObject->{LanguageObject}->Translate('Solution Expires Today')||"".' ('.$Param{EscalationFilters}->{6}->{Count}||"".')';
            $Escalations{7} = $LayoutObject->{LanguageObject}->Translate('Solution Expires Tomorrow')||"".' ('.$Param{EscalationFilters}->{7}->{Count}||"".')';
            $Escalations{8} = $LayoutObject->{LanguageObject}->Translate('Solution Expires Next Week')||"".' ('.$Param{EscalationFilters}->{8}->{Count}||"".')';

             $Escalations{9} = $LayoutObject->{LanguageObject}->Translate('First Response Expired')||"".' ('.$Param{EscalationFilters}->{9}->{Count}||"".')';
            $Escalations{10} = $LayoutObject->{LanguageObject}->Translate('First Response Expires Today')||"".' ('.$Param{EscalationFilters}->{10}->{Count}||"".')';
            $Escalations{11} = $LayoutObject->{LanguageObject}->Translate('First Response Expires Tomorrow')||"".' ('.$Param{EscalationFilters}->{11}->{Count}||"".')';
            $Escalations{12} = $LayoutObject->{LanguageObject}->Translate('First Response Expires Next Week')||"".' ('.$Param{EscalationFilters}->{12}->{Count}||"".')';

             $Escalations{13} = $LayoutObject->{LanguageObject}->Translate('Follow Up Expired')||"".' ('.$Param{EscalationFilters}->{13}->{Count}||"".')';
            $Escalations{14} = $LayoutObject->{LanguageObject}->Translate('Follow Up Expires Today')||"".' ('.$Param{EscalationFilters}->{14}->{Count}||"".')';
            $Escalations{15} = $LayoutObject->{LanguageObject}->Translate('Follow Up Expires Tomorrow')||"".' ('.$Param{EscalationFilters}->{15}->{Count}||"".')';
            $Escalations{16} = $LayoutObject->{LanguageObject}->Translate('Follow Up Expires Next Week')||"".' ('.$Param{EscalationFilters}->{16}->{Count}||"".')';

             my $FilterComp = $LayoutObject->BuildSelection(
                Data => \%Escalations,
                Name => $Filter,
                ID   => $Filter,
                PossibleNone => $possibleNone,
                #Size     => 4,
                Max => 200,
                SelectedID => $Self->{$Filter},
                OnChange      => "Kanboard.Board.Filter();",
                Sort => 'NumericKey',
                Class   => 'Modernize',
            );

            $Kernel::OM->Get('Kernel::Output::HTML::Layout')->Block(
                Name => 'kanban_filter',
                Data => {
                    Filter => $FilterComp,
                    FilterLabel => $label
                },
            );
    
        }
    }

    return (
        MainName      => 'Queues',
        Total         => $Param{TicketsShown},
    );
}

1;
