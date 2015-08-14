# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentMasterSlavePrepareTicket;

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

sub PreRun {
    my ( $Self, %Param ) = @_;

    # do only use this in phone and email ticket
    return if ( $Self->{Action} !~ /^AgentTicket(Email|Phone)$/ );

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # get master/slave dynamic field
    my $MasterSlaveDynamicField = $ConfigObject->Get('MasterSlave::DynamicField') || '';

    # return if no config option is used
    return if !$MasterSlaveDynamicField;

    # get dynamic field object
    my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');

    # get dynamic field config
    my $DynamicField = $DynamicFieldObject->DynamicFieldGet(
        Name => $MasterSlaveDynamicField,
    );

    # return if no dynamic field config is retrieved
    return if !$DynamicField;

    # get ticket object
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

    # find all current open master slave tickets
    my @TicketIDs = $TicketObject->TicketSearch(
        Result => 'ARRAY',

        # master slave dynamic field
        'DynamicField_' . $MasterSlaveDynamicField => {
            Equals => 'Master',
        },

        StateType  => 'Open',
        Limit      => 60,
        UserID     => $Self->{UserID},
        Permission => 'ro',
    );

    # set dynamic field as shown
    $ConfigObject->{"Ticket::Frontend::$Self->{Action}"}->{DynamicField}->{$MasterSlaveDynamicField} = 1;

    # get layout Object
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # set dynamic field possible values
    $DynamicField->{Config}->{PossibleValues} = {
        Master => $LayoutObject->{LanguageObject}->Translate('New Master Ticket'),
    };
    $DynamicField->{Config}->{DefaultValue} = '';
    $DynamicField->{Config}->{PossibleNone} = 1;

    TICKET:
    for my $TicketID (@TicketIDs) {
        my %CurrentTicket = $TicketObject->TicketGet(
            TicketID      => $TicketID,
            DynamicFields => 1,
        );

        next TICKET if !%CurrentTicket;

        # set dynamic field possible values
        $DynamicField->{Config}->{PossibleValues}->{"SlaveOf:$CurrentTicket{TicketNumber}"}
            = $LayoutObject->{LanguageObject}->Translate('Slave of Ticket#')
            . "$CurrentTicket{TicketNumber}: $CurrentTicket{Title}";
    }

    # set new dynamic field values
    my $SuccessTicketField = $DynamicFieldObject->DynamicFieldUpdate(
        %{$DynamicField},
        Reorder => 0,
        ValidID => 1,
        UserID  => $Self->{UserID},
    );

    return;
}

1;
