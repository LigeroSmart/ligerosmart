# --
# Kernel/System/ITSMChange/ITSMWorkOrder/Permission/CABCheck.pm - CAB based permission check
# Copyright (C) 2003-2009 OTRS AG, http://otrs.com/
# --
# $Id: CABCheck.pm,v 1.2 2009-11-10 12:15:00 bes Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::ITSMChange::ITSMWorkOrder::Permission::CABCheck;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.2 $) [1];

=head1 NAME

Kernel::System::ITSMChange::ITSMWorkOrder::Permission::CABCheck - change agent based permission check

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
    use Kernel::System::ITSMChange::ITSMWorkOrder::Permission::CABCheck;

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
    my $CheckObject = Kernel::System::ITSMChange::ITSMWorkOrder::Permission::CABCheck->new(
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

This method does the check. Access is allowed when type is 'ro' and the agent is a member
of the CAB of the change of the workorder.

    my $HasAccess = $CheckObject->Run(
        UserID      => 123,
        Type        => 'rw',     # 'ro' or 'rw'
        WorkOrderID => 4444,     # optional for WorkOrderAdd
    );

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(UserID Type)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $_!",
            );

            return;
        }
    }

    # only 'ro' access might be granted by this module
    return if $Param{Type} ne 'ro';

    # there already is a workorder
    my $WorkOrder = $Self->{WorkOrderObject}->WorkOrderGet(
        UserID      => $Param{UserID},
        WorkOrderID => $Param{WorkOrderID},
    );

    # deny access, when no workorder was found
    return if !$WorkOrder || !%{$WorkOrder} || !$WorkOrder->{ChangeID};

    # for checking the change builder, we need information on the change
    my $Change = $Self->{ChangeObject}->ChangeGet(
        UserID   => $Param{UserID},
        ChangeID => $WorkOrder->{ChangeID},
    );

    # get the CAB of the change
    my $CAB = $Self->{ChangeObject}->ChangeCABGet(
        UserID   => $Param{UserID},
        ChangeID => $WorkOrder->{ChangeID},
    );

    # check whether the agent is a member of the CAB
    return 1 if grep { $_ == $Param{UserID} } @{ $CAB->{CABAgents} };

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

$Id: CABCheck.pm,v 1.2 2009-11-10 12:15:00 bes Exp $

=cut

1;
