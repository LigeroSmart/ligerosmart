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

    # add two hidden fields for ImpactRC and PriorityRC
    ${ $Param{Data} }
        =~ s{(<input type="hidden" name="FormID")}{<input type="hidden" id="ImpactRC" name="ImpactRC" value="0"/>\n$1}ms;
    ${ $Param{Data} }
        =~ s{(<input type="hidden" name="FormID")}{<input type="hidden" id="PriorityRC" name="PriorityRC" value="0"/>\n$1}ms;

    # Define Priority field name for all AgentTicketActionCommon based templates.
    my $PriorityFieldName = 'NewPriorityID';

    if ( $Param{TemplateFile} eq 'AgentTicketPhone' || $Param{TemplateFile} eq 'AgentTicketEmail' ) {

        # Use another field name (will be used later)
        $PriorityFieldName = 'PriorityID';

        # get FormID
        my $FormID;
        if ( ${ $Param{Data} } =~ m{<input type="hidden" name="FormID" value="([^<>]+)"/>}ms ) {
            $FormID = $1;
        }

        # add "Link Ticket" link
        my $TranslatedString = $LayoutObject->{LanguageObject}->Translate('Link ticket');
        ${ $Param{Data} } =~ s{(<!-- OutputFilterHook_TicketOptionsEnd -->)}{<a href="$LayoutObject->{Baselink}Action=AgentLinkObject;Mode=Temporary;SourceObject=Ticket;SourceKey=$FormID;TargetIdentifier=ITSMConfigItem" id="OptionLinkTicket" class="AsPopup">[ $TranslatedString ]</a>\n$1}ms;
    }

    # For all AgentTicketActionCommon based templates
    else {

        # get ticket id and ticket number
        my $TicketID = $Kernel::OM->Get('Kernel::System::Web::Request')->GetParam( Param => 'TicketID' );
        my $TicketNumber = $Kernel::OM->Get('Kernel::System::Ticket')->TicketNumberLookup(
            TicketID => $TicketID,
        );

        # add headline for AgentTicketDecision
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

        # add headline for AgentTicketAddtlITSMField
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
    }

    # Define impact field search pattern, use without the x modifier and non greedy match (.+?)
    my $ImpactFieldPattern = '<div class="Row Row_DynamicField_ITSMImpact">.+?<div class="Clear"></div>';

    # Find Impact field and move before the priority field
    if ( ${ $Param{Data} } =~ m{($ImpactFieldPattern)}ms ) {

        my $ImpactField = $1;

        # remove Impact from the old position
        ${ $Param{Data} } =~ s{$ImpactFieldPattern}{}ms;

        # add before the priority field
        ${ $Param{Data} } =~ s{(<label for="$PriorityFieldName">.+?</label>)}{$ImpactField\n$1}ms;
    }

    return 1;
}

1;
