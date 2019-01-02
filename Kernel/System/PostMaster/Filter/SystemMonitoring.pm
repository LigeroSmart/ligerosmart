# --
# Copyright (C) 2001-2019 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

# important configuration items SystemMonitoring::SetIncidentState

package Kernel::System::PostMaster::Filter::SystemMonitoring;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::DynamicField',
    'Kernel::System::LinkObject',
    'Kernel::System::Log',
    'Kernel::System::Main',
    'Kernel::System::Ticket',
    'Kernel::System::DateTime',
);

#the base name for dynamic fields
our $DynamicFieldTicketTextPrefix  = 'TicketFreeText';
our $DynamicFieldArticleTextPrefix = 'ArticleFreeText';

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    $Self->{Debug} = $Param{Debug} || 0;

    # check if CI incident state should be set automatically
    # this requires the ITSMConfigurationManagement module to be installed
    if ( $Kernel::OM->Get('Kernel::Config')->Get('SystemMonitoring::SetIncidentState') ) {

        $Self->_IncidentStateNew();
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

    # get communication log object and MessageID
    if ( !defined $Param{CommuncationLogRequired} || $Param{CommuncationLogRequired} ) {
        $Self->{CommunicationLogObject} = $Param{CommunicationLogObject} || die "Got no CommunicationLogObject!";
    }

    return $Self;
}

sub _GetDynamicFieldDefinition {
    my ( $Self, %Param ) = @_;

    for my $Argument (qw(Config Key Default Base Name ObjectType)) {
        if ( !$Param{$Argument} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    my $Config     = $Param{Config};
    my $Key        = $Param{Key};           #FreeTextHost the config key
    my $Default    = $Param{Default};       #1 the default value
    my $Base       = $Param{Base};          # DynamicFieldTicketTextPrefix
    my $Name       = $Param{Name};          #HostName
    my $ObjectType = $Param{ObjectType};    #HostName

    my $ConfigFreeText = $Config->{$Key};

    if ( !$ConfigFreeText ) {
        $ConfigFreeText = $Default;
    }

    if ( $ConfigFreeText =~ /^\d+$/ ) {
        if ( ( $ConfigFreeText < 1 ) || ( $ConfigFreeText > 16 ) ) {
            die "Bad value $ConfigFreeText for CI Config $Key!";
        }
    }
    else {
        die "Bad value $ConfigFreeText for CI Config $Key!";
    }

    my $FieldNameHost = $Base . $ConfigFreeText;

    # define all dynamic fields for System Monitoring, these need to be changed as well if the
    # config changes
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
    my ( $Self, %Param ) = @_;

    my $Config = $Param{Config};

    push @{ $Param{NewFields} }, $Self->_GetDynamicFieldDefinition(
        Config     => $Config,
        Key        => 'FreeTextHost',
        Default    => 1,
        Base       => $DynamicFieldTicketTextPrefix,
        Name       => 'HostName',
        ObjectType => 'Ticket',
    );
    push @{ $Param{NewFields} }, $Self->_GetDynamicFieldDefinition(
        Config     => $Config,
        Key        => 'FreeTextService',
        Default    => 2,
        Base       => $DynamicFieldTicketTextPrefix,
        Name       => 'ServiceName',
        ObjectType => 'Ticket',
    );
    push @{ $Param{NewFields} }, $Self->_GetDynamicFieldDefinition(
        Config     => $Config,
        Key        => 'FreeTextState',
        Default    => 1,
        Base       => $DynamicFieldArticleTextPrefix,
        Name       => 'StateName',
        ObjectType => 'Article',
    );

    return 1;
}

sub _IncidentStateIncident {
    my ( $Self, %Param ) = @_;

    # set the CI incident state to 'Incident'
    $Self->_SetIncidentState(
        Name          => $Self->{Host},
        IncidentState => 'Incident',
    );

    return 1;
}

sub _IncidentStateOperational {
    my ( $Self, %Param ) = @_;

    # set the CI incident state to 'Operational'
    $Self->_SetIncidentState(
        Name          => $Self->{Host},
        IncidentState => 'Operational',
    );

    return 1;
}

# these are optional modules from the ITSM Kernel::System::GeneralCatalog and Kernel::System::ITSMConfigItem

sub _IncidentStateNew {
    my ( $Self, %Param ) = @_;

    # get main object
    my $MainObject = $Kernel::OM->Get('Kernel::System::Main');

    # require the general catalog module
    if ( $MainObject->Require('Kernel::System::GeneralCatalog') ) {

        # create general catalog object
        $Self->{GeneralCatalogObject} = Kernel::System::GeneralCatalog->new( %{$Self} );
    }

    # require the config item module
    if ( $MainObject->Require('Kernel::System::ITSMConfigItem') ) {

        # create config item object
        $Self->{ConfigItemObject} = Kernel::System::ITSMConfigItem->new( %{$Self} );
    }

    return 1;
}

sub _MailParse {
    my ( $Self, %Param ) = @_;

    if ( !$Param{GetParam} || !$Param{GetParam}->{Subject} ) {

        $Self->{CommunicationLogObject}->ObjectLog(
            ObjectLogType => 'Message',
            Priority      => 'Error',
            Key           => 'Kernel::System::PostMaster::Filter::SystemMonitoring',
            Value         => "Need Subject!",
        );

        return;
    }

    my $Subject = $Param{GetParam}->{Subject};

    # Try to get State, Host and Service from email subject
    my @SubjectLines = split /\n/, $Subject;
    for my $Line (@SubjectLines) {
        for my $Item (qw(State Host Service)) {
            if ( $Line =~ /$Self->{Config}->{ $Item . 'RegExp' }/ ) {
                $Self->{$Item} = $1;
            }
        }
    }

    #  Don't Try to get State, Host and Service from email body, we want it from the subject alone

    # split the body into separate lines
    if ( !$Param{GetParam}->{Body} ) {

        $Self->{CommunicationLogObject}->ObjectLog(
            ObjectLogType => 'Message',
            Priority      => 'Error',
            Key           => 'Kernel::System::PostMaster::Filter::SystemMonitoring',
            Value         => "Need Body!",
        );

        return;
    }
    my $Body = $Param{GetParam}->{Body};

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

    return 1;
}

sub _LogMessage {
    my ( $Self, %Param ) = @_;

    if ( !$Param{MessageText} ) {

        $Self->{CommunicationLogObject}->ObjectLog(
            ObjectLogType => 'Message',
            Priority      => 'Error',
            Key           => 'Kernel::System::PostMaster::Filter::SystemMonitoring',
            Value         => "Need MessageText!",
        );

        return;
    }

    my $MessageText = $Param{MessageText};

    # logging
    # define log message
    $Self->{Service} ||= "No Service";
    $Self->{State}   ||= "No State";
    $Self->{Host}    ||= "No Host";

    my $LogMessage = $MessageText . " - "
        . "Host: $Self->{Host}, "
        . "State: $Self->{State}, "
        . "Service: $Self->{Service}";

    $Self->{CommunicationLogObject}->ObjectLog(
        ObjectLogType => 'Message',
        Priority      => 'Notice',
        Key           => 'Kernel::System::PostMaster::Filter::SystemMonitoring',
        Value         => 'SystemMonitoring Mail: ' . $LogMessage,
    );

    return 1;
}

sub _TicketSearch {
    my ( $Self, %Param ) = @_;

    # Is there a ticket for this Host/Service pair?
    my %Query = (
        Result    => 'ARRAY',
        Limit     => 1,
        UserID    => 1,
        StateType => 'Open',
    );

    for my $Type (qw(Host Service)) {
        my $FreeTextField = $Self->{Config}->{ 'FreeText' . $Type };
        my $KeyName       = "DynamicField_" . $DynamicFieldTicketTextPrefix . $FreeTextField;
        my $KeyValue      = $Self->{$Type};

        $Query{$KeyName}->{Equals} = $KeyValue;
    }

    # get dynamic field object
    my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');

    # Check if dynamic fields really exists.
    # If dynamic fields don't exists, TicketSearch will return all tickets
    # and then the new article/ticket could take wrong place.
    # The lesser of the three evils is to create a new ticket
    # instead of defacing existing tickets or dropping it.
    # This behavior will come true if the dynamic fields
    # are named like TicketFreeTextHost. Its also bad.
    my $Errors = 0;
    for my $Type (qw(Host Service)) {
        my $FreeTextField = $Self->{Config}->{ 'FreeText' . $Type };

        my $DynamicField = $DynamicFieldObject->DynamicFieldGet(
            Name => $DynamicFieldTicketTextPrefix . $FreeTextField,
        );

        if ( !IsHashRefWithData($DynamicField) || $FreeTextField !~ m{\d+}xms ) {

            $Self->{CommunicationLogObject}->ObjectLog(
                ObjectLogType => 'Message',
                Priority      => 'Error',
                Key           => 'Kernel::System::PostMaster::Filter::SystemMonitoring',
                Value         => "DynamicField "
                    . $DynamicFieldTicketTextPrefix
                    . $FreeTextField
                    . " does not exists or misnamed."
                    . " The configuration is based on Dynamic fields, so the number of the dynamic field is expected"
                    . " (wrong value for dynamic field FreeText" . $Type . " is set).",
            );

            $Errors = 1;
        }
    }

    my $ArticleFreeTextField = $Self->{Config}->{'FreeTextState'};
    my $DynamicFieldArticle  = $DynamicFieldObject->DynamicFieldGet(
        Name => $DynamicFieldArticleTextPrefix . $ArticleFreeTextField,
    );

    if ( !IsHashRefWithData($DynamicFieldArticle) || $ArticleFreeTextField !~ m{\d+}xms ) {

        $Self->{CommunicationLogObject}->ObjectLog(
            ObjectLogType => 'Message',
            Priority      => 'Error',
            Key           => 'Kernel::System::PostMaster::Filter::SystemMonitoring',
            Value         => "DynamicField "
                . $DynamicFieldArticleTextPrefix
                . $ArticleFreeTextField
                . " does not exists or misnamed."
                . " The configuration is based on dynamic fields, so the number of the dynamic field is expected"
                . " (wrong value for dynamic field FreeTextState is set).",
        );

        $Errors = 1;
    }

    my @TicketIDs = $Kernel::OM->Get('Kernel::System::Ticket')->TicketSearch(%Query);

    # get the first and only ticket id
    my $TicketID;
    if ( !$Errors && @TicketIDs ) {
        $TicketID = shift @TicketIDs;
    }

    return $TicketID;
}

# the sub takes the param as a hash reference not as a copy, because it is updated

sub _TicketUpdate {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(TicketID Param)) {
        if ( !$Param{$Needed} ) {

            $Self->{CommunicationLogObject}->ObjectLog(
                ObjectLogType => 'Message',
                Priority      => 'Error',
                Key           => 'Kernel::System::PostMaster::Filter::SystemMonitoring',
                Value         => "Need $Needed",
            );

            return;
        }
    }

    my $TicketID = $Param{TicketID};
    my $Param    = $Param{Param};

    # get ticket object
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

    # get ticket number
    my $TicketNumber = $TicketObject->TicketNumberLookup(
        TicketID => $TicketID,
        UserID   => 1,
    );

    # build subject
    $Param->{GetParam}->{Subject} = $TicketObject->TicketSubjectBuild(
        TicketNumber => $TicketNumber,
        Subject      => $Param->{GetParam}->{Subject},
    );

    # set sender type and article type
    $Param->{GetParam}->{'X-OTRS-FollowUp-SenderType'}  = $Self->{Config}->{SenderType};
    $Param->{GetParam}->{'X-OTRS-FollowUp-ArticleType'} = $Self->{Config}->{ArticleType};

    # Set Article Free Field for State
    my $ArticleFreeTextNumber = $Self->{Config}->{'FreeTextState'};
    $Param->{GetParam}->{ 'X-OTRS-FollowUp-ArticleKey' . $ArticleFreeTextNumber }   = 'State';
    $Param->{GetParam}->{ 'X-OTRS-FollowUp-ArticleValue' . $ArticleFreeTextNumber } = $Self->{State};

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    if ( $Self->{State} =~ /$Self->{Config}->{CloseTicketRegExp}/ ) {

        # Close Ticket Condition -> Take Close Action
        if ( $Self->{Config}->{CloseActionState} ne 'OLD' ) {
            $Param->{GetParam}->{'X-OTRS-FollowUp-State'} = $Self->{Config}->{CloseActionState};

            # get datetime object
            my $DateTimeObject = $Kernel::OM->Create(
                'Kernel::System::DateTime'
            );
            $DateTimeObject->Add(
                Seconds => $Self->{Config}->{ClosePendingTime},
            );

            $Param->{GetParam}->{'X-OTRS-FollowUp-State-PendingTime'} = $DateTimeObject->ToString();
        }

        # set log message
        $Self->_LogMessage( MessageText => 'Recovered' );

        # if the CI incident state should be set
        if ( $ConfigObject->Get('SystemMonitoring::SetIncidentState') ) {
            $Self->_IncidentStateOperational();
        }
    }
    else {

        # Attach note to existing ticket
        $Self->_LogMessage( MessageText => 'New Notice' );
    }

    # link ticket with CI, this is only possible if the ticket already exists,
    # e.g. in a subsequent email request, because we need a ticket id
    if ( $ConfigObject->Get('SystemMonitoring::LinkTicketWithCI') ) {

        # link ticket with CI
        $Self->_LinkTicketWithCI(
            Name     => $Self->{Host},
            TicketID => $TicketID,
        );
    }

    return 1;
}

# the sub takes the param as a hash reference not as a copy, because it is updated

sub _TicketCreate {
    my ( $Self, $Param ) = @_;

    # Create Ticket Condition -> Create new Ticket and record Host and Service
    for my $Item (qw(Host Service)) {

        # get the freetext number from config
        my $TicketFreeTextNumber = $Self->{Config}->{ 'FreeText' . $Item };

        # see the Kernel::System::PostMaster::NewTicket  where this is read
        $Param->{GetParam}->{ 'X-OTRS-TicketKey' . $TicketFreeTextNumber }   = $Item;
        $Param->{GetParam}->{ 'X-OTRS-TicketValue' . $TicketFreeTextNumber } = $Self->{$Item};
    }

    # Set Article Free Field for State
    my $ArticleFreeTextNumber = $Self->{Config}->{'FreeTextState'};
    $Param->{GetParam}->{ 'X-OTRS-ArticleKey' . $ArticleFreeTextNumber }   = 'State';
    $Param->{GetParam}->{ 'X-OTRS-ArticleValue' . $ArticleFreeTextNumber } = $Self->{State};

    # set sender type and article type
    $Param->{GetParam}->{'X-OTRS-SenderType'}  = $Self->{Config}->{SenderType};
    $Param->{GetParam}->{'X-OTRS-ArticleType'} = $Self->{Config}->{ArticleType};

    # set log message
    $Self->_LogMessage( MessageText => 'New Ticket' );

    # if the CI incident state should be set
    if ( $Kernel::OM->Get('Kernel::Config')->Get('SystemMonitoring::SetIncidentState') ) {
        $Self->_IncidentStateIncident();
    }

    return 1;
}

# the sub takes the param as a hash reference not as a copy, because it is updated

sub _TicketDrop {
    my ( $Self, $Param ) = @_;

    # No existing ticket and no open condition -> drop silently
    $Param->{GetParam}->{'X-OTRS-Ignore'} = 'yes';
    $Self->_LogMessage(
        MessageText => 'Mail Dropped, no matching ticket found, no open on this state ',
    );

    return 1;
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

        $Self->{CommunicationLogObject}->ObjectLog(
            ObjectLogType => 'Message',
            Priority      => 'Error',
            Key           => 'Kernel::System::PostMaster::Filter::SystemMonitoring',
            Value         => 'SystemMonitoring Mail: '
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
        $Self->_TicketUpdate(
            TicketID => $TicketID,
            Param    => \%Param,
        );
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

            $Self->{CommunicationLogObject}->ObjectLog(
                ObjectLogType => 'Message',
                Priority      => 'Error',
                Key           => 'Kernel::System::PostMaster::Filter::SystemMonitoring',
                Value         => "Need $Argument",
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
        $Self->{CommunicationLogObject}->ObjectLog(
            ObjectLogType => 'Message',
            Priority      => 'Error',
            Key           => 'Kernel::System::PostMaster::Filter::SystemMonitoring',
            Value         => "Could not find any CI with the name '$Param{Name}'. ",
        );

        return;
    }

    # if more than one config item with this name was found
    if ( scalar @{$ConfigItemIDs} > 1 ) {

        # log error
        $Self->{CommunicationLogObject}->ObjectLog(
            ObjectLogType => 'Message',
            Priority      => 'Error',
            Key           => 'Kernel::System::PostMaster::Filter::SystemMonitoring',
            Value         => "Can not set incident state for CI with the name '$Param{Name}'. "
                . "More than one CI with this name was found!",
        );

        return;
    }

    # we only found one config item
    my $ConfigItemID = shift @{$ConfigItemIDs};

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
        $Self->{CommunicationLogObject}->ObjectLog(
            ObjectLogType => 'Message',
            Priority      => 'Error',
            Key           => 'Kernel::System::PostMaster::Filter::SystemMonitoring',
            Value         => "Invalid incident state '$Param{IncidentState}'!",
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
    for my $Argument (qw(Name TicketID)) {
        if ( !$Param{$Argument} ) {

            $Self->{CommunicationLogObject}->ObjectLog(
                ObjectLogType => 'Message',
                Priority      => 'Error',
                Key           => 'Kernel::System::PostMaster::Filter::SystemMonitoring',
                Value         => "Need $Argument",
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
        $Self->{CommunicationLogObject}->ObjectLog(
            ObjectLogType => 'Message',
            Priority      => 'Error',
            Key           => 'Kernel::System::PostMaster::Filter::SystemMonitoring',
            Value         => "Could not find any CI with the name '$Param{Name}'. ",
        );

        return;
    }

    # if more than one config item with this name was found
    if ( scalar @{$ConfigItemIDs} > 1 ) {

        # log error
        $Self->{CommunicationLogObject}->ObjectLog(
            ObjectLogType => 'Message',
            Priority      => 'Error',
            Key           => 'Kernel::System::PostMaster::Filter::SystemMonitoring',
            Value         => "Can not set incident state for CI with the name '$Param{Name}'. "
                . "More than one CI with this name was found!",
        );

        return;
    }

    # we only found one config item
    my $ConfigItemID = shift @{$ConfigItemIDs};

    # link the ticket with the CI
    my $LinkResult = $Kernel::OM->Get('Kernel::System::LinkObject')->LinkAdd(
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

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<https://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
