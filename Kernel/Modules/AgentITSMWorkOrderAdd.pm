# --
# Kernel/Modules/AgentITSMWorkOrderAdd.pm - the OTRS::ITSM::ChangeManagement workorder add module
# Copyright (C) 2003-2010 OTRS AG, http://otrs.com/
# --
# $Id: AgentITSMWorkOrderAdd.pm,v 1.40 2010-01-16 17:59:29 bes Exp $
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

use vars qw($VERSION);
$VERSION = qw($Revision: 1.40 $) [1];

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
    $Self->{WorkOrderObject}   = Kernel::System::ITSMChange::ITSMWorkOrder->new(%Param);
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
        ChangeID => $ChangeID,
        UserID   => $Self->{UserID},
    );

    # error screen, don't show the add mask
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

    # check error
    if ( !$Change ) {
        return $Self->{LayoutObject}->ErrorScreen(
            Message => "Change $ChangeID not found in database!",
            Comment => 'Please contact the admin.',
        );
    }

    # store needed parameters in %GetParam to make it reloadable
    my %GetParam;
    for my $ParamName (
        qw(
        WorkOrderTitle Instruction WorkOrderTypeID
        PlannedEffort
        SaveAttachment FileID
        MoveTimeType
        )
        )
    {
        $GetParam{$ParamName} = $Self->{ParamObject}->GetParam( Param => $ParamName );
    }

    # store time related fields in %GetParam
    for my $TimeType (qw(PlannedStartTime PlannedEndTime MoveTime)) {
        for my $TimePart (qw(Used Year Month Day Hour Minute)) {
            my $ParamName = $TimeType . $TimePart;
            $GetParam{$ParamName} = $Self->{ParamObject}->GetParam( Param => $ParamName );
        }
    }

    # Remember the reason why saving was not attempted.
    # The entries are the names of the dtl validation error blocks.
    my @ValidationErrors;

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

    # perform the adding
    if ( $Self->{Subaction} eq 'Save' ) {

        # the title is required
        if ( !$GetParam{WorkOrderTitle} ) {
            push @ValidationErrors, 'InvalidTitle';
        }

        # check WorkOrderTypeID
        my $WorkOrderType = $Self->{WorkOrderObject}->WorkOrderTypeLookup(
            UserID          => $Self->{UserID},
            WorkOrderTypeID => $GetParam{WorkOrderTypeID},
        );

        if ( !$WorkOrderType ) {
            push @ValidationErrors, 'InvalidType';
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

        # check format of planned effort
        if (
            $GetParam{PlannedEffort}
            && $GetParam{PlannedEffort} !~ m{ \A \d* (?: [.] \d{1,2} )? \z }xms
            )
        {
            push @ValidationErrors, 'InvalidPlannedEffort';
        }

        # add only when there are no input validation errors
        if ( !@ValidationErrors ) {
            my $WorkOrderID = $Self->{WorkOrderObject}->WorkOrderAdd(
                ChangeID         => $ChangeID,
                WorkOrderTitle   => $GetParam{WorkOrderTitle},
                Instruction      => $GetParam{Instruction},
                PlannedStartTime => $GetParam{PlannedStartTime},
                PlannedEndTime   => $GetParam{PlannedEndTime},
                WorkOrderTypeID  => $GetParam{WorkOrderTypeID},
                PlannedEffort    => $GetParam{PlannedEffort},
                UserID           => $Self->{UserID},
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

                # redirect to zoom mask, when adding was successful
                return $Self->{LayoutObject}->Redirect(
                    OP => "Action=AgentITSMWorkOrderZoom&WorkOrderID=$WorkOrderID",
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

    # handle saaveattachment subaction
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

    # build template dropdown
    # TODO: fill dropdown with data
    my $TemplateSelectionString = $Self->{LayoutObject}->BuildSelection(
        Name => 'WorkOrderTemplate',
        Data => {},
    );

    # build drop-down with time types
    my $MoveTimeTypeSelectionString = $Self->{LayoutObject}->BuildSelection(
        Data => [
            { Key => 'PlannedStartTime', Value => 'Planned start time' },
            { Key => 'PlannedEndTime',   Value => 'Planned end time' },
        ],
        Name => 'MoveTimeType',
        SelectedID => $GetParam{MoveTimeType} || 'PlannedStartTime',
    );

    # time period that can be selected from the GUI
    my %TimePeriod = %{ $Self->{ConfigObject}->Get('ITSMWorkOrder::TimePeriod') };

    # add selection for the time
    my $MoveTimeSelectionString = $Self->{LayoutObject}->BuildDateSelection(
        %GetParam,
        Format           => 'DateInputFormatLong',
        Prefix           => 'MoveTime',
        MoveTimeOptional => 1,
        %TimePeriod,
    );

    # remove AJAX-Loading images in date selection fields to avoid jitter effect
    $MoveTimeSelectionString =~ s{ <a [ ] id="AJAXImage [^<>]+ "></a> }{}xmsg;

    # show block with template dropdown
    $Self->{LayoutObject}->Block(
        Name => 'WorkOrderTemplate',
        Data => {
            TemplateSelectionString     => $TemplateSelectionString,
            MoveTimeTypeSelectionString => $MoveTimeTypeSelectionString,
            MoveTimeSelectionString     => $MoveTimeSelectionString,
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

    # set selected type
    my %SelectedInfo = (
        Default => 1,
    );

    if ( $GetParam{WorkOrderTypeID} ) {
        %SelectedInfo = ( Selected => $GetParam{WorkOrderTypeID}, )
    }

    # get WorkOrderType list
    my $WorkOrderTypeList = $Self->{WorkOrderObject}->WorkOrderTypeList(
        UserID => $Self->{UserID},
        %SelectedInfo,
    ) || [];

    # build the dropdown
    my $WorkOrderTypeDropDown = $Self->{LayoutObject}->BuildSelection(
        Name => 'WorkOrderTypeID',
        Data => $WorkOrderTypeList,
    );

    # show block with WorkOrderType dropdown
    $Self->{LayoutObject}->Block(
        Name => 'WorkOrderType',
        Data => {
            TypeStrg => $WorkOrderTypeDropDown,
        },
    );

    # set the time selection
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
        );
    }

    # Add the validation error messages.
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
                FormID   => $Self->{FormID},
                ChangeID => $ChangeID,
            },
        );
    }

    # start template output
    $Output .= $Self->{LayoutObject}->Output(
        TemplateFile => 'AgentITSMWorkOrderAdd',
        Data         => {
            %Param,
            %{$Change},
            %GetParam,
            FormID => $Self->{FormID},
        },
    );

    # add footer
    $Output .= $Self->{LayoutObject}->Footer();

    return $Output;
}

1;
