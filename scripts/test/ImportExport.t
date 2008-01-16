# --
# ImportExport.t - import export tests
# Copyright (C) 2001-2007 OTRS GmbH, http://otrs.org/
# --
# $Id: ImportExport.t,v 1.1.1.1 2008-01-16 14:11:00 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

use strict;
use warnings;

use Kernel::System::ImportExport;

$Self->{ImportExportObject} = Kernel::System::ImportExport->new( %{$Self} );



1;