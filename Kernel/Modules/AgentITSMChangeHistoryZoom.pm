# --
# Kernel/Modules/AgentITSMChangeHistoryZoom.pm - the OTRS ITSM ChangeManagement change history zoom module
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentITSMChangeHistoryZoom;

use strict;
use warnings;

use Kernel::System::ITSMChange;
use Kernel::System::ITSMChange::ITSMWorkOrder;
use Kernel::System::ITSMChange::History;

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
    $Self->{ChangeObject}    = Kernel::System::ITSMChange->new(%Param);
    $Self->{WorkOrderObject} = Kernel::System::ITSMChange::ITSMWorkOrder->new(%Param);
    $Self->{HistoryObject}   = Kernel::System::ITSMChange::History->new(%Param);

    # get config of frontend module
    $Self->{Config} = $Self->{ConfigObject}->Get("ITSMChange::Frontend::$Self->{Action}");

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # get needed change id
    my $HistoryEntryID = $Self->{ParamObject}->GetParam( Param => 'HistoryEntryID' );

    # check needed stuff
    if ( !$HistoryEntryID ) {

        # error page
        return $Self->{LayoutObject}->ErrorScreen(
            Message => "Can't show history zoom, no HistoryEntryID is given!",
            Comment => 'Please contact the administrator.',
        );
    }

    # get history entries
    my $HistoryEntry = $Self->{HistoryObject}->HistoryEntryGet(
        HistoryEntryID => $HistoryEntryID,
        UserID         => $Self->{UserID},
    );

    if ( !$HistoryEntry ) {
        return $Self->{LayoutObject}->ErrorScreen(
            Message => "HistoryEntry '$HistoryEntryID' not found in database!",
            Comment => 'Please contact the administrator.',
        );
    }

    # check permissions
    my $Access = $Self->{ChangeObject}->Permission(
        Type     => $Self->{Config}->{Permission},
        Action   => $Self->{Action},
        ChangeID => $HistoryEntry->{ChangeID},
        UserID   => $Self->{UserID},
    );

    # error screen
    if ( !$Access ) {
        return $Self->{LayoutObject}->NoPermission(
            Message    => "You need $Self->{Config}->{Permission} permissions!",
            WithHeader => 'yes',
        );
    }

    # get change information
    my $Change = $Self->{ChangeObject}->ChangeGet(
        ChangeID => $HistoryEntry->{ChangeID},
        UserID   => $Self->{UserID},
    );

    # check error
    if ( !$Change ) {
        return $Self->{LayoutObject}->ErrorScreen(
            Message => "Change '$HistoryEntry->{ChangeID}' not found in the data base!",
            Comment => 'Please contact the administrator.',
        );
    }

    # show dash ('-') when the field is empty
    for my $Field (qw(ContentNew ContentOld)) {
        $HistoryEntry->{$Field} ||= '-'
    }

    # output header
    my $Output = $Self->{LayoutObject}->Header(
        Type  => 'Small',
        Title => 'ChangeHistoryZoom',
    );

    # handle condition update
    if ( $HistoryEntry->{HistoryType} eq 'ConditionUpdate' ) {
        $HistoryEntry->{ContentNew} =~ s{ \A \d+ %% (.+) \z }{$1}xms;
        $HistoryEntry->{ContentOld} =~ s{ \A \d+ %% (.+) \z }{$1}xms;
    }

    # start template output
    $Output .= $Self->{LayoutObject}->Output(
        TemplateFile => 'AgentITSMChangeHistoryZoom',
        Data         => {
            %Param,
            %{$Change},
            %{$HistoryEntry},
        },
    );

    # add footer
    $Output .= $Self->{LayoutObject}->Footer(
        Type => 'Small',
    );

    return $Output;
}

1;
