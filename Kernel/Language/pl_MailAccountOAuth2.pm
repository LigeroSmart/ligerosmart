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

package Kernel::Language::pl_MailAccountOAuth2;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AdminMailAccount
    $Self->{Translation}->{'Profiles'} = 'Profile';
    $Self->{Translation}->{'Profiles can be specified in the system configuration under the setting "OAuth2::MailAccount::Profiles".'} = 'Ustawienia profili znajdują się w Konfiguracji Systemu pod nazwą "OAuth2::MailAccount::Profiles".';

    # SysConfig
    $Self->{Translation}->{'Configure custom OAuth 2 application profiles. "Name" should be unique and will be displayed on the Mail Account Management screen. "ProviderName" can be "MicrosoftAzure", "GoogleWorkspace" or a custom provider like "Custom1" (see OAuth2::MailAccount::Providers).'} = 'Ustawienia profili OAuth 2. Parametr "Name" musi mieć wartość unikatową i będzie wyświetlany na ekranie Kont pocztowych. Parametr "ProviderName" może przyjąć wartość "MicrosoftAzure", "GoogleWorkspace" lub inną (patrz OAuth2::MailAccount::Providers).';
    $Self->{Translation}->{'Custom authorization server settings.'} = 'Ustawienia serwera autoryzacji.';
}

1;
