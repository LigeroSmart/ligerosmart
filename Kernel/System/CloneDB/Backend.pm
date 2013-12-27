# --
# Kernel/System/CloneDB/Backend.pm - Interface for CloneDB backends
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::CloneDB::Backend;

use strict;
use warnings;

use Scalar::Util qw(weaken);
use Kernel::System::VariableCheck qw(:all);

=head1 NAME

Kernel::System::CloneDB::Backend

=head1 SYNOPSIS

DynamicFields backend interface

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create a CloneDB backend object

    use Kernel::Config;
    use Kernel::System::Encode;
    use Kernel::System::Log;
    use Kernel::System::Main;
    use Kernel::System::DB;
    use Kernel::System::CloneDB::Backend;

    my $ConfigObject = Kernel::Config->new();
    my $EncodeObject = Kernel::System::Encode->new(
        ConfigObject => $ConfigObject,
    );
    my $LogObject = Kernel::System::Log->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
    );
    my $MainObject = Kernel::System::Main->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
    );
    my $DBObject = Kernel::System::DB->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
        MainObject   => $MainObject,
    );
    my $CloneDBObject = Kernel::System::CloneDB::Backend->new(
        ConfigObject        => $ConfigObject,
        EncodeObject        => $EncodeObject,
        LogObject           => $LogObject,
        MainObject          => $MainObject,
        SourceDBObject      => $DBObject,
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get needed objects
    for my $Needed (qw(ConfigObject EncodeObject LogObject MainObject SourceDBObject)) {
        if ( !$Param{$Needed} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Got no $Needed!" );
            return;
        }
        $Self->{$Needed} = $Param{$Needed};
    }

    #
    # OTRS stores binary data in some columns. On some database systems,
    #   these are handled differently (data is converted to base64-encoding before
    #   it is stored. Here is the list of these columns which need special treatment.
    #
    $Self->{BlobColumns} = {
        'article_plain.body'          => 1,
        'article_attachment.content'  => 1,
        'virtual_fs_db.content'       => 1,
        'web_upload_cache.content'    => 1,
        'standard_attachment.content' => 1,
    };

    # get the Clone DB Backends configuration
    my $CloneDBConfig = $Self->{ConfigObject}->Get('CloneDB::Driver');

    # check Configuration format
    if ( !IsHashRefWithData($CloneDBConfig) ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Clone DB configuration is not valid!",
        );
        return;
    }

    # create all registered backend modules
    for my $DBType ( sort keys %{$CloneDBConfig} ) {

        # check if the registration for each database type is valid
        if ( !$CloneDBConfig->{$DBType}->{Module} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Registration for DBMS $DBType is invalid!",
            );
            return;
        }

        # set the backend file
        my $BackendModule = $CloneDBConfig->{$DBType}->{Module};

        # check if database backend exists
        if ( !$Self->{MainObject}->Require($BackendModule) ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Can't load Clone DB backend module for DBMS $DBType!",
            );
            return;
        }

        # create a backend object
        my $BackendObject = $BackendModule->new( %{$Self} );

        if ( !$BackendObject ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Couldn't create a backend object for DBMS $DBType!",
            );
            return;
        }

        if ( ref $BackendObject ne $BackendModule ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Backend object for DBMS $DBType was not created successfuly!",
            );
            return;
        }

        # remember the backend object
        $Self->{ 'CloneDB' . $DBType . 'Object' } = $BackendObject;
    }

    return $Self;
}

=item CreateTargetDBConnection()

creates the target db object.

    my $Success = $BackendObject->CreateTargetDBConnection(
        TargetDBSettings             => $TargetDBSettings, # a hash refs including target DB settings
    );

=cut

sub CreateTargetDBConnection {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(TargetDBSettings)) {
        if ( !$Param{$Needed} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $Needed!" );
            return;
        }
    }

    # check TargetDBSettings (internally)
    for my $Needed (
        qw(TargetDatabaseHost TargetDatabase TargetDatabaseUser TargetDatabasePw TargetDatabaseType)
        )
    {
        if ( !$Param{TargetDBSettings}->{$Needed} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Needed in TargetDBSettings!"
            );
            return;
        }
    }

    # set the clone db specific backend
    my $CloneDBBackend = 'CloneDB' . $Param{TargetDBSettings}->{TargetDatabaseType} . 'Object';

    if ( !$Self->{$CloneDBBackend} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Backend $Param{TargetDBSettings}->{TargetDatabaseType} is invalid!"
        );
        return;
    }

    # call CreateTargetDBConnection on the specific backend
    my $TargetDBConnection = $Self->{$CloneDBBackend}->CreateTargetDBConnection(
        %{ $Param{TargetDBSettings} },
    );

    return $TargetDBConnection;
}

=item DataTransfer()

transfers information from a source DB to the Target DB.

    my $Success = $BackendObject->DataTransfer(
        TargetDBObject => $TargetDBObject, # mandatory
    );

=cut

sub DataTransfer {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(TargetDBObject)) {
        if ( !$Param{$Needed} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $Needed!" );
            return;
        }
    }

    # set the source db specific backend
    my $CloneDBBackend = 'CloneDB' . $Self->{SourceDBObject}->{'DB::Type'} . 'Object';

    if ( !$Self->{$CloneDBBackend} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Backend $Self->{SourceDBObject}->{'DB::Type'} is invalid!"
        );
        return;
    }

    # call DataTransfer on the specific backend
    my $DataTransfer = $Self->{$CloneDBBackend}->DataTransfer(
        TargetDBObject => $Param{TargetDBObject},
    );

    return $DataTransfer;
}

=item SanityChecks()

perform some sanity check befor db cloning.

    my $SuccessSanityChecks = $BackendObject->SanityChecks(
        TargetDBObject => $TargetDBObject, # mandatory
    );

=cut

sub SanityChecks {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(TargetDBObject)) {
        if ( !$Param{$Needed} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $Needed!" );
            return;
        }
    }

    # set the clone db specific backend
    my $CloneDBBackend = 'CloneDB' . $Self->{SourceDBObject}->{'DB::Type'} . 'Object';

    if ( !$Self->{$CloneDBBackend} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Backend $Self->{SourceDBObject}->{'DB::Type'} is invalid!"
        );
        return;
    }

    # perform sanity checks
    my $SanityChecks = $Self->{$CloneDBBackend}->SanityChecks(
        TargetDBObject => $Param{TargetDBObject},
    );

    return $SanityChecks;
}

=back

=cut

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
