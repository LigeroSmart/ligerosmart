# --
# scripts/test/TimeAccounting.t - TimeAccounting testscript
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# --
# $Id: TimeAccounting.t,v 1.6 2010-07-29 08:40:16 jp Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;

# declare externally defined variables to avoid errors under 'use strict'
use vars qw($Self);

use Kernel::System::TimeAccounting;
use Kernel::System::User;

my $UserObject           = Kernel::System::User->new( %{$Self} );
my $TimeAccountingObject = Kernel::System::TimeAccounting->new(
    %{$Self},
    UserID     => 1,
    UserObject => $UserObject,
);

# IDs of created projects
my @ProjectIDs;

# insert test project settings
my $ProjectID = $TimeAccountingObject->ProjectSettingsInsert(
    Project            => 'Test',
    ProjectDescription => 'Description',
    ProjectStatus      => 1,
);

$Self->True(
    $ProjectID,
    'Insert test project settings into database',
);

push @ProjectIDs, $ProjectID;

# check if project settings have (really) been created
my %ProjectData = $TimeAccountingObject->ProjectSettingsGet(
    Status => 'valid',
);

my $ProjectFound            = 0;
my $ProjectDescriptionFound = 0;

$Self->True(
    exists $ProjectData{Project}->{$ProjectID}
        && $ProjectData{Project}->{$ProjectID} eq 'Test'
        && exists $ProjectData{ProjectDescription}->{$ProjectID}
        && $ProjectData{ProjectDescription}->{$ProjectID} eq 'Description',
    'test project found',
);

# delete test project(s)
for my $ProjectID (@ProjectIDs) {
    my $Result = $TimeAccountingObject->ProjectSettingsDelete(
        ProjectID => $ProjectID,
    );

    $Self->True(
        $Result,
        'test project deleted',
    );

    # TODO:
    # test if deleted project really doesn't exist anymore
}

1;
