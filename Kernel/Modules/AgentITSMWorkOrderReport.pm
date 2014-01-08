# --
# Kernel/Modules/AgentITSMWorkOrderReport.pm - the OTRS ITSM ChangeManagement workorder report module
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentITSMWorkOrderReport;

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

    # store needed parameters in %GetParam to make this page reloadable
    my %GetParam;
    for my $ParamName (qw(Report WorkOrderStateID AccountedTime AttachmentUpload FileID)) {
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

    # store actual time related fields in %GetParam
    if ( $Self->{Config}->{ActualTimeSpan} ) {
        for my $TimeType (qw(ActualStartTime ActualEndTime)) {
            for my $TimePart (qw(Year Month Day Hour Minute Used)) {
                my $ParamName = $TimeType . $TimePart;
                $GetParam{$ParamName} = $Self->{ParamObject}->GetParam( Param => $ParamName );
            }
        }
    }

    # Remember the reason why perfoming the subaction was not attempted.
    # The entries are the names of the dtl validation error blocks.
    my %ValidationError;

    # check if an attachment should be deleted
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

    # get meta data for all already uploaded files
    my @Attachments = $Self->{UploadCacheObject}->FormIDGetAllFilesMeta(
        FormID => $Self->{FormID},
    );

    # update workorder
    if ( $Self->{Subaction} eq 'Save' ) {

        # validate the actual time related parameters
        if ( $Self->{Config}->{ActualTimeSpan} ) {
            my %SystemTime;
            for my $TimeType (qw(ActualStartTime ActualEndTime)) {

                if ( !$GetParam{ $TimeType . 'Used' } ) {

                    # when the button was not checked, then clear the time
                    $GetParam{$TimeType} = undef;
                }
                elsif (
                    $GetParam{ $TimeType . 'Year' }
                    && $GetParam{ $TimeType . 'Month' }
                    && $GetParam{ $TimeType . 'Day' }
                    && defined $GetParam{ $TimeType . 'Hour' }
                    && defined $GetParam{ $TimeType . 'Minute' }
                    )
                {

                    # transform work order actual time, time stamp based on user time zone
                    %GetParam = $Self->{LayoutObject}->TransformDateSelection(
                        %GetParam,
                        Prefix => $TimeType,
                    );

                    # format as timestamp, when all required time params were passed
                    $GetParam{$TimeType} = sprintf '%04d-%02d-%02d %02d:%02d:00',
                        $GetParam{ $TimeType . 'Year' },
                        $GetParam{ $TimeType . 'Month' },
                        $GetParam{ $TimeType . 'Day' },
                        $GetParam{ $TimeType . 'Hour' },
                        $GetParam{ $TimeType . 'Minute' };

                    # sanity check of the assembled timestamp
                    $SystemTime{$TimeType} = $Self->{TimeObject}->TimeStamp2SystemTime(
                        String => $GetParam{$TimeType},
                    );

                    # do not save if time is invalid
                    if ( !$SystemTime{$TimeType} ) {
                        $ValidationError{ $TimeType . 'Invalid' } = 'ServerError';
                    }
                }
                else {

                    # it was indicated that the time should be set,
                    # but at least one of the required time params is missing
                    $ValidationError{ $TimeType . 'Invalid' }   = 'ServerError';
                    $ValidationError{ $TimeType . 'ErrorType' } = 'GenericServerError';
                }
            }

            # check validity of the actual start and end times
            if ( $SystemTime{ActualEndTime} && !$SystemTime{ActualStartTime} ) {
                $ValidationError{ActualStartTimeInvalid}   = 'ServerError';
                $ValidationError{ActualStartTimeErrorType} = 'SetServerError';
            }
            elsif (
                ( $SystemTime{ActualEndTime} && $SystemTime{ActualStartTime} )
                && ( $SystemTime{ActualEndTime} < $SystemTime{ActualStartTime} )
                )
            {
                $ValidationError{ActualStartTimeInvalid}   = 'ServerError';
                $ValidationError{ActualStartTimeErrorType} = 'BeforeThanEndTimeServerError';
            }
        }

        # validate format of accounted time
        if (
            $GetParam{AccountedTime}
            && $GetParam{AccountedTime} !~ m{ \A -? \d* (?: [.] \d{1,2} )? \z }xms
            )
        {
            $ValidationError{'AccountedTimeInvalid'} = 'ServerError';
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

        # update only when there are no input validation errors
        if ( !%ValidationError ) {

            # the actual time related fields are configurable
            my %AdditionalParam;
            if ( $Self->{Config}->{ActualTimeSpan} ) {
                for my $TimeType (qw(ActualStartTime ActualEndTime)) {

                    # $GetParam{$TimeType} is either a valid timestamp or undef
                    $AdditionalParam{$TimeType} = $GetParam{$TimeType};
                }
            }

            # update the workorder
            my $CouldUpdateWorkOrder = $Self->{WorkOrderObject}->WorkOrderUpdate(
                WorkOrderID      => $WorkOrderID,
                Report           => $GetParam{Report},
                WorkOrderStateID => $GetParam{WorkOrderStateID},
                UserID           => $Self->{UserID},
                AccountedTime    => $GetParam{AccountedTime},
                %AdditionalParam,
                %WorkOrderFreeTextParam,
            );

            # if workorder update was successful
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

                # write the new attachments
                ATTACHMENT:
                for my $Attachment ( values %NewAttachment ) {

                    # check if attachment is an inline attachment
                    my $Inline = 0;
                    if ( $Attachment->{ContentID} ) {

                        # check workorder report for content id
                        # we do not want to keep this attachment,
                        # if it was deleted in the rich text editor
                        next ATTACHMENT if $GetParam{Report} !~ m{ $Attachment->{ContentID} }xms;

                        # remember that it is inline
                        $Inline = 1;
                    }

                    # add attachment
                    my $Success = $Self->{WorkOrderObject}->WorkOrderAttachmentAdd(
                        %{$Attachment},
                        WorkOrderID    => $WorkOrderID,
                        ChangeID       => $WorkOrder->{ChangeID},
                        UserID         => $Self->{UserID},
                        AttachmentType => 'WorkOrderReport',
                    );

                    # check error
                    return $Self->{LayoutObject}->FatalError() if !$Success;

                    next ATTACHMENT if !$Inline;
                    next ATTACHMENT if !$Self->{LayoutObject}->{BrowserRichText};

                    # picture url in upload cache
                    my $Search = "Action=PictureUpload .+ FormID=$Self->{FormID} .+ "
                        . "ContentID=$Attachment->{ContentID}";

                    # picture url in workorder report attachment
                    my $Replace
                        = "Action=AgentITSMWorkOrderZoom;Subaction=DownloadAttachment;"
                        . "Filename=$Attachment->{Filename};WorkOrderID=$WorkOrderID;Type=WorkOrderReport";

                    # replace url
                    $GetParam{Report} =~ s{$Search}{$Replace}xms;

                    # update workorder
                    $Success = $Self->{WorkOrderObject}->WorkOrderUpdate(
                        WorkOrderID => $WorkOrderID,
                        Report      => $GetParam{Report},
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

                # delete the upload cache
                $Self->{UploadCacheObject}->FormIDRemove( FormID => $Self->{FormID} );

                # load new URL in parent window and close popup
                return $Self->{LayoutObject}->PopupClose(
                    URL => "Action=AgentITSMWorkOrderZoom;WorkOrderID=$WorkOrderID",
                );
            }
            else {

                # show error message
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

        # initialize the actual time related fields
        if ( $Self->{Config}->{ActualTimeSpan} ) {
            TIMETYPE:
            for my $TimeType (qw(ActualStartTime ActualEndTime)) {

                next TIMETYPE if !$WorkOrder->{$TimeType};

                # get the time from the workorder
                my $SystemTime = $Self->{TimeObject}->TimeStamp2SystemTime(
                    String => $WorkOrder->{$TimeType},
                );

                my ( $Second, $Minute, $Hour, $Day, $Month, $Year )
                    = $Self->{TimeObject}->SystemTime2Date( SystemTime => $SystemTime );

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

    # get change that the workorder belongs to
    my $Change = $Self->{ChangeObject}->ChangeGet(
        ChangeID => $WorkOrder->{ChangeID},
        UserID   => $Self->{UserID},
    );

    # no change found
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

    # get workorder state list
    my $WorkOrderPossibleStates = $Self->{WorkOrderObject}->WorkOrderPossibleStatesGet(
        WorkOrderID => $WorkOrderID,
        UserID      => $Self->{UserID},
    );

    # build drop-down with workorder states
    $Param{StateSelect} = $Self->{LayoutObject}->BuildSelection(
        Data       => $WorkOrderPossibleStates,
        Name       => 'WorkOrderStateID',
        SelectedID => $WorkOrder->{WorkOrderStateID},
    );

    # show state dropdown
    $Self->{LayoutObject}->Block(
        Name => 'State',
        Data => {
            %Param,
        },
    );

    # output header
    my $Output = $Self->{LayoutObject}->Header(
        Title => $WorkOrder->{WorkOrderTitle},
        Type  => 'Small',
    );

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

    # check if actual times should be shown
    if ( $Self->{Config}->{ActualTimeSpan} ) {

        for my $TimeType (qw(ActualEndTime ActualStartTime)) {

            # time period that can be selected from the GUI
            my %TimePeriod = %{ $Self->{ConfigObject}->Get('ITSMWorkOrder::TimePeriod') };

            # add selection for the time
            my $TimeSelectionString = $Self->{LayoutObject}->BuildDateSelection(
                %GetParam,
                Format                => 'DateInputFormatLong',
                Prefix                => $TimeType,
                "${TimeType}Optional" => 1,
                $TimeType . 'Class' => $ValidationError{ $TimeType . 'Invalid' } || '',
                Validate => 1,
                %TimePeriod,
            );

            # show time field
            $Self->{LayoutObject}->Block(
                Name => $TimeType,
                Data => {
                    $TimeType . 'SelectionString' => $TimeSelectionString,
                },
            );
        }

        # add server error messages for the actual start time
        $Self->{LayoutObject}->Block(
            Name => 'ActualStartTime'
                . ( $ValidationError{ActualStartTimeErrorType} || 'GenericServerError' )
        );
    }

    # show accounted time only when form was submitted
    if ( $Self->{Config}->{AccountedTime} ) {
        $Self->{LayoutObject}->Block(
            Name => 'ShowAccountedTime',
            Data => {
                AccountedTime => $GetParam{AccountedTime},
                %ValidationError,
            },
        );
    }

    # show accounted time only when form was submitted
    my $AccountedTime = '';
    if ( $GetParam{AccountedTime} ) {
        $AccountedTime = $GetParam{AccountedTime};
    }

    # show attachments
    my @WorkOrderAttachments = $Self->{WorkOrderObject}->WorkOrderReportAttachmentList(
        WorkOrderID => $WorkOrderID,
    );

    # show attachments (report)
    ATTACHMENT:
    for my $Filename (@WorkOrderAttachments) {

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

    # get all temporary attachments meta data
    my @TempAttachments = $Self->{UploadCacheObject}->FormIDGetAllFilesMeta(
        FormID => $Self->{FormID},
    );

    # show attachments (report)
    for my $Attachment (@TempAttachments) {

        # do not show inline images as attachments
        # (they have a content id)
        if ( $Attachment->{ContentID} && $Self->{LayoutObject}->{BrowserRichText} ) {
            next ATTACHMENT;
        }

        $Self->{LayoutObject}->Block(
            Name => 'ReportAttachmentRow',
            Data => $Attachment,
        );
    }

    # start template output
    $Output .= $Self->{LayoutObject}->Output(
        TemplateFile => 'AgentITSMWorkOrderReport',
        Data         => {
            %Param,
            %{$Change},
            %{$WorkOrder},
            %GetParam,
            %ValidationError,
            AccountedTime => $AccountedTime,
            FormID        => $Self->{FormID},
        },
    );

    # add footer
    $Output .= $Self->{LayoutObject}->Footer( Type => 'Small' );

    return $Output;
}

1;
