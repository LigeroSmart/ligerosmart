# --
# Kernel/Output/HTML/CustomerHeaderMetaFAQSearch.pm
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: CustomerHeaderMetaFAQSearch.pm,v 1.2 2011-10-08 17:55:21 cr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::CustomerHeaderMetaFAQSearch;

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

    # build open search description for FAQ number
    my $Title = $Self->{ConfigObject}->Get('ProductName');

    $Title .= ' - Customer (' . $Self->{ConfigObject}->Get('FAQ::FAQHook') . ')';
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

    # build open search description for FAQ fulltext
    my $Fulltext = $Self->{LayoutObject}->{LanguageObject}->Get('FAQFulltext');
    $Title = $Self->{ConfigObject}->Get('ProductName');
    $Title .= ' - Customer (' . $Fulltext . ')';
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
