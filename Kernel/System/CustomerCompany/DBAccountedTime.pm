# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::CustomerCompany::DBAccountedTime;

use strict;
use warnings;

use base qw(Kernel::System::CustomerCompany::DB);

our @ObjectDependencies = (
    'Kernel::System::Cache',
    'Kernel::System::DB',
    'Kernel::System::Log',
    'Kernel::System::Valid',
    'Kernel::System::AccountedTime',
);

sub CustomerCompanyGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{CustomerID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need CustomerID!'
        );
        return;
    }

    # check cache
    if ( $Self->{CacheObject} ) {
        my $Data = $Self->{CacheObject}->Get(
            Type => $Self->{CacheType},
            Key  => "CustomerCompanyGet::$Param{CustomerID}",
        );
        return %{$Data} if ref $Data eq 'HASH';
    }

    # build select
    my @Fields;
    my %FieldsMap;
    my %Data;
    
    FIELD:
    for my $Entry ( @{ $Self->{CustomerCompanyMap}->{Map} } ) {
        # COMPLEMENTO
        if($Entry->[5] eq 'usedquota'){
            $Entry->[7] = 1;
            $Data{$Entry->[0]} = $Kernel::OM->Get('Kernel::System::AccountedTime')->GetAccountedInMonth(
                                    CustomerID => $Param{CustomerID},
                                    Month => $Entry->[2],
                                );
            next FIELD;
        }
        # EO COMPLEMENTO
        
        push @Fields, $Entry->[2];
        $FieldsMap{ $Entry->[2] } = $Entry->[0];
    }
    my $SQL = 'SELECT ' . join( ', ', @Fields );

    if ( !$Self->{ForeignDB} ) {
        $SQL .= ", create_time, create_by, change_time, change_by";
    }

    # this seems to be legacy, if Name is passed it should take precedence over CustomerID
    my $CustomerID = $Param{Name} || $Param{CustomerID};

    $SQL .= " FROM $Self->{CustomerCompanyTable} WHERE ";

    if ( $Self->{CaseSensitive} ) {
        $SQL .= "$Self->{CustomerCompanyKey} = ?";
    }
    else {
        $SQL .= "LOWER($Self->{CustomerCompanyKey}) = LOWER( ? )";
    }

    # get initial data
    return if !$Self->{DBObject}->Prepare(
        SQL  => $SQL,
        Bind => [ \$CustomerID ]
    );

    # fetch the result
    # COMPLEMENTO
    #my %Data;
    # EO COMPLEMENTO
    ROW:
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {

        my $MapCounter = 0;

        for my $Field (@Fields) {
            $Data{ $FieldsMap{$Field} } = $Row[$MapCounter];
            $MapCounter++;
        }

        next ROW if $Self->{ForeignDB};

        for my $Key (qw(CreateTime CreateBy ChangeTime ChangeBy)) {
            $Data{$Key} = $Row[$MapCounter];
            $MapCounter++;
        }
    }

    # cache request
    if ( $Self->{CacheObject} ) {
        $Self->{CacheObject}->Set(
            Type  => $Self->{CacheType},
            Key   => "CustomerCompanyGet::$Param{CustomerID}",
            Value => \%Data,
            TTL   => $Self->{CacheTTL},
        );
    }

    # return data
    return (%Data);
}

sub CustomerCompanyAdd {
    my ( $Self, %Param ) = @_;

    # check ro/rw
    if ( $Self->{ReadOnly} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'CustomerCompany backend is read only!'
        );
        return;
    }

    my @Fields;
    my @Placeholders;
    my @Values;

    FIELD:
    for my $Entry ( @{ $Self->{CustomerCompanyMap}->{Map} } ) {
        # COMPLEMENTO
        if($Entry->[5] eq 'usedquota'){
            $Entry->[7] = 1;
            next FIELD;
        }
        # EO COMPLEMENTO
        push @Fields,       $Entry->[2];
        push @Placeholders, '?';
        push @Values,       \$Param{ $Entry->[0] };
    }
    if ( !$Self->{ForeignDB} ) {
        push @Fields,       qw(create_time create_by change_time change_by);
        push @Placeholders, qw(current_timestamp ? current_timestamp ?);
        push @Values, ( \$Param{UserID}, \$Param{UserID} );
    }

    # build insert
    my $SQL = "INSERT INTO $Self->{CustomerCompanyTable} (";
    $SQL .= join( ', ', @Fields ) . " ) VALUES ( " . join( ', ', @Placeholders ) . " )";

    return if !$Self->{DBObject}->Do(
        SQL  => $SQL,
        Bind => \@Values,
    );

    # log notice
    $Kernel::OM->Get('Kernel::System::Log')->Log(
        Priority => 'info',
        Message =>
            "CustomerCompany: '$Param{CustomerCompanyName}/$Param{CustomerID}' created successfully ($Param{UserID})!",
    );

    $Self->_CustomerCompanyCacheClear( CustomerID => $Param{CustomerID} );

    return $Param{CustomerID};
}

sub CustomerCompanyUpdate {
    my ( $Self, %Param ) = @_;

    # check ro/rw
    if ( $Self->{ReadOnly} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Customer backend is read only!'
        );
        return;
    }

    # check needed stuff
    FIELD:
    for my $Entry ( @{ $Self->{CustomerCompanyMap}->{Map} } ) {
        # COMPLEMENTO
        if($Entry->[5] eq 'usedquota'){
            $Entry->[7] = 1;
            next FIELD;
        }
        # EO COMPLEMENTO
        if ( !$Param{ $Entry->[0] } && $Entry->[4] && $Entry->[0] ne 'UserPassword' ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Entry->[0]!"
            );
            return;
        }
    }

    my @Fields;
    my @Values;

    FIELD:
    for my $Entry ( @{ $Self->{CustomerCompanyMap}->{Map} } ) {
        # COMPLEMENTO
        if($Entry->[5] eq 'usedquota'){
            $Entry->[7] = 1;
            next FIELD;
        }
        # EO COMPLEMENTO
        next FIELD if $Entry->[0] =~ /^UserPassword$/i;
        push @Fields, $Entry->[2] . ' = ?';
        push @Values, \$Param{ $Entry->[0] };
    }
    if ( !$Self->{ForeignDB} ) {
        push @Fields, ( 'change_time = current_timestamp', 'change_by = ?' );
        push @Values, \$Param{UserID};
    }

    # create SQL statement
    my $SQL = "UPDATE $Self->{CustomerCompanyTable} SET ";
    $SQL .= join( ', ', @Fields );

    if ( $Self->{CaseSensitive} ) {
        $SQL .= " WHERE $Self->{CustomerCompanyKey} = ?";
    }
    else {
        $SQL .= " WHERE LOWER($Self->{CustomerCompanyKey}) = LOWER( ? )";
    }
    push @Values, \$Param{CustomerCompanyID};

    return if !$Self->{DBObject}->Do(
        SQL  => $SQL,
        Bind => \@Values,
    );

    # log notice
    $Kernel::OM->Get('Kernel::System::Log')->Log(
        Priority => 'info',
        Message =>
            "CustomerCompany: '$Param{CustomerCompanyName}/$Param{CustomerID}' updated successfully ($Param{UserID})!",
    );

    $Self->_CustomerCompanyCacheClear( CustomerID => $Param{CustomerID} );
    if ( $Param{CustomerCompanyID} ne $Param{CustomerID} ) {
        $Self->_CustomerCompanyCacheClear( CustomerID => $Param{CustomerCompanyID} );
    }

    return 1;
}


1;
