# --
# ImportExport.t - all general import export tests
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: ImportExport.t,v 1.12 2008-03-26 17:35:14 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

use strict;
use warnings;
use utf8;

use vars qw($Self);

use Kernel::System::ImportExport;
use Kernel::System::User;

$Self->{ImportExportObject} = Kernel::System::ImportExport->new( %{$Self} );
$Self->{UserObject}         = Kernel::System::User->new( %{$Self} );

# ------------------------------------------------------------ #
# make preparations
# ------------------------------------------------------------ #

# create needed users
my @UserIDs;
{

    # disable email checks to create new user
    my $CheckEmailAddressesOrg = $Self->{ConfigObject}->Get('CheckEmailAddresses') || 1;
    $Self->{ConfigObject}->Set(
        Key   => 'CheckEmailAddresses',
        Value => 0,
    );

    for my $Counter ( 1 .. 2 ) {

        # create new users for the tests
        my $UserID = $Self->{UserObject}->UserAdd(
            UserFirstname => 'ImportExport' . $Counter,
            UserLastname  => 'UnitTest',
            UserLogin     => 'UnitTest-ImportExport-' . $Counter . int rand 1_000_000,
            UserEmail     => 'UnitTest-ImportExport-' . $Counter . '@localhost',
            ValidID       => 1,
            ChangeUserID  => 1,
        );

        push @UserIDs, $UserID;
    }

    # restore original email check param
    $Self->{ConfigObject}->Set(
        Key   => 'CheckEmailAddresses',
        Value => $CheckEmailAddressesOrg,
    );
}

# create needed random template names
my @TemplateName;

for my $Counter ( 1 .. 5 ) {

    push @TemplateName, 'UnitTest' . int rand 1_000_000;
}

# create needed random object names
my @ObjectName;
push @ObjectName, 'UnitTest' . int rand 1_000_000;

# create needed format names
my @FormatName = ('CSV');

# get original template list for later checks (all elements)
my $TemplateList1All = $Self->{ImportExportObject}->TemplateList(
    UserID => 1,
);

# get original template list for later checks (all elements)
my $TemplateList1Object = $Self->{ImportExportObject}->TemplateList(
    Object => $ObjectName[0],
    UserID => 1,
);

# ------------------------------------------------------------ #
# define general tests
# ------------------------------------------------------------ #

my $ItemData = [

    # this template is NOT complete and must not be added
    {
        Add => {
            Format  => $FormatName[0],
            Name    => $TemplateName[0],
            ValidID => 1,
            UserID  => 1,
        },
    },

    # this template is NOT complete and must not be added
    {
        Add => {
            Object  => $ObjectName[0],
            Name    => $TemplateName[0],
            ValidID => 1,
            UserID  => 1,
        },
    },

    # this template is NOT complete and must not be added
    {
        Add => {
            Object  => $ObjectName[0],
            Format  => $FormatName[0],
            ValidID => 1,
            UserID  => 1,
        },
    },

    # this template is NOT complete and must not be added
    {
        Add => {
            Object => $ObjectName[0],
            Format => $FormatName[0],
            Name   => $TemplateName[0],
            UserID => 1,
        },
    },

    # this template is NOT complete and must not be added
    {
        Add => {
            Object  => $ObjectName[0],
            Format  => $FormatName[0],
            Name    => $TemplateName[0],
            ValidID => 1,
        },
    },

    # this template must be inserted sucessfully
    {
        Add => {
            Object  => $ObjectName[0],
            Format  => $FormatName[0],
            Name    => $TemplateName[0],
            ValidID => 1,
            UserID  => 1,
        },
        AddGet => {
            Object   => $ObjectName[0],
            Format   => $FormatName[0],
            Name     => $TemplateName[0],
            ValidID  => 1,
            Comment  => '',
            CreateBy => 1,
            ChangeBy => 1,
        },
    },

    # this template have the same name as one test before and must not be added
    {
        Add => {
            Object  => $ObjectName[0],
            Format  => $FormatName[0],
            Name    => $TemplateName[0],
            ValidID => 1,
            UserID  => 1,
        },
    },

    # this template must be inserted sucessfully
    {
        Add => {
            Object  => $ObjectName[0],
            Format  => $FormatName[0],
            Name    => $TemplateName[1],
            ValidID => 1,
            Comment => 'TestComment',
            UserID  => 1,
        },
        AddGet => {
            Object   => $ObjectName[0],
            Format   => $FormatName[0],
            Name     => $TemplateName[1],
            ValidID  => 1,
            Comment  => 'TestComment',
            CreateBy => 1,
            ChangeBy => 1,
        },
    },

    # the template one add-test before must be NOT updated (template update arguments NOT complete)
    {
        Update => {
            ValidID => 2,
            UserID  => $UserIDs[0],
        },
    },

    # the template one add-test before must be NOT updated (template update arguments NOT complete)
    {
        Update => {
            Name   => $TemplateName[1] . 'UPDATE1',
            UserID => $UserIDs[0],
        },
    },

    # the template one add-test before must be NOT updated (template update arguments NOT complete)
    {
        Update => {
            Name    => $TemplateName[1] . 'UPDATE2',
            ValidID => 2,
        },
    },

    # the template one add-test before must be updated (template update arguments are complete)
    {
        Update => {
            Name    => $TemplateName[1] . 'UPDATE3',
            Comment => 'TestComment UPDATE3',
            ValidID => 2,
            UserID  => $UserIDs[0],
        },
        UpdateGet => {
            Name     => $TemplateName[1] . 'UPDATE3',
            ValidID  => 2,
            Comment  => 'TestComment UPDATE3',
            CreateBy => 1,
            ChangeBy => $UserIDs[0],
        },
    },

    # the template one add-test before must be updated (template update arguments are complete)
    {
        Update => {
            Name    => $TemplateName[1] . 'UPDATE4',
            ValidID => 1,
            Comment => '',
            UserID  => 1,
        },
        UpdateGet => {
            Name     => $TemplateName[1] . 'UPDATE4',
            ValidID  => 1,
            Comment  => '',
            CreateBy => 1,
            ChangeBy => 1,
        },
    },

    # this template must be inserted sucessfully (check string cleaner function)
    {
        Add => {
            Object  => " \t \n \r " . $ObjectName[0] . " \t \n \r ",
            Format  => " \t \n \r " . $FormatName[0] . " \t \n \r ",
            Name    => " \t \n \r " . $TemplateName[2] . " \t \n \r ",
            ValidID => 1,
            Comment => " \t \n \r Test Comment \t \n \r ",
            UserID  => 1,
        },
        AddGet => {
            Object   => $ObjectName[0],
            Format   => $FormatName[0],
            Name     => $TemplateName[2],
            ValidID  => 1,
            Comment  => 'Test Comment',
            CreateBy => 1,
            ChangeBy => 1,
        },
    },

    # the template one add-test before must be updated (check string cleaner function)
    {
        Update => {
            Name    => " \t \n \r " . $TemplateName[2] . "UPDATE1 \t \n \r ",
            ValidID => 1,
            Comment => " \t \n \r Test Comment UPDATE1 \t \n \r ",
            UserID  => 1,
        },
        UpdateGet => {
            Name     => $TemplateName[2] . 'UPDATE1',
            ValidID  => 1,
            Comment  => 'Test Comment UPDATE1',
            CreateBy => 1,
            ChangeBy => 1,
        },
    },

    # this template must be inserted sucessfully (unicode checks)
    {
        Add => {
            Object  => ' ƕ Ƙ ' . $ObjectName[0] . ' Ƶ ƻ ',
            Format  => ' Ǔ ǣ ' . $FormatName[0] . ' ǥ Ǯ ',
            Name    => ' Ƿ Ȝ ' . $TemplateName[3] . ' Ȟ Ƞ ',
            ValidID => 2,
            Comment => ' Ѡ Ѥ TestComment5 Ϡ Ω ',
            UserID  => 1,
        },
        AddGet => {
            Object   => 'ƕƘ' . $ObjectName[0] . 'Ƶƻ',
            Format   => 'Ǔǣ' . $FormatName[0] . 'ǥǮ',
            Name     => 'Ƿ Ȝ ' . $TemplateName[3] . ' Ȟ Ƞ',
            ValidID  => 2,
            Comment  => 'Ѡ Ѥ TestComment5 Ϡ Ω',
            CreateBy => 1,
            ChangeBy => 1,
        },
    },
];

# ------------------------------------------------------------ #
# run general tests
# ------------------------------------------------------------ #

my $TestCount  = 1;
my $AddCounter = 0;
my $LastAddedTemplateID;

TEMPLATE:
for my $Item ( @{$ItemData} ) {

    if ( $Item->{Add} ) {

        # add new template
        my $TemplateID = $Self->{ImportExportObject}->TemplateAdd( %{ $Item->{Add} } );

        if ($TemplateID) {
            $LastAddedTemplateID = $TemplateID;
            $AddCounter++;
        }

        # check if template was added successfully or not
        if ( $Item->{AddGet} ) {
            $Self->True(
                $TemplateID,
                "Test $TestCount: TemplateAdd() - TemplateKey: $TemplateID"
            );
        }
        else {
            $Self->False( $TemplateID, "Test $TestCount: TemplateAdd()" );
        }
    }

    if ( $Item->{AddGet} ) {

        # get template data to check the values after template was added
        my $TemplateGet = $Self->{ImportExportObject}->TemplateGet(
            TemplateID => $LastAddedTemplateID,
            UserID => $Item->{Add}->{UserID} || 1,
        );

        # check template data after creation of template
        for my $TemplateAttribute ( keys %{ $Item->{AddGet} } ) {
            $Self->Is(
                $TemplateGet->{$TemplateAttribute} || '',
                $Item->{AddGet}->{$TemplateAttribute} || '',
                "Test $TestCount: TemplateGet() - $TemplateAttribute",
            );
        }
    }

    if ( $Item->{Update} ) {

        # check last template id varaible
        if ( !$LastAddedTemplateID ) {
            $Self->False(
                1,
                "Test $TestCount: NO LAST ITEM ID GIVEN. Please add a template first."
            );
            last TEMPLATE;
        }

        # update the template
        my $UpdateSucess = $Self->{ImportExportObject}->TemplateUpdate(
            %{ $Item->{Update} },
            TemplateID => $LastAddedTemplateID,
        );

        # check if template was updated successfully or not
        if ( $Item->{UpdateGet} ) {
            $Self->True(
                $UpdateSucess,
                "Test $TestCount: TemplateUpdate() - TemplateKey: $LastAddedTemplateID",
            );
        }
        else {
            $Self->False(
                $UpdateSucess,
                "Test $TestCount: TemplateUpdate()",
            );
        }
    }

    if ( $Item->{UpdateGet} ) {

        # get template data to check the values after the update
        my $TemplateGet = $Self->{ImportExportObject}->TemplateGet(
            TemplateID => $LastAddedTemplateID,
            UserID => $Item->{Update}->{UserID} || 1,
        );

        # check template data after update
        for my $TemplateAttribute ( keys %{ $Item->{UpdateGet} } ) {
            $Self->Is(
                $TemplateGet->{$TemplateAttribute} || '',
                $Item->{UpdateGet}->{$TemplateAttribute} || '',
                "Test $TestCount: TemplateGet() - $TemplateAttribute",
            );
        }
    }
}
continue {

    # increment the counter
    $TestCount++;
}

# ------------------------------------------------------------ #
# TemplateList test 1 (check array references)
# ------------------------------------------------------------ #

# list must be an empty array reference
$Self->True(
    ref $TemplateList1All eq 'ARRAY' && ref $TemplateList1Object eq 'ARRAY',
    "Test $TestCount: TemplateList() - array references",
);

$TestCount++;

# ------------------------------------------------------------ #
# TemplateList test 2 (list must be empty)
# ------------------------------------------------------------ #

# list must be an empty list
$Self->True(
    scalar @{$TemplateList1Object} eq 0,
    "Test $TestCount: TemplateList() - empty list",
);

$TestCount++;

# ------------------------------------------------------------ #
# TemplateList test 2 (check correct number of new items)
# ------------------------------------------------------------ #

# get template list with all elements
my $TemplateList2 = $Self->{ImportExportObject}->TemplateList(
    UserID => 1,
);

# list must be an array reference
$Self->True(
    ref $TemplateList2 eq 'ARRAY',
    "Test $TestCount: TemplateList() - array reference",
);

my $TemplateListCount = scalar @{$TemplateList2} - scalar @{$TemplateList1All};

# check correct number of new items
$Self->True(
    $TemplateListCount eq $AddCounter,
    "Test $TestCount: TemplateList() - correct number of new items",
);

$TestCount++;

# ------------------------------------------------------------ #
# TemplateDelete test 1 (add one template and delete it)
# ------------------------------------------------------------ #

# get template list with all elements
my $TemplateDelete1List1 = $Self->{ImportExportObject}->TemplateList(
    Object => $ObjectName[0],
    UserID => 1,
);

# add a test template
my $TemplateDeleteID = $Self->{ImportExportObject}->TemplateAdd(
    Object  => $ObjectName[0],
    Format  => $FormatName[0],
    Name    => $TemplateName[4],
    ValidID => 1,
    UserID  => 1,
);

# get template list with all elements
my $TemplateDelete1List2 = $Self->{ImportExportObject}->TemplateList(
    Object => $ObjectName[0],
    UserID => 1,
);

# list must have one more element
$Self->True(
    scalar @{$TemplateDelete1List1} eq ( scalar @{$TemplateDelete1List2} ) - 1,
    "Test $TestCount: TemplateDelete() - number of listed elements",
);

# delete the new template
my $TemplateDelete1 = $Self->{ImportExportObject}->TemplateDelete(
    TemplateID => $TemplateDeleteID,
    UserID     => 1,
);

# list must be successfull
$Self->True(
    $TemplateDelete1,
    "Test $TestCount: TemplateDelete()",
);

# get template list with all elements
my $TemplateDelete1List3 = $Self->{ImportExportObject}->TemplateList(
    Object => $ObjectName[0],
    UserID => 1,
);

# list must have the original number of elements
$Self->True(
    scalar @{$TemplateDelete1List1} eq scalar @{$TemplateDelete1List3},
    "Test $TestCount: TemplateDelete() - number of listed elements",
);

$TestCount++;

# ------------------------------------------------------------ #
# ObjectList test 1 (check general functionality)
# ------------------------------------------------------------ #

# define test list
my $ObjectList1TestList = {
    UnitTest1 => {
        Module => 'Kernel::System::ImportExport::ObjectBackend::UnitTest1',
        Name   => 'Unit Test 1',
    },
    UnitTest2 => {
        Module => 'Kernel::System::ImportExport::ObjectBackend::UnitTest2',
        Name   => 'Unit Test 2',
    },
};

# get original object list
my $ObjectListOrg = $Self->{ConfigObject}->Get('ImportExport::ObjectBackendRegistration');

# set test list
$Self->{ConfigObject}->Set(
    Key   => 'ImportExport::ObjectBackendRegistration',
    Value => $ObjectList1TestList,
);

# get object list
my $ObjectList1 = $Self->{ImportExportObject}->ObjectList();

# list must be a hash reference
$Self->True(
    ref $ObjectList1 eq 'HASH',
    "Test $TestCount: ObjectList() - hash reference",
);

# check the list
KEY:
for my $Key ( keys %{$ObjectList1} ) {

    if ( !$ObjectList1TestList->{$Key} ) {
        $ObjectList1TestList->{Dummy} = 1;
    }

    next KEY if $ObjectList1->{$Key} ne $ObjectList1TestList->{$Key}->{Name};

    delete $ObjectList1TestList->{$Key};
}

$Self->True(
    !%{$ObjectList1TestList},
    "Test $TestCount: ObjectList() - content is valid",
);

# restore original object list
$Self->{ConfigObject}->Set(
    Key   => 'ImportExport::ObjectBackendRegistration',
    Value => $ObjectListOrg,
);

$TestCount++;

# ------------------------------------------------------------ #
# FormatList test 1 (check general functionality)
# ------------------------------------------------------------ #

# define test list
my $FormatList1TestList = {
    UnitTest1 => {
        Module => 'Kernel::System::ImportExport::FormatBackend::UnitTest1',
        Name   => 'Unit Test 1',
    },
    UnitTest2 => {
        Module => 'Kernel::System::ImportExport::FormatBackend::UnitTest2',
        Name   => 'Unit Test 2',
    },
};

# get original format list
my $FormatListOrg = $Self->{ConfigObject}->Get('ImportExport::FormatBackendRegistration');

# set test list
$Self->{ConfigObject}->Set(
    Key   => 'ImportExport::FormatBackendRegistration',
    Value => $FormatList1TestList,
);

# get format list
my $FormatList1 = $Self->{ImportExportObject}->FormatList();

# list must be a hash reference
$Self->True(
    ref $FormatList1 eq 'HASH',
    "Test $TestCount: FormatList() - hash reference",
);

# check the list
KEY:
for my $Key ( keys %{$FormatList1} ) {

    if ( !$FormatList1TestList->{$Key} ) {
        $FormatList1TestList->{Dummy} = 1;
    }

    next KEY if $FormatList1->{$Key} ne $FormatList1TestList->{$Key}->{Name};

    delete $FormatList1TestList->{$Key};
}

$Self->True(
    !%{$FormatList1TestList},
    "Test $TestCount: FormatList() - content is valid",
);

# restore original format list
$Self->{ConfigObject}->Set(
    Key   => 'ImportExport::FormatBackendRegistration',
    Value => $FormatListOrg,
);

$TestCount++;

1;
