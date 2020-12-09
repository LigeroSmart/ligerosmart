# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::DynamicFieldByService;

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

    # global config hash for id dissolution
    $Self->{NameToID} = {
        Title          => 'Title',
        State          => 'StateID',
        StateID        => 'StateID',
        Priority       => 'PriorityID',
        PriorityID     => 'PriorityID',
        Lock           => 'LockID',
        LockID         => 'LockID',
        Queue          => 'QueueID',
        QueueID        => 'QueueID',
        Customer       => 'CustomerID',
        CustomerID     => 'CustomerID',
        CustomerNo     => 'CustomerID',
        CustomerUserID => 'CustomerUserID',
        Owner          => 'OwnerID',
        OwnerID        => 'OwnerID',
        Type           => 'TypeID',
        TypeID         => 'TypeID',
        SLA            => 'SLAID',
        SLAID          => 'SLAID',
        Service        => 'ServiceID',
        ServiceID      => 'ServiceID',
        Responsible    => 'ResponsibleID',
        ResponsibleID  => 'ResponsibleID',
        PendingTime    => 'PendingTime',
        Article        => 'Article',
    };

    # get the dynamic fields for ticket object
    $Self->{DynamicField} = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldListGet(
        Valid      => 1,
        ObjectType => ['Ticket','Article'],
    );

    return $Self;
}

sub Run {
	my ( $Self, %Param ) = @_;
	my $ParamObject          = $Kernel::OM->Get('Kernel::System::Web::Request');
	my $ConfigObject         = $Kernel::OM->Get('Kernel::Config');
	my $LayoutObject         = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
	my $DfByServiceObject    = $Kernel::OM->Get('Kernel::System::DynamicFieldByService');

	my $ServiceDynamicID     = $ParamObject->GetParam( Param => 'ServiceDynamicID' );
	my $CustomerID           = $ParamObject->GetParam( Param => 'CustomerID' );
	my $SelectedCustomerUser = $ParamObject->GetParam( Param => 'SelectedCustomerUser' );
	my $InterfaceName        = $ParamObject->GetParam( Param => 'InterfaceName');

	# ------------------------------------------------------------ #
	# change
	# ------------------------------------------------------------ #
	if ( $Self->{Subaction} eq 'Edit' ) {
		my $ID = $ParamObject->GetParam( Param => 'ID' ) || '';
		my %Data = $DfByServiceObject->DynamicFieldByServiceGet( ID => $ID );
		my $Output = $LayoutObject->Header();
		$Output .= $LayoutObject->NavigationBar();
		$Self->_Edit(
		    Action => 'Edit',
		    %Data,
		);
		$Output .= $LayoutObject->Output(
		    TemplateFile => 'DynamicFieldByService',
		    Data         => \%Param,
		);
		$Output .= $LayoutObject->Footer();
		return $Output;
	}

    if ( $Self->{Subaction} eq 'Copy' ) {
		my $ID = $ParamObject->GetParam( Param => 'ID' ) || '';
		my %Data = $DfByServiceObject->DynamicFieldByServiceGet( ID => $ID );
		my $Output = $LayoutObject->Header();
		$Output .= $LayoutObject->NavigationBar();
		$Self->_Edit(
		    Action => 'Copy',
		    %Data,
		);

		$Output .= $LayoutObject->Output(
		    TemplateFile => 'DynamicFieldByService',
		    Data         => \%Param,
		);
		$Output .= $LayoutObject->Footer();
		return $Output;
	}

    ##################### SUBACTION THAT RENDERS THE FORMS ON AGENT OR CUSTOMER SCREEN ################
	if ( $Self->{Subaction} eq 'DisplayActivityDialogAJAX' && $ServiceDynamicID && $InterfaceName ) {
		my $GetParam = $Self->_GetParam(
			ServiceDynamicID => $ServiceDynamicID,
			InterfaceName   => $InterfaceName, 
		);
        $GetParam->{SelectedCustomerUser} = $SelectedCustomerUser || '';
        $GetParam->{CustomerID}           = $CustomerID || '';

		my $ActivityDialogHTML = $Self->_OutputActivityDialog(
	 	   	%Param,
	   	 	ServiceDynamicID => $ServiceDynamicID,
			InterfaceName    => $InterfaceName,
            GetParam         => $GetParam,
		);
		if(!$ActivityDialogHTML){
			$ActivityDialogHTML = 0;
		}
		return $LayoutObject->Attachment(
	   		ContentType => 'text/html; charset=' . $LayoutObject->{Charset},
	   		 Content     => $ActivityDialogHTML,
	  		  Type        => 'inline',
	   		 NoCache     => 1,
		);

	}

    # HideAndShowDynamicFields
    # Aqui iremos elaborar o html que deve ser exibido na tela de acordo com ACLs
	# elsif ( $Self->{Subaction} eq 'HideAndShowDynamicFields' && $ServiceDynamicID && $InterfaceName ) {
	elsif ( $Self->{Subaction} eq 'HideAndShowDynamicFields' && $InterfaceName ) {
        my $ActivityDialogHTML;
        my $Action = $Self->{Action}||'';
        my $DfByServiceObject = $Kernel::OM->Get('Kernel::System::DynamicFieldByService');
        # # Verifica se há o parametro ServiceID
        my $ServiceID  = $Kernel::OM->Get('Kernel::System::Web::Request')->GetParam( Param => 'ServiceID' ) || '';
        my $Subaction = $Self->{Subaction} || '';	    
        
        my $DynamicFieldsByService = $DfByServiceObject->GetDynamicFieldByService(ServiceID => $ServiceID);
        my %DynamicFieldsHash;

        if ($DynamicFieldsByService->{Config}){
            DIALOGFIELD:
                for my $CurrentField ( @{ $DynamicFieldsByService->{Config}{FieldOrder} } ) {
                    my %FieldData = %{ $DynamicFieldsByService->{Config}{Fields}{$CurrentField} };

                    next DIALOGFIELD if !$FieldData{Display} || $FieldData{Display} == 3;
        
                    # render DynamicFields
                    if ( $CurrentField =~ m{^DynamicField_(.*)}xms ) {
                        my $DynamicFieldName = $1;
                        $DynamicFieldsHash{$DynamicFieldName} = $FieldData{Display}; 	
                    }
            }
        }
        # return $Self if(!%DynamicFieldsHash);
        my $ConfigObject = $Kernel::OM->Get('Kernel::Config');   
        my $HashOld = $ConfigObject->Get("Ticket::Frontend::$Action"); 
        foreach my $Keys (keys %{$HashOld->{DynamicField}}){
            $DynamicFieldsHash{$Keys} = $HashOld->{DynamicField}{$Keys};
        }
        my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
        # Get all DynamicFields from Ticket And Article
        my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');
        my $DynamicFields = $DynamicFieldObject->DynamicFieldList(
            Valid => 1,             # optional, defaults to 1
            ObjectType => ['Ticket', 'Article'],
            ResultType => 'HASH'
        );
        my $DynamicFieldBackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');
        
        # Aqui ainda tem que desenvolver, pega os parametros possiveis e passar para a ACL
        my $ParamObject  = $Kernel::OM->Get('Kernel::System::Web::Request');
        # get params
        my %GetParam;
        for my $Key (qw( OriginalAction
            NewStateID NewPriorityID TimeUnits IsVisibleForCustomer Title Body Subject NewQueueID
            Year Month Day Hour Minute NewOwnerID NewResponsibleID TypeID ServiceID SLAID
            Expand ReplyToArticle StandardTemplateID CreateArticle FormDraftID Title
            )
            )
        {
            $GetParam{$Key} = $ParamObject->GetParam( Param => $Key );
            delete $GetParam{$Key} if !$GetParam{$Key};
        }

        $GetParam{Action} = $GetParam{OriginalAction};
        # ACL compatibility translation
        my %ACLCompatGetParam = (
            StateID       => $GetParam{NewStateID},
            PriorityID    => $GetParam{NewPriorityID},
            QueueID       => $GetParam{NewQueueID},
            OwnerID       => $GetParam{NewOwnerID},
            ResponsibleID => $GetParam{NewResponsibleID},
        );

        # get dynamic field values form http request
        my %DynamicFieldValues;

        # # get the dynamic fields for this screen
        my $DynamicField = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldListGet(
            Valid       => 1,
            ObjectType  => [ 'Ticket', 'Article' ],
        );

        # cycle trough the activated Dynamic Fields for this screen
        DYNAMICFIELD:
        for my $DynamicFieldConfig ( @{$DynamicField} ) {
            next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

            # extract the dynamic field value from the web request
            $DynamicFieldValues{ $DynamicFieldConfig->{Name} } = $DynamicFieldBackendObject->EditFieldValueGet(
                DynamicFieldConfig => $DynamicFieldConfig,
                ParamObject        => $ParamObject,
                LayoutObject       => $LayoutObject,
            );
        }

        # # convert dynamic field values into a structure for ACLs
        my %DynamicFieldACLParameters;
        DYNAMICFIELD:
        for my $DynamicFieldItem ( sort keys %DynamicFieldValues ) {
            next DYNAMICFIELD if !$DynamicFieldItem;
            next DYNAMICFIELD if !defined $DynamicFieldValues{$DynamicFieldItem};

            $DynamicFieldACLParameters{ 'DynamicField_' . $DynamicFieldItem } = $DynamicFieldValues{$DynamicFieldItem};
        }
        $GetParam{DynamicField} = \%DynamicFieldACLParameters;

        my %PossibleActions;

        my $Counter=0;
        for my $DF (keys %$DynamicFields){
            $Counter++;
            $PossibleActions{$Counter} = "DF_".$DynamicFields->{$DF};
            $Counter++;
            $PossibleActions{$Counter} = "DF_".$DynamicFields->{$DF}."_Required";
        }

        my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

        my %UserID;
        if($Self->{SessionSource} eq 'CustomerInterface'){
            $UserID{CustomerUserID} = $Self->{UserID};
        } else {
            $UserID{UserID} = $Self->{UserID};
        }

        my $ACL = $TicketObject->TicketAcl(
            Data          => \%PossibleActions,
            %GetParam,
            ReturnType    => 'Action',
            ReturnSubType => '-',
            %UserID,
        );

        my %AclAction = %PossibleActions;
        if ($ACL) {
            %AclAction = $TicketObject->TicketAclActionData();
            for my $CurrentField ( keys %AclAction ) {
                if ( $AclAction{$CurrentField} =~ m{^DF_(.*)_Required}xms ) {
                    my $DynamicFieldName = $1;
                    $DynamicFieldsHash{$DynamicFieldName} = '2';
                } elsif ( $AclAction{$CurrentField} =~ m{^DF_(.*)}xms ) {
                    my $DynamicFieldName = $1;
                    $DynamicFieldsHash{$DynamicFieldName} = '1';
                }
            }
        }

        my %DynamicFieldConfig;
        for my $DF (keys %DynamicFieldsHash){
            $DynamicFieldConfig{Fields}->{"DynamicField_$DF"} = {
                'Display' => $DynamicFieldsHash{$DF},
                'DescriptionShort' => '',
                'DescriptionLong' => '',
                # @TODO = Get Default Value from dynamic field config
                'DefaultValue' => ''
            }    
        }

		$ActivityDialogHTML = $Self->_OutputShowHideDynamicFields(
	 	   	%Param,
	   	 	# ServiceDynamicID => $ServiceDynamicID,
			InterfaceName	 => $InterfaceName,
	    		GetParam     => \%GetParam,
         DynamicFieldsToShow => \%DynamicFieldsHash,
         DynamicFieldConfg   => \%DynamicFieldConfig,
		) if $DynamicFieldConfig{Fields};

		if(!$ActivityDialogHTML){
			$ActivityDialogHTML = 0;
		}
		return $LayoutObject->Attachment(
	   		ContentType => 'text/html; charset=' . $LayoutObject->{Charset},
	   		 Content     => $ActivityDialogHTML,
	  		  Type        => 'inline',
	   		 NoCache     => 1,
		);

	}
    # ------------------------------------------------------------ #
	# add
	# ------------------------------------------------------------ #
	elsif ( $Self->{Subaction} eq 'Add' ) {
		my %GetParam;
		$GetParam{Name} = $ParamObject->GetParam( Param => 'Name' );
        $GetParam{ViewMode} = $ParamObject->GetParam( Param => 'ViewMode' );

        my $Output;
        
        if ($GetParam{ViewMode} eq 'Popup'){
                    $Output = $LayoutObject->Header(
                    Type      => 'Small',
                );
        } else {
		    $Output = $LayoutObject->Header();
    		$Output .= $LayoutObject->NavigationBar();
        }
		
		$Self->_Edit(
		    Action => 'Add',
		    %GetParam,
		);
		
		$Output .= $LayoutObject->Output(
		    TemplateFile => 'DynamicFieldByService',
		    Data         => \%Param,
		);

        if ($GetParam{ViewMode} eq 'Popup'){
                    $Output .= $LayoutObject->Footer(
                    Type      => 'Small',
                );
        } else {
    		$Output .= $LayoutObject->Footer();
        }


		return $Output;
	}
	# ------------------------------------------------------------ #
	# ActvityDialogEditAction
	# ------------------------------------------------------------ #
	elsif ( $Self->{Subaction} eq 'EditAction' ) {
		my $FormsData = $Param{FormsData} || {};
		my $AvailableFieldsList = {
		Article     => 'Article',
		State       => 'StateID',
		Priority    => 'PriorityID',
		Lock        => 'LockID',
		Queue       => 'QueueID',
		CustomerID  => 'CustomerID',
		Owner       => 'OwnerID',
		PendingTime => 'PendingTime',
		Title       => 'Title',
		};

		my ( %GetParam, %Errors );
		for my $Parameter (qw( ID Name TypeID ServiceID Comments HideArticle Message Subject ValidID Frontend  PopupRedirect PopupRedirectAction PopupRedirectSubaction PopupRedirectID PopupRedirectEntityID RequiredLock )) {
			if($Parameter ne  "RequiredLock"){
				$FormsData->{$Parameter} =  $ParamObject->GetParam( Param => $Parameter ) || '';
				$FormsData->{Config}->{$Parameter} = $ParamObject->GetParam( Param => $Parameter ) || '';
			}else{ 
				$FormsData->{Config}->{RequiredLock} = $ParamObject->GetParam( Param => $Parameter ) || 0;
			}	
		}
		for my $Parameter ( qw(ServiceID) ){
			my @Data = $ParamObject->GetArray( Param => $Parameter );
#		   	next PARAMETER if !@Data;
			$FormsData->{$Parameter} = \@Data;
		}
		my $Fields = $ParamObject->GetParam( Param => 'Fields' ) || '';
		my $JSONObject = $Kernel::OM->Get('Kernel::System::JSON');

		if ($Fields) {
			$GetParam{Fields} = $JSONObject->Decode(
	  	        	Data => $Fields,
			);
		}else {
			$GetParam{Fields} = '';
		}
		my $FieldDetails = $ParamObject->GetParam( Param => 'FieldDetails' ) || '';
		if ($FieldDetails) {
			$GetParam{FieldDetails} = $JSONObject->Decode(
				Data => $FieldDetails,
			);
		}
		else {
			$GetParam{FieldDetails} = '';
		}
		# add service and SLA fields, if option is activated in sysconfig.
		if ( $ConfigObject->Get('Ticket::Service') ) {
			$AvailableFieldsList->{Service} = 'ServiceID';
			$AvailableFieldsList->{SLA}     = 'SLAID';
		}

		# add ticket type field, if option is activated in sysconfig.
		if ( $ConfigObject->Get('Ticket::Type') ) {
			$AvailableFieldsList->{Type} = 'TypeID';
		}

		# add responsible field, if option is activated in sysconfig.
		if ( $ConfigObject->Get('Ticket::Responsible') ) {
			$AvailableFieldsList->{Responsible} = 'ResponsibleID';
		}

		my $DynamicFieldList = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldList(
			ObjectType => [ 'Ticket', 'Article' ],
			ResultType => 'HASH',
		);

		DYNAMICFIELD:
		for my $DynamicFieldName ( values %{$DynamicFieldList} ) {

			next DYNAMICFIELD if !$DynamicFieldName;

			# do not show internal fields for process management
			next DYNAMICFIELD if $DynamicFieldName eq 'ProcessManagementProcessID';
			next DYNAMICFIELD if $DynamicFieldName eq 'ProcessManagementActivityID';

			$AvailableFieldsList->{"DynamicField_$DynamicFieldName"} = $DynamicFieldName;
		}
		# localize available fields
		my %AvailableFields = %{$AvailableFieldsList};

		if ( defined $Param{Action} && ($Param{Action} eq 'Edit' || $Param{Action} eq 'Copy') ) {

			# get used fields by the activity dialog
			my %AssignedFields;

			if ( IsHashRefWithData( $FormsData->{Config}->{Fields} ) ) {
				FIELD:
				for my $Field ( sort keys %{ $FormsData->{Config}->{Fields} } ) {
					next FIELD if !$Field;
					next FIELD if !$FormsData->{Config}->{Fields}->{$Field};

					$AssignedFields{$Field} = 1;
				}
			}

			# remove used fields from available list
			for my $Field ( sort keys %AssignedFields ) {
				delete $AvailableFields{$Field};
			}

			# sort by translated field names
			my %AvailableFieldsTranslated;
			for my $Field ( sort keys %AvailableFields ) {
				my $Translation = $LayoutObject->{LanguageObject}->Translate($Field);
				$AvailableFieldsTranslated{$Field} = $Translation;
			}

			# display available fields
			# display used fields
			ASSIGNEDFIELD:
			for my $Field ( @{ $FormsData->{Config}->{FieldOrder} } ) {
				next ASSIGNEDFIELD if !$AssignedFields{$Field};

				my $FieldConfig = $FormsData->{Config}->{Fields}->{$Field};

				my $FieldConfigJSON = $Kernel::OM->Get('Kernel::System::JSON')->Encode(
					Data => $FieldConfig,
			    	);
			}

			# display other affected processes by editing this activity (if applicable)
		}
		else {

			# sort by translated field names
			my %AvailableFieldsTranslated;
			for my $Field ( sort keys %AvailableFields ) {
			    my $Translation = $LayoutObject->{LanguageObject}->Translate($Field);
			    $AvailableFieldsTranslated{$Field} = $Translation;
			}

			# display available fields
			$Param{Title} = 'Create New Activity Dialog';
		}
		# challenge token check for write action
		$LayoutObject->ChallengeTokenCheck();

		if ( IsArrayRefWithData( $GetParam{Fields} ) ) {

		    FIELD:
		    for my $FieldName ( @{ $GetParam{Fields} } ) {
                next FIELD if !$FieldName;
                next FIELD if !$AvailableFieldsList->{$FieldName};

                # set fields hash
                $FormsData->{Config}->{Fields}->{$FieldName} = {};

                # set field order array
                push @{ $FormsData->{Config}->{FieldOrder} }, $FieldName;
		    }
		}

		# add field detail config to fields
		if ( IsHashRefWithData( $GetParam{FieldDetails} ) ) {
		    FIELDDETAIL:
		    for my $FieldDetail ( sort keys %{ $GetParam{FieldDetails} } ) {
			next FIELDDETAIL if !$FieldDetail;
			next FIELDDETAIL if !$FormsData->{Config}->{Fields}->{$FieldDetail};

			$FormsData->{Config}->{Fields}->{$FieldDetail} = $GetParam{FieldDetails}->{$FieldDetail};
		    }
		}

		# set default values for fields in case they don't have details
		for my $FieldName ( sort keys %{ $FormsData->{Config}->{Fields} } ) {
		    if ( !IsHashRefWithData( $FormsData->{Config}->{Fields}->{$FieldName} ) ) {
			$FormsData->{Config}->{Fields}->{$FieldName}->{DescriptionShort} = $FieldName;
		    }
		}

		# set correct Interface value
		my %Interfaces = (
		    AgentInterface    => ['AgentInterface'],
		    CustomerInterface => ['CustomerInterface'],
		    BothInterfaces    => [ 'AgentInterface', 'CustomerInterface' ],
		);
		$FormsData->{Config}->{Froented} = $Interfaces{ $FormsData->{Config}->{Froented} };

		if ( !$FormsData->{Config}->{Froented} ) {
		    $FormsData->{Config}->{Froented} = $Interfaces{Agent};
					}

		# check required parameters
		my %Error;

		if ( !$GetParam{Name} ) {

		    # add server error error class
		    $Error{NameServerError}        = 'ServerError';
		    $Error{NameServerErrorMessage} = 'This field is required';
		}

		if ( !$GetParam{DescriptionShort} ) {

		    # add server error error class
		    $Error{DescriptionShortServerError} = 'ServerError';
		    $Error{DecriptionShortErrorMessage} = 'This field is required';
		}

		# check if permission exists
		if ( defined $GetParam{Permission} && $GetParam{Permission} ne '' ) {

		    my $PermissionList = $ConfigObject->Get('System::Permission');

		    my %PermissionLookup = map { $_ => 1 } @{$PermissionList};

		    if ( !$PermissionLookup{ $GetParam{Permission} } )
		    {

			# add server error error class
			$Error{PermissionServerError} = 'ServerError';
		    }
		}

		# check if required lock exists
		if ( $GetParam{RequiredLock} && $GetParam{RequiredLock} ne 1 ) {

		    # add server error error class
		    $Error{RequiredLockServerError} = 'ServerError';
		}

		# otherwise save configuration and return to overview screen
		my $Success = $DfByServiceObject->DynamicTemplateUpdate(
			ID          => $FormsData->{ID},
	    	Name        => $FormsData->{Name},
			ServiceID   => $FormsData->{ServiceID},
			TypeID      => $FormsData->{TypeID},
			Comments    => $FormsData->{Comments},	
			Message     => $FormsData->{Message},	
			Subject     => $FormsData->{Subject},	
			ValidID     => $FormsData->{ValidID},	
			Frontend    => $FormsData->{Frontend},	
			Title	    => $FormsData->{Title},	
			Config      => $FormsData->{Config},
			UserID      => $Self->{UserID},
			HideArticle => $FormsData->{HideArticle},
		);
		$Self->_Overview();
		my $Output = $LayoutObject->Header();
		$Output .= $LayoutObject->NavigationBar();
		$Output .= $LayoutObject->Output(
		    TemplateFile => 'DynamicFieldByService',
		    Data         => \%Param,
		);
		$Output .= $LayoutObject->Footer();
		return $Output;
	}
	# ------------------------------------------------------------ #
	# add action
	# ------------------------------------------------------------ #
	elsif ( $Self->{Subaction} eq 'AddAction' || $Self->{Subaction} eq 'CopyAction' ) {
		my $FormsData = $Param{FormsData} || {};

		# challenge token check for write action
		$LayoutObject->ChallengeTokenCheck();

		my @NewIDs = $ParamObject->GetArray( Param => 'IDs' );
		my ( %GetParam, %Errors );

		for my $Parameter (qw(Name TypeID ServiceID Comments HideArticle Message Subject ValidID Frontend  PopupRedirect PopupRedirectAction PopupRedirectSubaction PopupRedirectID PopupRedirectEntityID RequiredLock )) {
		    if($Parameter ne  "RequiredLock"){
		    	$FormsData->{$Parameter} =  $ParamObject->GetParam( Param => $Parameter ) || '';
			    $FormsData->{Config}->{$Parameter} = $ParamObject->GetParam( Param => $Parameter ) || '';
		    }else{ 
			    $FormsData->{Config}->{RequiredLock} = $ParamObject->GetParam( Param => $Parameter ) || 0;
		    }	
		}
		for my $Parameter ( qw(ServiceID) ){
			my @Data = $ParamObject->GetArray( Param => $Parameter );
	  	        $FormsData->{$Parameter} = \@Data;
		}
		my $Fields = $ParamObject->GetParam( Param => 'Fields' ) || '';
		my $JSONObject = $Kernel::OM->Get('Kernel::System::JSON');

		if ($Fields) {
    		$GetParam{Fields} = $JSONObject->Decode(
	    	    Data => $Fields,
		    );
		}
		else {
		    $GetParam{Fields} = '';
		}

		my $FieldDetails = $ParamObject->GetParam( Param => 'FieldDetails' ) || '';

		if ($FieldDetails) {
            $GetParam{FieldDetails} = $JSONObject->Decode(
                Data => $FieldDetails,
            );
		}
		else {
    		$GetParam{FieldDetails} = '';
		}

		#CARREGA TODOS OS CAMPOS
		my $AvailableFieldsList = {
            State       => 'StateID',
            Priority    => 'PriorityID',
            Queue       => 'QueueID',
		};

		# add service and SLA fields, if option is activated in sysconfig.
		if ( $ConfigObject->Get('Ticket::Service') ) {
            $AvailableFieldsList->{Service} = 'ServiceID';
            $AvailableFieldsList->{SLA}     = 'SLAID';
		}

		# add ticket type field, if option is activated in sysconfig.
		if ( $ConfigObject->Get('Ticket::Type') ) {
		    $AvailableFieldsList->{Type} = 'TypeID';
		}

		# add responsible field, if option is activated in sysconfig.
		if ( $ConfigObject->Get('Ticket::Responsible') ) {
		    $AvailableFieldsList->{Responsible} = 'ResponsibleID';
		}

		my $DynamicFieldList = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldList(
            ObjectType => [ 'Ticket', 'Article' ],
            ResultType => 'HASH',
		);

		DYNAMICFIELD:
		for my $DynamicFieldName ( values %{$DynamicFieldList} ) {

            next DYNAMICFIELD if !$DynamicFieldName;

            # do not show internal fields for process management
            next DYNAMICFIELD if $DynamicFieldName eq 'ProcessManagementProcessID';
            next DYNAMICFIELD if $DynamicFieldName eq 'ProcessManagementActivityID';

    		$AvailableFieldsList->{"DynamicField_$DynamicFieldName"} = $DynamicFieldName;
		}

		# localize available fields
		my %AvailableFields = %{$AvailableFieldsList};

		if ( defined $Param{Action} && ($Param{Action} eq 'Edit' || $Param{Action} eq 'Copy') ) {
            # get used fields by the activity dialog
            my %AssignedFields;

            if ( IsHashRefWithData( $FormsData->{Config}->{Fields} ) ) {
                FIELD:
                for my $Field ( sort keys %{ $FormsData->{Config}->{Fields} } ) {
                    next FIELD if !$Field;
                    next FIELD if !$FormsData->{Config}->{Fields}->{$Field};

                    $AssignedFields{$Field} = 1;
                }
            }

            # remove used fields from available list
            for my $Field ( sort keys %AssignedFields ) {
                delete $AvailableFields{$Field};
            }

            # sort by translated field names
            my %AvailableFieldsTranslated;
            for my $Field ( sort keys %AvailableFields ) {
                my $Translation = $LayoutObject->{LanguageObject}->Translate($Field);
                $AvailableFieldsTranslated{$Field} = $Translation;
            }

            # display available fields
            # display used fields
            ASSIGNEDFIELD:
            for my $Field ( @{ $FormsData->{Config}->{FieldOrder} } ) {
                next ASSIGNEDFIELD if !$AssignedFields{$Field};

                my $FieldConfig = $FormsData->{Config}->{Fields}->{$Field};

                my $FieldConfigJSON = $Kernel::OM->Get('Kernel::System::JSON')->Encode(
                    Data => $FieldConfig,
                );
            }
		# display other affected processes by editing this activity (if applicable)
		}
		else {
            # sort by translated field names
            my %AvailableFieldsTranslated;
            for my $Field ( sort keys %AvailableFields ) {
                my $Translation = $LayoutObject->{LanguageObject}->Translate($Field);
                $AvailableFieldsTranslated{$Field} = $Translation;
            }

            # display available fields
            $Param{Title} = 'Create New Activity Dialog';
		}

		if ( IsArrayRefWithData( $GetParam{Fields} ) ) {

		    FIELD:
		    for my $FieldName ( @{ $GetParam{Fields} } ) {
			next FIELD if !$FieldName;
			next FIELD if !$AvailableFieldsList->{$FieldName};

			# set fields hash
			$FormsData->{Config}->{Fields}->{$FieldName} = {};

			# set field order array
			push @{ $FormsData->{Config}->{FieldOrder} }, $FieldName;
		    }
		}

		# add field detail config to fields
		if ( IsHashRefWithData( $GetParam{FieldDetails} ) ) {
		    FIELDDETAIL:
		    for my $FieldDetail ( sort keys %{ $GetParam{FieldDetails} } ) {
			next FIELDDETAIL if !$FieldDetail;
			next FIELDDETAIL if !$FormsData->{Config}->{Fields}->{$FieldDetail};

			$FormsData->{Config}->{Fields}->{$FieldDetail} = $GetParam{FieldDetails}->{$FieldDetail};
		    }
		}
		# set correct Interface value
		my %Interfaces = (
		    AgentInterface    => ['AgentInterface'],
		    CustomerInterface => ['CustomerInterface'],
		    BothInterfaces    => [ 'AgentInterface', 'CustomerInterface' ],
		);
		$FormsData->{Config}->{Frontend} = $Interfaces{ $FormsData->{Config}->{Frontend} };

		if ( !$FormsData->{Config}->{Frontend} ) {
		    $FormsData->{Config}->{Froented} = $Interfaces{Agent};
            $FormsData->{Frontend} = $Interfaces{Agent};
		}

		# check required parameters
		my %Error;
		if ( !$GetParam{Name} ) {
		    # add server error error class
		    $Error{NameServerError}        = 'ServerError';
		    $Error{NameServerErrorMessage} = 'This field is required';
		}
		# otherwise save configuration and return process screen
		my $DfByServiceID = $DfByServiceObject->DynamicTemplateAdd(
			Name      							=> $FormsData->{Name},
			TypeID    							=> $FormsData->{TypeID},
			ServiceID 							=> $FormsData->{ServiceID},
			Comments  							=> $FormsData->{Comments},	
			HideArticle  						=> $FormsData->{HideArticle},	
			Message   							=> $FormsData->{Message},	
			Subject   							=> $FormsData->{Subject},	
			ValidID   							=> $FormsData->{ValidID},	
			Frontend  							=> $FormsData->{Frontend},	
			PopupRedirect 							=> $FormsData->{PopupRedirect},	
			PopupRedirectAction			 			=> $FormsData->{PopupRedirectAction},	
			PopupRedirectSubaction						=> $FormsData->{PopupRedirectSubaction},	
			PopupRedirectID							=> $FormsData->{PopupRedirectID},	
			PopupRedirectEntityID					 	=> $FormsData->{PopupRedirectEntityID},	
			Title			 					=> $FormsData->{Title},	
			Config  		 					=> $FormsData->{Config},
			UserID			 					=> $Self->{UserID},
			WorkflowID 		 					=> "",
			ContetType       						=> "text/html",
		);
        $GetParam{ViewMode} = $ParamObject->GetParam( Param => 'ViewMode' );
    
        if ($DfByServiceID) {
            if($GetParam{ViewMode} eq 'Popup'){

                # GET All Forms 
                my %ServiceForms = $Kernel::OM->Get('Kernel::System::DynamicFieldByService')->DynamicFieldByServiceList();

                my $SelOptions='<option>-</option>';
                for my $key (sort{"\L$ServiceForms{$a}" cmp "\L$ServiceForms{$b}"} keys %ServiceForms){
                    my $selected='';
                    if($key eq $DfByServiceID){
                        $selected = 'selected="selected"';
                    }
                    $SelOptions .= '<option '.$selected.' value="'.$key.'">'.$ServiceForms{$key}.'</option>';
                }

                my $Close = $LayoutObject->Header( Type => 'Small' );
                $LayoutObject->Block(
                    Name => 'PopUpClose',
                    Data => {
                        Options => $SelOptions,
                        SelectedID => $DfByServiceID
                    },
                );
                $Close .= $LayoutObject->Output( TemplateFile => 'DynamicFieldByService' );
                $Close .= $LayoutObject->Footer( Type => 'Small' );
                return $Close;

            } else {
                $Self->_Overview();
                my $Output = $LayoutObject->Header();
                $Output .= $LayoutObject->NavigationBar();
                $Output .= $LayoutObject->Notify( Info => 'Forms added!' );
                $Output .= $LayoutObject->Output(
                    TemplateFile => 'DynamicFieldByService',
                    Data         => \%Param,
                );
                $Output .= $LayoutObject->Footer();
                return $Output;                
            }
        
        }
		# something has gone wrong
		#@TODO Add VIEW MODE ON ERROR
		my $Output;
		
        if ($GetParam{ViewMode} eq 'Popup'){
            $Output = $LayoutObject->Header(
                Type      => 'Small',
                BodyClass => 'Popup',
            );
        } else {
		    $Output = $LayoutObject->Header();
    		$Output .= $LayoutObject->NavigationBar();
        }
		$Output .= $LayoutObject->Notify( Priority => 'Error' );
		$Self->_Edit(
		    Action              => 'Add',
		    Errors              => \%Errors,
		    SelectedAttachments => \@NewIDs,
		    %GetParam,
		);
		$Output .= $LayoutObject->Output(
		    TemplateFile => 'DynamicFieldByService',
		    Data         => \%Param,
		);

        if ($GetParam{ViewMode} eq 'Popup'){
            $Output .= $LayoutObject->Footer(
                Type      => 'Small',
            );
        } else {
    		$Output .= $LayoutObject->Footer();
        }

		return $Output;
	}

	# ------------------------------------------------------------ #
	# delete action
	# ------------------------------------------------------------ #
	elsif ( $Self->{Subaction} eq 'Delete' ) {

	# challenge token check for write action
	$LayoutObject->ChallengeTokenCheck();

	my $ID = $ParamObject->GetParam( Param => 'ID' );
    my $Delete = 		$DfByServiceObject->DynamicFieldByServiceDelete(ID => $ID);
	if ( !$Delete ) {
	    return $LayoutObject->ErrorScreen();
	}

	return $LayoutObject->Redirect( OP => "Action=$Self->{Action}" );
	}

	# ------------------------------------------------------------
	# overview
	# ------------------------------------------------------------
	else {
        $Self->_Overview();
    	my $Output = $LayoutObject->Header();
	    $Output .= $LayoutObject->NavigationBar();
	    $Output .= $LayoutObject->Output(
	        TemplateFile => 'DynamicFieldByService',
	        Data         => \%Param,
	    );
	    $Output .= $LayoutObject->Footer();
	    return $Output;
	}
}

sub _Edit {
    my ( $Self, %Param ) = @_;
    my $ParamObject  = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    $LayoutObject->Block(
        Name => 'Overview',
        Data => \%Param,
    );

    # Add: QUANDO NÃO FOR POPUP, MOSTRA A LISTA DE AÇÕES A ESQUERDA
    if($Param{ViewMode} ne 'Popup'){
        $LayoutObject->Block(
            Name => 'ActionListView',
            Data => {},
        );
    }
    $LayoutObject->Block( Name => 'ActionList' );
    $LayoutObject->Block( Name => 'ActionOverview' );

    # get valid list
    my %ValidList        = $Kernel::OM->Get('Kernel::System::Valid')->ValidList();
    my %ValidListReverse = reverse %ValidList;

    $Param{ValidOption} = $LayoutObject->BuildSelection(
        Data       => \%ValidList,
        Name       => 'ValidID',
        SelectedID => $Param{ValidID} || $ValidListReverse{valid},
        Class      => 'Validate_Required ' . ( $Param{Errors}->{'ValidIDInvalid'} || '' ),
    );

    # get type list
    my %TypeList        = $Kernel::OM->Get('Kernel::System::Type')->TypeList();
    my %TypeListReverse = reverse %TypeList;

    $Param{TypeOption} = $LayoutObject->BuildSelection(
        Data         => \%TypeList,
        Name         => 'TypeID',
        PossibleNone => 1,
        SelectedID   => $Param{TypeID} || $TypeListReverse{type},
        Class        => 'Modernize  ' . ( $Param{Errors}->{'TypeIDInvalid'} || '' ),
    );

    # get Service list
    my $ServiceObject 	   = $Kernel::OM->Get('Kernel::System::Service');
    my %ServiceList        = $ServiceObject->ServiceList(UserID => 1);
    my %ServiceListReverse = reverse %ServiceList;
    my @Selection;
    #Read Services 
    my $ServiceList2 = $ServiceObject->ServiceListGet(
            Valid  => 0,
            UserID => $Self->{UserID},
        );
        # if there are any services defined, they are shown
	if ( @{$ServiceList2} ) {
    	for my $ServiceData ( @{$ServiceList2} ) {
	        my %Preferences = $ServiceObject->ServicePreferencesGet(
				ServiceID => $ServiceData->{ServiceID},
			    UserID    => 1,
	        );
			#Caso o nome seja o mesmo ASSOCIADO AO CAMPO DA "FORMS" da Interface de admin de serviços 
			#O Serviço já será setado 
			#TO-DO
			#Pegar o nome do Sysconfig
			if( defined($Preferences{Forms}) and defined($Param{ID}) and $Param{ID} eq $Preferences{Forms}){
				if(defined( $ServiceData->{ServiceID})){
	            	push @Selection ,  $ServiceData->{ServiceID};
				}
	    	}
	    }   
	}
    #-------------------------------------#
    # Add = SE POPUP, NÃO MOSTRA A SELEÇÃO DE SERVIÇOS
    my $TreeView = 0;
    if ( $ConfigObject->Get('Ticket::Frontend::ListType') eq 'tree' ) {
        $TreeView = 1;
    }
    if ($Param{ViewMode} eq 'Popup'){
     	$Param{ServiceOption} = '<span class="ServiceUnderCreation">'.$LayoutObject->{LanguageObject}->Translate('Under creation').'</span>'
    } 
	else {
		if ($TreeView eq 1){
   	    	$Param{ServiceOption} = $LayoutObject->BuildSelection(
        	    Data       => \%ServiceList,
        	    Name       => 'ServiceID',
        	    Multiple   => 1, 
        	    SelectedID => \@Selection,
			    TreeView       => $TreeView,
        	    PossibleNone=> 1,
        	);
		}
		else {
			$Param{ServiceOption} = $LayoutObject->BuildSelection(
        	    Data       => \%ServiceList,
        	    Name       => 'ServiceID',
        	    Multiple   => 1, 
        	    SelectedID => \@Selection,
				Class	=> "Modernize",
			    TreeView       => $TreeView,
        	    PossibleNone=> 1,
        	); 
		}
    }
    $Param{InterfaceSelection} = $LayoutObject->BuildSelection(
        Data => {
            AgentInterface    => 'Agent Interface',
            CustomerInterface => 'Customer Interface',
            BothInterfaces    => 'Agent and Customer Interface',
        },
        Name         => 'Frontend',
        ID           => 'Frontend',
        SelectedID   => $Param{Frontend} || 'BothInterfaces',
        Sort         => 'AlphanumericKey',
        Translation  => 1,
        PossibleNone => 0,
        Class        => 'Modernize',
    );

    if ( defined $Param{Action} && ($Param{Action} eq 'Copy') ) {
        delete $Param{ID};
    }

	

    $LayoutObject->Block(
        Name => 'OverviewUpdate',
        Data => {
            %Param,
            %{ $Param{Errors} },
        },
    );
    
    # nesta variavel temos que armazenar os dados dos campos dinamicos imagino
    my %JobData=%Param;
    
    # create dynamic field HTML for set with historical data options
    my $PrintDynamicFieldsSearchHeader = 1;


    # create dynamic field HTML for set with historical data options
    my $PrintDynamicFieldsEditHeader = 1;

    
     # get Activity Dialog information
    my $FormsData = $Param{Config} || {};


    # check if last screen action is main screen

    # create available Fields list
    # CAMPOS DISPONÍVEIS
    my $AvailableFieldsList = {
#        Article     => 'Article',
        State       => 'StateID',
        Priority    => 'PriorityID',
        #Lock        => 'LockID',
        Queue       => 'QueueID',
        #CustomerID  => 'CustomerID',
        #Owner       => 'OwnerID',
        #PendingTime => 'PendingTime',
        #Title       => 'Title',
    };


    # add service and SLA fields, if option is activated in sysconfig.
    if ( $ConfigObject->Get('Ticket::Service') ) {
#        $AvailableFieldsList->{Service} = 'ServiceID';
        $AvailableFieldsList->{SLA}     = 'SLAID';
    }

    # add ticket type field, if option is activated in sysconfig.
    if ( $ConfigObject->Get('Ticket::Type') ) {
 #       $AvailableFieldsList->{Type} = 'TypeID';
    }

    # add responsible field, if option is activated in sysconfig.
    if ( $ConfigObject->Get('Ticket::Responsible') ) {
        $AvailableFieldsList->{Responsible} = 'ResponsibleID';
    }

    my $DynamicFieldList = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldList(
        ObjectType => [ 'Ticket', 'Article' ],
        ResultType => 'HASH',
    );

    DYNAMICFIELD:
    for my $DynamicFieldName ( values %{$DynamicFieldList} ) {

        next DYNAMICFIELD if !$DynamicFieldName;

        # do not show internal fields for process management
        next DYNAMICFIELD if $DynamicFieldName eq 'ProcessManagementProcessID';
        next DYNAMICFIELD if $DynamicFieldName eq 'ProcessManagementActivityID';

        $AvailableFieldsList->{"DynamicField_$DynamicFieldName"} = $DynamicFieldName;
    }

    # localize available fields
    my %AvailableFields = %{$AvailableFieldsList};

    if ( defined $Param{Action} && ($Param{Action} eq 'Edit' || $Param{Action} eq 'Copy') ) {

        # get used fields by the activity dialog
        my %AssignedFields;
        if ( IsHashRefWithData( $FormsData->{Fields} ) ) {
            FIELD:

            for my $Field ( sort keys %{ $FormsData->{Fields} } ) {

                next FIELD if !$Field;
                next FIELD if !$FormsData->{Fields}->{$Field};

                $AssignedFields{$Field} = 1;
            }
        }

        # remove used fields from available list
        for my $Field ( sort keys %AssignedFields ) {
            delete $AvailableFields{$Field};
        }

       # sort by translated field names
        my %AvailableFieldsTranslated;
        for my $Field ( sort keys %AvailableFields ) {
            my $Translation = $LayoutObject->{LanguageObject}->Translate($Field);
            $AvailableFieldsTranslated{$Field} = $Translation;
        }

        # display available fields
        for my $Field (
            sort { $AvailableFieldsTranslated{$a} cmp $AvailableFieldsTranslated{$b} }
            keys %AvailableFieldsTranslated
            )
        {

            $LayoutObject->Block(
                Name => 'AvailableFieldRow',
                Data => {
                    Field               => $Field,
                    FieldnameTranslated => $AvailableFieldsTranslated{$Field},
                },
            );
        }

        # display used fields
        ASSIGNEDFIELD:
        for my $Field ( @{ $FormsData->{FieldOrder} } ) {
            next ASSIGNEDFIELD if !$AssignedFields{$Field};

            my $FieldConfig = $FormsData->{Fields}->{$Field};

            my $FieldConfigJSON = $Kernel::OM->Get('Kernel::System::JSON')->Encode(
                Data => $FieldConfig,
            );
            $LayoutObject->Block(
                Name => 'AssignedFieldRow',
                Data => {
                    Field       => $Field,
                    FieldConfig => $FieldConfigJSON,
                },
            );
        }

        # display other affected processes by editing this activity (if applicable)
    }
    else {

        # sort by translated field names
        my %AvailableFieldsTranslated;
        for my $Field ( sort keys %AvailableFields ) {
            my $Translation = $LayoutObject->{LanguageObject}->Translate($Field);
            $AvailableFieldsTranslated{$Field} = $Translation;
        }

        # display available fields
        for my $Field (
            sort { $AvailableFieldsTranslated{$a} cmp $AvailableFieldsTranslated{$b} }
            keys %AvailableFieldsTranslated
            )
        {
            $LayoutObject->Block(
               Name => 'AvailableFieldRow',
                Data => {
                    Field               => $Field,
                    FieldnameTranslated => $AvailableFieldsTranslated{$Field},
                },
            );
        }

        $Param{Title} = 'Create New Activity Dialog';
    }
#
    # get interface infos
    if ( defined $FormsData->{Config}->{Frontend} ) {
        my $InterfaceLength = scalar @{ $FormsData->{Config}->{Frontend} };
        if ( $InterfaceLength == 2 ) {
            $FormsData->{Config}->{Interface} = 'BothInterfaces';
        }
        elsif ( $InterfaceLength == 1 ) {
            $FormsData->{Config}->{Frontend} = $FormsData->{Config}->{Frontend}->[0];
        }
        else {
            $FormsData->{Config}->{Frontend} = 'AgentInterface';
        }
    }
    else {
        $FormsData->{Config}->{Frontend} = 'AgentInterface';
    }

    # create interface selection
    $Param{InterfaceSelection} = $LayoutObject->BuildSelection(
        Data => {
            AgentInterface    => 'Agent Interface',
            CustomerInterface => 'Customer Interface',
            BothInterfaces    => 'Agent and Customer Interface',
        },
        Name         => 'Interface',
        ID           => 'Interface',
        SelectedID   => $FormsData->{Config}->{Frontend} || '',
        Sort         => 'AlphanumericKey',
        Translation  => 1,
        PossibleNone => 0,
        Class        => 'Modernize',
    );
#
    # create permission selection
    $Param{PermissionSelection} = $LayoutObject->BuildSelection(
        Data       => $Kernel::OM->Get('Kernel::Config')->Get('System::Permission') || ['rw'],
        Name       => 'Permission',
        ID         => 'Permission',
        SelectedID => $FormsData->{Config}->{Permission}                   || '',
        Sort       => 'AlphanumericKey',
        Translation  => 1,
        PossibleNone => 1,
        Class        => 'Modernize' . ( $Param{PermissionServerError} || '' ),
    );

#    # create "required lock" selection
    $Param{RequiredLockSelection} = $LayoutObject->BuildSelection(
        Data => {
            0 => 'No',
            1 => 'Yes',
        },
        Name        => 'RequiredLock',
        ID          => 'RequiredLock',
        SelectedID  => $FormsData->{Config}->{RequiredLock} || 0,
        Sort        => 'AlphanumericKey',
        Translation => 1,
        Class       => 'Modernize ' . ( $Param{RequiredLockServerError} || '' ),
    );
#
#    # create Display selection
    $Param{DisplaySelection} = $LayoutObject->BuildSelection(
        Data => {
            #0 => 'Do not show Field',
            1 => 'Show Field',
            2 => 'Show Field As Mandatory',
            3 => 'Do not show Field',
        },
        Name        => 'Display',
        ID          => 'Display',
        Sort        => 'AlphanumericKey',
        Translation => 1,
        Class       => 'Modernize',
    );

#    # create ArticleType selection
    $Param{ArticleTypeSelection} = $LayoutObject->BuildSelection(
        Data => [
            'note-internal',
            'note-external',
            'note-report',
            'phone',
            'fax',
            'sms',
            'webrequest',
        ],
        SelectedValue => 'note-internal',
        Name          => 'ArticleType',
        ID            => 'ArticleType',
        Sort          => 'Alphanumeric',
        Translation   => 1,
        Class         => 'Modernize',
    );
#
    # extract parameters from config
    $Param{HideArticle}      = (defined($Param{Config}) && $Param{Config} ne "" && defined($Param{Config}->{HideArticle})) ? $Param{Config}->{HideArticle} : 0;
    $Param{DescriptionShort} = $Param{FormsData}->{Config}->{DescriptionShort};
    $Param{DescriptionLong}  = $Param{FormsData}->{Config}->{DescriptionLong};
    $Param{SubmitAdviceText} = $Param{FormsData}->{Config}->{SubmitAdviceText};
    $Param{SubmitButtonText} = $Param{FormsData}->{Config}->{SubmitButtonText};
    my $Output = $LayoutObject->Header(
        Value => $Param{Title},
        Type  => 'Small',
    );
    $LayoutObject->Block(
        Name   => "Options",
        Data         => {
           %Param,
            %{$FormsData},
        },
    ); 

    # shows header
    if ( $Param{Action} eq 'Edit' ) {
        $LayoutObject->Block( Name => 'HeaderEdit' );
    }
    else {
        $LayoutObject->Block( Name => 'HeaderAdd' );
    }

    # add rich text editor
    if ( $LayoutObject->{BrowserRichText} ) {
        $LayoutObject->Block(
            Name => 'RichText',
            Data => \%Param,
        );

	    # reformat from plain to html
	    if ($Param{Message}){
	        $Param{Message} = $Kernel::OM->Get('Kernel::System::HTMLUtils')->ToHTML(
		        String => $Param{Message},
	        );
	    }
    }
    else {
        # reformat from html to plain
		$Param{Message} = $Kernel::OM->Get('Kernel::System::HTMLUtils')->ToAscii(
			String => $Param{Message},
		);
    }
    return 1;
}

sub _Overview {

    my ( $Self, %Param ) = @_;
    my $ParamObject  = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $LogObject    = $Kernel::OM->Get('Kernel::System::Log');

    $LayoutObject->Block(
        Name => 'Overview',
        Data => \%Param,
    );

    $LayoutObject->Block(
        Name => 'ActionListView',
        Data => {},
    );

    $LayoutObject->Block( Name => 'ActionList' );
    $LayoutObject->Block( Name => 'ActionAdd' );
    $LayoutObject->Block( Name => 'Filter' );

    $LayoutObject->Block(
        Name => 'OverviewResult',
        Data => \%Param,
    );
    my %List = $Kernel::OM->Get('Kernel::System::DynamicFieldByService')->DynamicFieldByServiceList(
        UserID => 1,
        Valid  => 0,
    );

    # if there are any results, they are shown
    if (%List) {

        # get valid list
        my %ValidList = $Kernel::OM->Get('Kernel::System::Valid')->ValidList();
        for my $ID ( sort { $List{$a} cmp $List{$b} } keys %List ) {

            my %Data = $Kernel::OM->Get('Kernel::System::DynamicFieldByService')->DynamicFieldByServiceGet( ID => $ID, );

            $LayoutObject->Block(
                Name => 'OverviewResultRow',
                Data => {
                    Valid => $ValidList{ $Data{ValidID} },
                    %Data,
#                    Attachments => scalar @SelectedAttachment,
                },
            );
        }
    }

    # otherwise it displays a no data found message
    else {
        $LayoutObject->Block(
            Name => 'NoDataFoundMsg',
            Data => {},
        );
    }

    return 1;
}

############ SUB ROUTINE THAT RENDERS FORMS FOR AGENT OR CUSTOMER INTERFACES ########
sub _OutputActivityDialog {
	my ( $Self, %Param ) = @_;
	my $TicketID               = $Param{GetParam}{TicketID};
	my $ActivityDialogEntityID = $Param{GetParam}{ActivityDialogEntityID};
	my $AjaxResponseJson='';
	my %Ticket;
	my %Error         = ();
	my %ErrorMessages = ();

	# If we had Errors, we got an Errorhash
	%Error         = %{ $Param{Error} }         if ( IsHashRefWithData( $Param{Error} ) );
	%ErrorMessages = %{ $Param{ErrorMessages} } if ( IsHashRefWithData( $Param{ErrorMessages} ) );

	# get needed object
	my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');
	my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
	my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
	my $DfByServiceObject = $Kernel::OM->Get('Kernel::System::DynamicFieldByService');

	my $ActivityDialog = $DfByServiceObject->GetDynamicFieldByServiceAndInterface(ServiceID => $Param{ServiceDynamicID},  InterfaceName   => $Param{InterfaceName} );
	if(!$ActivityDialog->{ID}){
		return;
	}

	my $Output='';
    my %RenderedFields = ();

    # get the list of fields where the AJAX loader icon should appear on AJAX updates triggered
    # by ActivityDialog fields
    my $AJAXUpdatableFields;
    if(ref ($ActivityDialog->{Config}) eq 'HASH'){
        $AJAXUpdatableFields = $Self->_GetAJAXUpdatableFields(
            ActivityDialogFields => $ActivityDialog->{Config}{Fields},
        );
        # Loop through ActivityDialogFields and render their output
	    DIALOGFIELD:
	    for my $CurrentField ( @{ $ActivityDialog->{Config}{FieldOrder} } ) {
            my %FieldData = %{ $ActivityDialog->{Config}{Fields}{$CurrentField} };
		    # We render just visible ActivityDialogFields
            next DIALOGFIELD if !$FieldData{Display} || $FieldData{Display} == 3;
		    $Self->{FormID} = "NewPhoneTicket";
            # render DynamicFields
            if ( $CurrentField =~ m{^DynamicField_(.*)}xms ) {
                # @TODO Render OTRS TAGs for Default Values
             	my $DynamicFieldName = $1;
			    my $Response         = $Self->_RenderDynamicField(
				    ActivityDialogField => $ActivityDialog->{Config}{Fields}{$CurrentField},
				    FieldName           => $DynamicFieldName,
				    DescriptionShort    => $ActivityDialog->{Config}{Fields}{$CurrentField}{DescriptionShort},
				    DescriptionLong     => $ActivityDialog->{Config}{Fields}{$CurrentField}{DescriptionLong},
				    DefaultValue        => $ActivityDialog->{Config}{Fields}{$CurrentField}{DefaultValue},
				    Ticket              => \%Ticket || {},
				    Error               => \%Error || {},
				    ErrorMessages       => \%ErrorMessages || {},
				    FormID              => $Self->{FormID},
				    GetParam            => $Param{GetParam},
				    AJAXUpdatableFields => $AJAXUpdatableFields,
                );
				
                if ( !$Response->{Success} ) {
                    # does not show header and footer again
                    if ( $Self->{IsMainWindow} ) {
                        return $LayoutObject->Error(
                            Message => $Response->{Message},
                        );
                    }
                    $LayoutObject->FatalError(
                        Message => $Response->{Message},
                    );
                }

                $Output .= $Response->{HTML};

                $RenderedFields{$CurrentField} = 1;
            }

           		# render State
           		elsif ( $Self->{NameToID}->{$CurrentField} eq 'StateID' )
            	{
		        # We don't render Fields twice,
		        # if there was already a Config without ID, skip this field
		        next DIALOGFIELD if $RenderedFields{ $Self->{NameToID}->{$CurrentField} };

		        my $Response = $Self->_RenderState(
		            ActivityDialogField => $ActivityDialog->{Config}{Fields}{$CurrentField},
		            FieldName           => $CurrentField,
		            DescriptionShort    => $ActivityDialog->{Config}{Fields}{$CurrentField}{DescriptionShort},
					    DescriptionLong     => $ActivityDialog->{Config}{Fields}{$CurrentField}{DescriptionLong},
		            Ticket              => \%Ticket || {},
		            Error               => \%Error || {},
		            FormID              => $Self->{FormID},
		            GetParam            => $Param{GetParam},
		            AJAXUpdatableFields => $AJAXUpdatableFields,
					    Action				=> $Self->{Action},
		        );
      		    $AjaxResponseJson .= $Response;
            	}

		    # render Queue
		    elsif ( $Self->{NameToID}->{$CurrentField} eq 'QueueID' )
		    {
		        next DIALOGFIELD if $RenderedFields{ $Self->{NameToID}->{$CurrentField} };

		        my $Response = $Self->_RenderQueue(
		            ActivityDialogField => $ActivityDialog->{Config}{Fields}{$CurrentField},
		            FieldName           => $CurrentField,
		            DescriptionShort    => $ActivityDialog->{Config}{Fields}{$CurrentField}{DescriptionShort},
		            DescriptionLong     => $ActivityDialog->{Config}{Fields}{$CurrentField}{DescriptionLong},
		            Ticket              => \%Ticket || {},
		            Error               => \%Error || {},
		            FormID              => $Self->{FormID},
		            GetParam            => $Param{GetParam},
		            AJAXUpdatableFields => $AJAXUpdatableFields,
		        );

		        $AjaxResponseJson .= $Response;
            	}

      		#     # render Priority
          		elsif ( $Self->{NameToID}->{$CurrentField} eq 'PriorityID' )
	            {	
             		next DIALOGFIELD if $RenderedFields{ $Self->{NameToID}->{$CurrentField} };

			    my $Response = $Self->_RenderPriority(
				    ActivityDialogField => $ActivityDialog->{Config}{Fields}{$CurrentField},
				    FieldName           => $CurrentField,
				    DescriptionShort    => $ActivityDialog->{Config}{Fields}{$CurrentField}{DescriptionShort},
				    DescriptionLong     => $ActivityDialog->{Config}{Fields}{$CurrentField}{DescriptionLong},
				    Ticket              => \%Ticket || {},
				    Error               => \%Error || {},
				    FormID              => $Self->{FormID},
				    GetParam            => $Param{GetParam},
				    AJAXUpdatableFields => $AJAXUpdatableFields,
			    );
			    $AjaxResponseJson .= $Response;
            	}

		    # render Lock
		    elsif ( $Self->{NameToID}->{$CurrentField} eq 'LockID' )
		    {
		        next DIALOGFIELD if $RenderedFields{ $Self->{NameToID}->{$CurrentField} };

		        my $Response = $Self->_RenderLock(
		            ActivityDialogField => $ActivityDialog->{Config}{Fields}{$CurrentField},
		            FieldName           => $CurrentField,
		            DescriptionShort    => $ActivityDialog->{Config}{Fields}{$CurrentField}{DescriptionShort},
		            DescriptionLong     => $ActivityDialog->{Config}{Fields}{$CurrentField}{DescriptionLong},
		            Ticket              => \%Ticket || {},
		            Error               => \%Error || {},
		            FormID              => $Self->{FormID},
		            GetParam            => $Param{GetParam},
		            AJAXUpdatableFields => $AJAXUpdatableFields,
		        );

		        $AjaxResponseJson .= $Response;
	            }

		    # render Service
		    elsif ( $Self->{NameToID}->{$CurrentField} eq 'ServiceID' )
		    {
		        next DIALOGFIELD if $RenderedFields{ $Self->{NameToID}->{$CurrentField} };

				     next DIALOGFIELD;
		        my $Response = $Self->_RenderService(
		            ActivityDialogField => $ActivityDialog->{Config}{Fields}{$CurrentField},
		            FieldName           => $CurrentField,
		            DescriptionShort    => $ActivityDialog->{Config}{Fields}{$CurrentField}{DescriptionShort},
		            DescriptionLong     => $ActivityDialog->{Config}{Fields}{$CurrentField}{DescriptionLong},
		            Ticket              => \%Ticket || {},
		            Error               => \%Error || {},
		            FormID              => $Self->{FormID},
		            GetParam            => $Param{GetParam},
		            AJAXUpdatableFields => $AJAXUpdatableFields,
		        );
      		    $AjaxResponseJson .= $Response;
            }

            # render SLA
            elsif ( $Self->{NameToID}->{$CurrentField} eq 'SLAID' )
            {
		    next DIALOGFIELD if $RenderedFields{ $Self->{NameToID}->{$CurrentField} };
		    # Pq existia o next abaixo?
		    #next DIALOGFIELD;
             	my $Response = $Self->_RenderSLA(
                    ActivityDialogField => $ActivityDialog->{Config}{Fields}{$CurrentField},
                    FieldName           => $CurrentField,
                    DescriptionShort    => $ActivityDialog->{Config}{Fields}{$CurrentField}{DescriptionShort},
                    DescriptionLong     => $ActivityDialog->{Config}{Fields}{$CurrentField}{DescriptionLong},
                    Ticket              => \%Ticket || {},
                    Error               => \%Error || {},
                    FormID              => $Self->{FormID},
                    GetParam            => $Param{GetParam},
                    AJAXUpdatableFields => $AJAXUpdatableFields,
                );

				$AjaxResponseJson .= $Response;
            }

	    # render Owner
	    elsif ( $Self->{NameToID}->{$CurrentField} eq 'OwnerID' )
	    {
		    next DIALOGFIELD if $RenderedFields{ $Self->{NameToID}->{$CurrentField} };

	            my $Response = $Self->_RenderOwner(
	                 ActivityDialogField => $ActivityDialog->{Config}{Fields}{$CurrentField},
	                 FieldName           => $CurrentField,
	                 DescriptionShort    => $ActivityDialog->{Config}{Fields}{$CurrentField}{DescriptionShort},
	                 DescriptionLong     => $ActivityDialog->{Config}{Fields}{$CurrentField}{DescriptionLong},
	                 Ticket              => \%Ticket || {},
	                 Error               => \%Error || {},
	                 FormID              => $Self->{FormID},
	                 GetParam            => $Param{GetParam},
	                 AJAXUpdatableFields => $AJAXUpdatableFields,
	             );



			    $AjaxResponseJson .= $Response;

	    }

	         # render responsible
	    elsif ( $Self->{NameToID}->{$CurrentField} eq 'ResponsibleID' )
	         {
	             next DIALOGFIELD if $RenderedFields{ $Self->{NameToID}->{$CurrentField} };

			     next DIALOGFIELD;
	             my $Response = $Self->_RenderResponsible(
	                 ActivityDialogField => $ActivityDialog->{Config}{Fields}{$CurrentField},
	                 FieldName           => $CurrentField,
	                 DescriptionShort    => $ActivityDialog->{Config}{Fields}{$CurrentField}{DescriptionShort},
	                 DescriptionLong     => $ActivityDialog->{Config}{Fields}{$CurrentField}{DescriptionLong},
	                 Ticket              => \%Ticket || {},
	                 Error               => \%Error || {},
	                 FormID              => $Self->{FormID},
	                 GetParam            => $Param{GetParam},
	                 AJAXUpdatableFields => $AJAXUpdatableFields,
	             );


		     $AjaxResponseJson .= $Response;
	         }

	         # render CustomerID
	         elsif ( $Self->{NameToID}->{$CurrentField} eq 'CustomerID' )
	         {
	             next DIALOGFIELD if $RenderedFields{ $Self->{NameToID}->{$CurrentField} };

			     next DIALOGFIELD;
	             my $Response = $Self->_RenderCustomer(
	                 ActivityDialogField => $ActivityDialog->{Config}{Fields}{$CurrentField},
	                 FieldName           => $CurrentField,
	                 DescriptionShort    => $ActivityDialog->{Config}{Fields}{$CurrentField}{DescriptionShort},
	                 DescriptionLong     => $ActivityDialog->{Config}{Fields}{$CurrentField}{DescriptionLong},
	                 Ticket              => \%Ticket || {},
	                 Error               => \%Error || {},
	                 FormID              => $Self->{FormID},
	                 GetParam            => $Param{GetParam},
	                 AJAXUpdatableFields => $AJAXUpdatableFields,
	             );

			    $AjaxResponseJson .= $Response;
	         }

	         elsif ( $CurrentField eq 'PendingTime' )
	         {

			     next DIALOGFIELD;
	             # PendingTime is just useful if we have State or StateID
	             if ( !grep {m{^(StateID|State)$}xms} @{ $ActivityDialog->{Config}{FieldOrder} } ) {
	                 my $Message = "PendingTime can just be used if State or StateID is configured for"
	                     . " the same ActivityDialog. ActivityDialog:"
	                     . " $ActivityDialog->{Config}{ActivityDialog}!";

	                 # does not show header and footer again
	                 if ( $Self->{IsMainWindow} ) {
	                     return $LayoutObject->Error(
	                         Message => $Message,
	                     );
	                 }

	                 $LayoutObject->FatalError(
	                     Message => $Message,
	                 );
	             }

	             next DIALOGFIELD if $RenderedFields{ $Self->{NameToID}->{$CurrentField} };

	             my $Response = $Self->_RenderPendingTime(
	                 ActivityDialogField => $ActivityDialog->{Config}{Fields}{$CurrentField},
	                 FieldName           => $CurrentField,
	                 DescriptionShort    => $ActivityDialog->{Config}{Fields}{$CurrentField}{DescriptionShort},
	                 DescriptionLong     => $ActivityDialog->{Config}{Fields}{$CurrentField}{DescriptionLong},
	                 Ticket              => \%Ticket || {},
	                 Error               => \%Error || {},
	                 FormID              => $Self->{FormID},
	                 GetParam            => $Param{GetParam},
	             );

	         }

	         # render Title
	         elsif ( $Self->{NameToID}->{$CurrentField} eq 'Title' ) {
	             next DIALOGFIELD if $RenderedFields{ $Self->{NameToID}->{$CurrentField} };

			     next DIALOGFIELD;
	             my $Response = $Self->_RenderTitle(
	                 ActivityDialogField => $ActivityDialog->{Config}{Fields}{$CurrentField},
	                 FieldName           => $CurrentField,
	                 DescriptionShort    => $ActivityDialog->{Config}{Fields}{$CurrentField}{DescriptionShort},
	                 DescriptionLong     => $ActivityDialog->{Config}{Fields}{$CurrentField}{DescriptionLong},
	                 Ticket              => \%Ticket || {},
	                 Error               => \%Error || {},
	                 FormID              => $Self->{FormID},
	                 GetParam            => $Param{GetParam},
	             );

	             if ( !$Response->{Success} ) {

	                 # does not show header and footer again
	                 if ( $Self->{IsMainWindow} ) {
	                     return $LayoutObject->Error(
	                         Message => $Response->{Message},
	                     );
	                 }

	                 $LayoutObject->FatalError(
	                     Message => $Response->{Message},
	                 );
	             }

	             $Output .= $Response->{HTML};

	             $RenderedFields{$CurrentField} = 1;
	         }

	         # render Article
	         elsif (
	             $Self->{NameToID}->{$CurrentField} eq 'Article'
	             )
	         {
	             next DIALOGFIELD if $RenderedFields{ $Self->{NameToID}->{$CurrentField} };

			     next DIALOGFIELD;
	             my $Response = $Self->_RenderArticle(
	                 ActivityDialogField => $ActivityDialog->{Config}{Fields}{$CurrentField},
	                 FieldName           => $CurrentField,
	                 DescriptionShort    => $ActivityDialog->{Config}{Fields}{$CurrentField}{DescriptionShort},
	                 DescriptionLong     => $ActivityDialog->{Config}{Fields}{$CurrentField}{DescriptionLong},
	                 Ticket              => \%Ticket || {},
	                 Error               => \%Error || {},
	                 FormID              => $Self->{FormID},
	                 GetParam            => $Param{GetParam},
	                 InformAgents        => $ActivityDialog->{Config}{Fields}->{Article}->{Config}->{InformAgents},
	             );

	             if ( !$Response->{Success} ) {

	                 # does not show header and footer again
	                 if ( $Self->{IsMainWindow} ) {
	                     return $LayoutObject->Error(
	                         Message => $Response->{Message},
	                     );
	                 }

	                 $LayoutObject->FatalError(
	                     Message => $Response->{Message},
	                 );
	             }

	             $Output .= $Response->{HTML};

	             $RenderedFields{$CurrentField} = 1;
	         }

	         # render Type
	         elsif ( $Self->{NameToID}->{$CurrentField} eq 'TypeID' )
	         {

			     next DIALOGFIELD;
	             # We don't render Fields twice,
	             # if there was already a Config without ID, skip this field
	             next DIALOGFIELD if $RenderedFields{ $Self->{NameToID}->{$CurrentField} };

	             my $Response = $Self->_RenderType(
	                 ActivityDialogField => $ActivityDialog->{Config}{Fields}{$CurrentField},
	                 FieldName           => $CurrentField,
	                 DescriptionShort    => $ActivityDialog->{Config}{Fields}{$CurrentField}{DescriptionShort},
	                 DescriptionLong     => $ActivityDialog->{Config}{Fields}{$CurrentField}{DescriptionLong},
	                 Ticket              => \%Ticket || {},
	                 Error               => \%Error || {},
	                 FormID              => $Self->{FormID},
	                 GetParam            => $Param{GetParam},
	                 AJAXUpdatableFields => $AJAXUpdatableFields,
	             );

	             if ( !$Response->{Success} ) {

	                 # does not show header and footer again
	                 if ( $Self->{IsMainWindow} ) {
	                     return $LayoutObject->Error(
	                         Message => $Response->{Message},
	                     );
	                 }

	                 $LayoutObject->FatalError(
	                     Message => $Response->{Message},
	                 );
	             }

	             $Output .= $Response->{HTML};

	             $RenderedFields{ $Self->{NameToID}->{$CurrentField} } = 1;
	         }
	    } #### fim do order
	}

	my $FooterCSSClass = 'Footer';

	if ( $Self->{IsAjaxRequest} ) {

		# Due to the initial loading of
		# the first ActivityDialog after Process selection
		# we have to bind the AjaxUpdate Function on
		# the selects, so we get the complete JSOnDocumentComplete code
		# and deliver it in the FooterJS block.
		# This Javascript Part is executed in
		# AgentTicketProcess.tt
		$LayoutObject->Block(
		    Name => 'FooterJS',
		);

		$FooterCSSClass = 'Centered';
	}

	# set submit button data
	my $ButtonText  = 'Submit';
	my $ButtonTitle = 'Save';
#	my $ButtonID    = 'Submit' . $ActivityDialog->{ActivityDialog};
	my $ButtonID    = 'Submit';
	if ( $ActivityDialog->{SubmitButtonText} ) {
		$ButtonText  = $ActivityDialog->{SubmitButtonText};
		$ButtonTitle = $ActivityDialog->{SubmitButtonText};
	}

	$LayoutObject->Block(
		Name => 'Footer',
		Data => {
		    FooterCSSClass => $FooterCSSClass,
		    ButtonText     => $ButtonText,
		    ButtonTitle    => $ButtonTitle,
		    ButtonID       => $ButtonID

		},
	);

	if ( $ActivityDialog->{SubmitAdviceText} ) {
	$LayoutObject->Block(
		Name => 'SubmitAdviceText',
	    	Data => {
			AdviceText => $ActivityDialog->{SubmitAdviceText},
		    },	
		);
	}

	# reload parent window
	if ( $Param{ParentReload} ) {
		$LayoutObject->Block(
		    	Name => 'ParentReload',
		);
	}

	# display regular footer only in non-ajax case
	if ( !$Self->{IsAjaxRequest} ) {
	#       $Output .= $LayoutObject->Footer( Type => $Self->{IsMainWindow} ? '' : 'Small' );
	}
	my $JsonSubject = '';
	my $JsonType = '';
	my $JsonMessage = '';
   	my %JsonReturn;
	my $AgentJsonFieldConfig;
	my $CustomerJsonFieldConfig;	
	my $JSONObject = $Kernel::OM->Get('Kernel::System::JSON');
	if($ActivityDialog->{HideArticle}){
		%JsonReturn = ('HideArticle' => $ActivityDialog->{HideArticle});
		$JsonType =  "@%@%@". $JSONObject->Encode(
						Data => \%JsonReturn,
		);
	}
	if($ActivityDialog->{TypeID}){
		%JsonReturn = ('TypeID' => $ActivityDialog->{TypeID});
		$JsonType =  "@%@%@". $JSONObject->Encode(
						Data => \%JsonReturn,
		);
	}
	if($ActivityDialog->{Subject}){
		%JsonReturn	 = ('Subject' =>  $ActivityDialog->{Subject});
		$JsonSubject = "@%@%@".$JSONObject->Encode(
								Data => \%JsonReturn,
			 				);
	}
	 $ActivityDialog->{Body} = " " if(!$ActivityDialog->{Body});
	    %JsonReturn  = ('Message' => $ActivityDialog->{Body});
		$JsonMessage = "@%@%@". $JSONObject->Encode( 
			Data => \%JsonReturn,
		);
		
	if($Kernel::OM->Get('Kernel::Config')->Get('AgentDynamicFieldByService::NameBeforeField')){
		%JsonReturn = ('AgentFieldConfig' => $Kernel::OM->Get('Kernel::Config')->Get('AgentDynamicFieldByService::NameBeforeField') );	
		$AgentJsonFieldConfig = "@%@%@".encode_json \%JsonReturn if(%JsonReturn);

	}	
	if($Kernel::OM->Get('Kernel::Config')->Get('CustomerDynamicFieldByService::NameBeforeField')){
		%JsonReturn = ('CustomerFieldConfig' => $Kernel::OM->Get('Kernel::Config')->Get('CustomerDynamicFieldByService::NameBeforeField') );	
		$CustomerJsonFieldConfig = "@%@%@".encode_json \%JsonReturn if(%JsonReturn);

	}	
	$Output .= $LayoutObject->Output(
	     Template => '[% Data.JSON %]',
	     Data         => {
							JSON => ':$$:Add:$$:{"1":"1"} ' . $JsonType . " " . $JsonSubject . " " . $JsonMessage . " " . $AgentJsonFieldConfig. " " . $CustomerJsonFieldConfig ." ".  $AjaxResponseJson,

						},
	 );

#	$Output .= ":\$\$:Add:\$\$:" . $Json . " " . $JsonSubject . " " . $JsonMessage . " " . $AgentJsonFieldConfig. " " . $CustomerJsonFieldConfig ." ".  $AjaxResponseJson;

	return $Output;
}

sub _RenderPendingTime {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(FormID)) {
        if ( !$Param{$Needed} ) {
            return {
                Success => 0,
                Message => "Got no $Needed in _RenderResponsible!",
            };
        }
    }
    if ( !IsHashRefWithData( $Param{ActivityDialogField} ) ) {
        return {
            Success => 0,
            Message => "Got no ActivityDialogField in _RenderPendingTime!",
        };
    }

    # get layout object
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    my %Data = (
        Label => (
            $LayoutObject->{LanguageObject}->Translate('Pending Date')
                . ' ('
                . $LayoutObject->{LanguageObject}->Translate('for pending* states') . ')'
        ),
        FieldID => 'ResponsibleID',
        FormID  => $Param{FormID},
    );

    my $Error = '';
    if ( IsHashRefWithData( $Param{Error} ) ) {
        if ( $Param{Error}->{'PendingtTimeDay'} ) {
            $Data{PendingtTimeDayError} = $LayoutObject->{LanguageObject}->Translate("Date invalid!");
            $Error = $Param{Error}->{'PendingtTimeDay'};
        }
        if ( $Param{Error}->{'PendingtTimeHour'} ) {
            $Data{PendingtTimeHourError} = $LayoutObject->{LanguageObject}->Translate("Date invalid!");
            $Error = $Param{Error}->{'PendingtTimeDay'};
        }
    }

    my $Calendar = '';

    # get ticket object
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

    # get used calendar if we have ticket data
    if ( IsHashRefWithData( $Param{Ticket} ) ) {
        $Calendar = $TicketObject->TicketCalendarGet(
            %{ $Param{Ticket} },
        );
    }

    $Data{Content} = $LayoutObject->BuildDateSelection(
        Prefix => 'PendingTime',
        PendingTimeRequired =>
            (
            $Param{ActivityDialogField}->{Display} && $Param{ActivityDialogField}->{Display} == 2
            ) ? 1 : 0,
        Format           => 'DateInputFormatLong',
        YearPeriodPast   => 0,
        YearPeriodFuture => 5,
        DiffTime         => $Param{ActivityDialogField}->{DefaultValue}
            || $Kernel::OM->Get('Kernel::Config')->Get('Ticket::Frontend::PendingDiffTime')
            || 86400,
        Class                => $Error,
        Validate             => 1,
        ValidateDateInFuture => 1,
        Calendar             => $Calendar,
    );

    $LayoutObject->Block(
        Name => $Param{ActivityDialogField}->{LayoutBlock} || 'rw:PendingTime',
        Data => \%Data,
    );
    if ( $Param{DescriptionShort} ) {
        $LayoutObject->Block(
            Name => $Param{ActivityDialogField}->{LayoutBlock} || 'rw:PendingTime:DescriptionShort',
            Data => {
                DescriptionShort => $Param{DescriptionShort},
            },
        );
    }

    if ( $Param{DescriptionLong} ) {
        $LayoutObject->Block(
            Name => 'rw:PendingTime:DescriptionLong',
            Data => {
                DescriptionLong => $Param{DescriptionLong},
            },
        );
    }

    return {
        Success => 1,
        HTML    => $LayoutObject->Output( TemplateFile => 'ProcessManagement/PendingTime' ),
    };
}

############ SUB ROUTINE FOR RENDERING DYNAMIC FIELDS OF THE FORM ###################
sub _RenderDynamicField {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(FormID FieldName)) {
        if ( !$Param{$Needed} ) {
            return {
                Success => 0,
                Message => "Got no $Needed in _RenderDynamicField!",
            };
        }
    }

    my $DynamicField = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldListGet(
        Valid      => 1,
        ObjectType => ['Ticket', 'Article'],
    );
    my $DynamicFieldConfig = ( grep { $_->{Name} eq $Param{FieldName} } @{$DynamicField} )[0];
    my $PossibleValuesFilter;
    # get dynamic field backend object
    my $DynamicFieldBackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');
    my $IsACLReducible = $DynamicFieldBackendObject->HasBehavior(
        DynamicFieldConfig => $DynamicFieldConfig,
        Behavior           => 'IsACLReducible',
    );
    # get ticket object
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');
    if ($IsACLReducible) {
        # get PossibleValues
        my $PossibleValues = $DynamicFieldBackendObject->PossibleValuesGet(
            DynamicFieldConfig => $DynamicFieldConfig,
        );

        # All Ticket DynamicFields
        # used for ACL checking
        my %DynamicFieldCheckParam = map { $_ => $Param{GetParam}->{DynamicField}{$_} }
            grep {m{^DynamicField_}xms} ( keys %{ $Param{GetParam}->{DynamicField} } );

        # check if field has PossibleValues property in its configuration
        if ( IsHashRefWithData($PossibleValues) ) {

            # convert possible values key => value to key => key for ACLs using a Hash slice
            my %AclData = %{$PossibleValues};
            @AclData{ keys %AclData } = keys %AclData;

            my %UserID;
            if($Self->{SessionSource} eq 'CustomerInterface'){
                $UserID{CustomerUserID} = $Self->{UserID};
            } else {
                $UserID{UserID} = $Self->{UserID};
            }
            # set possible values filter from ACLs
            my $ACL = $TicketObject->TicketAcl(
                %{ $Param{GetParam} },
                DynamicField  => \%DynamicFieldCheckParam,
                Action        => $Self->{Action},
                ReturnType    => 'Ticket',
                ReturnSubType => 'DynamicField_' . $DynamicFieldConfig->{Name},
                Data          => \%AclData,
                %UserID,
            );
            if ($ACL) {
                my %Filter = $TicketObject->TicketAclData();
                # convert Filer key => key back to key => value using map
                %{$PossibleValuesFilter} = map { $_ => $PossibleValues->{$_} } keys %Filter;
            }
        }
    }

    my $ServerError;
    if ( IsHashRefWithData( $Param{Error} ) ) {
        if (
            defined $Param{Error}->{ $Param{FieldName} }
            && $Param{Error}->{ $Param{FieldName} } ne ''
            )
        {
            $ServerError = 1;
        }
    }
    my $ErrorMessage = '';
    if ( IsHashRefWithData( $Param{ErrorMessages} ) ) {
        if (
            defined $Param{ErrorMessages}->{ $Param{FieldName} }
            && $Param{ErrorMessages}->{ $Param{FieldName} } ne ''
            )
        {
            $ErrorMessage = $Param{ErrorMessages}->{ $Param{FieldName} };
        }
    }

    # my layout object
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    my $TemplateGeneratorObject = $Kernel::OM->Get('Kernel::System::TemplateGenerator');
    my $DefaultValue = $Param{DefaultValue} || '';

    my $CustomerUserID;
    my $CustomerID;

    if ($Self->{SessionSource} && $Self->{SessionSource} eq "CustomerInterface"){
        $CustomerUserID = $Self->{UserID};
        $CustomerID    = $Self->{CustomerID};
    } elsif ($Self->{SessionSource} && $Self->{SessionSource} eq "AgentInterface") {
        $CustomerUserID = $Param{GetParam}->{SelectedCustomerUser};
        $CustomerID     = $Param{GetParam}->{CustomerID};
    }
    $DefaultValue = $TemplateGeneratorObject->_Replace(
        RichText   => 0,
        Text       => $DefaultValue,
        Data       => {},
        # Data       => \%ArticleCustomer,
        # DataAgent  => \%ArticleAgent,
        TicketData => {
            CustomerUserID => $CustomerUserID || '',
            CustomerID     => $CustomerID || '',
        },
        UserID     => $Self->{UserID},
    ) if $DefaultValue;

    my $DynamicFieldHTML = $DynamicFieldBackendObject->EditFieldRender(
        DynamicFieldConfig   => $DynamicFieldConfig,
        PossibleValuesFilter => $PossibleValuesFilter,
        Value                => $Param{GetParam}{ 'DynamicField_' . $Param{FieldName} } || $DefaultValue,
        LayoutObject         => $LayoutObject,
        ParamObject          => $Kernel::OM->Get('Kernel::System::Web::Request'),
        AJAXUpdate           => 1,
        Mandatory            => $Param{ActivityDialogField}->{Display} == 2,
        UpdatableFields      => $Param{AJAXUpdatableFields},
        ServerError          => $ServerError,
        ErrorMessage         => $ErrorMessage,
	    Class		         => "AddDFS",
    );

    my %Data = (
        Name    => $DynamicFieldConfig->{Name},
        Label   => $DynamicFieldHTML->{Label},
        Content => $DynamicFieldHTML->{Field},
    );

    $LayoutObject->Block(
        Name => $Param{ActivityDialogField}->{LayoutBlock} || 'rw:DynamicField',
        Data => \%Data,
    );

    return {
        Success => 1,
        HTML    => $LayoutObject->Output( TemplateFile => 'ProcessManagement/DynamicField' ),
    };
}

sub _RenderTitle {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(FormID)) {
        if ( !$Param{$Needed} ) {
            return {
                Success => 0,
                Message => "Got no $Needed in _RenderTitle!",
            };
        }
    }
    if ( !IsHashRefWithData( $Param{ActivityDialogField} ) ) {
        return {
            Success => 0,
            Message => "Got no ActivityDialogField in _RenderTitle!",
        };
    }

    # get layout object
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    my %Data = (
        Label            => $LayoutObject->{LanguageObject}->Translate("Title"),
        FieldID          => 'Title',
        FormID           => $Param{FormID},
        Value            => $Param{GetParam}{Title},
        Name             => 'Title',
        MandatoryClass   => '',
        ValidateRequired => '',
    );

    # If field is required put in the necessary variables for
    # ValidateRequired class input field, Mandatory class for the label
    if ( $Param{ActivityDialogField}->{Display} && $Param{ActivityDialogField}->{Display} == 2 ) {
        $Data{ValidateRequired} = 'Validate_Required';
        $Data{MandatoryClass}   = 'Mandatory';
    }

    # output server errors
    if ( IsHashRefWithData( $Param{Error} ) && $Param{Error}->{'Title'} ) {
        $Data{ServerError} = 'ServerError';
    }

    $LayoutObject->Block(
        Name => $Param{ActivityDialogField}->{LayoutBlock} || 'rw:Title',
        Data => \%Data,
    );

    # set mandatory label marker
    if ( $Data{MandatoryClass} && $Data{MandatoryClass} ne '' ) {
        $LayoutObject->Block(
            Name => 'LabelSpan',
            Data => {},
        );
    }

    if ( $Param{DescriptionShort} ) {
        $LayoutObject->Block(
            Name => $Param{ActivityDialogField}->{LayoutBlock} || 'rw:Title:DescriptionShort',
            Data => {
                DescriptionShort => $Param{DescriptionShort},
            },
        );
    }

    if ( $Param{DescriptionLong} ) {
        $LayoutObject->Block(
            Name => $Param{ActivityDialogField}->{LayoutBlock} || 'rw:Title:DescriptionLong',
            Data => {
                DescriptionLong => $Param{DescriptionLong},
            },
        );
    }

    return {
        Success => 1,
        HTML    => $LayoutObject->Output( TemplateFile => 'ProcessManagement/Title' ),
    };

}

sub _RenderArticle {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(FormID Ticket)) {
        if ( !$Param{$Needed} ) {
            return {
                Success => 0,
                Message => "Got no $Needed in _RenderArticle!",
            };
        }
    }
    if ( !IsHashRefWithData( $Param{ActivityDialogField} ) ) {
        return {
            Success => 0,
            Message => "Got no ActivityDialogField in _RenderArticle!",
        };
    }

    # get layout object
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    my %Data = (
        Name             => 'Article',
        MandatoryClass   => '',
        ValidateRequired => '',
        Subject          => $Param{GetParam}{Subject},
        Body             => $Param{GetParam}{Body},
        LabelSubject     => $Param{ActivityDialogField}->{Config}->{LabelSubject}
            || $LayoutObject->{LanguageObject}->Translate("Subject"),
        LabelBody => $Param{ActivityDialogField}->{Config}->{LabelBody}
            || $LayoutObject->{LanguageObject}->Translate("Text"),
    );

    # If field is required put in the necessary variables for
    # ValidateRequired class input field, Mandatory class for the label
    if ( $Param{ActivityDialogField}->{Display} && $Param{ActivityDialogField}->{Display} == 2 ) {
        $Data{ValidateRequired} = 'Validate_Required';
        $Data{MandatoryClass}   = 'Mandatory';
    }

    # output server errors
    if ( IsHashRefWithData( $Param{Error} ) && $Param{Error}->{'ArticleSubject'} ) {
        $Data{SubjectServerError} = 'ServerError';
    }
    if ( IsHashRefWithData( $Param{Error} ) && $Param{Error}->{'ArticleBody'} ) {
        $Data{BodyServerError} = 'ServerError';
    }

    $LayoutObject->Block(
        Name => $Param{ActivityDialogField}->{LayoutBlock} || 'rw:Article',
        Data => \%Data,
    );

    # set mandatory label marker
    if ( $Data{MandatoryClass} && $Data{MandatoryClass} ne '' ) {
        $LayoutObject->Block(
            Name => 'LabelSpanSubject',
            Data => {},
        );
        $LayoutObject->Block(
            Name => 'LabelSpanBody',
            Data => {},
        );
    }

    # add rich text editor
    if ( $LayoutObject->{BrowserRichText} ) {

        # use height/width defined for this screen
        $Param{RichTextHeight} = $Self->{Config}->{RichTextHeight} || 0;
        $Param{RichTextWidth}  = $Self->{Config}->{RichTextWidth}  || 0;

        $LayoutObject->Block(
            Name => 'RichText',
            Data => \%Param,
        );
    }

    if ( $Param{DescriptionShort} ) {
        $LayoutObject->Block(
            Name => 'rw:Article:DescriptionShort',
            Data => {
                DescriptionShort => $Param{DescriptionShort},
            },
        );
    }

    if ( $Param{DescriptionLong} ) {
        $LayoutObject->Block(
            Name => 'rw:Article:DescriptionLong',
            Data => {
                DescriptionLong => $Param{DescriptionLong},
            },
        );
    }

    if ( $Param{InformAgents} ) {

        my %ShownUsers;
        my %AllGroupsMembers = $Kernel::OM->Get('Kernel::System::User')->UserList(
            Type  => 'Long',
            Valid => 1,
        );
        my $GID = $Kernel::OM->Get('Kernel::System::Queue')->GetQueueGroupID( QueueID => $Param{Ticket}->{QueueID} );
        my %MemberList = $Kernel::OM->Get('Kernel::System::Group')->PermissionGroupGet(
            GroupID => $GID,
            Type    => 'note',
        );
        for my $UserID ( sort keys %MemberList ) {
            $ShownUsers{$UserID} = $AllGroupsMembers{$UserID};
        }
        $Param{OptionStrg} = $LayoutObject->BuildSelection(
            Data       => \%ShownUsers,
            SelectedID => '',
            Name       => 'InformUserID',
            Multiple   => 1,
            Size       => 3,
            Class      => 'Modernize AddDFS',
        );
        $LayoutObject->Block(
            Name => 'rw:Article:InformAgent',
            Data => \%Param,
        );
    }

    # get all attachments meta data
    my @Attachments = $Kernel::OM->Get('Kernel::System::Web::UploadCache')->FormIDGetAllFilesMeta(
        FormID => $Self->{FormID},
    );

    # show attachments
    ATTACHMENT:
    for my $Attachment (@Attachments) {
        if (
            $Attachment->{ContentID}
            && $LayoutObject->{BrowserRichText}
            && ( $Attachment->{ContentType} =~ /image/i )
            && ( $Attachment->{Disposition} eq 'inline' )
            )
        {
            next ATTACHMENT;
        }
        $LayoutObject->Block(
            Name => 'Attachment',
            Data => $Attachment,
        );
    }

    return {
        Success => 1,
        HTML    => $LayoutObject->Output( TemplateFile => 'ProcessManagement/Article' ),
    };
}

sub _RenderCustomer {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(FormID)) {
        if ( !$Param{$Needed} ) {
            return {
                Success => 0,
                Message => "Got no $Needed in _RenderResponsible!",
            };
        }
    }
    if ( !IsHashRefWithData( $Param{ActivityDialogField} ) ) {
        return {
            Success => 0,
            Message => "Got no ActivityDialogField in _RenderCustomer!",
        };
    }

    my %CustomerUserData = ();

    my $SubmittedCustomerUserID = $Param{GetParam}{CustomerUserID};

    # get layout object
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    my %Data = (
        LabelCustomerUser => $LayoutObject->{LanguageObject}->Translate("Customer user"),
        LabelCustomerID   => $LayoutObject->{LanguageObject}->Translate("CustomerID"),
        FormID            => $Param{FormID},
        MandatoryClass    => '',
        ValidateRequired  => '',
    );

    # If field is required put in the necessary variables for
    # ValidateRequired class input field, Mandatory class for the label
    if ( $Param{ActivityDialogField}->{Display} && $Param{ActivityDialogField}->{Display} == 2 ) {
        $Data{ValidateRequired} = 'Validate_Required';
        $Data{MandatoryClass}   = 'Mandatory';
    }

    # output server errors
    if ( IsHashRefWithData( $Param{Error} ) && $Param{Error}->{CustomerUserID} ) {
        $Data{CustomerUserIDServerError} = 'ServerError';
    }
    if ( IsHashRefWithData( $Param{Error} ) && $Param{Error}->{CustomerID} ) {
        $Data{CustomerIDServerError} = 'ServerError';
    }

    # set some customer search autocomplete properties
    $LayoutObject->Block(
        Name => 'CustomerSearchAutoComplete',
    );

    if (
        ( IsHashRefWithData( $Param{Ticket} ) && $Param{Ticket}->{CustomerUserID} )
        || $SubmittedCustomerUserID
        )
    {
        %CustomerUserData = $Kernel::OM->Get('Kernel::System::CustomerUser')->CustomerUserDataGet(
            User => $SubmittedCustomerUserID
                || $Param{Ticket}{CustomerUserID},
        );
    }

    # show customer field as "FirstName Lastname" <MailAddress>
    if ( IsHashRefWithData( \%CustomerUserData ) ) {
        $Data{CustomerUserID} = "\"$CustomerUserData{UserFirstname} " .
            "$CustomerUserData{UserLastname}\" <$CustomerUserData{UserEmail}>";
        $Data{CustomerID}           = $CustomerUserData{UserCustomerID} || '';
        $Data{SelectedCustomerUser} = $CustomerUserData{UserID}         || '';
    }

    # set fields that will get an AJAX loader icon when this field changes
    my $JSON = $LayoutObject->JSONEncode(
        Data     => $Param{AJAXUpdatableFields},
        NoQuotes => 0,
    ) || '';
    $Data{FieldsToUpdate} = $JSON;

    $LayoutObject->Block(
        Name => $Param{ActivityDialogField}->{LayoutBlock} || 'rw:Customer',
        Data => \%Data,
    );

    # set mandatory label marker
    if ( $Data{MandatoryClass} && $Data{MandatoryClass} ne '' ) {
        $LayoutObject->Block(
            Name => 'LabelSpanCustomerUser',
            Data => {},
        );
    }

    if ( $Param{DescriptionShort} ) {
        $LayoutObject->Block(
            Name => $Param{ActivityDialogField}->{LayoutBlock} || 'rw:Customer:DescriptionShort',
            Data => {
                DescriptionShort => $Param{DescriptionShort},
            },
        );
    }

    if ( $Param{DescriptionLong} ) {
        $LayoutObject->Block(
            Name => 'rw:Customer:DescriptionLong',
            Data => {
                DescriptionLong => $Param{DescriptionLong},
            },
        );
    }

    return {
        Success => 1,
        HTML    => $LayoutObject->Output( TemplateFile => 'ProcessManagement/Customer' ),
    };
}

sub _RenderResponsible {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(FormID)) {
        if ( !$Param{$Needed} ) {
            return {
                Success => 0,
                Message => "Got no $Needed in _RenderResponsible!",
            };
        }
    }
    if ( !IsHashRefWithData( $Param{ActivityDialogField} ) ) {
        return {
            Success => 0,
            Message => "Got no ActivityDialogField in _RenderResponsible!",
        };
    }

    my $Responsibles = $Self->_GetResponsibles( %{ $Param{GetParam} } );

    # get layout object
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    my %Data = (
        Label            => $LayoutObject->{LanguageObject}->Translate("Responsible"),
        FieldID          => 'ResponsibleID',
        FormID           => $Param{FormID},
        ResponsibleAll   => $Param{GetParam}{ResponsibleAll},
        MandatoryClass   => '',
        ValidateRequired => '',
    );

    my $PossibleNone = 1;

    # if field is required put in the necessary variables for
    #    ValidateRequired class input field, Mandatory class for the label
    #    do not allow empty selection
    if ( $Param{ActivityDialogField}->{Display} && $Param{ActivityDialogField}->{Display} == 2 ) {
        $Data{ValidateRequired} = 'Validate_Required';
        $Data{MandatoryClass}   = 'Mandatory';
        $PossibleNone           = 0;
    }

    my $SelectedValue;

    # get user object
    my $UserObject = $Kernel::OM->Get('Kernel::System::User');

    my $ResponsibleIDParam = $Param{GetParam}{ResponsibleID};
    $SelectedValue = $UserObject->UserLookup( UserID => $ResponsibleIDParam )
        if $ResponsibleIDParam;

    if ( $Param{ActivityDialogField}->{DefaultValue} ) {

        if ( $Param{FieldName} eq 'Responsible' ) {

            # Fetch DefaultValue from Config
            if ( !$SelectedValue ) {
                $SelectedValue = $UserObject->UserLookup(
                    User => $Param{ActivityDialogField}->{DefaultValue} || '',
                );
                if ($SelectedValue) {
                    $SelectedValue = $Param{ActivityDialogField}->{DefaultValue};
                }
            }
        }
        else {
            if ( !$SelectedValue ) {
                $SelectedValue = $UserObject->UserLookup(
                    UserID => $Param{ActivityDialogField}->{DefaultValue} || ''
                );
            }
        }
    }

    # if there is no user from GetParam or default and the field is mandatory get it from the ticket
    #    (if any)
    if (
        !$SelectedValue
        && !$PossibleNone
        && IsHashRefWithData( $Param{Ticket} )
        )
    {
        $SelectedValue = $Param{Ticket}->{Responsible};
    }

    # use current user as fallback, for all other cases where there is still no user
    elsif ( !$SelectedValue ) {
        $SelectedValue = $UserObject->UserLookup( UserID => $Self->{UserID} );
    }

    # if we have a user already and the field is not mandatory and it is the same as in ticket, then
    #    set it to none (as it doesn't need to be changed afterall)
    elsif (
        $SelectedValue
        && $PossibleNone
        && IsHashRefWithData( $Param{Ticket} )
        && $SelectedValue eq $Param{Ticket}->{Responsible}
        )
    {
        $SelectedValue = '';
    }

    # set server errors
    my $ServerError = '';
    if ( IsHashRefWithData( $Param{Error} ) && $Param{Error}->{'ResponsibleID'} ) {
        $ServerError = 'ServerError';
    }

    # look up $SelectedID
    my $SelectedID;
    if ($SelectedValue) {
        $SelectedID = $UserObject->UserLookup(
            UserLogin => $SelectedValue,
        );
    }

    # build Responsible string
    $Data{Content} = $LayoutObject->BuildSelection(
        Data         => $Responsibles,
        Name         => 'ResponsibleID',
        Translation  => 1,
        SelectedID   => $SelectedID,
        Class        => "Modernize $ServerError AddDFS",
        PossibleNone => $PossibleNone,
    );

    $LayoutObject->Block(
        Name => $Param{ActivityDialogField}->{LayoutBlock} || 'rw:Responsible',
        Data => \%Data,
    );

    # set mandatory label marker
    if ( $Data{MandatoryClass} && $Data{MandatoryClass} ne '' ) {
        $LayoutObject->Block(
            Name => 'LabelSpan',
            Data => {},
        );
    }

    if ( $Param{DescriptionShort} ) {
        $LayoutObject->Block(
            Name => $Param{ActivityDialogField}->{LayoutBlock} || 'rw:Responsible:DescriptionShort',
            Data => {
                DescriptionShort => $Param{DescriptionShort},
            },
        );
    }

    if ( $Param{DescriptionLong} ) {
        $LayoutObject->Block(
            Name => 'rw:Responsible:DescriptionLong',
            Data => {
                DescriptionLong => $Param{DescriptionLong},
            },
        );
    }
    my $Output;
    my %JsonReturn = ('ResponsibleID' => $SelectedValue);
    my $Json = encode_json \%JsonReturn;
    $Output .= '@%@%@'.$Json;
    return $Output;

    return {
        Success => 1,
        HTML    => $LayoutObject->Output( TemplateFile => 'ProcessManagement/Responsible' ),
    };

}

sub _RenderOwner {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(FormID)) {
        if ( !$Param{$Needed} ) {
            return {
                Success => 0,
                Message => "Got no $Needed in _RenderOwner!",
            };
        }
    }
    if ( !IsHashRefWithData( $Param{ActivityDialogField} ) ) {
        return {
            Success => 0,
            Message => "Got no ActivityDialogField in _RenderOwner!",
        };
    }

    my $Owners = $Self->_GetOwners( %{ $Param{GetParam} } );

    # get layout object
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    my %Data = (
        Label            => $LayoutObject->{LanguageObject}->Translate("Owner"),
        FieldID          => 'OwnerID',
        FormID           => $Param{FormID},
        OwnerAll         => $Param{GetParam}{OwnerAll},
        MandatoryClass   => '',
        ValidateRequired => '',
    );

    my $PossibleNone = 1;

    # if field is required put in the necessary variables for
    #    ValidateRequired class input field, Mandatory class for the label
    #    do not allow empty selection
    if ( $Param{ActivityDialogField}->{Display} && $Param{ActivityDialogField}->{Display} == 2 ) {
        $Data{ValidateRequired} = 'Validate_Required';
        $Data{MandatoryClass}   = 'Mandatory';
        $PossibleNone           = 0;
    }

    my $SelectedValue;

    # get user object
    my $UserObject = $Kernel::OM->Get('Kernel::System::User');

    my $OwnerIDParam = $Param{GetParam}{OwnerID};
    if ($OwnerIDParam) {
        $SelectedValue = $UserObject->UserLookup(
            UserID => $OwnerIDParam,
        );
    }

    if ( $Param{ActivityDialogField}->{DefaultValue} ) {

        if ( $Param{FieldName} eq 'Owner' ) {

            if ( !$SelectedValue ) {

                # Fetch DefaultValue from Config
                $SelectedValue = $UserObject->UserLookup(
                    User => $Param{ActivityDialogField}->{DefaultValue},
                );
                if ($SelectedValue) {
                    $SelectedValue = $Param{ActivityDialogField}->{DefaultValue};
                }
            }
        }
        else {
            if ( !$SelectedValue ) {
                $SelectedValue = $UserObject->UserLookup(
                    UserID => $Param{ActivityDialogField}->{DefaultValue},
                );
            }
        }
    }

    # if there is no user from GetParam or default and the field is mandatory get it from the ticket
    #    (if any)
    if (
        !$SelectedValue
        && !$PossibleNone
        && IsHashRefWithData( $Param{Ticket} )
        )
    {
        $SelectedValue = $Param{Ticket}->{Owner};
    }

    # use current user as fallback, for all other cases where there is still no user
    elsif ( !$SelectedValue ) {
        $SelectedValue = $UserObject->UserLookup( UserID => $Self->{UserID} );
    }

    # if we have a user already and the field is not mandatory and it is the same as in ticket, then
    #    set it to none (as it doesn't need to be changed afterall)
    elsif (
        $SelectedValue
        && $PossibleNone
        && IsHashRefWithData( $Param{Ticket} )
        && $SelectedValue eq $Param{Ticket}->{Owner}
        )
    {
        $SelectedValue = '';
    }

    # set server errors
    my $ServerError = '';
    if ( IsHashRefWithData( $Param{Error} ) && $Param{Error}->{'OwnerID'} ) {
        $ServerError = 'ServerError';
    }

    # look up $SelectedID
    my $SelectedID;
    if ($SelectedValue) {
        $SelectedID = $UserObject->UserLookup(
            UserLogin => $SelectedValue,
        );
    }

    # build Owner string
    $Data{Content} = $LayoutObject->BuildSelection(
        Data         => $Owners,
        Name         => 'OwnerID',
        Translation  => 1,
        SelectedID   => $SelectedID || '',
        Class        => "Modernize $ServerError AddDFS",
        PossibleNone => $PossibleNone,
    );

    $LayoutObject->Block(
        Name => $Param{ActivityDialogField}->{LayoutBlock} || 'rw:Owner',
        Data => \%Data,
    );

    # set mandatory label marker
    if ( $Data{MandatoryClass} && $Data{MandatoryClass} ne '' ) {
        $LayoutObject->Block(
            Name => 'LabelSpan',
            Data => {},
        );
    }

    if ( $Param{DescriptionShort} ) {
        $LayoutObject->Block(
            Name => $Param{ActivityDialogField}->{LayoutBlock} || 'rw:Owner:DescriptionShort',
            Data => {
                DescriptionShort => $Param{DescriptionShort},
            },
        );
    }

    if ( $Param{DescriptionLong} ) {
        $LayoutObject->Block(
            Name => 'rw:Owner:DescriptionLong',
            Data => {
                DescriptionLong => $Param{DescriptionLong},
            },
        );
    }
    my $Output;
    my %JsonReturn = ('OwnerID' => $SelectedValue);
    my $Json = encode_json \%JsonReturn;
    $Output .= '@%@%@'.$Json;
    return $Output;
}

sub _RenderSLA {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(FormID)) {
        if ( !$Param{$Needed} ) {
            return {
                Success => 0,
                Message => "Got no $Needed in _RenderSLA!",
            };
        }
    }
    if ( !IsHashRefWithData( $Param{ActivityDialogField} ) ) {
        return {
            Success => 0,
            Message => "Got no ActivityDialogField in _RenderSLA!",
        };
    }

    # create a local copy of the GetParam
    my %GetServicesParam = %{ $Param{GetParam} };

    # use ticket information as a fall back if customer was already set, otherwise when the
    # activity dialog displays the service list will be initially empty, see bug#10059
    if ( IsHashRefWithData( $Param{Ticket} ) ) {
        $GetServicesParam{CustomerUserID} ||= $Param{Ticket}->{CustomerUserID} ||= '';
    }

    my $Services = $Self->_GetServices(
        %GetServicesParam,
    );

    my $SLAs = $Self->_GetSLAs(
        %{ $Param{GetParam} },
        Services => $Services,
    );

    # get layout object
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # get SLA object
    my $SLAObject = $Kernel::OM->Get('Kernel::System::SLA');

    my $SLAIDParam = $Param{GetParam}{SLAID};
    
	if (!$SLAIDParam) {
		$SLAIDParam = $SLAObject->SLALookup( Name => $Param{ActivityDialogField}->{DefaultValue} );
	}
	my $Output;
    my %JsonReturn = ('SLAID' => $SLAIDParam);
    my $Json = encode_json \%JsonReturn;
    $Output .= '@%@%@'.$Json;
    return $Output;
}

sub _RenderService {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(FormID)) {
        if ( !$Param{$Needed} ) {
            return {
                Success => 0,
                Message => "Got no $Needed in _RenderService!",
            };
        }
    }
    if ( !IsHashRefWithData( $Param{ActivityDialogField} ) ) {
        return {
            Success => 0,
            Message => "Got no ActivityDialogField in _RenderService!"
        };
    }

    # create a local copy of the GetParam
    my %GetServicesParam = %{ $Param{GetParam} };

    # use ticket information as a fall back if customer was already set, otherwise when the
    # activity dialog displays the service list will be initially empty, see bug#10059
    if ( IsHashRefWithData( $Param{Ticket} ) ) {
        $GetServicesParam{CustomerUserID} ||= $Param{Ticket}->{CustomerUserID} ||= '';
    }

    my $Services = $Self->_GetServices(
        %GetServicesParam,
    );

    # get layout object
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    my %Data = (
        Label            => $LayoutObject->{LanguageObject}->Translate("Service"),
        FieldID          => 'ServiceID',
        FormID           => $Param{FormID},
        MandatoryClass   => '',
        ValidateRequired => '',
    );

    # If field is required put in the necessary variables for
    # ValidateRequired class input field, Mandatory class for the label
    if ( $Param{ActivityDialogField}->{Display} && $Param{ActivityDialogField}->{Display} == 2 ) {
        $Data{ValidateRequired} = 'Validate_Required';
        $Data{MandatoryClass}   = 'Mandatory';
    }

    my $SelectedValue;

    # get service object
    my $ServiceObject = $Kernel::OM->Get('Kernel::System::Service');

    my $ServiceIDParam = $Param{GetParam}{ServiceID};
    if ($ServiceIDParam) {
        $SelectedValue = $ServiceObject->ServiceLookup(
            ServiceID => $ServiceIDParam,
        );
    }

    if ( $Param{FieldName} eq 'Service' ) {

        if ( !$SelectedValue ) {

            # Fetch DefaultValue from Config
            if (
                defined $Param{ActivityDialogField}->{DefaultValue}
                && $Param{ActivityDialogField}->{DefaultValue} ne ''
                )
            {
                $SelectedValue = $ServiceObject->ServiceLookup(
                    Name => $Param{ActivityDialogField}->{DefaultValue},
                );
            }
            if ($SelectedValue) {
                $SelectedValue = $Param{ActivityDialogField}->{DefaultValue};
            }
        }
    }
    else {
        if ( !$SelectedValue ) {
            if (
                defined $Param{ActivityDialogField}->{DefaultValue}
                && $Param{ActivityDialogField}->{DefaultValue} ne ''
                )
            {
                $SelectedValue = $ServiceObject->ServiceLookup(
                    Service => $Param{ActivityDialogField}->{DefaultValue},
                );
            }
        }
    }

    # Get TicketValue
    if ( IsHashRefWithData( $Param{Ticket} ) && !$SelectedValue ) {
        $SelectedValue = $Param{Ticket}->{Service};
    }

    # set server errors
    my $ServerError = '';
    if ( IsHashRefWithData( $Param{Error} ) && $Param{Error}->{'ServiceID'} ) {
        $ServerError = 'ServerError';
    }

    # get list type
    my $TreeView = 0;
    if ( $Kernel::OM->Get('Kernel::Config')->Get('Ticket::Frontend::ListType') eq 'tree' ) {
        $TreeView = 1;
    }

    # build Service string
    $Data{Content} = $LayoutObject->BuildSelection(
        Data          => $Services,
        Name          => 'ServiceID',
        Class         => "Modernize $ServerError AddDFS",
        SelectedValue => $SelectedValue,
        PossibleNone  => 1,
        TreeView      => $TreeView,
        Sort          => 'TreeView',
        Translation   => 0,
        Max           => 200,
    );

    $LayoutObject->Block(
        Name => $Param{ActivityDialogField}->{LayoutBlock} || 'rw:Service',
        Data => \%Data,
    );

    # set mandatory label marker
    if ( $Data{MandatoryClass} && $Data{MandatoryClass} ne '' ) {
        $LayoutObject->Block(
            Name => 'LabelSpan',
            Data => {},
        );
    }

    if ( $Param{DescriptionShort} ) {
        $LayoutObject->Block(
            Name => $Param{ActivityDialogField}->{LayoutBlock} || 'rw:Service:DescriptionShort',
            Data => {
                DescriptionShort => $Param{DescriptionShort},
            },
        );
    }

    if ( $Param{DescriptionLong} ) {
        $LayoutObject->Block(
            Name => 'rw:Service:DescriptionLong',
            Data => {
                DescriptionLong => $Param{DescriptionLong},
            },
        );
    }
my $Output;
    my %JsonReturn = ('ServiceID' => $SelectedValue);
    my $Json = encode_json \%JsonReturn;
    $Output .= '@%@%@'.$Json;
    return $Output;

    return {
        Success => 1,
        HTML    => $LayoutObject->Output( TemplateFile => 'ProcessManagement/Service' ),
    };

}

sub _RenderLock {

    # for lock states there's no ACL checking yet implemented so no checking...

    my ( $Self, %Param ) = @_;

    for my $Needed (qw(FormID)) {
        if ( !$Param{$Needed} ) {
            return {
                Success => 0,
                Message => "Got no $Needed in _RenderLock!",
            };
        }
    }
    if ( !IsHashRefWithData( $Param{ActivityDialogField} ) ) {
        return {
            Success => 0,
            Message => "Got no ActivityDialogField in _RenderLock!",
        };
    }

    my $Locks = $Self->_GetLocks(
        %{ $Param{GetParam} },
    );

    # get layout object
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    my %Data = (
        Label            => $LayoutObject->{LanguageObject}->Translate("Lock state"),
        FieldID          => 'LockID',
        FormID           => $Param{FormID},
        MandatoryClass   => '',
        ValidateRequired => '',
    );

    # If field is required put in the necessary variables for
    # ValidateRequired class input field, Mandatory class for the label
    if ( $Param{ActivityDialogField}->{Display} && $Param{ActivityDialogField}->{Display} == 2 ) {
        $Data{ValidateRequired} = 'Validate_Required';
        $Data{MandatoryClass}   = 'Mandatory';
    }

    my $SelectedValue;

    # get lock object
    my $LockObject = $Kernel::OM->Get('Kernel::System::Lock');

    my $LockIDParam = $Param{GetParam}{LockID};
    $SelectedValue = $LockObject->LockLookup( LockID => $LockIDParam )
        if ($LockIDParam);

    if ( $Param{FieldName} eq 'Lock' ) {

        if ( !$SelectedValue ) {

            # Fetch DefaultValue from Config
            $SelectedValue = $LockObject->LockLookup(
                Lock => $Param{ActivityDialogField}->{DefaultValue} || '',
            );
            if ($SelectedValue) {
                $SelectedValue = $Param{ActivityDialogField}->{DefaultValue};
            }
        }
    }
    else {
        $SelectedValue = $LockObject->LockLookup(
            LockID => $Param{ActivityDialogField}->{DefaultValue} || ''
            )
            if !$SelectedValue;
    }

    # Get TicketValue
    if ( IsHashRefWithData( $Param{Ticket} ) && !$SelectedValue ) {
        $SelectedValue = $Param{Ticket}->{Lock};
    }

    # set server errors
    my $ServerError = '';
    if ( IsHashRefWithData( $Param{Error} ) && $Param{Error}->{'LockID'} ) {
        $ServerError = 'ServerError';
    }

    # build lock string
    $Data{Content} = $LayoutObject->BuildSelection(
        Data          => $Locks,
        Name          => 'LockID',
        Translation   => 1,
        SelectedValue => $SelectedValue,
        Class         => "Modernize $ServerError AddDFS",
    );


    $LayoutObject->Block(
        Name => $Param{ActivityDialogField}->{LayoutBlock} || 'rw:Lock',
        Data => \%Data,
    );

    # set mandatory label marker
    if ( $Data{MandatoryClass} && $Data{MandatoryClass} ne '' ) {
        $LayoutObject->Block(
            Name => 'LabelSpan',
            Data => {},
        );
    }

    if ( $Param{DescriptionShort} ) {
        $LayoutObject->Block(
            Name => $Param{ActivityDialogField}->{LayoutBlock} || 'rw:Lock:DescriptionShort',
            Data => {
                DescriptionShort => $Param{DescriptionShort},
            },
        );
    }

    if ( $Param{DescriptionLong} ) {
        $LayoutObject->Block(
            Name => 'rw:Lock:DescriptionLong',
            Data => {
                DescriptionLong => $Param{DescriptionLong},
            },
        );
    }
    my $Output;
    my %JsonReturn = ('LockID' => $SelectedValue);
    my $Json = encode_json \%JsonReturn;
    $Output .= '@%@%@'.$Json;
    return $Output;
  
    return {
        Success => 1,
        HTML    => $LayoutObject->Output( TemplateFile => 'ProcessManagement/Lock' ),
    };
}

sub _RenderPriority {
    my ( $Self, %Param ) = @_;
    for my $Needed (qw(FormID)) {
        if ( !$Param{$Needed} ) {
            return {
                Success => 0,
                Message => "Got no $Needed in _RenderPriority!",
            };
        }
    }
    if ( !IsHashRefWithData( $Param{ActivityDialogField} ) ) {
        return {
            Success => 0,
            Message => "Got no ActivityDialogField in _RenderPriority!",
        };
    }
    my $Priorities = $Self->_GetPriorities(
        %{ $Param{GetParam} },
    );

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $SelectedValue;
    # get priority object
    my $PriorityObject = $Kernel::OM->Get('Kernel::System::Priority');
	$SelectedValue = $PriorityObject->PriorityLookup(
		Priority => $Param{ActivityDialogField}->{DefaultValue} || '',
	);
	my $Output;
	my %JsonReturn = ('PriorityID' => $SelectedValue);
	my $Json = encode_json \%JsonReturn;
	$Output .= '@%@%@'.$Json;
	return $Output;
}

sub _RenderQueue {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(FormID)) {
        if ( !$Param{$Needed} ) {
            return {
                Success => 0,
                Message => "Got no $Needed in _RenderQueue!",
            };
        }
    }
    if ( !IsHashRefWithData( $Param{ActivityDialogField} ) ) {
        return {
            Success => 0,
            Message => "Got no ActivityDialogField in _RenderQueue!",
        };
    }

    my $Queues = $Self->_GetQueues(
        %{ $Param{GetParam} },
    );

    # get layout object
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    my %Data = (
        Label            => $LayoutObject->{LanguageObject}->Translate("To queue"),
        FieldID          => 'QueueID',
        FormID           => $Param{FormID},
        MandatoryClass   => '',
        ValidateRequired => '',
    );

    # If field is required put in the necessary variables for
    # ValidateRequired class input field, Mandatory class for the label
    if ( $Param{ActivityDialogField}->{Display} && $Param{ActivityDialogField}->{Display} == 2 ) {
        $Data{ValidateRequired} = 'Validate_Required';
        $Data{MandatoryClass}   = 'Mandatory';
    }
    my $SelectedValue;

    # get queue object
    my $QueueObject = $Kernel::OM->Get('Kernel::System::Queue');

    # if we got QueueID as Param from the GUI
    my $QueueIDParam = $Param{GetParam}{QueueID};
    if ($QueueIDParam) {
        $SelectedValue = $QueueObject->QueueLookup(
            QueueID => $QueueIDParam,
        );
    }

    if ( $Param{FieldName} eq 'Queue' ) {

        if ( !$SelectedValue ) {

            # Fetch DefaultValue from Config
            $SelectedValue = $QueueObject->QueueLookup(
                Queue => $Param{ActivityDialogField}->{DefaultValue} || '',
            );
            if ($SelectedValue) {
                $SelectedValue = $Param{ActivityDialogField}->{DefaultValue};
            }
        }
    }
    else {
        if ( !$SelectedValue ) {
            $SelectedValue = $QueueObject->QueueLookup(
                QueueID => $Param{ActivityDialogField}->{DefaultValue} || '',
            );
        }
    }

    # Get TicketValue
    if ( IsHashRefWithData( $Param{Ticket} ) && !$SelectedValue ) {
        $SelectedValue = $Param{Ticket}->{Queue};
    }

    # set server errors
    my $ServerError = '';
    if ( IsHashRefWithData( $Param{Error} ) && $Param{Error}->{'QueueID'} ) {
        $ServerError = 'ServerError';
    }

    # get list type
    my $TreeView = 0;
    if ( $Kernel::OM->Get('Kernel::Config')->Get('Ticket::Frontend::ListType') eq 'tree' ) {
        $TreeView = 1;
    }

    # build next queues string
    $Data{Content} = $LayoutObject->BuildSelection(
        Data          => $Queues,
        Name          => 'QueueID',
        Translation   => 1,
        SelectedValue => $SelectedValue,
        Class         => "Modernize $ServerError",
        TreeView      => $TreeView,
        Sort          => 'TreeView',
        PossibleNone  => 1,
    );

    $LayoutObject->Block(
        Name => $Param{ActivityDialogField}->{LayoutBlock} || 'rw:Queue',
        Data => \%Data,
    );

    # set mandatory label marker
    if ( $Data{MandatoryClass} && $Data{MandatoryClass} ne '' ) {
        $LayoutObject->Block(
            Name => 'LabelSpan',
            Data => {},
        );
    }

    if ( $Param{DescriptionShort} ) {
        $LayoutObject->Block(
            Name => $Param{ActivityDialogField}->{LayoutBlock} || 'rw:Queue:DescriptionShort',
            Data => {
                DescriptionShort => $Param{DescriptionShort},
            },
        );
    }

    if ( $Param{DescriptionLong} ) {
        $LayoutObject->Block(
            Name => 'rw:Queue:DescriptionLong',
            Data => {
                DescriptionLong => $Param{DescriptionLong},
            },
        );
    }

	my $Output;
	my $QueueIDSelected = $QueueObject->QueueLookup( Queue => $SelectedValue );
	my %JsonReturn = ('Dest' => $QueueIDSelected ."||". $SelectedValue);
	my $Json = encode_json \%JsonReturn;
	$Output .= '@%@%@'.$Json;
	return $Output;
}

sub _RenderState {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(FormID)) {
        if ( !$Param{$Needed} ) {
            return {
                Success => 0,
                Message => "Got no $Needed in _RenderState!",
            };
        }
    }
    if ( !IsHashRefWithData( $Param{ActivityDialogField} ) ) {
        return {
            Success => 0,
            Message => "Got no ActivityDialogField in _RenderState!",
        };
    }

    my $States = $Self->_GetStates( %{ $Param{GetParam} } );

    # get layout object
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    my $SelectedValue;

    # get state object
    my $StateObject = $Kernel::OM->Get('Kernel::System::State');
    $SelectedValue = $StateObject->StateLookup(
        State => $Param{ActivityDialogField}->{DefaultValue} || '',
    );

	my $Output;
	my %JsonReturn = ('NextStateID' => $SelectedValue);
	my $Json = encode_json \%JsonReturn;
	$Output .= '@%@%@'.$Json;
	return $Output;
}

sub _RenderType {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(FormID)) {
        if ( !$Param{$Needed} ) {
            return {
                Success => 0,
                Message => "Got no $Needed in _RenderType!",
            };
        }
    }
    if ( !IsHashRefWithData( $Param{ActivityDialogField} ) ) {
        return {
            Success => 0,
            Message => "Got no ActivityDialogField in _RenderType!"
        };
    }

    my $Types = $Self->_GetTypes(
        %{ $Param{GetParam} },
    );

    # get layout object
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    my %Data = (
        Label            => $LayoutObject->{LanguageObject}->Translate("Type"),
        FieldID          => 'TypeID',
        FormID           => $Param{FormID},
        MandatoryClass   => '',
        ValidateRequired => '',
    );

    # If field is required put in the necessary variables for
    # ValidateRequired class input field, Mandatory class for the label
    if ( $Param{ActivityDialogField}->{Display} && $Param{ActivityDialogField}->{Display} == 2 ) {
        $Data{ValidateRequired} = 'Validate_Required';
        $Data{MandatoryClass}   = 'Mandatory';
    }

    my $SelectedValue;

    # get type object
    my $TypeObject = $Kernel::OM->Get('Kernel::System::Type');

    my $TypeIDParam = $Param{GetParam}{TypeID};
    if ($TypeIDParam) {
        $SelectedValue = $TypeObject->TypeLookup(
            TypeID => $TypeIDParam,
        );
    }

    if ( $Param{FieldName} eq 'Type' ) {

        if ( !$SelectedValue ) {

            # Fetch DefaultValue from Config
            if (
                defined $Param{ActivityDialogField}->{DefaultValue}
                && $Param{ActivityDialogField}->{DefaultValue} ne ''
                )
            {
                $SelectedValue = $TypeObject->TypeLookup(
                    Type => $Param{ActivityDialogField}->{DefaultValue},
                );
            }
            if ($SelectedValue) {
                $SelectedValue = $Param{ActivityDialogField}->{DefaultValue};
            }
        }
    }
    else {
        if ( !$SelectedValue ) {
            if (
                defined $Param{ActivityDialogField}->{DefaultValue}
                && $Param{ActivityDialogField}->{DefaultValue} ne ''
                )
            {
                $SelectedValue = $TypeObject->TypeLookup(
                    Type => $Param{ActivityDialogField}->{DefaultValue},
                );
            }
        }
    }

    # Get TicketValue
    if ( IsHashRefWithData( $Param{Ticket} ) && !$SelectedValue ) {
        $SelectedValue = $Param{Ticket}->{Type};
    }

    # set server errors
    my $ServerError = '';
    if ( IsHashRefWithData( $Param{Error} ) && $Param{Error}->{'TypeID'} ) {
        $ServerError = 'ServerError';
    }

    # build Service string
    $Data{Content} = $LayoutObject->BuildSelection(
        Data          => $Types,
        Name          => 'TypeID',
        Class         => "Modernize $ServerError",
        SelectedValue => $SelectedValue,
        PossibleNone  => 1,
        Sort          => 'AlphanumericValue',
        Translation   => 0,
        Max           => 200,
    );


    $LayoutObject->Block(
        Name => $Param{ActivityDialogField}->{LayoutBlock} || 'rw:Type',
        Data => \%Data,
    );

    # set mandatory label marker
    if ( $Data{MandatoryClass} && $Data{MandatoryClass} ne '' ) {
        $LayoutObject->Block(
            Name => 'LabelSpan',
            Data => {},
        );
    }

    if ( $Param{DescriptionShort} ) {
        $LayoutObject->Block(
            Name => $Param{ActivityDialogField}->{LayoutBlock} || 'rw:Type:DescriptionShort',
            Data => {
                DescriptionShort => $Param{DescriptionShort},
            },
        );
    }

    if ( $Param{DescriptionLong} ) {
        $LayoutObject->Block(
            Name => 'rw:Type:DescriptionLong',
            Data => {
                DescriptionLong => $Param{DescriptionLong},
            },
        );
    }
	my $Output;
    my %JsonReturn = ('TypeID' =>  $SelectedValue);
    my $Json = encode_json \%JsonReturn;
    	$Output .= '@%@%@'.$Json;
         return $Output;
  
#    return {
#        Success => 1,
#        HTML    => $LayoutObject->Output( TemplateFile => 'ProcessManagement/Type' ),
#    };
}


sub _GetParam {
    my ( $Self, %Param ) = @_;
    # get layout object
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    for my $Needed (qw(ServiceDynamicID)) {
        if ( !$Param{$Needed} ) {
            $LayoutObject->FatalError( Message => "Got no $Needed in _GetParam!" );
        }
    }

    # get param object
    my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $DfByServiceObject = $Kernel::OM->Get('Kernel::System::DynamicFieldByService');
    my %GetParam;
    my %Ticket;
    my $ServiceDynamicID        = $Param{ServiceDynamicID};
	my $InterfaceName 			= $Param{InterfaceName};    
    my $TicketID               = $ParamObject->GetParam( Param => 'TicketID' );
    my $ActivityDialogEntityID = $ParamObject->GetParam(
        Param => 'ActivityDialogEntityID',
    );
    my $ActivityEntityID;
    my %ValuesGotten;
    my $Value;
    my 	$ActivityDialog =  $DfByServiceObject->GetDynamicFieldByService(ServiceID => $ServiceDynamicID );
    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');


    DIALOGFIELD:
    for my $CurrentField ( @{ $ActivityDialog->{FieldOrder} } ) {
        # Skip if we're working on a field that was already done with or without ID
        if ( $Self->{NameToID}{$CurrentField} && $ValuesGotten{ $Self->{NameToID}{$CurrentField} } )
        {
            next DIALOGFIELD;
        }

        if ( $CurrentField =~ m{^DynamicField_(.*)}xms ) {
            my $DynamicFieldName = $1;

            my $DynamicField = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldListGet(
                Valid      => 1,
                ObjectType => 'Ticket',
            );

            # Get the Config of the current DynamicField (the first element of the grep result array)
            my $DynamicFieldConfig = ( grep { $_->{Name} eq $DynamicFieldName } @{$DynamicField} )[0];

            if ( !IsHashRefWithData($DynamicFieldConfig) ) {
                my $Message = "DynamicFieldConfig missing for field: $DynamicFieldName!";

                # does not show header and footer again
                if ( $Self->{IsMainWindow} ) {
                    return $LayoutObject->Error(
                        Message => $Message,
                    );
                }

                $LayoutObject->FatalError(
                    Message => $Message,
                );
            }

            # Get DynamicField Values
            $Value = $Kernel::OM->Get('Kernel::System::DynamicField::Backend')->EditFieldValueGet(
                DynamicFieldConfig => $DynamicFieldConfig,
                ParamObject        => $ParamObject,
                LayoutObject       => $LayoutObject,
            );

            # If we got a submitted param, take it and next out
            if (
                defined $Value
                && (
                    $Value eq ''
                    || IsStringWithData($Value)
                    || IsArrayRefWithData($Value)
                    || IsHashRefWithData($Value)
                )
                )
            {
                $GetParam{$CurrentField} = $Value;
                next DIALOGFIELD;
            }

            # If we didn't have a Param Value try the ticket Value
            # next out if it was successful
            if (
                defined $Ticket{$CurrentField}
                && (
                    $Ticket{$CurrentField} eq ''
                    || IsStringWithData( $Ticket{$CurrentField} )
                    || IsArrayRefWithData( $Ticket{$CurrentField} )
                    || IsHashRefWithData( $Ticket{$CurrentField} )
                )
                )
            {
                $GetParam{$CurrentField} = $Ticket{$CurrentField};
                next DIALOGFIELD;
            }

            # If we had neighter submitted nor ticket param get the ActivityDialog's default Value
            # next out if it was successful
            $Value = $ActivityDialog->{Fields}{$CurrentField}{DefaultValue};
            if ($Value) {
                $GetParam{$CurrentField} = $Value;
                next DIALOGFIELD;
            }

            # If we had no submitted, ticket or ActivityDialog default value
            # use the DynamicField's default value and next out
            $Value = $DynamicFieldConfig->{Config}{DefaultValue};
            if ($Value) {
                $GetParam{$CurrentField} = $Value;
                next DIALOGFIELD;
            }

            # if all that failed then the field should not have a defined value otherwise
            # if a value (even empty) is sent, fields like Date or DateTime will mark the field as
            # used with the field display value, this could lead to unwanted field sets,
            # see bug#9159
            next DIALOGFIELD;
        }

        # get article fields
        if ( $CurrentField eq 'Article' ) {

            $GetParam{Subject} = $ParamObject->GetParam( Param => 'Subject' );
            $GetParam{Body}    = $ParamObject->GetParam( Param => 'Body' );
            @{ $GetParam{InformUserID} } = $ParamObject->GetArray(
                Param => 'InformUserID',
            );

            $ValuesGotten{Article} = 1 if ( $GetParam{Subject} && $GetParam{Body} );
        }

        if ( $CurrentField eq 'CustomerID' ) {
            $GetParam{Customer} = $ParamObject->GetParam(
                Param => 'SelectedCustomerUser',
            ) || '';
            $GetParam{CustomerUserID} = $ParamObject->GetParam(
                Param => 'SelectedCustomerUser',
            ) || '';
        }

        if ( $CurrentField eq 'PendingTime' ) {
            my $Prefix = 'PendingTime';

            # Ok, we need to try to find the target state now
            my %StateData;

            # get state object
            my $StateObject = $Kernel::OM->Get('Kernel::System::State');

            # Was something submitted from the GUI?
            my $TargetStateID = $ParamObject->GetParam( Param => 'StateID' );
            if ($TargetStateID) {
                %StateData = $StateObject->StateGet(
                    ID => $TargetStateID,
                );
            }

            # Fallback 1: default value of dialog field State
            if ( !%StateData && $ActivityDialog->{Fields}{State}{DefaultValue} ) {
                %StateData = $StateObject->StateGet(
                    Name => $ActivityDialog->{Fields}{State}{DefaultValue},
                );
            }

            # Fallback 2: default value of dialog field StateID
            if ( !%StateData && $ActivityDialog->{Fields}{StateID}{DefaultValue} ) {
                %StateData = $StateObject->StateGet(
                    ID => $ActivityDialog->{Fields}{StateID}{DefaultValue},
                );
            }

            # Fallback 3: existing ticket state
            if ( !%StateData && %Ticket ) {
                %StateData = $StateObject->StateGet(
                    ID => $Ticket{StateID},
                );
            }

            # get pending time values
            # depends on StateType containing '^pending'
            if (
                IsHashRefWithData( \%StateData )
                && $StateData{TypeName}
                && $StateData{TypeName} =~ /^pending/i
                )
            {

                my %DateParam = ( Prefix => $Prefix );

                # map the GetParam's Date Values to our DateParamHash
                %DateParam = map {
                    ( $Prefix . $_ )
                        => $ParamObject->GetParam( Param => ( $Prefix . $_ ) )
                    }
                    qw(Year Month Day Hour Minute);

                # if all values are present
                if (
                    defined $DateParam{ $Prefix . 'Year' }
                    && defined $DateParam{ $Prefix . 'Month' }
                    && defined $DateParam{ $Prefix . 'Day' }
                    && defined $DateParam{ $Prefix . 'Hour' }
                    && defined $DateParam{ $Prefix . 'Minute' }
                    )
                {

                    # recalculate time according to the user's timezone
                    %DateParam = $LayoutObject->TransformDateSelection(
                        %DateParam,
                    );

                    # reformat for storing (e.g. take out Prefix)
                    %{ $GetParam{$CurrentField} }
                        = map { $_ => $DateParam{ $Prefix . $_ } } qw(Year Month Day Hour Minute);
                    $ValuesGotten{PendingTime} = 1;
                }
            }
        }

        # Non DynamicFields
        # 1. try to get the required param
        my $Value = $ParamObject->GetParam( Param => $Self->{NameToID}{$CurrentField} );

        if ($Value) {

            # if we have an ID field make sure the value without ID won't be in the
            # %GetParam Hash any more
            if ( $Self->{NameToID}{$CurrentField} =~ m{(.*)ID$}xms ) {
                $GetParam{$1} = undef;
            }
            $GetParam{ $Self->{NameToID}{$CurrentField} }     = $Value;
            $ValuesGotten{ $Self->{NameToID}{$CurrentField} } = 1;
            next DIALOGFIELD;
        }

        # If we got ticket params, the GetParam Hash was already filled before the loop
        # and we can next out
        if ( $GetParam{ $Self->{NameToID}{$CurrentField} } ) {
            $ValuesGotten{ $Self->{NameToID}{$CurrentField} } = 1;
            next DIALOGFIELD;
        }

        # if no Submitted nore Ticket Param get ActivityDialog Config's Param
        if ( $CurrentField ne 'CustomerID' ) {
            $Value = $ActivityDialog->{Fields}{$CurrentField}{DefaultValue};
        }
        if ($Value) {
            $ValuesGotten{ $Self->{NameToID}{$CurrentField} } = 1;
            $GetParam{$CurrentField} = $Value;
            next DIALOGFIELD;
        }
    }
    REQUIREDFIELDLOOP:
    for my $CurrentField (qw(Queue State Lock Priority)) {
        $Value = undef;

        if ( !$ValuesGotten{ $Self->{NameToID}{$CurrentField} } ) {
            $Value = $ConfigObject->Get("Process::Default$CurrentField");
            if ( !$Value ) {

                my $Message = "Process::Default$CurrentField Config Value missing!";

                # does not show header and footer again
                if ( $Self->{IsMainWindow} ) {
                    return $LayoutObject->Error(
                        Message => $Message,
                    );
                }

                $LayoutObject->FatalError(
                    Message => $Message,
                );
            }
            $GetParam{$CurrentField} = $Value;
            $ValuesGotten{ $Self->{NameToID}{$CurrentField} } = 1;
        }
    }

    # get also the IDs for the Required files (if they are not present)
    if ( $GetParam{Queue} && !$GetParam{QueueID} ) {
        $GetParam{QueueID} = $Kernel::OM->Get('Kernel::System::Queue')->QueueLookup( Queue => $GetParam{Queue} );
    }
    if ( $GetParam{State} && !$GetParam{StateID} ) {
        $GetParam{StateID} = $Kernel::OM->Get('Kernel::System::State')->StateLookup( State => $GetParam{State} );
    }
    if ( $GetParam{Lock} && !$GetParam{LockID} ) {
        $GetParam{LockID} = $Kernel::OM->Get('Kernel::System::Lock')->LockLookup( Lock => $GetParam{Lock} );
    }
    if ( $GetParam{Priority} && !$GetParam{PriorityID} ) {
        $GetParam{PriorityID} = $Kernel::OM->Get('Kernel::System::Priority')->PriorityLookup(
            Priority => $GetParam{Priority},
        );
    }

    # and finally we'll have the special parameters:
    $GetParam{ResponsibleAll} = $ParamObject->GetParam( Param => 'ResponsibleAll' );
    $GetParam{OwnerAll}       = $ParamObject->GetParam( Param => 'OwnerAll' );
    $GetParam{Action}         = $Self->{Action};   
    return \%GetParam;
}
sub _GetLocks {
    my ( $Self, %Param ) = @_;

    my %Locks = $Kernel::OM->Get('Kernel::System::Lock')->LockList(
        UserID => $Self->{UserID},
    );

    return \%Locks;
}
sub _LookupValue {
    my ( $Self, %Param ) = @_;

    # get log object
    my $LogObject = $Kernel::OM->Get('Kernel::System::Log');

    # check needed stuff
    for my $Needed (qw(Field Value)) {
        if ( !defined $Param{$Needed} ) {
            $LogObject->Log(
                Priority => 'error',
                Message  => "Need $Needed!"
            );
            return;
        }
    }

    if ( !$Param{Field} ) {
        $LogObject->Log(
            Priority => 'error',
            Message  => "Field should not be empty!"
        );
        return;
    }

    # if there is no value, there is nothing to do
    return if !$Param{Value};

    # remove the ID for function name purpose
    my $FieldWithoutID = $Param{Field};
    $FieldWithoutID =~ s{ID$}{}xms;

    my $LookupFieldName;
    my $ObjectName;
    my $FunctionName;

    # owner(ID) and responsible(ID) lookup needs UserID as parameter
    if ( scalar grep { $Param{Field} eq $_ } qw( OwnerID ResponsibleID ) ) {
        $LookupFieldName = 'UserID';
        $ObjectName      = 'User';
        $FunctionName    = 'UserLookup';
    }

    # owner and responsible lookup needs UserLogin as parameter
    elsif ( scalar grep { $Param{Field} eq $_ } qw( Owner Responsible ) ) {
        $LookupFieldName = 'UserLogin';
        $ObjectName      = 'User';
        $FunctionName    = 'UserLookup';
    }

    # service and SLA lookup needs Name as parameter (While ServiceID an SLAID uses standard)
    elsif ( scalar grep { $Param{Field} eq $_ } qw( Service SLA ) ) {
        $LookupFieldName = 'Name';
        $ObjectName      = $FieldWithoutID;
        $FunctionName    = $FieldWithoutID . 'Lookup';
    }

    # other fields can use standard parameter names as Priority or PriorityID
    else {
        $LookupFieldName = $Param{Field};
        $ObjectName      = $FieldWithoutID;
        $FunctionName    = $FieldWithoutID . 'Lookup';
    }

    # get appropriate object of field
    my $FieldObject;
    if ( $Kernel::OM->Get('Kernel::System::Main')->Require( 'Kernel::System::' . $ObjectName, Silent => 1 ) ) {
        $FieldObject = $Kernel::OM->Get( 'Kernel::System::' . $ObjectName );
    }

    my $Value;

    # check if the backend module has the needed *Lookup sub
    if ( $FieldObject && $FieldObject->can($FunctionName) ) {

        # call the *Lookup sub and get the value
        $Value = $FieldObject->$FunctionName(
            $LookupFieldName => $Param{Value},
        );
    }

    # if we didn't have an object and the value has no ref a string e.g. Title and so on
    # return true
    elsif ( $Param{Field} eq $FieldWithoutID && !ref $Param{Value} ) {
        return $Param{Value};
    }
    else {
        $LogObject->Log(
            Priority => 'error',
            Message  => "Error while checking with " . $FieldWithoutID . "Object!"
        );
        return;
    }

    return if ( !$Value );

    # return the given ID value if the *Lookup result was a string
    if ( $Param{Field} ne $FieldWithoutID ) {
        return $Param{Value};
    }

    # return the *Lookup string return value
    return $Value;
}

sub _GetResponsibles {
    my ( $Self, %Param ) = @_;

    # get users
    my %ShownUsers;
    my %AllGroupsMembers = $Kernel::OM->Get('Kernel::System::User')->UserList(
        Type  => 'Long',
        Valid => 1,
    );

    # get needed objects
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');
    my $QueueObject  = $Kernel::OM->Get('Kernel::System::Queue');
    my $GroupObject  = $Kernel::OM->Get('Kernel::System::Group');

    # if we are updating a ticket show the full list of possible responsibles
    if ( $Param{TicketID} ) {
        if ( $Param{QueueID} && !$Param{AllUsers} ) {
            my $GID = $QueueObject->GetQueueGroupID( QueueID => $Param{QueueID} );
            my %MemberList = $GroupObject->PermissionGroupGet(
                GroupID => $GID,
                Type    => 'responsible',
            );
            for my $UserID ( sort keys %MemberList ) {
                $ShownUsers{$UserID} = $AllGroupsMembers{$UserID};
            }
        }
    }
    else {

        # get config object
        my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

        # the StartActivityDialog does not provide a TicketID and it could be that also there
        # is no QueueID information. Get the default QueueID for this matters.
        if ( !$Param{QueueID} ) {
            my $Queue = $ConfigObject->Get("Process::DefaultQueue");
            my $QueueID = $QueueObject->QueueLookup( Queue => $Queue );
            if ($QueueID) {
                $Param{QueueID} = $QueueID;
            }
        }

        # just show only users with selected custom queue
        if ( $Param{QueueID} && !$Param{ResponsibleAll} ) {
            my @UserIDs = $TicketObject->GetSubscribedUserIDsByQueueID(%Param);
            for my $KeyGroupMember ( sort keys %AllGroupsMembers ) {
                my $Hit = 0;
                for my $UID (@UserIDs) {
                    if ( $UID eq $KeyGroupMember ) {
                        $Hit = 1;
                    }
                }
                if ( !$Hit ) {
                    delete $AllGroupsMembers{$KeyGroupMember};
                }
            }
        }

        # show all system users
        if ( $ConfigObject->Get('Ticket::ChangeOwnerToEveryone') ) {
            %ShownUsers = %AllGroupsMembers;
        }

        # show all users who are rw in the queue group
        elsif ( $Param{QueueID} ) {
            my $GID = $QueueObject->GetQueueGroupID( QueueID => $Param{QueueID} );
            my %MemberList = $GroupObject->PermissionGroupGet(
                GroupID => $GID,
                Type    => 'responsible',
            );
            for my $KeyMember ( sort keys %MemberList ) {
                if ( $AllGroupsMembers{$KeyMember} ) {
                    $ShownUsers{$KeyMember} = $AllGroupsMembers{$KeyMember};
                }
            }
        }
    }

    # workflow
    my %UserID;
    if($Self->{SessionSource} eq 'CustomerInterface'){
        $UserID{CustomerUserID} = $Self->{UserID};
    } else {
        $UserID{UserID} = $Self->{UserID};
    }
    my $ACL = $TicketObject->TicketAcl(
        %Param,
        ReturnType    => 'Ticket',
        ReturnSubType => 'Responsible',
        Data          => \%ShownUsers,
        %UserID
    );

    return { $TicketObject->TicketAclData() } if $ACL;

    return \%ShownUsers;
}

sub _GetOwners {
    my ( $Self, %Param ) = @_;

    # get users
    my %ShownUsers;
    my %AllGroupsMembers = $Kernel::OM->Get('Kernel::System::User')->UserList(
        Type  => 'Long',
        Valid => 1,
    );

    # get needed objects
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');
    my $QueueObject  = $Kernel::OM->Get('Kernel::System::Queue');
    my $GroupObject  = $Kernel::OM->Get('Kernel::System::Group');

    # if we are updating a ticket show the full list of possible owners
    if ( $Param{TicketID} ) {
        if ( $Param{QueueID} && !$Param{AllUsers} ) {
            my $GID = $QueueObject->GetQueueGroupID( QueueID => $Param{QueueID} );
            my %MemberList = $GroupObject->PermissionGroupGet(
                GroupID => $GID,
                Type    => 'owner',
            );
            for my $UserID ( sort keys %MemberList ) {
                $ShownUsers{$UserID} = $AllGroupsMembers{$UserID};
            }
        }
    }
    else {

        # get config object
        my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

        # the StartActivityDialog does not provide a TicketID and it could be that also there
        # is no QueueID information. Get the default QueueID for this matters.
        if ( !$Param{QueueID} ) {
            my $Queue = $ConfigObject->Get("Process::DefaultQueue");
            my $QueueID = $QueueObject->QueueLookup( Queue => $Queue );
            if ($QueueID) {
                $Param{QueueID} = $QueueID;
            }
        }

        # just show only users with selected custom queue
        if ( $Param{QueueID} && !$Param{OwnerAll} ) {
            my @UserIDs = $TicketObject->GetSubscribedUserIDsByQueueID(%Param);
            for my $KeyGroupMember ( sort keys %AllGroupsMembers ) {
                my $Hit = 0;
                for my $UID (@UserIDs) {
                    if ( $UID eq $KeyGroupMember ) {
                        $Hit = 1;
                    }
                }
                if ( !$Hit ) {
                    delete $AllGroupsMembers{$KeyGroupMember};
                }
            }
        }

        # show all system users
        if ( $ConfigObject->Get('Ticket::ChangeOwnerToEveryone') ) {
            %ShownUsers = %AllGroupsMembers;
        }

        # show all users who are rw in the queue group
        elsif ( $Param{QueueID} ) {
            my $GID = $QueueObject->GetQueueGroupID( QueueID => $Param{QueueID} );
            my %MemberList = $GroupObject->PermissionGroupGet(
                GroupID => $GID,
                Type    => 'owner',
            );
            for my $KeyMember ( sort keys %MemberList ) {
                if ( $AllGroupsMembers{$KeyMember} ) {
                    $ShownUsers{$KeyMember} = $AllGroupsMembers{$KeyMember};
                }
            }
        }
    }

    # workflow
    my %UserID;
    if($Self->{SessionSource} eq 'CustomerInterface'){
        $UserID{CustomerUserID} = $Self->{UserID};
    } else {
        $UserID{UserID} = $Self->{UserID};
    }
    my $ACL = $TicketObject->TicketAcl(
        %Param,
        ReturnType    => 'Ticket',
        ReturnSubType => 'Owner',
        Data          => \%ShownUsers,
        %UserID
    );

    return { $TicketObject->TicketAclData() } if $ACL;

    return \%ShownUsers;
}

sub _GetSLAs {
    my ( $Self, %Param ) = @_;

    # get sla
    my %SLA;
    if ( $Param{ServiceID} && $Param{Services} && %{ $Param{Services} } ) {
        if ( $Param{Services}->{ $Param{ServiceID} } ) {
            %SLA = $Kernel::OM->Get('Kernel::System::Ticket')->TicketSLAList(
                %Param,
                Action => $Self->{Action},
                UserID => $Self->{UserID},
            );
        }
    }
    return \%SLA;
}

sub _GetServices {
    my ( $Self, %Param ) = @_;

    # get service
    my %Service;

    # check needed
    return \%Service if !$Param{QueueID} && !$Param{TicketID};

    # get options for default services for unknown customers
    my $DefaultServiceUnknownCustomer
        = $Kernel::OM->Get('Kernel::Config')->Get('Ticket::Service::Default::UnknownCustomer');

    # check if no CustomerUserID is selected
    # if $DefaultServiceUnknownCustomer = 0 leave CustomerUserID empty, it will not get any services
    # if $DefaultServiceUnknownCustomer = 1 set CustomerUserID to get default services
    if ( !$Param{CustomerUserID} && $DefaultServiceUnknownCustomer ) {
        $Param{CustomerUserID} = '<DEFAULT>';
    }

    # get service list
    if ( $Param{CustomerUserID} ) {
        %Service = $Kernel::OM->Get('Kernel::System::Ticket')->TicketServiceList(
            %Param,
            Action => $Self->{Action},
            UserID => $Self->{UserID},
        );
    }
    return \%Service;
}

sub _GetPriorities {
    my ( $Self, %Param ) = @_;

    my %Priorities;

    # Initially we have just the default Queue Parameter
    # so make sure to get the ID in that case
    my $QueueID;
    if ( !$Param{QueueID} && $Param{Queue} ) {
        $QueueID = $Kernel::OM->Get('Kernel::System::Queue')->QueueLookup( Queue => $Param{Queue} );
    }
    if ( $Param{QueueID} || $QueueID || $Param{TicketID} ) {
        %Priorities = $Kernel::OM->Get('Kernel::System::Ticket')->TicketPriorityList(
            %Param,
            Action => $Self->{Action},
            UserID => $Self->{UserID},
        );

    }
    return \%Priorities;
}

sub _GetQueues {
    my ( $Self, %Param ) = @_;

    # check which type of permission is needed: if the process ticket
    # already exists (= TicketID is present), we need the 'move_into'
    # permission otherwise the 'create' permission
    my $PermissionType = 'create';
    if ( $Param{TicketID} ) {
        $PermissionType = 'move_into';
    }

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # check own selection
    my %NewQueues;
    if ( $ConfigObject->Get('Ticket::Frontend::NewQueueOwnSelection') ) {
        %NewQueues = %{ $ConfigObject->Get('Ticket::Frontend::NewQueueOwnSelection') };
    }
    else {

        # SelectionType Queue or SystemAddress?
        my %Queues;
        if ( $ConfigObject->Get('Ticket::Frontend::NewQueueSelectionType') eq 'Queue' ) {
            %Queues = $Kernel::OM->Get('Kernel::System::Ticket')->MoveList(
                %Param,
                Type    => $PermissionType,
                Action  => $Self->{Action},
                QueueID => $Self->{QueueID},
                UserID  => $Self->{UserID},
            );
        }
        else {
            %Queues = $Kernel::OM->Get('Kernel::System::DB')->GetTableData(
                Table => 'system_address',
                What  => 'queue_id, id',
                Valid => 1,
                Clamp => 1,
            );
        }

        # get permission queues
        my %UserGroups = $Kernel::OM->Get('Kernel::System::Group')->PermissionUserGet(
            UserID => $Self->{UserID},
            Type   => $PermissionType,
        );

        # build selection string
        QUEUEID:
        for my $QueueID ( sort keys %Queues ) {
            my %QueueData = $Kernel::OM->Get('Kernel::System::Queue')->QueueGet( ID => $QueueID );

            # permission check, can we create new tickets in queue
            next QUEUEID if !$UserGroups{ $QueueData{GroupID} };

            my $String = $ConfigObject->Get('Ticket::Frontend::NewQueueSelectionString')
                || '<Realname> <<Email>> - Queue: <Queue>';
            $String =~ s/<Queue>/$QueueData{Name}/g;
            $String =~ s/<QueueComment>/$QueueData{Comment}/g;
            if ( $ConfigObject->Get('Ticket::Frontend::NewQueueSelectionType') ne 'Queue' )
            {
                my %SystemAddressData = $Self->{SystemAddress}->SystemAddressGet(
                    ID => $Queues{$QueueID},
                );
                $String =~ s/<Realname>/$SystemAddressData{Realname}/g;
                $String =~ s/<Email>/$SystemAddressData{Name}/g;
            }
            $NewQueues{$QueueID} = $String;
        }
    }

    return \%NewQueues;
}

sub _GetStates {
    my ( $Self, %Param ) = @_;

    my %States = $Kernel::OM->Get('Kernel::System::Ticket')->TicketStateList(
    #    %Param,

        # Set default values for new process ticket
        QueueID  => $Param{QueueID}  || 1,
        TicketID => $Param{TicketID} || '',

        # remove type, since if Ticket::Type is active in sysconfig, the Type parameter will
        # be sent and the TicketStateList will send the parameter as State Type
#        Type => undef,
#
 #       Action => $Self->{Action},
        UserID => $Self->{UserID},
    );

    return \%States;
}

sub _GetTypes {
    my ( $Self, %Param ) = @_;

    # get type
    my %Type;
    if ( $Param{QueueID} || $Param{TicketID} ) {
        %Type = $Kernel::OM->Get('Kernel::System::Ticket')->TicketTypeList(
            %Param,
            Action => $Self->{Action},
            UserID => $Self->{UserID},
        );
    }
    return \%Type;
}

sub _GetAJAXUpdatableFields {
    my ( $Self, %Param ) = @_;

    my %DefaultUpdatableFields = (
        PriorityID    => 1,
        QueueID       => 1,
        ResponsibleID => 1,
        ServiceID     => 1,
        SLAID         => 1,
        StateID       => 1,
        OwnerID       => 1,
        LockID        => 1,
    );

    my $DynamicField = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldListGet(
        Valid      => 1,
        ObjectType => 'Ticket',
    );

    # create a DynamicFieldLookupTable
    my %DynamicFieldLookup = map { 'DynamicField_' . $_->{Name} => $_ } @{$DynamicField};

    my @UpdatableFields;
    FIELD:
    for my $Field ( sort keys %{ $Param{ActivityDialogFields} } ) {

        my $FieldData = $Param{ActivityDialogFields}->{$Field};

        # skip hidden fields
#        next FIELD if !$FieldData->{Display};

        # for Dynamic Fields check if is AJAXUpdatable
        if ( $Field =~ m{^DynamicField_(.*)}xms ) {
            my $DynamicFieldConfig = $DynamicFieldLookup{$Field};

            # skip any field with wrong config
            next FIELD if !IsHashRefWithData($DynamicFieldConfig);

            # skip field if is not IsACLReducible (updatable)
            my $IsACLReducible = $Kernel::OM->Get('Kernel::System::DynamicField::Backend')->HasBehavior(
                DynamicFieldConfig => $DynamicFieldConfig,
                Behavior           => 'IsACLReducible',
            );
            next FIELD if !$IsACLReducible;

            push @UpdatableFields, $Field;
        }

        # for all others use %DefaultUpdatableFields table
        else {

            # standarize the field name (e.g. use StateID for State field)
            my $FieldName = $Self->{NameToID}->{$Field};

            # skip if field name could not be converted (this means that field is unknown)
            next FIELD if !$FieldName;

            # skip if the field is not updatable via ajax
            next FIELD if !$DefaultUpdatableFields{$FieldName};

            push @UpdatableFields, $FieldName;
        }
    }

    return \@UpdatableFields;
}



# Complemento, render new Dynamic Fields for this screen
sub _OutputShowHideDynamicFields {
	my ( $Self, %Param ) = @_;

	my $DynamicFieldsToShow    = $Param{DynamicFieldsToShow} || {};
	my $DynamicFieldConfig    = $Param{DynamicFieldConfg} || {};

	my $AjaxResponseJson='';
	# get needed object
	my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');
	my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
	my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
	my $DfByServiceObject = $Kernel::OM->Get('Kernel::System::DynamicFieldByService');

	my $ActivityDialog = $DfByServiceObject->GetDynamicFieldByServiceAndInterface(ServiceID => $Param{GetParam}->{ServiceID},  InterfaceName   => $Param{InterfaceName} );
	my %Ticket;

	my $Output='';

    # ################################### MONTAR ORDEM DOS CAMPOS AQUI
    my $DynamicFieldOrder = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldList(
        Valid       => 1,
        ObjectType  => ['Ticket'],
        ResultType => 'ARRAY',   # optional, 'ARRAY' or 'HASH', defaults to 'ARRAY'
        FieldFilter => $DynamicFieldsToShow || {},
    );

    # Se for retornado alguma lista de campos, devemos então fazer um loop nela 
    # e criar uma ordenação mista entre ordem do formulário e campos dinamicos hideandshow
    # que por padrão não estão ordenados, sendo assim, temos que pegar a ordem deles em relação 
    # aos campos que possuem ordem no cadastro geral de posição de campos
    my %FieldsOrder;
    if(ref($DynamicFieldOrder) eq 'ARRAY'){
        my $LastFieldOrder=0;
        my $LocalOrder=1;

        for my $Field (@{$DynamicFieldOrder}){
            # Pega o campo
            my $DynamicField = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldGet(
                ID   => $Field
            );

            my ($index) = grep { $ActivityDialog->{Config}{FieldOrder}[$_] eq "DynamicField_".$DynamicField->{Name} } (0 .. @{ $ActivityDialog->{Config}{FieldOrder} }-1);


            # Verificar se o campo possui ordem definida no Formulário
            if (defined($index)){
                # se tem ordem definida no form, sua ordem é esta então
                # e definimos ela na chave do FieldsOrder
                $LastFieldOrder = $index;
            } else {
                # Se não tem ordem definida no form, sua ordem é a ordem do último
                # campo ordenado do formulário + sua ordem no FieldsOrder geral
                $index = $LastFieldOrder+1;
                $LastFieldOrder = $index;
            }
            $FieldsOrder{$index} = $DynamicField;
        }
    }

    # @TODO: Verificar a necessidade da variavel abaixo
    $Self->{FormID} = 'NewPhoneTicket';
	my %Error         = ();
	my %ErrorMessages = ();
	# If we had Errors, we got an Errorhash
	%Error         = %{ $Param{Error} }         if ( IsHashRefWithData( $Param{Error} ) );
	%ErrorMessages = %{ $Param{ErrorMessages} } if ( IsHashRefWithData( $Param{ErrorMessages} ) );

    my $AJAXUpdatableFields;

    for my $Field (sort { $a <=> $b } keys %FieldsOrder){
        my $DynamicFieldName = $FieldsOrder{$Field}->{Name};
        my %ActivityDialog;
        $ActivityDialog{Display}=$DynamicFieldsToShow->{$FieldsOrder{$Field}->{Name}};
        my $Response         = $Self->_RenderDynamicField(
            ActivityDialogField => \%ActivityDialog,
            FieldName           => $DynamicFieldName,
            DescriptionShort    => '',
            DescriptionLong     => '',
            Ticket              => \%Ticket || {},
            Error               => \%Error || {},
            ErrorMessages       => \%ErrorMessages || {},
            GetParam            => $Param{GetParam},
            AJAXUpdatableFields => $AJAXUpdatableFields,
            FormID              => $Self->{FormID},
        );
        
        if ( !$Response->{Success} ) {
            # does not show header and footer again
            if ( $Self->{IsMainWindow} ) {
                return $LayoutObject->Error(
                    Message => $Response->{Message},
                );
            }
            $LayoutObject->FatalError(
                Message => $Response->{Message},
            );
        }

        $Output .= $Response->{HTML};
    }

	# reload parent window
	if ( $Param{ParentReload} ) {
		$LayoutObject->Block(
		    	Name => 'ParentReload',
		);
	}

	my $JsonSubject = '';
	my $JsonType = '';
	my $JsonMessage = '';
   	my %JsonReturn;
	my $AgentJsonFieldConfig;
	my $CustomerJsonFieldConfig;	
	my $JSONObject = $Kernel::OM->Get('Kernel::System::JSON');

	if($Kernel::OM->Get('Kernel::Config')->Get('AgentDynamicFieldByService::NameBeforeField')){
		%JsonReturn = ('AgentFieldConfig' => $Kernel::OM->Get('Kernel::Config')->Get('AgentDynamicFieldByService::NameBeforeField') );	
		$AgentJsonFieldConfig = "@%@%@".encode_json \%JsonReturn if(%JsonReturn);

	}	
	if($Kernel::OM->Get('Kernel::Config')->Get('CustomerDynamicFieldByService::NameBeforeField')){
		%JsonReturn = ('CustomerFieldConfig' => $Kernel::OM->Get('Kernel::Config')->Get('CustomerDynamicFieldByService::NameBeforeField') );	
		$CustomerJsonFieldConfig = "@%@%@".encode_json \%JsonReturn if(%JsonReturn);

	}	
	$Output .= $LayoutObject->Output(
	     Template => '[% Data.JSON %]',
	     Data         => {
							JSON => ':$$:Add:$$:{"1":"1"} ' . $JsonType . " " . $JsonSubject . " " . $JsonMessage . " " . $AgentJsonFieldConfig. " " . $CustomerJsonFieldConfig ." ".  $AjaxResponseJson,

						},
	 );

	return $Output;
}

1
;