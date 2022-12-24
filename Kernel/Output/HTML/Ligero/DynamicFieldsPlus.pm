package Kernel::Output::HTML::Ligero::DynamicFieldsPlus;

use strict;
use warnings;
use List::Util qw(first);
use HTTP::Status qw(:constants :is status_message);
sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;
	my %Data = ();
	my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');
	my $ConfigObject = $Kernel::OM->Get("Kernel::Config");
	my $QueueObject = $Kernel::OM->Get("Kernel::System::Queue");	
	my $LayoutObject = $Kernel::OM->Get("Kernel::Output::HTML::Layout");
    my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

    my $ObjectType  = $Kernel::OM->Get('Kernel::System::Web::Request')->GetParam( Param => 'ObjectType' ) || '';

    if($ObjectType ne 'Article' && $ObjectType ne 'Ticket'){
        return;
    }

    my %AreasList = (
            "Ticket::Frontend::AgentTicketZoom###DynamicField" =>
                $LayoutObject->{LanguageObject}->Translate(
                    'Agent - Ticket Zoom'
                    ),
            "Ticket::Frontend::AgentTicketZoom###ProcessWidgetDynamicField" =>
                $LayoutObject->{LanguageObject}->Translate(
                    'Agent - Process Widget'
                    ),
            "Ticket::Frontend::AgentTicketLigeroSmartClassification###DynamicField" =>
                $LayoutObject->{LanguageObject}->Translate(
                    'Agent - Smart Classification'
                    ),
            "Ticket::Frontend::AgentTicketPhone###DynamicField" => 
                $LayoutObject->{LanguageObject}->Translate(
                    'Agent - New Phone Ticket'
                    ),
            "Ticket::Frontend::AgentTicketEmail###DynamicField" =>
                $LayoutObject->{LanguageObject}->Translate(
                    'Agent - New Email Ticket'
                    ),
            "Ticket::Frontend::AgentTicketCompose###DynamicField" =>
                $LayoutObject->{LanguageObject}->Translate(
                    'Agent - New Reply'
                    ),
            "Ticket::Frontend::AgentTicketSearch###DynamicField" =>
                $LayoutObject->{LanguageObject}->Translate(
                    'Agent - Search'
                    ),
            "Ticket::Frontend::OverviewSmall###DynamicField" =>
                $LayoutObject->{LanguageObject}->Translate(
                    'Agent - List of Tickets'
                    ),
            "Ticket::Frontend::AgentTicketFreeText###DynamicField" =>
                $LayoutObject->{LanguageObject}->Translate(
                    'Agent - Free Text'
                    ),
            "Ticket::Frontend::AgentTicketNote###DynamicField" =>
                $LayoutObject->{LanguageObject}->Translate(
                    'Agent - New Note'
                    ),
            "Ticket::Frontend::AgentTicketClose###DynamicField" =>
                $LayoutObject->{LanguageObject}->Translate(
                    'Agent - Close'
                    ),
            "Ticket::Frontend::CustomerTicketMessage###DynamicField" => 
            $LayoutObject->{LanguageObject}->Translate(
                    'Customer - New Ticket'
                    ),
            "Ticket::Frontend::CustomerTicketZoom###DynamicField" => 
                $LayoutObject->{LanguageObject}->Translate(
                    'Customer - Ticket Zoom'
                    ),
            "Ticket::Frontend::CustomerTicketOverview###DynamicField" => 
                $LayoutObject->{LanguageObject}->Translate(
                    'Customer - List of Tickets'
                    ),
            "Ticket::Frontend::AgentTicketAddtlITSMField###DynamicField" => 
                $LayoutObject->{LanguageObject}->Translate(
                    'Agent - Additional ITSM Fields'
                    ),
            "Ticket::Frontend::AgentTicketArticleEdit###DynamicField" => 
                $LayoutObject->{LanguageObject}->Translate(
                    'Agent - Edit Article'
                    ),
            "Ticket::Frontend::AgentTicketDecision###DynamicField" => 
                $LayoutObject->{LanguageObject}->Translate(
                    'Agent - Decision'
                    ),
            "Ticket::Frontend::AgentTicketEmailOutbound###DynamicField" => 
                $LayoutObject->{LanguageObject}->Translate(
                    'Agent - Outbound Email'
                    ),
            "Ticket::Frontend::AgentTicketForward###DynamicField" => 
                $LayoutObject->{LanguageObject}->Translate(
                    'Agent - Forward'
                    ),
            "Ticket::Frontend::AgentTicketMove###DynamicField" => 
                $LayoutObject->{LanguageObject}->Translate(
                    'Agent - Move'
                    ),
            "Ticket::Frontend::AgentTicketOwner###DynamicField" => 
                $LayoutObject->{LanguageObject}->Translate(
                    'Agent - Owner'
                    ),
            "Ticket::Frontend::AgentTicketPending###DynamicField" => 
                $LayoutObject->{LanguageObject}->Translate(
                    'Agent - Pending'
                    ),
            "Ticket::Frontend::AgentTicketPhoneInbound###DynamicField" => 
                $LayoutObject->{LanguageObject}->Translate(
                    'Agent - Inbound Phone'
                    ),
            "Ticket::Frontend::AgentTicketPhoneOutbound###DynamicField" => 
                $LayoutObject->{LanguageObject}->Translate(
                    'Agent - Outbound Phone'
                    ),
            "Ticket::Frontend::AgentTicketPrint###DynamicField" => 
                $LayoutObject->{LanguageObject}->Translate(
                    'Agent - Print'
                    ),
            "Ticket::Frontend::AgentTicketPriority###DynamicField" => 
                $LayoutObject->{LanguageObject}->Translate(
                    'Agent - Priority'
                    ),
            "Ticket::Frontend::AgentTicketResponsible###DynamicField" => 
                $LayoutObject->{LanguageObject}->Translate(
                    'Agent - Responsible'
                    ),
            "Ticket::Frontend::CustomerTicketSearch###DynamicField" => 
                $LayoutObject->{LanguageObject}->Translate(
                    'Customer - Search'
                    ),
            "Ticket::Frontend::CustomerTicketPrint###DynamicField" => 
                $LayoutObject->{LanguageObject}->Translate(
                    'Customer - Print'
                    ),
	    );
	 $Data{Areas} = $LayoutObject->BuildSelection(
        Data         => \%AreasList,
        Name         => 'Areas',
        SelectedID   => '',
        Translation  => 0,
        PossibleNone => 1,
        Class       => 'Modernize',
        Multiple    => 1,
        Size        => 8,
    );

    foreach my $key (sort { $AreasList{$a} cmp $AreasList{$b}} keys %AreasList) {
        my $value = $AreasList{$key};

        my %DataSub = ();

        my %VisibilityList = (
	        "0" => $LayoutObject->{LanguageObject}->Translate('0 - Disabled'),
	        "1" => $LayoutObject->{LanguageObject}->Translate('1 - Enabled'),
            "2" => $LayoutObject->{LanguageObject}->Translate('2 - Enabled and Mandatory'),
	    );

        my $fieldName = $key;
        $fieldName =~ s/[^a-zA-Z0-9]*//g;

        $DataSub{Visibilities} = $LayoutObject->BuildSelection(
            Data         => \%VisibilityList,
            Name         => $fieldName,
            SelectedID   => '1',
            Translation  => 0,
            PossibleNone => 0,
            Class       => 'Modernize',
            Size        => 8,
        );

        $DataSub{FieldName} = $fieldName;

        $DataSub{FieldLabel} = $value;

        if($key eq "Ticket::Frontend::AgentTicketZoom###ProcessWidgetDynamicField"){

            my %Setting = $SysConfigObject->SettingGet(
                Name    => "Ticket::Frontend::AgentTicketZoom###ProcessWidgetDynamicFieldGroups",
            );

            my %Groups = (
                "Default" => $LayoutObject->{LanguageObject}->Translate('Default'),
            );

            foreach my $key2 (sort keys %{$Setting{EffectiveValue}}){
                $Groups{$key2} = $key2;
            }

            $DataSub{Groups} = $LayoutObject->BuildSelection(
                Data         => \%Groups,
                Name         => "Group".$fieldName,
                Translation  => 0,
                PossibleNone => 1,
                Class       => 'Modernize',
                Multiple    => 1,
                Size        => 8,
            );

            $DataSub{GroupFieldName} = $fieldName;

            $DataSub{GroupFieldLabel} = "Show in these groups";
            
            $LayoutObject->Block(
                Name => 'VisibilityWid',
                Data => \%DataSub, 
            )
        }
        else {
            $LayoutObject->Block(
                Name => 'Visibility',
                Data => \%DataSub, 
            )
        }

        
    }
    

	my $iFrame = $LayoutObject->Output(
    	    TemplateFile => 'OutputFilter.Ligero.DynamicFieldsPlus',
	        Data         => \%Data,
    	);
	my $NewHTML = $iFrame.'<div class="Field SpacingTop">';
	${ $Param{Data} } =~ s/<div class="Field SpacingTop">/$NewHTML/
	
#	${ $Param{Data} } .= $iFrame ;  
#	}
}
1;
