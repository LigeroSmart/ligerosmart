# --
# Kernel/System/CloneDB/Backend.pm - Interface for CloneDB backends
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
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
use Kernel::System::Package;
use Kernel::System::Time;
use Kernel::System::XML;

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
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Got no $Needed!"
            );
            return;
        }
        $Self->{$Needed} = $Param{$Needed};
    }

    $Self->{TimeObject} = Kernel::System::Time->new( %{$Self} );

    #
    # OTRS stores binary data in some columns. On some database systems,
    #   these are handled differently (data is converted to base64-encoding before
    #   it is stored. Here is the list of these columns which need special treatment.
    $Self->{BlobColumns} = $Self->{ConfigObject}->Get('CloneDB::BlobColumns');

    $Self->{CheckEncodingColumns} = $Self->{ConfigObject}->Get('CloneDB::CheckEncodingColumns');

    # create all registered backend modules
    for my $DBType (qw(mssql mysql oracle postgresql)) {

        my $BackendModule = 'Kernel::System::CloneDB::Driver::' . $DBType;

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
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Needed!"
            );
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
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Needed!"
            );
            return;
        }
    }

    # set the source db specific backend
    my $SourceDBBackend = 'CloneDB' . $Self->{SourceDBObject}->{'DB::Type'} . 'Object';

    if ( !$Self->{$SourceDBBackend} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Backend $Self->{SourceDBObject}->{'DB::Type'} is invalid!"
        );
        return;
    }

    # set the target db specific backend
    my $TargetDBBackend = 'CloneDB' . $Param{TargetDBObject}->{'DB::Type'} . 'Object';

    if ( !$Self->{$TargetDBBackend} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Backend $Param{TargetDBObject}->{'DB::Type'} is invalid!"
        );
        return;
    }

    # call DataTransfer on the specific backend
    my $DataTransfer = $Self->{$SourceDBBackend}->DataTransfer(
        TargetDBObject  => $Param{TargetDBObject},
        TargetDBBackend => $Self->{$TargetDBBackend},
        DryRun          => $Param{DryRun},
        Force           => $Param{Force},
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
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Needed!"
            );
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
        DryRun         => $Param{DryRun},
        Force          => $Param{Force},
    );

    return $SanityChecks;
}

sub _GenerateTargetStructuresSQL {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(TargetDBObject)) {
        if ( !$Param{$Needed} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Needed!"
            );
            return;
        }
    }

    $Self->PrintWithTime("Generating DDL for OTRS.\n");

    my $XMLObject = Kernel::System::XML->new(
        %{$Self},
        DBObject => $Param{TargetDBObject},
    );
    my $SQLDirectory = $Self->{ConfigObject}->Get('Home') . '/scripts/database';

    if ( !-f "$SQLDirectory/otrs-schema.xml" ) {
        die "SQL directory $SQLDirectory not found.";
    }

    my $XML = $Self->{MainObject}->FileRead(
        Directory => $SQLDirectory,
        Filename  => 'otrs-schema.xml',
    );
    my @XMLArray = $XMLObject->XMLParse(
        String => $XML,
    );
    $Self->{SQL} = [];
    push $Self->{SQL}, $Param{TargetDBObject}->SQLProcessor(
        Database => \@XMLArray,
    );
    $Self->{SQLPost} = [];
    push $Self->{SQLPost}, $Param{TargetDBObject}->SQLProcessorPost();

    my $PackageObject = Kernel::System::Package->new(
        %{$Self},
        DBObject => $Self->{SourceDBObject},    # this time we need the source
    );

    my @Packages = $PackageObject->RepositoryList();

    # first step: get the dependencies into a single hash,
    # so that the topological sorting goes faster
    my %ReverseDependencies;
    for my $Package (@Packages) {
        my $Dependencies = $Package->{PackageRequired} // [];

        for my $Dependency (@$Dependencies) {

            # undef happens to be the value that uses the least amount
            # of memory in Perl, and we are only interested in the keys
            $ReverseDependencies{ $Dependency->{Content} }->{ $Package->{Name}->{Content} } = undef;
        }
    }

    # second step: sort packages based on dependencies
    my $Sort = sub {
        if (
            exists $ReverseDependencies{ $a->{Name}->{Content} }
            && exists $ReverseDependencies{ $a->{Name}->{Content} }->{ $b->{Name}->{Content} }
            )
        {
            return -1;
        }
        if (
            exists $ReverseDependencies{ $b->{Name}->{Content} }
            && exists $ReverseDependencies{ $b->{Name}->{Content} }->{ $a->{Name}->{Content} }
            )
        {
            return 1;
        }
        return 0;
    };
    @Packages = sort { $Sort->() } @Packages;

    # loop all locally installed packages
    PACKAGE:
    for my $Package (@Packages) {
        $Self->PrintWithTime("Generating DDL for package $Package->{Name}->{Content}.\n");
        next PACKAGE if !$Package->{DatabaseInstall};

        TYPE:
        for my $Type (qw(pre post)) {
            next TYPE if !$Package->{DatabaseInstall}->{$Type};

            push $Self->{SQL}, $Param{TargetDBObject}->SQLProcessor(
                Database => $Package->{DatabaseInstall}->{$Type},
            );
            push $Self->{SQLPost}, $Param{TargetDBObject}->SQLProcessorPost();
        }
    }

    return;
}

sub PopulateTargetStructuresPre {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(TargetDBObject)) {
        if ( !$Param{$Needed} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Needed!"
            );
            return;
        }
    }

    $Self->_GenerateTargetStructuresSQL(%Param);

    $Self->PrintWithTime("Creating structures in target database (phase 1/2)");

    STATEMENT:
    for my $Statement ( @{ $Self->{SQL} } ) {
        next STATEMENT if $Statement =~ m{^INSERT}smxi;
        my $Result = $Param{TargetDBObject}->Do( SQL => $Statement );
        print '.';
        if ( !$Result ) {
            die
                "ERROR: Could not generate structures in target database!\nPlease make sure the target database is empty.\n";
        }
    }

    print " done.\n";

    return 1;
}

sub PopulateTargetStructuresPost {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(TargetDBObject)) {
        if ( !$Param{$Needed} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Needed!"
            );
            return;
        }
    }

    $Self->PrintWithTime("Creating structures in target database (phase 2/2)");

    for my $Statement ( @{ $Self->{SQLPost} } ) {
        next STATEMENT if $Statement =~ m{^INSERT}smxi;
        my $Result = $Param{TargetDBObject}->Do( SQL => $Statement );
        print '.';
        if ( !$Result ) {
            die "ERROR: Could not generate structures in target database!\n";
        }
    }

    print " done.\n";

    return 1;
}

sub PrintWithTime {
    my $Self = shift;

    my $TimeStamp = $Self->{TimeObject}->SystemTime2TimeStamp(
        SystemTime => $Self->{TimeObject}->SystemTime(),
    );

    print "[$TimeStamp] ", @_;
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
