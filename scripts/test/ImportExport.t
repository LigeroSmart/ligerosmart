# --
# ImportExport.t - import export tests
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: ImportExport.t,v 1.5 2008-02-04 12:19:54 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

use strict;
use warnings;

use Kernel::System::ImportExport;

$Self->{ImportExportObject} = Kernel::System::ImportExport->new( %{$Self} );

# ------------------------------------------------------------ #
# ObjectList() test
# ------------------------------------------------------------ #

# get object list
my $ObjectList1 = $Self->{ImportExportObject}->ObjectList();

# list must be a hash reference
$Self->True(
    ref $ObjectList1 eq 'HASH',
    '#1 ObjectList() - hash reference',
);

# list must have valid content
if ( ref $ObjectList1 eq 'HASH' ) {

    my $Counter1 = 1;
    for my $Key ( keys %{$ObjectList1} ) {
        $Self->True(
            $Key && $ObjectList1->{$Key} && !ref $ObjectList1->{$Key},
            "#$Counter1 ObjectList() - valid content",
        );
        $Counter1++;
    }
}

# ------------------------------------------------------------ #
# TemplateList() test #1
# ------------------------------------------------------------ #

# create a random object name
my $ObjectRand = 'UnitTest' . int rand 1_000_000;

# get template list
my $TemplateList1 = $Self->{ImportExportObject}->TemplateList(
    Object => $ObjectRand,
    UserID => 1,
);

# list must be an empty array reference
$Self->True(
    ref $TemplateList1 eq 'ARRAY' && scalar @{$TemplateList1} eq 0,
    "#1 TemplateList() - empty array reference",
);

# ------------------------------------------------------------ #
# TemplateAdd() tests
# ------------------------------------------------------------ #

my $TemplateRandName1 = 'UnitTest' . int rand 1_000_000;
my $TemplateRandName2 = 'UnitTest' . int rand 1_000_000;
my $TemplateRandName3 = 'UnitTest' . int rand 1_000_000;

my $TemplateChecks = [

    # this template is NOT complete and must not be added
    {
        Add => {
            Name    => $TemplateRandName1,
            ValidID => 1,
            UserID  => 1,
        },
    },

    # this template is NOT complete and must not be added
    {
        Add => {
            Type    => 'Import',
            ValidID => 1,
            UserID  => 1,
        },
    },

    # this template is NOT complete and must not be added
    {
        Add => {
            Object  => $ObjectRand,
            ValidID => 1,
            UserID  => 1,
        },
    },

    # this template is NOT complete and must not be added
    {
        Add => {
            Object => $ObjectRand,
            Name   => $TemplateRandName1,
            UserID => 1,
        },
    },

    # this template is NOT complete and must not be added
    {
        Add => {
            Object  => $ObjectRand,
            Name    => $TemplateRandName1,
            ValidID => 1,
        },
    },

    # this template is NOT complete and must not be added
    {
        Add => {
            Object  => $ObjectRand,
            Format  => 'CSV',
            ValidID => 1,
        },
    },

    # this template must be inserted sucessfully
    {
        Add => {
            Type    => 'Import',
            Object  => $ObjectRand,
            Format  => 'CSV',
            Name    => $TemplateRandName1,
            ValidID => 1,
            UserID  => 1,
        },
        AddGet => {
            Type     => 'Import',
            Object   => $ObjectRand,
            Format   => 'CSV',
            Name     => $TemplateRandName1,
            ValidID  => 1,
            Comment  => '',
            CreateBy => 1,
            ChangeBy => 1,
        },
    },

    # this template have the same name as one test before and must not be added
    {
        Add => {
            Type    => 'Import',
            Object  => $ObjectRand,
            Format  => 'CSV',
            Name    => $TemplateRandName1,
            ValidID => 1,
            UserID  => 1,
        },
    },

    # this template must be inserted sucessfully
    {
        Add => {
            Type    => 'Import',
            Object  => $ObjectRand,
            Format  => 'CSV',
            Name    => $TemplateRandName2,
            ValidID => 1,
            Comment => 'This is a test!',
            UserID  => 1,
        },
        AddGet => {
            Type     => 'Import',
            Object   => $ObjectRand,
            Format   => 'CSV',
            Name     => $TemplateRandName2,
            ValidID  => 1,
            Comment  => 'This is a test!',
            CreateBy => 1,
            ChangeBy => 1,
        },
    },

    # the template one add-test before must be NOT updated (template update arguments NOT complete)
    {
        Update => {
            ValidID => 2,
            UserID  => 2,
        },
    },

    # the template one add-test before must be NOT updated (template update arguments NOT complete)
    {
        Update => {
            Name   => $TemplateRandName2 . 'Update1',
            UserID => 2,
        },
    },

    # the template one add-test before must be NOT updated (template update arguments NOT complete)
    {
        Update => {
            Name    => $TemplateRandName2 . 'Update2',
            ValidID => 2,
        },
    },

    # the template one add-test before must be updated (template update arguments are complete)
    {
        Update => {
            Name    => $TemplateRandName2 . 'Update3',
            Comment => 'This is a second test!',
            ValidID => 2,
            UserID  => 2,
        },
        UpdateGet => {
            Name     => $TemplateRandName2 . 'Update3',
            ValidID  => 2,
            Comment  => 'This is a second test!',
            CreateBy => 1,
            ChangeBy => 2,
        },
    },

    # the template one add-test before must be updated (template update arguments are complete)
    {
        Update => {
            Name    => $TemplateRandName2 . 'Update4',
            ValidID => 1,
            Comment => '',
            UserID  => 1,
        },
        UpdateGet => {
            Name     => $TemplateRandName2 . 'Update4',
            ValidID  => 1,
            Comment  => '',
            CreateBy => 1,
            ChangeBy => 1,
        },
    },

    # the template one add-test before must be updated (template update arguments are complete)
    {
        Update => {
            Name    => $TemplateRandName2 . 'Update5',
            ValidID => 1,
            Comment => 'This is a comment.',
            UserID  => 1,
        },
        UpdateGet => {
            Name     => $TemplateRandName2 . 'Update5',
            ValidID  => 1,
            Comment  => 'This is a comment.',
            CreateBy => 1,
            ChangeBy => 1,
        },
    },

    # this template must be inserted sucessfully (check string cleaner function)
    {
        Add => {
            Type    => " \t \n \r Import \t \n \r ",
            Object  => " \t \n \r " . $ObjectRand . " \t \n \r ",
            Format  => " \t \n \r CSV \t \n \r ",
            Name    => " \t \n \r " . $TemplateRandName3 . " \t \n \r ",
            ValidID => 1,
            UserID  => 1,
        },
        AddGet => {
            Type     => 'Import',
            Object   => $ObjectRand,
            Format   => 'CSV',
            Name     => $TemplateRandName3,
            ValidID  => 1,
            Comment  => '',
            CreateBy => 1,
            ChangeBy => 1,
        },
    },

    # the template one add-test before must be updated (check string cleaner function)
    {
        Update => {
            Name    => " \t \n \r " . $TemplateRandName3 . "Update1 \t \n \r ",
            ValidID => 1,
            UserID  => 1,
        },
        UpdateGet => {
            Name     => $TemplateRandName3 . 'Update1',
            ValidID  => 1,
            CreateBy => 1,
            ChangeBy => 1,
        },
    },
];

my $IteratorCounter = 1;
my $AddCounter      = 0;
my $LastAddedTemplateID;
TEMPLATE:
for my $Template ( @{$TemplateChecks} ) {

    if ( $Template->{Add} ) {

        # add new template
        my $TemplateID = $Self->{ImportExportObject}->TemplateAdd( %{ $Template->{Add} } );

        if ($TemplateID) {
            $LastAddedTemplateID = $TemplateID;
            $AddCounter++;
        }

        # check if template was added successfully or not
        if ( $Template->{AddGet} ) {
            $Self->True(
                $TemplateID,
                "#$IteratorCounter TemplateAdd() - TemplateKey: $TemplateID"
            );
        }
        else {
            $Self->False( $TemplateID, "#$IteratorCounter TemplateAdd()" );
        }
    }

    if ( $Template->{AddGet} ) {

        # get template data to check the values after template was added
        my $TemplateGet = $Self->{ImportExportObject}->TemplateGet(
            TemplateID => $LastAddedTemplateID,
            UserID => $Template->{Add}->{UserID} || 1,
        );

        # check template data after creation of template
        for my $TemplateAttribute ( keys %{ $Template->{AddGet} } ) {
            $Self->Is(
                $TemplateGet->{$TemplateAttribute} || '',
                $Template->{AddGet}->{$TemplateAttribute} || '',
                "#$IteratorCounter TemplateGet() - $TemplateAttribute",
            );
        }
    }

    if ( $Template->{Update} ) {

        # check last template id varaible
        if ( !$LastAddedTemplateID ) {
            $Self->False(
                1,
                "#$IteratorCounter NO LAST ITEM ID GIVEN. Please add a template first."
            );
            last TEMPLATE;
        }

        # update the template
        my $UpdateSucess = $Self->{ImportExportObject}
            ->TemplateUpdate( %{ $Template->{Update} }, TemplateID => $LastAddedTemplateID );

        # check if template was updated successfully or not
        if ( $Template->{UpdateGet} ) {
            $Self->True(
                $UpdateSucess,
                "#$IteratorCounter TemplateUpdate() - TemplateKey: $LastAddedTemplateID",
            );
        }
        else {
            $Self->False( $UpdateSucess, "#$IteratorCounter TemplateUpdate()" );
        }
    }

    if ( $Template->{UpdateGet} ) {

        # get template data to check the values after the update
        my $TemplateGet = $Self->{ImportExportObject}->TemplateGet(
            TemplateID => $LastAddedTemplateID,
            UserID => $Template->{Update}->{UserID} || 1,
        );

        # check template data after update
        for my $TemplateAttribute ( keys %{ $Template->{UpdateGet} } ) {
            $Self->Is(
                $TemplateGet->{$TemplateAttribute} || '',
                $Template->{UpdateGet}->{$TemplateAttribute} || '',
                "#$IteratorCounter: TemplateGet() - $TemplateAttribute",
            );
        }
    }
}
continue {

    # increment the counter
    $IteratorCounter++;
}

# ------------------------------------------------------------ #
# TemplateList() test #2
# ------------------------------------------------------------ #

# get template list
my $TemplateList2 = $Self->{ImportExportObject}->TemplateList(
    Object => $ObjectRand,
    UserID => 1,
);

# list must be an array reference
$Self->True(
    ref $TemplateList2 eq 'ARRAY' && scalar @{$TemplateList2} eq $AddCounter,
    "#2 TemplateList()",
);

# ------------------------------------------------------------ #
# TemplateDelete() tests
# ------------------------------------------------------------ #

# delete the first template
my $Success1 = $Self->{ImportExportObject}->TemplateDelete(
    TemplateID => shift @{$TemplateList2},
    UserID     => 1,
);

# list must be an empty array reference
$Self->True(
    $Success1,
    "#1 TemplateDelete()",
);

# delete the last template
my $Success2 = $Self->{ImportExportObject}->TemplateDelete(
    TemplateID => $TemplateList2,
    UserID     => 1,
);

# list must be an empty array reference
$Self->True(
    $Success2,
    "#2 TemplateDelete()",
);

# ------------------------------------------------------------ #
# TemplateList() test #3
# ------------------------------------------------------------ #

# get template list
my $TemplateList3 = $Self->{ImportExportObject}->TemplateList(
    Object => $ObjectRand,
    UserID => 1,
);

# list must be an empty array reference
$Self->True(
    ref $TemplateList3 eq 'ARRAY' && scalar @{$TemplateList3} eq 0,
    "#3 TemplateList() - empty array reference",
);

1;
