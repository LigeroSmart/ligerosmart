# --
# Kernel/Modules/AgentMasterSlavePrepareTicket.pm - to prepare master/slave pull downs
# Copyright (C) 2003-2011 OTRS AG, http://otrs.com/
# --
# $Id: AgentMasterSlavePrepareTicket.pm,v 1.1 2011-10-10 09:30:05 te Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentMasterSlavePrepareTicket;

use strict;
use warnings;

use Kernel::Language;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.1 $) [1];

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
        = Kernel::Language->new( %Param, UserLanguage => $Self->{UserLanguage} );

    return $Self;
}

sub PreRun {
    my ( $Self, %Param ) = @_;

    # do only use this in phone and email ticket
    return if ( $Self->{Action} !~ /^AgentTicket(Email|Phone)$/ );

    # get master/slave ticket free field
    my $Count = $Self->{ConfigObject}->Get('MasterTicketFreeTextField');

    # return if no config option is used
    return if !$Count;

    # define TicketFreeText field
    my $TicketFreeText = 'TicketFreeText' . $Count;

    # find all current open master slave tickets
    my @TicketIDs = $Self->{TicketObject}->TicketSearch(

        # result (required)
        Result          => 'ARRAY',
        $TicketFreeText => 'Master',
        StateType       => 'Open',

        # result limit
        Limit      => 60,
        UserID     => $Self->{UserID},
        Permission => 'ro',
    );

    # set free field as shown
    $Self->{ConfigObject}->{"Ticket::Frontend::$Self->{Action}"}->{TicketFreeText}->{$Count} = 1;

    # set free fields
    $Self->{ConfigObject}->{$TicketFreeText} = undef;
    $Self->{ConfigObject}->{$TicketFreeText}->{''} = '-';
    $Self->{ConfigObject}->{$TicketFreeText}->{Master}
        = $Self->{LanguageObject}->Get('New Master Ticket');
    for my $TicketID (@TicketIDs) {
        my %Ticket = $Self->{TicketObject}->TicketGet( TicketID => $TicketID );
        next if !%Ticket;
        $Self->{ConfigObject}->{$TicketFreeText}->{"SlaveOf:$Ticket{TicketNumber}"}
            = $Self->{LanguageObject}->Get('Slave of Ticket#')
            . "$Ticket{TicketNumber}: $Ticket{Title}";
    }

    return;
}

1;
