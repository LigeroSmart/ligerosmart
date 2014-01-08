# --
# Kernel/Modules/AgentITSMChangeHistory.pm - the OTRS ITSM ChangeManagement change history module
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
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
use Kernel::System::ITSMChange::ITSMCondition;
use Kernel::System::ITSMChange::History;
use Kernel::System::HTMLUtils;
use Kernel::System::Valid;

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

    # create additional objects
    $Self->{ChangeObject}    = Kernel::System::ITSMChange->new(%Param);
    $Self->{WorkOrderObject} = Kernel::System::ITSMChange::ITSMWorkOrder->new(%Param);
    $Self->{ConditionObject} = Kernel::System::ITSMChange::ITSMCondition->new(%Param);
    $Self->{HistoryObject}   = Kernel::System::ITSMChange::History->new(%Param);
    $Self->{HTMLUtilsObject} = Kernel::System::HTMLUtils->new(%Param);
    $Self->{ValidObject}     = Kernel::System::Valid->new(%Param);

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
            Message => "Can't show history, as no ChangeID is given!",
            Comment => 'Please contact the administrator.',
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
            Message => "Change '$ChangeID' not found in the data base!",
            Comment => 'Please contact the administrator.',
        );
    }

    # build a lookup hash with all workorder IDs of this change
    my %WorkOrderIDLookup = map { $_ => 1 } @{ $Change->{WorkOrderIDs} };

    # get history entries
    my $HistoryEntriesRef = $Self->{HistoryObject}->ChangeHistoryGet(
        ChangeID => $ChangeID,
        UserID   => $Self->{UserID},
    ) || [];

    # get order direction
    my @HistoryLines = @{$HistoryEntriesRef};
    if ( $Self->{ConfigObject}->Get('ITSMChange::Frontend::HistoryOrder') eq 'reverse' ) {
        @HistoryLines = reverse @{$HistoryEntriesRef};
    }

    # make some lookups in advance to improve performance
    my $Cache = {};

    # get the object list
    $Cache->{ObjectList} = $Self->{ConditionObject}->ObjectList(
        UserID => $Self->{UserID},
    );

    # get the attribute list
    $Cache->{AttributeList} = $Self->{ConditionObject}->AttributeList(
        UserID => $Self->{UserID},
    );

    # get the operator list
    $Cache->{OperatorList} = $Self->{ConditionObject}->OperatorList(
        UserID => $Self->{UserID},
    );

    # max length of strings
    my $MaxLength = 30;

    # create table
    my $Counter = 1;
    HISTORYENTRY:
    for my $HistoryEntry (@HistoryLines) {
        $Counter++;

        # set fieldname to empty string if there is no fieldname
        $HistoryEntry->{Fieldname} ||= '';

        # do not show internal entries from workorder number recalculation
        next HISTORYENTRY if $HistoryEntry->{Fieldname} eq 'NoNumberCalc';

        # data for a single row, will be passed to the dtl
        my %Data = %{$HistoryEntry};

        # determine what should be shown
        my $HistoryType = $HistoryEntry->{HistoryType};
        if (
            $HistoryType =~ m{
                \A
                (?: (?: Change | ChangeCAB | WorkOrder ) Update )
                | (?: (?: Condition | Expression | Action ) (?: Add | Update | Delete | DeleteAll | Execute ) )
                \z
            }xms
            )
        {

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
                                Category | Impact | Priority
                                | ChangeState
                                | WorkOrderState | WorkOrderType
                                | WorkOrderAgent | ChangeBuilder | ChangeManager
                                | Valid
                                | Object | Attribute | Operator
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
                            elsif ( $Type eq 'ChangeState' ) {
                                $Value = $Self->{ChangeObject}->ChangeStateLookup(
                                    ChangeStateID => $HistoryEntry->{$ContentNewOrOld},
                                );
                            }
                            elsif (
                                $Type eq 'WorkOrderAgent'
                                || $Type eq 'ChangeBuilder'
                                || $Type eq 'ChangeManager'
                                )
                            {
                                $Value = $Self->{UserObject}->UserLookup(
                                    UserID => $HistoryEntry->{$ContentNewOrOld},
                                );

                                # the login names are not to be translated
                                $TranslationNeeded = 0;
                            }
                            elsif (
                                $Type eq 'Category'
                                || $Type eq 'Impact'
                                || $Type eq 'Priority'
                                )
                            {
                                $Value = $Self->{ChangeObject}->ChangeCIPLookup(
                                    ID   => $HistoryEntry->{$ContentNewOrOld},
                                    Type => $Type,
                                );
                            }
                            elsif ( $Type eq 'Valid' ) {

                                # get the UpdateID (ConditionID or ExpressionID or ActionID)
                                # and the AttributeID
                                if ( $HistoryEntry->{$ContentNewOrOld} =~ m{ %% }xms ) {
                                    ( $HistoryEntry->{UpdateID}, $HistoryEntry->{$ContentNewOrOld} )
                                        = split m/%%/, $HistoryEntry->{$ContentNewOrOld};
                                }

                                $Value = $Self->{ValidObject}->ValidLookup(
                                    ValidID => $HistoryEntry->{$ContentNewOrOld},
                                );
                            }
                            elsif ( $Type eq 'Object' ) {

                                # get the UpdateID (ConditionID or ExpressionID or ActionID)
                                # and the AttributeID
                                if ( $HistoryEntry->{$ContentNewOrOld} =~ m{ %% }xms ) {
                                    ( $HistoryEntry->{UpdateID}, $HistoryEntry->{$ContentNewOrOld} )
                                        = split m/%%/, $HistoryEntry->{$ContentNewOrOld};
                                }

                                # lookup the object name
                                $Value
                                    = $Cache->{ObjectList}->{ $HistoryEntry->{$ContentNewOrOld} };

                            }
                            elsif ( $Type eq 'Attribute' ) {

                                # get the UpdateID (ConditionID or ExpressionID or ActionID)
                                # and the AttributeID
                                if ( $HistoryEntry->{$ContentNewOrOld} =~ m{ %% }xms ) {
                                    ( $HistoryEntry->{UpdateID}, $HistoryEntry->{$ContentNewOrOld} )
                                        = split m/%%/, $HistoryEntry->{$ContentNewOrOld};
                                }

                                # lookup the attribute name
                                $Value = $Cache->{AttributeList}
                                    ->{ $HistoryEntry->{$ContentNewOrOld} };
                            }
                            elsif ( $Type eq 'Operator' ) {

                                # get the UpdateID (ConditionID or ExpressionID or ActionID)
                                # and the AttributeID
                                if ( $HistoryEntry->{$ContentNewOrOld} =~ m{ %% }xms ) {
                                    ( $HistoryEntry->{UpdateID}, $HistoryEntry->{$ContentNewOrOld} )
                                        = split m/%%/, $HistoryEntry->{$ContentNewOrOld};
                                }

                                # lookup the operator name
                                $Value
                                    = $Cache->{OperatorList}->{ $HistoryEntry->{$ContentNewOrOld} };
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
                    elsif ( $HistoryEntry->{Fieldname} eq 'CABCustomers' ) {

                      # ContentNew and ContentOld contain a '%%' seperated list of customer user ids
                      # reformat it as a comma separated list
                        $HistoryEntry->{$ContentNewOrOld} =~ s{ % % }{,}xmsg;
                    }
                    elsif ( $HistoryEntry->{Fieldname} eq 'CABAgents' ) {

                        # ContentNew and ContentOld contain a '%%' seperated list of user ids
                        # look up the login names from the user ids and
                        # format it as a comma separated list
                        my @UserIDs = split m/%%/, $HistoryEntry->{$ContentNewOrOld};
                        my @UserLogins
                            = map { $Self->{UserObject}->UserLookup( UserID => $_ ) } @UserIDs;
                        $HistoryEntry->{$ContentNewOrOld} = join ',', @UserLogins;
                    }
                    elsif (
                        $HistoryEntry->{Fieldname} eq 'ExpressionConjunction'
                        || $HistoryEntry->{Fieldname} eq 'Name'
                        || $HistoryEntry->{Fieldname} eq 'Comment'
                        || $HistoryEntry->{Fieldname} eq 'Selector'
                        || $HistoryEntry->{Fieldname} eq 'ActionValue'
                        || $HistoryEntry->{Fieldname} eq 'CompareValue'
                        )
                    {

                        # get the UpdateID (ConditionID or ExpressionID or ActionID)
                        # and the AttributeID
                        if ( $HistoryEntry->{$ContentNewOrOld} =~ m{ %% }xms ) {
                            ( $HistoryEntry->{UpdateID}, $HistoryEntry->{$ContentNewOrOld} )
                                = split m/%%/, $HistoryEntry->{$ContentNewOrOld};
                        }
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

            # build description array
            my @Description = ( $DisplayedFieldname || '' );

            # add the ID of the Condition, Expression or Action that was updated
            if (
                $HistoryType eq 'ConditionUpdate'
                || $HistoryType eq 'ExpressionUpdate'
                || $HistoryType eq 'ActionUpdate'
                )
            {
                if ( $HistoryEntry->{UpdateID} ) {
                    push @Description, $HistoryEntry->{UpdateID};
                }
            }

            # set description
            $Data{Content} = join '%%', @Description, $ContentNew, $ContentOld;
        }
        else {
            $Data{Content} = $HistoryEntry->{ContentNew};
        }

        # replace text
        if ( $Data{Content} ) {

            # remove leading %%
            $Data{Content} =~ s{ \A %% }{}xmsg;

            # split the content by %%
            my @Values = split m/%%/, $Data{Content};

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

            # for what item type is this history entry
            my $HistoryItemType = 'Change';
            if ( $HistoryType =~ m{ \A WorkOrder }xms ) {
                $HistoryItemType = 'WorkOrder';
            }

            # for workorder entries that still exists, show workorderid
            my $HistoryEntryType = $Data{HistoryType};
            if ( $HistoryEntry->{WorkOrderID} ) {
                $HistoryEntryType .= 'WithWorkOrderID';
                $Data{Content} = '"' . $HistoryEntry->{WorkOrderID} . '", ' . $Data{Content};
            }

            # handle condition add with id
            if ( $HistoryEntryType eq 'ConditionAdd' && !$HistoryEntry->{Fieldname} ) {
                $HistoryEntryType .= 'ID';
            }

            # handle expression add with id
            if ( $HistoryEntryType eq 'ExpressionAdd' && !$HistoryEntry->{Fieldname} ) {
                $HistoryEntryType .= 'ID';
            }

            # handle action add with id
            if ( $HistoryEntryType eq 'ActionAdd' && !$HistoryEntry->{Fieldname} ) {
                $HistoryEntryType .= 'ID';
            }

            # handle action execute
            if ( $HistoryEntryType eq 'ActionExecute' ) {

                # get content elements
                my @ActionExecuteData = split m/,/, $Data{Content};

                # extract result
                my $ActionExecuteResult
                    = ( $ActionExecuteData[1] =~ m{ ( unsuccessfully | successfully ) }xms )[0];

                # translate result
                $ActionExecuteData[1] = ' "' . $Self->{LayoutObject}->{LanguageObject}->Get(
                    $HistoryEntryType . '::' . $ActionExecuteResult,
                ) . '"';

                # create content for translation
                $Data{Content} = join ',', @ActionExecuteData;
            }

            # useful for debugging, can be added to dtl to see the untranslated output
            $Data{ContentUntranslated} = $Data{Content};

            # show 'nice' output with variable substitution
            # sample input:
            # ChangeHistory::ChangeLinkAdd", "Ticket", "1
            # YES, this looks strange, but this is the correct way!!!
            $Data{Content} = $Self->{LayoutObject}->{LanguageObject}->Get(
                $HistoryItemType . 'History::' . $HistoryEntryType . '", ' . $Data{Content},
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
            || (
                $HistoryEntry->{ContentOld}
                && length( $HistoryEntry->{ContentOld} ) > $MaxLength
            )
            )
        {

            # is it a ChangeHistoryZoom or a WorkOrderHistoryZoom?
            my $ZoomType = 'Change';

            if ( $HistoryType =~ m{ \A WorkOrder }xms && $HistoryEntry->{WorkOrderID} ) {
                $ZoomType = 'WorkOrder';
            }

            # show historyzoom block
            $Self->{LayoutObject}->Block(
                Name => 'ShowHistoryZoom',
                Data => {
                    %Data,
                    ZoomType => $ZoomType,
                },
            );
        }

        # don't show a link
        else {
            $Self->{LayoutObject}->Block(
                Name => 'NoHistoryZoom',
            );
        }

        # show link to workorder for WorkOrderAdd event - if the workorder still exists
        if (
            $HistoryEntry->{HistoryType} =~ m{ \A WorkOrder }xms
            && $HistoryEntry->{WorkOrderID}
            && $WorkOrderIDLookup{ $HistoryEntry->{WorkOrderID} }
            )
        {

            # show link
            $Self->{LayoutObject}->Block(
                Name => 'ShowWorkOrderZoom',
                Data => {%Data},
            );
        }

        # don't show any link
        else {
            $Self->{LayoutObject}->Block(
                Name => 'NoWorkOrderZoom',
            );
        }
    }

    # output header
    my $Output = $Self->{LayoutObject}->Header(
        Type  => 'Small',
        Title => 'ChangeHistory',
    );

    # start template output
    $Output .= $Self->{LayoutObject}->Output(
        TemplateFile => 'AgentITSMChangeHistory',
        Data         => {
            %Param,
            %{$Change},
        },
    );

    # add footer
    $Output .= $Self->{LayoutObject}->Footer(
        Type => 'Small',
    );

    return $Output;
}

1;
