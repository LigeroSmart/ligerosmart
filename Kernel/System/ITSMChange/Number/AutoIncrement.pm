# --
# ITSMChange/Number/AutoIncrement.pm - a change number auto increment generator
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --
# Note:
# available objects are: ConfigObject, LogObject and DBObject
#
# Generates change numbers like ID##### (e. g. 1000123)
#--

package Kernel::System::ITSMChange::Number::AutoIncrement;

use strict;
use warnings;

sub ChangeNumberCreate {
    my ( $Self, %Param ) = @_;

    # get needed config options
    my $CounterLog = $Self->{ConfigObject}->Get('ITSMChange::CounterLog');
    my $SystemID   = $Self->{ConfigObject}->Get('SystemID');
    my $MinSize
        = $Self->{ConfigObject}->Get('ITSMChange::NumberGenerator::AutoIncrement::MinCounterSize')
        || 5;

    # define number of maximum loops if created change number exists
    my $MaxRetryNumber        = 16000;
    my $LoopProtectionCounter = 0;

    # try to create a unique change number for up to $MaxRetryNumber times
    while ( $LoopProtectionCounter <= $MaxRetryNumber ) {

        # read count
        my $Count      = 0;
        my $LastModify = '';

        # try to read existing counter from file
        if ( -f $CounterLog ) {

            my $ContentSCALARRef = $Self->{MainObject}->FileRead(
                Location => $CounterLog,
            );

            if ( $ContentSCALARRef && ${$ContentSCALARRef} ) {

                ( $Count, $LastModify ) = split( /;/, ${$ContentSCALARRef} );

                # just debug
                if ( $Self->{Debug} > 0 ) {
                    $Self->{LogObject}->Log(
                        Priority => 'debug',
                        Message  => "Read counter from $CounterLog: $Count",
                    );
                }
            }
        }

        # count auto increment
        $Count++;

        my $Content = $Count;

        # write new count
        my $Write = $Self->{MainObject}->FileWrite(
            Location => $CounterLog,
            Content  => \$Content,
        );

        # log debug message
        if ( $Write && $Self->{Debug} ) {

            $Self->{LogObject}->Log(
                Priority => 'debug',
                Message  => "Write counter: $Count",
            );
        }

        # pad change number with leading '0' to length $MinSize (config option)
        $Count = sprintf "%.*u", $MinSize, $Count;

        # create new change number
        my $ChangeNumber = $SystemID . $Count;

        # lookup if change number exists already
        my $ChangeID = $Self->ChangeLookup(
            ChangeNumber => $ChangeNumber,
        );

        # now we have a new unused change number and return it
        return $ChangeNumber if !$ChangeID;

        # start loop protection mode
        $LoopProtectionCounter++;

        # create new change number again
        $Self->{LogObject}->Log(
            Priority => 'notice',
            Message  => "ChangeNumber ($ChangeNumber) exists! Creating a new one.",
        );
    }

    # loop was running too long
    $Self->{LogObject}->Log(
        Priority => 'error',
        Message  => "LoopProtectionCounter is now $LoopProtectionCounter!"
            . " Stopped ChangeNumberCreate()!",
    );

    return;
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
