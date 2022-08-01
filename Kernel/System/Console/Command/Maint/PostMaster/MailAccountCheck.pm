# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

## nofilter(TidyAll::Plugin::OTRS::Perl::NoExitInConsoleCommands)

package Kernel::System::Console::Command::Maint::PostMaster::MailAccountCheck;

use strict;
use warnings;

use parent qw(Kernel::System::Console::BaseCommand);

use POSIX ":sys_wait_h";
use Time::HiRes qw(sleep);

our @ObjectDependencies = (
    'Kernel::System::Log',
    'Kernel::System::MailAccount',
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('Fetch incoming emails from configured mail accounts.');
    $Self->AddOption(
        Name        => 'mail-account-id',
        Description => "Mail account IDs that will be verified and balanced.",
        Required    => 1,
        HasValue    => 1,
        ValueRegex  => qr{^\d+$}smx,
        Multiple    => 1,
    );
    $Self->AddOption(
        Name        => 'debug',
        Description => "Print debug info to the OTRS log.",
        Required    => 0,
        HasValue    => 0,
    );
    $Self->AddOption(
        Name        => 'get-status',
        Description => "Check status for email exchange (default: Failed).",
        Required    => 0,
        HasValue    => 1,
        ValueRegex => qr/(Failed|Warning|All)/smx,
    );    
    $Self->AddOption(
        Name => 'starttime',
        Description =>
            "StartTime in seconds for analysis, searches the log of communications performed within the given time window (default: 1200).",
        Required   => 0,
        HasValue   => 1,
        ValueRegex => qr{^\d+$}smx,
    );

    return;
}

sub PreRun {
    my ($Self) = @_;

    my $Debug = $Self->GetOption('debug');
    my $Name  = $Self->Name();

    my @MailAccountIDs = @{ $Self->GetOption('mail-account-id')     // [] };

    if ( !@MailAccountIDs ) {
        die "Please provide option --mail-account-id.\n";
    }    

    if ($Debug) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'debug',
            Message  => "OTRS email handle ($Name) started.",
        );
    }

    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $MailAccountObject    = $Kernel::OM->Get('Kernel::System::MailAccount');
    my %List                 = $MailAccountObject->MailAccountList( Valid => 1 );

    my $Debug                = $Self->GetOption('debug');
    my $StartTime            = $Self->GetOption('starttime') || 1200;
    my $AccountCheckStatus   = $Self->GetOption('get-status') || 'Failed';
    my @MailAccountIDs       = @{ $Self->GetOption('mail-account-id')     // [] };

    my @MailAccountIDInvalid;
    my $NoChange = 0;
    my $DateTime             = "";
    my $strmail              = "";
    my %Accounts;

    my $regex;

    $regex = qr/(Failed|Warning)/smx if ( $AccountCheckStatus eq 'All');
    $regex = qr/(Failed)/smx if ( $AccountCheckStatus eq 'Failed');
    $regex = qr/(Warning)/smx if ( $AccountCheckStatus eq 'Warning');

    if ( $StartTime && $StartTime !~ m{^\d+$} ) {
        $Self->PrintError("Invalid StartTime: %StartTime!.");
        return $Self->ExitCodeError();        
    }
    elsif ( $StartTime == 0 ) {
        $DateTime = $StartTime;
    }
    else {
        my $DateTimeObject = $Kernel::OM->Create('Kernel::System::DateTime');
        my $ValidDate      = $DateTimeObject->Subtract(
            Seconds => $StartTime,
        );

        if ( !$ValidDate ) {
            $Self->PrintError("Invalid StartTime: %StartTime!.");
            return $Self->ExitCodeError();
        }

        $DateTime = $DateTimeObject->ToString();        
    }        

    MAILACCOUNTID:
    for my $MailAccountID (@MailAccountIDs) {
        if ( !%List ) {
            if ($MailAccountID) {
                $Self->PrintError("Could not find mail account $MailAccountID.");
                return $Self->ExitCodeError();
            }

            $Self->Print("\n<yellow>No configured mail accounts found!</yellow>\n\n");
            return $Self->ExitCodeOk();
        }

        KEY:
        for my $Key ( sort keys %List ) {

            push @MailAccountIDInvalid, $MailAccountID if ( $MailAccountID && $Key != $MailAccountID );

            next KEY if ( $MailAccountID && $Key != $MailAccountID );

            my %Data = $MailAccountObject->MailAccountGet( ID => $Key );

            %Accounts = $Self->_AccountStatus(
                StartDate => $DateTime,
                %Data,
            );

            $strmail = $Data{Type} . "::" . $Data{ID};
            my $MailStatus = $Accounts{$strmail}->{Status} || "NO DATA";

            if ($Accounts{$strmail}->{Status} && ( $Accounts{$strmail}->{Status} =~ /$regex/ ) ) {
                # update mail account
                $Data{ValidID} = 3;

                my $Update = $MailAccountObject->MailAccountUpdate(
                    %Data,
                    UserID => 1,
                );

                $Self->Print("<red>$Data{Host} ($Data{Type} - ID: $Data{ID} - $MailStatus)</red>\n");              
            }

            else {
                $NoChange = 1;
                $Self->Print("<green>$Data{Host} ($Data{Type} - ID: $Data{ID} - Status:  - $MailStatus)</green>\n");
            }            
        }
    }

    MAILINVALIDACCOUNTID:
    for my $MailInvalidAccountID (@MailAccountIDInvalid) {   

        next MAILINVALIDACCOUNTID if ( !$MailInvalidAccountID || $NoChange == 1 );

        my %DataInvalid = $MailAccountObject->MailAccountGet( ID => $MailInvalidAccountID );

        $DataInvalid{ValidID} = 1;

        my $Update = $MailAccountObject->MailAccountUpdate(
            %DataInvalid,
            UserID => 1,
        );

        $Self->Print("<green>$DataInvalid{Host} ($DataInvalid{Type} - ID: $DataInvalid{ID})...</green>\n");           

    }   

    $Self->Print("<green>Done.</green>\n\n");
    return $Self->ExitCodeOk();
}

sub PostRun {
    my ($Self) = @_;

    my $Debug = $Self->GetOption('debug');
    my $Name  = $Self->Name();

    if ($Debug) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'debug',
            Message  => "OTRS email handle ($Name) stopped.",
        );
    }
}

sub _AccountStatus {
    my ( $Self, %Param ) = @_;

    my %Filter = (
        ObjectLogStartDate => $Param{StartDate},
    );

    if ( $Param{Status} ) {
        $Filter{ObjectLogStatus} = $Param{Status};
    }

    my $CommunicationLogDBObj = $Kernel::OM->Get('Kernel::System::CommunicationLog::DB');
    my $Connections           = $CommunicationLogDBObj->GetConnectionsObjectsAndCommunications(%Filter);
    if ( !$Connections || !@{$Connections} ) {
        return;
    }

    my %Account;
    for my $Connection (@$Connections) {

        my $AccountKey = $Connection->{AccountType};
        if ( $Connection->{AccountID} ) {
            $AccountKey .= "::$Connection->{AccountID}";
        }

        if ( !$Account{$AccountKey} ) {
            $Account{$AccountKey} = {
                AccountID   => $Connection->{AccountID},
                AccountType => $Connection->{AccountType},
                Transport   => $Connection->{Transport},
            };
        }

        $Account{$AccountKey}->{ $Connection->{ObjectLogStatus} } ||= [];

        push @{ $Account{$AccountKey}->{ $Connection->{ObjectLogStatus} } },
            $Connection->{CommunicationID};
    }

    for my $AccountKey ( sort keys %Account ) {
        $Account{$AccountKey}->{Status} =
            $Self->_CheckHealth( $Account{$AccountKey} );
    }

    return %Account;

}

sub _CheckHealth {
    my ( $Self, $Connections ) = @_;

    # Success if all is Successful;
    # Failed if all is Failed;
    # Warning if has both Successful and Failed Connections;

    my $Health = 'Success';

    if ( scalar $Connections->{Failed} ) {
        $Health = 'Failed';
        if ( scalar $Connections->{Successful} ) {
            $Health = 'Warning';
        }
    }

    return $Health;

}

1;