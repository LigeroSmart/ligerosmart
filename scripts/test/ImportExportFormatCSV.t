# --
# ImportExportFormatCSV.t - all import export tests for the CSV format backend
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: ImportExportFormatCSV.t,v 1.1 2008-03-27 15:10:13 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

use strict;
use warnings;
use utf8;

use vars qw($Self);

use Data::Dumper;
use Kernel::System::ImportExport;

$Self->{ImportExportObject} = Kernel::System::ImportExport->new( %{$Self} );

# ------------------------------------------------------------ #
# make preparations
# ------------------------------------------------------------ #

# add a test template for later checks
my $TemplateID = $Self->{ImportExportObject}->TemplateAdd(
    Object  => 'UnitTest' . int rand 1_000_000,
    Format  => 'CSV',
    Name    => 'UnitTest' . int rand 1_000_000,
    ValidID => 1,
    UserID  => 1,
);

my $TestCount = 1;

# ------------------------------------------------------------ #
# FormatList test 1 (check CSV item)
# ------------------------------------------------------------ #

# get format list
my $FormatList1 = $Self->{ImportExportObject}->FormatList();

# check format list
$Self->True(
    $FormatList1 && ref $FormatList1 eq 'HASH' && $FormatList1->{CSV},
    "Test $TestCount: FormatList() - CSV exists",
);

$TestCount++;

# ------------------------------------------------------------ #
# FormatAttributesGet test 1 (check attribute hash)
# ------------------------------------------------------------ #

# get format attributes
my $FormatAttributesGet1 = $Self->{ImportExportObject}->FormatAttributesGet(
    TemplateID => $TemplateID,
    UserID     => 1,
);

# check format attribute reference
$Self->True(
    $FormatAttributesGet1 && ref $FormatAttributesGet1 eq 'ARRAY',
    "Test $TestCount: FormatAttributesGet() - check array reference",
);

# define the reference hash
my $FormatAttributesGet1Reference = [
    {
        Key   => 'ColumnSeperator',
        Name  => 'Column Seperator',
        Input => {
            Type => 'Selection',
            Data => {
                Tabulator => 'Tabulator (TAB)',
                Semicolon => 'Semicolon (;)',
                Colon     => 'Colon (:)',
                Dot       => 'Dot (.)',
            },
            Required     => 1,
            Translation  => 1,
            PossibleNone => 1,
        },
    },
];

# turn off all pretty print
$Data::Dumper::Indent = 0;

# dump the list from FormatAttributesGet()
my $FormatAttributesGetDump1 = Data::Dumper::Dumper($FormatAttributesGet1);

# dump the reference table
my $FormatAttributesRefDump1 = Data::Dumper::Dumper($FormatAttributesGet1Reference);

$Self->True(
    $FormatAttributesGetDump1 eq $FormatAttributesRefDump1,
    "Test $TestCount: FormatAttributesGet() - attributes of the row are identical",
);

$TestCount++;

# ------------------------------------------------------------ #
# FormatAttributesGet test 2 (check with non existing template)
# ------------------------------------------------------------ #

# get format attributes
my $FormatAttributesGet2 = $Self->{ImportExportObject}->FormatAttributesGet(
    TemplateID => $TemplateID + 1,
    UserID     => 1,
);

# check false return
$Self->False(
    $FormatAttributesGet2,
    "Test $TestCount: FormatAttributesGet() - check false return",
);

$TestCount++;

# ------------------------------------------------------------ #
# MappingFormatAttributesGet test 1 (check attribute hash)
# ------------------------------------------------------------ #

# get mapping format attributes
my $MappingFormatAttributesGet1 = $Self->{ImportExportObject}->MappingFormatAttributesGet(
    TemplateID => $TemplateID,
    UserID     => 1,
);

# check mapping format attribute reference
$Self->True(
    $MappingFormatAttributesGet1 && ref $MappingFormatAttributesGet1 eq 'ARRAY',
    "Test $TestCount: MappingFormatAttributesGet() - check array reference",
);

# define the reference hash
my $MappingFormatAttributesGet1Reference = [
    {
        Key   => 'Column',
        Name  => 'Column',
        Input => {
            Type     => 'DTL',
            Data     => '$QData{"Counter"}',
            Required => 0,
        },
    },
];

# turn off all pretty print
$Data::Dumper::Indent = 0;

# dump the list from MappingFormatAttributesGet()
my $MappingFormatAttributesGetDump1 = Data::Dumper::Dumper($MappingFormatAttributesGet1);

# dump the reference table
my $MappingFormatAttributesRefDump1 = Data::Dumper::Dumper($MappingFormatAttributesGet1Reference);

$Self->True(
    $MappingFormatAttributesGetDump1 eq $MappingFormatAttributesRefDump1,
    "Test $TestCount: MappingFormatAttributesGet() - attributes of the row are identical",
);

$TestCount++;

# ------------------------------------------------------------ #
# MappingFormatAttributesGet test 2 (check with non existing template)
# ------------------------------------------------------------ #

# get mapping format attributes
my $MappingFormatAttributesGet2 = $Self->{ImportExportObject}->MappingFormatAttributesGet(
    TemplateID => $TemplateID + 1,
    UserID     => 1,
);

# check false return
$Self->False(
    $MappingFormatAttributesGet2,
    "Test $TestCount: MappingFormatAttributesGet() - check false return",
);

$TestCount++;

# ------------------------------------------------------------ #
# clean the system
# ------------------------------------------------------------ #

# delete the test template
$Self->{ImportExportObject}->TemplateDelete(
    TemplateID => $TemplateID,
    UserID     => 1,
);

1;
