# --
# Kernel/Modules/AgentITSMChangeHistoryZoom.pm - the OTRS::ITSM::ChangeManagement change history zoom module
# Copyright (C) 2003-2009 OTRS AG, http://otrs.com/
# --
# $Id: AgentITSMChangeHistoryZoom.pm,v 1.3 2009-11-16 22:23:41 ub Exp $
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

use vars qw($VERSION);
$VERSION = qw($Revision: 1.3 $) [1];

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
            Message => 'Can\'t show history zoom, no HistoryEntryID is given!',
            Comment => 'Please contact the admin.',
        );
    }

    # get history entries
    my $HistoryEntry = $Self->{HistoryObject}->HistoryEntryGet(
        HistoryEntryID => $HistoryEntryID,
        UserID         => $Self->{UserID},
    );

    if ( !$HistoryEntry ) {
        return $Self->{LayoutObject}->ErrorScreen(
            Message => "HistoryEntry $HistoryEntryID not found in database!",
            Comment => 'Please contact the admin.',
        );
    }

    # check permissions
    my $Access = $Self->{ChangeObject}->Permission(
        Type     => $Self->{Config}->{Permission},
        ChangeID => $HistoryEntry->{ChangeID},
        UserID   => $Self->{UserID},
    );

    # error screen, don't show change add mask
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
            Message => 'Change ' . $HistoryEntry->{ChangeID} . ' not found in database!',
            Comment => 'Please contact the admin.',
        );
    }

    # show dash ('-') when the field is empty
    for my $Field (qw(ContentNew ContentOld)) {
        $HistoryEntry->{$Field} ||= '-'
    }

    # output header
    my $Output = $Self->{LayoutObject}->Header(
        Title => 'ChangeHistoryZoom',
    );
    $Output .= $Self->{LayoutObject}->NavigationBar();

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
    $Output .= $Self->{LayoutObject}->Footer();

    return $Output;
}

1;
