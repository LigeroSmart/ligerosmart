package Kernel::System::CustomerCompanySLA;

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

    $Self->{CacheType} = 'Service';
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

=item CustomerSLAListGet()

return a list of services with the complete list of attributes for each service

    my $CustomerSLAList = $CustomerSLAObject->CustomerSLAListGet(
        CustomerID  => 0,   # (optional)
        SLAID => 1,     # (optional)
    );

    returns

    $SLAList = [
        {
            CustomerID  => 1,
            SLAID   => 1,
        },
        {
            ServiceID  => 2,
            SLAID   => 1,
        },
        # ...
    ];

=cut

sub CustomerSLAListGet {
    my ( $Self, %Param ) = @_;

    if ( !$Param{CustomerID} && !$Param{SLAID} ) {
      return;
    }

    # create SQL query
    my $SQL = 'SELECT customer_id, sla_id '
        . 'FROM customer_company_sla';

    if ( $Param{CustomerID} || $Param{SLAID} ) {
        $SQL .= ' WHERE ';

        if ( $Param{CustomerID} ) {
            $SQL .= ' customer_id = \'' . $Param{CustomerID} . '\''
        }

        if ( $Param{CustomerID} && $Param{SLAID} ) {
            $SQL .= ' AND '
        }

        if ( $Param{SLAID} ) {
            $SQL .= ' sla_id = ' . $Param{SLAID}
        }
    }

    $SQL .= ' ORDER BY customer_id';

    # ask database
    $Self->{DBObject}->Prepare(
        SQL => $SQL,
    );

    # fetch the result
    my @CustomerSLAList;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        my %CustomerSLAData;
        $CustomerSLAData{CustomerID}  = $Row[0];
        $CustomerSLAData{SLAID}       = $Row[1];
        push @CustomerSLAList, \%CustomerSLAData;
    }

    return \@CustomerSLAList;
}

=item CustomerSLAAdd()

add a customer company SLA

    my $Result = $CustomerSLAObject->CustomerSLAAdd(
        CustomerID  => 1,
        SLAID   => 1,
    );

=cut

sub CustomerSLAAdd {
    my ( $Self, %Param ) = @_;
    
    for my $Argument (qw(CustomerID SLAID)) {
        if ( !$Param{$Argument} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    return 0 if !$Self->{DBObject}->Do(
        SQL => 'INSERT INTO customer_company_sla '
            . '(customer_id, sla_id) '
            . 'VALUES (?, ?)',
        Bind => [
            \$Param{CustomerID}, \$Param{SLAID},
        ],
    );

    return 1;
}

=item CustomerSLARemove()

add a customer company sla

    my $Result = $CustomerSLAObject->CustomerSLARemove(
        CustomerID  => 1, #or
        SLAID   => 1, #or
    );

=cut

sub CustomerSLARemove {
    my ( $Self, %Param ) = @_;

    my $SQL = 'DELETE FROM customer_company_sla ';

    if ( $Param{CustomerID} || $Param{SLAID} ) {
        $SQL .= ' WHERE ';

        if ( $Param{CustomerID} ) {
            $SQL .= ' customer_id = \'' . $Param{CustomerID} . '\''
        }

        if ( $Param{CustomerID} && $Param{ServiceID} ) {
            $SQL .= ' AND '
        }

        if ( $Param{SLAID} ) {
            $SQL .= ' sla_id = ' . $Param{SLAID}
        }
    }

    return 0 if !$Self->{DBObject}->Do(
        SQL => $SQL,
    );

    return 1;
}

# ---

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
