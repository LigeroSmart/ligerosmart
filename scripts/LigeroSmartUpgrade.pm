# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2021 LigeroSmart, https://ligerosmart.com
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package scripts::LigeroSmartUpgrade;    ## no critic

use strict;
use warnings;
use utf8;
use File::Find;
use Data::Dumper;
use Time::HiRes ();
use Kernel::System::VariableCheck qw(IsHashRefWithData);

our @ObjectDependencies = (
    'Kernel::System::Cache',
    'Kernel::System::Main',
    'Kernel::System::SysConfig',
);

=head1 NAME

scripts::LigeroSmartUpgrade - Perform system upgrade

=head1 PUBLIC INTERFACE

=head2 new()

Don't use the constructor directly, use the ObjectManager instead:

    my $LigeroSmartUpgradeObject = $Kernel::OM->Get('scripts::LigeroSmartUpgrade');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    $Self->{ProductInfo} = $Self->_GetCurrentVersion();

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # Enable auto-flushing of STDOUT.
    $| = 1;    ## no critic

    # Enable timing feature in case it is call.
    my $TimingEnabled = $Param{CommandlineOptions}->{Timing} || 0;

    my $GeneralStartTime;
    if ($TimingEnabled) {
        $GeneralStartTime = Time::HiRes::time();
    }

    print "\nLigeroSmart Upgrade started ... \n";

    my $SuccessfulMigration = 1;

    $SuccessfulMigration = $Self->_Upgrade(
            %Param,
    );

    if ($SuccessfulMigration) {
        print "\n\n\n Migration completed! \n\n";
    }
    else {
        print "\n\n\n Not possible to complete migration, check previous messages for more information. \n\n";
    }

    if ($TimingEnabled) {
        my $GeneralStopTime      = Time::HiRes::time();
        my $GeneralExecutionTime = sprintf( "%.6f", $GeneralStopTime - $GeneralStartTime );
        print "    Migration took $GeneralExecutionTime seconds.\n\n";
    }

    return $SuccessfulMigration;
}

sub _Upgrade {
    my ( $Self, %Param ) = @_;

    # Enable timing feature in case it is call.
    my $TimingEnabled = $Param{CommandlineOptions}->{Timing} || 0;

    # Get migration tasks.
    my @Tasks = $Self->_TasksGet();

    # Get the number of total steps.
    my $Steps               = scalar @Tasks;
    my $CurrentStep         = 1;
    my $SuccessfulMigration = 1;

    # Show initial message for current component
    print "\n Executing tasks ... \n\n";

    TASK:
    for my $Task (@Tasks) {

        next TASK if !$Task;
        next TASK if !$Task->{Module};

        my $ModuleName = "scripts::LigeroSmartUpgrade::$Task->{Module}";
        if ( !$Kernel::OM->Get('Kernel::System::Main')->Require($ModuleName) ) {
            $SuccessfulMigration = 0;
            last TASK;
        }

        my $TaskStartTime;
        if ($TimingEnabled) {
            $TaskStartTime = Time::HiRes::time();
        }

        # Run module.
        $Kernel::OM->ObjectParamAdd(
            "scripts::LigeroSmartUpgrade::$Task->{Module}" => {
                Opts => $Self->{Opts},
            },
        );

        $Self->{TaskObjects}->{$ModuleName} //= $Kernel::OM->Create($ModuleName);
        if ( !$Self->{TaskObjects}->{$ModuleName} ) {
            print "\n    Error: Could not create object for: $ModuleName.\n\n";
            $SuccessfulMigration = 0;
            last TASK;
        }

        my $Success = 1;


        print "    Step $CurrentStep of $Steps: $Task->{Message} ...\n";
        $Success = $Self->{TaskObjects}->{$ModuleName}->Run(%Param);


        if ($TimingEnabled) {
            my $StopTaskTime      = Time::HiRes::time();
            my $ExecutionTaskTime = sprintf( "%.6f", $StopTaskTime - $TaskStartTime );
            print "        Time taken for task \"$Task->{Message}\": $ExecutionTaskTime seconds\n\n";
        }

        if ( !$Success ) {
            $SuccessfulMigration = 0;
            last TASK;
        }

        $CurrentStep++;
    }

    return $SuccessfulMigration;
}

sub _TasksGet {
    my ( $Self, %Param ) = @_;

    my $Home    = $Kernel::OM->Get('Kernel::Config')->Get('Home');

    my @TaskFiles;
    # Use $File::Find::name instead of $_ to get the paths.

    my @TaskModules = $Kernel::OM->Get('Kernel::System::Main')->DirectoryRead(
        Directory => "$Home/scripts/LigeroSmartUpgrade",
        Recursive => 1,
        Filter    => '*.pm',
    );

    my @Tasks;

    TASKMODULE:
    for my $TaskModule (@TaskModules){

        next TASKMODULE if $TaskModule =~ /Base\.pm/;

        $TaskModule =~ s/^.*\/(.+?)\/(.+?)\.pm$/$1::$2/;

        push @Tasks, {
            Message => "",
            Module  => $TaskModule
        }
    }


    return @Tasks;
}

sub _GetCurrentVersion {
    my ( $Self, %Param ) = @_;

    my %ProductInfo;

    my $Verbose = $Param{CommandlineOptions}->{Verbose} || 0;
    my $Home    = $Kernel::OM->Get('Kernel::Config')->Get('Home');

    # load RELEASE file
    if ( !-e "$Home/RELEASE" ) {
        print "\n    Error: $Home/RELEASE does not exist!\n";
        return;
    }

    my $ProductName;
    my $Version;
    if ( open( my $Product, '<', "$Home/RELEASE" ) ) {    ## no critic
        while (<$Product>) {

            # filtering of comment lines
            if ( $_ !~ /^#/ ) {
                if ( $_ =~ /^PRODUCT\s{0,2}=\s{0,2}(.*)\s{0,2}$/i ) {
                    $ProductName = $1;
                }
                elsif ( $_ =~ /^VERSION\s{0,2}=\s{0,2}(.*)\s{0,2}$/i ) {
                    $Version = $1;
                }
            }
        }
        close($Product);
    }
    else {
        print "\n    Error: Can't read $Home/RELEASE: $!\n";
        return;
    }

    $ProductInfo{ProductName} = $ProductName;
    $ProductInfo{Version}     = $Version;

    my @VersionArray = split /\./, $Version;

    $ProductInfo{VersionPath} = sprintf("%02d_%02d_%02d",@VersionArray);

    return \%ProductInfo;
}


1;

=head1 TERMS AND CONDITIONS

This software is part of the LigeroSmart project (L<https://ligerosmart.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
