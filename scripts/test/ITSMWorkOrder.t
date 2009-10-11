# --
# ITSMWorkOrder.t - work order tests
# Copyright (C) 2003-2009 OTRS AG, http://otrs.com/
# --
# $Id: ITSMWorkOrder.t,v 1.1 2009-10-11 23:18:49 ub Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use utf8;

use vars qw($Self);

use Kernel::System::ITSMChange::WorkOrder;

$Self->{WorkOrderObject} = Kernel::System::ITSMChange::WorkOrder->new( %{$Self} );

1;
