# --
# Kernel/System/ImportExport/FormatBackend/CSV.pm - import/export backend for CSV
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: CSV.pm,v 1.7 2008-02-06 17:53:07 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::System::ImportExport::FormatBackend::CSV;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.7 $) [1];

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
    for my $Object (qw(ConfigObject LogObject DBObject)) {
        $Self->{$Object} = $Param{$Object} || die "Got no $Object!";
    }

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
                Type         => 'Text',
                ValueDefault => ';',
                Required     => 1,
                Translation  => 0,
                Size         => 5,
                MaxLength    => 5,
            },
        },
    ];

    return $Attributes;
}

=item MappingFormatAttributesGet()

get the mapping attributes of an format as array/hash reference

    my $Attributes = $ObjectBackend->MappingFormatAttributesGet(
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
    ];

    return $Attributes;
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

$Revision: 1.7 $ $Date: 2008-02-06 17:53:07 $

=cut
