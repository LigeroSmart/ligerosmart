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

    my $StartField = $Kernel::OM->Get('Kernel::Config')->Get('Ticket::Complemento::AccountedTime::DynamicFieldStartID');
    my $EndField = $Kernel::OM->Get('Kernel::Config')->Get('Ticket::Complemento::AccountedTime::DynamicFieldEndID');
    return 1 if !$EndField;

    my $DynamicFieldObject        = $Kernel::OM->Get('Kernel::System::DynamicField');
    my $DynamicFieldBackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

    # Obtain Data
    my $DynamicFieldStart = $DynamicFieldObject->DynamicFieldGet(
        ID   => $StartField,             # ID or Name must be provided
    );

    my $DynamicFieldEnd = $DynamicFieldObject->DynamicFieldGet(
        ID   => $EndField,             # ID or Name must be provided
    );

    my @Fields = ("$DynamicFieldStart->{Name}","$DynamicFieldEnd->{Name}");
    
    return 1 if ! (grep /^$Param{Data}->{FieldName}$/, @Fields);

    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');
    my %Article = $Kernel::OM->Get('Kernel::System::Ticket::Article')->BackendForArticle( %{$Param{Data}} )->ArticleGet( 
        ArticleID     => $Param{Data}->{ArticleID},
        TicketID     => $Param{Data}->{TicketID},
        DynamicFields => 1,
        UserID        => $Param{UserID},
    );

    # Calcula o tempo contabilizado
    my $TimeObject = $Kernel::OM->Get('Kernel::System::Time');

    my $Start = $TimeObject->TimeStamp2SystemTime(
        String => $Article{"DynamicField_$DynamicFieldStart->{Name}"},
    ) || 0;
    my $End = $TimeObject->TimeStamp2SystemTime(
        String => $Article{"DynamicField_$DynamicFieldEnd->{Name}"},
    ) || 0 ;

    if (!$Article{"DynamicField_$DynamicFieldStart->{Name}"} || !$Article{"DynamicField_$DynamicFieldEnd->{Name}"}){
        # if one of the fields was not filled, we make both equal to zero, avoiding mistakes
        $Start = 0;
        $End = 0;
    };
    
    my $AccountedTimeInMin = int(($End-$Start)/60);

    # For Article Edit Addon
    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');
    return if !$DBObject->Do(
        SQL => 'DELETE FROM time_accounting where article_id = ?',
        Bind => [ \$Param{Data}->{ArticleID} ],
    );

    # Set new accounted time
    $TicketObject->TicketAccountTime(
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
        Bind => [ \$Article{"DynamicField_$DynamicFieldStart->{Name}"}, \$Param{Data}->{ArticleID} ],
    );

    

    return 1;
}

1;
