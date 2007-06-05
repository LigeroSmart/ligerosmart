# --
# Kernel/Output/HTML/NotificationTimeAccounting.pm
# Copyright (C) 2003-2007 OTRS GmbH, http://otrs.com/
# --
# $Id: NotificationTimeAccounting.pm,v 1.3 2007-06-05 14:17:41 tr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Output::HTML::NotificationTimeAccounting;

use strict;
use Kernel::System::TimeAccounting;
use Kernel::System::Time;

use vars qw($VERSION);
$VERSION = '$Revision: 1.3 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

sub new {
    my $Type = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {};
    bless ($Self, $Type);

    # get needed objects
    foreach (qw(ConfigObject LogObject DBObject LayoutObject UserID)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    $Self->{TimeObject}    = Kernel::System::Time          ->new(%Param);
    $Self->{TimeAccountingObject} = Kernel::System::TimeAccounting->new(%Param);
    return $Self;
}

sub Run {
    my $Self = shift;
    my %Param = @_;
    my ($Sec, $Min, $Hour, $Day, $Month, $Year) = $Self->{TimeObject}->SystemTime2Date(
        SystemTime => $Self->{TimeObject}->SystemTime(),
    );
    my %User = $Self->{TimeAccountingObject}->UserCurrentPeriodGet(
        Year  => $Year,
        Month => $Month,
        Day   => $Day,
    );
    if ($User{$Self->{UserID}}){
        my %IncompleteWorkingDays = $Self->{TimeAccountingObject}->WorkingUnitsCompletnessCheck();
        # redirect if incomplete working day are out of range
        if ($IncompleteWorkingDays{Warning}) {
            return $Self->{LayoutObject}->Notify(
                Info     => 'Please insert your working hours!',
                Priority => 'Error'
            );
        }
        else {
            return '';
        }
    }
    return '';
}

1;
