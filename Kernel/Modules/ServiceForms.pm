# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::ServiceForms;

use strict;
use warnings;

use Data::Dumper;

use Kernel::System::VariableCheck qw(:all);

use utf8;

our $ObjectManagerDisabled = 1;

sub new {
	my ( $Type, %Param ) = @_;
	
    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    my $Action = $Self->{Action}||'';
    
    # Para execução caso não seja uma das telas abaixo
    if ($Action !~ /(AgentTicketPhone|AgentTicketEmail|CustomerTicketMessage)/ ){
        return $Self;
    }

    my $DfByServiceObject = $Kernel::OM->Get('Kernel::System::DynamicFieldByService');
    # Verifica se há o parametro ServiceID
    my $ServiceID  = $Kernel::OM->Get('Kernel::System::Web::Request')->GetParam( Param => 'ServiceID' ) || '';
	my $Subaction = $Self->{Subaction} || '';	    
	 
    # Para execução se não houver SubAction
    if($Subaction eq ''){
        return $Self;
    }
    my $DynamicFieldsByService;
    $DynamicFieldsByService = $DfByServiceObject->GetDynamicFieldByService(ServiceID => $ServiceID) if $ServiceID;
    my %HashDosCampos;

    # COMPLEMENTO: 16-05-06
    if ($DynamicFieldsByService->{Config}){
	    DIALOGFIELD:
		    for my $CurrentField ( @{ $DynamicFieldsByService->{Config}{FieldOrder} } ) {
			    my %FieldData = %{ $DynamicFieldsByService->{Config}{Fields}{$CurrentField} };

			    # next DIALOGFIELD if !$FieldData{Display};
	
	       	    # render DynamicFields
	            if ( $CurrentField =~ m{^DynamicField_(.*)}xms ) {
           	    	my $DynamicFieldName = $1;
				    $HashDosCampos{$DynamicFieldName} = $FieldData{Display}; 	
           		}
	    }
    }
    # return $Self if(!%HashDosCampos);
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');   
	my $HashOld = $ConfigObject->Get("Ticket::Frontend::$Action"); 
	foreach my $Keys (keys %{$HashOld->{DynamicField}}){
		$HashDosCampos{$Keys} = $HashOld->{DynamicField}{$Keys};
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
    for my $Key (qw(
        NewStateID NewPriorityID TimeUnits IsVisibleForCustomer Title Body Subject NewQueueID
        Year Month Day Hour Minute NewOwnerID NewResponsibleID TypeID ServiceID SLAID
        Expand ReplyToArticle StandardTemplateID CreateArticle FormDraftID Title
        )
        )
    {
        $GetParam{$Key} = $ParamObject->GetParam( Param => $Key );
    }

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

    # define the dynamic fields to show based on the object type
    # my $ObjectType = ['Ticket'];

    # # only screens that add notes can modify Article dynamic fields
    # # if ( $Config->{Note} ) {
    # #     $ObjectType = [ 'Ticket', 'Article' ];
    # # }

    # # get the dynamic fields for this screen
    my $DynamicField = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldListGet(
        Valid       => 1,
        ObjectType  => [ 'Ticket', 'Article' ],
        # FieldFilter => $Config->{DynamicField} || {},
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
        # Action        => $Action,
        # TicketID      => $TicketID,
        ############# Pegar dados
        %GetParam,
        # DynamicField  => {                            # Optional
        #     DynamicField_Agua => 'Doce',
        # },
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
                $HashDosCampos{$DynamicFieldName} = '2';
            } elsif ( $AclAction{$CurrentField} =~ m{^DF_(.*)}xms ) {
                my $DynamicFieldName = $1;
                $HashDosCampos{$DynamicFieldName} = '1';
            }
	    }
    }

    # Exemplo:
    # Altera o valor dos campos
    $ConfigObject->Set(
        Key   => "Ticket::Frontend::$Action###DynamicField",
        Value => \%HashDosCampos
    );

    return $Self;
}

sub PreRun {
    my ( $Self, %Param ) = @_;
    return;
}

sub Run {
    my ( $Self, %Param ) = @_;
    return;

}

1;
