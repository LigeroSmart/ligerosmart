# --
# Kernel/Modules/AgentITSMWorkOrderEdit.pm - the OTRS::ITSM::ChangeManagement workorder edit module
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# --
# $Id: AgentITSMWorkOrderEdit.pm,v 1.48 2010-10-27 22:15:30 ub Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentITSMWorkOrderEdit;

use strict;
use warnings;

use Kernel::System::ITSMChange;
use Kernel::System::ITSMChange::ITSMWorkOrder;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.48 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check needed objects
    for my $Object (
        qw(ParamObject DBObject LayoutObject LogObject ConfigObject)
        )
    {
        if ( !$Self->{$Object} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $Object!" );
        }
    }

    # create additional objects
    $Self->{ChangeObject}    = Kernel::System::ITSMChange->new(%Param);
    $Self->{WorkOrderObject} = Kernel::System::ITSMChange::ITSMWorkOrder->new(%Param);

    # get config for frontend
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

    # get workorder data
    my $WorkOrder = $Self->{WorkOrderObject}->WorkOrderGet(
        WorkOrderID => $WorkOrderID,
        UserID      => $Self->{UserID},
    );

    # check if LayoutObject has TranslationObject
    if ( $Self->{LayoutObject}->{LanguageObject} ) {

        # translate workorder type
        $WorkOrder->{WorkOrderType} = $Self->{LayoutObject}->{LanguageObject}->Get(
            $WorkOrder->{WorkOrderType}
        );
    }

    # check error
    if ( !$WorkOrder ) {
        return $Self->{LayoutObject}->ErrorScreen(
            Message => "WorkOrder '$WorkOrderID' not found in database!",
            Comment => 'Please contact the admin.',
        );
    }

    # check permissions
    my $Access = $Self->{ChangeObject}->Permission(
        Type     => $Self->{Config}->{Permission},
        ChangeID => $WorkOrder->{ChangeID},
        UserID   => $Self->{UserID},
    );

    # error screen
    if ( !$Access ) {
        return $Self->{LayoutObject}->NoPermission(
            Message    => "You need $Self->{Config}->{Permission} permissions on the change!",
            WithHeader => 'yes',
        );
    }

    # store needed parameters in %GetParam to make it reloadable
    my %GetParam;
    for my $ParamName (
        qw(
        WorkOrderTitle Instruction
        PlannedEffort
        SaveAttachment Filename
        )
        )
    {
        $GetParam{$ParamName} = $Self->{ParamObject}->GetParam( Param => $ParamName );
    }

    # get configured workorder freetext field numbers
    my @ConfiguredWorkOrderFreeTextFields
        = $Self->{WorkOrderObject}->WorkOrderGetConfiguredFreeTextFields();

    # get workorder freetext params
    my %WorkOrderFreeTextParam;
    NUMBER:
    for my $Number (@ConfiguredWorkOrderFreeTextFields) {

        # consider only freetext fields which are activated in this frontend
        next NUMBER if !$Self->{Config}->{WorkOrderFreeText}->{$Number};

        my $Key   = 'WorkOrderFreeKey' . $Number;
        my $Value = 'WorkOrderFreeText' . $Number;

        $WorkOrderFreeTextParam{$Key}   = $Self->{ParamObject}->GetParam( Param => $Key );
        $WorkOrderFreeTextParam{$Value} = $Self->{ParamObject}->GetParam( Param => $Value );
    }

    # store time related fields in %GetParam
    for my $TimeType (qw(PlannedStartTime PlannedEndTime)) {
        for my $TimePart (qw(Year Month Day Hour Minute)) {
            my $ParamName = $TimeType . $TimePart;
            $GetParam{$ParamName} = $Self->{ParamObject}->GetParam( Param => $ParamName );
        }
    }

    # if attachment upload is requested
    if ( $GetParam{SaveAttachment} ) {
        $Self->{Subaction} = 'SaveAttachment';
    }

    # get all attachments meta data
    my @Attachments = $Self->{WorkOrderObject}->WorkOrderAttachmentList(
        WorkOrderID => $WorkOrderID,
    );

    # check if attachment should be deleted
    for my $Filename (@Attachments) {
        if ( $Self->{ParamObject}->GetParam( Param => 'DeleteAttachment' . $Filename ) ) {
            $Self->{Subaction} = 'DeleteAttachment';
        }
    }

    # Remember the reason why saving was not attempted.
    # The items are the names of the dtl validation error blocks.
    my @ValidationErrors;

    # remember the numbers of the workorder freetext fields with validation errors
    my %WorkOrderFreeTextValidationErrors;

    # update workorder
    if ( $Self->{Subaction} eq 'Save' ) {

        # update only if WorkOrderTitle is given
        if ( !$GetParam{WorkOrderTitle} ) {
            push @ValidationErrors, 'InvalidTitle';
        }

        # check whether complete times are passed and build the time stamps
        my %SystemTime;
        TIMETYPE:
        for my $TimeType (qw(PlannedStartTime PlannedEndTime)) {
            for my $TimePart (qw(Year Month Day Hour Minute)) {
                my $ParamName = $TimeType . $TimePart;
                if ( !defined $GetParam{$ParamName} ) {
                    $Self->{LogObject}->Log(
                        Priority => 'error',
                        Message  => "Need $ParamName!",
                    );
                    next TIMETYPE;
                }
            }

            # format as timestamp
            $GetParam{$TimeType} = sprintf '%04d-%02d-%02d %02d:%02d:00',
                $GetParam{ $TimeType . 'Year' },
                $GetParam{ $TimeType . 'Month' },
                $GetParam{ $TimeType . 'Day' },
                $GetParam{ $TimeType . 'Hour' },
                $GetParam{ $TimeType . 'Minute' };

            # sanity check the assembled timestamp
            $SystemTime{$TimeType} = $Self->{TimeObject}->TimeStamp2SystemTime(
                String => $GetParam{$TimeType},
            );

            # if time format is invalid
            if ( !$SystemTime{$TimeType} ) {
                push @ValidationErrors, "Invalid$TimeType";
            }
        }

        # check the ordering of the times
        if (
            $SystemTime{PlannedStartTime}
            && $SystemTime{PlannedEndTime}
            && $SystemTime{PlannedStartTime} >= $SystemTime{PlannedEndTime}
            )
        {
            push @ValidationErrors, 'InvalidPlannedEndTime';
        }

        # check format of planned effort, empty is allowed
        if ( $GetParam{PlannedEffort} !~ m{ \A \d* (?: [.] \d{1,2} )? \z }xms ) {
            push @ValidationErrors, 'InvalidPlannedEffort';
        }

        # check for required workorder freetext fields (if configured)
        for my $Number (@ConfiguredWorkOrderFreeTextFields) {
            if (
                $Self->{Config}->{WorkOrderFreeText}->{$Number}
                && $Self->{Config}->{WorkOrderFreeText}->{$Number} == 2
                && $WorkOrderFreeTextParam{ 'WorkOrderFreeText' . $Number } eq ''
                )
            {

                # remember the workorder freetext field number with validation errors
                $WorkOrderFreeTextValidationErrors{$Number}++;
            }
        }

        # if all passed data is valid
        if ( !@ValidationErrors && !%WorkOrderFreeTextValidationErrors ) {
            my $CouldUpdateWorkOrder = $Self->{WorkOrderObject}->WorkOrderUpdate(
                WorkOrderID      => $WorkOrder->{WorkOrderID},
                WorkOrderTitle   => $GetParam{WorkOrderTitle},
                Instruction      => $GetParam{Instruction},
                PlannedStartTime => $GetParam{PlannedStartTime},
                PlannedEndTime   => $GetParam{PlannedEndTime},
                PlannedEffort    => $GetParam{PlannedEffort},
                UserID           => $Self->{UserID},
                %WorkOrderFreeTextParam,
            );

            if ($CouldUpdateWorkOrder) {

                # redirect to zoom mask, when update was successful
                return $Self->{LayoutObject}->Redirect(
                    OP => $Self->{LastWorkOrderView},
                );
            }
            else {

                # show error message, when update failed
                return $Self->{LayoutObject}->ErrorScreen(
                    Message => "Was not able to update WorkOrder $WorkOrder->{WorkOrderID}!",
                    Comment => 'Please contact the admin.',
                );
            }
        }
    }

    # handle attachment actions
    elsif ( $Self->{Subaction} eq 'SaveAttachment' ) {

        my %UploadStuff = $Self->{ParamObject}->GetUploadAll(
            Param  => 'AttachmentNew',
            Source => 'string',
        );

        # check if file was already uploaded
        my $FileAlreadyUploaded = $Self->{WorkOrderObject}->WorkOrderAttachmentExists(
            Filename    => $UploadStuff{Filename},
            WorkOrderID => $WorkOrderID,
            UserID      => $Self->{UserID},
        );

        # write to virtual fs
        if ( $UploadStuff{Filename} && !$FileAlreadyUploaded ) {
            my $Success = $Self->{WorkOrderObject}->WorkOrderAttachmentAdd(
                %UploadStuff,
                WorkOrderID => $WorkOrderID,
                ChangeID    => $WorkOrder->{ChangeID},
                UserID      => $Self->{UserID},
            );

            # check for error
            if ( !$Success ) {
                push @ValidationErrors, 'FileAlreadyUploaded';
            }

            # reload attachment list
            @Attachments = $Self->{WorkOrderObject}->WorkOrderAttachmentList(
                WorkOrderID => $WorkOrderID,
            );
        }
        else {
            push @ValidationErrors, 'FileAlreadyUploaded';
        }
    }
    elsif ( $Self->{Subaction} eq 'DeleteAttachment' ) {

        for my $Filename (@Attachments) {
            if ( $Self->{ParamObject}->GetParam( Param => 'DeleteAttachment' . $Filename ) ) {

                # delete attachment
                $Self->{WorkOrderObject}->WorkOrderAttachmentDelete(
                    ChangeID    => $WorkOrder->{ChangeID},
                    WorkOrderID => $WorkOrderID,
                    Filename    => $Filename,
                    UserID      => $Self->{UserID},
                );

                # reload attachment list
                @Attachments = $Self->{WorkOrderObject}->WorkOrderAttachmentList(
                    WorkOrderID => $WorkOrderID,
                );
            }
        }
    }

    # handle attachment downloads
    elsif ( $Self->{Subaction} eq 'DownloadAttachment' ) {

        # get data for attachment
        my $AttachmentData = $Self->{WorkOrderObject}->WorkOrderAttachmentGet(
            WorkOrderID => $WorkOrderID,
            Filename    => $GetParam{Filename},
        );

        # return error if file does not exist
        if ( !$AttachmentData ) {
            $Self->{LogObject}->Log(
                Message  => "No such attachment ($GetParam{Filename})! May be an attack!!!",
                Priority => 'error',
            );
            return $Self->{LayoutObject}->ErrorScreen();
        }

        return $Self->{LayoutObject}->Attachment(
            %{$AttachmentData},
            Type => 'attachment',
        );
    }

    else {

        # delete all keys from GetParam when it is no Subaction
        %GetParam = ();

        # also reset the time fields
        for my $TimeType (qw(PlannedStartTime PlannedEndTime)) {

            if ( $WorkOrder->{$TimeType} ) {

                # get planned start time from workorder
                my $SystemTime = $Self->{TimeObject}->TimeStamp2SystemTime(
                    String => $WorkOrder->{$TimeType},
                );
                my ( $Second, $Minute, $Hour, $Day, $Month, $Year )
                    = $Self->{TimeObject}->SystemTime2Date(
                    SystemTime => $SystemTime,
                    );

                # set the parameter hash for BuildDateSelection()
                $GetParam{ $TimeType . 'Used' }   = 1;
                $GetParam{ $TimeType . 'Minute' } = $Minute;
                $GetParam{ $TimeType . 'Hour' }   = $Hour;
                $GetParam{ $TimeType . 'Day' }    = $Day;
                $GetParam{ $TimeType . 'Month' }  = $Month;
                $GetParam{ $TimeType . 'Year' }   = $Year;
            }
        }
    }

    # get change that workorder belongs to
    my $Change = $Self->{ChangeObject}->ChangeGet(
        ChangeID => $WorkOrder->{ChangeID},
        UserID   => $Self->{UserID},
    );

    # check whether change was found
    if ( !$Change ) {
        return $Self->{LayoutObject}->ErrorScreen(
            Message => "Could not find Change for WorkOrder $WorkOrderID!",
            Comment => 'Please contact the admin.',
        );
    }

    # output header
    my $Output = $Self->{LayoutObject}->Header(
        Title => $WorkOrder->{WorkOrderTitle},
    );
    $Output .= $Self->{LayoutObject}->NavigationBar();

    # add rich text editor
    if ( $Self->{ConfigObject}->Get('Frontend::RichText') ) {
        $Self->{LayoutObject}->Block(
            Name => 'RichText',
        );
    }

    # get the workorder freetext config and fillup workorder freetext fields from workorder data
    my %WorkOrderFreeTextConfig;
    NUMBER:
    for my $Number (@ConfiguredWorkOrderFreeTextFields) {

        TYPE:
        for my $Type (qw(WorkOrderFreeKey WorkOrderFreeText)) {

            # get workorder freetext fields from workorder if page is loaded the first time
            if ( !$Self->{Subaction} ) {

                $WorkOrderFreeTextParam{ $Type . $Number } ||= $WorkOrder->{ $Type . $Number };
            }

            # get config
            my $Config = $Self->{ConfigObject}->Get( $Type . $Number );

            next TYPE if !$Config;
            next TYPE if ref $Config ne 'HASH';

            # store the workorder freetext config
            $WorkOrderFreeTextConfig{ $Type . $Number } = $Config;
        }
    }

    # build the workorder freetext HTML
    my %WorkOrderFreeTextHTML = $Self->{LayoutObject}->BuildFreeTextHTML(
        Config                   => \%WorkOrderFreeTextConfig,
        WorkOrderData            => \%WorkOrderFreeTextParam,
        ConfiguredFreeTextFields => \@ConfiguredWorkOrderFreeTextFields,
    );

    # show workorder freetext fields
    my $WorkOrderFreeTextShown;
    for my $Number (@ConfiguredWorkOrderFreeTextFields) {

        # check if this freetext field should be shown in this frontend
        if ( $Self->{Config}->{WorkOrderFreeText}->{$Number} ) {

            # remember that at least one freetext field is shown
            $WorkOrderFreeTextShown = 1;

            # show single workorder freetext fields
            $Self->{LayoutObject}->Block(
                Name => 'WorkOrderFreeText' . $Number,
                Data => {
                    %WorkOrderFreeTextHTML,
                },
            );

            # show workorder freetext validation error for single workorder freetext field
            if ( $WorkOrderFreeTextValidationErrors{$Number} ) {
                $Self->{LayoutObject}->Block(
                    Name => 'InvalidWorkOrderFreeText' . $Number,
                    Data => {
                        %WorkOrderFreeTextHTML,
                    },
                );
            }

            # show all workorder freetext fields
            $Self->{LayoutObject}->Block(
                Name => 'WorkOrderFreeText',
                Data => {
                    WorkOrderFreeKeyField =>
                        $WorkOrderFreeTextHTML{ 'WorkOrderFreeKeyField' . $Number },
                    WorkOrderFreeTextField =>
                        $WorkOrderFreeTextHTML{ 'WorkOrderFreeTextField' . $Number },
                },
            );

            # show all workorder freetext validation errors
            if ( $WorkOrderFreeTextValidationErrors{$Number} ) {
                $Self->{LayoutObject}->Block(
                    Name => 'InvalidWorkOrderFreeText',
                    Data => {
                        %WorkOrderFreeTextHTML,
                    },
                );
            }
        }
    }

    # show space after workorder freetext fields
    if ($WorkOrderFreeTextShown) {

        $Self->{LayoutObject}->Block(
            Name => 'WorkOrderFreeTextSpacer',
            Data => {},
        );
    }

    # build workorder freetext java script check
    NUMBER:
    for my $Number (@ConfiguredWorkOrderFreeTextFields) {

        next NUMBER if !$Self->{Config}->{WorkOrderFreeText}->{$Number};

        # java script check for required workorder free text fields by form submit
        if ( $Self->{Config}->{WorkOrderFreeText}->{$Number} == 2 ) {
            $Self->{LayoutObject}->Block(
                Name => 'WorkOrderFreeTextCheckJs',
                Data => {
                    WorkOrderFreeKeyField  => 'WorkOrderFreeKey' . $Number,
                    WorkOrderFreeTextField => 'WorkOrderFreeText' . $Number,
                },
            );
        }
    }

    # time period that can be selected from the GUI
    my %TimePeriod = %{ $Self->{ConfigObject}->Get('ITSMWorkOrder::TimePeriod') };

    # set the time selections
    for my $TimeType (qw(PlannedStartTime PlannedEndTime)) {

        # set default value for $DiffTime
        # When no time is given yet, then use the current time plus the difftime
        # When an explicit time was retrieved, $DiffTime is not used
        my $DiffTime = $TimeType eq 'PlannedStartTime' ? 0 : 60 * 60;

        # add selection for the time
        $GetParam{ $TimeType . 'String' } = $Self->{LayoutObject}->BuildDateSelection(
            %GetParam,
            Format   => 'DateInputFormatLong',
            Prefix   => $TimeType,
            DiffTime => $DiffTime,
            %TimePeriod,
        );
    }

    # show planned effort if it is configured
    if ( $Self->{Config}->{PlannedEffort} ) {
        $Self->{LayoutObject}->Block(
            Name => 'ShowPlannedEffort',
            Data => {
                %{$WorkOrder},
                %GetParam,
            },
        );
    }

    # add the validation error messages
    for my $BlockName (@ValidationErrors) {
        $Self->{LayoutObject}->Block( Name => $BlockName );
    }

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

        # show block
        $Self->{LayoutObject}->Block(
            Name => 'AttachmentRow',
            Data => {
                %{$WorkOrder},
                %{$AttachmentData},
            },
        );
    }

    # start template output
    $Output .= $Self->{LayoutObject}->Output(
        TemplateFile => 'AgentITSMWorkOrderEdit',
        Data         => {
            %Param,
            %{$Change},
            %{$WorkOrder},
            %GetParam,
        },
    );

    # add footer
    $Output .= $Self->{LayoutObject}->Footer();

    return $Output;
}

1;
