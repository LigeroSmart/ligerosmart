# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentLigeroFixUserCIs;

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
  my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');
  my $ConfigItemObject = $Kernel::OM->Get('Kernel::System::ITSMConfigItem');
  my $LinkObject = $Kernel::OM->Get('Kernel::System::LinkObject');

  $Param{TicketID} = $ParamObject->GetParam(Param => "TicketID") || "";

  

  my %Ticket = $TicketObject->TicketGet(
      TicketID      => $Param{TicketID},
      DynamicFields => 0,         # Optional, default 0. To include the dynamic field values for this ticket on the return structure.
      UserID        => 1,
      Silent        => 0,         # Optional, default 0. To suppress the warning if the ticket does not exist.
  );

	# ------------------------------------------------------------ #
	# change
	# ------------------------------------------------------------ #
	if ( $Self->{Subaction} eq 'GetCounter' ) {
    my @SearchKey = (
        {
            "[1]{'Version'}[1]{'Owner'}[%]{'Content'}" => $Ticket{Owner},
        }
    );
    my $ConfigItemIDs = $ConfigItemObject->ConfigItemSearchExtended(
        #ClassIDs => [$ClassID],
        What     => \@SearchKey,
    );

    #use Data::Dumper;
    #$Kernel::OM->Get('Kernel::System::Log')->Log(
    #    Priority => 'error',
    #    Message  => " ENTROU NO USER CIS ".scalar @$ConfigItemIDs,
    #);

    my $Quantity =  scalar @$ConfigItemIDs;

    my $CounterJson = $LayoutObject->JSONEncode(
        Data => {
          Quantity => scalar @$ConfigItemIDs
        },
    );

    return $LayoutObject->Attachment(
        ContentType => 'application/json; charset=utf8',
        Content     => $CounterJson || '',
        Type        => 'inline',
        NoCache     => 1,
    );
	}

  if ( $Self->{Subaction} eq 'GetModal' ) {

    my $LigeroFixModules = $Kernel::OM->Get('Kernel::Config')->Get('LigeroFix::Modules');

    my $ModuleConfig = $LigeroFixModules->{'011-UserCIs'};

    my @SearchKey = (
        {
            "[1]{'Version'}[1]{'Owner'}[%]{'Content'}" => $Ticket{Owner},
        }
    );
    my $ConfigItemIDs = $ConfigItemObject->ConfigItemSearchExtended(
        #ClassIDs => [$ClassID],
        What     => \@SearchKey,
    );

    if(!(scalar @$ConfigItemIDs)){
      return $LayoutObject->Attachment(
          ContentType => 'text/html; charset=utf8',
          Content     => '',
          Type        => 'inline',
          NoCache     => 1,
      );
    }

    $LayoutObject->Block(
      Name => "CICardContent"
    );

    foreach my $item (@{$ConfigItemIDs}) {
      my $ConfigItem = $ConfigItemObject->VersionGet(
          ConfigItemID => $item,
          XMLDataGet   => 1,
      );
      
      #$Kernel::OM->Get('Kernel::System::Log')->Log(
      #    Priority => 'error',
      #    Message  => " ITEM ".Dumper($ConfigItem)." ".Dumper($ConfigItem->{XMLData}->[1]->{Version}->[1]->{Owner}->[1]->{Content}),
      #);
      my $Data = {};

      $Data->{Name} = $ConfigItem->{Name};
      $Data->{ID} = $item;
      $Data->{Description} = $ModuleConfig->{DescriptionTemplate};

      while(index($Data->{Description}, '<CI_') > -1){ 
        my $tag = substr $Data->{Description}, index($Data->{Description}, '<CI_');
        $tag = substr $tag, 0, index($tag,'>')+1;

        my $field = substr $tag, 4, index($tag,'>') -4;

        my $valueToChange = $ConfigItem->{XMLData}->[1]->{Version}->[1]->{$field}->[1]->{Content};

        $Data->{Description} =~ s/$tag/$valueToChange/ig;
      }

      $LayoutObject->Block(
				Name => "CICard",
        Data => $Data
			);
    }

    

    my $Output = $LayoutObject->Output(
			TemplateFile => 'ModalAgentLigeroFixUserCIs',
			Data         => {
				%Param,
			},
		);

    return $LayoutObject->Attachment(
        ContentType => 'text/html; charset=utf8',
        Content     => $Output || '',
        Type        => 'inline',
        NoCache     => 1,
    );
	}

  if ( $Self->{Subaction} eq 'LinkToTheTicket' ) {

    $Param{ObjectID} = $ParamObject->GetParam(Param => "ObjectID") || "";

    my $True = $LinkObject->LinkAdd(
        SourceObject => 'Ticket',
        SourceKey    => $Param{TicketID},
        TargetObject => 'ITSMConfigItem',
        TargetKey    => $Param{ObjectID},
        Type         => 'DependsOn',
        State        => 'Valid',
        UserID       => 1,
    );

    my $ResultJson = $LayoutObject->JSONEncode(
        Data => {
          Result => $True,
          Value => $Param{TicketID}
        },
    );

    return $LayoutObject->Attachment(
        ContentType => 'application/json; charset=utf8',
        Content     => $ResultJson || 0,
        Type        => 'inline',
        NoCache     => 1,
    );
	}

  my $JSON = $LayoutObject->JSONEncode(
      Data => {
        Error => 'Nothing to show.'
      },
  );

  return $LayoutObject->Attachment(
      ContentType => 'application/json; charset=utf8',
      Content     => $JSON || '',
      Type        => 'inline',
      NoCache     => 1,
  );
}

1;