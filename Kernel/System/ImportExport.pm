# --
# Kernel/System/ImportExport.pm - all import and export functions
# Copyright (C) 2001-2007 OTRS GmbH, http://otrs.org/
# --
# $Id: ImportExport.pm,v 1.1.1.1 2008-01-16 14:11:00 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::ImportExport;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.1.1.1 $) [1];

=head1 NAME

Kernel::System::ImportExport - import, export lib

=head1 SYNOPSIS

All import and export functions.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create a object

    use Kernel::Config;
    use Kernel::System::Log;
    use Kernel::System::DB;
    use Kernel::System::Priority;

    my $ConfigObject = Kernel::Config->new();
    my $LogObject = Kernel::System::Log->new(
        ConfigObject => $ConfigObject,
    );
    my $DBObject = Kernel::System::DB->new(
        ConfigObject => $ConfigObject,
        LogObject => $LogObject,
    );
    my $ImportExportObject = Kernel::System::ImportExport->new(
        ConfigObject => $ConfigObject,
        LogObject => $LogObject,
        DBObject => $DBObject,
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

=item ClassList()

return a list of available classes as hash reference

    my $ClassList = $ImportExportObject->ClassList();

=cut

sub ClassList {

    my $ClassList = {
        ITSMConfigItem => 'Config Item',
        Ticket => 'Ticket',
        FAQ => 'FAQ',
    };

    return $ClassList;
}

=item TemplateList()

return a list of templates as array reference

    my $TemplateList = $ImportExportObject->TemplateList(
        Class   => 'ITSMConfigItem',
        UserID  => 1,
    );

=cut

sub TemplateList {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(Class UserID)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!"
            );
            return;
        }
    }

    # quote
    $Param{Class}  = $Self->{DBObject}->Quote( $Param{Class} );
    $Param{UserID} = $Self->{DBObject}->Quote( $Param{UserID}, 'Integer' );

    # ask database
    $Self->{DBObject}->Prepare(
        SQL => "SELECT id FROM importexport_template WHERE "
            . "importexport_class = '$Param{Class}' "
            . "ORDER BY name",
    );

    # fetch the result
    my @TemplateList;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        push @TemplateList, $Row[0];
    }

    return \@TemplateList;
}

=item TemplateGet()

get a import export template

Return
    $TemplateData{TemplateID}
    $TemplateData{Class}
    $TemplateData{Name}
    $TemplateData{ValidID}
    $TemplateData{Comment}
    $TemplateData{CreateTime}
    $TemplateData{CreateBy}
    $TemplateData{ChangeTime}
    $TemplateData{ChangeBy}

    my $TemplateDataRef = $ImportExportObject->TemplateGet(
        TemplateID => 3,
        UserID     => 1,
    );

=cut

sub TemplateGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(TemplateID UserID)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!"
            );
            return;
        }
    }

    # quote
    $Param{TemplateID} = $Self->{DBObject}->Quote( $Param{TemplateID}, 'Integer' );

    # create sql string
    my $SQL = "SELECT id, importexport_class, name, valid_id, comments, "
        . "create_time, create_by, change_time, change_by FROM importexport_template WHERE "
        . "id = $Param{TemplateID}";

    # ask database
    $Self->{DBObject}->Prepare(
        SQL   => $SQL,
        Limit => 1,
    );

    # fetch the result
    my %TemplateData;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $TemplateData{TemplateID}    = $Row[0];
        $TemplateData{Class}         = $Row[1];
        $TemplateData{Name}          = $Row[2];
        $TemplateData{ValidID}       = $Row[3];
        $TemplateData{Comment}       = $Row[4] || '';
        $TemplateData{CreateTime}    = $Row[5];
        $TemplateData{CreateBy}      = $Row[6];
        $TemplateData{ChangeTime}    = $Row[7];
        $TemplateData{ChangeBy}      = $Row[8];
    }

    return \%TemplateData;
}

=item TemplateAdd()

add a new import/export template

    my $TemplateID = $ImportExportObject->TemplateAdd(
        Class => 'ITSMConfigItem',
        Name => 'Template Name',
        ValidID => 1,
        Comment => 'Comment',       # (optional)
        UserID => 1,
    );

=cut

sub TemplateAdd {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(Class Name ValidID UserID)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!"
            );
            return;
        }
    }

    # cleanup template name
    $Param{Name} =~ s{ \A \s+   }{}xmsg;  # TrimLeft
    $Param{Name} =~ s{ \s+ \z   }{}xmsg;  # TrimRight
    $Param{Name} =~ s{ [\n\r\f] }{}xmsg;  # RemoveAllNewlines
    $Param{Name} =~ s{ \t       }{}xmsg;  # RemoveAllTabs

    # set default values
    $Param{Comment} = $Param{Comment} || '';

    # quote
    for my $Argument (qw(Class Name Functionality Comment)) {
        $Param{$Argument} = $Self->{DBObject}->Quote( $Param{$Argument} );
    }
    for my $Argument (qw(ValidID UserID)) {
        $Param{$Argument} = $Self->{DBObject}->Quote( $Param{$Argument}, 'Integer' );
    }

    # find exiting template with same name
    $Self->{DBObject}->Prepare(
        SQL =>
            "SELECT id FROM importexport_template WHERE importexport_class = '$Param{Class}' AND name = '$Param{Name}'",
        Limit => 1,
    );

    # fetch the result
    my $NoAdd;
    while ( $Self->{DBObject}->FetchrowArray() ) {
        $NoAdd = 1;
    }

    # abort insert of new template, if template name already exists
    if ($NoAdd) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message =>
                "Can't add new template! Template with same name already exists in this class.",
        );
        return;
    }

    # insert new template
    return if !$Self->{DBObject}->Do( SQL => "INSERT INTO importexport_template "
        . "(importexport_class, name, valid_id, comments, "
        . "create_time, create_by, change_time, change_by) VALUES "
        . "('$Param{Class}', '$Param{Name}', $Param{ValidID}, '$Param{Comment}', "
        . "current_timestamp, $Param{UserID}, current_timestamp, $Param{UserID})" );

    # find id of new template
    $Self->{DBObject}->Prepare(
        SQL => "SELECT id FROM importexport_template "
            . "WHERE importexport_class = '$Param{Class}' AND name = '$Param{Name}'",
        Limit => 1,
    );

    # fetch the result
    my $TemplateID;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $TemplateID = $Row[0];
    }

    return $TemplateID;
}

=item TemplateUpdate()

update a existing import/export template

    my $True = $ImportExportObject->TemplateUpdate(
        TemplateID => 123,
        Name => 'Template Name',
        ValidID => 1,
        Comment => 'Comment',     # (optional)
        UserID => 1,
    );

=cut

sub TemplateUpdate {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(TemplateID Name ValidID UserID)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!"
            );
            return;
        }
    }

    # cleanup template name
    $Param{Name} =~ s{ \A \s+   }{}xmsg;  # TrimLeft
    $Param{Name} =~ s{ \s+ \z   }{}xmsg;  # TrimRight
    $Param{Name} =~ s{ [\n\r\f] }{}xmsg;  # RemoveAllNewlines
    $Param{Name} =~ s{ \t       }{}xmsg;  # RemoveAllTabs

    # set default values
    $Param{Comment} = $Param{Comment} || '';

    # quote
    for my $Argument (qw(Name Comment)) {
        $Param{$Argument} = $Self->{DBObject}->Quote( $Param{$Argument} );
    }
    for my $Argument (qw(TemplateID ValidID UserID)) {
        $Param{$Argument} = $Self->{DBObject}->Quote( $Param{$Argument}, 'Integer' );
    }

    # find exiting template with same name
    $Self->{DBObject}->Prepare(
        SQL =>
            "SELECT id FROM importexport_template WHERE importexport_class = '$Param{Class}' AND name = '$Param{Name}'",
        Limit => 1,
    );

    # fetch the result
    my $Update = 1;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        if ( $Param{TemplateID} ne $Row[0] ) {
            $Update = 0;
        }
    }

    if (!$Update) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message =>
                "Can't update template! Template with same name already exists in this class.",
        );
        return;
    }

    # update template
    return $Self->{DBObject}->Do( SQL =>
        "UPDATE importexport_template SET name = '$Param{Name}',"
        . "valid_id = $Param{ValidID}, comments = '$Param{Comment}', "
        . "change_time = current_timestamp, change_by = $Param{UserID} WHERE id = $Param{TemplateID}",
    );
}

1;

=back

=head1 TERMS AND CONDITIONS

This Software is part of the OTRS project (http://otrs.org/).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see http://www.gnu.org/licenses/gpl.txt.

=cut

=head1 VERSION

$Revision: 1.1.1.1 $ $Date: 2008-01-16 14:11:00 $

=cut
