# --
# Kernel/Scheduler/TaskHandler/AutoTicket.pm - Scheduler task handler backend for creating new tickets on the block =D
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Daemon::DaemonModules::SchedulerTaskWorker::AutoTicket;

use strict;
use warnings;
use Kernel::System::VariableCheck qw(:all);

sub new {
    my ( $Type, %Param ) = @_;

    my $Self = {};
    bless( $Self, $Type );


    return $Self;
}
use base qw(Kernel::System::Daemon::DaemonModules::BaseTaskWorker);
our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Daemon::SchedulerDB',
    'Kernel::System::Email',
    'Kernel::System::Log',
    'Kernel::System::Time',
);


sub Run {
    my ( $Self, %Param ) = @_;
    my $ConfigObject		= $Kernel::OM->Get('Kernel::Config');
    my $AutoTicketObject	= $Kernel::OM->Get('Kernel::System::AutoTicket');
    my $ValidObject 		= $Kernel::OM->Get('Kernel::System::Valid');
    my $TypeObject 		    = $Kernel::OM->Get('Kernel::System::Type');
    my $HTMLUtilsObject		= $Kernel::OM->Get('Kernel::System::HTMLUtils');
    my $ServiceObject		= $Kernel::OM->Get('Kernel::System::Service');
    my $SLAObject		    = $Kernel::OM->Get('Kernel::System::SLA');
    my $QueueObject		    = $Kernel::OM->Get('Kernel::System::Queue');
    my $StateObject 		= $Kernel::OM->Get('Kernel::System::State');
    my $PriorityObject		= $Kernel::OM->Get('Kernel::System::Priority');
    my $DynamicFieldObject 	= $Kernel::OM->Get('Kernel::System::DynamicField');
    my $BackendObject 		= $Kernel::OM->Get('Kernel::System::DynamicField::Backend');
    my $TicketObject		= $Kernel::OM->Get('Kernel::System::Ticket');
    my $LogObject		    = $Kernel::OM->Get('Kernel::System::Log');
    $Self->{DynamicField} 	= $DynamicFieldObject->DynamicFieldListGet(
        Valid      => 1,
        ObjectType => ['Ticket','Article'],
    );

    my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $LayoutObject   = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    # check data - we need a hash ref
    if ( $Param{Data} && ref $Param{Data} ne 'HASH' ) {
        $LogObject->Log(
            Priority => 'error',
            Message  => 'Got no valid Data!',
        );

        return {
            Success => 0,
        };
    }

    my $TicketID = $TicketObject->TicketCreate(
        TN            => $TicketObject->TicketCreateNumber(), # optional
        %{$Param{Data}},
        UserID        => 1,
    );

    my $ArticleObject = $Kernel::OM->Get('Kernel::System::Ticket::Article');
	my $ArticleBackendObject = $ArticleObject->BackendForChannel( ChannelName => 'Phone' );


	my $ArticleID = $ArticleBackendObject->ArticleCreate(
        TicketID         => $TicketID,
        %{$Param{Data}},
        Charset          => 'utf-8',
        MimeType         => 'text/html',
        HistoryType      => 'NewTicket',
        HistoryComment   => 'Ticket Started',
		UserID           => 1,
	);

  
    DYNAMICFIELD:
    for my $DynamicFieldConfig ( @{ $Self->{DynamicField} } ) {
        next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);
        next DYNAMICFIELD if $DynamicFieldConfig->{ObjectType} ne 'Ticket';
        ### TEMP
        # extract the dynamic field value form the web request

        my $Value = $BackendObject->EditFieldValueGet(
            DynamicFieldConfig => $DynamicFieldConfig,
            Template           => $Param{Data},
            TransformDates     => 0,
        );
        
        if ( defined $Value && $Value ne '' ) {
            my $Success = $BackendObject->ValueSet(
                DynamicFieldConfig => $DynamicFieldConfig,
                ObjectID           => $TicketID,
                Value              => $Value,
                UserID             => 1,
            );
            
            if ($Success) {
                my $ValueStrg = $BackendObject->ReadableValueRender(
                    DynamicFieldConfig => $DynamicFieldConfig,
                    Value              => $Value,
                );
            }
            else {
                $LogObject->Log(
                    Priority => 'error',
                    Message  => "Coud not set dynamic field $DynamicFieldConfig->{Name} "
                        . "for Ticket $TicketID.",
                );
            }
        }
    }
   
    # set new dynamic fields options
    # cycle trough the activated Dynamic Fields for this screen
    DYNAMICFIELD:
    for my $DynamicFieldConfig ( @{ $Self->{DynamicField} } ) {
        next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);
        next DYNAMICFIELD if $DynamicFieldConfig->{ObjectType} ne 'Article';
        
        # extract the dynamic field value form the web request
        my $Value = $BackendObject->EditFieldValueGet(
            DynamicFieldConfig => $DynamicFieldConfig,
            Template           => $Param{Data},
            TransformDates     => 0,
        );
        if ( defined $Value && $Value ne '' ) {
            my $Success = $BackendObject->ValueSet(
                DynamicFieldConfig => $DynamicFieldConfig,
                ObjectID           => $ArticleID,
                Value              => $Value,
                UserID             => 1,
            );

            if ($Success) {
                if ( $Self->{NoticeSTDOUT} ) {
                    my $ValueStrg = $BackendObject->ReadableValueRender(
                        DynamicFieldConfig => $DynamicFieldConfig,
                        Value              => $Value,
                    );
                }
            }
            else {
                $LogObject->Log(
                    Priority => 'error',
                    Message  => "Coud not set dynamic field $DynamicFieldConfig->{Name} "
                        . "for Ticket $TicketID.",
                );
            }
        }
    }

   
    # re schedule with new time
    return {
        Success    => $Param{Data}->{Success},
        ReSchedule => $Param{Data}->{ReSchedule},
        DueTime    => $Param{Data}->{ReScheduleDueTime},
        Data       => $Param{Data}->{ReScheduleData},
    };
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut

=head1 VERSION

$Revision: 1.12 $ $Date: 2011/07/26 19:50:13 $

=cut
