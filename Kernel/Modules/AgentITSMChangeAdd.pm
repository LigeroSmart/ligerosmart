# --
# Kernel/Modules/AgentITSMChangeAdd.pm - the OTRS::ITSM::ChangeManagement change add module
# Copyright (C) 2003-2009 OTRS AG, http://otrs.com/
# --
# $Id: AgentITSMChangeAdd.pm,v 1.31 2009-12-16 13:45:39 reb Exp $
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
use Kernel::System::VirtualFS;
use Kernel::System::Web::UploadCache;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.31 $) [1];

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
    $Self->{VirtualFSObject}   = Kernel::System::VirtualFS->new(%Param);
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
        qw(
        ChangeTitle Description Justification TicketID
        OldCategoryID CategoryID OldImpactID ImpactID OldPriorityID PriorityID
        ElementChanged SaveAttachment FileID
        )
        )
    {
        $GetParam{$ParamName} = $Self->{ParamObject}->GetParam( Param => $ParamName );
    }

    # store time related fields in %GetParam
    if ( $Self->{Config}->{RequestedTime} ) {
        for my $TimePart (qw(Year Month Day Hour Minute Used)) {
            my $ParamName = 'RequestedTime' . $TimePart;
            $GetParam{$ParamName} = $Self->{ParamObject}->GetParam( Param => $ParamName );
        }
    }

    # set default values for category and impact
    my $DefaultCategory = $Self->{ConfigObject}->Get('ITSMChange::Category::Default');
    $Param{CategoryID} = $GetParam{CategoryID} || $Self->{ChangeObject}->ChangeCIPLookup(
        CIP  => $DefaultCategory,
        Type => 'Category',
    );

    my $DefaultImpact = $Self->{ConfigObject}->Get('ITSMChange::Impact::Default');
    $Param{ImpactID} = $GetParam{ImpactID} || $Self->{ChangeObject}->ChangeCIPLookup(
        CIP  => $DefaultImpact,
        Type => 'Impact',
    );

    # if attachment upload is requested
    if ( $GetParam{SaveAttachment} ) {
        my %UploadStuff = $Self->{ParamObject}->GetUploadAll(
            Param  => "AttachmentNew",
            Source => 'string',
        );
        $Self->{UploadCacheObject}->FormIDAddFile(
            FormID => $Self->{FormID},
            %UploadStuff,
        );

        $Self->{Subaction} = 'SaveAttachment';
    }

    # get all attachments meta data
    my @Attachments = $Self->{UploadCacheObject}->FormIDGetAllFilesMeta(
        FormID => $Self->{FormID},
    );

    # check if attachment should be deleted
    for my $Attachment (@Attachments) {
        if ( $Self->{ParamObject}->GetParam( Param => 'DeleteAttachment' . $Attachment->{FileID} ) )
        {

            # delete attachment
            $Self->{UploadCacheObject}->FormIDRemoveFile(
                FormID => $Self->{FormID},
                FileID => $Attachment->{FileID},
            );

            # reload attachment list
            @Attachments = $Self->{UploadCacheObject}->FormIDGetAllFilesMeta(
                FormID => $Self->{FormID},
            );

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

    # Remember the reason why saving was not attempted.
    # The entries are the names of the dtl validation error blocks.
    my @ValidationErrors;
    my %CIPErrors;

    # update change
    if ( $Self->{Subaction} eq 'Save' ) {

        # check the title
        if ( !$GetParam{ChangeTitle} ) {
            push @ValidationErrors, 'InvalidTitle';
        }

        # check CIP
        for my $Type (qw(Category Impact Priority)) {
            if ( !$GetParam{"${Type}ID"} ) {
                push @ValidationErrors, 'Invalid' . $Type;
                $CIPErrors{$Type} = 1;
            }
            else {
                my $CIPIsValid = $Self->{ChangeObject}->ChangeCIPLookup(
                    ID   => $GetParam{"${Type}ID"},
                    Type => $Type,
                );

                if ( !$CIPIsValid ) {
                    push @ValidationErrors, 'Invalid' . $Type;
                    $CIPErrors{$Type} = 1;
                }
            }
        }

        # check the requested time
        if ( $Self->{Config}->{RequestedTime} && $GetParam{RequestedTimeUsed} ) {

            if (
                $GetParam{RequestedTimeYear}
                && $GetParam{RequestedTimeMonth}
                && $GetParam{RequestedTimeDay}
                && $GetParam{RequestedTimeHour}
                && $GetParam{RequestedTimeMinute}
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

        # add only when there are no input validation errors
        if ( !@ValidationErrors ) {
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
            );

            # change could be added successfully
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
                    my $Success = $Self->{VirtualFSObject}->Write(
                        Filename    => "Change/$ChangeID/" . $CachedAttachment->{Filename},
                        Mode        => 'binary',
                        Content     => \$CachedAttachment->{Content},
                        Preferences => {
                            ContentID   => $CachedAttachment->{ContentID},
                            ContentType => $CachedAttachment->{ContentType},
                            ChangeID    => $ChangeID,
                        },
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

                # redirect to zoom mask
                return $Self->{LayoutObject}->Redirect(
                    OP => "Action=AgentITSMChangeZoom&ChangeID=$ChangeID",
                );
            }
            else {

                # show error message
                return $Self->{LayoutObject}->ErrorScreen(
                    Message => 'Was not able to add Change!',
                    Comment => 'Please contact the admin.',
                );
            }
        }
    }

    # handle attachment downloads
    elsif ( $Self->{Subaction} eq 'DownloadAttachment' ) {

        # get filename
        my $Filename = $Attachments{ $GetParam{FileID} };

        # return error if file does not exist
        if ( !$Filename ) {
            $Self->{LogObject}->Log(
                Message  => "No such attachment ($GetParam{FileID})! May be an attack!!!",
                Priority => 'error',
            );
            return $Self->{LayoutObject}->ErrorScreen();
        }

        # get data for attachment
        my %AttachmentData = $Self->{VirtualFSObject}->Read(
            Filename => $Filename,
            Mode     => 'binary',
        );

        # remove extra information from filename
        ( my $NameDisplayed = $Filename ) =~ s{ \A WorkOrder / \d+ / }{}xms;

        return $Self->{LayoutObject}->Attachment(
            Filename    => $NameDisplayed,
            Content     => ${ $AttachmentData{Content} },
            ContentType => $AttachmentData{Preferences}->{ContentType},
            Type        => 'attachment',
        );
    }

    # handle AJAXUpdate
    elsif ( $Self->{Subaction} eq 'AJAXUpdate' ) {

        # get priorities
        my $Priorities = $Self->{ChangeObject}->ChangePossibleCIPGet(
            Type => 'Priority',
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
    # TODO: fill dropdown with data
    my $TemplateDropDown = $Self->{LayoutObject}->BuildSelection(
        Name => 'ChangeTemplate',
        Data => {},
    );

    # show block with template dropdown
    $Self->{LayoutObject}->Block(
        Name => 'ChangeTemplate',
        Data => {
            TemplatesStrg => $TemplateDropDown,
        },
    );

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

    # get categories
    $Param{Categories} = $Self->{ChangeObject}->ChangePossibleCIPGet(
        Type => 'Category',
    );

    # create category selection string
    $Param{'CategoryStrg'} = $Self->{LayoutObject}->BuildSelection(
        Data       => $Param{Categories},
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

    # show category dropdown
    $Self->{LayoutObject}->Block(
        Name => 'Category',
        Data => {
            %Param,
        },
    );

    # show error block
    if ( $CIPErrors{Category} ) {
        $Self->{LayoutObject}->Block( Name => 'InvalidCategory' );
    }

    # get impacts
    $Param{Impacts} = $Self->{ChangeObject}->ChangePossibleCIPGet(
        Type => 'Impact',
    );

    # create impact string
    $Param{'ImpactStrg'} = $Self->{LayoutObject}->BuildSelection(
        Data       => $Param{Impacts},
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

    # show impact dropdown
    $Self->{LayoutObject}->Block(
        Name => 'Impact',
        Data => {
            %Param,
        },
    );

    # show error block
    if ( $CIPErrors{Impact} ) {
        $Self->{LayoutObject}->Block( Name => 'InvalidImpact' );
    }

    # get priorities
    $Param{Priorities} = $Self->{ChangeObject}->ChangePossibleCIPGet(
        Type => 'Priority',
    );

    # get selected priority, or the default value
    my $SelectedPriority = $GetParam{PriorityID};
    $SelectedPriority ||= $Self->{CIPAllocateObject}->PriorityAllocationGet(
        CategoryID => $Param{CategoryID},
        ImpactID   => $Param{ImpactID},
    );

    # create impact string
    $Param{'PriorityStrg'} = $Self->{LayoutObject}->BuildSelection(
        Data       => $Param{Priorities},
        Name       => 'PriorityID',
        SelectedID => $SelectedPriority,
    );

    # show priority dropdown
    $Self->{LayoutObject}->Block(
        Name => 'Priority',
        Data => {
            %Param,
        },
    );

    # show error block
    if ( $CIPErrors{Priority} ) {
        $Self->{LayoutObject}->Block( Name => 'InvalidPriority' );
    }

    # Add the validation error messages as late as possible
    # as the enclosing blocks, e.g. 'RequestedTime' muss first be set.
    for my $BlockName (@ValidationErrors) {

        # show validation error message
        $Self->{LayoutObject}->Block(
            Name => $BlockName,
        );
    }

    # show attachments
    for my $Attachment (@Attachments) {
        $Self->{LayoutObject}->Block(
            Name => 'AttachmentRow',
            Data => {
                %{$Attachment},
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
