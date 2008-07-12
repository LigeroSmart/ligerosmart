# --
# ITSMCore.pm - code to excecute during package installation
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: ITSMCore.pm,v 1.1 2008-07-12 15:51:27 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package var::packagesetup::ITSMCore;

use strict;
use warnings;

use Kernel::System::Group;
use Kernel::System::Valid;

use vars qw(@ISA $VERSION);
$VERSION = qw($Revision: 1.1 $) [1];

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
    $Self->{GroupObject} = Kernel::System::Group->new( %{$Self} );
    $Self->{ValidObject} = Kernel::System::Valid->new( %{$Self} );

    return $Self;
}

=item CodeInstall()

run the code install part

    my $Result = $CodeObject->CodeInstall();

=cut

sub CodeInstall {
    my ( $Self, %Param ) = @_;

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

    return 1;
}

=item CodeUninstall()

run the code uninstall part

    my $Result = $CodeObject->CodeUninstall();

=cut

sub CodeUninstall {
    my ( $Self, %Param ) = @_;

    # deactivate the group itsm-service
    $Self->_GroupDeactivate(
        Name => 'itsm-service',
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
    my %ValidList = $Self->{ValidObject}->ValidList();
    my %ValidListReverse = reverse %ValidList;

    # check if group already exists
    my $GroupID = $Self->{GroupObject}->GroupLookup(
        Group => $Param{Name},
    );

    # reactivate the group
    if ($GroupID) {

        # get current group data
        my %GroupData = $Self->{GroupObject}->GroupGet(
            ID => $GroupID,
        );

        # reactivate group
        $Self->{GroupObject}->GroupUpdate(
            %GroupData,
            ValidID => $ValidListReverse{valid},
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

    # add user root to the group
    $Self->{GroupObject}->GroupMemberAdd(
        GID        => $Self->{GroupObject}->GroupLookup(Group => $Param{Name}),
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
    my %ValidList = $Self->{ValidObject}->ValidList();
    my %ValidListReverse = reverse %ValidList;

    # get current group data
    my %GroupData = $Self->{GroupObject}->GroupGet(
        ID => $GroupID,
    );

    # deactivate group
    $Self->{GroupObject}->GroupUpdate(
        %GroupData,
        ValidID => $ValidListReverse{invalid},
    );

    return 1;
}

=item _BackgroundColorSet()

sets the itsm backround color

    my $Result = $CodeObject->_BackgroundColorSet();

=cut

sub _BackgroundColorSet {
    my ( $Self, %Param ) = @_;

    # define the css file
    my $CssFile = $Self->{ConfigObject}->Get('Home') . '/Kernel/Output/HTML/Standard/css.dtl';

    if (!-e $CssFile . ".save" && open my $FH, '<', $CssFile) {

        my $Content = '';
        while (<$FH>) {
            if ($_ =~ /^body /) {
                $_ =~ s/background-color\:\#bbddff\;/background-color\:\#003399\;/;
            }
            $Content .= $_;
        }
        close $FH;

        if (open my $Out, '>', $CssFile) {
            binmode $Out;
            print $Out $Content;
            close $Out;
        }
    }

    return 1;
}

=item _BackgroundColorRestore()

restore the original backround color

    my $Result = $CodeObject->_BackgroundColorRestore();

=cut

sub _BackgroundColorRestore {
    my ( $Self, %Param ) = @_;

    # change background color of standard theme back to original
    my $CssFile = $Self->{ConfigObject}->Get('Home') . "/Kernel/Output/HTML/Standard/css.dtl";
    if (!-e $CssFile . ".save" && open (IN, "< $CssFile")) {

        my $Content = '';
        while (<IN>) {
            if ($_ =~ /^body /) {
                $_ =~ s/background-color\:\#003399\;/background-color\:\#bbddff\;/;
            }
            $Content .= $_;
        }
        close (IN);

        if (open (OUT, "> $CssFile")) {
            binmode(OUT);
            print OUT $Content;
            close (OUT);
        }
    }
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

$Revision: 1.1 $ $Date: 2008-07-12 15:51:27 $

=cut
