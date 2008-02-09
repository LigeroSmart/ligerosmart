# --
# Kernel/System/ImportExport/FormatBackend/CSV.pm - import/export backend for CSV
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: CSV.pm,v 1.10 2008-02-09 22:22:49 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::System::ImportExport::FormatBackend::CSV;

use strict;
use warnings;

use Kernel::System::ImportExport;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.10 $) [1];

=head1 NAME

Kernel::System::ImportExport::FormatBackend::CSV - import/export backend for CSV

=head1 SYNOPSIS

All functions to import and export a csv format

=over 4

=cut

=item new()

create a object

    use Kernel::Config;
    use Kernel::System::DB;
    use Kernel::System::Log;
    use Kernel::System::Main;
    use Kernel::System::ImportExport::FormatBackend::CSV;

    my $ConfigObject = Kernel::Config->new();
    my $LogObject = Kernel::System::Log->new(
        ConfigObject => $ConfigObject,
    );
    my $MainObject = Kernel::System::Main->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
    );
    my $DBObject = Kernel::System::DB->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
        MainObject   => $MainObject,
    );
    my $BackendObject = Kernel::System::ImportExport::FormatBackend::CSV->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
        DBObject     => $DBObject,
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for my $Object (qw(ConfigObject LogObject DBObject MainObject)) {
        $Self->{$Object} = $Param{$Object} || die "Got no $Object!";
    }

    $Self->{ImportExportObject} = Kernel::System::ImportExport->new( %{$Self} );

    return $Self;
}

=item FormatAttributesGet()

get the format attributes of a format as array/hash reference

    my $Attributes = $FormatBackend->FormatAttributesGet(
        UserID => 1,
    );

=cut

sub FormatAttributesGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{UserID} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need UserID!' );
        return;
    }

    my $Attributes = [
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

    return $Attributes;
}

=item MappingFormatAttributesGet()

get the mapping attributes of an format as array/hash reference

    my $Attributes = $FormatBackend->MappingFormatAttributesGet(
        UserID => 1,
    );

=cut

sub MappingFormatAttributesGet {
    my ( $Self, %Param ) = @_;

    # check needed object
    if ( !$Param{UserID} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need UserID!' );
        return;
    }

    my $Attributes = [
        {
            Key   => 'Column',
            Name  => 'Column',
            Input => {
                Type     => 'DTL',
                Data     => '$QData{"Counter"}',
                Required => 0,
            },
        },
        {
            Key   => 'Identifier',
            Name  => 'Identifier',
            Input => {
                Type => 'Checkbox',
            },
        },
    ];

    return $Attributes;
}

=item ImportDataGet()

get import data as 2D-array-hash reference

    my $ImportData = $FormatBackend->ImportDataGet(
        TemplateID    => 123,
        SourceContent => $StringRef,
        UserID        => 1,
    );

=cut

sub ImportDataGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(TemplateID UserID)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    return [] if !$Param{SourceContent};
    return [] if ref $Param{SourceContent} ne 'SCALAR';

    # get format data
    my $FormatData = $Self->{ImportExportObject}->FormatDataGet(
        TemplateID => $Param{TemplateID},
        UserID     => $Param{UserID},
    );

    return if !$FormatData;
    return if ref $FormatData ne 'HASH';
    return if !$FormatData->{ColumnSeperator};

    # split content in rows
    my @SourceContent = split "\n", ${ $Param{SourceContent} };

    my @ImportData;
    for my $SourceRow (@SourceContent) {

        # split source row
        my @Row = split $FormatData->{ColumnSeperator}, $SourceRow;

        push @ImportData, \@Row;
    }

    return \@ImportData;
}

=item ExportDataSave()

export one row of the export data

    my $DestinationContent = $FormatBackend->ExportDataSave(
        TemplateID    => 123,
        ExportDataRow => $ArrayRef,
        UserID        => 1,
    );

=cut

sub ExportDataSave {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(TemplateID ExportDataRow UserID)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    return if ref $Param{ExportDataRow} ne 'ARRAY';

    # get format data
    my $FormatData = $Self->{ImportExportObject}->FormatDataGet(
        TemplateID => $Param{TemplateID},
        UserID     => $Param{UserID},
    );

    return if !$FormatData;
    return if ref $FormatData ne 'HASH';
    return if !$FormatData->{ColumnSeperator};

    my %AvailableSeperators = (
        Tabulator => "\t",
        Semicolon => ';',
        Colon     => ':',
        Dot       => '.',
    );

    my $Seperator = $AvailableSeperators{ $FormatData->{ColumnSeperator} } || '';

    # replace undef with empty string
    map { $_ ||= '' } @{ $Param{ExportDataRow} };

    # create one csv row
    my $DestinationContent = join $Seperator, @{ $Param{ExportDataRow} };
    $DestinationContent .= "\n";

    return $DestinationContent;
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (http://otrs.org/).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.

=cut

=head1 VERSION

$Revision: 1.10 $ $Date: 2008-02-09 22:22:49 $

=cut
