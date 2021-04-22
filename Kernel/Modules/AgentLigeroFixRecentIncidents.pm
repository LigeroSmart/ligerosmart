# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentLigeroFixRecentIncidents;

use strict;
use warnings;
use Encode qw();

use Data::Dumper;

use Kernel::System::VariableCheck qw(:all);
use JSON;
use utf8;
use vars qw($VERSION);
use JSON::XS;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
	my ( $Self, %Param ) = @_;
my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');
  my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
  my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
  my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');
  my $TranslateObject = $Kernel::OM->Get('Kernel::Language');
  my $JSONObject = $Kernel::OM->Get('Kernel::System::JSON');

  my $JSON = $LayoutObject->JSONEncode(
      Data => {
        Quantity => '13'
      },
  );

	# ------------------------------------------------------------ #
	# change
	# ------------------------------------------------------------ #
	if ( $Self->{Subaction} eq 'GetCounter' ) {
    return $LayoutObject->Attachment(
        ContentType => 'application/json; charset=utf8',
        Content     => $JSON || '',
        Type        => 'inline',
        NoCache     => 1,
    );
	}

  return $LayoutObject->Attachment(
      ContentType => 'application/json; charset=utf8',
      Content     => $JSON || '',
      Type        => 'inline',
      NoCache     => 1,
  );
}

1;