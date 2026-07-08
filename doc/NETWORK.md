# LigeroSmart — Network Access Requirements

This document is aimed at **network and firewall administrators**. It lists every
network flow required for a LigeroSmart server to work fully, so the proper
firewall/proxy rules can be created.

All hostnames and ports below reflect the defaults or the places where they are
configured. After the rules are in place, connectivity can be verified from the
application server with:

```bash
perl scripts/network-validator.pl
```

The script reads the live system configuration (SysConfig + database) and tests
every endpoint actually configured on the installation.

## 1. Inbound (clients → LigeroSmart server)

| Port | Protocol | Purpose |
|------|----------|---------|
| 80/TCP | HTTP | Agent/customer web interface (redirect to HTTPS recommended) |
| 443/TCP | HTTPS | Agent/customer web interface, GenericInterface web services **provided** by LigeroSmart (`nph-genericinterface.pl`), REST/SOAP API consumed by third-party systems |
| 25/TCP | SMTP | Only if inbound e-mail is delivered directly to a local MTA on this server (PostMaster filter via sendmail pipe). Not needed when mail is fetched via POP3/IMAP |

## 2. Outbound (LigeroSmart server → other services)

### 2.1 Database (mandatory)

Configured in `Kernel/Config.pm` (`DatabaseHost`, `DatabaseDSN`).

| Destination | Port | Notes |
|-------------|------|-------|
| Database server | 3306/TCP (MySQL/MariaDB) | Default backend |
| | 5432/TCP (PostgreSQL) | Alternative backend |
| | 1521/TCP (Oracle) / 1433/TCP (SQL Server) | Alternative backends |

### 2.2 Outgoing e-mail (SMTP)

Configured in SysConfig: `SendmailModule`, `SendmailModule::Host`,
`SendmailModule::Port`. Typical relays: `smtp.gmail.com`,
`smtp.office365.com`, or a corporate relay.

| Module | Port | Encryption |
|--------|------|-----------|
| `Kernel::System::Email::SMTP` | 25/TCP | none |
| `Kernel::System::Email::SMTPTLS` | 587/TCP | STARTTLS (Gmail/Office 365 recommended) |
| `Kernel::System::Email::SMTPS` | 465/TCP | implicit TLS |

### 2.3 Incoming e-mail fetch (POP3/IMAP)

Configured per account in **Admin → PostMaster Mail Accounts** (stored in the
`mail_account` table). Typical hosts: `imap.gmail.com`, `pop.gmail.com`,
`outlook.office365.com`.

| Account type | Port | Encryption |
|--------------|------|-----------|
| POP3 / POP3TLS | 110/TCP | none / STARTTLS |
| POP3S / POP3OAuth2 | 995/TCP | implicit TLS |
| IMAP / IMAPTLS | 143/TCP | none / STARTTLS |
| IMAPS / IMAPOAuth2 | 993/TCP | implicit TLS |

### 2.4 OAuth2 token endpoints (Microsoft 365 / Google mail accounts)

Required only when mail accounts use the `*OAuth2` types
(SysConfig `OAuth2::MailAccount::Providers` / `OAuth2::MailAccount::Profiles`).

| Destination | Port | Purpose |
|-------------|------|---------|
| `login.microsoftonline.com` | 443/TCP | Microsoft Azure / Office 365 OAuth2 authorization and token URLs |
| `accounts.google.com` | 443/TCP | Google Workspace OAuth2 authorization and token URLs |
| `outlook.office365.com` | 993/995/TCP | Office 365 IMAP/POP3 (see 2.3) |
| `imap.gmail.com` / `pop.gmail.com` | 993/995/TCP | Gmail IMAP/POP3 (see 2.3) |

### 2.5 LDAP / Active Directory

Required when agent or customer authentication/backends use LDAP. Configured in
`Kernel/Config.pm` (`AuthModule::LDAP::Host*`, `AuthSyncModule::LDAP::Host*`,
`Customer::AuthModule::LDAP::Host*`, `CustomerUser*` backends) — also RADIUS
(`AuthModule::Radius::Host*`) if used.

| Destination | Port | Purpose |
|-------------|------|---------|
| LDAP / AD domain controllers | 389/TCP | LDAP (plain or STARTTLS) |
| | 636/TCP | LDAPS |
| RADIUS server | 1812/UDP | Only if RADIUS authentication is enabled |

### 2.6 Elasticsearch (LigeroSmart search engine)

Configured in SysConfig `LigeroSmart###Nodes` (default: `elasticsearch:9200`,
the Docker service name in containerized deployments).

| Destination | Port | Purpose |
|-------------|------|---------|
| Elasticsearch node(s) | 9200/TCP | Ticket/FAQ/Service indexing and search (Ligero Portal, LigeroSmart search) |

### 2.7 Package repositories and LigeroSmart/OTRS online services

Used by the package manager (Admin → Package Manager), cloud services and the
dashboard news widget. Configured in SysConfig `Package::RepositoryList`,
`Package::RepositoryRoot`, `CloudServices::Disabled`, `DashboardBackend###0410-RSS`.

| Destination | Port | Purpose |
|-------------|------|---------|
| `addons.ligerosmart.org` | 443/TCP | LigeroSmart add-on package repository |
| `news.ligerosmart.org` | 443/TCP | Dashboard RSS news widget |
| `cloud.otrs.com` | 443/TCP | OTRS cloud services / support data (skip if `CloudServices::Disabled` is set) |

### 2.8 GenericInterface web services (outbound integrations)

When LigeroSmart acts as **requester/invoker** (REST or SOAP) toward third-party
systems, each web service defines its own endpoint in
**Admin → Web Services** (`Requester → Transport → Endpoint/Host`). Firewall
rules must allow HTTPS (or the configured port) to each integrated system.
Run `scripts/network-validator.pl --category webservice` to list and test the
endpoints currently configured.

### 2.9 DNS and proxy

- **DNS (53/UDP+TCP)** to the configured resolvers — required to resolve every
  hostname above.
- If outbound HTTP/HTTPS must go through a **corporate proxy**, set
  `WebUserAgent::Proxy` and `Package::Proxy` in SysConfig and allow the server
  to reach the proxy host/port. Note: SMTP, POP3/IMAP, LDAP, RADIUS, database
  and Elasticsearch traffic does **not** go through the HTTP proxy and needs
  direct rules.

## 3. Quick reference — default outbound rule set

| # | Destination | Port/Proto | Service |
|---|-------------|-----------|---------|
| 1 | DB server | 3306/TCP | MySQL/MariaDB |
| 2 | SMTP relay (e.g. smtp.office365.com, smtp.gmail.com) | 587/TCP (or 25/465) | Outgoing mail |
| 3 | Mail host (e.g. outlook.office365.com, imap.gmail.com) | 993/TCP (or 995/143/110) | Mail fetch |
| 4 | login.microsoftonline.com, accounts.google.com | 443/TCP | OAuth2 (if used) |
| 5 | LDAP/AD servers | 389, 636/TCP | Authentication (if used) |
| 6 | Elasticsearch node(s) | 9200/TCP | Search engine |
| 7 | addons.ligerosmart.org, news.ligerosmart.org, cloud.otrs.com | 443/TCP | Packages, news, cloud services |
| 8 | Integration endpoints (per web service) | 443/TCP (typ.) | GenericInterface requester |
| 9 | DNS resolvers | 53/UDP+TCP | Name resolution |

## 4. Validating

From the application server (as the `otrs` user, inside the container in Docker
deployments):

```bash
# everything
perl scripts/network-validator.pl

# only specific categories
perl scripts/network-validator.pl --category smtp,mail,ldap

# longer timeout for slow links
perl scripts/network-validator.pl --timeout 10
```

Exit code `0` means all configured endpoints are reachable; `1` means at least
one check failed (details are printed per endpoint).
