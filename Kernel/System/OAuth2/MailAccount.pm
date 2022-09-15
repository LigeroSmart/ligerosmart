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

package Kernel::System::OAuth2::MailAccount;

use strict;
use warnings;

use parent 'Kernel::System::OAuth2';

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Cache',
    'Kernel::System::JSON',
    'Kernel::System::Log',
    'Kernel::System::MailAccount',
    'Kernel::System::WebUserAgent',
);

=head1 NAME

Kernel::System::OAuth2::MailAccount - to authenticate

=head1 DESCRIPTION

Global module to authenticate accounts via OAuth 2.0.

=head1 PUBLIC INTERFACE

=head2 new()

Don't use the constructor directly, use the ObjectManager instead:

    my $OAuth2Object = $Kernel::OM->Get('Kernel::System::OAuth2::MailAccount');

=cut

# execute Kernel::System::OAuth2->new()

=head2 GetAuthURL()

Build the URL to request an authorization code.

Example:
    my $AuthURL = $OAuth2Object->GetAuthURL(
        Login   => princess@leia.org
        UserID  => $Self->{UserID},
        Profile => 'Custom1'
    );

Returns:
    $AuthURL = https://login.microsoftonline.com/common/oauth2/v2.0/authorize?client_id=077d2059-219...

=cut

sub GetAuthURL {
    my ( $Self, %Param ) = @_;

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my $LogObject    = $Kernel::OM->Get('Kernel::System::Log');

    for my $Needed (qw(Login UserID Profile)) {
        if ( !$Param{$Needed} ) {
            $LogObject->Log(
                Priority => 'error',
                Message  => "Need $Needed!"
            );
            return;
        }
    }

    my $Profiles  = $ConfigObject->Get('OAuth2::MailAccount::Profiles')  || {};
    my $Providers = $ConfigObject->Get('OAuth2::MailAccount::Providers') || {};

    my $Profile  = $Profiles->{ $Param{Profile} };
    my $Provider = $Providers->{ $Profile->{ProviderName} };

    my $TypeWithoutOAuth = $Param{Type};
    $TypeWithoutOAuth =~ s/OAuth2//g;

    my $ProviderType = $Provider->{$TypeWithoutOAuth};

    # Fill needed parameters for the access token request.
    return $Self->BuildAuthURL(
        %Param,
        Host         => $ProviderType->{Host},
        Scope        => $ProviderType->{Scope},
        ClientID     => $Profile->{ClientID},
        ClientSecret => $Profile->{ClientSecret},
        BaseAuthURL  => $Provider->{AuthURL},
        TokenURL     => $Provider->{TokenURL},
    );
}

=head2 MailAccountProcess()

Creates a mail account by taking the authorization code and requesting a refresh and access token.

Example:
    my $MailAccountID = $OAuth2Object->MailAccountProcess(
        state => "24099",
        code  => "0.ATwAPR__xfVMxEGhyMk8RL4...",
    )

=cut

sub MailAccountProcess {
    my ( $Self, %Param ) = @_;

    my $Error = { Success => 0 };

    for my $Needed (qw(state code)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!"
            );
            return $Error;
        }
    }

    my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

    # Get the mail account params set by BuildAuthURL().
    my $CacheKey         = 'OAuth2State::' . $Param{state};
    my $MailAccountParam = $CacheObject->Get(
        Type => $Self->{CacheType},
        Key  => $CacheKey,
    );

    if ( !$MailAccountParam ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Authorization took too long (no cache found).',
        );
        return $Error;
    }

    # Can only be used once to prevent resends by refreshes.
    $CacheObject->Delete(
        Type => $Self->{CacheType},
        Key  => $CacheKey,
    );

    my $MailAccountID;
    if ( $MailAccountParam->{Task} eq 'Add' ) {
        $MailAccountID = $Kernel::OM->Get('Kernel::System::MailAccount')->MailAccountAdd( %{$MailAccountParam} );
    }
    elsif ( $MailAccountParam->{Task} eq 'Update' ) {
        $MailAccountID = $MailAccountParam->{ID};
    }
    return $Error if !$MailAccountID;

    # Get an access and refresh token.
    my %Response = $Self->_RequestAccessToken(
        URL          => $MailAccountParam->{TokenURL},
        ClientID     => $MailAccountParam->{ClientID},
        ClientSecret => $MailAccountParam->{ClientSecret},
        Scope        => $MailAccountParam->{Scope},
        Code         => $Param{code},
        GrantType    => 'authorization_code',
        AccountType  => 'MailAccount',
        AccountID    => $MailAccountID,
    );

    if ( !%Response ) {
        if ( $MailAccountParam->{Task} eq 'Add' ) {
            $Kernel::OM->Get('Kernel::System::MailAccount')->MailAccountDelete( ID => $MailAccountID );
        }
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Could not request access token',
        );

        return $Error;
    }

    if ( $MailAccountParam->{Task} eq 'Update' && $MailAccountParam->{ID} ) {
        return $Error if !$Kernel::OM->Get('Kernel::System::MailAccount')->MailAccountUpdate( %{$MailAccountParam} );
    }

    # Cache the access token until it expires.
    $CacheObject->Set(
        Type           => $Self->{CacheType},
        TTL            => ( $Response{expires_in} - 90 ),               # Add a buffer for latency reasons.
        Key            => "AccessToken::MailAccount::$MailAccountID",
        Value          => $Response{access_token},
        CacheInMemory  => 0,                                            # Cache in Backend only to enforce TTL
        CacheInBackend => 1,
    );

    return {
        Success => 1,
        Task    => $MailAccountParam->{Task},
    };
}

=head2 GetAccessToken()

Request a new access token for an account.

Example:
    my $AccessToken = $OAuth2Object->GetAccessToken(
        MailAccountID => 1,
    )

=cut

sub GetAccessToken {
    my ( $Self, %Param ) = @_;

    if ( !$Param{MailAccountID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need MailAccountID!"
        );
        return;
    }

    my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

    # Try the cache
    my $Token = $CacheObject->Get(
        Type => $Self->{CacheType},
        Key  => "AccessToken::MailAccount::$Param{MailAccountID}",
    );

    return $Token if $Token;

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    my $Profiles    = $ConfigObject->Get('OAuth2::MailAccount::Profiles')  || {};
    my $Providers   = $ConfigObject->Get('OAuth2::MailAccount::Providers') || {};
    my %MailAccount = $Kernel::OM->Get('Kernel::System::MailAccount')->MailAccountGet(
        ID => $Param{MailAccountID}
    );

    my $Profile          = $Profiles->{ $MailAccount{Profile} };
    my $Provider         = $Providers->{ $Profile->{ProviderName} };
    my $TypeWithoutOAuth = $MailAccount{Type};
    $TypeWithoutOAuth =~ s/OAuth2//g;

    my $ProviderType = $Provider->{$TypeWithoutOAuth};

    # Get an access and refresh token.
    my %Response = $Self->_RequestAccessToken(
        URL          => $Provider->{TokenURL},
        ClientID     => $Profile->{ClientID},
        ClientSecret => $Profile->{ClientSecret},
        Scope        => $ProviderType->{Scope},
        GrantType    => 'refresh_token',
        AccountType  => 'MailAccount',
        AccountID    => $MailAccount{ID},
    );
    return if !%Response;

    $Kernel::OM->Get('Kernel::System::Cache')->Set(
        Type  => $Self->{CacheType},
        TTL   => ( $Response{expires_in} - 90 ),                     # Add a buffer for latency reasons.
        Key   => "AccesToken::MailAccount::$Param{MailAccountID}",
        Value => $Response{access_token},
    );

    return $Response{access_token};
}

=head2 GetProfiles()

Return an array ref with profiles that can be selected in the mail account creation.

Example:
    my $Profiles = $OAuth2ObjectGetProfiles();

Returns:
    $Profiles = (
        [
            Key   => 'Custom1',
            Value => 'contoso.com (MicrosoftAzure)'
        ],
        [
            Key   => 'Custom2',
            Value => 'google.com (Google Workspace)'
        ],
    );

=cut

sub GetProfiles {
    my ( $Self, %Param ) = @_;

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    my $Profiles  = $ConfigObject->Get('OAuth2::MailAccount::Profiles')  || {};
    my $Providers = $ConfigObject->Get('OAuth2::MailAccount::Providers') || {};

    my @ProfileList = ();

    # Validate provider name set by the user in the system configuration.
    for my $Profile ( keys %{$Profiles} ) {
        my $ProviderName = $Profiles->{$Profile}->{ProviderName};
        if ( $Providers->{$ProviderName} ) {
            push @ProfileList, {
                Value => $Profiles->{$Profile}->{Name} . ' (' . $ProviderName . ')',
                Key   => $Profile
            };
        }
    }

    return \@ProfileList;
}

=head2 DeleteToken()

Delete tokens.

    my $Success = $OAuth2Object->DeleteToken(
        ID => $ID,
    );

=cut

sub DeleteToken {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(ID)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!"
            );
            return;
        }
    }

    return $Self->_DeleteToken(
        AccountID   => $Param{ID},
        AccountType => 'MailAccount',
    );
}

1;
