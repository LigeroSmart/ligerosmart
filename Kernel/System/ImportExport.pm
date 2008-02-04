# --
# Kernel/System/ImportExport.pm - all import and export functions
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: ImportExport.pm,v 1.10 2008-02-04 19:53:32 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::System::ImportExport;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.10 $) [1];

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
    use Kernel::System::DB;
    use Kernel::System::ImportExport;
    use Kernel::System::Log;
    use Kernel::System::Main;

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
    my $ImportExportObject = Kernel::System::ImportExport->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
        DBObject     => $DBObject,
        MainObject   => $MainObject,
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

    return $Self;
}

=item TemplateList()

return a list of templates as array reference

    my $TemplateList = $ImportExportObject->TemplateList(
        Object => 'Ticket',
        UserID => 1,
    );

=cut

sub TemplateList {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(Object UserID)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!"
            );
            return;
        }
    }

    # quote
    $Param{Object} = $Self->{DBObject}->Quote( $Param{Object} );
    $Param{UserID} = $Self->{DBObject}->Quote( $Param{UserID}, 'Integer' );

    # ask database
    $Self->{DBObject}->Prepare(
        SQL => "SELECT id FROM imexport_template WHERE "
            . "imexport_object = '$Param{Object}' "
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
    $TemplateData{Number}
    $TemplateData{Object}
    $TemplateData{Format}
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
    my $SQL = "SELECT id, imexport_object, imexport_format, name, valid_id, comments, "
        . "create_time, create_by, change_time, change_by FROM imexport_template WHERE "
        . "id = $Param{TemplateID}";

    # ask database
    $Self->{DBObject}->Prepare(
        SQL   => $SQL,
        Limit => 1,
    );

    # fetch the result
    my %TemplateData;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $TemplateData{TemplateID} = $Row[0];
        $TemplateData{Object}     = $Row[1];
        $TemplateData{Format}     = $Row[2];
        $TemplateData{Name}       = $Row[3];
        $TemplateData{ValidID}    = $Row[4];
        $TemplateData{Comment}    = $Row[5] || '';
        $TemplateData{CreateTime} = $Row[6];
        $TemplateData{CreateBy}   = $Row[7];
        $TemplateData{ChangeTime} = $Row[8];
        $TemplateData{ChangeBy}   = $Row[9];

        $TemplateData{Number} = sprintf "%06d", $TemplateData{TemplateID};
    }

    return \%TemplateData;
}

=item TemplateAdd()

add a new import/export template

    my $TemplateID = $ImportExportObject->TemplateAdd(
        Object  => 'Ticket',
        Format  => 'CSV',
        Name    => 'Template Name',
        ValidID => 1,
        Comment => 'Comment',       # (optional)
        UserID  => 1,
    );

=cut

sub TemplateAdd {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(Object Format Name ValidID UserID)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!"
            );
            return;
        }
    }

    # cleanup template name
    for my $Element (qw(Object Format Name)) {
        $Param{$Element} =~ s{ [\n\r\f] }{}xmsg;    # RemoveAllNewlines
        $Param{$Element} =~ s{ \t       }{}xmsg;    # RemoveAllTabs
        $Param{$Element} =~ s{ \A \s+   }{}xmsg;    # TrimLeft
        $Param{$Element} =~ s{ \s+ \z   }{}xmsg;    # TrimRight
    }

    # set default values
    $Param{Comment} = $Param{Comment} || '';

    # quote
    for my $Argument (qw(Object Format Name Functionality Comment)) {
        $Param{$Argument} = $Self->{DBObject}->Quote( $Param{$Argument} );
    }
    for my $Argument (qw(ValidID UserID)) {
        $Param{$Argument} = $Self->{DBObject}->Quote( $Param{$Argument}, 'Integer' );
    }

    # find exiting template with same name
    $Self->{DBObject}->Prepare(
        SQL => "SELECT id FROM imexport_template "
            . "WHERE imexport_object = '$Param{Object}' AND name = '$Param{Name}'",
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
                "Can't add new template! Template with same name already exists in this object.",
        );
        return;
    }

    # insert new template
    return if !$Self->{DBObject}->Do(
        SQL => "INSERT INTO imexport_template "
            . "(imexport_object, imexport_format, name, valid_id, comments, "
            . "create_time, create_by, change_time, change_by) VALUES "
            . "('$Param{Object}', '$Param{Format}', "
            . "'$Param{Name}', $Param{ValidID}, '$Param{Comment}', "
            . "current_timestamp, $Param{UserID}, current_timestamp, $Param{UserID})"
    );

    # find id of new template
    $Self->{DBObject}->Prepare(
        SQL => "SELECT id FROM imexport_template "
            . "WHERE imexport_object = '$Param{Object}' AND name = '$Param{Name}'",
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
        Name       => 'Template Name',
        ValidID    => 1,
        Comment    => 'Comment',        # (optional)
        UserID     => 1,
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
    $Param{Name} =~ s{ [\n\r\f] }{}xmsg;    # RemoveAllNewlines
    $Param{Name} =~ s{ \t       }{}xmsg;    # RemoveAllTabs
    $Param{Name} =~ s{ \A \s+   }{}xmsg;    # TrimLeft
    $Param{Name} =~ s{ \s+ \z   }{}xmsg;    # TrimRight

    # set default values
    $Param{Comment} = $Param{Comment} || '';

    # quote
    for my $Argument (qw(Name Comment)) {
        $Param{$Argument} = $Self->{DBObject}->Quote( $Param{$Argument} );
    }
    for my $Argument (qw(TemplateID ValidID UserID)) {
        $Param{$Argument} = $Self->{DBObject}->Quote( $Param{$Argument}, 'Integer' );
    }

    # get the object of this template id
    $Self->{DBObject}->Prepare(
        SQL => "SELECT imexport_object FROM imexport_template "
            . "WHERE id = '$Param{TemplateID}'",
        Limit => 1,
    );

    # fetch the result
    my $Object;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $Object = $Row[0];
    }

    if ( !$Object ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message =>
                "Can't update template! I can't find the template.",
        );
        return;
    }

    # find exiting template with same name
    $Self->{DBObject}->Prepare(
        SQL => "SELECT id FROM imexport_template "
            . "WHERE imexport_object = '$Object' AND name = '$Param{Name}'",
        Limit => 1,
    );

    # fetch the result
    my $Update = 1;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        if ( $Param{TemplateID} ne $Row[0] ) {
            $Update = 0;
        }
    }

    if ( !$Update ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message =>
                "Can't update template! Template with same name already exists in this object.",
        );
        return;
    }

    # update template
    return $Self->{DBObject}->Do(
        SQL => "UPDATE imexport_template SET name = '$Param{Name}',"
            . "valid_id = $Param{ValidID}, comments = '$Param{Comment}', "
            . "change_time = current_timestamp, change_by = $Param{UserID} "
            . "WHERE id = $Param{TemplateID}",
    );
}

=item TemplateDelete()

delete existing import/export templates

    my $True = $ImportExportObject->TemplateDelete(
        TemplateID => 123,
        UserID     => 1,
    );

    or

    my $True = $ImportExportObject->TemplateDelete(
        TemplateID => [1,44,166,5],
        UserID     => 1,
    );

=cut

sub TemplateDelete {
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

    if ( !ref $Param{TemplateID} ) {
        $Param{TemplateID} = [ $Param{TemplateID} ];
    }
    elsif ( ref $Param{TemplateID} ne 'ARRAY' ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'TemplateID must be an array reference or a string!',
        );
        return;
    }

    # delete all mapping data
    for my $TemplateID ( @{ $Param{TemplateID} } ) {
        $Self->MappingDataDelete(
            TemplateID => $TemplateID,
            UserID     => $Param{UserID},
        );
    }

    # delete existing format data
    $Self->FormatDataDelete(
        TemplateID => $Param{TemplateID},
        UserID     => $Param{UserID},
    );

    # delete existing object data
    $Self->ObjectDataDelete(
        TemplateID => $Param{TemplateID},
        UserID     => $Param{UserID},
    );

    # quote
    for my $TemplateID ( @{ $Param{TemplateID} } ) {
        $TemplateID = $Self->{DBObject}->Quote( $TemplateID, 'Integer' );
    }

    # create the template id string
    my $TemplateIDString = join ',', @{ $Param{TemplateID} };

    # delete templates
    return $Self->{DBObject}->Do(
        SQL => "DELETE FROM imexport_template WHERE id IN ( $TemplateIDString )",
    );
}

=item ObjectList()

return a list of available objects as hash reference

    my $ObjectList = $ImportExportObject->ObjectList();

=cut

sub ObjectList {
    my ( $Self, %Param ) = @_;

    # get config
    my $ModuleList = $Self->{ConfigObject}->Get('ImportExport::ObjectBackendRegistration');

    return if !$ModuleList;
    return if ref $ModuleList ne 'HASH';

    # create the object list
    my $ObjectList = {};
    for my $Module ( sort keys %{$ModuleList} ) {
        $ObjectList->{$Module} = $ModuleList->{$Module}->{Name};
    }

    return $ObjectList;
}

=item ObjectAttributesGet()

get the attributes of an object backend as array/hash reference

    my $Attributes = $ImportExportObject->ObjectAttributesGet(
        TemplateID => 123,
        UserID     => 1,
    );

=cut

sub ObjectAttributesGet {
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

    # get template data
    my $TemplateData = $Self->TemplateGet(
        TemplateID => $Param{TemplateID},
        UserID     => $Param{UserID},
    );

    # load backend
    my $Backend = $Self->_LoadBackend(
        Module => "Kernel::System::ImportExport::ObjectBackend::$TemplateData->{Object}",
    );

    return if !$Backend;

    # get an attribute list of the object
    my $Attributes = $Backend->AttributesGet(
        %Param,
        UserID => $Param{UserID},
    );

    return $Attributes;
}

=item ObjectDataGet()

get the object data from a template

    my $ObjectDataRef = $ImportExportObject->ObjectDataGet(
        TemplateID => 3,
        UserID     => 1,
    );

=cut

sub ObjectDataGet {
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
    my $SQL = "SELECT data_key, data_value FROM imexport_object WHERE "
        . "template_id = $Param{TemplateID}";

    # ask database
    $Self->{DBObject}->Prepare( SQL => $SQL );

    # fetch the result
    my %ObjectData;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $ObjectData{ $Row[0] } = $Row[1];
    }

    return \%ObjectData;
}

=item ObjectDataSave()

save the object data from a template

    my $True = $ImportExportObject->ObjectDataSave(
        TemplateID => 123,
        ObjectData => $HashRef,
        UserID     => 1,
    );

=cut

sub ObjectDataSave {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(TemplateID ObjectData UserID)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!"
            );
            return;
        }
    }

    if ( ref $Param{ObjectData} ne 'HASH' ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'ObjectData must be an hash reference!',
        );
        return;
    }

    # delete existing object data
    $Self->ObjectDataDelete(
        TemplateID => $Param{TemplateID},
        UserID     => $Param{UserID},
    );

    for my $DataKey ( keys %{ $Param{ObjectData} } ) {

        # quote
        my $QDataKey   = $Self->{DBObject}->Quote($DataKey);
        my $QDataValue = $Self->{DBObject}->Quote( $Param{ObjectData}->{$DataKey} );

        # insert one row
        $Self->{DBObject}->Do(
            SQL => "INSERT INTO imexport_object "
                . "(template_id, data_key, data_value) VALUES "
                . "($Param{TemplateID}, '$QDataKey', '$QDataValue')"
        );
    }

    return 1;
}

=item ObjectDataDelete()

delete the existing object data from a template

    my $True = $ImportExportObject->ObjectDataDelete(
        TemplateID => 123,
        UserID     => 1,
    );

    or

    my $True = $ImportExportObject->ObjectDataDelete(
        TemplateID => [1,44,166,5],
        UserID     => 1,
    );

=cut

sub ObjectDataDelete {
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

    if ( !ref $Param{TemplateID} ) {
        $Param{TemplateID} = [ $Param{TemplateID} ];
    }
    elsif ( ref $Param{TemplateID} ne 'ARRAY' ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'TemplateID must be an array reference or a string!',
        );
        return;
    }

    # quote
    for my $TemplateID ( @{ $Param{TemplateID} } ) {
        $TemplateID = $Self->{DBObject}->Quote( $TemplateID, 'Integer' );
    }

    # create the template id string
    my $TemplateIDString = join ',', @{ $Param{TemplateID} };

    # delete templates
    return $Self->{DBObject}->Do(
        SQL => "DELETE FROM imexport_object WHERE template_id IN ( $TemplateIDString )",
    );
}

=item FormatList()

return a list of available formats as hash reference

    my $FormatList = $ImportExportObject->FormatList();

=cut

sub FormatList {
    my ( $Self, %Param ) = @_;

    # get config
    my $ModuleList = $Self->{ConfigObject}->Get('ImportExport::FormatBackendRegistration');

    return if !$ModuleList;
    return if ref $ModuleList ne 'HASH';

    # create the format list
    my $FormatList = {};
    for my $Module ( sort keys %{$ModuleList} ) {
        $FormatList->{$Module} = $ModuleList->{$Module}->{Name};
    }

    return $FormatList;
}

=item FormatAttributesGet()

get the attributes of a format backend as array/hash reference

    my $Attributes = $ImportExportObject->FormatAttributesGet(
        TemplateID => 123,
        UserID     => 1,
    );

=cut

sub FormatAttributesGet {
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

    # get template data
    my $TemplateData = $Self->TemplateGet(
        TemplateID => $Param{TemplateID},
        UserID     => $Param{UserID},
    );

    # load backend
    my $Backend = $Self->_LoadBackend(
        Module => "Kernel::System::ImportExport::FormatBackend::$TemplateData->{Format}",
    );

    return if !$Backend;

    # get an attribute list of the format
    my $Attributes = $Backend->AttributesGet(
        %Param,
        UserID => $Param{UserID},
    );

    return $Attributes;
}

=item FormatDataGet()

get the format data from a template

    my $FormatDataRef = $ImportExportObject->FormatDataGet(
        TemplateID => 3,
        UserID     => 1,
    );

=cut

sub FormatDataGet {
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
    my $SQL = "SELECT data_key, data_value FROM imexport_format WHERE "
        . "template_id = $Param{TemplateID}";

    # ask database
    $Self->{DBObject}->Prepare( SQL => $SQL );

    # fetch the result
    my %FormatData;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $FormatData{ $Row[0] } = $Row[1];
    }

    return \%FormatData;
}

=item FormatDataSave()

save the format data from a template

    my $True = $ImportExportObject->FormatDataSave(
        TemplateID => 123,
        FormatData => $HashRef,
        UserID     => 1,
    );

=cut

sub FormatDataSave {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(TemplateID FormatData UserID)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!"
            );
            return;
        }
    }

    if ( ref $Param{FormatData} ne 'HASH' ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'FormatData must be an hash reference!',
        );
        return;
    }

    # delete existing format data
    $Self->FormatDataDelete(
        TemplateID => $Param{TemplateID},
        UserID     => $Param{UserID},
    );

    for my $DataKey ( keys %{ $Param{FormatData} } ) {

        # quote
        my $QDataKey   = $Self->{DBObject}->Quote($DataKey);
        my $QDataValue = $Self->{DBObject}->Quote( $Param{FormatData}->{$DataKey} );

        # insert one row
        $Self->{DBObject}->Do(
            SQL => "INSERT INTO imexport_format "
                . "(template_id, data_key, data_value) VALUES "
                . "($Param{TemplateID}, '$QDataKey', '$QDataValue')"
        );
    }

    return 1;
}

=item FormatDataDelete()

delete the existing format data from a template

    my $True = $ImportExportObject->FormatDataDelete(
        TemplateID => 123,
        UserID     => 1,
    );

    or

    my $True = $ImportExportObject->FormatDataDelete(
        TemplateID => [1,44,166,5],
        UserID     => 1,
    );

=cut

sub FormatDataDelete {
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

    if ( !ref $Param{TemplateID} ) {
        $Param{TemplateID} = [ $Param{TemplateID} ];
    }
    elsif ( ref $Param{TemplateID} ne 'ARRAY' ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'TemplateID must be an array reference or a string!',
        );
        return;
    }

    # quote
    for my $TemplateID ( @{ $Param{TemplateID} } ) {
        $TemplateID = $Self->{DBObject}->Quote( $TemplateID, 'Integer' );
    }

    # create the template id string
    my $TemplateIDString = join ',', @{ $Param{TemplateID} };

    # delete templates
    return $Self->{DBObject}->Do(
        SQL => "DELETE FROM imexport_format WHERE template_id IN ( $TemplateIDString )",
    );
}

=item MappingDataList()

return a list of mapping data ids sorted by position as array reference

    my $MappingDataList = $ImportExportObject->MappingDataList(
        TemplateID => 123,
        UserID     => 1,
    );

=cut

sub MappingDataList {
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
    my $SQL = "SELECT id FROM imexport_mapping WHERE "
        . "template_id = $Param{TemplateID} ORDER BY position";

    # ask database
    $Self->{DBObject}->Prepare( SQL => $SQL );

    # fetch the result
    my @MappingDataList;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        push @MappingDataList, $Row[0];
    }

    return \@MappingDataList;
}

=item MappingDataAdd()

add a new mapping data row

    my $True = $ImportExportObject->MappingDataAdd(
        TemplateID => 123,
        UserID     => 1,
    );

=cut

sub MappingDataAdd {
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
    for my $Argument (qw(TemplateID UserID)) {
        $Param{$Argument} = $Self->{DBObject}->Quote( $Param{$Argument}, 'Integer' );
    }

    # find maximum position
    $Self->{DBObject}->Prepare(
        SQL => "SELECT max(position) FROM imexport_mapping "
            . "WHERE template_id = $Param{TemplateID}",
        Limit => 1,
    );

    # fetch the result
    my $NewPosition = 0;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $NewPosition = $Row[0] + 1;
    }

    # insert a new mapping data row
    return $Self->{DBObject}->Do(
        SQL => "INSERT INTO imexport_mapping "
            . "(template_id, position) VALUES "
            . "($Param{TemplateID}, $NewPosition)"
    );
}

=item MappingDataDelete()

delete existing mapping data rows

    my $True = $ImportExportObject->MappingDataDelete(
        MappingID  => 123,
        TemplateID => 321,
        UserID     => 1,
    );

    or

    my $True = $ImportExportObject->MappingDataDelete(
        TemplateID => 321,
        UserID     => 1,
    );

=cut

sub MappingDataDelete {
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
    for my $Argument (qw(TemplateID UserID)) {
        $Param{$Argument} = $Self->{DBObject}->Quote( $Param{$Argument}, 'Integer' );
    }

    if ( defined $Param{MappingID} ) {

        # quote
        $Param{MappingID} = $Self->{DBObject}->Quote( $Param{MappingID}, 'Integer' );

        # delete one mapping row
        $Self->{DBObject}->Do(
            SQL => "DELETE FROM imexport_mapping WHERE id = $Param{MappingID}",
        );

        # rebuild mapping positions
        $Self->MappingDataPositionRebuild(
            TemplateID => $Param{TemplateID},
            UserID     => $Param{UserID},
        );

        return 1;
    }
    else {

        # delete all mapping rows of this template
        return $Self->{DBObject}->Do(
            SQL => "DELETE FROM imexport_mapping WHERE template_id = $Param{TemplateID}",
        );
    }
}

=item MappingDataUp()

move an mapping data row up

    my $True = $ImportExportObject->MappingDataUp(
        MappingID  => 123,
        TemplateID => 321,
        UserID     => 1,
    );

=cut

sub MappingDataUp {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(MappingID TemplateID UserID)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!"
            );
            return;
        }
    }

    # get mapping data list
    my $MappingDataList = $Self->MappingDataList(
        TemplateID => $Param{TemplateID},
        UserID     => $Param{UserID},
    );

    return 1 if $Param{MappingID} == $MappingDataList->[0];

    # quote
    for my $Argument (qw(MappingID TemplateID UserID)) {
        $Param{$Argument} = $Self->{DBObject}->Quote( $Param{$Argument}, 'Integer' );
    }

    # get position
    my $SQL = "SELECT position FROM imexport_mapping WHERE id = $Param{MappingID}";

    # ask database
    $Self->{DBObject}->Prepare( SQL => $SQL );

    # fetch the result
    my $Position;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $Position = $Row[0];
    }

    return 1 if !$Position;

    my $PositionUpper = $Position - 1;

    # update positions
    $Self->{DBObject}->Do(
        SQL => "UPDATE imexport_mapping SET position = $Position "
            . "WHERE template_id = $Param{TemplateID} AND position = $PositionUpper",
    );
    $Self->{DBObject}->Do(
        SQL => "UPDATE imexport_mapping SET position = $PositionUpper "
            . "WHERE id = $Param{MappingID}",
    );

    return 1;
}

=item MappingDataDown()

move an mapping data row down

    my $True = $ImportExportObject->MappingDataDown(
        MappingID  => 123,
        TemplateID => 321,
        UserID     => 1,
    );

=cut

sub MappingDataDown {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(MappingID TemplateID UserID)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!"
            );
            return;
        }
    }

    # get mapping data list
    my $MappingDataList = $Self->MappingDataList(
        TemplateID => $Param{TemplateID},
        UserID     => $Param{UserID},
    );

    return 1 if $Param{MappingID} == $MappingDataList->[-1];

    # quote
    for my $Argument (qw(MappingID TemplateID UserID)) {
        $Param{$Argument} = $Self->{DBObject}->Quote( $Param{$Argument}, 'Integer' );
    }

    # get position
    my $SQL = "SELECT position FROM imexport_mapping WHERE id = $Param{MappingID}";

    # ask database
    $Self->{DBObject}->Prepare( SQL => $SQL );

    # fetch the result
    my $Position;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $Position = $Row[0];
    }

    my $PositionDown = $Position + 1;

    # update positions
    $Self->{DBObject}->Do(
        SQL => "UPDATE imexport_mapping SET position = $Position "
            . "WHERE template_id = $Param{TemplateID} AND position = $PositionDown",
    );
    $Self->{DBObject}->Do(
        SQL => "UPDATE imexport_mapping SET position = $PositionDown "
            . "WHERE id = $Param{MappingID}",
    );

    return 1;
}

=item MappingDataPositionRebuild()

rebuild the positions of a mapping list

    my $True = $ImportExportObject->MappingDataPositionRebuild(
        TemplateID => 123,
        UserID     => 1,
    );

=cut

sub MappingDataPositionRebuild {
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

    # get mapping data list
    my $MappingDataList = $Self->MappingDataList(
        TemplateID => $Param{TemplateID},
        UserID     => $Param{UserID},
    );

    # update position
    my $Counter = 0;
    for my $MappingID ( @{$MappingDataList} ) {
        $Self->{DBObject}->Do(
            SQL => "UPDATE imexport_mapping SET position = $Counter "
                . "WHERE id = $MappingID",
        );
        $Counter++;
    }

    return 1;
}

=item _LoadBackend()

to load a import/export backend module

    $HashRef = $ImportExportObject->_LoadBackend(
        Module => 'Kernel::System::ImportExport::ObjectBackend::Ticket',
    );

=cut

sub _LoadBackend {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{Module} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need Module!'
        );
        return;
    }

    # check if object is already cached
    return $Self->{Cache}->{LoadBackend}->{ $Param{Module} }
        if $Self->{Cache}->{LoadBackend}->{ $Param{Module} };

    # load object backend module
    if ( !$Self->{MainObject}->Require( $Param{Module} ) ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Can't load backend module $Param{Module}!"
        );
        return;
    }

    # create new instance
    my $BackendObject = $Param{Module}->new(
        %{$Self},
        %Param,
    );

    if ( !$BackendObject ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Can't create a new instance of backend module $Param{Module}!",
        );
        return;
    }

    # cache the object
    $Self->{Cache}->{LoadBackend}->{ $Param{Module} } = $BackendObject;

    return $BackendObject;
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

$Revision: 1.10 $ $Date: 2008-02-04 19:53:32 $

=cut
