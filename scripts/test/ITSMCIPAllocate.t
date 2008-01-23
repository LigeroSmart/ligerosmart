# --
# ITSMCIPAllocate.t - general catalog tests
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: ITSMCIPAllocate.t,v 1.3 2008-01-23 16:48:36 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

use strict;
use warnings;

use Kernel::System::ITSMCIPAllocate;

$Self->{CIPAllocateObject} = Kernel::System::ITSMCIPAllocate->new( %{$Self} );

# get current allocation list (UserID is needed)
my $AllocateData1 = $Self->{CIPAllocateObject}->AllocateList();

# check the result
$Self->False( $AllocateData1, 'AllocateList()' );

# get current allocation list
my $AllocateData2 = $Self->{CIPAllocateObject}->AllocateList( UserID => 1 );

# check the result
$Self->True( $AllocateData2, 'AllocateList()' );

# check the allocation hash
my $HashOK = 1;
if ( ref($AllocateData2) ne 'HASH' ) {
    $HashOK = 0;
}

# check the allocation 2d hash
IMPACTID:
for my $ImpactID ( keys %{$AllocateData2} ) {

    if ( ref( $AllocateData2->{$ImpactID} ) ne 'HASH' ) {
        $HashOK = 0;
        last IMPACTID;
    }

    CRITICALITYID:
    for my $CriticalityID ( keys %{ $AllocateData2->{$ImpactID} } ) {

        if ( !$CriticalityID || !$AllocateData2->{$ImpactID}->{$CriticalityID} ) {
            $HashOK = 0;
            last IMPACTID;
        }
    }
}

# check HashOK
$Self->True( $HashOK, 'AllocateList()' );

# update the allocation hash (not all needed arguments given)
my $Success1 = $Self->{CIPAllocateObject}->AllocateUpdate( UserID => 1 );

# check the result
$Self->False( $Success1, 'AllocateUpdate()' );

# update the allocation hash (not all needed arguments given)
my $Success2 = $Self->{CIPAllocateObject}->AllocateUpdate( AllocateData => $AllocateData2 );

# check the result
$Self->False( $Success2, 'AllocateUpdate()' );

# update the allocation hash (allocation hash )
my $Success3 = $Self->{CIPAllocateObject}->AllocateUpdate(
    AllocateData => { Test => 'aaa', Test2 => 'bbb' },
    UserID => 1,
);

# check the result
$Self->False( $Success3, 'AllocateUpdate()' );

# update the allocation hash
my $Success4 = $Self->{CIPAllocateObject}->AllocateUpdate(
    AllocateData => $AllocateData2,
    UserID       => 1,
);

# check the result
$Self->True( $Success4, 'AllocateUpdate()' );

1;
