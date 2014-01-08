# --
# ITSMCIPAllocate.t - criticality, impact priority tests
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;

use vars qw($Self);

use Kernel::System::ITSMCIPAllocate;

$Self->{CIPAllocateObject} = Kernel::System::ITSMCIPAllocate->new( %{$Self} );

# get current allocation list (UserID is needed)
my $AllocateData1 = $Self->{CIPAllocateObject}->AllocateList();

# check the result
$Self->False( $AllocateData1, 'AllocateList()' );

# get current allocation list
my $AllocateData2 = $Self->{CIPAllocateObject}->AllocateList(
    UserID => 1,
);

# check the result
$Self->True( $AllocateData2, 'AllocateList()' );

# check the allocation hash
my $HashOK = 1;
if ( ref $AllocateData2 ne 'HASH' ) {
    $HashOK = 0;
}

# check the allocation 2d hash
if ($HashOK) {

    IMPACT:
    for my $Impact ( sort keys %{$AllocateData2} ) {

        if ( ref $AllocateData2->{$Impact} ne 'HASH' ) {
            $HashOK = 0;
            last IMPACT;
        }

        CRITICALITY:
        for my $Criticality ( sort keys %{ $AllocateData2->{$Impact} } ) {

            if ( !$Criticality || !$AllocateData2->{$Impact}->{$Criticality} ) {
                $HashOK = 0;
                last IMPACT;
            }
        }
    }
}

# check HashOK
$Self->True( $HashOK, 'AllocateList()' );

# call PriorityAllocationGet() for one Criticality/Impact pair
if ($HashOK) {

    my ($Impact) = sort keys %{$AllocateData2};

    if ( $AllocateData2->{$Impact} ) {
        my ($Criticality) = sort keys %{ $AllocateData2->{$Impact} };

        my $ExpectedPriorityID = $AllocateData2->{$Impact}->{$Criticality};
        my $PriorityID         = $Self->{CIPAllocateObject}->PriorityAllocationGet(
            Criticality => $Criticality,
            Impact      => $Impact,
        );
        $Self->Is(
            $PriorityID,
            $ExpectedPriorityID,
            'PriorityAllocationGet()',
        );
    }
}

# update the allocation hash (not all needed arguments given)
my $Success1 = $Self->{CIPAllocateObject}->AllocateUpdate(
    UserID => 1,
);

# check the result
$Self->False( $Success1, 'AllocateUpdate()' );

# update the allocation hash (not all needed arguments given)
my $Success2 = $Self->{CIPAllocateObject}->AllocateUpdate(
    AllocateData => $AllocateData2,
);

# check the result
$Self->False( $Success2, 'AllocateUpdate()' );

# update the allocation hash (allocation hash)
my $Success3 = $Self->{CIPAllocateObject}->AllocateUpdate(
    AllocateData => {
        Test  => 'aaa',
        Test2 => 'bbb',
    },
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
