# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentITSMWorkOrderHistoryZoom;

use strict;
use warnings;

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # get needed change id
    my $HistoryEntryID = $Kernel::OM->Get('Kernel::System::Web::Request')->GetParam( Param => 'HistoryEntryID' );

    # get layout object
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # check needed stuff
    if ( !$HistoryEntryID ) {

        # error page
        return $LayoutObject->ErrorScreen(
            Message => "Can't show history zoom, no HistoryEntryID is given!",
            Comment => 'Please contact the administrator.',
        );
    }

    # get history entries
    my $HistoryEntry = $Kernel::OM->Get('Kernel::System::ITSMChange::History')->HistoryEntryGet(
        HistoryEntryID => $HistoryEntryID,
        UserID         => $Self->{UserID},
    );

    if ( !$HistoryEntry ) {
        return $LayoutObject->ErrorScreen(
            Message => "HistoryEntry '$HistoryEntryID' not found in the data base!",
            Comment => 'Please contact the administrator.',
        );
    }

    # get workorder object
    my $WorkOrderObject = $Kernel::OM->Get('Kernel::System::ITSMChange::ITSMWorkOrder');

    # get config of frontend module
    $Self->{Config} = $Kernel::OM->Get('Kernel::Config')->Get("ITSMWorkOrder::Frontend::$Self->{Action}");

    # check permissions
    my $Access = $WorkOrderObject->Permission(
        Type        => $Self->{Config}->{Permission},
        Action      => $Self->{Action},
        WorkOrderID => $HistoryEntry->{WorkOrderID},
        UserID      => $Self->{UserID},
    );

    # error screen
    if ( !$Access ) {
        return $LayoutObject->NoPermission(
            Message    => "You need $Self->{Config}->{Permission} permissions!",
            WithHeader => 'yes',
        );
    }

    # get workorder information
    my $WorkOrder = $WorkOrderObject->WorkOrderGet(
        WorkOrderID => $HistoryEntry->{WorkOrderID},
        UserID      => $Self->{UserID},
    );

    # check error
    if ( !$WorkOrder ) {
        return $LayoutObject->ErrorScreen(
            Message => "WorkOrder '$HistoryEntry->{WorkOrderID}' not found in the data base!",
            Comment => 'Please contact the administrator.',
        );
    }

    # get change information
    my $Change = $Kernel::OM->Get('Kernel::System::ITSMChange')->ChangeGet(
        ChangeID => $HistoryEntry->{ChangeID},
        UserID   => $Self->{UserID},
    );

    # check error
    if ( !$WorkOrder ) {
        return $LayoutObject->ErrorScreen(
            Message => "Change '$HistoryEntry->{ChangeID}' not found in the data base!",
            Comment => 'Please contact the administrator.',
        );
    }

    # show dash ('-') when the field is empty
    for my $Field (qw(ContentNew ContentOld)) {
        $HistoryEntry->{$Field} ||= '-'
    }

    # output header
    my $Output = $LayoutObject->Header(
        Type  => 'Small',
        Title => 'WorkOrderHistoryZoom',
    );

    # start template output
    $Output .= $LayoutObject->Output(
        TemplateFile => 'AgentITSMWorkOrderHistoryZoom',
        Data         => {
            %Param,
            %{$Change},
            %{$WorkOrder},
            %{$HistoryEntry},
        },
    );

    # add footer
    $Output .= $LayoutObject->Footer(
        Type => 'Small',
    );

    return $Output;
}

1;
