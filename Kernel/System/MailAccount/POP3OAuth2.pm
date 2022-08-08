# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019–2021 Efflux GmbH, https://efflux.de/
# Copyright (C) 2019-2021 Rother OSS GmbH, https://otobo.de/
# --
# This program is free software: you can redistribute it and/or modify it under
# the terms of the GNU General Public License as published by the Free Software
# Foundation, either version 3 of the License, or (at your option) any later version.
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
# You should have received a copy of the GNU General Public License
# along with this program. If not, see <https://www.gnu.org/licenses/>.
# --

package Kernel::System::MailAccount::POP3OAuth2;

use strict;
use warnings;

use Net::POP3;
use MIME::Base64;

use parent qw(Kernel::System::MailAccount::POP3);

our @ObjectDependencies = (
    'Kernel::System::Log',
    'Kernel::System::OAuth2::MailAccount',
);

# Use Net::SSLGlue::POP3 on systems with older Net::POP3 modules that cannot handle POP3.
BEGIN {
    if ( !defined &Net::POP3::starttls ) {
        ## nofilter(TidyAll::Plugin::OTOBO::Perl::Require)
        ## nofilter(TidyAll::Plugin::OTOBO::Perl::SyntaxCheck)
        require Net::SSLGlue::POP3;
    }
}

sub Connect {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(ID Login Password Host Timeout Debug)) {
        if ( !defined $Param{$_} ) {
            return (
                Successful => 0,
                Message    => "Need $_!",
            );
        }
    }

    my $Type = 'POP3OAuth2';

    # connect to host
    my $PopObject = Net::POP3->new(
        $Param{Host},
        Timeout => $Param{Timeout},
        Debug   => $Param{Debug},
    );

    if ( !$PopObject ) {
        return (
            Successful => 0,
            Message    => "$Type: Can't connect to $Param{Host}"
        );
    }

    $PopObject->starttls(
        SSL             => 1,
        SSL_verify_mode => 0,
    );

    # authentication
    my $AccessToken = $Kernel::OM->Get('Kernel::System::OAuth2::MailAccount')->GetAccessToken(
        MailAccountID => $Param{ID}
    );

    if ( !$AccessToken ) {
        return (
            Successful => 0,
            Message    => "$Type: Could not request access token for $Param{Login}/$Param{Host}'. The refresh token could be expired or invalid."
        );
    }

    my $SASLXOAUTH2 = encode_base64( 'user=' . $Param{Login} . "\x01auth=Bearer " . $AccessToken . "\x01\x01" );
    $PopObject->command( 'AUTH', 'XOAUTH2' )->response();
    my $NOM = $PopObject->command($SASLXOAUTH2)->response();

    if ( !defined $NOM ) {
        $PopObject->quit();
        return (
            Successful => 0,
            Message    => "$Type: Auth for user $Param{Login}/$Param{Host} failed!"
        );
    }

    return (
        Successful => 1,
        PopObject  => $PopObject,
        NOM        => $NOM,
        Type       => $Type,
    );
}

1;
