# --
# GeneralCatalog.pm - code to excecute during package installation
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package var::packagesetup::GeneralCatalog;    ## no critic

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::System::DB',
);

=head1 NAME

GeneralCatalog.pm - code to excecute during package installation

=head1 SYNOPSIS

All functions

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

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

    # get objects from object manager
    $Self->{DBObject} = $Kernel::OM->Get('Kernel::System::DB');

    return $Self;
}

=item CodeInstall()

run the code install part

    my $Result = $CodeObject->CodeInstall();

=cut

sub CodeInstall {
    my ( $Self, %Param ) = @_;

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

    # migrate 'functionality' to external table
    # this is only neccesary in CodeUpgrade, for new installations this is done
    # in the package ITSMCore during CodeInstall
    $Self->_MigrateFunctionality();

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

=item _MigrateFunctionality()

=cut

sub _MigrateFunctionality {
    my ( $Self, %Param ) = @_;

    # SELECT all functionality values
    $Self->{DBObject}->Prepare(
        SQL => 'SELECT id, functionality FROM general_catalog',
    );

    my @List;
    ROW:
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        next ROW if !$Row[1];

        push @List, \@Row;
    }

    # save entries in new table
    for my $Entry (@List) {
        $Self->{DBObject}->Do(
            SQL =>
                'INSERT INTO general_catalog_preferences( general_catalog_id, pref_key, pref_value )'
                . ' VALUES( ?, \'Functionality\', ? )',
            Bind => [ \$Entry->[0], \$Entry->[1] ],
        );
    }

    # drop column functionality
    my ($Drop) = $Self->{DBObject}->SQLProcessor(
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

    $Self->{DBObject}->Do(
        SQL => $Drop,
    );

    return 1;
}

1;

=back

=head1 TERMS AND CONDITIONS

This Software is part of the OTRS project (http://otrs.org/).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see http://www.gnu.org/licenses/agpl.txt.

=cut
