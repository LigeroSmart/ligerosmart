# --
# Kernel/Language/bg_ImportExport.pm - the bulgarian translation of ImportExport
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# Copyright (C) 2007-2008 Milen Koutev
# --
# $Id: bg_ImportExport.pm,v 1.9 2010-05-17 13:49:17 ub Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::bg_ImportExport;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.9 $) [1];

sub Data {
    my $Self = shift;

    my $Lang = $Self->{Translation};

    return if ref $Lang ne 'HASH';

    $Lang->{'Import/Export'}              = '';
    $Lang->{'Import/Export Management'}   = '';
    $Lang->{'Add mapping template'}       = '';
    $Lang->{'Start Import'}               = '';
    $Lang->{'Start Export'}               = '';
    $Lang->{'Step'}                       = '';
    $Lang->{'Edit common information'}    = '';
    $Lang->{'Edit object information'}    = '';
    $Lang->{'Edit format information'}    = '';
    $Lang->{'Edit mapping information'}   = '';
    $Lang->{'Edit search information'}    = '';
    $Lang->{'Import information'}         = '';
    $Lang->{'Column'}                     = '';
    $Lang->{'Restrict export per search'} = '';
    $Lang->{'Source File'}                = '';
    $Lang->{'Column Separator'}           = '';
    $Lang->{'Tabulator (TAB)'}            = '';
    $Lang->{'Semicolon (;)'}              = '';
    $Lang->{'Colon (:)'}                  = '';
    $Lang->{'Dot (.)'}                    = '';
    $Lang->{'Charset'}                    = '';

    return 1;
}

1;
