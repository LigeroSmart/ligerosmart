# --
# Kernel/Output/HTML/ImportExportLayoutText.pm - layout backend module
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: ImportExportLayoutText.pm,v 1.6 2008-04-04 10:21:59 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::Output::HTML::ImportExportLayoutText;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.6 $) [1];

=head1 NAME

Kernel::Output::HTML::ImportExportLayoutText - layout backend module

=head1 SYNOPSIS

All layout functions for text elements

=over 4

=cut

=item new()

create an object

    $BackendObject = Kernel::Output::HTML::ImportExportLayoutText->new(
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

    my $Value = $Param{Value} || $Param{Item}->{Input}->{ValueDefault};
    my $Size = $Param{Item}->{Input}->{Size} || 40;
    my $String = "<input type=\"Text\" name=\"$Param{Prefix}$Param{Item}->{Key}\" size=\"$Size\" ";

    if ($Value) {

        # translate
        if ( $Param{Item}->{Input}->{Translation} ) {
            $Value = $Self->{LayoutObject}->{LanguageObject}->Get($Value);
        }

        # transform ascii to html
        $Value = $Self->{LayoutObject}->Ascii2Html(
            Text           => $Value,
            HTMLResultMode => 1,
        );

        $String .= "value=\"$Value\" ";
    }

    # add maximum length
    if ( $Param{Item}->{Input}->{MaxLength} ) {
        $String .= "maxlength=\"$Param{Item}->{Input}->{MaxLength}\" ";
    }

    $String .= "> ";

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

    # regex check
    if ( $Param{Item}->{Input}->{Regex} && $FormData !~ $Param{Item}->{Input}->{Regex} ) {

        $Param{Item}->{Form}->{Invalid} = 1;
        return $FormData;
    }

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

$Revision: 1.6 $ $Date: 2008-04-04 10:21:59 $

=cut
