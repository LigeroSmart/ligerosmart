# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package var::packagesetup::SystemMonitoring;
## no critic(Perl::Critic::Policy::OTRS::RequireCamelCase)

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::DynamicField',
    'Kernel::System::Main',
    'Kernel::System::Log',
    'Kernel::System::SysConfig',
    'Kernel::System::Valid',
);

=head1 NAME

var::packagesetup::SystemMonitoring - code to execute during package installation

=head1 SYNOPSIS

All functions

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create an object

    use Kernel::System::ObjectManager;
    local $Kernel::OM = Kernel::System::ObjectManager->new();
    my $CodeObject = $Kernel::OM->Get('var::packagesetup::SystemMonitoring');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # Force a reload of ZZZAuto.pm and ZZZAAuto.pm to get the fresh configuration values.
    for my $Module ( sort keys %INC ) {
        if ( $Module =~ m/ZZZAA?uto\.pm$/ ) {
            delete $INC{$Module};
        }
    }

    # always discard the config object before package code is executed,
    # to make sure that the config object will be created newly, so that it
    # will use the recently written new config from the package
    $Kernel::OM->ObjectsDiscard(
        Objects => ['Kernel::Config'],
    );

    # define file prefix
    $Self->{FilePrefix} = 'SystemMonitoring';

    return $Self;
}

=item CodeInstall()

run the code install part

    my $Result = $CodeObject->CodeInstall();

=cut

sub CodeInstall {
    my ( $Self, %Param ) = @_;

    $Self->_CreateDynamicFields();

    return 1;
}

=item CodeReinstall()

run the code reinstall part

    my $Result = $CodeObject->CodeReinstall();

=cut

sub CodeReinstall {
    my ( $Self, %Param ) = @_;

    return 1;
}

=item CodeUpgrade()

run the code upgrade part

    my $Result = $CodeObject->CodeUpgrade();

=cut

sub CodeUpgrade {
    my ( $Self, %Param ) = @_;

    return 1;
}

=item CodeUpgradePre()

run the code upgrade pre part

    my $Result = $CodeObject->CodeUpgradePre();

=cut

sub CodeUpgradePre {
    my ( $Self, %Param ) = @_;

    # check if config option exists
    my $Config = $Kernel::OM->Get('Kernel::Config')->Get('PostMaster::PreFilterModule');

    # update/rename config option
    if ( $Config && $Config->{'0001-SystemMonitoring'} ) {

        my $Success = $Kernel::OM->Get('Kernel::System::SysConfig')->SettingsSet(
            UserID   => 1,
            Comments => 'Deployment from CodeUpgradePre in var/packagesetup/SystemMonitoring.pm',
            Settings => [
                {
                    Name           => 'PostMaster::PreFilterModule###00-SystemMonitoring',
                    EffectiveValue => $Config->{'0001-SystemMonitoring'},
                    IsValid        => 1,
                },
            ],
        );
    }

    return 1;
}

=item CodeUpgradeFromLowerThan_2_2_92()

This function is only executed if the installed module version is smaller than 2.2.92.

my $Result = $CodeObject->CodeUpgradeFromLowerThan_2_2_92();

=cut

sub CodeUpgradeFromLowerThan_2_2_92 {
    my ( $Self, %Param ) = @_;

    # get the definition for all dynamic fields for SystemMonitoring
    my @DynamicFields = $Self->_GetDynamicFieldsDefinition();

    # get dynamic field object
    my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');

    # clean up the migrated freetext and freetime fields
    # e.g. delete the possible values for fields that use the general catalog
    DYNAMICFIELD:
    for my $DynamicFieldNew (@DynamicFields) {

        # get existing dynamic field data
        my $DynamicFieldOld =
            $DynamicFieldObject->DynamicFieldGet( Name => $DynamicFieldNew->{Name} );

        if ( !defined $DynamicFieldOld->{ID} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "The old Field does not exist $DynamicFieldNew->{Name}, skipping.",
            );
            next DYNAMICFIELD;
        }

        # update the dynamic field
        my $Success = $DynamicFieldObject->DynamicFieldUpdate(
            ID         => $DynamicFieldOld->{ID},
            FieldOrder => $DynamicFieldOld->{FieldOrder},
            Name       => $DynamicFieldNew->{Name},
            Label      => $DynamicFieldNew->{Label},
            FieldType  => $DynamicFieldNew->{FieldType},
            ObjectType => $DynamicFieldNew->{ObjectType},
            Config     => $DynamicFieldNew->{Config},
            ValidID    => 1,
            Reorder    => 0,
            UserID     => 1,
        );
    }

    return 1;
}

=item CodeUninstall()

run the code uninstall part

    my $Result = $CodeObject->CodeUninstall();

=cut

sub CodeUninstall {
    my ( $Self, %Param ) = @_;

    return 1;
}

=item _CreateDynamicFields()

creates all dynamic fields that are necessary for SystemMonitoring

    my $Result = $CodeObject->_CreateDynamicFields();

=cut

sub _CreateDynamicFields {
    my ( $Self, %Param ) = @_;

    my $ValidID = $Kernel::OM->Get('Kernel::System::Valid')->ValidLookup(
        Valid => 'valid',
    );

    # get dynamic field object
    my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');

    # get all current dynamic fields
    my $DynamicFieldList = $DynamicFieldObject->DynamicFieldListGet(
        Valid => 0,
    );

    # get the list of order numbers (is already sorted).
    my @DynamicfieldOrderList;
    for my $Dynamicfield ( @{$DynamicFieldList} ) {
        push @DynamicfieldOrderList, $Dynamicfield->{FieldOrder};
    }

    # get the last element from the order list and add 1
    my $NextOrderNumber = 1;
    if (@DynamicfieldOrderList) {
        $NextOrderNumber = $DynamicfieldOrderList[-1] + 1;
    }

    # get the definition for all dynamic fields for
    my @DynamicFields = $Self->_GetDynamicFieldsDefinition();

    # create dynamic fields
    DYNAMICFIELD:
    for my $DynamicField (@DynamicFields) {

        # create a new field
        my $OldDynamicField = $DynamicFieldObject->DynamicFieldGet(
            Name => $DynamicField->{Name},
        );

        if ( defined($OldDynamicField) ) {
            if ( exists( $OldDynamicField->{Label} ) ) {
                if (
                    ( $OldDynamicField->{Label} eq $DynamicField->{Label} )
                    )
                {
                    $Kernel::OM->Get('Kernel::System::Log')->Log(
                        Priority => 'info',
                        Message  => "Field already exists Label:$DynamicField->{Label}, skipping."
                    );
                    next DYNAMICFIELD;    # skip the record, it has been created already
                }

            }
        }

        my $FieldID = $DynamicFieldObject->DynamicFieldAdd(
            Name       => $DynamicField->{Name},
            Label      => $DynamicField->{Label},
            FieldOrder => $NextOrderNumber,
            FieldType  => $DynamicField->{FieldType},
            ObjectType => $DynamicField->{ObjectType},
            Config     => $DynamicField->{Config},
            ValidID    => $ValidID,
            UserID     => 1,
        );
        next DYNAMICFIELD if !$FieldID;

        # increase the order number
        $NextOrderNumber++;

    }

    return 1;
}

=item _GetDynamicFieldsDefinition()

returns the definition for System Monitoring related dynamic fields

    my $Result = $CodeObject->_GetDynamicFieldsDefinition();

=cut

sub _GetDynamicFieldsDefinition {
    my ( $Self, %Param ) = @_;

    my @AllNewFields = ();    # the fields that are filled out

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # get dynamic field object
    my $MainObject = $Kernel::OM->Get('Kernel::System::Main');

    # run all PreFilterModules (modify email params)
    for my $Key ('PostMaster::PreFilterModule') {
        if ( ref $ConfigObject->Get($Key) eq 'HASH' ) {
            my %Jobs = %{ $ConfigObject->Get($Key) };
            JOB:
            for my $Job ( sort keys %Jobs ) {
                return if !$MainObject->Require( $Jobs{$Job}->{Module} );

                if ( $Jobs{$Job}->{Module} ne 'Kernel::System::PostMaster::Filter::SystemMonitoring' ) {
                    next JOB;
                }

                my @NewFields;

                my $FilterObject = $Kernel::OM->Create(
                    $Jobs{$Job}->{Module},
                    ObjectParams => {
                        CommuncationLogRequired => 0,
                    },
                );

                if ( !$FilterObject ) {
                    $Kernel::OM->Get('Kernel::System::Log')->Log(
                        Priority => 'error',
                        Message  => "Can not create $Jobs{$Job}->{Module} object!",
                    );
                    next JOB;
                }

                my $Run = $FilterObject->GetDynamicFieldsDefinition(
                    Config    => $Jobs{$Job},    # the job config
                    NewFields => \@NewFields
                );
                if ( !$Run ) {
                    $Kernel::OM->Get('Kernel::System::Log')->Log(
                        Priority => 'error',
                        Message =>
                            "Execute GetDynamicFieldsDefinition() of $Key $Jobs{$Job}->{Module} not successful!",
                    );
                }
                else {
                    push @AllNewFields, (@NewFields);
                }
            }
        }
    }

    return @AllNewFields;
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<https://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
