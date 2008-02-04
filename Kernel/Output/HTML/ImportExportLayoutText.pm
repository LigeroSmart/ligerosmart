# --
# Kernel/Output/HTML/ImportExportLayoutText.pm - layout backend module
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: ImportExportLayoutText.pm,v 1.2 2008-02-04 12:19:54 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::Output::HTML::ImportExportLayoutText;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.2 $) [1];

=head1 NAME

Kernel::Output::HTML::ImportExportLayoutText - layout backend module

=head1 SYNOPSIS

All layout functions for text elements

=over 4

=cut

=item new()

create a object

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
        Item  => $ItemRef,
        Value => 'Value',   # (optional)
    );

=cut

sub FormInputCreate {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{Item} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need Item!' );
        return;
    }

    my $Size = $Param{Item}->{Input}->{Size} || 40;
    my $Key  = $Param{Item}->{Key}           || '';
    my $Value = $Param{Value} || $Param{Item}->{Input}->{ValueDefault} || '';

    my $String = "<input type=\"Text\" name=\"$Key\" size=\"$Size\" ";

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

    $String .= "> ";

    return $String;
}

=item FormDataGet()

get form data

    my $FormData = $BackendObject->FormDataGet(
        Item => $ItemRef,
    );

=cut

sub FormDataGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{Item} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need Item!' );
        return;
    }

    # get form data
    my $FormData = $Self->{ParamObject}->GetParam( Param => $Param{Item}->{Key} );

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

$Revision: 1.2 $ $Date: 2008-02-04 12:19:54 $

=cut
