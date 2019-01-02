# --
# Copyright (C) 2001-2019 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Modules::PublicFAQ;

use strict;
use warnings;

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $Redirect = $ENV{REQUEST_URI};

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    if ($Redirect) {
        $Redirect =~ s{PublicFAQ}{PublicFAQZoom}xms;
    }
    else {
        $Redirect = $LayoutObject->{Baselink}
            . 'Action=PublicFAQZoom;ItemID='
            . $Kernel::OM->Get('Kernel::System::Web::Request')->GetParam( Param => 'ItemID' );
    }

    return $LayoutObject->Redirect(
        OP => $Redirect,
    );
}

1;
