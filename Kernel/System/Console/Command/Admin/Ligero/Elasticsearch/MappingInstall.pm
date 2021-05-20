# --
# Copyright (C) 2001-2017 Complemento - Liberdade e Tecnologia http://www.complemento.net.br
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Console::Command::Admin::Ligero::Elasticsearch::MappingInstall;

use strict;
use warnings;
use Data::Dumper;
use Time::HiRes();

use base qw(Kernel::System::Console::BaseCommand);

our @ObjectDependencies = (
    'Kernel::Config',
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('Install Elasticsearch Mappings for all or one specific language.');
    $Self->AddOption(
        Name        => 'LanguageCode',
        Description => "Single language creation.",
        Required    => 0,
        HasValue    => 1,
		ValueRegex  => qr/.*/smx,
    );

    $Self->AddOption(
        Name        => 'AllLanguages',
        Description => "Install all mappings",
        Required    => 0,
        HasValue    => 0,
    );

    $Self->AddOption(
        Name        => 'ForceDelete',
        Description => "Try to Delete before creating new index",
        Required    => 0,
        HasValue    => 0,
    );

    $Self->AddOption(
        Name        => 'DefaultLanguage',
        Description => "Install mapping for default OTRS Language",
        Required    => 0,
        HasValue    => 0,
    );

    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    $Self->Print("<yellow>Creating Elasticsearch Mappings...</yellow>\n");

	if (!$Self->GetOption('LanguageCode') && !$Self->GetOption('AllLanguages') && !$Self->GetOption('DefaultLanguage')){
		$Self->Print("<yellow>You need to specify at least one option between LanguageCode, DefaultLanguage or AllLanguages.</yellow>\n");
		return $Self->ExitCodeOk();
	}
	if ($Self->GetOption('LanguageCode') && $Self->GetOption('AllLanguages') && $Self->GetOption('DefaultLanguage')){
		$Self->Print("<yellow>You need to specify only one option between LanguageCode, DefaultLanguage or AllLanguages.</yellow>\n");
		return $Self->ExitCodeOk();
	}

	my $Index = $Kernel::OM->Get('Kernel::Config')->Get('LigeroSmart::Index');

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
		push @Languages, $Kernel::OM->Get('Kernel::Config')->Get('DefaultLanguage');
	}

	# Create ingest pipelines
	my $Result = $Kernel::OM->Get('Kernel::System::LigeroSmart')->IngestPipelineInstall();
	if ($Result == 1){
		$Self->Print("<yellow>Ingest pipelines created.</yellow>\n");
	} elsif ($Result == 2) {
		$Self->Print("<yellow>Ingest pipelines already exists.</yellow>\n");
	} else {
		$Self->Print("<red>Failed to create Ingest pipelines.</red>\n");
	}

	# for each language
	for my $Lang (@Languages){

		if($Self->GetOption('ForceDelete')){
			my $Result = $Kernel::OM->Get('Kernel::System::LigeroSmart')->IndexDelete(
				Index 	 => 'ticket_'.$Index.'_'.$Lang,
			);
			$Self->Print("<yellow>Trying to delete Index ticket_$Index"."_"."$Lang.</yellow>\n");

			$Result = $Kernel::OM->Get('Kernel::System::LigeroSmart')->IndexDelete(
				Index 	 => 'portallinks_'.$Index.'_'.$Lang,
			);
			$Self->Print("<yellow>Trying to delete Index portallinks_$Index"."_"."$Lang.</yellow>\n");

			$Result = $Kernel::OM->Get('Kernel::System::LigeroSmart')->IndexDelete(
				Index 	 => 'ticket_'.$Index.'_'.$Lang."_index",
			);
			$Self->Print("<yellow>Trying to delete Index ticket_$Index"."_".$Lang."_index.</yellow>\n");

			$Result = $Kernel::OM->Get('Kernel::System::LigeroSmart')->IndexDelete(
				Index 	 => 'portallinks_'.$Index.'_'.$Lang."_index",
			);
			$Self->Print("<yellow>Trying to delete Index portallinks_$Index"."_".$Lang."_index.</yellow>\n");
		}

		my $Result = $Kernel::OM->Get('Kernel::System::LigeroSmart')->IndexCreate(
			Index 	 => 'ticket_'.$Index,
			Language => $Lang
		);
		$Self->Print("<yellow>Index created: $Result</yellow>\n");
		my $Result = $Kernel::OM->Get('Kernel::System::LigeroSmart')->IndexCreate(
			Index 	 => 'portallinks_'.$Index,
			Language => $Lang
		);
		$Self->Print("<yellow>Index created: $Result</yellow>\n");
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
