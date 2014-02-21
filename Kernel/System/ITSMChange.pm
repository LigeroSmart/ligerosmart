# --
# Kernel/System/ITSMChange.pm - all change functions
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::ITSMChange;

use strict;
use warnings;

use Kernel::System::EventHandler;
use Kernel::System::GeneralCatalog;
use Kernel::System::LinkObject;
use Kernel::System::CustomerUser;
use Kernel::System::ITSMChange::ITSMChangeCIPAllocate;
use Kernel::System::ITSMChange::ITSMStateMachine;
use Kernel::System::ITSMChange::ITSMWorkOrder;
use Kernel::System::ITSMChange::ITSMCondition;
use Kernel::System::HTMLUtils;
use Kernel::System::VirtualFS;
use Kernel::System::Cache;

use vars qw(@ISA);

@ISA = (
    'Kernel::System::EventHandler',
);

=head1 NAME

Kernel::System::ITSMChange - change lib

=head1 SYNOPSIS

All functions for changes in ITSMChangeManagement.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create an object

    use Kernel::Config;
    use Kernel::System::Encode;
    use Kernel::System::Log;
    use Kernel::System::DB;
    use Kernel::System::Main;
    use Kernel::System::Time;
    use Kernel::System::ITSMChange;

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
    my $TimeObject = Kernel::System::Time->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
    );
    my $DBObject = Kernel::System::DB->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
        MainObject   => $MainObject,
    );
    my $ChangeObject = Kernel::System::ITSMChange->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
        DBObject     => $DBObject,
        TimeObject   => $TimeObject,
        MainObject   => $MainObject,
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
    $Self->{CacheObject}          = Kernel::System::Cache->new( %{$Self} );
    $Self->{GeneralCatalogObject} = Kernel::System::GeneralCatalog->new( %{$Self} );
    $Self->{LinkObject}           = Kernel::System::LinkObject->new( %{$Self} );
    $Self->{CustomerUserObject}   = Kernel::System::CustomerUser->new( %{$Self} );
    $Self->{HTMLUtilsObject}      = Kernel::System::HTMLUtils->new( %{$Self} );
    $Self->{StateMachineObject}   = Kernel::System::ITSMChange::ITSMStateMachine->new( %{$Self} );
    $Self->{VirtualFSObject}      = Kernel::System::VirtualFS->new( %{$Self} );
    $Self->{WorkOrderObject}      = Kernel::System::ITSMChange::ITSMWorkOrder->new( %{$Self} );
    $Self->{ConditionObject}      = Kernel::System::ITSMChange::ITSMCondition->new( %{$Self} );
    $Self->{CIPAllocateObject}    = Kernel::System::ITSMChange::ITSMChangeCIPAllocate->new(
        %{$Self},
    );

    # load change number generator
    my $GeneratorModule = $Self->{ConfigObject}->Get('ITSMChange::NumberGenerator')
        || 'Kernel::System::ITSMChange::Number::DateChecksum';
    if ( !$Self->{MainObject}->RequireBaseClass($GeneratorModule) ) {
        die "Can't load change number generator backend module $GeneratorModule! $@";
    }

    # get the cache TTL (in seconds)
    $Self->{CacheTTL} = $Self->{ConfigObject}->Get('ITSMChange::CacheTTL') * 60;

    # init of event handler
    $Self->EventHandlerInit(
        Config     => 'ITSMChange::EventModule',
        BaseObject => 'ChangeObject',
        Objects    => {
            %{$Self},
        },
    );

    # get database type
    $Self->{DBType} = $Self->{DBObject}->{'DB::Type'} || '';
    $Self->{DBType} = lc $Self->{DBType};

    return $Self;
}

=item ChangeAdd()

Add a new change. The UserId is the only required parameter.
Internally first a minimal change is created, then ChangeUpdate() is called.

    my $ChangeID = $ChangeObject->ChangeAdd(
        UserID => 1,
    );

or

    my $ChangeID = $ChangeObject->ChangeAdd(
        ChangeTitle     => 'Replacement of mail server',       # (optional)
        Description     => 'New mail server is faster',        # (optional)
        Justification   => 'Old mail server too slow',         # (optional)
        ChangeStateID   => 4,                                  # (optional) or ChangeState => 'accepted'
        ChangeState     => 'accepted',                         # (optional) or ChangeStateID => 4
        ChangeManagerID => 5,                                  # (optional)
        ChangeBuilderID => 6,                                  # (optional)
        CategoryID      => 7,                                  # (optional) or Category => '3 normal'
        Category        => '3 normal',                         # (optional) or CategoryID => 4
        ImpactID        => 8,                                  # (optional) or Impact => '4 high'
        Impact          => '4 high',                           # (optional) or ImpactID => 5
        PriorityID      => 9,                                  # (optional) or Priority => '5 very high'
        Priority        => '5 very high',                      # (optional) or PriorityID => 6
        CABAgents       => [ 1, 2, 4 ],     # UserIDs          # (optional)
        CABCustomers    => [ 'tt', 'mm' ],  # CustomerUserIDs  # (optional)
        RequestedTime   => '2006-01-19 23:59:59',              # (optional)
        ChangeFreeKey1  => 'Sun',                              # (optional) change freekey fields from 1 to ITSMChange::FreeText::MaxNumber
        ChangeFreeText1 => 'Earth',                            # (optional) change freetext fields from 1 to ITSMChange::FreeText::MaxNumber
        UserID          => 1,
    );

=cut

sub ChangeAdd {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{UserID} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need UserID!',
        );
        return;
    }

    # get a plain text version of arguments which might contain HTML markup
    ARGUMENT:
    for my $Argument (qw(Description Justification)) {

        next ARGUMENT if !exists $Param{$Argument};

        $Param{"${Argument}Plain"} = $Self->{HTMLUtilsObject}->ToAscii(
            String => $Param{$Argument},
        );

        # Even when passed a plain ASCII string,
        # ToAscii() can return a non-utf8 string with chars in the extended range.
        # Upgrade to utf-8 in order to comply to the OTRS-convention.
        if ( $Self->{EncodeObject}->CharsetInternal() ) {
            utf8::upgrade( $Param{"${Argument}Plain"} );
        }
    }

    # check the parameters
    return if !$Self->_CheckChangeParams(%Param);

    # trigger ChangeAddPre-Event
    $Self->EventHandler(
        Event => 'ChangeAddPre',
        Data  => {
            %Param,
        },
        UserID => $Param{UserID},
    );

    # create a new change number
    my $ChangeNumber = $Self->ChangeNumberCreate();

    # get initial change state id
    my $ChangeStateID = delete $Param{ChangeStateID};
    if ( !$ChangeStateID ) {
        my $NextStateIDs = $Self->{StateMachineObject}->StateTransitionGet(
            StateID => 0,
            Class   => 'ITSM::ChangeManagement::Change::State',
        );
        $ChangeStateID = $NextStateIDs->[0];
    }

    # get default Category if not defined
    my $CategoryID = delete $Param{CategoryID};
    if ( !$CategoryID ) {
        my $DefaultCategory = $Self->{ConfigObject}->Get('ITSMChange::Category::Default');
        $CategoryID = $Self->ChangeCIPLookup(
            CIP  => $DefaultCategory,
            Type => 'Category',
        );
    }

    # get default Impact if not defined
    my $ImpactID = delete $Param{ImpactID};
    if ( !$ImpactID ) {
        my $DefaultImpact = $Self->{ConfigObject}->Get('ITSMChange::Impact::Default');
        $ImpactID = $Self->ChangeCIPLookup(
            CIP  => $DefaultImpact,
            Type => 'Impact',
        );
    }

    # get default Priority if not defined
    my $PriorityID = delete $Param{PriorityID};
    if ( !$PriorityID ) {
        $PriorityID = $Self->{CIPAllocateObject}->PriorityAllocationGet(
            CategoryID => $CategoryID,
            ImpactID   => $ImpactID,
        );
    }

    # if no change builder id was given, take the user id
    my $ChangeBuilderID = $Param{ChangeBuilderID} || $Param{UserID};

    # add change to database
    return if !$Self->{DBObject}->Do(
        SQL => 'INSERT INTO change_item '
            . '(change_number, change_state_id, change_builder_id, '
            . 'category_id, impact_id, priority_id, '
            . 'create_time, create_by, change_time, change_by) '
            . 'VALUES (?, ?, ?, ?, ?, ?, current_timestamp, ?, current_timestamp, ?)',
        Bind => [
            \$ChangeNumber, \$ChangeStateID, \$ChangeBuilderID,
            \$CategoryID,   \$ImpactID,      \$PriorityID,
            \$Param{UserID}, \$Param{UserID},
        ],
    );

    # get change id
    my $ChangeID = $Self->ChangeLookup(
        ChangeNumber => $ChangeNumber,
    );

    return if !$ChangeID;

    # delete cache
    for my $Key (
        'ChangeGet::ID::' . $ChangeID,
        'ChangeList',
        'ChangeLookup::ChangeID::' . $ChangeID,
        'ChangeLookup::ChangeNumber::' . $ChangeNumber,
        )
    {

        $Self->{CacheObject}->Delete(
            Type => 'ITSMChangeManagement',
            Key  => $Key,
        );
    }

    # trigger ChangeAddPost-Event
    # (yes, we want do do this before the ChangeUpdate!)
    # override the actually passed change state with the initial change state
    $Self->EventHandler(
        Event => 'ChangeAddPost',
        Data  => {
            %Param,
            ChangeID      => $ChangeID,
            CategoryID    => $CategoryID,
            ImpactID      => $ImpactID,
            PriorityID    => $PriorityID,
            ChangeStateID => $ChangeStateID,
            ChangeNumber  => $ChangeNumber,
        },
        UserID => $Param{UserID},
    );

    # update change with remaining parameters
    # the already handles params have been deleted from %Param
    my $UpdateSuccess = $Self->ChangeUpdate(
        %Param,
        ChangeID => $ChangeID,
    );

    # check update error
    if ( !$UpdateSuccess ) {

        # delete change if it could not be updated
        $Self->ChangeDelete(
            ChangeID => $ChangeID,
            UserID   => $Param{UserID},
        );

        return;
    }

    return $ChangeID;
}

=item ChangeUpdate()

Update a change.
Leading and trailing whitespace is removed from C<ChangeTitle>.
Passing undefined values is generally not allowed.
An exception is the parameter C<RequestedTime>, where the undefined value
indicates that requested time of the change should be cleared.

    my $Success = $ChangeObject->ChangeUpdate(
        ChangeID           => 123,
        ChangeTitle        => 'Replacement of slow mail server',  # (optional)
        Description        => 'New mail server is faster',        # (optional)
        Justification      => 'Old mail server too slow',         # (optional)
        ChangeStateID      => 4,                                  # (optional) or ChangeState => 'accepted'
        ChangeState        => 'accepted',                         # (optional) or ChangeStateID => 4
        ChangeManagerID    => 5,                                  # (optional)
        ChangeBuilderID    => 6,                                  # (optional)
        CategoryID         => 7,                                  # (optional) or Category => '3 normal'
        Category           => '3 normal',                         # (optional) or CategoryID => 4
        ImpactID           => 8,                                  # (optional) or Impact => '4 high'
        Impact             => '4 high',                           # (optional) or ImpactID => 5
        PriorityID         => 9,                                  # (optional) or Priority => '5 very high'
        Priority           => '5 very high',                      # (optional) or PriorityID => 6
        CABAgents          => [ 1, 2, 4 ],                        # (optional) UserIDs
        CABCustomers       => [ 'tt', 'mm' ],                     # (optional) CustomerUserIDs
        RequestedTime      => '2006-01-19 23:59:59',              # (optional) or 'undef', which clears the time
        ChangeFreeKey1     => 'Sun',                              # (optional) change freekey fields from 1 to ITSMChange::FreeText::MaxNumber
        ChangeFreeText1    => 'Earth',                            # (optional) change freetext fields from 1 to ITSMChange::FreeText::MaxNumber
        BypassStateMachine => 1,                                  # (optional) default 0, if 1 the state machine will be bypassed
        UserID             => 1,
    );

=cut

sub ChangeUpdate {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(ChangeID UserID )) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # check that not both ChangeState and ChangeStateID are given
    if ( $Param{ChangeState} && $Param{ChangeStateID} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need either ChangeState OR ChangeStateID - not both!',
        );
        return;
    }

    # when the State is given, then look up the ID
    if ( $Param{ChangeState} ) {
        $Param{ChangeStateID} = $Self->ChangeStateLookup(
            ChangeState => $Param{ChangeState},
        );
    }

    # when CIP is given, then look up the ID
    for my $Type (qw(Category Impact Priority)) {
        if ( $Param{$Type} ) {
            $Param{"${Type}ID"} = $Self->ChangeCIPLookup(
                CIP  => $Param{$Type},
                Type => $Type,
            );
        }
    }

    # normalize the Title, when it is given
    if ( $Param{ChangeTitle} && !ref $Param{ChangeTitle} ) {

        # remove leading whitespace
        $Param{ChangeTitle} =~ s{ \A \s+ }{}xms;

        # remove trailing whitespace
        $Param{ChangeTitle} =~ s{ \s+ \z }{}xms;
    }

    # get a plain text version of arguments which might contain HTML markup
    ARGUMENT:
    for my $Argument (qw(Description Justification)) {

        next ARGUMENT if !exists $Param{$Argument};

        $Param{"${Argument}Plain"} = $Self->{HTMLUtilsObject}->ToAscii(
            String => $Param{$Argument},
        );

        # Even when passed a plain ASCII string,
        # ToAscii() can return a non-utf8 string with chars in the extended range.
        # Upgrade to utf-8 in order to comply to the OTRS-convention.
        if ( $Self->{EncodeObject}->CharsetInternal() ) {
            utf8::upgrade( $Param{"${Argument}Plain"} );
        }
    }

    # check the given parameters
    return if !$Self->_CheckChangeParams(%Param);

    # check sanity of the new state with the state machine
    if ( $Param{ChangeStateID} ) {

        # get change id
        my $ChangeID = $Param{ChangeID};

        # do not give ChangePossibleStatesGet() the ChangeID
        # if the statemachine should be bypassed.
        # ChangePossibleStatesGet() will then return all change states.
        if ( $Param{BypassStateMachine} ) {
            $ChangeID = undef;
        }

        # get the list of possible next states
        my $StateList = $Self->ChangePossibleStatesGet(
            ChangeID => $ChangeID,
            UserID   => $Param{UserID},
        );
        if ( !grep { $_->{Key} == $Param{ChangeStateID} } @{$StateList} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "The state $Param{ChangeStateID} is not a possible next state!",
            );
            return;
        }
    }

    # trigger ChangeUpdatePre-Event
    $Self->EventHandler(
        Event => 'ChangeUpdatePre',
        Data  => {
            %Param,
        },
        UserID => $Param{UserID},
    );

    # get old data to be given to post event handler
    my $ChangeData = $Self->ChangeGet(
        ChangeID => $Param{ChangeID},
        UserID   => $Param{UserID},
    );

    # update CAB
    if ( exists $Param{CABAgents} || exists $Param{CABCustomers} ) {
        return if !$Self->ChangeCABUpdate(%Param);
    }

    # update change freekey and freetext fields
    return if !$Self->_ChangeFreeTextUpdate(%Param);

    # map update attributes to column names
    my %Attribute = (
        ChangeTitle        => 'title',
        Description        => 'description',
        Justification      => 'justification',
        ChangeStateID      => 'change_state_id',
        ChangeManagerID    => 'change_manager_id',
        ChangeBuilderID    => 'change_builder_id',
        CategoryID         => 'category_id',
        ImpactID           => 'impact_id',
        PriorityID         => 'priority_id',
        RequestedTime      => 'requested_time',
        DescriptionPlain   => 'description_plain',
        JustificationPlain => 'justification_plain',
    );

    # build SQL to update change
    my $SQL = 'UPDATE change_item SET ';
    my @Bind;

    ATTRIBUTE:
    for my $Attribute ( sort keys %Attribute ) {

        # preserve the old value, when the column isn't in function parameters
        next ATTRIBUTE if !exists $Param{$Attribute};

        # param checking has already been done, so this is safe
        $SQL .= "$Attribute{$Attribute} = ?, ";
        push @Bind, \$Param{$Attribute};
    }

    $SQL .= 'change_time = current_timestamp, change_by = ? ';
    push @Bind, \$Param{UserID};
    $SQL .= 'WHERE id = ?';
    push @Bind, \$Param{ChangeID};

    # update change
    return if !$Self->{DBObject}->Do(
        SQL  => $SQL,
        Bind => \@Bind,
    );

    # delete cache
    for my $Key (
        'ChangeGet::ID::' . $Param{ChangeID},
        'ChangeList',
        'ChangeLookup::ChangeID::' . $Param{ChangeID},
        'ChangeLookup::ChangeNumber::' . $ChangeData->{ChangeNumber},
        )
    {

        $Self->{CacheObject}->Delete(
            Type => 'ITSMChangeManagement',
            Key  => $Key,
        );
    }

    # trigger ChangeUpdatePost-Event
    $Self->EventHandler(
        Event => 'ChangeUpdatePost',
        Data  => {
            OldChangeData => $ChangeData,
            %Param,
        },
        UserID => $Param{UserID},
    );

    return 1;
}

=item ChangeGet()

Return a change as a hash reference.
When the workorder does not exist, a false value is returned.
The optional option C<LogNo> turns off logging when the change does not exist.

    my $Change = $ChangeObject->ChangeGet(
        ChangeID => 123,
        UserID   => 1,
        LogNo    => 1,      # optional, turns off logging when the change does not exist
    );

The returned hash reference contains the following elements:

    $Change{ChangeID}
    $Change{ChangeNumber}
    $Change{ChangeStateID}
    $Change{ChangeState}            # fetched from the general catalog
    $Change{ChangeStateSignal}      # fetched from SysConfig
    $Change{ChangeTitle}
    $Change{Description}
    $Change{DescriptionPlain}
    $Change{Justification}
    $Change{JustificationPlain}
    $Change{ChangeManagerID}
    $Change{ChangeBuilderID}
    $Change{CategoryID}
    $Change{Category}
    $Change{ImpactID}
    $Change{Impact}
    $Change{PriorityID}
    $Change{Priority}
    $Change{WorkOrderIDs}           # array reference with WorkOrderIDs, sorted by WorkOrderNumber
    $Change{WorkOrderCount}         # number of workorders
    $Change{CABAgents}              # array reference with CAB Agent UserIDs
    $Change{CABCustomers}           # array reference with CAB CustomerUserIDs
    $Change{PlannedStartTime}       # determined from the workorders
    $Change{PlannedEndTime}         # determined from the workorders
    $Change{ActualStartTime}        # determined from the workorders
    $Change{ActualEndTime}          # determined from the workorders
    $Change{PlannedEffort}          # determined from the workorders
    $Change{AccountedTime}          # determined from the workorders
    $Change{RequestedTime}
    $Change{ChangeFreeKey1}         # change freekey fields from 1 to ITSMChange::FreeText::MaxNumber
    $Change{ChangeFreeText1}        # change freetext fields from 1 to ITSMChange::FreeText::MaxNumber
    $Change{CreateTime}
    $Change{CreateBy}
    $Change{ChangeTime}
    $Change{ChangeBy}

=cut

sub ChangeGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Attribute (qw(ChangeID UserID)) {
        if ( !$Param{$Attribute} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Attribute!",
            );
            return;
        }
    }

    # check cache
    my $CacheKey = 'ChangeGet::ID::' . $Param{ChangeID};
    my $Cache    = $Self->{CacheObject}->Get(
        Type => 'ITSMChangeManagement',
        Key  => $CacheKey,
    );

    my %ChangeData;

    if ($Cache) {
        %ChangeData = %{$Cache};
    }
    else {

        # get data from database
        return if !$Self->{DBObject}->Prepare(
            SQL => 'SELECT id, change_number, title, '
                . 'description, description_plain, '
                . 'justification, justification_plain, '
                . 'change_state_id, change_manager_id, change_builder_id, '
                . 'category_id, impact_id, priority_id, '
                . 'create_time, create_by, change_time, change_by, '
                . 'requested_time '
                . 'FROM change_item '
                . 'WHERE id = ? ',
            Bind  => [ \$Param{ChangeID} ],
            Limit => 1,
        );

        # fetch the result
        while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
            $ChangeData{ChangeID}           = $Row[0];
            $ChangeData{ChangeNumber}       = $Row[1];
            $ChangeData{ChangeTitle}        = defined( $Row[2] ) ? $Row[2] : '';
            $ChangeData{Description}        = defined( $Row[3] ) ? $Row[3] : '';
            $ChangeData{DescriptionPlain}   = defined( $Row[4] ) ? $Row[4] : '';
            $ChangeData{Justification}      = defined( $Row[5] ) ? $Row[5] : '';
            $ChangeData{JustificationPlain} = defined( $Row[6] ) ? $Row[6] : '';
            $ChangeData{ChangeStateID}      = $Row[7];
            $ChangeData{ChangeManagerID}    = $Row[8];
            $ChangeData{ChangeBuilderID}    = $Row[9];
            $ChangeData{CategoryID}         = $Row[10];
            $ChangeData{ImpactID}           = $Row[11];
            $ChangeData{PriorityID}         = $Row[12];
            $ChangeData{CreateTime}         = $Row[13];
            $ChangeData{CreateBy}           = $Row[14];
            $ChangeData{ChangeTime}         = $Row[15];
            $ChangeData{ChangeBy}           = $Row[16];
            $ChangeData{RequestedTime}      = $Row[17];
        }

        # check error
        if ( !%ChangeData ) {
            if ( !$Param{LogNo} ) {
                $Self->{LogObject}->Log(
                    Priority => 'error',
                    Message  => "Change with ID $Param{ChangeID} does not exist.",
                );
            }
            return;
        }

        # cleanup time stamps (some databases are using e. g. 2008-02-25 22:03:00.000000)
        TIMEFIELD:
        for my $Timefield ( 'CreateTime', 'ChangeTime', 'RequestedTime' ) {
            next TIMEFIELD if !$ChangeData{$Timefield};
            $ChangeData{$Timefield}
                =~ s{ \A ( \d\d\d\d - \d\d - \d\d \s \d\d:\d\d:\d\d ) \. .+? \z }{$1}xms;
        }

        # get change freekey and freetext data
        my $ChangeFreeText = $Self->_ChangeFreeTextGet(
            ChangeID => $Param{ChangeID},
            UserID   => $Param{UserID},
        );

        # add result to change data
        %ChangeData = ( %ChangeData, %{$ChangeFreeText} );

        # set cache (change data exists at this point, it was checked before)
        $Self->{CacheObject}->Set(
            Type  => 'ITSMChangeManagement',
            Key   => $CacheKey,
            Value => \%ChangeData,
            TTL   => $Self->{CacheTTL},
        );
    }

    # set name of change state
    if ( $ChangeData{ChangeStateID} ) {
        $ChangeData{ChangeState} = $Self->ChangeStateLookup(
            ChangeStateID => $ChangeData{ChangeStateID},
        );
    }

    # set names for CIP
    for my $Type (qw(Category Impact Priority)) {
        if ( $ChangeData{"${Type}ID"} ) {
            $ChangeData{$Type} = $Self->ChangeCIPLookup(
                ID   => $ChangeData{"${Type}ID"},
                Type => $Type,
            );
        }
    }

    # set the change state signal
    if ( $ChangeData{ChangeState} ) {

        # get all change state signals
        my $StateSignal = $Self->{ConfigObject}->Get('ITSMChange::State::Signal');

        $ChangeData{ChangeStateSignal} = $StateSignal->{ $ChangeData{ChangeState} };
    }

    # get CAB data
    my $CAB = $Self->ChangeCABGet(
        ChangeID => $Param{ChangeID},
        UserID   => $Param{UserID},
    ) || {};

    # add result to change data
    %ChangeData = ( %ChangeData, %{$CAB} );

    # get all workorder ids for this change
    my $WorkOrderIDsRef = $Self->{WorkOrderObject}->WorkOrderList(
        ChangeID => $Param{ChangeID},
        UserID   => $Param{UserID},
    );

    # add result to change data
    $ChangeData{WorkOrderIDs} = $WorkOrderIDsRef || [];
    $ChangeData{WorkOrderCount} = scalar @{ $ChangeData{WorkOrderIDs} };

    # get planned effort and accounted time for the change
    my $ChangeEfforts = $Self->{WorkOrderObject}->WorkOrderChangeEffortsGet(
        ChangeID => $Param{ChangeID},
        UserID   => $Param{UserID},
    );

    # merge effort hash with change hash
    if (
        $ChangeEfforts
        && ref $ChangeEfforts eq 'HASH'
        && %{$ChangeEfforts}
        )
    {
        %ChangeData = ( %ChangeData, %{$ChangeEfforts} );
    }

    # get timestamps for the change
    my $ChangeTime = $Self->{WorkOrderObject}->WorkOrderChangeTimeGet(
        ChangeID => $Param{ChangeID},
        UserID   => $Param{UserID},
    );

    # merge time hash with change hash
    if (
        $ChangeTime
        && ref $ChangeTime eq 'HASH'
        && %{$ChangeTime}
        )
    {
        %ChangeData = ( %ChangeData, %{$ChangeTime} );
    }

    return \%ChangeData;
}

=item ChangeCABUpdate()

Add or update the CAB of a change.
One or both of CABAgents and CABCustomers must be passed.
Passing a reference to an empty array deletes the part of the CAB (CABAgents or CABCustomers)
When agents or customers are passed multiple times, they will be inserted only once.

    my $Success = $ChangeObject->ChangeCABUpdate(
        ChangeID     => 123,
        CABAgents    => [ 1, 2, 4 ],     # UserIDs          (optional)
        CABCustomers => [ 'tt', 'mm' ],  # CustomerUserIDs  (optional)
        UserID       => 1,
    );

=cut

sub ChangeCABUpdate {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Attribute (qw(ChangeID UserID)) {
        if ( !$Param{$Attribute} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Attribute!",
            );
            return;
        }
    }

    # either CABAgents of CABCustomers or both must be passed
    if ( !$Param{CABAgents} && !$Param{CABCustomers} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need parameter CABAgents or CABCustomers!',
        );
        return;
    }

    # CABAgents and CABCustomers must be array references
    for my $Attribute (qw(CABAgents CABCustomers)) {
        if ( $Param{$Attribute} && ref $Param{$Attribute} ne 'ARRAY' ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "The parameter $Attribute is not an array reference!",
            );
            return;
        }
    }

    # check if CABAgents and CABCustomers exist in the agents and customer databases
    return if !$Self->_CheckChangeParams(%Param);

    # trigger ChangeCABUpdatePre-Event
    $Self->EventHandler(
        Event => 'ChangeCABUpdatePre',
        Data  => {
            %Param,
        },
        UserID => $Param{UserID},
    );

    # get old CAB data to be given to post event handler
    my $ChangeCABData = $Self->ChangeCABGet(
        ChangeID => $Param{ChangeID},
        UserID   => $Param{UserID},
    );

    # enter the CAB Agents
    if ( $Param{CABAgents} ) {

        # remove all current users from cab table
        return if !$Self->{DBObject}->Do(
            SQL => 'DELETE FROM change_cab '
                . 'WHERE change_id = ? '
                . 'AND user_id IS NOT NULL',
            Bind => [ \$Param{ChangeID} ],
        );

        # filter out unique users
        my %UniqueUsers = map { $_ => 1 } @{ $Param{CABAgents} };

        # add user to cab table
        for my $UserID ( sort keys %UniqueUsers ) {
            return if !$Self->{DBObject}->Do(
                SQL => 'INSERT INTO change_cab ( change_id, user_id ) VALUES ( ?, ? )',
                Bind => [ \$Param{ChangeID}, \$UserID ],
            );
        }
    }

    # enter the CAB Customers
    if ( $Param{CABCustomers} ) {

        # remove all current customer users from cab table
        return if !$Self->{DBObject}->Do(
            SQL => 'DELETE FROM change_cab '
                . 'WHERE change_id = ? '
                . 'AND customer_user_id IS NOT NULL',
            Bind => [ \$Param{ChangeID} ],
        );

        # filter out unique customer users
        my %UniqueCustomerUsers = map { $_ => 1 } @{ $Param{CABCustomers} };

        # add user to cab table
        for my $CustomerUserID ( sort keys %UniqueCustomerUsers ) {
            return if !$Self->{DBObject}->Do(
                SQL => 'INSERT INTO change_cab ( change_id, customer_user_id ) VALUES ( ?, ? )',
                Bind => [ \$Param{ChangeID}, \$CustomerUserID ],
            );
        }
    }

    # delete cache
    $Self->{CacheObject}->Delete(
        Type => 'ITSMChangeManagement',
        Key  => 'ChangeCABGet::ID::' . $Param{ChangeID},
    );

    # trigger ChangeCABUpdatePost-Event
    $Self->EventHandler(
        Event => 'ChangeCABUpdatePost',
        Data  => {
            OldChangeCABData => $ChangeCABData,
            %Param,
        },
        UserID => $Param{UserID},
    );

    return 1;
}

=item ChangeCABGet()

Return the CAB of a change as a hashref, where the values are arrayrefs.
The returned array references are sorted.

    my $ChangeCAB = $ChangeObject->ChangeCABGet(
        ChangeID => 123,
        UserID   => 1,
    );

Returns:

    $ChangeCAB = {
        CABAgents    => [ 1, 2, 4 ],
        CABCustomers => [ 'aa', 'bb' ],
    }

=cut

sub ChangeCABGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(ChangeID UserID)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # cab data
    my %CAB = (
        CABAgents    => [],
        CABCustomers => [],
    );

    # check cache
    my $CacheKey = 'ChangeCABGet::ID::' . $Param{ChangeID};
    my $Cache    = $Self->{CacheObject}->Get(
        Type => 'ITSMChangeManagement',
        Key  => $CacheKey,
    );

    if ($Cache) {

        # get data from cache
        %CAB = %{$Cache};
    }

    else {

        # get data
        return if !$Self->{DBObject}->Prepare(
            SQL => 'SELECT id, change_id, user_id, customer_user_id '
                . 'FROM change_cab WHERE change_id = ?',
            Bind => [ \$Param{ChangeID} ],
        );

        my $ErrorCABID;

        ROW:
        while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
            my $CABID          = $Row[0];
            my $ChangeID       = $Row[1];
            my $UserID         = $Row[2];
            my $CustomerUserID = $Row[3];

            # error check if both columns are filled
            if ( $UserID && $CustomerUserID ) {
                $ErrorCABID = $CABID;
                next ROW;
            }

            # add data to CAB
            if ($UserID) {
                push @{ $CAB{CABAgents} }, $UserID;
            }
            elsif ($CustomerUserID) {
                push @{ $CAB{CABCustomers} }, $CustomerUserID;
            }
        }

        # error check if both columns are filled
        if ($ErrorCABID) {

            $Self->{LogObject}->Log(
                Priority => 'error',
                Message =>
                    "CAB table entry with ID $ErrorCABID contains UserID and CustomerUserID! "
                    . 'Only one at a time is allowed!',
            );
            return;
        }

        # sort the results
        @{ $CAB{CABAgents} }    = sort @{ $CAB{CABAgents} };
        @{ $CAB{CABCustomers} } = sort @{ $CAB{CABCustomers} };

        # set cache
        $Self->{CacheObject}->Set(
            Type  => 'ITSMChangeManagement',
            Key   => $CacheKey,
            Value => \%CAB,
            TTL   => $Self->{CacheTTL},
        );
    }

    return \%CAB;
}

=item ChangeCABDelete()

Delete the CAB of a change.

    my $Success = $ChangeObject->ChangeCABDelete(
        ChangeID => 123,
        UserID   => 1,
    );

=cut

sub ChangeCABDelete {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Attribute (qw(ChangeID UserID)) {
        if ( !$Param{$Attribute} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Attribute!",
            );
            return;
        }
    }

    # trigger ChangeCABDeletePre-Event
    $Self->EventHandler(
        Event => 'ChangeCABDeletePre',
        Data  => {
            %Param,
        },
        UserID => $Param{UserID},
    );

    # get old CAB data to be given to post event handler
    my $ChangeCABData = $Self->ChangeCABGet(
        ChangeID => $Param{ChangeID},
        UserID   => $Param{UserID},
    );

    # delete CAB
    return if !$Self->{DBObject}->Do(
        SQL  => 'DELETE FROM change_cab WHERE change_id = ?',
        Bind => [ \$Param{ChangeID} ],
    );

    # delete cache
    $Self->{CacheObject}->Delete(
        Type => 'ITSMChangeManagement',
        Key  => 'ChangeCABGet::ID::' . $Param{ChangeID},
    );

    # trigger ChangeCABDeletePost-Event
    $Self->EventHandler(
        Event => 'ChangeCABDeletePost',
        Data  => {
            OldChangeCABData => $ChangeCABData,
            %Param,
        },
        UserID => $Param{UserID},
    );

    return 1;
}

=item ChangeLookup()

Return the change id when the change number is passed.
Return the change number when the change id is passed.
When no change id or change number is found, then the undefined value is returned.

    my $ChangeID = $ChangeObject->ChangeLookup(
        ChangeNumber => '2009091742000465',
    );

    my $ChangeNumber = $ChangeObject->ChangeLookup(
        ChangeID => 42,
    );

=cut

sub ChangeLookup {
    my ( $Self, %Param ) = @_;

    # the change id or the change number must be passed
    if ( !$Param{ChangeID} && !$Param{ChangeNumber} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need the ChangeID or the ChangeNumber!',
        );
        return;
    }

    # only one of change id and change number can be passed
    if ( $Param{ChangeID} && $Param{ChangeNumber} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need either the ChangeID or the ChangeNumber, not both!',
        );
        return;
    }

    # get change id
    if ( $Param{ChangeNumber} ) {

        my $ChangeID;

        # check cache
        my $CacheKey = 'ChangeLookup::ChangeNumber::' . $Param{ChangeNumber};
        my $Cache    = $Self->{CacheObject}->Get(
            Type => 'ITSMChangeManagement',
            Key  => $CacheKey,
        );

        if ($Cache) {

            # get data from cache
            $ChangeID = $Cache;
        }

        else {
            return if !$Self->{DBObject}->Prepare(
                SQL   => 'SELECT id FROM change_item WHERE change_number = ?',
                Bind  => [ \$Param{ChangeNumber} ],
                Limit => 1,
            );

            while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
                $ChangeID = $Row[0];
            }

            # set cache only if change id exists
            if ($ChangeID) {

                # set cache
                $Self->{CacheObject}->Set(
                    Type  => 'ITSMChangeManagement',
                    Key   => $CacheKey,
                    Value => $ChangeID,
                    TTL   => $Self->{CacheTTL},
                );
            }
        }

        return $ChangeID;
    }

    # get change number
    elsif ( $Param{ChangeID} ) {

        my $ChangeNumber;

        # check cache
        my $CacheKey = 'ChangeLookup::ChangeID::' . $Param{ChangeID};
        my $Cache    = $Self->{CacheObject}->Get(
            Type => 'ITSMChangeManagement',
            Key  => $CacheKey,
        );

        if ($Cache) {

            # get data from cache
            $ChangeNumber = $Cache;
        }

        else {
            return if !$Self->{DBObject}->Prepare(
                SQL   => 'SELECT change_number FROM change_item WHERE id = ?',
                Bind  => [ \$Param{ChangeID} ],
                Limit => 1,
            );

            while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
                $ChangeNumber = $Row[0];
            }

            # set cache only if change number exists
            if ($ChangeNumber) {

                # set cache
                $Self->{CacheObject}->Set(
                    Type  => 'ITSMChangeManagement',
                    Key   => $CacheKey,
                    Value => $ChangeNumber,
                    TTL   => $Self->{CacheTTL},
                );
            }
        }

        return $ChangeNumber;
    }

    return;
}

=item ChangeList()

Return a change id list of all changes as an array reference.

    my $ChangeIDsRef = $ChangeObject->ChangeList(
        UserID => 1,
    );

=cut

sub ChangeList {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{UserID} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need UserID!',
        );
        return;
    }
    my @ChangeIDs;

    # check cache
    my $CacheKey = 'ChangeList';
    my $Cache    = $Self->{CacheObject}->Get(
        Type => 'ITSMChangeManagement',
        Key  => $CacheKey,
    );

    if ($Cache) {

        # get change ids from cache
        @ChangeIDs = @{$Cache};
    }

    else {

        # get change ids
        return if !$Self->{DBObject}->Prepare(
            SQL => 'SELECT id FROM change_item',
        );

        while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
            push @ChangeIDs, $Row[0];
        }

        # set cache
        $Self->{CacheObject}->Set(
            Type  => 'ITSMChangeManagement',
            Key   => $CacheKey,
            Value => \@ChangeIDs,
            TTL   => $Self->{CacheTTL},
        );
    }

    return \@ChangeIDs;
}

=item ChangeSearch()

Returns either a list, as an arrayref, or a count of found change ids.
The count of results is returned when the parameter C<Result = 'COUNT'> is passed.

The search criteria are logically AND connected.
When a list is passed as criterium, the individual members are OR connected.
When an undef or a reference to an empty array is passed, then the search criterium
is ignored.

    my $ChangeIDsRef = $ChangeObject->ChangeSearch(
        ChangeNumber       => '2009100112345778',                       # (optional)

        ChangeTitle        => 'Replacement of slow mail server',        # (optional)
        Description        => 'New mail server is faster',              # (optional)
        Justification      => 'Old mail server too slow',               # (optional)

        # array parameters are used with logical OR operator
        ChangeStateIDs     => [ 11, 12, 13 ],                           # (optional)
        ChangeStates       => [ 'requested', 'failed' ],                # (optional)
        ChangeManagerIDs   => [ 1, 2, 3 ],                              # (optional)
        ChangeBuilderIDs   => [ 5, 7, 4 ],                              # (optional)
        CreateBy           => [ 5, 2, 3 ],                              # (optional)
        ChangeBy           => [ 3, 2, 1 ],                              # (optional)
        WorkOrderAgentIDs  => [ 6, 2 ],                                 # (optional)
        CABAgents          => [ 9, 13 ],                                # (optional)
        CABCustomers       => [ 'tt', 'xx' ],                           # (optional)
        Categories         => [ '1 very low', '2 low' ],                # (optional)
        CategoryIDs        => [ 135, 173 ],                             # (optional)
        Impacts            => [ '1 very low', '2 low' ],                # (optional)
        ImpactIDs          => [ 136, 174 ],                             # (optional)
        Priorities         => [ '1 very low', '2 low' ],                # (optional)
        PriorityIDs        => [ 137, 175 ],                             # (optional)

        # search in change freetext and freekey fields
        ChangeFreeKey1     => 'Sun',                                    # (optional) change freekey fields from 1 to ITSMChange::FreeText::MaxNumber
        ChangeFreeText1    => 'Earth',                                  # (optional) change freetext fields from 1 to ITSMChange::FreeText::MaxNumber

        # search in workorder freetext and freekey fields
        WorkOrderFreeKey1  => 'Moon',                                   # (optional) workorder freekey fields from 1 to ITSMWorkOrder::FreeText::MaxNumber
        WorkOrderFreeText1 => 'Mars',                                   # (optional) workorder freetext fields from 1 to ITSMWorkOrder::FreeText::MaxNumber

        # search in text fields of workorder object
        WorkOrderTitle            => 'Boot Mailserver',                # (optional)
        WorkOrderInstruction      => 'Press the button.',              # (optional)
        WorkOrderReport           => 'Mailserver has booted.',         # (optional)

        # search in workorder (array params)
        WorkOrderStates   => [ 'accepted', 'ready' ],                  # (optional)
        WorkOrderStateIDs => [ 1, 2, 3 ],                              # (optional)
        WorkOrderTypes    => [ 'workorder', 'backout', 'approval' ],   # (optional)
        WorkOrderTypeIDs  => [ 5, 6, 7 ],                              # (optional)

        # changes with planned start time after ...
        PlannedStartTimeNewerDate => '2006-01-09 00:00:01',            # (optional)
        # changes with planned start time before then ....
        PlannedStartTimeOlderDate => '2006-01-19 23:59:59',            # (optional)

        # changes with planned end time after ...
        PlannedEndTimeNewerDate   => '2006-01-09 00:00:01',            # (optional)
        # changes with planned end time before then ....
        PlannedEndTimeOlderDate   => '2006-01-19 23:59:59',            # (optional)

        # changes with actual start time after ...
        ActualStartTimeNewerDate  => '2006-01-09 00:00:01',            # (optional)
        # changes with actual start time before then ....
        ActualStartTimeOlderDate  => '2006-01-19 23:59:59',            # (optional)

        # changes with actual end time after ...
        ActualEndTimeNewerDate    => '2006-01-09 00:00:01',            # (optional)
        # changes with actual end time before then ....
        ActualEndTimeOlderDate    => '2006-01-19 23:59:59',            # (optional)

        # changes with created time after ...
        CreateTimeNewerDate       => '2006-01-09 00:00:01',            # (optional)
        # changes with created time before then ....
        CreateTimeOlderDate       => '2006-01-19 23:59:59',            # (optional)

        # changes with changed time after ...
        ChangeTimeNewerDate       => '2006-01-09 00:00:01',            # (optional)
        # changes with changed time before then ....
        ChangeTimeOlderDate       => '2006-01-19 23:59:59',            # (optional)

        # changes with requested time after ...
        RequestedTimeNewerDate    => '2006-01-09 00:00:01',            # (optional)
        # changes with requested time before then ....
        RequestedTimeOlderDate    => '2006-01-19 23:59:59',            # (optional)

        OrderBy => [ 'ChangeID', 'ChangeManagerID' ],                  # (optional)
        # ignored when the result type is 'COUNT'
        # default: [ 'ChangeID' ]
        # (ChangeID, ChangeNumber, ChangeTitle, ChangeStateID,
        # ChangeManagerID, ChangeBuilderID,
        # CategoryID, ImpactID, PriorityID
        # PlannedStartTime, PlannedEndTime,
        # ActualStartTime, ActualEndTime, RequestedTime,
        # CreateTime, CreateBy, ChangeTime, ChangeBy)

        # Additional information for OrderBy:
        # The OrderByDirection can be specified for each OrderBy attribute.
        # The pairing is made by the array indices.

        OrderByDirection => [ 'Down', 'Up' ],                          # (optional)
        # ignored when the result type is 'COUNT'
        # default: [ 'Down' ]
        # (Down | Up)

        UsingWildcards => 1,                                           # (optional)
        # (0 | 1) default 1

        Result => 'ARRAY' || 'COUNT',                                  # (optional)
        # default: ARRAY, returns an array of change ids
        # COUNT returns a scalar with the number of found changes

        Limit => 100,                                                  # (optional)
        # ignored when the result type is 'COUNT'

        MirrorDB => 1,                                                 # (optional)
        # (0 | 1) default 0
        # if set to 1 and ITSMChange::ChangeSearch::MirrorDB
        # is activated and a mirror db is configured in
        # Core::MirrorDB::DSN the change search will then use
        # the mirror db

        UserID => 1,
    );

=cut

sub ChangeSearch {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{UserID} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need UserID!',
        );
        return;
    }

    # verify that all passed array parameters contain an arrayref
    ARGUMENT:
    for my $Argument (
        qw(
        OrderBy
        OrderByDirection
        ChangeStateIDs
        ChangeStates
        ChangeManagerIDs
        ChangeBuilderIDs
        CABAgents
        CABCustomers
        WorkOrderAgentIDs
        WorkOrderStates
        WorkOrderStateIDs
        WorkOrderTypes
        WorkOrderTypeIDs
        CreateBy
        ChangeBy
        Categories
        CategoryIDs
        Impacts
        ImpactIDs
        Priorities
        PriorityIDs
        )
        )
    {
        if ( !defined $Param{$Argument} ) {
            $Param{$Argument} ||= [];

            next ARGUMENT;
        }

        if ( ref $Param{$Argument} ne 'ARRAY' ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "$Argument must be an array reference!",
            );
            return;
        }
    }

    # define a local database object
    my $DBObject = $Self->{DBObject};

    # if we need to do a change search on an external mirror database
    if (
        $Param{MirrorDB}
        && $Self->{ConfigObject}->Get('ITSMChange::ChangeSearch::MirrorDB')
        && $Self->{ConfigObject}->Get('Core::MirrorDB::DSN')
        && $Self->{ConfigObject}->Get('Core::MirrorDB::User')
        && $Self->{ConfigObject}->Get('Core::MirrorDB::Password')
        )
    {

        # create an extra database object for the mirror db
        my $ExtraDatabaseObject = Kernel::System::DB->new(
            LogObject    => $Self->{LogObject},
            ConfigObject => $Self->{ConfigObject},
            MainObject   => $Self->{MainObject},
            EncodeObject => $Self->{EncodeObject},
            DatabaseDSN  => $Self->{ConfigObject}->Get('Core::MirrorDB::DSN'),
            DatabaseUser => $Self->{ConfigObject}->Get('Core::MirrorDB::User'),
            DatabasePw   => $Self->{ConfigObject}->Get('Core::MirrorDB::Password'),
        );

        # check error
        if ( !$ExtraDatabaseObject ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => 'Could not create database object for MirrorDB!',
            );
            return;
        }
        $DBObject = $ExtraDatabaseObject;
    }

    # define order table
    my %OrderByTable = (
        ChangeID         => 'c.id',
        ChangeNumber     => 'c.change_number',
        ChangeTitle      => 'c.title',
        ChangeStateID    => 'c.change_state_id',
        ChangeManagerID  => 'c.change_manager_id',
        ChangeBuilderID  => 'c.change_builder_id',
        CategoryID       => 'c.category_id',
        ImpactID         => 'c.impact_id',
        PriorityID       => 'c.priority_id',
        CreateTime       => 'c.create_time',
        CreateBy         => 'c.create_by',
        ChangeTime       => 'c.change_time',
        ChangeBy         => 'c.change_by',
        RequestedTime    => 'c.requested_time',
        PlannedStartTime => 'MIN(wo1.planned_start_time)',
        PlannedEndTime   => 'MAX(wo1.planned_end_time)',
        ActualStartTime  => 'MIN(wo1.actual_start_time)',
        ActualEndTime    => 'MAX(wo1.actual_end_time)',
    );

    # check if OrderBy contains only unique valid values
    my %OrderBySeen;
    for my $OrderBy ( @{ $Param{OrderBy} } ) {

        if ( !$OrderBy || !$OrderByTable{$OrderBy} || $OrderBySeen{$OrderBy} ) {

            # found an error
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "OrderBy contains invalid value '$OrderBy' "
                    . 'or the value is used more than once!',
            );
            return;
        }

        # remember the value to check if it appears more than once
        $OrderBySeen{$OrderBy} = 1;
    }

    # check if OrderByDirection array contains only 'Up' or 'Down'
    DIRECTION:
    for my $Direction ( @{ $Param{OrderByDirection} } ) {

        # only 'Up' or 'Down' allowed
        next DIRECTION if $Direction eq 'Up';
        next DIRECTION if $Direction eq 'Down';

        # found an error
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "OrderByDirection can only contain 'Up' or 'Down'!",
        );
        return;
    }

    # set default values
    if ( !defined $Param{UsingWildcards} ) {
        $Param{UsingWildcards} = 1;
    }

    # set the default behaviour for the return type
    my $Result = $Param{Result} || 'ARRAY';

    # check whether all of the given ChangeStateIDs are valid
    return if !$Self->_CheckChangeStateIDs( ChangeStateIDs => $Param{ChangeStateIDs} );

    # check whether all of the given CategoryIDs, ImpactIDs and PriorityIDs are valid
    for my $Type (qw(Category Impact Priority)) {
        return if !$Self->_CheckChangeCIPIDs(
            IDs  => $Param{"${Type}IDs"},
            Type => $Type,
        );
    }

    # look up and thus check the States
    for my $ChangeState ( @{ $Param{ChangeStates} } ) {

        # look up the ID for the name
        my $ChangeStateID = $Self->ChangeStateLookup(
            ChangeState => $ChangeState,
        );

        # check whether the ID was found, whether the name exists
        if ( !$ChangeStateID ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "The change state $ChangeState is not known!",
            );

            return;
        }

        push @{ $Param{ChangeStateIDs} }, $ChangeStateID;
    }

    # look up and thus check the CIPs
    my %CIPSingular2Plural = (
        Category => 'Categories',
        Impact   => 'Impacts',
        Priority => 'Priorities',
    );

    for my $CIPSingular ( sort keys %CIPSingular2Plural ) {
        for my $CIP ( @{ $Param{ $CIPSingular2Plural{$CIPSingular} } } ) {

            # look up the ID for the name
            my $CIPID = $Self->ChangeCIPLookup(
                CIP  => $CIP,
                Type => $CIPSingular,
            );

            # check whether the ID was found, whether the name exists
            if ( !$CIPID ) {
                $Self->{LogObject}->Log(
                    Priority => 'error',
                    Message  => "The $CIPSingular $CIP is not known!",
                );

                return;
            }

            push @{ $Param{"${CIPSingular}IDs"} }, $CIPID;
        }
    }

    # check workorder states - if given
    return if !$Self->{WorkOrderObject}->WorkOrderStateIDsCheck(
        WorkOrderStateIDs => $Param{WorkOrderStateIDs},
    );

    # look up and thus check the workorder states
    for my $WorkOrderState ( @{ $Param{WorkOrderStates} } ) {

        # look up the ID for the name
        my $WorkOrderStateID = $Self->{WorkOrderObject}->WorkOrderStateLookup(
            WorkOrderState => $WorkOrderState,
        );

        # check whether the ID was found, whether the name exists
        if ( !$WorkOrderStateID ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "The workorder state $WorkOrderState is not known!",
            );

            return;
        }

        push @{ $Param{WorkOrderStateIDs} }, $WorkOrderStateID;
    }

    # look up and thus check the workorder types
    for my $WorkOrderType ( @{ $Param{WorkOrderTypes} } ) {

        # look up the ID for the name
        my $WorkOrderTypeID = $Self->{WorkOrderObject}->WorkOrderTypeLookup(
            WorkOrderType => $WorkOrderType,
        );

        # check whether the ID was found, whether the name exists
        if ( !$WorkOrderTypeID ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "The workorder type $WorkOrderType is not known!",
            );

            return;
        }

        push @{ $Param{WorkOrderTypeIDs} }, $WorkOrderTypeID;
    }

    my @SQLWhere;           # assemble the conditions used in the WHERE clause
    my @SQLHaving;          # assemble the conditions used in the HAVING clause
    my @InnerJoinTables;    # keep track of the tables that need to be inner joined
    my @OuterJoinTables;    # keep track of the tables that need to be outer joined

    # keep track of the tables that need to be inner joined for change freetext fields
    my @InnerJoinTablesChangeFreeText;

    # keep track of the tables that need to be inner joined for workorder freetext fields
    my @InnerJoinTablesWorkOrderFreeText;

    # add string params to the WHERE clause
    my %StringParams = (

        # strings in change_item
        ChangeNumber  => 'c.change_number',
        ChangeTitle   => 'c.title',
        Description   => 'c.description_plain',
        Justification => 'c.justification_plain',

        # strings in change_workorder
        WorkOrderTitle       => 'wo2.title',
        WorkOrderInstruction => 'wo2.instruction_plain',
        WorkOrderReport      => 'wo2.report_plain',
    );

    # map free key/text params to alias
    my %FreeParams = (
        ChangeFreeText    => 'cft',
        ChangeFreeKey     => 'cfk',
        WorkOrderFreeText => 'wft',
        WorkOrderFreeKey  => 'wfk',
    );

    # add change and workorder freetext fields to %StringParams
    ARGUMENT:
    for my $Argument ( sort keys %Param ) {

        next ARGUMENT
            if $Argument !~ m{ \A (( Change | WorkOrder ) Free ( Text | Key )) ( \d+ ) \z }xms;

        my $Type   = $1;
        my $Number = $4;

        # set the table alias and column for string parameter
        if ( ref $Param{$Argument} eq '' ) {
            $StringParams{$Argument} = $FreeParams{$Type} . $Number . '.field_value';
        }

        # check if the given array contains only one element (with a possible wildcard)
        elsif (
            ref $Param{$Argument} eq 'ARRAY'
            && @{ $Param{$Argument} }
            && scalar @{ $Param{$Argument} } == 1
            )
        {

            # replace $Param{$Argument} for the STRINGPARAM loop, to handle it like an string
            $Param{$Argument} = ${ $Param{$Argument} }[0];

            # set the table alias and column for string parameter
            $StringParams{$Argument} = $FreeParams{$Type} . $Number . '.field_value';
        }

        # add table alias and column for array parameter
        elsif ( ref $Param{$Argument} eq 'ARRAY' && @{ $Param{$Argument} } ) {

            # quote
            for my $OneParam ( @{ $Param{$Argument} } ) {
                $OneParam = "'" . $DBObject->Quote($OneParam) . "'";
            }

            # create string
            my $InString = join ', ', @{ $Param{$Argument} };

            # add params to sql-where-array
            push @SQLWhere, $FreeParams{$Type} . $Number . '.field_value' . " IN ($InString)";

            # add the field id to the where clause
            push @SQLWhere, $FreeParams{$Type} . $Number . '.field_id = ' . $Number;

            if ( $Type =~ m{ \A ChangeFree }xms ) {

                # the change_freetext and change_freekey tables need to be joined,
                # when they occur in the WHERE clause
                push @InnerJoinTablesChangeFreeText, $FreeParams{$Type} . $Number;
            }
            elsif ( $Type =~ m{ \A WorkOrderFree }xms ) {

                # the change_wo_freetext and change_wo_freekey tables need to be joined,
                # when they occur in the WHERE clause
                push @InnerJoinTablesWorkOrderFreeText, $FreeParams{$Type} . $Number;
            }
        }
    }

    # add string params to sql-where-array
    STRINGPARAM:
    for my $StringParam ( sort keys %StringParams ) {

        # check string params for useful values, the string '0' is allowed
        next STRINGPARAM if !exists $Param{$StringParam};
        next STRINGPARAM if !defined $Param{$StringParam};
        next STRINGPARAM if $Param{$StringParam} eq '';

        # quote
        $Param{$StringParam} = $DBObject->Quote( $Param{$StringParam} );

        # check if a CLOB field is used in oracle
        # Fix/Workaround for ORA-00932: inconsistent datatypes: expected - got CLOB
        my $ForceLikeSearchForSpecialFields;
        if (
            $Self->{DBType} eq 'oracle'
            && ( $StringParam eq 'Description' || $StringParam eq 'Justification' )
            )
        {
            $ForceLikeSearchForSpecialFields = 1;
        }

        # wildcards are used (or LIKE search is forced for some special fields on oracle)
        if ( $Param{UsingWildcards} || $ForceLikeSearchForSpecialFields ) {

            # get like escape string needed for some databases (e.g. oracle)
            my $LikeEscapeString = $DBObject->GetDatabaseFunction('LikeEscapeString');

            # Quote
            $Param{$StringParam} = $DBObject->Quote( $Param{$StringParam}, 'Like' );

            # replace * with %
            $Param{$StringParam} =~ s{ \*+ }{%}xmsg;

            # do not use string params which contain only %
            next STRINGPARAM if $Param{$StringParam} =~ m{ \A %* \z }xms;

            push @SQLWhere,
                "LOWER($StringParams{$StringParam}) LIKE LOWER('$Param{$StringParam}') $LikeEscapeString";
        }

        # no wildcards are used
        else {
            push @SQLWhere,
                "LOWER($StringParams{$StringParam}) = LOWER('$Param{$StringParam}')";
        }

        if ( $StringParams{$StringParam} =~ m{ wo2 }xms ) {

            # the change_workorder table needs to be joined, when it occurs in the WHERE clause
            push @InnerJoinTables, 'wo2';
        }

        # add field_id to where clause for change freetext fields
        if ( $StringParams{$StringParam} =~ m{ \A ( ( cft | cfk ) ( \d+ ) ) }xms ) {

            my $TableAlias = $1;
            my $Number     = $3;

            # add the field id to the where clause
            push @SQLWhere, $TableAlias . '.field_id = ' . $Number;

            # the change_freetext and change_freekey tables need to be joined,
            # when they occur in the WHERE clause
            push @InnerJoinTablesChangeFreeText, $TableAlias;
        }

        # add field_id to where clause for workorder freetext fields
        elsif ( $StringParams{$StringParam} =~ m{ \A ( ( wft | wfk ) ( \d+ ) ) }xms ) {

            my $TableAlias = $1;
            my $Number     = $3;

            # add the field id to the where clause
            push @SQLWhere, $TableAlias . '.field_id = ' . $Number;

            # the change_wo_freetext and change_wo_freekey tables need to be joined,
            # when they occur in the WHERE clause
            push @InnerJoinTablesWorkOrderFreeText, $TableAlias;
        }
    }

    # set array params
    my %ArrayParams = (
        ChangeStateIDs   => 'c.change_state_id',
        ChangeManagerIDs => 'c.change_manager_id',
        ChangeBuilderIDs => 'c.change_builder_id',
        CategoryIDs      => 'c.category_id',
        ImpactIDs        => 'c.impact_id',
        PriorityIDs      => 'c.priority_id',
        CreateBy         => 'c.create_by',
        ChangeBy         => 'c.change_by',
    );

    # add array params to sql-where-array
    ARRAYPARAM:
    for my $ArrayParam ( sort keys %ArrayParams ) {

        # ignore empty lists
        next ARRAYPARAM if !@{ $Param{$ArrayParam} };

        # quote
        for my $OneParam ( @{ $Param{$ArrayParam} } ) {
            $OneParam = $DBObject->Quote( $OneParam, 'Integer' );
        }

        # create string
        my $InString = join ', ', @{ $Param{$ArrayParam} };

        push @SQLWhere, "$ArrayParams{$ArrayParam} IN ($InString)";
    }

    # set time params
    my %TimeParams = (

        # times in change_item
        CreateTimeNewerDate    => 'c.create_time >=',
        CreateTimeOlderDate    => 'c.create_time <=',
        ChangeTimeNewerDate    => 'c.change_time >=',
        ChangeTimeOlderDate    => 'c.change_time <=',
        RequestedTimeNewerDate => 'c.requested_time >=',
        RequestedTimeOlderDate => 'c.requested_time <=',

        # times in change_workorder
        PlannedStartTimeNewerDate => 'min(wo1.planned_start_time) >=',
        PlannedStartTimeOlderDate => 'min(wo1.planned_start_time) <=',
        PlannedEndTimeNewerDate   => 'max(wo1.planned_end_time) >=',
        PlannedEndTimeOlderDate   => 'max(wo1.planned_end_time) <=',
        ActualStartTimeNewerDate  => 'min(wo1.actual_start_time) >=',
        ActualStartTimeOlderDate  => 'min(wo1.actual_start_time) <=',
        ActualEndTimeNewerDate    => 'max(wo1.actual_end_time) >=',
        ActualEndTimeOlderDate    => 'max(wo1.actual_end_time) <=',
    );

    # check and add time params to WHERE or HAVING clause
    TIMEPARAM:
    for my $TimeParam ( sort keys %TimeParams ) {

        next TIMEPARAM if !$Param{$TimeParam};

        if ( $Param{$TimeParam} !~ m{ \A \d\d\d\d-\d\d-\d\d \s \d\d:\d\d:\d\d \z }xms ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "The parameter $TimeParam has an invalid date format!",
            );

            return;
        }

        $Param{$TimeParam} = $DBObject->Quote( $Param{$TimeParam} );

        if ( $TimeParams{$TimeParam} =~ m{ wo1 }xms ) {

            # the change_workorder table needs to be joined, when it occurs in the HAVING clause
            push @SQLHaving,       "$TimeParams{$TimeParam} '$Param{$TimeParam}'";
            push @OuterJoinTables, 'wo1';
        }
        else {

            # the time attributes of change_item show up in the WHERE clause
            push @SQLWhere, "$TimeParams{$TimeParam} '$Param{$TimeParam}'";
        }
    }

    # conditions for CAB searches
    my %CABParams = (
        CABAgents    => 'cab1.user_id',
        CABCustomers => 'cab2.customer_user_id',
    );

    # add cab params to sql-where-array
    CABPARAM:
    for my $CABParam ( sort keys %CABParams ) {
        next CABPARAM if !@{ $Param{$CABParam} };

        # quote
        for my $OneParam ( @{ $Param{$CABParam} } ) {
            $OneParam = $DBObject->Quote($OneParam);
        }

        if ( $CABParam eq 'CABAgents' ) {

            # CABAgent is a integer, so no quotes are needed
            my $InString = join ', ', @{ $Param{$CABParam} };
            push @SQLWhere,        "$CABParams{$CABParam} IN ($InString)";
            push @InnerJoinTables, 'cab1';
        }
        elsif ( $CABParam eq 'CABCustomers' ) {

            # CABCustomer is a string, so the single quotes are needed
            my $InString = join ', ', map {"'$_'"} @{ $Param{$CABParam} };
            push @SQLWhere,        "$CABParams{$CABParam} IN ($InString)";
            push @InnerJoinTables, 'cab2';
        }
    }

    # workorder array params
    my %WorkOrderArrayParams = (
        WorkOrderAgentIDs => 'workorder_agent_id',
        WorkOrderStateIDs => 'workorder_state_id',
        WorkOrderTypeIDs  => 'workorder_type_id',
    );

    # add workorder params to sql-where-array
    WORKORDERPARAM:
    for my $WorkOrderParam ( sort keys %WorkOrderArrayParams ) {

        next WORKORDERPARAM if !@{ $Param{$WorkOrderParam} };

        # quote as integer
        for my $OneParam ( @{ $Param{$WorkOrderParam} } ) {
            $OneParam = $DBObject->Quote( $OneParam, 'Integer' );
        }

        # create string
        my $InString = join ', ', @{ $Param{$WorkOrderParam} };
        my $ColumnName = $WorkOrderArrayParams{$WorkOrderParam};

        push @SQLWhere,        "wo2.$ColumnName IN ( $InString )";
        push @InnerJoinTables, 'wo2';
    }

    # define which parameter require a join with workorder table
    my %TableRequiresJoin = (
        PlannedStartTime => 1,
        PlannedEndTime   => 1,
        ActualStartTime  => 1,
        ActualEndTime    => 1,
    );

    # delete the OrderBy parameter when the result type is 'COUNT'
    if ( $Result eq 'COUNT' ) {
        $Param{OrderBy} = [];
    }

    # assemble the ORDER BY clause
    my @SQLOrderBy;
    my @SQLAliases;    # order by aliases, be on the save side with MySQL
    my $Count = 0;
    for my $OrderBy ( @{ $Param{OrderBy} } ) {

        # set the default order direction
        my $Direction = 'DESC';

        # add the given order direction
        if ( $Param{OrderByDirection}->[$Count] ) {
            if ( $Param{OrderByDirection}->[$Count] eq 'Up' ) {
                $Direction = 'ASC';
            }
            elsif ( $Param{OrderByDirection}->[$Count] eq 'Down' ) {
                $Direction = 'DESC';
            }
        }

        # add SQL
        if ( $OrderByTable{$OrderBy} =~ m{ wo1 }xms ) {
            push @SQLAliases, "$OrderByTable{$OrderBy} as alias_$OrderBy";
            push @SQLOrderBy, "alias_$OrderBy $Direction";
        }
        else {
            push @SQLOrderBy, "$OrderByTable{$OrderBy} $Direction";
        }

        # for some order fields, we need to make sure, that the wo1 table is joined
        if ( $TableRequiresJoin{$OrderBy} ) {
            push @OuterJoinTables, 'wo1';
        }
    }
    continue {
        $Count++;
    }

    # if there is a possibility that the ordering is not determined
    # we add an descending ordering by id
    if ( !grep { $_ eq 'ChangeID' } ( @{ $Param{OrderBy} } ) ) {
        push @SQLOrderBy, "$OrderByTable{ChangeID} DESC";
    }

    # assemble the SQL query
    my $SQL = 'SELECT ' . join( ', ', ( 'c.id', @SQLAliases ) ) . ' FROM change_item c ';

    # modify SQL when the result type is 'COUNT', and when there are no joins
    if ( $Result eq 'COUNT' && !@InnerJoinTables && !@OuterJoinTables ) {
        $SQL        = 'SELECT COUNT(c.id) FROM change_item c ';
        @SQLOrderBy = ();
    }

    # add the joins
    my %LongTableName = (
        wo1  => 'change_workorder',
        wo2  => 'change_workorder',
        cab1 => 'change_cab',
        cab2 => 'change_cab',
    );
    my %TableSeen;

    INNER_JOIN_TABLE:
    for my $Table (@InnerJoinTables) {

        # do not join a table twice
        next INNER_JOIN_TABLE if $TableSeen{$Table};

        $TableSeen{$Table} = 1;

        if ( !$LongTableName{$Table} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Encountered invalid inner join table '$Table'!",
            );
            return;
        }

        $SQL .= "INNER JOIN $LongTableName{$Table} $Table ON $Table.change_id = c.id ";
    }

    INNER_JOIN_TABLE_CHANGE_FREETEXT:
    for my $Table (@InnerJoinTablesChangeFreeText) {

        # change freetext
        if ( $Table =~ m{ \A cft }xms ) {
            $SQL .= "INNER JOIN change_freetext $Table ON $Table.change_id = c.id ";
        }

        # change freekey
        elsif ( $Table =~ m{ \A cfk }xms ) {
            $SQL .= "INNER JOIN change_freekey $Table ON $Table.change_id = c.id ";
        }
    }

    # check if we need have to join workorder freetext tables
    if (@InnerJoinTablesWorkOrderFreeText) {

        # we also need to join the workorder table
        $SQL .= 'INNER JOIN change_workorder ON change_workorder.change_id = c.id ';

        INNER_JOIN_TABLE_WORKORDER_FREETEXT:
        for my $Table (@InnerJoinTablesWorkOrderFreeText) {

            # workorder freetext
            if ( $Table =~ m{ \A wft }xms ) {
                $SQL .= "INNER JOIN change_wo_freetext $Table "
                    . "ON $Table.workorder_id = change_workorder.id ";
            }

            # workorder freekey
            elsif ( $Table =~ m{ \A wfk }xms ) {
                $SQL .= "INNER JOIN change_wo_freekey $Table ON "
                    . "$Table.workorder_id = change_workorder.id ";
            }
        }
    }

    OUTER_JOIN_TABLE:
    for my $Table (@OuterJoinTables) {

        # do not join a table twice, when a table has been inner joined, no outer join is necessary
        next OUTER_JOIN_TABLE if $TableSeen{$Table};

        # remember that this table is joined already
        $TableSeen{$Table} = 1;

        # check error
        if ( !$LongTableName{$Table} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Encountered invalid outer join table '$Table'!",
            );
            return;
        }

        $SQL .= "LEFT OUTER JOIN $LongTableName{$Table} $Table ON $Table.change_id = c.id ";
    }

    # add the WHERE clause
    if (@SQLWhere) {
        $SQL .= 'WHERE ';
        $SQL .= join ' AND ', map {"( $_ )"} @SQLWhere;
        $SQL .= ' ';
    }

    # we need to group whenever there is a join
    if (
        scalar @InnerJoinTables
        || scalar @InnerJoinTablesChangeFreeText
        || scalar @InnerJoinTablesWorkOrderFreeText
        || scalar @OuterJoinTables
        )
    {
        $SQL .= 'GROUP BY c.id ';

        # add the orderby columns also to the group by clause, as this is correct SQL
        # and some DBs like PostgreSQL are more strict than others
        # this is the bugfix for bug# 5825 http://bugs.otrs.org/show_bug.cgi?id=5825
        if (@SQLOrderBy) {

            ORDERBY:
            for my $OrderBy (@SQLOrderBy) {

                # get the column from a string that looks like: c.change_number ASC
                if ( $OrderBy =~ m{ \A (\S+) }xms ) {

                    # get the column part of the string
                    my $Column = $1;

                    # do not include the c.id column again, as this is already done before
                    next ORDERBY if $Column eq 'c.id';

                    # do not include aliases of aggregate functions (min/max)
                    next ORDERBY if $Column =~ m{ \A alias_ }xms;

                    # add the column to the group by clause
                    $SQL .= ", $Column ";
                }
            }
        }
    }

    # add the HAVING clause
    if (@SQLHaving) {
        $SQL .= 'HAVING ';
        $SQL .= join ' AND ', map {"( $_ )"} @SQLHaving;
        $SQL .= ' ';
    }

    # add the ORDER BY clause
    if (@SQLOrderBy) {
        $SQL .= 'ORDER BY ';
        $SQL .= join ', ', @SQLOrderBy;
        $SQL .= ' ';
    }

    # ignore the parameter 'Limit' when result type is 'COUNT'
    if ( $Result eq 'COUNT' ) {
        delete $Param{Limit};
    }

    # ask database
    return if !$DBObject->Prepare(
        SQL   => $SQL,
        Limit => $Param{Limit},
    );

    # fetch the result
    my @IDs;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        push @IDs, $Row[0];
    }

    if (
        $Result eq 'COUNT'
        && !@InnerJoinTables
        && !@InnerJoinTablesChangeFreeText
        && !@InnerJoinTablesWorkOrderFreeText
        && !@OuterJoinTables
        )
    {

        # return the COUNT(c.id) attribute
        return $IDs[0];
    }
    elsif ( $Result eq 'COUNT' ) {

        # return the count as the number of IDs
        return scalar @IDs;
    }
    else {
        return \@IDs;
    }
}

=item ChangeDelete()

Delete a change.

This function first removes all links and attachments to the given change.
Then it gets a list of all workorders of the change and
calls C<WorkorderDelete()> for each workorder, which will delete
all links and all attachments to the workorders.
Then it deletes the CAB.
After that the change is removed.
The history of this change will be deleted during the handling of the
triggered ChangeDeletePost-event.

    my $Success = $ChangeObject->ChangeDelete(
        ChangeID => 123,
        UserID   => 1,
    );

=cut

sub ChangeDelete {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Attribute (qw(ChangeID UserID)) {
        if ( !$Param{$Attribute} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Attribute!",
            );
            return;
        }
    }

    # trigger ChangeDeletePre-Event
    $Self->EventHandler(
        Event => 'ChangeDeletePre',
        Data  => {
            %Param,
        },
        UserID => $Param{UserID},
    );

    # the change does not exist, when it can't be looked up
    return if !$Self->ChangeLookup(
        ChangeID => $Param{ChangeID},
    );

    # delete all links to this change
    return if !$Self->{LinkObject}->LinkDeleteAll(
        Object => 'ITSMChange',
        Key    => $Param{ChangeID},
        UserID => 1,
    );

    # get the list of attachments and delete them
    my @Attachments = $Self->ChangeAttachmentList(
        ChangeID => $Param{ChangeID},
    );
    for my $Filename (@Attachments) {
        return if !$Self->ChangeAttachmentDelete(
            ChangeID => $Param{ChangeID},
            Filename => $Filename,
            UserID   => $Param{UserID},
        );
    }

    # get change data to get the workorder ids
    my $ChangeData = $Self->ChangeGet(
        ChangeID => $Param{ChangeID},
        UserID   => $Param{UserID},
    );

    # check if change contains workorders
    if (
        $ChangeData
        && ref $ChangeData eq 'HASH'
        && $ChangeData->{WorkOrderIDs}
        && ref $ChangeData->{WorkOrderIDs} eq 'ARRAY'
        )
    {

        # delete the workorders
        for my $WorkOrderID ( @{ $ChangeData->{WorkOrderIDs} } ) {
            return if !$Self->{WorkOrderObject}->WorkOrderDelete(
                WorkOrderID  => $WorkOrderID,
                NoNumberCalc => 1,
                UserID       => $Param{UserID},
            );
        }
    }

    # delete the CAB
    return if !$Self->ChangeCABDelete(
        ChangeID => $Param{ChangeID},
        UserID   => $Param{UserID},
    );

    # delete the change freetext fields
    return if !$Self->_ChangeFreeTextDelete(
        ChangeID => $Param{ChangeID},
        UserID   => $Param{UserID},
    );

    # delete cache
    for my $Key (
        'ChangeGet::ID::' . $Param{ChangeID},
        'ChangeList',
        'ChangeLookup::ChangeID::' . $Param{ChangeID},
        'ChangeLookup::ChangeNumber::' . $ChangeData->{ChangeNumber},
        )
    {

        $Self->{CacheObject}->Delete(
            Type => 'ITSMChangeManagement',
            Key  => $Key,
        );
    }

    # trigger ChangeDeletePost-Event
    # this must be done before deleting the change from the database,
    # because of a foreign key constraint in the change_history table
    $Self->EventHandler(
        Event => 'ChangeDeletePost',
        Data  => {
            OldChangeData => $ChangeData,
            %Param,
        },
        UserID => $Param{UserID},
    );

    # delete the change
    return if !$Self->{DBObject}->Do(
        SQL  => 'DELETE FROM change_item WHERE id = ?',
        Bind => [ \$Param{ChangeID} ],
    );

    return 1;
}

=item ChangeStateLookup()

This method does a lookup for a change state. If a change state id is given,
it returns the name of the change state. If a change state name is given,
the appropriate id is returned.

    my $ChangeState = $ChangeObject->ChangeStateLookup(
        ChangeStateID => 1234,
    );

    my $ChangeStateID = $ChangeObject->ChangeStateLookup(
        ChangeState => 'accepted',
    );

=cut

sub ChangeStateLookup {
    my ( $Self, %Param ) = @_;

    # either ChangeStateID or State must be passed
    if ( !$Param{ChangeStateID} && !$Param{ChangeState} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need ChangeStateID or ChangeState!',
        );
        return;
    }

    if ( $Param{ChangeStateID} && $Param{ChangeState} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need ChangeStateID OR ChangeState - not both!',
        );
        return;
    }

    # get the change states from the general catalog
    my $StateList = $Self->{GeneralCatalogObject}->ItemList(
        Class => 'ITSM::ChangeManagement::Change::State',
    );

    # convert state list into a lookup hash
    my %StateID2Name;
    if ( $StateList && ref $StateList eq 'HASH' && %{$StateList} ) {
        %StateID2Name = %{$StateList};
    }

    # check the state hash
    if ( !%StateID2Name ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Could not retrieve change states from the general catalog.',
        );
        return;
    }
    if ( $Param{ChangeStateID} ) {
        return $StateID2Name{ $Param{ChangeStateID} };
    }
    else {

        # reverse key - value pairs to have the name as keys
        my %StateName2ID = reverse %StateID2Name;

        return $StateName2ID{ $Param{ChangeState} };
    }
}

=item ChangePossibleStatesGet()

This method returns a list of possible change states.
If ChangeID is omitted, the complete list of change states is returned.
If ChangeID is given, the list of possible change states for this
change is returned.

    my $ChangeStateList = $ChangeObject->ChangePossibleStatesGet(
        ChangeID => 123,    # (optional)
        UserID   => 1,
    );

The return value is a reference to an array of hashrefs. The element 'Key' is then
the ChangeStateID and the element 'Value' is the name of the state. The array elements
are sorted by state id.

    my $ChangeStateList = [
        {
            Key   => 156,
            Value => 'approved',
        },
        {
            Key   => 157,
            Value => 'in progress',
        },
    ];

=cut

sub ChangePossibleStatesGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{UserID} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Need UserID!",
        );
        return;
    }

    # get change state list
    my $StateList = $Self->{GeneralCatalogObject}->ItemList(
        Class => 'ITSM::ChangeManagement::Change::State',
    ) || {};

    # to store an array of hash refs
    my @ArrayHashRef;

    # if ChangeID is given, only use possible next states as defined in state machine
    if ( $Param{ChangeID} ) {

        # get change data
        my $Change = $Self->ChangeGet(
            ChangeID => $Param{ChangeID},
            UserID   => $Param{UserID},
        );

        # check for state lock
        my $StateLock;
        $StateLock = $Self->{ConditionObject}->ConditionMatchStateLock(
            ObjectName => 'ITSMChange',
            Selector   => $Param{ChangeID},
            StateID    => $Change->{ChangeStateID},
            UserID     => $Param{UserID},
        );

        # set as default state current change state
        my @NextStateIDs = ( $Change->{ChangeStateID} );

        # check if reachable change end states should be allowed for locked change states
        my $ChangeEndStatesAllowed
            = $Self->{ConfigObject}->Get('ITSMChange::StateLock::AllowEndStates');

        if ($ChangeEndStatesAllowed) {

            # set as default state current state and all possible end states
            my $EndStateIDsRef = $Self->{StateMachineObject}->StateTransitionGetEndStates(
                StateID => $Change->{ChangeStateID},
                Class   => 'ITSM::ChangeManagement::Change::State',
            ) || [];
            @NextStateIDs = sort ( @{$EndStateIDsRef}, $Change->{ChangeStateID} );
        }

        # get possible next states if no state lock
        if ( !$StateLock ) {

            # get the possible next state ids
            my $NextStateIDsRef = $Self->{StateMachineObject}->StateTransitionGet(
                StateID => $Change->{ChangeStateID},
                Class   => 'ITSM::ChangeManagement::Change::State',
            ) || [];

            # add current change state id to list
            @NextStateIDs = sort ( @{$NextStateIDsRef}, $Change->{ChangeStateID} );
        }

        # assemble the array of hash refs with only possible next states
        STATEID:
        for my $StateID (@NextStateIDs) {

            next STATEID if !$StateID;

            push @ArrayHashRef, {
                Key   => $StateID,
                Value => $StateList->{$StateID},
            };
        }

        return \@ArrayHashRef;
    }

    # assemble the array of hash refs with all next states
    for my $StateID ( sort keys %{$StateList} ) {
        push @ArrayHashRef, {
            Key   => $StateID,
            Value => $StateList->{$StateID},
        };
    }

    return \@ArrayHashRef;
}

=item ChangePossibleCIPGet()

This method returns a list of possible categories, impacts or priorities.

    my $CIPList = $ChangeObject->ChangePossibleCIPGet(
        Type   => 'Category',  # Category|Impact|Priority
        UserID => 1,
    );

The return value is a reference to an array of hashrefs. The Element 'Key' is then
the ID and the element 'Value' is the name of the category, impact or priority.
The array elements are sorted by id in ascending order.

    my $CIPList = [
        {
            Key   => 156,
            Value => '1 very low',
        },
        {
            Key   => 157,
            Value => '2 low',
        },
    ];

=cut

sub ChangePossibleCIPGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{UserID} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Need UserID!",
        );
        return;
    }

    # check Type param for valid values
    if (
        !$Param{Type}
        || ( $Param{Type} ne 'Category' && $Param{Type} ne 'Impact' && $Param{Type} ne 'Priority' )
        )
    {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'The param Type must be either "Category" or "Impact" or "Priority"!',
        );
        return;
    }

    # get item list for the requested type
    my $CIPList = $Self->{GeneralCatalogObject}->ItemList(
        Class => 'ITSM::ChangeManagement::' . $Param{Type},
    ) || {};

    # assemble an array of hash refs
    my @ArrayHashRef;
    for my $ID ( sort { $CIPList->{$a} cmp $CIPList->{$b} } keys %{$CIPList} ) {
        push @ArrayHashRef, {
            Key   => $ID,
            Value => $CIPList->{$ID},
        };
    }

    return \@ArrayHashRef;
}

=item ChangeCIPLookup()

This method does a lookup for a change category, impact or priority.
If a change CIP-ID is given, it returns the name of the CIP.
If a change CIP name is given, the appropriate ID is returned.

    my $Name = $ChangeObject->ChangeCIPLookup(
        ID   => 1234,
        Type => 'Priority',
    );

    my $ID = $ChangeObject->ChangeCIPLookup(
        CIP  => '1 very low',
        Type => 'Category',
    );

=cut

sub ChangeCIPLookup {
    my ( $Self, %Param ) = @_;

    # either ID or CIP must be passed
    if ( !$Param{ID} && !$Param{CIP} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need ID or CIP!',
        );
        return;
    }

    # check that not both ID and CIP are given
    if ( $Param{ID} && $Param{CIP} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need either ID OR CIP - not both!',
        );
        return;
    }

    # check Type param for valid values
    if (
        !$Param{Type}
        || ( $Param{Type} ne 'Category' && $Param{Type} ne 'Impact' && $Param{Type} ne 'Priority' )
        )
    {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'The param Type must be either "Category" or "Impact" or "Priority"!',
        );
        return;
    }

    # get change CIP from general catalog
    # mapping of the id to the name
    my %ChangeCIP = %{
        $Self->{GeneralCatalogObject}->ItemList(
            Class => 'ITSM::ChangeManagement::' . $Param{Type},
            ) || {}
    };

    if ( $Param{ID} ) {
        return $ChangeCIP{ $Param{ID} };
    }
    else {

        # reverse key - value pairs to have the name as keys
        my %ReversedChangeCIP = reverse %ChangeCIP;

        return $ReversedChangeCIP{ $Param{CIP} };
    }
}

=item Permission()

Returns whether the agent C<UserID> has permissions of the type C<Type>
on the change C<ChangeID>. The parameters are passed on to
the permission modules that were registered in the permission registry.
The standard permission registry is B<ITSMChange::Permission>, but
that can be overridden with the parameter C<PermissionRegistry>.

The optional option C<LogNo> turns off logging when access was denied.
This is useful when the method is used for checking whether a link or an action should be shown.

    my $Access = $ChangeObject->Permission(
        UserID             => 123,
        Type               => 'ro',                         # 'ro' and 'rw' are supported
        Action             => 'AgentITSMChangeEdit',        # optional
        ChangeID           => 3333,   # optional, do not pass for 'ChangeAdd'
        PermissionRegistry => 'ITSMChange::Permission',
                                      # optional with default 'ITSMChange::Permission'
        LogNo              => 1,      # optional, turns off logging when access is denied
    );

=cut

sub Permission {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(Type UserID)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # There are valid cases when no ChangeID is passed.
    # E.g. for ChangeAdd() or ChangeSearch().
    $Param{ChangeID} ||= '';

    # the place where the permission modules are registerd can be overridden by a parameter
    my $Registry = $Param{PermissionRegistry} || 'ITSMChange::Permission';

    # run the relevant permission modules
    if ( ref $Self->{ConfigObject}->Get($Registry) eq 'HASH' ) {
        my %Modules = %{ $Self->{ConfigObject}->Get($Registry) };
        for my $Module ( sort keys %Modules ) {

            # log try of load module
            if ( $Self->{Debug} > 1 ) {
                $Self->{LogObject}->Log(
                    Priority => 'debug',
                    Message  => "Try to load module: $Modules{$Module}->{Module}!",
                );
            }

            # load module
            next if !$Self->{MainObject}->Require( $Modules{$Module}->{Module} );

            # create object
            my $ModuleObject = $Modules{$Module}->{Module}->new(
                ConfigObject => $Self->{ConfigObject},
                EncodeObject => $Self->{EncodeObject},
                LogObject    => $Self->{LogObject},
                MainObject   => $Self->{MainObject},
                TimeObject   => $Self->{TimeObject},
                DBObject     => $Self->{DBObject},
                UserObject   => $Self->{UserObject},
                GroupObject  => $Self->{GroupObject},
                ChangeObject => $Self,
                Debug        => $Self->{Debug},
            );

            # ask for the opinion of the Permission module
            my $Access = $ModuleObject->Run(%Param);

            # Grant overall permission,
            # when the module granted a sufficient permission.
            if ( $Access && $Modules{$Module}->{Granted} ) {
                if ( $Self->{Debug} > 0 ) {
                    $Self->{LogObject}->Log(
                        Priority => 'debug',
                        Message  => "Granted '$Param{Type}' access for "
                            . "UserID: $Param{UserID} on "
                            . "ChangeID '$Param{ChangeID}' "
                            . "through $Modules{$Module}->{Module} (no more checks)!",
                    );
                }

                # grant permission
                return 1;
            }

            # Deny overall permission,
            # when the module denied a required permission.
            if ( !$Access && $Modules{$Module}->{Required} ) {
                if ( !$Param{LogNo} ) {
                    $Self->{LogObject}->Log(
                        Priority => 'notice',
                        Message  => "Denied '$Param{Type}' access for "
                            . "UserID: $Param{UserID} on "
                            . "ChangeID '$Param{ChangeID}' "
                            . "because $Modules{$Module}->{Module} is required!",
                    );
                }

                # deny permission
                return;
            }
        }
    }

    # Deny access when neither a 'Granted'-Check nor a 'Required'-Check has reached a conclusion.
    if ( !$Param{LogNo} ) {
        $Self->{LogObject}->Log(
            Priority => 'notice',
            Message  => "Permission denied (UserID: $Param{UserID} '$Param{Type}' "
                . "on ChangeID: $Param{ChangeID})!",
        );
    }

    return;
}

=item ChangeAttachmentAdd()

Add an attachment to the given change.

    my $Success = $ChangeObject->ChangeAttachmentAdd(
        ChangeID    => 123,               # the ChangeID becomes part of the file path
        Filename    => 'filename',
        Content     => 'content',
        ContentType => 'text/plain',
        UserID      => 1,
    );

=cut

sub ChangeAttachmentAdd {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(ChangeID Filename Content ContentType UserID)) {
        if ( !$Param{$Needed} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );

            return;
        }
    }

    # write to virtual fs
    my $Success = $Self->{VirtualFSObject}->Write(
        Filename    => "Change/$Param{ChangeID}/$Param{Filename}",
        Mode        => 'binary',
        Content     => \$Param{Content},
        Preferences => {
            ContentID   => $Param{ContentID},
            ContentType => $Param{ContentType},
            ChangeID    => $Param{ChangeID},
            UserID      => $Param{UserID},
        },
    );

    # check for error
    if ($Success) {

        # trigger AttachmentAdd-Event
        $Self->EventHandler(
            Event => 'ChangeAttachmentAddPost',
            Data  => {
                %Param,
            },
            UserID => $Param{UserID},
        );
    }
    else {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Cannot add attachment for change $Param{ChangeID}",
        );

        return;
    }

    return 1;
}

=item ChangeAttachmentDelete()

Delete the given file from the virtual filesystem.

    my $Success = $ChangeObject->ChangeAttachmentDelete(
        ChangeID => 123,      # used in event handling, e.g. for logging the history
        Filename => 'Projectplan.pdf',     # identifies the attachment (together with the ChangeID)
        UserID   => 1,
    );

=cut

sub ChangeAttachmentDelete {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(ChangeID Filename UserID)) {
        if ( !$Param{$Needed} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );

            return;
        }
    }

    # add prefix
    my $Filename = 'Change/' . $Param{ChangeID} . '/' . $Param{Filename};

    # delete file
    my $Success = $Self->{VirtualFSObject}->Delete(
        Filename => $Filename,
    );

    # check for error
    if ($Success) {

        # trigger AttachmentDeletePost-Event
        $Self->EventHandler(
            Event => 'ChangeAttachmentDeletePost',
            Data  => {
                %Param,
            },
            UserID => $Param{UserID},
        );
    }
    else {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Cannot delete attachment $Filename!",
        );

        return;
    }

    return $Success;
}

=item ChangeAttachmentGet()

This method returns information about one specific attachment.

    my $Attachment = $ChangeObject->ChangeAttachmentGet(
        ChangeID => 4,
        Filename => 'test.txt',
    );

returns

    {
        Preferences => {
            AllPreferences => 'test',
        },
        Filename    => 'test.txt',
        Content     => 'hallo',
        ContentType => 'text/plain',
        Filesize    => '123 KBytes',
        Type        => 'attachment',
    }

=cut

sub ChangeAttachmentGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(ChangeID Filename)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # add prefix
    my $Filename = 'Change/' . $Param{ChangeID} . '/' . $Param{Filename};

    # find all attachments of this change
    my @Attachments = $Self->{VirtualFSObject}->Find(
        Filename    => $Filename,
        Preferences => {
            ChangeID => $Param{ChangeID},
        },
    );

    # return error if file does not exist
    if ( !@Attachments ) {
        $Self->{LogObject}->Log(
            Message  => "No such attachment ($Filename)! May be an attack!!!",
            Priority => 'error',
        );
        return;
    }

    # get data for attachment
    my %AttachmentData = $Self->{VirtualFSObject}->Read(
        Filename => $Filename,
        Mode     => 'binary',
    );

    my $AttachmentInfo = {
        %AttachmentData,
        Filename    => $Param{Filename},
        Content     => ${ $AttachmentData{Content} },
        ContentType => $AttachmentData{Preferences}->{ContentType},
        Type        => 'attachment',
        Filesize    => $AttachmentData{Preferences}->{Filesize},
    };

    return $AttachmentInfo;
}

=item ChangeAttachmentList()

Returns an array with all attachments of the given change.

    my @Attachments = $ChangeObject->ChangeAttachmentList(
        ChangeID => 123,
    );

returns

    @Attachments = (
        'filename.txt',
        'other_file.pdf',
    );

=cut

sub ChangeAttachmentList {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{ChangeID} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need ChangeID!',
        );

        return;
    }

    # find all attachments of this change
    my @Attachments = $Self->{VirtualFSObject}->Find(
        Preferences => {
            ChangeID => $Param{ChangeID},
        },
    );

    for my $Filename (@Attachments) {

        # remove extra information from filename
        $Filename =~ s{ \A Change / \d+ / }{}xms;
    }

    return @Attachments;
}

=item ChangeAttachmentExists()

Checks if a file with a given filename exists.

    my $Exists = $ChangeObject->ChangeAttachmentExists(
        Filename => 'test.txt',
        ChangeID => 123,
        UserID   => 1,
    );

=cut

sub ChangeAttachmentExists {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(Filename ChangeID UserID)) {
        if ( !$Param{$Needed} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );

            return;
        }
    }

    return if !$Self->{VirtualFSObject}->Find(
        Filename => 'Change/' . $Param{ChangeID} . '/' . $Param{Filename},
    );

    return 1;
}

=item ChangeGetConfiguredFreeTextFields()

Returns an array with the numbers of all configured change freekey and freetext fields

    my @ConfiguredChangeFreeTextFields = $ChangeObject->ChangeGetConfiguredFreeTextFields();

=cut

sub ChangeGetConfiguredFreeTextFields {
    my ( $Self, %Param ) = @_;

    # lookup cached result
    if (
        $Self->{ConfiguredChangeFreeTextFields}
        && ref $Self->{ConfiguredChangeFreeTextFields} eq 'ARRAY'
        && @{ $Self->{ConfiguredChangeFreeTextFields} }
        )
    {
        return @{ $Self->{ConfiguredChangeFreeTextFields} };
    }

    # get maximum number of change freetext fields
    my $MaxNumber = $Self->{ConfigObject}->Get('ITSMChange::FreeText::MaxNumber');

    # get all configured change freekey and freetext numbers
    my @ConfiguredChangeFreeTextFields = ();
    FREETEXTNUMBER:
    for my $Number ( 1 .. $MaxNumber ) {

        # check change freekey config
        if ( $Self->{ConfigObject}->Get( 'ChangeFreeKey' . $Number ) ) {
            push @ConfiguredChangeFreeTextFields, $Number;
            next FREETEXTNUMBER;
        }

        # check change freetext config
        if ( $Self->{ConfigObject}->Get( 'ChangeFreeText' . $Number ) ) {
            push @ConfiguredChangeFreeTextFields, $Number;
            next FREETEXTNUMBER;
        }
    }

    # cache result
    $Self->{ConfiguredChangeFreeTextFields} = \@ConfiguredChangeFreeTextFields;

    return @ConfiguredChangeFreeTextFields;
}

sub DESTROY {
    my $Self = shift;

    # execute all transaction events
    $Self->EventHandlerTransaction();

    return 1;
}

=begin Internal:

=item _CheckChangeStateIDs()

Check whether all of the given change state ids are valid.

    my $Ok = $ChangeObject->_CheckChangeStateIDs(
        ChangeStateIDs => [ 25, 26 ],
    );

=cut

sub _CheckChangeStateIDs {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{ChangeStateIDs} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need ChangeStateIDs!',
        );
        return;
    }

    if ( ref $Param{ChangeStateIDs} ne 'ARRAY' ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'The param ChangeStateIDs must be an array reference!',
        );
        return;
    }

    # check if ChangeStateIDs belong to correct general catalog class
    for my $StateID ( @{ $Param{ChangeStateIDs} } ) {
        my $State = $Self->ChangeStateLookup(
            ChangeStateID => $StateID,
        );

        if ( !$State ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "The state id $StateID is not valid!",
            );

            return;
        }
    }

    return 1;
}

=item _CheckChangeCIPIDs()

Check whether all of the given ids of category, impact or priority are valid.

    my $Ok = $ChangeObject->_CheckChangeCIPIDs(
        IDs  => [ 25, 26 ], # mandatory
        Type => 'Priority', # mandatory (Category|Impact|Priority)
    );

=cut

sub _CheckChangeCIPIDs {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(IDs Type)) {
        if ( !$Param{$Needed} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    # check if IDs is an array reference
    if ( ref $Param{IDs} ne 'ARRAY' ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'The param IDs must be an array reference!',
        );
        return;
    }

    # check Type param for valid values
    if (
        !$Param{Type}
        || ( $Param{Type} ne 'Category' && $Param{Type} ne 'Impact' && $Param{Type} ne 'Priority' )
        )
    {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'The param Type must be either "Category" or "Impact" or "Priority"!',
        );
        return;
    }

    # check if IDs belongs to correct general catalog class
    for my $ID ( @{ $Param{IDs} } ) {
        my $CIP = $Self->ChangeCIPLookup(
            ID   => $ID,
            Type => $Param{Type},
        );

        if ( !$CIP ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "The $Param{Type} id $ID is not valid!",
            );

            return;
        }
    }

    return 1;
}

=item _CheckChangeParams()

Checks the params to ChangeAdd() and ChangeUpdate().
There are no required parameters.

    my $Ok = $ChangeObject->_CheckChangeParams(
        ChangeTitle          => 'Replacement of mail server',       # (optional)
        Description          => 'New mail server <b>is</b> faster', # (optional)
        DescriptionPlain     => 'New mail server is faster',        # (optional)
        Justification        => 'Old mail server<b>too</b> slow',   # (optional)
        JustificationPlain   => 'Old mail server too slow',         # (optional)
        ChangeStateID        => 4,                                  # (optional)
        ChangeManagerID      => 5,                                  # (optional)
        ChangeBuilderID      => 6,                                  # (optional)
        CategoryID           => 7,                                  # (optional)
        ImpactID             => 8,                                  # (optional)
        PriorityID           => 9,                                  # (optional)
        RequestedTime        => '2009-10-23 08:57:12',              # (optional)
        CABAgents            => [ 1, 2, 4 ],     # UserIDs          # (optional)
        CABCustomers         => [ 'tt', 'mm' ],  # CustomerUserIDs  # (optional)
        ChangeFreeKey1       => 'Sun',                              # (optional) change freekey fields from 1 to ITSMChange::FreeText::MaxNumber
        ChangeFreeText1      => 'Earth',                            # (optional) change freetext fields from 1 to ITSMChange::FreeText::MaxNumber
    );

The ChangeStateID is checked for existence in the general catalog.
These string parameters have length constraints:

    Parameter           | max. length
    --------------------+-----------------
    ChangeTitle         |  250 characters
    Description         | 1800000 characters
    DescriptionPlain    | 1800000 characters
    Justification       | 1800000 characters
    JustificationPlain  | 1800000 characters
    ChangeFreeKeyXX     |  250 characters
    ChangeFreeTextXX    |  250 characters

=cut

sub _CheckChangeParams {
    my ( $Self, %Param ) = @_;

    # check the string and id parameters
    ARGUMENT:
    for my $Argument (
        qw(
        ChangeTitle
        Description
        DescriptionPlain
        Justification
        JustificationPlain
        ChangeManagerID
        ChangeBuilderID
        ChangeStateID
        )
        )
    {

        # params are not required
        next ARGUMENT if !exists $Param{$Argument};

        # check if param is not defined
        if ( !defined $Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "The parameter '$Argument' must be defined!",
            );
            return;
        }

        # check if param is not a reference
        if ( ref $Param{$Argument} ne '' ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "The parameter '$Argument' mustn't be a reference!",
            );
            return;
        }

        # check the maximum length of title
        if ( $Argument eq 'ChangeTitle' && length( $Param{$Argument} ) > 250 ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "The parameter '$Argument' must be shorter than 250 characters!",
            );
            return;
        }

        # check the maximum length of description and justification
        if (
            $Argument eq 'Description'
            || $Argument eq 'DescriptionPlain'
            || $Argument eq 'Justification'
            || $Argument eq 'JustificationPlain'
            )
        {
            if ( length( $Param{$Argument} ) > 1800000 ) {
                $Self->{LogObject}->Log(
                    Priority => 'error',
                    Message => "The parameter '$Argument' must be shorter than 1800000 characters!",
                );
                return;
            }
        }
    }

    # check the freekey and freetext parameters
    for my $Type ( 'ChangeFreeKey', 'ChangeFreeText' ) {

        # check all possible freetext fields
        NUMBER:
        for my $Number ( 1 .. $Self->{ConfigObject}->Get('ITSMChange::FreeText::MaxNumber') ) {

            # build argument, e.g. ChangeFreeKey1
            my $Argument = $Type . $Number;

            # params are not required
            next NUMBER if !exists $Param{$Argument};

            # check if param is not defined
            if ( !defined $Param{$Argument} ) {
                $Self->{LogObject}->Log(
                    Priority => 'error',
                    Message  => "The parameter '$Argument' must be defined!",
                );
                return;
            }

            # check if param is not a reference
            if ( ref $Param{$Argument} ne '' ) {
                $Self->{LogObject}->Log(
                    Priority => 'error',
                    Message  => "The parameter '$Argument' mustn't be a reference!",
                );
                return;
            }

            # check the maximum length of freetext fields
            if ( length( $Param{$Argument} ) > 250 ) {
                $Self->{LogObject}->Log(
                    Priority => 'error',
                    Message  => "The parameter '$Argument' must be shorter than 250 characters!",
                );
                return;
            }
        }
    }

    # check if requested_time has correct format
    if (
        defined $Param{RequestedTime}
        && $Param{RequestedTime} !~ m{ \A \d\d\d\d-\d\d-\d\d \s \d\d:\d\d:\d\d \z }xms
        )
    {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Invalid format for RequestedTime!',
        );
        return;
    }

    # check if given ChangeStateID is valid
    if ( $Param{ChangeStateID} ) {
        return if !$Self->_CheckChangeStateIDs(
            ChangeStateIDs => [ $Param{ChangeStateID} ],
        );
    }

    # check if given category, impact or priority ID is valid
    for my $Type (qw(Category Impact Priority)) {
        if ( defined $Param{"${Type}ID"} ) {
            return if !$Self->_CheckChangeCIPIDs(
                IDs  => [ $Param{"${Type}ID"} ],
                Type => $Type,
            );
        }

        if ( defined $Param{$Type} ) {
            return if !$Self->ChangeCIPLookup(
                CIP  => $Param{$Type},
                Type => $Type,
            );
        }
    }

    # change manager and change builder must be agents
    ARGUMENT:
    for my $Argument (qw( ChangeManagerID ChangeBuilderID )) {

        # params are not required
        next ARGUMENT if !exists $Param{$Argument};

        # get user data
        my %UserData = $Self->{UserObject}->GetUserData(
            UserID => $Param{$Argument},
            Valid  => 1,
        );

        if ( !$UserData{UserID} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "The $Argument $Param{$Argument} is not a valid user id!",
            );
            return;
        }
    }

    # CAB agents must be agents
    if ( exists $Param{CABAgents} ) {
        if ( ref $Param{CABAgents} ne 'ARRAY' ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => 'The parameter CABAgents is not an ARRAY reference!',
            );
            return;
        }

        # check users
        for my $UserID ( @{ $Param{CABAgents} } ) {

            # get user data
            my %UserData = $Self->{UserObject}->GetUserData(
                UserID => $UserID,
                Valid  => 1,
            );

            if ( !$UserData{UserID} ) {
                $Self->{LogObject}->Log(
                    Priority => 'error',
                    Message  => "The CABAgent $UserID is not a valid user id!",
                );
                return;
            }
        }
    }

    # CAB customers must be customers
    if ( exists $Param{CABCustomers} ) {
        if ( ref $Param{CABCustomers} ne 'ARRAY' ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => 'The parameter CABCustomers is not an ARRAY reference!',
            );
            return;
        }

        # check customer users
        for my $CustomerUser ( @{ $Param{CABCustomers} } ) {

            # get customer user data
            my %CustomerUserData = $Self->{CustomerUserObject}->CustomerUserDataGet(
                User  => $CustomerUser,
                Valid => 1,
            );

            if ( !%CustomerUserData ) {
                $Self->{LogObject}->Log(
                    Priority => 'error',
                    Message  => "The CABCustomer $CustomerUser is not a valid customer!",
                );
                return;
            }
        }
    }

    return 1;
}

=item _ChangeFreeTextGet()

Gets the freetext and freekey fields of a change as a hash reference.

    my $ChangeFreeText = $ChangeObject->_ChangeFreeTextGet(
        ChangeID => 123,
        UserID   => 1,
    );

Returns:

    $ChangeFreeText = {
        ChangeFreeKey1  => 'Sun',   # change freekey fields from 1 to ITSMChange::FreeText::MaxNumber
        ChangeFreeText1 => 'Earth', # change freetext fields from 1 to ITSMChange::FreeText::MaxNumber
    }

=cut

sub _ChangeFreeTextGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Attribute (qw(ChangeID UserID)) {
        if ( !$Param{$Attribute} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Attribute!",
            );
            return;
        }
    }

    # to store change freekey and freetext data
    my %Data;

    # get change freekey and freetext data
    for my $Type ( 'ChangeFreeKey', 'ChangeFreeText' ) {

        # preset every freetext field with empty string
        for my $Number ( 1 .. $Self->{ConfigObject}->Get('ITSMChange::FreeText::MaxNumber') ) {
            $Data{ $Type . $Number } = '';
        }

        # set table name
        my $TableName = '';
        if ( $Type eq 'ChangeFreeText' ) {
            $TableName = 'change_freetext';
        }
        elsif ( $Type eq 'ChangeFreeKey' ) {
            $TableName = 'change_freekey';
        }

        # get change freetext fields
        return if !$Self->{DBObject}->Prepare(
            SQL => 'SELECT field_id, field_value'
                . ' FROM ' . $TableName
                . ' WHERE change_id = ?',
            Bind => [ \$Param{ChangeID} ],
        );
        while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
            my $Field = $Type . $Row[0];
            my $Value = $Row[1];
            $Data{$Field} = defined $Value ? $Value : '';
        }
    }

    return \%Data;
}

=item _ChangeFreeTextUpdate()

Updates the freetext and freekey fields of a change.
Passing an empty string deletes the freetext field.

    my $Success = $ChangeObject->_ChangeFreeTextUpdate(
        ChangeID        => 123,
        ChangeFreeKey1  => 'Sun',   # (optional) change freekey fields from 1 to ITSMChange::FreeText::MaxNumber
        ChangeFreeText1 => 'Earth', # (optional) change freetext fields from 1 to ITSMChange::FreeText::MaxNumber
        UserID          => 1,
    );

=cut

sub _ChangeFreeTextUpdate {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Attribute (qw(ChangeID UserID)) {
        if ( !$Param{$Attribute} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Attribute!",
            );
            return;
        }
    }

    # check the given parameters
    return if !$Self->_CheckChangeParams(%Param);

    # store the given freekey and freetext ids
    my @FreeKeyFieldIDs;
    my @FreeTextFieldIDs;
    for my $Type ( 'ChangeFreeKey', 'ChangeFreeText' ) {

        # check all possible freetext fields
        NUMBER:
        for my $Number ( 1 .. $Self->{ConfigObject}->Get('ITSMChange::FreeText::MaxNumber') ) {

            # build argument, e.g. ChangeFreeKey1
            my $Argument = $Type . $Number;

            # params are not required
            next NUMBER if !exists $Param{$Argument};

            # all checks were done before, so here we are safe and store the ids
            if ( $Type eq 'ChangeFreeKey' ) {
                push @FreeKeyFieldIDs, $Number;
            }
            elsif ( $Type eq 'ChangeFreeText' ) {
                push @FreeTextFieldIDs, $Number;
            }
        }
    }

    for my $Type ( 'ChangeFreeKey', 'ChangeFreeText' ) {

        # set table name and arrays of field ids
        my $TableName;
        my @FieldIDs;
        if ( $Type eq 'ChangeFreeKey' ) {
            $TableName = 'change_freekey';
            @FieldIDs  = @FreeKeyFieldIDs;
        }
        elsif ( $Type eq 'ChangeFreeText' ) {
            $TableName = 'change_freetext';
            @FieldIDs  = @FreeTextFieldIDs;
        }

        # get all existing entries for this change_id
        # and type (ChangeFreeKey or ChangeFreeText)
        $Self->{DBObject}->Prepare(
            SQL => 'SELECT id, field_id '
                . 'FROM ' . $TableName
                . ' WHERE change_id = ?',
            Bind => [ \$Param{ChangeID} ],
        );
        my %FieldData;
        while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
            my $ID      = $Row[0];
            my $FieldID = $Row[1];

            $FieldData{$FieldID} = {
                ID => $ID,
            };
        }

        # update all given change freekey and freetext fields
        for my $FieldID (@FieldIDs) {

            # get new value from parameter
            my $Value = $Param{ $Type . $FieldID };

            # freetext/freekey field exists in database
            if ( $FieldData{$FieldID} ) {

                # new value is not en empty string, the field needs an update
                if ( $Value ne '' ) {
                    return if !$Self->{DBObject}->Do(
                        SQL => 'UPDATE ' . $TableName
                            . ' SET field_value = ?'
                            . ' WHERE id = ?',
                        Bind => [ \$Value, \$FieldData{$FieldID}->{ID} ],
                    );
                }

                # new value is an empty string, the field must be deleted
                else {
                    return if !$Self->{DBObject}->Do(
                        SQL => 'DELETE FROM ' . $TableName
                            . ' WHERE id = ?',
                        Bind => [ \$FieldData{$FieldID}->{ID} ],
                    );
                }
            }

            # freetext/freekey field does not exist in database
            # and new value is not an empty string
            elsif ( $Value ne '' ) {
                return if !$Self->{DBObject}->Do(
                    SQL => 'INSERT INTO ' . $TableName
                        . ' (change_id, field_id, field_value)'
                        . ' VALUES (?, ?, ?)',
                    Bind => [ \$Param{ChangeID}, \$FieldID, \$Value ],
                );
            }
        }
    }

    # delete cache
    $Self->{CacheObject}->Delete(
        Type => 'ITSMChangeManagement',
        Key  => 'ChangeGet::ID::' . $Param{ChangeID},
    );

    return 1;
}

=item _ChangeFreeTextDelete()

Deletes all freetext and freekey fields of a change.

    my $Success = $ChangeObject->_ChangeFreeTextDelete(
        ChangeID => 123,
        UserID   => 1,
    );

=cut

sub _ChangeFreeTextDelete {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Attribute (qw(ChangeID UserID)) {
        if ( !$Param{$Attribute} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Attribute!",
            );
            return;
        }
    }

    for my $Type ( 'ChangeFreeKey', 'ChangeFreeText' ) {

        # set table name
        my $TableName;
        if ( $Type eq 'ChangeFreeKey' ) {
            $TableName = 'change_freekey';
        }
        elsif ( $Type eq 'ChangeFreeText' ) {
            $TableName = 'change_freetext';
        }

        # delete entries from database
        return if !$Self->{DBObject}->Do(
            SQL => 'DELETE FROM ' . $TableName
                . ' WHERE change_id = ?',
            Bind => [ \$Param{ChangeID} ],
        );
    }

    # delete cache
    $Self->{CacheObject}->Delete(
        Type => 'ITSMChangeManagement',
        Key  => 'ChangeGet::ID::' . $Param{ChangeID},
    );

    return 1;
}

1;

=end Internal:

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
