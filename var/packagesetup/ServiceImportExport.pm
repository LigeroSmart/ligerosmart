# --
# ServiceImportExport.pm - code run during package de-/installation
# Copyright (C) 2006-2015 c.a.p.e. IT GmbH, http://www.cape-it.de
#
# written/edited by:
# * Torsten(dot)Thau(at)cape-it.de
# * Martin(dot)Balzarek(at)cape-it.de
# * Anna(dot)Litvinova(at)cape(dash)it(dot)de
# * Thomas(dot)Lange(at)cape(dash)it(dot)de
#
# --
# $Id: ServiceImportExport.pm,v 1.20 2015/11/17 05:44:19 tlange Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package var::packagesetup::ServiceImportExport;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::System::ImportExport',
    'Kernel::System::DynamicField',
    'Kernel::System::Service',
    'Kernel::System::SLA',
    'Kernel::System::Log',
    'Kernel::System::Main',
    'Kernel::Config'
);

=head1 NAME

ServiceImportExport.pm - code to excecute during package installation

=head1 SYNOPSIS

All functions

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create an object

    use Kernel::Config;
    use Kernel::System::Log;
    use Kernel::System::Main;
    use Kernel::System::Time;
    use Kernel::System::DB;
    use Kernel::System::XML;

    my $ConfigObject = Kernel::Config->new();
    my $LogObject    = Kernel::System::Log->new(
        ConfigObject => $ConfigObject,
    );
    my $MainObject = Kernel::System::Main->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
    );
    my $TimeObject = Kernel::System::Time->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
    );
    my $DBObject = Kernel::System::DB->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
        MainObject   => $MainObject,
    );
    my $XMLObject = Kernel::System::XML->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
        DBObject     => $DBObject,
        MainObject   => $MainObject,
    );
    my $CodeObject = var::packagesetup::ServiceImportExport.pm->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
        MainObject   => $MainObject,
        TimeObject   => $TimeObject,
        DBObject     => $DBObject,
        XMLObject    => $XMLObject,
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

=item CodeInstall()

run the code install part

    my $Result = $CodeObject->CodeInstall();

=cut

sub CodeInstall {
    my ( $Self, %Param ) = @_;

    $Self->_CreateMappings();

    return 1;
}

=item CodeReinstall()

run the code reinstall part

    my $Result = $CodeObject->CodeReinstall();

=cut

sub CodeReinstall {
    my ( $Self, %Param ) = @_;

    $Self->_CreateMappings();

    return 1;
}

=item CodeUpgrade()

run the code upgrade part

    my $Result = $CodeObject->CodeUpgrade();

=cut

sub CodeUpgrade {
    my ( $Self, %Param ) = @_;

    $Self->_CreateMappings();
    
    return 1;
}

=item CodeUninstall()

run the code uninstall part

    my $Result = $CodeObject->CodeUninstall();

=cut

sub CodeUninstall {
    my ( $Self, %Param ) = @_;

    $Self->_RemoveRelatedMappings();

    return 1;
}

sub _RemoveRelatedMappings () {

    my ( $Self, %Param ) = @_;

    my $TemplateList;
    my @TemplateObjects = ( 'Service', 'SLA', 'Service2CustomerUser' );
    my @TemplateObjectsSum;
    foreach my $TemplateObject (@TemplateObjects) {
        $TemplateList = $Kernel::OM->Get('Kernel::System::ImportExport')->TemplateList(
            Object => $TemplateObject,
            Format => 'CSV',
            UserID => 1,
        );
        @TemplateObjectsSum = ( @TemplateObjectsSum, @{$TemplateList} );
    }

    # delete the templates
    if ( ref($TemplateList) eq 'ARRAY' && @{$TemplateList} ) {
        $Kernel::OM->Get('Kernel::System::ImportExport')->TemplateDelete(
            TemplateID => \@TemplateObjectsSum,
            UserID     => 1,
        );
    }

    return 1;
}

sub _CreateMappings () {
    my ( $Self, %Param ) = @_;

    my $ImportExportMappingHash = undef;

    #---------------------------------------------------------------------------
    # SLA ...
    my %SLAPreferences     = ();
    my %SLAMappingPrefs    = ();
    my @SLAPreferencesKeys = qw{};
    my @MappingKeysSLA     = (
        'Name',              'Calendar',
        'Valid',             'Comment',
        'FirstResponseTime', 'FirstResponseNotify',
        'UpdateTime',        'UpdateNotify',
        'SolutionTime',      'SolutionNotify',
        'Type',              'MinTimeBetweenIncidents'
    );

    if ( $Kernel::OM->Get('Kernel::Config')->Get('SLAPreferences') ) {
        %SLAPreferences = %{ $Kernel::OM->Get('Kernel::Config')->Get('SLAPreferences') };
    }
    for my $Item ( sort keys %SLAPreferences ) {
        if (
            $SLAPreferences{$Item}->{SelectionSource}
            && $SLAPreferences{$Item}->{PrefKey} =~ /^(.+)ID$/
            )
        {
            my $NamePart = $1;
            $SLAMappingPrefs{$NamePart} = 1;
        }
        $SLAMappingPrefs{ $SLAPreferences{$Item}->{PrefKey} } = 1;
    }

    if ( keys(%SLAMappingPrefs) ) {
        @MappingKeysSLA = ( @MappingKeysSLA, keys(%SLAMappingPrefs) );
    }

    push( @MappingKeysSLA, 'AssignedService' );

    $ImportExportMappingHash->{SLA} = \@MappingKeysSLA;

    #---------------------------------------------------------------------------
    # Service ...
    my %ServicePreferences     = ();
    my %ServiceMappingPrefs    = ();
    my @ServicePreferencesKeys = qw{};
    my @MappingKeysService     = (
        'ServiceID', 'Name', 'NameShort',   'Valid',
        'Comment',   'Type', 'Criticality', 'CurInciState'
    );

    if ( $Kernel::OM->Get('Kernel::Config')->Get('ServicePreferences') ) {
        %ServicePreferences = %{ $Kernel::OM->Get('Kernel::Config')->Get('ServicePreferences') };
    }
    for my $Item ( sort keys %ServicePreferences ) {
        if (
            $ServicePreferences{$Item}->{SelectionSource}
            && $ServicePreferences{$Item}->{PrefKey} =~ /^(.+)ID$/
            )
        {
            my $NamePart = $1;
            $ServiceMappingPrefs{$NamePart} = 1;
        }
        $ServiceMappingPrefs{ $ServicePreferences{$Item}->{PrefKey} } = 1;
    }

    if ( keys(%ServiceMappingPrefs) ) {
        @MappingKeysService = ( @MappingKeysService, keys(%ServiceMappingPrefs) );
    }

    $ImportExportMappingHash->{Service} = \@MappingKeysService;

    #---------------------------------------------------------------------------
    # Service2CustomerUser ...
    $ImportExportMappingHash->{Service2CustomerUser} =
        [ 'CustomerUserLogin', 'ServiceName', 'ServiceID', 'AssignmentActive' ];

    #---------------------------------------------------------------------------
    # create mappings...
    for my $ObjectMappingKey ( keys %{$ImportExportMappingHash} ) {

        my $TemplateName = $ObjectMappingKey . " (auto-created map)";
        my %TemplateList = ();

        # get config option
        my $ForceCSVMappingConfiguration = $Kernel::OM->Get('Kernel::Config')->Get(
            'ImportExport::ServiceImportExport::ForceCSVMappingRecreation'
        ) || '0';

        # get list of all templates
        my $TemplateListRef = $Kernel::OM->Get('Kernel::System::ImportExport')->TemplateList(
            Object => $ObjectMappingKey,
            Format => 'CSV',
            UserID => 1,
        );

        # get data for each template and build hash with key = template name; value = template ID
        if ( $TemplateListRef && ref($TemplateListRef) eq 'ARRAY' ) {
            for my $CurrTemplateID ( @{$TemplateListRef} ) {
                my $TemplateDataRef = $Kernel::OM->Get('Kernel::System::ImportExport')->TemplateGet(
                    TemplateID => $CurrTemplateID,
                    UserID     => 1,
                );
                if (
                    $TemplateDataRef
                    && ref($TemplateDataRef) eq 'HASH'
                    && $TemplateDataRef->{Object}
                    && $TemplateDataRef->{Name}
                    )
                {
                    $TemplateList{ $TemplateDataRef->{Object} . '::' . $TemplateDataRef->{Name} }
                        = $CurrTemplateID;
                }
            }
        }

        # add a template
        my $TemplateID;

        # check if template already exists...
        if ( $TemplateList{ $ObjectMappingKey . '::' . $TemplateName } ) {
            if ($ForceCSVMappingConfiguration) {

                # delete old template
                $Kernel::OM->Get('Kernel::System::ImportExport')->TemplateDelete(
                    TemplateID => $TemplateList{ $ObjectMappingKey . '::' . $TemplateName },
                    UserID     => 1,
                );
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'notice',
                    Message  => "CSV mapping deleted for re-creation <"
                        . $TemplateName
                        . ">.",
                );

                # create new template
                $TemplateID = $Kernel::OM->Get('Kernel::System::ImportExport')->TemplateAdd(
                    Object  => $ObjectMappingKey,
                    Format  => 'CSV',
                    Name    => $TemplateName,
                    Comment => "Automatically created during ServiceImportExport installation",
                    ValidID => 1,
                    UserID  => 1,
                );
            }
            else {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  => "CSV mapping already exists and not re-created <"
                        . $TemplateName
                        . ">.",
                );
                next;
            }
        }
        else {

            # create new template
            $TemplateID = $Kernel::OM->Get('Kernel::System::ImportExport')->TemplateAdd(
                Object  => $ObjectMappingKey,
                Format  => 'CSV',
                Name    => $TemplateName,
                Comment => "Automatically created during ServiceImportExport installation",
                ValidID => 1,
                UserID  => 1,
            );
        }

        if ( !$TemplateID ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Could not add mapping for object $ObjectMappingKey",
            );
            next;
        }

        my $ServiceMappingData = {
            SourceServiceData => {
                FormatData => {
                    ColumnSeparator => 'Semicolon',
                    Charset         => 'UTF-8',
                },
                ServiceDataGet => {
                    TemplateID => $TemplateID,
                    UserID     => 1,
                },
            },
        };

        # get object attributes
        my $ObjectAttributeList = $Kernel::OM->Get('Kernel::System::ImportExport')->ObjectAttributesGet(
            TemplateID => $ServiceMappingData->{SourceServiceData}->{ServiceDataGet}
                ->{TemplateID},
            UserID => 1,
        );

        my $AttributeValues;

        for my $Default ( @{$ObjectAttributeList} ) {

            # set sla types
            if (
                $ObjectMappingKey  eq 'SLA'
                && $Default->{Key} eq 'DefaultSLATypeID'
                )
            {
                if ( $Kernel::OM->Get('Kernel::System::Main')->Require('Kernel::System::GeneralCatalog') ) {
                    $Self->{GeneralCatalogObject} = Kernel::System::GeneralCatalog->new( %{$Self} );

                    if ( $Self->{GeneralCatalogObject} ) {

                        # get SLA type list
                        $Self->{SLATypeList} = $Self->{GeneralCatalogObject}->ItemList(
                            Class => 'ITSM::SLA::Type',
                        );

                        if ( $Self->{SLATypeList} && ref( $Self->{SLATypeList} ) eq 'HASH' ) {
                            my %TmpHash = reverse( %{ $Self->{SLATypeList} } );
                            $Self->{ReverseSLATypeList} = \%TmpHash;
                        }
                    }
                }
                my $SLATypeID;
                for my $ID ( keys %{ $Self->{SLATypeList} } ) {
                    $SLATypeID = $Self->{SLATypeList}->{$ID};
                    if ( $Self->{SLATypeList}->{$ID} eq 'Other' ) {
                        $SLATypeID = $ID;
                        last;
                    }
                }

                $AttributeValues->{ $Default->{Key} } = $SLATypeID;
                next;
            }

            # set service types
            if ( $ObjectMappingKey eq 'Service' ) {
                my $CriticalityID;
                my $ServiceTypeID;
                if ( $Self->{GeneralCatalogObject} ) {

                    # get service type list
                    $Self->{ServiceTypeList} = $Self->{GeneralCatalogObject}->ItemList(
                        Class => 'ITSM::Service::Type',
                    );

                    if ( $Self->{ServiceTypeList} && ( ref( $Self->{ServiceTypeList} ) eq 'HASH' ) )
                    {
                        my %TmpHash = reverse( %{ $Self->{ServiceTypeList} } );
                        $Self->{ReverseServiceTypeList} = \%TmpHash;
                    }

                    # get criticality list
                    my $ITSMCriticality = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldGet(
                        Name => 'ITSMCriticality',
                    );
                    if ( $ITSMCriticality && $ITSMCriticality->{'FieldType'} eq 'Dropdown' && $ITSMCriticality->{'ObjectType'} eq 'Ticket' ) {
                        $Self->{CriticalityList} = $ITSMCriticality->{'Config'}->{'PossibleValues'};
                        my %TmpHash2 = reverse( %{ $Self->{CriticalityList} } );
                        $Self->{ReverseCriticalityList} = \%TmpHash2;
                    }
                }

                if ( $Default->{Key} eq 'DefaultCriticalityID' ) {
                    for my $ID ( keys %{ $Self->{CriticalityList} } ) {

                        if ( $Self->{CriticalityList}->{$ID} =~ /normal/ ) {
                            $CriticalityID = $ID;
                            last;
                        }
                    }

                    $AttributeValues->{ $Default->{Key} } = $CriticalityID;
                    next;
                }
                if ( $Default->{Key} eq 'DefaultServiceTypeID' ) {
                    for my $ID ( keys %{ $Self->{ServiceTypeList} } ) {
                        $ServiceTypeID = $Self->{ServiceTypeList}->{$ID};
                        if ( $Self->{ServiceTypeList}->{$ID} eq 'Other' ) {
                            $ServiceTypeID = $ID;
                            last;
                        }
                    }

                    $AttributeValues->{ $Default->{Key} } = $ServiceTypeID;
                    next;
                }
            }
            $AttributeValues->{ $Default->{Key} } = $Default->{Input}->{ValueDefault};
        }

        $ServiceMappingData->{SourceServiceData}->{ObjectData} = $AttributeValues;

        my $DefaultNumberOfAssignableServices =
            $ServiceMappingData->{SourceServiceData}->{ObjectData}
            ->{NumberOfAssignableServices};

        my $i = 0;
        my @MappingObjData;
        for my $Key ( @{ $ImportExportMappingHash->{$ObjectMappingKey} } ) {

            my %MappingObjectDataHash;
            $MappingObjectDataHash{Key} =
                $ImportExportMappingHash->{$ObjectMappingKey}->[$i];
            if ( $i == 0 ) {
                $MappingObjectDataHash{Identifier} = 1;
            }
            if ( $Key eq 'Valid' && !$AttributeValues->{DefaultValid} ) {
                next;
            }

            if ( $Key eq 'AssignedService' ) {
                for (
                    my $Count = 0;
                    $Count < $DefaultNumberOfAssignableServices;
                    $Count++
                    )
                {
                    my %MappingObjectDataHashLocal = ();
                    $MappingObjectDataHashLocal{Key} =
                        'AssignedService' . sprintf( '%03s', $Count );
                    push( @MappingObjData, \%MappingObjectDataHashLocal );
                }
            }
            else {
                push( @MappingObjData, \%MappingObjectDataHash );
            }

            $i++;
        }

        $ServiceMappingData->{SourceServiceData}->{MappingObjectData} =
            \@MappingObjData;

        if (
            !$ServiceMappingData
            || ref $ServiceMappingData ne 'HASH'
            )
        {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message =>
                    "No valid mapping list found for template id $TemplateID",
            );
            return;
        }

        # set the object data
        if (
            $ServiceMappingData->{SourceServiceData}->{ObjectData}
            && ref $ServiceMappingData->{SourceServiceData}->{ObjectData} eq 'HASH'
            && $ServiceMappingData->{SourceServiceData}->{ServiceDataGet}
            ->{TemplateID}
            )
        {

            # save object data
            $Kernel::OM->Get('Kernel::System::ImportExport')->ObjectDataSave(
                TemplateID =>
                    $ServiceMappingData->{SourceServiceData}->{ServiceDataGet}
                    ->{TemplateID},
                ObjectData =>
                    $ServiceMappingData->{SourceServiceData}->{ObjectData},
                UserID => 1,
            );
        }

        # set the format data
        if (
            $ServiceMappingData->{SourceServiceData}->{FormatData}
            && ref $ServiceMappingData->{SourceServiceData}->{FormatData} eq 'HASH'
            && $ServiceMappingData->{SourceServiceData}->{ServiceDataGet}
            ->{TemplateID}
            )
        {

            # save format data
            $Kernel::OM->Get('Kernel::System::ImportExport')->FormatDataSave(
                TemplateID =>
                    $ServiceMappingData->{SourceServiceData}->{ServiceDataGet}
                    ->{TemplateID},
                FormatData =>
                    $ServiceMappingData->{SourceServiceData}->{FormatData},
                UserID => 1,
            );
        }

        # set the mapping object data
        if (
            $ServiceMappingData->{SourceServiceData}->{ObjectData}

            #&& ref $ServiceMappingData->{MappingObjectData} eq 'ARRAY'
            && $ServiceMappingData->{SourceServiceData}->{ServiceDataGet}
            ->{TemplateID}
            )
        {

            # delete all existing mapping data
            $Kernel::OM->Get('Kernel::System::ImportExport')->MappingDelete(
                TemplateID =>
                    $ServiceMappingData->{SourceServiceData}->{ServiceDataGet}
                    ->{TemplateID},
                UserID => 1,
            );

            # add the mapping object rows

            for my $MappingObjectData (
                @{ $ServiceMappingData->{SourceServiceData}->{MappingObjectData} }
                )
            {

                # add a new mapping row
                my $MappingID = $Kernel::OM->Get('Kernel::System::ImportExport')->MappingAdd(
                    TemplateID =>
                        $ServiceMappingData->{SourceServiceData}->{ServiceDataGet}
                        ->{TemplateID},
                    UserID => 1,
                );

                # add the mapping object data
                $Kernel::OM->Get('Kernel::System::ImportExport')->MappingObjectDataSave(
                    MappingID         => $MappingID,
                    MappingObjectData => $MappingObjectData,
                    UserID            => 1,
                );
            }
        }
    }

    return 1;
}

1;