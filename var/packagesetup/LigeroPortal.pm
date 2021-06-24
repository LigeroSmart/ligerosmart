# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package var::packagesetup::LigeroPortal;

use strict;
use warnings;
use utf8;

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
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}


sub CodeInstall {
    my ( $Self, %Param ) = @_;

	$Self->_UpdateConfig();
    $Self->_CreateDynamicFields();

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

    my @Configs = (
        {
            ConfigItem => 'CustomerFrontend::CommonParam###Action',
            Value 	   => 'CustomerServiceCatalog'
        },
    );

    CONFIGITEM:
    for my $Config (@Configs) {
        # set new setting,
        #my $Success = $SysConfigObject->ConfigItemUpdate(
        #    Valid => 1,
        #    Key   => $Config->{ConfigItem},
        #    Value => $Config->{Value},
        #);

        my $Success = $SysConfigObject->SettingsSet(
            UserID   => 1,                                      # (required) UserID
            Comments => 'LigeroServiceCatalog',                   # (optional) Comment
            Settings => [                                       # (required) List of settings to update.
                {
                    Name                   => $Config->{ConfigItem},  # (required)
                    EffectiveValue         => $Config->{Value},          # (optional)
                    IsValid                => 1,                # (optional)
                }
            ],
        );

    }

    return 1;
}

sub _CreateDynamicFields {
    my ( $Self, %Param ) = @_;

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
        if ( ref $DynamicFieldLookup{ $DynamicField->{Name} } ne 'HASH' ) {
            $CreateDynamicField = 1;
        }

        # check if new field has to be created
        if ($CreateDynamicField) {

            # create a new field
            my $FieldID = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldAdd(
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

    # define all dynamic fields for ITSM
    my @DynamicFields = (
        {
            Name       => 'FAQTitle',
            Label      => 'FAQ Title',
            FieldType  => 'Text',
            ObjectType => 'Ticket',
            Config     => {
                DefaultValue   => '',
                Cols           => '255',
            },
        },

        {
            Name       => 'FAQID',
            Label      => 'FAQ ID',
            FieldType  => 'Text',
            ObjectType => 'Ticket',
            Config     => {
                DefaultValue   => '',
                Cols           => '5',
            },
        },

        {
            Name       => 'ServiceDescription',
            Label      => 'Service Description',
            FieldType  => 'TextArea',
            ObjectType => 'Service',
            Config     => {
                DefaultValue   => '',
                Cols           => '70',
            },
        },

        {
            Name       => 'TicketExceededAlert',
            Label      => 'Ticket Exceeded Alert',
            FieldType  => 'TextArea',
            ObjectType => 'Service',
            Config     => {
                DefaultValue   => '',
                Cols           => '70',
            },
        },

        {
            Name       => 'ServiceImage',
            Label      => 'Service Image',
            FieldType  => 'File',
            ObjectType => 'Service',
            Config     => {
                DefaultValue   => '',
            },
        },

        {
            Name       => 'ServiceDescriptionXXarXXSA',
            Label      => 'Arabic (Saudi Arabia)',
            FieldType  => 'TextArea',
            ObjectType => 'Service',
            Config     => {
                DefaultValue   => '',
                Cols           => '70',
            },
        },

        {
            Name       => 'ServiceDescriptionXXbg',
            Label      => 'Bulgarian',
            FieldType  => 'TextArea',
            ObjectType => 'Service',
            Config     => {
                DefaultValue   => '',
                Cols           => '70',
            },
        },

        {
            Name       => 'ServiceDescriptionXXca',
            Label      => 'Catalan',
            FieldType  => 'TextArea',
            ObjectType => 'Service',
            Config     => {
                DefaultValue   => '',
                Cols           => '70',
            },
        },

        {
            Name       => 'ServiceDescriptionXXcs',
            Label      => 'Czech',
            FieldType  => 'TextArea',
            ObjectType => 'Service',
            Config     => {
                DefaultValue   => '',
                Cols           => '70',
            },
        },

        {
            Name       => 'ServiceDescriptionXXda',
            Label      => 'Danish',
            FieldType  => 'TextArea',
            ObjectType => 'Service',
            Config     => {
                DefaultValue   => '',
                Cols           => '70',
            },
        },

        {
            Name       => 'ServiceDescriptionXXde',
            Label      => 'German',
            FieldType  => 'TextArea',
            ObjectType => 'Service',
            Config     => {
                DefaultValue   => '',
                Cols           => '70',
            },
        },

        {
            Name       => 'ServiceDescriptionXXen',
            Label      => 'English (United States)',
            FieldType  => 'TextArea',
            ObjectType => 'Service',
            Config     => {
                DefaultValue   => '',
                Cols           => '70',
            },
        },

        {
            Name       => 'ServiceDescriptionXXenXXCA',
            Label      => 'English (Canada)',
            FieldType  => 'TextArea',
            ObjectType => 'Service',
            Config     => {
                DefaultValue   => '',
                Cols           => '70',
            },
        },

        {
            Name       => 'ServiceDescriptionXXenXXGB',
            Label      => 'English (United Kingdom)',
            FieldType  => 'TextArea',
            ObjectType => 'Service',
            Config     => {
                DefaultValue   => '',
                Cols           => '70',
            },
        },

        {
            Name       => 'ServiceDescriptionXXes',
            Label      => 'Spanish',
            FieldType  => 'TextArea',
            ObjectType => 'Service',
            Config     => {
                DefaultValue   => '',
                Cols           => '70',
            },
        },

        {
            Name       => 'ServiceDescriptionXXesXXCO',
            Label      => 'Spanish (Colombia)',
            FieldType  => 'TextArea',
            ObjectType => 'Service',
            Config     => {
                DefaultValue   => '',
                Cols           => '70',
            },
        },

        {
            Name       => 'ServiceDescriptionXXesXXMX',
            Label      => 'Spanish (Mexico)',
            FieldType  => 'TextArea',
            ObjectType => 'Service',
            Config     => {
                DefaultValue   => '',
                Cols           => '70',
            },
        },

        {
            Name       => 'ServiceDescriptionXXet',
            Label      => 'Estonian',
            FieldType  => 'TextArea',
            ObjectType => 'Service',
            Config     => {
                DefaultValue   => '',
                Cols           => '70',
            },
        },

        {
            Name       => 'ServiceDescriptionXXel',
            Label      => 'Greek',
            FieldType  => 'TextArea',
            ObjectType => 'Service',
            Config     => {
                DefaultValue   => '',
                Cols           => '70',
            },
        },

        {
            Name       => 'ServiceDescriptionXXfa',
            Label      => 'Persian',
            FieldType  => 'TextArea',
            ObjectType => 'Service',
            Config     => {
                DefaultValue   => '',
                Cols           => '70',
            },
        },

        {
            Name       => 'ServiceDescriptionXXfi',
            Label      => 'Finnish',
            FieldType  => 'TextArea',
            ObjectType => 'Service',
            Config     => {
                DefaultValue   => '',
                Cols           => '70',
            },
        },

        {
            Name       => 'ServiceDescriptionXXfr',
            Label      => 'French',
            FieldType  => 'TextArea',
            ObjectType => 'Service',
            Config     => {
                DefaultValue   => '',
                Cols           => '70',
            },
        },

        {
            Name       => 'ServiceDescriptionXXfrXXCA',
            Label      => 'French (Canada)',
            FieldType  => 'TextArea',
            ObjectType => 'Service',
            Config     => {
                DefaultValue   => '',
                Cols           => '70',
            },
        },

        {
            Name       => 'ServiceDescriptionXXgl',
            Label      => 'Galician',
            FieldType  => 'TextArea',
            ObjectType => 'Service',
            Config     => {
                DefaultValue   => '',
                Cols           => '70',
            },
        },

        {
            Name       => 'ServiceDescriptionXXhe',
            Label      => 'Hebrew',
            FieldType  => 'TextArea',
            ObjectType => 'Service',
            Config     => {
                DefaultValue   => '',
                Cols           => '70',
            },
        },

        {
            Name       => 'ServiceDescriptionXXhi',
            Label      => 'Hindi',
            FieldType  => 'TextArea',
            ObjectType => 'Service',
            Config     => {
                DefaultValue   => '',
                Cols           => '70',
            },
        },

        {
            Name       => 'ServiceDescriptionXXhr',
            Label      => 'Croatian',
            FieldType  => 'TextArea',
            ObjectType => 'Service',
            Config     => {
                DefaultValue   => '',
                Cols           => '70',
            },
        },

        {
            Name       => 'ServiceDescriptionXXhu',
            Label      => 'Hungarian',
            FieldType  => 'TextArea',
            ObjectType => 'Service',
            Config     => {
                DefaultValue   => '',
                Cols           => '70',
            },
        },

        {
            Name       => 'ServiceDescriptionXXid',
            Label      => 'Indonesian',
            FieldType  => 'TextArea',
            ObjectType => 'Service',
            Config     => {
                DefaultValue   => '',
                Cols           => '70',
            },
        },

        {
            Name       => 'ServiceDescriptionXXit',
            Label      => 'Italian',
            FieldType  => 'TextArea',
            ObjectType => 'Service',
            Config     => {
                DefaultValue   => '',
                Cols           => '70',
            },
        },

        {
            Name       => 'ServiceDescriptionXXja',
            Label      => 'Japanese',
            FieldType  => 'TextArea',
            ObjectType => 'Service',
            Config     => {
                DefaultValue   => '',
                Cols           => '70',
            },
        },

        {
            Name       => 'ServiceDescriptionXXlt',
            Label      => 'Lithuanian',
            FieldType  => 'TextArea',
            ObjectType => 'Service',
            Config     => {
                DefaultValue   => '',
                Cols           => '70',
            },
        },

        {
            Name       => 'ServiceDescriptionXXlv',
            Label      => 'Latvian',
            FieldType  => 'TextArea',
            ObjectType => 'Service',
            Config     => {
                DefaultValue   => '',
                Cols           => '70',
            },
        },

        {
            Name       => 'ServiceDescriptionXXms',
            Label      => 'Malay',
            FieldType  => 'TextArea',
            ObjectType => 'Service',
            Config     => {
                DefaultValue   => '',
                Cols           => '70',
            },
        },

        {
            Name       => 'ServiceDescriptionXXnl',
            Label      => 'Nederlands',
            FieldType  => 'TextArea',
            ObjectType => 'Service',
            Config     => {
                DefaultValue   => '',
                Cols           => '70',
            },
        },

        {
            Name       => 'ServiceDescriptionXXnbXXNO',
            Label      => 'Norwegian',
            FieldType  => 'TextArea',
            ObjectType => 'Service',
            Config     => {
                DefaultValue   => '',
                Cols           => '70',
            },
        },

        {
            Name       => 'ServiceDescriptionXXptXXBR',
            Label      => 'Portuguese (Brasil)',
            FieldType  => 'TextArea',
            ObjectType => 'Service',
            Config     => {
                DefaultValue   => '',
                Cols           => '70',
            },
        },

        {
            Name       => 'ServiceDescriptionXXpt',
            Label      => 'Portuguese',
            FieldType  => 'TextArea',
            ObjectType => 'Service',
            Config     => {
                DefaultValue   => '',
                Cols           => '70',
            },
        },

        {
            Name       => 'ServiceDescriptionXXpl',
            Label      => 'Polish',
            FieldType  => 'TextArea',
            ObjectType => 'Service',
            Config     => {
                DefaultValue   => '',
                Cols           => '70',
            },
        },

        {
            Name       => 'ServiceDescriptionXXru',
            Label      => 'Russian',
            FieldType  => 'TextArea',
            ObjectType => 'Service',
            Config     => {
                DefaultValue   => '',
                Cols           => '70',
            },
        },

        {
            Name       => 'ServiceDescriptionXXsl',
            Label      => 'Slovenian',
            FieldType  => 'TextArea',
            ObjectType => 'Service',
            Config     => {
                DefaultValue   => '',
                Cols           => '70',
            },
        },

        {
            Name       => 'ServiceDescriptionXXsrXXLatn',
            Label      => 'Serbian Latin',
            FieldType  => 'TextArea',
            ObjectType => 'Service',
            Config     => {
                DefaultValue   => '',
                Cols           => '70',
            },
        },

        {
            Name       => 'ServiceDescriptionXXsrXXCyrl',
            Label      => 'Serbian Cyrillic',
            FieldType  => 'TextArea',
            ObjectType => 'Service',
            Config     => {
                DefaultValue   => '',
                Cols           => '70',
            },
        },

        {
            Name       => 'ServiceDescriptionXXskXXSK',
            Label      => 'Slovak',
            FieldType  => 'TextArea',
            ObjectType => 'Service',
            Config     => {
                DefaultValue   => '',
                Cols           => '70',
            },
        },

        {
            Name       => 'ServiceDescriptionXXsv',
            Label      => 'Swedish',
            FieldType  => 'TextArea',
            ObjectType => 'Service',
            Config     => {
                DefaultValue   => '',
                Cols           => '70',
            },
        },

        {
            Name       => 'ServiceDescriptionXXsw',
            Label      => 'Swahili',
            FieldType  => 'TextArea',
            ObjectType => 'Service',
            Config     => {
                DefaultValue   => '',
                Cols           => '70',
            },
        },

        {
            Name       => 'ServiceDescriptionXXthXXTH',
            Label      => 'Thai',
            FieldType  => 'TextArea',
            ObjectType => 'Service',
            Config     => {
                DefaultValue   => '',
                Cols           => '70',
            },
        },

        {
            Name       => 'ServiceDescriptionXXtr',
            Label      => 'Turkish',
            FieldType  => 'TextArea',
            ObjectType => 'Service',
            Config     => {
                DefaultValue   => '',
                Cols           => '70',
            },
        },

        {
            Name       => 'ServiceDescriptionXXuk',
            Label      => 'Ukrainian',
            FieldType  => 'TextArea',
            ObjectType => 'Service',
            Config     => {
                DefaultValue   => '',
                Cols           => '70',
            },
        },

        {
            Name       => 'ServiceDescriptionXXviXXVN',
            Label      => 'Vietnam',
            FieldType  => 'TextArea',
            ObjectType => 'Service',
            Config     => {
                DefaultValue   => '',
                Cols           => '70',
            },
        },

        {
            Name       => 'ServiceDescriptionXXzhXXCN',
            Label      => 'Chinese (Simplified)',
            FieldType  => 'TextArea',
            ObjectType => 'Service',
            Config     => {
                DefaultValue   => '',
                Cols           => '70',
            },
        },

        {
            Name       => 'ServiceDescriptionXXzhXXTW',
            Label      => 'Chinese (Traditional)',
            FieldType  => 'TextArea',
            ObjectType => 'Service',
            Config     => {
                DefaultValue   => '',
                Cols           => '70',
            },
        },

        {
            Name       => 'ShowAsCategory',
            Label      => 'Exibir como',
            FieldType  => 'Dropdown',
            ObjectType => 'Service',
            Config     => {
                DefaultValue   => '0',
                Translatable   => 1,
                PossibleValues => {
                    '0' => '1 - Categoria Normal',
                    '1' => '2 - Categoria Serviço',
                    '2' => '3 - Categoria Principal',
                    '3' => '4 - Categoria Secundaria',
                    '4' => '5 - Categoria Terciaria'
                }
            },
        },

        {
            Name       => 'ServiceType',
            Label      => 'Servico Principal',
            FieldType  => 'Checkbox',
            ObjectType => 'Service',
            Config     => {
                DefaultValue   => '0',
                Translatable   => 1,
            },
        },

        {
            Name       => 'JustOneTicket',
            Label      => 'Um Chamado Aberto por Vez',
            FieldType  => 'Checkbox',
            ObjectType => 'Service',
            Config     => {
                DefaultValue   => '0',
                Translatable   => 1,
            },
        },

        {
            Name       => 'UrlTarget',
            Label      => 'Url Target',
            FieldType  => 'Dropdown',
            ObjectType => 'Service',
            Config     => {
                DefaultValue   => '',
                Translatable   => 1,
                PossibleValues => {
                    '' => '',
                    '_self'  => '_self',
                    '_blank'  => '_blank',
                }
            },
        },

        {
            Name       => 'ForwardToUrl',
            Label      => 'Forward to URL',
            FieldType  => 'Text',
            ObjectType => 'Service',
            Config     => {
                DefaultValue   => '',
            },
        },

        {
            Name       => 'FaqButtons',
            Label      => 'Faq Buttons',
            FieldType  => 'Multiselect',
            ObjectType => 'FAQ',
            Config     => {
                DefaultValue   => '',
            },
        },
    );

    return @DynamicFields;
}


