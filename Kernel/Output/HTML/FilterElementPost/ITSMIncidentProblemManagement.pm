# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
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
    'Kernel::System::Service',
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

    # get needed objects
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

    # get allowed template names
    my $ValidTemplates
        = $ConfigObject->Get('Frontend::Output::FilterElementPost')->{ITSMIncidentProblemManagement}->{Templates};

    # check template name
    return if !$ValidTemplates->{ $Param{TemplateFile} };

    # handling of AgentTicketZoom related ITSM changes
    if ( $Param{TemplateFile} eq 'AgentTicketZoom' ) {

        # get ticket id
        my $TicketID = $Kernel::OM->Get('Kernel::System::Web::Request')->GetParam( Param => 'TicketID' );

        # Get ticket attributes.
        my %Ticket = $TicketObject->TicketGet(
            TicketID      => $TicketID,
            DynamicFields => 1,
        );

        if ( $Ticket{ServiceID} ) {

            # set incident signal
            my %InciSignals = (
                operational => 'greenled',
                warning     => 'yellowled',
                incident    => 'redled',
            );

            # get service data
            my %Service = $Kernel::OM->Get('Kernel::System::Service')->ServiceGet(
                IncidentState => 1,
                ServiceID     => $Ticket{ServiceID},
                UserID        => 1,
            );

            my $TranslatedServiceIncidentStateLabel
                = $LayoutObject->{LanguageObject}->Translate('Service Incident State');
            my $TranslatedCurInciState = $LayoutObject->{LanguageObject}->Translate( $Service{CurInciState} );

            my $ServiceIncidentStateHTML = <<"END";

            <label>$TranslatedServiceIncidentStateLabel:</label>
            <div class="Value">
                <div class="Flag Small">
                    <span class="$InciSignals{ $Service{CurInciStateType} }" title="$TranslatedCurInciState"></span>
                </div>
                <span>$TranslatedCurInciState</span>
            </div>
END

            # Add link to service and add Service incident state.
            my $TranslatedServiceLabel = $LayoutObject->{LanguageObject}->Translate('Service');
            ${ $Param{Data} }
                =~ s{(<label>$TranslatedServiceLabel:</label>)[^<>]*(<p class="Value" title="[^<>]+">)([^<>]+)</p>}{$1$2<a href="$LayoutObject->{Baselink}Action=AgentITSMServiceZoom;ServiceID=$Ticket{ServiceID};" target="_blank">$3</a></p>\n$ServiceIncidentStateHTML}ms;

            # Add link to sla.
            my $TranslatedSLALabel = $LayoutObject->{LanguageObject}->Translate('Service Level Agreement');
            ${ $Param{Data} }
                =~ s{(<label>$TranslatedSLALabel:</label>)[^<>]*(<p class="Value" title="[^<>]+">)([^<>]+)</p>}{$1$2<a href="$LayoutObject->{Baselink}Action=AgentITSMSLAZoom;SLAID=$Ticket{SLAID};" target="_blank">$3</a></p>}ms;
        }

        # Move Criticality Impact Priority and other ITSM Dynamic Fields before the CustomerID field
        for my $FieldName (
            'Criticality',
            'Impact',
            'Priority',
            'Review Required',
            'Decision Result',
            'Decision Date',
            'Repair Start Time',
            'Recovery Start Time',
            'Due Date',
            )
        {

            my $TranslatedFieldLabel = $LayoutObject->{LanguageObject}->Translate($FieldName);
            my $FieldPattern         = '<label>' . $TranslatedFieldLabel . ':</label>.+?<div class="Clear"></div>';
            if ( ${ $Param{Data} } =~ m{($FieldPattern)}ms ) {

                my $Field = $1;

                # remove field from the old position
                ${ $Param{Data} } =~ s{$FieldPattern}{}ms;

                my $TranslatedCustomerIDLabel = $LayoutObject->{LanguageObject}->Translate('Customer ID');

                # add before the Customer ID field
                ${ $Param{Data} } =~ s{(<label>$TranslatedCustomerIDLabel:</label>)}{$Field\n$1}ms;
            }
        }

        return 1;
    }

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
        ${ $Param{Data} }
            =~ s{(<!-- OutputFilterHook_TicketOptionsEnd -->)}{<a href="$LayoutObject->{Baselink}Action=AgentLinkObject;Mode=Temporary;SourceObject=Ticket;SourceKey=$FormID;TargetIdentifier=ITSMConfigItem" id="OptionLinkTicket" class="AsPopup">[ $TranslatedString ]</a>\n$1}ms;
    }

    # For all AgentTicketActionCommon based templates
    else {

        # get Ticket Number
        my $TicketNumber;
        if ( ${ $Param{Data} } =~ m{<input type="hidden" name="TicketID" value="([^<>]+)"/>}ms ) {
            my $TicketID = $1;
            $TicketNumber = $TicketObject->TicketNumberLookup(
                TicketID => $TicketID,
            );
        }

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

    # Define criticality field search pattern, use without the x modifier and non greedy match (.+?)
    my $CriticalityFieldPattern
        = '<div class="Row Row_DynamicField_ITSMCriticality">.+?<div class="Clear"></div>\s*</div>';

    # Find criticality field and move before the priority field
    if ( ${ $Param{Data} } =~ m{($CriticalityFieldPattern)}ms ) {

        my $CriticalityField = $1;

        # Only if priority is visible on the screen
        if ( ${ $Param{Data} } =~ m{<label for="$PriorityFieldName">.+?</label>}ms ) {

            # remove criticality from the old position
            ${ $Param{Data} } =~ s{$CriticalityFieldPattern}{}ms;

            # add before the priority field
            ${ $Param{Data} } =~ s{(<label for="$PriorityFieldName">.+?</label>)}{$CriticalityField\n$1}ms;
        }
    }

    # Define impact field search pattern, use without the x modifier and non greedy match (.+?)
    my $ImpactFieldPattern = '<div class="Row Row_DynamicField_ITSMImpact">.+?<div class="Clear"></div>\s*</div>';

    # Find Impact field and move before the priority field
    if ( ${ $Param{Data} } =~ m{($ImpactFieldPattern)}ms ) {

        my $ImpactField = $1;

        # Only if priority is visible on the screen
        if ( ${ $Param{Data} } =~ m{<label for="$PriorityFieldName">.+?</label>}ms ) {

            # remove impact from the old position
            ${ $Param{Data} } =~ s{$ImpactFieldPattern}{}ms;

            # add before the priority field
            ${ $Param{Data} } =~ s{(<label for="$PriorityFieldName">.+?</label>)}{$ImpactField\n$1}ms;
        }
    }

    return 1;
}

1;
