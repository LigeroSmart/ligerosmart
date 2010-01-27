# --
# Kernel/System/ITSMChange/ITSMCondition/Operator/ITSMWorkOrder.pm - all itsm workorder operator functions
# Copyright (C) 2003-2010 OTRS AG, http://otrs.com/
# --
# $Id: ITSMWorkOrder.pm,v 1.1 2010-01-27 20:10:14 mae Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::ITSMChange::ITSMCondition::Operator::ITSMWorkOrder;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.1 $) [1];

use Kernel::System::ITSMChange::ITSMWorkOrder;

=head1 NAME

Kernel::System::ITSMChange::ITSMCondition::Operator::ITSMWorkOrder - condition itsm workorder operator lib

=head1 SYNOPSIS

All ITSMWorkOrder operator functions for conditions in ITSMChangeManagement.

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
    use Kernel::System::Time;

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

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for my $Object (qw(DBObject ConfigObject EncodeObject LogObject MainObject TimeObject)) {
        $Self->{$Object} = $Param{$Object} || die "Got no $Object!";
    }

    # create additional objects
    $Self->{WorkOrderObject} = Kernel::System::ITSMChange::ITSMWorkOrder->new( %{$Self} );

    return $Self;
}

=item Run()

Updates a workorder with the given data.

    my $Success = $ITSMWorkOrderOperator->Run(
        Selector    => 1234,
        Attribute   => 'WorkOrderStateID',
        ActionValue => 2345,
        UserID      => 1234,
    );

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(Selector Attribute ActionValue UserID)) {
        if ( !exists $Param{$Argument} || !defined $Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # update workorder and return update result
    return $Self->{WorkOrderObject}->WorkOrderUpdate(
        WorkOrderID       => $Param{Selector},
        $Param{Attribute} => $Param{ActionValue},
        UserID            => $Param{UserID},
    );
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

$Revision: 1.1 $ $Date: 2010-01-27 20:10:14 $

=cut
