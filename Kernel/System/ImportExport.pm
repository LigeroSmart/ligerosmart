# --
# Kernel/System/ImportExport.pm - all import and export functions
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: ImportExport.pm,v 1.23 2008-04-04 10:19:24 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::System::ImportExport;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.23 $) [1];

=head1 NAME

Kernel::System::ImportExport - import, export lib

=head1 SYNOPSIS

All import and export functions.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create an object

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
        Object => 'Ticket',  # (optional)
        Format => 'CSV'      # (optional)
        UserID => 1,
    );

=cut

sub TemplateList {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{UserID} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need UserID!',
        );
        return;
    }

    # quote
    for my $Argument (qw(Object Format)) {
        $Param{$Argument} = $Self->{DBObject}->Quote( $Param{$Argument} ) || '';
    }
    $Param{UserID} = $Self->{DBObject}->Quote( $Param{UserID}, 'Integer' );

    # create sql string
    my $SQL = 'SELECT id FROM imexport_template WHERE 1=1 ';

    if ( $Param{Object} ) {
        $SQL .= "AND imexport_object = '$Param{Object}' ";
    }
    if ( $Param{Format} ) {
        $SQL .= "AND imexport_format = '$Param{Format}' ";
    }

    # add order option
    $SQL .= 'ORDER BY id';

    # ask database
    $Self->{DBObject}->Prepare( SQL => $SQL );

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

    # check if result is already cached
    return $Self->{Cache}->{TemplateGet}->{ $Param{TemplateID} }
        if $Self->{Cache}->{TemplateGet}->{ $Param{TemplateID} };

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

    # cache the result
    $Self->{Cache}->{TemplateGet}->{ $Param{TemplateID} } = \%TemplateData;

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

    # set default values
    $Param{Comment} = $Param{Comment} || '';

    # quote
    for my $Argument (qw(Object Format Name Functionality Comment)) {
        $Param{$Argument} = $Self->{DBObject}->Quote( $Param{$Argument} );
    }
    for my $Argument (qw(ValidID UserID)) {
        $Param{$Argument} = $Self->{DBObject}->Quote( $Param{$Argument}, 'Integer' );
    }

    # cleanup given params (replace it with StringClean() in OTRS 2.3 and later)
    for my $Argument (qw(Object Format)) {
        $Self->_StringClean(
            StringRef         => \$Param{$Argument},
            RemoveAllNewlines => 1,
            RemoveAllTabs     => 1,
            RemoveAllSpaces   => 1,
        );
    }
    for my $Argument (qw(Name Comment)) {
        $Self->_StringClean(
            StringRef         => \$Param{$Argument},
            RemoveAllNewlines => 1,
            RemoveAllTabs     => 1,
        );
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

    # set default values
    $Param{Comment} = $Param{Comment} || '';

    # quote
    for my $Argument (qw(Name Comment)) {
        $Param{$Argument} = $Self->{DBObject}->Quote( $Param{$Argument} );
    }
    for my $Argument (qw(TemplateID ValidID UserID)) {
        $Param{$Argument} = $Self->{DBObject}->Quote( $Param{$Argument}, 'Integer' );
    }

    # cleanup given params (replace it with StringClean() in OTRS 2.3 and later)
    for my $Argument (qw(Name Comment)) {
        $Self->_StringClean(
            StringRef         => \$Param{$Argument},
            RemoveAllNewlines => 1,
            RemoveAllTabs     => 1,
        );
    }

    # get the object of this template id
    $Self->{DBObject}->Prepare(
        SQL => "SELECT imexport_object FROM imexport_template "
            . "WHERE id = $Param{TemplateID}",
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

    # reset cache
    delete $Self->{Cache}->{TemplateGet}->{ $Param{TemplateID} };

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

    # delete existing search data
    $Self->SearchDataDelete(
        TemplateID => $Param{TemplateID},
        UserID     => $Param{UserID},
    );

    # delete all mapping data
    for my $TemplateID ( @{ $Param{TemplateID} } ) {
        $Self->MappingDelete(
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

    # reset cache
    delete $Self->{Cache}->{TemplateGet};

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

    # check template data
    if ( !$TemplateData || !$TemplateData->{Object} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Template with ID $Param{TemplateID} not complete!",
        );
        return;
    }

    # load backend
    my $Backend = $Self->_LoadBackend(
        Module => "Kernel::System::ImportExport::ObjectBackend::$TemplateData->{Object}",
    );

    return if !$Backend;

    # get an attribute list of the object
    my $Attributes = $Backend->ObjectAttributesGet(
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

save the object data of a template

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

    DATAKEY:
    for my $DataKey ( keys %{ $Param{ObjectData} } ) {

        # quote
        my $QDataKey   = $Self->{DBObject}->Quote($DataKey);
        my $QDataValue = $Self->{DBObject}->Quote( $Param{ObjectData}->{$DataKey} );

        next DATAKEY if !defined $QDataKey;
        next DATAKEY if !defined $QDataValue;

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

delete the existing object data of a template

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

    # check template data
    if ( !$TemplateData || !$TemplateData->{Format} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Template with ID $Param{TemplateID} not complete!",
        );
        return;
    }

    # load backend
    my $Backend = $Self->_LoadBackend(
        Module => "Kernel::System::ImportExport::FormatBackend::$TemplateData->{Format}",
    );

    return if !$Backend;

    # get an attribute list of the format
    my $Attributes = $Backend->FormatAttributesGet(
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

save the format data of a template

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

    DATAKEY:
    for my $DataKey ( keys %{ $Param{FormatData} } ) {

        # quote
        my $QDataKey   = $Self->{DBObject}->Quote($DataKey);
        my $QDataValue = $Self->{DBObject}->Quote( $Param{FormatData}->{$DataKey} );

        next DATAKEY if !defined $QDataKey;
        next DATAKEY if !defined $QDataValue;

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

delete the existing format data of a template

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

=item MappingList()

return a list of mapping data ids sorted by position as array reference

    my $MappingList = $ImportExportObject->MappingList(
        TemplateID => 123,
        UserID     => 1,
    );

=cut

sub MappingList {
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
    my @MappingList;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        push @MappingList, $Row[0];
    }

    return \@MappingList;
}

=item MappingAdd()

add a new mapping data row

    my $True = $ImportExportObject->MappingAdd(
        TemplateID => 123,
        UserID     => 1,
    );

=cut

sub MappingAdd {
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

        if ( defined $Row[0] ) {
            $NewPosition = $Row[0];
            $NewPosition++;
        }
    }

    # insert a new mapping data row
    return $Self->{DBObject}->Do(
        SQL => "INSERT INTO imexport_mapping "
            . "(template_id, position) VALUES "
            . "($Param{TemplateID}, $NewPosition)"
    );
}

=item MappingDelete()

delete existing mapping data rows

    my $True = $ImportExportObject->MappingDelete(
        MappingID  => 123,
        TemplateID => 321,
        UserID     => 1,
    );

    or

    my $True = $ImportExportObject->MappingDelete(
        TemplateID => 321,
        UserID     => 1,
    );

=cut

sub MappingDelete {
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

        # delete existing object mapping data
        $Self->MappingObjectDataDelete(
            MappingID => $Param{MappingID},
            UserID    => $Param{UserID},
        );

        # delete existing format mapping data
        $Self->MappingFormatDataDelete(
            MappingID => $Param{MappingID},
            UserID    => $Param{UserID},
        );

        # quote
        $Param{MappingID} = $Self->{DBObject}->Quote( $Param{MappingID}, 'Integer' );

        # delete one mapping row
        $Self->{DBObject}->Do(
            SQL => "DELETE FROM imexport_mapping WHERE id = $Param{MappingID}",
        );

        # rebuild mapping positions
        $Self->MappingPositionRebuild(
            TemplateID => $Param{TemplateID},
            UserID     => $Param{UserID},
        );

        return 1;
    }
    else {

        # get mapping list
        my $MappingList = $Self->MappingList(
            TemplateID => $Param{TemplateID},
            UserID     => $Param{UserID},
        );

        for my $MappingID ( @{$MappingList} ) {

            # delete existing object mapping data
            $Self->MappingObjectDataDelete(
                MappingID => $MappingID,
                UserID    => $Param{UserID},
            );

            # delete existing format mapping data
            $Self->MappingFormatDataDelete(
                MappingID => $MappingID,
                UserID    => $Param{UserID},
            );
        }

        # delete all mapping rows of this template
        return $Self->{DBObject}->Do(
            SQL => "DELETE FROM imexport_mapping WHERE template_id = $Param{TemplateID}",
        );
    }
}

=item MappingUp()

move an mapping data row up

    my $True = $ImportExportObject->MappingUp(
        MappingID  => 123,
        TemplateID => 321,
        UserID     => 1,
    );

=cut

sub MappingUp {
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
    my $MappingList = $Self->MappingList(
        TemplateID => $Param{TemplateID},
        UserID     => $Param{UserID},
    );

    return 1 if $Param{MappingID} == $MappingList->[0];

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

=item MappingDown()

move an mapping data row down

    my $True = $ImportExportObject->MappingDown(
        MappingID  => 123,
        TemplateID => 321,
        UserID     => 1,
    );

=cut

sub MappingDown {
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
    my $MappingList = $Self->MappingList(
        TemplateID => $Param{TemplateID},
        UserID     => $Param{UserID},
    );

    return 1 if $Param{MappingID} == $MappingList->[-1];

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

=item MappingPositionRebuild()

rebuild the positions of a mapping list

    my $True = $ImportExportObject->MappingPositionRebuild(
        TemplateID => 123,
        UserID     => 1,
    );

=cut

sub MappingPositionRebuild {
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
    my $MappingList = $Self->MappingList(
        TemplateID => $Param{TemplateID},
        UserID     => $Param{UserID},
    );

    # update position
    my $Counter = 0;
    for my $MappingID ( @{$MappingList} ) {
        $Self->{DBObject}->Do(
            SQL => "UPDATE imexport_mapping SET position = $Counter "
                . "WHERE id = $MappingID",
        );
        $Counter++;
    }

    return 1;
}

=item MappingObjectAttributesGet()

get the attributes of an object backend as array/hash reference

    my $Attributes = $ImportExportObject->MappingObjectAttributesGet(
        TemplateID => 123,
        UserID     => 1,
    );

=cut

sub MappingObjectAttributesGet {
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

    # check template data
    if ( !$TemplateData || !$TemplateData->{Object} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Template with ID $Param{TemplateID} not complete!",
        );
        return;
    }

    # load backend
    my $Backend = $Self->_LoadBackend(
        Module => "Kernel::System::ImportExport::ObjectBackend::$TemplateData->{Object}",
    );

    return if !$Backend;

    # get an attribute list of the object
    my $Attributes = $Backend->MappingObjectAttributesGet(
        %Param,
        UserID => $Param{UserID},
    );

    return $Attributes;
}

=item MappingObjectDataDelete()

delete the existing object data of a mapping

    my $True = $ImportExportObject->MappingObjectDataDelete(
        MappingID => 123,
        UserID    => 1,
    );

    or

    my $True = $ImportExportObject->MappingObjectDataDelete(
        MappingID => [1,44,166,5],
        UserID    => 1,
    );

=cut

sub MappingObjectDataDelete {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(MappingID UserID)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!"
            );
            return;
        }
    }

    if ( !ref $Param{MappingID} ) {
        $Param{MappingID} = [ $Param{MappingID} ];
    }
    elsif ( ref $Param{MappingID} ne 'ARRAY' ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'MappingID must be an array reference or a string!',
        );
        return;
    }

    # quote
    for my $MappingID ( @{ $Param{MappingID} } ) {
        $MappingID = $Self->{DBObject}->Quote( $MappingID, 'Integer' );
    }

    # create the mapping id string
    my $MappingIDString = join ',', @{ $Param{MappingID} };

    # delete mapping object data
    return $Self->{DBObject}->Do(
        SQL => "DELETE FROM imexport_mapping_object WHERE mapping_id IN ( $MappingIDString )",
    );
}

=item MappingObjectDataSave()

save the object data of a mapping

    my $True = $ImportExportObject->MappingObjectDataSave(
        MappingID         => 123,
        MappingObjectData => $HashRef,
        UserID            => 1,
    );

=cut

sub MappingObjectDataSave {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(MappingID MappingObjectData UserID)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!"
            );
            return;
        }
    }

    if ( ref $Param{MappingObjectData} ne 'HASH' ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'MappingObjectData must be an hash reference!',
        );
        return;
    }

    # delete existing object mapping data
    $Self->MappingObjectDataDelete(
        MappingID => $Param{MappingID},
        UserID    => $Param{UserID},
    );

    DATAKEY:
    for my $DataKey ( keys %{ $Param{MappingObjectData} } ) {

        # quote
        my $QDataKey   = $Self->{DBObject}->Quote($DataKey);
        my $QDataValue = $Self->{DBObject}->Quote( $Param{MappingObjectData}->{$DataKey} );

        next DATAKEY if !defined $QDataKey;
        next DATAKEY if !defined $QDataValue;

        # insert one mapping object row
        $Self->{DBObject}->Do(
            SQL => "INSERT INTO imexport_mapping_object "
                . "(mapping_id, data_key, data_value) VALUES "
                . "($Param{MappingID}, '$QDataKey', '$QDataValue')"
        );
    }

    return 1;
}

=item MappingObjectDataGet()

get the object data of a mapping

    my $ObjectDataRef = $ImportExportObject->MappingObjectDataGet(
        MappingID => 123,
        UserID    => 1,
    );

=cut

sub MappingObjectDataGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(MappingID UserID)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!"
            );
            return;
        }
    }

    # quote
    $Param{MappingID} = $Self->{DBObject}->Quote( $Param{MappingID}, 'Integer' );

    # create sql string
    my $SQL = "SELECT data_key, data_value FROM imexport_mapping_object WHERE "
        . "mapping_id = $Param{MappingID}";

    # ask database
    $Self->{DBObject}->Prepare( SQL => $SQL );

    # fetch the result
    my %MappingObjectData;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $MappingObjectData{ $Row[0] } = $Row[1];
    }

    return \%MappingObjectData;
}

=item MappingFormatAttributesGet()

get the attributes of an format backend as array/hash reference

    my $Attributes = $ImportExportObject->MappingFormatAttributesGet(
        TemplateID => 123,
        UserID     => 1,
    );

=cut

sub MappingFormatAttributesGet {
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

    # check template data
    if ( !$TemplateData || !$TemplateData->{Format} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Template with ID $Param{TemplateID} not complete!",
        );
        return;
    }

    # load backend
    my $Backend = $Self->_LoadBackend(
        Module => "Kernel::System::ImportExport::FormatBackend::$TemplateData->{Format}",
    );

    return if !$Backend;

    # get an attribute list of the format
    my $Attributes = $Backend->MappingFormatAttributesGet(
        %Param,
        UserID => $Param{UserID},
    );

    return $Attributes;
}

=item MappingFormatDataDelete()

delete the existing format data of a mapping

    my $True = $ImportExportObject->MappingFormatDataDelete(
        MappingID => 123,
        UserID    => 1,
    );

    or

    my $True = $ImportExportObject->MappingFormatDataDelete(
        MappingID => [1,44,166,5],
        UserID    => 1,
    );

=cut

sub MappingFormatDataDelete {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(MappingID UserID)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!"
            );
            return;
        }
    }

    if ( !ref $Param{MappingID} ) {
        $Param{MappingID} = [ $Param{MappingID} ];
    }
    elsif ( ref $Param{MappingID} ne 'ARRAY' ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'MappingID must be an array reference or a string!',
        );
        return;
    }

    # quote
    for my $MappingID ( @{ $Param{MappingID} } ) {
        $MappingID = $Self->{DBObject}->Quote( $MappingID, 'Integer' );
    }

    # create the mapping id string
    my $MappingIDString = join ',', @{ $Param{MappingID} };

    # delete mapping format data
    return $Self->{DBObject}->Do(
        SQL => "DELETE FROM imexport_mapping_format WHERE mapping_id IN ( $MappingIDString )",
    );
}

=item MappingFormatDataSave()

save the format data of a mapping

    my $True = $ImportExportObject->MappingFormatDataSave(
        MappingID         => 123,
        MappingFormatData => $HashRef,
        UserID            => 1,
    );

=cut

sub MappingFormatDataSave {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(MappingID MappingFormatData UserID)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!"
            );
            return;
        }
    }

    if ( ref $Param{MappingFormatData} ne 'HASH' ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'MappingFormatData must be an hash reference!',
        );
        return;
    }

    # delete existing format mapping data
    $Self->MappingFormatDataDelete(
        MappingID => $Param{MappingID},
        UserID    => $Param{UserID},
    );

    DATAKEY:
    for my $DataKey ( keys %{ $Param{MappingFormatData} } ) {

        # quote
        my $QDataKey   = $Self->{DBObject}->Quote($DataKey);
        my $QDataValue = $Self->{DBObject}->Quote( $Param{MappingFormatData}->{$DataKey} );

        next DATAKEY if !defined $QDataKey;
        next DATAKEY if !defined $QDataValue;

        # insert one mapping format row
        $Self->{DBObject}->Do(
            SQL => "INSERT INTO imexport_mapping_format "
                . "(mapping_id, data_key, data_value) VALUES "
                . "($Param{MappingID}, '$QDataKey', '$QDataValue')"
        );
    }

    return 1;
}

=item MappingFormatDataGet()

get the format data of a mapping

    my $ObjectDataRef = $ImportExportObject->MappingFormatDataGet(
        MappingID => 123,
        UserID    => 1,
    );

=cut

sub MappingFormatDataGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(MappingID UserID)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!"
            );
            return;
        }
    }

    # quote
    $Param{MappingID} = $Self->{DBObject}->Quote( $Param{MappingID}, 'Integer' );

    # create sql string
    my $SQL = "SELECT data_key, data_value FROM imexport_mapping_format WHERE "
        . "mapping_id = $Param{MappingID}";

    # ask database
    $Self->{DBObject}->Prepare( SQL => $SQL );

    # fetch the result
    my %MappingFormatData;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $MappingFormatData{ $Row[0] } = $Row[1];
    }

    return \%MappingFormatData;
}

=item SearchAttributesGet()

get the search attributes of a object backend as array/hash reference

    my $Attributes = $ImportExportObject->SearchAttributesGet(
        TemplateID => 123,
        UserID     => 1,
    );

=cut

sub SearchAttributesGet {
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

    # check template data
    if ( !$TemplateData || !$TemplateData->{Object} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Template with ID $Param{TemplateID} not complete!",
        );
        return;
    }

    # load backend
    my $Backend = $Self->_LoadBackend(
        Module => "Kernel::System::ImportExport::ObjectBackend::$TemplateData->{Object}",
    );

    return if !$Backend;

    # get an search attribute list of an object
    my $Attributes = $Backend->SearchAttributesGet(
        %Param,
        UserID => $Param{UserID},
    );

    return $Attributes;
}

=item SearchDataGet()

get the search data from a template

    my $SearchDataRef = $ImportExportObject->SearchDataGet(
        TemplateID => 3,
        UserID     => 1,
    );

=cut

sub SearchDataGet {
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
    my $SQL = "SELECT data_key, data_value FROM imexport_search WHERE "
        . "template_id = $Param{TemplateID}";

    # ask database
    $Self->{DBObject}->Prepare( SQL => $SQL );

    # fetch the result
    my %SearchData;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $SearchData{ $Row[0] } = $Row[1];
    }

    return \%SearchData;
}

=item SearchDataSave()

save the search data of a template

    my $True = $ImportExportObject->SearchDataSave(
        TemplateID => 123,
        SearchData => $HashRef,
        UserID     => 1,
    );

=cut

sub SearchDataSave {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(TemplateID SearchData UserID)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!"
            );
            return;
        }
    }

    if ( ref $Param{SearchData} ne 'HASH' ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'SearchData must be an hash reference!',
        );
        return;
    }

    # delete existing search data
    $Self->SearchDataDelete(
        TemplateID => $Param{TemplateID},
        UserID     => $Param{UserID},
    );

    DATAKEY:
    for my $DataKey ( keys %{ $Param{SearchData} } ) {

        # quote
        my $QDataKey   = $Self->{DBObject}->Quote($DataKey);
        my $QDataValue = $Self->{DBObject}->Quote( $Param{SearchData}->{$DataKey} );

        next DATAKEY if !$QDataKey;
        next DATAKEY if !$QDataValue;

        # insert one row
        $Self->{DBObject}->Do(
            SQL => "INSERT INTO imexport_search "
                . "(template_id, data_key, data_value) VALUES "
                . "($Param{TemplateID}, '$QDataKey', '$QDataValue')"
        );
    }

    return 1;
}

=item SearchDataDelete()

delete the existing search data of a template

    my $True = $ImportExportObject->SearchDataDelete(
        TemplateID => 123,
        UserID     => 1,
    );

    or

    my $True = $ImportExportObject->SearchDataDelete(
        TemplateID => [1,44,166,5],
        UserID     => 1,
    );

=cut

sub SearchDataDelete {
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
        SQL => "DELETE FROM imexport_search WHERE template_id IN ( $TemplateIDString )",
    );
}

=item Export()

export function

    my $ResultRef = $ImportExportObject->Export(
        TemplateID => 123,
        UserID     => 1,
    );

=cut

sub Export {
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

    # get template data
    my $TemplateData = $Self->TemplateGet(
        TemplateID => $Param{TemplateID},
        UserID     => $Param{UserID},
    );

    # check template data
    if ( !$TemplateData || !$TemplateData->{Object} || !$TemplateData->{Format} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Template with ID $Param{TemplateID} not complete!",
        );
        return;
    }

    # load object backend
    my $ObjectBackend = $Self->_LoadBackend(
        Module => "Kernel::System::ImportExport::ObjectBackend::$TemplateData->{Object}",
    );

    return if !$ObjectBackend;

    # load format backend
    my $FormatBackend = $Self->_LoadBackend(
        Module => "Kernel::System::ImportExport::FormatBackend::$TemplateData->{Format}",
    );

    return if !$FormatBackend;

    # get export data
    my $ExportData = $ObjectBackend->ExportDataGet(
        TemplateID => $Param{TemplateID},
        UserID     => $Param{UserID},
    );

    my %Result;
    $Result{Success}            = 0;
    $Result{Failed}             = 0;
    $Result{DestinationContent} = [];

    EXPORTDATAROW:
    for my $ExportDataRow ( @{$ExportData} ) {

        # export one row
        my $DestinationContentRow = $FormatBackend->ExportDataSave(
            TemplateID    => $Param{TemplateID},
            ExportDataRow => $ExportDataRow,
            UserID        => $Param{UserID},
        );

        if ( !defined $DestinationContentRow ) {
            $Result{Failed}++;
            next EXPORTDATAROW;
        }

        # add row to destination content
        push @{ $Result{DestinationContent} }, $DestinationContentRow;
        $Result{Success}++;
    }

    return \%Result;
}

=item Import()

import function

    my $ResultRef = $ImportExportObject->Import(
        TemplateID    => 123,
        SourceContent => $StringRef,  # (optional)
        UserID        => 1,
    );

=cut

sub Import {
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

    # get template data
    my $TemplateData = $Self->TemplateGet(
        TemplateID => $Param{TemplateID},
        UserID     => $Param{UserID},
    );

    # check template data
    if ( !$TemplateData || !$TemplateData->{Object} || !$TemplateData->{Format} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Template with ID $Param{TemplateID} not complete!",
        );
        return;
    }

    # load object backend
    my $ObjectBackend = $Self->_LoadBackend(
        Module => "Kernel::System::ImportExport::ObjectBackend::$TemplateData->{Object}",
    );

    return if !$ObjectBackend;

    # load format backend
    my $FormatBackend = $Self->_LoadBackend(
        Module => "Kernel::System::ImportExport::FormatBackend::$TemplateData->{Format}",
    );

    return if !$FormatBackend;

    # get import data
    my $ImportData = $FormatBackend->ImportDataGet(
        TemplateID    => $Param{TemplateID},
        SourceContent => $Param{SourceContent},
        UserID        => $Param{UserID},
    );

    return if !$ImportData;

    my %Result;
    $Result{Success} = 0;
    $Result{Failed}  = 0;

    IMPORTDATAROW:
    for my $ImportDataRow ( @{$ImportData} ) {

        # import one row
        my $Success = $ObjectBackend->ImportDataSave(
            TemplateID    => $Param{TemplateID},
            ImportDataRow => $ImportDataRow,
            UserID        => $Param{UserID},
        );

        if ( !$Success ) {
            $Result{Failed}++;
            next IMPORTDATAROW;
        }

        $Result{Success}++;
    }

    return \%Result;
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

=item _StringClean()

DON'T USE THIS INTERNAL FUNCTION IN OTHER MODULES!

This function can be replaced with Kernel::System::CheckItem::StringClean() in OTRS 2.3 and later!

clean a given string

    my $Error = $CheckItemObject->_StringClean(
        StringRef         => \'String',
        TrimLeft          => 0,  # (optional) default 1
        TrimRight         => 0,  # (optional) default 1
        RemoveAllNewlines => 1,  # (optional) default 0
        RemoveAllTabs     => 1,  # (optional) default 0
        RemoveAllSpaces   => 1,  # (optional) default 0
    );

=cut

sub _StringClean {
    my ( $Self, %Param ) = @_;

    if ( !$Param{StringRef} || ref $Param{StringRef} ne 'SCALAR' ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need a scalar reference!'
        );
        return;
    }

    return 1 if !${ $Param{StringRef} };

    # set default values
    $Param{TrimLeft}  = defined $Param{TrimLeft}  ? $Param{TrimLeft}  : 1;
    $Param{TrimRight} = defined $Param{TrimRight} ? $Param{TrimRight} : 1;

    my %TrimAction = (
        RemoveAllNewlines => qr{ [\n\r\f] }xms,
        RemoveAllTabs     => qr{ \t       }xms,
        RemoveAllSpaces   => qr{ [ ]      }xms,
        TrimLeft          => qr{ \A \s+   }xms,
        TrimRight         => qr{ \s+ \z   }xms,
    );

    ACTION:
    for my $Action ( sort keys %TrimAction ) {
        next ACTION if !$Param{$Action};

        ${ $Param{StringRef} } =~ s{ $TrimAction{$Action} }{}xmsg;
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

$Revision: 1.23 $ $Date: 2008-04-04 10:19:24 $

=cut
