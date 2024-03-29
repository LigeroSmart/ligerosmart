# --
# Copyright (C) 2001-2018 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::GenericInterface::Operation::TicketLigero::TicketSearch;

use strict;
use warnings;

use Kernel::System::VariableCheck qw( :all );

use base qw(
    Kernel::GenericInterface::Operation::Common
    Kernel::GenericInterface::Operation::Ticket::Common
);

our $ObjectManagerDisabled = 1;

=head1 NAME

Kernel::GenericInterface::Operation::Ticket::TicketSearch - GenericInterface Ticket Search Operation backend

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

usually, you want to create an instance of this
by using Kernel::GenericInterface::Operation->new();

=cut

sub new {
    my ( $Type, %Param ) = @_;

    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for my $Needed (qw(DebuggerObject WebserviceID)) {
        if ( !$Param{$Needed} ) {
            return {
                Success      => 0,
                ErrorMessage => "Got no $Needed!",
            };
        }

        $Self->{$Needed} = $Param{$Needed};
    }

    # get config for this screen
    $Self->{Config} = $Kernel::OM->Get('Kernel::Config')->Get('GenericInterface::Operation::TicketSearch');

    return $Self;
}

=item Run()

perform TicketSearch Operation. This will return a Ticket ID list.

    my $Result = $OperationObject->Run(
        # ticket number (optional) as STRING or as ARRAYREF
        TicketNumber => '%123546%',
        TicketNumber => ['%123546%', '%123666%'],

        # ticket title (optional) as STRING or as ARRAYREF
        Title => '%SomeText%',
        Title => ['%SomeTest1%', '%SomeTest2%'],

        Queues   => ['system queue', 'other queue'],
        QueueIDs => [1, 42, 512],

        # use also sub queues of Queue|Queues in search
        UseSubQueues => 0,

        # You can use types like normal, ...
        Types   => ['normal', 'change', 'incident'],
        TypeIDs => [3, 4],

        # You can use states like new, open, pending reminder, ...
        States   => ['new', 'open'],
        StateIDs => [3, 4],

        # (Open|Closed) tickets for all closed or open tickets.
        StateType => 'Open',

        # You also can use real state types like new, open, closed,
        # pending reminder, pending auto, removed and merged.
        StateType    => ['open', 'new'],
        StateTypeIDs => [1, 2, 3],

        Priorities  => ['1 very low', '2 low', '3 normal'],
        PriorityIDs => [1, 2, 3],

        Services   => ['Service A', 'Service B'],
        ServiceIDs => [1, 2, 3],

        SLAs   => ['SLA A', 'SLA B'],
        SLAIDs => [1, 2, 3],

        Locks   => ['unlock'],
        LockIDs => [1, 2, 3],

        OwnerIDs => [1, 12, 455, 32]

        ResponsibleIDs => [1, 12, 455, 32]

        WatchUserIDs => [1, 12, 455, 32]

        # CustomerID (optional) as STRING or as ARRAYREF
        CustomerID => '123',
        CustomerID => ['123', 'ABC'],

        # CustomerUserLogin (optional) as STRING as ARRAYREF
        CustomerUserLogin => 'uid123',
        CustomerUserLogin => ['uid123', 'uid777'],

        # create ticket properties (optional)
        CreatedUserIDs     => [1, 12, 455, 32]
        CreatedTypes       => ['normal', 'change', 'incident'],
        CreatedTypeIDs     => [1, 2, 3],
        CreatedPriorities  => ['1 very low', '2 low', '3 normal'],
        CreatedPriorityIDs => [1, 2, 3],
        CreatedStates      => ['new', 'open'],
        CreatedStateIDs    => [3, 4],
        CreatedQueues      => ['system queue', 'other queue'],
        CreatedQueueIDs    => [1, 42, 512],

        # DynamicFields
        #   At least one operator must be specified. Operators will be connected with AND,
        #       values in an operator with OR.
        #   You can also pass more than one argument to an operator: ['value1', 'value2']
        DynamicField_FieldNameX => {
            Equals            => 123,
            Like              => 'value*',                # "equals" operator with wildcard support
            GreaterThan       => '2001-01-01 01:01:01',
            GreaterThanEquals => '2001-01-01 01:01:01',
            SmallerThan       => '2002-02-02 02:02:02',
            SmallerThanEquals => '2002-02-02 02:02:02',
        }

        # article stuff (optional)
        From    => '%spam@example.com%',
        To      => '%service@example.com%',
        Cc      => '%client@example.com%',
        Subject => '%VIRUS 32%',
        Body    => '%VIRUS 32%',

        # attachment stuff (optional, applies only for ArticleStorageDB)
        AttachmentName => '%anyfile.txt%',

        # use full article text index if configured (optional, default off)
        FullTextIndex => 1,

        # article content search (AND or OR for From, To, Cc, Subject and Body) (optional)
        ContentSearch => 'AND',

        # content conditions for From,To,Cc,Subject,Body
        # Title,CustomerID and CustomerUserLogin (all optional)
        ConditionInline => 1,

        # articles created more than 60 minutes ago (article older than 60 minutes) (optional)
        ArticleCreateTimeOlderMinutes => 60,
        # articles created less than 120 minutes ago (article newer than 60 minutes) (optional)
        ArticleCreateTimeNewerMinutes => 120,

        # articles with create time after ... (article newer than this date) (optional)
        ArticleCreateTimeNewerDate => '2006-01-09 00:00:01',
        # articles with created time before ... (article older than this date) (optional)
        ArticleCreateTimeOlderDate => '2006-01-19 23:59:59',

        # tickets created more than 60 minutes ago (ticket older than 60 minutes)  (optional)
        TicketCreateTimeOlderMinutes => 60,
        # tickets created less than 120 minutes ago (ticket newer than 120 minutes) (optional)
        TicketCreateTimeNewerMinutes => 120,

        # tickets with create time after ... (ticket newer than this date) (optional)
        TicketCreateTimeNewerDate => '2006-01-09 00:00:01',
        # tickets with created time before ... (ticket older than this date) (optional)
        TicketCreateTimeOlderDate => '2006-01-19 23:59:59',

        # ticket history entries that created more than 60 minutes ago (optional)
        TicketChangeTimeOlderMinutes => 60,
        # ticket history entries that created less than 120 minutes ago (optional)
        TicketChangeTimeNewerMinutes => 120,

        # tickets changed more than 60 minutes ago (optional)
        TicketLastChangeTimeOlderMinutes => 60,
        # tickets changed less than 120 minutes ago (optional)
        TicketLastChangeTimeNewerMinutes => 120,

        # tickets with changed time after ... (ticket changed newer than this date) (optional)
        TicketLastChangeTimeNewerDate => '2006-01-09 00:00:01',
        # tickets with changed time before ... (ticket changed older than this date) (optional)
        TicketLastChangeTimeOlderDate => '2006-01-19 23:59:59',

        # ticket history entry create time after ... (ticket history entries newer than this date) (optional)
        TicketChangeTimeNewerDate => '2006-01-09 00:00:01',
        # ticket history entry create time before ... (ticket history entries older than this date) (optional)
        TicketChangeTimeOlderDate => '2006-01-19 23:59:59',

        # tickets closed more than 60 minutes ago (optional)
        TicketCloseTimeOlderMinutes => 60,
        # tickets closed less than 120 minutes ago (optional)
        TicketCloseTimeNewerMinutes => 120,

        # tickets with closed time after ... (ticket closed newer than this date) (optional)
        TicketCloseTimeNewerDate => '2006-01-09 00:00:01',
        # tickets with closed time before ... (ticket closed older than this date) (optional)
        TicketCloseTimeOlderDate => '2006-01-19 23:59:59',

        # tickets with pending time of more than 60 minutes ago (optional)
        TicketPendingTimeOlderMinutes => 60,
        # tickets with pending time of less than 120 minutes ago (optional)
        TicketPendingTimeNewerMinutes => 120,

        # tickets with pending time after ... (optional)
        TicketPendingTimeNewerDate => '2006-01-09 00:00:01',
        # tickets with pending time before ... (optional)
        TicketPendingTimeOlderDate => '2006-01-19 23:59:59',

        # you can use all following escalation options with this four different ways of escalations
        # TicketEscalationTime...
        # TicketEscalationUpdateTime...
        # TicketEscalationResponseTime...
        # TicketEscalationSolutionTime...

        # ticket escalation time of more than 60 minutes ago (optional)
        TicketEscalationTimeOlderMinutes => -60,
        # ticket escalation time of less than 120 minutes ago (optional)
        TicketEscalationTimeNewerMinutes => -120,

        # tickets with escalation time after ... (optional)
        TicketEscalationTimeNewerDate => '2006-01-09 00:00:01',
        # tickets with escalation time before ... (optional)
        TicketEscalationTimeOlderDate => '2006-01-09 23:59:59',

        # search in archive (optional)
        ArchiveFlags => ['y', 'n'],

        # OrderBy and SortBy (optional)
        OrderBy => 'Down',  # Down|Up
        SortBy  => 'Age',   # Owner|Responsible|CustomerID|State|TicketNumber|Queue|Priority|Age|Type|Lock
                            # Changed|Title|Service|SLA|PendingTime|EscalationTime
                            # EscalationUpdateTime|EscalationResponseTime|EscalationSolutionTime
                            # DynamicField_FieldNameX
                            # TicketFreeTime1-6|TicketFreeKey1-16|TicketFreeText1-16

        # OrderBy and SortBy as ARRAY for sub sorting (optional)
        OrderBy => ['Down', 'Up'],
        SortBy  => ['Priority', 'Age'],
        },
    );

    $Result = {
        Success      => 1,                                # 0 or 1
        ErrorMessage => '',                               # In case of an error
        Data         => {
            TicketID => [ 1, 2, 3, 4 ],
        },
    };

=cut

=pod
@api {post} /ticket/search/fullcontent Search a ticket and return all content.
@apiName Search Full Content
@apiGroup Ticket
@apiVersion 1.0.0

@apiExample Example usage:
  {
    "SessionID": "a0uShqmDGXkiSyPRjmFnPH2vRH4yPc8J",
    "TicketNumber": ["2021052910000021"],
    "Title": ["Teste Attachment"],
    "Queues": ["Postmaster"],
    "QueueIDs": ["1"],
    "UseSubQueues": 0,
    "Types": ["Unclassified"],
    "TypeIDs": ["1"],
    "States": ["new"],
    "StateIDs": ["1"],
    "StateType": ["new"],
    "StateTypeIDs": ["1"],
    "Priorities": ["1 very low"],
    "PriorityIDs": ["1"],
    "Services": ["teste"],
    "ServiceIDs": ["1"],
    "SLAs": ["teste"],
    "SLAIDs": ["1"],
    "Locks": ["unlock"],
    "LockIDs": ["1"],
    "OwnerIDs": ["1"],
    "ResponsibleIDs": ["1"],
    "WatchUserIDs": [],
    "CustomerID": [],
    "CustomerUserLogin":["ricardo.silva"],
    "CreatedUserIDs": ["1"],
    "CreatedTypes":["Unclassified"],
    "CreatedTypeIDs": ["1"],
    "CreatedPriorities": ["1 very low"],
    "CreatedPriorityIDs": ["1"],
    "CreatedStates": ["new"],
    "CreatedStateIDs": ["1"],
    "CreatedQueues": ["Postmaster"],
    "CreatedQueueIDs": ["1"],
    "DynamicField_TicketKey": {
      "Empty": 0,
      "Equals": "teste",
      "Like": "teste",
      "GreaterThan": "",
      "GreaterThanEquals": "",
      "SmallerThan": "",
      "SmallerThanEquals": ""
    },
    "MIMEBase_From": "",
    "MIMEBase_To": "",
    "MIMEBase_Cc": "",
    "MIMEBase_Subject": "",
    "MIMEBase_Body": "",
    "AttachmentName": "",
    "FullTextIndex": 1,
    "ContentSearch": "AND",
    "ConditionInline": 1,
    "ArticleCreateTimeOlderMinutes": 10,
    "ArticleCreateTimeNewerMinutes": 300,
    "ArticleCreateTimeNewerDate": "2021-01-01 00:00:00",
    "ArticleCreateTimeOlderDate": "2022-01-01 00:00:00",
    "TicketCreateTimeOlderMinutes": 10,
    "TicketCreateTimeNewerMinutes": 300,
    "TicketCreateTimeNewerDate": "2021-01-01 00:00:00",
    "TicketCreateTimeOlderDate": "2022-01-01 00:00:00",
    "TicketChangeTimeOlderMinutes": 10,
    "TicketChangeTimeNewerMinutes": 300,
    "TicketLastChangeTimeOlderMinutes": 10,
    "TicketLastChangeTimeNewerMinutes": 300,
    "TicketLastChangeTimeNewerDate": "2021-01-01 00:00:00",
    "TicketLastChangeTimeOlderDate": "2022-01-01 00:00:00",
    "TicketChangeTimeNewerDate": "2021-01-01 00:00:00",
    "TicketChangeTimeOlderDate": "2022-01-01 00:00:00",
    "TicketCloseTimeOlderMinutes": "",
    "TicketCloseTimeNewerMinutes": "",
    "TicketCloseTimeNewerDate": "",
    "TicketCloseTimeOlderDate": "",
    "OrderBy": ["Down", "Up"],
    "SortBy": ["Priority", "Age"]
  }

@apiParam (Request body) {String} [UserLogin] User login to create sesssion.
@apiParam (Request body) {String} [Password] Password to create session.
@apiParam (Request body) {String} SessionID session id generated by session create method.
@apiParam (Request body) {Array} TicketNumber Ticket Number list array to search.
@apiParam (Request body) {Array} [Title] Ticket Title List Array to search
@apiParam (Request body) {Array} [Queues] Ticket Queue List Array to search
@apiParam (Request body) {Array} [QueueIDs] Ticket Queue ID List Array to search
@apiParam (Request body) {Integer="0","1"} [UseSubQueues] Define if use sub queues in the search
@apiParam (Request body) {Array} [Types] Ticket Type List Array to search
@apiParam (Request body) {Array} [TypeIDs] Ticket Type ID List Array to search
@apiParam (Request body) {Array} [States] Ticket State List Array to search
@apiParam (Request body) {Array} [StateIDs] Ticket State ID List Array to search
@apiParam (Request body) {Array} [StateType] Ticket State Type List Array to search
@apiParam (Request body) {Array} [StateTypeIDs] Ticket State Type ID List Array to search
@apiParam (Request body) {Array} [Priorities] Ticket Priorities List Array to search
@apiParam (Request body) {Array} [PriorityIDs] Ticket Prioritiy ID List Array to search
@apiParam (Request body) {Array} [Services] Ticket Service List Array to search
@apiParam (Request body) {Array} [ServiceIDs] Ticket Service ID List Array to search
@apiParam (Request body) {Array} [SLAs] Ticket SLA List Array to search
@apiParam (Request body) {Array} [SLAIDs] Ticket SLA ID List Array to search
@apiParam (Request body) {Array} [Locks] Ticket Lock List Array to search
@apiParam (Request body) {Array} [LockIDs] Ticket Lock ID List Array to search
@apiParam (Request body) {Array} [OwnerIDs] Ticket Owner ID List Array to search
@apiParam (Request body) {Array} [ResponsibleIDs] Ticket Responsible ID List Array to search
@apiParam (Request body) {Array} [WatchUserIDs] Ticket Watch User ID List Array to search
@apiParam (Request body) {Array} [CustomerID] Ticket Customer ID List Array to search
@apiParam (Request body) {Array} [CustomerUserLogin] Ticket Customer User Login List Array to search
@apiParam (Request body) {Array} [CreatedUserIDs] Ticket Created User ID List Array to search
@apiParam (Request body) {Array} [CreatedTypes] Ticket Created Type List Array to search
@apiParam (Request body) {Array} [CreatedTypeIDs] Ticket Created Type ID List Array to search
@apiParam (Request body) {Array} [CreatedPriorities] Ticket Created Priority List Array to search
@apiParam (Request body) {Array} [CreatedPriorityIDs] Ticket Created Priority ID List Array to search
@apiParam (Request body) {Array} [CreatedStates] Ticket Created State List Array to search
@apiParam (Request body) {Array} [CreatedStateIDs] Ticket Created State ID List Array to search
@apiParam (Request body) {Array} [CreatedQueues] Ticket Created Queue List Array to search
@apiParam (Request body) {Array} [CreatedQueueIDs] Ticket Created Queue ID List Array to search
@apiParam (Request body) {Object} [DynamicField_*] Dynamic Field Object to search
@apiParam (Request body) {Array} [OrderBy] Ticket Order By Field List Array to search
@apiParam (Request body) {Array} [SortBy] Ticket Sort By Field List Array to search

@apiErrorExample {json} Error example:
  HTTP/1.1 200 Success
  {
    "Error": {
      "ErrorCode": "TicketSearch.AuthFail",
      "ErrorMessage": "TicketSearch: Authorization failing!"
    }
  }
@apiSuccessExample {json} Success example:
  HTTP/1.1 200 Success
  {
    "Length": 500,
    "Total": 1,
    "Tickets": [
      {
        "Created": "2021-05-29 19:25:05",
        "TypeID": 1,
        "Service": "teste",
        "StateID": 1,
        "CustomerUserID": "ricardo.silva",
        "SLA": "teste",
        "CreateBy": 1,
        "UnlockTimeout": 1622316305,
        "State": "new",
        "Title": "Teste Attachment",
        "CustomerID": "LIGEROSMART",
        "TicketNumber": "2021052910000021",
        "Priority": "1 very low",
        "FirstResponse": "2021-05-29 19:25:05",
        "OwnerID": 1,
        "LockID": 1,
        "Age": 848212,
        "Owner": "root@localhost",
        "ArchiveFlag": "n",
        "RealTillTimeNotUsed": 0,
        "EscalationUpdateTime": 0,
        "EscalationResponseTime": 0,
        "ServiceID": 1,
        "Type": "Unclassified",
        "ChangeBy": 1,
        "SLAID": 1,
        "FirstResponseInMin": 0,
        "StateType": "new",
        "ResponsibleID": 1,
        "EscalationSolutionTime": 0,
        "Changed": "2021-05-29 19:25:06",
        "Queue": "Postmaster",
        "PriorityID": 1,
        "GroupID": 1,
        "TicketID": 4,
        "UntilTime": 0,
        "Lock": "unlock",
        "Article": [
          {
            "MessageID": "",
            "CreateBy": 1,
            "From": "ricardo.silva@complemento.ne.br",
            "IncomingTime": 1622316305,
            "CreateTime": "2021-05-29 19:25:05",
            "References": "",
            "ReplyTo": "",
            "InReplyTo": "",
            "ArticleID": 36,
            "ContentCharset": "utf-8",
            "To": "raw",
            "Charset": "utf-8",
            "IsVisibleForCustomer": 1,
            "Subject": "Teste Attachment",
            "MimeType": "text/plain",
            "ChangeTime": "2021-05-29 19:25:05",
            "Body": "Teste Attachment",
            "SenderType": "agent",
            "ChangeBy": 1,
            "Cc": "",
            "Bcc": "",
            "SenderTypeID": "1",
            "ArticleNumber": 1,
            "ContentType": "text/plain; charset=utf-8",
            "CommunicationChannelID": 1,
            "TicketID": 4
          }
        ],
        "Responsible": "root@localhost",
        "QueueID": 1,
        "EscalationTime": 0
      }
    ],
    "Start": 1
  }
=cut
sub Run {
    my ( $Self, %Param ) = @_;

    my $Result = $Self->Init(
        WebserviceID => $Self->{WebserviceID},
    );

    if ( !$Result->{Success} ) {
        $Self->ReturnError(
            ErrorCode    => 'Webservice.InvalidConfiguration',
            ErrorMessage => $Result->{ErrorMessage},
        );
    }

    my ( $UserID, $UserType ) = $Self->Auth(
        %Param,
    );

    return $Self->ReturnError(
        ErrorCode    => 'TicketSearch.AuthFail',
        ErrorMessage => "TicketSearch: Authorization failing!",
    ) if !$UserID;

    # all needed variables
    $Self->{SearchLimit} = $Param{Data}->{Limit}
        || $Self->{Config}->{SearchLimit}
        || 500;
    $Self->{SortBy} = $Param{Data}->{SortBy}
        || $Self->{Config}->{'SortBy::Default'}
        || 'Age';
    $Self->{OrderBy} = $Param{Data}->{OrderBy}
        || $Self->{Config}->{'Order::Default'}
        || 'Down';
    $Self->{Start} = $Param{Data}->{Start}
        || 1;
    $Self->{Length} = $Param{Data}->{Length}
        || $Self->{Config}->{SearchLimit}
        || 500;
    $Self->{FullTextIndex} = $Param{Data}->{FullTextIndex} || 0;

    # get parameter from data
    my %GetParam = $Self->_GetParams( %{ $Param{Data} } );

    # create time settings
    %GetParam = $Self->_CreateTimeSettings(%GetParam);

    # get dynamic fields
    my %DynamicFieldSearchParameters = $Self->_GetDynamicFields( %{ $Param{Data} } );

    # perform ticket search
    $UserType = ( $UserType eq 'Customer' ) ? 'CustomerUserID' : 'UserID';
    my @TicketIDs = $Kernel::OM->Get('Kernel::System::Ticket')->TicketSearch(
        %GetParam,
        %DynamicFieldSearchParameters,
        Result              => 'ARRAY',
        SortBy              => $Self->{SortBy},
        OrderBy             => $Self->{OrderBy},
        Limit               => $Self->{SearchLimit},
        $UserType           => $UserID,
        ConditionInline     => $Self->{Config}->{ExtendedSearchCondition},
        ContentSearchPrefix => '*',
        ContentSearchSuffix => '*',
        FullTextIndex       => $Self->{FullTextIndex},
    );

    if (@TicketIDs) {

        my @ticketsPagged = ();
        my $to = (int($Self->{Length}) + int($Self->{Start}) - 1);

        if(int(@TicketIDs) > int($Self->{Start})-1){
            for(my $i=int($Self->{Start})-1;$i < $to; $i++){
                if($i < int(@TicketIDs)){
                    #my @itemTicketData = {
                    #    TicketID => @TicketIDs[$i];
                    #};
                    #push(@ticketsPagged,@TicketIDs[$i]);
                    my %TicketEntry = $Kernel::OM->Get('Kernel::System::Ticket')->TicketGet(
                        TicketID      => @TicketIDs[$i],
                        #DynamicFields => $DynamicFields,
                        Extended      => 1,
                        #UserID        => $UserID,
                    );

                    my $ArticleTypes;
                    if ( $UserType eq 'Customer' ) {
                        $ArticleTypes = [ $Kernel::OM->Get('Kernel::System::Ticket')->ArticleTypeList( Type => 'Customer' ) ];
                    }

                    my $ArticleSenderType = '';
                    my @ArticleBoxRaw = $Kernel::OM->Get('Kernel::System::Ticket::Article')->ArticleList(
                        TicketID          => @TicketIDs[$i],
                        SenderTypeID => $ArticleSenderType,
                        SenderType       => $ArticleTypes,
                        #Extended          => $Extended,
                        #Order             => $ArticleOrder,
                        #Limit             => $ArticleLimit,
                        #UserID            => $UserID,
                    );

                    # start article loop
                    #ARTICLE:
                    #for my $Article (@ArticleBoxRaw) {

                        # get attachment index (without attachments)
                    #    my %AtmIndex = $Kernel::OM->Get('Kernel::System::Ticket')->ArticleAttachmentIndex(
                    #        ContentPath                => $Article->{ContentPath},
                    #        ArticleID                  => $Article->{ArticleID},
                    #        StripPlainBodyAsAttachment => 3,
                    #        Article                    => $Article,
                    #        UserID                     => $UserID,
                    #    );

                    #    next ARTICLE if !IsHashRefWithData( \%AtmIndex );

                    #    my @Attachments;
                    #    ATTACHMENT:
                    #    for my $FileID ( sort keys %AtmIndex ) {
                    #        next ATTACHMENT if !$FileID;
                    #        my %Attachment = $Kernel::OM->Get('Kernel::System::Ticket')->ArticleAttachment(
                    #            ArticleID => $Article->{ArticleID},
                    #            FileID    => $FileID,                 # as returned by ArticleAttachmentIndex
                    #            UserID    => $UserID,
                    #        );

                    #        next ATTACHMENT if !IsHashRefWithData( \%Attachment );

                            # convert content to base64
                    #        $Attachment{Content} = MIME::Base64::encode_base64( $Attachment{Content} );
                    #        push @Attachments, {%Attachment};
                    #    }

                        # set Attachments data
                    #    $Article->{Attachment} = \@Attachments;

                    #}    # finish article loop

                    # set Ticket entry data
                    if (@ArticleBoxRaw) {

                        my @ArticleBox;

                        for my $ArticleRawT (@ArticleBoxRaw) {
                            my %Article;
                            my @ArticleDynamicFields;

                            my %ArticleRaw = $Kernel::OM->Get('Kernel::System::Ticket::Article')->BackendForArticle( %{$ArticleRawT} )->ArticleGet( %{$ArticleRawT},DynamicFields => 1 );

                            # remove all dynamic fields form main article hash and set them into an array.
                            ATTRIBUTE:
                            for my $Attribute ( sort keys %ArticleRaw ) {

                                if ( $Attribute =~ m{\A DynamicField_(.*) \z}msx ) {

                                    # Skip dynamic fields that are not for article object
                                    #next ATTRIBUTE if ( !$ArticleDynamicFieldLookup{$1} );

                                    push @ArticleDynamicFields, {
                                        Name  => $1,
                                        Value => %ArticleRaw{$Attribute},
                                    };
                                    next ATTRIBUTE;
                                }

                                $Article{$Attribute} = %ArticleRaw{$Attribute};
                            }

                            # add dynamic fields array into 'DynamicField' hash key if any
                            if (@ArticleDynamicFields) {
                                $Article{DynamicField} = \@ArticleDynamicFields;
                            }

                            push @ArticleBox, \%Article;
                        }
                        $TicketEntry{Article} = \@ArticleBox;
                    }

                    $TicketEntry{TicketID} => @TicketIDs[$i];

                    push(@ticketsPagged,
                        \%TicketEntry
                    );
                }
            }
        }
        

        return {
            Success => 1,
            Data    => {
                Total => int(@TicketIDs),
                Start => int($Self->{Start}),
                Length => int($Self->{Length}),
                Tickets => \@ticketsPagged,
            },
        };
    }

    # return result
    return {
        Success => 1,
        Data    => {
            Total => 0,
            Start => 0,
            Length => 0,
            Tickets => ()
        },
    };
}

=begin Internal:

=item _GetParams()

get search parameters.

    my %GetParam = _GetParams(
        %Params,                          # all ticket parameters
    );

    returns:

    %GetParam = {
        AllowedParams => 'WithContent', # return not empty parameters for search
    }

=cut

sub _GetParams {
    my ( $Self, %Param ) = @_;

    # get single params
    my %GetParam;

    for my $Item (
        qw(From To Cc Subject Body
        Agent ResultForm TimeSearchType ChangeTimeSearchType LastChangeTimeSearchType CloseTimeSearchType UseSubQueues
        ArticleTimeSearchType SearchInArchive
        Fulltext ContentSearch ShownAttributes AttachmentName
        )
        )
    {

        # get search string params (get submitted params)
        if ( IsStringWithData( $Param{$Item} ) ) {

            $GetParam{$Item} = $Param{$Item};

            # remove white space on the start and end
            $GetParam{$Item} =~ s/\s+$//g;
            $GetParam{$Item} =~ s/^\s+//g;
        }
    }

    # get array params
    for my $Item (
        qw(TicketNumber Title
        StateIDs StateTypeIDs QueueIDs PriorityIDs OwnerIDs
        CreatedUserIDs WatchUserIDs ResponsibleIDs
        TypeIDs ServiceIDs SLAIDs LockIDs Queues Types States
        Priorities Services SLAs Locks
        CreatedTypes CreatedTypeIDs CreatedPriorities
        CreatedPriorityIDs CreatedStates CreatedStateIDs
        CreatedQueues CreatedQueueIDs StateType CustomerID
        CustomerUserLogin )
        )
    {

        # get search array params
        my @Values;
        if ( IsArrayRefWithData( $Param{$Item} ) ) {
            @Values = @{ $Param{$Item} };
        }
        elsif ( IsStringWithData( $Param{$Item} ) ) {
            @Values = ( $Param{$Item} );
        }
        $GetParam{$Item} = \@Values if scalar @Values;
    }

    # get escalation times
    my %EscalationTimes = (
        1 => '',
        2 => 'Update',
        3 => 'Response',
        4 => 'Solution',
    );

    for my $Index ( sort keys %EscalationTimes ) {
        for my $PostFix (qw( OlderMinutes NewerMinutes NewerDate OlderDate )) {
            my $Item = 'TicketEscalation' . $EscalationTimes{$Index} . 'Time' . $PostFix;

            # get search string params (get submitted params)
            if ( IsStringWithData( $Param{$Item} ) ) {
                $GetParam{$Item} = $Param{$Item};

                # remove white space on the start and end
                $GetParam{$Item} =~ s/\s+$//g;
                $GetParam{$Item} =~ s/^\s+//g;
            }
        }
    }

    my @Prefixes = (
        'TicketCreateTime',
        'TicketChangeTime',
        'TicketLastChangeTime',
        'TicketCloseTime',
        'TicketPendingTime',
        'ArticleCreateTime',
    );

    my @Postfixes = (
        'Point',
        'PointFormat',
        'PointStart',
        'Start',
        'StartDay',
        'StartMonth',
        'StartYear',
        'Stop',
        'StopDay',
        'StopMonth',
        'StopYear',
        'OlderMinutes',
        'NewerMinutes',
        'OlderDate',
        'NewerDate',
    );

    for my $Prefix (@Prefixes) {

        # get search string params (get submitted params)
        if ( IsStringWithData( $Param{$Prefix} ) ) {
            $GetParam{$Prefix} = $Param{$Prefix};

            # remove white space on the start and end
            $GetParam{$Prefix} =~ s/\s+$//g;
            $GetParam{$Prefix} =~ s/^\s+//g;
        }

        for my $Postfix (@Postfixes) {
            my $Item = $Prefix . $Postfix;

            # get search string params (get submitted params)
            if ( IsStringWithData( $Param{$Item} ) ) {
                $GetParam{$Item} = $Param{$Item};

                # remove white space on the start and end
                $GetParam{$Item} =~ s/\s+$//g;
                $GetParam{$Item} =~ s/^\s+//g;
            }
        }
    }

    return %GetParam;

}

=item _GetDynamicFields()

get search parameters.

    my %DynamicFieldSearchParameters = _GetDynamicFields(
        %Params,                          # all ticket parameters
    );

    returns:

    %DynamicFieldSearchParameters = {
        'AllAllowedDF' => 'WithData',   # return not empty parameters for search
    }

=cut

sub _GetDynamicFields {
    my ( $Self, %Param ) = @_;

    # dynamic fields search parameters for ticket search
    my %DynamicFieldSearchParameters;

    # get single params
    my %AttributeLookup;

    # get the dynamic fields for ticket object
    $Self->{DynamicField} = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldListGet(
        Valid      => 1,
        ObjectType => ['Ticket'],
    );

    for my $ParameterName ( sort keys %Param ) {
        if ( $ParameterName =~ m{\A DynamicField_ ( [a-zA-Z\d]+ ) \z}xms ) {

            # loop over the dynamic fields configured
            DYNAMICFIELD:
            for my $DynamicFieldConfig ( @{ $Self->{DynamicField} } ) {
                next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);
                next DYNAMICFIELD if !$DynamicFieldConfig->{Name};

                # skip all fields that does not match with current field name ($1)
                # without the 'DynamicField_' prefix
                next DYNAMICFIELD if $DynamicFieldConfig->{Name} ne $1;

                # set search parameter
                $DynamicFieldSearchParameters{ 'DynamicField_' . $DynamicFieldConfig->{Name} }
                    = $Param{ 'DynamicField_' . $DynamicFieldConfig->{Name} };

                last DYNAMICFIELD;
            }
        }
    }

    # allow free fields

    return %DynamicFieldSearchParameters;

}

=item _CreateTimeSettings()

get search parameters.

    my %GetParam = _CreateTimeSettings(
        %Params,                          # all ticket parameters
    );

    returns:

    %GetParam = {
        AllowedTimeSettings => 'WithData',   # return not empty parameters for search
    }

=cut

sub _CreateTimeSettings {
    my ( $Self, %Param ) = @_;

    # get single params
    my %GetParam = %Param;

    # get change time settings
    if ( !$GetParam{ChangeTimeSearchType} ) {

        # do nothing on time stuff
    }
    elsif ( $GetParam{ChangeTimeSearchType} eq 'TimeSlot' ) {
        for (qw(Month Day)) {
            $GetParam{"TicketChangeTimeStart$_"} = sprintf( "%02d", $GetParam{"TicketChangeTimeStart$_"} );
        }
        for (qw(Month Day)) {
            $GetParam{"TicketChangeTimeStop$_"} = sprintf( "%02d", $GetParam{"TicketChangeTimeStop$_"} );
        }
        if (
            $GetParam{TicketChangeTimeStartDay}
            && $GetParam{TicketChangeTimeStartMonth}
            && $GetParam{TicketChangeTimeStartYear}
            )
        {
            $GetParam{TicketChangeTimeNewerDate} = $GetParam{TicketChangeTimeStartYear} . '-'
                . $GetParam{TicketChangeTimeStartMonth} . '-'
                . $GetParam{TicketChangeTimeStartDay}
                . ' 00:00:00';
        }
        if (
            $GetParam{TicketChangeTimeStopDay}
            && $GetParam{TicketChangeTimeStopMonth}
            && $GetParam{TicketChangeTimeStopYear}
            )
        {
            $GetParam{TicketChangeTimeOlderDate} = $GetParam{TicketChangeTimeStopYear} . '-'
                . $GetParam{TicketChangeTimeStopMonth} . '-'
                . $GetParam{TicketChangeTimeStopDay}
                . ' 23:59:59';
        }
    }
    elsif ( $GetParam{ChangeTimeSearchType} eq 'TimePoint' ) {
        if (
            $GetParam{TicketChangeTimePoint}
            && $GetParam{TicketChangeTimePointStart}
            && $GetParam{TicketChangeTimePointFormat}
            )
        {
            my $Time = 0;
            if ( $GetParam{TicketChangeTimePointFormat} eq 'minute' ) {
                $Time = $GetParam{TicketChangeTimePoint};
            }
            elsif ( $GetParam{TicketChangeTimePointFormat} eq 'hour' ) {
                $Time = $GetParam{TicketChangeTimePoint} * 60;
            }
            elsif ( $GetParam{TicketChangeTimePointFormat} eq 'day' ) {
                $Time = $GetParam{TicketChangeTimePoint} * 60 * 24;
            }
            elsif ( $GetParam{TicketChangeTimePointFormat} eq 'week' ) {
                $Time = $GetParam{TicketChangeTimePoint} * 60 * 24 * 7;
            }
            elsif ( $GetParam{TicketChangeTimePointFormat} eq 'month' ) {
                $Time = $GetParam{TicketChangeTimePoint} * 60 * 24 * 30;
            }
            elsif ( $GetParam{TicketChangeTimePointFormat} eq 'year' ) {
                $Time = $GetParam{TicketChangeTimePoint} * 60 * 24 * 365;
            }
            if ( $GetParam{TicketChangeTimePointStart} eq 'Before' ) {
                $GetParam{TicketChangeTimeOlderMinutes} = $Time;
            }
            else {
                $GetParam{TicketChangeTimeNewerMinutes} = $Time;
            }
        }
    }

    # get last change time settings
    if ( !$GetParam{LastChangeTimeSearchType} ) {

        # do nothing on time stuff
    }
    elsif ( $GetParam{LastChangeTimeSearchType} eq 'TimeSlot' ) {
        for (qw(Month Day)) {
            $GetParam{"TicketLastChangeTimeStart$_"} = sprintf( "%02d", $GetParam{"TicketLastChangeTimeStart$_"} );
        }
        for (qw(Month Day)) {
            $GetParam{"TicketLastChangeTimeStop$_"} = sprintf( "%02d", $GetParam{"TicketLastChangeTimeStop$_"} );
        }
        if (
            $GetParam{TicketLastChangeTimeStartDay}
            && $GetParam{TicketLastChangeTimeStartMonth}
            && $GetParam{TicketLastChangeTimeStartYear}
            )
        {
            $GetParam{TicketLastChangeTimeNewerDate} = $GetParam{TicketLastChangeTimeStartYear} . '-'
                . $GetParam{TicketLastChangeTimeStartMonth} . '-'
                . $GetParam{TicketLastChangeTimeStartDay}
                . ' 00:00:00';
        }
        if (
            $GetParam{TicketLastChangeTimeStopDay}
            && $GetParam{TicketLastChangeTimeStopMonth}
            && $GetParam{TicketLastChangeTimeStopYear}
            )
        {
            $GetParam{TicketLastChangeTimeOlderDate} = $GetParam{TicketLastChangeTimeStopYear} . '-'
                . $GetParam{TicketLastChangeTimeStopMonth} . '-'
                . $GetParam{TicketLastChangeTimeStopDay}
                . ' 23:59:59';
        }
    }
    elsif ( $GetParam{LastChangeTimeSearchType} eq 'TimePoint' ) {
        if (
            $GetParam{TicketLastChangeTimePoint}
            && $GetParam{TicketLastChangeTimePointStart}
            && $GetParam{TicketLastChangeTimePointFormat}
            )
        {
            my $Time = 0;
            if ( $GetParam{TicketLastChangeTimePointFormat} eq 'minute' ) {
                $Time = $GetParam{TicketLastChangeTimePoint};
            }
            elsif ( $GetParam{TicketLastChangeTimePointFormat} eq 'hour' ) {
                $Time = $GetParam{TicketLastChangeTimePoint} * 60;
            }
            elsif ( $GetParam{TicketLastChangeTimePointFormat} eq 'day' ) {
                $Time = $GetParam{TicketLastChangeTimePoint} * 60 * 24;
            }
            elsif ( $GetParam{TicketLastChangeTimePointFormat} eq 'week' ) {
                $Time = $GetParam{TicketLastChangeTimePoint} * 60 * 24 * 7;
            }
            elsif ( $GetParam{TicketLastChangeTimePointFormat} eq 'month' ) {
                $Time = $GetParam{TicketLastChangeTimePoint} * 60 * 24 * 30;
            }
            elsif ( $GetParam{TicketLastChangeTimePointFormat} eq 'year' ) {
                $Time = $GetParam{TicketLastChangeTimePoint} * 60 * 24 * 365;
            }
            if ( $GetParam{TicketLastChangeTimePointStart} eq 'Before' ) {
                $GetParam{TicketLastChangeTimeOlderMinutes} = $Time;
            }
            else {
                $GetParam{TicketLastChangeTimeNewerMinutes} = $Time;
            }
        }
    }

    # get close time settings
    if ( !$GetParam{CloseTimeSearchType} ) {

        # do nothing on time stuff
    }
    elsif ( $GetParam{CloseTimeSearchType} eq 'TimeSlot' ) {
        for (qw(Month Day)) {
            $GetParam{"TicketCloseTimeStart$_"} = sprintf( "%02d", $GetParam{"TicketCloseTimeStart$_"} );
        }
        for (qw(Month Day)) {
            $GetParam{"TicketCloseTimeStop$_"} = sprintf( "%02d", $GetParam{"TicketCloseTimeStop$_"} );
        }
        if (
            $GetParam{TicketCloseTimeStartDay}
            && $GetParam{TicketCloseTimeStartMonth}
            && $GetParam{TicketCloseTimeStartYear}
            )
        {
            $GetParam{TicketCloseTimeNewerDate} = $GetParam{TicketCloseTimeStartYear} . '-'
                . $GetParam{TicketCloseTimeStartMonth} . '-'
                . $GetParam{TicketCloseTimeStartDay}
                . ' 00:00:00';
        }
        if (
            $GetParam{TicketCloseTimeStopDay}
            && $GetParam{TicketCloseTimeStopMonth}
            && $GetParam{TicketCloseTimeStopYear}
            )
        {
            $GetParam{TicketCloseTimeOlderDate} = $GetParam{TicketCloseTimeStopYear} . '-'
                . $GetParam{TicketCloseTimeStopMonth} . '-'
                . $GetParam{TicketCloseTimeStopDay}
                . ' 23:59:59';
        }
    }
    elsif ( $GetParam{CloseTimeSearchType} eq 'TimePoint' ) {
        if (
            $GetParam{TicketCloseTimePoint}
            && $GetParam{TicketCloseTimePointStart}
            && $GetParam{TicketCloseTimePointFormat}
            )
        {
            my $Time = 0;
            if ( $GetParam{TicketCloseTimePointFormat} eq 'minute' ) {
                $Time = $GetParam{TicketCloseTimePoint};
            }
            elsif ( $GetParam{TicketCloseTimePointFormat} eq 'hour' ) {
                $Time = $GetParam{TicketCloseTimePoint} * 60;
            }
            elsif ( $GetParam{TicketCloseTimePointFormat} eq 'day' ) {
                $Time = $GetParam{TicketCloseTimePoint} * 60 * 24;
            }
            elsif ( $GetParam{TicketCloseTimePointFormat} eq 'week' ) {
                $Time = $GetParam{TicketCloseTimePoint} * 60 * 24 * 7;
            }
            elsif ( $GetParam{TicketCloseTimePointFormat} eq 'month' ) {
                $Time = $GetParam{TicketCloseTimePoint} * 60 * 24 * 30;
            }
            elsif ( $GetParam{TicketCloseTimePointFormat} eq 'year' ) {
                $Time = $GetParam{TicketCloseTimePoint} * 60 * 24 * 365;
            }
            if ( $GetParam{TicketCloseTimePointStart} eq 'Before' ) {
                $GetParam{TicketCloseTimeOlderMinutes} = $Time;
            }
            else {
                $GetParam{TicketCloseTimeNewerMinutes} = $Time;
            }
        }
    }

    # prepare full text search
    if ( $GetParam{Fulltext} ) {
        $GetParam{ContentSearch} = 'OR';
        for (qw(From To Cc Subject Body)) {
            $GetParam{$_} = $GetParam{Fulltext};
        }
    }

    # prepare archive flag
    if ( $Kernel::OM->Get('Kernel::Config')->Get('Ticket::ArchiveSystem') ) {

        $GetParam{SearchInArchive} ||= '';
        if ( $GetParam{SearchInArchive} eq 'AllTickets' ) {
            $GetParam{ArchiveFlags} = [ 'y', 'n' ];
        }
        elsif ( $GetParam{SearchInArchive} eq 'ArchivedTickets' ) {
            $GetParam{ArchiveFlags} = ['y'];
        }
        else {
            $GetParam{ArchiveFlags} = ['n'];
        }
    }

    return %GetParam;
}

=end Internal:

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut

1;
