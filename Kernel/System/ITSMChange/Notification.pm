# --
# Kernel/System/ITSMChange/Notification.pm - lib for notifications in change management
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::ITSMChange::Notification;

use strict;
use warnings;

use Kernel::System::EventHandler;
use Kernel::System::CacheInternal;
use Kernel::System::CustomerUser;
use Kernel::System::Email;
use Kernel::System::HTMLUtils;
use Kernel::System::ITSMChange;
use Kernel::System::ITSMChange::ITSMWorkOrder;
use Kernel::System::Notification;
use Kernel::System::Valid;
use Kernel::Language;

use vars qw(@ISA);

@ISA = (
    'Kernel::System::EventHandler',
);

=head1 NAME

Kernel::System::ITSMChange::Notification - notification functions for change management

=head1 SYNOPSIS

This module is managing notifications.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create a notification object

    use Kernel::Config;
    use Kernel::System::Encode;
    use Kernel::System::Log;
    use Kernel::System::Main;
    use Kernel::System::DB;
    use Kernel::System::Time;
    use Kernel::System::ITSMChange::Notification;

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
    my $DBObject = Kernel::System::DB->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
        MainObject   => $MainObject,
    );
    my $TimeObject = Kernel::System::Time->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
    );
    my $NotificationObject = Kernel::System::ITSMChange::Notification->new(
        EncodeObject => $EncodeObject,
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
        MainObject   => $MainObject,
        DBObject     => $DBObject,
        TimeObject   => $TimeObject,
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for my $Object (
        qw(DBObject ConfigObject EncodeObject LogObject UserObject GroupObject MainObject TimeObject)
        )
    {
        $Self->{$Object} = $Param{$Object} || die "Got no $Object!";
    }

    # set the debug flag
    $Self->{Debug} = $Param{Debug} || 0;

    # create additional objects
    $Self->{NotificationObject} = Kernel::System::Notification->new( %{$Self} );
    $Self->{CustomerUserObject} = Kernel::System::CustomerUser->new( %{$Self} );
    $Self->{ChangeObject}       = Kernel::System::ITSMChange->new( %{$Self} );
    $Self->{WorkOrderObject}    = Kernel::System::ITSMChange::ITSMWorkOrder->new( %{$Self} );
    $Self->{HTMLUtilsObject}    = Kernel::System::HTMLUtils->new( %{$Self} );
    $Self->{SendmailObject}     = Kernel::System::Email->new( %{$Self} );
    $Self->{ValidObject}        = Kernel::System::Valid->new( %{$Self} );

    # get the cache TTL (in seconds)
    $Self->{CacheTTL} = $Self->{ConfigObject}->Get('ITSMChange::CacheTTL') * 60;

    # create additional objects
    $Self->{CacheInternalObject} = Kernel::System::CacheInternal->new(
        %{$Self},
        Type => 'ITSMChangeManagement',
        TTL  => $Self->{CacheTTL},
    );

    # do we use richtext
    $Self->{RichText} = $Self->{ConfigObject}->Get('Frontend::RichText');

    # set up empty cache for _NotificationGet()
    $Self->{NotificationCache} = {};

    # init of event handler
    $Self->EventHandlerInit(
        Config     => 'ITSMChangeManagementNotification::EventModule',
        BaseObject => 'ChangeObject',
        Objects    => {
            %{$Self},
        },
    );

    return $Self;
}

=item NotificationSend()

Send the notification to customers and/or agents.

    my $Success = $NotificationObject->NotificationSend(
        AgentIDs    => [ 1, 2, 3, ]
        CustomerIDs => [ 1, 2, 3, ],
        Type        => 'Change',          # Change|WorkOrder
        Event       => 'ChangeUpdate',
        Data        => { %ChangeData },   # Change|WorkOrder|Link data
        UserID      => 123,
    );

=cut

sub NotificationSend {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(Type Event UserID Data)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # for convenience
    my $Event = $Param{Event};

    # need at least AgentIDs or CustomerIDs
    if ( !$Param{AgentIDs} && !$Param{CustomerIDs} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need at least AgentIDs or CustomerIDs!',
        );
        return;
    }

    # AgentIDs and CustomerIDs have to be array references
    for my $IDKey (qw(AgentIDs CustomerIDs)) {
        if ( defined $Param{$IDKey} && ref $Param{$IDKey} ne 'ARRAY' ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "$IDKey has to be an array reference!",
            );
            return;
        }
    }

    # check whether the sending of notification has been turned off
    return 1 if !$Self->{ConfigObject}->Get('ITSMChange::SendNotifications');

    # we need to get the items for replacements
    my $Change    = {};
    my $WorkOrder = {};
    my $Link      = {};

    # start with workorder, as the change id might be taken from the workorder
    if ( $Param{Data}->{WorkOrderID} ) {

        if ( $Event eq 'WorkOrderDelete' ) {

            # the workorder is already deleted,
            # so we display the old data
            $WorkOrder = $Param{Data}->{OldWorkOrderData};
        }
        else {

            # get fresh data
            $WorkOrder = $Self->{WorkOrderObject}->WorkOrderGet(
                WorkOrderID => $Param{Data}->{WorkOrderID},
                UserID      => $Param{UserID},
                LogNo       => 1,
            );
        }

        # The event 'WorkOrderAdd' is a special case, as the workorder
        # is not completely initialized yet. So also take
        # the params for WorkOrderAdd() into account.
        # WorkOrderGet() must still be called, as it provides translation
        # for some IDs that were set in WorkOrderAdd().
        if ( $Event eq 'WorkOrderAdd' ) {
            for my $Attribute ( sort keys %{$WorkOrder} ) {
                $WorkOrder->{$Attribute} ||= $Param{Data}->{$Attribute};
            }
        }

        if ( $WorkOrder->{WorkOrderAgentID} ) {

            # get user data for the workorder agent
            $Param{Data}->{WorkOrderAgent} = {
                $Self->{UserObject}->GetUserData(
                    UserID => $WorkOrder->{WorkOrderAgentID},
                    )
            };
        }

        # infer the change id from the workorder
        if ( $WorkOrder->{ChangeID} ) {
            $Param{Data}->{ChangeID} = $WorkOrder->{ChangeID};
        }
    }

    if ( $Param{Data}->{ChangeID} ) {

        $Change = $Self->{ChangeObject}->ChangeGet(
            ChangeID => $Param{Data}->{ChangeID},
            UserID   => $Param{UserID},
            LogNo    => 1,
        );

        # The event 'ChangeAdd' is a special case, as the change
        # is not completely initialized yet. So also take
        # the params for ChangeAdd() into account.
        # ChangeGet() must still be called, as it provides translation
        # for some IDs that were set in ChangeAdd().
        if ( $Event eq 'ChangeAdd' ) {
            for my $Attribute ( sort keys %{$Change} ) {
                $Change->{$Attribute} ||= $Param{Data}->{$Attribute};
            }
        }

        if ( $Change->{ChangeBuilderID} ) {
            $Param{Data}->{ChangeBuilder} = {
                $Self->{UserObject}->GetUserData(
                    UserID => $Change->{ChangeBuilderID},
                    )
            };
        }

        if ( $Change->{ChangeManagerID} ) {
            $Param{Data}->{ChangeManager} = {
                $Self->{UserObject}->GetUserData(
                    UserID => $Change->{ChangeManagerID},
                    )
            };
        }
    }

    # for link events there is some info about the link
    if ( $Event =~ m{ \A (?: Change | WorkOrder ) Link (?: Add | Delete ) }xms ) {
        $Link = {
            SourceObject => $Param{Data}->{SourceObject},
            TargetObject => $Param{Data}->{TargetObject},
            State        => $Param{Data}->{State},
            Type         => $Param{Data}->{Type},
            Object       => $Param{Data}->{Object},
        };
    }

    # get the valid ids
    my @ValidIDs = $Self->{ValidObject}->ValidIDsGet();
    my %ValidIDLookup = map { $_ => 1 } @ValidIDs;

    my %AgentsSent;

    AGENTID:
    for my $AgentID ( @{ $Param{AgentIDs} } ) {

        # check if notification was already sent to this agent
        next AGENTID if $AgentsSent{$AgentID};

        # User info for prefered language and macro replacement
        my %User = $Self->{UserObject}->GetUserData(
            UserID => $AgentID,
        );

        # do not send emails to invalid agents
        if ( exists $User{ValidID} && !$ValidIDLookup{ $User{ValidID} } ) {
            next AGENTID;
        }

        my $PreferredLanguage
            = $User{UserLanguage} || $Self->{ConfigObject}->Get('DefaultLanguage') || 'en';

        my $NotificationKey
            = $PreferredLanguage . '::Agent::' . $Param{Type} . '::' . $Param{Event};

        # get notification (cache || database)
        my $Notification = $Self->_NotificationGet(
            NotificationKey => $NotificationKey,
        );

        return if !$Notification;

        # replace otrs macros
        $Notification->{Body} = $Self->_NotificationReplaceMacros(
            Type      => $Param{Type},
            Text      => $Notification->{Body},
            Recipient => {%User},
            RichText  => $Self->{RichText},
            UserID    => $Param{UserID},
            Change    => $Change,
            WorkOrder => $WorkOrder,
            Link      => $Link,
            Data      => $Param{Data},
            Language  => $PreferredLanguage,
        );

        $Notification->{Subject} = $Self->_NotificationReplaceMacros(
            Type      => $Param{Type},
            Text      => $Notification->{Subject},
            Recipient => {%User},
            UserID    => $Param{UserID},
            Change    => $Change,
            WorkOrder => $WorkOrder,
            Link      => $Link,
            Data      => $Param{Data},
            Language  => $PreferredLanguage,
        );

        # add urls and verify to be full html document
        if ( $Self->{RichText} ) {

            $Notification->{Body} = $Self->{HTMLUtilsObject}->LinkQuote(
                String => $Notification->{Body},
            );

            $Notification->{Body} = $Self->{HTMLUtilsObject}->DocumentComplete(
                Charset => $Notification->{Charset},
                String  => $Notification->{Body},
            );
        }

        # send notification
        $Self->{SendmailObject}->Send(
            From => $Self->{ConfigObject}->Get('NotificationSenderName') . ' <'
                . $Self->{ConfigObject}->Get('NotificationSenderEmail') . '>',
            To       => $User{UserEmail},
            Subject  => $Notification->{Subject},
            MimeType => $Notification->{ContentType} || 'text/plain',
            Charset  => $Notification->{Charset},
            Body     => $Notification->{Body},
            Loop     => 1,
        );

        # get the event type
        my $Type;
        if ( $Event =~ m{ \A (Change|ActionExecute) }xms ) {
            $Type = 'Change';
        }
        elsif ( $Event =~ m{ \A WorkOrder }xms ) {
            $Type = 'WorkOrder';
        }

        # trigger NotificationSent-Event
        $Self->EventHandler(
            Event => $Type . 'NotificationSentPost',
            Data  => {
                WorkOrderID => $WorkOrder->{WorkOrderID},
                ChangeID    => $Change->{ChangeID},
                EventType   => $Event,
                To          => $User{UserEmail},
            },
            UserID => $Param{UserID},
        );

        $AgentsSent{$AgentID} = 1;
    }

    my %CustomersSent;

    CUSTOMERID:
    for my $CustomerID ( @{ $Param{CustomerIDs} } ) {

        # check if notification was already sent to customer
        next CUSTOMERID if $CustomersSent{$CustomerID};

        # User info for prefered language and macro replacement
        my %CustomerUser = $Self->{CustomerUserObject}->CustomerUserDataGet(
            User => $CustomerID,
        );

        # do not send emails to invalid customers
        if ( exists $CustomerUser{ValidID} && !$ValidIDLookup{ $CustomerUser{ValidID} } ) {
            next CUSTOMERID;
        }

        my $PreferredLanguage
            = $CustomerUser{UserLanguage} || $Self->{ConfigObject}->Get('DefaultLanguage') || 'en';

        my $NotificationKey
            = $PreferredLanguage . '::Customer::' . $Param{Type} . '::' . $Param{Event};

        # get notification (cache || database)
        my $Notification = $Self->_NotificationGet(
            NotificationKey => $NotificationKey,
        );

        # replace otrs macros
        $Notification->{Body} = $Self->_NotificationReplaceMacros(
            Type      => $Param{Type},
            Text      => $Notification->{Body},
            Recipient => {%CustomerUser},
            RichText  => $Self->{RichText},
            UserID    => $Param{UserID},
            Change    => $Change,
            WorkOrder => $WorkOrder,
            Link      => $Link,
            Data      => $Param{Data},
            Language  => $PreferredLanguage,
        );

        $Notification->{Subject} = $Self->_NotificationReplaceMacros(
            Type      => $Param{Type},
            Text      => $Notification->{Subject},
            Recipient => {%CustomerUser},
            UserID    => $Param{UserID},
            Change    => $Change,
            WorkOrder => $WorkOrder,
            Link      => $Link,
            Data      => $Param{Data},
            Language  => $PreferredLanguage,
        );

        # send notification
        $Self->{SendmailObject}->Send(
            From => $Self->{ConfigObject}->Get('NotificationSenderName') . ' <'
                . $Self->{ConfigObject}->Get('NotificationSenderEmail') . '>',
            To       => $CustomerUser{UserEmail},
            Subject  => $Notification->{Subject},
            MimeType => $Notification->{ContentType} || 'text/plain',
            Charset  => $Notification->{Charset},
            Body     => $Notification->{Body},
            Loop     => 1,
        );

        # trigger NotificationSent-Event
        my ($Type) = $Event =~ m{ (WorkOrder|Change) }xms;
        $Self->EventHandler(
            Event => $Type . 'NotificationSentPost',
            Data  => {
                WorkOrderID => $WorkOrder->{WorkOrderID},
                ChangeID    => $Change->{ChangeID},
                EventType   => $Event,
                To          => $CustomerUser{UserEmail},
            },
            UserID => $Param{UserID},
        );

        $CustomersSent{$CustomerID} = 1;
    }

    return 1;
}

=item NotificationRuleGet()

Get info about a single notification rule

    my $NotificationRule = $NotificationObject->NotificationRuleGet(
        ID => 123,
    );

returns

    {
        ID           => 123,
        Name         => 'a descriptive name',
        Attribute    => 'ChangeTitle',
        EventID      => 1,
        Event        => 'ChangeUpdate',
        ValidID      => 1,
        Comment      => 'description what the rule does',
        Rule         => 'rejected',
        Recipients   => [ 'ChangeBuilder', 'ChangeManager', 'ChangeCABCustomers' ],
        RecipientIDs => [ 2, 3, 7 ],
    }

=cut

sub NotificationRuleGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{ID} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need ID!',
        );
        return;
    }

    # check the cache
    my $CacheKey = 'NotificationRuleGet::ID::' . $Param{ID};
    my $Cache    = $Self->{CacheInternalObject}->Get(
        Key => $CacheKey,
    );
    return $Cache if $Cache;

    # do sql query
    return if !$Self->{DBObject}->Prepare(
        SQL => 'SELECT cn.id, cn.name, item_attribute, event_id, cht.name, '
            . 'cn.valid_id, cn.comments, notification_rule '
            . 'FROM change_notification cn, change_history_type cht '
            . 'WHERE event_id = cht.id AND cn.id = ?',
        Bind  => [ \$Param{ID} ],
        Limit => 1,
    );

    # fetch notification rule
    my %NotificationRule;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        %NotificationRule = (
            ID           => $Row[0],
            Name         => $Row[1],
            Attribute    => defined $Row[2] ? $Row[2] : '',
            EventID      => $Row[3],
            Event        => $Row[4],
            ValidID      => $Row[5],
            Comment      => $Row[6],
            Rule         => defined $Row[7] ? $Row[7] : '',
            Recipients   => undef,
            RecipientIDs => undef,
        );
    }

    # get additional info
    if (%NotificationRule) {

        # get recipients
        return if !$Self->{DBObject}->Prepare(
            SQL => 'SELECT grp.id, grp.name '
                . 'FROM change_notification_grps grp, change_notification_rec r '
                . 'WHERE grp.id = r.group_id AND r.notification_id = ?',
            Bind => [ \$NotificationRule{ID} ],
        );

        # fetch recipients
        my @Recipients;
        my @RecipientIDs;
        while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
            push @RecipientIDs, $Row[0];
            push @Recipients,   $Row[1];
        }

        $NotificationRule{Recipients}   = \@Recipients;
        $NotificationRule{RecipientIDs} = \@RecipientIDs;
    }

    # save values in cache
    $Self->{CacheInternalObject}->Set(
        Key   => $CacheKey,
        Value => \%NotificationRule,
    );

    return \%NotificationRule;
}

=item NotificationRuleAdd()

Add a notification rule. Returns the ID of the rule.

    my $ID = $NotificationObject->NotificationRuleAdd(
        Name         => 'a descriptive name',
        Attribute    => 'ChangeTitle',
        EventID      => 1,
        ValidID      => 1,
        Comment      => 'description what the rule does',
        Rule         => 'rejected',
        RecipientIDs => [ 2, 3, 7 ],
    );

=cut

sub NotificationRuleAdd {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(Name EventID ValidID RecipientIDs)) {
        if ( !$Param{$Needed} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    # RecipientIDs must be an array reference
    if ( ref $Param{RecipientIDs} ne 'ARRAY' ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'RecipientIDs must be an array reference!',
        );
        return;
    }

    # save notification rule
    return if !$Self->{DBObject}->Do(
        SQL => 'INSERT INTO change_notification (name, event_id, valid_id, '
            . 'item_attribute, comments, notification_rule) '
            . 'VALUES (?, ?, ?, ?, ?, ?)',
        Bind => [
            \$Param{Name},      \$Param{EventID}, \$Param{ValidID},
            \$Param{Attribute}, \$Param{Comment}, \$Param{Rule},
        ],
    );

    # get ID of rule
    return if !$Self->{DBObject}->Prepare(
        SQL =>
            'SELECT id FROM change_notification WHERE name = ? AND event_id = ? AND valid_id = ? '
            . 'AND item_attribute = ? AND comments = ? AND notification_rule = ?',
        Bind => [
            \$Param{Name},      \$Param{EventID}, \$Param{ValidID},
            \$Param{Attribute}, \$Param{Comment}, \$Param{Rule},
        ],
        Limit => 1,
    );

    # fetch ID
    my $RuleID;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $RuleID = $Row[0];
    }

    return if !$RuleID;

    # insert recipients
    for my $RecipientID ( @{ $Param{RecipientIDs} } ) {
        return if !$Self->{DBObject}->Do(
            SQL => 'INSERT INTO change_notification_rec (notification_id, group_id) VALUES (?, ?)',
            Bind => [ \$RuleID, \$RecipientID ],
        );
    }

    # delete cache
    for my $Key (
        'NotificationRuleList',
        'NotificationRuleSearch::Valid::0',
        'NotificationRuleSearch::Valid::1',
        'NotificationRuleSearch::Valid::0::EventID::' . $Param{EventID},
        'NotificationRuleSearch::Valid::1::EventID::' . $Param{EventID},
        )
    {

        $Self->{CacheInternalObject}->Delete(
            Type => 'ITSMChangeManagement',
            Key  => $Key,
        );
    }

    return $RuleID;
}

=item NotificationRuleUpdate()

updates an existing notification rule

    my $Success = $NotificationObject->NotificationRuleUpdate(
        ID           => 123,
        Name         => 'a descriptive name',
        Attribute    => 'ChangeTitle',
        EventID      => 1,
        ValidID      => 1,
        Comment      => 'description what the rule does',
        Rule         => 'rejected',
        RecipientIDs => [ 2, 3, 7 ],
    );

=cut

sub NotificationRuleUpdate {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(ID Name EventID ValidID RecipientIDs)) {
        if ( !$Param{$Needed} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    # RecipientIDs must be an array reference
    if ( ref $Param{RecipientIDs} ne 'ARRAY' ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'RecipientIDs must be an array reference!',
        );
        return;
    }

    # save notification rule
    return if !$Self->{DBObject}->Do(
        SQL => 'UPDATE change_notification '
            . 'SET name = ?, event_id = ?, valid_id = ?, item_attribute = ?, '
            . 'comments = ?, notification_rule = ? WHERE id = ?',
        Bind => [
            \$Param{Name},      \$Param{EventID}, \$Param{ValidID},
            \$Param{Attribute}, \$Param{Comment}, \$Param{Rule},
            \$Param{ID},
        ],
    );

    # delete old recipient entries
    return if !$Self->{DBObject}->Do(
        SQL  => 'DELETE FROM change_notification_rec WHERE notification_id = ?',
        Bind => [ \$Param{ID} ],
    );

    # insert recipients
    for my $RecipientID ( @{ $Param{RecipientIDs} } ) {
        return if !$Self->{DBObject}->Do(
            SQL => 'INSERT INTO change_notification_rec (notification_id, group_id) VALUES (?, ?)',
            Bind => [ \$Param{ID}, \$RecipientID ],
        );
    }

    # delete cache
    for my $Key (
        'NotificationRuleGet::ID::' . $Param{ID},
        'NotificationRuleList',
        'NotificationRuleSearch::Valid::0',
        'NotificationRuleSearch::Valid::1',
        'NotificationRuleSearch::Valid::0::EventID::' . $Param{EventID},
        'NotificationRuleSearch::Valid::1::EventID::' . $Param{EventID},
        )
    {

        $Self->{CacheInternalObject}->Delete(
            Type => 'ITSMChangeManagement',
            Key  => $Key,
        );
    }

    return 1;
}

=item NotificationRuleList()

returns an array reference with IDs of all existing notification rules

    my $List = $NotificationObject->NotificationRuleList();

returns

    [ 1, 2, 3 ]

=cut

sub NotificationRuleList {
    my $Self = shift;

    # check the cache
    my $CacheKey = 'NotificationRuleList';
    my $Cache    = $Self->{CacheInternalObject}->Get(
        Key => $CacheKey,
    );
    return $Cache if $Cache;

    # do sql query,
    # sort in a userfriendly fashion
    return if !$Self->{DBObject}->Prepare(
        SQL => 'SELECT id FROM change_notification '
            . 'ORDER BY event_id, item_attribute, notification_rule',
    );

    # fetch IDs
    my @IDs;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        push @IDs, $Row[0],
    }

    # save values in cache
    $Self->{CacheInternalObject}->Set(
        Key   => $CacheKey,
        Value => \@IDs,
    );

    return \@IDs;
}

=item NotificationRuleSearch()

Returns an array reference with IDs of all matching notification rules.
The only valid search parameter is the EventID.

    my $NotificationRuleIDs = $NotificationObject->NotificationRuleSearch(
        EventID => 4,    # optional, primary key in change_history_type
        Valid   => 1,    # optional, default is 1
    );

returns

    [ 1, 2, 3 ]

=cut

sub NotificationRuleSearch {
    my ( $Self, %Param ) = @_;

    my $Valid = defined $Param{Valid} ? $Param{Valid} : 1;

    my @SQLWhere;    # assemble the conditions used in the WHERE clause
    my @SQLBind;     # parameters for the WHERE clause

    # define the cache key
    my $CacheKey = 'NotificationRuleSearch::Valid::' . $Valid;

    # for now we only have a single search param
    if ( $Param{EventID} ) {
        push @SQLWhere, 'cn.event_id = ?';
        push @SQLBind,  \$Param{EventID};
        $CacheKey .= '::EventID::' . $Param{EventID};
    }

    my $Cache = $Self->{CacheInternalObject}->Get(
        Key => $CacheKey,
    );
    return $Cache if $Cache;

    my $SQL = 'SELECT id FROM change_notification cn ';

    # add the WHERE clause
    if (@SQLWhere) {
        $SQL .= 'WHERE ';
        $SQL .= join ' AND ', map {"( $_ )"} @SQLWhere;
        $SQL .= ' ';
    }

    # add valid option
    if ($Valid) {
        $SQL .= 'AND cn.valid_id IN (' . join( ', ', $Self->{ValidObject}->ValidIDsGet() ) . ') ';
    }

    # add the ORDER BY clause
    $SQL .= 'ORDER BY cn.id ';

    # do sql query
    return if !$Self->{DBObject}->Prepare(
        SQL  => $SQL,
        Bind => \@SQLBind,
    );

    # fetch IDs
    my @IDs;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        push @IDs, $Row[0],
    }

    # save values in cache
    $Self->{CacheInternalObject}->Set(
        Key   => $CacheKey,
        Value => \@IDs,
    );

    return \@IDs;
}

=item RecipientLookup()

Returns the ID when you pass the recipient name and returns the name if you
pass the recipient ID.

    my $ID = $NotificationObject->RecipientLookup(
        Name => 'ChangeBuilder',
    );

    my $Name = $NotificationObject->RecipientLookup(
        ID => 123,
    );

=cut

sub RecipientLookup {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{ID} && !$Param{Name} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need either ID or Name!',
        );
        return;
    }

    if ( $Param{ID} && $Param{Name} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need either ID or Name - not both!',
        );
        return;
    }

    # check the cache
    my $CacheKey;
    if ( $Param{ID} ) {
        $CacheKey = 'RecipientLookup::ID::' . $Param{ID};
    }
    elsif ( $Param{Name} ) {
        $CacheKey = 'RecipientLookup::Name::' . $Param{Name};
    }
    my $Cache = $Self->{CacheInternalObject}->Get(
        Key => $CacheKey,
    );
    return $Cache if $Cache;

    # determine sql statement and bind parameters
    my $SQL;
    my @Binds;
    if ( $Param{ID} ) {
        $SQL   = 'SELECT name FROM change_notification_grps WHERE id = ?';
        @Binds = ( \$Param{ID} );
    }
    elsif ( $Param{Name} ) {
        $SQL   = 'SELECT id FROM change_notification_grps WHERE name = ?';
        @Binds = ( \$Param{Name} );
    }

    # do sql query
    return if !$Self->{DBObject}->Prepare(
        SQL   => $SQL,
        Bind  => \@Binds,
        Limit => 1,
    );

    # get value
    my $Value;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $Value = $Row[0];
    }

    # save value in cache
    $Self->{CacheInternalObject}->Set(
        Key   => $CacheKey,
        Value => $Value,
    );

    return $Value;
}

=item RecipientList()

returns an array reference with hashreferences. The key of the hashreference is the id
of an recipient and the name is the value.

    my $List = $NotificationObject->RecipientList();

returns

    [
        {
            Key   => 1,
            Value => 'ChangeBuilder'
        },
        {
            Key   => 2,
            Value => 'ChangeManager'
        },
    ]

=cut

sub RecipientList {
    my $Self = shift;

    # do SQL query
    return if !$Self->{DBObject}->Prepare(
        SQL => 'SELECT id, name FROM change_notification_grps ORDER BY name',
    );

    # fetch recipients
    my @Recipients;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        my $Recipient = {
            Key   => $Row[0],
            Value => $Row[1],
        };
        push @Recipients, $Recipient;
    }

    return \@Recipients;
}

=begin Internal:

=item _NotificationGet()

Get the notification template from cache or from the NotificationObject.
Also convert to notification the appropriate content type.

    my $Notification = $NotificationObject->_NotificationGet(
        NotificationKey => 'en::Agent::WorkOrder::WorkOrderUpdate',
    );

=cut

sub _NotificationGet {
    my ( $Self, %Param ) = @_;

    for my $Argument (qw(NotificationKey)) {
        if ( !defined $Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    my $NotificationKey = $Param{NotificationKey};

    # check the cache
    if ( $Self->{NotificationCache}->{$NotificationKey} ) {
        return $Self->{NotificationCache}->{$NotificationKey};
    }

    # get from database
    my %NotificationData = $Self->{NotificationObject}->NotificationGet(
        Name => $NotificationKey,
    );

    # no notification found
    if ( !%NotificationData ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Could not find notification for $NotificationKey",
        );

        return;
    }

    # do text/plain to text/html convert
    if ( $Self->{RichText} && $NotificationData{ContentType} =~ m{ text/plain }xmsi ) {
        $NotificationData{ContentType} = 'text/html';
        $NotificationData{Body}        = $Self->{HTMLUtilsObject}->ToHTML(
            String => $NotificationData{Body},
        );
    }

    # do text/html to text/plain convert
    elsif ( !$Self->{RichText} && $NotificationData{ContentType} =~ m{ text/html }xmsi ) {
        $NotificationData{ContentType} = 'text/plain';
        $NotificationData{Body}        = $Self->{HTMLUtilsObject}->ToAscii(
            String => $NotificationData{Body},
        );
    }

    # cache data
    $Self->{NotificationCache}->{$NotificationKey} = \%NotificationData;

    # return data
    return \%NotificationData;
}

=item _NotificationReplaceMacros()

This method replaces all the <OTRS_xxxx> macros in notification text.

    my $CleanText = $NotificationObject->_NotificationReplaceMacros(
        Type      => 'Change',    # Change|WorkOrder
        Text      => 'Some <OTRS_CONFIG_FQDN> text',
        RichText  => 1,           # optional, is Text richtext or not. default 0
        Recipient => {%User},
        Data      => {
            ChangeBuilder => {
                UserFirstname => 'Tom',
                UserLastname  => 'Tester',
                UserEmail     => 'tt@otrs.com',
            },
        },
        Change    => $Change,
        WorkOrder => $WorkOrder,
        Link      => $Link,
        Language  => $Language,    # used for translating states and such
        UserID    => 1,
    );

=cut

sub _NotificationReplaceMacros {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(Type Text Data UserID Change WorkOrder Link Language)) {
        if ( !defined $Param{$Needed} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    my $Text = $Param{Text};

    # determine what "macro" delimiters are used
    my $Start = '<';
    my $End   = '>';

    # with richtext enabled, the delimiters change
    if ( $Param{RichText} ) {
        $Start = '&lt;';
        $End   = '&gt;';
        $Text =~ s{ (\n|\r) }{}xmsg;
    }

    # translate Change and Workorder values, where appropriate
    my $LanguageObject = Kernel::Language->new(
        MainObject   => $Self->{MainObject},
        ConfigObject => $Self->{ConfigObject},
        EncodeObject => $Self->{EncodeObject},
        LogObject    => $Self->{LogObject},
        UserLanguage => $Param{Language},
    );
    my %ChangeData = %{ $Param{Change} };
    for my $Field (qw(ChangeState Category Priority Impact)) {
        $ChangeData{$Field} = $LanguageObject->Get( $ChangeData{$Field} );
    }

    my %WorkOrderData = %{ $Param{WorkOrder} };
    for my $Field (qw(WorkOrderState WorkOrderType)) {
        $WorkOrderData{$Field} = $LanguageObject->Get( $WorkOrderData{$Field} );
    }

    # replace config options
    my $Tag = $Start . 'OTRS_CONFIG_';
    $Text =~ s{ $Tag (.+?) $End }{$Self->{ConfigObject}->Get($1)}egx;

    # cleanup
    $Text =~ s{ $Tag .+? $End }{-}gi;

    $Tag = $Start . 'OTRS_Agent_';
    my $Tag2 = $Start . 'OTRS_CURRENT_';
    my %CurrentUser = $Self->{UserObject}->GetUserData( UserID => $Param{UserID} );

    # html quoting of content
    if ( $Param{RichText} ) {
        KEY:
        for my $Key ( sort keys %CurrentUser ) {
            next KEY if !$CurrentUser{$Key};
            $CurrentUser{$Key} = $Self->{HTMLUtilsObject}->ToHTML(
                String => $CurrentUser{$Key},
            );
        }
    }

    # replace it
    KEY:
    for my $Key ( sort keys %CurrentUser ) {
        next KEY if !defined $CurrentUser{$Key};
        $Text =~ s{ $Tag $Key $End }{$CurrentUser{$Key}}gxmsi;
        $Text =~ s{ $Tag2 $Key $End }{$CurrentUser{$Key}}gxmsi;
    }

    # replace other needed stuff
    $Text =~ s{ $Start OTRS_FIRST_NAME $End }{$CurrentUser{UserFirstname}}gxms;
    $Text =~ s{ $Start OTRS_LAST_NAME $End }{$CurrentUser{UserLastname}}gxms;

    # cleanup
    $Text =~ s{ $Tag .+? $End}{-}xmsgi;
    $Text =~ s{ $Tag2 .+? $End}{-}xmsgi;

    # get and prepare realname
    $Tag = $Start . 'OTRS_CUSTOMER_REALNAME';
    $Text =~ s{$Tag$End}{-}g;

    # get customer data and replace it with <OTRS_CUSTOMER_DATA_...
    $Tag  = $Start . 'OTRS_CUSTOMER_';
    $Tag2 = $Start . 'OTRS_CUSTOMER_DATA_';

    # cleanup all not needed <OTRS_CUSTOMER_DATA_ tags
    $Text =~ s{ $Tag .+? $End }{-}xmsgi;
    $Text =~ s{ $Tag2 .+? $End}{-}xmsgi;

    # replace <OTRS_CHANGE_... tags
    {
        my $Tag = $Start . 'OTRS_CHANGE_';

        # html quoting of content
        if ( $Param{RichText} ) {
            KEY:
            for my $Key ( sort keys %ChangeData ) {
                next KEY if !$ChangeData{$Key};
                $ChangeData{$Key} = $Self->{HTMLUtilsObject}->ToHTML(
                    String => $ChangeData{$Key},
                );
            }
        }

        # get change builder and change manager
        USER:
        for my $User (qw(ChangeBuilder ChangeManager)) {

            my $Attribute = $User . 'ID';

            # only if an agent is set for this attribute
            next USER if !$ChangeData{$Attribute};

            # get user data
            my %UserData = $Self->{UserObject}->GetUserData(
                UserID => $ChangeData{$Attribute},
                Valid  => 1,
            );

            next USER if !%UserData;

            # build user attribute
            $ChangeData{$User} = "$UserData{UserFirstname} $UserData{UserLastname}";
        }

        # replace it
        KEY:
        for my $Key ( sort keys %ChangeData ) {
            next KEY if !defined $ChangeData{$Key};
            $Text =~ s{ $Tag $Key $End }{$ChangeData{$Key}}gxmsi;
        }

        # cleanup
        $Text =~ s{ $Tag .+? $End}{-}gxmsi;
    }

    # replace <OTRS_WORKORDER_... tags
    {
        my $Tag = $Start . 'OTRS_WORKORDER_';

        # html quoting of content
        if ( $Param{RichText} ) {
            KEY:
            for my $Key ( sort keys %WorkOrderData ) {
                next KEY if !$WorkOrderData{$Key};
                $WorkOrderData{$Key} = $Self->{HTMLUtilsObject}->ToHTML(
                    String => $WorkOrderData{$Key},
                );
            }
        }

        # get workorder agent
        if ( $WorkOrderData{WorkOrderAgentID} ) {

            # get user data
            my %UserData = $Self->{UserObject}->GetUserData(
                UserID => $WorkOrderData{WorkOrderAgentID},
                Valid  => 1,
            );

            # build workorder agent attribute
            if (%UserData) {
                $WorkOrderData{WorkOrderAgent} = "$UserData{UserFirstname} $UserData{UserLastname}";
            }
        }

        # replace it
        KEY:
        for my $Key ( sort keys %WorkOrderData ) {
            next KEY if !defined $WorkOrderData{$Key};
            $Text =~ s{ $Tag $Key $End }{$WorkOrderData{$Key}}gxmsi;
        }

        # cleanup
        $Text =~ s{ $Tag .+? $End}{-}gxmsi;
    }

    # replace <OTRS_CONDITION... tags
    {
        my $Tag  = $Start . 'OTRS_CONDITION_';
        my %Data = %{ $Param{Data} };

        # html quoting of content
        if ( $Param{RichText} ) {
            KEY:
            for my $Key ( sort keys %Data ) {
                next KEY if !$Data{$Key};
                $Data{$Key} = $Self->{HTMLUtilsObject}->ToHTML(
                    String => $Data{$Key},
                );
            }
        }

        # replace it
        KEY:
        for my $Key ( sort keys %Data ) {
            next KEY if !defined $Data{$Key};
            $Text =~ s{ $Tag $Key $End }{$Data{$Key}}gxmsi;
        }

        # cleanup
        $Text =~ s{ $Tag .+? $End}{-}gxmsi;
    }

    # replace <OTRS_LINK_... tags
    {
        my $Tag      = $Start . 'OTRS_LINK_';
        my %LinkData = %{ $Param{Link} };

        # html quoting of content
        if ( $Param{RichText} ) {
            KEY:
            for my $Key ( sort keys %LinkData ) {
                next KEY if !$LinkData{$Key};
                $LinkData{$Key} = $Self->{HTMLUtilsObject}->ToHTML(
                    String => $LinkData{$Key},
                );
            }
        }

        # replace it
        KEY:
        for my $Key ( sort keys %LinkData ) {
            next KEY if !defined $LinkData{$Key};
            $Text =~ s{ $Tag $Key $End }{$LinkData{$Key}}gxmsi;
        }

        # cleanup
        $Text =~ s{ $Tag .+? $End}{-}gxmsi;
    }

    # replace extended <OTRS_CHANGE_... tags
    my %InfoHash = %{ $Param{Data} };

    for my $Object (qw(ChangeBuilder ChangeManager WorkOrderAgent)) {
        my $Tag = $Start . uc 'OTRS_' . $Object . '_';

        if ( exists $InfoHash{$Object} && ref $InfoHash{$Object} eq 'HASH' ) {

            # html quoting of content
            if ( $Param{RichText} ) {

                KEY:
                for my $Key ( sort keys %{ $InfoHash{$Object} } ) {
                    next KEY if !$InfoHash{$Object}->{$Key};
                    $InfoHash{$Object}->{$Key} = $Self->{HTMLUtilsObject}->ToHTML(
                        String => $InfoHash{$Object}->{$Key},
                    );
                }
            }

            # replace it
            KEY:
            for my $Key ( sort keys %{ $InfoHash{$Object} } ) {
                next KEY if !defined $InfoHash{$Object}->{$Key};
                $Text =~ s{ $Tag $Key $End }{$InfoHash{$Object}->{$Key}}gxmsi;
            }
        }

        # cleanup
        $Text =~ s{ $Tag .+? $End}{-}gxmsi;
    }

    # get recipient data and replace it with <OTRS_...
    $Tag = $Start . 'OTRS_';
    if ( $Param{Recipient} ) {

        # html quoting of content
        if ( $Param{RichText} ) {
            KEY:
            for my $Key ( sort keys %{ $Param{Recipient} } ) {
                next KEY if !$Param{Recipient}->{$Key};
                $Param{Recipient}->{$Key} = $Self->{HTMLUtilsObject}->ToHTML(
                    String => $Param{Recipient}->{$Key},
                );
            }
        }

        # replace it
        KEY:
        for my $Key ( sort keys %{ $Param{Recipient} } ) {
            next KEY if !defined $Param{Recipient}->{$Key};
            my $Value = $Param{Recipient}->{$Key};
            $Text =~ s{ $Tag $Key $End }{$Value}gxmsi;
        }
    }

    # cleanup
    $Text =~ s{ $Tag .+? $End}{-}gxmsi;

    return $Text;
}

1;

=end Internal:

=back

=head2 The following placeholders can be used in Change::xxx notifications

=head3 C<OTRS_CHANGE_xxx>

with the subsequent values for xxx:

    ChangeID
        The ID of the change
    ChangeNumber
        The number of the change
    ChangeStateID
        The ID of the change state
    ChangeState
        The name of the change state (e.g. requested, approved)
    ChangeStateSignal
    ChangeTitle
        The change title
    Description
        The "original" description. Please note: If richtext feature is enabled,
        this contains HTML markup. So this can be used to send HTML notifications.
    DescriptionPlain
        This is the plain description without any HTML markup. This is better for plain notifications.
    Justification
        The same as for Description applies here.
    JustificationPlain
        See DescriptionPlain.
    ChangeBuilderID
        Change builder ID
    ChangeManagerID
        Change manager ID
    CategoryID
        ID of changes' category.
    Category
        Name of changes' category.
    ImpactID
        ID of changes' impact.
    Impact
        Name of changes' impact.
    PriorityID
        ID of changes' priority.
    Priority
        Name of changes' priority.
    WorkOrderCount
        Number of all work orders that belong to the change.
    RequestedTime
        The time the customer want the change to be finished.
    PlannedEffort
        Sum of the planned efforts (calculated from the workorders).
    AccountedTime
        Accounted time of the change (calculated from the workorders).
    PlannedStartTime
        Planned start time of the change (calculated from the workorders).
    PlannedEndTime
        Planned end time of the change (calculated from the workorders).
    ActualStartTime
        Actual start time of the change (calculated from the workorders).
    ActualEndTime
        Actual end time of the change (calculated from the workorders).

=head3 C<OTRS_CHANGEBUILDER_xxx>, C<OTRS_CHANGEMANAGER_xxx>, C<OTRS_WORKORDERAGENT_xxx>

with the subsequent values for xxx:

    UserFirstname
        Firstname of the person.
    UserLastname
        Lastname of the person.
    UserEmail
        Email address of the person.

=head3 C<OTRS_WORKORDER_xxx>

with the subsequent values for xxx:

    WorkOrderID
        ID of the workorder
    ChangeID
        ID of the change the workorder belongs to.
    WorkOrderNumber
        Workorder number
    WorkOrderTitle
        Title of the workorder
    Instruction
        See Change placeholders -> Description
    InstructionPlain
        See Change placeholders -> DescriptionPlain
    Report
        See Change placeholders -> Description
    ReportPlain
        See Change placeholders -> DescriptionPlain
    WorkOrderStateID
        ID of the workorder state.
    WorkOrderState
        Name of the workorder state.
    WorkOrderStateSignal
    WorkOrderTypeID
        ID of the workorder type.
    WorkOrderType
        The name of the work order type.
    WorkOrderAgentID
        The ID of the workorder agent.
    PlannedStartTime
        The planned start time for the workorder.
    PlannedEndTime
        The planned end time for the workorder.
    ActualStartTime
        When did the workorder actually start.
    ActualEndTime
        When did the workorder actually end.
    AccountedTime
        The so far accounted time for the single workorder
    PlannedEffort
        This is the effort planned for the single workorder.

=head3 C<OTRS_LINK_xxx>

with the subsequent values for xxx:

    Object
        other object of the link
    SourceObject
        other object of the link, when the other object is the source
    TargetObject
        other object of the link, when the other object ist the target
    State
        State of the link
    Type
        Type of the link

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (http://otrs.org/).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
