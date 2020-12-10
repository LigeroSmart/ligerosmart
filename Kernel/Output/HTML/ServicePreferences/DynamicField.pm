# --
# Copyright (C) 2001-2016 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::ServicePreferences::DynamicField;

use strict;
use warnings;

use Data::Dumper;

use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::System::Web::Request',
    'Kernel::System::Service',
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get env
    for ( sort keys %Param ) {
        $Self->{$_} = $Param{$_};
    }

    $Self->{DF}=$Param{ConfigItem}->{DynamicField};

    $Self->{DynamicField} = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldListGet(
        Valid       => 1,
        ObjectType  => 'Service',
        FieldFilter => {
            $Param{ConfigItem}->{DynamicField} => 1
        },
    );
    
    return $Self;
}

sub Param {
    my ( $Self, %Param ) = @_;

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $ParamObject  = $Kernel::OM->Get('Kernel::System::Web::Request');

    my @Params = ();
    my $GetParam
        = $Kernel::OM->Get('Kernel::System::Web::Request')->GetParam( Param => $Self->{ConfigItem}->{PrefKey} );

    # get dynamic field values form http request
    my %DynamicFieldValues;

    # get dynamic field backend object
    my $DynamicFieldBackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

    # extract the dynamic field value form the web request
    my $DynamicFieldConfig = $Self->{DynamicField}->[0];
#    $DynamicFieldValues{ $Self->{DF} } = $DynamicFieldBackendObject->EditFieldValueGet(
    my $DynamicFieldValuesNew = $DynamicFieldBackendObject->EditFieldValueGet(
        DynamicFieldConfig => $DynamicFieldConfig,
        ParamObject        => $ParamObject,
        LayoutObject       => $LayoutObject,
    );

    # GET Value
    my $Value;
    if ($Param{ServiceData}->{ServiceID}) {
        $Value = $DynamicFieldBackendObject->ValueGet(
           DynamicFieldConfig => $DynamicFieldConfig,
           ObjectID           => $Param{ServiceData}->{ServiceID},
           FieldID            => $DynamicFieldConfig->{ID},
        );
    }
    
    
    # create HTML strings for all dynamic fields
    my %DynamicFieldHTML;

    # get field HTML
    $DynamicFieldHTML{ $DynamicFieldConfig->{Name} } =
        $DynamicFieldBackendObject->EditFieldRender(
        DynamicFieldConfig => $DynamicFieldConfig,
#        Mandatory =>
#            $Self->{Config}->{DynamicField}->{ $DynamicFieldConfig->{Name} } == 2,
        LayoutObject => $LayoutObject,
        ParamObject  => $ParamObject,
        Value => $Value
        );

    # get the HTML strings form $Param
    my $newDynamicFieldHTML = $DynamicFieldHTML{ $DynamicFieldConfig->{Name} };



        
    if ( !defined($GetParam) ) {
        $GetParam = defined( $Param{ServiceData}->{ $Self->{ConfigItem}->{PrefKey} } )
            ? $Param{ServiceData}->{ $Self->{ConfigItem}->{PrefKey} }
            : $Self->{ConfigItem}->{DataSelected};
    }
    push(
        @Params,
        {
            %Param,
            Name       => $Self->{ConfigItem}->{PrefKey},
            Option     => $newDynamicFieldHTML->{Field}
        },
    );
    return @Params;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $ParamObject  = $Kernel::OM->Get('Kernel::System::Web::Request');

    my $DynamicFieldBackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');
    # set the object ID depending on the field configuration
    my $ObjectID = $Param{ServiceData}->{ServiceID};

    # get upload cache object
    my $UploadCacheObject = $Kernel::OM->Get('Kernel::System::Web::UploadCache');

    # get form id
    my $FormID = $ParamObject->GetParam( Param => 'FormID' );

    # create form id
    if ( !$FormID ) {
        $FormID = $UploadCacheObject->FormIDCreate();
    }

    # get dynamic field values form http request
#    my %DynamicFieldValues;

    # extract the dynamic field value form the web request
    my $DynamicFieldConfig = $Self->{DynamicField}->[0];
    
    my $DynamicFieldValue = $DynamicFieldBackendObject->EditFieldValueGet(
        DynamicFieldConfig => $DynamicFieldConfig,
        ParamObject        => $ParamObject,
        LayoutObject       => $LayoutObject,
    );

    # set the value
    my $Success = $DynamicFieldBackendObject->ValueSet(
        DynamicFieldConfig => $DynamicFieldConfig,
        ObjectID           => $ObjectID,
        Value              => $DynamicFieldValue,
        UserID             => $Self->{UserID},
    );

    $Self->{Message} = 'Preferences updated successfully!';

    return 1;
}

sub Error {
    my ( $Self, %Param ) = @_;

    return $Self->{Error} || '';
}

sub Message {
    my ( $Self, %Param ) = @_;

    return $Self->{Message} || '';
}

1;
