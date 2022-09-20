package Kernel::System::CustomerCompanyService;

use strict;
use warnings;
# COMPLEMENTO
use Data::Dumper;
# EO COMPLEMENTO
use Kernel::System::VariableCheck (qw(:all));

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Cache',
    'Kernel::System::CheckItem',
    'Kernel::System::DB',
# ---
# ITSMCore
# ---
    'Kernel::System::DynamicField',
    'Kernel::System::GeneralCatalog',
    'Kernel::System::LinkObject',
# ---
    'Kernel::System::Log',
    'Kernel::System::Main',
    'Kernel::System::Valid',
);

=head1 NAME

Kernel::System::Service - service lib

=head1 SYNOPSIS

All service functions.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create an object

    use Kernel::System::ObjectManager;
    local $Kernel::OM = Kernel::System::ObjectManager->new();
    my $ServiceObject = $Kernel::OM->Get('Kernel::System::Service');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    $Self->{DBObject} = $Kernel::OM->Get('Kernel::System::DB');

    $Self->{CacheType} = 'CompanyService';
    $Self->{CacheTTL}  = 60 * 60 * 24 * 20;
    
    # COMPLEMENTO
    $Self->{EnvUserLanguage} = $ENV{UserLanguage} || $Kernel::OM->Get('Kernel::Config')->Get('DefaultLanguage');
    $Self->{EnvDefaultLanguage} = $Kernel::OM->Get('Kernel::Config')->Get('DefaultLanguage');
    # EO COMPLEMENTO
# ---
# ITSMCore
# ---

    # get the dynamic field for ITSMCriticality
    my $DynamicFieldConfigArrayRef = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldListGet(
        Valid       => 1,
        ObjectType  => [ 'Ticket' ],
        FieldFilter => {
            ITSMCriticality => 1,
        },
    );

    # get the dynamic field value for ITSMCriticality
    my %PossibleValues;
    DYNAMICFIELD:
    for my $DynamicFieldConfig ( @{ $DynamicFieldConfigArrayRef } ) {
        next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

        # get PossibleValues
        $PossibleValues{ $DynamicFieldConfig->{Name} } = $DynamicFieldConfig->{Config}->{PossibleValues} || {};
    }

    # set the criticality list
    $Self->{CriticalityList} = $PossibleValues{ITSMCriticality};
# ---

    # load generator preferences module
    my $GeneratorModule = $Kernel::OM->Get('Kernel::Config')->Get('Service::PreferencesModule')
        || 'Kernel::System::Service::PreferencesDB';
    if ( $Kernel::OM->Get('Kernel::System::Main')->Require($GeneratorModule) ) {
        $Self->{PreferencesObject} = $GeneratorModule->new( %{$Self} );
    }

    return $Self;
}

=item CustomerServiceListGet()

return a list of services from a customer

    my $CustomerServiceList = $CustomerServiceObject->CustomerServiceListGet(
        CustomerID  => 0,   # (optional)
        ServiceID => 1,     # (optional)
    );

    returns

    $ServiceList = [
        {
            CustomerID  => 1,
            ServiceID   => 1,
        },
        {
            ServiceID  => 2,
            ServiceID   => 1,
        },
        # ...
    ];

=cut

sub CustomerServiceListGet {
    my ( $Self, %Param ) = @_;

    if ( !$Param{CustomerID} && !$Param{ServiceID} ) {
      return;
    }

    # create SQL query
    my $SQL = 'SELECT customer_id, service_id '
        . 'FROM customer_company_service';

    if ( $Param{CustomerID} || $Param{ServiceID} ) {
        $SQL .= ' WHERE ';

        if ( $Param{CustomerID} ) {
            $SQL .= ' customer_id = \'' . $Param{CustomerID} . '\''
        }

        if ( $Param{CustomerID} && $Param{ServiceID} ) {
            $SQL .= ' AND '
        }

        if ( $Param{ServiceID} ) {
            $SQL .= ' service_id = ' . $Param{ServiceID}
        }
    }

    $SQL .= ' ORDER BY customer_id';

    # ask database
    $Self->{DBObject}->Prepare(
        SQL => $SQL,
    );

    # fetch the result
    my @CustomerServiceList;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        my %CustomerServiceData;
        $CustomerServiceData{CustomerID}  = $Row[0];
        $CustomerServiceData{ServiceID}   = $Row[1];
        push @CustomerServiceList, \%CustomerServiceData;
    }

    return \@CustomerServiceList;
}

=item CustomerServiceAdd()

add a customer company service

    my $Result = $CustomerServiceObject->CustomerServiceAdd(
        CustomerID  => 1,
        ServiceID   => 1,
    );

=cut

sub CustomerServiceAdd {
    my ( $Self, %Param ) = @_;
    
    for my $Argument (qw(CustomerID ServiceID)) {
        if ( !$Param{$Argument} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    return 0 if !$Self->{DBObject}->Do(
        SQL => 'INSERT INTO customer_company_service '
            . '(customer_id, service_id) '
            . 'VALUES (?, ?)',
        Bind => [
            \$Param{CustomerID}, \$Param{ServiceID},
        ],
    );

    return 1;
}

=item CustomerServiceRemove()

add a customer company service

    my $Result = $CustomerServiceObject->CustomerServiceRemove(
        CustomerID  => 1, #or
        ServiceID   => 1, #or
    );

=cut

sub CustomerServiceRemove {
    my ( $Self, %Param ) = @_;

    my $SQL = 'DELETE FROM customer_company_service ';

    if ( $Param{CustomerID} || $Param{ServiceID} ) {
        $SQL .= ' WHERE ';

        if ( $Param{CustomerID} ) {
            $SQL .= ' customer_id = \'' . $Param{CustomerID} . '\''
        }

        if ( $Param{CustomerID} && $Param{ServiceID} ) {
            $SQL .= ' AND '
        }

        if ( $Param{ServiceID} ) {
            $SQL .= ' service_id = ' . $Param{ServiceID}
        }
    }

    return 0 if !$Self->{DBObject}->Do(
        SQL => $SQL,
    );

    return 1;
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
