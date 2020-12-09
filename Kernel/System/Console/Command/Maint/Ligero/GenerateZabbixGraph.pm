# --
# Copyright (C) 2001-2016 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Console::Command::Maint::Ligero::GenerateZabbixGraph;

use strict;
use warnings;

use base qw(Kernel::System::Console::BaseCommand);
# COMPLEMENTO
use MIME::Base64;
use HTTP::Cookies;
use LWP::UserAgent;

our @ObjectDependencies = (
    'Kernel::System::Loader',
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('Generate Zabbix Graphs for OTRS Dashboards.');

    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    $Self->Print("<yellow>Generating graphs...</yellow>\n");
    
    my $Config = $Kernel::OM->Get('Kernel::Config');

    # Obtem todos os dashboards do tipo Zabbix Graph em utilização
    my %Dashboards = %{ $Config->Get("DashboardBackend") || {} };
    
    for my $k (keys %Dashboards){
        if ($Dashboards{$k}->{Module} eq 'Kernel::Output::HTML::Ligero::DashboardComplementoWidgets') {
            if(exists $Dashboards{$k}->{Widgets}){
                my $i=0;
                while ($i < ($Dashboards{$k}->{Widgets})){
                    $i++;
                    if ($Dashboards{$k}->{"Widget $i"}->{"2-WidgetType"} eq 'Kernel::Output::HTML::Ligero::DashboardComplementoZabbixGraph') {
                        # TAKE Widget Options
                        my %DashParams;
                        my @Options = split /;/, $Dashboards{$k}->{"Widget $i"}->{"4-WidgetOptions"};
                        for my $String (@Options) {
                            next if !$String;
                            my ( $Key, $Value ) = split /=/, $String;
                            $DashParams{$Key}=$Value;
                        }
                        
                        # Verify if required params exists:
                        if(
                            exists $DashParams{Graphid}  &&
                            exists $DashParams{Url}      &&
                            exists $DashParams{Name}     &&
                            exists $DashParams{Password}
                        ){
                            # Generate Zabbix Cache
                            _generateGraphCache(
                                %DashParams,
                                Dashboard => $k,
                                Index     => $i,
                            );
                        }
                    }
                }
            }
        }
    }

    
    
    $Self->Print("<green>Done.</green>\n");

    return $Self->ExitCodeOk();
}


sub _generateGraphCache {
    my %Param = @_;
    
    my $cookie_jar = HTTP::Cookies->new();

    my %form = (
            'name' => $Param{Name},
            'password' => $Param{Password},
            'enter' => 'Sign in',
    );

    my $ua = LWP::UserAgent->new;
    
    # conecta ao servidor zabbix
    $ua->cookie_jar($cookie_jar);
    my $resp = $ua->post($Param{Url}.'/index.php',\%form);
    
    # Verifica se a conexao ocorreu
    if(!defined $resp->header('Set-Cookie')){
        print "It was not possible to authenticate on Zabbix Server\n";
        exit 0;
    }

    my $Width=$Param{Width} || '700';
    my $Height=$Param{Height} || '150';
    my $Period=$Param{Period} || '3600';

    my $zabbixGraphUrl = $Param{Url}."/chart2.php?graphid=$Param{Graphid}&width=$Width&height=$Height&period=$Period&border=1";

#    print $zabbixGraphUrl;

    my $graph = $ua->get($zabbixGraphUrl);

    # Verifica se foi possível retornar um PNG
    if ($graph->header('Content-Type') ne 'image/png'){
        print "Something went wrong. Server did not return a PNG Image\n";
        exit 0;
    };

    my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');
    
    # Cria cache com png encodado
    $CacheObject->Set(
        Type  => 'ZabbixGraph',
        Key   => "$Param{Dashboard}_$Param{Index}",
        Value => encode_base64($graph->content),
        TTL   => 60 * 60 * 60,
    );

    # Cria cache com horario gerado
    $CacheObject->Set(
        Type  => 'ZabbixGraphTime',
        Key   => "$Param{Dashboard}_$Param{Index}",
        Value => time(),
        TTL   => 60 * 60 * 60,
    );

}


1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
