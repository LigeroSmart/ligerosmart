# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentLigeroFixTickets;

use strict;
use warnings;
use Encode qw();

use Data::Dumper;

use Kernel::System::VariableCheck qw(:all);
use JSON;
use utf8;
use vars qw($VERSION);
use JSON::XS;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
	my ( $Self, %Param ) = @_;

	my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');
  my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
  my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
  my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');
  my $TranslateObject = $Kernel::OM->Get('Kernel::Language');
  my $JSONObject = $Kernel::OM->Get('Kernel::System::JSON');
  my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');
  my $LinkObject = $Kernel::OM->Get('Kernel::System::LinkObject');

  $Param{TicketID} = $ParamObject->GetParam(Param => "TicketID") || "";

  my %Ticket = $TicketObject->TicketGet(
      TicketID      => $Param{TicketID},
      DynamicFields => 0,         # Optional, default 0. To include the dynamic field values for this ticket on the return structure.
      UserID        => 1,
      Silent        => 0,         # Optional, default 0. To suppress the warning if the ticket does not exist.
  );

  my $LigeroFixModules = $Kernel::OM->Get('Kernel::Config')->Get('LigeroFix::Modules');

  my $ModuleConfig = $LigeroFixModules->{'031-Tickets'};

  my $FilterText = $ModuleConfig->{Filters};
  while(index($FilterText, '<OTRS_Ticket_') > -1){
    my $tag = substr $FilterText, index($FilterText, '<OTRS_Ticket_');
    $tag = substr $tag, 0, index($tag,'>')+1;

    my $field = substr $tag, 13, index($tag,'>') -13;
    
    my $valueToSubst = $Ticket{$field};

    $FilterText =~ s/$tag/$valueToSubst/ig;
  }

  my %SearchParams        = $Self->_SearchParamsGet(Filters => $FilterText);
  my %TicketSearch        = %{ $SearchParams{TicketSearch} };
  my %TicketSearchSummary = %{ $SearchParams{TicketSearchSummary} };
  

	if ( $Self->{Subaction} eq 'GetCounter' ) {

    if(!$Ticket{ServiceID}){
      return $LayoutObject->Attachment(
          ContentType => 'application/json; charset=utf8',
          Content     => $LayoutObject->JSONEncode(
              Data => {
                Quantity => 0
              },
          ),
          Type        => 'inline',
          NoCache     => 1,
      );
    }

    my $Quantity = 0;

    $Quantity = $TicketObject->TicketSearch(
        Result      =>  'COUNT',
        %TicketSearch
    );

    #use Data::Dumper;
    #$Kernel::OM->Get('Kernel::System::Log')->Log(
    #    Priority => 'error',
    #    Message  => " CHEGOU AQUI ".Dumper($Quantity),
    #);

    my $CounterJson = $LayoutObject->JSONEncode(
        Data => {
          Quantity => $Quantity
        },
    );

    return $LayoutObject->Attachment(
        ContentType => 'application/json; charset=utf8',
        Content     => $CounterJson || '',
        Type        => 'inline',
        NoCache     => 1,
    );
	}

  if ( $Self->{Subaction} eq 'GetModal' ) {

    my @TicketList;

    @TicketList = $TicketObject->TicketSearch(
        Result      =>  'ARRAY',
        %TicketSearch
    );

    #use Data::Dumper;
    #$Kernel::OM->Get('Kernel::System::Log')->Log(
    #    Priority => 'error',
    #    Message  => " TICKET LIST ".Dumper((scalar @TicketList)),
    #);

    if((scalar @TicketList) == 0){
      return $LayoutObject->Attachment(
          ContentType => 'text/html; charset=utf8',
          Content     =>  '',
          Type        => 'inline',
          NoCache     => 1,
      );
    }

    $LayoutObject->Block(
      Name => "TicketCardContent"
    );

    my $FirstTicket = undef;

    foreach my $key (@TicketList) { 
      if(!$FirstTicket){
        $FirstTicket = $key;
      }
      my %TicketContent = $TicketObject->TicketGet(
          TicketID      => $key,
          DynamicFields => 1,
          Extended      => 1,
          UserID        => 1,
      );

      my $TicketData = {};

      $TicketData->{Title} = $TicketContent{$ModuleConfig->{TitleField}};
      $TicketData->{Description} = $ModuleConfig->{DescriptionTemplate};
      $TicketData->{FirstTicket} = $FirstTicket;
      $TicketData->{ID} = $TicketContent{TicketID};

      $TicketData->{Content} = $ModuleConfig->{ContentTemplate};

      while(index($TicketData->{Content}, '<OTRS_Ticket_') > -1){
        my $tag = substr $TicketData->{Content}, index($TicketData->{Content}, '<OTRS_Ticket_');
        $tag = substr $tag, 0, index($tag,'>')+1;

        my $field = substr $tag, 13, index($tag,'>') -13;
        
        my $valueToSubst = $TicketContent{$field};

        $TicketData->{Content} =~ s/$tag/$valueToSubst/ig;
      }


      while(index($TicketData->{Description}, '<OTRS_Ticket_') > -1){
        my $tag = substr $TicketData->{Description}, index($TicketData->{Description}, '<OTRS_Ticket_');
        $tag = substr $tag, 0, index($tag,'>')+1;

        my $field = substr $tag, 13, index($tag,'>') -13;
        
        my $valueToSubst = $TicketContent{$field};

        $TicketData->{Description} =~ s/$tag/$valueToSubst/ig;
      }

      $LayoutObject->Block(
				Name => "TicketCard",
        Data => $TicketData
			);

      
    }

    

    my $Output = $LayoutObject->Output(
			TemplateFile => 'ModalAgentLigeroFixTickets',
			Data         => {
				%Param,
			},
		);

    return $LayoutObject->Attachment(
        ContentType => 'text/html; charset=utf8',
        Content     => $Output || '',
        Type        => 'inline',
        NoCache     => 1,
    );
	}

  if ( $Self->{Subaction} eq 'LinkToTheTicket' ) {

    $Param{ObjectID} = $ParamObject->GetParam(Param => "ObjectID") || "";

    my $True = $LinkObject->LinkAdd(
        SourceObject => 'Ticket',
        SourceKey    => $Param{TicketID},
        TargetObject => 'Ticket',
        TargetKey    => $Param{ObjectID},
        Type         => 'ParentChild',
        State        => 'Valid',
        UserID       => 1,
    );

    my $ResultJson = $LayoutObject->JSONEncode(
        Data => {
          Result => $True
        },
    );

    return $LayoutObject->Attachment(
        ContentType => 'application/json; charset=utf8',
        Content     => $ResultJson || 0,
        Type        => 'inline',
        NoCache     => 1,
    );
	}

  my $JSON = $LayoutObject->JSONEncode(
      Data => {
        Error => 'Nothing to show.'
      },
  );

  return $LayoutObject->Attachment(
      ContentType => 'application/json; charset=utf8',
      Content     => $JSON || '',
      Type        => 'inline',
      NoCache     => 1,
  );
}

sub _SearchParamsGet {
    my ( $Self, %Param ) = @_;

    # get all search base attributes
    my %TicketSearch;
    my %DynamicFieldsParameters;
    my @Params = split /;/, $Param{Filters};

    # read user preferences and config to get columns that
    # should be shown in the dashboard widget (the preferences
    # have precedence)
    my %Preferences = $Kernel::OM->Get('Kernel::System::User')->GetPreferences(
        UserID => $Self->{UserID},
    );

    # get column names from Preferences
    my $PreferencesColumn = $Kernel::OM->Get('Kernel::System::JSON')->Decode(
        Data => $Preferences{ $Self->{PrefKeyColumns} },
    );

    # check for default settings
    my @Columns;
    if ( $Self->{Config}->{DefaultColumns} && IsHashRefWithData( $Self->{Config}->{DefaultColumns} ) ) {
        @Columns = grep { $Self->{Config}->{DefaultColumns}->{$_} eq '2' }
            sort { $Self->_DefaultColumnSort() } keys %{ $Self->{Config}->{DefaultColumns} };
    }
    if ($PreferencesColumn) {
        if ( $PreferencesColumn->{Columns} && %{ $PreferencesColumn->{Columns} } ) {
            @Columns = grep {
                defined $PreferencesColumn->{Columns}->{$_}
                    && $PreferencesColumn->{Columns}->{$_} eq '1'
            } sort { $Self->_DefaultColumnSort() } keys %{ $Self->{Config}->{DefaultColumns} };
        }
        if ( $PreferencesColumn->{Order} && @{ $PreferencesColumn->{Order} } ) {
            @Columns = @{ $PreferencesColumn->{Order} };
        }

        # remove duplicate columns
        my %UniqueColumns;
        my @ColumnsEnabledAux;

        for my $Column (@Columns) {
            if ( !$UniqueColumns{$Column} ) {
                push @ColumnsEnabledAux, $Column;
            }
            $UniqueColumns{$Column} = 1;
        }

        # set filtered column list
        @Columns = @ColumnsEnabledAux;
    }

    # always set TicketNumber
    if ( !grep { $_ eq 'TicketNumber' } @Columns ) {
        unshift @Columns, 'TicketNumber';
    }

    # also always set ProcessID and ActivityID (for process widgets)
    if ( $Self->{Config}->{IsProcessWidget} ) {

        my @AlwaysColumns = (
            'DynamicField_' . $Self->{ProcessManagementProcessID},
            'DynamicField_' . $Self->{ProcessManagementActivityID},
        );
        my $Resort;
        for my $AlwaysColumn (@AlwaysColumns) {
            if ( !grep { $_ eq $AlwaysColumn } @Columns ) {
                push @Columns, $AlwaysColumn;
                $Resort = 1;
            }
        }
        if ($Resort) {
            @Columns = sort { $Self->_DefaultColumnSort() } @Columns;
        }
    }

    {

        # loop through all the dynamic fields to get the ones that should be shown
        DYNAMICFIELDNAME:
        for my $DynamicFieldName (@Columns) {

            next DYNAMICFIELDNAME if $DynamicFieldName !~ m{ DynamicField_ }xms;

            # remove dynamic field prefix
            my $FieldName = $DynamicFieldName;
            $FieldName =~ s/DynamicField_//gi;
            $Self->{DynamicFieldFilter}->{$FieldName} = 1;
        }
    }

    # get the dynamic fields for this screen
    $Self->{DynamicField} = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldListGet(
        Valid       => 1,
        ObjectType  => ['Ticket'],
        FieldFilter => $Self->{DynamicFieldFilter} || {},
    );

    # get dynamic field backend object
    my $BackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

    # get filterable Dynamic fields
    # cycle trough the activated Dynamic Fields for this screen
    DYNAMICFIELD:
    for my $DynamicFieldConfig ( @{ $Self->{DynamicField} } ) {
        next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

        my $IsFiltrable = $BackendObject->HasBehavior(
            DynamicFieldConfig => $DynamicFieldConfig,
            Behavior           => 'IsFiltrable',
        );

        # if the dynamic field is filterable add it to the ValidFilterableColumns hash
        if ($IsFiltrable) {
            $Self->{ValidFilterableColumns}->{ 'DynamicField_' . $DynamicFieldConfig->{Name} } = 1;
        }
    }

    # get sortable Dynamic fields
    # cycle trough the activated Dynamic Fields for this screen
    DYNAMICFIELD:
    for my $DynamicFieldConfig ( @{ $Self->{DynamicField} } ) {
        next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

        my $IsSortable = $BackendObject->HasBehavior(
            DynamicFieldConfig => $DynamicFieldConfig,
            Behavior           => 'IsSortable',
        );

        # if the dynamic field is sortable add it to the ValidSortableColumns hash
        if ($IsSortable) {
            $Self->{ValidSortableColumns}->{ 'DynamicField_' . $DynamicFieldConfig->{Name} } = 1;
        }
    }

    # get queue object
    my $QueueObject = $Kernel::OM->Get('Kernel::System::Queue');

    STRING:
    for my $String (@Params) {
        next STRING if !$String;
        my ( $Key, $Value ) = split /=/, $String;

        if ( $Key eq 'CustomerID' ) {
            $Key = "CustomerIDRaw";
        }

        # push ARRAYREF attributes directly in an ARRAYREF
        if (
            $Key
            =~ /^(StateType|StateTypeIDs|Queues|QueueIDs|Types|TypeIDs|States|StateIDs|Priorities|PriorityIDs|Services|ServiceIDs|SLAs|SLAIDs|Locks|LockIDs|OwnerIDs|ResponsibleIDs|WatchUserIDs|ArchiveFlags|CreatedUserIDs|CreatedTypes|CreatedTypeIDs|CreatedPriorities|CreatedPriorityIDs|CreatedStates|CreatedStateIDs|CreatedQueues|CreatedQueueIDs)$/
            )
        {
            if ( $Value =~ m{,}smx ) {
                push @{ $TicketSearch{$Key} }, split( /,/, $Value );
            }
            else {
                push @{ $TicketSearch{$Key} }, $Value;
            }
        }

        # check if parameter is a dynamic field and capture dynamic field name (with DynamicField_)
        # in $1 and the Operator in $2
        # possible Dynamic Fields options include:
        #   DynamicField_NameX_Equals=123;
        #   DynamicField_NameX_Like=value*;
        #   DynamicField_NameX_GreaterThan=2001-01-01 01:01:01;
        #   DynamicField_NameX_GreaterThanEquals=2001-01-01 01:01:01;
        #   DynamicField_NameX_SmallerThan=2002-02-02 02:02:02;
        #   DynamicField_NameX_SmallerThanEquals=2002-02-02 02:02:02;
        elsif ( $Key =~ m{\A (DynamicField_.+?) _ (.+?) \z}sxm ) {

            # prevent adding ProcessManagement search parameters (for ProcessWidget)
            if ( $Self->{Config}->{IsProcessWidget} ) {
                next STRING if $2 eq $Self->{ProcessManagementProcessID};
                next STRING if $2 eq $Self->{ProcessManagementActivityID};
            }

            push @{ $DynamicFieldsParameters{$1}->{$2} }, $Value;
        }

        elsif ( !defined $TicketSearch{$Key} ) {

            # change sort by, if needed
            if (
                $Key eq 'SortBy'
                && $Self->{SortBy}
                && $Self->{ValidSortableColumns}->{ $Self->{SortBy} }
                )
            {
                $Value = $Self->{SortBy};
            }
            elsif ( $Key eq 'SortBy' && !$Self->{ValidSortableColumns}->{$Value} ) {
                $Value = 'Age';
            }
            $TicketSearch{$Key} = $Value;
        }
        elsif ( !ref $TicketSearch{$Key} ) {
            my $ValueTmp = $TicketSearch{$Key};
            $TicketSearch{$Key} = [$ValueTmp];
            push @{ $TicketSearch{$Key} }, $Value;
        }
        else {
            push @{ $TicketSearch{$Key} }, $Value;
        }
    }
    %TicketSearch = (
        %TicketSearch,
        %DynamicFieldsParameters,
        Permission => $Self->{Config}->{Permission} || 'ro',
        UserID     => $Self->{UserID},
    );

    # CustomerInformationCenter shows data per CustomerID
    if ( $Param{CustomerID} ) {
        $TicketSearch{CustomerIDRaw} = $Param{CustomerID};
    }

    # define filter attributes
    my @MyQueues = $QueueObject->GetAllCustomQueues(
        UserID => $Self->{UserID},
    );
    if ( !@MyQueues ) {
        @MyQueues = (999_999);
    }

    # get all queues the agent is allowed to see (for my services)
    my %ViewableQueues = $QueueObject->GetAllQueues(
        UserID => $Self->{UserID},
        Type   => 'ro',
    );
    my @ViewableQueueIDs = sort keys %ViewableQueues;
    if ( !@ViewableQueueIDs ) {
        @ViewableQueueIDs = (999_999);
    }

    # get the custom services from agent preferences
    # set the service ids to an array of non existing service ids (0)
    my @MyServiceIDs = (0);
    if ( $Self->{UseTicketService} ) {
        @MyServiceIDs = $Kernel::OM->Get('Kernel::System::Service')->GetAllCustomServices(
            UserID => $Self->{UserID},
        );

        if ( !defined $MyServiceIDs[0] ) {
            @MyServiceIDs = (0);
        }
    }

    my %LockList = $Kernel::OM->Get('Kernel::System::Lock')->LockList(
        UserID => $Self->{UserID},
    );
    my %LockName2ID = reverse %LockList;

    my %TicketSearchSummary = (
        Locked => {
            OwnerIDs => $TicketSearch{OwnerIDs} // [ $Self->{UserID}, ],
            LockIDs  => [ $LockName2ID{lock}, $LockName2ID{tmp_lock} ],
        },
        Watcher => {
            WatchUserIDs => [ $Self->{UserID}, ],
            LockIDs      => $TicketSearch{LockIDs} // undef,
        },
        Responsible => {
            ResponsibleIDs => $TicketSearch{ResponsibleIDs} // [ $Self->{UserID}, ],
            LockIDs        => $TicketSearch{LockIDs}        // undef,
        },
        MyQueues => {
            QueueIDs => \@MyQueues,
            LockIDs  => $TicketSearch{LockIDs} // undef,
        },
        MyServices => {
            QueueIDs   => \@ViewableQueueIDs,
            ServiceIDs => \@MyServiceIDs,
            LockIDs    => $TicketSearch{LockIDs} // undef,
        },
        All => {
            OwnerIDs => $TicketSearch{OwnerIDs} // undef,
            LockIDs  => $TicketSearch{LockIDs}  // undef,
        },
    );

    if ( $Self->{Action} eq 'AgentCustomerUserInformationCenter' ) {

        # Add filters for assigend and accessible tickets for the customer user information center as a
        #   additional filter together with the other filters. One of them must be always active.
        %TicketSearchSummary = (
            AssignedToCustomerUser => {
                CustomerUserLoginRaw => $Param{CustomerUserID} // undef,
            },
            AccessibleForCustomerUser => {
                CustomerUserID => $Param{CustomerUserID} // undef,
            },
            %TicketSearchSummary,
        );
    }

    if ( defined $TicketSearch{LockIDs} || defined $TicketSearch{Locks} ) {
        delete $TicketSearchSummary{Locked};
    }

    if ( defined $TicketSearch{WatchUserIDs} ) {
        delete $TicketSearchSummary{Watcher};
    }

    if ( defined $TicketSearch{ResponsibleIDs} ) {
        delete $TicketSearchSummary{Responsible};
    }

    if ( defined $TicketSearch{QueueIDs} || defined $TicketSearch{Queues} ) {
        delete $TicketSearchSummary{MyQueues};
        delete $TicketSearchSummary{MyServices}->{QueueIDs};
    }

    if ( !$Self->{UseTicketService} ) {
        delete $TicketSearchSummary{MyServices};
    }

    return (
        Columns             => \@Columns,
        TicketSearch        => \%TicketSearch,
        TicketSearchSummary => \%TicketSearchSummary,
    );
}

1;
