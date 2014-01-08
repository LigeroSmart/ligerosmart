# --
# Kernel/Modules/AgentITSMChangeEdit.pm - the OTRS ITSM ChangeManagement change edit module
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentITSMChangeEdit;

use strict;
use warnings;

use Kernel::System::ITSMChange;
use Kernel::System::ITSMChange::ITSMChangeCIPAllocate;
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
    $Self->{CIPAllocateObject} = Kernel::System::ITSMChange::ITSMChangeCIPAllocate->new(%Param);
    $Self->{UploadCacheObject} = Kernel::System::Web::UploadCache->new(%Param);

    # get config of frontend module
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
            Message    => "You need $Self->{Config}->{Permission} permissions!",
            WithHeader => 'yes',
        );
    }

    # get change data
    my $Change = $Self->{ChangeObject}->ChangeGet(
        ChangeID => $ChangeID,
        UserID   => $Self->{UserID},
    );

    # check if change is found
    if ( !$Change ) {
        return $Self->{LayoutObject}->ErrorScreen(
            Message => "Change '$ChangeID' not found in database!",
            Comment => 'Please contact the admin.',
        );
    }

    # store needed parameters in %GetParam to make this page reloadable
    my %GetParam;
    for my $ParamName (
        qw(
        ChangeTitle Description Justification
        CategoryID ImpactID PriorityID
        AttachmentUpload FileID
        )
        )
    {
        $GetParam{$ParamName} = $Self->{ParamObject}->GetParam( Param => $ParamName );
    }

    # get configured change freetext field numbers
    my @ConfiguredChangeFreeTextFields = $Self->{ChangeObject}->ChangeGetConfiguredFreeTextFields();

    # get change freetext params
    my %ChangeFreeTextParam;
    NUMBER:
    for my $Number (@ConfiguredChangeFreeTextFields) {

        # consider only freetext fields which are activated in this frontend
        next NUMBER if !$Self->{Config}->{ChangeFreeText}->{$Number};

        my $Key   = 'ChangeFreeKey' . $Number;
        my $Value = 'ChangeFreeText' . $Number;

        $ChangeFreeTextParam{$Key}   = $Self->{ParamObject}->GetParam( Param => $Key );
        $ChangeFreeTextParam{$Value} = $Self->{ParamObject}->GetParam( Param => $Value );
    }

    # store time related fields in %GetParam
    if ( $Self->{Config}->{RequestedTime} ) {
        for my $TimePart (qw(Used Year Month Day Hour Minute)) {
            my $ParamName = 'RequestedTime' . $TimePart;
            $GetParam{$ParamName} = $Self->{ParamObject}->GetParam( Param => $ParamName );
        }
    }

    # Remember the reason why performing the subaction was not attempted.
    my %ValidationError;

    # keep ChangeStateID only if configured
    if ( $Self->{Config}->{ChangeState} ) {
        $GetParam{ChangeStateID} = $Self->{ParamObject}->GetParam( Param => 'ChangeStateID' );
    }

    # update change
    if ( $Self->{Subaction} eq 'Save' ) {

        # check the title
        if ( !$GetParam{ChangeTitle} ) {
            $ValidationError{ChangeTitleServerError} = 'ServerError';
        }

        # check CIP
        for my $Type (qw(Category Impact Priority)) {
            if ( !$GetParam{"${Type}ID"} || $GetParam{"${Type}ID"} !~ m{ \A \d+ \z }xms ) {
                $ValidationError{ $Type . 'IDServerError' } = 'ServerError';
            }
            else {
                my $CIPIsValid = $Self->{ChangeObject}->ChangeCIPLookup(
                    ID   => $GetParam{"${Type}ID"},
                    Type => $Type,
                );

                if ( !$CIPIsValid ) {
                    $ValidationError{ $Type . 'IDServerError' } = 'ServerError';
                }
            }
        }

        # check the requested time
        if ( $Self->{Config}->{RequestedTime} && $GetParam{RequestedTimeUsed} ) {

            if (
                $GetParam{RequestedTimeYear}
                && $GetParam{RequestedTimeMonth}
                && $GetParam{RequestedTimeDay}
                && defined $GetParam{RequestedTimeHour}
                && defined $GetParam{RequestedTimeMinute}
                )
            {

                # transform change requested time, time stamp based on user time zone
                %GetParam = $Self->{LayoutObject}->TransformDateSelection(
                    %GetParam,
                    Prefix => 'RequestedTime',
                );

                # format as timestamp, when all required time params were passed
                $GetParam{RequestedTime} = sprintf '%04d-%02d-%02d %02d:%02d:00',
                    $GetParam{RequestedTimeYear},
                    $GetParam{RequestedTimeMonth},
                    $GetParam{RequestedTimeDay},
                    $GetParam{RequestedTimeHour},
                    $GetParam{RequestedTimeMinute};

                # sanity check of the assembled timestamp
                my $SystemTime = $Self->{TimeObject}->TimeStamp2SystemTime(
                    String => $GetParam{RequestedTime},
                );

                # do not save when time is invalid
                if ( !$SystemTime ) {
                    $ValidationError{RequestedTimeInvalid} = 'ServerError';
                }
            }
            else {

                # it was indicated that the requested time should be set,
                # but at least one of the required time params is missing
                $ValidationError{RequestedTimeInvalid} = 'ServerError';
            }
        }

        # check for required change freetext fields (if configured)
        for my $Number (@ConfiguredChangeFreeTextFields) {
            if (
                $Self->{Config}->{ChangeFreeText}->{$Number}
                && $Self->{Config}->{ChangeFreeText}->{$Number} == 2
                && $ChangeFreeTextParam{ 'ChangeFreeText' . $Number } eq ''
                )
            {

                # remember the change freetext field number with validation errors
                $ChangeFreeTextParam{Error}->{$Number} = 1;
                $ValidationError{ 'ChangeFreeText' . $Number } = 'ServerError';
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

        # update only when there are no input validation errors
        if ( !%ValidationError ) {

            # setting of change state and requested time is configurable
            my %AdditionalParam;
            if ( $Self->{Config}->{ChangeState} ) {
                $AdditionalParam{ChangeStateID} = $GetParam{ChangeStateID};
            }
            if ( $Self->{Config}->{RequestedTime} ) {
                $AdditionalParam{RequestedTime} = $GetParam{RequestedTime};
            }

            # update the change
            my $CouldUpdateChange = $Self->{ChangeObject}->ChangeUpdate(
                ChangeID      => $ChangeID,
                Description   => $GetParam{Description},
                Justification => $GetParam{Justification},
                ChangeTitle   => $GetParam{ChangeTitle},
                CategoryID    => $GetParam{CategoryID},
                ImpactID      => $GetParam{ImpactID},
                PriorityID    => $GetParam{PriorityID},
                UserID        => $Self->{UserID},
                %AdditionalParam,
                %ChangeFreeTextParam,
            );

            # update was successful
            if ($CouldUpdateChange) {

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
                my @ExistingAttachments = $Self->{ChangeObject}->ChangeAttachmentList(
                    ChangeID => $ChangeID,
                );

                # check the existing attachments
                FILENAME:
                for my $Filename (@ExistingAttachments) {

                    # get the existing attachment data
                    my $AttachmentData = $Self->{ChangeObject}->ChangeAttachmentGet(
                        ChangeID => $ChangeID,
                        Filename => $Filename,
                        UserID   => $Self->{UserID},
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
                        my $DeleteSuccessful = $Self->{ChangeObject}->ChangeAttachmentDelete(
                            ChangeID => $ChangeID,
                            Filename => $Filename,
                            UserID   => $Self->{UserID},
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

                        # remember if this inline attachment is used in
                        # the change description or justification
                        my $ContentIDFound;

                        # check change description and justification for content id
                        if (
                            ( $GetParam{Description} =~ m{ $Attachment->{ContentID} }xms )
                            || ( $GetParam{Justification} =~ m{ $Attachment->{ContentID} }xms )
                            )
                        {

                            # found the content id
                            $ContentIDFound = 1;
                        }

                        # we do not want to keep this attachment,
                        # because it was deleted in the richt text editor
                        next ATTACHMENT if !$ContentIDFound;
                    }

                    # add attachment
                    my $Success = $Self->{ChangeObject}->ChangeAttachmentAdd(
                        %{$Attachment},
                        ChangeID => $ChangeID,
                        UserID   => $Self->{UserID},
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

                    # picture url in change atttachment
                    my $Replace
                        = "Action=AgentITSMChangeZoom;Subaction=DownloadAttachment;"
                        . "Filename=$Attachment->{Filename};ChangeID=$ChangeID";

                    # replace urls
                    $GetParam{Description} =~ s{$Search}{$Replace}xms;
                    $GetParam{Justification} =~ s{$Search}{$Replace}xms;

                    # update change
                    $Success = $Self->{ChangeObject}->ChangeUpdate(
                        ChangeID      => $ChangeID,
                        Description   => $GetParam{Description},
                        Justification => $GetParam{Justification},
                        UserID        => $Self->{UserID},
                    );

                    # check error
                    if ( !$Success ) {
                        $Self->{LogObject}->Log(
                            Priority => 'error',
                            Message  => "Could not update the inline image URLs "
                                . "for ChangeID '$ChangeID'!!",
                        );
                    }
                }

                # delete the upload cache
                $Self->{UploadCacheObject}->FormIDRemove( FormID => $Self->{FormID} );

                # load new URL in parent window and close popup
                return $Self->{LayoutObject}->PopupClose(
                    URL => "Action=AgentITSMChangeZoom;ChangeID=$ChangeID",
                );

            }
            else {

                # show error message
                return $Self->{LayoutObject}->ErrorScreen(
                    Message => "Was not able to update Change $ChangeID!",
                    Comment => 'Please contact the admin.',
                );
            }
        }
    }

    # handle AJAXUpdate
    elsif ( $Self->{Subaction} eq 'AJAXUpdate' ) {

        # get priorities
        my $Priorities = $Self->{ChangeObject}->ChangePossibleCIPGet(
            Type   => 'Priority',
            UserID => $Self->{UserID},
        );

        # get selected priority
        my $SelectedPriority = $Self->{CIPAllocateObject}->PriorityAllocationGet(
            CategoryID => $GetParam{CategoryID},
            ImpactID   => $GetParam{ImpactID},
        );

        # build json
        my $JSON = $Self->{LayoutObject}->BuildSelectionJSON(
            [
                {
                    Name        => 'PriorityID',
                    Data        => $Priorities,
                    SelectedID  => $SelectedPriority,
                    Translation => 1,
                    Max         => 100,
                },
            ],
        );

        # return json
        return $Self->{LayoutObject}->Attachment(
            ContentType => 'text/plain; charset=' . $Self->{LayoutObject}->{Charset},
            Content     => $JSON,
            Type        => 'inline',
            NoCache     => 1,
        );
    }

    # delete all keys from %GetParam when it is no Subaction
    else {

        %GetParam = ();

        # set the change state from change, if configured
        if ( $Self->{Config}->{ChangeState} ) {
            $GetParam{ChangeStateID} = $Change->{ChangeStateID};
        }

        # set the requested time from change if configured
        if ( $Self->{Config}->{RequestedTime} && $Change->{RequestedTime} ) {

            # get requested time from the change
            my $SystemTime = $Self->{TimeObject}->TimeStamp2SystemTime(
                String => $Change->{RequestedTime},
            );

            my ( $Second, $Minute, $Hour, $Day, $Month, $Year )
                = $Self->{TimeObject}->SystemTime2Date( SystemTime => $SystemTime );

            # set the parameter hash for BuildDateSelection()
            $GetParam{RequestedTimeUsed}   = 1;
            $GetParam{RequestedTimeMinute} = $Minute;
            $GetParam{RequestedTimeHour}   = $Hour;
            $GetParam{RequestedTimeDay}    = $Day;
            $GetParam{RequestedTimeMonth}  = $Month;
            $GetParam{RequestedTimeYear}   = $Year;
        }

        # get all attachments meta data
        my @ExistingAttachments = $Self->{ChangeObject}->ChangeAttachmentList(
            ChangeID => $ChangeID,
        );

        # copy all existing attachments to upload cache
        FILENAME:
        for my $Filename (@ExistingAttachments) {

            # get the existing attachment data
            my $AttachmentData = $Self->{ChangeObject}->ChangeAttachmentGet(
                ChangeID => $ChangeID,
                Filename => $Filename,
                UserID   => $Self->{UserID},
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

    # if there was an attachment delete or upload
    # we do not want to show validation errors for other fields
    if ( $ValidationError{Attachment} ) {
        %ValidationError = ();
        $ChangeFreeTextParam{Error} = {};
    }

    # check if change state is configured
    if ( $Self->{Config}->{ChangeState} ) {

        # get change state list
        my $ChangePossibleStates = $Self->{ChangeObject}->ChangePossibleStatesGet(
            ChangeID => $ChangeID,
            UserID   => $Self->{UserID},
        );

        # build drop-down with change states
        my $StateSelectionString = $Self->{LayoutObject}->BuildSelection(
            Data       => $ChangePossibleStates,
            Name       => 'ChangeStateID',
            SelectedID => $GetParam{ChangeStateID},
        );

        # show change state dropdown
        $Self->{LayoutObject}->Block(
            Name => 'ChangeState',
            Data => {
                StateSelectionString => $StateSelectionString,
            },
        );
    }

    # output header
    my $Output = $Self->{LayoutObject}->Header(
        Title => 'Edit',
        Type  => 'Small',
    );

    # check if requested time should be shown
    if ( $Self->{Config}->{RequestedTime} ) {

        # time period that can be selected from the GUI
        my %TimePeriod = %{ $Self->{ConfigObject}->Get('ITSMWorkOrder::TimePeriod') };

        # add selection for the time
        my $TimeSelectionString = $Self->{LayoutObject}->BuildDateSelection(
            %GetParam,
            Format                => 'DateInputFormatLong',
            Prefix                => 'RequestedTime',
            RequestedTimeOptional => 1,
            RequestedTimeClass    => 'Validate ' . ( $ValidationError{RequestedTimeInvalid} || '' ),
            Validate              => 1,
            %TimePeriod,
        );

        # show time fields
        $Self->{LayoutObject}->Block(
            Name => 'RequestedTime',
            Data => {
                'RequestedTimeString' => $TimeSelectionString,
            },
        );
    }

    # create dropdown for the category
    # all categories are selectable
    # when the category is changed, a new priority is proposed
    my $Categories = $Self->{ChangeObject}->ChangePossibleCIPGet(
        Type   => 'Category',
        UserID => $Self->{UserID},
    );
    $Param{CategorySelectionString} = $Self->{LayoutObject}->BuildSelection(
        Data       => $Categories,
        Name       => 'CategoryID',
        SelectedID => $GetParam{CategoryID} || $Change->{CategoryID},
    );

    # create dropdown for the impact
    # all impacts are selectable
    # when the impact is changed, a new priority is proposed
    my $Impacts = $Self->{ChangeObject}->ChangePossibleCIPGet(
        Type   => 'Impact',
        UserID => $Self->{UserID},
    );
    $Param{ImpactSelectionString} = $Self->{LayoutObject}->BuildSelection(
        Data       => $Impacts,
        Name       => 'ImpactID',
        SelectedID => $GetParam{ImpactID} || $Change->{ImpactID},
    );

    # create dropdown for priority,
    # all priorities are selectable
    my $Priorities = $Self->{ChangeObject}->ChangePossibleCIPGet(
        Type   => 'Priority',
        UserID => $Self->{UserID},
    );
    $Param{PrioritySelectionString} = $Self->{LayoutObject}->BuildSelection(
        Data       => $Priorities,
        Name       => 'PriorityID',
        SelectedID => $GetParam{PriorityID} || $Change->{PriorityID},
    );

    # get the change freetext config and fillup change freetext fields from change data
    my %ChangeFreeTextConfig;
    NUMBER:
    for my $Number (@ConfiguredChangeFreeTextFields) {

        TYPE:
        for my $Type (qw(ChangeFreeKey ChangeFreeText)) {

            # get change freetext fields from change if page is loaded the first time
            if ( !$Self->{Subaction} ) {

                $ChangeFreeTextParam{ $Type . $Number } ||= $Change->{ $Type . $Number };
            }

            # get config
            my $Config = $Self->{ConfigObject}->Get( $Type . $Number );

            next TYPE if !$Config;
            next TYPE if ref $Config ne 'HASH';

            # store the change freetext config
            $ChangeFreeTextConfig{ $Type . $Number } = $Config;
        }

        # add required entry in the hash (if configured for this free text field)
        if (
            $Self->{Config}->{ChangeFreeText}->{$Number}
            && $Self->{Config}->{ChangeFreeText}->{$Number} == 2
            )
        {
            $ChangeFreeTextConfig{Required}->{$Number} = 1;
        }
    }

    # build the change freetext HTML
    my %ChangeFreeTextHTML = $Self->{LayoutObject}->BuildFreeTextHTML(
        Config                   => \%ChangeFreeTextConfig,
        ChangeData               => \%ChangeFreeTextParam,
        ConfiguredFreeTextFields => \@ConfiguredChangeFreeTextFields,
    );

    # show change freetext fields
    for my $Number (@ConfiguredChangeFreeTextFields) {

        # check if this freetext field should be shown in this frontend
        if ( $Self->{Config}->{ChangeFreeText}->{$Number} ) {

            # show single change freetext fields
            $Self->{LayoutObject}->Block(
                Name => 'ChangeFreeText' . $Number,
                Data => {
                    %ChangeFreeTextHTML,
                },
            );

            # show all change freetext fields
            $Self->{LayoutObject}->Block(
                Name => 'ChangeFreeText',
                Data => {
                    ChangeFreeKeyField  => $ChangeFreeTextHTML{ 'ChangeFreeKeyField' . $Number },
                    ChangeFreeTextField => $ChangeFreeTextHTML{ 'ChangeFreeTextField' . $Number },
                },
            );
        }
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
        TemplateFile => 'AgentITSMChangeEdit',
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
