# --
# Kernel/Output/HTML/OutputFilterFAQ.pm - Output filter for FAQ module
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# --
# $Id: OutputFilterFAQ.pm,v 1.7 2010-12-02 05:17:29 cr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::OutputFilterFAQ;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.7 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

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
    my $ValidTemplates
        = $Self->{ConfigObject}->Get('Frontend::Output::FilterElementPre')->{FAQ}->{Templates};

    # check template name
    return if !$ValidTemplates->{ $Param{TemplateFile} };

    # add FAQ link
    #$FinishPattern will be replaced by $Replace
    my $StartPattern  = '<!-- [ ] dtl:block:OptionCustomer [ ] --> .+?';
    my $FinishPattern = '</div>';

    # TODO replace the class Customer another class with the same effect but different name
    my $Replace = <<'END';
    <a  href="#" id="OptionFAQ">[ $Text{"FAQ"} ]</a>

<!--dtl:js_on_document_complete-->
<script type="text/javascript">//<![CDATA[
$('#OptionFAQ').bind('click', function (event) {
    var FAQIFrame = '<iframe class="TextOption Customer" src="' + Core.Config.Get('CGIHandle') + '?Action=AgentFAQExplorer;Nav=None;Subject=;What="></iframe>';
    Core.UI.Dialog.ShowContentDialog(FAQIFrame, '', '10px', 'Center', true);
    return false;
});
//]]></script>
<!--dtl:js_on_document_complete-->

    </div>
END

    ${ $Param{Data} } =~ s{ ($StartPattern) $FinishPattern }{$1$Replace}ixms;

    return 1;
}

1;
