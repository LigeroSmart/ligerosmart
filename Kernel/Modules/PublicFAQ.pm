# --
# Kernel/Modules/PublicFAQ.pm - This module redirects to PublicFAQZoom
# Copyright (C) 2001-2012 OTRS AG, http://otrs.org/
# --
# $Id: PublicFAQ.pm,v 1.17 2012-11-19 14:44:36 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.
# --

package Kernel::Modules::PublicFAQ;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.17 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check needed objects
    for my $Object (qw(ParamObject DBObject LayoutObject LogObject ConfigObject )) {
        if ( !$Self->{$Object} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $Object!" );
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
