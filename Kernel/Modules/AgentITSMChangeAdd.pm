# --
# Kernel/Modules/AgentITSMChangeAdd.pm - the OTRS ITSM ChangeManagement change add module
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentITSMChangeAdd;

use strict;
use warnings;

use Kernel::System::ITSMChange;
use Kernel::System::ITSMChange::ITSMChangeCIPAllocate;
use Kernel::System::LinkObject;
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
    $Self->{LinkObject}        = Kernel::System::LinkObject->new(%Param);
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

    # check permissions
    my $Access = $Self->{ChangeObject}->Permission(
        Type   => $Self->{Config}->{Permission},
        Action => $Self->{Action},
        UserID => $Self->{UserID},
    );

    # error screen
    if ( !$Access ) {
        return $Self->{LayoutObject}->NoPermission(
            Message    => "You need $Self->{Config}->{Permission} permissions!",
            WithHeader => 'yes',
        );
    }

    # store needed parameters in %GetParam to make it reloadable
    my %GetParam;
    for my $ParamName (
        qw(ChangeTitle Description Justification TicketID CategoryID ImpactID PriorityID AttachmentUpload FileID)
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

    # set default value for category
    $Param{CategoryID} = $GetParam{CategoryID};
    if ( !$Param{CategoryID} ) {
        my $DefaultCategory = $Self->{ConfigObject}->Get('ITSMChange::Category::Default');
        $Param{CategoryID} = $Self->{ChangeObject}->ChangeCIPLookup(
            CIP  => $DefaultCategory,
            Type => 'Category',
        );
    }

    # set default value for impact
    $Param{ImpactID} = $GetParam{ImpactID};
    if ( !$Param{ImpactID} ) {
        my $DefaultImpact = $Self->{ConfigObject}->Get('ITSMChange::Impact::Default');
        $Param{ImpactID} = $Self->{ChangeObject}->ChangeCIPLookup(
            CIP  => $DefaultImpact,
            Type => 'Impact',
        );
    }

    # Remember the reason why saving was not attempted.
    my %ValidationError;

    # the TicketID can be validated even without the Subaction 'Save',
    # as it is passed as GET-param or in a hidden field.
    if ( $GetParam{TicketID} ) {

        # get ticket data
        my %Ticket = $Self->{TicketObject}->TicketGet(
            TicketID => $GetParam{TicketID},
        );

        # check if ticket exists
        if ( !%Ticket ) {

            # show error message
            return $Self->{LayoutObject}->ErrorScreen(
                Message => "Ticket with TicketID $GetParam{TicketID} does not exist!",
                Comment => 'Please contact the admin.',
            );
        }

        # get list of relevant ticket types
        my $AddChangeLinkTicketTypes
            = $Self->{ConfigObject}->Get('ITSMChange::AddChangeLinkTicketTypes');

        # check the list of relevant ticket types
        if (
            !$AddChangeLinkTicketTypes
            || ref $AddChangeLinkTicketTypes ne 'ARRAY'
            || !@{$AddChangeLinkTicketTypes}
            )
        {

            # set error message
            my $Message = "Missing sysconfig option 'ITSMChange::AddChangeLinkTicketTypes'!";

            # log error
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => $Message,
            );

            # show error message
            return $Self->{LayoutObject}->ErrorScreen(
                Message => $Message,
                Comment => 'Please contact the admin.',
            );
        }

        # get relevant ticket types
        my %IsRelevant = map { $_ => 1 } @{$AddChangeLinkTicketTypes};

        # check whether the ticket's type is relevant
        if ( !$IsRelevant{ $Ticket{Type} } ) {

            # set error message
            my $Message
                = "Invalid ticket type '$Ticket{Type}' for directly linking a ticket with a change. "
                . 'Only the following ticket type(s) are allowed for this operation: '
                . join ',', @{$AddChangeLinkTicketTypes};

            # log error
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => $Message,
            );

            # show error message
            return $Self->{LayoutObject}->ErrorScreen(
                Message => $Message,
                Comment => 'Please contact the admin.',
            );
        }
    }

    # perform the adding
    if ( $Self->{Subaction} eq 'Save' ) {

        # challenge token check for write action
        $Self->{LayoutObject}->ChallengeTokenCheck();

        # the title is required
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

        # add only when there are no input validation errors
        if ( !%ValidationError ) {

            my %AdditionalParam;

            # add requested time if configured
            if ( $Self->{Config}->{RequestedTime} ) {
                $AdditionalParam{RequestedTime} = $GetParam{RequestedTime};
            }

            # create the change
            my $ChangeID = $Self->{ChangeObject}->ChangeAdd(
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

            # adding was successful
            if ($ChangeID) {

                # if the change add mask was called from the ticket zoom
                if ( $GetParam{TicketID} ) {

                    # link ticket with newly created change
                    my $LinkSuccess = $Self->{LinkObject}->LinkAdd(
                        SourceObject => 'Ticket',
                        SourceKey    => $GetParam{TicketID},
                        TargetObject => 'ITSMChange',
                        TargetKey    => $ChangeID,
                        Type         => 'Normal',
                        State        => 'Valid',
                        UserID       => $Self->{UserID},
                    );

                    # link could not be added
                    if ( !$LinkSuccess ) {

                        # set error message
                        my $Message = "Change with ChangeID $ChangeID was successfully added, "
                            . "but a link to Ticket with TicketID $GetParam{TicketID} could not be created!";

                        # log error
                        $Self->{LogObject}->Log(
                            Priority => 'error',
                            Message  => $Message,
                        );

                        # show error message
                        return $Self->{LayoutObject}->ErrorScreen(
                            Message => $Message,
                            Comment => 'Please contact the admin.',
                        );
                    }
                }

                # move attachments from cache to virtual fs
                my @CachedAttachments = $Self->{UploadCacheObject}->FormIDGetAllFilesData(
                    FormID => $Self->{FormID},
                );

                for my $CachedAttachment (@CachedAttachments) {
                    my $Success = $Self->{ChangeObject}->ChangeAttachmentAdd(
                        %{$CachedAttachment},
                        ChangeID => $ChangeID,
                        UserID   => $Self->{UserID},
                    );

                    # delete file from cache if move was successful
                    if ($Success) {

                        # rewrite URL for inline images
                        if ( $CachedAttachment->{ContentID} ) {

                            # get the change data
                            my $ChangeData = $Self->{ChangeObject}->ChangeGet(
                                ChangeID => $ChangeID,
                                UserID   => $Self->{UserID},
                            );

                            # picture url in upload cache
                            my $Search = "Action=PictureUpload .+ FormID=$Self->{FormID} .+ "
                                . "ContentID=$CachedAttachment->{ContentID}";

                            # picture url in change atttachment
                            my $Replace
                                = "Action=AgentITSMChangeZoom;Subaction=DownloadAttachment;"
                                . "Filename=$CachedAttachment->{Filename};ChangeID=$ChangeID";

                            # replace urls
                            $ChangeData->{Description} =~ s{$Search}{$Replace}xms;
                            $ChangeData->{Justification} =~ s{$Search}{$Replace}xms;

                            # update change
                            my $Success = $Self->{ChangeObject}->ChangeUpdate(
                                ChangeID      => $ChangeID,
                                Description   => $ChangeData->{Description},
                                Justification => $ChangeData->{Justification},
                                UserID        => $Self->{UserID},
                            );

                            # check error
                            if ( !$Success ) {
                                $Self->{LogObject}->Log(
                                    Priority => 'error',
                                    Message  => "Could not update the inline image URLs "
                                        . "for ChangeID '$ChangeID'!",
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

                # redirect to zoom mask of the new change, when adding was successful
                return $Self->{LayoutObject}->Redirect(
                    OP => "Action=AgentITSMChangeZoom;ChangeID=$ChangeID",
                );
            }
            else {

                # show error message, when adding failed
                return $Self->{LayoutObject}->ErrorScreen(
                    Message => 'Was not able to add change!',
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

    # if there was an attachment delete or upload
    # we do not want to show validation errors for other fields
    if ( $ValidationError{Attachment} ) {
        %ValidationError = ();
        $ChangeFreeTextParam{Error} = {};
    }

    # get all attachments meta data
    my @Attachments = $Self->{UploadCacheObject}->FormIDGetAllFilesMeta(
        FormID => $Self->{FormID},
    );

    # output header
    my $Output = $Self->{LayoutObject}->Header(
        Title => 'Add',
    );
    $Output .= $Self->{LayoutObject}->NavigationBar();

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
        SelectedID => $Param{CategoryID},
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
        SelectedID => $Param{ImpactID},
    );

    # create dropdown for priority,
    # all priorities are selectable
    # the default value might depend on category and impact
    my $Priorities = $Self->{ChangeObject}->ChangePossibleCIPGet(
        Type   => 'Priority',
        UserID => $Self->{UserID},
    );
    my $SelectedPriority = $GetParam{PriorityID}
        || $Self->{CIPAllocateObject}->PriorityAllocationGet(
        CategoryID => $Param{CategoryID},
        ImpactID   => $Param{ImpactID},
        );
    $Param{PrioritySelectionString} = $Self->{LayoutObject}->BuildSelection(
        Data       => $Priorities,
        Name       => 'PriorityID',
        SelectedID => $SelectedPriority,
    );

    # get the change freetext config and fillup change freetext fields from defaults (if configured)
    my %ChangeFreeTextConfig;
    NUMBER:
    for my $Number (@ConfiguredChangeFreeTextFields) {

        TYPE:
        for my $Type (qw(ChangeFreeKey ChangeFreeText)) {

            # get defaults for change freetext fields if page is loaded the first time
            if ( !$Self->{Subaction} ) {

                $ChangeFreeTextParam{ $Type . $Number }
                    ||= $Self->{ConfigObject}->Get( $Type . $Number . '::DefaultSelection' );
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
        TemplateFile => 'AgentITSMChangeAdd',
        Data         => {
            %Param,
            %GetParam,
            %ValidationError,
            FormID => $Self->{FormID},
        },
    );

    # add footer
    $Output .= $Self->{LayoutObject}->Footer();

    return $Output;
}

1;
