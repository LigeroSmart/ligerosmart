# --
# ITSMCore.pm - code to excecute during package installation
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: ITSMCore.pm,v 1.6 2008-07-15 09:15:16 ub Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package var::packagesetup::ITSMCore;

use strict;
use warnings;

use Kernel::System::GeneralCatalog;
use Kernel::System::Group;
use Kernel::System::ITSMCIPAllocate;
use Kernel::System::Priority;
use Kernel::System::Valid;

use vars qw(@ISA $VERSION);
$VERSION = qw($Revision: 1.6 $) [1];

=head1 NAME

ITSMCore.pm - code to excecute during package installation

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
    my $CodeObject = ITSMCore->new(
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
    $Self->{GeneralCatalogObject} = Kernel::System::GeneralCatalog->new( %{$Self} );
    $Self->{GroupObject}          = Kernel::System::Group->new( %{$Self} );
    $Self->{CIPAllocateObject}    = Kernel::System::ITSMCIPAllocate->new( %{$Self} );
    $Self->{PriorityObject}       = Kernel::System::Priority->new( %{$Self} );
    $Self->{ValidObject}          = Kernel::System::Valid->new( %{$Self} );

    return $Self;
}

=item CodeInstall()

run the code install part

    my $Result = $CodeObject->CodeInstall();

=cut

sub CodeInstall {
    my ( $Self, %Param ) = @_;

    # change background color to the ITSM blue
    $Self->_BackgroundColorChange(
        OldColor => 'bbddff',
        NewColor => '003399',
    );

    # set default CIP matrix
    $Self->_CIPDefaultMatrixSet();

    # add the group itsm-service
    $Self->_GroupAdd(
        Name        => 'itsm-service',
        Description => 'Group for ITSM Service mask access in the agent interface.',
    );

    return 1;
}

=item CodeReinstall()

run the code reinstall part

    my $Result = $CodeObject->CodeReinstall();

=cut

sub CodeReinstall {
    my ( $Self, %Param ) = @_;

    # change background color to the ITSM blue
    $Self->_BackgroundColorChange(
        OldColor => 'bbddff',
        NewColor => '003399',
    );

    # set default CIP matrix
    $Self->_CIPDefaultMatrixSet();

    # add the group itsm-service
    $Self->_GroupAdd(
        Name        => 'itsm-service',
        Description => 'Group for ITSM Service mask access in the agent interface.',
    );

    return 1;
}

=item CodeUpgrade()

run the code upgrade part

    my $Result = $CodeObject->CodeUpgrade();

=cut

sub CodeUpgrade {
    my ( $Self, %Param ) = @_;

    # set default CIP matrix
    $Self->_CIPDefaultMatrixSet();

    return 1;
}

=item CodeUninstall()

run the code uninstall part

    my $Result = $CodeObject->CodeUninstall();

=cut

sub CodeUninstall {
    my ( $Self, %Param ) = @_;

    # restore the original background
    $Self->_BackgroundColorChange(
        OldColor => '003399',
        NewColor => 'bbddff',
    );

    # deactivate the group itsm-service
    $Self->_GroupDeactivate(
        Name => 'itsm-service',
    );

    return 1;
}

=item _BackgroundColorChange()

change the backround color

    my $Result = $CodeObject->_BackgroundColorChange(
        OldColor => 'bbddff',
        NewColor => '003399',
    );

=cut

sub _BackgroundColorChange {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(OldColor NewColor)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # define the css file
    my $CssFile = $Self->{ConfigObject}->Get('Home') . '/Kernel/Output/HTML/Standard/css.dtl';

    return 1 if -e $CssFile . '.save';

    # read file content
    my $Content = $Self->{MainObject}->FileRead(
        Location        => $CssFile,
        Mode            => 'binmode',
        Result          => 'SCALAR',
        DisableWarnings => 1,
    );

    return if !$Content;
    return if ref $Content ne 'SCALAR';
    return if !${$Content};

    # change background color
    ${$Content} =~ s{
        background-color\:\#$Param{OldColor}\;
    }{background-color\:\#$Param{NewColor}\;}xms;

    # write new content to file
    $Self->{MainObject}->FileWrite(
        Location => $CssFile,
        Content  => $Content,
        Mode     => 'binmode',
    );

    return 1;
}

=item _CIPDefaultMatrixSet()

set the default CIP matrix

    my $Result = $CodeObject->_CIPDefaultMatrixSet();

=cut

sub _CIPDefaultMatrixSet {
    my ( $Self, %Param ) = @_;

    # get current allocation list
    my $List = $Self->{CIPAllocateObject}->AllocateList(
        UserID => 1,
    );

    return if !$List;
    return if ref $List ne 'HASH';

    # set no matrix if already defined
    return if %{$List};

    # define the allocations
    my %Allocation;
    $Allocation{'1 very low'}->{'1 very low'}   = '1 very low';
    $Allocation{'1 very low'}->{'2 low'}        = '1 very low';
    $Allocation{'1 very low'}->{'3 normal'}     = '2 low';
    $Allocation{'1 very low'}->{'4 high'}       = '2 low';
    $Allocation{'1 very low'}->{'5 very high'}  = '3 normal';
    $Allocation{'2 low'}->{'1 very low'}        = '1 very low';
    $Allocation{'2 low'}->{'2 low'}             = '2 low';
    $Allocation{'2 low'}->{'3 normal'}          = '2 low';
    $Allocation{'2 low'}->{'4 high'}            = '3 normal';
    $Allocation{'2 low'}->{'5 very high'}       = '4 high';
    $Allocation{'3 normal'}->{'1 very low'}     = '2 low';
    $Allocation{'3 normal'}->{'2 low'}          = '2 low';
    $Allocation{'3 normal'}->{'3 normal'}       = '3 normal';
    $Allocation{'3 normal'}->{'4 high'}         = '4 high';
    $Allocation{'3 normal'}->{'5 very high'}    = '4 high';
    $Allocation{'4 high'}->{'1 very low'}       = '2 low';
    $Allocation{'4 high'}->{'2 low'}            = '3 normal';
    $Allocation{'4 high'}->{'3 normal'}         = '4 high';
    $Allocation{'4 high'}->{'4 high'}           = '4 high';
    $Allocation{'4 high'}->{'5 very high'}      = '5 very high';
    $Allocation{'5 very high'}->{'1 very low'}  = '3 normal';
    $Allocation{'5 very high'}->{'2 low'}       = '4 high';
    $Allocation{'5 very high'}->{'3 normal'}    = '4 high';
    $Allocation{'5 very high'}->{'4 high'}      = '5 very high';
    $Allocation{'5 very high'}->{'5 very high'} = '5 very high';

    # get impact list
    my $ImpactList = $Self->{GeneralCatalogObject}->ItemList(
        Class => 'ITSM::Core::Impact',
    );
    my %ImpactListReverse = reverse %{$ImpactList};

    # get criticality list
    my $CriticalityList = $Self->{GeneralCatalogObject}->ItemList(
        Class => 'ITSM::Core::Criticality',
    );
    my %CriticalityListReverse = reverse %{$CriticalityList};

    # get priority list
    my %PriorityList = $Self->{PriorityObject}->PriorityList(
        UserID => 1,
    );
    my %PriorityListReverse = reverse %PriorityList;

    # create the allocation matrix
    my %AllocationMatrix;
    IMPACT:
    for my $Impact ( keys %Allocation ) {

        next IMPACT if !$ImpactListReverse{$Impact};

        # extract impact id
        my $ImpactID = $ImpactListReverse{$Impact};

        CRITICALITY:
        for my $Criticality ( keys %{ $Allocation{$Impact} } ) {

            next CRITICALITY if !$CriticalityListReverse{$Criticality};

            # extract priority
            my $Priority = $Allocation{$Impact}->{$Criticality};

            next CRITICALITY if !$PriorityListReverse{$Priority};

            # extract criticality id and priority id
            my $CriticalityID = $CriticalityListReverse{$Criticality};
            my $PriorityID    = $PriorityListReverse{$Priority};

            $AllocationMatrix{$ImpactID}->{$CriticalityID} = $PriorityID;
        }
    }

    # save the matrix
    $Self->{CIPAllocateObject}->AllocateUpdate(
        AllocateData => \%AllocationMatrix,
        UserID       => 1,
    );

    return 1;
}

=item _GroupAdd()

add a group

    my $Result = $CodeObject->_GroupAdd(
        Name        => 'the-group-name',
        Description => 'The group description.',
    );

=cut

sub _GroupAdd {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(Name Description)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # get valid list
    my %ValidList = $Self->{ValidObject}->ValidList(
        UserID => 1,
    );
    my %ValidListReverse = reverse %ValidList;

    # check if group already exists
    my $GroupID = $Self->{GroupObject}->GroupLookup(
        Group  => $Param{Name},
        UserID => 1,
    );

    # reactivate the group
    if ($GroupID) {

        # get current group data
        my %GroupData = $Self->{GroupObject}->GroupGet(
            ID     => $GroupID,
            UserID => 1,
        );

        # reactivate group
        $Self->{GroupObject}->GroupUpdate(
            %GroupData,
            ValidID => $ValidListReverse{valid},
            UserID  => 1,
        );

        return 1;
    }

    # add the group
    else {
        return if !$Self->{GroupObject}->GroupAdd(
            Name    => $Param{Name},
            Comment => $Param{Description},
            ValidID => $ValidListReverse{valid},
            UserID  => 1,
        );
    }

    # lookup the new group id
    my $NewGroupID = $Self->{GroupObject}->GroupLookup(
        Group  => $Param{Name},
        UserID => 1,
    );

    # add user root to the group
    $Self->{GroupObject}->GroupMemberAdd(
        GID        => $NewGroupID,
        UID        => 1,
        Permission => {
            ro        => 1,
            move_into => 1,
            create    => 1,
            owner     => 1,
            priority  => 1,
            rw        => 1,
        },
        UserID => 1,
    );

    return 1;
}

=item _GroupDeactivate()

deactivate a group

    my $Result = $CodeObject->_GroupDeactivate(
        Name => 'the-group-name',
    );

=cut

sub _GroupDeactivate {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{Name} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need Name!',
        );
        return;
    }

    # lookup group id
    my $GroupID = $Self->{GroupObject}->GroupLookup(
        Group => $Param{Name},
    );

    return if !$GroupID;

    # get valid list
    my %ValidList = $Self->{ValidObject}->ValidList(
        UserID => 1,
    );
    my %ValidListReverse = reverse %ValidList;

    # get current group data
    my %GroupData = $Self->{GroupObject}->GroupGet(
        ID     => $GroupID,
        UserID => 1,
    );

    # deactivate group
    $Self->{GroupObject}->GroupUpdate(
        %GroupData,
        ValidID => $ValidListReverse{invalid},
        UserID  => 1,
    );

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

$Revision: 1.6 $ $Date: 2008-07-15 09:15:16 $

=cut
