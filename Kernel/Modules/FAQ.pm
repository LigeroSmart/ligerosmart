# --
# Kernel/Modules/FAQ.pm - faq module
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: FAQ.pm,v 1.17 2008-07-07 11:00:30 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::Modules::FAQ;

use strict;
use warnings;

use Kernel::System::User;
use Kernel::System::FAQ;
use Kernel::System::LinkObject;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.17 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    for ( keys %Param ) {
        $Self->{$_} = $Param{$_};
    }

    # check needed Objects
    for (qw(ParamObject DBObject LayoutObject LogObject ConfigObject UserObject)) {
        $Self->{LayoutObject}->FatalError( Message => "Got no $_!" ) if ( !$Self->{$_} );
    }

    # faq object
    $Self->{FAQObject} = Kernel::System::FAQ->new(%Param);

    # link object
    $Self->{LinkObject} = Kernel::System::LinkObject->new(%Param);

    # agent user
    $Self->{AgentUserObject} = Kernel::System::User->new(%Param);

    # interface settings

    $Self->{Interface} = $Self->{FAQObject}->StateTypeGet(
        Name => 'public'
    );
    $Self->{InterfaceStates} = $Self->{FAQObject}->StateTypeList(
        Types => ['public']
    );

    # global output vars
    $Self->{Notify} = [];

    return $Self;
}

sub GetExplorer {
    my ( $Self, %Param ) = @_;

    my %Frontend = ();
    my %GetParam = ();
    my @Params   = qw(Order Sort);

    # manage parameters
    $GetParam{CategoryID} = $Self->{ParamObject}->GetParam( Param => 'CategoryID' ) || 0;
    $GetParam{Order}      = $Self->{ParamObject}->GetParam( Param => 'Order' )      || 'Title';
    $GetParam{Sort}       = $Self->{ParamObject}->GetParam( Param => 'Sort' )       || 'up';
    for (@Params) {
        if ( !$GetParam{$_} && !( $GetParam{$_} = $Self->{ParamObject}->GetParam( Param => $_ ) ) )
        {
            return $Self->{LayoutObject}->FatalError( Message => "Need parameter $_" );
        }
    }

    # db action
    my %CategoryData = ();
    if ( $GetParam{CategoryID} ) {
        %CategoryData = $Self->{FAQObject}
            ->CategoryGet( CategoryID => $GetParam{CategoryID}, UserID => $Self->{UserID} );
        if ( !%CategoryData ) {
            return $Self->{LayoutObject}->ErrorScreen();
        }
    }

    # dtl block
    $Self->{LayoutObject}->Block(
        Name => 'Explorer',
        Data => { %CategoryData, %Frontend },
    );

    # FAQ path
    $Self->_GetFAQPath(
        CategoryID => $GetParam{CategoryID},
    );

    # explorer title
    if ( $GetParam{CategoryID} ) {
        $Self->{LayoutObject}->Block(
            Name => 'ExplorerTitle',
            Data => {
                Name    => $CategoryData{Name},
                Comment => $CategoryData{Comment}
            },
        );
    }
    else {
        $Self->{LayoutObject}->Block(
            Name => 'ExplorerTitle',
            Data => {
                Name    => $Self->{ConfigObject}->Get('FAQ::Default::RootCategoryName'),
                Comment => $Self->{ConfigObject}->Get('FAQ::Default::RootCategoryComment')
            },
        );
    }

    # explorer category list
    if ( !$Param{Mode} ) {
        $Param{Mode} = 'Public';
    }
    if ( !defined( $Param{CustomerUser} ) ) {
        $Param{CustomerUser} = '';
    }
    if ( $Param{Mode} && $Param{Mode} eq 'Customer' ) {
        $Self->_GetExplorerCategoryList(
            CategoryID   => $GetParam{CategoryID},
            Order        => 'Name',
            Sort         => 'up',
            Mode         => $Param{Mode},
            CustomerUser => $Param{CustomerUser},
        );
    }
    else {
        $Self->_GetExplorerCategoryList(
            CategoryID => $GetParam{CategoryID},
            Order      => 'Name',
            Sort       => 'up',
            Mode       => $Param{Mode},
        );
    }

    # explorer item list
    $Self->_GetExplorerItemList(
        CategoryID => $GetParam{CategoryID},
        Order      => $GetParam{Order} || 'Title',
        Sort       => $GetParam{Sort} || 'up'
    );

    # quicksearch
    my %ShowQuickSearch = %{ $Self->{ConfigObject}->Get('FAQ::Explorer::QuickSearch::Show') };
    if ( exists( $ShowQuickSearch{ $Self->{Interface}{Name} } ) ) {
        $Self->_GetExplorerQuickSearch(
            CategoryID => $GetParam{CategoryID},
        );
    }

    # latest change faq items
    my %ShowLastChange = %{ $Self->{ConfigObject}->Get('FAQ::Explorer::LastChange::Show') };
    if ( exists( $ShowLastChange{ $Self->{Interface}{Name} } ) ) {
        $Self->_GetExplorerLastChangeItems(
            CategoryID   => $GetParam{CategoryID},
            Mode         => $Param{Mode},
            CustomerUser => $Param{CustomerUser},
        );
    }

    # latest create faq items
    my %ShowLastCreate = %{ $Self->{ConfigObject}->Get('FAQ::Explorer::LastCreate::Show') };
    if ( exists( $ShowLastCreate{ $Self->{Interface}{Name} } ) ) {
        $Self->_GetExplorerLastCreateItems(
            CategoryID   => $GetParam{CategoryID},
            Mode         => $Param{Mode},
            CustomerUser => $Param{CustomerUser},
        );
    }
}

sub _GetFAQPath {
    my ( $Self, %Param ) = @_;

    $Self->{LayoutObject}->Block(
        Name => 'FAQPathCategoryElement',
        Data => {
            'Name'       => $Self->{ConfigObject}->Get('FAQ::Default::RootCategoryName'),
            'CategoryID' => '0'
        },
    );

    if ( $Self->{ConfigObject}->Get('FAQ::Explorer::Path::Show') ) {
        my @CategoryList
            = @{ $Self->{FAQObject}->FAQPathListGet( CategoryID => $Param{CategoryID} ) };
        for my $Data (@CategoryList) {
            $Self->{LayoutObject}->Block(
                Name => 'FAQPathCategoryElement',
                Data => { %{$Data} },
            );
        }
        return 1;
    }
    return 0;
}

sub _GetExplorerCategoryList {
    my ( $Self, %Param ) = @_;

    my %Frontend = ();
    $Frontend{CssRow} = '';

    # check needed parameters
    for (qw(Order Sort)) {
        if ( !$Param{$_} ) {
            $Self->{LayoutObject}->FatalError( Message => "Need parameter $_!" )
        }
    }
    my @CategoryIDs = ();
    if ( $Param{Mode} && $Param{Mode} eq 'Agent' ) {
        @CategoryIDs = @{
            $Self->{FAQObject}->AgentCategorySearch(
                ParentID => $Param{CategoryID},
                UserID   => $Self->{UserID},
                )
            };
    }
    elsif ( $Param{Mode} && $Param{Mode} eq 'Customer' ) {
        @CategoryIDs = @{
            $Self->{FAQObject}->CustomerCategorySearch(
                ParentID     => $Param{CategoryID},
                CustomerUser => $Param{CustomerUser},
                )
            };
    }
    else {
        @CategoryIDs = @{
            $Self->{FAQObject}->PublicCategorySearch(
                ParentID => $Param{CategoryID},
                )
            };
    }

    if (@CategoryIDs) {
        $Self->{LayoutObject}->Block(
            Name => 'ExplorerCategoryList',
        );
        for (@CategoryIDs) {
            my %Data = $Self->{FAQObject}->CategoryGet( CategoryID => $_ );
            $Data{CategoryNumber} = $Self->{FAQObject}->CategoryCount(
                ParentIDs => [$_]
            );
            $Data{ArticleNumber} = $Self->{FAQObject}->FAQCount(
                CategoryIDs => [$_],
                ItemStates  => $Self->{InterfaceStates}
            );

            # css configuration
            if ( $Frontend{CssRow} eq 'searchpassive' ) {
                $Frontend{CssRow} = 'searchactive';
            }
            else {
                $Frontend{CssRow} = 'searchpassive';
            }
            $Self->{LayoutObject}->Block(
                Name => 'ExplorerCategoryRow',
                Data => { %Data, %Frontend },
            );
        }
    }
    return;
}

sub _GetExplorerItemList {
    my ( $Self, %Param ) = @_;

    # check needed parameters
    for (qw(Order Sort)) {
        if ( !$Param{$_} ) {
            $Self->{LayoutObject}->FatalError( Message => "Need parameter $_!" )
        }
    }

    my $CssRow  = '';
    my @ItemIDs = $Self->{FAQObject}->FAQSearch(
        CategoryIDs => [ $Param{CategoryID} ],
        States      => $Self->{InterfaceStates},
        Order       => $Param{Order},
        Sort        => $Param{Sort},
        Limit       => 300,
    );

    if (@ItemIDs) {
        $Self->{LayoutObject}->Block(
            Name => 'ExplorerFAQItemList',
            Data => {%Param}
        );
        for (@ItemIDs) {
            my %Frontend = ();
            my %Data = $Self->{FAQObject}->FAQGet( ItemID => $_ );

            # css configuration
            if ( $CssRow eq 'searchpassive' ) {
                $CssRow = 'searchactive';
            }
            else {
                $CssRow = 'searchpassive';
            }
            $Frontend{CssRow}                = $CssRow;
            $Frontend{CssColumnVotingResult} = 'color:'
                . $Self->{LayoutObject}->GetFAQItemVotingRateColor( Rate => $Data{Result} ) . ';';

            $Self->{LayoutObject}->Block(
                Name => 'ExplorerFAQItemRow',
                Data => { %Data, %Frontend },
            );
        }
    }
    return;
}

sub _GetExplorerLastChangeItems {
    my ( $Self, %Param ) = @_;

    if ( $Self->{ConfigObject}->Get('FAQ::Explorer::LastChange::Show') ) {

        # check needed parameters
        for (qw(CategoryID)) {
            if ( !defined( $Param{$_} ) ) {
                $Self->{LayoutObject}->FatalError( Message => "Need parameter $_!" )
            }
        }
        my @ItemIDs = ();
        if ( defined( $Param{CategoryID} ) ) {

            # add current categoryid
            my @CategoryIDs = ();
            if ( $Param{CategoryID} ) {
                push( @CategoryIDs, ( $Param{CategoryID} ) );
            }
            if ( !defined( $Param{Mode} ) ) {
                $Param{Mode} = '';
            }
            if ( !defined( $Param{CustomerUser} ) ) {
                $Param{CustomerUser} = '';
            }

            # add subcategoryids
            if ( $Self->{ConfigObject}->Get('FAQ::Explorer::LastChange::ShowSubCategoryItems') ) {
                my @SubCategoryIDs = @{
                    $Self->{FAQObject}->CategorySubCategoryIDList(
                        ParentID     => $Param{CategoryID},
                        ItemStates   => $Self->{InterfaceStates},
                        Mode         => $Param{Mode},
                        CustomerUser => $Param{CustomerUser},
                        UserID       => $Self->{UserID},
                        )
                    };
                push( @CategoryIDs, @SubCategoryIDs );
            }
            $Self->{LayoutObject}->Block(
                Name => 'ExplorerLatestChange'
            );
            if ( $Param{Mode} =~ /public/i ) {
                $Self->{LayoutObject}->Block(
                    Name => 'ExplorerLatestChangeRss',
                    Data => {},
                );
            }
            if (@CategoryIDs) {
                @ItemIDs = $Self->{FAQObject}->FAQSearch(
                    CategoryIDs => \@CategoryIDs,
                    States      => $Self->{InterfaceStates},
                    Order       => 'Changed',
                    Sort        => 'down',
                    Limit       => $Self->{ConfigObject}->Get('FAQ::Explorer::LastChange::Limit')
                );
            }
        }
        else {
            $Self->{LayoutObject}->Block(
                Name => 'ExplorerLatestChange'
            );
            @ItemIDs = $Self->{FAQObject}->FAQSearch(
                States => $Self->{InterfaceStates},
                Order  => 'Changed',
                Sort   => 'down',
                Limit  => $Self->{ConfigObject}->Get('FAQ::Explorer::LastChange::Limit')
            );
        }
        for (@ItemIDs) {
            my %Data = $Self->{FAQObject}->FAQGet( ItemID => $_ );
            $Self->{LayoutObject}->Block(
                Name => 'ExplorerLatestChangeFAQItemRow',
                Data => {%Data},
            );
        }
        return 1;
    }
    return 0;
}

sub _GetExplorerLastCreateItems {
    my ( $Self, %Param ) = @_;

    if ( $Self->{ConfigObject}->Get('FAQ::Explorer::LastCreate::Show') ) {

        # check needed parameters
        for (qw(CategoryID)) {
            if ( !defined( $Param{$_} ) ) {
                $Self->{LayoutObject}->FatalError( Message => "Need parameter $_!" )
            }
        }
        my @ItemIDs = ();
        if ( defined( $Param{CategoryID} ) ) {

            # add current categoryid
            my @CategoryIDs = ();
            if ( $Param{CategoryID} ) {
                push( @CategoryIDs, ( $Param{CategoryID} ) );
            }
            if ( !defined( $Param{Mode} ) ) {
                $Param{Mode} = '';
            }
            if ( !defined( $Param{CustomerUser} ) ) {
                $Param{CustomerUser} = '';
            }

            # add subcategoryids
            if ( $Self->{ConfigObject}->Get('FAQ::Explorer::LastCreate::ShowSubCategoryItems') ) {
                my @SubCategoryIDs = @{
                    $Self->{FAQObject}->CategorySubCategoryIDList(
                        ParentID     => $Param{CategoryID},
                        ItemStates   => $Self->{InterfaceStates},
                        Mode         => $Param{Mode},
                        CustomerUser => $Param{CustomerUser},
                        UserID       => $Self->{UserID},
                        )
                    };
                push( @CategoryIDs, @SubCategoryIDs );
            }
            $Self->{LayoutObject}->Block(
                Name => 'ExplorerLatestCreate'
            );
            if ( $Param{Mode} =~ /public/i ) {
                $Self->{LayoutObject}->Block(
                    Name => 'ExplorerLatestCreateRss',
                    Data => {},
                );
            }
            if (@CategoryIDs) {
                @ItemIDs = $Self->{FAQObject}->FAQSearch(
                    CategoryIDs => \@CategoryIDs,
                    States      => $Self->{InterfaceStates},
                    Order       => 'Created',
                    Sort        => 'down',
                    Limit       => $Self->{ConfigObject}->Get('FAQ::Explorer::LastCreate::Limit')
                );
            }
        }
        else {
            $Self->{LayoutObject}->Block(
                Name => 'ExplorerLatestCreate'
            );
            @ItemIDs = $Self->{FAQObject}->FAQSearch(
                States => $Self->{InterfaceStates},
                Order  => 'Created',
                Sort   => 'down',
                Limit  => $Self->{ConfigObject}->Get('FAQ::Explorer::LastCreate::Limit')
            );
        }

        # dtl block
        for (@ItemIDs) {
            my %Data = $Self->{FAQObject}->FAQGet( ItemID => $_ );
            $Self->{LayoutObject}->Block(
                Name => 'ExplorerLatestCreateFAQItemRow',
                Data => {%Data},
            );
        }
        return 1;
    }
    return 0;
}

sub _GetExplorerQuickSearch {
    my ( $Self, %Param ) = @_;

    if ( $Self->{ConfigObject}->Get('FAQ::Explorer::QuickSearch::Show') ) {

        # check needed parameters
        for (qw()) {
            if ( !$Param{$_} ) {
                $Self->{LayoutObject}->FatalError( Message => "Need parameter $_!" )
            }
        }

        # dtl block
        $Self->{LayoutObject}->Block(
            Name => 'ExplorerQuickSearch',
            Data => { CategoryID => $Param{CategoryID} }
        );
        return 1;
    }
    return 0;
}

sub GetItemView {
    my ( $Self, %Param ) = @_;

    my %Frontend = ();
    my %GetParam = ();
    my @Params   = qw(ItemID);

    # manage parameters
    for (@Params) {
        if ( !( $GetParam{$_} = $Self->{ParamObject}->GetParam( Param => $_ ) ) ) {
            $Self->{LayoutObject}->FatalError( Message => "Need parameter $_" );
        }
    }

    # db action
    my %ItemData = $Self->{FAQObject}->FAQGet(
        ItemID => $GetParam{ItemID},
        UserID => $Self->{UserID},
    );

    # html quoting
    for my $Key (qw (Field1 Field2 Field3 Field4 Field5 Field6)) {
        if ( $Self->{ConfigObject}->Get('FAQ::Item::HTML') ) {
            my @Array = split /pre>/, $ItemData{$Key};
            my $Text = '';
            for (@Array) {
                if ( $_ =~ /(.*)\<\/$/ ) {
                    $Text .= 'pre>' . $_ . 'pre>';
                }
                else {
                    $_ =~ s/\n/\<br\>/g;
                    $Text .= $_;
                }
            }
            $ItemData{$Key} = $Text;
        }
        else {
            $ItemData{$Key} = $Self->{LayoutObject}->Ascii2Html(
                NewLine        => 0,
                Text           => $ItemData{$Key},
                VMax           => 5000,
                HTMLResultMode => 1,
                LinkFeature    => 1,
            );
        }
    }
    if ( !%ItemData ) {
        return $Self->{LayoutObject}->ErrorScreen();
    }

    # permission check
    if ( !exists( $Self->{InterfaceStates}{ $ItemData{StateTypeID} } ) ) {
        return $Self->{LayoutObject}->NoPermission( WithHeader => 'yes' );
    }

    # user info
    my %UserInfo = $Self->{AgentUserObject}->GetUserData(
        UserID => $ItemData{CreatedBy},
    );
    $Frontend{CreatedByLogin} = $UserInfo{UserLogin};
    %UserInfo = $Self->{AgentUserObject}->GetUserData(
        UserID => $ItemData{ChangedBy},
    );
    $Frontend{ChangedByLogin} = $UserInfo{UserLogin};

    # item view
    $Frontend{CssColumnVotingResult} = 'color:'
        . $Self->{LayoutObject}->GetFAQItemVotingRateColor( Rate => $ItemData{Result} ) . ';';
    $Self->{LayoutObject}->Block(
        Name => 'View',
        Data => { %Param, %ItemData, %Frontend },
    );
    if ( $Param{Permission} && $Param{Permission} eq 'rw' ) {
        $Self->{LayoutObject}->Block(
            Name => 'FAQItemViewLinkUpdate',
            Data => { %Param, %ItemData, %Frontend },
        );
        $Self->{LayoutObject}->Block(
            Name => 'FAQItemViewLinkDelete',
            Data => { %Param, %ItemData, %Frontend },
        );
    }

    # FAQ path
    if ( $Self->_GetFAQPath( CategoryID => $ItemData{CategoryID} ) ) {
        $Self->{LayoutObject}->Block(
            Name => 'FAQPathItemElement',
            Data => \%ItemData,
        );
    }

    # item attachment
    my @AttachmentIndex = $Self->{FAQObject}->AttachmentIndex(
        ItemID => $GetParam{ItemID},
    );
    if (@AttachmentIndex) {
        $Self->{LayoutObject}->Block(
            Name => 'FAQItemViewAttachment',
            Data => {%ItemData},
        );
        for my $Attachment (@AttachmentIndex) {
            $Self->{LayoutObject}->Block(
                Name => 'FAQItemViewAttachmentRow',
                Data => { %ItemData, %{$Attachment} },
            );
        }
    }

    # item fields
    $Self->_GetItemFields(
        ItemData => \%ItemData
    );

    # item voting
    my %ShowItemVoting = %{ $Self->{ConfigObject}->Get('FAQ::Item::Voting::Show') };
    if ( exists( $ShowItemVoting{ $Self->{Interface}{Name} } ) ) {
        $Self->_GetItemVoting(
            ItemData => \%ItemData
        );
    }

    if ( $Param{Links} && $Param{Links} == 1 ) {

        # get linked objects
        my $LinkListWithData = $Self->{LinkObject}->LinkListWithData(
            Object => 'FAQ',
            Key    => $GetParam{ItemID},
            State  => 'Valid',
            UserID => $Self->{UserID},
        );

        # get link table view mode
        my $LinkTableViewMode = $Self->{ConfigObject}->Get('LinkObject::ViewMode');

        # create the link table
        my $LinkTableStrg = $Self->{LayoutObject}->LinkObjectTableCreate(
            LinkListWithData => $LinkListWithData,
            ViewMode         => $LinkTableViewMode,
        );

        # output the simple link table
        if ($LinkTableStrg) {
            $Self->{LayoutObject}->Block(
                Name => 'LinkTable' . $LinkTableViewMode,
                Data => {
                    LinkTableStrg => $LinkTableStrg,
                },
            );
        }
    }
    return;
}

sub GetItemSmallView {
    my ( $Self, %Param ) = @_;

    my %Frontend = ();
    my %GetParam = ();
    my @Params   = qw(ItemID);

    # manage parameters
    for (@Params) {
        if ( !( $GetParam{$_} = $Self->{ParamObject}->GetParam( Param => $_ ) ) ) {
            $Self->{LayoutObject}->FatalError( Message => "Need parameter $_" );
        }
    }

    # db action
    my %ItemData = $Self->{FAQObject}->FAQGet(
        ItemID => $GetParam{ItemID},
        UserID => $Self->{UserID},
    );
    if ( !%ItemData ) {
        return $Self->{LayoutObject}->ErrorScreen();
    }

    # permission check
    if ( !exists( $Self->{InterfaceStates}{ $ItemData{StateTypeID} } ) ) {
        return $Self->{LayoutObject}->NoPermission( WithHeader => 'yes' );
    }

    # user info
    my %UserInfo = $Self->{AgentUserObject}->GetUserData(
        UserID => $ItemData{CreatedBy},
    );
    $Frontend{CreatedByLogin} = $UserInfo{UserLogin};
    %UserInfo = $Self->{AgentUserObject}->GetUserData(
        UserID => $ItemData{ChangedBy},
    );
    $Frontend{ChangedByLogin} = $UserInfo{UserLogin};

    # item view
    $Frontend{CssColumnVotingResult} = 'color:'
        . $Self->{LayoutObject}->GetFAQItemVotingRateColor( Rate => $ItemData{Result} ) . ';';
    $Frontend{ItemFieldValues} = $Self->_GetItemFieldValues( ItemData => \%ItemData );
    $Self->{LayoutObject}->Block(
        Name => 'ViewSmall',
        Data => { %Param, %ItemData, %Frontend },
    );

    # FAQ path
    if ( $Self->_GetFAQPath( CategoryID => $ItemData{CategoryID} ) ) {
        $Self->{LayoutObject}->Block(
            Name => 'FAQPathItemElementSmall',
            Data => \%ItemData,
        );
    }

    # item attachment
    if ( defined( $ItemData{Filename} ) ) {
        $Self->{LayoutObject}->Block(
            Name => 'FAQItemViewAttachmentSmall',
            Data => { %Param, %ItemData },
        );
    }

    # get linked objects
    # lookup the link state id
    my $LinkStateID = $Self->{LinkObject}->StateLookup(
        Name   => 'Valid',
        UserID => $Self->{UserID},
    );

    # get linked objects
    my $ExistingLinks = $Self->{LinkObject}->LinksGet(
        Object  => 'FAQ',
        Key     => $GetParam{ItemID},
        StateID => $LinkStateID,
        UserID  => $Self->{UserID},
    );

    # prepare the output hash
    for my $Object ( sort { lc $a cmp lc $b } keys %{$ExistingLinks} ) {

        # get object description
        my %ObjectDescription = $Self->{LinkObject}->ObjectDescriptionGet(
            Object => $Object,
            UserID => $Self->{UserID},
        );

        for my $Type ( sort { lc $a cmp lc $b } keys %{ $ExistingLinks->{$Object} } ) {

            # lookup type id
            my $TypeID = $Self->{LinkObject}->TypeLookup(
                Name   => $Type,
                UserID => $Self->{UserID},
            );

            # get type data
            my %TypeData = $Self->{LinkObject}->TypeGet(
                TypeID => $TypeID,
                UserID => $Self->{UserID},
            );

            for my $Direction ( keys %{ $ExistingLinks->{$Object}->{$Type} } ) {

                my $LinkTypeName
                    = $Direction eq 'Target' ? $TypeData{TargetName} : $TypeData{SourceName};

                $Self->{LayoutObject}->Block(
                    Name => 'Link',
                    Data => {
                        %Param,
                        LinkTypeName => $LinkTypeName,
                    },
                );

                for my $ItemKey ( @{ $ExistingLinks->{$Object}->{$Type}->{$Direction} } ) {

                    # get item description
                    my %ItemDescription = $Self->{LinkObject}->ItemDescriptionGet(
                        Object => $Object,
                        Key    => $ItemKey,
                        UserID => $Self->{UserID},
                    );

                    # extract cell value
                    my $Content = $ItemDescription{ItemData}
                        ->{ $ObjectDescription{Overview}->{Normal}->{Key} } || '';

                    my $LinkString = $Self->{LayoutObject}->LinkObjectContentStringCreate(
                        SourceObject => {
                            Object => 'FAQ',
                            Key    => $Self->{ItemID},
                        },
                        TargetObject => {
                            Object => $Object,
                            Key    => $ItemKey,
                        },
                        TargetItemDescription => \%ItemDescription,
                        ColumnData            => $ObjectDescription{Overview}->{Normal},
                        Content               => $Content,
                    );

                    $Self->{LayoutObject}->Block(
                        Name => 'LinkItem',
                        Data => {
                            LinkString => $LinkString,
                        },
                    );
                }
            }
        }
    }
    return;
}

sub GetItemPrint {
    my ( $Self, %Param ) = @_;

    my %GetParam = ();
    my @Params   = qw(ItemID);

    # manage parameters
    for (@Params) {
        if ( !( $GetParam{$_} = $Self->{ParamObject}->GetParam( Param => $_ ) ) ) {
            $Self->{LayoutObject}->FatalError( Message => "Need parameter $_" );
        }
    }

    # db action
    my %ItemData = $Self->{FAQObject}->FAQGet(
        ItemID => $GetParam{ItemID},
        UserID => $Self->{UserID},
    );
    if ( !%ItemData ) {
        return $Self->{LayoutObject}->ErrorScreen();
    }

    # html quoting
    for my $Key (qw (Field1 Field2 Field3 Field4 Field5 Field6)) {
        if ( $Self->{ConfigObject}->Get('FAQ::Item::HTML') ) {
            $ItemData{$Key} =~ s/\n/\<br\>/g;
        }
        else {
            $ItemData{$Key} = $Self->{LayoutObject}->Ascii2Html(
                NewLine        => 0,
                Text           => $ItemData{$Key},
                VMax           => 5000,
                HTMLResultMode => 1,
                LinkFeature    => 1,
            );
        }
    }

    # permission check
    if ( !exists( $Self->{InterfaceStates}{ $ItemData{StateTypeID} } ) ) {
        return $Self->{LayoutObject}->NoPermission( WithHeader => 'yes' );
    }

    # add article
    $Self->{LayoutObject}->Block(
        Name => 'Print',
        Data => \%ItemData,
    );

    # fields
    $Self->_GetItemFields(
        ItemData => \%ItemData
    );
    return;
}

sub _GetItemFields {
    my ( $Self, %Param ) = @_;

    my %GetParam = ();
    my @Params   = qw(ItemData);

    # manage parameters
    for (@Params) {
        if ( !exists( $Param{$_} ) ) {
            return $Self->{LayoutObject}->FatalError( Message => "Need parameter $_" );
        }
    }

    # config values
    my %ItemFields = ();
    for ( my $i = 1; $i < 7; $i++ ) {
        my %ItemConfig = %{ $Self->{ConfigObject}->Get( 'FAQ::Item::Field' . $i ) };
        if ( $ItemConfig{Show} ) {
            $ItemFields{ "Field" . $i } = \%ItemConfig;
        }
    }
    for my $Key ( sort( { $ItemFields{$a}{Prio} <=> $ItemFields{$b}{Prio} } keys(%ItemFields) ) ) {
        my %StateTypeData = %{
            $Self->{FAQObject}->StateTypeGet(
                Name => $ItemFields{$Key}{Show}
                )
            };

        # show yes /no
        if ( exists( $Self->{InterfaceStates}{ $StateTypeData{ID} } ) ) {
            $Self->{LayoutObject}->Block(
                Name => 'FAQItemField',
                Data => {
                    %{ $ItemFields{$Key} },
                    'StateName' => $StateTypeData{Name},
                    'Key'       => $Key,
                    'Value'     => $Param{ItemData}{$Key} || '',
                },
            );
        }
    }
    return;
}

sub _GetItemFieldValues {
    my ( $Self, %Param ) = @_;

    my %GetParam = ();
    my @Params   = qw(ItemData);

    # manage parameters
    for (@Params) {
        if ( !exists( $Param{$_} ) ) {
            return $Self->{LayoutObject}->FatalError( Message => "Need parameter $_" );
        }
    }

    # config values
    my %ItemFields = ();
    for ( my $i = 1; $i < 7; $i++ ) {
        my %ItemConfig = %{ $Self->{ConfigObject}->Get( 'FAQ::Item::Field' . $i ) };
        if ( $ItemConfig{Show} ) {
            $ItemFields{ "Field" . $i } = \%ItemConfig;
        }
    }
    my $String = '';
    for my $Key ( sort( { $ItemFields{$a}{Prio} <=> $ItemFields{$b}{Prio} } keys(%ItemFields) ) ) {
        if ( $ItemFields{$Key}{Show} eq 'internal' ) {
            next;
        }
        my %StateTypeData = %{
            $Self->{FAQObject}->StateTypeGet(
                Name => $ItemFields{$Key}{Show}
                )
            };

        # show yes /no
        if ( exists( $Self->{InterfaceStates}{ $StateTypeData{ID} } ) ) {
            $String .= $Param{ItemData}{$Key} || '';
            $String .= "\n\n";
        }
    }
    return $String;
}

sub _GetItemVoting {
    my ( $Self, %Param ) = @_;

    # check needed parameters
    for (qw(ItemData)) {
        if ( !$Param{$_} ) {
            $Self->{LayoutObject}->FatalError( Message => "Need parameter $_!" );
        }
    }
    my %ItemData = %{ $Param{ItemData} };

    $Self->{LayoutObject}->Block(
        Name => "Voting"
    );
    my %VoteData = %{
        $Self->{FAQObject}->VoteGet(
            CreateBy  => $Self->{UserID},
            ItemID    => $ItemData{ItemID},
            Interface => $Self->{Interface}{ID},
            IP        => $ENV{'REMOTE_ADDR'},
            )
        };

    my $Flag = 0;

    # already voted?
    if (%VoteData) {

        # item/change_time > voting/create_time
        my $ItemChangedSystemTime
            = $Self->{TimeObject}->TimeStamp2SystemTime( String => $ItemData{Changed} || '' );
        my $VoteCreatedSystemTime
            = $Self->{TimeObject}->TimeStamp2SystemTime( String => $VoteData{Created} || '' );

        if ( $ItemChangedSystemTime > $VoteCreatedSystemTime ) {
            $Flag = 1;
        }
        else {
            push( @{ $Self->{Notify} }, [ 'Info', 'You have already voted!' ] );
            return;
        }
    }
    else {
        $Flag = 1;
    }
    if ( $Self->{Subaction} eq 'Vote' && $Flag ) {

        # check needed parameters
        for (qw(ItemData)) {
            if ( !$Param{$_} ) {
                $Self->{LayoutObject}->FatalError( Message => "Need parameter $_!" )
            }
        }

        # manage parameters
        my %GetParam = ();
        my @Params   = qw(ItemID Rate);
        for (@Params) {
            $GetParam{$_} = $Self->{ParamObject}->GetParam( Param => $_ );
        }

        if ( $GetParam{Rate} eq '0' or $GetParam{Rate} ) {
            $Self->{FAQObject}->VoteAdd(
                CreatedBy => $Self->{UserID},
                ItemID    => $GetParam{ItemID},
                IP        => $ENV{'REMOTE_ADDR'},
                Interface => $Self->{Interface}{ID},
                Rate      => $GetParam{Rate},
            );
            push( @{ $Self->{Notify} }, [ 'Info', 'Thanks for vote!' ] );
            return;

        }
        else {
            push( @{ $Self->{Notify} }, [ 'Error', 'No rate selected!' ] );
            $Self->GetItemVotingForm(
                ItemData => $Param{ItemData}
            );

            return;
        }
    }

    # form
    $Self->_GetItemVotingForm(
        ItemData => $Param{ItemData}
    );

    return;
}

sub _GetItemVotingForm {
    my ( $Self, %Param ) = @_;

    # check needed parameters
    for (qw(ItemData)) {
        if ( !$Param{$_} ) {
            $Self->{LayoutObject}->FatalError( Message => "Need parameter $_!" )
        }
    }
    $Self->{LayoutObject}->Block(
        Name => 'VoteForm',
        Data => { %Param, %{ $Param{ItemData} } }
    );

    my %VotingRates = %{ $Self->{ConfigObject}->Get('FAQ::Item::Voting::Rates') };
    for my $key ( sort( { $b <=> $a } keys(%VotingRates) ) ) {
        my %Data = ( "Value" => $key, "Title" => $VotingRates{$key} );
        $Self->{LayoutObject}->Block(
            Name => "VotingRateRow",
            Data => \%Data,
        );
    }
    return;
}

sub GetItemSearch {
    my ( $Self, %Param ) = @_;

    my %GetParam = ();
    my %Frontend = ();

    # get params
    for (qw(LanguageIDs CategoryIDs)) {
        my @Array = $Self->{ParamObject}->GetArray( Param => $_ );
        if (@Array) {
            $GetParam{$_} = \@Array;
        }
    }
    for (qw(QuickSearch Number Title What Keyword)) {
        $GetParam{$_} = $Self->{ParamObject}->GetParam( Param => $_ );
    }

    # quicksearch in subcategories?
    if ( $GetParam{QuickSearch} ) {
        if ( $Self->{ConfigObject}->Get('FAQ::Explorer::QuickSearch::ShowSubCategoryItems') ) {
            if ( !$Param{Mode} ) {
                $Param{Mode} = 'Public';
            }
            if ( !defined( $Param{User} ) ) {
                $Param{User} = '';
            }
            my @SubCategoryIDs = @{
                $Self->{FAQObject}->CategorySubCategoryIDList(
                    ParentID     => $GetParam{CategoryIDs}->[0],
                    ItemStates   => $Self->{InterfaceStates},
                    CustomerUser => $Param{CustomerUser},
                    UserID       => $Param{User},
                    Mode         => $Param{Mode},
                    )
                };
            push( @{ $GetParam{CategoryIDs} }, @SubCategoryIDs );
        }
    }
    $Frontend{LanguageOption} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data                => { $Self->{FAQObject}->LanguageList() },
        Size                => 5,
        Name                => 'LanguageIDs',
        Multiple            => 1,
        SelectedIDRefArray  => $GetParam{LanguageIDs} || [],
        HTMLQuote           => 1,
        LanguageTranslation => 0,
    );
    my $Categories = ();
    if ( $Param{Mode} && $Param{Mode} eq 'Agent' ) {
        $Categories = $Self->{FAQObject}->GetUserCategories(
            UserID => $Self->{UserID},
            Type   => 'rw'
        );
    }
    elsif ( $Param{Mode} && $Param{Mode} eq 'Customer' ) {
        $Categories = $Self->{FAQObject}->GetCustomerCategories(
            CustomerUser => $Param{CustomerUser},
            Type         => 'rw'
        );
    }
    else {
        $Categories = $Self->{FAQObject}->CategoryList();
    }
    $Frontend{CategoryOption} = $Self->{LayoutObject}->AgentFAQCategoryListOption(
        CategoryList        => { %{$Categories} },
        Size                => 5,
        Name                => 'CategoryIDs',
        Multiple            => 1,
        SelectedIDs         => $GetParam{CategoryIDs} || [],
        HTMLQuote           => 1,
        LanguageTranslation => 0,
    );
    $Self->{LayoutObject}->Block(
        Name => 'Search',
        Data => { %Param, %GetParam, %Frontend },
    );

    # build result
    if ( $Self->{ParamObject}->GetParam( Param => 'Submit' ) ) {
        my $CssRow = '';

        my @ItemIDs = $Self->{FAQObject}->FAQSearch(
            %Param,
            %GetParam,
            States => $Self->{InterfaceStates},
            Limit  => 25,
        );
        $Self->{LayoutObject}->Block(
            Name => 'SearchResult',
            Data => { %Param, %Frontend },
        );
        for (@ItemIDs) {
            %Frontend = ();
            my %Data = $Self->{FAQObject}->FAQGet( ItemID => $_ );
            my $Permission = 'ro';
            if ( $Param{Mode} && $Param{Mode} eq 'Agent' ) {
                $Permission = $Self->{FAQObject}->CheckCategoryUserPermission(
                    UserID     => $Param{User},
                    CategoryID => $Data{CategoryID},
                );
            }
            elsif ( $Param{Mode} && $Param{Mode} eq 'Customer' ) {
                $Permission = $Self->{FAQObject}->CheckCategoryCustomerPermission(
                    CustomerUser => $Param{CustomerUser},
                    CategoryID   => $Data{CategoryID},
                );
            }
            if ( $Permission ne '' ) {
                if ( $CssRow eq 'searchpassive' ) {
                    $CssRow = 'searchactive';
                }
                else {
                    $CssRow = 'searchpassive';
                }
                $Data{CssRow} = $CssRow;
                $Frontend{CssColumnVotingResult}
                    = 'color:'
                    . $Self->{LayoutObject}->GetFAQItemVotingRateColor( Rate => $Data{Result} )
                    . ';';

                $Self->{LayoutObject}->Block(
                    Name => 'SearchResultRow',
                    Data => { %Data, %Frontend },
                );
            }
        }
    }
    return;
}

sub GetSystemHistory {
    my ( $Self, %Param ) = @_;

    my %Frontend = ();

    $Self->{LayoutObject}->Block(
        Name => 'SystemHistory',
        Data => {%Param},
    );

    $Frontend{CssRow} = '';
    my @History = @{ $Self->{FAQObject}->HistoryGet() };
    for my $Row (@History) {

        # css configuration
        if ( $Frontend{CssRow} eq 'searchpassive' ) {
            $Frontend{CssRow} = 'searchactive';
        }
        else {
            $Frontend{CssRow} = 'searchpassive';
        }
        my %Data = %{$Row};    #$Self->{FAQObject}->FAQGet(ItemID => $Row->{ItemID});
        my %User = $Self->{UserObject}->GetUserData(
            UserID => $Row->{CreatedBy},
            Cached => 1,
        );
        $Self->{LayoutObject}->Block(
            Name => 'SystemHistoryRow',
            Data => { %Data, %Frontend, %User, Name => $Row->{Name} },
        );
    }
    return;
}

1;
