# --
# Kernel/System/ITSMChange/Notification.pm - lib for notifications in change management
# Copyright (C) 2003-2010 OTRS AG, http://otrs.com/
# --
# $Id: Notification.pm,v 1.16 2010-01-07 08:54:26 reb Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::ITSMChange::Notification;

use strict;
use warnings;

use Kernel::System::CustomerUser;
use Kernel::System::Email;
use Kernel::System::HTMLUtils;
use Kernel::System::ITSMChange;
use Kernel::System::ITSMChange::ITSMWorkOrder;
use Kernel::System::Notification;
use Kernel::System::User;
use Kernel::System::Valid;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.16 $) [1];

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
    my $NotificationObject = Kernel::System::ITSMChange::Notification->new(
        EncodeObject => $EncodeObject,
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
        MainObject   => $MainObject,
        DBObject     => $DBObject,
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for my $Object (qw(DBObject ConfigObject EncodeObject LogObject MainObject TimeObject)) {
        $Self->{$Object} = $Param{$Object} || die "Got no $Object!";
    }

    # set the debug flag
    $Self->{Debug} = $Param{Debug} || 0;

    # create additional objects
    $Self->{NotificationObject} = Kernel::System::Notification->new( %{$Self} );
    $Self->{UserObject}         = Kernel::System::User->new( %{$Self} );
    $Self->{CustomerUserObject} = Kernel::System::CustomerUser->new( %{$Self} );
    $Self->{ChangeObject}       = Kernel::System::ITSMChange->new( %{$Self} );
    $Self->{WorkOrderObject}    = Kernel::System::ITSMChange::ITSMWorkOrder->new( %{$Self} );
    $Self->{HTMLUtilsObject}    = Kernel::System::HTMLUtils->new( %{$Self} );
    $Self->{SendmailObject}     = Kernel::System::Email->new( %{$Self} );
    $Self->{ValidObject}        = Kernel::System::Valid->new( %{$Self} );

    # do we use richtext
    $Self->{RichText} = $Self->{ConfigObject}->Get('Frontend::RichText');

    return $Self;
}

=item NotificationSend()

Send the notification to customers and/or agents.

    my $Success = $NotificationObject->NotificationSend(
        AgentIDs    => [ 1, 2, 3, ]
        CustomerIDs => [ 1, 2, 3, ],
        Type        => 'Change',          # Change|WorkOrder
        Event       => 'ChangeUpdate',
        Data        => { %ChangeData },   # Change|WorkOrder data
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

    # we need to get the items for replacements
    my $Change    = {};
    my $WorkOrder = {};

    if ( $Param{Data}->{ChangeID} ) {
        $Change = $Self->{ChangeObject}->ChangeGet(
            ChangeID => $Param{Data}->{ChangeID},
            UserID   => $Param{UserID},
            LogNo    => 1,
        );
    }

    if ( $Param{Data}->{WorkOrderID} ) {
        $WorkOrder = $Self->{WorkOrderObject}->ChangeGet(
            WorkOrderID => $Param{Data}->{WorkOrderID},
            UserID      => $Param{UserID},
            LogNo       => 1,
        );
    }

    my %NotificationCache;

    for my $AgentID ( @{ $Param{AgentIDs} } ) {

        # get preferred language
        my %User = $Self->{UserObject}->GetUserData(
            UserID => $AgentID,
        );

        # get preferred language
        my $PreferredLanguage = $Self->{ConfigObject}->Get('DefaultLanguage') || 'en';
        if ( $User{UserLanguage} ) {
            $PreferredLanguage = $User{UserLanguage};
        }

        my $NotificationKey
            = $PreferredLanguage . '::Agent::' . $Param{Type} . '::' . $Param{Event};

        # get notification (cache || database)
        my $Notification = $NotificationCache{$NotificationKey};

        if ( !$Notification ) {

            # get from database
            my %NotificationData = $Self->{NotificationObject}->NotificationGet(
                Name => $NotificationKey
            );

            # no notification found
            if ( !%NotificationData ) {
                $Self->{LogObject}->Log(
                    Priority => 'error',
                    Message  => "Could not find notification for $NotificationKey",
                );

                return;
            }

            $NotificationCache{$NotificationKey} = {%NotificationData};
            $Notification = {%NotificationData};
        }

        # replace otrs macros
        $Notification->{Body} = $Self->_NotificationReplaceMacros(
            Type      => $Param{Type},
            Text      => $Notification->{Body},
            Recipient => {%User},
            RichText  => $Self->{RichText},
            UserID    => $Param{UserID},
            Change    => $Change,
            WorkOrder => $WorkOrder,
            Data      => $Param{Data},
        );

        $Notification->{Subject} = $Self->_NotificationReplaceMacros(
            Type      => $Param{Type},
            Text      => $Notification->{Subject},
            Recipient => {%User},
            UserID    => $Param{UserID},
            Change    => $Change,
            WorkOrder => $WorkOrder,
            Data      => $Param{Data},
        );

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
    }

    for my $CustomerID ( @{ $Param{CustomerIDs} } ) {

        # get preferred language
        my %CustomerUser = $Self->{CustomerUserObject}->CustomerUserDataGet(
            User => $CustomerID,
        );

        # get preferred language
        my $PreferredLanguage = $Self->{ConfigObject}->Get('DefaultLanguage') || 'en';
        if ( $CustomerUser{UserLanguage} ) {
            $PreferredLanguage = $CustomerUser{UserLanguage};
        }

        my $NotificationKey
            = $PreferredLanguage . '::Customer::' . $Param{Type} . '::' . $Param{Event};

        # get notification (cache || database)
        my $Notification = $NotificationCache{$NotificationKey};

        if ( !$Notification ) {

            # get from database
            my %NotificationData = $Self->{NotificationObject}->NotificationGet(
                Name => $NotificationKey
            );

            # no notification found
            if ( !%NotificationData ) {
                $Self->{LogObject}->Log(
                    Priority => 'error',
                    Message  => "Could not find notification for $NotificationKey",
                );

                return;
            }

            $NotificationCache{$NotificationKey} = {%NotificationData};
            $Notification = {%NotificationData};
        }

        # replace otrs macros
        $Notification->{Body} = $Self->_NotificationReplaceMacros(
            Type      => $Param{Type},
            Text      => $Notification->{Body},
            Recipient => {%CustomerUser},
            RichText  => $Self->{RichText},
            UserID    => $Param{UserID},
            Change    => $Change,
            WorkOrder => $WorkOrder,
            Data      => $Param{Data},
        );

        $Notification->{Subject} = $Self->_NotificationReplaceMacros(
            Type      => $Param{Type},
            Text      => $Notification->{Subject},
            Recipient => {%CustomerUser},
            UserID    => $Param{UserID},
            Change    => $Change,
            WorkOrder => $WorkOrder,
            Data      => $Param{Data},
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

    return 1;
}

=item NotificationRuleList()

returns an array reference with IDs of all existing notification rules

    my $List = $NotificationObject->NotificationRuleList();

returns

    [ 1, 2, 3 ]

=cut

sub NotificationRuleList {
    my ($Self) = @_;

    # do sql query
    return if !$Self->{DBObject}->Prepare(
        SQL => 'SELECT id FROM change_notification ORDER BY id',
    );

    # fetch IDs
    my @IDs;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        push @IDs, $Row[0],
    }

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

    # for now we only have a single search param
    if ( $Param{EventID} ) {
        push @SQLWhere, 'cn.event_id = ?';
        push @SQLBind,  \$Param{EventID};
    }

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
    my ($Self) = @_;

    # do SQL query
    return if !$Self->{DBObject}->Prepare(
        SQL => 'SELECT id, name FROM change_notification_grps ORDER BY name',
    );

    # fetch recipients
    my @Recipients;
    while ( my @Row = $Self->{DBObject}->FetchrowArray ) {
        my $Recipient = {
            Key   => $Row[0],
            Value => $Row[1],
        };
        push @Recipients, $Recipient;
    }

    return \@Recipients;
}

=begin Internal:

=item _NotificationReplaceMacros()

This method replaces all the <OTRS_xxxx> macros in notification text.

    my $CleanText = $NotificationObject->_NotificationReplaceMacros(
        Type      => 'Change',    # Change|WorkOrder
        Text      => 'Some <OTRS_CONFIG_FQDN> text',
        Data      => { %ChangeData },
        UserID    => 1,
        Change    => $Change,
        WorkOrder => $WorkOrder,
    );

=cut

sub _NotificationReplaceMacros {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(Type Text Data UserID Change WorkOrder)) {
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
        $Text =~ s/(\n|\r)//g;
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
        for ( keys %CurrentUser ) {
            next if !$CurrentUser{$_};
            $CurrentUser{$_} = $Self->{HTMLUtilsObject}->ToHTML(
                String => $CurrentUser{$_},
            );
        }
    }

    # replace it
    for ( keys %CurrentUser ) {
        next if !defined $CurrentUser{$_};
        $Text =~ s{ $Tag $_ $End }{$CurrentUser{$_}}gxmsi;
        $Text =~ s{ $Tag2 $_ $End }{$CurrentUser{$_}}gxmsi;
    }

    # replace other needed stuff
    $Text =~ s{ $Start OTRS_FIRST_NAME $End }{$CurrentUser{UserFirstname}}gxms;
    $Text =~ s{ $Start OTRS_LAST_NAME $End }{$CurrentUser{UserLastname}}gxms;

    # cleanup
    $Text =~ s/$Tag.+?$End/-/gi;
    $Text =~ s/$Tag2.+?$End/-/gi;

    # get and prepare realname
    $Tag = $Start . 'OTRS_CUSTOMER_REALNAME';
    $Text =~ s/$Tag$End/-/g;

    # get customer data and replace it with <OTRS_CUSTOMER_DATA_...
    $Tag  = $Start . 'OTRS_CUSTOMER_';
    $Tag2 = $Start . 'OTRS_CUSTOMER_DATA_';

    # cleanup all not needed <OTRS_CUSTOMER_DATA_ tags
    $Text =~ s/$Tag.+?$End/-/gi;
    $Text =~ s/$Tag2.+?$End/-/gi;

    # replace <OTRS_CHANGE_... tags
    $Tag = $Start . 'OTRS_CHANGE_';
    my %ChangeData = %{ $Param{Change} };

    # html quoting of content
    if ( $Param{RichText} ) {
        for ( keys %ChangeData ) {
            next if !$ChangeData{$_};
            $ChangeData{$_} = $Self->{HTMLUtilsObject}->ToHTML(
                String => $ChangeData{$_},
            );
        }
    }

    # replace it
    for ( keys %ChangeData ) {
        next if !defined $ChangeData{$_};
        $Text =~ s{ $Tag $_ $End }{$ChangeData{$_}}gxmsi;
    }

    # replace <OTRS_WORKORDER_... tags
    $Tag = $Start . 'OTRS_WORKORDER_';
    my %WorkOrderData = %{ $Param{WorkOrder} };

    # html quoting of content
    if ( $Param{RichText} ) {
        for ( keys %WorkOrderData ) {
            next if !$WorkOrderData{$_};
            $WorkOrderData{$_} = $Self->{HTMLUtilsObject}->ToHTML(
                String => $WorkOrderData{$_},
            );
        }
    }

    # replace it
    for ( keys %WorkOrderData ) {
        next if !defined $WorkOrderData{$_};
        $Text =~ s{ $Tag $_ $End }{$WorkOrderData{$_}}gxmsi;
    }

    # get recipient data and replace it with <OTRS_...
    $Tag = $Start . 'OTRS_';
    if ( $Param{Recipient} ) {

        # html quoting of content
        if ( $Param{RichText} ) {
            for ( keys %{ $Param{Recipient} } ) {
                next if !$Param{Recipient}->{$_};
                $Param{Recipient}->{$_} = $Self->{HTMLUtilsObject}->ToHTML(
                    String => $Param{Recipient}->{$_},
                );
            }
        }

        # replace it
        for ( keys %{ $Param{Recipient} } ) {
            next if !defined $Param{Recipient}->{$_};
            my $Value = $Param{Recipient}->{$_};
            $Text =~ s{ $Tag $_ $End }{$Value}gxmsi;
        }
    }

    # cleanup
    $Text =~ s{ $Tag .+? $End}{-}gxmsi;

    return $Text;
}

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

$Revision: 1.16 $ $Date: 2010-01-07 08:54:26 $

=cut
