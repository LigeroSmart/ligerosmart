# --
# Kernel/System/ITSMChange.pm - all change functions
# Copyright (C) 2003-2009 OTRS AG, http://otrs.com/
# --
# $Id: ITSMChange.pm,v 1.1 2009-10-02 13:07:31 ub Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::ITSMChange;

use strict;
use warnings;

use Kernel::System::Valid;
use Kernel::System::ITSMChange::WorkOrder;

use vars qw(@ISA $VERSION);
$VERSION = qw($Revision: 1.1 $) [1];

=head1 NAME

Kernel::System::ITSMChange - change lib

=head1 SYNOPSIS

All config item functions.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create an object

    use Kernel::Config;
    use Kernel::System::Encode;
    use Kernel::System::Log;
    use Kernel::System::DB;
    use Kernel::System::Main;
    use Kernel::System::ITSMChange;

    my $ConfigObject = Kernel::Config->new();
    my $EncodeObject = Kernel::System::Encode->new(
        ConfigObject => $ConfigObject,
    );
    my $LogObject = Kernel::System::Log->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
    );
    my $MainObject = Kernel::System::Main->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
    );
    my $DBObject = Kernel::System::DB->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
        MainObject   => $MainObject,
    );
    my $ChangeObject = Kernel::System::ITSMChange->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
        DBObject     => $DBObject,
        MainObject   => $MainObject,
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for my $Object (qw(DBObject ConfigObject EncodeObject LogObject MainObject)) {
        $Self->{$Object} = $Param{$Object} || die "Got no $Object!";
    }

    $Self->{ValidObject}     = Kernel::System::Valid->new( %{$Self} );
    $Self->{WorkOrderObject} = Kernel::System::ITSMChange::WorkOrder->new( %{$Self} );

    return $Self;
}

=item ChangeAdd()

short description of ChangeAdd

    my $ChangeID = $ChangeObject->ChangeAdd(
        Test1 => 123,
        Test2 => 'Hello',  # (optional)
    );

=cut

sub ChangeAdd {
    my ( $Self, %Param ) = @_;

    return $ChangeID;
}

=item ChangeUpdate()

short description of ChangeUpdate

    my $Result = $ChangeObject->ChangeUpdate(
        ChangeID => 123,
        Test2    => 'Hello',  # (optional)
    );

=cut

sub ChangeUpdate {
    my ( $Self, %Param ) = @_;

    return;
}

=item ChangeGet()

short description of ChangeGet

    my $Result = $ChangeObject->ChangeGet(
        ChangeID => 123,
    );

=cut

sub ChangeGet {
    my ( $Self, %Param ) = @_;

    return;
}

=item ChangeList()

short description of ChangeList

    my $Result = $ChangeObject->ChangeList();

=cut

sub ChangeList {
    my ( $Self, %Param ) = @_;

    return;
}

=item ChangeSearch()

short description of ChangeSearch

    my $Result = $ChangeObject->ChangeSearch(
        Test1 => 123,
        Test2 => 'Hello',  # (optional)
    );

=cut

sub ChangeSearch {
    my ( $Self, %Param ) = @_;

    return;
}

=item ChangeDelete()

short description of ChangeDelete

NOTE: This function must first remove all links to this ChangeObject,
      delete the history of this ChangeObject,
      then get a list of all WorkOrderObjects of this change and
      call WorkorderDelete for each WorkOrder (which will itself delete
      all links to the WorkOrder).

    my $Result = $ChangeObject->ChangeDelete(
        ChangeID => 123,
        Test1 => 123,
        Test2 => 'Hello',  # (optional)
    );

=cut

sub ChangeDelete {
    my ( $Self, %Param ) = @_;

    return;
}

=item ChangeEditWorkflow()

short description of ChangeEditWorkflow

    my $Result = $ChangeObject->ChangeEditWorkflow(
        Test1 => 123,
        Test2 => 'Hello',  # (optional)
    );

=cut

sub ChangeEditWorkflow {
    my ( $Self, %Param ) = @_;

    return;
}

=item ChangeListWorkflow()

short description of ChangeListWorkflow

    my $Result = $ChangeObject->ChangeListWorkflow(
        Test1 => 123,
        Test2 => 'Hello',  # (optional)
    );

=cut

sub ChangeListWorkflow {
    my ( $Self, %Param ) = @_;

    return;
}

=item _ChangeGetStart()

short description of _ChangeGetStart

    my $ChangeStartTime = $ChangeObject->_ChangeGetStart(
        ChangeID => 123,
        Type     => 'planned' || 'actual',
    );

=cut

sub _ChangeGetStart {
    my ( $Self, %Param ) = @_;

    return;
}

=item _ChangeGetEnd()

short description of _ChangeGetEnd

    my $ChangeEndTime = $ChangeObject->_ChangeGetEnd(
        ChangeID => 123,
        Type     => 'planned' || 'actual',
    );

=cut

sub _ChangeGetEnd {
    my ( $Self, %Param ) = @_;

    return;
}

=item _ChangeGetTicks()

NOTE: Maybe this function better belongs to Kernel/Output/HTML/LayoutITSMChange.pm

short description of _ChangeGetTicks

    my $Result = $ChangeObject->_ChangeGetTicks(
        Test1 => 123,
        Test2 => 'Hello',  # (optional)
    );

=cut

sub _ChangeGetTicks {
    my ( $Self, %Param ) = @_;

    return;
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

$Revision: 1.1 $ $Date: 2009-10-02 13:07:31 $

=cut
