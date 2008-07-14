# --
# ITSMServiceLevelManagement.pm - code to excecute during package installation
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: ITSMServiceLevelManagement.pm,v 1.4 2008-07-14 15:28:30 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package var::packagesetup::ITSMServiceLevelManagement;

use strict;
use warnings;

use Kernel::System::Config;
use Kernel::System::CSV;
use Kernel::System::Group;
use Kernel::System::Stats;
use Kernel::System::Time;
use Kernel::System::User;

use vars qw(@ISA $VERSION);
$VERSION = qw($Revision: 1.4 $) [1];

=head1 NAME

ITSMServiceLevelManagement.pm - code to excecute during package installation

=head1 SYNOPSIS

All functions

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create an object

    use Kernel::Config;
    use Kernel::System::Log;
    use Kernel::System::Main;
    use Kernel::System::DB;

    my $ConfigObject = Kernel::Config->new();
    my $LogObject    = Kernel::System::Log->new(
        ConfigObject => $ConfigObject,
    );
    my $MainObject = Kernel::System::Main->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
    );
    my $CodeObject = ITSMServiceLevelManagement->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
        MainObject   => $MainObject,
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for my $Object (qw(ConfigObject LogObject MainObject TimeObject DBObject XMLObject)) {
        $Self->{$Object} = $Param{$Object} || die "Got no $Object!";
    }

    # add user id
    $Self->{UserID} = 1;

    # create needed objects
    $Self->{CSVObject}       = Kernel::System::CSV->new( %{$Self} );
    $Self->{GroupObject}     = Kernel::System::Group->new( %{$Self} );
    $Self->{TimeObject}      = Kernel::System::Time->new( %{$Self} );
    $Self->{UserObject}      = Kernel::System::User->new( %{$Self} );
    $Self->{StatsObject}     = Kernel::System::Stats->new( %{$Self} );
    $Self->{SysConfigObject} = Kernel::System::Config->new( %{$Self} );

    # add module name
    $Self->{ModuleName} = 'ITSMStats';

    return $Self;
}

=item CodeInstall()

run the code install part

    my $Result = $CodeObject->CodeInstall();

=cut

sub CodeInstall {
    my ( $Self, %Param ) = @_;

    # install stats
    $Self->_StatsInstall();

    return 1;
}

=item CodeReinstall()

run the code reinstall part

    my $Result = $CodeObject->CodeReinstall();

=cut

sub CodeReinstall {
    my ( $Self, %Param ) = @_;

    # install stats
    $Self->_StatsInstall();

    return 1;
}

=item CodeUpgrade()

run the code upgrade part

    my $Result = $CodeObject->CodeUpgrade();

=cut

sub CodeUpgrade {
    my ( $Self, %Param ) = @_;

    # install stats
    $Self->_StatsInstall();

    return 1;
}

=item CodeUninstall()

run the code uninstall part

    my $Result = $CodeObject->CodeUninstall();

=cut

sub CodeUninstall {
    my ( $Self, %Param ) = @_;

    # uninstall stats
    $Self->_StatsUninstall();

    return 1;
}

=item _StatsInstall()

installs stats

    my $Result = $CodeObject->_StatsInstall();

=cut

sub _StatsInstall {
    my ( $Self, %Param ) = @_;

    # start AutomaticSampleImport if no stats are installed
    $Self->{StatsObject}->GetStatsList();

    # rebuild ZZZ* files
    return if !$Self->{SysConfigObject}->WriteDefault();

    # read temporary directory
    my $StatsTempDir = $Self->{ConfigObject}->Get('Home') . '/var/stats/';

    # get list of stats files
    my @StatsFileList = glob $StatsTempDir . $Self->{ModuleName} . '-*.xml';

    # import the stats
    my $InstalledPostfix = '.installed';
    FILE:
    for my $File ( sort @StatsFileList ) {

        next FILE if !-f $File;
        next FILE if -e $File . $InstalledPostfix;

        # read file content
        my $XMLContentRef = $Self->{MainObject}->FileRead(
            Location => $File,
        );

        # import stat
        my $StatID = $Self->{StatsObject}->Import(
            Content => ${$XMLContentRef},
        );

        next FILE if !$StatID;

        # write installed file with stat id
        $Self->{MainObject}->FileWrite(
            Content  => \$StatID,
            Location => $File . $InstalledPostfix,
        );
    }

    return 1;
}

=item _StatsUninstall()

uninstalls stats

    my $Result = $CodeObject->_StatsUninstall();

=cut

sub _StatsUninstall {
    my ( $Self, %Param ) = @_;

    # read temporary directory
    my $StatsTempDir = $Self->{ConfigObject}->Get('Home') . '/var/stats/';

    # get list of installed stats files
    my @StatsFileList = glob $StatsTempDir . $Self->{ModuleName} . '-*.xml.installed';

    # delete the stats
    for my $File (@StatsFileList) {

        # read file content
        my $StatIDRef = $Self->{MainObject}->FileRead(
            Location => $File,
        );

        # delete stat
        $Self->{StatsObject}->StatsDelete(
            StatID => ${$StatIDRef},
        );

        # delete installed file
        $Self->{MainObject}->FileDelete(
            Location => $File,
        );
    }

    return 1;
}

1;

=back

=head1 TERMS AND CONDITIONS

This Software is part of the OTRS project (http://otrs.org/).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.

=cut

=head1 VERSION

$Revision: 1.4 $ $Date: 2008-07-14 15:28:30 $

=cut
