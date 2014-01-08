# --
# Kernel/System/FAQSearch.pm - all FAQ search functions
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::FAQSearch;

use strict;
use warnings;

=head1 NAME

Kernel::System::FAQSearch - FAQ search lib

=head1 SYNOPSIS

All FAQ search functions.

=over 4

=cut

=item FAQSearch()

search in FAQ articles

    my @IDs = $FAQObject->FAQSearch(

        Number    => '*134*',                                         # (optional)
        Title     => '*some title*',                                  # (optional)

        # is searching in Number, Title, Keyword and Field1-6
        What      => '*some text*',                                   # (optional)

        Keyword   => '*webserver*',                                   # (optional)
        States    => {                                                # (optional)
            1 => 'internal',
            2 => 'external',
        },
        LanguageIDs => [ 4, 5, 6 ],                                   # (optional)
        CategoryIDs => [ 7, 8, 9 ],                                   # (optional)
        ValidIDs    => [ 1, 2, 3 ],                                   # (optional) (default 1)

        # Approved
        #    Only available in internal interface (agent interface)
        Approved    => 1,                                             # (optional) 1 or 0,

        # Votes
        #   At least one operator must be specified. Operators will be connected with AND,
        #       values in an operator with OR.
        #   You can also pass more than one argument to an operator: [123, 654]
        Votes => {
            Equals            => 123,
            GreaterThan       => 123,
            GreaterThanEquals => 123,
            SmallerThan       => 123,
            SmallerThanEquals => 123,
        }

        # Rate
        #   At least one operator must be specified. Operators will be connected with AND,
        #       values in an operator with OR.
        #   You can also pass more than one argument to an operator: [50, 75]
        Rate => {
            Equals            => 75,
            GreaterThan       => 75,
            GreaterThanEquals => 75,
            SmallerThan       => 75,
            SmallerThanEquals => 75,
        }

        # create FAQ item properties (optional)
        CreatedUserIDs => [1, 12, 455, 32]

        # change FAQ item properties (optional)
        LastChangedUserIDs => [1, 12, 455, 32]

        # FAQ items created more than 60 minutes ago (item older than 60 minutes)  (optional)
        ItemCreateTimeOlderMinutes => 60,
        # FAQ item created less than 120 minutes ago (item newer than 120 minutes) (optional)
        ItemCreateTimeNewerMinutes => 120,

        # FAQ items with create time after ... (item newer than this date) (optional)
        ItemCreateTimeNewerDate => '2006-01-09 00:00:01',
        # FAQ items with created time before ... (item older than this date) (optional)
        ItemCreateTimeOlderDate => '2006-01-19 23:59:59',

        # FAQ items changed more than 60 minutes ago (optional)
        ItemChangeTimeOlderMinutes => 60,
        # FAQ items changed less than 120 minutes ago (optional)
        ItemChangeTimeNewerMinutes => 120,

        # FAQ item with changed time after ... (item changed newer than this date) (optional)
        ItemChangeTimeNewerDate => '2006-01-09 00:00:01',
        # FAQ item with changed time before ... (item changed older than this date) (optional)
        ItemChangeTimeOlderDate => '2006-01-19 23:59:59',

        OrderBy => [ 'FAQID', 'Title' ],                              # (optional)
        # default: [ 'FAQID' ],
        # (FAQID, Number, Title, Language, Category, Valid, Created,
        # Changed, State, Votes, Result)

        # Additional information for OrderBy:
        # The OrderByDirection can be specified for each OrderBy attribute.
        # The pairing is made by the array indexes.

        OrderByDirection => [ 'Down', 'Up' ],                         # (optional)
        # default: [ 'Down' ]
        # (Down | Up)

        Limit     => 150,

        Interface => {              # (default internal)
            StateID => 3,
            Name    => 'public',    # public|external|internal
        },
        UserID    => 1,
    );

Returns:

    @IDs = (
        32,
        13,
        12,
        9,
        6,
        5,
        4,
        1,
    );

=cut

sub FAQSearch {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{UserID} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Need UserID!",
        );
        return;
    }

    # set default interface
    if ( !$Param{Interface} || !$Param{Interface}->{Name} ) {
        $Param{Interface}->{Name} = 'internal';
    }

    # verify that all passed array parameters contain an arrayref
    ARGUMENT:
    for my $Argument (qw(OrderBy OrderByDirection)) {

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

    # define order table
    my %OrderByTable = (

        # FAQ item attributes
        FAQID    => 'i.id',
        Number   => 'i.f_number',
        Title    => 'i.f_subject',
        Language => 'i.f_language_id',
        Category => 'i.category_id',
        Valid    => 'i.valid_id',
        Created  => 'i.created',
        Changed  => 'i.changed',

        # State attributes
        State => 's.name',

        # Vote attributes
        Votes  => 'votes',
        Result => 'vrate',
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
    if ( !grep { $_ eq 'FAQID' } ( @{ $Param{OrderBy} } ) ) {
        push @SQLOrderBy, "$OrderByTable{FAQID} DESC";
    }

    # sql
    my $SQL = 'SELECT i.id, count( v.item_id ) as votes, avg( v.rate ) as vrate '
        . 'FROM faq_item i '
        . 'LEFT JOIN faq_voting v ON v.item_id = i.id '
        . 'LEFT JOIN faq_state s ON s.id = i.state_id';

    # extended SQL
    my $Ext = '';

    # fulltext search
    if ( $Param{What} && $Param{What} ne '*' ) {

        # define the search fields for fulltext search
        my @SearchFields = ( 'i.f_number', 'i.f_subject', 'i.f_keywords' );

        # used from the agent interface (internal)
        if ( $Param{Interface}->{Name} eq 'internal' ) {

            for my $Number ( 1 .. 6 ) {

                # get the state of the field (internal, external, public)
                my $FieldState = $Self->{ConfigObject}->Get( 'FAQ::Item::Field' . $Number )->{Show};

                # add all internal, external and public fields
                if (
                    $FieldState eq 'internal'
                    || $FieldState eq 'external'
                    || $FieldState eq 'public'
                    )
                {
                    push @SearchFields, 'i.f_field' . $Number;
                }
            }
        }

        # used from the customer interface (external)
        elsif ( $Param{Interface}->{Name} eq 'external' ) {

            for my $Number ( 1 .. 6 ) {

                # get the state of the field (internal, external, public)
                my $FieldState = $Self->{ConfigObject}->Get( 'FAQ::Item::Field' . $Number )->{Show};

                # add all external and public fields
                if ( $FieldState eq 'external' || $FieldState eq 'public' ) {
                    push @SearchFields, 'i.f_field' . $Number;
                }
            }
        }

        # used from the public interface (public)
        else {
            for my $Number ( 1 .. 6 ) {

                # get the state of the field (internal, external, public)
                my $FieldState = $Self->{ConfigObject}->Get( 'FAQ::Item::Field' . $Number )->{Show};

                # add all public fields
                if ( $FieldState eq 'public' ) {
                    push @SearchFields, 'i.f_field' . $Number;
                }
            }
        }

        # add the SQL for the fulltext search
        $Ext .= $Self->{DBObject}->QueryCondition(
            Key          => \@SearchFields,
            Value        => $Param{What},
            SearchPrefix => '*',
            SearchSuffix => '*',
        );
    }

    # search for the number
    if ( $Param{Number} ) {
        $Param{Number} =~ s/\*/%/g;
        $Param{Number} =~ s/%%/%/g;
        $Param{Number} = $Self->{DBObject}->Quote( $Param{Number}, 'Like' );
        if ($Ext) {
            $Ext .= ' AND';
        }
        $Ext .= " LOWER(i.f_number) LIKE LOWER('" . $Param{Number} . "') $Self->{LikeEscapeString}";
    }

    # search for the title
    if ( $Param{Title} ) {
        $Param{Title} = "\%$Param{Title}\%";
        $Param{Title} =~ s/\*/%/g;
        $Param{Title} =~ s/%%/%/g;
        $Param{Title} = $Self->{DBObject}->Quote( $Param{Title}, 'Like' );
        if ($Ext) {
            $Ext .= ' AND';
        }
        $Ext .= " LOWER(i.f_subject) LIKE LOWER('" . $Param{Title} . "') $Self->{LikeEscapeString}";
    }

    # search for languages
    if ( $Param{LanguageIDs} && ref $Param{LanguageIDs} eq 'ARRAY' && @{ $Param{LanguageIDs} } ) {

        my $InString = $Self->_InConditionGet(
            TableColumn => 'i.f_language_id',
            IDRef       => $Param{LanguageIDs},
        );

        if ($Ext) {
            $Ext .= ' AND';
        }
        $Ext .= $InString;
    }

    # search for categories
    if ( $Param{CategoryIDs} && ref $Param{CategoryIDs} eq 'ARRAY' && @{ $Param{CategoryIDs} } ) {

        my $InString = $Self->_InConditionGet(
            TableColumn => 'i.category_id',
            IDRef       => $Param{CategoryIDs},
        );

        if ($Ext) {
            $Ext .= ' AND';
        }
        $Ext .= $InString;
    }

    # set default value for ValidIDs (only search for valid FAQs)
    if ( !defined $Param{ValidIDs} ) {

        # get the valid ids
        my @ValidIDs = $Self->{ValidObject}->ValidIDsGet();

        $Param{ValidIDs} = \@ValidIDs;
    }

    # search for ValidIDs
    if ( $Param{ValidIDs} && ref $Param{ValidIDs} eq 'ARRAY' && @{ $Param{ValidIDs} } ) {

        my $InString = $Self->_InConditionGet(
            TableColumn => 'i.valid_id',
            IDRef       => $Param{ValidIDs},
        );

        if ($Ext) {
            $Ext .= ' AND';
        }
        $Ext .= $InString;
    }

    # search for states
    if ( $Param{States} && ref $Param{States} eq 'HASH' && %{ $Param{States} } ) {

        my @States = map {$_} keys %{ $Param{States} };

        my $InString = $Self->_InConditionGet(
            TableColumn => 's.type_id',
            IDRef       => \@States,
        );

        if ($Ext) {
            $Ext .= ' AND';
        }
        $Ext .= $InString;
    }

    # search for keywords
    if ( $Param{Keyword} ) {
        if ($Ext) {
            $Ext .= ' AND';
        }
        $Param{Keyword} = "\%$Param{Keyword}\%";
        $Param{Keyword} =~ s/\*/%/g;
        $Param{Keyword} =~ s/%%/%/g;
        $Param{Keyword} = $Self->{DBObject}->Quote( $Param{Keyword}, 'Like' );

        if ( $Self->{DBObject}->GetDatabaseFunction('NoLowerInLargeText') ) {
            $Ext .= " i.f_keywords LIKE '" . $Param{Keyword} . "' $Self->{LikeEscapeString}";
        }
        elsif ( $Self->{DBObject}->GetDatabaseFunction('LcaseLikeInLargeText') ) {
            $Ext
                .= " LCASE(i.f_keywords) LIKE LCASE('"
                . $Param{Keyword}
                . "') $Self->{LikeEscapeString}";
        }
        else {
            $Ext
                .= " LOWER(i.f_keywords) LIKE LOWER('"
                . $Param{Keyword}
                . "') $Self->{LikeEscapeString}";
        }
    }

    # show only approved faq articles for public and customer interface
    if ( $Param{Interface}->{Name} eq 'public' || $Param{Interface}->{Name} eq 'external' ) {
        if ($Ext) {
            $Ext .= ' AND';
        }
        $Ext .= ' i.approved = 1';
    }

    # otherwise check if need to search for approved status
    elsif ( defined $Param{Approved} ) {
        my $ApprovedValue = $Param{Approved} ? 1 : 0;
        if ($Ext) {
            $Ext .= ' AND';
        }
        $Ext .= " i.approved = $ApprovedValue";
    }

    # search for create users
    if (
        $Param{CreatedUserIDs}
        && ref $Param{CreatedUserIDs} eq 'ARRAY'
        && @{ $Param{CreatedUserIDs} }
        )
    {

        my $InString = $Self->_InConditionGet(
            TableColumn => 'i.created_by',
            IDRef       => $Param{CreatedUserIDs},
        );

        if ($Ext) {
            $Ext .= ' AND';
        }
        $Ext .= $InString;
    }

    # search for last change users
    if (
        $Param{LastChangedUserIDs}
        && ref $Param{LastChangedUserIDs} eq 'ARRAY'
        && @{ $Param{LastChangedUserIDs} }
        )
    {

        my $InString = $Self->_InConditionGet(
            TableColumn => 'i.changed_by',
            IDRef       => $Param{LastChangedUserIDs},
        );

        if ($Ext) {
            $Ext .= ' AND';
        }
        $Ext .= $InString;
    }

    # search for create and change times
    # remember current time to prevent searches for future timestamps
    my $CurrentSystemTime = $Self->{TimeObject}->SystemTime();

    # get FAQ items created older than x minutes
    if ( defined $Param{ItemCreateTimeOlderMinutes} ) {

        $Param{ItemCreateTimeOlderMinutes} ||= 0;

        my $TimeStamp = $Self->{TimeObject}->SystemTime();
        $TimeStamp -= ( $Param{ItemCreateTimeOlderMinutes} * 60 );

        $Param{ItemCreateTimeOlderDate} = $Self->{TimeObject}->SystemTime2TimeStamp(
            SystemTime => $TimeStamp,
        );
    }

    # get FAQ items created newer than x minutes
    if ( defined $Param{ItemCreateTimeNewerMinutes} ) {

        $Param{ItemCreateTimeNewerMinutes} ||= 0;

        my $TimeStamp = $Self->{TimeObject}->SystemTime();
        $TimeStamp -= ( $Param{ItemCreateTimeNewerMinutes} * 60 );

        $Param{ItemCreateTimeNewerDate} = $Self->{TimeObject}->SystemTime2TimeStamp(
            SystemTime => $TimeStamp,
        );
    }

    # get FAQ items created older than xxxx-xx-xx xx:xx date
    my $CompareCreateTimeOlderNewerDate;
    if ( $Param{ItemCreateTimeOlderDate} ) {

        # check time format
        if (
            $Param{ItemCreateTimeOlderDate}
            !~ /\d\d\d\d-(\d\d|\d)-(\d\d|\d) (\d\d|\d):(\d\d|\d):(\d\d|\d)/
            )
        {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Invalid time format '$Param{ItemCreateTimeOlderDate}'!",
            );
            return;
        }
        my $Time = $Self->{TimeObject}->TimeStamp2SystemTime(
            String => $Param{ItemCreateTimeOlderDate},
        );
        if ( !$Time ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message =>
                    "Search not executed due to invalid time '"
                    . $Param{ItemCreateTimeOlderDate} . "'!",
            );
            return;
        }
        $CompareCreateTimeOlderNewerDate = $Time;

        $Ext .= " AND i.created <= '"
            . $Self->{DBObject}->Quote( $Param{ItemCreateTimeOlderDate} ) . "'";
    }

    # get Items changed newer than xxxx-xx-xx xx:xx date
    if ( $Param{ItemCreateTimeNewerDate} ) {
        if (
            $Param{ItemCreateTimeNewerDate}
            !~ /\d\d\d\d-(\d\d|\d)-(\d\d|\d) (\d\d|\d):(\d\d|\d):(\d\d|\d)/
            )
        {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Invalid time format '$Param{ItemCreateTimeNewerDate}'!",
            );
            return;
        }
        my $Time = $Self->{TimeObject}->TimeStamp2SystemTime(
            String => $Param{ItemCreateTimeNewerDate},
        );
        if ( !$Time ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message =>
                    "Search not executed due to invalid time '"
                    . $Param{ItemCreateTimeNewerDate} . "'!",
            );
            return;
        }

        # don't execute queries if newer date is after current date
        return if $Time > $CurrentSystemTime;

        # don't execute queries if older/newer date restriction show now valid timeframe
        return if $CompareCreateTimeOlderNewerDate && $Time > $CompareCreateTimeOlderNewerDate;

        $Ext .= " AND i.created >= '"
            . $Self->{DBObject}->Quote( $Param{ItemCreateTimeNewerDate} ) . "'";
    }

    # get FAQ items changed older than x minutes
    if ( defined $Param{ItemChangeTimeOlderMinutes} ) {

        $Param{ItemChangeTimeOlderMinutes} ||= 0;

        my $TimeStamp = $Self->{TimeObject}->SystemTime();
        $TimeStamp -= ( $Param{ItemChangeTimeOlderMinutes} * 60 );

        $Param{ItemChangeTimeOlderDate} = $Self->{TimeObject}->SystemTime2TimeStamp(
            SystemTime => $TimeStamp,
        );
    }

    # get FAQ items changed newer than x minutes
    if ( defined $Param{ItemChangeTimeNewerMinutes} ) {

        $Param{ItemChangeTimeNewerMinutes} ||= 0;

        my $TimeStamp = $Self->{TimeObject}->SystemTime();
        $TimeStamp -= ( $Param{ItemChangeTimeNewerMinutes} * 60 );

        $Param{ItemChangeTimeNewerDate} = $Self->{TimeObject}->SystemTime2TimeStamp(
            SystemTime => $TimeStamp,
        );
    }

    # get FAQ items changed older than xxxx-xx-xx xx:xx date
    my $CompareChangeTimeOlderNewerDate;
    if ( $Param{ItemChangeTimeOlderDate} ) {

        # check time format
        if (
            $Param{ItemChangeTimeOlderDate}
            !~ /\d\d\d\d-(\d\d|\d)-(\d\d|\d) (\d\d|\d):(\d\d|\d):(\d\d|\d)/
            )
        {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Invalid time format '$Param{ItemChangeTimeOlderDate}'!",
            );
            return;
        }
        my $Time = $Self->{TimeObject}->TimeStamp2SystemTime(
            String => $Param{ItemChangeTimeOlderDate},
        );
        if ( !$Time ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message =>
                    "Search not executed due to invalid time '"
                    . $Param{ItemChangeTimeOlderDate} . "'!",
            );
            return;
        }
        $CompareChangeTimeOlderNewerDate = $Time;

        $Ext .= " AND i.changed <= '"
            . $Self->{DBObject}->Quote( $Param{ItemChangeTimeOlderDate} ) . "'";
    }

    # get Items changed newer than xxxx-xx-xx xx:xx date
    if ( $Param{ItemChangeTimeNewerDate} ) {
        if (
            $Param{ItemChangeTimeNewerDate}
            !~ /\d\d\d\d-(\d\d|\d)-(\d\d|\d) (\d\d|\d):(\d\d|\d):(\d\d|\d)/
            )
        {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Invalid time format '$Param{ItemChangeTimeNewerDate}'!",
            );
            return;
        }
        my $Time = $Self->{TimeObject}->TimeStamp2SystemTime(
            String => $Param{ItemChangeTimeNewerDate},
        );
        if ( !$Time ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message =>
                    "Search not executed due to invalid time '"
                    . $Param{ItemChangeTimeNewerDate} . "'!",
            );
            return;
        }

        # don't execute queries if newer date is after current date
        return if $Time > $CurrentSystemTime;

        # don't execute queries if older/newer date restriction show now valid timeframe
        return if $CompareChangeTimeOlderNewerDate && $Time > $CompareChangeTimeOlderNewerDate;

        $Ext .= " AND i.changed >= '"
            . $Self->{DBObject}->Quote( $Param{ItemChangeTimeNewerDate} ) . "'";
    }

    # add WHERE statement
    if ($Ext) {
        $Ext = ' WHERE ' . $Ext;
    }

    # add GROUP BY
    $Ext
        .= ' GROUP BY i.id, i.f_subject, i.f_language_id, i.created, i.changed, s.name, v.item_id ';

    # add HAVING clause ( Votes and Rate are agreggated columns, they can't be in the WHERE clause)
    # defined voting parameters (for Votes and Rate)
    my %VotingOperators = (
        Equals            => '=',
        GreaterThan       => '>',
        GreaterThanEquals => '>=',
        SmallerThan       => '<',
        SmallerThanEquals => '<=',
    );

    my $HavingPrint;
    my $AddedCondition;

    HAVING_PARAM:
    for my $HavingParam (qw(Votes Rate)) {
        my $SearchParam = $Param{$HavingParam};

        next HAVING_PARAM if ( !$SearchParam );
        next HAVING_PARAM if ( ref $SearchParam ne 'HASH' );

        OPERATOR:
        for my $Operator ( sort keys %{$SearchParam} ) {

            next OPERATOR if !( $VotingOperators{$Operator} );

            # print HAVING clause just once if and just if the operator is valid
            if ( !$HavingPrint ) {
                $Ext .= ' HAVING ';
                $HavingPrint = 1;
            }

            my $SQLExtSub;

            my @SearchParams
                = ( ref $SearchParam->{$Operator} eq 'ARRAY' )
                ? @{ $SearchParam->{$Operator} }
                : ( $SearchParam->{$Operator} );

            # do not use AND on the first condition
            if ($AddedCondition) {
                $SQLExtSub .= ' AND (';
            }
            else {
                $SQLExtSub .= ' (';
            }
            my $Counter = 0;
            TEXT:
            for my $Text (@SearchParams) {
                next TEXT if ( !defined $Text || $Text eq '' );

                $Text =~ s/\*/%/gi;

                # check search attribute, we do not need to search for *
                next if $Text =~ /^\%{1,3}$/;

                $SQLExtSub .= ' OR ' if ($Counter);

                # define aggregation column
                my $AggregateColumn = 'count( v.item_id )';
                if ( $HavingParam eq 'Rate' ) {
                    $AggregateColumn = 'avg( v.rate )';
                }

                # set condition
                $SQLExtSub .= " $AggregateColumn $VotingOperators{$Operator} ";
                $SQLExtSub .= $Self->{DBObject}->Quote( $Text, 'Number' ) . " ";

                $Counter++;
            }

            # close condition
            $SQLExtSub .= ') ';

            # add condition to the final SQL statement
            if ($Counter) {
                $Ext .= $SQLExtSub;
                $AddedCondition = 1;
            }
        }
    }

    # add the ORDER BY clause
    if (@SQLOrderBy) {
        $Ext .= 'ORDER BY ';
        $Ext .= join ', ', @SQLOrderBy;
        $Ext .= ' ';
    }

    # add extended SQL
    $SQL .= $Ext;

    # ask database
    return if !$Self->{DBObject}->Prepare(
        SQL => $SQL,
        Limit => $Param{Limit} || 500
    );

    # fetch the result
    my @List;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        push @List, $Row[0];
    }

    return @List;
}

=begin Internal:

=cut

=item _InConditionGet()

internal function to create an

    table.column IN (values)

condition string from an array.

    my $SQLPart = $TicketObject->_InConditionGet(
        TableColumn => 'table.column',
        IDRef       => $ArrayRef,
    );

=cut

sub _InConditionGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Key (qw(TableColumn IDRef)) {
        if ( !$Param{$Key} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Key!",
            );
            return;
        }
    }

    # sort ids to cache the SQL query
    my @SortedIDs = sort { $a <=> $b } @{ $Param{IDRef} };

    # quote values
    for my $Value (@SortedIDs) {
        return if !defined $Self->{DBObject}->Quote( $Value, 'Integer' );
    }

    return " $Param{TableColumn} IN (" . ( join ',', @SortedIDs ) . ")";
}

1;

=end Internal:

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (http://otrs.org/).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
