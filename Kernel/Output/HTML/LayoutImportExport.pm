# --
# Kernel/Output/HTML/LayoutImportExport.pm - provides generic HTML output for ImportExport
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: LayoutImportExport.pm,v 1.3 2008-02-05 11:29:01 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::Output::HTML::LayoutImportExport;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.3 $) [1];

=item ImportExportFormInputCreate()

returns a input field html string

    my $String = $LayoutObject->ImportExportFormInputCreate(
        Item  => $ItemRef,
        Value => 'Value',   # (optional)
    );

=cut

sub ImportExportFormInputCreate {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{Item} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need Item!' );
        return;
    }

    # load backend
    my $BackendObject = $Self->_ImportExportLoadLayoutBackend(
        Type => $Param{Item}->{Input}->{Type},
    );

    return '' if !$BackendObject;

    # lookup item value
    my $String = $BackendObject->FormInputCreate(%Param);

    return $String;
}

=item ImportExportFormDataGet()

returns the values from the html form as hash reference

    my $FormData = $LayoutObject->ImportExportFormDataGet(
        Item => $ItemRef,
    );

=cut

sub ImportExportFormDataGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{Item} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need Item!' );
        return;
    }

    # load backend
    my $BackendObject = $Self->_ImportExportLoadLayoutBackend(
        Type => $Param{Item}->{Input}->{Type},
    );

    return if !$BackendObject;

    # get form data
    my $FormData = $BackendObject->FormDataGet(%Param);

    return $FormData;
}

=item _ImportExportLoadLayoutBackend()

to load a import/export layout backend module

    $HashRef = $LayoutObject->_ImportExportLoadLayoutBackend(
        Type => 'Selection',
    );

=cut

sub _ImportExportLoadLayoutBackend {
    my ( $Self, %Param ) = @_;

    if ( !$Param{Type} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need Type!',
        );
        return;
    }

    # check if object is already cached
    return $Self->{Cache}->{ImportExportLoadLayoutBackend}->{ $Param{Type} }
        if $Self->{Cache}->{ImportExportLoadLayoutBackend}->{ $Param{Type} };

    my $GenericModule = "Kernel::Output::HTML::ImportExportLayout$Param{Type}";

    # load the backend module
    if ( !$Self->{MainObject}->Require($GenericModule) ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Can't load backend module $Param{Type}!"
        );
        return;
    }

    # create new instance
    my $BackendObject = $GenericModule->new(
        %{$Self},
        %Param,
        LayoutObject => $Self,
    );

    if ( !$BackendObject ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Can't create a new instance of backend module $Param{Type}!",
        );
        return;
    }

    # cache the object
    $Self->{Cache}->{ImportExportLoadLayoutBackend}->{ $Param{Type} } = $BackendObject;

    return $BackendObject;
}

1;
