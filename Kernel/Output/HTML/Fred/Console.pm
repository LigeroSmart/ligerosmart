# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Output::HTML::Fred::Console;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::Output::HTML::Layout',
    'Kernel::System::Log',
);

use Cwd;

=head1 NAME

Kernel::Output::HTML::Fred::Console - layout backend module

=head1 SYNOPSIS

All layout functions of console object

=over 4

=cut

=item new()

create an object

    $BackendObject = Kernel::Output::HTML::FredConsole->new(
        %Param,
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

=item CreateFredOutput()

create the output of the STDERR log

    $LayoutObject->CreateFredOutput(
        ModulesRef => $ModulesRef,
    );

=cut

sub CreateFredOutput {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{ModuleRef} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need ModuleRef!',
        );
        return;
    }

    # create the console table
    my $Console = 'Activated modules: <strong>'
        . ( join ' - ', @{ $Param{ModuleRef}->{Data} } )
        . '</strong>';

    return 1 if !$Param{ModuleRef}->{Status};

    if ( $Param{ModuleRef}->{Setting} ) {
        $Kernel::OM->Get('Kernel::Output::HTML::Layout')->Block(
            Name => 'Setting',
        );
    }

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    my $SystemName = $ConfigObject->Get('Fred::SystemName')
        || $ConfigObject->Get('Home');
    my $OTRSVersion     = $ConfigObject->Get('Version') || 'Version unknown';
    my $BackgroundColor = $ConfigObject->Get('Fred::BackgroundColor')
        || 'red';
    my $BranchName = 'could not be detected';

    # Add current git branch to output
    my $Home = $ConfigObject->Get('Home');
    if ( -d "$Home/.git" ) {
        my $OldWorkingDir = getcwd();
        chdir($Home);
        my $GitResult = `git branch`;
        chdir($OldWorkingDir);

        if ($GitResult) {
            ($BranchName) = $GitResult =~ m/^[*] \s+ (\S+)/xms;
        }
    }

    my $BranchClass;
    my $BugNumber;

    if ( $BranchName eq 'master' ) {
        $BranchClass = 'Warning';
    }
    elsif ( $BranchName =~ m{bug-((\d){1,6}).*} ) {
        $BugNumber = $1;
    }

    $Param{ModuleRef}->{Output} = $Kernel::OM->Get('Kernel::Output::HTML::Layout')->Output(
        TemplateFile => 'DevelFredConsole',
        Data         => {
            Text            => $Console,
            ModPerl         => _ModPerl(),
            Perl            => sprintf( "%vd", $^V ),
            SystemName      => $SystemName,
            OTRSVersion     => $OTRSVersion,
            BranchName      => $BranchName,
            BranchClass     => $BranchClass,
            BackgroundColor => $BackgroundColor,
            BugNumber       => $BugNumber,
        },
    );

    return 1;
}

sub _ModPerl {

    # find out, if modperl is used
    my $ModPerl = 'not active';

    ## no critic
    if ( exists $ENV{MOD_PERL} && defined $mod_perl::VERSION ) {
        $ModPerl = $mod_perl::VERSION;
    }
    ## use critic

    return $ModPerl;
}

1;

=back
