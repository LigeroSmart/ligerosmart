# --
# Kernel/Language/fa_ITSMCore.pm - translation file
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::fa_ITSMCore;

use strict;
use warnings;

sub Data {
    my $Self = shift;

    # Template: AAAITSMCore
    $Self->{Translation}->{'Alternative to'} = 'جایگزینی برای';
    $Self->{Translation}->{'Availability'} = 'میزان در دسترس بودن';
    $Self->{Translation}->{'Back End'} = 'پشت صحنه';
    $Self->{Translation}->{'Connected to'} = 'متصل است به';
    $Self->{Translation}->{'Current State'} = 'وضعیت جاری';
    $Self->{Translation}->{'Demonstration'} = 'نمایش';
    $Self->{Translation}->{'Depends on'} = 'وابسته است به';
    $Self->{Translation}->{'End User Service'} = 'سرویس کاربر نهایی';
    $Self->{Translation}->{'Errors'} = 'خطاها';
    $Self->{Translation}->{'Front End'} = 'جلو صحنه';
    $Self->{Translation}->{'IT Management'} = 'مدیریت IT';
    $Self->{Translation}->{'IT Operational'} = 'عملیات IT';
    $Self->{Translation}->{'Impact'} = 'اثر';
    $Self->{Translation}->{'Incident State'} = 'وضعیت رخداد';
    $Self->{Translation}->{'Includes'} = 'مشتمل است بر';
    $Self->{Translation}->{'Other'} = 'بقیه';
    $Self->{Translation}->{'Part of'} = 'بخشی از';
    $Self->{Translation}->{'Project'} = 'پروژه';
    $Self->{Translation}->{'Recovery Time'} = 'زمان بهبود';
    $Self->{Translation}->{'Relevant to'} = 'مرتبط با';
    $Self->{Translation}->{'Reporting'} = 'گزارشی';
    $Self->{Translation}->{'Required for'} = 'مورد نیاز است برای';
    $Self->{Translation}->{'Resolution Rate'} = 'نرخ حل مسئله';
    $Self->{Translation}->{'Response Time'} = 'زمان پاسخگویی';
    $Self->{Translation}->{'SLA Overview'} = 'خلاصه SLA';
    $Self->{Translation}->{'Service Overview'} = 'خلاصه سرویس';
    $Self->{Translation}->{'Service-Area'} = 'بخش سرویس';
    $Self->{Translation}->{'Training'} = 'آموزشی';
    $Self->{Translation}->{'Transactions'} = 'تراکنش‌ها';
    $Self->{Translation}->{'Underpinning Contract'} = 'قرارداد آماده چاپ';
    $Self->{Translation}->{'allocation'} = 'اختصاص';

    # Template: AdminITSMCIPAllocate
    $Self->{Translation}->{'Criticality <-> Impact <-> Priority'} = 'اهمیت <-> اثر <-> اولویت';
    $Self->{Translation}->{'Manage the priority result of combinating Criticality <-> Impact.'} =
        'مدیریت الویت ناشی از ترکیب اهمیت <-> اثر';
    $Self->{Translation}->{'Priority allocation'} = 'تخصیص الویت';

    # Template: AdminSLA
    $Self->{Translation}->{'Minimum Time Between Incidents'} = 'حداقل زمان بین دو رخداد';

    # Template: AdminService
    $Self->{Translation}->{'Criticality'} = 'اهمیت';

    # Template: AgentITSMCustomerSearch

    # Template: AgentITSMSLA

    # Template: AgentITSMSLAPrint
    $Self->{Translation}->{'SLA-Info'} = 'اطلاعات SLA';
    $Self->{Translation}->{'Last changed'} = 'آخرین تغییر';
    $Self->{Translation}->{'Last changed by'} = 'آخرین تغییر توسط';

    # Template: AgentITSMSLAZoom
    $Self->{Translation}->{'SLA Information'} = 'اطلاعات SLA';
    $Self->{Translation}->{'Associated Services'} = 'سرویس‌های مرتبط';

    # Template: AgentITSMService

    # Template: AgentITSMServicePrint
    $Self->{Translation}->{'Service-Info'} = 'اطلاعات سرویس';
    $Self->{Translation}->{'Current Incident State'} = 'وضعیت جاری رخداد';
    $Self->{Translation}->{'Associated SLAs'} = 'SLAهای مرتبط';

    # Template: AgentITSMServiceZoom
    $Self->{Translation}->{'Service Information'} = 'اطلاعات سرویس';
    $Self->{Translation}->{'Current incident state'} = 'وضعیت کنونی رخداد';

    # SysConfig
    $Self->{Translation}->{'Frontend module registration for the AdminITSMCIPAllocate configuration in the admin area.'} =
        'ثبت ماژول برای پیکربندی AdminITSMCIPAllocate در بخش مدیریت';
    $Self->{Translation}->{'Frontend module registration for the AgentITSMSLA object in the agent interface.'} =
        'ثبت ماژول برای پیکربندی آبجکت AgentITSMSLA در واسط کاربری کارشناس';
    $Self->{Translation}->{'Frontend module registration for the AgentITSMSLAPrint object in the agent interface.'} =
        'ثبت ماژول برای پیکربندی آبجکت AgentITSMSLAPrint در واسط کاربری کارشناس';
    $Self->{Translation}->{'Frontend module registration for the AgentITSMSLAZoom object in the agent interface.'} =
        'ثبت ماژول برای پیکربندی آبجکت AgentITSMSLAZoom در واسط کاربری کارشناس';
    $Self->{Translation}->{'Frontend module registration for the AgentITSMService object in the agent interface.'} =
        'ثبت ماژول برای پیکربندی آبجکت AgentITSMService در واسط کاربری کارشناس';
    $Self->{Translation}->{'Frontend module registration for the AgentITSMServicePrint object in the agent interface.'} =
        'ثبت ماژول برای پیکربندی آبجکت AgentITSMServicePrint در واسط کاربری کارشناس';
    $Self->{Translation}->{'Frontend module registration for the AgentITSMServiceZoom object in the agent interface.'} =
        'ثبت ماژول برای پیکربندی آبجکت AgentITSMServiceZoom در واسط کاربری کارشناس';
    $Self->{Translation}->{'Manage priority matrix.'} = 'مدیریت ماتریس الویت';
    $Self->{Translation}->{'Module to show back link in service menu.'} = 'ماژولی برای نمایش لینک بازگشت در منوی سرویس';
    $Self->{Translation}->{'Module to show back link in sla menu.'} = 'ماژولی برای نمایش لینک بازگشت در منوی SLA';
    $Self->{Translation}->{'Module to show print link in service menu.'} = 'ماژولی برای نمایش لینک چاپ در منوی سرویس';
    $Self->{Translation}->{'Module to show print link in sla menu.'} = 'ماژولی برای نمایش لینک چاپ در منوی SLA';
    $Self->{Translation}->{'Module to show the link link in service menu.'} = '';
    $Self->{Translation}->{'Parameters for the incident states in the preference view.'} = 'پارامترهایی برای وضعیت‌های رخداد در نمای تنظیمات شخصی';
    $Self->{Translation}->{'Set the type of link to be used to calculate the incident state.'} =
        'تنظیم نوع ارتباطی که باید برای محاسبه وضعیت رخداد استفاده شود.';
    $Self->{Translation}->{'This setting defines that a \'ITSMChange\' object can be linked with \'Ticket\' objects using the \'Normal\' link type.'} =
        '';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'FAQ\' objects using the \'Normal\' link type.'} =
        '';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'FAQ\' objects using the \'ParentChild\' link type.'} =
        '';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'FAQ\' objects using the \'RelevantTo\' link type.'} =
        '';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'Service\' objects using the \'AlternativeTo\' link type.'} =
        '';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'Service\' objects using the \'DependsOn\' link type.'} =
        '';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'Service\' objects using the \'RelevantTo\' link type.'} =
        '';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'Ticket\' objects using the \'AlternativeTo\' link type.'} =
        '';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'Ticket\' objects using the \'DependsOn\' link type.'} =
        '';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with \'Ticket\' objects using the \'RelevantTo\' link type.'} =
        '';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with other \'ITSMConfigItem\' objects using the \'AlternativeTo\' link type.'} =
        '';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with other \'ITSMConfigItem\' objects using the \'ConnectedTo\' link type.'} =
        '';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with other \'ITSMConfigItem\' objects using the \'DependsOn\' link type.'} =
        '';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with other \'ITSMConfigItem\' objects using the \'Includes\' link type.'} =
        '';
    $Self->{Translation}->{'This setting defines that a \'ITSMConfigItem\' object can be linked with other \'ITSMConfigItem\' objects using the \'RelevantTo\' link type.'} =
        '';
    $Self->{Translation}->{'This setting defines that a \'ITSMWorkOrder\' object can be linked with \'ITSMConfigItem\' objects using the \'DependsOn\' link type.'} =
        '';
    $Self->{Translation}->{'This setting defines that a \'ITSMWorkOrder\' object can be linked with \'ITSMConfigItem\' objects using the \'Normal\' link type.'} =
        '';
    $Self->{Translation}->{'This setting defines that a \'ITSMWorkOrder\' object can be linked with \'Service\' objects using the \'DependsOn\' link type.'} =
        '';
    $Self->{Translation}->{'This setting defines that a \'ITSMWorkOrder\' object can be linked with \'Service\' objects using the \'Normal\' link type.'} =
        '';
    $Self->{Translation}->{'This setting defines that a \'ITSMWorkOrder\' object can be linked with \'Ticket\' objects using the \'Normal\' link type.'} =
        '';
    $Self->{Translation}->{'This setting defines that a \'Service\' object can be linked with \'FAQ\' objects using the \'Normal\' link type.'} =
        '';
    $Self->{Translation}->{'This setting defines that a \'Service\' object can be linked with \'FAQ\' objects using the \'ParentChild\' link type.'} =
        '';
    $Self->{Translation}->{'This setting defines that a \'Service\' object can be linked with \'FAQ\' objects using the \'RelevantTo\' link type.'} =
        '';
    $Self->{Translation}->{'This setting defines the link type \'AlternativeTo\'. If the source name and the target name contain the same value, the resulting link is a non-directional one. If the values are different, the resulting link is a directional link.'} =
        '';
    $Self->{Translation}->{'This setting defines the link type \'ConnectedTo\'. If the source name and the target name contain the same value, the resulting link is a non-directional one. If the values are different, the resulting link is a directional link.'} =
        '';
    $Self->{Translation}->{'This setting defines the link type \'DependsOn\'. If the source name and the target name contain the same value, the resulting link is a non-directional one. If the values are different, the resulting link is a directional link.'} =
        '';
    $Self->{Translation}->{'This setting defines the link type \'Includes\'. If the source name and the target name contain the same value, the resulting link is a non-directional one. If the values are different, the resulting link is a directional link.'} =
        '';
    $Self->{Translation}->{'This setting defines the link type \'RelevantTo\'. If the source name and the target name contain the same value, the resulting link is a non-directional one. If the values are different, the resulting link is a directional link.'} =
        '';
    $Self->{Translation}->{'Width of ITSM textareas.'} = 'اندازه عرض کنترل‌های ورود متن ITSM';

    #
    # OBSOLETE ENTRIES FOR REFERENCE, DO NOT TRANSLATE!
    #

}

1;
