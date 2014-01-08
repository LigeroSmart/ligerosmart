# --
# Kernel/Modules/AgentITSMChangeZoom.pm - the OTRS ITSM ChangeManagement change zoom module
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentITSMChangeZoom;

use strict;
use warnings;

use Kernel::System::HTMLUtils;
use Kernel::System::LinkObject;
use Kernel::System::CustomerUser;
use Kernel::System::ITSMChange;
use Kernel::System::ITSMChange::ITSMWorkOrder;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check needed objects
    for my $Object (
        qw(ParamObject DBObject LayoutObject LogObject ConfigObject UserObject GroupObject)
        )
    {
        if ( !$Self->{$Object} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $Object!" );
        }
    }

    # create needed objects
    $Self->{HTMLUtilsObject}    = Kernel::System::HTMLUtils->new(%Param);
    $Self->{LinkObject}         = Kernel::System::LinkObject->new(%Param);
    $Self->{CustomerUserObject} = Kernel::System::CustomerUser->new(%Param);
    $Self->{ChangeObject}       = Kernel::System::ITSMChange->new(%Param);
    $Self->{WorkOrderObject}    = Kernel::System::ITSMChange::ITSMWorkOrder->new(%Param);

    # get config of frontend module
    $Self->{Config} = $Self->{ConfigObject}->Get("ITSMChange::Frontend::$Self->{Action}");

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # get params
    my $ChangeID = $Self->{ParamObject}->GetParam( Param => "ChangeID" );

    # check needed stuff
    if ( !$ChangeID ) {
        return $Self->{LayoutObject}->ErrorScreen(
            Message => 'No ChangeID is given!',
            Comment => 'Please contact the admin.',
        );
    }

    # check permissions
    my $Access = $Self->{ChangeObject}->Permission(
        Type     => $Self->{Config}->{Permission},
        Action   => $Self->{Action},
        ChangeID => $ChangeID,
        UserID   => $Self->{UserID},
    );

    # error screen, don't show change zoom
    if ( !$Access ) {
        return $Self->{LayoutObject}->NoPermission(
            Message    => "You need $Self->{Config}->{Permission} permissions!",
            WithHeader => 'yes',
        );
    }

    # get Change
    my $Change = $Self->{ChangeObject}->ChangeGet(
        ChangeID => $ChangeID,
        UserID   => $Self->{UserID},
    );

    # check error
    if ( !$Change ) {
        return $Self->{LayoutObject}->ErrorScreen(
            Message => "Change '$ChangeID' not found in database!",
            Comment => 'Please contact the admin.',
        );
    }

    # clean the richt text fields from active HTML content
    ATTRIBUTE:
    for my $Attribute (qw(Description Justification)) {

        next ATTRIBUTE if !$Change->{$Attribute};

        # remove active html content (scripts, applets, etc...)
        my %SafeContent = $Self->{HTMLUtilsObject}->Safety(
            String       => $Change->{$Attribute},
            NoApplet     => 1,
            NoObject     => 1,
            NoEmbed      => 1,
            NoIntSrcLoad => 0,
            NoExtSrcLoad => 0,
            NoJavaScript => 1,
        );

        # take the safe content if neccessary
        if ( $SafeContent{Replace} ) {
            $Change->{$Attribute} = $SafeContent{String};
        }
    }

    # handle DownloadAttachment
    if ( $Self->{Subaction} eq 'DownloadAttachment' ) {

        # get data for attachment
        my $Filename = $Self->{ParamObject}->GetParam( Param => 'Filename' );
        my $AttachmentData = $Self->{ChangeObject}->ChangeAttachmentGet(
            ChangeID => $ChangeID,
            Filename => $Filename,
        );

        # return error if file does not exist
        if ( !$AttachmentData ) {
            $Self->{LogObject}->Log(
                Message  => "No such attachment ($Filename)! May be an attack!!!",
                Priority => 'error',
            );
            return $Self->{LayoutObject}->ErrorScreen();
        }

        return $Self->{LayoutObject}->Attachment(
            %{$AttachmentData},
            Type => 'attachment',
        );
    }

    # Store LastChangeView, for backlinks from change specific pages
    $Self->{SessionObject}->UpdateSessionID(
        SessionID => $Self->{SessionID},
        Key       => 'LastChangeView',
        Value     => $Self->{RequestedURL},
    );

    # Store LastScreenOverview, for backlinks from AgentLinkObject
    $Self->{SessionObject}->UpdateSessionID(
        SessionID => $Self->{SessionID},
        Key       => 'LastScreenOverview',
        Value     => $Self->{RequestedURL},
    );

    # Store LastScreenOverview, for backlinks from AgentLinkObject
    $Self->{SessionObject}->UpdateSessionID(
        SessionID => $Self->{SessionID},
        Key       => 'LastScreenView',
        Value     => $Self->{RequestedURL},
    );

    # Store LastScreenWorkOrders, for backlinks from ITSMWorkOrderZoom
    $Self->{SessionObject}->UpdateSessionID(
        SessionID => $Self->{SessionID},
        Key       => 'LastScreenWorkOrders',
        Value     => $Self->{RequestedURL},
    );

    # run change menu modules
    if ( ref $Self->{ConfigObject}->Get('ITSMChange::Frontend::MenuModule') eq 'HASH' ) {

        # get items for menu
        my %Menus   = %{ $Self->{ConfigObject}->Get('ITSMChange::Frontend::MenuModule') };
        my $Counter = 0;

        for my $Menu ( sort keys %Menus ) {

            # load module
            if ( $Self->{MainObject}->Require( $Menus{$Menu}->{Module} ) ) {
                my $Object = $Menus{$Menu}->{Module}->new(
                    %{$Self},
                    ChangeID => $ChangeID,
                );

                # set classes
                if ( $Menus{$Menu}->{Target} ) {

                    if ( $Menus{$Menu}->{Target} eq 'PopUp' ) {
                        $Menus{$Menu}->{MenuClass} = 'AsPopup';
                    }
                    elsif ( $Menus{$Menu}->{Target} eq 'Back' ) {
                        $Menus{$Menu}->{MenuClass} = 'HistoryBack';
                    }

                }

                # run module
                $Counter = $Object->Run(
                    %Param,
                    Change  => $Change,
                    Counter => $Counter,
                    Config  => $Menus{$Menu},
                    MenuID  => $Menu,
                );
            }
            else {
                return $Self->{LayoutObject}->FatalError();
            }
        }
    }

    # output header
    my $Output = $Self->{LayoutObject}->Header(
        Value => $Change->{ChangeTitle},
    );
    $Output .= $Self->{LayoutObject}->NavigationBar();

    # build workorder graph in layout object
    my $WorkOrderGraph = $Self->{LayoutObject}->ITSMChangeBuildWorkOrderGraph(
        Change          => $Change,
        WorkOrderObject => $Self->{WorkOrderObject},
    );

    # display graph within an own block
    $Self->{LayoutObject}->Block(
        Name => 'WorkOrderGraph',
        Data => {
            WorkOrderGraph => $WorkOrderGraph,
        },
    );

    # get change builder data
    my %ChangeBuilderUser = $Self->{UserObject}->GetUserData(
        UserID => $Change->{ChangeBuilderID},
        Cached => 1,
    );

    # get create user data
    my %CreateUser = $Self->{UserObject}->GetUserData(
        UserID => $Change->{CreateBy},
        Cached => 1,
    );

    # get change user data
    my %ChangeUser = $Self->{UserObject}->GetUserData(
        UserID => $Change->{ChangeBy},
        Cached => 1,
    );

    # all postfixes needed for user information
    my @Postfixes = qw(UserLogin UserFirstname UserLastname);

    # get user information for ChangeBuilder, CreateBy, ChangeBy
    for my $Postfix (@Postfixes) {
        $Change->{ 'ChangeBuilder' . $Postfix } = $ChangeBuilderUser{$Postfix};
        $Change->{ 'Create' . $Postfix }        = $CreateUser{$Postfix};
        $Change->{ 'Change' . $Postfix }        = $ChangeUser{$Postfix};
    }

    # output meta block
    $Self->{LayoutObject}->Block(
        Name => 'Meta',
        Data => {
            %{$Change},
        },
    );

    # show values or dash ('-')
    for my $BlockName (qw(PlannedStartTime PlannedEndTime ActualStartTime ActualEndTime)) {
        if ( $Change->{$BlockName} ) {
            $Self->{LayoutObject}->Block(
                Name => $BlockName,
                Data => {
                    $BlockName => $Change->{$BlockName},
                },
            );
        }
        else {
            $Self->{LayoutObject}->Block(
                Name => 'Empty' . $BlockName,
            );
        }
    }

    # show configurable blocks
    BLOCKNAME:
    for my $BlockName (qw(RequestedTime PlannedEffort AccountedTime)) {

        # skip if block is switched off in SysConfig
        next BLOCKNAME if !$Self->{Config}->{$BlockName};

        # show block
        $Self->{LayoutObject}->Block(
            Name => 'Show' . $BlockName,
        );

        # show value or dash
        if ( $Change->{$BlockName} ) {
            $Self->{LayoutObject}->Block(
                Name => $BlockName,
                Data => {
                    $BlockName => $Change->{$BlockName},
                },
            );
        }
        else {
            $Self->{LayoutObject}->Block(
                Name => 'Empty' . $BlockName,
            );
        }
    }

    # show CIP
    for my $Type (qw(Category Impact Priority)) {
        $Self->{LayoutObject}->Block(
            Name => $Type,
            Data => { %{$Change} },
        );
    }

    # get all change freekey and freetext numbers from change
    my %ChangeFreeTextFields;
    ATTRIBUTE:
    for my $Attribute ( sort keys %{$Change} ) {

        # get the freetext number, only look at the freetext field,
        # as we do not want to show empty fields in the zoom view
        if ( $Attribute =~ m{ \A ChangeFreeText ( \d+ ) }xms ) {

            # do not show empty freetext values (number zero is allowed)
            next ATTRIBUTE if $Change->{$Attribute} eq '';

            # get the freetext number
            my $Number = $1;

            # remember the freetext number
            $ChangeFreeTextFields{$Number}++;
        }
    }

    # show change freetext fields block
    if (%ChangeFreeTextFields) {

        $Self->{LayoutObject}->Block(
            Name => 'ChangeFreeTextFields',
            Data => {},
        );
    }

    # show the change freetext fields
    for my $Number ( sort { $a <=> $b } keys %ChangeFreeTextFields ) {

        $Self->{LayoutObject}->Block(
            Name => 'ChangeFreeText' . $Number,
            Data => {
                %{$Change},
            },
        );
        $Self->{LayoutObject}->Block(
            Name => 'ChangeFreeText',
            Data => {
                ChangeFreeKey  => $Change->{ 'ChangeFreeKey' . $Number },
                ChangeFreeText => $Change->{ 'ChangeFreeText' . $Number },
            },
        );

        # show freetext field as link
        if ( $Self->{ConfigObject}->Get( 'ChangeFreeText' . $Number . '::Link' ) ) {

            $Self->{LayoutObject}->Block(
                Name => 'ChangeFreeTextLink' . $Number,
                Data => {
                    %{$Change},
                },
            );
            $Self->{LayoutObject}->Block(
                Name => 'ChangeFreeTextLink',
                Data => {
                    %{$Change},
                    ChangeFreeTextLink => $Self->{ConfigObject}->Get(
                        'ChangeFreeText' . $Number . '::Link'
                    ),
                    ChangeFreeKey  => $Change->{ 'ChangeFreeKey' . $Number },
                    ChangeFreeText => $Change->{ 'ChangeFreeText' . $Number },
                },
            );
        }

        # show freetext field as plain text
        else {
            $Self->{LayoutObject}->Block(
                Name => 'ChangeFreeTextPlain' . $Number,
                Data => {
                    %{$Change},
                },
            );
            $Self->{LayoutObject}->Block(
                Name => 'ChangeFreeTextPlain',
                Data => {
                    %{$Change},
                    ChangeFreeKey  => $Change->{ 'ChangeFreeKey' . $Number },
                    ChangeFreeText => $Change->{ 'ChangeFreeText' . $Number },
                },
            );
        }
    }

    # get change manager data
    my %ChangeManagerUser;
    if ( $Change->{ChangeManagerID} ) {

        # get change manager data
        %ChangeManagerUser = $Self->{UserObject}->GetUserData(
            UserID => $Change->{ChangeManagerID},
            Cached => 1,
        );
    }

    # get change manager information
    for my $Postfix (qw(UserLogin UserFirstname UserLastname)) {
        $Change->{ 'ChangeManager' . $Postfix } = $ChangeManagerUser{$Postfix} || '';
    }

    # output change manager block
    if (%ChangeManagerUser) {

        # show name and mail address if user exists
        $Self->{LayoutObject}->Block(
            Name => 'ChangeManager',
            Data => {
                %{$Change},
            },
        );
    }
    else {

        # show dash if no change manager exists
        $Self->{LayoutObject}->Block(
            Name => 'EmptyChangeManager',
            Data => {},
        );
    }

    # show CAB block when there is a CAB
    if ( @{ $Change->{CABAgents} } || @{ $Change->{CABCustomers} } ) {

        # output CAB block
        $Self->{LayoutObject}->Block(
            Name => 'CAB',
            Data => {
                %{$Change},
            },
        );

        # build and output CAB agents
        CABAGENT:
        for my $CABAgent ( @{ $Change->{CABAgents} } ) {
            next CABAGENT if !$CABAgent;

            my %CABAgentUserData = $Self->{UserObject}->GetUserData(
                UserID => $CABAgent,
                Cache  => 1,
            );

            next CABAGENT if !%CABAgentUserData;

            # build content for agent block
            my %CABAgentData;
            for my $Postfix (@Postfixes) {
                $CABAgentData{ 'CABAgent' . $Postfix } = $CABAgentUserData{$Postfix};
            }

            # output agent block
            $Self->{LayoutObject}->Block(
                Name => 'CABAgent',
                Data => {
                    %CABAgentData,
                },
            );
        }

        # build and output CAB customers
        CABCUSTOMER:
        for my $CABCustomer ( @{ $Change->{CABCustomers} } ) {
            next CABCUSTOMER if !$CABCustomer;

            my %CABCustomerUserData = $Self->{CustomerUserObject}->CustomerUserDataGet(
                User => $CABCustomer,
            );

            next CABCUSTOMER if !%CABCustomerUserData;

            # build content for CAB customer block
            my %CABCustomerData;
            for my $Postfix (@Postfixes) {
                $CABCustomerData{ 'CABCustomer' . $Postfix } = $CABCustomerUserData{$Postfix};
            }

            # output CAB customer block
            $Self->{LayoutObject}->Block(
                Name => 'CABCustomer',
                Data => {
                    %CABCustomerData,
                },
            );
        }
    }

    # show dash when no CAB exists
    else {
        $Self->{LayoutObject}->Block(
            Name => 'EmptyCAB',
        );
    }

    # get linked objects which are directly linked with this change object
    my $LinkListWithData = $Self->{LinkObject}->LinkListWithData(
        Object => 'ITSMChange',
        Key    => $ChangeID,
        State  => 'Valid',
        UserID => $Self->{UserID},
    );

    # get change initiators (customer users of linked tickets)
    my $TicketsRef = $LinkListWithData->{Ticket} || {};
    my %ChangeInitiatorsID;
    for my $LinkType ( sort keys %{$TicketsRef} ) {

        my $TicketRef = $TicketsRef->{$LinkType}->{Source};
        for my $TicketID ( sort keys %{$TicketRef} ) {

            # get id of customer user
            my $CustomerUserID = $TicketRef->{$TicketID}->{CustomerUserID};

            # if a customer
            if ($CustomerUserID) {
                $ChangeInitiatorsID{$CustomerUserID} = 'CustomerUser';
            }
            else {
                my $OwnerID = $TicketRef->{$TicketID}->{OwnerID};
                $ChangeInitiatorsID{$OwnerID} = 'User';
            }
        }
    }

    # get change initiators info
    if ( keys %ChangeInitiatorsID ) {
        $Self->{LayoutObject}->Block(
            Name => 'ChangeInitiatorExists',
        );
    }

    my $ChangeInitiators = '';
    for my $UserID ( sort keys %ChangeInitiatorsID ) {
        my %User;

        # get customer user info if CI is a customer user
        if ( $ChangeInitiatorsID{$UserID} eq 'CustomerUser' ) {
            %User = $Self->{CustomerUserObject}->CustomerUserDataGet(
                User => $UserID,
            );
        }

        # otherwise get user info
        else {
            %User = $Self->{UserObject}->GetUserData(
                UserID => $UserID,
            );
        }

        # if user info exist
        if (%User) {
            $Self->{LayoutObject}->Block(
                Name => 'ChangeInitiator',
                Data => {%User},
            );

            $User{UserLogin}     ||= '';
            $User{UserFirstname} ||= '';
            $User{UserLastname}  ||= '';

            $ChangeInitiators .= sprintf "%s (%s %s)",
                $User{UserLogin},
                $User{UserFirstname},
                $User{UserLastname};
        }
    }

    # show dash if no change initiator exists
    if ( !$ChangeInitiators ) {
        $Self->{LayoutObject}->Block(
            Name => 'EmptyChangeInitiators',
        );
    }

    # display a string with all changeinitiators
    $Change->{'Change Initators'} = $ChangeInitiators;

    # store the combined linked objects from all workorders of this change
    my $LinkListWithDataCombinedWorkOrders = {};
    for my $WorkOrderID ( @{ $Change->{WorkOrderIDs} } ) {

        # get linked objects of this workorder
        my $LinkListWithDataWorkOrder = $Self->{LinkObject}->LinkListWithData(
            Object => 'ITSMWorkOrder',
            Key    => $WorkOrderID,
            State  => 'Valid',
            UserID => $Self->{UserID},
        );

        OBJECT:
        for my $Object ( sort keys %{$LinkListWithDataWorkOrder} ) {

            # only show linked services and config items of workorder
            if ( $Object ne 'Service' && $Object ne 'ITSMConfigItem' ) {
                next OBJECT;
            }

            LINKTYPE:
            for my $LinkType ( sort keys %{ $LinkListWithDataWorkOrder->{$Object} } ) {

                DIRECTION:
                for my $Direction (
                    sort keys %{ $LinkListWithDataWorkOrder->{$Object}->{$LinkType} }
                    )
                {

                    ID:
                    for my $ID (
                        sort
                        keys %{ $LinkListWithDataWorkOrder->{$Object}->{$LinkType}->{$Direction} }
                        )
                    {

                        # combine the linked object data from all workorders
                        $LinkListWithDataCombinedWorkOrders->{$Object}->{$LinkType}->{$Direction}
                            ->{$ID}
                            = $LinkListWithDataWorkOrder->{$Object}->{$LinkType}->{$Direction}
                            ->{$ID};
                    }
                }
            }
        }
    }

    # add combined linked objects from workorder to linked objects from change object
    $LinkListWithData = {
        %{$LinkListWithData},
        %{$LinkListWithDataCombinedWorkOrders},
    };

    # get link table view mode
    my $LinkTableViewMode = $Self->{ConfigObject}->Get('LinkObject::ViewMode');

    # create the link table
    my $LinkTableStrg = $Self->{LayoutObject}->LinkObjectTableCreate(
        LinkListWithData => $LinkListWithData,
        ViewMode         => $LinkTableViewMode,
    );

    # output the link table
    if ($LinkTableStrg) {
        $Self->{LayoutObject}->Block(
            Name => 'LinkTable' . $LinkTableViewMode,
            Data => {
                LinkTableStrg => $LinkTableStrg,
            },
        );
    }

    # get attachments
    my @Attachments = $Self->{ChangeObject}->ChangeAttachmentList(
        ChangeID => $ChangeID,
    );

    # show attachments
    ATTACHMENT:
    for my $Filename (@Attachments) {

        # get info about file
        my $AttachmentData = $Self->{ChangeObject}->ChangeAttachmentGet(
            ChangeID => $ChangeID,
            Filename => $Filename,
        );

        # check for attachment information
        next ATTACHMENT if !$AttachmentData;

        # do not show inline attachments in attachments list (they have a content id)
        next ATTACHMENT if $AttachmentData->{Preferences}->{ContentID};

        # show block
        $Self->{LayoutObject}->Block(
            Name => 'AttachmentRow',
            Data => {
                %{$Change},
                %{$AttachmentData},
            },
        );
    }

    # start template output
    $Output .= $Self->{LayoutObject}->Output(
        TemplateFile => 'AgentITSMChangeZoom',
        Data         => {
            %{$Change},
        },
    );

    # add footer
    $Output .= $Self->{LayoutObject}->Footer();

    return $Output;
}

1;
