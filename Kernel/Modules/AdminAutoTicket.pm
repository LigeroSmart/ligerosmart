# --
# Kernel/Modules/AdminAutoTicket.pm - provides admin std AutoTicket module
# --
# @TODO @todo
# Attachments in tickets
# Difference between text/plain and html
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AdminAutoTicket;

use strict;
use warnings;

use Kernel::System::AutoTicket;
use Kernel::System::Type;
use Kernel::System::Valid;
use Kernel::System::HTMLUtils;
use Kernel::System::Service;
use Kernel::System::SLA;
use Kernel::System::Queue;
use Kernel::System::State;
use Kernel::System::Priority;
use Kernel::System::DynamicField;
use Kernel::System::DynamicField::Backend;
use Kernel::System::VariableCheck qw(:all);

use vars qw($VERSION);
$VERSION = qw($Revision: 1.55 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );



   

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;
    my $AutoTicketObject	= $Kernel::OM->Get('Kernel::System::AutoTicket');
    my $ValidObject 		= $Kernel::OM->Get('Kernel::System::Valid');
    my $TypeObject 		= $Kernel::OM->Get('Kernel::System::Type');
    my $HTMLUtilsObject		= $Kernel::OM->Get('Kernel::System::HTMLUtils');
    my $ServiceObject		= $Kernel::OM->Get('Kernel::System::Service');
    my $SLAObject		= $Kernel::OM->Get('Kernel::System::SLA');
    my $QueueObject		= $Kernel::OM->Get('Kernel::System::Queue');
    my $StateObject 		= $Kernel::OM->Get('Kernel::System::State');
    my $PriorityObject		= $Kernel::OM->Get('Kernel::System::Priority');
    my $DynamicFieldObject 	= $Kernel::OM->Get('Kernel::System::DynamicField');
    my $BackendObject 		= $Kernel::OM->Get('Kernel::System::DynamicField::Backend');
    $Self->{DynamicField} 	= $DynamicFieldObject->DynamicFieldListGet(
        Valid      => 1,
        ObjectType => ['Ticket','Article'],
    );
    my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $LayoutObject   = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    # ------------------------------------------------------------ #
    # change
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'Change' ) {
        my $ID = $ParamObject->GetParam( Param => 'ID' ) || '';
        my %Data = $AutoTicketObject->AutoTicketGet( ID => $ID, );

#  # Maybe we can attach files in the future
#        my @SelectedAttachment;
#        my %SelectedAttachmentData = $Self->{StdAttachmentObject}->StdAttachmentsByAutoTicketID(
#            ID => $ID,
#        );
#        for my $Key ( keys %SelectedAttachmentData ) {
#            push @SelectedAttachment, $Key;
#        }

        my $Output = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar();
        $Self->_Edit(
            Action => 'Change',
            %Data,
#            SelectedAttachments => \@SelectedAttachment,
        );
        $Output .= $LayoutObject->Output(
            TemplateFile => 'AdminAutoTicket',
            Data         => \%Param,
        );
        $Output .= $LayoutObject->Footer();
        return $Output;
    }

    # ------------------------------------------------------------ #
    # change action
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'ChangeAction' ) {

        # challenge token check for write action
        $LayoutObject->ChallengeTokenCheck();

        my @NewIDs = $ParamObject->GetArray( Param => 'IDs' );
        my ( %GetParam, %Errors );

        for my $Parameter (qw(ID Name TypeID ServiceID Customer CustomerID IsVisibleForCustomer SLAID QueueID StateID PriorityID Title Message NoAgentNotify Nwd Weekday Monthday Months Hour Minutes Comment ValidID)) {
            $GetParam{$Parameter} = $ParamObject->GetParam( Param => $Parameter ) || '';
        }
		$GetParam{IsVisibleForCustomer} = $GetParam{IsVisibleForCustomer} ? 1 : 0;

        # get composed content type
#        $GetParam{ContentType} = 'text/plain';
#        if ( $LayoutObject->{BrowserRichText} ) {
#            $GetParam{ContentType} = 'text/html';
#        }

        # check needed data
        $GetParam{Minutes} =$GetParam{Minutes}||"00";
        for my $Needed (qw(Name ValidID TypeID QueueID StateID PriorityID Title Hour Minutes)) {
            if ( !$GetParam{$Needed} ) {
                $Errors{ $Needed . 'Invalid' } = 'ServerError';
            }
        }

	# Take Weekday fields from template and convert into one string split by ;
	$GetParam{Weekday}='';
        my @wdays = $ParamObject->GetArray( Param => "Weekday" );
	for (@wdays) {
            $GetParam{Weekday} .= "$_;";
	}

	# Get months selections
	$GetParam{Months}='';
	my @months= $ParamObject->GetArray( Param => "Months" );
        for (@months) {
            $GetParam{Months} .= "$_;";
        }
        
        
    # GET DYNAMIC FIELDS FOR UPDATE ACTION
    # get dynamic fields to set from web request
    # to store dynamic fields profile data
    my %DynamicFieldValues;

    # cycle trough the activated Dynamic Fields for this screen
    DYNAMICFIELD:
    for my $DynamicFieldConfig ( @{ $Self->{DynamicField} } ) {
        next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

        # extract the dynamic field value form the web request
        my $DynamicFieldValue = $BackendObject->EditFieldValueGet(
            DynamicFieldConfig      => $DynamicFieldConfig,
            ParamObject             => $ParamObject,
            LayoutObject            => $LayoutObject,
            ReturnTemplateStructure => 1,
        );

        # set the comple value structure in GetParam to store it later in the Generic Agent Job
        if ( IsHashRefWithData($DynamicFieldValue) ) {
            %DynamicFieldValues = ( %DynamicFieldValues, %{$DynamicFieldValue} );
        }
    }

        # if no errors occurred
        if ( !%Errors ) {

            # update group
            if (
                $AutoTicketObject
                ->AutoTicketUpdate(
                     %GetParam,
                     %DynamicFieldValues,
                     UserID => $Self->{UserID} )
                )
            {

                # update attachments to AutoTicket
#                $Self->{StdAttachmentObject}->StdAttachmentSetAutoTickets(
#                    AttachmentIDsRef => \@NewIDs,
#                    ID               => $GetParam{ID},
#                    UserID           => $Self->{UserID},
#                );

                $Self->_Overview();
                my $Output = $LayoutObject->Header();
                $Output .= $LayoutObject->NavigationBar();
                $Output .= $LayoutObject->Notify( Info => 'AutoTicket updated!' );
                $Output .= $LayoutObject->Output(
                    TemplateFile => 'AdminAutoTicket',
                    Data         => \%Param,
                );
                $Output .= $LayoutObject->Footer();
                return $Output;
            }
        }

        # something has gone wrong
        my $Output = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar();
        $Output .= $LayoutObject->Notify( Priority => 'Error' );
        $Self->_Edit(
            Action              => 'Change',
            Errors              => \%Errors,
            SelectedAttachments => \@NewIDs,
            %GetParam,
        );
        $Output .= $LayoutObject->Output(
            TemplateFile => 'AdminAutoTicket',
            Data         => \%Param,
        );
        $Output .= $LayoutObject->Footer();
        return $Output;
    }

    # ------------------------------------------------------------ #
    # add
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'Add' ) {
        my %GetParam;
        $GetParam{Name} = $ParamObject->GetParam( Param => 'Name' );
        
        my $Output = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar();
        $Self->_Edit(
            Action => 'Add',
            %GetParam,
        );
        $Output .= $LayoutObject->Output(
            TemplateFile => 'AdminAutoTicket',
            Data         => \%Param,
        );
        $Output .= $LayoutObject->Footer();
        return $Output;
    }

    # ------------------------------------------------------------ #
    # add action
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'AddAction' ) {

        # challenge token check for write action
        $LayoutObject->ChallengeTokenCheck();

        my @NewIDs = $ParamObject->GetArray( Param => 'IDs' );
        my ( %GetParam, %Errors );

        for my $Parameter (qw(ID Name TypeID ServiceID SLAID QueueID StateID PriorityID Title Customer CustomerID IsVisibleForCustomer Message NoAgentNotify Nwd Weekday Monthday Months Hour Minutes Comment ValidID)) {
            $GetParam{$Parameter} = $ParamObject->GetParam( Param => $Parameter ) || '';
        }

		$GetParam{IsVisibleForCustomer} = $GetParam{IsVisibleForCustomer} || 0;
		
	# Take Weekday fields from template and convert into one string split by ;
	$GetParam{Weekday}='';
        my @wdays = $ParamObject->GetArray( Param => "Weekday" );
	for (@wdays) {
            $GetParam{Weekday} .= "$_;";
	}

	# Get months selections
	$GetParam{Months}='';
	my @months= $ParamObject->GetArray( Param => "Months" );
        for (@months) {
            $GetParam{Months} .= "$_;";
        }
        
        
        
        # get composed content type
#        $GetParam{ContentType} = 'text/plain';
#        if ( $LayoutObject->{BrowserRichText} ) {
#            $GetParam{ContentType} = 'text/html';
#        }
    # GET DYNAMIC FIELDS FOR UPDATE ACTION
    # get dynamic fields to set from web request
    # to store dynamic fields profile data
    my %DynamicFieldValues;

    # cycle trough the activated Dynamic Fields for this screen
    DYNAMICFIELD:
    for my $DynamicFieldConfig ( @{ $Self->{DynamicField} } ) {
        next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

        # extract the dynamic field value form the web request
        my $DynamicFieldValue = $BackendObject->EditFieldValueGet(
            DynamicFieldConfig      => $DynamicFieldConfig,
            ParamObject             => $ParamObject,
            LayoutObject            => $LayoutObject,
            ReturnTemplateStructure => 1,
        );

        # set the comple value structure in GetParam to store it later in the Generic Agent Job
        if ( IsHashRefWithData($DynamicFieldValue) ) {
            %DynamicFieldValues = ( %DynamicFieldValues, %{$DynamicFieldValue} );
        }
    }


        # check needed data
        $GetParam{Minutes} =$GetParam{Minutes}||"00";
        for my $Needed (qw(Name ValidID TypeID QueueID StateID PriorityID Title Hour Minutes)) {
            if ( !$GetParam{$Needed} ) {
                $Errors{ $Needed . 'Invalid' } = 'ServerError';
            }
        }

        # if no errors occurred
        if ( !%Errors ) {

            # add AutoTicket
            my $AutoTicketID
                = $AutoTicketObject
                ->AutoTicketAdd( 
                    %GetParam,
                    %DynamicFieldValues,
                    UserID => $Self->{UserID} );
            if ($AutoTicketID) {
                $Self->_Overview();
                my $Output = $LayoutObject->Header();
                $Output .= $LayoutObject->NavigationBar();
                $Output .= $LayoutObject->Notify( Info => 'AutoTicket added!' );
                $Output .= $LayoutObject->Output(
                    TemplateFile => 'AdminAutoTicket',
                    Data         => \%Param,
                );
                $Output .= $LayoutObject->Footer();
                return $Output;
            }
        }

        # something has gone wrong
        my $Output = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar();
        $Output .= $LayoutObject->Notify( Priority => 'Error' );
        $Self->_Edit(
            Action              => 'Add',
            Errors              => \%Errors,
            SelectedAttachments => \@NewIDs,
            %GetParam,
        );
        $Output .= $LayoutObject->Output(
            TemplateFile => 'AdminAutoTicket',
            Data         => \%Param,
        );
        $Output .= $LayoutObject->Footer();
        return $Output;
    }

    # ------------------------------------------------------------ #
    # delete action
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'Delete' ) {

        # challenge token check for write action
        $LayoutObject->ChallengeTokenCheck();

        my $ID = $ParamObject->GetParam( Param => 'ID' );

        my $Delete = $AutoTicketObject->AutoTicketDelete(
            ID => $ID,
        );
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
            TemplateFile => 'AdminAutoTicket',
            Data         => \%Param,
        );
        $Output .= $LayoutObject->Footer();
        return $Output;
    }
}

sub _Edit {
    my ( $Self, %Param ) = @_;

    my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $LayoutObject   = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $AutoTicketObject	= $Kernel::OM->Get('Kernel::System::AutoTicket');
    my $ValidObject 		= $Kernel::OM->Get('Kernel::System::Valid');
    my $TypeObject 		= $Kernel::OM->Get('Kernel::System::Type');
    my $HTMLUtilsObject		= $Kernel::OM->Get('Kernel::System::HTMLUtils');
    my $ServiceObject		= $Kernel::OM->Get('Kernel::System::Service');
    my $SLAObject		= $Kernel::OM->Get('Kernel::System::SLA');
    my $QueueObject		= $Kernel::OM->Get('Kernel::System::Queue');
    my $StateObject 		= $Kernel::OM->Get('Kernel::System::State');
    my $PriorityObject		= $Kernel::OM->Get('Kernel::System::Priority');
    my $DynamicFieldObject 	= $Kernel::OM->Get('Kernel::System::DynamicField');
    my $BackendObject 		= $Kernel::OM->Get('Kernel::System::DynamicField::Backend');
 my $TicketObject		= $Kernel::OM->Get('Kernel::System::Ticket');
    $LayoutObject->Block(
        Name => 'Overview',
        Data => \%Param,
    );

    $LayoutObject->Block( Name => 'ActionList' );
    $LayoutObject->Block( Name => 'ActionOverview' );

    # get valid list
    my %ValidList        = $ValidObject->ValidList();
    my %ValidListReverse = reverse %ValidList;

    $Param{ValidOption} = $LayoutObject->BuildSelection(
        Data       => \%ValidList,
        Name       => 'ValidID',
        SelectedID => $Param{ValidID} || $ValidListReverse{valid},
        Class      => 'Modernize Validate_Required ' . ( $Param{Errors}->{'ValidIDInvalid'} || '' ),
    );



    # get type list
    my %TypeList        = $TypeObject->TypeList();
    my %TypeListReverse = reverse %TypeList;

    $Param{TypeOption} = $LayoutObject->BuildSelection(
        Data       => \%TypeList,
        Name       => 'TypeID',
        SelectedID => $Param{TypeID} || $TypeListReverse{type},
        Class      => 'Modernize Validate_Required ' . ( $Param{Errors}->{'TypeIDInvalid'} || '' ),
    );

    # get Service list
    my %ServiceList        = $ServiceObject->ServiceList(UserID => 1);
    my %ServiceListReverse = reverse %ServiceList;

    $Param{ServiceOption} = $LayoutObject->BuildSelection(
        Data       => \%ServiceList,
        Name       => 'ServiceID',
        SelectedID => $Param{ServiceID} || $ServiceListReverse{service},
        Class      => 'Modernize Validate_Required ' . ( $Param{Errors}->{'ServiceIDInvalid'} || '' ),
        PossibleNone=> 1,
    );

    # get SLA list
    my %SLAList        = $SLAObject->SLAList(UserID => 1);
    my %SLAListReverse = reverse %SLAList;

    $Param{SLAOption} = $LayoutObject->BuildSelection(
        Data       => \%SLAList,
        Name       => 'SLAID',
        SelectedID => $Param{SLAID} || $SLAListReverse{sla},
        Class      => 'Modernize Validate_Required ' . ( $Param{Errors}->{'SLAIDInvalid'} || '' ),
        PossibleNone=> 1,
    );

    # get queue list
    my %QueueList        = $QueueObject->QueueList();
    my %QueueListReverse = reverse %QueueList;

    $Param{QueueOption} = $LayoutObject->BuildSelection(
        Data       => \%QueueList,
        Name       => 'QueueID',
        SelectedID => $Param{QueueID} || $QueueListReverse{queue},
        Class      => 'Modernize Validate_Required ' . ( $Param{Errors}->{'QueueIDInvalid'} || '' ),
    );

    # get state list
    my %StateList        = $StateObject->StateList(UserID=>1);
    my %StateListReverse = reverse %StateList;

    $Param{StateOption} = $LayoutObject->BuildSelection(
        Data       => \%StateList,
        Name       => 'StateID',
        SelectedID => $Param{StateID} || $StateListReverse{state},
        Class      => 'Modernize Validate_Required ' . ( $Param{Errors}->{'StateIDInvalid'} || '' ),
    );


    # Display article types for article creation if notification is sent
    # only use 'email-notification-*'-type articles

    




    # NoAgentNotify
    if ($Param{NoAgentNotify} && $Param{NoAgentNotify} eq 1) {
	$Param{NoAgentNotifyOption} = ' checked="checked" ',
    }

    $Param{NwdOption} = $LayoutObject->BuildSelection(
        Data => {
        	5 => "Create at scheduled time.",
        	4 => "Create based on SLA. By Pass NBD.",
        	3 => "Create based on SLA. On NBD, solution on next business hour.",
        	2 => "Create based on SLA. On NBD, solution on previous business day.",
        	1 => "Create based on SLA. On NBD, solution on next business day.",
        },
        Name       => 'Nwd',
        SelectedID => $Param{Nwd} || 5,
        Class      => 'Modernize Validate_Required ' . ( $Param{Errors}->{'NwdInvalid'} || '' ),
        Max 	   => 255,
    );


    # Weekdays
    my @weekdays = split(/;/, $Param{Weekday});
    $Param{w0_Option} = grep(/^0$/, @weekdays)?' checked="checked" ':"";
    $Param{w1_Option} = grep(/^1$/, @weekdays)?' checked="checked" ':"";
    $Param{w2_Option} = grep(/^2$/, @weekdays)?' checked="checked" ':"";
    $Param{w3_Option} = grep(/^3$/, @weekdays)?' checked="checked" ':"";
    $Param{w4_Option} = grep(/^4$/, @weekdays)?' checked="checked" ':"";
    $Param{w5_Option} = grep(/^5$/, @weekdays)?' checked="checked" ':"";
    $Param{w6_Option} = grep(/^6$/, @weekdays)?' checked="checked" ':"";
    
    # Months
    my @months = split(/;/, $Param{Months});
    $Param{m1_Option} = grep(/^1$/, @months)?' checked="checked" ':"";
    $Param{m2_Option} = grep(/^2$/, @months)?' checked="checked" ':"";
    $Param{m3_Option} = grep(/^3$/, @months)?' checked="checked" ':"";
    $Param{m4_Option} = grep(/^4$/, @months)?' checked="checked" ':"";
    $Param{m5_Option} = grep(/^5$/, @months)?' checked="checked" ':"";
    $Param{m6_Option} = grep(/^6$/, @months)?' checked="checked" ':"";
    $Param{m7_Option} = grep(/^7$/, @months)?' checked="checked" ':"";
    $Param{m8_Option} = grep(/^8$/, @months)?' checked="checked" ':"";
    $Param{m9_Option} = grep(/^9$/, @months)?' checked="checked" ':"";
    $Param{m10_Option} = grep(/^10$/, @months)?' checked="checked" ':"";
    $Param{m11_Option} = grep(/^11$/, @months)?' checked="checked" ':"";
    $Param{m12_Option} = grep(/^12$/, @months)?' checked="checked" ':"";
    
    
    # get priority list
    my %PriorityList        = $PriorityObject->PriorityList();
    my %PriorityListReverse = reverse %PriorityList;

    $Param{PriorityOption} = $LayoutObject->BuildSelection(
        Data       => \%PriorityList,
        Name       => 'PriorityID',
        SelectedID => $Param{PriorityID} || '3',
        Class      => 'Modernize Validate_Required ' . ( $Param{Errors}->{'PriorityIDInvalid'} || '' ),
    );


#    my %AttachmentData = $Self->{StdAttachmentObject}->StdAttachmentList( Valid => 1 );
#    $Param{AttachmentOption} = $LayoutObject->BuildSelection(
#        Data         => \%AttachmentData,
#        Name         => 'IDs',
#        Multiple     => 1,
#        Size         => 6,
#        Translation  => 0,
#        PossibleNone => 1,
#        SelectedID   => $Param{SelectedAttachments},
#    );

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

    # cycle trough the activated Dynamic Fields for this screen
    DYNAMICFIELD:
    for my $DynamicFieldConfig ( @{ $Self->{DynamicField} } ) {
        next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

        my $PossibleValuesFilter;

        # check if field has PossibleValues property in its configuration
        if ( IsHashRefWithData( $DynamicFieldConfig->{Config}->{PossibleValues} ) ) {

            # convert possible values key => value to key => key for ACLs usign a Hash slice
            my %AclData = %{ $DynamicFieldConfig->{Config}->{PossibleValues} };
            @AclData{ keys %AclData } = keys %AclData;

            # set possible values filter from ACLs
            my $ACL = $TicketObject->TicketAcl(
                Action        => $Self->{Action},
                Type          => 'DynamicField_' . $DynamicFieldConfig->{Name},
                ReturnType    => 'Ticket',
                ReturnSubType => 'DynamicField_' . $DynamicFieldConfig->{Name},
                Data          => \%AclData,
                UserID        => $Self->{UserID},
            );
            if ($ACL) {
                my %Filter = $TicketObject->TicketAclData();

                # convert Filer key => key back to key => value using map
                %{$PossibleValuesFilter}
                    = map { $_ => $DynamicFieldConfig->{Config}->{PossibleValues}->{$_} }
                    keys %Filter;
            }
        }

        # get field html
        my $DynamicFieldHTML = $BackendObject->EditFieldRender(
            DynamicFieldConfig   => $DynamicFieldConfig,
            PossibleValuesFilter => $PossibleValuesFilter,
            LayoutObject         => $LayoutObject,
            ParamObject          => $ParamObject,
            UseDefaultValue      => 0,
            OverridePossibleNone => 1,
            ConfirmationNeeded   => 1,
            Template             => \%JobData,
        );

        next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldHTML);

        if ($PrintDynamicFieldsEditHeader) {
            $LayoutObject->Block( Name => 'NewDynamicField' );
            $PrintDynamicFieldsEditHeader = 0;
        }
  
        # output dynamic field
        $LayoutObject->Block(
            Name => 'NewDynamicFieldElement',
            Data => {
                Label => $DynamicFieldHTML->{Label},
                Field => $DynamicFieldHTML->{Field},
            },
        );
    }
    
    
    # shows header
    if ( $Param{Action} eq 'Change' ) {
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
	$Param{Message} = $HTMLUtilsObject->ToHTML(
		String => $Param{Message},
	);
    }
    else {

        # reformat from html to plain
	$Param{Message} = $HTMLUtilsObject->ToAscii(
		String => $Param{Message},
	);
    }
    return 1;
}

sub _Overview {
    my ( $Self, %Param ) = @_;
    my $AutoTicketObject	= $Kernel::OM->Get('Kernel::System::AutoTicket');
    my $ValidObject 		= $Kernel::OM->Get('Kernel::System::Valid');
    my $TypeObject 		= $Kernel::OM->Get('Kernel::System::Type');
    my $HTMLUtilsObject		= $Kernel::OM->Get('Kernel::System::HTMLUtils');
    my $ServiceObject		= $Kernel::OM->Get('Kernel::System::Service');
    my $SLAObject		= $Kernel::OM->Get('Kernel::System::SLA');
    my $QueueObject		= $Kernel::OM->Get('Kernel::System::Queue');
    my $StateObject 		= $Kernel::OM->Get('Kernel::System::State');
    my $PriorityObject		= $Kernel::OM->Get('Kernel::System::Priority');
    my $DynamicFieldObject 	= $Kernel::OM->Get('Kernel::System::DynamicField');
    my $BackendObject 		= $Kernel::OM->Get('Kernel::System::DynamicField::Backend');
   my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $LayoutObject   = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    $LayoutObject->Block(
        Name => 'Overview',
        Data => \%Param,
    );

    $LayoutObject->Block( Name => 'ActionList' );
    $LayoutObject->Block( Name => 'ActionAdd' );
    $LayoutObject->Block( Name => 'Filter' );

    $LayoutObject->Block(
        Name => 'OverviewResult',
        Data => \%Param,
    );
    my %List = $AutoTicketObject->AutoTicketList();

    # if there are any results, they are shown
    if (%List) {

        # get valid list
        my %ValidList = $ValidObject->ValidList();
        for my $ID ( sort { $List{$a} cmp $List{$b} } keys %List ) {

            my %Data = $AutoTicketObject->AutoTicketGet( ID => $ID, );
#            my @SelectedAttachment;
#            my %SelectedAttachmentData = $Self->{StdAttachmentObject}->StdAttachmentsByAutoTicketID(
#                ID => $ID,
#            );
#            for my $Key ( keys %SelectedAttachmentData ) {
#                push @SelectedAttachment, $Key;
#            }
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

1;
