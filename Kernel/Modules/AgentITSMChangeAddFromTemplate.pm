# --
# Kernel/Modules/AgentITSMChangeAddFromTemplate.pm - the OTRS ITSM ChangeManagement change add module (from template)
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentITSMChangeAddFromTemplate;

use strict;
use warnings;

use Kernel::System::ITSMChange;
use Kernel::System::ITSMChange::Template;
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
    $Self->{TemplateObject}    = Kernel::System::ITSMChange::Template->new(%Param);
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
        qw(MoveTimeType MoveTimeYear MoveTimeMonth MoveTimeDay MoveTimeHour MoveTimeMinute TicketID TemplateID)
        )
    {
        $GetParam{$ParamName} = $Self->{ParamObject}->GetParam( Param => $ParamName );
    }

    # store time related fields in %GetParam
    for my $TimePart (qw(Used Year Month Day Hour Minute)) {
        my $ParamName = 'MoveTime' . $TimePart;
        $GetParam{$ParamName} = $Self->{ParamObject}->GetParam( Param => $ParamName );
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

    # create change from template
    if ( $Self->{Subaction} eq 'CreateFromTemplate' ) {

        my $NewTime;

        # check validity of the time type
        my $MoveTimeType = $GetParam{MoveTimeType};
        if (
            !defined $MoveTimeType
            || ( $MoveTimeType ne 'PlannedStartTime' && $MoveTimeType ne 'PlannedEndTime' )
            )
        {
            $ValidationError{MoveTimeTypeInvalid} = 'ServerError';
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
            $ValidationError{MoveTimeInvalid} = 'ServerError';
        }

        # get the system time from the input, if it can't be determined we have a validation error
        if ( !%ValidationError ) {

            # transform change planned time, time stamp based on user time zone
            %GetParam = $Self->{LayoutObject}->TransformDateSelection(
                %GetParam,
                Prefix => 'MoveTime',
            );

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
                $ValidationError{MoveTimeInvalid} = 'ServerError';
            }
        }

        # check whether a template was selected
        if ( !$GetParam{TemplateID} ) {
            $ValidationError{TemplateIDServerError} = 'ServerError';
        }

        if ( !%ValidationError ) {

            # create change based on the template
            my $ChangeID = $Self->{TemplateObject}->TemplateDeSerialize(
                TemplateID => $Self->{ParamObject}->GetParam( Param => 'TemplateID' ),
                UserID     => $Self->{UserID},
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
                OP => "Action=AgentITSMChangeZoom;ChangeID=$ChangeID",
            );
        }
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
        Class        => 'Validate_Required ' . ( $ValidationError{TemplateIDServerError} || '' ),
        PossibleNone => 1,
    );

    # build drop-down with time types
    my $MoveTimeTypeSelectionString = $Self->{LayoutObject}->BuildSelection(
        Name => 'MoveTimeType',
        Data => [
            { Key => 'PlannedStartTime', Value => 'PlannedStartTime' },
            { Key => 'PlannedEndTime',   Value => 'PlannedEndTime' },
        ],
        SelectedID => $GetParam{MoveTimeType} || 'PlannedStartTime',
        Class => 'Validate_Required ' . ( $ValidationError{MoveTimeTypeInvalid} || '' ),
    );

    # time period that can be selected from the GUI
    my %TimePeriod = %{ $Self->{ConfigObject}->Get('ITSMWorkOrder::TimePeriod') };

    # add selection for the time
    my $MoveTimeSelectionString = $Self->{LayoutObject}->BuildDateSelection(
        %GetParam,
        Format        => 'DateInputFormatLong',
        Prefix        => 'MoveTime',
        MoveTimeClass => 'Validate_Required ' . ( $ValidationError{MoveTimeInvalid} || '' ),
        Validate      => 1,
        %TimePeriod,
    );

    # output header
    my $Output = $Self->{LayoutObject}->Header(
        Title => 'Add',
    );
    $Output .= $Self->{LayoutObject}->NavigationBar();

    # start template output
    $Output .= $Self->{LayoutObject}->Output(
        TemplateFile => 'AgentITSMChangeAddFromTemplate',
        Data         => {
            %Param,
            %GetParam,
            %ValidationError,
            FormID                      => $Self->{FormID},
            TemplateSelectionString     => $TemplateSelectionString,
            MoveTimeTypeSelectionString => $MoveTimeTypeSelectionString,
            MoveTimeSelectionString     => $MoveTimeSelectionString,
        },
    );

    # add footer
    $Output .= $Self->{LayoutObject}->Footer();

    return $Output;
}

1;
