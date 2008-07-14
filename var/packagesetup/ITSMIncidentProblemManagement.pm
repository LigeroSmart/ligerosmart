# --
# ITSMIncidentProblemManagement.pm - code to excecute during package installation
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: ITSMIncidentProblemManagement.pm,v 1.3 2008-07-14 14:40:05 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package var::packagesetup::ITSMIncidentProblemManagement;

use strict;
use warnings;

use Kernel::System::State;
use Kernel::System::Type;
use Kernel::System::Valid;

use vars qw(@ISA $VERSION);
$VERSION = qw($Revision: 1.3 $) [1];

=head1 NAME

ITSMIncidentProblemManagement.pm - code to excecute during package installation

=head1 SYNOPSIS

All functions

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create an object

    use Kernel::Config;
    use Kernel::System::Log;
    use Kernel::System::Main;
    use Kernel::System::DB;

    my $ConfigObject = Kernel::Config->new();
    my $LogObject    = Kernel::System::Log->new(
        ConfigObject => $ConfigObject,
    );
    my $MainObject = Kernel::System::Main->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
    );
    my $CodeObject = ITSMIncidentProblemManagement->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
        MainObject   => $MainObject,
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for my $Object (qw(ConfigObject LogObject MainObject TimeObject DBObject XMLObject)) {
        $Self->{$Object} = $Param{$Object} || die "Got no $Object!";
    }
    $Self->{StateObject} = Kernel::System::State->new( %{$Self} );
    $Self->{TypeObject}  = Kernel::System::Type->new( %{$Self} );
    $Self->{ValidObject} = Kernel::System::Valid->new( %{$Self} );

    return $Self;
}

=item CodeInstall()

run the code install part

    my $Result = $CodeObject->CodeInstall();

=cut

sub CodeInstall {
    my ( $Self, %Param ) = @_;

    # set new ticket states to valid
    {
        my @StateNames = (
            'closed with workaround',
        );

        # set states to valid
        $Self->_SetStateValid(
            StateNames => \@StateNames,
            Valid      => 1,
        );
    }

    # set new ticket types to valid
    {
        my @TypeNames = (
            'Incident',
            'Incident::ServiceRequest',
            'Incident::Disaster',
            'Problem',
            'Problem::KnownError',
            'Problem::PendingRfC',
        );

        # set types to valid
        $Self->_SetTypeValid(
            TypeNames => \@TypeNames,
            Valid     => 1,
        );
    }

    return 1;
}

=item CodeUninstall()

run the code uninstall part

    my $Result = $CodeObject->CodeUninstall();

=cut

sub CodeUninstall {
    my ( $Self, %Param ) = @_;

    # set new ticket states to invalid
    {
        my @StateNames = (
            'closed with workaround',
        );

        # set states to invalid
        $Self->_SetStateValid(
            StateNames => \@StateNames,
            Valid      => 0,
        );
    }

    # set new ticket types to invalid
    {
        my @TypeNames = (
            'Incident',
            'Incident::ServiceRequest',
            'Incident::Disaster',
            'Problem',
            'Problem::KnownError',
            'Problem::PendingRfC',
        );

        # set types to invalid
        $Self->_SetTypeValid(
            TypeNames => \@TypeNames,
            Valid     => 0,
        );
    }

    return 1;
}

=item _SetStateValid()

sets states to valid|invalid

    my $Result = $CodeObject->_SetStateValid(
        StateNames => [ 'new', 'open' ],
        Valid      => 1,
    );

=cut

sub _SetStateValid {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{StateNames} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need StateNames!' );
        return;
    }

    # lookup valid id
    my %ValidList = $Self->{ValidObject}->ValidList();
    %ValidList = reverse %ValidList;
    my $ValidID = $Param{Valid} ? $ValidList{valid} : $ValidList{invalid};

    STATENAME:
    for my $StateName ( @{ $Param{StateNames} } ) {

        # get state
        my %State = $Self->{StateObject}->StateGet(
            Name => $StateName,
        );

        next STATENAME if !%State;

        # set state
        $Self->{StateObject}->StateUpdate(
            %State,
            ValidID => $ValidID,
            UserID  => 1,
        );
    }

    return 1;
}

=item _SetTypeValid()

sets types to valid|invalid

    my $Result = $CodeObject->_SetTypeValid(
        TypeNames => [ 'Incident', 'Problem' ],
        Valid     => 1,
    );

=cut

sub _SetTypeValid {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{TypeNames} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need TypeNames!' );
        return;
    }

    # lookup valid id
    my %ValidList = $Self->{ValidObject}->ValidList();
    %ValidList = reverse %ValidList;
    my $ValidID = $Param{Valid} ? $ValidList{valid} : $ValidList{invalid};

    TYPENAME:
    for my $TypeName ( @{ $Param{TypeNames} } ) {

        # lookup type id
        my $TypeID = $Self->{TypeObject}->TypeLookup(
            Type => $TypeName,
        );

        next TYPENAME if !$TypeID;

        # get type
        my %Type = $Self->{TypeObject}->TypeGet(
            ID => $TypeID,
        );

        # set type
        $Self->{TypeObject}->TypeUpdate(
            %Type,
            ValidID => $ValidID,
            UserID  => 1,
        );
    }

    return 1;
}

1;

=back

=head1 TERMS AND CONDITIONS

This Software is part of the OTRS project (http://otrs.org/).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.

=cut

=head1 VERSION

$Revision: 1.3 $ $Date: 2008-07-14 14:40:05 $

=cut
