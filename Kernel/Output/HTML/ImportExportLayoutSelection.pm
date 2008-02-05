# --
# Kernel/Output/HTML/ImportExportLayoutSelection.pm - layout backend module
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: ImportExportLayoutSelection.pm,v 1.4 2008-02-05 19:23:56 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::Output::HTML::ImportExportLayoutSelection;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.4 $) [1];

=head1 NAME

Kernel::Output::HTML::ImportExportLayoutSelection - layout backend module

=head1 SYNOPSIS

All layout functions for selection elements

=over 4

=cut

=item new()

create a object

    $BackendObject = Kernel::Output::HTML::ImportExportLayoutSelection->new(
        %Param,
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for my $Object (qw(ConfigObject LogObject MainObject ParamObject LayoutObject)) {
        $Self->{$Object} = $Param{$Object} || die "Got no $Object!";
    }

    return $Self;
}

=item FormInputCreate()

create a input string

    my $Value = $BackendObject->FormInputCreate(
        Item   => $ItemRef,
        Prefix => 'Prefix::',  # (optional)
        Value  => 'Value',     # (optional)
    );

=cut

sub FormInputCreate {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{Item} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need Item!' );
        return;
    }

    $Param{Prefix} ||= '';

    # set default value
    if ( !defined $Param{Item}->{Input}->{Translation} ) {
        $Param{Item}->{Input}->{Translation} = 1;
    }

    # generate option string
    my $String = $Self->{LayoutObject}->BuildSelection(
        Name       => $Param{Prefix} . $Param{Item}->{Key},
        Data       => $Param{Item}->{Input}->{Data} || {},
        SelectedID => $Param{Value}                 || $Param{Item}->{Input}->{ValueDefault},
        Translation => $Param{Item}->{Input}->{Translation},
        PossibleNone => $Param{Item}->{Input}->{PossibleNone} || 0,
    );

    return $String;
}

=item FormDataGet()

get form data

    my $FormData = $BackendObject->FormDataGet(
        Item   => $ItemRef,
        Prefix => 'Prefix::',  # (optional)
    );

=cut

sub FormDataGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{Item} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need Item!' );
        return;
    }

    $Param{Prefix} ||= '';

    # get form data
    my $FormData = $Self->{ParamObject}->GetParam(
        Param => $Param{Prefix} . $Param{Item}->{Key},
    );

    return $FormData if $FormData;
    return $FormData if !$Param{Item}->{Input}->{Required};

    # set invalid param
    $Param{Item}->{Form}->{Invalid} = 1;

    return $FormData;
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (http://otrs.org/).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.

=cut

=head1 VERSION

$Revision: 1.4 $ $Date: 2008-02-05 19:23:56 $

=cut
