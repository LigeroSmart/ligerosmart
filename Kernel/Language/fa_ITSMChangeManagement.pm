# --
# Kernel/Language/fa_ITSMChangeManagement.pm - translation file
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::fa_ITSMChangeManagement;

use strict;
use warnings;

sub Data {
    my $Self = shift;

    # Template: AAAITSMChangeManagement
    $Self->{Translation}->{'ITSMChange'} = 'تغییر';
    $Self->{Translation}->{'ITSMChanges'} = 'تغییرات';
    $Self->{Translation}->{'ITSM Changes'} = 'تغییرات';
    $Self->{Translation}->{'workorder'} = 'دستور کار';
    $Self->{Translation}->{'A change must have a title!'} = 'هر تغییر باید عنوان داشته باشد!';
    $Self->{Translation}->{'A condition must have a name!'} = 'هر شرط باید دارای نام باشد!';
    $Self->{Translation}->{'A template must have a name!'} = 'قالب باید دارای نام باشد!';
    $Self->{Translation}->{'A workorder must have a title!'} = 'هر دستور کار باید دارای عنوان باشد!';
    $Self->{Translation}->{'ActionExecute::successfully'} = 'با موفقیت';
    $Self->{Translation}->{'ActionExecute::unsuccessfully'} = 'عدم موفقیت';
    $Self->{Translation}->{'Add CAB Template'} = 'افزودن قالب برای هیئت مشاوران';
    $Self->{Translation}->{'Add Workorder'} = 'افزودن دستور کار';
    $Self->{Translation}->{'Add a workorder to the change'} = 'افزودن یک دستور کار به تغییر';
    $Self->{Translation}->{'Add new condition and action pair'} = 'افزودن جفتی از شرط و عملیات';
    $Self->{Translation}->{'Agent interface module to show the ChangeManager overview icon.'} =
        'ماژول واسط کاربری کارشناس برای نمایش آیکون نمای کلی مدیر تغییر';
    $Self->{Translation}->{'Agent interface module to show the MyCAB overview icon.'} = 'ماژول واسط کاربری کارشناس برای نمایش آیکون نمای کلی کارشناسان تیم تغییر من';
    $Self->{Translation}->{'Agent interface module to show the MyChanges overview icon.'} = 'ماژول واسط کاربری کارشناس برای نمایش آیکون نمای کلی تغییرات من';
    $Self->{Translation}->{'Agent interface module to show the MyWorkOrders overview icon.'} =
        'ماژول واسط کاربری کارشناس برای نمایش آیکون نمای کلی دستور کارهای من';
    $Self->{Translation}->{'CABAgents'} = 'کارشناسان هیئت مشاور تغییر';
    $Self->{Translation}->{'CABCustomers'} = 'هیئت مشاور تغییر - مشترکان';
    $Self->{Translation}->{'Change Overview'} = 'نمای کلی تغییر';
    $Self->{Translation}->{'Change Schedule'} = 'زمان‌بندی تغییر';
    $Self->{Translation}->{'Change involved persons of the change'} = 'افراد درگیر این تغییر';
    $Self->{Translation}->{'ChangeHistory::ActionAdd'} = '%s: %s';
    $Self->{Translation}->{'ChangeHistory::ActionAddID'} = 'عملیات جدید (ID=%s)';
    $Self->{Translation}->{'ChangeHistory::ActionDelete'} = 'عملیات (ID=%s) حذف شد';
    $Self->{Translation}->{'ChangeHistory::ActionDeleteAll'} = 'تمام عملیات‌های شرط (ID=%s) حذف شد';
    $Self->{Translation}->{'ChangeHistory::ActionExecute'} = 'عملیات (ID=%s) اجرا شد: %s';
    $Self->{Translation}->{'ChangeHistory::ActionUpdate'} = '%s (شناسه عملیات=%s): جدید: %s -> قدیم: %s';
    $Self->{Translation}->{'ChangeHistory::ChangeActualEndTimeReached'} = 'زمان حقیقی پایان تغییر فرا رسیده (ID=%s)';
    $Self->{Translation}->{'ChangeHistory::ChangeActualStartTimeReached'} = 'زمان حقیقی آغاز تغییر فرا رسیده (ID=%s)';
    $Self->{Translation}->{'ChangeHistory::ChangeAdd'} = 'تغییر جدید (ID=%s)';
    $Self->{Translation}->{'ChangeHistory::ChangeAttachmentAdd'} = 'پیوست جدید: %s';
    $Self->{Translation}->{'ChangeHistory::ChangeAttachmentDelete'} = 'پیوست حذف شد %s';
    $Self->{Translation}->{'ChangeHistory::ChangeCABDelete'} = 'هیئت مشاوران تغییر حذف شد %s';
    $Self->{Translation}->{'ChangeHistory::ChangeCABUpdate'} = '%s: جدید: %s -> قدیم: %s';
    $Self->{Translation}->{'ChangeHistory::ChangeLinkAdd'} = 'ارتباط به %s (ID=%s) افزوده شد';
    $Self->{Translation}->{'ChangeHistory::ChangeLinkDelete'} = 'ارتباط به %s (ID=%s) حذف شد';
    $Self->{Translation}->{'ChangeHistory::ChangeNotificationSent'} = 'اعلام فرستاده شد %s (رویداد: %s)';
    $Self->{Translation}->{'ChangeHistory::ChangePlannedEndTimeReached'} = 'زمان برنامه‌ریزی شده پایان تغییر فرا رسیده (ID=%s)';
    $Self->{Translation}->{'ChangeHistory::ChangePlannedStartTimeReached'} = 'زمان برنامه‌ریزی شده آغاز تغییر فرا رسیده (ID=%s)';
    $Self->{Translation}->{'ChangeHistory::ChangeRequestedTimeReached'} = 'زمان درخواست شده تغییر توسط مشترک فرا رسیده (ID=%s)';
    $Self->{Translation}->{'ChangeHistory::ChangeUpdate'} = '%s: جدید: %s -> قدیم: %s';
    $Self->{Translation}->{'ChangeHistory::ConditionAdd'} = '%s: %s';
    $Self->{Translation}->{'ChangeHistory::ConditionAddID'} = 'شرط جدید (ID=%s)';
    $Self->{Translation}->{'ChangeHistory::ConditionDelete'} = 'شرط (ID=%s) حذف شد';
    $Self->{Translation}->{'ChangeHistory::ConditionDeleteAll'} = 'تمام شروط دستور کار (ID=%s) حذف شد';
    $Self->{Translation}->{'ChangeHistory::ConditionUpdate'} = '%s (شناسه شرط=%s): جدید: %s -> قدیم: %s';
    $Self->{Translation}->{'ChangeHistory::ExpressionAdd'} = '%s: %s';
    $Self->{Translation}->{'ChangeHistory::ExpressionAddID'} = 'عبارت منطقی جدید (ID=%s)';
    $Self->{Translation}->{'ChangeHistory::ExpressionDelete'} = 'عبارت منطقی (ID=%s) حذف شد';
    $Self->{Translation}->{'ChangeHistory::ExpressionDeleteAll'} = 'تمام عبارات منطقی شرط (ID=%s) حذف شد';
    $Self->{Translation}->{'ChangeHistory::ExpressionUpdate'} = '%s (شناسه عبارت=%s): جدید: %s -> قدیم: %s';
    $Self->{Translation}->{'ChangeNumber'} = 'شماره تغییر';
    $Self->{Translation}->{'Condition Edit'} = 'ویرایش شرط';
    $Self->{Translation}->{'Create Change'} = 'ساختن تغییر';
    $Self->{Translation}->{'Create a change from this ticket!'} = 'ساخت یک تغییر از این درخواست!';
    $Self->{Translation}->{'Delete Workorder'} = 'حذف دستور کار';
    $Self->{Translation}->{'Edit the change'} = 'ویرایش تغییر';
    $Self->{Translation}->{'Edit the conditions of the change'} = 'ویرایش شروط تغییر';
    $Self->{Translation}->{'Edit the workorder'} = 'ویرایش دستور کار';
    $Self->{Translation}->{'Expression'} = 'عبارت منطقی';
    $Self->{Translation}->{'Full-Text Search in Change and Workorder'} = 'جستجوی تمام متن در تغییرات و دستور کارها';
    $Self->{Translation}->{'ITSMCondition'} = 'شرط';
    $Self->{Translation}->{'ITSMWorkOrder'} = 'دستور کار';
    $Self->{Translation}->{'Link another object to the change'} = 'ارتباط دادن یک شیء به تغییر';
    $Self->{Translation}->{'Link another object to the workorder'} = 'ارتباط دادن یک شیء دیگر به دستور کار';
    $Self->{Translation}->{'Move all workorders in time'} = 'جابه‌جا کردن تمام دستور کارها در زمان';
    $Self->{Translation}->{'My CABs'} = 'هیئت مشاوران من';
    $Self->{Translation}->{'My Changes'} = 'تغییرات من';
    $Self->{Translation}->{'My Workorders'} = 'دستور کارهای من';
    $Self->{Translation}->{'No XXX settings'} = 'بدون تنظیمات \'%s\'';
    $Self->{Translation}->{'PIR (Post Implementation Review)'} = 'بررسی پس از پیاده‌سازی';
    $Self->{Translation}->{'PSA (Projected Service Availability)'} = 'دسترس‌پذیری پیش‌بینی شده خدمات';
    $Self->{Translation}->{'Please select first a catalog class!'} = 'لطفا ابتدا یک کلاس انتخاب کنید!';
    $Self->{Translation}->{'Print the change'} = 'چاپ تغییر';
    $Self->{Translation}->{'Print the workorder'} = 'چاپ دستور کار';
    $Self->{Translation}->{'RequestedTime'} = 'زمان مورد انتظار';
    $Self->{Translation}->{'Save Change CAB as Template'} = 'ذخیره کردن تیم کارشناسی تغییر به عنوان قالب';
    $Self->{Translation}->{'Save change as a template'} = 'ذخیره کردن تغییر به عنون قالب';
    $Self->{Translation}->{'Save workorder as a template'} = 'ذخیره کردن دستور کار به عنوان قالب';
    $Self->{Translation}->{'Search Changes'} = 'جستجوی تغییرات';
    $Self->{Translation}->{'Set the agent for the workorder'} = 'مشخص کردن کارشناس برای دستور کار';
    $Self->{Translation}->{'Take Workorder'} = 'گرفتن دستور کار';
    $Self->{Translation}->{'Take the workorder'} = 'این دستور کار را بگیر';
    $Self->{Translation}->{'Template Overview'} = 'نمای کلی قالب';
    $Self->{Translation}->{'The planned end time is invalid!'} = 'زمان برنامه‌ریزی شده پایان معتبر نیست!';
    $Self->{Translation}->{'The planned start time is invalid!'} = 'زمان برنامه‌ریزی شده آغاز معتبر نیست!';
    $Self->{Translation}->{'The planned time is invalid!'} = 'زمان برنامه‌ریزی شده معتبر نیست!';
    $Self->{Translation}->{'The requested time is invalid!'} = 'زمان درخواست معتبر نیست!';
    $Self->{Translation}->{'New (from template)'} = '';
    $Self->{Translation}->{'Add from template'} = '';
    $Self->{Translation}->{'Add Workorder (from template)'} = '';
    $Self->{Translation}->{'Add a workorder (from template) to the change'} = '';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderActualEndTimeReached'} = 'زمان حقیقی پایان دستور کار فرا رسیده (ID=%s)';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderActualEndTimeReachedWithWorkOrderID'} =
        'زمان حقیقی پایان دستور کار فرا رسیده (ID=%s)';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderActualStartTimeReached'} = 'زمان حقیقی آغاز دستور کار فرا رسیده (ID=%s)';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderActualStartTimeReachedWithWorkOrderID'} =
        'زمان حقیقی آغاز دستور کار فرا رسیده (ID=%s)';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderAdd'} = 'دستور کار جدید (ID=%s)';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderAddWithWorkOrderID'} = 'دستور کار جدید (ID=%s)';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderAttachmentAdd'} = 'پیوست جدید برای دستور کار: %s';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderAttachmentAddWithWorkOrderID'} = '(ID=%s) پیوست جدید برای دستور کار: %s';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderAttachmentDelete'} = 'پیوست حذف شده از دستور کار: %s';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderAttachmentDeleteWithWorkOrderID'} = '(ID=%s) پیوست حذف شده از دستور کار: %s';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderReportAttachmentAdd'} = '';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderReportAttachmentAddWithWorkOrderID'} =
        '';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderReportAttachmentDelete'} = '';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderReportAttachmentDeleteWithWorkOrderID'} =
        '';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderDelete'} = 'دستور کار (ID=%s) حذف شد';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderDeleteWithWorkOrderID'} = 'دستور کار (ID=%s) حذف شد';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderLinkAdd'} = 'ارتباط به %s (ID=%s) افزوده شد';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderLinkAddWithWorkOrderID'} = '(ID=%s) ارتباط به %s (ID=%s) افزوده شد';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderLinkDelete'} = 'ارتباط به %s (ID=%s) حذف شد';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderLinkDeleteWithWorkOrderID'} = '(ID=%s) ارتباط به %s (ID=%s) حذف شد';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderNotificationSent'} = 'اعلان به %s ارسال شد )رویداد: %s(';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderNotificationSentWithWorkOrderID'} = '(ID=%s) اعلان ارسال شد به %s (رویداد: %s)';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderPlannedEndTimeReached'} = 'زمان برنامه‌ریزی شده پایان پایان کار فرا رسیده (ID=%s)';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderPlannedEndTimeReachedWithWorkOrderID'} =
        'زمان برنامه‌ریزی شده پایان پایان کار فرا رسیده (ID=%s)';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderPlannedStartTimeReached'} = 'زمان برنامه‌ریزی شده آغاز دستور کار فرا رسیده (ID=%s)';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderPlannedStartTimeReachedWithWorkOrderID'} =
        'زمان برنامه‌ریزی شده آغاز دستور کار فرا رسیده (ID=%s)';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderUpdate'} = '%s: جدید: %s -> قدیم: %s';
    $Self->{Translation}->{'WorkOrderHistory::WorkOrderUpdateWithWorkOrderID'} = '(ID=%s) %s: جدید: %s -> قدیم: %s';
    $Self->{Translation}->{'WorkOrderNumber'} = 'شماره دستور کار';
    $Self->{Translation}->{'accepted'} = 'پذیرفته شده';
    $Self->{Translation}->{'any'} = 'هیچ';
    $Self->{Translation}->{'approval'} = 'تصویب';
    $Self->{Translation}->{'approved'} = 'تایید شده';
    $Self->{Translation}->{'backout'} = 'طرح بازگشت';
    $Self->{Translation}->{'begins with'} = 'شروع می‌شود با';
    $Self->{Translation}->{'canceled'} = 'لغو شده';
    $Self->{Translation}->{'contains'} = 'شامل است';
    $Self->{Translation}->{'created'} = 'ساخته شده';
    $Self->{Translation}->{'decision'} = 'تصمیم';
    $Self->{Translation}->{'ends with'} = 'پایان می‌یابد با';
    $Self->{Translation}->{'failed'} = 'شکست';
    $Self->{Translation}->{'in progress'} = 'در حال اجرا';
    $Self->{Translation}->{'is'} = 'هست';
    $Self->{Translation}->{'is after'} = 'پس از';
    $Self->{Translation}->{'is before'} = 'قبل از';
    $Self->{Translation}->{'is empty'} = 'خالی است';
    $Self->{Translation}->{'is greater than'} = 'بزرگتر است از';
    $Self->{Translation}->{'is less than'} = 'کوچکتر است از';
    $Self->{Translation}->{'is not'} = 'نیست';
    $Self->{Translation}->{'is not empty'} = 'خالی نیست';
    $Self->{Translation}->{'not contains'} = 'شامل نیست';
    $Self->{Translation}->{'pending approval'} = 'در انتظار تایید';
    $Self->{Translation}->{'pending pir'} = 'در انتظار بررسی پس از پیاده‌سازی';
    $Self->{Translation}->{'pir'} = 'بررسی پس از پیاده‌سازی';
    $Self->{Translation}->{'ready'} = 'آماده';
    $Self->{Translation}->{'rejected'} = 'رد شده';
    $Self->{Translation}->{'requested'} = 'درخواست شده';
    $Self->{Translation}->{'retracted'} = 'جمع شده';
    $Self->{Translation}->{'set'} = 'تنظیم شده';
    $Self->{Translation}->{'successful'} = 'موفقیت';

    # Template: AdminITSMChangeCIPAllocate
    $Self->{Translation}->{'Category <-> Impact <-> Priority'} = 'طبقه <-> اثر <-> الویت';
    $Self->{Translation}->{'Manage the priority result of combinating Category <-> Impact.'} =
        'مدیریت الویت ناشی از ترکیب طبقه <-> اثر';
    $Self->{Translation}->{'Priority allocation'} = 'تخصیص الویت';

    # Template: AdminITSMChangeNotification
    $Self->{Translation}->{'ITSM ChangeManagement Notification Management'} = 'مدیریت اعلان مربوط به مدیریت تغییرات در ITSM';
    $Self->{Translation}->{'Add Notification Rule'} = 'افزودن قاعده اعلان';
    $Self->{Translation}->{'Attribute'} = '';
    $Self->{Translation}->{'Rule'} = 'قاعده';
    $Self->{Translation}->{'Recipients'} = '';
    $Self->{Translation}->{'A notification should have a name!'} = 'اعلان باید دارای نام باشد!';
    $Self->{Translation}->{'Name is required.'} = 'نام مورد نیاز است.';

    # Template: AdminITSMStateMachine
    $Self->{Translation}->{'Admin State Machine'} = 'ماشین حالت مدیر';
    $Self->{Translation}->{'Select a catalog class!'} = 'یک کلاس انتخاب کنید!';
    $Self->{Translation}->{'A catalog class is required!'} = 'کلاس فهرست مورد نیاز است!';
    $Self->{Translation}->{'Add a state transition'} = 'افزودن یک انتقال وضعیت';
    $Self->{Translation}->{'Catalog Class'} = 'کلاس فهرست';
    $Self->{Translation}->{'Object Name'} = 'نام شیء';
    $Self->{Translation}->{'Overview over state transitions for'} = 'نمای کلی روی انتقال‌های وضعیت برای';
    $Self->{Translation}->{'Delete this state transition'} = '';
    $Self->{Translation}->{'Add a new state transition for'} = 'افزودن یک انتقال وضعیت برای';
    $Self->{Translation}->{'Please select a state!'} = 'لطفا یک وضعیت را انتخای نمایید!';
    $Self->{Translation}->{'Please select a next state!'} = 'لطفا یک وضعیت بعدی انخاب نمایید!';
    $Self->{Translation}->{'Edit a state transition for'} = 'ویرایش یک انتقال وضعیت برای';
    $Self->{Translation}->{'Do you really want to delete the state transition'} = 'آیا از حذف انتقال وضعیت مطمئن هستید؟';
    $Self->{Translation}->{'from'} = 'از';

    # Template: AgentITSMCABMemberSearch

    # Template: AgentITSMChangeAdd
    $Self->{Translation}->{'Add Change'} = 'افزودن تغییر';
    $Self->{Translation}->{'ITSM Change'} = 'تغییر';
    $Self->{Translation}->{'Justification'} = 'دلیل';
    $Self->{Translation}->{'Input invalid.'} = 'ورودی نامعتبر است.';
    $Self->{Translation}->{'Impact'} = 'اثر مخرب';
    $Self->{Translation}->{'Requested Date'} = 'تاریخ درخواست شده';

    # Template: AgentITSMChangeAddFromTemplate
    $Self->{Translation}->{'Select Change Template'} = 'انتخاب قالب تغییر';
    $Self->{Translation}->{'Time type'} = 'نوع زمان';
    $Self->{Translation}->{'Invalid time type.'} = 'نوع زمان نامعتبراست.';
    $Self->{Translation}->{'New time'} = 'زمان جدید';

    # Template: AgentITSMChangeCABTemplate
    $Self->{Translation}->{'Save Change CAB as template'} = 'ذخیره کردن هیئت مشاوران تغییر به عنوان قالب';
    $Self->{Translation}->{'go to involved persons screen'} = 'به صفحه افراد درگیر کار برو';
    $Self->{Translation}->{'This field is required'} = 'این فیلد مورد نیاز است';
    $Self->{Translation}->{'Invalid Name'} = 'نام معتبر نیست';

    # Template: AgentITSMChangeCondition
    $Self->{Translation}->{'Conditions and Actions'} = 'شروط و عملیات‌ها';
    $Self->{Translation}->{'Delete Condition'} = 'حذف شرط';
    $Self->{Translation}->{'Add new condition'} = 'افزودن شرط جدید';

    # Template: AgentITSMChangeConditionEdit
    $Self->{Translation}->{'Need a valid name.'} = 'یک نام معتبر مورد نیاز است.';
    $Self->{Translation}->{'A a valid name is needed.'} = 'یک نام معتبر مورد نیاز است.';
    $Self->{Translation}->{'Matching'} = 'تطابق';
    $Self->{Translation}->{'Any expression (OR)'} = 'هر عبارتی (OR)';
    $Self->{Translation}->{'All expressions (AND)'} = 'همه عبارات (AND)';
    $Self->{Translation}->{'Expressions'} = 'عبارات منطقی';
    $Self->{Translation}->{'Selector'} = 'انتخاب کننده';
    $Self->{Translation}->{'Operator'} = 'اپراتور';
    $Self->{Translation}->{'Delete Expression'} = '';
    $Self->{Translation}->{'No Expressions found.'} = 'هیچ عبارتی یافت نشد.';
    $Self->{Translation}->{'Add new expression'} = 'افزودن یک عبارت منطقی';
    $Self->{Translation}->{'Delete Action'} = '';
    $Self->{Translation}->{'No Actions found.'} = 'هیچ عملیاتی یافت نشد.';
    $Self->{Translation}->{'Add new action'} = 'افزودن عملیات جدید';

    # Template: AgentITSMChangeDelete
    $Self->{Translation}->{'Do you really want to delete this change?'} = '';

    # Template: AgentITSMChangeEdit

    # Template: AgentITSMChangeHistory
    $Self->{Translation}->{'Workorder'} = 'دستور کار';
    $Self->{Translation}->{'Show details'} = 'نمایش جزئیات';
    $Self->{Translation}->{'Show workorder'} = 'نمایش دستور کارها';

    # Template: AgentITSMChangeHistoryZoom
    $Self->{Translation}->{'Detailed history information of'} = 'اطلاعات تاریخچه جزئی مربوط به';
    $Self->{Translation}->{'Modified'} = '';
    $Self->{Translation}->{'Old Value'} = 'مقدار قدیمی';
    $Self->{Translation}->{'New Value'} = 'مقدار جدید';

    # Template: AgentITSMChangeInvolvedPersons
    $Self->{Translation}->{'Involved Persons'} = 'افراد درگیر';
    $Self->{Translation}->{'ChangeManager'} = 'مدیر تغییر';
    $Self->{Translation}->{'User invalid.'} = 'کاربر نامعتبر است.';
    $Self->{Translation}->{'ChangeBuilder'} = 'سازنده تغییر';
    $Self->{Translation}->{'Change Advisory Board'} = 'هیئت مشاوران تغییر';
    $Self->{Translation}->{'CAB Template'} = 'قالب هیئت مشاوران تغییر';
    $Self->{Translation}->{'Apply Template'} = 'اعمال قالب';
    $Self->{Translation}->{'NewTemplate'} = 'قالب جدید';
    $Self->{Translation}->{'Save this CAB as template'} = 'این را به عنوان یک قالب ذخیره کن';
    $Self->{Translation}->{'Add to CAB'} = 'افزودن به هیئت مشاوران تغییر';
    $Self->{Translation}->{'Invalid User'} = 'کاربر نامعتبر';
    $Self->{Translation}->{'Current CAB'} = 'هیئت مشاور کنونی';

    # Template: AgentITSMChangeOverviewNavBar
    $Self->{Translation}->{'Context Settings'} = 'تنظیمات مفاد';
    $Self->{Translation}->{'Changes per page'} = 'تغییر در صفحه';

    # Template: AgentITSMChangeOverviewSmall
    $Self->{Translation}->{'WorkOrderTitle'} = 'عنوان دستور کار';
    $Self->{Translation}->{'ChangeTitle'} = 'عنوان تغییر';
    $Self->{Translation}->{'WorkOrderAgent'} = 'کارشناس انجام دستور کار';
    $Self->{Translation}->{'Workorders'} = 'دستور کارها';
    $Self->{Translation}->{'ChangeState'} = 'وضعیت تغییر';
    $Self->{Translation}->{'WorkOrderState'} = 'وضعیت دستور کار';
    $Self->{Translation}->{'WorkOrderType'} = 'نوع دستور کار';
    $Self->{Translation}->{'Requested Time'} = 'زمان درخواست شده';
    $Self->{Translation}->{'PlannedStartTime'} = 'زمان آغاز برنامه‌ریزی شده';
    $Self->{Translation}->{'PlannedEndTime'} = 'زمان خاتمه برنامه‌ریزی شده';
    $Self->{Translation}->{'ActualStartTime'} = 'زمان آغاز در عمل';
    $Self->{Translation}->{'ActualEndTime'} = 'زمان خاتمه در عمل';

    # Template: AgentITSMChangePrint
    $Self->{Translation}->{'ITSM Workorder'} = 'دستور کار';

    # Template: AgentITSMChangeReset
    $Self->{Translation}->{'Do you really want to reset this change?'} = '';

    # Template: AgentITSMChangeSearch
    $Self->{Translation}->{'(e.g. 10*5155 or 105658*)'} = 'مثال: 10*5155 یا 105658*';
    $Self->{Translation}->{'CABAgent'} = 'کارشناس هیئت مشاور تغییر';
    $Self->{Translation}->{'e.g.'} = 'به عنوان مثال';
    $Self->{Translation}->{'CABCustomer'} = 'هیئت مشاور تغییر - مشترک';
    $Self->{Translation}->{'Instruction'} = 'دستورالعمل';
    $Self->{Translation}->{'Report'} = 'گزارش';
    $Self->{Translation}->{'Change Category'} = 'تغییر طبقه‌بندی';
    $Self->{Translation}->{'(before/after)'} = 'قبل از/بعد از';
    $Self->{Translation}->{'(between)'} = 'بین';
    $Self->{Translation}->{'Run Search'} = '';

    # Template: AgentITSMChangeSearchResultPrint
    $Self->{Translation}->{'WorkOrders'} = 'دستور کارها';

    # Template: AgentITSMChangeTemplate
    $Self->{Translation}->{'Save Change as Template'} = 'ذخیره تغییر به عنوان قالب';
    $Self->{Translation}->{'A template should have a name!'} = 'قالب باید دارای نام باشد!';
    $Self->{Translation}->{'The template name is required.'} = 'نام قالب مورد نیاز است.';
    $Self->{Translation}->{'Reset States'} = 'تنظیم مجدد وضعیت‌ها';

    # Template: AgentITSMChangeTimeSlot
    $Self->{Translation}->{'Move Time Slot'} = 'جابجایی شیار زمان';

    # Template: AgentITSMChangeZoom
    $Self->{Translation}->{'Change Information'} = 'اطلاعات تغییر';
    $Self->{Translation}->{'PlannedEffort'} = 'سعی برنامه‌ریزی شده';
    $Self->{Translation}->{'Change Initiator(s)'} = 'آغازگر تغییر';
    $Self->{Translation}->{'Change Manager'} = 'مدیر تغییر';
    $Self->{Translation}->{'Change Builder'} = 'سازنده تغییر';
    $Self->{Translation}->{'CAB'} = 'هیئت مشاور تغییر';
    $Self->{Translation}->{'Last changed'} = 'آخرین تغییر ';
    $Self->{Translation}->{'Last changed by'} = 'آخرین تغییر توسط';
    $Self->{Translation}->{'Ok'} = 'تایید';
    $Self->{Translation}->{'Download Attachment'} = 'دریافت پیوست';

    # Template: AgentITSMTemplateDelete
    $Self->{Translation}->{'Do you really want to delete this template?'} = 'آیا واقعا مایل به حذف این قالب هستید؟';

    # Template: AgentITSMTemplateEdit

    # Template: AgentITSMTemplateOverviewNavBar

    # Template: AgentITSMTemplateOverviewSmall
    $Self->{Translation}->{'TemplateID'} = 'شناسه قالب';
    $Self->{Translation}->{'CreateBy'} = 'ساخته شده توسط';
    $Self->{Translation}->{'CreateTime'} = 'ساخته شده';
    $Self->{Translation}->{'ChangeBy'} = 'تغییر یافته توسط';
    $Self->{Translation}->{'ChangeTime'} = 'تغییر یافته';
    $Self->{Translation}->{'Delete: '} = 'حذف: ';
    $Self->{Translation}->{'Delete Template'} = 'حذف قالب';

    # Template: AgentITSMUserSearch

    # Template: AgentITSMWorkOrderAdd
    $Self->{Translation}->{'Add Workorder to'} = 'افزودن دستور کار به';
    $Self->{Translation}->{'Invalid workorder type.'} = 'نوع دستور کار نامعتبر است.';
    $Self->{Translation}->{'The planned start time must be before the planned end time!'} = 'زمان آغاز باید قبل از زمان پایان باشد!';
    $Self->{Translation}->{'Invalid format.'} = 'قالب نامعتبر است.';

    # Template: AgentITSMWorkOrderAddFromTemplate
    $Self->{Translation}->{'Select Workorder Template'} = 'انتخاب قالب دستور کار';

    # Template: AgentITSMWorkOrderAgent

    # Template: AgentITSMWorkOrderDelete
    $Self->{Translation}->{'Do you really want to delete this workorder?'} = 'آیا مایل به حذف این دستور کار هستید؟';
    $Self->{Translation}->{'You can not delete this Workorder. It is used in at least one Condition!'} =
        'شما نمی‌توانید این دستور کار را حذف نمایید زیرا حداقل در یک شرط استفاده شده است.';
    $Self->{Translation}->{'This Workorder is used in the following Condition(s)'} = 'این دستور کار در شروط زیر استفاده شده است';

    # Template: AgentITSMWorkOrderEdit
    $Self->{Translation}->{'Move following workorders accordingly'} = '';
    $Self->{Translation}->{'If the planned end time of this workorder is changed, the planned start times of all following workorders will be changed accordingly'} =
        '';

    # Template: AgentITSMWorkOrderHistory

    # Template: AgentITSMWorkOrderHistoryZoom

    # Template: AgentITSMWorkOrderReport
    $Self->{Translation}->{'The actual start time must be before the actual end time!'} = 'زمان واقعی آغاز باید قبل از زمان واقعی خاتمه باشد!';
    $Self->{Translation}->{'The actual start time must be set, when the actual end time is set!'} =
        'زمانی که زمان واقعی خاتمه مشخص شده است، می‌بایست زمان واقعی آغاز نیز مشخص شده باشد!';
    $Self->{Translation}->{'Existing attachments'} = '';

    # Template: AgentITSMWorkOrderTake
    $Self->{Translation}->{'Current Agent'} = 'کارشناس کنونی';
    $Self->{Translation}->{'Do you really want to take this workorder?'} = 'آیا واقعا می‌خواهید این دستور کار را بگیرید؟';

    # Template: AgentITSMWorkOrderTemplate
    $Self->{Translation}->{'Save Workorder as Template'} = 'ذخیره دستور کار به عنوان قالب';

    # Template: AgentITSMWorkOrderZoom
    $Self->{Translation}->{'Workorder Information'} = 'اطلاعات قالب کار';

    # Template: CustomerITSMChangeOverview

    # Template: ITSMChange

    # SysConfig
    $Self->{Translation}->{'A list of the agents who have permission to take workorders. Key is a login name. Content is 0 or 1.'} =
        'فهرست کارشناسانی که اجازه دسترسی برای گرفتن دستور کار را دارا هستند. کلید یک نام برای ورود است. محتوا 0 یا 1 است.';
    $Self->{Translation}->{'A list of workorder states, at which the ActualStartTime of a workorder will be set if it was empty at this point.'} =
        'فهرستی از وضعیت‌های دستور کار که در صورتی در اینجا وارد نشود، به عنوان زمان واقعی آغاز مشخص خواهد شد.';
    $Self->{Translation}->{'Admin of notification rules.'} = 'مدیر قواعد اعلان';
    $Self->{Translation}->{'Admin of the CIP matrix.'} = 'مدیر ماتریس اهمیت <-> اثر <-> الویت';
    $Self->{Translation}->{'Admin of the state machine.'} = 'مدیر ماشین وضعیت';
    $Self->{Translation}->{'Agent interface notification module to see the number of change advisory boards.'} =
        'ماژول اعلان واسط کارشناس برای نمایش تعداد هیئت‌های مشاور تغییرات';
    $Self->{Translation}->{'Agent interface notification module to see the number of changes managed by the user.'} =
        'ماژول اعلان واسط کارشناس برای نمایش تعداد تغییرات مدیریت شده توسط کاربر';
    $Self->{Translation}->{'Agent interface notification module to see the number of changes.'} =
        'ماژول اعلان واسط کارشناس برای نمایش تعداد تغییرات';
    $Self->{Translation}->{'Agent interface notification module to see the number of work orders.'} =
        'ماژول اعلان واسط کارشناس برای نمایش تعداد دستور کارها';
    $Self->{Translation}->{'Cache time in minutes for the change management toolbars. Default: 3 hours (180 minutes).'} =
        '';
    $Self->{Translation}->{'Cache time in minutes for the change management. Default: 5 days (7200 minutes).'} =
        '';
    $Self->{Translation}->{'Change Overview "Small" Limit'} = 'نمای کلی تغییر به صورت کوچک';
    $Self->{Translation}->{'Change free text options shown in the change add of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.'} =
        '';
    $Self->{Translation}->{'Change free text options shown in the change edit of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.'} =
        '';
    $Self->{Translation}->{'Change free text options shown in the change search of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled.'} =
        '';
    $Self->{Translation}->{'Change limit per page for Change Overview "Small"'} = 'تغییر محدودیت برای هر صفحه برای نمای کوچک تغییر';
    $Self->{Translation}->{'Change search backend router of the agent interface.'} = 'تغییر مسیریاب جستجو در رابط کاربری کارشناس';
    $Self->{Translation}->{'Configures how often the notifications are sent when planned the start time or other time values have been reached/passed.'} =
        '';
    $Self->{Translation}->{'Default type for a workorder. This entry must exist in general catalog class \'ITSM::ChangeManagement::WorkOrder::Type\'.'} =
        '';
    $Self->{Translation}->{'Define the signals for each workorder state.'} = 'تعریف علائم برای هر وضعیت دستور کار';
    $Self->{Translation}->{'Defines an overview module to show the small view of a change list.'} =
        'تعریف ماژول نمای کلی برای نمایش نمای کوچک از فهرست تغییرات';
    $Self->{Translation}->{'Defines an overview module to show the small view of a template list.'} =
        'تعریف ماژول نمای کلی برای نمایش نمای کوچک از فهرست قالب‌ها';
    $Self->{Translation}->{'Defines if it will be possible to print the accounted time.'} = '';
    $Self->{Translation}->{'Defines if it will be possible to print the planned effort.'} = '';
    $Self->{Translation}->{'Defines if reachable (as defined by the state machine) change end states should be allowed if a change is in a locked state.'} =
        '';
    $Self->{Translation}->{'Defines if reachable (as defined by the state machine) workorder end states should be allowed if a workorder is in a locked state.'} =
        '';
    $Self->{Translation}->{'Defines if the accounted time should be shown.'} = '';
    $Self->{Translation}->{'Defines if the actual start and end times should be set.'} = '';
    $Self->{Translation}->{'Defines if the change search and the workorder search functions could use the mirror DB.'} =
        '';
    $Self->{Translation}->{'Defines if the change state can be set in AgentITSMChangeEdit.'} =
        '';
    $Self->{Translation}->{'Defines if the planned effort should be shown.'} = '';
    $Self->{Translation}->{'Defines if the requested date should be print by customer.'} = '';
    $Self->{Translation}->{'Defines if the requested date should be searched by customer.'} =
        '';
    $Self->{Translation}->{'Defines if the requested date should be set by customer.'} = '';
    $Self->{Translation}->{'Defines if the requested date should be shown by customer.'} = '';
    $Self->{Translation}->{'Defines if the workorder state should be shown.'} = '';
    $Self->{Translation}->{'Defines if the workorder title should be shown.'} = '';
    $Self->{Translation}->{'Defines shown graph attributes.'} = '';
    $Self->{Translation}->{'Defines that only changes containing Workorders linked with services, which the customer user has permission to use will be shown. Any other changes will not be displayed.'} =
        '';
    $Self->{Translation}->{'Defines the change states that will be allowed to delete.'} = '';
    $Self->{Translation}->{'Defines the change states that will be used as filters in the Change PSA overview.'} =
        '';
    $Self->{Translation}->{'Defines the change states that will be used as filters in the Change Schedule overview.'} =
        '';
    $Self->{Translation}->{'Defines the change states that will be used as filters in the MyCAB overview.'} =
        '';
    $Self->{Translation}->{'Defines the change states that will be used as filters in the MyChanges overview.'} =
        '';
    $Self->{Translation}->{'Defines the change states that will be used as filters in the change manager overview.'} =
        '';
    $Self->{Translation}->{'Defines the change states that will be used as filters in the change overview.'} =
        '';
    $Self->{Translation}->{'Defines the change states that will be used as filters in the customer change schedule overview.'} =
        '';
    $Self->{Translation}->{'Defines the default selection of the free key field number 1 for changes (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد کلید آزاد شماره ۱ برای تغییرات (اگر بیش از یک انتخاب مهیا شده باشد).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 1 for workorders (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد کلید آزاد شماره ۱ برای دستور کارها (اگر بیش از یک انتخاب مهیا شده باشد).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 10 for changes (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد کلید آزاد شماره ۱۰ برای تغییرات (اگر بیش از یک انتخاب مهیا شده باشد).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 10 for workorders (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد کلید آزاد شماره ۱۰ برای دستور کارها (اگر بیش از یک انتخاب مهیا شده باشد).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 11 for changes (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد کلید آزاد شماره ۱۱ برای تغییرات (اگر بیش از یک انتخاب مهیا شده باشد).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 11 for workorders (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد کلید آزاد شماره ۱۱ برای دستور کارها (اگر بیش از یک انتخاب مهیا شده باشد).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 12 for changes (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد کلید آزاد شماره ۱۲ برای تغییرات (اگر بیش از یک انتخاب مهیا شده باشد).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 12 for workorders (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد کلید آزاد شماره ۱۲ برای دستور کارها (اگر بیش از یک انتخاب مهیا شده باشد).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 13 for changes (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد کلید آزاد شماره ۱۳ برای تغییرات (اگر بیش از یک انتخاب مهیا شده باشد).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 13 for workorders (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد کلید آزاد شماره ۱۳ برای دستور کارها (اگر بیش از یک انتخاب مهیا شده باشد).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 14 for changes (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد کلید آزاد شماره ۱۴ برای تغییرات (اگر بیش از یک انتخاب مهیا شده باشد).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 14 for workorders (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد کلید آزاد شماره ۱۴ برای دستور کارها (اگر بیش از یک انتخاب مهیا شده باشد).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 15 for changes (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد کلید آزاد شماره ۱۵ برای تغییرات (اگر بیش از یک انتخاب مهیا شده باشد).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 15 for workorders (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد کلید آزاد شماره ۱۵ برای دستور کارها (اگر بیش از یک انتخاب مهیا شده باشد).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 16 for changes (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد کلید آزاد شماره ۱۶ برای تغییرات (اگر بیش از یک انتخاب مهیا شده باشد).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 16 for workorders (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد کلید آزاد شماره ۱۶ برای دستور کارها (اگر بیش از یک انتخاب مهیا شده باشد).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 17 for changes (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد کلید آزاد شماره ۱۷ برای تغییرات (اگر بیش از یک انتخاب مهیا شده باشد).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 17 for workorders (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد کلید آزاد شماره ۱۷ برای دستور کارها (اگر بیش از یک انتخاب مهیا شده باشد).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 18 for changes (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد کلید آزاد شماره ۱۸ برای تغییرات (اگر بیش از یک انتخاب مهیا شده باشد).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 18 for workorders (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد کلید آزاد شماره ۱۸ برای دستور کارها (اگر بیش از یک انتخاب مهیا شده باشد).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 19 for changes (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد کلید آزاد شماره ۱۹ برای تغییرات (اگر بیش از یک انتخاب مهیا شده باشد).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 19 for workorders (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد کلید آزاد شماره ۱۹ برای دستور کارها (اگر بیش از یک انتخاب مهیا شده باشد).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 2 for changes (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد کلید آزاد شماره ۲ برای تغییرات (اگر بیش از یک انتخاب مهیا شده باشد).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 2 for workorders (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد کلید آزاد شماره ۲ برای دستور کارها (اگر بیش از یک انتخاب مهیا شده باشد).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 20 for changes (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد کلید آزاد شماره ۲۰ برای تغییرات (اگر بیش از یک انتخاب مهیا شده باشد).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 20 for workorders (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد کلید آزاد شماره ۲۰ برای دستور کارها (اگر بیش از یک انتخاب مهیا شده باشد).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 21 for changes (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد کلید آزاد شماره ۲۱ برای تغییرات (اگر بیش از یک انتخاب مهیا شده باشد).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 21 for workorders (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد کلید آزاد شماره ۲۱ برای دستور کارها (اگر بیش از یک انتخاب مهیا شده باشد).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 22 for changes (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد کلید آزاد شماره ۲۲ برای تغییرات (اگر بیش از یک انتخاب مهیا شده باشد).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 22 for workorders (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد کلید آزاد شماره ۲۲ برای دستور کارها (اگر بیش از یک انتخاب مهیا شده باشد).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 23 for changes (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد کلید آزاد شماره ۲۳ برای تغییرات (اگر بیش از یک انتخاب مهیا شده باشد).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 23 for workorders (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد کلید آزاد شماره ۲۳ برای دستور کارها (اگر بیش از یک انتخاب مهیا شده باشد).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 24 for changes (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد کلید آزاد شماره ۲۴ برای تغییرات (اگر بیش از یک انتخاب مهیا شده باشد).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 24 for workorders (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد کلید آزاد شماره ۲۴ برای دستور کارها (اگر بیش از یک انتخاب مهیا شده باشد).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 25 for changes (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد کلید آزاد شماره ۲۵ برای تغییرات (اگر بیش از یک انتخاب مهیا شده باشد).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 25 for workorders (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد کلید آزاد شماره ۲۵ برای دستور کارها (اگر بیش از یک انتخاب مهیا شده باشد).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 26 for changes (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد کلید آزاد شماره ۲۶ برای تغییرات (اگر بیش از یک انتخاب مهیا شده باشد).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 26 for workorders (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد کلید آزاد شماره ۲۶ برای دستور کارها (اگر بیش از یک انتخاب مهیا شده باشد).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 27 for changes (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد کلید آزاد شماره ۲۷ برای تغییرات (اگر بیش از یک انتخاب مهیا شده باشد).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 27 for workorders (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد کلید آزاد شماره ۲۷ برای دستور کارها (اگر بیش از یک انتخاب مهیا شده باشد).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 28 for changes (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد کلید آزاد شماره ۲۸ برای تغییرات (اگر بیش از یک انتخاب مهیا شده باشد).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 28 for workorders (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد کلید آزاد شماره ۲۸ برای دستور کارها (اگر بیش از یک انتخاب مهیا شده باشد).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 29 for changes (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد کلید آزاد شماره ۲۹ برای تغییرات (اگر بیش از یک انتخاب مهیا شده باشد).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 29 for workorders (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد کلید آزاد شماره ۲۹ برای دستور کارها (اگر بیش از یک انتخاب مهیا شده باشد).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 3 for changes (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد کلید آزاد شماره ۳ برای تغییرات (اگر بیش از یک انتخاب مهیا شده باشد).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 3 for workorders (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد کلید آزاد شماره ۳ برای دستور کارها (اگر بیش از یک انتخاب مهیا شده باشد).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 30 for changes (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد کلید آزاد شماره ۳۰ برای تغییرات (اگر بیش از یک انتخاب مهیا شده باشد).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 30 for workorders (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد کلید آزاد شماره ۳۰ برای دستور کارها (اگر بیش از یک انتخاب مهیا شده باشد).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 31 for changes (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد کلید آزاد شماره ۳۱ برای تغییرات (اگر بیش از یک انتخاب مهیا شده باشد).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 31 for workorders (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد کلید آزاد شماره ۳۱ برای دستور کارها (اگر بیش از یک انتخاب مهیا شده باشد).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 32 for changes (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد کلید آزاد شماره ۳۲ برای تغییرات (اگر بیش از یک انتخاب مهیا شده باشد).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 32 for workorders (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد کلید آزاد شماره ۳۲ برای دستور کارها (اگر بیش از یک انتخاب مهیا شده باشد).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 33 for changes (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد کلید آزاد شماره ۳۳ برای تغییرات (اگر بیش از یک انتخاب مهیا شده باشد).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 33 for workorders (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد کلید آزاد شماره ۳۳ برای دستور کارها (اگر بیش از یک انتخاب مهیا شده باشد).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 34 for changes (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد کلید آزاد شماره ۳۴ برای تغییرات (اگر بیش از یک انتخاب مهیا شده باشد).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 34 for workorders (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد کلید آزاد شماره ۳۴ برای دستور کارها (اگر بیش از یک انتخاب مهیا شده باشد).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 35 for changes (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد کلید آزاد شماره ۳۵ برای تغییرات (اگر بیش از یک انتخاب مهیا شده باشد).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 35 for workorders (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد کلید آزاد شماره ۳۵ برای دستور کارها (اگر بیش از یک انتخاب مهیا شده باشد).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 36 for changes (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد کلید آزاد شماره ۳۶ برای تغییرات (اگر بیش از یک انتخاب مهیا شده باشد).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 36 for workorders (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد کلید آزاد شماره ۳۶ برای دستور کارها (اگر بیش از یک انتخاب مهیا شده باشد).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 37 for changes (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد کلید آزاد شماره ۳۷ برای تغییرات (اگر بیش از یک انتخاب مهیا شده باشد).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 37 for workorders (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد کلید آزاد شماره ۳۷ برای دستور کارها (اگر بیش از یک انتخاب مهیا شده باشد).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 38 for changes (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد کلید آزاد شماره ۳۸ برای تغییرات (اگر بیش از یک انتخاب مهیا شده باشد).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 38 for workorders (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد کلید آزاد شماره ۳۸ برای دستور کارها (اگر بیش از یک انتخاب مهیا شده باشد).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 39 for changes (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد کلید آزاد شماره ۳۹ برای تغییرات (اگر بیش از یک انتخاب مهیا شده باشد).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 39 for workorders (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد کلید آزاد شماره ۳۹ برای دستور کارها (اگر بیش از یک انتخاب مهیا شده باشد).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 4 for changes (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد کلید آزاد شماره ۴ برای تغییرات (اگر بیش از یک انتخاب مهیا شده باشد).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 4 for workorders (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد کلید آزاد شماره ۴ برای دستور کارها (اگر بیش از یک انتخاب مهیا شده باشد).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 40 for changes (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد کلید آزاد شماره ۴۰ برای تغییرات (اگر بیش از یک انتخاب مهیا شده باشد).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 40 for workorders (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد کلید آزاد شماره ۴۰ برای دستور کارها (اگر بیش از یک انتخاب مهیا شده باشد).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 41 for changes (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد کلید آزاد شماره ۴۱ برای تغییرات (اگر بیش از یک انتخاب مهیا شده باشد).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 41 for workorders (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد کلید آزاد شماره ۴۱ برای دستور کارها (اگر بیش از یک انتخاب مهیا شده باشد).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 42 for changes (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد کلید آزاد شماره ۴۲ برای تغییرات (اگر بیش از یک انتخاب مهیا شده باشد).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 42 for workorders (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد کلید آزاد شماره ۴۲ برای دستور کارها (اگر بیش از یک انتخاب مهیا شده باشد).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 43 for changes (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد کلید آزاد شماره ۴۳ برای تغییرات (اگر بیش از یک انتخاب مهیا شده باشد).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 43 for workorders (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد کلید آزاد شماره ۴۳ برای دستور کارها (اگر بیش از یک انتخاب مهیا شده باشد).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 44 for changes (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد کلید آزاد شماره ۴۴ برای تغییرات (اگر بیش از یک انتخاب مهیا شده باشد).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 44 for workorders (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد کلید آزاد شماره ۴۴ برای دستور کارها (اگر بیش از یک انتخاب مهیا شده باشد).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 45 for changes (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد کلید آزاد شماره ۴۵ برای تغییرات (اگر بیش از یک انتخاب مهیا شده باشد).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 45 for workorders (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد کلید آزاد شماره ۴۵ برای دستور کارها (اگر بیش از یک انتخاب مهیا شده باشد).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 46 for changes (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد کلید آزاد شماره ۴۶ برای تغییرات (اگر بیش از یک انتخاب مهیا شده باشد).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 46 for workorders (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد کلید آزاد شماره ۴۶ برای دستور کارها (اگر بیش از یک انتخاب مهیا شده باشد).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 47 for changes (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد کلید آزاد شماره ۴۷ برای تغییرات (اگر بیش از یک انتخاب مهیا شده باشد).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 47 for workorders (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد کلید آزاد شماره ۴۷ برای دستور کارها (اگر بیش از یک انتخاب مهیا شده باشد).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 48 for changes (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد کلید آزاد شماره ۴۸ برای تغییرات (اگر بیش از یک انتخاب مهیا شده باشد).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 48 for workorders (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد کلید آزاد شماره ۴۸ برای دستور کارها (اگر بیش از یک انتخاب مهیا شده باشد).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 49 for changes (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد کلید آزاد شماره ۴۹ برای تغییرات (اگر بیش از یک انتخاب مهیا شده باشد).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 49 for workorders (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد کلید آزاد شماره ۴۹ برای دستور کارها (اگر بیش از یک انتخاب مهیا شده باشد).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 5 for changes (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد کلید آزاد شماره ۵ برای تغییرات (اگر بیش از یک انتخاب مهیا شده باشد).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 5 for workorders (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد کلید آزاد شماره ۵ برای دستور کارها (اگر بیش از یک انتخاب مهیا شده باشد).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 50 for changes (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد کلید آزاد شماره ۵۰ برای تغییرات (اگر بیش از یک انتخاب مهیا شده باشد).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 50 for workorders (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد کلید آزاد شماره ۵۰ برای دستور کارها (اگر بیش از یک انتخاب مهیا شده باشد).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 6 for changes (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد کلید آزاد شماره ۶ برای تغییرات (اگر بیش از یک انتخاب مهیا شده باشد).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 6 for workorders (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد کلید آزاد شماره ۶ برای دستور کارها (اگر بیش از یک انتخاب مهیا شده باشد).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 7 for changes (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد کلید آزاد شماره ۷ برای تغییرات (اگر بیش از یک انتخاب مهیا شده باشد).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 7 for workorders (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد کلید آزاد شماره ۷ برای دستور کارها (اگر بیش از یک انتخاب مهیا شده باشد).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 8 for changes (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد کلید آزاد شماره ۸ برای تغییرات (اگر بیش از یک انتخاب مهیا شده باشد).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 8 for workorders (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد کلید آزاد شماره ۸ برای دستور کارها (اگر بیش از یک انتخاب مهیا شده باشد).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 9 for changes (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد کلید آزاد شماره ۹ برای تغییرات (اگر بیش از یک انتخاب مهیا شده باشد).';
    $Self->{Translation}->{'Defines the default selection of the free key field number 9 for workorders (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد کلید آزاد شماره ۹ برای دستور کارها (اگر بیش از یک انتخاب مهیا شده باشد).';
    $Self->{Translation}->{'Defines the default selection of the free text field number 1 for changes (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد متن آزاد شماره ۱ برای تغییرات (اگر بیش از یک انتخاب مهیا شده باشد).';
    $Self->{Translation}->{'Defines the default selection of the free text field number 1 for workorders (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد متن آزاد شماره ۱ برای دستور کارها (اگر بیش از یک انتخاب مهیا شده باشد)';
    $Self->{Translation}->{'Defines the default selection of the free text field number 10 for changes (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد متن آزاد شماره ۱۰ برای تغییرات (اگر بیش از یک انتخاب مهیا شده باشد)';
    $Self->{Translation}->{'Defines the default selection of the free text field number 10 for workorders (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد متن آزاد شماره ۱۰ برای دستور کارها (اگر بیش از یک انتخاب مهیا شده باشد)';
    $Self->{Translation}->{'Defines the default selection of the free text field number 11 for changes (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد متن آزاد شماره ۱۱ برای تغییرات (اگر بیش از یک انتخاب مهیا شده باشد)';
    $Self->{Translation}->{'Defines the default selection of the free text field number 11 for workorders (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد متن آزاد شماره ۱۱ برای دستور کارها (اگر بیش از یک انتخاب مهیا شده باشد)';
    $Self->{Translation}->{'Defines the default selection of the free text field number 12 for changes (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد متن آزاد شماره ۱۲ برای تغییرات (اگر بیش از یک انتخاب مهیا شده باشد)';
    $Self->{Translation}->{'Defines the default selection of the free text field number 12 for workorders (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد متن آزاد شماره ۱۲ برای دستور کارها (اگر بیش از یک انتخاب مهیا شده باشد)';
    $Self->{Translation}->{'Defines the default selection of the free text field number 13 for changes (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد متن آزاد شماره ۱۳ برای تغییرات (اگر بیش از یک انتخاب مهیا شده باشد)';
    $Self->{Translation}->{'Defines the default selection of the free text field number 13 for workorders (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد متن آزاد شماره ۱۳ برای دستور کارها (اگر بیش از یک انتخاب مهیا شده باشد)';
    $Self->{Translation}->{'Defines the default selection of the free text field number 14 for changes (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد متن آزاد شماره ۱۴ برای تغییرات (اگر بیش از یک انتخاب مهیا شده باشد)';
    $Self->{Translation}->{'Defines the default selection of the free text field number 14 for workorders (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد متن آزاد شماره ۱۴ برای دستور کارها (اگر بیش از یک انتخاب مهیا شده باشد)';
    $Self->{Translation}->{'Defines the default selection of the free text field number 15 for changes (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد متن آزاد شماره ۱۵ برای تغییرات (اگر بیش از یک انتخاب مهیا شده باشد)';
    $Self->{Translation}->{'Defines the default selection of the free text field number 15 for workorders (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد متن آزاد شماره ۱۵ برای دستور کارها (اگر بیش از یک انتخاب مهیا شده باشد)';
    $Self->{Translation}->{'Defines the default selection of the free text field number 16 for changes (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد متن آزاد شماره ۱۶ برای تغییرات (اگر بیش از یک انتخاب مهیا شده باشد)';
    $Self->{Translation}->{'Defines the default selection of the free text field number 16 for workorders (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد متن آزاد شماره ۱۶ برای دستور کارها (اگر بیش از یک انتخاب مهیا شده باشد)';
    $Self->{Translation}->{'Defines the default selection of the free text field number 17 for changes (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد متن آزاد شماره ۱۷ برای تغییرات (اگر بیش از یک انتخاب مهیا شده باشد)';
    $Self->{Translation}->{'Defines the default selection of the free text field number 17 for workorders (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد متن آزاد شماره ۱۷ برای دستور کارها (اگر بیش از یک انتخاب مهیا شده باشد)';
    $Self->{Translation}->{'Defines the default selection of the free text field number 18 for changes (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد متن آزاد شماره ۱۸ برای تغییرات (اگر بیش از یک انتخاب مهیا شده باشد)';
    $Self->{Translation}->{'Defines the default selection of the free text field number 18 for workorders (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد متن آزاد شماره ۱۸ برای دستور کارها (اگر بیش از یک انتخاب مهیا شده باشد)';
    $Self->{Translation}->{'Defines the default selection of the free text field number 19 for changes (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد متن آزاد شماره ۱۹ برای تغییرات (اگر بیش از یک انتخاب مهیا شده باشد)';
    $Self->{Translation}->{'Defines the default selection of the free text field number 19 for workorders (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد متن آزاد شماره ۱۹ برای دستور کارها (اگر بیش از یک انتخاب مهیا شده باشد)';
    $Self->{Translation}->{'Defines the default selection of the free text field number 2 for changes (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد متن آزاد شماره ۲ برای تغییرات (اگر بیش از یک انتخاب مهیا شده باشد)';
    $Self->{Translation}->{'Defines the default selection of the free text field number 2 for workorders (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد متن آزاد شماره ۲ برای دستور کارها (اگر بیش از یک انتخاب مهیا شده باشد)';
    $Self->{Translation}->{'Defines the default selection of the free text field number 20 for changes (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد متن آزاد شماره ۲۰ برای تغییرات (اگر بیش از یک انتخاب مهیا شده باشد)';
    $Self->{Translation}->{'Defines the default selection of the free text field number 20 for workorders (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد متن آزاد شماره ۲۰ برای دستور کارها (اگر بیش از یک انتخاب مهیا شده باشد)';
    $Self->{Translation}->{'Defines the default selection of the free text field number 21 for changes (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد متن آزاد شماره ۲۱ برای تغییرات (اگر بیش از یک انتخاب مهیا شده باشد)';
    $Self->{Translation}->{'Defines the default selection of the free text field number 21 for workorders (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد متن آزاد شماره ۲۱ برای دستور کارها (اگر بیش از یک انتخاب مهیا شده باشد)';
    $Self->{Translation}->{'Defines the default selection of the free text field number 22 for changes (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد متن آزاد شماره ۲۲ برای تغییرات (اگر بیش از یک انتخاب مهیا شده باشد)';
    $Self->{Translation}->{'Defines the default selection of the free text field number 22 for workorders (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد متن آزاد شماره ۲۲ برای دستور کارها (اگر بیش از یک انتخاب مهیا شده باشد)';
    $Self->{Translation}->{'Defines the default selection of the free text field number 23 for changes (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد متن آزاد شماره ۲۳ برای تغییرات (اگر بیش از یک انتخاب مهیا شده باشد)';
    $Self->{Translation}->{'Defines the default selection of the free text field number 23 for workorders (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد متن آزاد شماره ۲۳ برای دستور کارها (اگر بیش از یک انتخاب مهیا شده باشد)';
    $Self->{Translation}->{'Defines the default selection of the free text field number 24 for changes (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد متن آزاد شماره ۲۴ برای تغییرات (اگر بیش از یک انتخاب مهیا شده باشد)';
    $Self->{Translation}->{'Defines the default selection of the free text field number 24 for workorders (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد متن آزاد شماره ۲۴ برای دستور کارها (اگر بیش از یک انتخاب مهیا شده باشد)';
    $Self->{Translation}->{'Defines the default selection of the free text field number 25 for changes (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد متن آزاد شماره ۲۵ برای تغییرات (اگر بیش از یک انتخاب مهیا شده باشد)';
    $Self->{Translation}->{'Defines the default selection of the free text field number 25 for workorders (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد متن آزاد شماره ۲۵ برای دستور کارها (اگر بیش از یک انتخاب مهیا شده باشد)';
    $Self->{Translation}->{'Defines the default selection of the free text field number 26 for changes (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد متن آزاد شماره ۲۶ برای تغییرات (اگر بیش از یک انتخاب مهیا شده باشد)';
    $Self->{Translation}->{'Defines the default selection of the free text field number 26 for workorders (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد متن آزاد شماره ۲۶ برای دستور کارها (اگر بیش از یک انتخاب مهیا شده باشد)';
    $Self->{Translation}->{'Defines the default selection of the free text field number 27 for changes (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد متن آزاد شماره ۲۷ برای تغییرات (اگر بیش از یک انتخاب مهیا شده باشد)';
    $Self->{Translation}->{'Defines the default selection of the free text field number 27 for workorders (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد متن آزاد شماره ۲۷ برای دستور کارها (اگر بیش از یک انتخاب مهیا شده باشد)';
    $Self->{Translation}->{'Defines the default selection of the free text field number 28 for changes (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد متن آزاد شماره ۲۸ برای تغییرات (اگر بیش از یک انتخاب مهیا شده باشد)';
    $Self->{Translation}->{'Defines the default selection of the free text field number 28 for workorders (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد متن آزاد شماره ۲۸ برای دستور کارها (اگر بیش از یک انتخاب مهیا شده باشد)';
    $Self->{Translation}->{'Defines the default selection of the free text field number 29 for changes (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد متن آزاد شماره ۲۹ برای تغییرات (اگر بیش از یک انتخاب مهیا شده باشد)';
    $Self->{Translation}->{'Defines the default selection of the free text field number 29 for workorders (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد متن آزاد شماره ۲۹ برای دستور کارها (اگر بیش از یک انتخاب مهیا شده باشد)';
    $Self->{Translation}->{'Defines the default selection of the free text field number 3 for changes (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد متن آزاد شماره ۳ برای تغییرات (اگر بیش از یک انتخاب مهیا شده باشد)';
    $Self->{Translation}->{'Defines the default selection of the free text field number 3 for workorders (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد متن آزاد شماره ۳ برای دستور کارها (اگر بیش از یک انتخاب مهیا شده باشد)';
    $Self->{Translation}->{'Defines the default selection of the free text field number 30 for changes (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد متن آزاد شماره ۳۰ برای تغییرات (اگر بیش از یک انتخاب مهیا شده باشد)';
    $Self->{Translation}->{'Defines the default selection of the free text field number 30 for workorders (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد متن آزاد شماره ۳۰ برای دستور کارها (اگر بیش از یک انتخاب مهیا شده باشد)';
    $Self->{Translation}->{'Defines the default selection of the free text field number 31 for changes (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد متن آزاد شماره ۳۱ برای تغییرات (اگر بیش از یک انتخاب مهیا شده باشد)';
    $Self->{Translation}->{'Defines the default selection of the free text field number 31 for workorders (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد متن آزاد شماره ۳۱ برای دستور کارها (اگر بیش از یک انتخاب مهیا شده باشد)';
    $Self->{Translation}->{'Defines the default selection of the free text field number 32 for changes (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد متن آزاد شماره ۳۲ برای تغییرات (اگر بیش از یک انتخاب مهیا شده باشد)';
    $Self->{Translation}->{'Defines the default selection of the free text field number 32 for workorders (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد متن آزاد شماره ۳۲ برای دستور کارها (اگر بیش از یک انتخاب مهیا شده باشد)';
    $Self->{Translation}->{'Defines the default selection of the free text field number 33 for changes (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد متن آزاد شماره ۳۳ برای تغییرات (اگر بیش از یک انتخاب مهیا شده باشد)';
    $Self->{Translation}->{'Defines the default selection of the free text field number 33 for workorders (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد متن آزاد شماره ۳۳ برای دستور کارها (اگر بیش از یک انتخاب مهیا شده باشد)';
    $Self->{Translation}->{'Defines the default selection of the free text field number 34 for changes (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد متن آزاد شماره ۳۴ برای تغییرات (اگر بیش از یک انتخاب مهیا شده باشد)';
    $Self->{Translation}->{'Defines the default selection of the free text field number 34 for workorders (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد متن آزاد شماره ۳۴ برای دستور کارها (اگر بیش از یک انتخاب مهیا شده باشد)';
    $Self->{Translation}->{'Defines the default selection of the free text field number 35 for changes (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد متن آزاد شماره ۳۵ برای تغییرات (اگر بیش از یک انتخاب مهیا شده باشد)';
    $Self->{Translation}->{'Defines the default selection of the free text field number 35 for workorders (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد متن آزاد شماره ۳۵ برای دستور کارها (اگر بیش از یک انتخاب مهیا شده باشد)';
    $Self->{Translation}->{'Defines the default selection of the free text field number 36 for changes (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد متن آزاد شماره ۳۶ برای تغییرات (اگر بیش از یک انتخاب مهیا شده باشد)';
    $Self->{Translation}->{'Defines the default selection of the free text field number 36 for workorders (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد متن آزاد شماره ۳۶ برای دستور کارها (اگر بیش از یک انتخاب مهیا شده باشد)';
    $Self->{Translation}->{'Defines the default selection of the free text field number 37 for changes (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد متن آزاد شماره ۳۷ برای تغییرات (اگر بیش از یک انتخاب مهیا شده باشد)';
    $Self->{Translation}->{'Defines the default selection of the free text field number 37 for workorders (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد متن آزاد شماره ۳۷ برای دستور کارها (اگر بیش از یک انتخاب مهیا شده باشد)';
    $Self->{Translation}->{'Defines the default selection of the free text field number 38 for changes (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد متن آزاد شماره ۳۸ برای تغییرات (اگر بیش از یک انتخاب مهیا شده باشد)';
    $Self->{Translation}->{'Defines the default selection of the free text field number 38 for workorders (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد متن آزاد شماره ۳۸ برای دستور کارها (اگر بیش از یک انتخاب مهیا شده باشد)';
    $Self->{Translation}->{'Defines the default selection of the free text field number 39 for changes (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد متن آزاد شماره ۳۹ برای تغییرات (اگر بیش از یک انتخاب مهیا شده باشد)';
    $Self->{Translation}->{'Defines the default selection of the free text field number 39 for workorders (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد متن آزاد شماره ۳۹ برای دستور کارها (اگر بیش از یک انتخاب مهیا شده باشد)';
    $Self->{Translation}->{'Defines the default selection of the free text field number 4 for changes (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد متن آزاد شماره ۴ برای تغییرات (اگر بیش از یک انتخاب مهیا شده باشد)';
    $Self->{Translation}->{'Defines the default selection of the free text field number 4 for workorders (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد متن آزاد شماره ۴ برای دستور کارها (اگر بیش از یک انتخاب مهیا شده باشد)';
    $Self->{Translation}->{'Defines the default selection of the free text field number 40 for changes (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد متن آزاد شماره ۴۰ برای تغییرات (اگر بیش از یک انتخاب مهیا شده باشد)';
    $Self->{Translation}->{'Defines the default selection of the free text field number 40 for workorders (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد متن آزاد شماره ۴۰ برای دستور کارها (اگر بیش از یک انتخاب مهیا شده باشد)';
    $Self->{Translation}->{'Defines the default selection of the free text field number 41 for changes (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد متن آزاد شماره ۴۱ برای تغییرات (اگر بیش از یک انتخاب مهیا شده باشد)';
    $Self->{Translation}->{'Defines the default selection of the free text field number 41 for workorders (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد متن آزاد شماره ۴۱ برای دستور کارها (اگر بیش از یک انتخاب مهیا شده باشد)';
    $Self->{Translation}->{'Defines the default selection of the free text field number 42 for changes (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد متن آزاد شماره ۴۲ برای تغییرات (اگر بیش از یک انتخاب مهیا شده باشد)';
    $Self->{Translation}->{'Defines the default selection of the free text field number 42 for workorders (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد متن آزاد شماره ۴۲ برای دستور کارها (اگر بیش از یک انتخاب مهیا شده باشد)';
    $Self->{Translation}->{'Defines the default selection of the free text field number 43 for changes (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد متن آزاد شماره ۴۳ برای تغییرات (اگر بیش از یک انتخاب مهیا شده باشد)';
    $Self->{Translation}->{'Defines the default selection of the free text field number 43 for workorders (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد متن آزاد شماره ۴۳ برای دستور کارها (اگر بیش از یک انتخاب مهیا شده باشد)';
    $Self->{Translation}->{'Defines the default selection of the free text field number 44 for changes (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد متن آزاد شماره ۴۴ برای تغییرات (اگر بیش از یک انتخاب مهیا شده باشد)';
    $Self->{Translation}->{'Defines the default selection of the free text field number 44 for workorders (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد متن آزاد شماره ۴۴ برای دستور کارها (اگر بیش از یک انتخاب مهیا شده باشد)';
    $Self->{Translation}->{'Defines the default selection of the free text field number 45 for changes (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد متن آزاد شماره ۴۵ برای تغییرات (اگر بیش از یک انتخاب مهیا شده باشد)';
    $Self->{Translation}->{'Defines the default selection of the free text field number 45 for workorders (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد متن آزاد شماره ۴۵ برای دستور کارها (اگر بیش از یک انتخاب مهیا شده باشد)';
    $Self->{Translation}->{'Defines the default selection of the free text field number 46 for changes (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد متن آزاد شماره ۴۶ برای تغییرات (اگر بیش از یک انتخاب مهیا شده باشد)';
    $Self->{Translation}->{'Defines the default selection of the free text field number 46 for workorders (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد متن آزاد شماره ۴۶ برای دستور کارها (اگر بیش از یک انتخاب مهیا شده باشد)';
    $Self->{Translation}->{'Defines the default selection of the free text field number 47 for changes (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد متن آزاد شماره ۴۷ برای تغییرات (اگر بیش از یک انتخاب مهیا شده باشد)';
    $Self->{Translation}->{'Defines the default selection of the free text field number 47 for workorders (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد متن آزاد شماره ۴۷ برای دستور کارها (اگر بیش از یک انتخاب مهیا شده باشد)';
    $Self->{Translation}->{'Defines the default selection of the free text field number 48 for changes (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد متن آزاد شماره ۴۸ برای تغییرات (اگر بیش از یک انتخاب مهیا شده باشد)';
    $Self->{Translation}->{'Defines the default selection of the free text field number 48 for workorders (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد متن آزاد شماره ۴۸ برای دستور کارها (اگر بیش از یک انتخاب مهیا شده باشد)';
    $Self->{Translation}->{'Defines the default selection of the free text field number 49 for changes (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد متن آزاد شماره ۴۹ برای تغییرات (اگر بیش از یک انتخاب مهیا شده باشد)';
    $Self->{Translation}->{'Defines the default selection of the free text field number 49 for workorders (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد متن آزاد شماره ۴۹ برای دستور کارها (اگر بیش از یک انتخاب مهیا شده باشد)';
    $Self->{Translation}->{'Defines the default selection of the free text field number 5 for changes (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد متن آزاد شماره ۵ برای تغییرات (اگر بیش از یک انتخاب مهیا شده باشد)';
    $Self->{Translation}->{'Defines the default selection of the free text field number 5 for workorders (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد متن آزاد شماره ۵ برای دستور کارها (اگر بیش از یک انتخاب مهیا شده باشد)';
    $Self->{Translation}->{'Defines the default selection of the free text field number 50 for changes (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد متن آزاد شماره ۵۰ برای تغییرات (اگر بیش از یک انتخاب مهیا شده باشد)';
    $Self->{Translation}->{'Defines the default selection of the free text field number 50 for workorders (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد متن آزاد شماره ۵۰ برای دستور کارها (اگر بیش از یک انتخاب مهیا شده باشد)';
    $Self->{Translation}->{'Defines the default selection of the free text field number 6 for changes (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد متن آزاد شماره ۶ برای تغییرات (اگر بیش از یک انتخاب مهیا شده باشد)';
    $Self->{Translation}->{'Defines the default selection of the free text field number 6 for workorders (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد متن آزاد شماره ۶ برای دستور کارها (اگر بیش از یک انتخاب مهیا شده باشد)';
    $Self->{Translation}->{'Defines the default selection of the free text field number 7 for changes (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد متن آزاد شماره ۷ برای تغییرات (اگر بیش از یک انتخاب مهیا شده باشد)';
    $Self->{Translation}->{'Defines the default selection of the free text field number 7 for workorders (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد متن آزاد شماره ۷ برای دستور کارها (اگر بیش از یک انتخاب مهیا شده باشد)';
    $Self->{Translation}->{'Defines the default selection of the free text field number 8 for changes (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد متن آزاد شماره ۸ برای تغییرات (اگر بیش از یک انتخاب مهیا شده باشد)';
    $Self->{Translation}->{'Defines the default selection of the free text field number 8 for workorders (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد متن آزاد شماره ۸ برای دستور کارها (اگر بیش از یک انتخاب مهیا شده باشد)';
    $Self->{Translation}->{'Defines the default selection of the free text field number 9 for changes (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد متن آزاد شماره ۹ برای تغییرات (اگر بیش از یک انتخاب مهیا شده باشد)';
    $Self->{Translation}->{'Defines the default selection of the free text field number 9 for workorders (if more than one option is provided).'} =
        'مشخص کردن انتخاب پیش‌فرض فیلد متن آزاد شماره ۹ برای دستور کارها (اگر بیش از یک انتخاب مهیا شده باشد)';
    $Self->{Translation}->{'Defines the default sort criteria in the change PSA overview.'} =
        '';
    $Self->{Translation}->{'Defines the default sort criteria in the change manager overview.'} =
        '';
    $Self->{Translation}->{'Defines the default sort criteria in the change overview.'} = '';
    $Self->{Translation}->{'Defines the default sort criteria in the change schedule overview.'} =
        '';
    $Self->{Translation}->{'Defines the default sort criteria of the changes in the MyCAB overview.'} =
        '';
    $Self->{Translation}->{'Defines the default sort criteria of the changes in the MyChanges overview.'} =
        '';
    $Self->{Translation}->{'Defines the default sort criteria of the changes in the MyWorkorders overview.'} =
        '';
    $Self->{Translation}->{'Defines the default sort criteria of the changes in the PIR overview.'} =
        '';
    $Self->{Translation}->{'Defines the default sort criteria of the changes in the customer change schedule overview.'} =
        '';
    $Self->{Translation}->{'Defines the default sort criteria of the changes in the template overview.'} =
        '';
    $Self->{Translation}->{'Defines the default sort order in the MyCAB overview.'} = '';
    $Self->{Translation}->{'Defines the default sort order in the MyChanges overview.'} = '';
    $Self->{Translation}->{'Defines the default sort order in the MyWorkorders overview.'} =
        '';
    $Self->{Translation}->{'Defines the default sort order in the PIR overview.'} = '';
    $Self->{Translation}->{'Defines the default sort order in the change PSA overview.'} = '';
    $Self->{Translation}->{'Defines the default sort order in the change manager overview.'} =
        '';
    $Self->{Translation}->{'Defines the default sort order in the change overview.'} = '';
    $Self->{Translation}->{'Defines the default sort order in the change schedule overview.'} =
        '';
    $Self->{Translation}->{'Defines the default sort order in the customer change schedule overview.'} =
        '';
    $Self->{Translation}->{'Defines the default sort order in the template overview.'} = '';
    $Self->{Translation}->{'Defines the default value for the category of a change.'} = '';
    $Self->{Translation}->{'Defines the default value for the impact of a change.'} = '';
    $Self->{Translation}->{'Defines the field type of CompareValue fields for change attributes used in AgentITSMChangeConditionEdit. Valid values are Selection, Text and Date. If a type is not defined, the field will not be shown.'} =
        '';
    $Self->{Translation}->{'Defines the field type of CompareValue fields for workorder attributes used in AgentITSMChangeConditionEdit. Valid values are Selection, Text and Date. If a type is not defined, the field will not be shown.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 1 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 1 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 10 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 10 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 11 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 11 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 12 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 12 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 13 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 13 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 14 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 14 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 15 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 15 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 16 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 16 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 17 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 17 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 18 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 18 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 19 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 19 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 2 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 2 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 20 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 20 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 21 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 21 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 22 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 22 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 23 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 23 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 24 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 24 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 25 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 25 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 26 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 26 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 27 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 27 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 28 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 28 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 29 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 29 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 3 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 3 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 30 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 30 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 31 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 31 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 32 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 32 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 33 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 33 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 34 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 34 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 35 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 35 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 36 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 36 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 37 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 37 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 38 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 38 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 39 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 39 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 4 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 4 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 40 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 40 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 41 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 41 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 42 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 42 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 43 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 43 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 44 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 44 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 45 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 45 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 46 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 46 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 47 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 47 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 48 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 48 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 49 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 49 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 5 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 5 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 50 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 50 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 6 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 6 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 7 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 7 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 8 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 8 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 9 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free key field number 9 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 1 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 1 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 10 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 10 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 11 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 11 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 12 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 13 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 13 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 14 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 14 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 15 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 15 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 16 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 16 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 17 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 17 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 18 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 18 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 19 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 19 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 2 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 2 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 20 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 20 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 21 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 21 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 22 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 22 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 23 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 23 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 24 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 24 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 25 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 25 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 26 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 26 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 27 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 27 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 28 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 28 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 29 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 29 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 3 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 3 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 30 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 30 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 31 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 31 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 32 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 32 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 33 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 33 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 34 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 34 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 35 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 35 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 36 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 36 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 37 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 37 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 38 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 38 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 39 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 39 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 4 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 4 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 40 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 40 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 41 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 41 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 42 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 42 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 43 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 43 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 44 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 44 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 45 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 45 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 46 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 46 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 47 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 47 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 48 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 48 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 49 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 49 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 5 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 5 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 50 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 50 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 6 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 6 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 7 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 7 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 8 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 8 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 9 for changes to add a new change attribute.'} =
        '';
    $Self->{Translation}->{'Defines the free text field number 9 for workorders to add a new workorder attribute.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 1 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 1 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 10 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 10 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 11 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 11 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 12 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 12 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 13 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 13 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 14 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 14 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 15 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 15 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 16 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 16 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 17 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 17 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 18 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 18 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 19 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 19 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 2 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 2 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 20 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 20 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 21 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 21 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 22 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 22 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 23 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 23 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 24 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 24 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 25 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 25 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 26 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 26 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 27 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 27 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 28 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 28 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 29 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 29 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 3 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 3 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 30 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 30 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 31 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 31 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 32 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 32 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 33 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 33 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 34 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 34 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 35 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 35 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 36 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 36 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 37 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 37 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 38 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 38 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 39 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 39 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 4 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 4 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 40 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 40 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 41 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 41 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 42 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 42 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 43 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 43 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 44 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 44 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 45 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 45 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 46 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 46 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 47 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 47 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 48 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 48 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 49 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 49 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 5 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 5 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 50 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 50 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 6 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 6 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 7 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 7 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 8 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 8 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 9 for changes.'} =
        '';
    $Self->{Translation}->{'Defines the http link for the free text field number 9 for workorders.'} =
        '';
    $Self->{Translation}->{'Defines the maximum number of change freetext fields.'} = '';
    $Self->{Translation}->{'Defines the maximum number of workorder freetext fields.'} = '';
    $Self->{Translation}->{'Defines the object attributes that are selectable for change objects in AgentITSMChangeConditionEdit.'} =
        '';
    $Self->{Translation}->{'Defines the object attributes that are selectable for workorder objects in AgentITSMChangeConditionEdit.'} =
        '';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute AccountedTime in AgentITSMChangeConditionEdit.'} =
        '';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute ActualEndTime in AgentITSMChangeConditionEdit.'} =
        '';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute ActualStartTime in AgentITSMChangeConditionEdit.'} =
        '';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute CategoryID in AgentITSMChangeConditionEdit.'} =
        '';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute ChangeBuilderID in AgentITSMChangeConditionEdit.'} =
        '';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute ChangeFreeKey in AgentITSMChangeConditionEdit.'} =
        '';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute ChangeFreeText in AgentITSMChangeConditionEdit.'} =
        '';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute ChangeManagerID in AgentITSMChangeConditionEdit.'} =
        '';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute ChangeStateID in AgentITSMChangeConditionEdit.'} =
        '';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute ChangeTitle in AgentITSMChangeConditionEdit.'} =
        '';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute ImpactID in AgentITSMChangeConditionEdit.'} =
        '';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute PlannedEffort in AgentITSMChangeConditionEdit.'} =
        '';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute PlannedEndTime in AgentITSMChangeConditionEdit.'} =
        '';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute PlannedStartTime in AgentITSMChangeConditionEdit.'} =
        '';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute PriorityID in AgentITSMChangeConditionEdit.'} =
        '';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute RequestedTime in AgentITSMChangeConditionEdit.'} =
        '';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute WorkOrderAgentID in AgentITSMChangeConditionEdit.'} =
        '';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute WorkOrderFreeKey in AgentITSMChangeConditionEdit.'} =
        '';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute WorkOrderFreeText in AgentITSMChangeConditionEdit.'} =
        '';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute WorkOrderNumber in AgentITSMChangeConditionEdit.'} =
        '';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute WorkOrderStateID in AgentITSMChangeConditionEdit.'} =
        '';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute WorkOrderTitle in AgentITSMChangeConditionEdit.'} =
        '';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute WorkOrderTypeID in AgentITSMChangeConditionEdit.'} =
        '';
    $Self->{Translation}->{'Defines the period (in years), in which start and end times can be selected.'} =
        '';
    $Self->{Translation}->{'Defines the shown attributes of a workorder in the tooltip of the workorder graph in the change zoom.'} =
        '';
    $Self->{Translation}->{'Defines the shown columns in the Change PSA overview. This option has no effect on the position of the column.'} =
        '';
    $Self->{Translation}->{'Defines the shown columns in the Change Schedule overview. This option has no effect on the position of the column.'} =
        '';
    $Self->{Translation}->{'Defines the shown columns in the MyCAB overview. This option has no effect on the position of the column.'} =
        '';
    $Self->{Translation}->{'Defines the shown columns in the MyChanges overview. This option has no effect on the position of the column.'} =
        '';
    $Self->{Translation}->{'Defines the shown columns in the MyWorkorders overview. This option has no effect on the position of the column.'} =
        '';
    $Self->{Translation}->{'Defines the shown columns in the PIR overview. This option has no effect on the position of the column.'} =
        '';
    $Self->{Translation}->{'Defines the shown columns in the change manager overview. This option has no effect on the position of the column.'} =
        '';
    $Self->{Translation}->{'Defines the shown columns in the change overview. This option has no effect on the position of the column.'} =
        '';
    $Self->{Translation}->{'Defines the shown columns in the change search. This option has no effect on the position of the column.'} =
        '';
    $Self->{Translation}->{'Defines the shown columns in the customer change schedule overview. This option has no effect on the position of the column.'} =
        '';
    $Self->{Translation}->{'Defines the shown columns in the template overview. This option has no effect on the position of the column.'} =
        '';
    $Self->{Translation}->{'Defines the signals for each ITSMChange state.'} = '';
    $Self->{Translation}->{'Defines the template types that will be used as filters in the template overview.'} =
        '';
    $Self->{Translation}->{'Defines the workorder states that will be used as filters in the MyWorkorders overview.'} =
        '';
    $Self->{Translation}->{'Defines the workorder states that will be used as filters in the PIR overview.'} =
        '';
    $Self->{Translation}->{'Defines the workorder types that will be used to show the PIR overview.'} =
        '';
    $Self->{Translation}->{'Defines whether notifications should be sent.'} = '';
    $Self->{Translation}->{'Determines if an agent can exchange the X-axis of a stat if he generates one.'} =
        '';
    $Self->{Translation}->{'Determines if the common stats module may generate stats about changes done for config item classes.'} =
        '';
    $Self->{Translation}->{'Determines if the common stats module may generate stats about changes regarding change state updates within a timeperiod.'} =
        '';
    $Self->{Translation}->{'Determines if the common stats module may generate stats about changes regarding the relation between changes and incident tickets.'} =
        '';
    $Self->{Translation}->{'Determines if the common stats module may generate stats about changes.'} =
        '';
    $Self->{Translation}->{'Determines if the common stats module may generate stats about the number of Rfc tickets a requester created.'} =
        '';
    $Self->{Translation}->{'Event list to be displayed on GUI to trigger generic interface invokers.'} =
        '';
    $Self->{Translation}->{'ITSM event module deletes the history of changes.'} = '';
    $Self->{Translation}->{'ITSM event module that cleans up conditions.'} = '';
    $Self->{Translation}->{'ITSM event module that deletes the cache for a toolbar.'} = '';
    $Self->{Translation}->{'ITSM event module that matches conditions and executes actions.'} =
        '';
    $Self->{Translation}->{'ITSM event module that sends notifications.'} = '';
    $Self->{Translation}->{'ITSM event module that updates the history of changes.'} = '';
    $Self->{Translation}->{'ITSM event module to recalculate the workorder numbers.'} = '';
    $Self->{Translation}->{'ITSM event module to set the actual start and end times of workorders.'} =
        '';
    $Self->{Translation}->{'ITSM event module updates the history of changes.'} = '';
    $Self->{Translation}->{'ITSM event module updates the history of conditions.'} = '';
    $Self->{Translation}->{'ITSM event module updates the history of workorders.'} = '';
    $Self->{Translation}->{'If frequency is \'regularly\', you can configure how often the notications are sent (every X hours).'} =
        '';
    $Self->{Translation}->{'If this option is enabled, then the decrypted data will be stored in the database if they are displayed in AgentTicketZoom.'} =
        '';
    $Self->{Translation}->{'Logfile for the ITSM change counter. This file is used for creating the change numbers.'} =
        '';
    $Self->{Translation}->{'Module to check the CAB members.'} = '';
    $Self->{Translation}->{'Module to check the agent.'} = '';
    $Self->{Translation}->{'Module to check the change builder.'} = '';
    $Self->{Translation}->{'Module to check the change manager.'} = '';
    $Self->{Translation}->{'Module to check the workorder agent.'} = '';
    $Self->{Translation}->{'Module to check whether no workorder agent is set.'} = '';
    $Self->{Translation}->{'Module to check whether the agent is contained in the configured list.'} =
        '';
    $Self->{Translation}->{'Module to show a link to create a change from this ticket. The ticket will be automatically linked with the new change.'} =
        '';
    $Self->{Translation}->{'Notification (ITSM Change Management)'} = 'اعلان (مدیریت تغییرات)';
    $Self->{Translation}->{'Only users of these groups have the permission to use the ticket types as defined in "ITSMChange::AddChangeLinkTicketTypes" if the feature "Ticket::Acl::Module###200-Ticket::Acl::Module" is enabled.'} =
        '';
    $Self->{Translation}->{'Parameters for the pages (in which the changes are shown) of the small change overview.'} =
        '';
    $Self->{Translation}->{'Presents a link in the menu to show the involved persons in a change, in the zoom view of such change in the agent interface.'} =
        '';
    $Self->{Translation}->{'Required privileges in order for an agent to take a workorder.'} =
        '';
    $Self->{Translation}->{'Required privileges to access the overview of all changes.'} = '';
    $Self->{Translation}->{'Required privileges to add a workorder.'} = '';
    $Self->{Translation}->{'Required privileges to change the workorder agent.'} = '';
    $Self->{Translation}->{'Required privileges to create a template from a change.'} = '';
    $Self->{Translation}->{'Required privileges to create a template from a changes\' CAB.'} =
        '';
    $Self->{Translation}->{'Required privileges to create a template from a workorder.'} = '';
    $Self->{Translation}->{'Required privileges to create changes from templates.'} = '';
    $Self->{Translation}->{'Required privileges to create changes.'} = '';
    $Self->{Translation}->{'Required privileges to delete a template.'} = '';
    $Self->{Translation}->{'Required privileges to delete a workorder.'} = '';
    $Self->{Translation}->{'Required privileges to delete changes.'} = '';
    $Self->{Translation}->{'Required privileges to edit a template.'} = '';
    $Self->{Translation}->{'Required privileges to edit a workorder.'} = '';
    $Self->{Translation}->{'Required privileges to edit changes.'} = '';
    $Self->{Translation}->{'Required privileges to edit the conditions of changes.'} = '';
    $Self->{Translation}->{'Required privileges to edit the involved persons of a change.'} =
        '';
    $Self->{Translation}->{'Required privileges to move changes in time.'} = '';
    $Self->{Translation}->{'Required privileges to print a change.'} = '';
    $Self->{Translation}->{'Required privileges to reset changes.'} = '';
    $Self->{Translation}->{'Required privileges to view a workorder.'} = '';
    $Self->{Translation}->{'Required privileges to view changes.'} = '';
    $Self->{Translation}->{'Required privileges to view list of changes where the user is a CAB member.'} =
        '';
    $Self->{Translation}->{'Required privileges to view list of changes where the user is the change manager.'} =
        '';
    $Self->{Translation}->{'Required privileges to view overview over all templates.'} = '';
    $Self->{Translation}->{'Required privileges to view the conditions of changes.'} = '';
    $Self->{Translation}->{'Required privileges to view the history of a change.'} = '';
    $Self->{Translation}->{'Required privileges to view the history of a workorder.'} = '';
    $Self->{Translation}->{'Required privileges to view the history zoom of a change.'} = '';
    $Self->{Translation}->{'Required privileges to view the history zoom of a workorder.'} =
        '';
    $Self->{Translation}->{'Required privileges to view the list of Change Schedule.'} = '';
    $Self->{Translation}->{'Required privileges to view the list of change PSA.'} = '';
    $Self->{Translation}->{'Required privileges to view the list of changes with an upcoming PIR (Post Implementation Review).'} =
        '';
    $Self->{Translation}->{'Required privileges to view the list of own changes.'} = '';
    $Self->{Translation}->{'Required privileges to view the list of own workorders.'} = '';
    $Self->{Translation}->{'Required privileges to write a report for the workorder.'} = '';
    $Self->{Translation}->{'Selects the change number generator module. "AutoIncrement" increments the change number, the SystemID and the counter are used with SystemID.counter format (e.g. 100118, 100119). With "Date", the change numbers will be generated by the current date and a counter; this format looks like Year.Month.Day.counter, e.g. 2010062400001, 2010062400002. With "DateChecksum", the counter will be appended as checksum to the string of date plus the SystemID. The checksum will be rotated on a daily basis. This format looks like Year.Month.Day.SystemID.Counter.CheckSum, e.g. 2010062410000017, 2010062410000026.'} =
        '';
    $Self->{Translation}->{'Sets the minimal change counter size (if "AutoIncrement" was selected as ITSMChange::NumberGenerator). Default is 5, this means the counter starts from 10000.'} =
        '';
    $Self->{Translation}->{'Sets up the state machine for changes.'} = '';
    $Self->{Translation}->{'Sets up the state machine for workorders.'} = '';
    $Self->{Translation}->{'Shows a checkbox in the AgentITSMWorkOrderEdit screen that defines if the the following workorders should also be moved if a workorder is modified and the planned end time has changed.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu that allows changing the work order agent, in the zoom view of such work order of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu that allows defining a change as a template in the zoom view of the change, in the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu that allows defining a work order as a template in the zoom view of the work order, in the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu that allows editing the report of a workd order, in the zoom view of such work order of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu that allows linking a change with another object in the change zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu that allows linking a work order with another object in the zoom view of such work order of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu that allows moving the time slot of a change in its zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu that allows taking a work order in the its zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu to access the conditions of a change in the its zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu to access the history of a change in the its zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu to access the history of a work order in the its zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu to add a work order in the change zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu to delete a change in its zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu to delete a work order in its zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu to edit a change in the its zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu to edit a work order in the its zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu to go back in the change zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu to go back in the work order zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu to print a change in the its zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu to print a work order in the its zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows a link in the menu to reset a change and its workorders in its zoom view of the agent interface.'} =
        '';
    $Self->{Translation}->{'Shows the change history (reverse ordered) in the agent interface.'} =
        '';
    $Self->{Translation}->{'State Machine'} = 'ماشین وضعیت';
    $Self->{Translation}->{'The identifier for a change, e.g. Change#, MyChange#. The default is Change#.'} =
        '';
    $Self->{Translation}->{'The identifier for a workorder, e.g. Workorder#, MyWorkorder#. The default is Workorder#.'} =
        '';
    $Self->{Translation}->{'This ACL module restricts the usuage of the ticket types that are defined in the sysconfig option \'ITSMChange::AddChangeLinkTicketTypes\', to users of the groups as defined in "ITSMChange::RestrictTicketTypes::Groups". As this ACL could collide with other ACLs which are also related to the ticket type, this sysconfig option is disabled by default and should only be activated if needed.'} =
        '';
    $Self->{Translation}->{'Types of tickets, where in the ticket zoom view a link to add a change will be displayed.'} =
        '';
    $Self->{Translation}->{'Workorder free text options shown in the change search of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled.'} =
        '';
    $Self->{Translation}->{'Workorder free text options shown in the workorder add of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.'} =
        '';
    $Self->{Translation}->{'Workorder free text options shown in the workorder edit of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.'} =
        '';
    $Self->{Translation}->{'Workorder free text options shown in the workorder report of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.'} =
        '';

    #
    # OBSOLETE ENTRIES FOR REFERENCE, DO NOT TRANSLATE!
    #
    $Self->{Translation}->{'Adapts the width of the autocomplete drop down to the length of the longest option.'} =
        'تطابق عرض منوی کشویی که به صورت خودکار کامل می‌شود با طول بلندترین گزینه.';
    $Self->{Translation}->{'Cache time in minutes for the change management.'} = 'زمان ذخیره برای مدیریت تغییر در واحد دقیقه';
    $Self->{Translation}->{'Manage priority matrix.'} = 'مدیریت ماتریس الویت';
    $Self->{Translation}->{'Search Agent'} = 'جستجوی کارشناس';

}

1;
