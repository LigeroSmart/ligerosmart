#!/usr/bin/perl
# --
# scripts/network-validator.pl - validate outbound network connectivity for all
# services used by this LigeroSmart installation (database, SMTP, POP3/IMAP,
# LDAP, Elasticsearch, HTTP/HTTPS integrations, package repositories, etc.).
#
# Run as the otrs user from the installation directory:
#   perl scripts/network-validator.pl [--timeout 5] [--category smtp,mail,ldap,...]
#
# Exit code: 0 if all checks pass, 1 if any check fails.
# See doc/NETWORK.md for the full list of required network accesses.
# --

use strict;
use warnings;

use File::Basename;
use FindBin qw($RealBin);
use lib dirname($RealBin);
use lib dirname($RealBin) . '/Kernel/cpan-lib';
use lib dirname($RealBin) . '/Custom';

use Getopt::Long;
use IO::Socket::INET;

my $Timeout    = 5;
my $Categories = '';
my $Help;
GetOptions(
    'timeout=i'  => \$Timeout,
    'category=s' => \$Categories,
    'help'       => \$Help,
);

if ($Help) {
    print <<"EOF";
Usage: perl scripts/network-validator.pl [options]

Validates that this server can reach every network service used by
LigeroSmart, based on the current system configuration.

Options:
  --timeout <sec>     Connection timeout per check (default: 5)
  --category <list>   Comma-separated list of categories to check.
                      Available: database, smtp, mail, oauth2, ldap,
                      elasticsearch, http, webservice, proxy
                      (default: all)
  --help              Show this help
EOF
    exit 0;
}

my %OnlyCategory = map { lc($_) => 1 } split /\s*,\s*/, $Categories;

# Optional modules (present on any working LigeroSmart install).
my $HasSSL = eval { require IO::Socket::SSL; 1 };
my $HasLWP = eval { require LWP::UserAgent;  1 };
my $HasURI = eval { require URI;             1 };

# Load the OTRS/LigeroSmart framework to read the live configuration.
eval {
    require Kernel::System::ObjectManager;
    1;
} or die "ERROR: Could not load the LigeroSmart framework from " . dirname($RealBin) . ": $@";

local $Kernel::OM = Kernel::System::ObjectManager->new(
    'Kernel::System::Log' => {
        LogPrefix => 'network-validator',
    },
);

my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

# ---------------------------------------------------------------------------
# Collect checks from the configuration.
# Each check: Category, Name, Host, Port, SSL (implicit TLS), URL (HTTP check)
# ---------------------------------------------------------------------------
my @Checks;

sub AddCheck {
    my %Check = @_;
    return if %OnlyCategory && !$OnlyCategory{ lc $Check{Category} };
    push @Checks, \%Check;
    return;
}

sub AddURLCheck {
    my ( $Category, $Name, $URL ) = @_;
    return if !$URL;
    my ( $Host, $Port, $SSL ) = ParseURL($URL);
    return if !$Host;
    AddCheck(
        Category => $Category,
        Name     => $Name,
        Host     => $Host,
        Port     => $Port,
        SSL      => $SSL,
        URL      => $URL,
    );
    return;
}

sub ParseURL {
    my ($URL) = @_;
    if ($HasURI) {
        my $URI = eval { URI->new($URL) };
        return if !$URI || !$URI->can('host') || !eval { $URI->host };
        return ( $URI->host, $URI->port, ( $URI->scheme // '' ) eq 'https' ? 1 : 0 );
    }
    if ( $URL =~ m{^(https?)://([^/:]+)(?::(\d+))?}i ) {
        my $SSL = lc($1) eq 'https' ? 1 : 0;
        return ( $2, $3 || ( $SSL ? 443 : 80 ), $SSL );
    }
    return;
}

# --- Database ---------------------------------------------------------------
{
    my $DSN  = $ConfigObject->Get('DatabaseDSN')  || '';
    my $Host = $ConfigObject->Get('DatabaseHost') || '';
    my $Port;
    if ( $DSN =~ m{port=(\d+)}i ) {
        $Port = $1;
    }
    elsif ( $DSN =~ m{DBI:mysql}i )  { $Port = 3306 }
    elsif ( $DSN =~ m{DBI:Pg}i )     { $Port = 5432 }
    elsif ( $DSN =~ m{DBI:Oracle}i ) { $Port = 1521; $Port = $1 if $DSN =~ m{//[^:/]+:(\d+)} }
    elsif ( $DSN =~ m{DBI:ODBC}i )   { $Port = 1433; $Port = $1 if $DSN =~ m{Server=[^,;]+,(\d+)}i }

    if ( $Host && $Port ) {
        AddCheck(
            Category => 'database',
            Name     => 'Database server',
            Host     => $Host,
            Port     => $Port,
        );
    }
}

# --- SMTP (outgoing mail) ---------------------------------------------------
{
    my $Module = $ConfigObject->Get('SendmailModule') || '';
    if ( $Module =~ m{SMTP}i ) {
        my $Host = $ConfigObject->Get('SendmailModule::Host');
        my $Port = $ConfigObject->Get('SendmailModule::Port');
        my $SSL  = 0;
        if ( $Module =~ m{SMTPS$} )   { $Port ||= 465; $SSL = 1 }
        elsif ( $Module =~ m{SMTPTLS$} ) { $Port ||= 587 }
        else                             { $Port ||= 25 }
        if ($Host) {
            AddCheck(
                Category => 'smtp',
                Name     => "Outgoing mail ($Module)",
                Host     => $Host,
                Port     => $Port,
                SSL      => $SSL,
            );
        }
        else {
            print "NOTE: SendmailModule is $Module but SendmailModule::Host is not set.\n";
        }
    }
}

# --- Mail accounts (POP3/IMAP fetch) ----------------------------------------
{
    my %TypePort = (
        POP3       => { Port => 110, SSL => 0 },
        POP3TLS    => { Port => 110, SSL => 0 },    # STARTTLS on the plain port
        POP3S      => { Port => 995, SSL => 1 },
        POP3OAuth2 => { Port => 995, SSL => 1 },
        IMAP       => { Port => 143, SSL => 0 },
        IMAPTLS    => { Port => 143, SSL => 0 },    # STARTTLS on the plain port
        IMAPS      => { Port => 993, SSL => 1 },
        IMAPOAuth2 => { Port => 993, SSL => 1 },
    );

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');
    if (
        $DBObject->Prepare(
            SQL => 'SELECT login, host, account_type FROM mail_account WHERE valid_id = 1',
        )
        )
    {
        while ( my @Row = $DBObject->FetchrowArray() ) {
            my ( $Login, $Host, $Type ) = @Row;
            my $Map = $TypePort{$Type};
            if ( !$Map ) {
                print "NOTE: Mail account $Login has unknown type '$Type', skipping.\n";
                next;
            }
            AddCheck(
                Category => 'mail',
                Name     => "Mail account $Login ($Type)",
                Host     => $Host,
                Port     => $Map->{Port},
                SSL      => $Map->{SSL},
            );
        }
    }
}

# --- OAuth2 token endpoints (Microsoft 365 / Google mail accounts) -----------
{
    my $Profiles  = $ConfigObject->Get('OAuth2::MailAccount::Profiles')  || {};
    my $Providers = $ConfigObject->Get('OAuth2::MailAccount::Providers') || {};
    my %UsedProviders;
    for my $Profile ( values %{$Profiles} ) {
        next if ref $Profile ne 'HASH' || !$Profile->{ProviderName};
        $UsedProviders{ $Profile->{ProviderName} } = 1;
    }
    for my $ProviderName ( sort keys %UsedProviders ) {
        my $Provider = $Providers->{$ProviderName};
        next if ref $Provider ne 'HASH';
        AddURLCheck( 'oauth2', "OAuth2 token endpoint ($ProviderName)", $Provider->{TokenURL} );
    }
}

# --- LDAP (agent auth, agent sync, customer auth, customer backend) ---------
{
    my @LDAPSources = (
        [ 'AuthModule::LDAP::Host',           'AuthModule::LDAP::Params',           'Agent LDAP auth' ],
        [ 'AuthSyncModule::LDAP::Host',       'AuthSyncModule::LDAP::Params',       'Agent LDAP sync' ],
        [ 'Customer::AuthModule::LDAP::Host', 'Customer::AuthModule::LDAP::Params', 'Customer LDAP auth' ],
    );
    my %SeenLDAP;
    for my $Source (@LDAPSources) {
        my ( $HostKey, $ParamsKey, $Label ) = @{$Source};
        for my $Suffix ( '', 1 .. 9 ) {
            my $Host = $ConfigObject->Get( $HostKey . $Suffix );
            next if !$Host;
            my $Params = $ConfigObject->Get( $ParamsKey . $Suffix ) || {};
            my $SSL    = $Host =~ s{^ldaps://}{}i ? 1 : 0;
            $Host =~ s{^ldap://}{}i;
            my $Port = $Params->{port} || ( $SSL ? 636 : 389 );
            if ( $Host =~ s{:(\d+)$}{} ) {
                $Port = $1;
            }
            next if $SeenLDAP{"$Host:$Port"}++;
            AddCheck(
                Category => 'ldap',
                Name     => "$Label$Suffix",
                Host     => $Host,
                Port     => $Port,
                SSL      => $SSL,
            );
        }
    }

    # CustomerUser backends using Net::LDAP.
    for my $Suffix ( '', 1 .. 9 ) {
        my $Backend = $ConfigObject->Get( 'CustomerUser' . $Suffix );
        next if ref $Backend ne 'HASH';
        next if ( $Backend->{Module} || '' ) !~ m{LDAP};
        my $Host = $Backend->{Params}->{Host};
        next if !$Host;
        my $SSL = $Host =~ s{^ldaps://}{}i ? 1 : 0;
        $Host =~ s{^ldap://}{}i;
        my $Port = $Backend->{Params}->{Params}->{port} || ( $SSL ? 636 : 389 );
        if ( $Host =~ s{:(\d+)$}{} ) {
            $Port = $1;
        }
        next if $SeenLDAP{"$Host:$Port"}++;
        AddCheck(
            Category => 'ldap',
            Name     => "Customer backend CustomerUser$Suffix (LDAP)",
            Host     => $Host,
            Port     => $Port,
            SSL      => $SSL,
        );
    }
}

# --- Elasticsearch (LigeroSmart search engine) --------------------------------
{
    my $LigeroSmart = $ConfigObject->Get('LigeroSmart') || {};
    my $Nodes       = $LigeroSmart->{Nodes}             || [];
    for my $Node ( @{$Nodes} ) {
        my ( $Host, $Port, $SSL ) = ( $Node, 9200, 0 );
        if ( $Node =~ m{^https?://} ) {
            ( $Host, $Port, $SSL ) = ParseURL($Node);
        }
        elsif ( $Node =~ m{^([^:/]+)(?::(\d+))?} ) {
            ( $Host, $Port ) = ( $1, $2 || 9200 );
        }
        next if !$Host;
        AddCheck(
            Category => 'elasticsearch',
            Name     => "Elasticsearch node $Node",
            Host     => $Host,
            Port     => $Port,
            SSL      => $SSL,
        );
    }
}

# --- HTTP/HTTPS: LigeroSmart services, package repositories, dashboard RSS ---
{
    my %SeenHTTP;

    my $AddHTTPCheck = sub {
        my ( $Name, $URL ) = @_;
        my ( $Host, $Port ) = ParseURL($URL);
        return if !$Host || $SeenHTTP{"$Host:$Port"}++;
        AddURLCheck( 'http', $Name, $URL );
    };

    my $RepositoryList = $ConfigObject->Get('Package::RepositoryList') || {};
    for my $URL ( sort keys %{$RepositoryList} ) {
        my ( $Host, $Port ) = ParseURL($URL);
        next if !$Host;
        $AddHTTPCheck->( "Package repository ($Host)", $URL );
    }
    my $RepositoryRoot = $ConfigObject->Get('Package::RepositoryRoot') || [];
    for my $URL ( @{$RepositoryRoot} ) {
        $AddHTTPCheck->( 'Package repository root', $URL );
    }

    # Dashboard RSS backends (any enabled backend with a URL).
    my $Backends = $ConfigObject->Get('DashboardBackend') || {};
    for my $Key ( sort keys %{$Backends} ) {
        my $Backend = $Backends->{$Key};
        next if ref $Backend ne 'HASH' || !$Backend->{URL};
        next if ( $Backend->{Module} || '' ) !~ m{RSS}i;
        $AddHTTPCheck->( "Dashboard RSS ($Key)", $Backend->{URL} );
    }

    # LigeroSmart online services - always checked, even when not present in
    # the deployed configuration (package repository and dashboard news).
    $AddHTTPCheck->( 'LigeroSmart add-ons repository', 'https://addons.ligerosmart.org/6' );
    $AddHTTPCheck->( 'LigeroSmart news (RSS)',         'https://news.ligerosmart.org/rss/en_US' );
}

# --- GenericInterface web services (requester endpoints) ---------------------
{
    my $WebserviceObject = $Kernel::OM->Get('Kernel::System::GenericInterface::Webservice');
    my $List             = $WebserviceObject->WebserviceList( Valid => 1 ) || {};
    WEBSERVICE:
    for my $ID ( sort keys %{$List} ) {
        my $Webservice = $WebserviceObject->WebserviceGet( ID => $ID );
        next WEBSERVICE if !$Webservice;
        my $TransportConfig = $Webservice->{Config}->{Requester}->{Transport}->{Config};
        next WEBSERVICE if ref $TransportConfig ne 'HASH';
        my $Endpoint = $TransportConfig->{Host} || $TransportConfig->{Endpoint};
        next WEBSERVICE if !$Endpoint;
        AddURLCheck( 'webservice', "Web service '$Webservice->{Name}'", $Endpoint );
    }
}

# --- Proxy -------------------------------------------------------------------
{
    for my $Key (qw(WebUserAgent::Proxy Package::Proxy)) {
        my $Proxy = $ConfigObject->Get($Key);
        next if !$Proxy;
        AddURLCheck( 'proxy', "Proxy ($Key)", $Proxy );
    }
}

# ---------------------------------------------------------------------------
# Run the checks.
# ---------------------------------------------------------------------------
if ( !@Checks ) {
    print "No network checks to run for the selected categories.\n";
    exit 0;
}

if ( !$HasSSL ) {
    print "NOTE: IO::Socket::SSL not available - TLS handshakes will be skipped (plain TCP only).\n";
}

my $UserAgent;
if ($HasLWP) {
    $UserAgent = LWP::UserAgent->new(
        timeout  => $Timeout,
        agent    => 'LigeroSmart-network-validator',
        max_redirect => 3,
    );
    my $Proxy = $ConfigObject->Get('WebUserAgent::Proxy');
    $UserAgent->proxy( [ 'http', 'https' ], $Proxy ) if $Proxy;
    if ( $ConfigObject->Get('WebUserAgent::DisableSSLVerification') ) {
        $UserAgent->ssl_opts( verify_hostname => 0, SSL_verify_mode => 0 );
    }
}

sub CheckTCP {
    my ($Check) = @_;
    my $Socket = IO::Socket::INET->new(
        PeerAddr => $Check->{Host},
        PeerPort => $Check->{Port},
        Proto    => 'tcp',
        Timeout  => $Timeout,
    );
    return ( 0, $! || 'connection failed' ) if !$Socket;

    if ( $Check->{SSL} && $HasSSL ) {
        if ( !IO::Socket::SSL->start_SSL( $Socket, SSL_verify_mode => 0, Timeout => $Timeout ) ) {
            return ( 0, 'TCP OK but TLS handshake failed: ' . ( IO::Socket::SSL::errstr() || 'unknown' ) );
        }
    }
    $Socket->close();
    return ( 1, $Check->{SSL} && $HasSSL ? 'TCP + TLS OK' : 'TCP OK' );
}

sub CheckHTTP {
    my ($Check) = @_;
    return if !$UserAgent || !$Check->{URL};
    my $Response = $UserAgent->head( $Check->{URL} );
    if ( $Response->code == 405 || $Response->code == 501 ) {
        $Response = $UserAgent->get( $Check->{URL} );
    }
    my $Status = $Response->code . ' ' . $Response->message;
    # Any HTTP status means the server was reached; only transport-level
    # errors (LWP internal 5xx with Client-Warning) count as failures.
    if ( $Response->header('Client-Warning') && $Response->header('Client-Warning') eq 'Internal response' ) {
        return ( 0, $Status );
    }
    return ( 1, "HTTP $Status" );
}

my $NameWidth = 20;
for my $Check (@Checks) {
    my $Length = length $Check->{Name};
    $NameWidth = $Length if $Length > $NameWidth;
}

my $Failed = 0;
my $LastCategory = '';
for my $Check (@Checks) {
    if ( $Check->{Category} ne $LastCategory ) {
        printf "\n[%s]\n", uc $Check->{Category};
        $LastCategory = $Check->{Category};
    }

    my ( $OK, $Detail );
    if ( $Check->{URL} && $UserAgent ) {
        ( $OK, $Detail ) = CheckHTTP($Check);
    }
    ( $OK, $Detail ) = CheckTCP($Check) if !defined $OK;

    printf "  %-6s %-${NameWidth}s  %s:%s  (%s)\n",
        $OK ? 'OK' : 'FAIL',
        $Check->{Name},
        $Check->{Host},
        $Check->{Port},
        $Detail;
    $Failed++ if !$OK;
}

my $Total = scalar @Checks;
printf "\n%d/%d checks passed.\n", $Total - $Failed, $Total;
if ($Failed) {
    print "Some services are unreachable. See doc/NETWORK.md for the firewall rules required by LigeroSmart.\n";
    exit 1;
}
exit 0;
