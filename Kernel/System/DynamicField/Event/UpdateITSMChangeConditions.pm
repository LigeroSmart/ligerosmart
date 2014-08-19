# --
# Kernel/System/DynamicField/Event/UpdateITSMChangeConditions.pm - event handler module for dynamic fields
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::DynamicField::Event::UpdateITSMChangeConditions;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::System::Cache',
    'Kernel::System::Log',
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(Data Event Config)) {
        if ( !$Param{$Argument} ) {

            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );

            return;
        }
    }

    # TODO: Implement event handler (like described below)

    # return if DynamicField ObjectType is not ITSMChange or ITSMWorkOrder

    # handle DynamicFieldAdd:
    #  - add new attribute to condition attribute table

    # handle DynamicFieldUpdate:
    #  - search for old name in attribute table and update the name

    # handle DynamicFieldDelete:
    #  - first, delete all expressions and actions where this attribute is used
    #  - second, delete this attribute from attribute table

    return 1;
}

1;
