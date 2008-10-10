# --
# Kernel/Output/HTML/OutputFilterFAQ.pm - Output filter for FAQ module
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: OutputFilterFAQ.pm,v 1.2 2008-10-10 13:49:37 ub Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::Output::HTML::OutputFilterFAQ;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.2 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless ($Self, $Type);

    # get needed objects
    for my $Object (qw(ConfigObject MainObject LogObject LayoutObject)) {
        $Self->{$Object} = $Param{$Object} || die "Got no $Object!";
    }

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # check data
    return if !$Param{Data};
    return if ref $Param{Data} ne 'SCALAR';
    return if !${ $Param{Data} };
    return if !$Param{TemplateFile};

    # check permission
    return if !$Self->{LayoutObject}->{EnvRef}->{'UserIsGroupRo[faq]'};

    # get allowed template names
    my $ValidTemplates = $Self->{ConfigObject}->Get('Frontend::Output::FilterElementPre')
        ->{FAQ}
        ->{Templates};

    # check template name
    return if !$ValidTemplates->{ $Param{TemplateFile} };

    # add javascript function
    my $Search  = '</script>';
    my $Replace = <<'END';
</script>

<script language="JavaScript" type="text/javascript">
<!--
function FAQSubmit() {
    window.open('', 'faq', 'toolbar=no,location=no,status=yes,scrollbars=yes,resizable=yes,width=700,height=550,left=100,top=100');
    document.faq.submit()
}
// -->
</script>
END
    ${$Param{Data}} =~ s{ $Search }{$Replace}ixms;

    # add FAQ link
    my $Search1 = '<!-- [ ] dtl:block:SpellCheck [ ] --> .+?';
    my $Search2 = '</td>';
    $Replace    = <<'END';
  $Env{"Box0"}<a href="" onclick="FAQSubmit(); return false;" onmouseover="window.status='$JSText{"FAQ"}'; return true;" onmouseout="window.status='';"><img border="0" src="$Env{"Images"}help-small.png">$Text{"FAQ"}</a>$Env{"Box1"}
                  </td>
END
    ${$Param{Data}} =~ s{ ($Search1) $Search2 }{$1$Replace}ixms;

    # add FAQ form
    $Search = '<form [^<>]+ target="spelling"> .+? </form>';
    $Replace = <<'END';

      <form action="$Env{"CGIHandle"}" method="post" name="faq" target="faq">
        <input type="hidden" name="Action" value="AgentFAQ"/>
        <input type="hidden" name="Nav" value="None"/>
        <input type="hidden" name="Body" value=""/>
        <input type="hidden" name="Subject" value=""/>
        <input type="hidden" name="What" value=""/>
      </form>
END
    ${$Param{Data}} =~ s{ ($Search) }{$1$Replace}ixms;

    return 1;
}

1;
