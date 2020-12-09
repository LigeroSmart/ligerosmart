# --
# Copyright (C) 2001-2017 Complemento - Liberdade e Tecnologia http://www.complemento.net.br
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Console::Command::Admin::Ligero::Elasticsearch::Reindex;

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
        Name        => 'DefaultLanguage',
        Description => "Install mapping for default OTRS Language",
        Required    => 0,
        HasValue    => 0,
    );


    $Self->AddOption(
        Name        => 'LanguageCode',
        Description => "Single language creation.",
        Required    => 0,
        HasValue    => 1,
		ValueRegex  => qr/.*/smx,
    );

    $Self->AddOption(
        Name        => 'requests-per-second',
        Description => "Requests Per Second.",
        Required    => 0,
        HasValue    => 1,
        ValueRegex  => qr/^\d+$/smx,
    );

    $Self->AddOption(
        Name        => 'AllLanguages',
        Description => "Install all mappings",
        Required    => 0,
        HasValue    => 0,
    );

    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    $Self->Print("<yellow>Reindexing Elasticsearch Indices...</yellow>\n");

	if (!$Self->GetOption('LanguageCode') && !$Self->GetOption('AllLanguages') && !$Self->GetOption('DefaultLanguage')){
		$Self->Print("<yellow>You need to specify at least one option between LanguageCode, DefaultLanguage or AllLanguages.</yellow>\n");
		return $Self->ExitCodeOk();
	}
	if ($Self->GetOption('LanguageCode') && $Self->GetOption('AllLanguages') && $Self->GetOption('DefaultLanguage')){
		$Self->Print("<yellow>You need to specify only one option between LanguageCode, DefaultLanguage or AllLanguages.</yellow>\n");
		return $Self->ExitCodeOk();
	}

	my $RequestsPerSecond = $Self->GetOption('requests-per-second') || 50;

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
	
	# for each language, call IndexCreate
	for my $Lang (@Languages){
		for my $Type (qw(ticket portallinks)){
			# Create new indice, make alias to search and index, remove index alias of old index
			my %Result = $Kernel::OM->Get('Kernel::System::LigeroSmart')->Reindex(
				Index 	 => $Type.'_'.$Index,
				Language => $Lang,
				RequestsPerSecond => $RequestsPerSecond
			);
			$Self->Print("<yellow>Reindexing $Lang. Please wait Elasticsearch Task $Result{TaskID} to finish.</yellow>\n");
			
			# Monitor Reindex progress
			my $NotCompleted = 1;
			while($NotCompleted){
				my %TaskStatus = $Kernel::OM->Get('Kernel::System::LigeroSmart')->CheckReindexStatus( EsTaskID => $Result{TaskID} );
				$Self->Print("Progress: <yellow>$TaskStatus{Progress}%</yellow>. Reindexes documents <yellow>$TaskStatus{Created}</yellow>.\n");
				if($TaskStatus{Completed}){
					$NotCompleted = 0;
				}
				sleep 5;
			}
			
			# Removes Old Index
			$Kernel::OM->Get('Kernel::System::LigeroSmart')->IndexDelete( Index => $Result{CurrentIndex} );
		}

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
