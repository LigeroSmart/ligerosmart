# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::CustomerPortal;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::SysConfig',
    'Kernel::System::Cache',
    'Kernel::System::DB',
    'Kernel::System::Log',
    'Kernel::System::Valid',
);

=head1 NAME

Kernel::System::Type - type lib

=head1 DESCRIPTION

All type functions.

=head1 PUBLIC INTERFACE

=head2 new()

create an object

    my $CustomerPortalObject = $Kernel::OM->Get('Kernel::System::CustomerPortal');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    $Self->{CacheType} = 'CustomerPortal';
    $Self->{CacheTTL}  = 60 * 60 * 24 * 20;

    return $Self;
}

=head2 CustomerPortalAdd()

add a new customer portal

    my $ID = $CustomerPortalObject->CustomerPortalAdd(
        Name    => 'New Type',
        ValidID => 1,
        UserID  => 123,
    );

=cut

sub CustomerPortalAdd {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Name ValidID UserID)) {
        if ( !$Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!"
            );
            return;
        }
    }

    # check if a type with this name already exists
    if ( $Self->NameExistsCheck( Name => $Param{Name} ) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "A customer portal with the name '$Param{Name}' already exists.",
        );
        return;
    }

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    return if !$DBObject->Do(
        SQL => 'INSERT INTO customer_portal (name, valid_id, '
            . ' create_time, create_by, change_time, change_by)'
            . ' VALUES (?, ?, current_timestamp, ?, current_timestamp, ?)',
        Bind => [ \$Param{Name}, \$Param{ValidID}, \$Param{UserID}, \$Param{UserID} ],
    );

    # get new type id
    return if !$DBObject->Prepare(
        SQL   => 'SELECT id FROM customer_portal WHERE name = ?',
        Bind  => [ \$Param{Name} ],
        Limit => 1,
    );

    # fetch the result
    my $ID;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $ID = $Row[0];
    }
    return if !$ID;

    # reset cache
    $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
        Type => $Self->{CacheType},
    );

    return $ID;
}

=head2 CustomerPortalGet()

get customer portal attributes

    my %CustomerPortal = $CustomerPortalObject->CustomerPortalGet(
        ID => 123,
    );

    my %CustomerPortal = $CustomerPortalObject->CustomerPortalGet(
        Name => 'default',
    );

Returns:

    CustomerPortal = (
        ID                  => '123',
        Name                => 'Service Request',
        ValidID             => '1',
        CreateTime          => '2010-04-07 15:41:15',
        CreateBy            => '321',
        ChangeTime          => '2010-04-07 15:59:45',
        ChangeBy            => '223',
    );

=cut

sub CustomerPortalGet {
    my ( $Self, %Param ) = @_;

    # either ID or Name must be passed
    if ( !$Param{ID} && !$Param{Name} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need ID or Name!',
        );
        return;
    }

    # check that not both ID and Name are given
    if ( $Param{ID} && $Param{Name} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need either ID OR Name - not both!',
        );
        return;
    }

    # lookup the ID
    if ( $Param{Name} ) {
        $Param{ID} = $Self->TypeLookup(
            Type => $Param{Name},
        );
        if ( !$Param{ID} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "CustomerPortalID for Customer Portal '$Param{Name}' not found!",
            );
            return;
        }
    }

    # check cache
    my $CacheKey = 'CustomerPortalGet::ID::' . $Param{ID};
    my $Cache    = $Kernel::OM->Get('Kernel::System::Cache')->Get(
        Type => $Self->{CacheType},
        Key  => $CacheKey,
    );
    return %{$Cache} if $Cache;

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # ask the database
    return if !$DBObject->Prepare(
        SQL => 'SELECT id, name, valid_id, '
            . 'create_time, create_by, change_time, change_by '
            . 'FROM customer_portal WHERE id = ?',
        Bind => [ \$Param{ID} ],
    );

    # fetch the result
    my %CustomerPortal;
    while ( my @Data = $DBObject->FetchrowArray() ) {
        $CustomerPortal{ID}         = $Data[0];
        $CustomerPortal{Name}       = $Data[1];
        $CustomerPortal{ValidID}    = $Data[2];
        $CustomerPortal{CreateTime} = $Data[3];
        $CustomerPortal{CreateBy}   = $Data[4];
        $CustomerPortal{ChangeTime} = $Data[5];
        $CustomerPortal{ChangeBy}   = $Data[6];
    }

    # no data found
    if ( !%CustomerPortal ) {
        my $Error = $Param{Name} ? "Customer Portal '$Param{Name}'" : "CustomerPortalID '$Param{ID}'";
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => $Error . " not found!",
        );
        return;
    }

    # set cache
    $Kernel::OM->Get('Kernel::System::Cache')->Set(
        Type  => $Self->{CacheType},
        TTL   => $Self->{CacheTTL},
        Key   => $CacheKey,
        Value => \%CustomerPortal,
    );

    return %CustomerPortal;
}

=head2 CustomerPortalUpdate()

update customer portal attributes

    $CustomerPortalObject->CustomerPortalUpdate(
        ID      => 123,
        Name    => 'New Portal',
        ValidID => 1,
        UserID  => 123,
    );

=cut

sub CustomerPortalUpdate {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(ID Name ValidID UserID)) {
        if ( !$Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!"
            );
            return;
        }
    }

    # check if a portal with this name already exists
    if (
        $Self->NameExistsCheck(
            Name => $Param{Name},
            ID   => $Param{ID}
        )
        )
    {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "A customer portal with the name '$Param{Name}' already exists.",
        );
        return;
    }

    my %CustomerPortal = $Self->CustomerPortalGet(
        ID => $Param{ID},
    );

    # sql
    return if !$Kernel::OM->Get('Kernel::System::DB')->Do(
        SQL => 'UPDATE customer_portal SET name = ?, valid_id = ?, '
            . ' change_time = current_timestamp, change_by = ? WHERE id = ?',
        Bind => [
            \$Param{Name}, \$Param{ValidID}, \$Param{UserID}, \$Param{ID},
        ],
    );

    # reset cache
    $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
        Type => $Self->{CacheType},
    );

    return 1;
}

=head2 CustomerPortalList()

get portal list

    my %List = $CustomerPortalObject->CustomerPortalList();

or

    my %List = $CustomerPortalObject->CustomerPortalList(
        Valid => 0,
    );

=cut

sub CustomerPortalList {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    my $Valid = 1;
    if ( !$Param{Valid} && defined $Param{Valid} ) {
        $Valid = 0;
    }

    # check cache
    my $CacheKey = "CustomerPortalList::Valid::$Valid";
    my $Cache    = $Kernel::OM->Get('Kernel::System::Cache')->Get(
        Type => $Self->{CacheType},
        Key  => $CacheKey,
    );
    return %{$Cache} if $Cache;

    # create the valid list
    my $ValidIDs = join ', ', $Kernel::OM->Get('Kernel::System::Valid')->ValidIDsGet();

    # build SQL
    my $SQL = 'SELECT id, name FROM customer_portal';

    # add WHERE statement
    if ($Valid) {
        $SQL .= ' WHERE valid_id IN (' . $ValidIDs . ')';
    }

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # ask database
    return if !$DBObject->Prepare(
        SQL => $SQL,
    );

    # fetch the result
    my %CustomerPortalList;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $CustomerPortalList{ $Row[0] } = $Row[1];
    }

    # set cache
    $Kernel::OM->Get('Kernel::System::Cache')->Set(
        Type  => $Self->{CacheType},
        TTL   => $Self->{CacheTTL},
        Key   => $CacheKey,
        Value => \%CustomerPortalList,
    );

    return %CustomerPortalList;
}

=head2 CustomerPortalLookup()

get id or name for a customer portal

    my $Type = $CustomerPortalObject->CustomerPortalLookup( CustomerPortalID => $CustomerPortalID );

    my $CustomerPortalID = $CustomerPortalObject->CustomerPortalLookup( CustomerPortal => $CustomerPortal );

=cut

sub CustomerPortalLookup {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{CustomerPortal} && !$Param{CustomerPortalID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Got no CustomerPortal or CustomerPortalID!',
        );
        return;
    }

    # get (already cached) portal list
    my %CustomerPortalList = $Self->CustomerPortalList(
        Valid => 0,
    );

    my $Key;
    my $Value;
    my $ReturnData;
    if ( $Param{CustomerPortalID} ) {
        $Key        = 'CustomerPortalID';
        $Value      = $Param{CustomerPortalID};
        $ReturnData = $CustomerPortalList{ $Param{CustomerPortalID} };
    }
    else {
        $Key   = 'CustomerPortal';
        $Value = $Param{CustomerPortal};
        my %CustomerPortalListReverse = reverse %CustomerPortalList;
        $ReturnData = $CustomerPortalListReverse{ $Param{Type} };
    }

    # check if data exists
    if ( !defined $ReturnData ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "No $Key for $Value found!",
        );
        return;
    }

    return $ReturnData;
}

=head2 NameExistsCheck()

    return 1 if another portal with this name already exits

        $Exist = $CustomerPortalObject->NameExistsCheck(
            Name => 'Some::Template',
            ID => 1, # optional
        );

=cut

sub NameExistsCheck {
    my ( $Self, %Param ) = @_;

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');
    return if !$DBObject->Prepare(
        SQL  => 'SELECT id FROM customer_portal WHERE name = ?',
        Bind => [ \$Param{Name} ],
    );

    # fetch the result
    my $Flag;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        if ( !$Param{ID} || $Param{ID} ne $Row[0] ) {
            $Flag = 1;
        }
    }
    if ($Flag) {
        return 1;
    }
    return 0;
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<https://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
