# --
# ITSMTemplate.t - change tests
# Copyright (C) 2003-2010 OTRS AG, http://otrs.com/
# --
# $Id: ITSMTemplate.t,v 1.2 2010-02-02 12:56:26 reb Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use utf8;

use vars qw($Self);

use Data::Dumper;
use List::Util qw(max);

use Kernel::System::ITSMChange;
use Kernel::System::ITSMChange::ITSMCondition;
use Kernel::System::ITSMChange::ITSMWorkOrder;
use Kernel::System::ITSMChange::Template;
use Kernel::System::Valid;

# ---------------------------------------------------------------------------- #
# Note for developers:
# Please note that the keys in %ChangeDefinitions (resp. WorkOrderDefinitions )
# have to be identical with the key names in %TemplateDefinitions
# ---------------------------------------------------------------------------- #

# ------------------------------------------------------------ #
# make preparations
# ------------------------------------------------------------ #
my $TestCount = 1;

# create common objects
$Self->{ChangeObject}    = Kernel::System::ITSMChange->new( %{$Self} );
$Self->{ConditionObject} = Kernel::System::ITSMChange::ITSMCondition->new( %{$Self} );
$Self->{WorkOrderObject} = Kernel::System::ITSMChange::ITSMWorkOrder->new( %{$Self} );
$Self->{TemplateObject}  = Kernel::System::ITSMChange::Template->new( %{$Self} );
$Self->{ValidObject}     = Kernel::System::Valid->new( %{$Self} );

# test if change object was created successfully
$Self->True(
    $Self->{TemplateObject},
    "Test " . $TestCount++ . ' - construction of template object',
);
$Self->Is(
    ref $Self->{TemplateObject},
    'Kernel::System::ITSMChange::Template',
    "Test " . $TestCount++ . ' - class of template object',
);

# ------------------------------------------------------------ #
# test Template API
# ------------------------------------------------------------ #

# define public interface (in alphabetical order)
my @ObjectMethods = qw(
    TemplateAdd
    TemplateDelete
    TemplateUpdate
    TemplateSearch
    TemplateSerialize
    TemplateDeSerialize
    TemplateTypeLookup
    TemplateList
    TemplateGet
);

# check if subs are available
for my $ObjectMethod (@ObjectMethods) {
    $Self->True(
        $Self->{TemplateObject}->can($ObjectMethod),
        "Test " . $TestCount++ . " - check 'can $ObjectMethod'",
    );
}

# ------------------------------------------------------------ #
# search for default Template types
# ------------------------------------------------------------ #

# define default Template types
my @DefaultTypes = qw(
    ITSMChange
    ITSMWorkOrder
    ITSMCondition
    CAB
);

# investigate the default types
for my $Type (@DefaultTypes) {

    # look up the state name
    my $LookedUpTypeID = $Self->{TemplateObject}->TemplateTypeLookup(
        TemplateType => $Type,
    );

    $Self->True(
        $LookedUpTypeID,
        "Look up type '$Type'",
    );

    # do the reverse lookup
    my $LookedUpType = $Self->{TemplateObject}->TemplateTypeLookup(
        TemplateTypeID => $LookedUpTypeID,
    );

    $Self->Is(
        $LookedUpType,
        $Type,
        "Look up type id '$LookedUpTypeID'",
    );
}

# now some param checks for ChangeStateLookup
my $LookupOk = $Self->{TemplateObject}->TemplateTypeLookup();

$Self->False(
    $LookupOk,
    'No params passed to TemplateTypeLookup()',
);

$LookupOk = $Self->{TemplateObject}->TemplateTypeLookup(
    TemplateType   => 'approved',
    TemplateTypeID => 2,
);

$Self->False(
    $LookupOk,
    'Exclusive params passed to TemplateTypeLookup()',
);

$LookupOk = $Self->{TemplateObject}->TemplateTypeLookup(
    TemplateTypes => 'ITSMAnything',
);

$Self->False(
    $LookupOk,
    "Incorrect param 'TemplateTypes' passed to TemplateTypeLookup()",
);

# ------------------------------------------------------------ #
# general template tests
# ------------------------------------------------------------ #

# store current TestCount for better test case recognition
my $TestCountMisc = $TestCount;

# An unique indentifier, so that data from different test runs
# won't be mixed up. The string is formated to a constant length,
# as the conversion to plain text with ToAscii() depends on the string length.
my $UniqueSignature = sprintf 'UnitTest-ITSMTemplate-%06d_%010d',
    int( rand 1_000_000 ),
    time();

my %ChangeDefinitions = (
    BaseChange => {
        ChangeTitle     => 'ASCII Change - Title - ' . $UniqueSignature,
        Description     => 'ASCII Change - Description - ' . $UniqueSignature,
        Justification   => 'ASCII Change - Justification - ' . $UniqueSignature,
        ChangeManagerID => 1,
        ChangeBuilderID => 1,
        CABAgents       => [
            1,
        ],
    },
    UnicodeChange => {
        ChangeTitle   => "Unicode Change - Title äöü - $UniqueSignature",
        Description   => 'Unicode Change - Description - ' . $UniqueSignature,
        Justification => "Unicode Change - Justification "
            . "\x{167}\x{b6}\x{20ac}\@\x{142}\x{142}\x{138}j\x{f0}\x{b5}\x{ab}\x{df}\x{bb} "
            . "- $UniqueSignature",
        ChangeManagerID => 1,
        ChangeBuilderID => 1,
        CABAgents       => [
            1,
        ],
    },
    ContainerChange => {
        ChangeTitle     => 'Container Change - Title - ' . $UniqueSignature,
        Description     => 'Container Change - Description - ' . $UniqueSignature,
        Justification   => 'Container Change - Justification - ' . $UniqueSignature,
        ChangeManagerID => 1,
        ChangeBuilderID => 1,
        CABAgents       => [
            1,
        ],
    },
);

# create change that should act as the base for the template test
my %CreatedChangeID;
$CreatedChangeID{BaseChange} = $Self->{ChangeObject}->ChangeAdd(
    %{ $ChangeDefinitions{BaseChange} },
    UserID => 1,
);

# create change for unicode tests
$CreatedChangeID{UnicodeChange} = $Self->{ChangeObject}->ChangeAdd(
    %{ $ChangeDefinitions{UnicodeChange} },
    UserID => 1,
);

# create change for the workorder, cab and condition templates
$CreatedChangeID{ContainerChange} = $Self->{ChangeObject}->ChangeAdd(
    %{ $ChangeDefinitions{ContainerChange} },
    UserID => 1,
);

for my $ChangeName ( keys %CreatedChangeID ) {
    my $ChangeID = $CreatedChangeID{$ChangeName};

    $Self->True(
        $ChangeID,
        "Test $TestCount: ChangeAdd() - $ChangeID created",
    );

    my $Change = $Self->{ChangeObject}->ChangeGet(
        ChangeID => $CreatedChangeID{$ChangeName},
        UserID   => 1,
    );

    # check change attributes
    for my $RequestedAttribute ( keys %{ $ChangeDefinitions{$ChangeName} } ) {

        # turn off all pretty print
        local $Data::Dumper::Indent = 0;
        local $Data::Dumper::Useqq  = 1;

        # dump the attribute from ChangeGet()
        my $ChangeAttribute = Data::Dumper::Dumper( $Change->{$RequestedAttribute} );

        # dump the reference attribute
        my $ReferenceAttribute
            = Data::Dumper::Dumper( $ChangeDefinitions{$ChangeName}->{$RequestedAttribute} );

        $Self->Is(
            $ChangeAttribute,
            $ReferenceAttribute,
            "Test $TestCount: |- $RequestedAttribute (ChangeID: $ChangeID)",
        );
    }

    $TestCount++;
}

# add workorders
my %WorkOrderDefinitions = (
    ASCIIWorkOrder => {
        ChangeID       => $CreatedChangeID{ContainerChange},
        WorkOrderTitle => 'Just an ASCII workorder title - ' . $UniqueSignature,
    },
    UmlautsWorkOrder => {
        ChangeID       => $CreatedChangeID{ContainerChange},
        WorkOrderTitle => 'Workorder title with german umlauts äöü- ' . $UniqueSignature,
    },
    UnicodeWorkOrder => {
        ChangeID       => $CreatedChangeID{ContainerChange},
        WorkOrderTitle => 'Workorder title with unicode chars \x{167}\x{b6}\x{20ac} - '
            . $UniqueSignature,
        }
);

my %CreatedWorkOrderID;
for my $WorkOrderName ( keys %WorkOrderDefinitions ) {

    # add workorder
    $CreatedWorkOrderID{$WorkOrderName} = $Self->{WorkOrderObject}->WorkOrderAdd(
        %{ $WorkOrderDefinitions{$WorkOrderName} },
        UserID => 1,
    );

    my $WorkOrderID = $CreatedWorkOrderID{$WorkOrderName};

    # get workorder
    my $WorkOrder = $Self->{WorkOrderObject}->WorkOrderGet(
        WorkOrderID => $WorkOrderID,
        UserID      => 1,
    );

    # check workorder attributes
    for my $RequestedAttribute ( keys %{ $WorkOrderDefinitions{$WorkOrderName} } ) {

        # turn off all pretty print
        local $Data::Dumper::Indent = 0;
        local $Data::Dumper::Useqq  = 1;

        # dump the attribute from ChangeGet()
        my $WorkOrderAttribute = Data::Dumper::Dumper( $WorkOrder->{$RequestedAttribute} );

        # dump the reference attribute
        my $ReferenceAttribute
            = Data::Dumper::Dumper( $WorkOrderDefinitions{$WorkOrderName}->{$RequestedAttribute} );

        $Self->Is(
            $WorkOrderAttribute,
            $ReferenceAttribute,
            "Test $TestCount: |- $RequestedAttribute (WorkOrderID: $WorkOrderID)",
        );

        $TestCount++;
    }
}

# add conditions

# ------------------------------- #
# create templates
# ------------------------------- #
my %TestedTemplateID;
my %TestedTemplateStrings;

my %TemplateDefinitions = (
    BaseChange => {
        Name     => 'Base Change Template - ' . $UniqueSignature,
        Type     => 'ITSMChange',
        ValidID  => $Self->{ValidObject}->ValidLookup( Valid => 'valid' ),
        ChangeID => $CreatedChangeID{BaseChange},
        UserID   => 1,
    },
    UnicodeChange => {
        Name     => 'Unicode Change Template - ' . $UniqueSignature,
        Type     => 'ITSMChange',
        ValidID  => $Self->{ValidObject}->ValidLookup( Valid => 'valid' ),
        ChangeID => $CreatedChangeID{UnicodeChange},
        UserID   => 1,
    },
    ASCIIWorkOrder => {
        Name        => 'Ascii WorkOrder Template - ' . $UniqueSignature,
        Type        => 'ITSMWorkOrder',
        ValidID     => $Self->{ValidObject}->ValidLookup( Valid => 'valid' ),
        WorkOrderID => $CreatedWorkOrderID{ASCIIWorkOrder},
        UserID      => 1,
    },
    UmlautsWorkOrder => {
        Name        => 'Umlauts WorkOrder Template - ' . $UniqueSignature,
        Type        => 'ITSMWorkOrder',
        ValidID     => $Self->{ValidObject}->ValidLookup( Valid => 'valid' ),
        WorkOrderID => $CreatedWorkOrderID{UmlautsWorkOrder},
        UserID      => 1,
    },
    UnicodeWorkOrder => {
        Name        => 'Unicode WorkOrder Template - ' . $UniqueSignature,
        Type        => 'ITSMWorkOrder',
        ValidID     => $Self->{ValidObject}->ValidLookup( Valid => 'valid' ),
        WorkOrderID => $CreatedWorkOrderID{UnicodeWorkOrder},
        UserID      => 1,
    },
);

for my $TemplateDefinitionName ( keys %TemplateDefinitions ) {

    # create simple change template
    $TemplateDefinitions{$TemplateDefinitionName}->{Content} =
        $Self->{TemplateObject}->TemplateSerialize(
        %{ $TemplateDefinitions{$TemplateDefinitionName} },
        TemplateType => $TemplateDefinitions{$TemplateDefinitionName}->{Type},
        );

    # check serialization
    $Self->True(
        $TemplateDefinitions{$TemplateDefinitionName}->{Content},
        "Test $TestCount: TemplateSerialize for $TemplateDefinitionName",
    );

    # add template
    $TestedTemplateID{$TemplateDefinitionName} = $Self->{TemplateObject}->TemplateAdd(
        %{ $TemplateDefinitions{$TemplateDefinitionName} },
        TemplateType => $TemplateDefinitions{$TemplateDefinitionName}->{Type},
    );

    my $TemplateID = $TestedTemplateID{$TemplateDefinitionName};

    # check template ID
    $Self->True(
        $TemplateID,
        "Test $TestCount: |- TemplateAdd for $TemplateDefinitionName",
    );

    # get created template
    my $Template = $Self->{TemplateObject}->TemplateGet(
        TemplateID => $TemplateID,
        UserID     => 1,
    );

    # check template attributes name, type and content
    for my $Attribute (qw(Name Type Content)) {
        $Self->Is(
            $Template->{$Attribute},
            $TemplateDefinitions{$TemplateDefinitionName}->{$Attribute},
            "Test $TestCount: |- $Attribute (TemplateID: $TemplateID)",
        );
    }

    $TestCount++;
}

# create objects based on templates
my @ChangeIDs;

CHANGETEMPLATENAME:
for my $ChangeTemplateName ( keys %CreatedChangeID ) {

    # get template id
    my $TemplateID = $TestedTemplateID{$ChangeTemplateName};

    next CHANGETEMPLATENAME if !$TemplateID;

    # deserialize template
    my $ChangeID = $Self->{TemplateObject}->TemplateDeSerialize(
        TemplateID => $TemplateID,
        UserID     => 1,
    );

    # check change id
    $Self->True(
        $ChangeID,
        "Test $TestCount: Create change based on template (TemplateID: $TemplateID)",
    );

    # get change data
    my $Change = $Self->{ChangeObject}->ChangeGet(
        ChangeID => $ChangeID,
        UserID   => 1,
    );

    # check change attributes
    for my $RequestedAttribute ( keys %{ $ChangeDefinitions{$ChangeTemplateName} } ) {

        # turn off all pretty print
        local $Data::Dumper::Indent = 0;
        local $Data::Dumper::Useqq  = 1;

        # dump the attribute from ChangeGet()
        my $ChangeAttribute = Data::Dumper::Dumper( $Change->{$RequestedAttribute} );

        # dump the reference attribute
        my $ReferenceAttribute
            = Data::Dumper::Dumper(
            $ChangeDefinitions{$ChangeTemplateName}->{$RequestedAttribute}
            );

        $Self->Is(
            $ChangeAttribute,
            $ReferenceAttribute,
            "Test $TestCount: |- $RequestedAttribute (ChangeID: $ChangeID)",
        );
    }

    push @ChangeIDs, $ChangeID;

    $TestCount++;
}

# ------------------------------------------------------------ #
# clean the system
# ------------------------------------------------------------ #

# delete the test templates
for my $TemplateName ( keys %TestedTemplateID ) {
    my $TemplateID = $TestedTemplateID{$TemplateName};

    my $DeleteOk = $Self->{TemplateObject}->TemplateDelete(
        TemplateID => $TemplateID,
        UserID     => 1,
    );
    $Self->True(
        $DeleteOk,
        "Test $TestCount: TemplateDelete()"
    );

    # double check if change is really deleted
    my $TemplateData = $Self->{TemplateObject}->TemplateGet(
        TemplateID => $TemplateID,
        UserID     => 1,
    );

    $Self->False(
        $TemplateData->{TemplateID},
        "Test $TestCount: TemplateDelete() - double check",
    );
}
continue {
    $TestCount++;
}

# delete the test changes
for my $ChangeID ( @ChangeIDs, values %CreatedChangeID ) {
    my $DeleteOk = $Self->{ChangeObject}->ChangeDelete(
        ChangeID => $ChangeID,
        UserID   => 1,
    );
    $Self->True(
        $DeleteOk,
        "Test $TestCount: ChangeDelete()"
    );

    # double check if change is really deleted
    my $ChangeData = $Self->{ChangeObject}->ChangeGet(
        ChangeID => $ChangeID,
        UserID   => 1,
    );

    $Self->False(
        $ChangeData->{ChangeID},
        "Test $TestCount: ChangeDelete() - double check",
    );
}
continue {
    $TestCount++;
}

1;
