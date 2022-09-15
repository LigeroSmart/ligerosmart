# --
# OTOBO is a web-based ticketing system for service organisations.
# --
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

package Kernel::System::OAuth2;

use strict;
use warnings;

use URI;
use URI::QueryParam;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Cache',
    'Kernel::System::DB',
    'Kernel::System::JSON',
    'Kernel::System::Log',
    'Kernel::System::MailAccount',
    'Kernel::System::Main',
    'Kernel::System::WebUserAgent',
);

=head1 NAME

Kernel::System::OAuth2 - to authenticate

=head1 DESCRIPTION

Global module to authenticate accounts via OAuth 2.0.

=head1 PUBLIC INTERFACE

=head2 new()

Don't use the constructor directly, use the ObjectManager instead:

    my $OAuth2Object = $Kernel::OM->Get('Kernel::System::OAuth2');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    my $Self = {};
    bless( $Self, $Type );

    $Self->{CacheType}  = 'OAuth2';
    $Self->{TokenTable} = 'auth_token';

    return $Self;
}

=head2 BuildAuthURL()

Build the URL to request an authorization code.

Example:
    my $AuthURL = $OAuth2Object->BuildAuthURL(
        Host         => $ProviderType->{Host},
        Scope        => $ProviderType->{Scope},
        ClientID     => $Profile->{ClientID},
        ClientSecret => $Profile->{ClientSecret},
        BaseAuthURL  => $Provider->{AuthURL},
        Login        => $Param{Login},
    );

Returns:
    $AuthURL = https://login.microsoftonline.com/common/oauth2/v2.0/authorize?client_id=077d2059-219...

=cut

sub BuildAuthURL {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(Host Scope ClientID ClientSecret BaseAuthURL Login)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!"
            );
            return;
        }
    }

    my $Config = $Kernel::OM->Get('Kernel::Config')->Get('OAuth2::Settings');

    # Create a random string to prevent cross-site requests.
    my $RandomString = $Kernel::OM->Get('Kernel::System::Main')->GenerateRandomString(
        Length => $Config->{StateNonceLength} || 22,
    );

    # Save all MailAccountAdd() parameters to use after successful authorization.
    $Kernel::OM->Get('Kernel::System::Cache')->Set(
        Type  => $Self->{CacheType},
        TTL   => $Config->{StateNonceTTL} || 60 * 15,
        Key   => "OAuth2State::$RandomString",
        Value => \%Param,
    );

    my $URL = URI->new( $Param{BaseAuthURL} );
    $URL->query_param_append( 'client_id',     $Param{ClientID} );
    $URL->query_param_append( 'response_type', 'code' );
    $URL->query_param_append( 'scope',         $Param{Scope} );
    $URL->query_param_append( 'response_mode', 'query' );
    $URL->query_param_append( 'state',         $RandomString );
    $URL->query_param_append( 'login_hint',    $Param{Login} );

    return $URL->as_string;
}

=head2 _RequestAccessToken()

This can either be used to request an initial access and refresh token or to request a new access token.

Example:
    my %Response = $Self->_RequestAccessToken(
        URL          => 'https://login.microsoftonline.com/common/oauth2/v2.0/token',
        ClientSecret => $SecretValue,
        Scope        => 'offline_access https://outlook.office.com/IMAP.AccessAsUser.All',
        ClientID     => $ClientID,
        GrantType    => 'refresh_token',
        AccountType  => 'MailAccount',
        AccountID    => 'max@mail.de',
        Code         => $Code,    # Optional: Only needed in combination with GrantType "authorization_code".
    )

Returns:
    %Response = (
        'refresh_token'  => '123...',
        'access_token'   => '098...',
        'ext_expires_in' => 3599,
        'token_type'     => 'Bearer',
        'expires_in'     => 3599,
        'scope'          => 'https://outlook.office.com/IMAP.AccessAsUser.All'
    )

=cut

sub _RequestAccessToken {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(URL Scope ClientID ClientSecret GrantType AccountType AccountID)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!"
            );
            return;
        }
    }

    my %Data = (
        client_id     => $Param{ClientID},
        client_secret => $Param{ClientSecret},
        scope         => $Param{Scope},
        grant_type    => $Param{GrantType},
    );

    my $DBObject;
    my $RefreshToken;

    # Add optional parameters.
    if ( $Param{Code} && $Param{GrantType} eq 'authorization_code' ) {
        $Data{code} = $Param{Code};
    }
    elsif ( $Param{GrantType} eq 'refresh_token' ) {

        $DBObject = $Kernel::OM->Get('Kernel::System::DB');

        my $SQL = "SELECT token FROM $Self->{TokenTable} WHERE "
            . "account_type = LOWER(?) AND account_id = ? AND token_type = 'refresh'";

        return if !$DBObject->Prepare(
            SQL   => $SQL,
            Bind  => [ \$Param{AccountType}, \$Param{AccountID} ],
            Limit => 1,
        );

        while ( my @Row = $DBObject->FetchrowArray() ) {
            $RefreshToken = $Row[0];
        }

        if ( !$RefreshToken ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "No refresh token found for $Param{AccountType}: '$Param{AccountID}'!"
            );
            return;
        }

        $Data{refresh_token} = $RefreshToken;
    }
    else {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need GrantType authorization_code and the Code, or GrantType refresh_token!',
        );
        return;
    }

    my %Response = $Kernel::OM->Get('Kernel::System::WebUserAgent')->Request(
        URL  => $Param{URL},
        Type => 'POST',
        Data => \%Data,
    );

    # Server did not accept the request.
    if ( $Response{Status} ne '200 OK' ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Got: '$Response{Status}'!",
        );
        return;
    }

    my $ResponseData = $Kernel::OM->Get('Kernel::System::JSON')->Decode(
        Data => ${ $Response{Content} }
    );

    if ( exists $ResponseData->{error} || exists $ResponseData->{error_description} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => $ResponseData->{error} . ': ' . $ResponseData->{error_description},
        );
        return;
    }

    # Should not happen if no error message given.
    if ( !$ResponseData->{access_token} || !$ResponseData->{refresh_token} || !$ResponseData->{expires_in} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Host did not provide "access_token", "refresh_token" or "expires_in"!',
        );
        return;
    }

    # renew refresh token if necessary
    if ( !$RefreshToken || $RefreshToken ne $ResponseData->{refresh_token} ) {
        $DBObject //= $Kernel::OM->Get('Kernel::System::DB');

        # delete old data
        return if !$DBObject->Do(
            SQL => "DELETE FROM $Self->{TokenTable} WHERE "
                . "account_type = LOWER(?) AND account_id = ? AND token_type = 'refresh'",
            Bind => [ \$Param{AccountType}, \$Param{AccountID} ],
        );

        # insert new data
        return if !$DBObject->Do(
            SQL => "INSERT INTO $Self->{TokenTable} (token, account_type, account_id, token_type) "
                . "VALUES (?, ?, ?, 'refresh')",
            Bind => [ \$ResponseData->{refresh_token}, \$Param{AccountType}, \$Param{AccountID} ],
        );
    }

    return %{$ResponseData};
}

=head2 _DeleteToken()

Delete tokens.

    my $Success = $OAuth2Object->DeleteToken(
        AccountType => 'MailAccount',
        AccountID   => $ID,
        TokenType   => 'refresh', #optional
    );

=cut

sub _DeleteToken {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(AccountType AccountID)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!"
            );
            return;
        }
    }

    if ( $Param{TokenType} ) {
        return if !$Kernel::OM->Get('Kernel::System::DB')->Do(
            SQL  => "DELETE FROM $Self->{TokenTable} WHERE account_type = ? AND account_id = ? AND token_type = ?",
            Bind => [ \$Param{AccountType}, \$Param{AccountID}, \$Param{TokenType} ],
        );
    }
    else {
        return if !$Kernel::OM->Get('Kernel::System::DB')->Do(
            SQL  => "DELETE FROM $Self->{TokenTable} WHERE account_type = ? AND account_id = ?",
            Bind => [ \$Param{AccountType}, \$Param{AccountID} ],
        );
    }

    return 1;
}

1;
