# --
# DynamicFieldITSMConfigItem.pm - code run during package de-/installation
# Copyright (C) 2006-2016 c.a.p.e. IT GmbH, http://www.cape-it.de
#
# written/edited by:
# * Torsten(dot)Thau(at)cape(dash)it(dot)de
# * Anna(dot)Litvinova(at)cape(dash)it(dot)de
#
# --
# $Id: DynamicFieldITSMConfigItem.pm,v 1.10 2016/06/30 05:46:14 millinger Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package var::packagesetup::DynamicFieldITSMConfigItem;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);
use List::Util qw(min);

our @ObjectDependencies = (
    'Kernel::System::DynamicField',
    'Kernel::System::GeneralCatalog',
    'Kernel::System::GenericAgent',
    'Kernel::System::Log',
    'Kernel::System::SysConfig',
    'Kernel::System::Valid',
);

=head1 NAME

CordesGraefe.pm - code to excecute during package installation

=head1 SYNOPSIS

All functions

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create an object

=cut

sub new {
    my ( $Type, %Param ) = @_;
    my $Self = {};
    bless( $Self, $Type );

    # create additional objects...
    $Self->{DynamicFieldObject}   = $Kernel::OM->Get('Kernel::System::DynamicField');
    $Self->{GeneralCatalogObject} = $Kernel::OM->Get('Kernel::System::GeneralCatalog');
    $Self->{GenericAgentObject}   = $Kernel::OM->Get('Kernel::System::GenericAgent');
    $Self->{LogObject}            = $Kernel::OM->Get('Kernel::System::Log');
    $Self->{ValidObject}          = $Kernel::OM->Get('Kernel::System::Valid');

    # define valid list
    my %Validlist = $Self->{ValidObject}->ValidList();
    my %TmpHash2  = reverse(%Validlist);
    $Self->{ReverseValidList} = \%TmpHash2;
    $Self->{ValidList}        = \%Validlist;

    return $Self;
}

=item CodeInstall()

run the code install part

    my $Result = $CodeObject->CodeInstall();

=cut

sub CodeInstall {
    my ( $Self, %Param ) = @_;

    return 1;
}

=item CodeReinstall()

run the code reinstall part

    my $Result = $CodeObject->CodeReinstall();

=cut

sub CodeReinstall {
    my ( $Self, %Param ) = @_;

    return 1;
}

=item CodeUpgrade()

run the code upgrade part

    my $Result = $CodeObject->CodeUpgrade();

=cut

sub CodeUpgrade {
    my ( $Self, %Param ) = @_;

    return 1;
}

=item CodeUpgrade_5()

run the code upgrade part for versions before framework 5

    my $Result = $CodeObject->CodeUpgrade();

=cut

sub CodeUpgrade_5 {
    my ( $Self, %Param ) = @_;

    # migrate old configuration
    $Self->_MigrateConfigBefore5();

    return 1;
}

=item CodeUninstall()

run the code uninstall part

    my $Result = $CodeObject->CodeUninstall();

=cut

sub CodeUninstall {
    my ( $Self, %Param ) = @_;

    # remove Dynamic Fields and its values
    $Self->_DynamicFieldsDelete();

    return 1;
}

#-------------------------------------------------------------------------------
# Internal functions

=item _DynamicFieldsDelete()

delete all existing dynamic fields

    my $Result = $CodeObject->_DynamicFieldsDelete();

=cut

sub _DynamicFieldsDelete {
    my ( $Self, %Param ) = @_;

    my $DynamicFieldObject      = $Kernel::OM->Get('Kernel::System::DynamicField');
    my $DynamicFieldValueObject = $Kernel::OM->Get('Kernel::System::DynamicFieldValue');

    # get the list of dynamic fields (valid and invalid ones)
    my $DynamicFieldList = $DynamicFieldObject->DynamicFieldListGet(
        Valid      => 0,
    );

    # delete the dynamic fields
    DYNAMICFIELD:
    for my $DynamicField ( @{$DynamicFieldList} ) {
        next DYNAMICFIELD if (
            $DynamicField->{FieldType} ne 'ITSMConfigItemReference'
        );

        # delete all field values
        my $ValuesDeleteSuccess = $DynamicFieldValueObject->AllValuesDelete(
            FieldID => $DynamicField->{ID},
            UserID  => 1,
        );

        # values could be deleted
        if ($ValuesDeleteSuccess) {

            # delete field
            my $Success = $DynamicFieldObject->DynamicFieldDelete(
                ID     => $DynamicField->{ID},
                UserID => 1,
            );

            # check error
            if ( !$Success ) {
                $Self->{LogObject}->Log(
                    Priority => 'error',
                    Message  => "Could not delete dynamic field '$DynamicField->{Name}'!",
                );
            }
        }

        # values could not be deleted
        else {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Could not delete values for dynamic field '$DynamicField->{Name}'!",
            );
        }
    }

    return 1;
}

sub _MigrateConfigBefore5 {
    my ( $Self, %Param ) = @_;

    # get dynamic fields
    my $List = $Self->{DynamicFieldObject}->DynamicFieldList(
        Valid => 0,
        ObjectType => ['Ticket', 'Article'],
        ResultType => 'ARRAY',
    );

    my @RelevantFields = ();
    # process dynamic fields
    DYNAMICFIELD:
    for my $DynamicFieldID ( @{$List} ) {
        # get dynamic field
        my $DynamicField = $Self->{DynamicFieldObject}->DynamicFieldGet(
            ID => $DynamicFieldID,
        );

        next DYNAMICFIELD if (
            $DynamicField->{FieldType} ne 'ITSMConfigItemReference'
            && $DynamicField->{FieldType} ne 'ITSMConfigItemReferenceArray'
        );

        push( @RelevantFields, $DynamicField->{Name} );

        if ( defined( $DynamicField->{Config}->{DefaultValue} ) ) {
            $DynamicField->{Config}->{DefaultValues} = [];
            push( @{$DynamicField->{Config}->{DefaultValues}}, $DynamicField->{Config}->{DefaultValue} );
            delete( $DynamicField->{Config}->{DefaultValue} );
        }

        if ( exists( $DynamicField->{Config}->{PossibleNone} ) ) {
            delete( $DynamicField->{Config}->{PossibleNone} );
        }

        $DynamicField->{Config}->{AgentLink} =~ s/\$[LQ]*Data\{"Key"\}/<CI_ConfigItemID>/g;
        $DynamicField->{Config}->{AgentLink} =~ s/\$QEnv\{"SessionID"\}/<SessionID>/g;

        $DynamicField->{Config}->{CustomerLink} =~ s/\$[LQ]*Data\{"Key"\}/<CI_ConfigItemID>/g;
        $DynamicField->{Config}->{CustomerLink} =~ s/\$QEnv\{"SessionID"\}/<SessionID>/g;

        if ( exists( $DynamicField->{Config}->{ITSMConfigItemClass} ) ) {
            $DynamicField->{Config}->{ITSMConfigItemClasses} = [];
            push( @{$DynamicField->{Config}->{ITSMConfigItemClasses}}, $DynamicField->{Config}->{ITSMConfigItemClass} );
            delete( $DynamicField->{Config}->{ITSMConfigItemClass} );
        }

        if ( ref( $DynamicField->{Config}->{DeploymentStates} ) eq 'SCALAR' ) {
            $DynamicField->{Config}->{DeploymentStates} = [];
            my $TempDeploymentStates = $DynamicField->{Config}->{DeploymentStates};
            my $DeplStates = $Self->{GeneralCatalogObject}->ItemList(
                Class => 'ITSM::ConfigItem::DeploymentState',
            );
            for my $State ( keys %{$DeplStates} ) {
                push( @{$DynamicField->{Config}->{DeploymentStates}}, $State ) if( $TempDeploymentStates =~ /$DeplStates->{$State}/ );
            }
        }

        if ( defined( $DynamicField->{Config}->{DisplayType} ) ) {
            if (  $DynamicField->{Config}->{DisplayType} eq 'CIName' ) {
                $DynamicField->{Config}->{DisplayPattern} = '<CI_Name>';
            }
            elsif (  $DynamicField->{Config}->{DisplayType} eq 'CINumber' ) {
                $DynamicField->{Config}->{DisplayPattern} = '<CI_Number>';
            }
            elsif (  $DynamicField->{Config}->{DisplayType} eq 'CINameNumber' ) {
                $DynamicField->{Config}->{DisplayPattern} = '<CI_Name> (<CI_Number>)';
            }
            elsif (  $DynamicField->{Config}->{DisplayType} eq 'CINumberName' ) {
                $DynamicField->{Config}->{DisplayPattern} = '<CI_Number> (<CI_Name>)';
            }
            delete( $DynamicField->{Config}->{DisplayType} );
        }

        if ( exists( $DynamicField->{Config}->{EditorMode} ) ) {
            delete( $DynamicField->{Config}->{EditorMode} );
        }

        if ( exists( $DynamicField->{Config}->{ShowMatchInResult} ) ) {
            delete( $DynamicField->{Config}->{ShowMatchInResult} );
        }

        if ($DynamicField->{FieldType} eq 'ITSMConfigItemReference') {
            if ( !$DynamicField->{Config}->{MaxArraySize} ) {
                $DynamicField->{Config}->{MaxArraySize} = 1;
            }
        }
        if ($DynamicField->{FieldType} eq 'ITSMConfigItemReferenceArray') {
            $DynamicField->{FieldType} = 'ITSMConfigItemReference';
        }

        my $Success = $Self->{DynamicFieldObject}->DynamicFieldUpdate(
            %{$DynamicField},
            UserID      => 1,
        );

        if (!$Success) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => 'Could not update dynamic field ' . $DynamicField->{Name} . '!'
            );
        }
    }

    # get GenericAgent jobs
    my %JobList = $Self->{GenericAgentObject}->JobList();

    # process GenericAgent jobs
    for my $JobName ( keys ( %JobList ) ) {
        my %JobData = $Self->{GenericAgentObject}->JobGet(
            Name => $JobName
        );

        for my $Field ( @RelevantFields ) {
            if (
                $JobData{'DynamicField_' . $Field}
                && ref($JobData{'DynamicField_' . $Field}) eq 'ARRAY'
                && scalar($JobData{'DynamicField_' . $Field}) == 1
                && $JobData{'DynamicField_' . $Field}->[0] eq ''
            ) {
                delete $JobData{'DynamicField_' . $Field};
            }
            if (
                $JobData{'Search_DynamicField_' . $Field}
                && ref($JobData{'Search_DynamicField_' . $Field}) eq 'ARRAY'
                && scalar($JobData{'Search_DynamicField_' . $Field}) == 1
                && $JobData{'Search_DynamicField_' . $Field}->[0] eq ''
            ) {
                delete $JobData{'Search_DynamicField_' . $Field};
            }
        }

        my $Success = $Self->{GenericAgentObject}->JobDelete(
            Name   => $JobName,
            UserID => 1,
        );
        $Self->{GenericAgentObject}->JobAdd(
            Name => $JobName,
            Data => \%JobData,
            UserID => 1,
        );
    }

    return 1;
}

# EO Internal functions
#-------------------------------------------------------------------------------

1;

=back

=head1 TERMS AND CONDITIONS

This Software is part of the OTRS project (http://otrs.org/).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see http://www.gnu.org/licenses/agpl.txt.

=cut

#-------------------------------------------------------------------------------

=head1 VERSION
$Revision: 1.10 $ $Date: 2016/06/30 05:46:14 $
=cut
