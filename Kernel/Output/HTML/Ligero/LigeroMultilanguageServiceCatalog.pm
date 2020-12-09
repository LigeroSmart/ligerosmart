# --
# Copyright (C) 2011 - 2015 Complemento - Liberdade e Tecnologia http://www.complemento.net.br
# --
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::Ligero::LigeroMultilanguageServiceCatalog;

use strict;
use warnings;
require LWP::UserAgent;
use List::Util qw(first);
use HTTP::Status qw(:constants :is status_message);
use Kernel::System::VariableCheck qw(:all);

use Data::Dumper;
use CGI ();

use utf8;

sub new {
	my ( $Type, %Param ) = @_;
	# allocate new hash for object
	my $Self = {};
	bless( $Self, $Type );
	# get needed objects
	$Self->{UserID} = $Param{UserID};
	$Self->{SessionID} = $Param{SessionID};

    return $Self;
    
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $ParamObject  = $Kernel::OM->Get('Kernel::System::Web::Request');
    
    my $Subaction = $ParamObject->GetParam(Param => 'Subaction') ||'';

    if ($Subaction eq 'ServiceEdit'){

		my $DefaultLanguage = $Kernel::OM->Get('Kernel::Config')->Get("DefaultLanguage") || 'en';

        # Add JavaScript
        $LayoutObject->Block(
            Name => 'JavaScript',
            Data => {
				DefaultLanguage => $DefaultLanguage
			}
        );
        
        $LayoutObject->Output(
            TemplateFile => 'LigeroAdminMultilanguageServiceCatalog',
            Data         => {}
        );

        # Add Style
        $LayoutObject->Block(
            Name => 'Style'
        );
        my $Style = $LayoutObject->Output(
            TemplateFile => 'LigeroAdminMultilanguageServiceCatalog',
            Data         => {}
        );
                
        ${ $Param{Data} } = $Style.${ $Param{Data} };
    }

    return $Param{Data};
}

1;
