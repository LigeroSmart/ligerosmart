# --
# Copyright (C) 2001-2019 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::DynamicField::Driver::MasterSlave;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);

use parent qw(Kernel::System::DynamicField::Driver::BaseSelect);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::Language',
    'Kernel::Output::HTML::Layout',
    'Kernel::System::DynamicFieldValue',
    'Kernel::System::LinkObject',
    'Kernel::System::Log',
    'Kernel::System::Main',
    'Kernel::System::Ticket',
);

=head1 NAME

Kernel::System::DynamicField::Driver::MasterSlave

=head1 SYNOPSIS

DynamicFields MasterSlave Driver delegate

=head1 PUBLIC INTERFACE

This module implements the public interface of L<Kernel::System::DynamicField::Backend>.
Please look there for a detailed reference of the functions.

=head2 new()

usually, you want to create an instance of this
by using Kernel::System::DynamicField::Backend->new();

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # set field behaviors
    $Self->{Behaviors} = {
        'IsACLReducible'               => 0,
        'IsNotificationEventCondition' => 1,
        'IsSortable'                   => 1,
        'IsFiltrable'                  => 1,
        'IsStatsCondition'             => 1,
        'IsCustomerInterfaceCapable'   => 0,
    };

    # get the Dynamic Field Backend custom extensions
    my $DynamicFieldDriverExtensions
        = $Kernel::OM->Get('Kernel::Config')->Get('DynamicFields::Extension::Driver::MasterSlave');

    EXTENSION:
    for my $ExtensionKey ( sort keys %{$DynamicFieldDriverExtensions} ) {

        # skip invalid extensions
        next EXTENSION if !IsHashRefWithData( $DynamicFieldDriverExtensions->{$ExtensionKey} );

        # create a extension config shortcut
        my $Extension = $DynamicFieldDriverExtensions->{$ExtensionKey};

        # check if extension has a new module
        if ( $Extension->{Module} ) {

            # check if module can be loaded
            if (
                !$Kernel::OM->Get('Kernel::System::Main')->RequireBaseClass( $Extension->{Module} )
                )
            {
                die "Can't load dynamic fields backend module"
                    . " $Extension->{Module}! $@";
            }
        }

        # check if extension contains more behaviors
        if ( IsHashRefWithData( $Extension->{Behaviors} ) ) {

            %{ $Self->{Behaviors} } = (
                %{ $Self->{Behaviors} },
                %{ $Extension->{Behaviors} }
            );
        }
    }

    return $Self;
}

sub ValueSet {
    my ( $Self, %Param ) = @_;

    my $Success = $Self->_HandleLinks(
        FieldName  => $Param{DynamicFieldConfig}->{Name},
        FieldValue => $Param{Value},
        TicketID   => $Param{ObjectID},
        UserID     => $Param{UserID},
    );

    if ( !$Success ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "There was an error handling the links for master/slave, value could not be set",
        );

        return;
    }

    my $Value = $Param{Value} !~ /^(?:UnsetMaster|UnsetSlave)$/ ? $Param{Value} : '';

    $Success = $Kernel::OM->Get('Kernel::System::DynamicFieldValue')->ValueSet(
        FieldID  => $Param{DynamicFieldConfig}->{ID},
        ObjectID => $Param{ObjectID},
        Value    => [
            {
                ValueText => $Value,
            },
        ],
        UserID => $Param{UserID},
    );

    return $Success;
}

sub EditFieldValueValidate {
    my ( $Self, %Param ) = @_;

    # get the field value from the http request
    my $Value = $Self->EditFieldValueGet(
        DynamicFieldConfig => $Param{DynamicFieldConfig},
        ParamObject        => $Param{ParamObject},

        # not necessary for this Driver but place it for consistency reasons
        ReturnValueStructure => 1,
    );

    my $ServerError;
    my $ErrorMessage;

    # perform necessary validations
    if ( $Param{Mandatory} && !$Value ) {
        return {
            ServerError => 1,
        };
    }
    else {

        my $PossibleValues;

        # use PossibleValuesFilter if sent
        if ( defined $Param{PossibleValuesFilter} ) {
            $PossibleValues = $Param{PossibleValuesFilter};
        }
        else {

            # get possible values list
            $PossibleValues = $Self->PossibleValuesGet(
                %Param,
            );
        }

        # validate if value is in possible values list (but let pass empty values)
        if ( $Value && !$PossibleValues->{$Value} ) {
            $ServerError  = 1;
            $ErrorMessage = 'The field content is invalid';
        }
    }

    # create resulting structure
    my $Result = {
        ServerError  => $ServerError,
        ErrorMessage => $ErrorMessage,
    };

    return $Result;
}

sub DisplayValueRender {
    my ( $Self, %Param ) = @_;

    # set HTMLOutput as default if not specified
    if ( !defined $Param{HTMLOutput} ) {
        $Param{HTMLOutput} = 1;
    }

    # get raw Value strings from field value
    my $Value = defined $Param{Value} ? $Param{Value} : '';

    # get real value
    if ( $Param{DynamicFieldConfig}->{Config}->{PossibleValues}->{$Value} ) {

        # get readable value
        $Value = $Param{DynamicFieldConfig}->{Config}->{PossibleValues}->{$Value};
    }

    if ( $Value eq 'Master' ) {
        $Value = $Param{LayoutObject}->{LanguageObject}->Translate('Master');
    }
    elsif ( $Value =~ m{SlaveOf:(\d+)}msx ) {

        my $TicketNumber = $1;
        if ($TicketNumber) {
            my $ConfigObject      = $Kernel::OM->Get('Kernel::Config');
            my $TicketHook        = $ConfigObject->Get('Ticket::Hook');
            my $TicketHookDivider = $ConfigObject->Get('Ticket::HookDivider');
            $Value = $Param{LayoutObject}->{LanguageObject}->Translate(
                'Slave of %s%s%s',
                $TicketHook,
                $TicketHookDivider,
                $TicketNumber,
            );
        }
    }

    # set title as value after update and before limit
    my $Title = $Value;

    # HTMLOutput transformations
    if ( $Param{HTMLOutput} ) {
        $Value = $Param{LayoutObject}->Ascii2Html(
            Text => $Value,
            Max  => $Param{ValueMaxChars} || '',
        );

        $Title = $Param{LayoutObject}->Ascii2Html(
            Text => $Title,
            Max  => $Param{TitleMaxChars} || '',
        );
    }
    else {
        if ( $Param{ValueMaxChars} && length($Value) > $Param{ValueMaxChars} ) {
            $Value = substr( $Value, 0, $Param{ValueMaxChars} ) . '...';
        }
        if ( $Param{TitleMaxChars} && length($Title) > $Param{TitleMaxChars} ) {
            $Title = substr( $Title, 0, $Param{TitleMaxChars} ) . '...';
        }
    }

    # set field link from config
    my $Link        = $Param{DynamicFieldConfig}->{Config}->{Link}        || '';
    my $LinkPreview = $Param{DynamicFieldConfig}->{Config}->{LinkPreview} || '';

    my $Data = {
        Value       => $Value,
        Title       => $Title,
        Link        => $Link,
        LinkPreview => $LinkPreview,
    };

    return $Data;
}

sub PossibleValuesGet {
    my ( $Self, %Param ) = @_;

    # to store the possible values
    my %PossibleValues = (
        '' => '-',
    );

    # get needed objects
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # find all current open master slave tickets
    my @TicketIDs = $TicketObject->TicketSearch(
        Result => 'ARRAY',

        # master slave dynamic field
        'DynamicField_' . $Param{DynamicFieldConfig}->{Name} => {
            Equals => 'Master',
        },

        StateType  => 'Open',
        Limit      => 60,
        UserID     => $LayoutObject->{UserID},
        Permission => 'ro',
    );

    # set dynamic field possible values
    $PossibleValues{Master} = $LayoutObject->{LanguageObject}->Translate('New Master Ticket');

    my $ConfigObject      = $Kernel::OM->Get('Kernel::Config');
    my $TicketHook        = $ConfigObject->Get('Ticket::Hook');
    my $TicketHookDivider = $ConfigObject->Get('Ticket::HookDivider');

    TICKET:
    for my $TicketID (@TicketIDs) {
        my %CurrentTicket = $TicketObject->TicketGet(
            TicketID      => $TicketID,
            DynamicFields => 1,
        );

        next TICKET if !%CurrentTicket;

        # set dynamic field possible values
        $PossibleValues{"SlaveOf:$CurrentTicket{TicketNumber}"} = $LayoutObject->{LanguageObject}->Translate(
            'Slave of %s%s%s: %s',
            $TicketHook,
            $TicketHookDivider,
            $CurrentTicket{TicketNumber},
            $CurrentTicket{Title},
        );
    }

    # return the possible values hash as a reference
    return \%PossibleValues;
}

sub _HandleLinks {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(FieldName FieldValue TicketID UserID)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    # get ticket object
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

    my $FieldName = $Param{FieldName};

    my %Ticket = $Param{Ticket}
        ? %{ $Param{Ticket} }
        : $TicketObject->TicketGet(
        TicketID      => $Param{TicketID},
        DynamicFields => 1,
        );

    my $OldValue = $Ticket{ 'DynamicField_' . $FieldName };

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # get master slave config
    my $MasterSlaveKeepParentChildAfterUnset  = $ConfigObject->Get('MasterSlave::KeepParentChildAfterUnset')  || 0;
    my $MasterSlaveFollowUpdatedMaster        = $ConfigObject->Get('MasterSlave::FollowUpdatedMaster')        || 0;
    my $MasterSlaveKeepParentChildAfterUpdate = $ConfigObject->Get('MasterSlave::KeepParentChildAfterUpdate') || 0;

    my $NewValue = $Param{FieldValue};

    # get link object
    my $LinkObject = $Kernel::OM->Get('Kernel::System::LinkObject');

    # set a new master ticket
    # check if it is already a master ticket
    if (
        $NewValue eq 'Master'
        && ( !$OldValue || $OldValue ne $NewValue )
        )
    {

        # check if it was a slave ticket before and if we have to delete
        # the old parent child link (MasterSlaveKeepParentChildAfterUnset)
        if (
            $OldValue
            && $OldValue =~ /^SlaveOf:(.*?)$/
            && !$MasterSlaveKeepParentChildAfterUnset
            )
        {
            my $SourceKey = $TicketObject->TicketIDLookup(
                TicketNumber => $1,
                UserID       => $Param{UserID},
            );

            $LinkObject->LinkDelete(
                Object1 => 'Ticket',
                Key1    => $SourceKey,
                Object2 => 'Ticket',
                Key2    => $Param{TicketID},
                Type    => 'ParentChild',
                UserID  => $Param{UserID},
            );
        }
    }

    # set a new slave ticket
    # check if it's already the slave of the wished master ticket
    elsif (
        $NewValue =~ /^SlaveOf:(.*?)$/
        && ( !$OldValue || $OldValue ne $NewValue )
        )
    {
        my $SourceKey = $TicketObject->TicketIDLookup(
            TicketNumber => $1,
            UserID       => $Param{UserID},
        );

        $LinkObject->LinkAdd(
            SourceObject => 'Ticket',
            SourceKey    => $SourceKey,
            TargetObject => 'Ticket',
            TargetKey    => $Param{TicketID},
            Type         => 'ParentChild',
            State        => 'Valid',
            UserID       => $Param{UserID},
        );

        my %Links = $LinkObject->LinkKeyList(
            Object1   => 'Ticket',
            Key1      => $Param{TicketID},
            Object2   => 'Ticket',
            State     => 'Valid',
            Type      => 'ParentChild',      # (optional)
            Direction => 'Target',           # (optional) default Both (Source|Target|Both)
            UserID    => $Param{UserID},
        );

        my @SlaveTicketIDs;

        LINKEDTICKETID:
        for my $LinkedTicketID ( sort keys %Links ) {
            next LINKEDTICKETID if !$Links{$LinkedTicketID};

            # just take ticket with slave attributes for action
            my %LinkedTicket = $TicketObject->TicketGet(
                TicketID      => $LinkedTicketID,
                DynamicFields => 1,
            );

            my $LinkedTicketValue = $Ticket{ 'DynamicField_' . $FieldName };

            next LINKEDTICKETID if !$LinkedTicketValue;
            next LINKEDTICKETID if $LinkedTicketValue !~ /^SlaveOf:(.*?)$/;

            # remember linked ticket id
            push @SlaveTicketIDs, $LinkedTicketID;
        }

        if ( $OldValue && $OldValue eq 'Master' ) {

            if ( $MasterSlaveFollowUpdatedMaster && @SlaveTicketIDs ) {
                for my $LinkedTicketID (@SlaveTicketIDs) {
                    $LinkObject->LinkAdd(
                        SourceObject => 'Ticket',
                        SourceKey    => $SourceKey,
                        TargetObject => 'Ticket',
                        TargetKey    => $LinkedTicketID,
                        Type         => 'ParentChild',
                        State        => 'Valid',
                        UserID       => $Param{UserID},
                    );
                }
            }

            if ( !$MasterSlaveKeepParentChildAfterUnset ) {
                for my $LinkedTicketID (@SlaveTicketIDs) {
                    $LinkObject->LinkDelete(
                        Object1 => 'Ticket',
                        Key1    => $Param{TicketID},
                        Object2 => 'Ticket',
                        Key2    => $LinkedTicketID,
                        Type    => 'ParentChild',
                        UserID  => $Param{UserID},
                    );
                }
            }
        }
        elsif (
            $OldValue
            && $OldValue =~ /^SlaveOf:(.*?)$/
            && !$MasterSlaveKeepParentChildAfterUpdate
            )
        {
            my $SourceKey = $TicketObject->TicketIDLookup(
                TicketNumber => $1,
                UserID       => $Param{UserID},
            );

            $LinkObject->LinkDelete(
                Object1 => 'Ticket',
                Key1    => $SourceKey,
                Object2 => 'Ticket',
                Key2    => $Param{TicketID},
                Type    => 'ParentChild',
                UserID  => $Param{UserID},
            );
        }
    }
    elsif ( $NewValue =~ /^(?:UnsetMaster|UnsetSlave)$/ && $OldValue ) {

        if ( $NewValue eq 'UnsetMaster' && !$MasterSlaveKeepParentChildAfterUnset ) {
            my %Links = $LinkObject->LinkKeyList(
                Object1   => 'Ticket',
                Key1      => $Param{TicketID},
                Object2   => 'Ticket',
                State     => 'Valid',
                Type      => 'ParentChild',      # (optional)
                Direction => 'Target',           # (optional) default Both (Source|Target|Both)
                UserID    => $Param{UserID},
            );

            my @SlaveTicketIDs;

            LINKEDTICKETID:
            for my $LinkedTicketID ( sort keys %Links ) {
                next LINKEDTICKETID if !$Links{$LinkedTicketID};

                # just take ticket with slave attributes for action
                my %LinkedTicket = $TicketObject->TicketGet(
                    TicketID      => $LinkedTicketID,
                    DynamicFields => 1,
                );

                my $LinkedTicketValue = $Ticket{ 'DynamicField_' . $FieldName };
                next LINKEDTICKETID if !$LinkedTicketValue;
                next LINKEDTICKETID if $LinkedTicketValue !~ /^SlaveOf:(.*?)$/;

                # remember ticket id
                push @SlaveTicketIDs, $LinkedTicketID;
            }

            for my $LinkedTicketID (@SlaveTicketIDs) {
                $LinkObject->LinkDelete(
                    Object1 => 'Ticket',
                    Key1    => $Param{TicketID},
                    Object2 => 'Ticket',
                    Key2    => $LinkedTicketID,
                    Type    => 'ParentChild',
                    UserID  => $Param{UserID},
                );
            }
        }
        elsif (
            $NewValue eq 'UnsetSlave'
            && !$MasterSlaveKeepParentChildAfterUnset
            && $OldValue =~ /^SlaveOf:(.*?)$/
            )
        {
            my $SourceKey = $TicketObject->TicketIDLookup(
                TicketNumber => $1,
                UserID       => $Param{UserID},
            );

            $LinkObject->LinkDelete(
                Object1 => 'Ticket',
                Key1    => $SourceKey,
                Object2 => 'Ticket',
                Key2    => $Param{TicketID},
                Type    => 'ParentChild',
                UserID  => $Param{UserID},
            );
        }
    }

    return 1;
}

sub SearchFieldRender {
    my ( $Self, %Param ) = @_;

    # take config from field config
    my $FieldConfig = $Param{DynamicFieldConfig}->{Config};
    my $FieldName   = 'Search_DynamicField_' . $Param{DynamicFieldConfig}->{Name};
    my $FieldLabel  = $Param{DynamicFieldConfig}->{Label};

    my $Value;

    my @DefaultValue;

    if ( defined $Param{DefaultValue} ) {
        @DefaultValue = split /;/, $Param{DefaultValue};
    }

    # set the field value
    if (@DefaultValue) {
        $Value = \@DefaultValue;
    }

    # get the field value, this function is always called after the profile is loaded
    my $FieldValues = $Self->SearchFieldValueGet(
        %Param,
    );

    if ( defined $FieldValues ) {
        $Value = $FieldValues;
    }

    # check and set class if necessary
    my $FieldClass = 'DynamicFieldMultiSelect Modernize';

    # set TreeView class
    if ( $FieldConfig->{TreeView} ) {
        $FieldClass .= ' DynamicFieldWithTreeView';
    }

    my $LanguageObject = $Kernel::OM->Get('Kernel::Language');

    # set PossibleValues (master should be always an option)
    my $SelectionData = {
        Master => $LanguageObject->Translate('Master Ticket'),
    };

    # get historical values from database
    my $HistoricalValues = $Self->HistoricalValuesGet(%Param);

    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

    if ( IsHashRefWithData($HistoricalValues) ) {

        my $ConfigObject      = $Kernel::OM->Get('Kernel::Config');
        my $TicketHook        = $ConfigObject->Get('Ticket::Hook');
        my $TicketHookDivider = $ConfigObject->Get('Ticket::HookDivider');

        # Recreate the display value from the already set tickets.
        VALUE:
        for my $ValueKey ( sort keys %{$HistoricalValues} ) {

            if ( $ValueKey =~ m{SlaveOf:(.*)}gmx ) {
                my $TicketNumber = $1;

                my $TicketID = $TicketObject->TicketIDLookup(
                    TicketNumber => $TicketNumber,
                    UserID       => 1,
                );

                my %Ticket;
                if ($TicketID) {
                    %Ticket = $TicketObject->TicketGet(
                        TicketID => $TicketID
                    );
                }

                next VALUE if !%Ticket;

                $SelectionData->{$ValueKey} = $LanguageObject->Translate(
                    'Slave of %s%s%s: %s',
                    $TicketHook,
                    $TicketHookDivider,
                    $Ticket{TicketNumber},
                    $Ticket{Title},
                );
            }
        }
    }

    # use PossibleValuesFilter if defined
    $SelectionData = $Param{PossibleValuesFilter} // $SelectionData;

    my $HTMLString = $Param{LayoutObject}->BuildSelection(
        Data         => $SelectionData,
        Name         => $FieldName,
        SelectedID   => $Value,
        Translation  => 0,
        PossibleNone => 0,
        Class        => $FieldClass,
        Multiple     => 1,
        HTMLQuote    => 1,
    );

    # call EditLabelRender on the common Driver
    my $LabelString = $Self->EditLabelRender(
        %Param,
        FieldName => $FieldName,
    );

    my $Data = {
        Field => $HTMLString,
        Label => $LabelString,
    };

    return $Data;
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<https://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
