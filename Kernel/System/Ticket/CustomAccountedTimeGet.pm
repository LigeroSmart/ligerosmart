# --
# Kernel/System/Ticket/Custom.pm.example - custom ticket changes
# Copyright (C) 2001-2012 OTRS AG, http://otrs.org/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Ticket::CustomAccountedTimeGet;

use strict;
use warnings;

use vars qw(@ISA $VERSION);
$VERSION = qw($Revision: 1.5 $) [1];

# disable redefine warnings in this scope
{
no warnings 'redefine';

# as example redefine the TicketXXX() of Kernel::System::Ticket
sub Kernel::System::Ticket::TicketAccountedTimeGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{TicketID} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need TicketID!' );
        return;
    }

    my $Ini = $Kernel::OM->Get('Kernel::Config')->Get('Ticket::Complemento::AccountedTime::DynamicFieldStartID');
    my $End = $Kernel::OM->Get('Kernel::Config')->Get('Ticket::Complemento::AccountedTime::DynamicFieldEndID');
	# get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # get config data
    $Self->{DSN}  = $ConfigObject->Get('DatabaseDSN');


    # get database type (auto detection)
    if ( $Self->{DSN} =~ /:mysql/i ) {

		  return if !$Kernel::OM->Get('Kernel::System::DB')->Prepare(
        SQL  => "select TIME_TO_SEC(TIMEDIFF(f.fim,i.inicio))/60 as time_unit from 
                (SELECT object_id, value_date as inicio FROM dynamic_field_value where field_id=?) i
                left join
                (SELECT object_id, value_date as fim FROM dynamic_field_value where field_id=?) f
                on i.object_id=f.object_id
                left join article a on i.object_id = a.id where a.ticket_id = ?",
        Bind => [ \$Ini, \$End, \$Param{TicketID} ],
    );
    }
    elsif ( $Self->{DSN} =~ /:pg/i ) {

		  return if !$Kernel::OM->Get('Kernel::System::DB')->Prepare(
		        SQL  => "select extract (epoch from ( f.fim - i.inicio))::integer/60 as time_unit from 
        	        (SELECT object_id, value_date as inicio FROM dynamic_field_value where field_id=?) i
            	    left join
                	(SELECT object_id, value_date as fim FROM dynamic_field_value where field_id=?) f
	                on i.object_id=f.object_id
    	            left join article a on i.object_id = a.id where a.ticket_id = ?",
        		Bind => [ \$Ini, \$End, \$Param{TicketID} ],
    	);
    }
    # db query

	   $Kernel::OM->Get('Kernel::System::Log')->Dumper($Param{TicketID}); 
  

	my $Total = 0;
	my $Text = "";
    while ( my @Row = $Kernel::OM->Get('Kernel::System::DB')->FetchrowArray() ) {
        $Row[0] =~ s/,/./g;
        $Total += $Row[0];
    }


	$Text = sprintf("%dh %dm", $Total/60, $Total%60);
	return $Text;
}

# reset all warnings
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=head1 VERSION

$Revision: 1.5 $ $Date: 2012-11-20 15:59:31 $

=cut
