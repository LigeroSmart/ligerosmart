# --
# Kernel/Modules/AgentITSMWorkOrderEdit.pm - the OTRS ITSM ChangeManagement workorder edit module
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
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
use Kernel::System::Web::UploadCache;

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
    $Self->{ChangeObject}      = Kernel::System::ITSMChange->new(%Param);
    $Self->{WorkOrderObject}   = Kernel::System::ITSMChange::ITSMWorkOrder->new(%Param);
    $Self->{UploadCacheObject} = Kernel::System::Web::UploadCache->new(%Param);

    # get config of frontend module
    $Self->{Config} = $Self->{ConfigObject}->Get("ITSMWorkOrder::Frontend::$Self->{Action}");

    # get form id
    $Self->{FormID} = $Self->{ParamObject}->GetParam( Param => 'FormID' );

    # create form id
    if ( !$Self->{FormID} ) {
        $Self->{FormID} = $Self->{UploadCacheObject}->FormIDCreate();
    }

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

    # check error
    if ( !$WorkOrder ) {
        return $Self->{LayoutObject}->ErrorScreen(
            Message => "WorkOrder '$WorkOrderID' not found in database!",
            Comment => 'Please contact the admin.',
        );
    }

    # check permissions
    my $Access = $Self->{ChangeObject}->Permission(
        Type        => $Self->{Config}->{Permission},
        Action      => $Self->{Action},
        ChangeID    => $WorkOrder->{ChangeID},
        WorkOrderID => $WorkOrderID,
        UserID      => $Self->{UserID},
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
    for my $ParamName (qw(WorkOrderTitle Instruction PlannedEffort AttachmentUpload FileID)) {
        $GetParam{$ParamName} = $Self->{ParamObject}->GetParam( Param => $ParamName );
    }

    # get the checkbox value and store it in %GetParam to make it reloadable
    $GetParam{MoveFollowingWorkOrders}
        = $Self->{ParamObject}->GetParam( Param => 'MoveFollowingWorkOrders' );

    # get all workorder ids for this change
    my $WorkOrderIDsRef = $Self->{WorkOrderObject}->WorkOrderList(
        ChangeID => $WorkOrder->{ChangeID},
        UserID   => $Self->{UserID},
    );

    # find out the following workorder ids
    my @FollowingWorkOrderIDs;
    my $OwnWorkOrderIDFound;
    WORKORDERID:
    for my $OtherWorkOrderID ( @{$WorkOrderIDsRef} ) {

        # check if the other workorder id is the own workorder id
        if ( $OtherWorkOrderID eq $WorkOrderID ) {
            $OwnWorkOrderIDFound = 1;
            next WORKORDERID;
        }

        # we are only interested in the following workorder ids
        next WORKORDERID if !$OwnWorkOrderIDFound;

        # collect the following workorder ids
        push @FollowingWorkOrderIDs, $OtherWorkOrderID;
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

    # Remember the reason why saving was not attempted.
    my %ValidationError;

    # update workorder
    if ( $Self->{Subaction} eq 'Save' ) {

        # challenge token check for write action
        $Self->{LayoutObject}->ChallengeTokenCheck();

        # the title is required
        if ( !$GetParam{WorkOrderTitle} ) {
            $ValidationError{WorkOrderTitleServerError} = 'ServerError';
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

            # transform work order planned time, time stamp based on user time zone
            %GetParam = $Self->{LayoutObject}->TransformDateSelection(
                %GetParam,
                Prefix => $TimeType,
            );

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

            # do not save if time is invalid
            if ( !$SystemTime{$TimeType} ) {
                $ValidationError{ $TimeType . 'Invalid' } = 'ServerError';
            }
        }

        # check validity of the planned start and end times
        if ( $SystemTime{PlannedStartTime} && !$SystemTime{PlannedEndTime} ) {
            $ValidationError{PlannedEndTimeInvalid}   = 'ServerError';
            $ValidationError{PlannedEndTimeErrorType} = 'GenericServerError';
        }
        elsif ( !$SystemTime{PlannedStartTime} && $SystemTime{PlannedEndTime} ) {
            $ValidationError{PlannedStartTimeInvalid}   = 'ServerError';
            $ValidationError{PlannedStartTimeErrorType} = 'GenericServerError';
        }
        elsif (
            ( $SystemTime{PlannedStartTime} && $SystemTime{PlannedEndTime} )
            && ( $SystemTime{PlannedEndTime} <= $SystemTime{PlannedStartTime} )
            )
        {
            $ValidationError{PlannedStartTimeInvalid}   = 'ServerError';
            $ValidationError{PlannedStartTimeErrorType} = 'BeforeThanEndTimeServerError';
        }

        # check format of planned effort, empty is allowed
        if (
            $GetParam{PlannedEffort}
            && $GetParam{PlannedEffort} !~ m{ \A \d* (?: [.] \d{1,2} )? \z }xms
            )
        {
            $ValidationError{'PlannedEffortInvalid'} = 'ServerError';
        }

        # check for required workorder freetext fields (if configured)
        for my $Number (@ConfiguredWorkOrderFreeTextFields) {
            if (
                $Self->{Config}->{WorkOrderFreeText}->{$Number}
                && $Self->{Config}->{WorkOrderFreeText}->{$Number} == 2
                && $WorkOrderFreeTextParam{ 'WorkOrderFreeText' . $Number } eq ''
                )
            {
                $WorkOrderFreeTextParam{Error}->{$Number} = 1;
                $ValidationError{ 'WorkOrderFreeText' . $Number } = 'ServerError';
            }
        }

        # check if an attachment must be deleted
        ATTACHMENT:
        for my $Number ( 1 .. 32 ) {

            # check if the delete button was pressed for this attachment
            my $Delete = $Self->{ParamObject}->GetParam( Param => "AttachmentDelete$Number" );

            # check next attachment if it was not pressed
            next ATTACHMENT if !$Delete;

            # remember that we need to show the page again
            $ValidationError{Attachment} = 1;

            # remove the attachment from the upload cache
            $Self->{UploadCacheObject}->FormIDRemoveFile(
                FormID => $Self->{FormID},
                FileID => $Number,
            );
        }

        # check if there was an attachment upload
        if ( $GetParam{AttachmentUpload} ) {

            # remember that we need to show the page again
            $ValidationError{Attachment} = 1;

            # get the uploaded attachment
            my %UploadStuff = $Self->{ParamObject}->GetUploadAll(
                Param  => 'FileUpload',
                Source => 'string',
            );

            # add attachment to the upload cache
            $Self->{UploadCacheObject}->FormIDAddFile(
                FormID => $Self->{FormID},
                %UploadStuff,
            );
        }

        # if all passed data is valid
        if ( !%ValidationError ) {
            my $CouldUpdateWorkOrder = $Self->{WorkOrderObject}->WorkOrderUpdate(
                WorkOrderID      => $WorkOrderID,
                WorkOrderTitle   => $GetParam{WorkOrderTitle},
                Instruction      => $GetParam{Instruction},
                PlannedStartTime => $GetParam{PlannedStartTime},
                PlannedEndTime   => $GetParam{PlannedEndTime},
                PlannedEffort    => $GetParam{PlannedEffort},
                UserID           => $Self->{UserID},
                %WorkOrderFreeTextParam,
            );

            # update was successful
            if ($CouldUpdateWorkOrder) {

                # get all attachments from upload cache
                my @Attachments = $Self->{UploadCacheObject}->FormIDGetAllFilesData(
                    FormID => $Self->{FormID},
                );

                # build a lookup lookup hash of the new attachments
                my %NewAttachment;
                for my $Attachment (@Attachments) {

                    # the key is the filename + filesize + content type
                    my $Key = $Attachment->{Filename}
                        . $Attachment->{Filesize}
                        . $Attachment->{ContentType};

                    # append content id if available (for new inline images)
                    if ( $Attachment->{ContentID} ) {
                        $Key .= $Attachment->{ContentID};
                    }

                    # store all of the new attachment data
                    $NewAttachment{$Key} = $Attachment;
                }

                # get all attachments meta data
                my @ExistingAttachments = $Self->{WorkOrderObject}->WorkOrderAttachmentList(
                    WorkOrderID => $WorkOrderID,
                );

                # check the existing attachments
                FILENAME:
                for my $Filename (@ExistingAttachments) {

                    # get the existing attachment data
                    my $AttachmentData = $Self->{WorkOrderObject}->WorkOrderAttachmentGet(
                        WorkOrderID => $WorkOrderID,
                        Filename    => $Filename,
                        UserID      => $Self->{UserID},
                    );

                    # do not consider inline attachments
                    next FILENAME if $AttachmentData->{Preferences}->{ContentID};

                    # the key is the filename + filesize + content type
                    # (no content id, as existing attachments don't have it)
                    my $Key = $AttachmentData->{Filename}
                        . $AttachmentData->{Filesize}
                        . $AttachmentData->{ContentType};

                    # attachment is already existing, we can delete it from the new attachment hash
                    if ( $NewAttachment{$Key} ) {
                        delete $NewAttachment{$Key};
                    }

                    # existing attachment is no longer in new attachments hash
                    else {

                        # delete the existing attachment
                        my $DeleteSuccessful = $Self->{WorkOrderObject}->WorkOrderAttachmentDelete(
                            ChangeID    => $WorkOrder->{ChangeID},
                            WorkOrderID => $WorkOrderID,
                            Filename    => $Filename,
                            UserID      => $Self->{UserID},
                        );

                        # check error
                        if ( !$DeleteSuccessful ) {
                            return $Self->{LayoutObject}->FatalError();
                        }
                    }
                }

                # write the new attachments
                ATTACHMENT:
                for my $Attachment ( values %NewAttachment ) {

                    # check if attachment is an inline attachment
                    my $Inline = 0;
                    if ( $Attachment->{ContentID} ) {

                        # remember that it is inline
                        $Inline = 1;

                        # remember if this inline attachment is used in the workorder instruction
                        my $ContentIDFound;

                        # check workorder instruction for content id
                        if ( $GetParam{Instruction} =~ m{ $Attachment->{ContentID} }xms ) {

                            # found the content id
                            $ContentIDFound = 1;
                        }

                        # we do not want to keep this attachment,
                        # because it was deleted in the richt text editor
                        next ATTACHMENT if !$ContentIDFound;
                    }

                    # add attachment
                    my $Success = $Self->{WorkOrderObject}->WorkOrderAttachmentAdd(
                        %{$Attachment},
                        WorkOrderID => $WorkOrderID,
                        ChangeID    => $WorkOrder->{ChangeID},
                        UserID      => $Self->{UserID},
                    );

                    # check error
                    if ( !$Success ) {
                        return $Self->{LayoutObject}->FatalError();
                    }

                    next ATTACHMENT if !$Inline;
                    next ATTACHMENT if !$Self->{LayoutObject}->{BrowserRichText};

                    # picture url in upload cache
                    my $Search = "Action=PictureUpload .+ FormID=$Self->{FormID} .+ "
                        . "ContentID=$Attachment->{ContentID}";

                    # picture url in workorder atttachment
                    my $Replace
                        = "Action=AgentITSMWorkOrderZoom;Subaction=DownloadAttachment;"
                        . "Filename=$Attachment->{Filename};WorkOrderID=$WorkOrderID";

                    # replace url
                    $GetParam{Instruction} =~ s{$Search}{$Replace}xms;

                    # update workorder
                    $Success = $Self->{WorkOrderObject}->WorkOrderUpdate(
                        WorkOrderID => $WorkOrderID,
                        Instruction => $GetParam{Instruction},
                        UserID      => $Self->{UserID},
                    );

                    # check error
                    if ( !$Success ) {
                        $Self->{LogObject}->Log(
                            Priority => 'error',
                            Message  => "Could not update the inline image URLs "
                                . "for WorkOrderID '$WorkOrderID'!!",
                        );
                    }
                }

# if there are any following workorders
# and if the following workorders should be moved, that means we want to keep the difference
# between the planned end date of this workorder and the the planned start dates of ALL LATER workorders
                if ( @FollowingWorkOrderIDs && $GetParam{MoveFollowingWorkOrders} ) {

               # convert the OLD planned end time of this workorder into system time (epoch seconds)
                    my $OldPlannedEndTimeSystemTime = $Self->{TimeObject}->TimeStamp2SystemTime(
                        String => $WorkOrder->{PlannedEndTime},
                    );

               # convert the NEW planned end time of this workorder into system time (epoch seconds)
                    my $NewPlannedEndTimeSystemTime = $Self->{TimeObject}->TimeStamp2SystemTime(
                        String => $GetParam{PlannedEndTime},
                    );

                    # calculate the difference time
                    my $DiffTime = $NewPlannedEndTimeSystemTime - $OldPlannedEndTimeSystemTime;

                    # modify all following workorders
                    WORKORDERID:
                    for my $WorkOrderID (@FollowingWorkOrderIDs) {

                        # get workorder data
                        my $WorkOrder = $Self->{WorkOrderObject}->WorkOrderGet(
                            WorkOrderID => $WorkOrderID,
                            UserID      => $Self->{UserID},
                        );

                        # calculate the new planned start and end time for this following workorder
                        my %TimeData;
                        for my $TimeType (qw(PlannedStartTime PlannedEndTime)) {

                   # convert the old planned times of the workorder into system time (epoch seconds)
                            $TimeData{$TimeType} = $Self->{TimeObject}->TimeStamp2SystemTime(
                                String => $WorkOrder->{$TimeType},
                            );

                            # add the difference and convert time to timestamp
                            $TimeData{$TimeType} = $Self->{TimeObject}->SystemTime2TimeStamp(
                                SystemTime => $TimeData{$TimeType} + $DiffTime,
                            );
                        }

                        # update the workorder with the new times
                        my $Success = $Self->{WorkOrderObject}->WorkOrderUpdate(
                            WorkOrderID => $WorkOrderID,
                            UserID      => $Self->{UserID},
                            %TimeData,
                        );

                        # show error message, if update failed
                        if ( !$Success ) {
                            return $Self->{LayoutObject}->ErrorScreen(
                                Message => "Was not able to update WorkOrder $WorkOrderID!",
                                Comment => 'Please contact the admin.',
                            );
                        }
                    }
                }

                # delete the upload cache
                $Self->{UploadCacheObject}->FormIDRemove( FormID => $Self->{FormID} );

                # load new URL in parent window and close popup
                return $Self->{LayoutObject}->PopupClose(
                    URL => "Action=AgentITSMWorkOrderZoom;WorkOrderID=$WorkOrderID",
                );
            }
            else {

                # show error message, when update failed
                return $Self->{LayoutObject}->ErrorScreen(
                    Message => "Was not able to update WorkOrder $WorkOrderID!",
                    Comment => 'Please contact the admin.',
                );
            }
        }
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
                $GetParam{ $TimeType . 'Minute' } = $Minute;
                $GetParam{ $TimeType . 'Hour' }   = $Hour;
                $GetParam{ $TimeType . 'Day' }    = $Day;
                $GetParam{ $TimeType . 'Month' }  = $Month;
                $GetParam{ $TimeType . 'Year' }   = $Year;
            }
        }

        # get all attachments meta data
        my @ExistingAttachments = $Self->{WorkOrderObject}->WorkOrderAttachmentList(
            WorkOrderID => $WorkOrderID,
        );

        # copy all existing attachments to upload cache
        FILENAME:
        for my $Filename (@ExistingAttachments) {

            # get the existing attachment data
            my $AttachmentData = $Self->{WorkOrderObject}->WorkOrderAttachmentGet(
                WorkOrderID => $WorkOrderID,
                Filename    => $Filename,
                UserID      => $Self->{UserID},
            );

            # do not consider inline attachments
            next FILENAME if $AttachmentData->{Preferences}->{ContentID};

            # add attachment to the upload cache
            $Self->{UploadCacheObject}->FormIDAddFile(
                FormID      => $Self->{FormID},
                Filename    => $AttachmentData->{Filename},
                Content     => $AttachmentData->{Content},
                ContentType => $AttachmentData->{ContentType},
            );
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

    # if there was an attachment delete or upload
    # we do not want to show validation errors for other fields
    if ( $ValidationError{Attachment} ) {
        %ValidationError = ();
        $WorkOrderFreeTextParam{Error} = {};
    }

    # output header
    my $Output = $Self->{LayoutObject}->Header(
        Title => $WorkOrder->{WorkOrderTitle},
        Type  => 'Small',
    );

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

        # add required entry in the hash (if configured for this free text field)
        if (
            $Self->{Config}->{WorkOrderFreeText}->{$Number}
            && $Self->{Config}->{WorkOrderFreeText}->{$Number} == 2
            )
        {
            $WorkOrderFreeTextConfig{Required}->{$Number} = 1;
        }
    }

    # build the workorder freetext HTML
    my %WorkOrderFreeTextHTML = $Self->{LayoutObject}->BuildFreeTextHTML(
        Config                   => \%WorkOrderFreeTextConfig,
        WorkOrderData            => \%WorkOrderFreeTextParam,
        ConfiguredFreeTextFields => \@ConfiguredWorkOrderFreeTextFields,
    );

    # show workorder freetext fields
    for my $Number (@ConfiguredWorkOrderFreeTextFields) {

        # check if this freetext field should be shown in this frontend
        if ( $Self->{Config}->{WorkOrderFreeText}->{$Number} ) {

            # show single workorder freetext fields
            $Self->{LayoutObject}->Block(
                Name => 'WorkOrderFreeText' . $Number,
                Data => {
                    %WorkOrderFreeTextHTML,
                },
            );

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
        $GetParam{ $TimeType . 'SelectionString' } = $Self->{LayoutObject}->BuildDateSelection(
            %GetParam,
            Format              => 'DateInputFormatLong',
            Prefix              => $TimeType,
            DiffTime            => $DiffTime,
            Validate            => 1,
            $TimeType . 'Class' => 'Validate_Required '
                . ( $ValidationError{ $TimeType . 'Invalid' } || '' ),
            %TimePeriod,
        );

        # add server error messages for the planned times
        $Self->{LayoutObject}->Block(
            Name => $TimeType
                . ( $ValidationError{ $TimeType . 'ErrorType' } || 'GenericServerError' )
        );
    }

    # show planned effort if it is configured
    if ( $Self->{Config}->{PlannedEffort} ) {
        $Self->{LayoutObject}->Block(
            Name => 'ShowPlannedEffort',
            Data => {
                %{$WorkOrder},
                %GetParam,
                %ValidationError,
            },
        );
    }

    # show the checkbox for MoveFollowingWorkOrders if it is configured
    if ( $Self->{Config}->{MoveFollowingWorkOrders} ) {

        # set checkbox for MoveFollowingWorkOrders
        if ( $GetParam{MoveFollowingWorkOrders} ) {
            $GetParam{MoveFollowingWorkOrders} = 'checked="checked"';
        }

        $Self->{LayoutObject}->Block(
            Name => 'MoveFollowingWorkOrders',
            Data => {
                %GetParam,
            },
        );
    }

    # show the attachment upload button
    $Self->{LayoutObject}->Block(
        Name => 'AttachmentUpload',
        Data => {%Param},
    );

    # get all attachments meta data
    my @Attachments = $Self->{UploadCacheObject}->FormIDGetAllFilesMeta(
        FormID => $Self->{FormID},
    );

    # show attachments
    ATTACHMENT:
    for my $Attachment (@Attachments) {

        # do not show inline images as attachments
        # (they have a content id)
        if ( $Attachment->{ContentID} && $Self->{LayoutObject}->{BrowserRichText} ) {
            next ATTACHMENT;
        }

        $Self->{LayoutObject}->Block(
            Name => 'Attachment',
            Data => $Attachment,
        );
    }

    # add rich text editor javascript
    # only if activated and the browser can handle it
    # otherwise just a textarea is shown
    if ( $Self->{LayoutObject}->{BrowserRichText} ) {
        $Self->{LayoutObject}->Block(
            Name => 'RichText',
            Data => {%Param},
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
            %ValidationError,
            FormID => $Self->{FormID},
        },
    );

    # add footer
    $Output .= $Self->{LayoutObject}->Footer( Type => 'Small' );

    return $Output;
}

1;
