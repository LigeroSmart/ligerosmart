# --
# Kernel/Output/HTML/DashboardComplementoOpenByOwner.pm
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# --
# $Id:
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.

#
# @Params:
#       QueueIDs=1,2,3... Filter for queues. Use user preferencial queues if not defined (Custom Queues)
#       StateTypeIDs =1,2,3 Filter for StateTypeIDs (required!)
#
# --

package Kernel::Output::HTML::Ligero::DashboardComplementoZabbixGraph;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.2 $) [1];

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

 
    return $Self;
}

sub Preferences {
    my ( $Self, %Param ) = @_;

    return;
}

sub Config {
    my ( $Self, %Param ) = @_;

    return (
        %{ $Self->{Config} }
    );
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $Title = $Param{'Title'} || '';

    my $url;

    # get cache object
    my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $TimeObject   = $Kernel::OM->Get('Kernel::System::Time');
    my $GraphTime = $CacheObject->Get(
        Type => 'ZabbixGraphTime',
        Key  =>  "$Param{Dashboard}_$Param{Index}",
    );

    if($GraphTime ne ""){
        $GraphTime = $TimeObject->SystemTime2TimeStamp(
            SystemTime => $GraphTime,
        );
        $LayoutObject->Block(
            Name => 'GraphTime',
            Data => {
                GraphTime=>$GraphTime,
               }
            );
    }

    my $GraphPNG = $CacheObject->Get(
        Type => 'ZabbixGraph',
        Key  =>  "$Param{Dashboard}_$Param{Index}",
    );

    if($GraphPNG ne ""){
        $LayoutObject->Block(
            Name => 'GraphPNG',
            Data => {
                GraphPNG=>$GraphPNG,
               }
        );
    } else {
        $LayoutObject->Block(
            Name => 'GraphPNGNotFound',
        );
    }
    
    my $Content = $LayoutObject->Output(
        TemplateFile => 'AgentDashboardComplementoZabbixGraph',
        Data         => {
            Title => $Title,
            %Param
        },
    );
    
    return $Content;
}

1;
