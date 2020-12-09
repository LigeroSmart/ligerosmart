# --
# Copyright (C) 2001-2016 Complemento - Liberdade e Tecnologia http://www.complemento.net.br
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Console::Command::Maint::Ligero::Elasticsearch::PortalFaqIndexRebuild;

use strict;
use warnings;

use Time::HiRes();
use URI::Escape qw(uri_escape);
use Data::Dumper;
use base qw(Kernel::System::Console::BaseCommand);
use MIME::Base64;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Service',
    'Kernel::System::FAQ'

    
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
    $Self->AddOption(
        Name        => 'description-field',
        Description => "Specify the field that will be used as Portal Link description, defaults to Field1 (Field1, DynamicField_Field).",
        Required    => 0,
        HasValue    => 1,
	ValueRegex  => qr/.*/smx,
    );
    $Self->AddOption(
        Name        => 'attachments',
        Description => 'Index FAQ attachments as well.',
        Required    => 0,
        HasValue    => 0,
    );

    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $ParamObject  = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $FAQObject = $Kernel::OM->Get('Kernel::System::FAQ');
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
    my %FaqLanguages = reverse $FAQObject->LanguageList(
        UserID => 1,
    );

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

    # Pega a URL base do catalogo de serviços na tela do cliente
#    my $CustomerBaseURL = $ConfigObject->Get('HttpType')
#		    . '://'
#		    . $ConfigObject->Get('FQDN')
#		    . '/'
#		    . $ConfigObject->Get('ScriptAlias')
#		    . 'customer.pl';
    my $CustomerBaseURL = '/'
		    . $ConfigObject->Get('ScriptAlias')
		    . 'customer.pl';

    # Obtem parametros de configuração para utilizações diversas ao longo do arquivo
    my $Config  = $Self->{Config} = $Kernel::OM->Get('Kernel::Config')->Get("ServiceCatalog")||{};

    $Self->Print("<yellow>Rebuilding Faq search index...</yellow>\n");

    # disable ticket events
    $Kernel::OM->Get('Kernel::Config')->{'Ticket::EventModulePost'} = {};

	# for each Language
	for my $Lang (@Languages){
		my $Index = $Kernel::OM->Get('Kernel::Config')->Get('LigeroSmart::Index');
		$Index .= "_".$Lang."_index";
		$Index = lc($Index);

		# Get All External and Public FAQs IDs
		my @FaqIDs = $FAQObject->FAQSearch(
			States    => {                                                # (optional)
				3 => 'public',
				2 => 'external',
			},
			#LanguageIDs => [$FaqLanguages{$Lang}],                                   # (optional)
			ValidIDs    => [ 1 ],                                   # (optional) (default 1)
			UserID    => 1,
		);

		my $DescriptionField = $Self->GetOption('description-field') || 'Field1';

		my $Count      = 0;
		my $MicroSleep = $Self->GetOption('micro-sleep');
			 
		## Prepare each FAQ to be sent to Elasticsearch
		for my $FaqID (@FaqIDs){
			
		$Count++;
		
		my %FAQ = $FAQObject->FAQGet(
			ItemID        => $FaqID,
			ItemFields    => 1,
			DynamicFields => 1,
			UserID        => 1,
		);
		
		my %CatalogItem;

        # FAQ visibility
        $CatalogItem{Visibility} = $FAQ{StateTypeName};
			
		$CatalogItem{dateTime} = $dateTime;
		$CatalogItem{Object}   = "FAQ-".$FAQ{CategoryName};
		$CatalogItem{Title}    = $FAQ{Title};
		$CatalogItem{Language} = $Lang;
		$CatalogItem{ObjectID} = $FaqID;
		$CatalogItem{Subtitle} = 'FAQ Article';

		$CatalogItem{Description} = $Kernel::OM->Get('Kernel::System::HTMLUtils')->ToAscii(
				String => $FAQ{$DescriptionField}||"",
			);
		$CatalogItem{Description} =~ s/^\s+|\n|\s+$//g;
	
		## Action URL
		$CatalogItem{URL} = $CustomerBaseURL."?Action=CustomerFAQZoom;ItemID=$FaqID";

		## SearchBody - Field used for the search
		$CatalogItem{SearchBody} = "$CatalogItem{Title} $CatalogItem{Subtitle}";
		for my $Field (qw(CategoryName Title Field1 Field2 Field3 Field4 Field5 Field6 Keywords a aa aaaa aaaa)){
			$CatalogItem{SearchBody} .= " ".$Kernel::OM->Get('Kernel::System::HTMLUtils')->ToAscii(
							String => $FAQ{$Field},
							) if defined $FAQ{$Field};
		}
		
		########## FAQ Attachments ##########
		if($Self->GetOption('attachments')){
			my @FaqAttachments;
			my @AtIndex = $FAQObject->AttachmentIndex(
			ItemID     => $FaqID,
			ShowInline => 1,
			UserID     => 1,
			);
			
			for my $At (@AtIndex){
			my %File = $FAQObject->AttachmentGet(
				ItemID => $FaqID,
				FileID => $At->{FileID},
				UserID => 1,
			);
			# O segundo parametro do encode_base64 é o caracter usado no fim de linha. Coloquei em '' 
			# para ser uma string sem quebras de linha
			$File{Content} = encode_base64($File{Content},'');

			push @FaqAttachments, \%File;
			}
			$CatalogItem{Attachments} = \@FaqAttachments;
		}

		$CatalogItem{Keywords} = $FAQ{Keywords};

			my $Result = $Kernel::OM->Get('Kernel::System::LigeroSmart')->Index(
				Index 	=> $Index,
				Type  	=> 'portallinks',
				Body  	=> \%CatalogItem,
				Pipeline	=> 'portallinkattachments',
				Id    	=> "$CatalogItem{Object}-$Lang-$CatalogItem{ObjectID}-$dateTime"
			);
		
			if ( $Count % 10 == 0 ) {
				my $Percent = int( $Count / ( $#FaqIDs / 100 ) );
				$Self->Print(
					"<yellow>$Count</yellow> of <yellow>$#FaqIDs</yellow> FAQs processed (<yellow>$Percent %</yellow> done).\n"
				);
			}

			Time::HiRes::usleep($MicroSleep) if $MicroSleep;
		}

		my %Search;
		my @SearchMust;
		my %DateRange;
		my %TermObject;
		my %TermLang;
		
		$DateRange{'range'}->{'dateTime'}->{'lt'}=$dateTime;
		push @SearchMust,\%DateRange;
		
		$TermObject{'prefix'}->{'Object.raw'}->{'value'}='FAQ-';
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

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
