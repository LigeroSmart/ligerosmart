# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::CustomerReports;

use strict;
use warnings;
use POSIX;

use Kernel::System::VariableCheck qw(:all);
use Kernel::Language qw(Translatable);

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;
	
	my $ParamObject  = $Kernel::OM->Get('Kernel::System::Web::Request');
	my $CustomerID = $ParamObject->GetParam( Param => 'UserCustomerID' ) ||  $Param{UserCustomerID}; 	
	$Param{UserCustomerID} = $CustomerID;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $ParamObject  = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $UserObject   = $Kernel::OM->Get('Kernel::System::CustomerUser');
	my $AccountedObject = $Kernel::OM->Get("Kernel::System::AccountedTime");	
    my $Output = $LayoutObject->CustomerHeader( Title => Translatable('Reports') );
	$Output .= $LayoutObject->CustomerNavigationBar();
    # get param
    my $Message  = $ParamObject->GetParam( Param => 'Message' )  || '';
    my $Priority = $ParamObject->GetParam( Param => 'Priority' ) || '';

    # add notification
    if ( $Message && $Priority eq 'Error' ) {
    	$Output .= $LayoutObject->Notify(
        	Priority => $Priority,
            Info     => $Message,
        );
    }
    elsif ($Message) {
 	   $Output .= $LayoutObject->Notify(
    	   Priority => 'Success',
           Info     => $Message,
       );
   }

   # get user data
   my %UserData = $UserObject->CustomerUserDataGet( User => $Self->{UserLogin} );
   $Output .= $Self->CustomerReports( UserData => \%UserData );
   $Output .= $LayoutObject->CustomerFooter();
   return $Output;
}

sub CustomerReports {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $ParamObject  = $Kernel::OM->Get('Kernel::System::Web::Request');
    $Param{UserCustomerID} = $Self->{UserCustomerID};    

	my $AccountedObject = $Kernel::OM->Get("Kernel::System::AccountedTime");	
    # Filter settings
    my $SortBy         = $ParamObject->GetParam( Param => 'SortBy' )  || 'Age';
    my $OrderByCurrent = $ParamObject->GetParam( Param => 'OrderBy' ) || 'Down';

    # filter definition
    my %Filters = (
        MyTickets => {
            All => {
                Name   => 'All',
                Prio   => 1000,
                Search => {
                    CustomerUserLoginRaw => $Self->{UserID},
                    OrderBy              => $OrderByCurrent,
                    SortBy               => $SortBy,
                    CustomerUserID       => $Self->{UserID},
                    Permission           => 'ro',
                },
            },

        },
    );
    
    $LayoutObject->Block(
        Name => 'Body',
        Data => \%Param,
    );
    #Quantidade Meses a serem exibidos
    my $QtdeMonth = $Kernel::OM->Get('Kernel::Config')->Get('Ticket::Complemento::AccountedTime::QtdeMonth') || 2;
    #Mês será utilizado de 0 a N.
    $QtdeMonth = ($QtdeMonth - 1);
	#Busca no sysconfig ID dos campos Dynamicos utilizados
    my $Ini = $Kernel::OM->Get('Kernel::Config')->Get('Ticket::Complemento::AccountedTime::DynamicFieldStartID');
    my $End = $Kernel::OM->Get('Kernel::Config')->Get('Ticket::Complemento::AccountedTime::DynamicFieldEndID');
	#Busca o nome dos campos dynamicos
    my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');
    my $DynamicField = $DynamicFieldObject->DynamicFieldGet(
    	ID   => $Ini,             # ID or Name must be provided
    );

    my $IniName = $DynamicField->{Name};
    $DynamicField = $DynamicFieldObject->DynamicFieldGet(
    	ID   => $End,             # ID or Name must be provided
    );
    my $EndName = $DynamicField->{Name};
    my $Out_d = 0;
    my $Text_out = 0;
    my $Out_d_t = 0;
    my $Text_out_t = 0;
    my $Total = 0;	
    my $Text_c = 0;

    my $UserObject   = $Kernel::OM->Get('Kernel::System::CustomerUser');
    my %CustomerIDsTemp = $UserObject->CustomerIDs( User => $Self->{UserLogin} );
    my %CustomerIDs;
#    $CustomerIDs{'0'}="All";
    for my $Key ( sort %CustomerIDsTemp ) {
   		$CustomerIDs{$Key}=$Key;
    }

    my %CustomerIDSelected;
    
    if ( $Self->{CustomerID} ) {
        $CustomerIDSelected{SelectedID} = $Self->{UserCustomerID};
    }
    else {
        $CustomerIDSelected{SelectedID} = '0';
    }
    $Param{CustomerIDsStrg} = $LayoutObject->BuildSelection(
        Data => \%CustomerIDs,
        Name => 'UserCustomerID',
        Sort => 'AlphanumericKey',
        %CustomerIDSelected,
        # KIX4OTRS-capeIT
        Translation => 1,
        # EO KIX4OTRS-capeIT
    );
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    $Param{"SelectorLabel"}=$ConfigObject->Get("MultiCustomerCompany::Selector::Label") || "Company";

	$LayoutObject->Block(
		Name => 'CustomerID',
        Data => \%Param,
    );

    $LayoutObject->Block(
          Name => 'Item',
          Data => {
			Label => "Visao de Horas",
			UserCustomerID => $Self->{UserCustomerID},
                },
            );
	my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

    my $CategoryString = "[";
    my $JSONString = "[{name: 'Tickets' ,";
    $JSONString   .= "data: [ ";

    my $JsonData ="";
    my $CategoryData ="";
	my $JsonsData = "";
	my $CategorysData = "";

	my $Categorys = "[";

	$LayoutObject->Block(
		Name => 'Input',
		Data => {
					
		},
	);	

    # Month Name
    my @Months = qw(January February  March April May June  July August September October November December);
    my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);

    my $count= 0;
    my $YearBlock=0;

    my $TimeObject = $Kernel::OM->Get("Kernel::System::Time");
    my $Prio = 1200;

    my %HashTicketTypes = $AccountedObject->GetAccountedTimeQuotasPerMonth(CustomerID => $Self->{UserCustomerID});

    # Para cada mes
    while ($count<= $QtdeMonth) {
        my @t = localtime(time);
        # obtem mes anterior e cria nova data
        $t[4] -= $count;  # $t[4] is tm_moni
		# Verificar este BUG volta a ocorrer: problemas com dias 28 29 30 31
		#$t[3] =  -1;
        my $newmonth = mktime(@t);
        # armazena a nova data
        my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime($newmonth);
       	 
        my $Year=$year+1900;
        my $Month=$mon+1;
        # Nome do mes
        my $MonthName = $Months[$mon];
        # separa ano
        if($YearBlock != $year){
		    $LayoutObject->Block(
			    Name => 'YearRow',
			    Data => {
				    Year 	=> $Year,
			    },
		    );
		    $YearBlock=$year;
        }
        # Obtem tempo consumido no ano
        my $TotalMinutes= $AccountedObject->getMonthUsedTime(Ini=> $Ini, End=>$End, CustomerID => $Self->{UserCustomerID}, Year=>$Year, Month=>$Month )||0;
        my $Text_c  = sprintf("%dh %dm", $TotalMinutes/60, $TotalMinutes%60);
		$LayoutObject->Block(
			Name => 'Row',
			Data => {
				Month 	=> $MonthName,
				Value 	=> $Text_c,
			},
		);
		
		
		############################# MONTA FILTRO DO MÊS ##############################
		#Create Search Data
		if(length $Month eq 1){
            $Month = "0".$Month;
    	    $Month = "01" if ($Month eq 0);
        }

		my $TicketCreateTimeNewerDate = $Year."-".$Month."-01 00:00:00";
	    
        my $SystemTime = $TimeObject->TimeStamp2SystemTime(
            String => "$Year-$Month-01 00:00:00",
        );
        @t = localtime($SystemTime);
        $t[4] ++;  # $t[4] is tm_mon
    	$t[3] ++; # Evita Problemas com 29 28 etc
        $newmonth = mktime(@t);
        ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime($newmonth);

	    my $NextYear = $year+1900;
	    my $NextMonth = $mon+1;
	    if(length $NextMonth eq 1){
                $NextMonth = "0".$NextMonth;
                $NextMonth = "01" if ($NextMonth eq 0);
        }
	    my $TicketCreateTimeOlderDate = $NextYear."-".$NextMonth."-01 00:00:00";
	    $Filters{MyTickets}{"$MonthName-$Year"} = {
    	  	Name   => "$MonthName",
           	Year   => substr("$Year",2),
            Prio   => $Prio,
            Search => {
	    		"DynamicField_$IniName" => {
		        	GreaterThanEquals => $TicketCreateTimeNewerDate,

        		},
				"DynamicField_$EndName" => {
					SmallerThanEquals => $TicketCreateTimeOlderDate,
				},

                CustomerUserLoginRaw => $Self->{UserID},
#                	TicketCreateTimeNewerDate => $TicketCreateTimeNewerDate,
#               TicketCreateTimeOlderDate => $TicketCreateTimeOlderDate,
                OrderBy              => $OrderByCurrent,
                SortBy               => $SortBy,
                CustomerUserID       => $Self->{UserID},
                Permission           => 'ro',
            },
	
                
	    };
	    $Prio = ($Prio+100);

        ################### monta json do Highcharts

        my $Serie;
		my $Category;
		my $NameTranslate = $LayoutObject->{LanguageObject}->Translate($MonthName);
		$NameTranslate = $NameTranslate.  "-" .substr($Year,2);
		$Category .= " \"$NameTranslate\"  , " ;
	
		$TotalMinutes =  sprintf("%d.%d", $TotalMinutes/60, $TotalMinutes%60);
#sprintf("%dh %dm", $TotalMinutes/60, $TotalMinutes%60);
        $Serie .= $TotalMinutes .",";
       
        $JsonData = $Serie . $JsonData;
		$CategoryData = $Category . $CategoryData;

		$JsonsData = $Serie . $JsonData;
		$CategorysData = $Category . $CategorysData;

        $count++;
    }
    
    $JSONString.= $JsonData;
    $CategoryString .= $CategoryData;

	$Categorys .= $CategorysData;

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



    # disable output of customer company tickets
    my $DisableCompanyTickets = $ConfigObject->Get('Ticket::Frontend::CustomerDisableCompanyTicketAccess');

    # check subaction
    if ( !$Self->{Subaction} ) {
        return $LayoutObject->Redirect(
            OP => 'Action=CustomerReports;Subaction=MyTickets',
        );
    }

    # check needed CustomerID
    if ( !$Self->{UserCustomerID} ) {
        my $Output = $LayoutObject->CustomerHeader( Title => 'Error' );
        $Output .= $LayoutObject->CustomerError( Message => 'Need CustomerID!!!' );
        $Output .= $LayoutObject->CustomerFooter();
        return $Output;
    }
    $Kernel::OM->Get('Kernel::System::AuthSession')->UpdateSessionID(
        SessionID => $Self->{SessionID},
        Key       => 'LastScreenOverview',
        Value     => $Self->{RequestedURL},
    );
	
    my $FilterCurrent = $ParamObject->GetParam( Param => 'Filter' ) || 'All';

    # check if filter is valid
    if ( !$Filters{ $Self->{Subaction} }->{$FilterCurrent} ) {
        my $Output = $LayoutObject->CustomerHeader( Title => 'Error' );
        $Output .= $LayoutObject->CustomerError(
            Message => "Invalid Filter: $FilterCurrent!",
        );
        $Output .= $LayoutObject->CustomerFooter();
        return $Output;
    }

    # check if archive search is allowed, otherwise search for all tickets
    my %SearchInArchive;
    if (
        $ConfigObject->Get('Ticket::ArchiveSystem')
        && !$ConfigObject->Get('Ticket::CustomerArchiveSystem')
        )
    {
        $SearchInArchive{ArchiveFlags} = [ 'y', 'n' ];
    }

    my %NavBarFilter;
    my $Counter         = 0;
    my $AllTickets      = 0;
    my $AllTicketsTotal = 0;
    $TicketObject    = $Kernel::OM->Get('Kernel::System::Ticket');

    for my $Filter ( sort keys %{ $Filters{ $Self->{Subaction} } } ) {
        $Counter++;

        my $Count = $TicketObject->TicketSearch(
            %{ $Filters{ $Self->{Subaction} }->{$Filter}->{Search} },
            %SearchInArchive,
            Result => 'COUNT',
        );

        my $ClassA = '';
        if ( $Filter eq $FilterCurrent ) {
            $ClassA     = 'Selected';
            $AllTickets = $Count;
        }
        if ( $Filter eq 'All' ) {
            $AllTicketsTotal = $Count;
        }
        $NavBarFilter{ $Filters{ $Self->{Subaction} }->{$Filter}->{Prio} } = {
            %{ $Filters{ $Self->{Subaction} }->{$Filter} },
            Count  => $Count,
            Filter => $Filter,
            ClassA => $ClassA,
        };
    }
    my $StartHit = int( $ParamObject->GetParam( Param => 'StartHit' ) || 1 );
    my $PageShown = $Self->{UserShowTickets} || 1;

    if ( !$AllTicketsTotal ) {
        $LayoutObject->Block(
            Name => 'Empty',
        );

        my $CustomTexts = $ConfigObject->Get('Ticket::Frontend::CustomerTicketOverviewCustomEmptyText');

        if ( ref $CustomTexts eq 'HASH' ) {
            $LayoutObject->Block(
                Name => 'EmptyCustom',
                Data => $CustomTexts,
            );

            # only show button, if frontend module for NewTicket is registered
            # and button text is configured
            if (
                ref $ConfigObject->Get('CustomerFrontend::Module')->{CustomerTicketMessage}
                eq 'HASH'
                && defined $ConfigObject->Get('Ticket::Frontend::CustomerTicketOverviewCustomEmptyText')
                ->{Button}
                )
            {
                $LayoutObject->Block(
                    Name => 'EmptyCustomButton',
                    Data => $CustomTexts,
                );
            }
        }
        else {
            $LayoutObject->Block(
                Name => 'EmptyDefault',
            );

            # only show button, if frontend module for NewTicket is registered
            if (
                ref $ConfigObject->Get('CustomerFrontend::Module')->{CustomerTicketMessage}
                eq 'HASH'
                )
            {
                $LayoutObject->Block(
                    Name => 'EmptyDefaultButton',
                );
            }
        }
    }
    else {

        # create & return output
        my $Link = 'SortBy=' . $LayoutObject->Ascii2Html( Text => $SortBy )
            . ';OrderBy=' . $LayoutObject->Ascii2Html( Text => $OrderByCurrent )
            . ';Filter=' . $LayoutObject->Ascii2Html( Text => $FilterCurrent )
            . ';Subaction=' . $LayoutObject->Ascii2Html( Text => $Self->{Subaction} )
            . ';';
        my %PageNav = $LayoutObject->PageNavBar(
            Limit     => 10000,
            StartHit  => $StartHit,
            PageShown => $PageShown,
            AllHits   => $AllTickets,
            Action    => 'Action=CustomerReports',
            Link      => $Link,
            IDPrefix  => 'CustomerReports',
        );

        my $OrderBy = 'Down';
        if ( $OrderByCurrent eq 'Down' ) {
            $OrderBy = 'Up';
        }
        my $Sort       = '';
        my $StateSort  = '';
        my $TicketSort = '';
        my $TitleSort  = '';
        my $AgeSort    = '';
        my $QueueSort  = '';
        my $OwnerSort  = '';

        # this sets the opposite to the $OrderBy
        if ( $OrderBy eq 'Down' ) {
            $Sort = 'SortAscending';
        }
        if ( $OrderBy eq 'Up' ) {
            $Sort = 'SortDescending';
        }

        if ( $SortBy eq 'State' ) {
            $StateSort = $Sort;
        }
        elsif ( $SortBy eq 'Ticket' ) {
            $TicketSort = $Sort;
        }
        elsif ( $SortBy eq 'Title' ) {
            $TitleSort = $Sort;
        }
        elsif ( $SortBy eq 'Age' ) {
            $AgeSort = $Sort;
        }
        elsif ( $SortBy eq 'Queue' ) {
            $QueueSort = $Sort;
        }
        elsif ( $SortBy eq 'Owner' ) {
            $OwnerSort = $Sort;
        }
        $LayoutObject->Block(
            Name => 'Filled',
            Data => {
                %Param,
                %PageNav,
                OrderBy    => $OrderBy,
                StateSort  => $StateSort,
                TicketSort => $TicketSort,
                TitleSort  => $TitleSort,
                AgeSort    => $AgeSort,
                Filter     => $FilterCurrent,
            },
        );

        my $Owner = $ConfigObject->Get('Ticket::Frontend::CustomerTicketOverview')->{Owner};
        my $Queue = $ConfigObject->Get('Ticket::Frontend::CustomerTicketOverview')->{Queue};

        if ($Owner) {
            $LayoutObject->Block(
                Name => 'OverviewNavBarPageOwner',
                Data => {
                    OrderBy   => $OrderBy,
                    OwnerSort => $OwnerSort,
                    Filter    => $FilterCurrent,
                },
            );
        }

        if ($Queue) {
            $LayoutObject->Block(
                Name => 'OverviewNavBarPageQueue',
                Data => {
                    OrderBy   => $OrderBy,
                    QueueSort => $QueueSort,
                    Filter    => $FilterCurrent,
                },
            );
        }

        # show header filter
        for my $Key ( sort keys %NavBarFilter ) {
            $LayoutObject->Block(
                Name => 'FilterHeader',
                Data => {
                    %{ $NavBarFilter{$Key} },
                },
            );
        }

        # show footer filter - show only if more the one page is available
        if ( $AllTickets > $PageShown ) {
            $LayoutObject->Block(
                Name => 'FilterFooter',
                Data => {
                    %Param,
                    %PageNav,
                },
            );
        }
        for my $Key ( sort keys %NavBarFilter ) {
            if ( $AllTickets > $PageShown ) {
                $LayoutObject->Block(
                    Name => 'FilterFooterItem',
                    Data => {
                        %{ $NavBarFilter{$Key} },
                    },
                );
            }
        }
     # get the dynamic fields for this screen
        my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');
        my $BackendObject      = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

        # get dynamic field config for frontend module
        my $DynamicFieldFilter = $ConfigObject->Get("Ticket::Frontend::CustomerTicketOverview")->{DynamicField};
        my $DynamicField       = $DynamicFieldObject->DynamicFieldListGet(
            Valid       => 1,
            ObjectType  => ['Ticket'],
            FieldFilter => $DynamicFieldFilter || {},
        );

        # reduce the dynamic fields to only the ones that are desinged for customer interface
        my @CustomerDynamicFields;
        DYNAMICFIELD:
        for my $DynamicFieldConfig ( @{$DynamicField} ) {
            next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

            my $IsCustomerInterfaceCapable = $BackendObject->HasBehavior(
                DynamicFieldConfig => $DynamicFieldConfig,
                Behavior           => 'IsCustomerInterfaceCapable',
            );
            next DYNAMICFIELD if !$IsCustomerInterfaceCapable;

            push @CustomerDynamicFields, $DynamicFieldConfig;
        }
        $DynamicField = \@CustomerDynamicFields;

        # Dynamic fields
        # cycle trough the activated Dynamic Fields for this screen
        DYNAMICFIELD:
        for my $DynamicFieldConfig ( @{$DynamicField} ) {
            next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

            my $Label = $DynamicFieldConfig->{Label};

            # get field sortable condition
            my $IsSortable = $BackendObject->HasBehavior(
                DynamicFieldConfig => $DynamicFieldConfig,
                Behavior           => 'IsSortable',
            );

            if ($IsSortable) {
                my $CSS = '';
                if (
                    $SortBy
                    && ( $SortBy eq ( 'DynamicField_' . $DynamicFieldConfig->{Name} ) )
                    )
                {
                    if ( $OrderByCurrent && ( $OrderByCurrent eq 'Up' ) ) {
                        $OrderBy = 'Down';
                        $CSS .= ' SortDescending';
                    }
                    else {
                        $OrderBy = 'Up';
                        $CSS .= ' SortAscending';
                    }
                }

                $LayoutObject->Block(
                    Name => 'OverviewNavBarPageDynamicField',
                    Data => {
                        %Param,
                        CSS => $CSS,
                    },
                );

                $LayoutObject->Block(
                    Name => 'OverviewNavBarPageDynamicFieldSortable',
                    Data => {
                        %Param,
                        OrderBy          => $OrderBy,
                        Label            => $Label,
                        DynamicFieldName => $DynamicFieldConfig->{Name},
                        Filter           => $FilterCurrent,
                    },
                );

                # example of dynamic fields order customization
                $LayoutObject->Block(
                    Name => 'OverviewNavBarPageDynamicField_' . $DynamicFieldConfig->{Name},
                    Data => {
                        %Param,
                        CSS => $CSS,
                    },
                );

                $LayoutObject->Block(
                    Name => 'OverviewNavBarPageDynamicField_'
                        . $DynamicFieldConfig->{Name}
                        . '_Sortable',
                    Data => {
                        %Param,
                        OrderBy          => $OrderBy,
                        Label            => $Label,
                        DynamicFieldName => $DynamicFieldConfig->{Name},
                        Filter           => $FilterCurrent,
                    },
                );
            }
            else {

                $LayoutObject->Block(
                    Name => 'OverviewNavBarPageDynamicField',
                    Data => {
                        %Param,
                    },
                );

                $LayoutObject->Block(
                    Name => 'OverviewNavBarPageDynamicFieldNotSortable',
                    Data => {
                        %Param,
                        Label => $Label,
                    },
                );

                # example of dynamic fields order customization
                $LayoutObject->Block(
                    Name => 'OverviewNavBarPageDynamicField_' . $DynamicFieldConfig->{Name},
                    Data => {
                        %Param,
                    },
                );

                $LayoutObject->Block(
                    Name => 'OverviewNavBarPageDynamicField_'
                        . $DynamicFieldConfig->{Name}
                        . '_NotSortable',
                    Data => {
                        %Param,
                        Label => $Label,
                    },
                );
            }
        }
		my $GreaterThan = $Filters{ $Self->{Subaction} }->{$FilterCurrent}->{Search}{"DynamicField_$IniName"}->{GreaterThanEquals};
		my $SmallerThan = $Filters{ $Self->{Subaction} }->{$FilterCurrent}->{Search}{"DynamicField_$EndName"}->{SmallerThanEquals};
        my @ViewableTickets = $TicketObject->TicketSearch(
            %{ $Filters{ $Self->{Subaction} }->{$FilterCurrent}->{Search} },
            %SearchInArchive,
            Result => 'ARRAY',
        );

        # show tickets
        $Counter = 0;
        for my $TicketID (@ViewableTickets) {
            $Counter++;
            if (
                $Counter >= $StartHit
                && $Counter < ( $PageShown + $StartHit )
                )
            {
                $Self->ShowTicketStatus( TicketID => $TicketID,
										 Smaller  => $SmallerThan,  
										 Greater  => $GreaterThan,
										);
            }
        }
    }

    # create & return output
    my $Refresh = '';
    if ( $Self->{UserRefreshTime} ) {
        $Refresh = 60 * $Self->{UserRefreshTime};
    }
    my $Output; 

    chop($JSONString);
    chop($CategoryString);

    $JSONString .= "]}] ";
    $CategoryString .= "]";

	
	

	my $JSONType = "[";
	foreach my $keys (keys %HashTicketTypes) {
		my $Values =  join(",", @{$HashTicketTypes{$keys}});
		$JSONType .= "{ name : \" ".$LayoutObject->{LanguageObject}->Translate($keys)." \" , data:[" . $Values ."] }, ";
	}


	chop($Categorys);
	chop($JSONType);

    $Categorys .= "]";
	#$JSONTicketType .= "] ";
	$JSONType .= "] ";


    # get page footer
    $LayoutObject->Block(
        Name => 'TicketTypeSerie',
	         Data => {
            	 Serie => $JSONType,
				 Category => $Categorys,
             },
	); 
	#GET TITLE FOR GRAPH
	$Param{GraphTitle} = $ConfigObject->Get('Ticket::Complemento::AccountedTime::GraphTitle');

    # create & return output
    $Output .= $LayoutObject->Output(
        TemplateFile => 'CustomerReports',
        Data         => \%Param,

    );
	return $Output;
}
sub ShowTicketStatus {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');
    my $TicketID     = $Param{TicketID} || return;
	my $Smaller 	 = $Param{Smaller} || '';
	my $Greater		 = $Param{Greater} || '';
	my $Ini = $Kernel::OM->Get('Kernel::Config')->Get('Ticket::Complemento::AccountedTime::DynamicFieldStartID');
    my $End = $Kernel::OM->Get('Kernel::Config')->Get('Ticket::Complemento::AccountedTime::DynamicFieldEndID');

    # contains last article (non-internal)
    my %Article;

    # get whole article index
    my @ArticleIDs = $TicketObject->ArticleIndex( TicketID => $Param{TicketID} );

    # get article data
    if (@ArticleIDs) {
        my %LastNonInternalArticle;

        ARTICLEID:
        for my $ArticleID ( reverse @ArticleIDs ) {
            my %CurrentArticle = $Kernel::OM->Get('Kernel::System::Ticket::Article')->BackendForArticle( ArticleID => $ArticleID, TicketID => $Param{TicketID} )->ArticleGet( 
                ArticleID     => $ArticleID,
                TicketID     => $Param{TicketID},
                DynamicFields => 1
            );

            # check for non-internal and non-chat article
            next ARTICLEID if $CurrentArticle{ArticleType} =~ m{internal|chat}smx;

            # check for customer article
            if ( $CurrentArticle{SenderType} eq 'customer' ) {
                %Article = %CurrentArticle;
                last ARTICLEID;
            }

            # check for last non-internal article (sender type does not matter)
            if ( !%LastNonInternalArticle ) {
                %LastNonInternalArticle = %CurrentArticle;
            }
        }

        if ( !%Article && %LastNonInternalArticle ) {
            %Article = %LastNonInternalArticle;
        }
    }

    my $NoArticle;
    if ( !%Article ) {
        $NoArticle = 1;
    }

    # get ticket info
    my %Ticket = $TicketObject->TicketGet(
        TicketID      => $TicketID,
        DynamicFields => 0,
    );

    my $Subject;
    my $ConfigObject          = $Kernel::OM->Get('Kernel::Config');
    my $SmallViewColumnHeader = $ConfigObject->Get('Ticket::Frontend::CustomerTicketOverview')->{ColumnHeader};

    # check if last customer subject or ticket title should be shown
    if ( $SmallViewColumnHeader eq 'LastCustomerSubject' ) {
        $Subject = $Article{Subject} || '';
    }
    elsif ( $SmallViewColumnHeader eq 'TicketTitle' ) {
        $Subject = $Ticket{Title};
    }

    # return ticket information if there is no article
    if ($NoArticle) {
        $Article{State}        = $Ticket{State};
        $Article{TicketNumber} = $Ticket{TicketNumber};
        $Article{CustomerAge}  = $LayoutObject->CustomerAge(
            Age   => $Ticket{Age},
            Space => ' '
        ) || 0;
        $Article{Body} = $LayoutObject->{LanguageObject}->Translate('This item has no articles yet.');
    }

    # otherwise return article information
    else {
        $Article{CustomerAge} = $LayoutObject->CustomerAge(
            Age   => $Article{Age},
            Space => ' '
        ) || 0;
    }

    # customer info (customer name)
    if ( $Article{CustomerUserID} ) {
        $Param{CustomerName} = $Kernel::OM->Get('Kernel::System::CustomerUser')->CustomerName(
            UserLogin => $Article{CustomerUserID},
        );
        $Param{CustomerName} = '(' . $Param{CustomerName} . ')' if ( $Param{CustomerName} );
    }

    # if there is no subject try with Ticket title or set to Untitled
    if ( !$Subject ) {
        $Subject = $Ticket{Title} || 'Untitled!';
    }

    # condense down the subject
    $Subject = $TicketObject->TicketSubjectClean(
        TicketNumber => $Article{TicketNumber},
        Subject      => $Subject,
    );
	my %HashTimeByTicket =   $Kernel::OM->Get("Kernel::System::AccountedTime")->getUsedTimeByTicket(
		CustomerID 		=> $Self->{UserCustomerID},
		TicketID	  	=> $Ticket{TicketID},
		Smaller			=> $Smaller,
		Greater			=> $Greater,

	);

    # add block
    $LayoutObject->Block(
        Name => 'Record',
        Data => {
            %Article,
            %Ticket,
            Subject => $Subject,
			TimesUsedByTicket => $HashTimeByTicket{Horas},
            %Param,
        },
    );

    my $Owner = $ConfigObject->Get('Ticket::Frontend::CustomerTicketOverview')->{Owner};
    my $Queue = $ConfigObject->Get('Ticket::Frontend::CustomerTicketOverview')->{Queue};

    if ($Owner) {
        my $OwnerName = $Kernel::OM->Get('Kernel::System::User')->UserName( UserID => $Ticket{OwnerID} );
        $LayoutObject->Block(
            Name => 'RecordOwner',
            Data => {
                OwnerName => $OwnerName,
            },
        );
    }
    if ($Queue) {
        $LayoutObject->Block(
            Name => 'RecordQueue',
            Data => {
                %Ticket,
            },
        );
    }

}
#sub getUsedTimeByTicket{
#	my ( $Self, %Param) = @_;
#	if(!$Param{Ini} or  !$Param{End} or !$Param{CustomerID} or !$Param{TicketID}){	
#	    $Kernel::OM->Get('Kernel::System::Log')->Log(
#            Priority => 'error',
#            Message  => 'Need Params!'
#        );
#        return;
#
#	}	
#	my $Smaller = $Param{Smaller};
#	my $Greater = $Param{Greater};
#	my $SQL = "";	
# 	my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
#
#    # get config data
#    $Self->{DSN}  = $ConfigObject->Get('DatabaseDSN');
#
#	if ( $Self->{DSN} =~ /:mysql/i ) {
#	
#     		$SQL = "select TIME_TO_SEC(TIMEDIFF(f.fim,i.inicio))/60 as Minutes, MONTHNAME(i.inicio) as month, i.field_id, i.object_id, i.inicio from"; 
#			$SQL .= " (SELECT field_id,object_id, value_date as inicio FROM dynamic_field_value as d  where field_id=? ";
#			$SQL .= " and value_date >= "."\' $Greater\'" if($Greater);
#			$SQL .= ") i";
#            $SQL .= " left join";
#            $SQL .= " (SELECT object_id, value_date as fim FROM dynamic_field_value as d where field_id=? ";
#			$SQL .= " and value_date  <= " ." \' $Smaller \' " if($Smaller);
#			$SQL .= ") f
#                on i.object_id=f.object_id
#                left join article a on i.object_id = a.id  LEFT JOIN ticket t ON   t.id = a.ticket_id   where t.customer_id = ? and a.ticket_id = ? ";
#
# 	}
#    elsif ( $Self->{DSN} =~ /:pg/i ) {
#		$SQL = "Select extract (epoch from (d.value_date))::integer/60 as Minutes, select to_char ( TIMESTAMP d.value_date) as month,field_id,object_id, d.value_date FROM  dynamic_field_value d LEFT JOIN article a  ON  d.object_id = a.id LEFT JOIN ticket t ON   t.id = a.ticket_id where d.field_id in (?,?) and t.customer_id = ? and t.id = ? ";
#
#	}
#	my %HashTime;
#	my $DBObject = $Kernel::OM->Get("Kernel::System::DB");
#	return if !$DBObject->Prepare(
#		SQL  => $SQL,
#		Bind => [ \$Param{Ini}, \$Param{End}, \$Param{CustomerID},  \$Param{TicketID} ],
#	);
#	my $Total = 0;
#	while ( my @Row = $DBObject->FetchrowArray() ) {
#
##		if($Param{Ini} eq $Row[2]){
##			$HashTime{Horas} -= $Row[0]; 		
##		}else{
#	
#			$HashTime{Horas} += $Row[0];
##
##		}
#	}
#	if(defined($HashTime{Horas})){
#		$HashTime{Horas}  = sprintf("%dh %dm", $HashTime{Horas}/60, $HashTime{Horas}%60);
#	}else{
#		$HashTime{Horas} = 0;
#	}
#
#			return %HashTime;
#
#}

#sub getUsedTime{
#	#Return In Minutes
#	my ( $Self, %Param) = @_;
#	if(!$Param{Ini} or  !$Param{End} or !$Param{CustomerID}){	
#		$Kernel::OM->Get('Kernel::System::Log')->Log(
#			Priority => 'error',
#			Message  => 'Need Params!'
#		);
#		return;
#
#	}	
#	my $SQL = "";	
#	my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
#
#	# get config data
#	$Self->{DSN}  = $ConfigObject->Get('DatabaseDSN');
#	if ( $Self->{DSN} =~ /:mysql/i ) {
#
#		$SQL = "SELECT (TIME_TO_SEC(d.value_date))/60 as Minutes, MONTHNAME(d.value_date) as month,field_id,object_id, d.value_date FROM  dynamic_field_value d LEFT JOIN article a  ON  d.object_id = a.id LEFT JOIN ticket t ON   t.id = a.ticket_id where d.field_id in (?,?) and t.customer_id = ? ";			
#	}elsif ( $Self->{DSN} =~ /:pg/i ) {
#		$SQL = "Select extract (epoch from (d.value_date))::integer/60 as Minutes, select to_char ( TIMESTAMP d.value_date) as month,field_id,object_id, d.value_date FROM  dynamic_field_value d LEFT JOIN article a  ON  d.object_id = a.id LEFT JOIN ticket t ON   t.id = a.ticket_id where d.field_id in (?,?) and t.customer_id = ? ";			
#
#	}
#	#my $SQL = "SELECT (TIME_TO_SEC(d.value_date))/60 as Minutes, MONTHNAME(d.value_date) as month,field_id,object_id, d.value_date FROM  dynamic_field_value d LEFT JOIN article a  ON  d.object_id = a.id LEFT JOIN ticket t ON   t.id = a.ticket_id where d.field_id in (?,?) and t.customer_id = ? ";			
#	my %HashTime =(
#				January 	=> 0,
#				February	=> 0,
#				March		=> 0,
#				April		=> 0,
#				May   		=> 0,
#				June 		=> 0,
#				July		=> 0,
#				August          => 0,
#				Setember 	=> 0,
#				October		=> 0,
#				November 	=> 0,
#				December	=> 0, 
#	);
#	my $DBObject = $Kernel::OM->Get("Kernel::System::DB");
#	return if !$DBObject->Prepare(
#		SQL  => $SQL,
#		Bind => [ \$Param{Ini}, \$Param{End}, \$Param{CustomerID}  ],
#	);
#	while ( my @Row = $DBObject->FetchrowArray() ) {
#		if($Param{Ini} eq $Row[2]){
#			$HashTime{$Row[1]} -= $Row[0]; 		
#		}else{
#			$HashTime{$Row[1]} += $Row[0];
#		}
#	}
#
#	return %HashTime;
#}
#

#sub getMonthUsedTime{
#    my $TimeObject = $Kernel::OM->Get('Kernel::System::Time');
#
#	#Return In Minutes
#	my ( $Self, %Param) = @_;
#	if(!$Param{Ini} or  !$Param{End} or !$Param{CustomerID} or !$Param{Month} or !$Param{Year}){
#	    $Kernel::OM->Get('Kernel::System::Log')->Log(
#            Priority => 'error',
#            Message  => 'Need Params!'
#        );
#        return;
#	}
#	
#	my $Year = $Param{Year};
#	my $Month = $Param{Month};
#
#    my $SystemTime = $TimeObject->TimeStamp2SystemTime(
#        String => "$Year-$Month-01 00:00:00",
#    );
#    my @t = localtime($SystemTime);
#    $t[4] ++;  # $t[4] is tm_mon
#    $t[3] ++;
#    my $newmonth = mktime(@t);
#    my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime($newmonth);
#
#	my $NextYear = $year+1900;
#	my $NextMonth = $mon+1;
#	
#	#my $SQL = "SELECT (TIME_TO_SEC(d.value_date))/60 as Minutes, MONTHNAME(d.value_date) as month,field_id,object_id, d.value_date FROM  dynamic_field_value d LEFT JOIN article a  ON  d.object_id = a.id LEFT JOIN ticket t ON   t.id = a.ticket_id where d.field_id in (?,?) and t.customer_id = ?  and d.value_date between '$Year-$Month-01 00:00:00' and '$NextYear-$NextMonth-01 00:00:00'";
#	my $SQL = "";	
# 	my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
#
#    # get config data
#    $Self->{DSN}  = $ConfigObject->Get('DatabaseDSN');
#	if ( $Self->{DSN} =~ /:mysql/i ) {
##		$SQL = "SELECT (TIME_TO_SEC(d.value_date))/60 as Minutes, MONTHNAME(d.value_date) as month,field_id,object_id, d.value_date FROM  dynamic_field_value d LEFT JOIN article a  ON  d.object_id = a.id LEFT JOIN ticket t ON   t.id = a.ticket_id where d.field_id in (?,?) and t.customer_id = ?  and d.value_date between '$Year-$Month-01 00:00:00' and '$NextYear-$NextMonth-01 00:00:00'";
#	$SQL = " select TIME_TO_SEC(TIMEDIFF(f.fim,i.inicio))/60 as time_unit from 
#                (SELECT object_id, value_date as inicio FROM dynamic_field_value as d  where field_id=? and d.value_date between '$Year-$Month-01 00:00:00' and '$NextYear-$NextMonth-01 00:00:00') i
#                left join
#                (SELECT object_id, value_date as fim FROM dynamic_field_value as d where field_id=?  and d.value_date between '$Year-$Month-01 00:00:00' and '$NextYear-$NextMonth-01 00:00:00') f
#                on i.object_id=f.object_id
#                left join article a on i.object_id = a.id LEFT JOIN ticket t ON   t.id = a.ticket_id   where t.customer_id = ? ";
#	}elsif ( $Self->{DSN} =~ /:pg/i ) {
#		$SQL = "Select extract (epoch from (d.value_date))::integer/60 as Minutes, select to_char ( TIMESTAMP d.value_date) as month,field_id,object_id, d.value_date FROM  dynamic_field_value d LEFT JOIN article a  ON  d.object_id = a.id LEFT JOIN ticket t ON   t.id = a.ticket_id where d.field_id in (?,?) and t.customer_id = ?  and d.value_date between '$Year-$Month-01 00:00:00' and '$NextYear-$NextMonth-01 00:00:00'";
#	}
#	my $DBObject = $Kernel::OM->Get("Kernel::System::DB");
#	return if !$DBObject->Prepare(
#		SQL  => $SQL,
#		Bind => [ \$Param{Ini}, \$Param{End}, \$Param{CustomerID}],
#	);
#	my $Time=0;
#	while ( my @Row = $DBObject->FetchrowArray() ) {
#	        $Row[0] =~ s/,/./g;
#	        $Time += $Row[0];
##		if($Param{Ini} eq $Row[2]){
##			$Time -= $Row[0];
##		}else{
##			$Time += $Row[0];
##		}
#
#	}
#	return $Time;
#}
#

1;
