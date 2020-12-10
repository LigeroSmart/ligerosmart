# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::DefaultLanguageEnv;

use strict;
use warnings;

use Data::Dumper;

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    return $Self;
}

sub PreRun {
    my ( $Self, %Param ) = @_;

	$ENV{'DefaultLanguage'} = $Kernel::OM->Get('Kernel::Config')->Get('DefaultLanguage');
    if ( $Self->{Action} eq 'AdminService'  || $Self->{Action} eq 'AdminCustomerUserService') {
		$ENV{'UserLanguage'} = $Kernel::OM->Get('Kernel::Config')->Get('DefaultLanguage');
    } else {
		$ENV{'UserLanguage'} = $Self->{UserLanguage} || $ENV{'DefaultLanguage'};
	}
	

	return;

}

sub Run {
    my ( $Self, %Param ) = @_;
}

1;
