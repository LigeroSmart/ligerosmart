# --
# Copyright (C) 2001-2018 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));

use Kernel::System::VariableCheck qw(:all);

# get needed objects
my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');
my $ParamObject        = $Kernel::OM->Get('Kernel::System::Web::Request');

$Kernel::OM->ObjectParamAdd(
    'Kernel::Output::HTML::Layout' => {
        UserID => 1,
    },
);
my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $HelperObject = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# ------------------------------------------------------------ #
# make preparations
# ------------------------------------------------------------ #

# get master/slave dynamic field data
my $MasterSlaveDynamicField     = $ConfigObject->Get('MasterSlave::DynamicField');
my $MasterSlaveDynamicFieldData = $DynamicFieldObject->DynamicFieldGet(
    Name => $MasterSlaveDynamicField,
);

my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

# find all current open master slave tickets
my @TicketIDs = $TicketObject->TicketSearch(
    Result => 'ARRAY',

    # master slave dynamic field
    'DynamicField_' . $MasterSlaveDynamicField => {
        Equals => 'Master',
    },

    StateType  => 'Open',
    UserID     => 1,
    Permission => 'ro',
);

# set tickets to removed so they are not fond later in the test cases
#    the tickets will be restored automatically at the end of the test
#    due to the RestoreDatabase option in helper object
for my $TicketID (@TicketIDs) {
    my $Success = $TicketObject->TicketStateSet(
        State    => 'removed',
        TicketID => $TicketID,
        UserID   => 1,
    );
    $Self->True(
        $Success,
        "Temporary set Master Ticket: $TicketID to removed",
    );
}

# define tests
my @Tests = (
    {
        Name   => 'MasterSlave - Possible Values Filter',
        Config => {
            DynamicFieldConfig   => $MasterSlaveDynamicFieldData,
            PossibleValuesFilter => {
                Master => 'New Master Ticket',
            },
            LayoutObject => $LayoutObject,
            ParamObject  => $ParamObject,
        },
        ExpectedResults => {
            Field =>
                '<select class="DynamicFieldText Modernize" id="DynamicField_MasterSlave" name="DynamicField_MasterSlave" size="1">
  <option value="Master">New Master Ticket</option>
</select>
',
            Label => '<label id="LabelDynamicField_MasterSlave" for="DynamicField_MasterSlave">
Master Ticket:
</label>
'
        },
    },
    {
        Name   => 'UnsetMasterSlave - Possible Values Filter',
        Config => {
            DynamicFieldConfig   => $MasterSlaveDynamicFieldData,
            PossibleValuesFilter => {
                Master      => 'New Master Ticket',
                UnsetMaster => 'Unset Master Tickets',
                UnsetSlave  => 'Unset Slave Tickets',
            },
            LayoutObject => $LayoutObject,
            ParamObject  => $ParamObject,
        },
        ExpectedResults => {
            Field =>
                '<select class="DynamicFieldText Modernize" id="DynamicField_MasterSlave" name="DynamicField_MasterSlave" size="1">
  <option value="Master">New Master Ticket</option>
  <option value="UnsetMaster">Unset Master Tickets</option>
  <option value="UnsetSlave">Unset Slave Tickets</option>
</select>
',
            Label => '<label id="LabelDynamicField_MasterSlave" for="DynamicField_MasterSlave">
Master Ticket:
</label>
'
        },
    },
    {
        Name   => 'MasterSlave: No value ',
        Config => {
            DynamicFieldConfig => $MasterSlaveDynamicFieldData,
            LayoutObject       => $LayoutObject,
            ParamObject        => $ParamObject,
            Class              => 'MyClass',
            UseDefaultValue    => 0,
        },
        ExpectedResults => {
            Field => <<"EOF" . '</select>',
<select class="DynamicFieldText Modernize MyClass" id="DynamicField_MasterSlave" name="DynamicField_MasterSlave" size="1">
  <option value="">-</option>
  <option value="Master">New Master Ticket</option>
EOF
            Label => '<label id="LabelDynamicField_MasterSlave" for="DynamicField_MasterSlave">
Master Ticket:
</label>
'
        },
    },
    {
        Name   => 'MasterSlave: No value / Default',
        Config => {
            DynamicFieldConfig => $MasterSlaveDynamicFieldData,
            LayoutObject       => $LayoutObject,
            ParamObject        => $ParamObject,
            Class              => 'MyClass',
        },
        ExpectedResults => {
            Field => <<"EOF" . '</select>',
<select class="DynamicFieldText Modernize MyClass" id="DynamicField_MasterSlave" name="DynamicField_MasterSlave" size="1">
  <option value="" selected="selected">-</option>
  <option value="Master">New Master Ticket</option>
EOF
            Label => '<label id="LabelDynamicField_MasterSlave" for="DynamicField_MasterSlave">
Master Ticket:
</label>
'
        },
    },
    {
        Name   => 'MasterSlave: Value direct',
        Config => {
            DynamicFieldConfig => $MasterSlaveDynamicFieldData,
            LayoutObject       => $LayoutObject,
            ParamObject        => $ParamObject,
            Value              => 'Master',
            Class              => 'MyClass',
            UseDefaultValue    => 0,
        },
        ExpectedResults => {
            Field => <<"EOF" . '</select>',
<select class="DynamicFieldText Modernize MyClass" id="DynamicField_MasterSlave" name="DynamicField_MasterSlave" size="1">
  <option value="">-</option>
  <option value="Master" selected="selected">New Master Ticket</option>
EOF
            Label => '<label id="LabelDynamicField_MasterSlave" for="DynamicField_MasterSlave">
Master Ticket:
</label>
'
        },
    },
    {
        Name   => 'MasterSlave: Mandatory',
        Config => {
            DynamicFieldConfig => $MasterSlaveDynamicFieldData,
            LayoutObject       => $LayoutObject,
            ParamObject        => $ParamObject,
            Value              => 'Master',
            Class              => 'MyClass',
            UseDefaultValue    => 0,
            Mandatory          => 1,
        },
        ExpectedResults => {
            Field =>
                '<select class="DynamicFieldText Modernize MyClass Validate_Required" id="DynamicField_MasterSlave" name="DynamicField_MasterSlave" size="1">
  <option value="">-</option>
  <option value="Master" selected="selected">New Master Ticket</option>
</select>
<div id="DynamicField_MasterSlaveError" class="TooltipErrorMessage">
    <p>
        This field is required.
    </p>
</div>
',
            Label => '<label id="LabelDynamicField_MasterSlave" for="DynamicField_MasterSlave" class="Mandatory">
    <span class="Marker">*</span>
Master Ticket:
</label>
'
        },
    },
    {
        Name   => 'MasterSlave: Server Error',
        Config => {
            DynamicFieldConfig => $MasterSlaveDynamicFieldData,
            LayoutObject       => $LayoutObject,
            ParamObject        => $ParamObject,
            Value              => 'Master',
            Class              => 'MyClass',
            UseDefaultValue    => 0,
            ServerError        => 1,
            ErrorMessage       => 'This is an error.'
        },
        ExpectedResults => {
            Field =>
                '<select class="DynamicFieldText Modernize MyClass ServerError" id="DynamicField_MasterSlave" name="DynamicField_MasterSlave" size="1">
  <option value="">-</option>
  <option value="Master" selected="selected">New Master Ticket</option>
</select>
<div id="DynamicField_MasterSlaveServerError" class="TooltipErrorMessage">
    <p>
        This is an error.
    </p>
</div>
',
            Label => '<label id="LabelDynamicField_MasterSlave" for="DynamicField_MasterSlave">
Master Ticket:
</label>
'
        },
    },
);

# ------------------------------------------------------------ #
# execute tests
# ------------------------------------------------------------ #
my $DynamicFieldBackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

for my $Test (@Tests) {

    my $FieldHTML = $DynamicFieldBackendObject->EditFieldRender( %{ $Test->{Config} } );

    # heredocs always have the newline, even if it is not expected
    if ( $FieldHTML->{Field} !~ m{\n$} ) {
        chomp $Test->{ExpectedResults}->{Field};
    }

    $Self->IsDeeply(
        $FieldHTML,
        $Test->{ExpectedResults},
        "$Test->{Name} | EditFieldRender()",
    );
}

# Cleanup is done by RestoreDatabase.

1;
