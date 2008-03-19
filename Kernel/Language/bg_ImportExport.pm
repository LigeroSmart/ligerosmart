# --
# Kernel/Language/bg_ImportExport.pm - the bulgarian translation of ImportExport
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: bg_ImportExport.pm,v 1.3 2008-03-19 15:10:04 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::Language::bg_ImportExport;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.3 $) [1];

sub Data {
    my ($Self) = @_;
    my $Lang = $Self->{Translation};

    return if ref $Lang ne 'HASH';

    $Lang->{'Import/Export'} = 'Import/Export';

    return 1;
}

1;
