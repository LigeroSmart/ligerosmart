# --
# Kernel/System/ITSMChange/Template.pm - all template functions
# Copyright (C) 2003-2010 OTRS AG, http://otrs.com/
# --
# $Id: Template.pm,v 1.6 2010-01-18 10:10:23 bes Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::ITSMChange::Template;

use strict;
use warnings;

use Kernel::System::ITSMChange;
use Kernel::System::ITSMChange::ITSMWorkOrder;
use Kernel::System::ITSMChange::ITSMCondition;
use Kernel::System::Valid;
use Data::Dumper;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.6 $) [1];

=head1 NAME

Kernel::System::ITSMChange::Template - template lib

=head1 SYNOPSIS

All functions for templates in ITSMChangeManagement.

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
    use Kernel::System::ITSMChange::Template;

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
    my $ConditionObject = Kernel::System::ITSMChange::Template->new(
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
    for my $Object (qw(DBObject ConfigObject EncodeObject LogObject MainObject TimeObject)) {
        $Self->{$Object} = $Param{$Object} || die "Got no $Object!";
    }

    # set the debug flag
    $Self->{Debug} = $Param{Debug} || 0;

    # create additional objects
    $Self->{ChangeObject}    = Kernel::System::ITSMChange->new( %{$Self} );
    $Self->{ConditionObject} = Kernel::System::ITSMChange::ITSMCondition->new( %{$Self} );
    $Self->{WorkOrderObject} = Kernel::System::ITSMChange::ITSMWorkOrder->new( %{$Self} );
    $Self->{ValidObject}     = Kernel::System::Valid->new( %{$Self} );

    return $Self;
}

=item TemplateAdd()

Add a new template.

    my $TemplateID = $TemplateObject->TemplateAdd(
        Name     => 'The condition name',
        Content  => [{ ChangeAdd => { ... } }],
        Comment  => 'A comment',           # (optional)
        TypeID   => 1,
        ValidID  => 1,
        UserID   => 1,
    );

=cut

sub TemplateAdd {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(ChangeID Name TypeID ValidID UserID)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # check if a template with this name already exists
    return if !$Self->{DBObject}->Prepare(
        SQL   => 'SELECT id FROM change_template WHERE name = ?',
        Bind  => [ \$Param{Name} ],
        Limit => 1,
    );

    # fetch the result
    my $TemplateID;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $TemplateID = $Row[0];
    }

    # a template with this name exists already
    if ($TemplateID) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "A template with the name $Param{Name} already exists.!",
        );
        return;
    }

    # TODO: execute TemplateAddPre Event

    # add new template to database
    return if !$Self->{DBObject}->Do(
        SQL => 'INSERT INTO change_template '
            . '(name, comments, content, type_id, valid_id, '
            . 'create_time, create_by, change_time, change_by) '
            . 'VALUES (?, ?, ?, ?, ?, current_timestamp, ?, current_timestamp, ?)',
        Bind => [
            \$Param{Name}, \$Param{Comment}, \$Param{Content}, \$Param{TypeID}, \$Param{ValidID},
            \$Param{ValidID}, \$Param{UserID}, \$Param{UserID},
        ],
    );

    # prepare SQL statement
    return if !$Self->{DBObject}->Prepare(
        SQL   => 'SELECT id FROM change_template WHERE name = ?',
        Bind  => [ \$Param{Name} ],
        Limit => 1,
    );

    # fetch the result
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $TemplateID = $Row[0];
    }

    # check if template could be added
    if ( !$TemplateID ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "TemplateAdd() failed!",
        );
        return;
    }

    # TODO: execute TemplateAddPost Event

    return $TemplateID;
}

=item TemplateUpdate()

Update a template.

    my $Success = $TemplateObject->TemplateUpdate(
        TemplateID => 1234,
        Name       => 'The template name',   # (optional)
        Comment    => 'A comment',           # (optional)
        Content    => [ ... ],               # (optional)
        ValidID    => 1,                     # (optional)
        TypeID     => 1,                     # (optional)
        UserID     => 1,
    );

=cut

sub TemplateUpdate {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(TemplateID UserID)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # TODO: execute TemplateUpdatePre Event

    # map update attributes to column names
    my %Attribute = (
        Name    => 'name',
        Comment => 'comments',
        Content => 'content',
        ValidID => 'valid_id',
        TypeID  => 'type_id',
    );

    # build SQL to update template
    my $SQL = 'UPDATE change_template SET ';
    my @Bind;

    ATTRIBUTE:
    for my $Attribute ( keys %Attribute ) {

        # preserve the old value, when the column isn't in function parameters
        next ATTRIBUTE if !exists $Param{$Attribute};

        # param checking has already been done, so this is safe
        $SQL .= "$Attribute{$Attribute} = ?, ";
        push @Bind, \$Param{$Attribute};
    }

    # add change time and change user
    $SQL .= 'change_time = current_timestamp, change_by = ? ';
    push @Bind, \$Param{UserID};

    # set matching of SQL statement
    $SQL .= 'WHERE id = ?';
    push @Bind, \$Param{TemplateID};

    # update template
    return if !$Self->{DBObject}->Do(
        SQL  => $SQL,
        Bind => \@Bind,
    );

    # TODO: execute TemplateUpdatePost Event

    return 1;
}

=item TemplateGet()

Returns a hash reference of the template data for a given TemplateID.

    my $TemplateData = $TemplateObject->TemplateGet(
        TemplateID => 123,
        UserID      => 1,
    );

The returned hash reference contains following elements:

    $TemplateData{TemplateID}
    $TemplateData{Name}
    $TemplateData{Comment}
    $TemplateData{TypeID}
    $TemplateData{Type}
    $TemplateData{ValidID}
    $TemplateData{CreateTime}
    $TemplateData{CreateBy}
    $TemplateData{ChangeTime}
    $TemplateData{ChangeBy}

=cut

sub TemplateGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(TemplateID UserID)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # prepare SQL statement
    return if !$Self->{DBObject}->Prepare(
        SQL => 'SELECT ct.id, ct.name, comments, type_id, ctt.name '
            . 'ct.valid_id, ct.create_time, ct.create_by, ct.change_time, ct.change_by '
            . 'FROM change_template ct, change_template_type ctt '
            . 'WHERE ct.type_id = ctt.id AND ct.id = ?',
        Bind  => [ \$Param{TemplateID} ],
        Limit => 1,
    );

    # fetch the result
    my %TemplateData;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $TemplateData{TemplateID} = $Row[0];
        $TemplateData{Name}       = $Row[1];
        $TemplateData{Comment}    = $Row[2];
        $TemplateData{TypeID}     = $Row[3];
        $TemplateData{Type}       = $Row[4];
        $TemplateData{ValidID}    = $Row[5];
        $TemplateData{CreateTime} = $Row[6];
        $TemplateData{CreateBy}   = $Row[7];
        $TemplateData{ChangeTime} = $Row[8];
        $TemplateData{ChangeBy}   = $Row[9];
    }

    # check error
    if ( !%TemplateData ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "TemplateID $Param{TemplateID} does not exist!",
        );
        return;
    }

    return \%TemplateData;
}

=item TemplateList()

return a hashref of all templates

    my $Templates = $TemplateObject->TemplateList(
        Valid    => 0,   # (optional) default 1 (0|1)
        UserID   => 1,
    );

returns

    $Templates = {
        1 => 'my template',
        3 => 'your template name',
    };

=cut

sub TemplateList {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(UserID)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # check valid param
    if ( !defined $Param{Valid} ) {
        $Param{Valid} = 1;
    }

    # define SQL statement
    my $SQL = 'SELECT id, name FROM change_template';

    # get only valid template ids
    if ( $Param{Valid} ) {

        my @ValidIDs = $Self->{ValidObject}->ValidIDsGet();
        my $ValidIDString = join ', ', @ValidIDs;

        $SQL .= "AND valid_id IN ( $ValidIDString )";
    }

    # prepare SQL statement
    return if !$Self->{DBObject}->Prepare(
        SQL => $SQL,
    );

    # fetch the result
    my %Templates;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $Templates{ $Row[0] } = $Row[1];
    }

    return \%Templates;
}

=item TemplateDelete()

Delete a template.

    my $Success = $TemplateObject->TemplateDelete(
        TemplateID => 123,
        UserID      => 1,
    );

=cut

sub TemplateDelete {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(TemplateID UserID)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # TODO: execute TemplateDeletePre Event
    # TODO it may be neccessary to get the ChangeID from TemplateGet()
    # so that the history entry will be written to the correct change

    # delete template from database
    return if !$Self->{DBObject}->Do(
        SQL  => 'DELETE FROM change_template WHERE id = ?',
        Bind => [ \$Param{TemplateID} ],
    );

    # TODO: execute TemplateDeletePost Event

    return 1;
}

=item TemplateTypeLookup()

Return the template id when the template name is passed.
Return the template name when the template id is passed.
When no template id or template name is found, then the undefined value is returned.

    my $TemplateID = $TemplateObject->TemplateTypeLookup(
        TemplateName => 'my template name',
        UserID       => 1,
    );

    my $TemplateName = $TemplateObject->TemplateTypeLookup(
        TemplateID => 42,
        UserID     => 1,
    );

=cut

sub TemplateTypeLookup {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{UserID} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need UserID!',
        );
        return;
    }

    # the change id or the change number must be passed
    if ( !$Param{TemplateID} && !$Param{TemplateName} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need the TemplateID or the TemplateName!',
        );
        return;
    }

    # only one of template id and template name can be passed
    if ( $Param{TemplateID} && $Param{TemplateName} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need either the TemplateName or the TemplateID, not both!',
        );
        return;
    }

    # get template id
    if ( $Param{TemplateName} ) {
        return if !$Self->{DBObject}->Prepare(
            SQL   => 'SELECT id FROM change_template WHERE name = ?',
            Bind  => [ \$Param{TemplateName} ],
            Limit => 1,
        );

        my $TemplateID;
        while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
            $TemplateID = $Row[0];
        }

        return $TemplateID;
    }

    # get template name
    elsif ( $Param{TemplateID} ) {

        return if !$Self->{DBObject}->Prepare(
            SQL   => 'SELECT name FROM change_template_type WHERE id = ?',
            Bind  => [ \$Param{TemplateID} ],
            Limit => 1,
        );

        my $TemplateName;
        while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
            $TemplateName = $Row[0];
        }

        return $TemplateName;
    }

    return;
}

=item TemplateSerialize()

This method is in fact a dispatcher for different template types.
Currently ITSMChangeManagement supports these template types:

ITSMChange

The method returns a datastruction, serialized with Data::Dumper.

    my $ChangeTemplate = $TemplateObject->TemplateSerialize(
        TemplateType => 'ITSMChange',
        UserID       => 1,

        # other options needed depending on the template type
        ChangeID => 123,
    );

=cut

sub TemplateSerialize {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{UserID} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need UserID!',
        );
        return;
    }

    # the template type id or the template type name must be passed
    if ( !$Param{TemplateTypeID} && !$Param{TemplateType} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need the TemplateTypeID or the TemplateType!',
        );
        return;
    }

    # only one of template type name and template type id can be passed
    if ( $Param{TemplateType} && $Param{TemplateTypeID} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need either the TemplateTypeID or the TemplateType, not both!',
        );
        return;
    }

    my $TemplateType = $Param{TemplateType};
    if ( $Param{TemplateTypeID} ) {
        $TemplateType = $Self->TemplateTypeLookup(
            TemplateID => $Param{TemplateTypeID},
        );
    }

    # what types of templates are supported and what subroutines do the serialization
    my %Types2Subroutines = (
        ITSMChange    => '_ITSMChangeSerialize',
        ITSMWorkOrder => '_ITSMWorkOrderSerialize',
        ITSMCondition => '_ConditionSerialize',
        CAB           => '_CABSerialize',
    );

    return if !exists $Types2Subroutines{$TemplateType};

    my $Sub            = $Types2Subroutines{$TemplateType};
    my $SerializedData = $Self->$Sub(%Param);

    return $SerializedData;
}

=item TemplateDeSerialize()

This method deserializes the template content. A Perl datastructure is returned. Actually
it is an array reference with hash references as elements.

    my $ArrayReference = $TemplateObject->TemplateDeSerialize(
        TemplateID => 123,
        UserID     => 1,
    );

=cut

sub TemplateDeSerialize {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(UserID TemplateID)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # get template
    my $Template = $Self->TemplateGet(
        %Param,
    );

    return if !$Template;

    # get the Perl datastructure
    my $TemplateContent = $Template->{Content};
    my $TemplateData;

    eval "\$TemplateData = $TemplateContent; 1;" or return;

    # dispatch table
    my %Method2Subroutine = (
        ChangeAdd    => '_ChangeAdd',
        WorkOrderAdd => '_WorkOrderAdd',
        CABAdd       => '_CABAdd',
        ConditionAdd => '_ConditionAdd',
    );

    # create entities defined by the template
    my $ChangeID = $Param{ChangeID};

    ENTITY:
    for my $Entity ( @{$TemplateData} ) {
        my ( $Method, $Data ) = each %{$Entity};

        my $Sub = $Method2Subroutine{$Method};

        next ENTITY if !$Sub;

        $ChangeID = $Self->$Sub(
            %{$Data},
            ChangeID => $ChangeID,
            UserID   => $Param{UserID},
        );
    }

    return $TemplateData;
}

=begin Internal:

=item _ITSMChangeSerialize()

Serialize a change.

=cut

sub _ITSMChangeSerialize {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(UserID ChangeID)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # get change
    my $Change = $Self->{ChangeObject}->ChangeGet(
        ChangeID => $Param{ChangeID},
        UserID   => $Param{UserID},
    );

    return if !$Change;

    # the ids are needed later
    my $WorkOrderIDs = $Change->{WorkOrderIDs};

    # delete not needed values from change
    for my $Attribute
        (
        qw(ChangeState ChangeStateSignal Category Impact Priority WorkOrderIDs
        WorkOrderCount PlannedStartTime PlannedEndTime ActualStartTime ActualEndTime
        PlannedEffort AccountedTime)
        )
    {
        delete $Change->{$Attribute};
    }

    my $OriginalData = [ { ChangeAdd => $Change } ];

    # get workorders
    WORKORDERID:
    for my $WorkOrderID ( @{$WorkOrderIDs} ) {
        my $WorkOrder = $Self->{WorkOrderObject}->WorkOrderGet(
            WorkOrderID => $WorkOrderID,
            UserID      => $Param{UserID},
        );

        next WORKORDERID if !$WorkOrder;

        # delete not needed attributes from workorder
        for my $Attribute (qw(WorkOrderState WorkOrderStateSignal WorkOrderType)) {
            delete $WorkOrder->{$Attribute};
        }

        push @{$OriginalData}, { WorkOrderAdd => $WorkOrder };
    }

    # get condition list for the change
    my $ConditionList = $Self->{ConditionObject}->ConditionList(
        ChangeID => $Param{ChangeID},
        Valid    => 0,
        UserID   => $Param{UserID},
    ) || [];

    # get each condition
    CONDITIONID:
    for my $ConditionID ( @{$ConditionList} ) {
        my $Condition = $Self->{ConditionObject}->ConditionGet(
            ConditionID => $ConditionID,
            UserID      => $Param{UserID},
        );

        next CONDITIONID if !$Condition;

        push @{$OriginalData}, { ConditionAdd => $Condition };
    }

    # TODO: get attachments

    # no indentation (saves space)
    local $Data::Dumper::Indent = 0;

    # do not use cross-referencing
    local $Data::Dumper::Deepcopy = 1;

    # serialize the data (do not use $VAR1, but $TemplateData for Dumper output)
    my $SerializedData = Data::Dumper->Dump( [$OriginalData], ['TemplateData'] );

    return $SerializedData;
}

=item _ITSMWorkOrderSerialize()

Serialize a workorder.

=cut

sub _ITSMWorkOrderSerialize {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(UserID WorkOrderID)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # get workorder
    my $WorkOrder = $Self->{WorkOrderObject}->WorkOrderGet(
        WorkOrderID => $Param{WorkOrderID},
        UserID      => $Param{UserID},
    );

    return if !$WorkOrder;

    # delete not needed attributes from workorder
    for my $Attribute (qw(WorkOrderState WorkOrderStateSignal WorkOrderType)) {
        delete $WorkOrder->{$Attribute};
    }

    # TODO: get Attachments

    # no indentation (saves space)
    local $Data::Dumper::Indent = 0;

    # do not use cross-referencing
    local $Data::Dumper::Deepcopy = 1;

    # templates have to be an array reference;
    my $OriginalData = [ { WorkOrderAdd => $WorkOrder } ];

    # serialize the data (do not use $VAR1, but $TemplateData for Dumper output)
    my $SerializedData = Data::Dumper->Dump( [$OriginalData], ['TemplateData'] );

    return $SerializedData;
}

=item _CABSerialize()

=cut

sub _CABSerialize {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(UserID ChangeID)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # get CAB of the change
    my $Change = $Self->{ChangeObject}->ChangeGet(
        ChangeID => $Param{ChangeID},
        UserID   => $Param{UserID},
    );

    return if !$Change;

    # no indentation (saves space)
    local $Data::Dumper::Indent = 0;

    # do not use cross-referencing
    local $Data::Dumper::Deepcopy = 1;

    # templates have to be an array reference;
    my $OriginalData = [
        {
            CABAdd => {
                CABCustomers => $Change->{CABCustomers},
                CABAgents    => $Change->{CABAgents},
                }
        }
    ];

    # serialize the data (do not use $VAR1, but $TemplateData for Dumper output)
    my $SerializedData = Data::Dumper->Dump( [$OriginalData], ['TemplateData'] );

    return $SerializedData;

}

=item _ConditionSerialize()

Serialize a condition.

=cut

sub _ConditionSerialize {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(UserID ConditionID)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # get condition
    my $Condition = $Self->{ConditionObject}->ConditionGet(
        ConditionID => $Param{ConditionID},
        UserID      => $Param{UserID},
    );

    return if !$Condition;

    # no indentation (saves space)
    local $Data::Dumper::Indent = 0;

    # do not use cross-referencing
    local $Data::Dumper::Deepcopy = 1;

    # templates have to be an array reference;
    my $OriginalData = [ { ConditionAdd => $Condition } ];

    # serialize the data (do not use $VAR1, but $TemplateData for Dumper output)
    my $SerializedData = Data::Dumper->Dump( [$OriginalData], ['TemplateData'] );

    return $SerializedData;
}

=item _ChangeAdd()

Creates a new change based on a template. It returns the new ChangeID.

    my $ChangeID = $TemplateObject->_ChangeAdd(
        ChangeID => 0,

    );

=cut

sub _ChangeAdd {
    my ( $Self, %Param ) = @_;

    # we should not pass the ChangeID to ChangeAdd
    delete $Param{ChangeID};

    # add the change
    my $ChangeID = $Self->{ChangeObject}->ChangeAdd(
        %Param,
    );

    return $ChangeID;
}

=item _WorkOrderAdd()

Creates a new workorder based on a template. It returns the
change id it was created for.

    my $ChangeID = $TemplateObject->_WorkOrderAdd(
    );

=cut

sub _WorkOrderAdd {
    my ( $Self, %Param ) = @_;

    return if !$Self->{WorkOrderObject}->WorkOrderAdd(
        %Param,
    );

    return $Param{ChangeID};
}

=item _CABAdd()

=cut

sub _CABAdd {
    my ( $Self, %Param ) = @_;

    return $Param{ChangeID};
}

=item _ConditionAdd()

=cut

sub _ConditionAdd {
    my ( $Self, %Param ) = @_;
    return $Param{ChangeID};
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

$Revision: 1.6 $ $Date: 2010-01-18 10:10:23 $

=cut
