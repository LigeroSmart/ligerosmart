
package Kernel::System::Audit;

use strict;
use warnings;

use Kernel::System::DateTime;
use Kernel::System::VariableCheck qw( IsArrayRefWithData IsHashRefWithData );

our @ObjectDependencies = (
    'Kernel::System::DB',
    'Kernel::System::Log',
    'Kernel::System::JSON'
);

sub new {
    my ( $Type, %Param ) = @_;

    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

sub Store {
    my ( $Self, %Param ) = @_;

    # debug
    #$Kernel::OM->Get('Kernel::System::Log')->Dumper( \%Param );
    #return;

    # sanitize data
    my $SessionID = $Param{SessionID}; delete $Param{SessionID};
    my $Data;
    foreach (sort keys %Param) {
        $Data->{ $_ } = ${ $Param{$_} }[0];
    }

    # ignore incomplete requests
    return if not defined($Data->{Action});
    return if not defined($Data->{Subaction});

    # ignore non admin requests
    return if ($Data->{Action} !~ m/^Admin/g);

    # ignore some modules
    return if ($Data->{Action} =~ m/SelectBox/g);

    # get user data
    my %UserData = $Kernel::OM->Get('Kernel::System::AuthSession')->GetSessionIDData( SessionID => $SessionID );
    return if (!%UserData);

    # json data
    my $Action     = $Data->{Action}; delete $Data->{Action};
    my $SubAction  = $Data->{Subaction}; delete $Data->{Subaction};
    my $Payload    = $Kernel::OM->Get('Kernel::System::JSON')->Encode(
        Data => $Data,
        SortKeys => 1,
        Pretty => 1
    );

    # create db record
    $Action =~ s/Admin//g;
    $Kernel::OM->Get('Kernel::System::DB')->Do(
        SQL => '
            INSERT INTO audit_log (user_id, module, action, payload, create_time)
            VALUES (?, ?, ?, ?, current_timestamp)',
        Bind => [
            \$UserData{UserID},
            \$Action,
            \$SubAction,
            \$Payload
        ]
    );

    return;
}

1;
