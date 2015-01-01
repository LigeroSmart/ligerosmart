#!/usr/bin/perl
# --
# otrs.ImportExport.pl - import/export script
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU AFFERO General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301 USA
# or see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;

use File::Basename;
use FindBin qw($RealBin);
use lib dirname($RealBin);
use lib dirname($RealBin) . '/Kernel/cpan-lib';
use vars qw($RealBin);

use Getopt::Std;

use Kernel::System::ObjectManager;

local $Kernel::OM = Kernel::System::ObjectManager->new(
    'Kernel::System::Log' => {
        LogPrefix => 'OTRS-ImportExport',
    },
);

# get options
my %Opts;
getopts( 'hn:a:i:o:', \%Opts );

if ( $Opts{h} ) {

    print STDOUT "otrs.ImportExport.pl - an import/export tool\n";
    print STDOUT "Copyright (C) 2001-2015 OTRS AG, http://otrs.com/\n";
    print STDOUT "\n";
    print STDOUT "usage: otrs.ImportExport.pl -n <TemplateNumber> -a import|export ";
    print STDOUT "[-i <SourceFile>] [-o <DestinationFile>]\n";
    print STDOUT "\n";
    print STDOUT "   examples:\n";
    print STDOUT "       otrs.ImportExport.pl -n 00004 -a import -i /tmp/import.csv\n";
    print STDOUT "       otrs.ImportExport.pl -n 00004 -a export -o /tmp/export.csv\n";

    exit 1;
}

# check template number
if ( !$Opts{n} ) {
    print STDERR "ERROR: Need -n TemplateNumber\n";
    exit 1;
}
if ( $Opts{n} !~ m{ \A \d+ \z }xms ) {
    print STDERR "ERROR: Invalid TemplateNumber\n";
    exit 1;
}
my $TemplateID = int $Opts{n};

# check action mode
if ( !$Opts{a} ) {
    print STDERR "ERROR: Need -a import|export\n";
    exit 1;
}
if ( lc $Opts{a} ne 'import' && lc $Opts{a} ne 'export' ) {
    print STDERR "ERROR: Invalid action\n";
    exit 1;
}

# get template data
my $TemplateData = $Kernel::OM->Get('Kernel::System::ImportExport')->TemplateGet(
    TemplateID => $TemplateID,
    UserID     => 1,
);

if ( !$TemplateData->{TemplateID} ) {
    print STDERR "ERROR: Template $Opts{n} not found!\n";
    print STDERR "Export aborted.\n";
    exit 1;
}

# time to start
if ( lc $Opts{a} eq 'import' ) {

    my $SourceContent = \do {''};
    if ( $Opts{i} ) {

        print STDOUT "Read File $Opts{i}.\n";

        # read source file
        $SourceContent = $Kernel::OM->Get('Kernel::System::Main')->FileRead(
            Location => $Opts{i},
            Result   => 'SCALAR',
            Mode     => 'binmode',
        );

        die "Can't read file $Opts{i}.\nImport aborted.\n" if !$SourceContent;
    }

    print STDOUT "Import in process...\n";

    # import data
    my $Result = $Kernel::OM->Get('Kernel::System::ImportExport')->Import(
        TemplateID    => $TemplateID,
        SourceContent => $SourceContent,
        UserID        => 1,
    );

    die "\nError occurred. Import impossible! See the OTRS log for details.\n" if !defined $Result;

    # Print result
    print STDOUT "\n";
    print STDOUT
        "Import of $Result->{Counter} $Result->{Object} records: "
        . "$Result->{Failed} failed, $Result->{Success} succeeded\n";
    for my $RetCode ( sort keys %{ $Result->{RetCode} } ) {
        my $Count = $Result->{RetCode}->{$RetCode} || 0;
        print STDOUT
            "Import of $Result->{Counter} $Result->{Object} records: $Count $RetCode\n",
    }
    if ( $Result->{Failed} ) {
        print STDOUT
            "Last processed line number of import file: $Result->{Counter}\n";
    }
}
elsif ( lc $Opts{a} eq 'export' ) {

    print STDOUT "Export in process...\n";

    # export data
    my $Result = $Kernel::OM->Get('Kernel::System::ImportExport')->Export(
        TemplateID => $TemplateID,
        UserID     => 1,
    );

    die "\nError occurred. Export impossible! See Syslog for details.\n" if !defined $Result;

    print STDOUT
        "\n",
        "Success: $Result->{Success}\n",
        "Failed : $Result->{Failed}\n",
        "\n";

    if ( $Opts{o} ) {

        my $FileContent = join "\n", @{ $Result->{DestinationContent} };

        # save destination content to file
        my $Success = $Kernel::OM->Get('Kernel::System::Main')->FileWrite(
            Location => $Opts{o},
            Content  => \$FileContent,
        );

        die "Can't write file $Opts{o}.\nExport aborted.\n" if !$Success;

        print STDOUT "File $Opts{o} saved.\n";
    }

    print STDOUT "Export complete.\n";
}

exit 0;

=back

=head1 TERMS AND CONDITIONS

This Software is part of the OTRS project (http://otrs.org/).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
