# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::Console::Command::Maint::CloudServices::TestRESTAPI;

use strict;
use warnings;

use Data::Dumper;

use parent qw(Kernel::System::Console::BaseCommand);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::DateTime',
    'Kernel::System::JSON',
    'Kernel::System::Main',
    'Kernel::System::WebUserAgent',
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('Check Auth REST API services connectivity.');

    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    $Self->Print("<yellow>Checking Auth REST API service connectivity...</yellow>\n");

    # set trace level
    $Net::SSLeay::trace = 3;

    # print WebUserAgent settings if any
    my $ConfigObject           = $Kernel::OM->Get('Kernel::Config');
    my $Timeout                = $ConfigObject->Get('WebUserAgent::Timeout') || '';
    my $Proxy                  = $ConfigObject->Get('WebUserAgent::Proxy') || '';
    my $DisableSSLVerification = $ConfigObject->Get('WebUserAgent::DisableSSLVerification') || '';

    # remove credentials if any
    if ($Proxy) {
        $Proxy =~ s{\A.+?(http)}{$1};
    }
    if ( $Timeout || $Proxy || $DisableSSLVerification ) {

        $Self->Print("<yellow>Sending request with the following options:</yellow>\n");

        if ( $Proxy =~ m{\A ( http(?: s)? :// (?: \d{1,3}\.){3}\d{1,3}) : (\d+) /\z}msx ) {
            $Self->Print("  Proxy Address: $1\n");
            $Self->Print("  Proxy Port: $2\n");
        }
        elsif ($Proxy) {
            $Self->Print("  Proxy String: $Proxy\n");
        }

        if ($Timeout) {
            $Self->Print("  Timeout: $Timeout second(s)\n");
        }

        if ($DisableSSLVerification) {
            $Self->Print("  Disable SSL Verification: Yes\n");
        }
        $Self->Print("\n");
    }
    else {
        $Self->Print("<yellow>Sending request...</yellow>\n\n");
    }

    # prepare request data
    my $RequestData = $Kernel::OM->Get('Kernel::System::JSON')->Encode(
        Data => {
            token => "86739577-faf7-48de-8225-00c0c9d724a7",
            username => "alder.pinto",
            password => "Pass5793",
            type => "5",
            uf => "",            
        },
    );

    # remember the time when the request is sent
    my $TimeStartObject = $Kernel::OM->Create('Kernel::System::DateTime');

    # send request
    my %Response = $Kernel::OM->Get('Kernel::System::WebUserAgent')->Request(
        Type => 'POST',
        URL  => 'https://portalapp.simers.org.br/external/auth/login',
        Data => {
            token => "86739577-faf7-48de-8225-00c0c9d724a7",
            username => "alder.pinto",
            password => "Pass5793",
            type => "5",
            uf => ""           
        },
        Header => {
            Content_Type  => 'application/json',
        },
    );

    # calculate and print the time spent in the request
    my $TimeEndObject = $Kernel::OM->Create('Kernel::System::DateTime');
    my $TimeDelta     = $TimeEndObject->Delta( DateTimeObject => $TimeStartObject );
    my $TimeDiff      = $TimeDelta->{AbsoluteSeconds};

    $Self->Print(
        sprintf(
            "<yellow>Response time:</yellow> %s second(s)\n\n",
            $TimeDiff,
        )
    );

    # dump the request response
    my $DumpContent = $Kernel::OM->Get('Kernel::System::Main')->Dump(
        $Response{Content},
        'ascii',
    );

    # remove heading and tailing dump output
    $DumpContent =~ s{\$VAR1 [ ] = [ ] (.*)}{$1}msx;
    $DumpContent =~ s{\\'}{}msx;
    $DumpContent =~ s{\';\n\z}{}msx;
    $DumpContent =~ s{(.*)}{[$1]}msx;

    # prepare request data
    my $ResponseData = $Kernel::OM->Get('Kernel::System::JSON')->Decode(
        Data => $DumpContent,
    );

    #$Self->Print("<yellow>Response Pure Value:</yellow>\n" . Dumper($Response{Content}) . "\n");
    $Self->Print("<yellow>ResponseAuth:</yellow>\n" . $ResponseData->[0]->{auth} . "\n");

    # dump the request response
    my $Dump = $Kernel::OM->Get('Kernel::System::Main')->Dump(
        \%Response,
        'ascii',
    );

    # remove heading and tailing dump output
    $Dump =~ s{\A \$VAR1 [ ] = [ ] \{\n\s}{}msx;
    $Dump =~ s{\};\n\z}{}msx;

    # print response
    $Self->Print("<yellow>Response:</yellow>\n $Dump\n");

    # check for suggestions
    my %Suggestions;

    if ( $Proxy && $Proxy !~ m{/\z}msx ) {
        $Suggestions{WrongProxyEndLine} = 1;
    }
    if ( $Response{Status} =~ m{504}msx || $TimeDiff > $Timeout ) {
        $Suggestions{IncreseTimeout} = 1;
    }

    # print suggestions if any
    if (%Suggestions) {
        $Self->Print("<yellow>Suggestions:</yellow>\n");
        if ( $Suggestions{WrongProxyEndLine} ) {
            print
                "  The proxy string settings does not end with a '/', update your setting 'WebUserAgent::Proxy' as: $Proxy/\n";
        }
        if ( $Suggestions{IncreseTimeout} ) {
            $Self->Print("  Please increase the time out setting 'WebUserAgent::Timeout' and try again\n");
        }
    }
    return $Self->ExitCodeOk();
}

1;
