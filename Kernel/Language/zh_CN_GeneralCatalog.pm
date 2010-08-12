# --
# Kernel/Language/zh_CN_GeneralCatalog.pm - the Chinese simple translation of GeneralCatalog
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# --
# $Id: zh_CN_GeneralCatalog.pm,v 1.4 2010-08-12 22:50:38 cr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::zh_CN_GeneralCatalog;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.4 $) [1];

sub Data {
    my $Self = shift;

    my $Lang = $Self->{Translation};

    return if ref $Lang ne 'HASH';

    $Lang->{'General Catalog'}            = '总目录';
    $Lang->{'General Catalog Management'} = '总目录管理';
    $Lang->{'Catalog Class'}              = '目录分级';
    $Lang->{'Add a new Catalog Class.'}   = '增加一个新目录分级';
    $Lang->{'Add Catalog Item'}           = '增加目录项目';
    $Lang->{'Add Catalog Class'}          = '增加新目录分级';
    $Lang->{'Functionality'}              = '功能用途';
    $Lang->{'Frontend module registration for the AdminGeneralCatalog configuration in the admin area.'} = '';
    $Lang->{'Parameters for the example comment 2 of general catalog attributes.'} = '';
    $Lang->{'Parameters for the example permission groups of general catalog attributes.'} = '';

    return 1;
}

1;
