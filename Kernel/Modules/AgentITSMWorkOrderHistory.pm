# --
# Kernel/Modules/AgentITSMWorkOrderHistory.pm - the OTRS ITSM ChangeManagement workorder history module
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
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

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check needed objects
    for my $Object (
        qw(ParamObject DBObject LayoutObject LogObject UserObject GroupObject ConfigObject)
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
    $Self->{HTMLUtilsObject} = Kernel::System::HTMLUtils->new(%Param);

    # get config of frontend module
    $Self->{Config} = $Self->{ConfigObject}->Get("ITSMWorkOrder::Frontend::$Self->{Action}");

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # get needed workorder id
    my $WorkOrderID = $Self->{ParamObject}->GetParam( Param => 'WorkOrderID' );

    # check needed stuff
    if ( !$WorkOrderID ) {

        # error page
        return $Self->{LayoutObject}->ErrorScreen(
            Message => "Can't show history, as no WorkOrderID is given!",
            Comment => 'Please contact the administrator.',
        );
    }

    # check permissions
    my $Access = $Self->{WorkOrderObject}->Permission(
        Type        => $Self->{Config}->{Permission},
        Action      => $Self->{Action},
        WorkOrderID => $WorkOrderID,
        UserID      => $Self->{UserID},
    );

    # error screen
    if ( !$Access ) {
        return $Self->{LayoutObject}->NoPermission(
            Message    => "You need $Self->{Config}->{Permission} permissions!",
            WithHeader => 'yes',
        );
    }

    # get workorder information
    my $WorkOrder = $Self->{WorkOrderObject}->WorkOrderGet(
        WorkOrderID => $WorkOrderID,
        UserID      => $Self->{UserID},
    );

    # check error
    if ( !$WorkOrder ) {
        return $Self->{LayoutObject}->ErrorScreen(
            Message => "WorkOrder '$WorkOrderID' not found in the data base!",
            Comment => 'Please contact the administrator.',
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
            Message => "Change '$WorkOrder->{ChangeID}' not found in the data base!",
            Comment => 'Please contact the administrator.',
        );
    }

    # get history entries
    my $HistoryEntriesRef = $Self->{HistoryObject}->WorkOrderHistoryGet(
        WorkOrderID => $WorkOrderID,
        UserID      => $Self->{UserID},
    ) || [];

    # get order direction
    my @HistoryLines = @{$HistoryEntriesRef};
    if ( $Self->{ConfigObject}->Get('ITSMChange::Frontend::HistoryOrder') eq 'reverse' ) {
        @HistoryLines = reverse @{$HistoryEntriesRef};
    }

    # max length of strings
    my $MaxLength = 30;

    # create table
    my $Counter = 1;
    for my $HistoryEntry (@HistoryLines) {
        $Counter++;

        # data for a single row, will be passed to the dtl
        my %Data = %{$HistoryEntry};

        # determine what should be shown
        my $HistoryType = $HistoryEntry->{HistoryType};
        if ( $HistoryType eq 'WorkOrderUpdate' ) {

            # The displayed fieldname might be changed in the following loop
            my $DisplayedFieldname = $HistoryEntry->{Fieldname};

            # set default values for some keys
            for my $ContentNewOrOld (qw(ContentNew ContentOld)) {
                if ( !defined $HistoryEntry->{$ContentNewOrOld} ) {
                    $HistoryEntry->{$ContentNewOrOld} = '-';
                }
                else {

                    # for the ID fields, we replace ID with its textual value
                    if (
                        my ($Type) = $HistoryEntry->{Fieldname} =~ m{
                            \A          # string start
                            (           # start capture of $Type
                                WorkOrderState | WorkOrderType
                                | WorkOrderAgent
                            )           # end capture of $Type
                            ID          # processing only for the 'ID' fields
                        }xms
                        )
                    {
                        if ( $HistoryEntry->{$ContentNewOrOld} ) {
                            my $Value;
                            my $TranslationNeeded = 1;
                            if ( $Type eq 'WorkOrderState' ) {
                                $Value = $Self->{WorkOrderObject}->WorkOrderStateLookup(
                                    WorkOrderStateID => $HistoryEntry->{$ContentNewOrOld},
                                );
                            }
                            elsif ( $Type eq 'WorkOrderType' ) {
                                $Value = $Self->{WorkOrderObject}->WorkOrderTypeLookup(
                                    WorkOrderTypeID => $HistoryEntry->{$ContentNewOrOld},
                                );
                            }
                            elsif ( $Type eq 'WorkOrderAgent' ) {
                                $Value = $Self->{UserObject}->UserLookup(
                                    UserID => $HistoryEntry->{$ContentNewOrOld},
                                );

                                # the login names are not to be translated
                                $TranslationNeeded = 0;
                            }
                            else {
                                return $Self->{LayoutObject}->ErrorScreen(
                                    Message => "Unknown type '$Type' encountered!",
                                    Comment => 'Please contact the administrator.',
                                );
                            }

                            # E.g. the usernames should not be translated
                            my $TranslatedValue = $TranslationNeeded
                                ?
                                $Self->{LayoutObject}->{LanguageObject}->Get($Value)
                                :
                                $Value;

                            $HistoryEntry->{$ContentNewOrOld} = sprintf '%s (ID=%s)',
                                $TranslatedValue, $HistoryEntry->{$ContentNewOrOld};
                        }
                        else {
                            $HistoryEntry->{$ContentNewOrOld} = '-';
                        }

                        # The content has changed, so change the displayed fieldname as well
                        $DisplayedFieldname = $Type;
                    }

                    # replace HTML breaks with single space
                    $HistoryEntry->{$ContentNewOrOld} =~ s{ < br \s* /? > }{ }xmsg;
                }
            }

            # translate fieldname for display
            $DisplayedFieldname = $Self->{LayoutObject}->{LanguageObject}->Get(
                $DisplayedFieldname,
            );

            # trim strings to a max length of $MaxLength
            my $ContentNew = $Self->{HTMLUtilsObject}->ToAscii(
                String => $HistoryEntry->{ContentNew} || '-',
            );
            my $ContentOld = $Self->{HTMLUtilsObject}->ToAscii(
                String => $HistoryEntry->{ContentOld} || '-',
            );

            # show [...] for too long strings
            for my $Content ( $ContentNew, $ContentOld ) {
                if ( $Content && ( length $Content > $MaxLength ) ) {
                    $Content = substr( $Content, 0, $MaxLength ) . '[...]';
                }
            }

            # set description
            $Data{Content} = join '%%', $DisplayedFieldname, $ContentNew, $ContentOld;
        }
        else {
            $Data{Content} = $HistoryEntry->{ContentNew};
        }

        # replace text
        if ( $Data{Content} ) {

            # remove leading %%
            $Data{Content} =~ s{ \A %% }{}xmsg;

            # split the content by %%
            my @Values = split( /%%/, $Data{Content} );

            $Data{Content} = '';

            # clean the values
            for my $Value (@Values) {
                if ( $Data{Content} ) {
                    $Data{Content} .= '", ';
                }

                $Data{Content} .= qq{"$Value};
            }

            # we need at least a double quote
            if ( !$Data{Content} ) {
                $Data{Content} = '" ';
            }

            # show 'nice' output with variable substitution
            # sample input:
            # ChangeHistory::ChangeLinkAdd", "Ticket", "1
            $Data{Content} = $Self->{LayoutObject}->{LanguageObject}->Get(
                'WorkOrderHistory::' . $Data{HistoryType} . '", ' . $Data{Content}
            );

            # remove not needed place holder
            $Data{Content} =~ s{ % s }{}xmsg;
        }

        $Self->{LayoutObject}->Block(
            Name => 'Row',
            Data => {%Data},
        );

        # show a 'more info' link
        if (
            (
                $HistoryEntry->{ContentNew}
                && length( $HistoryEntry->{ContentNew} ) > $MaxLength
            )
            ||
            (
                $HistoryEntry->{ContentOld}
                && length( $HistoryEntry->{ContentOld} ) > $MaxLength
            )
            )
        {

            # show historyzoom block
            $Self->{LayoutObject}->Block(
                Name => 'ShowHistoryZoom',
                Data => {%Data},
            );
        }

        # don't show a link
        else {
            $Self->{LayoutObject}->Block(
                Name => 'NoHistoryZoom',
            );
        }

        $Self->{LayoutObject}->Block(
            Name => 'ShowWorkOrderZoom',
            Data => {%Data},
        );

    }

    # output header
    my $Output = $Self->{LayoutObject}->Header(
        Type  => 'Small',
        Title => 'WorkOrderHistory',
    );

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
    $Output .= $Self->{LayoutObject}->Footer(
        Type => 'Small',
    );

    return $Output;
}

1;
