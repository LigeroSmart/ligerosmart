package Kernel::GenericInterface::Invoker::Ligero::LigeroEasyConnector;

use strict;
use warnings;
use Data::Dumper;
use utf8;
use Encode qw( encode_utf8 );
use MIME::Base64 qw(encode_base64 decode_base64);
use Kernel::System::VariableCheck qw(IsString IsStringWithData IsHashRefWithData IsArrayRefWithData);

use parent qw(
    Kernel::GenericInterface::LigeroEasyConnectorCommon
);
# prevent 'Used once' warning for Kernel::OM
use Kernel::System::ObjectManager;

our $ObjectManagerDisabled = 1;

=head1 NAME

Kernel::GenericInterface::Invoker::Ligero::LigeroEasyConnector - GenericInterface LigeroEasyConnector Invoker backend

=head1 SYNOPSIS

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

usually, you want to create an instance of this
by using Kernel::GenericInterface::Invoker->new();

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # check needed params
    if ( !$Param{DebuggerObject} ) {
        return {
            Success      => 0,
            ErrorMessage => "Got no DebuggerObject!"
        };
    }

    $Self->{DebuggerObject} = $Param{DebuggerObject};

    return $Self;
}

=item PrepareRequest()

prepare the invocation of the configured remote webservice.

    my $Result = $InvokerObject->PrepareRequest(
        Data => {                               # data payload
            ...
        },
    );

    $Result = {
        Success         => 1,                   # 0 or 1
        ErrorMessage    => '',                  # in case of error
        Data            => {                    # data payload after Invoker
            ...
        },
    };

=cut

sub PrepareRequest {
    my ( $Self, %Param ) = @_;

    my %ReturnData;

    # Call Pre Invoker
    my $WebserviceData = $Kernel::OM->Get('Kernel::System::GenericInterface::Webservice')->WebserviceGet(
        ID => $Param{WebserviceID},
    );
    if ( IsHashRefWithData($WebserviceData) 
            && $WebserviceData->{Config}->{Requester}
            && $WebserviceData->{Config}->{Requester}->{Invoker}
            && IsHashRefWithData($WebserviceData->{Config}->{Requester}->{Invoker})
            && IsHashRefWithData($WebserviceData->{Config}->{Requester}->{Invoker}->{$Param{Invoker}})
            && IsStringWithData($WebserviceData->{Config}->{Requester}->{Invoker}->{$Param{Invoker}}->{PreInvoker})
        )
    {
        my ($PreInvokerWS, $PreInvoker) = split '::',$WebserviceData->{Config}->{Requester}->{Invoker}->{$Param{Invoker}}->{PreInvoker};
        my $PreInvokerWSData = $Kernel::OM->Get('Kernel::System::GenericInterface::Webservice')->WebserviceGet(
            Name => $PreInvokerWS,
        );
        my $PreResult = $Kernel::OM->Get('Kernel::GenericInterface::Requester')->Run(
            WebserviceID => $PreInvokerWSData->{ID},
            Invoker      => $PreInvoker,
            Data         => $Param{Data}
        );
        $Self->{DebuggerObject}->Debug(
            Summary => "Result from Pre Invoker",
            Data    => $PreResult,
        );
        $ReturnData{PreResult} = $PreResult;
    }
    
    if(IsHashRefWithData($Param{Data}->{OldTicketData})){
        $ReturnData{OldTicketData} = $Param{Data}->{OldTicketData};
    }
    
    # check Action
    if ( IsStringWithData( $Param{Data}->{Action} ) ) {
        $ReturnData{Action} = $Param{Data}->{Action};
    }

    # check request for system time
    if ( IsStringWithData( $Param{Data}->{GetSystemTime} ) && $Param{Data}->{GetSystemTime} ) {
        $ReturnData{SystemTime} = $Kernel::OM->Get('Kernel::System::Time')->SystemTime();
    }

    my %Ticket;
    my %Article;
    my @Ats; # For attachments
    my %Service;
    my %SLA;
    my %CustomerCompany;
    my %CustomerUser;

    ### Check if we have InvokerData to replace in the $Param{Data} structure
    if (IsHashRefWithData($Param{Data}->{InvokerData})) {
        $Param{Data}                = $Param{Data}->{InvokerData}->{Data};
        $ReturnData{InvokerData}    = $Param{Data};
    }

	### Get Ticket Data
    if(IsStringWithData( $Param{Data}->{TicketID} )){
		%Ticket = $Kernel::OM->Get('Kernel::System::Ticket')->TicketGet(
				TicketID => $Param{Data}->{TicketID},
				DynamicFields => 1,
				Extended => 1,
				UserID => 1
			);
        $Ticket{CustomerUser} = $Ticket{CustomerUserID};
	}	

	# ### Get Article
    # if(IsStringWithData( $Param{Data}->{ArticleID} )){
	# 	%Article = $Kernel::OM->Get('Kernel::System::Ticket')->ArticleGet(
	# 			ArticleID => $Param{Data}->{ArticleID}, 
	# 			DynamicFields => 1,
	# 			Extended => 1,
	# 			UserID => 1
	# 		);
    #     $Article{CustomerUser} = $Article{CustomerUserID};

    #     delete $Article{$_} for grep /^((?!DynamicField_)).*ID$/, keys %Article;

	# 	my %Attachments = $Kernel::OM->Get('Kernel::System::Ticket')->ArticleAttachmentIndex(ArticleID => $Param{Data}->{ArticleID}, UserID => 1);
		
	# 	for (keys %Attachments){
	# 		my %Attachment = $Kernel::OM->Get('Kernel::System::Ticket')->ArticleAttachment(
	# 			ArticleID => $Param{Data}->{ArticleID},
	# 			FileID    => $_,   # as returned by ArticleAttachmentIndex
	# 			UserID    => 1,
	# 		);
	# 		my %At;
	# 		$At{Content} = encode_base64($Attachment{Content});
	# 		$At{ContentType} = $Attachments{$_}->{ContentType};
	# 		$At{Filename} = $Attachments{$_}->{Filename};
			
	# 		push @Ats, \%At;
	# 	}
	# }

	#### Get Service if Any
	if($Ticket{ServiceID}){
		%Service = $Kernel::OM->Get('Kernel::System::Service')->ServicePreferencesGet(
			ServiceID => $Ticket{ServiceID},
			UserID    => 1,
		);
		my %ServiceData = $Kernel::OM->Get('Kernel::System::Service')->ServiceGet(
			ServiceID => $Ticket{ServiceID},
			UserID    => 1,
		);
		%Service = (%Service, %ServiceData);
	}
	
	#### Get SLA if Any
	#if ($Ticket{SLAID}){
	   #%SLA = $Kernel::OM->Get('Kernel::System::SLA')->SLAGet(
		   #SLAID  => $Ticket{SLAID},
		   #UserID => 1,
	   #);
	   
		#delete $SLA{SLAID};
		#delete $SLA{ServiceIDs};
		#delete $SLA{ValidID};
		#delete $SLA{CreateBy};
		#delete $SLA{CreateTime};
		#delete $SLA{ChangeBy};
		#delete $SLA{ChangeTime};
	#}

	### Get CustomerCompany if Any
    if($Ticket{CustomerID}){
        %CustomerCompany = $Kernel::OM->Get('Kernel::System::CustomerCompany')->CustomerCompanyGet(
        CustomerID => $Ticket{CustomerID},
        );
    }
#	delete $CustomerCompany{ValidID};
	delete $CustomerCompany{Config};
	delete $CustomerCompany{CreateBy};
	delete $CustomerCompany{CreateTime};
	delete $CustomerCompany{ChangeBy};
	delete $CustomerCompany{ChangeTime};

	### Get Customer User if Any
	%CustomerUser = $Kernel::OM->Get('Kernel::System::CustomerUser')->CustomerUserDataGet(
       User => $Ticket{CustomerUserID},
	);
	delete $CustomerUser{CompanyConfig};
	delete $CustomerUser{UserID};
	delete $CustomerUser{ChangeBy};
	delete $CustomerUser{ChangeTime};
	delete $CustomerUser{Config};
	delete $CustomerUser{CreateBy};
	delete $CustomerUser{CreateTime};
	delete $CustomerUser{UserPassword};
	delete $CustomerUser{UserGoogleAuthenticatorSecretKey};
	delete $CustomerUser{$_} for grep /^CustomerCompany/, keys %CustomerUser;

    # Verificar se este ticket é integrado (se ele possui o campo dinamico )
    $ReturnData{Ticket} 			= \%Ticket if %Ticket;
    $ReturnData{Article} 			= \%Article if %Article;
    $ReturnData{Attachment} 			= \@Ats if @Ats;
    $ReturnData{CustomerCompany} 		= \%CustomerCompany if %CustomerCompany;
    $ReturnData{CustomerUser} 			= \%CustomerUser if %CustomerUser;
    $ReturnData{Service} 			= \%Service if %Service;
    #$ReturnData{SLA} 				= \%SLA if %SLA;

    if($Param{Data}->{PreResult} && $Param{Data}->{PreResult}->{Data}){
        $ReturnData{PreResult} = $Param{Data}->{PreResult}->{Data};
    }

    if($Param{Data}->{FilePath}){
        $ReturnData{FilePath} = $Param{Data}->{FilePath};
    }

    if($Param{Data}->{FileData}){
        $ReturnData{FileData} = $Param{Data}->{FileData};
    }
    
    my $EncodeObject = $Kernel::OM->Get("Kernel::System::Encode");

    $EncodeObject->EncodeInput( \%ReturnData );
        
    return {
        Success => 1,
        Data    => \%ReturnData,
    };
}

=item HandleResponse()

handle response data of the configured remote webservice.

    my $Result = $InvokerObject->HandleResponse(
        ResponseSuccess      => 1,              # success status of the remote webservice
        ResponseErrorMessage => '',             # in case of webservice error
        Data => {                               # data payload
            ...
        },
    );

    $Result = {
        Success         => 1,                   # 0 or 1
        ErrorMessage    => '',                  # in case of error
        Data            => {                    # data payload after Invoker
            ...
        },
    };

=cut

sub HandleResponse {
    my ( $Self, %Param ) = @_;

    # if there was an error in the response, forward it
    if ( !$Param{ResponseSuccess} ) {
        if ( !IsStringWithData( $Param{ResponseErrorMessage} ) ) {

            return $Self->{DebuggerObject}->Error(
                Summary => 'Got response error, but no response error message!',
            );
        }

        return {
            Success      => 0,
            ErrorMessage => $Param{ResponseErrorMessage},
        };
    }

    my $TicketID;
    my $UserID = 1;

    if(    IsHashRefWithData($Param{DataInclude}->{RequesterRequestInput})
        && IsStringWithData( $Param{DataInclude}->{RequesterRequestInput}->{TicketID} )
        && $Param{DataInclude}->{RequesterRequestInput}->{TicketID} 
    ){
        $TicketID = $Param{DataInclude}->{RequesterRequestInput}->{TicketID};
    }

    delete $Param{DataInclude} if $Param{DataInclude};

    my $Ticket;
    if ( defined $Param{Data}->{Ticket} ) {

        # isolate ticket parameter
        $Ticket = $Param{Data}->{Ticket};

        $Ticket->{UserID} = $UserID;

        # remove leading and trailing spaces
        for my $Attribute ( sort keys %{$Ticket} ) {
            if ( ref $Attribute ne 'HASH' && ref $Attribute ne 'ARRAY' ) {

                #remove leading spaces
                $Ticket->{$Attribute} =~ s{\A\s+}{};

                #remove trailing spaces
                $Ticket->{$Attribute} =~ s{\s+\z}{};
            }
        }
        if ( IsHashRefWithData( $Ticket->{PendingTime} ) ) {
            for my $Attribute ( sort keys %{ $Ticket->{PendingTime} } ) {
                if ( ref $Attribute ne 'HASH' && ref $Attribute ne 'ARRAY' ) {

                    #remove leading spaces
                    $Ticket->{PendingTime}->{$Attribute} =~ s{\A\s+}{};

                    #remove trailing spaces
                    $Ticket->{PendingTime}->{$Attribute} =~ s{\s+\z}{};
                }
            }
        }
    }

    my $DynamicField;
    my @DynamicFieldList;
    if ( defined $Param{Data}->{DynamicField} ) {

        # isolate DynamicField parameter
        $DynamicField = $Param{Data}->{DynamicField};

        # homogenate input to array
        if ( ref $DynamicField eq 'HASH' ) {
            push @DynamicFieldList, $DynamicField;
        }
        else {
            @DynamicFieldList = @{$DynamicField};
        }

        # check DynamicField internal structure
        for my $DynamicFieldItem (@DynamicFieldList) {
            if ( !IsHashRefWithData($DynamicFieldItem) ) {
                return {
                    ErrorCode => 'TicketUpdateOrCreate.InvalidParameter',
                    ErrorMessage =>
                        "TicketUpdateOrCreate: Ticket->DynamicField parameter is invalid!",
                };
            }

            # remove leading and trailing spaces
            for my $Attribute ( sort keys %{$DynamicFieldItem} ) {
                if ( ref $Attribute ne 'HASH' && ref $Attribute ne 'ARRAY' ) {

                    #remove leading spaces
                    $DynamicFieldItem->{$Attribute} =~ s{\A\s+}{};

                    #remove trailing spaces
                    $DynamicFieldItem->{$Attribute} =~ s{\s+\z}{};
                }
            }
        }
    }


    # prepare Return
    my %ReturnData;

    if($Param{Data}->{ReturnData}){
        %ReturnData = %{$Param{Data}->{ReturnData}};
    };

    if($TicketID && (IsHashRefWithData($Ticket) || IsArrayRefWithData(\@DynamicFieldList))){
        $ReturnData{TicketUpdateStatus} = $Self->_TicketUpdate(
                TicketID         => $TicketID,
                Ticket           => $Ticket,
                # Article          => $Article,
                DynamicFieldList => \@DynamicFieldList,
                # AttachmentList   => \@AttachmentList,
                UserID           => 1,
                UserType         => 'agent',
        );
    }

    # $Self->_LigeroEasyConnectorCall(
    #     Data => $Param{Data}
    # );

    # Call Post Invoker
    my $WebserviceData = $Kernel::OM->Get('Kernel::System::GenericInterface::Webservice')->WebserviceGet(
        ID => $Param{WebserviceID},
    );
    if ( IsHashRefWithData($WebserviceData) 
            && $WebserviceData->{Config}->{Requester}
            && $WebserviceData->{Config}->{Requester}->{Invoker}
            && IsHashRefWithData($WebserviceData->{Config}->{Requester}->{Invoker})
            && IsHashRefWithData($WebserviceData->{Config}->{Requester}->{Invoker}->{$Param{Invoker}})
            && IsStringWithData($WebserviceData->{Config}->{Requester}->{Invoker}->{$Param{Invoker}}->{PostInvoker})
        )
    {
        my ($PostInvokerWS, $PostInvoker) = split '::',$WebserviceData->{Config}->{Requester}->{Invoker}->{$Param{Invoker}}->{PostInvoker};
        my $PostInvokerWSData = $Kernel::OM->Get('Kernel::System::GenericInterface::Webservice')->WebserviceGet(
            Name => $PostInvokerWS,
        );

        my $PostResult = $Kernel::OM->Get('Kernel::GenericInterface::Requester')->Run(
            WebserviceID => $PostInvokerWSData->{ID},
            Invoker      => $PostInvoker,
            Data         => \%ReturnData
        );
        $Self->{DebuggerObject}->Debug(
            Summary => "Result from Post Invoker",
            Data    => $PostResult,
        );
        $ReturnData{PostResult} = $PostResult;
    }

    return {
        Success => 1,
        Data    => \%ReturnData,
    };
}

=item _TicketUpdate()

updates a ticket and creates an article and sets dynamic fields and attachments if specified.

    my $Response = $OperationObject->_TicketUpdate(
        TicketID     => 123
        Ticket       => $Ticket,                  # all ticket parameters
        Article      => $Article,                 # all attachment parameters
        DynamicField => $DynamicField,            # all dynamic field parameters
        Attachment   => $Attachment,              # all attachment parameters
        UserID       => 123,
        UserType     => 'Agent'                   # || 'Customer
    );

    returns:

    $Response = {
        Success => 1,                               # if everything is OK
        Data => {
            TicketID     => 123,
            TicketNumber => 'TN3422332',
            ArticleID    => 123,                    # if new article was created
        }
    }

    $Response = {
        Success      => 0,                         # if unexpected error
        ErrorMessage => "$Param{ErrorCode}: $Param{ErrorMessage}",
    }

=cut

sub _TicketUpdate {
    my ( $Self, %Param ) = @_;

    my $TicketID         = $Param{TicketID};
    my $Ticket           = $Param{Ticket};
    my $Article          = $Param{Article};
    my $DynamicFieldList = $Param{DynamicFieldList};
    my $AttachmentList   = $Param{AttachmentList};

    # get ticket object
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

    # get current ticket data
    my %TicketData = $TicketObject->TicketGet(
        TicketID      => $TicketID,
        DynamicFields => 0,
        UserID        => $Param{UserID},
    );

    # update ticket parameters
    # update Ticket->Title
    if (
        defined $Ticket->{Title}
        && $Ticket->{Title} ne ''
        && $Ticket->{Title} ne $TicketData{Title}
        )
    {
        my $Success = $TicketObject->TicketTitleUpdate(
            Title    => $Ticket->{Title},
            TicketID => $TicketID,
            UserID   => $Param{UserID},
        );
        if ( !$Success ) {
            return {
                Success => 0,
                Errormessage =>
                    'Ticket title could not be updated, please contact system administrator!',
                }
        }
    }

    # update Ticket->Queue
    if ( $Ticket->{Queue} || $Ticket->{QueueID} ) {
        my $Success;
        if ( defined $Ticket->{Queue} && $Ticket->{Queue} ne $TicketData{Queue} ) {
            $Success = $TicketObject->TicketQueueSet(
                Queue    => $Ticket->{Queue},
                TicketID => $TicketID,
                UserID   => $Param{UserID},
            );
        }
        elsif ( defined $Ticket->{QueueID} && $Ticket->{QueueID} ne $TicketData{QueueID} ) {
            $Success = $TicketObject->TicketQueueSet(
                QueueID  => $Ticket->{QueueID},
                TicketID => $TicketID,
                UserID   => $Param{UserID},
            );
        }
        else {

            # data is the same as in ticket nothing to do
            $Success = 1;
        }

        if ( !$Success ) {
            return {
                Success => 0,
                ErrorMessage =>
                    'Ticket queue could not be updated, please contact system administrator!',
                }
        }
    }

    # update Ticket->Lock
    if ( $Ticket->{Lock} || $Ticket->{LockID} ) {
        my $Success;
        if ( defined $Ticket->{Lock} && $Ticket->{Lock} ne $TicketData{Lock} ) {
            $Success = $TicketObject->TicketLockSet(
                Lock     => $Ticket->{Lock},
                TicketID => $TicketID,
                UserID   => $Param{UserID},
            );
        }
        elsif ( defined $Ticket->{LockID} && $Ticket->{LockID} ne $TicketData{LockID} ) {
            $Success = $TicketObject->TicketLockSet(
                LockID   => $Ticket->{LockID},
                TicketID => $TicketID,
                UserID   => $Param{UserID},
            );
        }
        else {

            # data is the same as in ticket nothing to do
            $Success = 1;
        }

        if ( !$Success ) {
            return {
                Success => 0,
                Errormessage =>
                    'Ticket lock could not be updated, please contact system administrator!',
                }
        }
    }

    # update Ticket->Type
    if ( $Ticket->{Type} || $Ticket->{TypeID} ) {
        my $Success;
        if ( defined $Ticket->{Type} && $Ticket->{Type} ne $TicketData{Type} ) {
            $Success = $TicketObject->TicketTypeSet(
                Type     => $Ticket->{Type},
                TicketID => $TicketID,
                UserID   => $Param{UserID},
            );
        }
        elsif ( defined $Ticket->{TypeID} && $Ticket->{TypeID} ne $TicketData{TypeID} )
        {
            $Success = $TicketObject->TicketTypeSet(
                TypeID   => $Ticket->{TypeID},
                TicketID => $TicketID,
                UserID   => $Param{UserID},
            );
        }
        else {

            # data is the same as in ticket nothing to do
            $Success = 1;
        }

        if ( !$Success ) {
            return {
                Success => 0,
                Errormessage =>
                    'Ticket type could not be updated, please contact system administrator!',
                }
        }
    }

    # update Ticket>State
    # depending on the state, might require to unlock ticket or enables pending time set
    if ( $Ticket->{State} || $Ticket->{StateID} ) {

        # get State Data
        my %StateData;
        my $StateID;

        # get state object
        my $StateObject = $Kernel::OM->Get('Kernel::System::State');

        if ( $Ticket->{StateID} ) {
            $StateID = $Ticket->{StateID};
        }
        else {
            $StateID = $StateObject->StateLookup(
                State => $Ticket->{State},
            );
        }

        %StateData = $StateObject->StateGet(
            ID => $StateID,
        );

        # force unlock if state type is close
        if ( $StateData{TypeName} =~ /^close/i ) {

            # set lock
            $TicketObject->TicketLockSet(
                TicketID => $TicketID,
                Lock     => 'unlock',
                UserID   => $Param{UserID},
            );
        }

        # set pending time
        elsif ( $StateData{TypeName} =~ /^pending/i ) {

            # set pending time
            if ( defined $Ticket->{PendingTime} ) {
                my $Success = $TicketObject->TicketPendingTimeSet(
                    UserID   => $Param{UserID},
                    TicketID => $TicketID,
                    %{ $Ticket->{PendingTime} },
                );

                if ( !$Success ) {
                    return {
                        Success => 0,
                        Errormessage =>
                            'Ticket pendig time could not be updated, please contact system'
                            . ' administrator!',
                        }
                }
            }
            else {
                     return {
                        Success => 0,
                        Errormessage =>
                            'Can\'t set a ticket on a pending state without pendig time!',
                        }
            }
        }

        my $Success;
        if ( defined $Ticket->{State} && $Ticket->{State} ne $TicketData{State} ) {
            $Success = $TicketObject->TicketStateSet(
                State    => $Ticket->{State},
                TicketID => $TicketID,
                UserID   => $Param{UserID},
            );
        }
        elsif ( defined $Ticket->{StateID} && $Ticket->{StateID} ne $TicketData{StateID} )
        {
            $Success = $TicketObject->TicketStateSet(
                StateID  => $Ticket->{StateID},
                TicketID => $TicketID,
                UserID   => $Param{UserID},
            );
        }
        else {

            # data is the same as in ticket nothing to do
            $Success = 1;
        }

        if ( !$Success ) {
            return {
                Success => 0,
                Errormessage =>
                    'Ticket state could not be updated, please contact system administrator!',
                }
        }
    }

    # update Ticket->Service
    # this might reset SLA if current SLA is not available for the new service
    if ( $Ticket->{Service} || $Ticket->{ServiceID} ) {

        # check if ticket has a SLA assigned
        if ( $TicketData{SLAID} ) {

            # check if old SLA is still valid
            if (
                !$Self->ValidateSLA(
                    SLAID     => $TicketData{SLAID},
                    Service   => $Ticket->{Service} || '',
                    ServiceID => $Ticket->{ServiceID} || '',
                )
                )
            {

                # remove current SLA if is not compatible with new service
                my $Success = $TicketObject->TicketSLASet(
                    SLAID    => '',
                    TicketID => $TicketID,
                    UserID   => $Param{UserID},
                );
            }
        }

        my $Success;

        # prevent comparison errors on undefined values
        if ( !defined $TicketData{Service} ) {
            $TicketData{Service} = '';
        }
        if ( !defined $TicketData{ServiceID} ) {
            $TicketData{ServiceID} = '';
        }

        if ( defined $Ticket->{Service} && $Ticket->{Service} ne $TicketData{Service} ) {
            $Success = $TicketObject->TicketServiceSet(
                Service  => $Ticket->{Service},
                TicketID => $TicketID,
                UserID   => $Param{UserID},
            );
        }
        elsif ( defined $Ticket->{ServiceID} && $Ticket->{ServiceID} ne $TicketData{ServiceID} )
        {
            $Success = $TicketObject->TicketServiceSet(
                ServiceID => $Ticket->{ServiceID},
                TicketID  => $TicketID,
                UserID    => $Param{UserID},
            );
        }
        else {

            # data is the same as in ticket nothing to do
            $Success = 1;
        }

        if ( !$Success ) {
            return {
                Success => 0,
                Errormessage =>
                    'Ticket service could not be updated, please contact system administrator!',
                }
        }
    }

    # update Ticket->SLA
    if ( $Ticket->{SLA} || $Ticket->{SLAID} ) {
        my $Success;

        # prevent comparison errors on undefined values
        if ( !defined $TicketData{SLA} ) {
            $TicketData{SLA} = '';
        }
        if ( !defined $TicketData{SLAID} ) {
            $TicketData{SLAID} = '';
        }

        if ( defined $Ticket->{SLA} && $Ticket->{SLA} ne $TicketData{SLA} ) {
            $Success = $TicketObject->TicketSLASet(
                SLA      => $Ticket->{SLA},
                TicketID => $TicketID,
                UserID   => $Param{UserID},
            );
        }
        elsif ( defined $Ticket->{SLAID} && $Ticket->{SLAID} ne $TicketData{SLAID} )
        {
            $Success = $TicketObject->TicketSLASet(
                SLAID    => $Ticket->{SLAID},
                TicketID => $TicketID,
                UserID   => $Param{UserID},
            );
        }
        else {

            # data is the same as in ticket nothing to do
            $Success = 1;
        }

        if ( !$Success ) {
            return {
                Success => 0,
                Errormessage =>
                    'Ticket SLA could not be updated, please contact system administrator!',
                }
        }
    }

    # update Ticket->Priority
    if ( $Ticket->{Priority} || $Ticket->{PriorityID} ) {
        my $Success;
        if ( defined $Ticket->{Priority} && $Ticket->{Priority} ne $TicketData{Priority} ) {
            $Success = $TicketObject->TicketPrioritySet(
                Priority => $Ticket->{Priority},
                TicketID => $TicketID,
                UserID   => $Param{UserID},
            );
        }
        elsif ( defined $Ticket->{PriorityID} && $Ticket->{PriorityID} ne $TicketData{PriorityID} )
        {
            $Success = $TicketObject->TicketPrioritySet(
                PriorityID => $Ticket->{PriorityID},
                TicketID   => $TicketID,
                UserID     => $Param{UserID},
            );
        }
        else {

            # data is the same as in ticket nothing to do
            $Success = 1;
        }

        if ( !$Success ) {
            return {
                Success => 0,
                Errormessage =>
                    'Ticket priority could not be updated, please contact system administrator!',
                }
        }
    }

    my $UnlockOnAway = 1;

    # update Ticket->Owner
    if ( $Ticket->{Owner} || $Ticket->{OwnerID} ) {
        my $Success;
        if ( defined $Ticket->{Owner} && $Ticket->{Owner} ne $TicketData{Owner} ) {
            $Success = $TicketObject->TicketOwnerSet(
                NewUser  => $Ticket->{Owner},
                TicketID => $TicketID,
                UserID   => $Param{UserID},
            );
            $UnlockOnAway = 0;
        }
        elsif ( defined $Ticket->{OwnerID} && $Ticket->{OwnerID} ne $TicketData{OwnerID} )
        {
            $Success = $TicketObject->TicketOwnerSet(
                NewUserID => $Ticket->{OwnerID},
                TicketID  => $TicketID,
                UserID    => $Param{UserID},
            );
            $UnlockOnAway = 0;
        }
        else {

            # data is the same as in ticket nothing to do
            $Success = 1;
        }

        if ( !$Success ) {
            return {
                Success => 0,
                Errormessage =>
                    'Ticket owner could not be updated, please contact system administrator!',
                }
        }
    }

    # update Ticket->Responsible
    if ( $Ticket->{Responsible} || $Ticket->{ResponsibleID} ) {
        my $Success;
        if (
            defined $Ticket->{Responsible}
            && $Ticket->{Responsible} ne $TicketData{Responsible}
            )
        {
            $Success = $TicketObject->TicketResponsibleSet(
                NewUser  => $Ticket->{Responsible},
                TicketID => $TicketID,
                UserID   => $Param{UserID},
            );
        }
        elsif (
            defined $Ticket->{ResponsibleID}
            && $Ticket->{ResponsibleID} ne $TicketData{ResponsibleID}
            )
        {
            $Success = $TicketObject->TicketResponsibleSet(
                NewUserID => $Ticket->{ResponsibleID},
                TicketID  => $TicketID,
                UserID    => $Param{UserID},
            );
        }
        else {

            # data is the same as in ticket nothing to do
            $Success = 1;
        }

        if ( !$Success ) {
            return {
                Success => 0,
                Errormessage =>
                    'Ticket responsible could not be updated, please contact system administrator!',
                }
        }
    }

    # set dynamic fields
    for my $DynamicField ( @{$DynamicFieldList} ) {
        
        my $Result = $Self->_SetDynamicFieldValue(
            %{$DynamicField},
            TicketID  => $TicketID,
            # ArticleID => $ArticleID || '',
            UserID    => $Param{UserID},
        );

        if ( !$Result->{Success} ) {
            my $ErrorMessage =
                $Result->{ErrorMessage} || "Dynamic Field $DynamicField->{Name} could not be set,"
                . " please contact the system administrator";

            return {
                Success      => 0,
                ErrorMessage => $ErrorMessage,
            };
        }
    }

    return {
        Success => 1,
        Data    => {
            TicketID     => $TicketID,
            TicketNumber => $TicketData{TicketNumber},
        },
    };
}

=head2 _SetDynamicFieldValue()
sets the value of a dynamic field.
    my $Result = $CommonObject->SetDynamicFieldValue(
        Name      => 'some name',           # the name of the dynamic field
        Value     => 'some value',          # String or Integer or DateTime format
        TicketID  => 123
        ArticleID => 123
        UserID    => 123,
    );
    my $Result = $CommonObject->SetDynamicFieldValue(
        Name   => 'some name',           # the name of the dynamic field
        Value => [
            'some value',
            'some other value',
        ],
        UserID => 123,
    );
    returns
    $Result = {
        Success => 1,                        # if everything is ok
    }
    $Result = {
        Success      => 0,
        ErrorMessage => 'Error description'
    }
=cut

sub _SetDynamicFieldValue {
    my ( $Self, %Param ) = @_;

    # get the dynamic fields
    my $DynamicField = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldListGet(
        Valid      => 1,
        ObjectType => [ 'Ticket'],
    );

    # create a Dynamic Fields lookup table (by name)
    DYNAMICFIELD:
    for my $DynamicField ( @{$DynamicField} ) {
        next DYNAMICFIELD if !$DynamicField;
        next DYNAMICFIELD if !IsHashRefWithData($DynamicField);
        next DYNAMICFIELD if !$DynamicField->{Name};
        $Self->{DynamicFieldLookup}->{ $DynamicField->{Name} } = $DynamicField;
    }
    # check needed stuff
    for my $Needed (qw(Name UserID)) {
        if ( !IsString( $Param{$Needed} ) ) {
            return {
                Success      => 0,
                ErrorMessage => "SetDynamicFieldValue() Invalid value for $Needed, just string is allowed!"
            };
        }
    }

    # check value structure
    if ( !IsString( $Param{Value} ) && ref $Param{Value} ne 'ARRAY' ) {
        return {
            Success      => 0,
            ErrorMessage => "SetDynamicFieldValue() Invalid value for Value, just string and array are allowed!"
        };
    }

    return if !IsHashRefWithData( $Self->{DynamicFieldLookup} );

    # get dynamic field config
    my $DynamicFieldConfig = $Self->{DynamicFieldLookup}->{ $Param{Name} };

    my $ObjectID;
    if ( $DynamicFieldConfig->{ObjectType} eq 'Ticket' ) {
        $ObjectID = $Param{TicketID} || '';
    }
    else {
        $ObjectID = $Param{ArticleID} || '';
    }

    if ( !$ObjectID ) {
        return {
            Success      => 0,
            ErrorMessage => "SetDynamicFieldValue() Could not set $ObjectID!",
        };
    }

    my $Success = $Kernel::OM->Get('Kernel::System::DynamicField::Backend')->ValueSet(
        DynamicFieldConfig => $DynamicFieldConfig,
        ObjectID           => $ObjectID,
        Value              => $Param{Value},
        UserID             => $Param{UserID},
    );

    return {
        Success => $Success,
    };
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut