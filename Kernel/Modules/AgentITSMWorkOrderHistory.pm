# --
# Kernel/Modules/AgentITSMWorkOrderHistory.pm - the OTRS::ITSM::ChangeManagement workorder history module
# Copyright (C) 2003-2009 OTRS AG, http://otrs.com/
# --
# $Id: AgentITSMWorkOrderHistory.pm,v 1.7 2009-11-10 13:13:13 reb Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentITSMWorkOrderHistory;

use strict;
use warnings;

use Kernel::System::ITSMChange;
use Kernel::System::ITSMChange::ITSMWorkOrder;
use Kernel::System::ITSMChange::History;
use Kernel::System::HTMLUtils;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.7 $) [1];

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
    $Self->{HTMLUtilsObject} = Kernel::System::HTMLUtils->new(%Param);

    # get config of frontend module
    $Self->{Config} = $Self->{ConfigObject}->Get("ITSMWorkOrder::Frontend::$Self->{Action}");

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # get needed change id
    my $WorkOrderID = $Self->{ParamObject}->GetParam( Param => 'WorkOrderID' );

    # check needed stuff
    if ( !$WorkOrderID ) {

        # error page
        return $Self->{LayoutObject}->ErrorScreen(
            Message => 'Can\'t show history, no WorkOrderID is given!',
            Comment => 'Please contact the admin.',
        );
    }

    # check permissions
    my $Access = $Self->{WorkOrderObject}->Permission(
        Type        => $Self->{Config}->{Permission},
        WorkOrderID => $WorkOrderID,
        UserID      => $Self->{UserID}
    );

    # error screen
    if ( !$Access ) {
        return $Self->{LayoutObject}->NoPermission(
            Message    => "You need $Self->{Config}->{Permission} permissions!",
            WithHeader => 'yes',
        );
    }

    # get change information
    my $WorkOrder = $Self->{WorkOrderObject}->WorkOrderGet(
        WorkOrderID => $WorkOrderID,
        UserID      => $Self->{UserID},
    );

    # check error
    if ( !$WorkOrder ) {
        return $Self->{LayoutObject}->ErrorScreen(
            Message => "WorkOrder $WorkOrderID not found in database!",
            Comment => 'Please contact the admin.',
        );
    }

    # get change information
    my $Change = $Self->{ChangeObject}->ChangeGet(
        ChangeID => $WorkOrder->{ChangeID},
        UserID   => $Self->{UserID},
    );

    # check error
    if ( !$Change ) {
        return $Self->{LayoutObject}->ErrorScreen(
            Message => 'Change ' . $WorkOrder->{ChangeID} . ' not found in database!',
            Comment => 'Please contact the admin.',
        );
    }

    # get history entries
    my $HistoryEntriesRef = $Self->{HistoryObject}->WorkOrderHistoryGet(
        WorkOrderID => $WorkOrderID,
        UserID      => $Self->{UserID},
    );

    # get order direction
    my @HistoryLines = @{$HistoryEntriesRef};
    if ( $Self->{ConfigObject}->Get('ITSMChange::Frontend::HistoryOrder') eq 'reverse' ) {
        @HistoryLines = reverse @{$HistoryEntriesRef};
    }

    # max length of strings
    my $MaxLength = 50;

    # create table
    my $Counter = 1;
    for my $HistoryEntry (@HistoryLines) {
        $Counter++;

        # data for a single row
        my %Data = (
            %{$HistoryEntry},
        );

        # determine what should be shown
        my $HistoryType = $HistoryEntry->{HistoryType};
        if ( $HistoryType =~ m{ Update \z }xms ) {

            # tranlate fieldname for display
            my $TranslatedFieldname = $Self->{LayoutObject}->{LanguageObject}->Get(
                $HistoryEntry->{Fieldname},
            );

            $Data{Content} = join '%%', $TranslatedFieldname,
                $HistoryEntry->{ContentNew},
                $HistoryEntry->{ContentOld};
        }
        else {
            $Data{Content} = $HistoryEntry->{ContentNew};
        }

        # replace text
        if ( $Data{Content} ) {

            # remove leading %%
            $Data{Content} =~ s{ \A%% }{}xmsg;

            # split the content by %%
            my @Values = split( /%%/, $Data{Content} );

            # translate to ASCII representation
            for my $Value (@Values) {
                $Value = $Self->{HTMLUtilsObject}->ToAscii( String => $Value );
            }

            $Data{Content} = '';

            # clean the values
            for my $Value (@Values) {
                if ( $Data{Content} ) {
                    $Data{Content} .= "\", ";
                }

                $Data{Content} .= "\"$Value";
            }

            # we need at least a double quote
            if ( !$Data{Content} ) {
                $Data{Content} = '" ';
            }

            # show 'nice' output
            $Data{Content} = $Self->{LayoutObject}->{LanguageObject}->Get(
                'WorkOrderHistory::' . $Data{HistoryType} . '", ' . $Data{Content}
            );

            # remove not needed place holder
            $Data{Content} =~ s{ \%s }{}xmsg;
        }

        # seperate each searchresult line by using several css
        $Data{css} = $Counter % 2 ? 'searchpassive' : 'searchactive';

        $Self->{LayoutObject}->Block(
            Name => 'Row',
            Data => {%Data},
        );

        if (
            ( $HistoryEntry->{ContentNew} && length( $HistoryEntry->{ContentNew} ) > $MaxLength )
            || ( $HistoryEntry->{ContentOld} && length( $HistoryEntry->{ContentOld} ) > $MaxLength )
            )
        {

            # show historyzoom block
            $Self->{LayoutObject}->Block(
                Name => 'HistoryZoom',
                Data => {%Data},
            );

        }

        # don't show a link
        else {
            $Self->{LayoutObject}->Block(
                Name => 'HistoryZoomDash',
            );
        }

        $Self->{LayoutObject}->Block(
            Name => 'WorkOrderZoom',
            Data => {%Data},
        );

    }

    # output header
    my $Output = $Self->{LayoutObject}->Header(
        Title => 'WorkOrderHistory',
    );
    $Output .= $Self->{LayoutObject}->NavigationBar();

    # start template output
    $Output .= $Self->{LayoutObject}->Output(
        TemplateFile => 'AgentITSMWorkOrderHistory',
        Data         => {
            %Param,
            %{$Change},
            %{$WorkOrder},
        },
    );

    # add footer
    $Output .= $Self->{LayoutObject}->Footer();

    return $Output;
}

1;
