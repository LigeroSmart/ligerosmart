
package var::packagesetup::PublicTicket;

use strict;
use warnings;

use Kernel::Output::Template::Provider;

our @ObjectDependencies = (
    'Kernel::Config',               'Kernel::System::DB',
    'Kernel::System::DynamicField', 'Kernel::System::Log',
    'Kernel::System::State',        'Kernel::System::Stats',
    'Kernel::System::SysConfig',    'Kernel::System::Type',
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

    $Self->_CreateDynamicFields();
    $Self->_UpdateConfig();

    return 1;
}

sub CodeUpgrade {
    my ( $Self, %Param ) = @_;

    $Self->_CreateDynamicFields();
    $Self->_UpdateConfig();

    return 1;
}

sub _UpdateConfig {
    my ( $Self, %Param ) = @_;
    my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');
    return 1;
}

sub _CreateDynamicFields {
    my ( $Self, %Param ) = @_;

    my $ValidID = $Kernel::OM->Get('Kernel::System::Valid')
      ->ValidLookup( Valid => 'valid', );

    # get all current dynamic fields
    my $DynamicFieldList = $Kernel::OM->Get('Kernel::System::DynamicField')
      ->DynamicFieldListGet( Valid => 0, );

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

    # get the definition for all dynamic fields
    my @DynamicFields = $Self->_GetDynamicFieldsDefinition();

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

        if ( ref $DynamicFieldLookup{ $DynamicField->{Name} } eq 'HASH' ) {

            # Deletes DF
            my $DynamicFieldID =
              $Kernel::OM->Get('Kernel::System::DynamicField')
              ->DynamicFieldGet( Name => $DynamicField->{Name}, );
            if ( $DynamicFieldID->{ID} ) {
                my $Success =
                  $Kernel::OM->Get('Kernel::System::DynamicField')
                  ->DynamicFieldDelete(
                    ID     => $DynamicFieldID->{ID},
                    UserID => 1,
                    Reorder => 1, # or 0, to trigger reorder function, default 1
                  );
            }
        }

        # create a new field
        my $FieldID =
          $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldAdd(
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

    return 1;
}

sub _GetDynamicFieldsDefinition {
    my ( $Self, %Param ) = @_;
    my @DynamicFields = (
        {
            Name       => 'TicketKey',
            Label      => 'Ticket Key',
            FieldType  => 'Text',
            ObjectType => 'Ticket',
            Config     => { DefaultValue   => '' }
        }
    );
    return @DynamicFields;
}
