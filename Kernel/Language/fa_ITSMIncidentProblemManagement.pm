# --
# Copyright (C) 2001-2016 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::fa_ITSMIncidentProblemManagement;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AAAITSMIncidentProblemManagement
    $Self->{Translation}->{'Add decision to ticket'} = 'الصاق یک تصمیم به درخواست';
    $Self->{Translation}->{'Decision Date'} = 'تاریخ تصمیم';
    $Self->{Translation}->{'Decision Result'} = 'نتیجه تصمیم';
    $Self->{Translation}->{'Due Date'} = 'تاریخ انجام';
    $Self->{Translation}->{'Reason'} = 'دلیل';
    $Self->{Translation}->{'Recovery Start Time'} = 'زمان شروع بهبود';
    $Self->{Translation}->{'Repair Start Time'} = 'زمان شروع تعمیر';
    $Self->{Translation}->{'Review Required'} = 'نیاز به بازبینی دارد';
    $Self->{Translation}->{'closed with workaround'} = 'موقتا بسته شد';

    # Template: AgentTicketActionCommon
    $Self->{Translation}->{'Change Decision of Ticket'} = 'تغییر تصمیم درخواست';
    $Self->{Translation}->{'Change ITSM fields of ticket'} = 'تغییر فیلدهای ITSM درخواست';
    $Self->{Translation}->{'Service Incident State'} = '';

    # Template: AgentTicketEmail
    $Self->{Translation}->{'Link ticket'} = 'ارتباط درخواست';

    # Template: AgentTicketOverviewPreview
    $Self->{Translation}->{'Criticality'} = 'اهمیت';
    $Self->{Translation}->{'Impact'} = 'اثر';

}

1;
