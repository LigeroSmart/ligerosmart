# --
# Kernel/Modules/AgentITSMWorkOrderAdd.pm - the OTRS ITSM ChangeManagement workorder add module
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentITSMWorkOrderAdd;

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

    # get config of frontend module (WorkorderAdd is a change action!)
    $Self->{Config} = $Self->{ConfigObject}->Get("ITSMChange::Frontend::$Self->{Action}");

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

    # get needed ChangeID
    my $ChangeID = $Self->{ParamObject}->GetParam( Param => 'ChangeID' );

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

    # error screen
    if ( !$Access ) {
        return $Self->{LayoutObject}->NoPermission(
            Message    => "You need $Self->{Config}->{Permission} permissions on the change!",
            WithHeader => 'yes',
        );
    }

    # get change data
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

    # store needed parameters in %GetParam to make it reloadable
    my %GetParam;
    for my $ParamName (
        qw(WorkOrderTitle Instruction WorkOrderTypeID PlannedEffort AttachmentUpload FileID)
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

    # Remember the reason why saving was not attempted.
    my %ValidationError;

    # add the workorder
    if ( $Self->{Subaction} eq 'Save' ) {

        # challenge token check for write action
        $Self->{LayoutObject}->ChallengeTokenCheck();

        # the title is required
        if ( !$GetParam{WorkOrderTitle} ) {
            $ValidationError{WorkOrderTitleServerError} = 'ServerError';
        }

        # check WorkOrderTypeID
        my $WorkOrderType = $Self->{WorkOrderObject}->WorkOrderTypeLookup(
            UserID          => $Self->{UserID},
            WorkOrderTypeID => $GetParam{WorkOrderTypeID},
        );

        if ( !$WorkOrderType ) {
            $ValidationError{WorkOrderTypeIDServerError} = 'ServerError';
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
        if ( $GetParam{PlannedEffort} !~ m{ \A \d* (?: [.] \d{1,2} )? \z }xms ) {
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

        # add only when there are no input validation errors
        if ( !%ValidationError ) {

            # create the workorder
            my $WorkOrderID = $Self->{WorkOrderObject}->WorkOrderAdd(
                ChangeID         => $ChangeID,
                WorkOrderTitle   => $GetParam{WorkOrderTitle},
                Instruction      => $GetParam{Instruction},
                PlannedStartTime => $GetParam{PlannedStartTime},
                PlannedEndTime   => $GetParam{PlannedEndTime},
                WorkOrderTypeID  => $GetParam{WorkOrderTypeID},
                PlannedEffort    => $GetParam{PlannedEffort},
                UserID           => $Self->{UserID},
                %WorkOrderFreeTextParam,
            );

            # adding was successful
            if ($WorkOrderID) {

                # move attachments from cache to virtual fs
                my @CachedAttachments = $Self->{UploadCacheObject}->FormIDGetAllFilesData(
                    FormID => $Self->{FormID},
                );

                for my $CachedAttachment (@CachedAttachments) {
                    my $Success = $Self->{WorkOrderObject}->WorkOrderAttachmentAdd(
                        %{$CachedAttachment},
                        WorkOrderID => $WorkOrderID,
                        ChangeID    => $ChangeID,
                        UserID      => $Self->{UserID},
                    );

                    # delete file from cache if move was successful
                    if ($Success) {

                        # rewrite URL for inline images
                        if ( $CachedAttachment->{ContentID} ) {

                            # get the workorder data
                            my $WorkOrderData = $Self->{WorkOrderObject}->WorkOrderGet(
                                WorkOrderID => $WorkOrderID,
                                UserID      => $Self->{UserID},
                            );

                            # picture url in upload cache
                            my $Search = "Action=PictureUpload .+ FormID=$Self->{FormID} .+ "
                                . "ContentID=$CachedAttachment->{ContentID}";

                            # picture url in workorder atttachment
                            my $Replace
                                = "Action=AgentITSMWorkOrderZoom;Subaction=DownloadAttachment;"
                                . "Filename=$CachedAttachment->{Filename};WorkOrderID=$WorkOrderID";

                            # replace url
                            $WorkOrderData->{Instruction} =~ s{$Search}{$Replace}xms;

                            # update workorder
                            my $Success = $Self->{WorkOrderObject}->WorkOrderUpdate(
                                WorkOrderID => $WorkOrderID,
                                Instruction => $WorkOrderData->{Instruction},
                                UserID      => $Self->{UserID},
                            );

                            # check error
                            if ( !$Success ) {
                                $Self->{LogObject}->Log(
                                    Priority => 'error',
                                    Message  => "Could not update the inline image URLs "
                                        . "for WorkOrderID '$WorkOrderID'!",
                                );
                            }
                        }

                        $Self->{UploadCacheObject}->FormIDRemoveFile(
                            FormID => $Self->{FormID},
                            FileID => $CachedAttachment->{FileID},
                        );
                    }
                    else {
                        $Self->{LogObject}->Log(
                            Priority => 'error',
                            Message  => 'Cannot move File from Cache to VirtualFS'
                                . "(${$CachedAttachment}{Filename})",
                        );
                    }
                }

                # get redirect screen
                my $NextScreen = $Self->{UserCreateWorkOrderNextMask} || 'AgentITSMWorkOrderZoom';

                # add the correct id
                if ( $NextScreen eq 'AgentITSMWorkOrderZoom' ) {
                    $NextScreen .= ";WorkOrderID=$WorkOrderID";
                }
                elsif ( $NextScreen eq 'AgentITSMChangeZoom' ) {
                    $NextScreen .= ";ChangeID=$ChangeID";
                }

                # load new URL in parent window and close popup
                return $Self->{LayoutObject}->PopupClose(
                    URL => "Action=$NextScreen",
                );
            }
            else {

                # show error message, when adding failed
                return $Self->{LayoutObject}->ErrorScreen(
                    Message => 'Was not able to add workorder!',
                    Comment => 'Please contact the admin.',
                );
            }
        }
    }

    # if there was an attachment delete or upload
    # we do not want to show validation errors for other fields
    if ( $ValidationError{Attachment} ) {
        %ValidationError = ();
        $WorkOrderFreeTextParam{Error} = {};
    }

    # get all attachments meta data
    my @Attachments = $Self->{UploadCacheObject}->FormIDGetAllFilesMeta(
        FormID => $Self->{FormID},
    );

    # output header
    my $Output = $Self->{LayoutObject}->Header(
        Title => 'Add',
        Type  => 'Small',
    );

    # set selected type
    my %SelectedInfo = (
        Default => 1,
    );

    if ( $GetParam{WorkOrderTypeID} ) {
        %SelectedInfo = ( Selected => $GetParam{WorkOrderTypeID} );
    }

    # get WorkOrderType list
    my $WorkOrderTypeList = $Self->{WorkOrderObject}->WorkOrderTypeList(
        UserID => $Self->{UserID},
        %SelectedInfo,
    ) || [];

    # build the WorkOrderType dropdown
    $GetParam{WorkOrderTypeStrg} = $Self->{LayoutObject}->BuildSelection(
        Name => 'WorkOrderTypeID',
        Data => $WorkOrderTypeList,
    );

    # get the workorder freetext config and fillup workorder freetext fields
    # from defaults (if configured)
    my %WorkOrderFreeTextConfig;
    NUMBER:
    for my $Number (@ConfiguredWorkOrderFreeTextFields) {

        TYPE:
        for my $Type (qw(WorkOrderFreeKey WorkOrderFreeText)) {

            # get defaults for workorder freetext fields if page is loaded the first time
            if ( !$Self->{Subaction} ) {

                $WorkOrderFreeTextParam{ $Type . $Number }
                    ||= $Self->{ConfigObject}->Get( $Type . $Number . '::DefaultSelection' );
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
                PlannedEffort => $GetParam{PlannedEffort},
                %ValidationError,
            },
        );
    }

    # show the attachment upload button
    $Self->{LayoutObject}->Block(
        Name => 'AttachmentUpload',
        Data => {%Param},
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
        TemplateFile => 'AgentITSMWorkOrderAdd',
        Data         => {
            %Param,
            %{$Change},
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
