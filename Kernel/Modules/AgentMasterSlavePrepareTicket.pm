# --
# Kernel/Modules/AgentMasterSlavePrepareTicket.pm - to prepare master/slave pull downs
# Copyright (C) 2003-2012 OTRS AG, http://otrs.com/
# --
# $Id: AgentMasterSlavePrepareTicket.pm,v 1.3 2012-02-11 00:13:34 cg Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentMasterSlavePrepareTicket;

use strict;
use warnings;

use Kernel::Language;
use Kernel::System::DynamicField;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.3 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check needed Objects
    for (
        qw(ParamObject DBObject LayoutObject LogObject ConfigObject TicketObject UserObject UserID)
        )
    {
        if ( !$Self->{$_} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $_!" );
        }
    }
    $Self->{UserLanguage} = $Self->{LayoutObject}->{UserLanguage}
        || $Self->{ConfigObject}->Get('DefaultLanguage');
    $Self->{LanguageObject}
        = Kernel::Language->new(
        %Param,
        UserLanguage => $Self->{UserLanguage}
        );

    $Self->{DynamicFieldObject} = Kernel::System::DynamicField->new(%Param);

    return $Self;
}

sub PreRun {
    my ( $Self, %Param ) = @_;

    # do only use this in phone and email ticket
    return if ( $Self->{Action} !~ /^AgentTicket(Email|Phone)$/ );

    # get master/slave dynamic field
    my $MasterSlaveDynamicField = $Self->{ConfigObject}->Get('MasterSlaveDynamicField');

    # return if no config option is used
    return if !$MasterSlaveDynamicField;

    # get dynamic field config
    my $DynamicField = $Self->{DynamicFieldObject}->DynamicFieldGet(
        Name => $MasterSlaveDynamicField,
    );

    # return if no dynamic field config is retreived
    return if !$DynamicField;

    # find all current open master slave tickets
    my @TicketIDs = $Self->{TicketObject}->TicketSearch(

        # result (required)
        Result => 'ARRAY',

        # master slave dynamic field
        'DynamicField_' . $MasterSlaveDynamicField => {
            Equals => 'Master',
        },
        StateType => 'Open',

        # result limit
        Limit      => 60,
        UserID     => $Self->{UserID},
        Permission => 'ro',
    );

    # set dynamic field as shown
    $Self->{ConfigObject}->{"Ticket::Frontend::$Self->{Action}"}->{DynamicField}
        ->{$MasterSlaveDynamicField} = 1;

    # get current ticket information
    my %Ticket;
    my $TicketID = $Self->{ParamObject}->GetParam( Param => 'TicketID' );
    if ($TicketID) {
        %Ticket = $Self->{TicketObject}->TicketGet( TicketID => $TicketID );
    }

    # set dynamic field posible values
    $DynamicField->{Config}->{PossibleValues} = {
        Master => $Self->{LanguageObject}->Get('New Master Ticket'),
    };
    $DynamicField->{Config}->{DefaultValue} = '';
    $DynamicField->{Config}->{PossibleNone} = 1;

    for my $TicketID (@TicketIDs) {
        my %CurrentTicket = $Self->{TicketObject}->TicketGet(
            TicketID      => $TicketID,
            DynamicFields => 1,
        );
        next if !%CurrentTicket;
        next
            if $Ticket{ 'DynamicField_' . $MasterSlaveDynamicField } eq
                "SlaveOf:$CurrentTicket{TicketNumber}";
        next if $Ticket{TicketID} eq $CurrentTicket{TicketID};

        # set dynamic field posible values
        $DynamicField->{Config}->{PossibleValues} = {
            "SlaveOf:$CurrentTicket{TicketNumber}" =>
                $Self->{LanguageObject}->Get('Slave of Ticket#')
                . "$CurrentTicket{TicketNumber}: $CurrentTicket{Title}",
        };
    }

    # set new dynamic field values
    my $SuccessTicketField = $Self->{DynamicFieldObject}->DynamicFieldUpdate(
        %{$DynamicField},
        Reorder => 0,
        ValidID => 1,
        UserID  => $Self->{UserID},
    );

    return;
}

1;
