# --
# Kernel/Output/HTML/OutputFilterFAQPre.pm - Output filter "Pre" for FAQ module
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# --
# $Id: OutputFilterFAQPre.pm,v 1.1 2010-12-09 19:20:24 cr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::OutputFilterFAQPre;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.1 $';
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
        = $Self->{ConfigObject}->Get('Frontend::Output::FilterElement')->{FAQ};

    # check template name
    return if !$ValidTemplates->{ $Param{TemplateFile} };

    # add Javascript outsise TicketOptions block (no matter if the block is called or not)
    my $StartPattern = '<!-- [ ] OutputFilterHook_NoTicketOptionsFallback [ ] --> .+?';

    my $Replace = <<'END';

<!-- OutputFilterHook_NoTicketOptionsFallback -->
<!--dtl:js_on_document_complete-->
<script type="text/javascript">//<![CDATA[
$('#OptionFAQ').bind('click', function (event) {
    var FAQIFrame = '<iframe class="TextOption Customer" src="' + Core.Config.Get('CGIHandle') + '?Action=AgentFAQExplorer;Nav=None;Subject=;What="></iframe>';
    Core.UI.Dialog.ShowContentDialog(FAQIFrame, '', '10px', 'Center', true);
    return false;
});
//]]></script>
<!--dtl:js_on_document_complete-->
END
    ${ $Param{Data} } =~ s{ ($StartPattern) }{$Replace}ixms;

    return 1;
}

1;
