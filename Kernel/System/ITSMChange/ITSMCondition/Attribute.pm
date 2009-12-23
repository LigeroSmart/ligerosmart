# --
# Kernel/System/ITSMChange/ITSMCondition/Attribute.pm - all condition attribute functions
# Copyright (C) 2003-2009 OTRS AG, http://otrs.com/
# --
# $Id: Attribute.pm,v 1.1 2009-12-23 10:33:09 mae Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::ITSMChange::ITSMCondition::Attribute;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.1 $) [1];

=head1 NAME

Kernel::System::ITSMChange::ITSMCondition::Attribute - condition attribute lib

=head1 SYNOPSIS

All functions for condition attributes in ITSMChangeManagement.

=head1 PUBLIC INTERFACE

=over 4

=item AttributeAdd()

Add a new attribute.

    my $ConditionID = $ConditionObject->AttributeAdd(
        UserID   => 1,
    );

=cut

sub AttributeAdd {
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

    my $AttributeID;
    return $AttributeID;
}

=item AttributeUpdate()

=cut

sub AttributeUpdate {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(AttributeID UserID)) {
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

=item AttributeGet()

=cut

sub AttributeGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Attribute (qw(AttributeID UserID)) {
        if ( !$Param{$Attribute} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Attribute!",
            );
            return;
        }
    }

    my %AttributeData;
    return \%AttributeData;
}

=item AttributeLookup()

=cut

sub AttributeLookup {
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

=item AttributeList()

return a list of all condition Attribute ids as array reference

    my $ConditionAttributeIDsRef = $ConditionObject->AttributeList(
        UserID   => 1,
    );

=cut

sub AttributeList {
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

=item AttributeDelete()

Delete a condition.

    my $Success = $ConditionObject->AttributeDelete(
        AttributeID => 123,
        UserID   => 1,
    );

=cut

sub AttributeDelete {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Attribute (qw(AttributeID UserID)) {
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

$Revision: 1.1 $ $Date: 2009-12-23 10:33:09 $

=cut
