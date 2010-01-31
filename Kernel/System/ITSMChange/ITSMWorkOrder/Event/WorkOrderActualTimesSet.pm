# --
# Kernel/System/ITSMChange/ITSMWorkOrder/Event/WorkOrderActualTimesSet.pm - WorkOrderActualTimesSet
# event module for ITSMWorkOrder
# Copyright (C) 2003-2010 OTRS AG, http://otrs.com/
# --
# $Id: WorkOrderActualTimesSet.pm,v 1.1 2010-01-31 09:30:05 bes Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::ITSMChange::ITSMWorkOrder::Event::WorkOrderActualTimesSet;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.1 $) [1];

=head1 NAME

use Kernel::System::ITSMChange::ITSMWorkOrder::Event::WorkOrderActualTimesSet - WorkOrderActualTimesSet
event module for ITSMWorkOrder

=head1 SYNOPSIS

Event handler module for settin the actual times.

=head1 PUBLIC INTERFACE

=over 4

=item new()

create an object

    use Kernel::Config;
    use Kernel::System::Encode;
    use Kernel::System::Log;
    use Kernel::System::DB;
    use Kernel::System::Main;
    use Kernel::System::Time;
    use Kernel::System::ITSMChange::ITSMWorkOrder;
    use Kernel::System::ITSMChange::ITSMWorkOrder::Event::WorkOrderActualTimesSet;

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
    my $TimesSetObject = Kernel::System::ITSMChange::ITSMWorkOrder::Event::WorkOrderActualTimesSet->new(
        ConfigObject    => $ConfigObject,
        EncodeObject    => $EncodeObject,
        LogObject       => $LogObject,
        DBObject        => $DBObject,
        TimeObject      => $TimeObject,
        MainObject      => $MainObject,
        WorkOrderObject => $WorkOrderObject,
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get needed objects
    for my $Object (
        qw(DBObject ConfigObject EncodeObject LogObject MainObject TimeObject WorkOrderObject)
        )
    {
        $Self->{$Object} = $Param{$Object} || die "Got no $Object!";
    }

    return $Self;
}

=item Run()

The C<Run()> method recalculates the workorder numbers for the given workorder
and it's siblings.
This is triggered by the C<WorkOrderUpdate> and C<WorkOrderDelete> events.
This isn't triggered by C<WorkOrderAdd> events as C<WorkOrderAdd()> sets the
correct workorder number by itself.

The methods returns 1 on success, C<undef> otherwise.

    my $Success = $EventObject->Run(
        Event => 'WorkOrderUpdatePost',
        Data => {
            WorkOrderID => 123,
        },
        Config => {
            Event       => '(WorkOrderUpdatePost|WorkOrderDeletePost)',
            Module      => 'Kernel::System::ITSMChange::ITSMWorkOrder::Event::WorkOrderActualTimesSet',
            Transaction => '0',
        },
        UserID => 1,
    );

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(Data Event Config UserID)) {
        if ( !$Param{$Needed} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    # TODO: put actual code here
    return 1;
}

=begin Internal:

=cut

1;

=end Internal:

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (http://otrs.org/).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see http://www.gnu.org/licenses/agpl.txt.

=cut

=head1 VERSION

$Revision: 1.1 $ $Date: 2010-01-31 09:30:05 $

=cut
