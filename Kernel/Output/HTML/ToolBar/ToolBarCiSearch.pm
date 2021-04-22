# --
# Kernel/Output/HTML/ToolBarCiSearch.pm
# Copyright (C) 2012 http://www.complemento.net.br
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::ToolBar::ToolBarCiSearch;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.2 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get needed objects
    #for (qw(ConfigObject LogObject DBObject TicketObject LayoutObject UserID UserObject)) {
     #   $Self->{$_} = $Param{$_} || die "Got no $_!";
   # }

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    #OBJECTS 
 
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout'); 
 
    #----------

    my %Classes = %{$ConfigObject->Get('ToolBarCiSearch::Classes')};

    my %Options = %{$ConfigObject->Get('ToolBarCiSearch::Options')};
    if ( !%Classes ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need one class at least!' );
    	return;
    }

    my $HTML = $LayoutObject->Output(
        TemplateFile   => "AgentToolBarCiSearch",
        Data           => {
	   Size      => $Param{Config}->{Size},
           DefaultClassID => $Options{DefaultClassID} || 32,
           Classes   => scalar keys(%Classes),
           ClassesName => join(',',keys %Classes) || 'Computer',
           ClassesID => join(',',values %Classes) || '32',
           Hint => $Options{Hint},
        },
        KeepScriptTags => 0,
    );

    my $Priority = $Param{Config}->{'Priority'};
    my %Return   = ();
    $Return{$Priority} = {
        Block       => 'ToolBarItem',
        Description => '',
        Class       => 'NoShow',
        Link        => '',
        AccessKey   => '',
    };
    return %Return;
}

1;
