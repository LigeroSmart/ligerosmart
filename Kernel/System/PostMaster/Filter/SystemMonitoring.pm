# --
# Kernel/System/PostMaster/Filter/SystemMonitoring.pm - Basic System Monitoring Interface
# Copyright (C) 2001-2012 OTRS AG, http://otrs.org/
# --
# $Id: SystemMonitoring.pm,v 1.15 2012-01-31 14:39:47 md Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

# important configuration items SystemMonitoring::SetIncidentState

package Kernel::System::PostMaster::Filter::SystemMonitoring;

use strict;
use warnings;
use Kernel::System::LinkObject;
use vars qw($VERSION);
$VERSION = qw($Revision: 1.15 $) [1];

#the base name for dynamic fields

use constant DynamicFieldTicketTextPrefix  => 'TicketFreeText';
use constant DynamicFieldArticleTextPrefix => 'ArticleFreeText';

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    $Self->{Debug} = $Param{Debug} || 0;

    # get needed objects
    for my $Object (
        qw(DBObject ConfigObject LogObject MainObject EncodeObject TicketObject TimeObject)
        )
    {
        $Self->{$Object} = $Param{$Object} || die "Got no $Object!";
    }

    # create additional objects
    $Self->{LinkObject} = Kernel::System::LinkObject->new( %{$Self} );

    # check if CI incident state should be set automatically
    # this requires the ITSMConfigurationManagement module to be installed
    if ( $Self->{ConfigObject}->Get('SystemMonitoring::SetIncidentState') ) {

        _IncidentStateNew();
    }

    # Default Settings
    $Self->{Config} = {
        StateRegExp       => '\s*State:\s+(\S+)',
        FromAddressRegExp => 'sysmon@example.com',
        NewTicketRegExp   => 'CRITICAL|DOWN',
        CloseTicketRegExp => 'OK|UP',
        CloseActionState  => 'closed successful',
        ClosePendingTime  => 60 * 60 * 24 * 2,                          # 2 days
        HostRegExp        => '\s*Address:\s+(\d+\.\d+\.\d+\.\d+)\s*',
        FreeTextHost      => '1',
        FreeTextService   => '2',
        FreeTextState     => '1',
        ServiceRegExp     => '\s*Service:\s+(.*)\s*',
        DefaultService    => 'Host',
        SenderType        => 'system',
        ArticleType       => 'note-report',
    };

    return $Self;
}

sub _GetDynamicFieldDefinition {
    my $Self       = shift;
    my $Config     = shift;
    my $Key        = shift;    #FreeTextHost the config key
    my $Default    = shift;    #1 the default value
    my $Base       = shift;    # DynamicFieldTicketTextPrefix
    my $Name       = shift;    #HostName
    my $ObjectType = shift;    #HostName

    my $ConfigFreeText = $Config->{$Key};

    if ( !$ConfigFreeText ) {
        $ConfigFreeText = $Default;
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Missing CI Config $Key, using value $Default!"
        );
    }

    if ( $ConfigFreeText =~ /^\d+$/ ) {
        if ( ( $ConfigFreeText < 1 ) || ( $ConfigFreeText > 16 ) ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message => "Bad value $ConfigFreeText for CI Config $Key, must be between 1 and 16!"
            );
            die "Bad value $ConfigFreeText for CI Config $Key!";
        }
    }
    else
    {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Bad value $ConfigFreeText for CI Config $Key, must be numeric!"
        );
        die "Bad value $ConfigFreeText for CI Config $Key!";
    }

    my $FieldNameHost = $Base . $ConfigFreeText;

# define all dynamic fields for System Monitoring, these need to be changed as well if the config changes
    return (
        {
            Name       => $FieldNameHost,
            Label      => 'SystemMonitoring ' . $Name,
            FieldType  => 'Text',
            ObjectType => $ObjectType,
            Config     => {
                TranslatableValues => 1,
            },
        }
    );
}

sub GetDynamicFieldsDefinition {
    my $class  = shift;
    my $Self   = shift;
    my %Param  = @_;
    my $Config = $Param{Config};

    push @{ $Param{NewFields} },
        _GetDynamicFieldDefinition(
        $Self, $Config, "FreeTextHost", 1, DynamicFieldTicketTextPrefix,
        "HostName", "Ticket"
        );
    push @{ $Param{NewFields} },
        _GetDynamicFieldDefinition(
        $Self, $Config, "FreeTextService", 2,
        DynamicFieldTicketTextPrefix, "ServiceName", "Ticket"
        );
    push @{ $Param{NewFields} },
        _GetDynamicFieldDefinition(
        $Self, $Config, "FreeTextState", 1,
        DynamicFieldArticleTextPrefix, "StateName", "Article"
        );

    return 1;
}

sub _IncidentStateIncident {
    my $Self = shift || die "missing self";

    # set the CI incident state to 'Incident'
    $Self->_SetIncidentState(
        Name          => $Self->{Host},
        IncidentState => 'Incident',
    );

}

sub _IncidentStateOperational {
    my $Self = shift || die "missing self";

    # set the CI incident state to 'Operational'
    $Self->_SetIncidentState(
        Name          => $Self->{Host},
        IncidentState => 'Operational',
    );
}

# these are optional modules from the ITSM Kernel::System::GeneralCatalog and Kernel::System::ITSMConfigItem

sub _IncidentStateNew {
    my $Self = shift || die "missing self";

    # require the general catalog module
    if ( $Self->{MainObject}->Require('Kernel::System::GeneralCatalog') ) {

        # create general catalog object
        $Self->{GeneralCatalogObject} = Kernel::System::GeneralCatalog->new( %{$Self} );
    }

    # require the config item module
    if ( $Self->{MainObject}->Require('Kernel::System::ITSMConfigItem') ) {

        # create config item object
        $Self->{ConfigItemObject} = Kernel::System::ITSMConfigItem->new( %{$Self} );
    }
}

sub _MailParse {
    my $Self = shift || die "missing self";
    my %Param = @_;

    my $Subject = $Param{GetParam}->{Subject} || die "No Param Subject";

    # Try to get State, Host and Service from email subject
    my @SubjectLines = split /\n/, $Subject;
    for my $Line (@SubjectLines) {
        for (qw(State Host Service)) {
            if ( $Line =~ /$Self->{Config}->{ $_ . 'RegExp' }/ ) {
                $Self->{$_} = $1;
            }
        }
    }

    #  Dont Try to get State, Host and Service from email body, we want it from the subject alone

    # split the body into separate lines
    my $Body = $Param{GetParam}->{Body} || die "Message has no Body";

    my @BodyLines = split /\n/, $Body;

    # to remember if an element was found before
    my %AlreadyMatched;

    LINE:
    for my $Line (@BodyLines) {

        # Try to get State, Host and Service from email body
        ELEMENT:
        for my $Element (qw(State Host Service)) {

            next ELEMENT if $AlreadyMatched{$Element};

            my $Regex = $Self->{Config}->{ $Element . 'RegExp' };

            if ( $Line =~ /$Regex/ ) {

                # get the found element value
                $Self->{$Element} = $1;

                # remember that we found this element already
                $AlreadyMatched{$Element} = 1;
            }
        }
    }
}

sub _LogMessage {
    my $Self        = shift;
    my $MessageText = shift;

    # logging
    # define log message
    $Self->{Service} ||= "No Service";
    $Self->{State}   ||= "No State";
    $Self->{Host}    ||= "No Host";

    my $LogMessage = $MessageText . " - "
        . "Host: $Self->{Host}, "
        . "State: $Self->{State}, "
        . "Service: $Self->{Service}";

    $Self->{LogObject}->Log(
        Priority => 'notice',
        Message  => 'SystemMonitoring Mail: ' . $LogMessage,
    );
}

sub _TicketSearch {
    my $Self = shift || die "missing self";

    # Is there a ticket for this Host/Service pair?
    my %Query = (
        Result    => 'ARRAY',
        Limit     => 1,
        UserID    => 1,
        StateType => 'Open',
    );

    for my $Type (qw(Host Service)) {
        my $FreeTextField = $Self->{Config}->{ 'FreeText' . $Type };
        my $KeyName       = "DynamicField_" . DynamicFieldTicketTextPrefix . $FreeTextField;
        my $KeyValue      = $Self->{$Type};

        $Query{$KeyName}->{Equals} = $KeyValue;
    }

    my @TicketIDs = $Self->{TicketObject}->TicketSearch(%Query);

    # get the first and only ticket id
    my $TicketID = shift @TicketIDs;

    return $TicketID;

}

# the sub takes the param as a hashref not as a copy, because it is updated

sub _TicketUpdate {
    my $Self     = shift || die "missing self";
    my $TicketID = shift || die "missing ticketid";
    my $Param    = shift || die "missing param hashref";

    # get ticket number
    my $TicketNumber = $Self->{TicketObject}->TicketNumberLookup(
        TicketID => $TicketID,
        UserID   => 1,
    );

    # build subject
    $Param->{GetParam}->{Subject} = $Self->{TicketObject}->TicketSubjectBuild(
        TicketNumber => $TicketNumber,
        Subject      => $Param->{GetParam}->{Subject},
    );

    # set sender type and article type
    $Param->{GetParam}->{'X-OTRS-FollowUp-SenderType'}  = $Self->{Config}->{SenderType};
    $Param->{GetParam}->{'X-OTRS-FollowUp-ArticleType'} = $Self->{Config}->{ArticleType};

    # Set Article Free Field for State
    my $ArticleFreeTextNumber = $Self->{Config}->{'FreeTextState'};
    $Param->{GetParam}->{ 'X-OTRS-FollowUp-ArticleKey' . $ArticleFreeTextNumber } = 'State';
    $Param->{GetParam}->{ 'X-OTRS-FollowUp-ArticleValue' . $ArticleFreeTextNumber }
        = $Self->{State};

    if ( $Self->{State} =~ /$Self->{Config}->{CloseTicketRegExp}/ ) {

        # Close Ticket Condition -> Take Close Action
        if ( $Self->{Config}->{CloseActionState} ne 'OLD' ) {
            $Param->{GetParam}->{'X-OTRS-FollowUp-State'} = $Self->{Config}->{CloseActionState};

            my $TimeStamp = $Self->{TimeObject}->SystemTime2TimeStamp(
                SystemTime => $Self->{TimeObject}->SystemTime()
                    + $Self->{Config}->{ClosePendingTime},
            );
            $Param->{GetParam}->{'X-OTRS-State-PendingTime'} = $TimeStamp;
        }

        # set log message
        $Self->_LogMessage('Recovered');

        # if the CI incident state should be set
        if ( $Self->{ConfigObject}->Get('SystemMonitoring::SetIncidentState') ) {
            $Self->_IncidentStateOperational();
        }
    }
    else {

        # Attach note to existing ticket
        $Self->_LogMessage('New Notice');
    }

    # link ticket with CI, this is only possible if the ticket already exists,
    # e.g. in a subsequent email request, because we need a ticket id
    if ( $Self->{ConfigObject}->Get('SystemMonitoring::LinkTicketWithCI') ) {

        # link ticket with CI
        $Self->_LinkTicketWithCI(
            Name     => $Self->{Host},
            TicketID => $TicketID,
        );
    }
}

# the sub takes the param as a hashref not as a copy, because it is updated

sub _TicketCreate
{
    my $Self  = shift || die "missing self";
    my $Param = shift || die "missing param hashref";

    # Create Ticket Condition -> Create new Ticket and record Host and Service
    for (qw(Host Service)) {

        # get the freetext number from config
        my $TicketFreeTextNumber = $Self->{Config}->{ 'FreeText' . $_ };

        # see the Kernel::System::PostMaster::NewTicket  where this is read
        $Param->{GetParam}->{ 'X-OTRS-TicketKey' . $TicketFreeTextNumber }   = $_;
        $Param->{GetParam}->{ 'X-OTRS-TicketValue' . $TicketFreeTextNumber } = $Self->{$_};
    }

    # Set Article Free Field for State
    my $ArticleFreeTextNumber = $Self->{Config}->{'FreeTextState'};
    $Param->{GetParam}->{ 'X-OTRS-ArticleKey' . $ArticleFreeTextNumber }   = 'State';
    $Param->{GetParam}->{ 'X-OTRS-ArticleValue' . $ArticleFreeTextNumber } = $Self->{State};

    # set sender type and article type
    $Param->{GetParam}->{'X-OTRS-SenderType'}  = $Self->{Config}->{SenderType};
    $Param->{GetParam}->{'X-OTRS-ArticleType'} = $Self->{Config}->{ArticleType};

    # set log message
    $Self->_LogMessage('New Ticket');

    # if the CI incident state should be set
    if ( $Self->{ConfigObject}->Get('SystemMonitoring::SetIncidentState') ) {
        $Self->_IncidentStateIncident();
    }
}

# the sub takes the param as a hashref not as a copy, because it is updated

sub _TicketDrop {
    my $Self  = shift || die "missing self";
    my $Param = shift || die "missing param hashref";

    # No existing ticket and no open condition -> drop silently
    $Param->{GetParam}->{'X-OTRS-Ignore'} = 'yes';
    $Self->_LogMessage('Mail Dropped, no matching ticket found, no open on this state ');

}

sub Run {

    my ( $Self, %Param ) = @_;

    # get config options, use defaults unless value specified
    if ( $Param{JobConfig} && ref $Param{JobConfig} eq 'HASH' ) {
        KEY:
        for my $Key ( keys( %{ $Param{JobConfig} } ) ) {
            next KEY if !$Self->{Config}->{$Key};
            $Self->{Config}->{$Key} = $Param{JobConfig}->{$Key};
        }
    }

    # check if sender is of interest
    return 1 if !$Param{GetParam}->{From};
    return 1 if $Param{GetParam}->{From} !~ /$Self->{Config}->{FromAddressRegExp}/i;

    $Self->_MailParse(%Param);

    # we need State and Host to proceed
    if ( !$Self->{State} || !$Self->{Host} ) {

        $Self->{LogObject}->Log(
            Priority => 'notice',
            Message  => 'SystemMonitoring Mail: '
                . 'SystemMonitoring: Could not find host address '
                . 'and/or state in mail => Ignoring',
        );
        return 1;
    }

    # Check for Service
    $Self->{Service} ||= $Self->{Config}->{DefaultService};

    my $TicketID = $Self->_TicketSearch();

    # OK, found ticket to deal with
    if ($TicketID) {
        $Self->_TicketUpdate( $TicketID, \%Param );
    }
    elsif ( $Self->{State} =~ /$Self->{Config}->{NewTicketRegExp}/ ) {
        $Self->_TicketCreate( \%Param );
    }
    else {
        $Self->_TicketDrop( \%Param );
    }

    return 1;
}

sub _SetIncidentState {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(Name IncidentState )) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # check configitem object
    return if !$Self->{ConfigItemObject};

    # search configitem
    my $ConfigItemIDs = $Self->{ConfigItemObject}->ConfigItemSearchExtended(
        Name => $Param{Name},
    );

    # if no config item with this name was found
    if ( !$ConfigItemIDs || ref $ConfigItemIDs ne 'ARRAY' || !@{$ConfigItemIDs} ) {

        # log error
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Could not find any CI with the name '$Param{Name}'. ",
        );
        return;
    }

    # if more than one config item with this name was found
    if ( scalar @{$ConfigItemIDs} > 1 ) {

        # log error
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Can not set incident state for CI with the name '$Param{Name}'. "
                . "More than one CI with this name was found!",
        );
        return;
    }

    # we only found one config item
    my $ConfigItemID = shift @{$ConfigItemIDs};

    # get config item
    my $ConfigItem = $Self->{ConfigItemObject}->ConfigItemGet(
        ConfigItemID => $ConfigItemID,
    );

    # get latest version data of config item
    my $Version = $Self->{ConfigItemObject}->VersionGet(
        ConfigItemID => $ConfigItemID,
    );

    return if !$Version;
    return if ref $Version ne 'HASH';

    # get incident state list
    my $InciStateList = $Self->{GeneralCatalogObject}->ItemList(
        Class => 'ITSM::Core::IncidentState',
    );

    return if !$InciStateList;
    return if ref $InciStateList ne 'HASH';

    # reverse the incident state list
    my %ReverseInciStateList = reverse %{$InciStateList};

    # check if incident state is valid
    if ( !$ReverseInciStateList{ $Param{IncidentState} } ) {

        # log error
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Invalid incident state '$Param{IncidentState}'!",
        );
        return;
    }

    # add a new version with the new incident state
    my $VersionID = $Self->{ConfigItemObject}->VersionAdd(
        %{$Version},
        InciStateID => $ReverseInciStateList{ $Param{IncidentState} },
        UserID      => 1,
    );

    return $VersionID;
}

sub _LinkTicketWithCI {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(Name TicketID )) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # check configitem object
    return if !$Self->{ConfigItemObject};

    # search configitem
    my $ConfigItemIDs = $Self->{ConfigItemObject}->ConfigItemSearchExtended(
        Name => $Param{Name},
    );

    # if no config item with this name was found
    if ( !$ConfigItemIDs || ref $ConfigItemIDs ne 'ARRAY' || !@{$ConfigItemIDs} ) {

        # log error
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Could not find any CI with the name '$Param{Name}'. ",
        );
        return;
    }

    # if more than one config item with this name was found
    if ( scalar @{$ConfigItemIDs} > 1 ) {

        # log error
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Can not set incident state for CI with the name '$Param{Name}'. "
                . "More than one CI with this name was found!",
        );
        return;
    }

    # we only found one config item
    my $ConfigItemID = shift @{$ConfigItemIDs};

    # link the ticket with the CI
    my $LinkResult = $Self->{LinkObject}->LinkAdd(
        SourceObject => 'Ticket',
        SourceKey    => $Param{TicketID},
        TargetObject => 'ITSMConfigItem',
        TargetKey    => $ConfigItemID,
        Type         => 'RelevantTo',
        State        => 'Valid',
        UserID       => 1,
    );

    return $LinkResult;
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (http://otrs.org/).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut

=head1 VERSION

$Revision: 1.15 $ $Date: 2012-01-31 14:39:47 $

=cut
