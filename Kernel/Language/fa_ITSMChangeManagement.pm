# --
# Kernel/Language/fa_ITSMChangeManagement.pm - the persian translation of ITSMChangeManagement
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# --
# $Id: fa_ITSMChangeManagement.pm,v 1.2 2010-12-17 15:47:18 ub Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::fa_ITSMChangeManagement;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.2 $) [1];

sub Data {
    my $Self = shift;

    my $Lang = $Self->{Translation};

    return if ref $Lang ne 'HASH';

    # misc
    $Lang->{'A change must have a title!'}          = 'هر تغییر باید عنوان داشته باشد!';
    $Lang->{'Template Name'}                        = 'نام قالب';
    $Lang->{'Templates'}                            = 'قالب‌ها';
    $Lang->{'A workorder must have a title!'}       = 'هر دستور کار باید دارای عنوان باشد!';
    $Lang->{'Clear'}                                = 'پاک کردن';
    $Lang->{'Create a change from this ticket!'}    = 'ساخت یک تغییر از این درخواست!';
    $Lang->{'Create Change'}                        = 'ساختن تغییر';
    $Lang->{'e.g.'}                                 = 'به عنوان مثال';
    $Lang->{'Save Change as template'}              = 'ذخیره کردن تغییر به عنوان قالب';
    $Lang->{'Save Workorder as template'}           = 'ذخیره کردن دستور کار به عنوان قالب';
    $Lang->{'Save Change CAB as template'}          = 'ذخیره کردن هیئت مشاوران تغییر به عنوان قالب';
    $Lang->{'New time'}                             = 'زمان جدید';
    $Lang->{'Requested (by customer) Date'}         = 'زمان درخواست )توسط مشترک(';
    $Lang->{'The planned end time is invalid!'}     = 'زمان برنامه‌ریزی شده پایان معتبر نیست!';
    $Lang->{'The planned start time is invalid!'}   = 'زمان برنامه‌ریزی شده آغاز معتبر نیست!';
    $Lang->{'The planned start time must be before the planned end time!'}
        = 'زمان آغاز باید قبل از زمان پایان باشد!';
    $Lang->{'The requested time is invalid!'}       = 'زمان درخواست معتبر نیست!';
    $Lang->{'Time type'}                            = 'نوع زمان';
    $Lang->{'Do you really want to delete this template?'} = 'آیا واقعا مایل به حذف این قالب هستید؟';
    $Lang->{'Change Advisory Board'}                = 'هیئت مشاوران تغییر';
    $Lang->{'CAB'}                                  = 'CAB';
    $Lang->{'Reset States'}                         = 'تنظیم مجدد وضعیت‌ها';

    # ITSM ChangeManagement icons
    $Lang->{'My Changes'}                           = 'تغییرات من';
    $Lang->{'My Workorders'}                        = 'دستور کارهای من';
    $Lang->{'PIR (Post Implementation Review)'}     = 'بررسی پس از پیاده‌سازی';
    $Lang->{'PSA (Projected Service Availability)'} = 'دسترس‌پذیری پیش‌بینی شده خدمات';
    $Lang->{'My CABs'}                              = 'هیئت مشاوران من';
    $Lang->{'Change Overview'}                      = 'نمای کلی تغییر';
    $Lang->{'Template Overview'}                    = 'نمای کلی قالب';
    $Lang->{'Search Changes'}                       = 'جستجوی تغییرات';

    # Change menu
    $Lang->{'ITSM Change'}                           = 'تغییر';
    $Lang->{'ITSM Workorder'}                        = 'دستور کار';
    $Lang->{'Schedule'}                              = 'زمان‌بندی';
    $Lang->{'Involved Persons'}                      = 'افراد درگیر';
    $Lang->{'Add Workorder'}                         = 'افزودن دستور کار';
    $Lang->{'Template'}                              = 'قالب';
    $Lang->{'Move Time Slot'}                        = 'جابجایی شیار زمان';
    $Lang->{'Print the change'}                      = 'چاپ تغییر';
    $Lang->{'Edit the change'}                       = 'ویرایش تغییر';
    $Lang->{'Change involved persons of the change'} = 'افراد درگیر این تغییر';
    $Lang->{'Add a workorder to the change'}         = 'افزودن یک دستور کار به تغییر';
    $Lang->{'Edit the conditions of the change'}     = 'ویرایش شروط تغییر';
    $Lang->{'Link another object to the change'}     = 'ارتباط دادن یک شیء به تغییر';
    $Lang->{'Save change as a template'}             = 'ذخیره کردن تغییر به عنون قالب';
    $Lang->{'Move all workorders in time'}           = 'جابه‌جا کردن تمام دستور کارها در زمان';
    $Lang->{'Current CAB'}                           = 'عضو هیئت مشاور کنونی';
    $Lang->{'Add to CAB'}                            = 'افزودن به هیئت مشاوران تغییر';
    $Lang->{'Add CAB Template'}                      = 'افزودن قالب برای هیئت مشاوران';
    $Lang->{'Add Workorder to'}                      = 'افزودن دستور کار به';
    $Lang->{'Select Workorder Template'}             = 'انتخاب قالب دستور کار';
    $Lang->{'Select Change Template'}                = 'انتخاب قالب تغییر';
    $Lang->{'The planned time is invalid!'}          = 'زمان برنامه‌ریزی شده معتبر نیست!';

    # Workorder menu
    $Lang->{'Workorder'}                            = 'دستور کار';
    $Lang->{'Save workorder as a template'}         = 'ذخیره کردن دستور کار به عنوان قالب';
    $Lang->{'Link another object to the workorder'} = 'ارتباط دادن یک شیء دیگر به دستور کار';
    $Lang->{'Delete Workorder'}                     = 'حذف دستور کار';
    $Lang->{'Edit the workorder'}                   = 'ویرایش دستور کار';
    $Lang->{'Print the workorder'}                  = 'چاپ دستور کار';
    $Lang->{'Set the agent for the workorder'}      = 'مشخص کردن کارشناس برای دستور کار';

    # Template menu
    $Lang->{'A template must have a name!'} = 'قالب باید دارای نام باشد!';

    # Change attributes as returned from ChangeGet(), or taken by ChangeUpdate()
    $Lang->{'AccountedTime'}    = 'زمان محاسبه شده';
    $Lang->{'ActualEndTime'}    = 'زمان خاتمه در عمل';
    $Lang->{'ActualStartTime'}  = 'زمان آغاز در عمل';
    $Lang->{'CABAgent'}         = 'کارشناس هیئت مشاور تغییر';
    $Lang->{'CABAgents'}        = 'کارشناسان هیئت مشاور تغییر';
    $Lang->{'CABCustomer'}      = 'هیئت مشاور تغییر - مشترک';
    $Lang->{'CABCustomers'}     = 'هیئت مشاور تغییر - مشترکان';
    $Lang->{'Category'}         = 'دسته';
    $Lang->{'ChangeBuilder'}    = 'سازنده تغییر';
    $Lang->{'ChangeBy'}         = 'تغییر یافته توسط';
    $Lang->{'ChangeManager'}    = 'مدیر تغییر';
    $Lang->{'ChangeNumber'}     = 'شماره تغییر';
    $Lang->{'ChangeTime'}       = 'تغییر یافته';
    $Lang->{'ChangeState'}      = 'وضعیت تغییر';
    $Lang->{'ChangeTitle'}      = 'عنوان تغییر';
    $Lang->{'CreateBy'}         = 'ساخته شده توسط';
    $Lang->{'CreateTime'}       = 'ساخته شده';
    $Lang->{'Description'}      = 'شرح';
    $Lang->{'Impact'}           = 'اثر مخرب';
    $Lang->{'Justification'}    = 'دلیل';
    $Lang->{'PlannedEffort'}    = 'سعی برنامه‌ریزی شده';
    $Lang->{'PlannedEndTime'}   = 'زمان خاتمه برنامه‌ریزی شده';
    $Lang->{'PlannedStartTime'} = 'زمان آغاز برنامه‌ریزی شده';
    $Lang->{'Priority'}         = 'الویت';
    $Lang->{'RequestedTime'}    = 'زمان مورد انتظار';

    # Workorder attributes as returned from WorkOrderGet(), or taken by WorkOrderUpdate()
    $Lang->{'Instruction'}      = 'دستورالعمل';
    $Lang->{'Report'}           = 'گزارش';
    $Lang->{'WorkOrderAgent'}   = 'کارشناس انجام دستور کار';
    $Lang->{'WorkOrderNumber'}  = 'شماره دستور کار';
    $Lang->{'WorkOrderState'}   = 'وضعیت دستور کار';
    $Lang->{'WorkOrderTitle'}   = 'عنوان دستور کار';
    $Lang->{'WorkOrderType'}    = 'نوع دستور کار';

     # Change history
    $Lang->{'ChangeHistory::ChangeAdd'}              = 'تغییر جدید (ID=%s)';
    $Lang->{'ChangeHistory::ChangeUpdate'}           = '%s: جدید: %s -> قدیم: %s';
    $Lang->{'ChangeHistory::ChangeLinkAdd'}          = 'ارتباط به %s (ID=%s) افزوده شد';
    $Lang->{'ChangeHistory::ChangeLinkDelete'}       = 'ارتباط به %s (ID=%s) حذف شد';
    $Lang->{'ChangeHistory::ChangeCABUpdate'}        = '%s: جدید: %s -> قدیم: %s';
    $Lang->{'ChangeHistory::ChangeCABDelete'}        = 'هیئت مشاوران تغییر حذف شد %s';
    $Lang->{'ChangeHistory::ChangeAttachmentAdd'}    = 'پیوست جدید: %s';
    $Lang->{'ChangeHistory::ChangeAttachmentDelete'} = 'پیوست حذف شد %s';
    $Lang->{'ChangeHistory::ChangeNotificationSent'} = 'اعلام فرستاده شد %s (رویداد: %s)';

    # workorder history
    $Lang->{'WorkOrderHistory::WorkOrderAdd'}              = 'دستور کار جدید (ID=%s)';
    $Lang->{'WorkOrderHistory::WorkOrderUpdate'}           = '%s: جدید: %s -> قدیم: %s';
    $Lang->{'WorkOrderHistory::WorkOrderLinkAdd'}          = 'ارتباط به %s (ID=%s) افزوده شد';
    $Lang->{'WorkOrderHistory::WorkOrderLinkDelete'}       = 'ارتباط به %s (ID=%s) حذف شد';
    $Lang->{'WorkOrderHistory::WorkOrderDelete'}           = 'دستور کار (ID=%s) حذف شد';
    $Lang->{'WorkOrderHistory::WorkOrderAttachmentAdd'}    = 'پیوست جدید برای دستور کار: %s';
    $Lang->{'WorkOrderHistory::WorkOrderAttachmentDelete'} = 'پیوست حذف شده از دستور کار: %s';
    $Lang->{'WorkOrderHistory::WorkOrderNotificationSent'} = 'اعلان به %s ارسال شد )رویداد: %s(';

    # long workorder history
    $Lang->{'WorkOrderHistory::WorkOrderAddWithWorkOrderID'}              = 'دستور کار جدید (ID=%s)';
    $Lang->{'WorkOrderHistory::WorkOrderUpdateWithWorkOrderID'}           = '(ID=%s) %s: جدید: %s -> قدیم: %s';
    $Lang->{'WorkOrderHistory::WorkOrderLinkAddWithWorkOrderID'}          = '(ID=%s) ارتباط به %s (ID=%s) افزوده شد';
    $Lang->{'WorkOrderHistory::WorkOrderLinkDeleteWithWorkOrderID'}       = '(ID=%s) ارتباط به %s (ID=%s) حذف شد';
    $Lang->{'WorkOrderHistory::WorkOrderDeleteWithWorkOrderID'}           = 'دستور کار (ID=%s) حذف شد';
    $Lang->{'WorkOrderHistory::WorkOrderAttachmentAddWithWorkOrderID'}    = '(ID=%s) پیوست جدید برای دستور کار: %s';
    $Lang->{'WorkOrderHistory::WorkOrderAttachmentDeleteWithWorkOrderID'} = '(ID=%s) پیوست حذف شده از دستور کار: %s';
    $Lang->{'WorkOrderHistory::WorkOrderNotificationSentWithWorkOrderID'} = '(ID=%s) اعلان ارسال شد به %s (رویداد: %s)';

    # condition history
    $Lang->{'ChangeHistory::ConditionAdd'}       = '%s: %s';
    $Lang->{'ChangeHistory::ConditionAddID'}     = 'شرط جدید (ID=%s)';
    $Lang->{'ChangeHistory::ConditionUpdate'}    = '%s (شناسه شرط=%s): جدید: %s -> قدیم: %s';
    $Lang->{'ChangeHistory::ConditionDelete'}    = 'شرط (ID=%s) حذف شد';
    $Lang->{'ChangeHistory::ConditionDeleteAll'} = 'تمام شروط دستور کار (ID=%s) حذف شد';

    # expression history
    $Lang->{'ChangeHistory::ExpressionAdd'}       = '%s: %s';
    $Lang->{'ChangeHistory::ExpressionAddID'}     = 'عبارت منطقی جدید (ID=%s)';
    $Lang->{'ChangeHistory::ExpressionUpdate'}    = '%s (شناسه عبارت=%s): جدید: %s -> قدیم: %s';
    $Lang->{'ChangeHistory::ExpressionDelete'}    = 'عبارت منطقی (ID=%s) حذف شد';
    $Lang->{'ChangeHistory::ExpressionDeleteAll'} = 'تمام عبارات منطقی شرط (ID=%s) حذف شد';

    # action history
    $Lang->{'ChangeHistory::ActionAdd'}       = '%s: %s';
    $Lang->{'ChangeHistory::ActionAddID'}     = 'عملیات جدید (ID=%s)';
    $Lang->{'ChangeHistory::ActionUpdate'}    = '%s (شناسه عملیات=%s): جدید: %s -> قدیم: %s';
    $Lang->{'ChangeHistory::ActionDelete'}    = 'عملیات (ID=%s) حذف شد';
    $Lang->{'ChangeHistory::ActionDeleteAll'} = 'تمام عملیات‌های شرط (ID=%s) حذف شد';
    $Lang->{'ChangeHistory::ActionExecute'}   = 'عملیات (ID=%s) اجرا شد: %s';
    $Lang->{'ActionExecute::successfully'}    = 'با موفقیت';
    $Lang->{'ActionExecute::unsuccessfully'}  = 'عدم موفقیت';

    # history for time events
    $Lang->{'ChangeHistory::ChangePlannedStartTimeReached'}                      = 'زمان برنامه‌ریزی شده آغاز تغییر فرا رسیده (ID=%s)';
    $Lang->{'ChangeHistory::ChangePlannedEndTimeReached'}                        = 'زمان برنامه‌ریزی شده پایان تغییر فرا رسیده (ID=%s)';
    $Lang->{'ChangeHistory::ChangeActualStartTimeReached'}                       = 'زمان حقیقی آغاز تغییر فرا رسیده (ID=%s)';
    $Lang->{'ChangeHistory::ChangeActualEndTimeReached'}                         = 'زمان حقیقی پایان تغییر فرا رسیده (ID=%s)';
    $Lang->{'ChangeHistory::ChangeRequestedTimeReached'}                         = 'زمان درخواست شده تغییر توسط مشترک فرا رسیده (ID=%s)';
    $Lang->{'WorkOrderHistory::WorkOrderPlannedStartTimeReached'}                = 'زمان برنامه‌ریزی شده آغاز دستور کار فرا رسیده (ID=%s)';
    $Lang->{'WorkOrderHistory::WorkOrderPlannedEndTimeReached'}                  = 'زمان برنامه‌ریزی شده پایان پایان کار فرا رسیده (ID=%s)';
    $Lang->{'WorkOrderHistory::WorkOrderActualStartTimeReached'}                 = 'زمان حقیقی آغاز دستور کار فرا رسیده (ID=%s)';
    $Lang->{'WorkOrderHistory::WorkOrderActualEndTimeReached'}                   = 'زمان حقیقی پایان دستور کار فرا رسیده (ID=%s)';
    $Lang->{'WorkOrderHistory::WorkOrderPlannedStartTimeReachedWithWorkOrderID'} = 'زمان برنامه‌ریزی شده آغاز دستور کار فرا رسیده (ID=%s)';;
    $Lang->{'WorkOrderHistory::WorkOrderPlannedEndTimeReachedWithWorkOrderID'}   = 'زمان برنامه‌ریزی شده پایان پایان کار فرا رسیده (ID=%s)';
    $Lang->{'WorkOrderHistory::WorkOrderActualStartTimeReachedWithWorkOrderID'}  = 'زمان حقیقی آغاز دستور کار فرا رسیده (ID=%s)';
    $Lang->{'WorkOrderHistory::WorkOrderActualEndTimeReachedWithWorkOrderID'}    = 'زمان حقیقی پایان دستور کار فرا رسیده (ID=%s)';

    # change states
    $Lang->{'requested'}        = 'درخواست شده';
    $Lang->{'pending approval'} = 'در انتظار تایید';
    $Lang->{'pending pir'}      = 'در انتظار بررسی پس از پیاده‌سازی';
    $Lang->{'rejected'}         = 'رد شده';
    $Lang->{'approved'}         = 'تایید شده';
    $Lang->{'in progress'}      = 'در حال اجرا';
    $Lang->{'successful'}       = 'موفقیت';
    $Lang->{'failed'}           = 'شکست';
    $Lang->{'canceled'}         = 'لغو شده';
    $Lang->{'retracted'}        = 'جمع شده';

    # workorder states
    $Lang->{'created'}     = 'ساخته شده';
    $Lang->{'accepted'}    = 'پذیرفته شده';
    $Lang->{'ready'}       = 'آماده';
    $Lang->{'in progress'} = 'در حال اجرا';
    $Lang->{'closed'}      = 'بسته شده';
    $Lang->{'canceled'}    = 'لغو شده';

    # Admin Interface
    $Lang->{'Category <-> Impact <-> Priority'}      = 'طبقه <-> اثر <-> الویت';
    $Lang->{'Notification (ITSM Change Management)'} = 'اعلام )مدیریت تغییرات(';

    # Admin StateMachine
    $Lang->{'Add a state transition'}               = 'افزودن یک انتقال وضعیت';
    $Lang->{'Add a new state transition for'}       = 'افزودن یک انتقال وضعیت برای';
    $Lang->{'Edit a state transition for'}          = 'ویرایش یک انتقال وضعیت برای';
    $Lang->{'Overview over state transitions for'}  = 'نمای کلی روی انتقال‌های وضعیت برای';
    $Lang->{'Object Name'}                          = 'نام شیء';
    $Lang->{'Please select first a catalog class!'} = 'لطفا ابتدا یک کلاس انتخاب کنید!';

    # workorder types
    $Lang->{'approval'}  = 'تصویب';
    $Lang->{'decision'}  = 'تصمیم';
    $Lang->{'workorder'} = 'دستور کار';
    $Lang->{'backout'}   = 'طرح بازگشت';
    $Lang->{'pir'}       = 'بررسی پس از پیاده‌سازی';

    # objects that can be used in condition expressions and actions
    $Lang->{'ITSMChange'}    = 'تغییر';
    $Lang->{'ITSMWorkOrder'} = 'دستور کار';
    $Lang->{'ITSMCondition'} = 'شرط';

    # Overviews
    $Lang->{'Change Schedule'} = 'زمان‌بندی تغییر';

    # Workorder delete
    $Lang->{'Do you really want to delete this workorder?'} = 'آیا مایل به حذف این دستور کار هستید؟';
    $Lang->{'You can not delete this Workorder. It is used in at least one Condition!'} = 'شما نمی‌توانید این دستور کار را حذف نمایید زیرا حداقل در یک شرط استفاده شده است.';
    $Lang->{'This Workorder is used in the following Condition(s)'} = 'این دستور کار در شروط زیر استفاده شده است';

    # Take workorder
    $Lang->{'Take Workorder'}                             = 'گرفتن دستور کار';
    $Lang->{'Take the workorder'}                         = 'این دستور کار را بگیر';
    $Lang->{'Current Agent'}                              = 'کارشناس کنونی';
    $Lang->{'Do you really want to take this workorder?'} = 'آیا واقعا می‌خواهید این دستور کار را بگیرید؟';

    # Condition Overview and Edit
    $Lang->{'Condition'}                                = 'شرط';
    $Lang->{'Conditions'}                               = 'شروط';
    $Lang->{'Expression'}                               = 'عبارت منطقی';
    $Lang->{'Expressions'}                              = 'عبارات منطقی';
    $Lang->{'Action'}                                   = 'عملیات';
    $Lang->{'Actions'}                                  = 'عملیات‌ها';
    $Lang->{'Matching'}                                 = 'تطابق';
    $Lang->{'Conditions and Actions'}                   = 'شروط و عملیات‌ها';
    $Lang->{'Add new condition and action pair'}        = 'افزودن جفتی از شرط و عملیات';
    $Lang->{'A condition must have a name!'}            = 'هر شرط باید دارای نام باشد!';
    $Lang->{'Condition Edit'}                           = 'ویرایش شرط';
    $Lang->{'Add new expression'}                       = 'افزودن یک عبارت منطقی';
    $Lang->{'Add new action'}                           = 'افزودن عملیات جدید';
    $Lang->{'Any expression'}                           = 'هیچ عبارت منطقی';
    $Lang->{'All expressions'}                          = 'تمام عبارات منطقی';
    $Lang->{'any'}                                      = 'هیچ';
    $Lang->{'all'}                                      = 'همه';
    $Lang->{'is'}                                       = 'هست';
    $Lang->{'is not'}                                   = 'نیست';
    $Lang->{'is empty'}                                 = 'خالی است';
    $Lang->{'is not empty'}                             = 'خالی نیست';
    $Lang->{'is greater than'}                          = 'بزرگتر است از';
    $Lang->{'is less than'}                             = 'کوچکتر است از';
    $Lang->{'is before'}                                = 'قبل از';
    $Lang->{'is after'}                                 = 'پس از';
    $Lang->{'contains'}                                 = 'شامل است';
    $Lang->{'not contains'}                             = 'شامل نیست';
    $Lang->{'begins with'}                              = 'شروع می‌شود با';
    $Lang->{'ends with'}                                = 'پایان می‌یابد با';
    $Lang->{'set'}                                      = 'تنظیم شده';
    $Lang->{'lock'}                                     = 'قفل شده';

    # Change Zoom
    $Lang->{'Change Initiator(s)'} = 'آغازگر تغییر';

    # AgentITSMChangePrint
    $Lang->{'Linked Objects'} = 'اشیاء ارتباط داده شده';
    $Lang->{'Full-Text Search in Change and Workorder'} =
        'جستجوی تمام متن در تغییرات و دستور کارها';

    # AgentITSMChangeSearch
    $Lang->{'No XXX settings'} = "بدون تنظیمات '%s'";

    return 1;
}

1;
