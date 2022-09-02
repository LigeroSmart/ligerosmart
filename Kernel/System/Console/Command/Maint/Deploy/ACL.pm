# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::Console::Command::Maint::Deploy::ACL;

use strict;
use warnings;

use parent qw(Kernel::System::Console::BaseCommand);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::ACL::DB::ACL',
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('Synchronize ACL file with the latest deployment in the database.');

    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    $Self->Print("<yellow>Synchronizing ACLs...</yellow>\n");

    my $Location = $Kernel::OM->Get('Kernel::Config')->Get('Home') . '/Kernel/Config/Files/ZZZACL.pm';

    my $ACLDump = $Kernel::OM->Get('Kernel::System::ACL::DB::ACL')->ACLDump(
        ResultType => 'FILE',
        Location   => $Location,
        UserID     => 1,
    );

    if ( !$ACLDump ) {
        $Self->print("\t<red> - There was an error synchronizing the ACLs.</red>\n\n");
        return $Self->ExitCodeError();
    }

    my $Success = $Kernel::OM->Get('Kernel::System::ACL::DB::ACL')->ACLsNeedSyncReset();
    if ( !$Success ) {
        $Self->print("\t<red> - There was an error setting the entity sync status.</red>\n\n");
        return $Self->ExitCodeError();
    }

    $Self->Print("\n<green>Done.</green>\n");
    return $Self->ExitCodeOk();
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<https://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
