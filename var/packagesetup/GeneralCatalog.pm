# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package var::packagesetup::GeneralCatalog;    ## no critic

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::DB',
    'Kernel::System::SysConfig',
);

=head1 NAME

GeneralCatalog.pm - code to execute during package installation

=head1 PUBLIC INTERFACE

=cut

=head2 new()

create an object

    use Kernel::System::ObjectManager;
    local $Kernel::OM = Kernel::System::ObjectManager->new();
    my $CodeObject = $Kernel::OM->Get('var::packagesetup::GeneralCatalog');

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

    # Create common objects with fresh default config.
    $Kernel::OM->ObjectsDiscard();

    return $Self;
}

=head2 CodeInstall()

run the code install part

    my $Result = $CodeObject->CodeInstall();

=cut

sub CodeInstall {
    my ( $Self, %Param ) = @_;

    return 1;
}

=head2 CodeReinstall()

run the code reinstall part

    my $Result = $CodeObject->CodeReinstall();

=cut

sub CodeReinstall {
    my ( $Self, %Param ) = @_;

    return 1;
}

=head2 CodeUpgrade()

run the code upgrade part

    my $Result = $CodeObject->CodeUpgrade();

=cut

sub CodeUpgrade {
    my ( $Self, %Param ) = @_;

    # migrate 'functionality' to external table
    # this is only neccesary in CodeUpgrade, for new installations this is done
    # in the package ITSMCore during CodeInstall
    $Self->_MigrateFunctionality();

    return 1;
}

=head2 CodeUpgradeFromLowerThan_4_0_91()

This function is only executed if the installed module version is smaller than 4.0.91.

my $Result = $CodeObject->CodeUpgradeFromLowerThan_4_0_91();

=cut

sub CodeUpgradeFromLowerThan_4_0_91 {    ## no critic
    my ( $Self, %Param ) = @_;

    # change configurations to match the new module location.
    $Self->_MigrateConfigs();

    return 1;
}

=head2 CodeUninstall()

run the code uninstall part

    my $Result = $CodeObject->CodeUninstall();

=cut

sub CodeUninstall {
    my ( $Self, %Param ) = @_;

    return 1;
}

=head2 _MigrateFunctionality()

=cut

sub _MigrateFunctionality {
    my ( $Self, %Param ) = @_;

    # SELECT all functionality values
    $Kernel::OM->Get('Kernel::System::DB')->Prepare(
        SQL => 'SELECT id, functionality FROM general_catalog',
    );

    my @List;
    ROW:
    while ( my @Row = $Kernel::OM->Get('Kernel::System::DB')->FetchrowArray() ) {
        next ROW if !$Row[1];

        push @List, \@Row;
    }

    # save entries in new table
    for my $Entry (@List) {
        $Kernel::OM->Get('Kernel::System::DB')->Do(
            SQL =>
                'INSERT INTO general_catalog_preferences( general_catalog_id, pref_key, pref_value )'
                . ' VALUES( ?, \'Functionality\', ? )',
            Bind => [ \$Entry->[0], \$Entry->[1] ],
        );
    }

    # drop column functionality
    my ($Drop) = $Kernel::OM->Get('Kernel::System::DB')->SQLProcessor(
        Database => [
            {
                Tag     => 'TableAlter',
                Name    => 'general_catalog',
                TagType => 'Start',
            },
            {
                Tag     => 'ColumnDrop',
                Name    => 'functionality',
                TagType => 'Start',
            },
            {
                Tag     => 'TableAlter',
                TagType => 'End',
            },
        ],
    );

    $Kernel::OM->Get('Kernel::System::DB')->Do(
        SQL => $Drop,
    );

    return 1;
}

=head2 _MigrateConfigs()

change configurations to match the new module location.

    my $Result = $CodeObject->_MigrateConfigs();

=cut

sub _MigrateConfigs {

    # create needed objects
    my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');
    my $ConfigObject    = $Kernel::OM->Get('Kernel::Config');

    # migrate GeneralCatalog Preferences
    # get setting content for GeneralCatalog Preferences
    my $Setting = $ConfigObject->Get('GeneralCatalogPreferences');

    CONFIGITEM:
    for my $MenuModule ( sort keys %{$Setting} ) {

        # update module location
        my $Module = $Setting->{$MenuModule}->{'Module'};
        if ( $Module !~ m{Kernel::Output::HTML::GeneralCatalogPreferences(\w+)} ) {
            next CONFIGITEM;
        }

        my %GeneralCatalogPreferencesSetting = $SysConfigObject->SettingGet(
            Name    => 'GeneralCatalogPreferences###' . $MenuModule,
            Default => 1,
        );

        my $ExclusiveLockGUID = $SysConfigObject->SettingLock(
            UserID    => 1,
            Force     => 1,
            DefaultID => $GeneralCatalogPreferencesSetting{DefaultID},
        );

        $Setting->{$MenuModule}->{Module} = "Kernel::Output::HTML::GeneralCatalogPreferences::Generic";

        # set new setting
        $SysConfigObject->SettingUpdate(
            Name              => 'GeneralCatalogPreferences###' . $MenuModule,
            EffectiveValue    => $Setting->{$MenuModule},
            ExclusiveLockGUID => $ExclusiveLockGUID,
            UserID            => 1,
        );

        $SysConfigObject->SettingUnlock(
            UserID    => 1,
            DefaultID => $GeneralCatalogPreferencesSetting{DefaultID},
        );

    }

    return 1;
}

1;

=head1 TERMS AND CONDITIONS

This Software is part of the OTRS project (http://otrs.org/).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
