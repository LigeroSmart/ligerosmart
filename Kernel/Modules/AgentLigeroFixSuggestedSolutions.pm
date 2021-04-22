# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentLigeroFixSuggestedSolutions;

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
  my $LinkObject = $Kernel::OM->Get('Kernel::System::LinkObject');

  $Param{TicketID} = $ParamObject->GetParam(Param => "TicketID") || "";

  my %Ticket = $TicketObject->TicketGet(
      TicketID      => $Param{TicketID},
      DynamicFields => 0,         # Optional, default 0. To include the dynamic field values for this ticket on the return structure.
      UserID        => 1,
      Silent        => 0,         # Optional, default 0. To suppress the warning if the ticket does not exist.
  );
  

	if ( $Self->{Subaction} eq 'GetCounter' ) {

    if(!$Ticket{ServiceID}){
      return $LayoutObject->Attachment(
          ContentType => 'application/json; charset=utf8',
          Content     => $LayoutObject->JSONEncode(
              Data => {
                Quantity => 0
              },
          ),
          Type        => 'inline',
          NoCache     => 1,
      );
    }

    my %LinkKeyList = $LinkObject->LinkKeyList(
        Object1    => 'Service',
        Key1       => $Ticket{ServiceID},
        Object2   => 'FAQ',         # (optional)
        State     => 'Valid',   # (optional) default Both (Source|Target|Both)
        UserID    => 1,
    );

    my $Quantity =  keys %LinkKeyList;

    my $CounterJson = $LayoutObject->JSONEncode(
        Data => {
          Quantity => $Quantity
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

    my $FAQObject = $Kernel::OM->Get('Kernel::System::FAQ');

    my $LigeroFixModules = $Kernel::OM->Get('Kernel::Config')->Get('LigeroFix::Modules');

    my $ModuleConfig = $LigeroFixModules->{'001-SugestedSolutions'};


    my %LinkKeyList = $LinkObject->LinkKeyListWithData(
        Object1    => 'Service',
        Key1       => $Ticket{ServiceID},
        Object2   => 'FAQ',         # (optional)
        State     => 'Valid',   # (optional) default Both (Source|Target|Both)
        UserID    => 1,
    );

    if(!(keys %LinkKeyList)){
      return $LayoutObject->Attachment(
          ContentType => 'text/html; charset=utf8',
          Content     =>  '',
          Type        => 'inline',
          NoCache     => 1,
      );
    }

    $LayoutObject->Block(
      Name => "FaqCardContent"
    );

    my $FirstFaq = undef;

    foreach my $key (sort keys %LinkKeyList) { 
      if(!$FirstFaq){
        $FirstFaq = $key;
      }
      my $FaqContent = $LinkKeyList{$key};
      #$Kernel::OM->Get('Kernel::System::Log')->Log(
      #    Priority => 'error',
      #    Message  => " KEY ".Dumper($FaqContent),
      #);

      $FaqContent->{Description} = $LayoutObject->RichText2Ascii(
          String => $FaqContent->{$ModuleConfig->{DescriptionField}},
      );
      $FaqContent->{FirstFaq} = $FirstFaq;

      $FaqContent->{Content} = $ModuleConfig->{ContentTemplate};

      while(index($FaqContent->{Content}, '<FAQ_') > -1){
        my $tag = substr $FaqContent->{Content}, index($FaqContent->{Content}, '<FAQ_');
        $tag = substr $tag, 0, index($tag,'>')+1;

        my $field = substr $tag, 5, index($tag,'>') -5;
        

        $FaqContent->{Content} =~ s/$tag/$FaqContent->{$field}/ig;
      }

      my @AttachmentIndex = $FAQObject->AttachmentIndex(
          ItemID     => $FaqContent->{ID},
          ShowInline => 0,
          UserID     => 1,
      );

      $LayoutObject->Block(
				Name => "FaqCard",
        Data => $FaqContent
			);

      # output header and all attachments
      if (@AttachmentIndex) {
          $LayoutObject->Block(
              Name => 'AttachmentHeader',
          );
          for my $Attachment (@AttachmentIndex) {
              $LayoutObject->Block(
                  Name => 'AttachmentRow',
                  Data => {
                      %$FaqContent,
                      %{$Attachment},
                  },
              );
          }
      }

      
    }

    

    my $Output = $LayoutObject->Output(
			TemplateFile => 'ModalAgentLigeroFixSuggestedSolutions',
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
        TargetObject => 'FAQ',
        TargetKey    => $Param{ObjectID},
        Type         => 'ParentChild',
        State        => 'Valid',
        UserID       => 1,
    );

    my $ResultJson = $LayoutObject->JSONEncode(
        Data => {
          Result => $True
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
