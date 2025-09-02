# --
# Kernel/Output/HTML/CustomerUserCustomerIDs.pm
# Copyright (C) 2006-2011 c.a.p.e. IT GmbH, http://www.cape-it.de
#
# written/edited by:
# * Martin(dot)Balzarek(at)cape(dash)it(dot)de
#
# --
# $Id: CustomerUserCustomerIDs.pm,v 1.2 2011-08-24 14:15:53 maba Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::CustomerUserCustomerIDs;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.2 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );    

    # get needed objects
    for (
#        qw(ConfigObject LogObject DBObject LayoutObject TicketObject MainObject UserID EncodeObject ParamObject)
        qw(LayoutObject)
        )
    {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

#    # return if nothing should be shown...
    my $CallingAction = $Kernel::OM->Get('Kernel::System::Web::Request')->GetParam( Param => 'Action' ) || '';
    my $ShowSelectBox = ( $CallingAction =~ /$Param{Config}->{ShowSelectBoxActionRegExp}/ ) ? 1 : 0;

    return 1 if !$ShowSelectBox;

    # generate output...
    my $OutputStrg = $Kernel::OM->Get('Kernel::Output::HTML::Layout')->CustomerAssignedCustomerIDsTable(
        CustomerUserID => $Param{Data}->{UserLogin} || '',
        AJAX           => $Param{Data}->{AJAX} || 0,
    );

    $Kernel::OM->Get('Kernel::Output::HTML::Layout')->Block(
        Name => 'CustomerIDsSelection',
        Data => {
            CustomerIDsStrg => $OutputStrg,
        },
    );

    return 1;
}

1;