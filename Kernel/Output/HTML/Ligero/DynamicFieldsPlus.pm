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
	        "Ticket::Frontend::AgentTicketPhone###DynamicField" => $LayoutObject->{LanguageObject}->Translate('Agent Iterface - New Phone Ticket'),
	        "Ticket::Frontend::CustomerTicketMessage###DynamicField" => $LayoutObject->{LanguageObject}->Translate('Customer Interface - New Ticket'),
            "Ticket::Frontend::AgentTicketZoom###DynamicField" => $LayoutObject->{LanguageObject}->Translate('Agent Interface - Ticket Zoom'),
            "Ticket::Frontend::CustomerTicketZoom###DynamicField" => $LayoutObject->{LanguageObject}->Translate('Customer Interface - Ticket Zoom'),
            "Ticket::Frontend::AgentTicketZoom###ProcessWidgetDynamicField" => $LayoutObject->{LanguageObject}->Translate('Agent Interface - Process Widget'),
            "Ticket::Frontend::AgentTicketEmail###DynamicField" => $LayoutObject->{LanguageObject}->Translate('Agent Interface - New Email Ticket'),
            "Ticket::Frontend::AgentTicketSearch###DynamicField" => $LayoutObject->{LanguageObject}->Translate('Agent Interface - Allow ticket search'),
            "Ticket::Frontend::OverviewSmall###DynamicField" => $LayoutObject->{LanguageObject}->Translate('Agent Interface - Allow show as column on ticket lists'),
            "Ticket::Frontend::AgentTicketFreeText###DynamicField" => $LayoutObject->{LanguageObject}->Translate('Agent Interface - Free Text'),
            "Ticket::Frontend::AgentTicketNote###DynamicField" => $LayoutObject->{LanguageObject}->Translate('Agent Interface - Note'),
            "Ticket::Frontend::AgentTicketClose###DynamicField" => $LayoutObject->{LanguageObject}->Translate('Agent Interface - Close'),
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

    foreach my $key (sort keys %AreasList) {
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

        $DataSub{FieldLabel} = $LayoutObject->{LanguageObject}->Translate("Visibility ").$value;

        if($key eq "Ticket::Frontend::AgentTicketZoom###ProcessWidgetDynamicField"){

            my %Setting = $SysConfigObject->SettingGet(
                Name    => "Ticket::Frontend::AgentTicketZoom###ProcessWidgetDynamicFieldGroups",
            );

            my %Groups = (
                "Default" => "Default"
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
                Size        => 8,
            );

            $DataSub{GroupFieldName} = "Group".$fieldName;

            $DataSub{GroupFieldLabel} = $LayoutObject->{LanguageObject}->Translate("Group ").$value;
            
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