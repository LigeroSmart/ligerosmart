# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::Stats::Dynamic::SurveyList;

use strict;
use warnings;

use List::Util qw( first );

use Kernel::System::VariableCheck qw(:all);
use Kernel::Language qw(Translatable);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::Language',
    'Kernel::System::DB',
    'Kernel::System::DynamicField',
    'Kernel::System::DynamicField::Backend',
    'Kernel::System::Lock',
    'Kernel::System::Log',
    'Kernel::System::Queue',
    'Kernel::System::Service',
    'Kernel::System::SLA',
    'Kernel::System::Stats',
    'Kernel::System::Ticket',
    'Kernel::System::Type',
    'Kernel::System::User',
    'Kernel::System::HTMLUtils',
    'Kernel::System::Survey',
);

sub new {
    my ( $Type, %Param ) = @_;

    # Allocate new hash for object.
    my $Self = {};
    bless( $Self, $Type );

    # Get the dynamic fields for ticket object.
    $Self->{DynamicField} = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldListGet(
        Valid      => 1,
        ObjectType => ['Ticket'],
    );

    return $Self;
}

sub GetObjectName {
    my ( $Self, %Param ) = @_;

    return 'SurveyList';
}

sub GetObjectBehaviours {
    my ( $Self, %Param ) = @_;

    my %Behaviours = (
        ProvidesDashboardWidget => 0,
    );

    return %Behaviours;
}

sub GetObjectAttributes {
    my ( $Self, %Param ) = @_;

    # Get needed objects.
    my $LockObject   = $Kernel::OM->Get('Kernel::System::Lock');
    my $SurveyObject = $Kernel::OM->Get('Kernel::System::Survey');

    my %Limit = (
        5         => 5,
        10        => 10,
        20        => 20,
        50        => 50,
        100       => 100,
        unlimited => Translatable('unlimited'),
    );

    # Get Survey List.
    my %SurveyList = $SurveyObject->SurveyList();

    my %SurveyAttributes = %{ $Self->_SurveyAttributes() };
    my %OrderBy          = map { $_ => $SurveyAttributes{$_} } grep { $_ ne 'Number' } keys %SurveyAttributes;

    # Get dynamic field backend object.
    my $DynamicFieldBackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

    # Remove non sortable (and orderable) Dynamic Fields.
    DYNAMICFIELD:
    for my $DynamicFieldConfig ( @{ $Self->{DynamicField} } ) {
        next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);
        next DYNAMICFIELD if !$DynamicFieldConfig->{Name};

        # Check if dynamic field is sortable.
        my $IsSortable = $DynamicFieldBackendObject->HasBehavior(
            DynamicFieldConfig => $DynamicFieldConfig,
            Behavior           => 'IsSortable',
        );

        # Remove dynamic fields from the list if is not sortable.
        if ( !$IsSortable ) {
            delete $OrderBy{ 'DynamicField_' . $DynamicFieldConfig->{Name} };
        }
    }

    my %SortSequence = (
        Up   => Translatable('ascending'),
        Down => Translatable('descending'),
    );

    my @ObjectAttributes = (
        {
            Name             => Translatable('Attributes to be printed'),
            UseAsXvalue      => 1,
            UseAsValueSeries => 0,
            UseAsRestriction => 0,
            Element          => 'SurveyAttributes',
            Block            => 'MultiSelectField',
            Translation      => 1,
            Values           => \%SurveyAttributes,
            Sort             => 'IndividualKey',
            SortIndividual   => $Self->_SortedAttributes(),

        },
        {
            Name             => Translatable('Sort sequence'),
            UseAsXvalue      => 0,
            UseAsValueSeries => 1,
            UseAsRestriction => 0,
            Element          => 'SortSequence',
            Block            => 'SelectField',
            Translation      => 1,
            Values           => \%SortSequence,
        },
        {
            Name             => Translatable('Limit'),
            UseAsXvalue      => 0,
            UseAsValueSeries => 0,
            UseAsRestriction => 1,
            Element          => 'Limit',
            Block            => 'SelectField',
            Translation      => 1,
            Values           => \%Limit,
            Sort             => 'IndividualKey',
            SortIndividual   => [ '5', '10', '20', '50', '100', 'unlimited', ],
        },
        {
            Name             => Translatable('Close Time'),
            UseAsXvalue      => 0,
            UseAsValueSeries => 0,
            UseAsRestriction => 1,
            Element          => 'CloseTime',
            TimePeriodFormat => 'DateInputFormat',
            Block            => 'Time',
            Values           => {
                TimeStart => 'TicketCloseTimeNewerDate',
                TimeStop  => 'TicketCloseTimeOlderDate',
            },
        },
        {
            Name             => Translatable('Create Time'),
            UseAsXvalue      => 0,
            UseAsValueSeries => 0,
            UseAsRestriction => 1,
            Element          => 'CreateTime',
            TimePeriodFormat => 'DateInputFormat',
            Block            => 'Time',
            Values           => {
                TimeStart => 'TicketCreateTimeNewerDate',
                TimeStop  => 'TicketCreateTimeOlderDate',
            },
        },
        {
            Name             => Translatable('Send Time'),
            UseAsXvalue      => 0,
            UseAsValueSeries => 0,
            UseAsRestriction => 1,
            Element          => 'SendTime',
            TimePeriodFormat => 'DateInputFormat',
            Block            => 'Time',
            Values           => {
                TimeStart => 'RequestSendTimeNewerDate',
                TimeStop  => 'RequestSendTimeOlderDate',
            },
        },
        {
            Name             => Translatable('Vote Time'),
            UseAsXvalue      => 0,
            UseAsValueSeries => 0,
            UseAsRestriction => 1,
            Element          => 'VoteTime',
            TimePeriodFormat => 'DateInputFormat',
            Block            => 'Time',
            Values           => {
                TimeStart => 'RequestVoteTimeNewerDate',
                TimeStop  => 'RequestVoteTimeOlderDate',
            },
        },
        {
            Name             => Translatable('Survey List'),
            UseAsXvalue      => 0,
            UseAsValueSeries => 0,
            UseAsRestriction => 1,
            Element          => 'SurveyIDs',
            Block            => 'SelectField',
            Values           => \%SurveyList,
        },

    );

    return @ObjectAttributes;
}

sub GetStatTablePreview {
    my ( $Self, %Param ) = @_;

    return $Self->GetStatTable(
        %Param,
        Preview => 1,
    );
}

sub GetStatTable {
    my ( $Self, %Param ) = @_;
    my %SurveyAttributes    = map { $_ => 1 } @{ $Param{XValue}->{SelectedValues} };
    my $SortedAttributesRef = $Self->_SortedAttributes();
    my $Preview             = $Param{Preview};

    # Get needed objects.
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');
    my $SurveyObject = $Kernel::OM->Get('Kernel::System::Survey');

    # Check if a enumeration is requested.
    my $AddEnumeration = 0;
    if ( $SurveyAttributes{Number} ) {
        $AddEnumeration = 1;
        delete $SurveyAttributes{Number};
    }

    # Set default values if no sort or order attribute is given.
    my $SortRef = first { $_->{Element} eq 'SortSequence' } @{ $Param{ValueSeries} };
    my $Sort    = $SortRef ? $SortRef->{SelectedValues}->[0] : 'Down';
    my $Limit   = $Param{Restrictions}->{Limit};

    $Param{Restrictions}->{Limit} = $Limit || 100_000_000;

    # Find out if the extended version of TicketGet is needed.
    my $Extended = $Self->_ExtendedAttributesCheck(
        SurveyAttributes => \%SurveyAttributes,
    );

    # Find out if dynamic fields are required.
    my $NeedDynamicFields = 0;
    DYNAMICFIELDSNEEDED:
    for my $ParameterName ( sort keys %SurveyAttributes ) {
        if ( $ParameterName =~ m{\A DynamicField_ }xms ) {
            $NeedDynamicFields = 1;
            last DYNAMICFIELDSNEEDED;
        }
    }

    # Get involved Tickets.
    my @TicketIDs;
    if ($Preview) {
        @TicketIDs = $TicketObject->TicketSearch(
            UserID     => 1,
            Result     => 'ARRAY',
            Permission => 'ro',
            Limit      => 10,
        );
    }
    else {
        @TicketIDs = $TicketObject->TicketSearch(
            UserID     => 1,
            Result     => 'ARRAY',
            Permission => 'ro',
            %{ $Param{Restrictions} },
        );
    }

    # Create lookup hash for TicketIDs due to performance reasons.
    my %TicketIDs = map { $_ => 1 } @TicketIDs;

    # Get the survey data.
    my @SurveyIDs;
    my @StatArray;

    if ($Preview) {

        @SurveyIDs = $SurveyObject->SurveySearch(
            UserID => 1,
            Limit  => 10,
        );
    }
    else {

        @SurveyIDs = $SurveyObject->SurveySearch(
            UserID => 1,
            %{ $Param{Restrictions} },
        );
    }

    # Get needed data and create lookup tables.
    my %SurveyRawData;
    my %Questions;

    my $StatsObject = $Kernel::OM->Get('Kernel::System::Stats');

    SURVEYID:
    for my $SurveyID (@SurveyIDs) {

        # Check survey restriction.
        # Can't done by SurveySearch.
        next SURVEYID if $Param{Restrictions}->{SurveyIDs} && $Param{Restrictions}->{SurveyIDs} ne $SurveyID;

        # Survey raw data.
        my %SurveyRaw = $SurveyObject->SurveyGet(
            SurveyID => $SurveyID,
        );

        $SurveyRawData{$SurveyID} = \%SurveyRaw;

        # Question data.
        my @QuestionsList = $SurveyObject->QuestionList(
            SurveyID => $SurveyID,
        );

        $Questions{$SurveyID} = \@QuestionsList;

        # Get public survey keys.
        my $PublicSurveyKeys;
        if ($Preview) {
            $PublicSurveyKeys = $SurveyObject->PublicSurveyKeyGet(
                SurveyID => $SurveyID,
                Limit    => 10,
            );
        }
        else {
            $PublicSurveyKeys = $SurveyObject->PublicSurveyKeyGet(
                SurveyID => $SurveyID,
            );
        }

        # Get request.
        PUBLICKEY:
        for my $PublicKey ( @{$PublicSurveyKeys} ) {

            my %SurveyRequest = $SurveyObject->RequestGet(
                PublicSurveyKey => $PublicKey,
                %{ $Param{Restrictions} },
            );

            # Skip if no survey request data found (e.g. send time filter).
            next PUBLICKEY if !IsHashRefWithData( \%SurveyRequest );

            # Skip if ticket specific filters are set.
            next PUBLICKEY if !$TicketIDs{ $SurveyRequest{TicketID} };

            # Get all votes for this request.
            my @RequestVoteList = $SurveyObject->VoteGetAll(
                RequestID => $SurveyRequest{RequestID},
            );

            my @Questions;

            # Loop through vote data to merge votes into survey request hash.
            VOTEDATA:
            for my $VoteData (@RequestVoteList) {

                my $Question     = $VoteData->{Question};
                my $QuestionID   = $VoteData->{QuestionID};
                my $QuestionType = $VoteData->{QuestionType};
                my $VoteValue    = $VoteData->{VoteValue};

                if (
                    $QuestionType eq 'NPS'
                    || $QuestionType eq 'Radio'
                    || $QuestionType eq 'Checkbox'
                    )
                {
                    my %Answer = $SurveyObject->AnswerGet(
                        AnswerID => $VoteValue,
                    );

                    if ( $QuestionType eq 'Checkbox' ) {

                        my $CountAnswer = $SurveyObject->AnswerCount(
                            QuestionID => $QuestionID,
                        );

                        # If we have only one answer use Checked.
                        if ( $CountAnswer == 1 ) {
                            $Answer{Answer} = Translatable('Checked');
                        }
                    }

                    if ( $SurveyRequest{$Question} ) {

                        $SurveyRequest{$Question} .= $Answer{Answer} . "\n";
                    }
                    else {

                        $SurveyRequest{$Question} = $Answer{Answer};
                    }
                }
                elsif ( $QuestionType eq 'YesNo' || $QuestionType eq 'Textarea' ) {

                    if ( $QuestionType eq 'Textarea' ) {

                        $VoteValue =~ s{ \A \$html\/text\$ \s* (.*) }{$1}xms;
                        $VoteValue = $Kernel::OM->Get('Kernel::System::HTMLUtils')->ToAscii(
                            String => $VoteValue,
                        );
                    }

                    $SurveyRequest{$Question} = $VoteValue;
                }
            }

            # Get question list.
            my $QuestionsList = $Questions{ $SurveyRequest{SurveyID} };
            for my $Question ( @{$QuestionsList} ) {

                # Push questions into array for later use.
                push @Questions, $Question->{Question};

                # Default value.
                if ( !defined $SurveyRequest{ $Question->{Question} } ) {

                    $SurveyRequest{ $Question->{Question} } = " ";
                }
            }

            my @ResultRow;
            my %Ticket = $TicketObject->TicketGet(
                TicketID      => $SurveyRequest{TicketID},
                UserID        => 1,
                Extended      => $Extended,
                DynamicFields => $NeedDynamicFields,
            );

            # Merge ticket and survey request data.
            my %SurveyData = ( %SurveyRequest, %Ticket );

            # Merge SurveyTitle into SurveyData.
            $SurveyData{SurveyTitle} = $SurveyRawData{$SurveyID}->{Title};

            ATTRIBUTE:
            for my $Attribute ( @{$SortedAttributesRef} ) {
                next ATTRIBUTE if !$SurveyAttributes{$Attribute};

                # Clean SurveyData.
                if ( !$SurveyData{$Attribute} ) {
                    $SurveyData{$Attribute} = '';
                }

                if (
                    $Param{TimeZone}
                    && $SurveyData{$Attribute}
                    && $SurveyData{$Attribute} =~ /\A(\d{4})-(\d{2})-(\d{2})\s(\d{2}):(\d{2}):(\d{2})\z/
                    )
                {
                    $SurveyData{$Attribute} = $StatsObject->_FromOTRSTimeZone(
                        String   => $SurveyData{$Attribute},
                        TimeZone => $Param{TimeZone},
                    );
                    $SurveyData{$Attribute} .= " ($Param{TimeZone})";
                }

                push @ResultRow, $SurveyData{$Attribute};
            }

            # Merge questions into result row.
            QUESTIONS:
            for my $Question (@Questions) {

                push @ResultRow, $SurveyData{$Question};
            }

            push @StatArray, \@ResultRow;
        }
    }

    @StatArray = $Self->_IndividualResultOrder(
        StatArray => \@StatArray,
        Sort      => $Sort,
        Limit     => $Limit,
    );

    return @StatArray;
}

sub GetHeaderLine {
    my ( $Self, %Param ) = @_;
    my %SelectedAttributes = map { $_ => 1 } @{ $Param{XValue}->{SelectedValues} };

    my $SurveyAttributes    = $Self->_SurveyAttributes();
    my $SortedAttributesRef = $Self->_SortedAttributes();
    my @HeaderLine;

    # Get language object.
    my $LanguageObject = $Kernel::OM->Get('Kernel::Language');

    # Get survey object.
    my $SurveyObject = $Kernel::OM->Get('Kernel::System::Survey');

    ATTRIBUTE:
    for my $Attribute ( @{$SortedAttributesRef} ) {
        next ATTRIBUTE if !$SelectedAttributes{$Attribute};
        push @HeaderLine, $LanguageObject->Translate( $SurveyAttributes->{$Attribute} );
    }

    # Add questions.
    # Only if survey restriction is active.
    # Get survey ids.
    if ( $Param{Restrictions}->{SurveyIDs} ) {

        my @SurveyIDs = $Param{Restrictions}->{SurveyIDs};

        # Get questions.
        my @Questions;
        for my $SurveyID (@SurveyIDs) {

            my @List = $SurveyObject->QuestionList(
                SurveyID => $SurveyID,
            );

            for my $List (@List) {
                push @Questions, $List->{Question};
            }
        }

        push @HeaderLine, @Questions;
    }

    return \@HeaderLine;
}

sub ExportWrapper {
    my ( $Self, %Param ) = @_;

    return \%Param;
}

sub ImportWrapper {
    my ( $Self, %Param ) = @_;

    return \%Param;
}

sub _SurveyAttributes {
    my $Self = shift;

    # Get config object.
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    my %SurveyAttributes = (

        TicketNumber => 'TicketNumber',
        SurveyTitle  => 'Survey Title',
        Created      => 'Create Time',
        Closed       => 'Close Time',
        SendTime     => 'Survey Send Time',
        VoteTime     => 'Survey Vote Time',
        Queue        => 'Queue',
        CustomerID   => 'CustomerID',

    );

    if ( $ConfigObject->Get('Ticket::Service') ) {
        $SurveyAttributes{Service} = 'Service';
    }

    DYNAMICFIELD:
    for my $DynamicFieldConfig ( @{ $Self->{DynamicField} } ) {
        next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);
        next DYNAMICFIELD if !$DynamicFieldConfig->{Name};

        $SurveyAttributes{ 'DynamicField_' . $DynamicFieldConfig->{Name} } = $DynamicFieldConfig->{Label};
    }

    return \%SurveyAttributes;
}

sub _SortedAttributes {
    my $Self = shift;

    my @SortedAttributes = qw(
        TicketNumber
        SurveyTitle
        Created
        Closed
        SendTime
        VoteTime
        Queue
        Service
        CustomerID
    );

    # Cycle trought the Dynamic Fields.
    DYNAMICFIELD:
    for my $DynamicFieldConfig ( @{ $Self->{DynamicField} } ) {
        next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);
        next DYNAMICFIELD if !$DynamicFieldConfig->{Name};

        # Add dynamic field attribute.
        push @SortedAttributes, 'DynamicField_' . $DynamicFieldConfig->{Name};
    }

    return \@SortedAttributes;
}

sub _ExtendedAttributesCheck {
    my ( $Self, %Param ) = @_;

    my @ExtendedAttributes = qw(
        Closed
    );

    ATTRIBUTE:
    for my $Attribute (@ExtendedAttributes) {
        return 1 if $Param{SurveyAttributes}{$Attribute};
    }

    return;
}

sub _IndividualResultOrder {
    my ( $Self, %Param ) = @_;
    my @Unsorted = @{ $Param{StatArray} };

    my @Sorted = sort { $a <=> $b } @Unsorted;

    # Make a reverse sort if needed.
    if ( $Param{Sort} eq 'Down' ) {
        @Sorted = reverse @Sorted;
    }

    # Take care about the limit.
    if ( $Param{Limit} && $Param{Limit} ne 'unlimited' ) {
        my $Count = 0;
        @Sorted = grep { ++$Count <= $Param{Limit} } @Sorted;
    }

    return @Sorted;
}

1;
