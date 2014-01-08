# --
# Kernel/Modules/AgentITSMWorkOrderAddFromTemplate.pm - the OTRS ITSM ChangeManagement workorder add module (from template)
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentITSMWorkOrderAddFromTemplate;

use strict;
use warnings;

use Kernel::System::ITSMChange;
use Kernel::System::ITSMChange::ITSMWorkOrder;
use Kernel::System::ITSMChange::Template;
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
    $Self->{TemplateObject}    = Kernel::System::ITSMChange::Template->new(%Param);

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
        qw(MoveTimeType MoveTimeYear MoveTimeMonth MoveTimeDay MoveTimeHour MoveTimeMinute TemplateID)
        )
    {
        $GetParam{$ParamName} = $Self->{ParamObject}->GetParam( Param => $ParamName );
    }

    # store time related fields in %GetParam
    for my $TimePart (qw(Year Month Day Hour Minute)) {
        my $ParamName = 'MoveTime' . $TimePart;
        $GetParam{$ParamName} = $Self->{ParamObject}->GetParam( Param => $ParamName );
    }

    # Remember the reason why saving was not attempted.
    my %ValidationError;

    # create workorder from template
    if ( $Self->{Subaction} eq 'CreateFromTemplate' ) {

        my $NewTime;

        # check validity of the time type
        if (
            !defined $GetParam{MoveTimeType}
            || (
                $GetParam{MoveTimeType} ne 'PlannedStartTime'
                && $GetParam{MoveTimeType} ne 'PlannedEndTime'
            )
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

            # transform work order planned time, time stamp based on user time zone
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

            # create workorder based on the template
            my $WorkOrderID = $Self->{TemplateObject}->TemplateDeSerialize(
                ChangeID        => $ChangeID,
                TemplateID      => $Self->{ParamObject}->GetParam( Param => 'TemplateID' ),
                UserID          => $Self->{UserID},
                NewTimeInEpoche => $NewTime,
                MoveTimeType    => $GetParam{MoveTimeType},
            );

            # workorder could not be created
            if ( !$WorkOrderID ) {

                # show error message, when adding failed
                return $Self->{LayoutObject}->ErrorScreen(
                    Message => 'Was not able to create workorder from template!',
                    Comment => 'Please contact the admin.',
                );
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
    }

    # build template dropdown
    my $TemplateList = $Self->{TemplateObject}->TemplateList(
        UserID        => $Self->{UserID},
        CommentLength => 15,
        TemplateType  => 'ITSMWorkOrder',
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

    # start template output
    $Output .= $Self->{LayoutObject}->Output(
        TemplateFile => 'AgentITSMWorkOrderAddFromTemplate',
        Data         => {
            %Param,
            %{$Change},
            %GetParam,
            ChangeID                    => $ChangeID,
            TemplateSelectionString     => $TemplateSelectionString,
            MoveTimeTypeSelectionString => $MoveTimeTypeSelectionString,
            MoveTimeSelectionString     => $MoveTimeSelectionString,
            %ValidationError,
            FormID => $Self->{FormID},
        },
    );

    # add footer
    $Output .= $Self->{LayoutObject}->Footer( Type => 'Small' );

    return $Output;
}

1;
