# --
# Copyright (C) 2011 - 2021 Complemento - Liberdade e Tecnologia http://www.complemento.net.br
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::OutputFilterLigeroFix;

use strict;
use warnings;
require LWP::UserAgent;
use List::Util qw(first);
use HTTP::Status qw(:constants :is status_message);
#----------------------------------------
our @ObjectDependencies = (
    'Kernel::System::Log',
    'Kernel::Config',
    'Kernel::System::Main',
    'Kernel::Output::HTML::Layout',
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
	my %Data = ();
    # get template name
    my $Templatename = $Param{TemplateFile} || '';
    return 1 if !$Templatename;
	return 1 if ${$Param{Data}} !~ m/\<div id\="ArticleTree"\>/g;

    # get param object
	my $ShowDiv			  = $Kernel::OM->Get('Kernel::Config')->Get('LigeroFix::ShowDiv');
	if($ShowDiv){
		# Get Cards
		my $LigeroFixModules = $Kernel::OM->Get('Kernel::Config')->Get('LigeroFix::Modules');
		return if !$LigeroFixModules;

    my $Count = 0;

		for my $Module (sort keys %{$LigeroFixModules}){
      $LigeroFixModules->{$Module}->{Index} = $Count;
			$Kernel::OM->Get('Kernel::Output::HTML::Layout')->Block(
				Name => "LigeroFixCard",
				Data => $LigeroFixModules->{$Module},
			);
      $Count++;
		}

		# Mostra widget central com iframe da pagina
		my $iFrame = $Kernel::OM->Get('Kernel::Output::HTML::Layout')->Output(
			TemplateFile => 'OutputFilterLigeroFix',
			Data         => \%Data,
		); 
		${ $Param{Data} } =~ s{("ContentColumn">\s+)<div}{$1$iFrame<div}xms;
	}else{
		return ${ $Param{Data} };
	}
}
1;
