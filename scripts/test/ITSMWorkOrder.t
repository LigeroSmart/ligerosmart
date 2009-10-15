# --
# ITSMWorkOrder.t - work order tests
# Copyright (C) 2003-2009 OTRS AG, http://otrs.com/
# --
# $Id: ITSMWorkOrder.t,v 1.3 2009-10-15 08:42:08 bes Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use utf8;

use vars qw($Self);

#use Data::Dumper;
#use Kernel::System::User;
#use Kernel::System::CustomerUser;
#use Kernel::System::GeneralCatalog;
#use Kernel::System::ITSMChange;
use Kernel::System::ITSMChange::WorkOrder;

# ------------------------------------------------------------ #
# make preparations
# ------------------------------------------------------------ #
my $TestCount = 1;

# create common objects
$Self->{WorkOrderObject} = Kernel::System::ITSMChange::WorkOrder->new( %{$Self} );
$Self->True(
    $Self->{WorkOrderObject},
    "Test " . $TestCount++ . ' - construction of workorder object'
);
$Self->Is(
    ref $Self->{WorkOrderObject},
    'Kernel::System::ITSMChange::WorkOrder',
    "Test " . $TestCount++ . ' - class of workorder object'
);

# ------------------------------------------------------------ #
# test WorkOrder API
# ------------------------------------------------------------ #

# define public interface
my @ObjectMethods = qw(
    WorkOrderAdd
    WorkOrderDelete
    WorkOrderGet
    WorkOrderList
    WorkOrderSearch
    WorkOrderUpdate
    WorkOrderChangeStartGet
    WorkOrderChangeEndGet
);

# check if subs are available
for my $ObjectMethod (@ObjectMethods) {
    $Self->True(
        $Self->{WorkOrderObject}->can($ObjectMethod),
        "Test " . $TestCount++ . " - check 'can $ObjectMethod'"
    );
}

1;
