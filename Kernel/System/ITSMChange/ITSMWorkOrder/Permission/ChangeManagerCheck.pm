# --
# Kernel/System/ITSMChange/ITSMWorkOrder/Permission/ChangeManagerCheck.pm - change manager based permission check
# Copyright (C) 2003-2009 OTRS AG, http://otrs.com/
# --
# $Id: ChangeManagerCheck.pm,v 1.4 2009-11-04 14:16:27 bes Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::ITSMChange::ITSMWorkOrder::Permission::ChangeManagerCheck;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.4 $) [1];

=head1 NAME

Kernel::System::ITSMChange::ITSMWorkOrder::Permission::ChangeManagerCheck - change manager based permission check

=head1 SYNOPSIS

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create an object

    use Kernel::Config;
    use Kernel::System::Encode;
    use Kernel::System::Log;
    use Kernel::System::Main;
    use Kernel::System::Time;
    use Kernel::System::DB;
    use Kernel::System::ITSMChange::ITSMWorkOrder;
    use Kernel::System::User;
    use Kernel::System::Group;
    use Kernel::System::ITSMChange::ITSMWorkOrder::Permission::ChangeManagerCheck;

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
    my $TimeObject = Kernel::System::Time->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
    );
    my $DBObject = Kernel::System::DB->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
        MainObject   => $MainObject,
    );
    my $WorkOrderObject = Kernel::System::ITSMChange::ITSMWorkOrder->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
        DBObject     => $DBObject,
        TimeObject   => $TimeObject,
        MainObject   => $MainObject,
    );
    my $UserObject = Kernel::System::User->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
        MainObject   => $MainObject,
        TimeObject   => $TimeObject,
        DBObject     => $DBObject,
        EncodeObject => $EncodeObject,
    );
    my $GroupObject = Kernel::System::Group->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
        DBObject     => $DBObject,
    );
    my $CheckObject = Kernel::System::ITSMChange::ITSMWorkOrder::Permission::ChangeManagerCheck->new(
        ConfigObject         => $ConfigObject,
        EncodeObject         => $EncodeObject,
        LogObject            => $LogObject,
        DBObject             => $DBObject,
        MainObject           => $MainObject,
        TimeObject           => $TimeObject,
        WorkOrderObject      => $WorkOrderObject,
        UserObject           => $UserObject,
        GroupObject          => $GroupObject,
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get needed objects
    for (
        qw(ConfigObject EncodeObject LogObject DBObject MainObject TimeObject WorkOrderObject UserObject GroupObject)
        )
    {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    return $Self;
}

=item Run()

this method does the check

    my $HasAccess = $CheckObject->Run(
        UserID      => 123,
        Type        => 'rw',     # 'ro' or 'rw'
        WorkOrderID => 4444,     # optional for WorkOrderAdd
    );

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(UserID Type WorkOrderID)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $_!",
            );

            return;
        }
    }

    # the check is based upon the change manager
    my $GroupID = $Self->{GroupObject}->GroupLookup( Group => 'itsm-change-manager' );

    # deny access, when the group is not found
    return if !$GroupID;

    # get user groups, where the user has the appropriate privilege
    my %Groups = $Self->{GroupObject}->GroupMemberList(
        UserID => $Param{UserID},
        Type   => $Param{Type},
        Result => 'HASH',
        Cached => 1,
    );

    # allow ro and rw access if the agent is a change manager
    return 1 if $Groups{$GroupID};

    # no need to check whether the agent is the actual manager of the change of the workorder

    # deny access otherwise
    return;
}

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (http://otrs.org/).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see http://www.gnu.org/licenses/agpl.txt.

=head1 VERSION

$Id: ChangeManagerCheck.pm,v 1.4 2009-11-04 14:16:27 bes Exp $

=cut

1;
