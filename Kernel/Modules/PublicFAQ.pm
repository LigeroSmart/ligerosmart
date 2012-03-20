# --
# Kernel/Modules/PublicFAQ.pm - This module redirects to PublicFAQZoom
# Copyright (C) 2001-2012 OTRS AG, http://otrs.org/
# --
# $Id: PublicFAQ.pm,v 1.15 2012-03-20 14:45:22 ub Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::PublicFAQ;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.15 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check needed objects
    for (qw(ParamObject DBObject LayoutObject LogObject ConfigObject )) {
        if ( !$Self->{$_} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $_!" );
        }
    }

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $Redirect = $ENV{REQUEST_URI};

    if ($Redirect) {
        $Redirect =~ s{PublicFAQ}{PublicFAQZoom}xms;
    }
    else {
        $Redirect = $Self->{LayoutObject}->{Baselink}
            . 'Action=PublicFAQZoom;ItemID='
            . $Self->{ParamObject}->GetParam( Param => 'ItemID' );
    }

    return $Self->{LayoutObject}->Redirect(
        OP => $Redirect,
    );
}

1;
