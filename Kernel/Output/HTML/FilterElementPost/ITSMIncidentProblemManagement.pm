# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::FilterElementPost::ITSMIncidentProblemManagement;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::Output::HTML::Layout',
    'Kernel::System::Web::Request',
    'Kernel::System::Group',
    'Kernel::System::Ticket',
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # check data
    return if !$Param{Data};
    return if ref $Param{Data} ne 'SCALAR';
    return if !${ $Param{Data} };
    return if !$Param{TemplateFile};

    # get layout object
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # get allowed template names
    my $ValidTemplates
        = $ConfigObject->Get('Frontend::Output::FilterElementPost')->{ITSMIncidentProblemManagement}->{Templates};

    # check template name
    return if !$ValidTemplates->{ $Param{TemplateFile} };

    if ( $Param{TemplateFile} eq 'AgentTicketPhone' ) {

    }
    elsif ( $Param{TemplateFile} eq 'AgentTicketEmail' ) {

    }

    # For all AgentTicketActionCommon based templates
    else {

        # Define impact field search pattern, use without the x modifier and non greedy match (.+?)
        my $ImpactFieldPattern = '<div class="Row Row_DynamicField_ITSMImpact">.+?<div class="Clear"></div>';

        # Find Impact field
        if ( ${ $Param{Data} } =~ m{($ImpactFieldPattern)}ms ) {

            my $ImpactField = $1;

            # remove Impact from the old position
            ${ $Param{Data} } =~ s{$ImpactFieldPattern}{}ms;

            # add before the priority field
            ${ $Param{Data} } =~ s{(<label for="NewPriorityID">Priority:</label>)}{$ImpactField\n$1}ms;
        }

        # get ticket id and number
        my $TicketID = $Kernel::OM->Get('Kernel::System::Web::Request')->GetParam( Param => 'TicketID' );
        my $TicketNumber = $Kernel::OM->Get('Kernel::System::Ticket')->TicketNumberLookup(
            TicketID => $TicketID,
        );

        # add headline for AgentTicketDecision or AgentTicketAddtlITSMField
        if ( $Param{TemplateFile} eq 'AgentTicketDecision' ) {

            # Translate the string
            my $TranslatedString = $LayoutObject->{LanguageObject}->Translate(
                'Change Decision of %s%s%s',
                $ConfigObject->Get('Ticket::Hook'),
                $ConfigObject->Get('Ticket::HookDivider'),
                $TicketNumber,
            );

            ${ $Param{Data} } =~ s{(<h1>)}{$1\n$TranslatedString}ms;
        }
        elsif ( $Param{TemplateFile} eq 'AgentTicketAddtlITSMField' ) {

            # Translate the string
            my $TranslatedString = $LayoutObject->{LanguageObject}->Translate(
                'Change ITSM fields of %s%s%s',
                $ConfigObject->Get('Ticket::Hook'),
                $ConfigObject->Get('Ticket::HookDivider'),
                $TicketNumber,
            );

            ${ $Param{Data} } =~ s{(<h1>)}{$1\n$TranslatedString}ms;
        }

        # add two hidden fields
        ${ $Param{Data} }
            =~ s{(<input type="hidden" name="FormID")}{<input type="hidden" id="ImpactRC" name="ImpactRC" value="0"/>\n$1}ms;
        ${ $Param{Data} }
            =~ s{(<input type="hidden" name="FormID")}{<input type="hidden" id="PriorityRC" name="PriorityRC" value="0"/>\n$1}ms;
    }

    return 1;
}

1;
