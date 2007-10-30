# --
# scripts/test/TimeAccounting.t - TimeAccounting testscript
# Copyright (C) 2001-2007 OTRS GmbH, http://otrs.org/
# --
# $Id: TimeAccounting.t,v 1.2 2007-10-30 10:48:30 tr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

# A benchmark test script
#use Kernel::System::TimeAccounting;
#
#our $Ref = $Self;
#$Ref->{UserID} = 3;
#
#$Ref->{TimeAccountingObject} = Kernel::System::TimeAccounting->new(%{$Ref});
#
#use Benchmark qw(cmpthese);
#cmpthese -5 , {
#    old      => 'my %IncompleteWorkingDays = $Ref->{TimeAccountingObject}->WorkingUnitsCompletnessCheck()',
#    'values' => 'my %IncompleteWorkingDays = $Ref->{TimeAccountingObject}->WorkingUnitsCompletnessCheckValues()'
#};

1;
