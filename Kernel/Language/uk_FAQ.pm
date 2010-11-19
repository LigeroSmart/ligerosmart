# --
# Kernel/Language/uk_FAQ.pm - the ukrainian translation of FAQ
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# Copyright (C) 2009 Belskii Artem
# --
# $Id: uk_FAQ.pm,v 1.3 2010-11-19 10:34:45 ub Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.
# --

package Kernel::Language::uk_FAQ;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.3 $) [1];

sub Data {
    my $Self = shift;

    my $Lang = $Self->{Translation};

    return if ref $Lang ne 'HASH';

    $Lang->{'You have already voted!'}           = 'Ви вже голосували!';
    $Lang->{'No rate selected!'}                 = 'Немає обраної категорії!';
    $Lang->{'Thanks for your vote!'}             = 'Дякуємо, за те, що проголосували!';
    $Lang->{'Votes'}                             = 'Голосів';
    $Lang->{'LatestChangedItems'}                = 'Остання змінена стаття';
    $Lang->{'LatestCreatedItems'}                = 'Остання створена стаття';
    $Lang->{'Top10Items'}                        = 'Топ 10 статтей';
    $Lang->{'ArticleVotingQuestion'}             = 'Вам допомогла ця стаття?';
    $Lang->{'SubCategoryOf'}                     = 'Підкатегорії';
    $Lang->{'QuickSearch'}                       = 'Швидкий пошук';
    $Lang->{'DetailSearch'}                      = 'Деталізований пошук';
    $Lang->{'Categories'}                        = 'Категорії';
    $Lang->{'SubCategories'}                     = 'Підкатегорії';
    $Lang->{'New FAQ Article'}                   = 'нова стаття БЗ';
    $Lang->{'FAQ Category'}                      = 'Категорії БЗ';
    $Lang->{'A category should have a name!'}    = 'Категорія повинна мати ім\'я';
    $Lang->{'A category should have a comment!'} = 'Категорія повинна мати коментар';
    $Lang->{'FAQ News (new created)'}            = 'Новини БЗ(нові статті)';
    $Lang->{'FAQ News (recently changed)'}       = 'Новини БЗ(недавно змінені)';
    $Lang->{'FAQ News (Top 10)'}                 = 'Новини БЗ(ТОП 10)';
    $Lang->{'StartDay'}                          = 'Початок доби';
    $Lang->{'StartMonth'}                        = 'Початок місяця';
    $Lang->{'StartYear'}                         = 'Початок року';
    $Lang->{'EndDay'}                            = 'Кінець дня';
    $Lang->{'EndMonth'}                          = 'Кінець місяця';
    $Lang->{'EndYear'}                           = 'Кінець року';
    $Lang->{'Approval'}                          = 'Уточнить смысл и изменить(Approval)';
    $Lang->{'internal'}                          = '';
    $Lang->{'external'}                          = '';
    $Lang->{'public'}                            = '';

    $Lang->{
        'No category accessible. To create an article you need access to at least one category. Please check your group/category permission under -category menu-!'
        } = 'Немає доступних категорій. Щоб створити статтю вам необхідно одержати доступ, принаймні до одній категорії. Будь ласка, перевірте вашу групу/категорію доступу для -категорії меню-!';
    $Lang->{'Agent groups which can access this category.'} = 'Виділіть групи, якиі можуть отримати доступ до категорії';
    $Lang->{'A category needs at least one permission group!'}   = 'Категорії неодбхідне мінімальні права доступу у группі';
    $Lang->{'Will be shown as comment in Explorer.'}         = 'Буде показано, як коментар у Провіднику';
    $Lang->{'FAQ'}                          = 'База знань';
    $Lang->{'FAQ-Area'}                     = 'База знань';
    $Lang->{'Explorer'}                       = 'Провідник';
    $Lang->{'Здрастуйте'}                   = 'Вітаємо';
    return 1;
}

1;
