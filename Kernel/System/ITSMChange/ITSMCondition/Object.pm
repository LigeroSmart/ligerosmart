# --
# Kernel/System/ITSMChange/ITSMCondition/Object.pm - all condition object functions
# Copyright (C) 2003-2009 OTRS AG, http://otrs.com/
# --
# $Id: Object.pm,v 1.1 2009-12-23 10:15:31 mae Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::ITSMChange::ITSMCondition::Object;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.1 $) [1];

=head1 NAME

Kernel::System::ITSMChange::ITSMCondition::Object - condition object lib

=head1 SYNOPSIS

All functions for condition objects in ITSMChangeManagement.

=head1 PUBLIC INTERFACE

=over 4

=item ObjectAdd()

Add a new object.

    my $ConditionID = $ConditionObject->ObjectAdd(
        UserID   => 1,
    );

=cut

sub ObjectAdd {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(UserID)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    my $ObjectID;
    return $ObjectID;
}

=item ObjectUpdate()

=cut

sub ObjectUpdate {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(ObjectID UserID)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    return 1;
}

=item ObjectGet()

=cut

sub ObjectGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Attribute (qw(ObjectID UserID)) {
        if ( !$Param{$Attribute} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Attribute!",
            );
            return;
        }
    }

    my %ObjectData;
    return \%ObjectData;
}

=item ObjectLookup()

=cut

sub ObjectLookup {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Attribute (qw(UserID)) {
        if ( !$Param{$Attribute} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Attribute!",
            );
            return;
        }
    }

    return;
}

=item ObjectList()

return a list of all condition object ids as array reference

    my $ConditionObjectIDsRef = $ConditionObject->ObjectList(
        UserID   => 1,
    );

=cut

sub ObjectList {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Attribute (qw(UserID)) {
        if ( !$Param{$Attribute} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Attribute!",
            );
            return;
        }
    }

    return [];
}

=item ObjectDelete()

Delete a condition.

    my $Success = $ConditionObject->ObjectDelete(
        ObjectID => 123,
        UserID   => 1,
    );

=cut

sub ObjectDelete {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Attribute (qw(ObjectID UserID)) {
        if ( !$Param{$Attribute} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Attribute!",
            );
            return;
        }
    }

    return 1;
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (http://otrs.org/).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see http://www.gnu.org/licenses/agpl.txt.

=cut

=head1 VERSION

$Revision: 1.1 $ $Date: 2009-12-23 10:15:31 $

=cut
