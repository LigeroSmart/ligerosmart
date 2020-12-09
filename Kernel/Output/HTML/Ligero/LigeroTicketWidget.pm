# --
# Kernel/Output/HTML/OutputFilterMediaWiki.pm
# Copyright (C) 2011 - 2015 Complemento - Liberdade e Tecnologia http://www.complemento.net.br
# --
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::Ligero::LigeroTicketWidget;

use strict;
use warnings;
require LWP::UserAgent;
use List::Util qw(first);
use HTTP::Status qw(:constants :is status_message);

use utf8;

sub new {
	my ( $Type, %Param ) = @_;
	# allocate new hash for object
	my $Self = {};
	bless( $Self, $Type );
	# get needed objects
	$Self->{UserID} = $Param{UserID};
	$Self->{SessionID} = $Param{SessionID};
    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;
    my $Script = '';
    my %Data = ();
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $ParamObject  = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

    if(${$Param{Data}} !~ /Headline/){
        return $Param{Data};
    }

    my $TicketID = $ParamObject->GetParam(Param => 'TicketID');
    my %Ticket = $TicketObject->TicketGet(TicketID => $TicketID);

    # Dynamically load module    
    my $Action = $Param{Action};
    my $module_name = 'Kernel::Modules::'.$Action;
    (my $require_name = $module_name . ".pm") =~ s{::}{/}g;
    require $require_name;
    
    # get ACL restrictions
    my %PossibleActions;
    my $Counter = 0;
    my $Show = 0;
    $PossibleActions{'1'}=$Action;
    my $ACL = $TicketObject->TicketAcl(
        Data          => \%PossibleActions,
        Action        => $Action,
        TicketID      => $TicketID,
        ReturnType    => 'Action',
        ReturnSubType => '-',
        UserID        => $Self->{UserID},
    );
    my %AclAction = %PossibleActions;
    if ($ACL) {
        %AclAction = $TicketObject->TicketAclActionData();
    }
    # check if ACL restrictions exist
    my %AclActionLookup = reverse %AclAction;
    # dont show reclassification screen if ACL prohibits this action
    if ( $AclActionLookup{ $Action } ) {
#        return {$Param{Data}};
        $Show = 1;
    }

    my $SessionObject = $Kernel::OM->Get('Kernel::System::AuthSession');
    my $UserObject    = $Kernel::OM->Get('Kernel::System::User');

    # get session data
    my %UserData = $SessionObject->GetSessionIDData(
        SessionID => $Self->{SessionID},
    );
    
    my $ModuleReg = $ConfigObject->Get('Frontend::Module')->{ $Action };
    my $FrontendObject = ( 'Kernel::Modules::'.$Action )->new(
        TicketID => $TicketID,
        UserID        => $Self->{UserID},
        Action => $Action,
        %Param,
        %UserData,
        ModuleReg => $ModuleReg,
        

    );
            
    $Script = $FrontendObject->Run(Show => $Show) || '';

    ${ $Param{Data} } =~ s/(<div class="WidgetSimple Expanded" id="DynamicFieldsWidget">|<div id="ArticleTree">)/$Script $1/;
    return $Param{Data};
}

1;
