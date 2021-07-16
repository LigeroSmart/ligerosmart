# --
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Ticket::Event::AccountedTime;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::DynamicField',
    'Kernel::System::DynamicField::Backend',
    'Kernel::System::Log',
    'Kernel::System::Ticket',
    'Kernel::System::LinkObject',
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # From Event or Generic Agent
    return if !$Param{Data}->{ArticleID};
    my $TicketID = $Param{Data}->{TicketID};

    if ( !$TicketID ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need TicketID",
        );
        return;
    }
    my $StartField = $Kernel::OM->Get('Kernel::Config')->Get('Ticket::Complemento::AccountedTime::DynamicFieldStart');
    my $EndField = $Kernel::OM->Get('Kernel::Config')->Get('Ticket::Complemento::AccountedTime::DynamicFieldEnd');
    return 1 if ((!$StartField || !$EndField) ||
                     !(($Param{Data}->{FieldName} eq $StartField) || ($Param{Data}->{FieldName} eq $EndField)));

    my %Article = $Kernel::OM->Get('Kernel::System::Ticket::Article')->BackendForArticle( %{$Param{Data}} )->ArticleGet( 
        ArticleID     => $Param{Data}->{ArticleID},
        TicketID     => $Param{Data}->{TicketID},
        DynamicFields => 1,
        UserID        => $Param{UserID},
    );

    return 1 if (!$Article{"DynamicField_$StartField"} 
                    || !$Article{"DynamicField_$EndField"});

    # Calculate delta
    my $StartObj = $Kernel::OM->Create(
        'Kernel::System::DateTime',
        ObjectParams => {
            String   => $Article{"DynamicField_$StartField"},
            # TimeZone => 'Europe/Berlin',        # optional, defaults to setting of SysConfig OTRSTimeZone
        }
    );
    my $EndObj = $Kernel::OM->Create(
        'Kernel::System::DateTime',
        ObjectParams => {
            String   => $Article{"DynamicField_$EndField"},
            # TimeZone => 'Europe/Berlin',        # optional, defaults to setting of SysConfig OTRSTimeZone
        }
    );
    
    my $AccountedTimeInMin = $StartObj->Delta(DateTimeObject => $EndObj)->{AbsoluteSeconds};
    if($AccountedTimeInMin != 0){
        $AccountedTimeInMin = int($AccountedTimeInMin/60);
    }

    # For Article Edit Addon
    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');
    return if !$DBObject->Do(
        SQL => 'DELETE FROM time_accounting where article_id = ?',
        Bind => [ \$Param{Data}->{ArticleID} ],
    );

    # Set new accounted time
    $Kernel::OM->Get('Kernel::System::Ticket')->TicketAccountTime(
        TicketID  => $TicketID,
        ArticleID => $Param{Data}->{ArticleID},
        TimeUnit  => $AccountedTimeInMin,
        UserID    => $Param{UserID},
    ) if $AccountedTimeInMin;

    # Return if accounted time = 0
    return if !$AccountedTimeInMin;

    #Update no campo create_time colocando a data do CampoDinamico "Start"
    return if !$DBObject->Do(
        SQL => 'UPDATE time_accounting set create_time = ? where article_id = ?',
        Bind => [ \$Article{"DynamicField_$StartField"}, \$Param{Data}->{ArticleID} ],
    );

    return 1;
}

1;
