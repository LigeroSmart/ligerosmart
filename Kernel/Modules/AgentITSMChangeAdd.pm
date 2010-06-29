# --
# Kernel/Modules/AgentITSMChangeAdd.pm - the OTRS::ITSM::ChangeManagement change add module
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# --
# $Id: AgentITSMChangeAdd.pm,v 1.65 2010-06-29 13:36:40 ub Exp $
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
use Kernel::System::ITSMChange::Template;
use Kernel::System::LinkObject;
use Kernel::System::Web::UploadCache;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.65 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check needed objects
    for my $Object (qw(ParamObject DBObject LayoutObject LogObject ConfigObject)) {
        if ( !$Self->{$Object} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $Object!" );
        }
    }

    # create needed objects
    $Self->{ChangeObject}      = Kernel::System::ITSMChange->new(%Param);
    $Self->{LinkObject}        = Kernel::System::LinkObject->new(%Param);
    $Self->{CIPAllocateObject} = Kernel::System::ITSMChange::ITSMChangeCIPAllocate->new(%Param);
    $Self->{UploadCacheObject} = Kernel::System::Web::UploadCache->new(%Param);
    $Self->{TemplateObject}    = Kernel::System::ITSMChange::Template->new(%Param);

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
        UserID => $Self->{UserID},
    );

    # error screen, don't show the add mask
    if ( !$Access ) {
        return $Self->{LayoutObject}->NoPermission(
            Message    => "You need $Self->{Config}->{Permission} permissions!",
            WithHeader => 'yes',
        );
    }

    # store needed parameters in %GetParam to make it reloadable
    my %GetParam;
    for my $ParamName (
        qw(
        ChangeTitle Description Justification TicketID
        OldCategoryID CategoryID OldImpactID ImpactID OldPriorityID PriorityID
        ElementChanged
        SaveAttachment FileID
        MoveTimeType MoveTimeYear MoveTimeMonth MoveTimeDay MoveTimeHour
        MoveTimeMinute TemplateID
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
    TIME_TYPE:
    for my $TimeType (qw(RequestedTime MoveTime)) {

        # skip the requested time if not configured
        next TIME_TYPE if ( $TimeType eq 'RequestedTime' && !$Self->{Config}->{RequestedTime} );

        for my $TimePart (qw(Used Year Month Day Hour Minute)) {
            my $ParamName = $TimeType . $TimePart;
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
    # The entries are the names of the dtl validation error blocks.
    my @ValidationErrors;

    # remember the numbers of the change freetext fields with validation errors
    my %ChangeFreeTextValidationErrors;

    # get meta data for all already uploaded files
    my @Attachments = $Self->{UploadCacheObject}->FormIDGetAllFilesMeta(
        FormID => $Self->{FormID},
    );

    # reset subaction
    # if attachment upload is requested
    if ( $GetParam{SaveAttachment} ) {

        # get upload data
        my %UploadStuff = $Self->{ParamObject}->GetUploadAll(
            Param  => 'AttachmentNew',
            Source => 'string',
        );

        # check if file was already uploaded
        my $FileAlreadyUploaded = 0;
        for my $FileMetaData (@Attachments) {
            if ( $FileMetaData->{Filename} eq $UploadStuff{Filename} ) {
                $FileAlreadyUploaded = 1;

                # show error message
                push @ValidationErrors, 'FileAlreadyUploaded';
            }
        }

        if ( !$FileAlreadyUploaded ) {
            $Self->{UploadCacheObject}->FormIDAddFile(
                FormID => $Self->{FormID},
                %UploadStuff,
            );

            # reload attachment list, as an attachment was added
            @Attachments = $Self->{UploadCacheObject}->FormIDGetAllFilesMeta(
                FormID => $Self->{FormID},
            );
        }

        $Self->{Subaction} = 'SaveAttachment';
    }

    # reset subaction
    # if attachment should be deleted
    for my $Attachment (@Attachments) {
        if ( $Self->{ParamObject}->GetParam( Param => 'DeleteAttachment' . $Attachment->{FileID} ) )
        {

            # delete attachment
            $Self->{UploadCacheObject}->FormIDRemoveFile(
                FormID => $Self->{FormID},
                FileID => $Attachment->{FileID},
            );

            # set marker that the attachment list needs to be reloaded
            $Self->{Subaction} = 'DeleteAttachment';
        }
    }

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

        # the title is required
        if ( !$GetParam{ChangeTitle} ) {
            push @ValidationErrors, 'InvalidTitle';
        }

        # check CIP
        for my $Type (qw(Category Impact Priority)) {
            if ( !$GetParam{"${Type}ID"} || $GetParam{"${Type}ID"} !~ m{ \A \d+ \z }xms ) {
                push @ValidationErrors, 'Invalid' . $Type;
            }
            else {
                my $CIPIsValid = $Self->{ChangeObject}->ChangeCIPLookup(
                    ID   => $GetParam{"${Type}ID"},
                    Type => $Type,
                );

                if ( !$CIPIsValid ) {
                    push @ValidationErrors, 'Invalid' . $Type;
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

                # format as timestamp, when all required time param were passed
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
                    push @ValidationErrors, 'InvalidRequestedTime';
                }
            }
            else {

                # it was indicated that the requested time should be set,
                # but at least one of the required time params is missing
                push @ValidationErrors, 'InvalidRequestedTime';
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
                $ChangeFreeTextValidationErrors{$Number}++;
            }
        }

        # add only when there are no input validation errors
        if ( !@ValidationErrors && !%ChangeFreeTextValidationErrors ) {
            my %AdditionalParam;

            if ( $Self->{Config}->{RequestedTime} ) {
                $AdditionalParam{RequestedTime} = $GetParam{RequestedTime};
            }

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
                    OP => "Action=AgentITSMChangeZoom&ChangeID=$ChangeID",
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

    # create change from template
    elsif ( $Self->{Subaction} eq 'CreateFromTemplate' ) {

        my $NewTime;

        # check validity of the time type
        my $MoveTimeType = $GetParam{MoveTimeType};
        if (
            !defined $MoveTimeType
            || ( $MoveTimeType ne 'PlannedStartTime' && $MoveTimeType ne 'PlannedEndTime' )
            )
        {
            push @ValidationErrors, 'InvalidTimeType';
        }

        # check the completeness of the time parameter list,
        # only hour and minute are allowed to be '0'
        if (
            !$GetParam{MoveTimeYear}
            || !$GetParam{MoveTimeMonth}
            || !$GetParam{MoveTimeDay}
            || !defined $GetParam{MoveTimeHour}
            || !defined $GetParam{MoveTimeMinute}
            )
        {
            push @ValidationErrors, 'InvalidMoveTime';
        }

        # get the system time from the input, if it can't be determined we have a validation error
        if ( !@ValidationErrors ) {

            # format as timestamp
            my $PlannedTime = sprintf '%04d-%02d-%02d %02d:%02d:00',
                $GetParam{MoveTimeYear},
                $GetParam{MoveTimeMonth},
                $GetParam{MoveTimeDay},
                $GetParam{MoveTimeHour},
                $GetParam{MoveTimeMinute};

            # sanity check of the assembled timestamp
            $NewTime = $Self->{TimeObject}->TimeStamp2SystemTime(
                String => $PlannedTime,
            );

            if ( !$NewTime ) {
                push @ValidationErrors, 'InvalidMoveTime';
            }
        }

        # check whether a template was selected
        if ( !$GetParam{TemplateID} ) {
            push @ValidationErrors, 'InvalidTemplate';
        }

        if ( !@ValidationErrors ) {

            # create change based on the template
            my $ChangeID = $Self->{TemplateObject}->TemplateDeSerialize(
                TemplateID => $Self->{ParamObject}->GetParam( Param => 'TemplateID' ),
                UserID => $Self->{UserID},
                NewTimeInEpoche => $NewTime,
                MoveTimeType    => $GetParam{MoveTimeType},
            );

            # change could not be created
            if ( !$ChangeID ) {

                # show error message, when adding failed
                return $Self->{LayoutObject}->ErrorScreen(
                    Message => 'Was not able to create change from template!',
                    Comment => 'Please contact the admin.',
                );
            }

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

            # redirect to zoom mask, when adding was successful
            return $Self->{LayoutObject}->Redirect(
                OP => "Action=AgentITSMChangeZoom&ChangeID=$ChangeID",
            );
        }
    }

    # handle save attachment subaction
    elsif ( $Self->{Subaction} eq 'SaveAttachment' ) {

        # nothing to do
        # attachments were already saved above
    }

    # handle attachment deletion
    elsif ( $Self->{Subaction} eq 'DeleteAttachment' ) {

        # reload the attachment list,
        # as at least one attachment was deleted above
        @Attachments = $Self->{UploadCacheObject}->FormIDGetAllFilesMeta(
            FormID => $Self->{FormID},
        );
    }

    # handle attachment downloads
    elsif ( $Self->{Subaction} eq 'DownloadAttachment' ) {

        # get meta-data and content of the cached attachments
        my @CachedAttachments = $Self->{UploadCacheObject}->FormIDGetAllFilesData(
            FormID => $Self->{FormID},
        );

        # get data for requested attachment
        my ($AttachmentData) = grep { $_->{FileID} == $GetParam{FileID} } @CachedAttachments;

        # return error if file does not exist
        if ( !$AttachmentData ) {
            $Self->{LogObject}->Log(
                Message  => "No such attachment ($GetParam{FileID})! May be an attack!!!",
                Priority => 'error',
            );
            return $Self->{LayoutObject}->ErrorScreen();
        }

        return $Self->{LayoutObject}->Attachment(
            %{$AttachmentData},
            Type => 'attachment',
        );
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
        my $JSON = $Self->{LayoutObject}->BuildJSON(
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

    # build template dropdown
    my $TemplateList = $Self->{TemplateObject}->TemplateList(
        UserID        => $Self->{UserID},
        CommentLength => 15,
        TemplateType  => 'ITSMChange',
    );
    my $TemplateSelectionString = $Self->{LayoutObject}->BuildSelection(
        Name         => 'TemplateID',
        Data         => $TemplateList,
        PossibleNone => 1,
    );

    # build drop-down with time types
    my $MoveTimeTypeSelectionString = $Self->{LayoutObject}->BuildSelection(
        Data => [
            { Key => 'PlannedStartTime', Value => 'PlannedStartTime' },
            { Key => 'PlannedEndTime',   Value => 'PlannedEndTime' },
        ],
        Name => 'MoveTimeType',
        SelectedID => $GetParam{MoveTimeType} || 'PlannedStartTime',
    );

    # time period that can be selected from the GUI
    my %TimePeriod = %{ $Self->{ConfigObject}->Get('ITSMWorkOrder::TimePeriod') };

    # add selection for the time
    my $MoveTimeSelectionString = $Self->{LayoutObject}->BuildDateSelection(
        %GetParam,
        Format => 'DateInputFormatLong',
        Prefix => 'MoveTime',
        %TimePeriod,
    );

    # remove AJAX-Loading images in date selection fields to avoid jitter effect
    $MoveTimeSelectionString = $Self->{LayoutObject}->RemoveAJAXLoadingImage(
        HTMLString => $MoveTimeSelectionString,
    );

    # show block with template dropdown
    $Self->{LayoutObject}->Block(
        Name => 'ChangeTemplate',
        Data => {
            %GetParam,
            TemplateSelectionString     => $TemplateSelectionString,
            MoveTimeTypeSelectionString => $MoveTimeTypeSelectionString,
            MoveTimeSelectionString     => $MoveTimeSelectionString,
        },
    );

    # show validation errors in ChangeTemplate block
    my %ValidationErrorNames;
    @ValidationErrorNames{@ValidationErrors} = (1) x @ValidationErrors;
    for my $ChangeTemplateValidationError (qw(InvalidMoveTimeType InvalidMoveTime InvalidTemplate))
    {
        if ( $ValidationErrorNames{$ChangeTemplateValidationError} ) {
            $Self->{LayoutObject}->Block(
                Name => $ChangeTemplateValidationError,
            );
        }
    }

    # output header
    my $Output = $Self->{LayoutObject}->Header(
        Title => 'Add',
    );
    $Output .= $Self->{LayoutObject}->NavigationBar();

    # add rich text editor
    if ( $Self->{ConfigObject}->Get('Frontend::RichText') ) {
        $Self->{LayoutObject}->Block(
            Name => 'RichText',
        );
    }

    if ( $Self->{Config}->{RequestedTime} ) {

        # time period that can be selected from the GUI
        my %TimePeriod = %{ $Self->{ConfigObject}->Get('ITSMWorkOrder::TimePeriod') };

        # add selection for the time
        my $TimeSelectionString = $Self->{LayoutObject}->BuildDateSelection(
            %GetParam,
            Format                => 'DateInputFormatLong',
            Prefix                => 'RequestedTime',
            RequestedTimeOptional => 1,
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
        Ajax       => {
            Update => [
                'PriorityID',
            ],
            Depend => [
                'CategoryID',
                'ImpactID',
            ],
            Subaction => 'AJAXUpdate',
        },
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
        Ajax       => {
            Update => [
                'PriorityID',
            ],
            Depend => [
                'CategoryID',
                'ImpactID',
            ],
            Subaction => 'AJAXUpdate',
        },
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
    }

    # build the change freetext HTML
    my %ChangeFreeTextHTML = $Self->{LayoutObject}->BuildFreeTextHTML(
        Config                   => \%ChangeFreeTextConfig,
        ChangeData               => \%ChangeFreeTextParam,
        ConfiguredFreeTextFields => \@ConfiguredChangeFreeTextFields,
    );

    # show change freetext fields
    my $ChangeFreeTextShown;
    for my $Number (@ConfiguredChangeFreeTextFields) {

        # check if this freetext field should be shown in this frontend
        if ( $Self->{Config}->{ChangeFreeText}->{$Number} ) {

            # remember that at least one freetext field is shown
            $ChangeFreeTextShown = 1;

            # show single change freetext fields
            $Self->{LayoutObject}->Block(
                Name => 'ChangeFreeText' . $Number,
                Data => {
                    %ChangeFreeTextHTML,
                },
            );

            # show change freetext validation error for single change freetext field
            if ( $ChangeFreeTextValidationErrors{$Number} ) {
                $Self->{LayoutObject}->Block(
                    Name => 'InvalidChangeFreeText' . $Number,
                    Data => {
                        %ChangeFreeTextHTML,
                    },
                );
            }

            # show all change freetext fields
            $Self->{LayoutObject}->Block(
                Name => 'ChangeFreeText',
                Data => {
                    ChangeFreeKeyField  => $ChangeFreeTextHTML{ 'ChangeFreeKeyField' . $Number },
                    ChangeFreeTextField => $ChangeFreeTextHTML{ 'ChangeFreeTextField' . $Number },
                },
            );

            # show all change freetext validation errors
            if ( $ChangeFreeTextValidationErrors{$Number} ) {
                $Self->{LayoutObject}->Block(
                    Name => 'InvalidChangeFreeText',
                    Data => {
                        %ChangeFreeTextHTML,
                    },
                );
            }
        }
    }

    # show space between priority and change freetext if change freetext fields are shown
    if ($ChangeFreeTextShown) {

        $Self->{LayoutObject}->Block(
            Name => 'ChangeFreeTextSpacer',
            Data => {},
        );
    }

    # build change freetext java script check
    NUMBER:
    for my $Number (@ConfiguredChangeFreeTextFields) {

        next NUMBER if !$Self->{Config}->{ChangeFreeText}->{$Number};

        # java script check for required change free text fields by form submit
        if ( $Self->{Config}->{ChangeFreeText}->{$Number} == 2 ) {
            $Self->{LayoutObject}->Block(
                Name => 'ChangeFreeTextCheckJs',
                Data => {
                    ChangeFreeKeyField  => 'ChangeFreeKey' . $Number,
                    ChangeFreeTextField => 'ChangeFreeText' . $Number,
                },
            );
        }
    }

    # add the validation error messages
    for my $BlockName (@ValidationErrors) {
        $Self->{LayoutObject}->Block( Name => $BlockName );
    }

    # show attachments
    for my $Attachment (@Attachments) {
        $Self->{LayoutObject}->Block(
            Name => 'AttachmentRow',
            Data => {
                %{$Attachment},
                FormID => $Self->{FormID},
            },
        );
    }

    # start template output
    $Output .= $Self->{LayoutObject}->Output(
        TemplateFile => 'AgentITSMChangeAdd',
        Data         => {
            %Param,
            %GetParam,
            FormID => $Self->{FormID},
        },
    );

    # add footer
    $Output .= $Self->{LayoutObject}->Footer();

    return $Output;
}

1;
