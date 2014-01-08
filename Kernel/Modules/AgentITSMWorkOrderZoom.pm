# --
# Kernel/Modules/AgentITSMWorkOrderZoom.pm - the OTRS ITSM ChangeManagement workorder zoom module
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentITSMWorkOrderZoom;

use strict;
use warnings;

use Kernel::System::HTMLUtils;
use Kernel::System::ITSMChange;
use Kernel::System::ITSMChange::ITSMWorkOrder;
use Kernel::System::LinkObject;

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
    $Self->{HTMLUtilsObject} = Kernel::System::HTMLUtils->new(%Param);
    $Self->{ChangeObject}    = Kernel::System::ITSMChange->new(%Param);
    $Self->{WorkOrderObject} = Kernel::System::ITSMChange::ITSMWorkOrder->new(%Param);
    $Self->{LinkObject}      = Kernel::System::LinkObject->new(%Param);

    # get config of frontend module
    $Self->{Config} = $Self->{ConfigObject}->Get("ITSMWorkOrder::Frontend::$Self->{Action}");

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # get needed WorkOrderID
    my $WorkOrderID = $Self->{ParamObject}->GetParam( Param => 'WorkOrderID' );

    # check needed stuff
    if ( !$WorkOrderID ) {
        return $Self->{LayoutObject}->ErrorScreen(
            Message => 'No WorkOrderID is given!',
            Comment => 'Please contact the admin.',
        );
    }

    # check permissions
    my $Access = $Self->{WorkOrderObject}->Permission(
        Type        => $Self->{Config}->{Permission},
        Action      => $Self->{Action},
        WorkOrderID => $WorkOrderID,
        UserID      => $Self->{UserID},
    );

    # error screen
    if ( !$Access ) {
        return $Self->{LayoutObject}->NoPermission(
            Message    => "You need $Self->{Config}->{Permission} permissions!",
            WithHeader => 'yes',
        );
    }

    # get workorder data
    my $WorkOrder = $Self->{WorkOrderObject}->WorkOrderGet(
        WorkOrderID => $WorkOrderID,
        UserID      => $Self->{UserID},
    );

    # check error
    if ( !$WorkOrder ) {
        return $Self->{LayoutObject}->ErrorScreen(
            Message => "WorkOrder '$WorkOrderID' not found in database!",
            Comment => 'Please contact the admin.',
        );
    }

    # clean the rich text fields from active HTML content
    ATTRIBUTE:
    for my $Attribute (qw(Instruction Report)) {

        next ATTRIBUTE if !$WorkOrder->{$Attribute};

        # remove active html content (scripts, applets, etc...)
        my %SafeContent = $Self->{HTMLUtilsObject}->Safety(
            String       => $WorkOrder->{$Attribute},
            NoApplet     => 1,
            NoObject     => 1,
            NoEmbed      => 1,
            NoIntSrcLoad => 0,
            NoExtSrcLoad => 0,
            NoJavaScript => 1,
        );

        # take the safe content if neccessary
        if ( $SafeContent{Replace} ) {
            $WorkOrder->{$Attribute} = $SafeContent{String};
        }
    }

    # handle DownloadAttachment
    if ( $Self->{Subaction} eq 'DownloadAttachment' ) {

        # get data for attachment
        my $Filename = $Self->{ParamObject}->GetParam( Param => 'Filename' );
        my $Type     = $Self->{ParamObject}->GetParam( Param => 'Type' );
        my $AttachmentData = $Self->{WorkOrderObject}->WorkOrderAttachmentGet(
            WorkOrderID    => $WorkOrderID,
            Filename       => $Filename,
            AttachmentType => $Type,
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

    # check if LayoutObject has TranslationObject
    if ( $Self->{LayoutObject}->{LanguageObject} ) {

        # translate parameter
        PARAM:
        for my $Param (qw(WorkOrderType)) {

            # check for parameter
            next PARAM if !$WorkOrder->{$Param};

            # translate
            $WorkOrder->{$Param} = $Self->{LayoutObject}->{LanguageObject}->Get(
                $WorkOrder->{$Param},
            );
        }
    }

    # Store LastWorkOrderView, for backlinks from workorder specific pages
    $Self->{SessionObject}->UpdateSessionID(
        SessionID => $Self->{SessionID},
        Key       => 'LastWorkOrderView',
        Value     => $Self->{RequestedURL},
    );

    # Store LastScreenOverview, for backlinks from AgentLinkObject
    $Self->{SessionObject}->UpdateSessionID(
        SessionID => $Self->{SessionID},
        Key       => 'LastScreenOverView',
        Value     => $Self->{RequestedURL},
    );

    # Store LastScreenOverview, for backlinks from 'AgentLinkObject'
    $Self->{SessionObject}->UpdateSessionID(
        SessionID => $Self->{SessionID},
        Key       => 'LastScreenView',
        Value     => $Self->{RequestedURL},
    );

    # get the change that workorder belongs to
    my $Change = $Self->{ChangeObject}->ChangeGet(
        ChangeID => $WorkOrder->{ChangeID},
        UserID   => $Self->{UserID},
    );

    # run workorder menu modules
    if ( ref $Self->{ConfigObject}->Get('ITSMWorkOrder::Frontend::MenuModule') eq 'HASH' ) {

        # get items for menu
        my %Menus   = %{ $Self->{ConfigObject}->Get('ITSMWorkOrder::Frontend::MenuModule') };
        my $Counter = 0;

        for my $Menu ( sort keys %Menus ) {

            # load module
            if ( $Self->{MainObject}->Require( $Menus{$Menu}->{Module} ) ) {
                my $Object = $Menus{$Menu}->{Module}->new(
                    %{$Self},
                    WorkOrderID => $WorkOrder->{WorkOrderID},
                );

                # set classes
                if ( $Menus{$Menu}->{Target} ) {

                    if ( $Menus{$Menu}->{Target} eq 'PopUp' ) {
                        $Menus{$Menu}->{MenuClass} = 'AsPopup';
                    }
                    elsif ( $Menus{$Menu}->{Target} eq 'Back' ) {
                        $Menus{$Menu}->{MenuClass} = 'HistoryBack';
                    }
                    elsif ( $Menus{$Menu}->{Target} eq 'ConfirmationDialog' ) {
                        $Menus{$Menu}->{MenuClass} = 'AsConfirmationDialog';
                    }

                }

                # run module
                $Counter = $Object->Run(
                    %Param,
                    WorkOrder => $WorkOrder,
                    Counter   => $Counter,
                    Config    => $Menus{$Menu},
                    MenuID    => $Menu,
                );
            }
            else {
                return $Self->{LayoutObject}->FatalError();
            }
        }
    }

    # output header
    my $Output = $Self->{LayoutObject}->Header(
        Title => $WorkOrder->{WorkOrderTitle},
    );
    $Output .= $Self->{LayoutObject}->NavigationBar();

    # get create user data
    my %CreateUser = $Self->{UserObject}->GetUserData(
        UserID => $WorkOrder->{CreateBy},
        Cached => 1,
    );

    # get CreateBy user information
    for my $Postfix (qw(UserLogin UserFirstname UserLastname)) {
        $WorkOrder->{ 'Create' . $Postfix } = $CreateUser{$Postfix};
    }

    # get change user data
    my %ChangeUser = $Self->{UserObject}->GetUserData(
        UserID => $WorkOrder->{ChangeBy},
        Cached => 1,
    );

    # get ChangeBy user information
    for my $Postfix (qw(UserLogin UserFirstname UserLastname)) {
        $WorkOrder->{ 'Change' . $Postfix } = $ChangeUser{$Postfix};
    }

    # output meta block
    $Self->{LayoutObject}->Block(
        Name => 'Meta',
        Data => {
            %{$WorkOrder},
        },
    );

    # show values or dash ('-')
    for my $BlockName (
        qw(WorkOrderType PlannedStartTime PlannedEndTime ActualStartTime ActualEndTime)
        )
    {
        if ( $WorkOrder->{$BlockName} ) {
            $Self->{LayoutObject}->Block(
                Name => $BlockName,
                Data => {
                    $BlockName => $WorkOrder->{$BlockName},
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
    for my $BlockName (qw(PlannedEffort AccountedTime)) {

        # skip if block is switched off in SysConfig
        next BLOCKNAME if !$Self->{Config}->{$BlockName};

        # show block
        $Self->{LayoutObject}->Block(
            Name => 'Show' . $BlockName,
        );

        # show value or dash
        if ( $WorkOrder->{$BlockName} ) {
            $Self->{LayoutObject}->Block(
                Name => $BlockName,
                Data => {
                    $BlockName => $WorkOrder->{$BlockName},
                },
            );
        }
        else {
            $Self->{LayoutObject}->Block(
                Name => 'Empty' . $BlockName,
            );
        }
    }

    # get all workorder freekey and freetext numbers from workorder
    my %WorkOrderFreeTextFields;
    ATTRIBUTE:
    for my $Attribute ( sort keys %{$WorkOrder} ) {

        # get the freetext number, only look at the freetext field,
        # as we do not want to show empty fields in the zoom view
        if ( $Attribute =~ m{ \A WorkOrderFreeText ( \d+ ) }xms ) {

            # do not show empty freetext values
            next ATTRIBUTE if $WorkOrder->{$Attribute} eq '';

            # get the freetext number
            my $Number = $1;

            # remember the freetext number
            $WorkOrderFreeTextFields{$Number}++;
        }
    }

    # show workorder freetext fields block
    if (%WorkOrderFreeTextFields) {

        $Self->{LayoutObject}->Block(
            Name => 'WorkOrderFreeTextFields',
            Data => {},
        );
    }

    # show the workorder freetext fields
    for my $Number ( sort { $a <=> $b } keys %WorkOrderFreeTextFields ) {

        $Self->{LayoutObject}->Block(
            Name => 'WorkOrderFreeText' . $Number,
            Data => {
                %{$WorkOrder},
            },
        );
        $Self->{LayoutObject}->Block(
            Name => 'WorkOrderFreeText',
            Data => {
                WorkOrderFreeKey  => $WorkOrder->{ 'WorkOrderFreeKey' . $Number },
                WorkOrderFreeText => $WorkOrder->{ 'WorkOrderFreeText' . $Number },
            },
        );

        # show freetext field as link
        if ( $Self->{ConfigObject}->Get( 'WorkOrderFreeText' . $Number . '::Link' ) ) {

            $Self->{LayoutObject}->Block(
                Name => 'WorkOrderFreeTextLink' . $Number,
                Data => {
                    %{$WorkOrder},
                },
            );
            $Self->{LayoutObject}->Block(
                Name => 'WorkOrderFreeTextLink',
                Data => {
                    %{$WorkOrder},
                    WorkOrderFreeTextLink => $Self->{ConfigObject}->Get(
                        'WorkOrderFreeText' . $Number . '::Link'
                    ),
                    WorkOrderFreeKey  => $WorkOrder->{ 'WorkOrderFreeKey' . $Number },
                    WorkOrderFreeText => $WorkOrder->{ 'WorkOrderFreeText' . $Number },
                },
            );
        }

        # show freetext field as plain text
        else {
            $Self->{LayoutObject}->Block(
                Name => 'WorkOrderFreeTextPlain' . $Number,
                Data => {
                    %{$WorkOrder},
                },
            );
            $Self->{LayoutObject}->Block(
                Name => 'WorkOrderFreeTextPlain',
                Data => {
                    %{$WorkOrder},
                    WorkOrderFreeKey  => $WorkOrder->{ 'WorkOrderFreeKey' . $Number },
                    WorkOrderFreeText => $WorkOrder->{ 'WorkOrderFreeText' . $Number },
                },
            );
        }
    }

    # get change builder user
    my %ChangeBuilderUser;
    if ( $Change->{ChangeBuilderID} ) {
        %ChangeBuilderUser = $Self->{UserObject}->GetUserData(
            UserID => $Change->{ChangeBuilderID},
            Cached => 1,
        );
    }

    # get change builder information
    for my $Postfix (qw(UserLogin UserFirstname UserLastname)) {
        $WorkOrder->{ 'ChangeBuilder' . $Postfix } = $ChangeBuilderUser{$Postfix} || '';
    }

    # output change builder block
    if (%ChangeBuilderUser) {

        # show name and mail address if user exists
        $Self->{LayoutObject}->Block(
            Name => 'ChangeBuilder',
            Data => {
                %{$WorkOrder},
            },
        );
    }
    else {

        # show dash if no change builder exists
        $Self->{LayoutObject}->Block(
            Name => 'EmptyChangeBuilder',
            Data => {},
        );
    }

    # get workorder agent user
    if ( $WorkOrder->{WorkOrderAgentID} ) {
        my %WorkOrderAgentUser = $Self->{UserObject}->GetUserData(
            UserID => $WorkOrder->{WorkOrderAgentID},
            Cached => 1,
        );

        if (%WorkOrderAgentUser) {

            # get WorkOrderAgent information
            for my $Postfix (qw(UserLogin UserFirstname UserLastname)) {
                $WorkOrder->{ 'WorkOrderAgent' . $Postfix } = $WorkOrderAgentUser{$Postfix} || '';
            }

            # output WorkOrderAgent information
            $Self->{LayoutObject}->Block(
                Name => 'WorkOrderAgent',
                Data => {
                    %{$WorkOrder},
                },
            );
        }
    }

    # output if no WorkOrderAgent is found
    if ( !$WorkOrder->{WorkOrderAgentUserLogin} ) {
        $Self->{LayoutObject}->Block(
            Name => 'EmptyWorkOrderAgent',
            Data => {},
        );
    }

    # get linked objects
    my $LinkListWithData = $Self->{LinkObject}->LinkListWithData(
        Object => 'ITSMWorkOrder',
        Key    => $WorkOrderID,
        State  => 'Valid',
        UserID => $Self->{UserID},
    );

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
    my @Attachments = $Self->{WorkOrderObject}->WorkOrderAttachmentList(
        WorkOrderID => $WorkOrderID,
    );

    # show attachments
    ATTACHMENT:
    for my $Filename (@Attachments) {

        # get info about file
        my $AttachmentData = $Self->{WorkOrderObject}->WorkOrderAttachmentGet(
            WorkOrderID => $WorkOrderID,
            Filename    => $Filename,
        );

        # check for attachment information
        next ATTACHMENT if !$AttachmentData;

        # do not show inline attachments in attachments list (they have a content id)
        next ATTACHMENT if $AttachmentData->{Preferences}->{ContentID};

        # show block
        $Self->{LayoutObject}->Block(
            Name => 'AttachmentRow',
            Data => {
                %{$WorkOrder},
                %{$AttachmentData},
            },
        );
    }

    # get report attachments
    my @ReportAttachments = $Self->{WorkOrderObject}->WorkOrderReportAttachmentList(
        WorkOrderID => $WorkOrderID,
    );

    # show report attachments
    ATTACHMENT:
    for my $Filename (@ReportAttachments) {

        # get info about file
        my $AttachmentData = $Self->{WorkOrderObject}->WorkOrderAttachmentGet(
            WorkOrderID    => $WorkOrderID,
            Filename       => $Filename,
            AttachmentType => 'WorkOrderReport',
        );

        # check for attachment information
        next ATTACHMENT if !$AttachmentData;

        # do not show inline attachments in attachments list (they have a content id)
        next ATTACHMENT if $AttachmentData->{Preferences}->{ContentID};

        # show block
        $Self->{LayoutObject}->Block(
            Name => 'ReportAttachmentRow',
            Data => {
                %{$WorkOrder},
                %{$AttachmentData},
            },
        );
    }

    # start template output
    $Output .= $Self->{LayoutObject}->Output(
        TemplateFile => 'AgentITSMWorkOrderZoom',
        Data         => {
            %{$Change},
            %{$WorkOrder},
        },
    );

    # add footer
    $Output .= $Self->{LayoutObject}->Footer();

    return $Output;
}

1;
