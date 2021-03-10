# --
# Copyright (C) 2021 LigeroSmart, https://ligerosmart.com
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package scripts::LigeroSmartUpgrade::06_00_32::01_checkFramework;    ## no critic

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::System::DB',
    'Kernel::System::Log',
    'Kernel::System::Package',
);

use parent qw(scripts::LigeroSmartUpgrade::Base);

sub Run {
    my ( $Self, %Param ) = @_;

    print "        6.0.32 --------\n\n";

    return 1;
}

1;