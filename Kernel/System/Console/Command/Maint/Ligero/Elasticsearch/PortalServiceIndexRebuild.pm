# --
# Copyright (C) 2001-2016 Complemento - Liberdade e Tecnologia http://www.complemento.net.br
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Console::Command::Maint::Ligero::Elasticsearch::PortalServiceIndexRebuild;

use strict;
use warnings;

use Time::HiRes();
use URI::Escape qw(uri_escape_utf8);
use Data::Dumper;
use base qw(Kernel::System::Console::BaseCommand);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Service',

    
);

sub Configure {
    my ( $Self, %Param ) = @_;


    
    $Self->Description('Completely rebuild the article search index on Elasticsearch for Ligero Search.');
    
    $Self->AddOption(
        Name        => 'LanguageCode',
        Description => "Single language Index rebuild.",
        Required    => 0,
        HasValue    => 1,
		ValueRegex  => qr/.*/smx,
    );

    $Self->AddOption(
        Name        => 'AllLanguages',
        Description => "Index Rebuild for all languages",
        Required    => 0,
        HasValue    => 0,
    );

    $Self->AddOption(
        Name        => 'DefaultLanguage',
        Description => "Index rebuild for OTRS Default Language",
        Required    => 0,
        HasValue    => 0,
    );

    
    $Self->AddOption(
        Name        => 'micro-sleep',
        Description => "Specify microseconds to sleep after every ticket to reduce system load (e.g. 1000).",
        Required    => 0,
        HasValue    => 1,
        ValueRegex  => qr/^\d+$/smx,
    );

    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

	my $ParamObject  = $Kernel::OM->Get('Kernel::System::Web::Request');
	my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
	my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
	
	
	if (!$Self->GetOption('LanguageCode') && !$Self->GetOption('AllLanguages') && !$Self->GetOption('DefaultLanguage')){
		$Self->Print("<yellow>You need to specify at least one option between LanguageCode, DefaultLanguage or AllLanguages.</yellow>\n");
		return $Self->ExitCodeOk();
	}
	if ($Self->GetOption('LanguageCode') && $Self->GetOption('AllLanguages') && $Self->GetOption('DefaultLanguage')){
		$Self->Print("<yellow>You need to specify only one option between LanguageCode, DefaultLanguage or AllLanguages.</yellow>\n");
		return $Self->ExitCodeOk();
	}

	my $DefaultLanguage = $Kernel::OM->Get('Kernel::Config')->Get('DefaultLanguage');
	
	# Get all Languages from Config
	my %LanguagesMappings = %{$Kernel::OM->Get('Kernel::Config')->Get('DefaultUsedLanguages')};
	my @Languages;
	if($Self->GetOption('AllLanguages')){
		@Languages = keys %LanguagesMappings;
	}
	if($Self->GetOption('LanguageCode')){
		push @Languages, $Self->GetOption('LanguageCode');
	}
	if($Self->GetOption('DefaultLanguage')){
		push @Languages, $DefaultLanguage;
	}


	# Obtem a data e hora atual para podermos armazenar e apagar os antigos
    my ( $s, $m, $h, $D, $M, $Y ) =
        $Kernel::OM->Get('Kernel::System::Time')->SystemTime2Date(
        SystemTime => $Kernel::OM->Get('Kernel::System::Time')->SystemTime(),
    );
    my $dateTime = "$Y-$M-$D $h:$m:$s";

    my $CustomerBaseURL = '/'
		    . $ConfigObject->Get('ScriptAlias')
		    . 'customer.pl';


    # Obtem parametros de configuração para utilizações diversas ao longo do arquivo
    my $Config  = $Self->{Config} = $Kernel::OM->Get('Kernel::Config')->Get("ServiceCatalog")||{};
    my %TypesLabel = %{$Config->{TypeLabels}};
	

    $Self->Print("<yellow>Rebuilding Service Catalog Search Index...</yellow>\n");

    # disable ticket events
    $Kernel::OM->Get('Kernel::Config')->{'Ticket::EventModulePost'} = {};

    # Get objects
    my $ServiceObject = $Kernel::OM->Get('Kernel::System::Service');
    my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');
    my $BackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

    # get all Services
    my $ServicesRef = $ServiceObject->ServiceListGet(
        UserID       => 1,
    );
    my @ServicesArray = @$ServicesRef;

    my @SearchCatalogItems;

    my $Count      = 0;
    my $MicroSleep = $Self->GetOption('micro-sleep');

	# for each Language
	for my $Lang (@Languages){
		
		my $Index = $Kernel::OM->Get('Kernel::Config')->Get('LigeroSmart::Index');
		$Index .= "_".$Lang."_index";
		$Index = lc($Index);
		
		# Prepare each Service to send to Elasticsearch
		for my $Service (@ServicesArray){
		
			$Count++;
		
			my %CatalogItem;
            
            # Services visibility
            $CatalogItem{Visibility} = 'public';
            
			$CatalogItem{dateTime} = $dateTime;
			$CatalogItem{Object}   = "Service";

			if($Lang eq $DefaultLanguage){
				$CatalogItem{Title}    = $Service->{Name};
			} else {
				$CatalogItem{Title}    = $Service->{"name_$Lang"} || $Service->{Name};
			}

			$CatalogItem{ObjectID} = $Service->{ServiceID};
			$CatalogItem{Language} = $Lang;
			
			# Subtitle: for tickets which have TicketType defined (ServiceTicketType AddOn), it should be the corresponding Label
			#           otherwise, if it's a service category, it should be "Service Caregory"
			my $Subtitle = '';
			if(defined $Service->{TicketType} && $Service->{TicketType} ne ''){
				if(defined $TypesLabel{$Service->{TicketType}}){
					$Subtitle = $TypesLabel{$Service->{TicketType}};
				}
			} else {
				# Verifica se o serviço é pai (categoria)
				if(_HasChildren($ServicesRef,$Service->{Name})){
					$Subtitle = $Kernel::OM->Get('Kernel::Language')->Translate('Service Category');
				}
			}
			$CatalogItem{Subtitle} = $Subtitle;
			
			# Description
			my $ValueLang;
			my $DescriptionDF = 'ServiceDescription';
			if($Lang ne $DefaultLanguage){
				$DescriptionDF .= 'XX';
				my $LangCode = $Lang;
				$LangCode =~ s/_/XX/g;
				$DescriptionDF .= $LangCode;
				# Current Language Code
				my $DynamicFieldConfigLang = $DynamicFieldObject->DynamicFieldGet(
					Name   => $DescriptionDF,             # ID or Name must be provided
				);
				$ValueLang = $BackendObject->ValueGet(
					DynamicFieldConfig => $DynamicFieldConfigLang,      # complete config of the DynamicField
					ObjectID           => $Service->{ServiceID},                # ID of the current object that the field
					);											# must be linked to, e. g. TicketID
			}

			# DefaltLanguage Code
			my $DynamicFieldConfig = $DynamicFieldObject->DynamicFieldGet(
				Name   => 'ServiceDescription',             # ID or Name must be provided
			);
			my $Value = $BackendObject->ValueGet(
				DynamicFieldConfig => $DynamicFieldConfig,      # complete config of the DynamicField
				ObjectID           => $Service->{ServiceID},                # ID of the current object that the field
				);											# must be linked to, e. g. TicketID


			$CatalogItem{Description} = $ValueLang || $Value || '';
			# EO Description
			
			# Image
			$DynamicFieldConfig = $DynamicFieldObject->DynamicFieldGet(
				Name   => 'ServiceImage',             # ID or Name must be provided
			);
			$Value = $BackendObject->ValueGet(
				DynamicFieldConfig => $DynamicFieldConfig,      # complete config of the DynamicField
				ObjectID           => $Service->{ServiceID},                # ID of the current object that the field
																	# must be linked to, e. g. TicketID
			);
			if($Value){
				if($Value =~ /<a[^>]*?FieldID=([\d]*?)\;[^>]*?ObjectID=([\d]*?)\'/g){
					$Value = $CustomerBaseURL."?Action=CustomerDFFileAttachment;FieldID=$1;ObjectID=$2";
				}
				$CatalogItem{ImgUrl} = $Value||'';
			}
			# EO Image

			# ImageBackground
			$CatalogItem{ImgBackground} = $Service->{ServiceImageBackground} || '';
			
			# Action URL
			$CatalogItem{URL} = $CustomerBaseURL."?Action=CustomerServiceCatalog&Subaction=NextLevel&KeyPrimary=".uri_escape_utf8($Service->{Name});

			# SearchBody - Field used for the search
			$CatalogItem{SearchBody} = "$CatalogItem{Title} $CatalogItem{Description}";

			my $Result = $Kernel::OM->Get('Kernel::System::LigeroSmart')->Index(
				Index => $Index,
				Type  => 'portallinks',
				Body  => \%CatalogItem,
				Id    => "$CatalogItem{Object}-$CatalogItem{ObjectID}-$Lang-$dateTime"
			);

			if ( $Count % 30 == 0 ) {
				my $Percent = int( $Count / ( $#ServicesArray / 100 ) );
				$Self->Print(
					"<yellow>$Count</yellow> of <yellow>$#ServicesArray</yellow> Services processed (<yellow>$Percent %</yellow> done).\n"
				);
			}

		Time::HiRes::usleep($MicroSleep) if $MicroSleep;
		}

		# Remove old items
		my %Search;
		my @SearchMust;
		my %DateRange;
		my %TermObject;
		my %TermLang;
		
		$DateRange{'range'}->{'dateTime'}->{'lt'}=$dateTime;
		push @SearchMust,\%DateRange;
		
		$TermObject{'term'}->{'Object.raw'}->{'value'}='Service';
		push @SearchMust,\%TermObject;

		$TermLang{'term'}->{'Language.raw'}->{'value'}=$Lang;
		push @SearchMust,\%TermLang;
		
		$Search{'query'}->{'bool'}->{'must'} = \@SearchMust;

		

		my $Result = $Kernel::OM->Get('Kernel::System::LigeroSmart')->DeleteByQuery(
			Indexes => $Index,
			Types  => 'portallinks',
			Body => \%Search
		);

	}


    $Self->Print("<green>Done.</green>\n");
    return $Self->ExitCodeOk();
}

sub _HasChildren{ 
    # ESTA FUNÇÃO ESTÁ UM POUCO DIFERENTE DA DO ROBERT NO ARQUIVO CustomerServiceCatalog
	my $Para = shift;
	my @AllServices = @$Para;
	my $Name = ""|| shift;
	my $Regex="^".quotemeta($Name)."::";

	my @matching_items = grep {	  $_->{Name} =~ /$Regex/} @AllServices;

	if(scalar @matching_items){
		return 1;	
	}else{
		return 0;
	}

}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
