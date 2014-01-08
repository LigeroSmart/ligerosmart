# --
# Kernel/System/ITSMChange/Template.pm - all template functions
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::ITSMChange::Template;

use strict;
use warnings;

use Kernel::System::EventHandler;
use Kernel::System::ITSMChange;
use Kernel::System::ITSMChange::ITSMWorkOrder;
use Kernel::System::ITSMChange::ITSMCondition;
use Kernel::System::LinkObject;
use Kernel::System::Valid;
use Kernel::System::VirtualFS;

## nofilter(TidyAll::Plugin::OTRS::Perl::Dumper)
use Data::Dumper;

use vars qw(@ISA);

@ISA = (
    'Kernel::System::EventHandler',
);

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
    my $TemplateObject = Kernel::System::ITSMChange::Template->new(
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
    $Self->{ChangeObject}    = Kernel::System::ITSMChange->new( %{$Self} );
    $Self->{WorkOrderObject} = Kernel::System::ITSMChange::ITSMWorkOrder->new( %{$Self} );
    $Self->{LinkObject}      = Kernel::System::LinkObject->new( %{$Self} );
    $Self->{ConditionObject} = Kernel::System::ITSMChange::ITSMCondition->new( %{$Self} );
    $Self->{ValidObject}     = Kernel::System::Valid->new( %{$Self} );
    $Self->{VirtualFSObject} = Kernel::System::VirtualFS->new( %{$Self} );

    # init of event handler
    $Self->EventHandlerInit(
        Config     => 'ITSMTemplate::EventModule',
        BaseObject => 'TemplateObject',
        Objects    => {
            %{$Self},
        },
    );

    return $Self;
}

=item TemplateAdd()

Add a new template.

    my $TemplateID = $TemplateObject->TemplateAdd(
        Name           => 'The template name',
        Content        => '[{ ChangeAdd => { ... } }]',   # a serialized change, workorder, ...
        Comment        => 'A comment',                    # (optional)
        TemplateType   => 'ITSMChange',                   # alternatively: TemplateTypeID
        TemplateTypeID => 1,                              # alternatively: TemplateType
        ValidID        => 1,
        UserID         => 1,
    );

=cut

sub TemplateAdd {
    my ( $Self, %Param ) = @_;

    # check that not both TemplateType and TemplateTypeID are given
    if ( $Param{TemplateType} && $Param{TemplateTypeID} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need either TemplateType OR TemplateTypeID - not both!',
        );
        return;
    }

    # when the template type is given, then look up the ID
    if ( $Param{TemplateType} ) {
        $Param{TemplateTypeID} = $Self->TemplateTypeLookup(
            TemplateType => $Param{TemplateType},
        );
    }

    # check needed stuff
    for my $Argument (qw(Content Name TemplateTypeID ValidID UserID)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # check whether a template with this name and type already exists
    return if !$Self->{DBObject}->Prepare(
        SQL   => 'SELECT id FROM change_template WHERE name = ? AND type_id = ?',
        Bind  => [ \$Param{Name}, \$Param{TemplateTypeID} ],
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
            Message =>
                "A template with the name '$Param{Name}' and the type '$Param{TemplateTypeID}' already exists!",
        );
        return;
    }

    # trigger TemplateAddPre-Event
    $Self->EventHandler(
        Event => 'TemplateAddPre',
        Data  => {
            %Param,
        },
        UserID => $Param{UserID},
    );

    # add new template to database
    return if !$Self->{DBObject}->Do(
        SQL => 'INSERT INTO change_template '
            . '(name, comments, content, type_id, valid_id, '
            . 'create_time, create_by, change_time, change_by) '
            . 'VALUES (?, ?, ?, ?, ?, current_timestamp, ?, current_timestamp, ?)',
        Bind => [
            \$Param{Name}, \$Param{Comment}, \$Param{Content}, \$Param{TemplateTypeID},
            \$Param{ValidID}, \$Param{UserID}, \$Param{UserID},
        ],
    );

    # prepare SQL statement
    return if !$Self->{DBObject}->Prepare(
        SQL   => 'SELECT id FROM change_template WHERE name = ? AND type_id = ?',
        Bind  => [ \$Param{Name}, \$Param{TemplateTypeID} ],
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
            Message  => 'TemplateAdd() failed!',
        );
        return;
    }

    # trigger TemplateAddPost-Event
    $Self->EventHandler(
        Event => 'TemplateAddPost',
        Data  => {
            %Param,
            TemplateID => $TemplateID,
        },
        UserID => $Param{UserID},
    );

    # TODO: all attachments in the template should be copied
    # in the virtual fs. Otherwise it could happen that an
    # attachment is deleted after template creation and therefore
    # no longer available.

    return $TemplateID;
}

=item TemplateUpdate()

Update a template.

    my $Success = $TemplateObject->TemplateUpdate(
        TemplateID => 1234,
        Name       => 'The template name',          # (optional)
        Comment    => 'A comment',                  # (optional)
        Content  => '[{ ChangeAdd => { ... } }]',   # (optional) a serialized change, workorder, ...
        ValidID    => 1,                            # (optional)
        TypeID     => 1,                            # (optional)
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

    # trigger TemplateUpdatePre-Event
    $Self->EventHandler(
        Event => 'TemplateUpdatePre',
        Data  => {
            %Param,
        },
        UserID => $Param{UserID},
    );

    # get template data
    my $TemplateData = $Self->TemplateGet(
        TemplateID => $Param{TemplateID},
        UserID     => $Param{UserID},
    );

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
    for my $Attribute ( sort keys %Attribute ) {

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

    # trigger TemplateUpdatePost-Event
    $Self->EventHandler(
        Event => 'TemplateUpdatePost',
        Data  => {
            OldTemplateData => $TemplateData,
            %Param,
        },
        UserID => $Param{UserID},
    );

    # TODO: all attachments in the template should be copied
    # in the virtual fs. Otherwise it could happen that an
    # attachment is deleted after template creation and therefore
    # no longer available.

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
    $TemplateData{Content}
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
        SQL => 'SELECT ct.id, ct.name, comments, content, type_id, ctt.name, '
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
        $TemplateData{Content}    = $Row[3];
        $TemplateData{TypeID}     = $Row[4];
        $TemplateData{Type}       = $Row[5];
        $TemplateData{ValidID}    = $Row[6];
        $TemplateData{CreateTime} = $Row[7];
        $TemplateData{CreateBy}   = $Row[8];
        $TemplateData{ChangeTime} = $Row[9];
        $TemplateData{ChangeBy}   = $Row[10];
    }

    # check error
    if ( !%TemplateData ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "TemplateID $Param{TemplateID} does not exist!",
        );
        return;
    }

    # cleanup time stamps (some databases are using e. g. 2008-02-25 22:03:00.000000)
    TIMEFIELD:
    for my $Timefield ( 'CreateTime', 'ChangeTime', ) {
        next TIMEFIELD if !$TemplateData{$Timefield};
        $TemplateData{$Timefield}
            =~ s{ \A ( \d\d\d\d - \d\d - \d\d \s \d\d:\d\d:\d\d ) \. .+? \z }{$1}xms;
    }

    return \%TemplateData;
}

=item TemplateList()

return a hashref of all templates

    my $Templates = $TemplateObject->TemplateList(
        Valid          => 0,             # (optional) default 1 (0|1)
        CommentLength  => 15,            # (optional) default 0
        TemplateType   => 'ITSMChange'   # (optional) or TemplateType
        TemplateTypeID => 1,             # (optional) or TemplateTypeID
        UserID         => 1,
    );

returns

    $Templates = {
        1 => 'my template',
        3 => 'your template name',
    };

If parameter C<CommentLength> is passed, an excerpt (of the passed length)
of the comment is appended to the template name.
If the parameter C<TemplateType> or C<TemplateTypeID> is passed, then the
list of templates is restricted to the given type.

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

    # check that not both TemplateType and TemplateTypeID are given
    if ( $Param{TemplateType} && $Param{TemplateTypeID} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need either TemplateType OR TemplateTypeID - not both!',
        );
        return;
    }

    # when the template type is given, then look up the ID
    if ( $Param{TemplateType} ) {
        $Param{TemplateTypeID} = $Self->TemplateTypeLookup(
            TemplateType => $Param{TemplateType},
        );
    }

    # check valid param
    if ( !defined $Param{Valid} ) {
        $Param{Valid} = 1;
    }

    # define SQL statement
    my $SQL = 'SELECT id, name, comments FROM change_template ';
    my @SQLWhere;    # assemble the conditions used in the WHERE clause
    my @SQLBind;

    # restrict by template type
    if ( $Param{TemplateTypeID} ) {
        push @SQLWhere, "type_id = ?";
        push @SQLBind,  \$Param{TemplateTypeID};
    }

    # get only valid template ids
    if ( $Param{Valid} ) {

        my @ValidIDs = $Self->{ValidObject}->ValidIDsGet();
        my $ValidIDString = join ', ', @ValidIDs;

        push @SQLWhere, "valid_id IN ( $ValidIDString )";
    }

    # append the WHERE-clause
    if (@SQLWhere) {
        $SQL .= 'WHERE ';
        $SQL .= join ' AND ', map {"( $_ )"} @SQLWhere;
        $SQL .= ' ';
    }

    # prepare SQL statement
    return if !$Self->{DBObject}->Prepare(
        SQL  => $SQL,
        Bind => \@SQLBind,
    );

    # fetch the result
    my %Templates;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $Templates{ $Row[0] } = [ $Row[1], $Row[2] ];
    }

    for my $Key ( sort keys %Templates ) {
        my ( $Name, $Comment ) = @{ $Templates{$Key} };

        my $CommentAppend = '';
        if ( $Param{CommentLength} && $Comment ) {
            my $Length = $Param{CommentLength} > length $Comment
                ? length $Comment
                : $Param{CommentLength};
            my $Ellipsis = $Param{CommentLength} > length $Comment
                ? ''
                : '...';
            $Comment = substr $Comment, 0, $Length;
            $CommentAppend = ' (' . $Comment . $Ellipsis . ')';
        }

        $Templates{$Key} = $Name . $CommentAppend;
    }

    return \%Templates;
}

=item TemplateSearch()

Returns either a list, as an arrayref, or a count of found template ids.
The count of results is returned when the parameter C<Result => 'COUNT'> is passed.

The search criteria are logically AND connected.
When a list is passed as criterium, the individual members are OR connected.
When an undef or a reference to an empty array is passed, then the search criterium
is ignored.

    my $TemplateIDsRef = $TemplateObject->TemplateSearch(

        Name              => 'Sample template',                        # (optional)
        Comment           => 'just an example',                        # (optional)

        TemplateTypeIDs   => [ 11, 12 ],                               # (optional)
        TemplateTypes     => [ 'ITSMChange', 'CAB' ],                  # (optional)

        CreateBy          => [ 5, 2, 3 ],                              # (optional)
        ChangeBy          => [ 3, 2, 1 ],                              # (optional)

        # templates with created time after ...
        CreateTimeNewerDate       => '2006-01-09 00:00:01',            # (optional)
        # templates with created time before then ....
        CreateTimeOlderDate       => '2006-01-19 23:59:59',            # (optional)

        # templates with changed time after ...
        ChangeTimeNewerDate       => '2006-01-09 00:00:01',            # (optional)
        # templates with changed time before then ....
        ChangeTimeOlderDate       => '2006-01-19 23:59:59',            # (optional)

        OrderBy => [ 'TemplateID', 'Name' ],                           # (optional)
        # ignored when the result type is 'COUNT'
        # default: [ 'TemplateID' ],
        # (TemplateID, Name, Comment, TemplateTypeID,
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
        # default: ARRAY, returns an array of template ids
        # COUNT returns a scalar with the number of found templates

        Limit => 100,                                                  # (optional)
        # ignored when the result type is 'COUNT'

        UserID => 1,
    );

=cut

sub TemplateSearch {
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
        TemplateTypes
        TemplateTypeIDs
        CreateBy
        ChangeBy
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

    my @SQLWhere;    # assemble the conditions used in the WHERE clause

    # define order table
    my %OrderByTable = (
        TemplateID     => 't.id',
        Name           => 't.name',
        Comment        => 't.comments',
        TemplateTypeID => 't.type_id',
        ValidID        => 't.valid_id',
        CreateTime     => 't.create_time',
        CreateBy       => 't.create_by',
        ChangeTime     => 't.change_time',
        ChangeBy       => 't.change_by',
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

    # check whether the given TemplateTypeIDs are all valid
    return if !$Self->_CheckTemplateTypeIDs(
        TemplateTypeIDs => $Param{TemplateTypeIDs},
        UserID          => $Param{UserID},
    );

    # look up and thus check the TemplateTypes
    for my $Type ( @{ $Param{TemplateTypes} } ) {

        # get the ID for the name
        my $TypeID = $Self->TemplateTypeLookup(
            TemplateType => $Type,
        );

        # check whether the ID was found, whether the name exists
        if ( !$TypeID ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "The template type '$Type' is not known!",
            );
            return;
        }

        push @{ $Param{TemplateTypeIDs} }, $TypeID;
    }

    # add string params to the WHERE clause
    my %StringParams = (
        Name    => 't.name',
        Comment => 't.comments',
    );

    # add string params to sql-where-array
    STRINGPARAM:
    for my $StringParam ( sort keys %StringParams ) {

        # check string params for useful values, the string '0' is allowed
        next STRINGPARAM if !exists $Param{$StringParam};
        next STRINGPARAM if !defined $Param{$StringParam};
        next STRINGPARAM if $Param{$StringParam} eq '';

        # quote
        $Param{$StringParam} = $Self->{DBObject}->Quote( $Param{$StringParam} );

        # wildcards are used
        if ( $Param{UsingWildcards} ) {

            # get like escape string needed for some databases (e.g. oracle)
            my $LikeEscapeString = $Self->{DBObject}->GetDatabaseFunction('LikeEscapeString');

            # Quote
            $Param{$StringParam} = $Self->{DBObject}->Quote( $Param{$StringParam}, 'Like' );

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
    }

    # set array params
    my %ArrayParams = (
        TemplateTypeIDs => 't.type_id',
        CreateBy        => 't.create_by',
        ChangeBy        => 't.change_by',
    );

    # add array params to sql-where-array
    ARRAYPARAM:
    for my $ArrayParam ( sort keys %ArrayParams ) {

        # ignore empty lists
        next ARRAYPARAM if !@{ $Param{$ArrayParam} };

        # quote as integer
        for my $OneParam ( @{ $Param{$ArrayParam} } ) {
            $OneParam = $Self->{DBObject}->Quote( $OneParam, 'Integer' );
        }

        # create string
        my $InString = join ', ', @{ $Param{$ArrayParam} };

        push @SQLWhere, "$ArrayParams{$ArrayParam} IN ($InString)";
    }

    # check the time params and add them to the WHERE clause of the SELECT-Statement
    my %TimeParams = (
        CreateTimeNewerDate => 't.create_time >=',
        CreateTimeOlderDate => 't.create_time <=',
        ChangeTimeNewerDate => 't.change_time >=',
        ChangeTimeOlderDate => 't.change_time <=',
    );
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

        # quote
        $Param{$TimeParam} = $Self->{DBObject}->Quote( $Param{$TimeParam} );

        push @SQLWhere, "$TimeParams{$TimeParam} '$Param{$TimeParam}'";
    }

    # delete the OrderBy parameter when the result type is 'COUNT'
    if ( $Result eq 'COUNT' ) {
        $Param{OrderBy} = [];
    }

    # assemble the ORDER BY clause
    my @SQLOrderBy;
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
        push @SQLOrderBy, "$OrderByTable{$OrderBy} $Direction";
    }
    continue {
        $Count++;
    }

    # if there is a possibility that the ordering is not determined
    # we add an descending ordering by id
    if ( !grep { $_ eq 'TemplateID' } ( @{ $Param{OrderBy} } ) ) {
        push @SQLOrderBy, "$OrderByTable{TemplateID} DESC";
    }

    # assemble the SQL query
    my $SQL = 'SELECT t.id FROM change_template t ';

    # modify SQL when the result type is 'COUNT'.
    # There is no 'GROUP BY' SQL-clause, therefore COUNT(c.id) always give the wanted count
    if ( $Result eq 'COUNT' ) {
        $SQL        = 'SELECT COUNT(t.id) FROM change_template t ';
        @SQLOrderBy = ();
    }

    # add the WHERE clause
    if (@SQLWhere) {
        $SQL .= 'WHERE ';
        $SQL .= join ' AND ', map {"( $_ )"} @SQLWhere;
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
        $Param{Limit} = 1;
    }

    # ask database
    return if !$Self->{DBObject}->Prepare(
        SQL   => $SQL,
        Limit => $Param{Limit},
    );

    # fetch the result
    my @IDs;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        push @IDs, $Row[0];
    }

    # return the count as scalar
    return $IDs[0] if $Result eq 'COUNT';

    return \@IDs;
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

    # trigger TemplateDeletePre-Event
    $Self->EventHandler(
        Event => 'TemplateDeletePre',
        Data  => {
            %Param,
        },
        UserID => $Param{UserID},
    );

    # get template data
    my $TemplateData = $Self->TemplateGet(
        TemplateID => $Param{TemplateID},
        UserID     => $Param{UserID},
    );

    # delete template from database
    return if !$Self->{DBObject}->Do(
        SQL  => 'DELETE FROM change_template WHERE id = ?',
        Bind => [ \$Param{TemplateID} ],
    );

    # trigger TemplateDeletePost-Event
    $Self->EventHandler(
        Event => 'TemplateDeletePost',
        Data  => {
            OldTemplateData => $TemplateData,
            %Param,
        },
        UserID => $Param{UserID},
    );

    return 1;
}

=item TemplateTypeLookup()

Return the template type id when the template type name is passed.
Return the template type name when the template type id is passed.
When no template type id or template type name is found, then the
undefined value is returned.

    my $TypeID = $TemplateObject->TemplateTypeLookup(
        TemplateType => 'my template type name',
    );

    my $TxpeName = $TemplateObject->TemplateTypeLookup(
        TemplateTypeID => 42,
    );

=cut

sub TemplateTypeLookup {
    my ( $Self, %Param ) = @_;

    # the template type id or the template type name must be passed
    if ( !$Param{TemplateTypeID} && !$Param{TemplateType} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need the TemplateTypeID or the TemplateType!',
        );
        return;
    }

    # only one of template id and template name can be passed
    if ( $Param{TemplateTypeID} && $Param{TemplateType} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need either the TemplateType or the TemplateTemplateID, not both!',
        );
        return;
    }

    # get type id
    if ( $Param{TemplateType} ) {
        return if !$Self->{DBObject}->Prepare(
            SQL   => 'SELECT id FROM change_template_type WHERE name = ?',
            Bind  => [ \$Param{TemplateType} ],
            Limit => 1,
        );

        my $TypeID;
        while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
            $TypeID = $Row[0];
        }

        return $TypeID;
    }

    # get type name
    elsif ( $Param{TemplateTypeID} ) {

        return if !$Self->{DBObject}->Prepare(
            SQL   => 'SELECT name FROM change_template_type WHERE id = ?',
            Bind  => [ \$Param{TemplateTypeID} ],
            Limit => 1,
        );

        my $TypeName;
        while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
            $TypeName = $Row[0];
        }

        return $TypeName;
    }

    return;
}

=item TemplateSerialize()

This method is in fact a dispatcher for different template types.
Currently ITSMChangeManagement supports these template types:

ITSMChange
ITSMWorkOrder
CAB
ITSMCondition

The method returns a datastructure, serialized with Data::Dumper.

    my $ChangeTemplate = $TemplateObject->TemplateSerialize(
        TemplateType => 'ITSMChange',
        StateReset   => 1, # (optional) reset to default state
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
            TemplateTypeID => $Param{TemplateTypeID},
        );
    }

    # what types of templates are supported and what subroutines do the serialization
    my $BackendObject = $Self->_TemplateLoadBackend(
        Type => $TemplateType,
    );

    return if !$BackendObject;

    my $SerializedData = $BackendObject->Serialize(
        %Param,
    );

    return $SerializedData;
}

=item TemplateDeSerialize()

This method deserializes the template content. It returns the
ID of the "main" element that was created based on the template.

    my $ElementID = $TemplateObject->TemplateDeSerialize(
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
    my $VAR1;

    return if !eval "\$VAR1 = $TemplateContent; 1;";    ## no critic

    return if !$VAR1;
    return if ref $VAR1 ne 'HASH';

    # create entities defined by the template
    my %Info = $Self->_CreateTemplateElements(
        %Param,
        Template => $VAR1,
    );

    return $Info{ID};
}

=begin Internal:

=item _CreateTemplateElements()

This method dispatches the elements creation. It calls the subroutine
that belongs to the given type (e.g. ChangeAdd). After that it
invokes itself for all the childrens of the main element.

This method returns the ID of the main element.

    my $ElementID = $TemplateObject->_CreateTemplateElements(
        Template => {
            ChangeAdd => { ... },
            Children  => [
                {
                    WorkOrderAdd => { ... },
                    Children     => [ ... ],
                },
                {
                    WorkOrderAdd => { ... },
                    Children     => [ ... ],
                },
            ],
        },

        # any other parameters can follow
    )

=cut

sub _CreateTemplateElements {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(Template)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # get children
    my $Children = delete $Param{Template}->{Children};
    $Children ||= [];

    # dispatch table
    my %Method2Object = (
        ChangeAdd     => 'ITSMChange',
        WorkOrderAdd  => 'ITSMWorkOrder',
        CABAdd        => 'CAB',
        ConditionAdd  => 'ITSMCondition',
        AttachmentAdd => 'Parent',
        ExpressionAdd => 'Parent',
        ActionAdd     => 'Parent',
        LinkAdd       => 'Parent',
    );

    # get action
    my ( $Method, $Data ) = each %{ $Param{Template} };
    my $Type = $Method2Object{$Method};
    my $BackendObject;

    if ( $Type eq 'Parent' ) {
        $BackendObject = $Self->_TemplateLoadBackend(
            Type => $Param{Parent},
        );
    }
    else {
        $BackendObject = $Self->_TemplateLoadBackend(
            Type => $Type,
        );
    }

    return if !$BackendObject;

    # create parent element
    my %ParentReturn = $BackendObject->DeSerialize(
        %Param,
        Data   => $Data,
        Type   => $Type,
        Method => $Method,
    );

    return if !%ParentReturn;

    my %SiblingsInfo;

    # create child elements
    # prevent new number calculation for workorders,
    # as the original number will be used
    for my $Child ( @{$Children} ) {
        my %ChildInfo = $Self->_CreateTemplateElements(
            %Param,
            %SiblingsInfo,
            %ParentReturn,
            Template     => $Child,
            Parent       => $Type,
            Method       => $Method,
            NoNumberCalc => 1,
        );

        # save info for next sibling
        for my $Key ( sort keys %ChildInfo ) {
            $SiblingsInfo{$Key} = $ChildInfo{$Key};
        }
    }

    return %ParentReturn;
}

=item _CheckTemplateTypeIDs()

check whether the given template type ids are all valid

    my $Ok = $TemplateObject->_CheckTemplateTypeIDs(
        TemplateTypeIDs => [ 2, 500 ],
        UserID          => 1,
    );

=cut

sub _CheckTemplateTypeIDs {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(TemplateTypeIDs UserID)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    if ( ref $Param{TemplateTypeIDs} ne 'ARRAY' ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'The param TemplateTypeIDs must be an ARRAY reference!',
        );

        return;
    }

    # check if TemplateTypeIDs can be looked up
    for my $TypeID ( @{ $Param{TemplateTypeIDs} } ) {
        my $Type = $Self->TemplateTypeLookup(
            TemplateTypeID => $TypeID,
        );

        if ( !$Type ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "The type id $TypeID is not valid!",
            );

            return;
        }
    }

    return 1;
}

=item _TemplateLoadBackend()

Returns a newly loaded backend object

    my $BackendObject = $TemplateObject->_TemplateLoadBackend(
        Type => 'ITSMChange',
    );

=cut

sub _TemplateLoadBackend {
    my ( $Self, %Param ) = @_;

    if ( !$Param{Type} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need Type!',
        );
        return;
    }

    # define backend module name
    my $ModuleName = 'Kernel::System::ITSMChange::Template::' . $Param{Type};

    # load the backend module
    if ( !$Self->{MainObject}->Require($ModuleName) ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Can't load template backend module $Param{Type}!"
        );
        return;
    }

    # create new instance
    my $BackendObject = $ModuleName->new(
        %{$Self},
        %Param,
    );

    # check for backend object
    if ( !$BackendObject ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Can't create a new instance of template backend module $Param{Type}!",
        );
        return;
    }

    return $BackendObject;
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
