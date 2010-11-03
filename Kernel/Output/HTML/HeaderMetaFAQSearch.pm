# --
# Kernel/Output/HTML/HeaderMetaFAQSearch.pm
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# --
# $Id: HeaderMetaFAQSearch.pm,v 1.5 2010-11-03 20:16:20 cr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::Output::HTML::HeaderMetaFAQSearch;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.5 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get needed objects
    for (qw(ConfigObject LogObject LayoutObject TimeObject)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $Session = '';
    if ( !$Self->{LayoutObject}->{SessionIDCookie} ) {
        $Session = ';' . $Self->{LayoutObject}->{SessionName} . '='
            . $Self->{LayoutObject}->{SessionID};
    }
    my $Title = $Self->{ConfigObject}->Get('ProductName');
    $Title .= '(' . $Self->{ConfigObject}->Get('FAQ::FAQHook') . ')';
    $Self->{LayoutObject}->Block(
        Name => 'MetaLink',
        Data => {
            Rel   => 'search',
            Type  => 'application/opensearchdescription+xml',
            Title => $Title,
            Href  => '$Env{"Baselink"}Action=' . $Param{Config}->{Action}
                . ';Subaction=OpenSearchDescriptionFAQNumber' . $Session,
        },
    );

    my $Fulltext = $Self->{LayoutObject}->{LanguageObject}->Get('FAQFulltext');
    $Title = $Self->{ConfigObject}->Get('ProductName');
    $Title .= '(' . $Fulltext . ')';
    $Self->{LayoutObject}->Block(
        Name => 'MetaLink',
        Data => {
            Rel   => 'search',
            Type  => 'application/opensearchdescription+xml',
            Title => $Title,
            Href  => '$Env{"Baselink"}Action=' . $Param{Config}->{Action}
                . ';Subaction=OpenSearchDescriptionFulltext' . $Session,
        },
    );
    return 1;
}

1;
