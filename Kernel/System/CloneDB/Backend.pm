# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::CloneDB::Backend;

use strict;
use warnings;

use Scalar::Util qw(weaken);
use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::DB',
    'Kernel::System::Log',
    'Kernel::System::Main',
    'Kernel::System::Package',
    'Kernel::System::DateTime',
    'Kernel::System::XML',
);

=head1 NAME

Kernel::System::CloneDB::Backend

=head1 SYNOPSIS

DynamicFields backend interface

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create a CloneDB backend object

    use Kernel::System::ObjectManager;
    local $Kernel::OM = Kernel::System::ObjectManager->new();

    my $CloneDBBackendObject = $Kernel::OM->Get('Kernel::System::CloneDB::Backend');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # OTRS stores binary data in some columns. On some database systems,
    #   these are handled differently (data is converted to base64-encoding before
    #   it is stored. Here is the list of these columns which need special treatment.
    $Self->{BlobColumns}          = $ConfigObject->Get('CloneDB::BlobColumns');
    $Self->{CheckEncodingColumns} = $ConfigObject->Get('CloneDB::CheckEncodingColumns');

    # get main object
    my $MainObject = $Kernel::OM->Get('Kernel::System::Main');

    # create all registered backend modules
    for my $DBType (qw(mssql mysql oracle postgresql)) {

        my $BackendModule = 'Kernel::System::CloneDB::Driver::' . $DBType;

        # check if database backend exists
        if ( !$MainObject->Require($BackendModule) ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Can't load Clone DB backend module for DBMS $DBType!",
            );

            return;
        }

        # sanity action
        $Kernel::OM->ObjectsDiscard(
            Objects => [$BackendModule],
        );

        $Kernel::OM->ObjectParamAdd(
            $BackendModule => {
                BlobColumns          => $Self->{BlobColumns},
                CheckEncodingColumns => $Self->{CheckEncodingColumns},
            },
        );

        # create a backend object
        my $BackendObject = $Kernel::OM->Get($BackendModule);

        if ( !$BackendObject ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
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
    if ( !$Param{TargetDBSettings} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need TargetDBSettings!",
        );

        return;
    }

    # check TargetDBSettings (internally)
    for my $Needed (
        qw(TargetDatabaseHost TargetDatabase TargetDatabaseUser TargetDatabasePw TargetDatabaseType)
        )
    {
        if ( !$Param{TargetDBSettings}->{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed in TargetDBSettings!",
            );

            return;
        }
    }

    # set the clone db specific backend
    my $CloneDBBackend = 'CloneDB' . $Param{TargetDBSettings}->{TargetDatabaseType} . 'Object';

    if ( !$Self->{$CloneDBBackend} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Backend $Param{TargetDBSettings}->{TargetDatabaseType} is invalid!",
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
    if ( !$Param{TargetDBObject} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need TargetDBObject!",
        );

        return;
    }

    # set the source db specific backend
    my $SourceDBBackend = 'CloneDB' . $Kernel::OM->Get('Kernel::System::DB')->{'DB::Type'} . 'Object';

    if ( !$Self->{$SourceDBBackend} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Backend " . $Kernel::OM->Get('Kernel::System::DB')->{'DB::Type'} . " is invalid!",
        );

        return;
    }

    # set the target db specific backend
    my $TargetDBBackend = 'CloneDB' . $Param{TargetDBObject}->{'DB::Type'} . 'Object';

    if ( !$Self->{$TargetDBBackend} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Backend $Param{TargetDBObject}->{'DB::Type'} is invalid!",
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

perform some sanity check before db cloning.

    my $SuccessSanityChecks = $BackendObject->SanityChecks(
        TargetDBObject => $TargetDBObject, # mandatory
    );

=cut

sub SanityChecks {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{TargetDBObject} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need TargetDBObject!",
        );

        return;
    }

    # set the clone db specific backend
    my $CloneDBBackend = 'CloneDB' . $Kernel::OM->Get('Kernel::System::DB')->{'DB::Type'} . 'Object';

    if ( !$Self->{$CloneDBBackend} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Backend " . $Kernel::OM->Get('Kernel::System::DB')->{'DB::Type'} . " is invalid!",
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

    # check needed stuff
    if ( !$Param{TargetDBObject} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need TargetDBObject!",
        );

        return;
    }

    $Self->PrintWithTime("Generating DDL for OTRS.\n");

    # SourceDBObject get data
    my $SQLDirectory = $Kernel::OM->Get('Kernel::Config')->Get('Home') . '/scripts/database';

    if ( !-f "$SQLDirectory/otrs-schema.xml" ) {
        die "SQL directory $SQLDirectory not found.";
    }

    # keep next lines here due this time we need the source db object
    # get repository list
    my @Packages = $Kernel::OM->Get('Kernel::System::Package')->RepositoryList();

    # attention!!!
    # switch database object to target object to use the xml
    # object of the target database
    $Kernel::OM->ObjectsDiscard(
        Objects => [
            'Kernel::System::DB',
            'Kernel::System::XML',
        ],
    );
    $Kernel::OM->ObjectInstanceRegister(
        Package => 'Kernel::System::DB',
        Object  => $Param{TargetDBObject},
    );

    my $XMLObject = $Kernel::OM->Get('Kernel::System::XML');    # of target database

    # get XML structure
    my $XML = $Kernel::OM->Get('Kernel::System::Main')->FileRead(
        Directory => $SQLDirectory,
        Filename  => 'otrs-schema.xml',
    );
    my @XMLArray = $XMLObject->XMLParse(
        String => $XML,
    );

    $Self->{SQL} = [];
    push @{ $Self->{SQL} }, $Param{TargetDBObject}->SQLProcessor(
        Database => \@XMLArray,
    );
    $Self->{SQLPost} = [];
    push @{ $Self->{SQLPost} }, $Param{TargetDBObject}->SQLProcessorPost();

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

            push @{ $Self->{SQL} }, $Param{TargetDBObject}->SQLProcessor(
                Database => $Package->{DatabaseInstall}->{$Type},
            );
            push @{ $Self->{SQLPost} }, $Param{TargetDBObject}->SQLProcessorPost();
        }
    }

    # discard objects of target database to switch back to source object
    $Kernel::OM->ObjectsDiscard(
        Objects => [
            'Kernel::System::DB',
            'Kernel::System::XML',
        ],
    );

    return;
}

sub PopulateTargetStructuresPre {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{TargetDBObject} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need TargetDBObject!",
        );
        return;
    }

    $Self->_GenerateTargetStructuresSQL(%Param);

    $Self->PrintWithTime("Creating structures in target database (phase 1/2)");

    STATEMENT:
    for my $Statement ( @{ $Self->{SQL} } ) {
        next STATEMENT if $Statement =~ m{^INSERT}smxi;
        my $Result = $Param{TargetDBObject}->Do( SQL => $Statement );
        print '.';
        if ( !$Result && !$Param{Force} ) {
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
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    $Self->PrintWithTime("Creating structures in target database (phase 2/2)");

    for my $Statement ( @{ $Self->{SQLPost} } ) {
        my $Result = $Param{TargetDBObject}->Do( SQL => $Statement );
        print '.';
        if ( !$Result ) {
            die "ERROR: Could not generate structures in target database!\n";
        }
    }

    print " done.\n";

    return 1;
}

sub PrintWithTime {    ## no critic
    my $Self = shift;

    # Get current timestamp.
    my $TimeStamp = $Kernel::OM->Create('Kernel::System::DateTime')->ToString();

    print "[$TimeStamp] ", @_;

    return 1;
}

=back

=cut

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<https://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
