# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::FAQ::State;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::System::Cache',
    'Kernel::System::DB',
    'Kernel::System::Log',
);

=head1 NAME

Kernel::System::FAQ::State - sub module of Kernel::System::FAQ

=head1 DESCRIPTION

All FAQ state functions.

=head1 PUBLIC INTERFACE

=head2 StateAdd()

add a state

    my $Success = $FAQObject->StateAdd(
        Name   => 'public',
        TypeID => 1,
        UserID => 1,
    );

Returns:

    $Success = 1;               # or undef if state could not be added

=cut

sub StateAdd {
    my ( $Self, %Param ) = @_;

    for my $Argument (qw(Name TypeID UserID)) {
        if ( !$Param{$Argument} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );

            return;
        }
    }

    return if !$Kernel::OM->Get('Kernel::System::DB')->Do(
        SQL => '
            INSERT INTO faq_state (name, type_id)
            VALUES ( ?, ? )',
        Bind => [ \$Param{Name}, \$Param{TypeID} ],
    );

    return 1;
}

=head2 StateGet()

get a state as hash

    my %State = $FAQObject->StateGet(
        StateID => 1,
        UserID  => 1,
    );

Returns:

    %State = (
        StateID  => 1,
        Name     => 'internal (agent)',
        TypeID   => 1,
    );

=cut

sub StateGet {
    my ( $Self, %Param ) = @_;

    for my $Argument (qw(StateID UserID)) {
        if ( !$Param{$Argument} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );

            return;
        }
    }

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # SQL
    return if !$DBObject->Prepare(
        SQL => '
            SELECT id, name, type_id
            FROM faq_state
            WHERE id = ?',
        Bind  => [ \$Param{StateID} ],
        Limit => 1,
    );

    my %Data;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        %Data = (
            StateID => $Row[0],
            Name    => $Row[1],
            TypeID  => $Row[2],
        );
    }

    return %Data;
}

=head2 StateList()

get the state list as hash

    my %States = $FAQObject->StateList(
        UserID => 1,
    );

optional, get state list for some state types:

    my $StateTypeHashRef = $FAQObject->StateTypeList(
        Types  => [ 'public', 'internal'],
        UserID => 1,
    );

Returns:

    %States = (
        1 => 'internal (agent)',
        2 => 'external (customer)',
        3 => 'public (all)',
    );

=cut

sub StateList {
    my ( $Self, %Param ) = @_;

    if ( !$Param{UserID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need UserID!',
        );

        return;
    }

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    my $SQL = '
        SELECT id, name
        FROM faq_state';

    # Filter state list by type id if available.
    if ( IsArrayRefWithData( $Param{Types} ) ) {
        my $StateTypeHashRef = $Self->StateTypeList(
            Types  => $Param{Types},
            UserID => $Param{UserID},
        );
        if ( IsHashRefWithData($StateTypeHashRef) ) {
            $SQL .= ' WHERE type_id IN ( ' . join( ', ', sort keys %{$StateTypeHashRef} ) . ' )';
        }
    }

    return if !$DBObject->Prepare( SQL => $SQL );

    my %List;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $List{ $Row[0] } = $Row[1];
    }

    return %List;
}

=head2 StateUpdate()

update a state

    my Success = $FAQObject->StateUpdate(
        StateID => 1,
        Name    => 'public',
        TypeID  => 1,
        UserID  => 1,
    );

Returns:

    Success = 1;             # or undef if state could not be updated

=cut

sub StateUpdate {
    my ( $Self, %Param ) = @_;

    for my $Argument (qw(StateID Name TypeID UserID)) {
        if ( !$Param{$Argument} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );

            return;
        }
    }

    # SQL
    return if !$Kernel::OM->Get('Kernel::System::DB')->Do(
        SQL => '
            UPDATE faq_state
            SET name = ?, type_id = ?,
            WHERE id = ?',
        Bind => [ \$Param{Name}, \$Param{TypeID}, \$Param{StateID} ],
    );

    return 1;
}

=head2 StateTypeGet()

get a state as hash reference

    my $StateTypeHashRef = $FAQObject->StateTypeGet(
        StateID => 1,
        UserID  => 1,
    );

Or

    my $StateTypeHashRef = $FAQObject->StateTypeGet(
        Name    => 'internal',
        UserID  => 1,
    );

Returns:

    $StateTypeHashRef = {
        'StateID' => 1,
        'Name'    => 'internal',
    };

=cut

sub StateTypeGet {
    my ( $Self, %Param ) = @_;

    if ( !$Param{UserID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need UserID!",
        );

        return;
    }

    my $SQL = '
        SELECT id, name
        FROM faq_state_type
        WHERE';
    my @Bind;
    my $CacheKey = 'StateTypeGet::';
    if ( defined $Param{StateID} ) {
        $SQL .= ' id = ?';
        push @Bind, \$Param{StateID};
        $CacheKey .= 'ID::' . $Param{StateID};
    }
    elsif ( defined $Param{Name} ) {
        $SQL .= ' name = ?';
        push @Bind, \$Param{Name};
        $CacheKey .= 'Name::' . $Param{Name};
    }

    my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

    # check cache
    my $Cache = $CacheObject->Get(
        Type => 'FAQ',
        Key  => $CacheKey,
    );

    return $Cache if $Cache;

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # SQL
    return if !$DBObject->Prepare(
        SQL  => $SQL,
        Bind => \@Bind,
    );

    my %Data;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        %Data = (
            StateID => $Row[0],
            Name    => $Row[1],
        );
    }

    # cache result
    $CacheObject->Set(
        Type  => 'FAQ',
        Key   => $CacheKey,
        Value => \%Data,
        TTL   => 60 * 60 * 24 * 2,
    );

    return \%Data;
}

=head2 StateTypeList()

get the state type list as hash reference

    my $StateTypeHashRef = $FAQObject->StateTypeList(
        UserID => 1,
    );

optional, get state type list for some states:

    my $StateTypeHashRef = $FAQObject->StateTypeList(
        Types  => [ 'public', 'internal'],
        UserID => 1,
    );

Returns:

    $StateTypeHashRef = {
        1 => 'internal',
        3 => 'public',
        2 => 'external',
    };

=cut

sub StateTypeList {
    my ( $Self, %Param ) = @_;

    if ( !$Param{UserID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need UserID!',
        );

        return;
    }

    # build SQL
    my $SQL = '
        SELECT id, name
        FROM faq_state_type';

    # types are given
    if ( $Param{Types} ) {

        if ( ref $Param{Types} ne 'ARRAY' ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => 'Types should be an array reference!',
            );
        }

        # call StateTypeList without parameters to validate Types
        my $StateTypeList = $Self->StateTypeList( UserID => $Param{UserID} );
        my %StateTypes    = reverse %{ $StateTypeList || {} };
        my @Types;

        # only add types to list that exist
        TYPE:
        for my $Type ( @{ $Param{Types} } ) {
            next TYPE if !$StateTypes{$Type};
            push @Types, "'$Type'";
        }

        # create string
        if (@Types) {
            $SQL .= ' WHERE name IN ( ' . join( ', ', @Types ) . ' )';
        }
    }

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # prepare SQL
    return if !$DBObject->Prepare( SQL => $SQL );

    # fetch the result
    my %List;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $List{ $Row[0] } = $Row[1];
    }

    return \%List;
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<https://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
