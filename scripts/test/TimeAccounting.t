# --
# scripts/test/TimeAccounting.t - TimeAccounting testscript
# Copyright (C) 2001-2009 OTRS AG, http://otrs.org/
# --
# $Id: TimeAccounting.t,v 1.4 2009-01-14 07:38:23 tr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

use strict;
use warnings;

# declare externally defined variables to avoid errors under 'use strict'
use vars qw($Self);

use Kernel::System::TimeAccounting;

$Self->{TimeAccountingObject} = Kernel::System::TimeAccounting->new(
    ConfigObject => $Self->{ConfigObject},
    LogObject    => $Self->{LogObject},
    DBObject     => $Self->{DBObject},
    TimeObject   => $Self->{TimeObject},
    UserID       => 1,
);

1;
