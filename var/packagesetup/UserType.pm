# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package var::packagesetup::UserType;

use strict;
use warnings;

use Kernel::Output::Template::Provider;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::DB',
    'Kernel::System::DynamicField',
    'Kernel::System::Log',
    'Kernel::System::State',
    'Kernel::System::Stats',
    'Kernel::System::SysConfig',
    'Kernel::System::Type',
    'Kernel::System::Valid',
    'Kernel::System::Encode',
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    bless( $Self, $Type );    

    $Self->{Path} = $ConfigObject->Get('Home');

    return $Self;
}


sub CodeInstall {
    my ( $Self, %Param ) = @_;

    my $ConfigMapCustomerUser = "\t\t\t[ 'DynamicField_userType', undef, 'userType', 1, 0, 'dynamic_field', undef, 0, undef, undef ],";

	$Self->_UpdateConfig();
    $Self->_CreateDynamicFields(
        DeleteOldField => 1,
    );
    $Self->_ConfigMapFieldUserType(
        CustomerUser  => $ConfigMapCustomerUser,
    );    


    return 1;
}

sub CodeUpgrade {
    my ( $Self, %Param ) = @_;

	$Self->_UpdateConfig();
    $Self->_CreateDynamicFields();


    return 1;
}

sub _UpdateConfig {
    my ( $Self, %Param ) = @_;

    my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

    return 1;
}

sub _CreateDynamicFields {
    my ( $Self, %Param ) = @_;

    my $DynamicFieldBackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');
    my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');

    my $ValidID = $Kernel::OM->Get('Kernel::System::Valid')->ValidLookup(
        Valid => 'valid',
    );

    # get all current dynamic fields
    my $DynamicFieldList = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldListGet(
        Valid => 0,
    );

    # get the list of order numbers (is already sorted).
    my @DynamicfieldOrderList;
    for my $Dynamicfield ( @{$DynamicFieldList} ) {
        push @DynamicfieldOrderList, $Dynamicfield->{FieldOrder};
    }

    # get the last element from the order list and add 1
    my $NextOrderNumber = 1;
    if (@DynamicfieldOrderList) {
        $NextOrderNumber = $DynamicfieldOrderList[-1] + 1;
    }

    # get the definition for all dynamic fields for ITSM
    my @DynamicFields = $Self->_GetITSMDynamicFieldsDefinition();

    # create a dynamic fields lookup table
    my %DynamicFieldLookup;
    DYNAMICFIELD:
    for my $DynamicField ( @{$DynamicFieldList} ) {
        next DYNAMICFIELD if ref $DynamicField ne 'HASH';
        $DynamicFieldLookup{ $DynamicField->{Name} } = $DynamicField;
    }

    # create or update dynamic fields
    DYNAMICFIELD:
    for my $DynamicField (@DynamicFields) {

        my $CreateDynamicField;

        # check if the dynamic field already exists
        if ( ref $DynamicFieldLookup{ $DynamicField->{Name} } eq 'HASH' ) {

            #next DYNAMICFIELD if !IsHashRefWithData($DynamicField);
            if ( $Param{DeleteOldField} ) {
                # remove data from the field
                my $ValuesDeleteSuccess = $DynamicFieldBackendObject->AllValuesDelete(
                    DynamicFieldConfig => $DynamicFieldLookup{ $DynamicField->{Name} },
                    UserID             => 1,
                );

                my $Success = $DynamicFieldObject->DynamicFieldDelete(
                    ID      => $DynamicFieldLookup{ $DynamicField->{Name} }->{ID},
                    UserID  => 1,
                    Reorder => 1,
                );

                $CreateDynamicField = 1;
            }

        }
        else {

            $CreateDynamicField = 1;

        }

        # check if new field has to be created
        if ($CreateDynamicField) {

            # create a new field
            my $FieldID = $DynamicFieldObject->DynamicFieldAdd(
                InternalField => 1,
                Name          => $DynamicField->{Name},
                Label         => $DynamicField->{Label},
                FieldOrder    => $NextOrderNumber,
                FieldType     => $DynamicField->{FieldType},
                ObjectType    => $DynamicField->{ObjectType},
                Config        => $DynamicField->{Config},
                ValidID       => $ValidID,
                UserID        => 1,
            );
            next DYNAMICFIELD if !$FieldID;

            # increase the order number
            $NextOrderNumber++;
        }
    }

    return 1;
}

sub _GetITSMDynamicFieldsDefinition {
    my ( $Self, %Param ) = @_;

    my $String = 'Técnico';
    $Kernel::OM->Get('Kernel::System::Encode')->EncodeInput( \$String );

    chomp $String;

    # define all dynamic fields for ITSM
    my @DynamicFields = (
        {
            Name       => 'userType',
            Label      => 'Tipo de usuário',
            FieldType  => 'Dropdown',
            ObjectType => 'CustomerUser',
            Config     => {
                DefaultValue   => '',
                Translatable   => 1,
                PossibleValues => {
                    'master' => 'Master',
                    'tecnico'  => $String,
                }
            },
        },
    );

    return @DynamicFields;
}

sub _ConfigMapFieldUserType {
    my ( $Self, %Param ) = @_;

    # Perl quote and set via ConfigObject.
    for my $Key ( sort keys %Param ) {
        $Kernel::OM->Get('Kernel::Config')->Set(
            Key   => $Key,
            Value => $Param{$Key},
        );
    }

    # Read config file.
    my $ConfigFile = "$Self->{Path}/Kernel/Config.pm";
    ## no critic
    open( my $In, '<', $ConfigFile )
        || return "Can't open $ConfigFile: $!";
    ## use critic
    my $Config = '';
    my $flag = 0;
    while (<$In>) {

        # Skip empty lines or comments.
        if ( !$_ || $_ =~ /^\s*#/ || $_ =~ /^\s*$/ ) {
            $Config .= $_;
        }
        else {
            my $NewConfig = $_;

            # Replace config with %Param.
            for my $Key ( sort keys %Param ) {

                if ( $Key eq 'CustomerUser' && $flag == 0) {
                    $flag = 1;
                }

                if ( $NewConfig =~ /(Map \=\> \[)/ && $flag == 1) {
                    $NewConfig =~
                        s/(Map \=\> \[)/Map \=\> \[\n $Param{$Key}/g;
                    $flag = 2;
                }
                elsif ( $NewConfig =~ /(DynamicField_userType)/ && $flag == 2) {
                    $NewConfig =~
                        s/^(.+?)([\[])((.+?)DynamicField_userType(.+?))$/$1#$2$3/g;
                }                
                else {
                    $NewConfig =~
                        s/(\$Self->\{("|'|)$Key("|'|)} =.+?('|"));/\$Self->{'$Key'} = "$Param{$Key}";/g;
                }
            }
            $Config .= $NewConfig;
        }
    }
    close $In;

    # Write new config file.
    ## no critic
    open( my $Out, '>:utf8', $ConfigFile )
        || return "Can't open $ConfigFile: $!";
    print $Out $Config;
    ## use critic
    close $Out;

    return;
}