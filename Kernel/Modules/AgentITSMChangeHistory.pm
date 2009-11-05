# --
# Kernel/Modules/AgentITSMChangeHistory.pm - the OTRS::ITSM::ChangeManagement change history module
# Copyright (C) 2003-2009 OTRS AG, http://otrs.com/
# --
# $Id: AgentITSMChangeHistory.pm,v 1.7 2009-11-05 10:59:34 reb Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentITSMChangeHistory;

use strict;
use warnings;

use Kernel::System::ITSMChange;
use Kernel::System::ITSMChange::ITSMWorkOrder;
use Kernel::System::ITSMChange::History;

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

    # get config of frontend module
    $Self->{Config} = $Self->{ConfigObject}->Get("ITSMChange::Frontend::$Self->{Action}");

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # get needed change id
    my $ChangeID = $Self->{ParamObject}->GetParam( Param => 'ChangeID' );

    # check needed stuff
    if ( !$ChangeID ) {

        # error page
        return $Self->{LayoutObject}->ErrorScreen(
            Message => 'Can\'t show history, no ChangeID is given!',
            Comment => 'Please contact the admin.',
        );
    }

    # check permissions
    my $Access = $Self->{ChangeObject}->Permission(
        Type     => $Self->{Config}->{Permission},
        ChangeID => $ChangeID,
        UserID   => $Self->{UserID}
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

    # get history entries
    my $HistoryEntriesRef = $Self->{HistoryObject}->ChangeHistoryGet(
        ChangeID => $ChangeID,
        UserID   => $Self->{UserID},
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
            $Data{Content} =~ s/^%%//g;

            # split the content by %%
            my @Values = split( /%%/, $Data{Content} );

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

            my $HistoryItemType = 'Change';
            if ( $HistoryType =~ m{ \A WorkOrder }xms ) {
                $HistoryItemType = 'WorkOrder';
            }

            # show 'nice' output
            $Data{Content} = $Self->{LayoutObject}->{LanguageObject}->Get(
                $HistoryItemType . 'History::' . $Data{HistoryType} . '", ' . $Data{Content}
            );

            # remove not needed place holder
            $Data{Content} =~ s/\%s//g;
        }

        # seperate each searchresult line by using several css
        $Data{css} = $Counter % 2 ? 'searchpassive' : 'searchactive';

        # show a history entry
        $Self->{LayoutObject}->Block(
            Name => 'Row',
            Data => {%Data},
        );

        # show a 'more info' link
        if (
            ( $HistoryEntry->{ContentNew} && length( $HistoryEntry->{ContentNew} ) > $MaxLength )
            || ( $HistoryEntry->{ContentOld} && length( $HistoryEntry->{ContentOld} ) > $MaxLength )
            )
        {

            # is it a ChangeHistoryZoom or a WorkOrderHistoryZoom?
            my $ZoomType = 'Change';

            if ( $HistoryType =~ m{ \A WorkOrder }xms ) {
                $ZoomType = 'WorkOrder';
            }

            # show historyzoom block
            $Self->{LayoutObject}->Block(
                Name => 'HistoryZoom',
                Data => {
                    %Data,
                    ZoomType => $ZoomType,
                },
            );
        }

        # show link to workorder for WorkOrderAdd event - if the workorder still exists
        elsif ( $HistoryEntry->{HistoryType} eq 'WorkOrderAdd' ) {
            my $WorkOrder = $Self->{WorkOrderObject}->WorkOrderGet(
                WorkOrderID => $HistoryEntry->{WorkOrderID},
                UserID      => $Self->{UserID},
            );

            # show link
            if ($WorkOrder) {
                $Self->{LayoutObject}->Block(
                    Name => 'WorkOrderZoom',
                    Data => {%Data},
                );
            }
        }

        # show link to change for ChangeAdd event
        elsif ( $HistoryEntry->{HistoryType} eq 'ChangeAdd' ) {
            $Self->{LayoutObject}->Block(
                Name => 'ChangeZoom',
                Data => {%Data},
            );
        }

        # don't show any link
        else {
            $Self->{LayoutObject}->Block(
                Name => 'Dash',
            );
        }
    }

    # output header
    my $Output = $Self->{LayoutObject}->Header(
        Title => 'ChangeHistory',
    );
    $Output .= $Self->{LayoutObject}->NavigationBar();

    # start template output
    $Output .= $Self->{LayoutObject}->Output(
        TemplateFile => 'AgentITSMChangeHistory',
        Data         => {
            %Param,
            %{$Change},
        },
    );

    # add footer
    $Output .= $Self->{LayoutObject}->Footer();

    return $Output;
}

1;
