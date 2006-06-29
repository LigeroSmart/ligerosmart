# --
# Kernel/Modules/AgentFAQ.pm - faq module
# Copyright (C) 2001-2005 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: FAQ.pm,v 1.1.1.1 2006-06-29 09:29:51 ct Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::FAQ;

use strict;
use Kernel::System::User;
use Kernel::System::FAQ;
use Kernel::System::LinkObject;

use vars qw($VERSION);
$VERSION = '$Revision: 1.1.1.1 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

# --
sub new {
    my $Type = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {};
    bless ($Self, $Type);

    foreach (keys %Param) {
        $Self->{$_} = $Param{$_};
    }

    # check needed Opjects
    foreach (qw(ParamObject DBObject LayoutObject LogObject ConfigObject UserObject)) {
        $Self->{LayoutObject}->FatalError(Message => "Got no $_!") if (!$Self->{$_});
    }

    # faq object
    $Self->{FAQObject} = Kernel::System::FAQ->new(%Param);
    # link object
    $Self->{LinkObject} = Kernel::System::LinkObject->new(%Param); 
    # agent user
    $Self->{AgentUserObject} = Kernel::System::User->new(%Param);    
    
    
    # interface settings
    # ********************************************************** #   
    $Self->{Interface} = $Self->{FAQObject}->StateTypeGet(
        Name => 'public'
    );      
    $Self->{InterfaceStates} = $Self->{FAQObject}->StateTypeList(
        Types => ['public']
    );
    
    # global output vars
    $Self->{Notify} = [];         

       
    # store last screen
    # ********************************************************** #     
    if($Self->{SessionObject}) {
        if($Self->{Subaction} eq 'Explorer') {
            $Self->{SessionObject}->UpdateSessionID(
                SessionID => $Self->{SessionID},
                Key => 'LastScreenOverview',
                Value => $Self->{RequestedURL},
            );
        } else {
            $Self->{SessionObject}->UpdateSessionID(
                SessionID => $Self->{SessionID},
                Key => 'LastScreenView',
                Value => $Self->{RequestedURL},
            );
        }  
    }
    
    return $Self;
}

sub GetExplorer {

    my $Self = shift;
    my %Param = @_;
    
    my %Frontend = ();
    my %GetParam = ();        
    my @Params = qw(Order Sort);    
                 
    # manage parameters
    # ********************************************************** # 
    $GetParam{CategoryID} = $Self->{ParamObject}->GetParam(Param => 'CategoryID') || 0;                             
    $GetParam{Order} = $Self->{ParamObject}->GetParam(Param => 'Order') || 'Title';
    $GetParam{Sort} = $Self->{ParamObject}->GetParam(Param => 'Sort') || 'up';        
    foreach (@Params) {
        if(!$GetParam{$_} && !($GetParam{$_} = $Self->{ParamObject}->GetParam(Param => $_))) {
            return $Self->{LayoutObject}->FatalError(Message => "Need parameter $_");
        }
    }       

    # store back link
    # ********************************************************** #    
    if($Self->{SessionObject}) {
        $Self->{SessionObject}->UpdateSessionID(
            SessionID => $Self->{SessionID},
            Key => 'LastScreenView',
            Value => $Self->{RequestedURL},
        );    
    }

    # db action
    # ********************************************************** #    
    my %CategoryData = ();
    if($GetParam{CategoryID}) {                           
        %CategoryData = $Self->{FAQObject}->CategoryGet(CategoryID => $GetParam{CategoryID}, UserID => $Self->{UserID});        
        if (!%CategoryData) {
            return $Self->{LayoutObject}->ErrorScreen();
        }       
    }
    
    # dtl block
    # ********************************************************** #        
    $Frontend{LastScreenOverview} = $Self->{RequestedURL};                         
    $Self->{LayoutObject}->Block(
        Name => 'Explorer',
        Data => { %CategoryData, %Frontend },
    );
       
    # FAQ path
    # ********************************************************** #           
    $Self->_GetFAQPath(
        CategoryID => $GetParam{CategoryID},
    );
      
    # explorer title
    # ********************************************************** #
    if($GetParam{CategoryID}) {        
        $Self->{LayoutObject}->Block(
            Name => 'ExplorerTitle',
            Data => { 
                        'Name' => $CategoryData{Name},
                        'Comment' => $CategoryData{Comment}                    
                    },
        );    
    } else {
        $Self->{LayoutObject}->Block(
            Name => 'ExplorerTitle',
            Data => {
                        'Name' => $Self->{ConfigObject}->Get('FAQ::Default::RootCategoryName'),
                        'Comment' => $Self->{ConfigObject}->Get('FAQ::Default::RootCategoryComment')                    
                    },
        );        
    }

    # explorer category list
    # ********************************************************** #
    $Self->_GetExplorerCategoryList(
        CategoryID => $GetParam{CategoryID},
        Order => 'Name',
        Sort => 'up'
    );        

    # explorer item list
    # ********************************************************** #
    $Self->_GetExplorerItemList(
        CategoryID => $GetParam{CategoryID},    
        Order => $GetParam{Order} || 'Title',
        Sort => $GetParam{Sort} || 'up'
    );                  
            
    # quicksearch
    # ********************************************************** #
    my %ShowQuickSearch = %{$Self->{ConfigObject}->Get('FAQ::Explorer::QuickSearch::Show')};
    if(exists($ShowQuickSearch{$Self->{Interface}{Name}})) {    
        $Self->_GetExplorerQuickSearch(
            CategoryID => $GetParam{CategoryID},     
        );        
    }

        
        # latest change faq items
    # ********************************************************** # 
    my %ShowLastChange = %{$Self->{ConfigObject}->Get('FAQ::Explorer::LastChange::Show')};
    if(exists($ShowLastChange{$Self->{Interface}{Name}})) {       
        $Self->_GetExplorerLastChangeItems(
            CategoryID => $GetParam{CategoryID},     
        );                            
    }
    
    # latest create faq items
    # ********************************************************** #  
    my %ShowLastCreate = %{$Self->{ConfigObject}->Get('FAQ::Explorer::LastCreate::Show')};
    if(exists($ShowLastCreate{$Self->{Interface}{Name}})) {    
        $Self->_GetExplorerLastCreateItems(
            CategoryID => $GetParam{CategoryID},     
        );  
    }
    
}

sub _GetFAQPath {
    my $Self = shift;
    my %Param = @_; 
    
    $Self->{LayoutObject}->Block(
        Name => 'FAQPathCategoryElement',
        Data => { 'Name' => $Self->{ConfigObject}->Get('FAQ::Default::RootCategoryName'),
                  'CategoryID' => '0'
                },
    );     
    
    if($Self->{ConfigObject}->Get('FAQ::Explorer::Path::Show')) {  
        my @CategoryList = @{$Self->{FAQObject}->FAQPathListGet(CategoryID => $Param{CategoryID})};
        foreach my $Data (@CategoryList) {
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
    my $Self = shift;
    my %Param = @_; 
    my %Frontend = ();
    $Frontend{CssRow} = '';
    
    # check needed parameters
    # ********************************************************** # 
    foreach (qw(Order Sort)) {
        if (!$Param{$_}) {
            $Self->{LayoutObject}->FatalError(Message => "Need parameter $_!") 
        }
    }

    my @CategoryIDs = @{$Self->{FAQObject}->CategorySearch(
        ParentID => $Param{CategoryID},
        ValidID => 1,        
        Order => $Param{Order},
        Sort => $Param{Sort}
    )};
    
    if(@CategoryIDs) {
        $Self->{LayoutObject}->Block(
            Name => 'ExplorerCategoryList',
        );    
        foreach (@CategoryIDs) {
            my %Data = $Self->{FAQObject}->CategoryGet(CategoryID => $_);
            $Data{CategoryNumber} = $Self->{FAQObject}->CategoryCount(
                ParentIDs => [$_]
            );            
            $Data{ArticleNumber} = $Self->{FAQObject}->FAQCount(
                CategoryIDs => [$_],
                ItemStates => $Self->{InterfaceStates}
            );                        
            
            # css configuration
            # rows
            if($Frontend{CssRow} eq 'searchpassive') {
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
    my $Self = shift;
    my %Param = @_;

    # check needed parameters
    foreach (qw(Order Sort)) {
        if (!$Param{$_}) {
            $Self->{LayoutObject}->FatalError(Message => "Need parameter $_!") 
        }
    }

    my $CssRow = ''; 
    my @ItemIDs = $Self->{FAQObject}->FAQSearch(
        CategoryIDs => [$Param{CategoryID}],
        States => $Self->{InterfaceStates},
        Order => $Param{Order},
        Sort => $Param{Sort},
        Limit => 300,
    );
    
    if(@ItemIDs) {
        $Self->{LayoutObject}->Block(
            Name => 'ExplorerFAQItemList',
            Data => {%Param}
        );    
        foreach (@ItemIDs) {
        
            my %Frontend = ();
            my %Data = $Self->{FAQObject}->FAQGet(ItemID => $_);
            
            # css configuration
            # rows
            if($CssRow eq 'searchpassive') {
                $CssRow = 'searchactive';
            }
            else {
                $CssRow = 'searchpassive';
            }        
            $Frontend{CssRow} = $CssRow;
            
            $Frontend{CssColumnVotingResult} = 'color:'.$Self->{LayoutObject}->GetFAQItemVotingRateColor(Rate => $Data{Result}).';';
    
            
            $Self->{LayoutObject}->Block(
                Name => 'ExplorerFAQItemRow',
                Data => { %Data, %Frontend },
            );
            
        }        
    }
    return;
}


sub _GetExplorerLastChangeItems {
    my $Self = shift;
    my %Param = @_;
    
    if($Self->{ConfigObject}->Get('FAQ::Explorer::LastChange::Show')) {         
        
        # check needed parameters
        foreach (qw(CategoryID)) {
            if (!defined($Param{$_})) {
                $Self->{LayoutObject}->FatalError(Message => "Need parameter $_!") 
            }
        }
        my @ItemIDs = ();
        if($Param{CategoryID}) {
            # add current categoryid
            my @CategoryIDs = (); 
            if($Param{CategoryID}) {
                push(@CategoryIDs, ($Param{CategoryID}));
            }               
            
            # add subcategoryids
            if($Self->{ConfigObject}->Get('FAQ::Explorer::LastChange::ShowSubCategoryItems')) {                
                my @SubCategoryIDs = @{$Self->{FAQObject}->CategorySubCategoryIDList(
                    ParentID => $Param{CategoryID},
                    ItemStates => $Self->{InterfaceStates},         
                )};                     
                push(@CategoryIDs, @SubCategoryIDs);  
            }         
    
            $Self->{LayoutObject}->Block(
                Name => 'ExplorerLatestChange'
            );        
               
            @ItemIDs = $Self->{FAQObject}->FAQSearch(
                CategoryIDs => \@CategoryIDs,
                States => $Self->{InterfaceStates},
                Order => 'Changed',
                Sort => 'down',            
                Limit => $Self->{ConfigObject}->Get('FAQ::Explorer::LastChange::Limit')
            );
        } else {
            $Self->{LayoutObject}->Block(
                Name => 'ExplorerLatestChange'
            );          
            @ItemIDs = $Self->{FAQObject}->FAQSearch(
#                CategoryIDs => \@CategoryIDs,
                States => $Self->{InterfaceStates},
                Order => 'Changed',
                Sort => 'down',            
                Limit => $Self->{ConfigObject}->Get('FAQ::Explorer::LastChange::Limit')
            );        
        }        
        foreach (@ItemIDs) {
            my %Data = $Self->{FAQObject}->FAQGet(ItemID => $_);
            $Self->{LayoutObject}->Block(
                Name => 'ExplorerLatestChangeFAQItemRow',
                Data => { %Data },
            );
        }   
        return 1;
    }
    return 0;
}


sub _GetExplorerLastCreateItems {
    my $Self = shift;
    my %Param = @_;
    
    if($Self->{ConfigObject}->Get('FAQ::Explorer::LastCreate::Show')) {         
        
        # check needed parameters
        foreach (qw(CategoryID)) {
            if (!defined($Param{$_})) {
                $Self->{LayoutObject}->FatalError(Message => "Need parameter $_!") 
            }
        }   
        my @ItemIDs = ();           
        if($Param{CategoryID}) {
            # add current categoryid
            my @CategoryIDs = ();
            if($Param{CategoryID}) {
                push(@CategoryIDs, ($Param{CategoryID}));
            }
            
            # add subcategoryids
            if($Self->{ConfigObject}->Get('FAQ::Explorer::LastCreate::ShowSubCategoryItems')) {                
                my @SubCategoryIDs = @{$Self->{FAQObject}->CategorySubCategoryIDList(
                    ParentID => $Param{CategoryID},
                    ItemStates => $Self->{InterfaceStates},         
                )};                     
                push(@CategoryIDs, @SubCategoryIDs); 
            }         
        
            $Self->{LayoutObject}->Block(
                Name => 'ExplorerLatestCreate'
            );        
               
            @ItemIDs = $Self->{FAQObject}->FAQSearch(
                CategoryIDs => \@CategoryIDs,
                States => $Self->{InterfaceStates},
                Order => 'Created',
                Sort => 'down',            
                Limit => $Self->{ConfigObject}->Get('FAQ::Explorer::LastCreate::Limit')
            );
        } else {
            $Self->{LayoutObject}->Block(
                Name => 'ExplorerLatestCreate'
            );          
            @ItemIDs = $Self->{FAQObject}->FAQSearch(
#                CategoryIDs => \@CategoryIDs,
                States => $Self->{InterfaceStates},
                Order => 'Created',
                Sort => 'down',            
                Limit => $Self->{ConfigObject}->Get('FAQ::Explorer::LastCreate::Limit')
            );        
        }

        # dtl block           
        foreach (@ItemIDs) {
            my %Data = $Self->{FAQObject}->FAQGet(ItemID => $_);
            $Self->{LayoutObject}->Block(
                Name => 'ExplorerLatestCreateFAQItemRow',
                Data => { %Data },
            );
        }   
        return 1;
    }
    return 0;
}

sub _GetExplorerQuickSearch {
    my $Self = shift;
    my %Param = @_;
                       
    if($Self->{ConfigObject}->Get('FAQ::Explorer::QuickSearch::Show')) {             
        
        # check needed parameters
        foreach (qw()) {
            if (!$Param{$_}) {
                $Self->{LayoutObject}->FatalError(Message => "Need parameter $_!") 
            }
        }           
    
        # dtl block          
        $Self->{LayoutObject}->Block(
            Name => 'ExplorerQuickSearch',
            Data => { CategoryID => $Param{CategoryID} }
        );         
        
        # search in current category
        #my @CategoryIDs = ($Param{CategoryID});
        
        # search in subcategories
        #if($Self->{ConfigObject}->Get('FAQ::Explorer::QuickSearch::ShowSubCategoryItems')) {                
        #    my @SubCategoryIDs = @{$Self->{FAQObject}->CategorySubCategoryIDList(
        #        ParentID => $Param{CategoryID},
        #        ItemStates => $Self->{InterfaceStates},         
        #    )};                     
        #    push(@CategoryIDs, @SubCategoryIDs); 
        #}              
        
        #foreach my $SubCategoryID (@CategoryIDs) {
        #    $Self->{LayoutObject}->Block(
        #        Name => 'ExplorerQuickSearchCategory',
        #        Data => { CategoryID => $SubCategoryID }
        #    );        
        #}
          
        return 1;              
    }
    return 0;
}

sub GetItemView {

    my $Self = shift;
    my %Param = @_;
    
    my %Frontend = ();
    my %GetParam = ();
    my @Params = qw(ItemID);                
    
    # manage parameters
    # ********************************************************** #                                
    foreach (@Params) {
        if(!($GetParam{$_} = $Self->{ParamObject}->GetParam(Param => $_))) {
            $Self->{LayoutObject}->FatalError(Message => "Need parameter $_");
        }
    }

    # db action
    # ********************************************************** #                                
    my %ItemData = $Self->{FAQObject}->FAQGet(ItemID => $GetParam{ItemID}, UserID => $Self->{UserID});        
    if (!%ItemData) {
        return $Self->{LayoutObject}->ErrorScreen();
    }       
    
    # permission check
    # ********************************************************** #
    if(!exists($Self->{InterfaceStates}{$ItemData{StateTypeID}})) {        
        return $Self->{LayoutObject}->NoPermission(WithHeader => 'yes');
    }    
    
    # user info
    # ********************************************************** #    
    my %UserInfo = $Self->{AgentUserObject}->GetUserData(
        UserID => $ItemData{CreatedBy},
    );    
    $Frontend{CreatedByLogin} = $UserInfo{UserLogin};
    %UserInfo = $Self->{AgentUserObject}->GetUserData(
        UserID => $ItemData{ChangedBy},
    );    
    $Frontend{ChangedByLogin} = $UserInfo{UserLogin};             


    # item view
    # ********************************************************** #        
    $Frontend{CssColumnVotingResult} = 'color:'.$Self->{LayoutObject}->GetFAQItemVotingRateColor(Rate => $ItemData{Result}).';';                    
    $Self->{LayoutObject}->Block(
        Name => 'View',
        Data => { %Param, %ItemData, %Frontend },
    );      


    # FAQ path
    # ********************************************************** #
    if($Self->_GetFAQPath(CategoryID => $ItemData{CategoryID})) {          
        $Self->{LayoutObject}->Block(
            Name => 'FAQPathItemElement',
            Data => \%ItemData,
        );            
    }  
    

    # item attachment
    # ********************************************************** #            
    if(defined($ItemData{Filename})) {
        $Self->{LayoutObject}->Block(
            Name => 'FAQItemViewAttachment',
            Data => { %Param, %ItemData },
        );        
    }              
    
    # item fields         
    # ********************************************************** #
    $Self->_GetItemFields(
        ItemData => \%ItemData
    );
    
    # item voting
    # ********************************************************** #   
    my %ShowItemVoting = %{$Self->{ConfigObject}->Get('FAQ::Item::Voting::Show')};
    if(exists($ShowItemVoting{$Self->{Interface}{Name}})) {
        $Self->_GetItemVoting(
            ItemData => \%ItemData
        );                
    }    
    
    # get linked objects
    # ---------------------------------------------------------- #        
    my %Links = $Self->{LinkObject}->AllLinkedObjects(
        Object => 'FAQ',
        ObjectID => $ItemData{ItemID},
        UserID => $Self->{UserID},
    );
    foreach my $LinkType (sort keys %Links) {
        my %ObjectType = %{$Links{$LinkType}};
        foreach my $Object (sort keys %ObjectType) {
            my %Data = %{$ObjectType{$Object}};
            foreach my $Item (sort keys %Data) {
                $Self->{LayoutObject}->Block(
                    Name => "Link$LinkType",
                    Data => $Data{$Item},
                );
            }
        }
    }
    return;
}


sub GetItemSmallView {

    my $Self = shift;
    my %Param = @_;
    
    my %Frontend = ();
    my %GetParam = ();
    my @Params = qw(ItemID);                
    
    # manage parameters
    # ********************************************************** #                                
    foreach (@Params) {
        if(!($GetParam{$_} = $Self->{ParamObject}->GetParam(Param => $_))) {
            $Self->{LayoutObject}->FatalError(Message => "Need parameter $_");
        }
    }

    # db action
    # ********************************************************** #                                
    my %ItemData = $Self->{FAQObject}->FAQGet(ItemID => $GetParam{ItemID}, UserID => $Self->{UserID});        
    if (!%ItemData) {
        return $Self->{LayoutObject}->ErrorScreen();
    }       
    
    # permission check
    # ********************************************************** #
    if(!exists($Self->{InterfaceStates}{$ItemData{StateTypeID}})) {        
        return $Self->{LayoutObject}->NoPermission(WithHeader => 'yes');
    }    
    
    # user info
    # ********************************************************** #    
    my %UserInfo = $Self->{AgentUserObject}->GetUserData(
        UserID => $ItemData{CreatedBy},
    );    
    $Frontend{CreatedByLogin} = $UserInfo{UserLogin};
    %UserInfo = $Self->{AgentUserObject}->GetUserData(
        UserID => $ItemData{ChangedBy},
    );    
    $Frontend{ChangedByLogin} = $UserInfo{UserLogin};             


    # item view
    # ********************************************************** #        
    $Frontend{CssColumnVotingResult} = 'color:'.$Self->{LayoutObject}->GetFAQItemVotingRateColor(Rate => $ItemData{Result}).';';                    
    $Frontend{ItemFieldValues} = $Self->_GetItemFieldValues(ItemData => \%ItemData);
    $Self->{LayoutObject}->Block(
        Name => 'ViewSmall',
        Data => { %Param, %ItemData, %Frontend },
    );
     
    # FAQ path
    # ********************************************************** #
    if($Self->_GetFAQPath(CategoryID => $ItemData{CategoryID})) {          
        $Self->{LayoutObject}->Block(
            Name => 'FAQPathItemElement',
            Data => \%ItemData,
        );            
    }                
    
    # get linked objects
    # ---------------------------------------------------------- #        
    my %Links = $Self->{LinkObject}->AllLinkedObjects(
        Object => 'FAQ',
        ObjectID => $ItemData{ItemID},
        UserID => $Self->{UserID},
    );
    foreach my $LinkType (sort keys %Links) {
        my %ObjectType = %{$Links{$LinkType}};
        foreach my $Object (sort keys %ObjectType) {
            my %Data = %{$ObjectType{$Object}};
            foreach my $Item (sort keys %Data) {
                $Self->{LayoutObject}->Block(
                    Name => "Link$LinkType",
                    Data => $Data{$Item},
                );
            }
        }
    }
    return;
}

sub GetItemPrint {

    my $Self = shift;
    my %Param = @_;
    
    my %GetParam = ();    
    my @Params = qw(ItemID);        
    
    # manage parameters
    # ********************************************************** #                                
    foreach (@Params) {
        if(!($GetParam{$_} = $Self->{ParamObject}->GetParam(Param => $_))) {
            $Self->{LayoutObject}->FatalError(Message => "Need parameter $_");
        }
    }

    # db action
    # ********************************************************** #                                
    my %ItemData = $Self->{FAQObject}->FAQGet(ItemID => $GetParam{ItemID}, UserID => $Self->{UserID});        
    if (!%ItemData) {
        return $Self->{LayoutObject}->ErrorScreen();
    }     
    
    # permission check
    # ********************************************************** #
    if(!exists($Self->{InterfaceStates}{$ItemData{StateTypeID}})) {        
        return $Self->{LayoutObject}->NoPermission(WithHeader => 'yes');
    }       

    # dtl
    # ********************************************************** #                                
    # add article
    $Self->{LayoutObject}->Block(
         Name => 'Print',
         Data => \%ItemData,
    );
    
    # get linked objects
    my %Links = $Self->{LinkObject}->AllLinkedObjects(
        Object => 'FAQ',
        ObjectID => $ItemData{ItemID},
        UserID => $Self->{UserID},
    );
    
        
    # fields         
    $Self->_GetItemFields(
        ItemData => \%ItemData
    );    
    
    # links
    foreach my $LinkType (sort keys %Links) {
        my %ObjectType = %{$Links{$LinkType}};
        foreach my $Object (sort keys %ObjectType) {
            my %Data = %{$ObjectType{$Object}};
            foreach my $Item (sort keys %Data) {
                $Self->{LayoutObject}->Block(
                    Name => "Link$LinkType",
                    Data => $Data{$Item},
                );
            }
        }
    }
    
    return;
}

sub _GetItemFields {
    my $Self = shift;
    my %Param = @_;

    my %GetParam = ();            
    my @Params = qw(ItemData);
         
    # manage parameters
    # ********************************************************** #                                
    foreach (@Params) {
        if(!exists($Param{$_})) {
            return $Self->{LayoutObject}->FatalError(Message => "Need parameter $_");
        }
    }    
    
    # config values
    # ********************************************************** #        
    my %ItemFields = ();
    for(my $i=1;$i<7;$i++) {
        my %ItemConfig = %{$Self->{ConfigObject}->Get('FAQ::Item::Field'.$i)};
        if($ItemConfig{Show}) {
            $ItemFields{"Field".$i} = \%ItemConfig;            
        }
    }

    foreach my $Key (sort( { $ItemFields{$a}{Prio} <=> $ItemFields{$b}{Prio} } keys(%ItemFields))) {
    

        my %StateTypeData = %{$Self->{FAQObject}->StateTypeGet(
            Name => $ItemFields{$Key}{Show}
        )};

        # show yes /no
        if(exists($Self->{InterfaceStates}{$StateTypeData{ID}})) {               
            $Self->{LayoutObject}->Block(
                Name => 'FAQItemField',
                Data => {
                    %{$ItemFields{$Key}}, 
                    'StateName' => $StateTypeData{Name},
                    'Key' => $Key,
                    'Value' => $Param{ItemData}{$Key} || '',
                },
            );    
        }          
        
    }         
     
    return;   
}

sub _GetItemFieldValues {
    my $Self = shift;
    my %Param = @_;

    my %GetParam = ();            
    my @Params = qw(ItemData);
         
    # manage parameters
    # ********************************************************** #                                
    foreach (@Params) {
        if(!exists($Param{$_})) {
            return $Self->{LayoutObject}->FatalError(Message => "Need parameter $_");
        }
    }    
    
    # config values
    # ********************************************************** #        
    my %ItemFields = ();
    for(my $i=1;$i<7;$i++) {
        my %ItemConfig = %{$Self->{ConfigObject}->Get('FAQ::Item::Field'.$i)};
        if($ItemConfig{Show}) {
            $ItemFields{"Field".$i} = \%ItemConfig;            
        }
    }

    my $String = '';
    foreach my $Key (sort( { $ItemFields{$a}{Prio} <=> $ItemFields{$b}{Prio} } keys(%ItemFields))) {
    
        my %StateTypeData = %{$Self->{FAQObject}->StateTypeGet(
            Name => $ItemFields{$Key}{Show}
        )};

        # show yes /no
        if(exists($Self->{InterfaceStates}{$StateTypeData{ID}})) {               
            $String .= $Param{ItemData}{$Key} || '';
            $String .= "\n\n";
        }          
        
    }         
     
    return $String;   
}

sub _GetItemVoting {
    my $Self = shift;
    my %Param = @_;

    # check needed parameters
    # ********************************************************** #    
    foreach (qw(ItemData)) {
        if (!$Param{$_}) {
            $Self->{LayoutObject}->FatalError(Message => "Need parameter $_!");
        }
    }   
        
    my %ItemData = %{$Param{ItemData}};
        
    $Self->{LayoutObject}->Block(
        Name => "Voting"
    );            
   
    my %VoteData = %{$Self->{FAQObject}->VoteGet( 
        CreateBy => $Self->{UserID},
        ItemID => $ItemData{ItemID},
        Interface => $Self->{Interface}{ID},                                
        IP => $ENV{'REMOTE_ADDR'},    
    )};  
        
    my $Flag = 0;        
    # already voted?
    if(%VoteData) {     
        
        # item/change_time > voting/create_time
        my $ItemChangedSystemTime = $Self->{TimeObject}->TimeStamp2SystemTime(String => $ItemData{Changed} || '');
        my $VoteCreatedSystemTime = $Self->{TimeObject}->TimeStamp2SystemTime(String => $VoteData{Created} || ''); 
        
        if($ItemChangedSystemTime > $VoteCreatedSystemTime) { 
            $Flag = 1;                        
        } else {
            push(@{$Self->{Notify}}, ['Info', 'You have already voted!']);                            
            return;        
        }
                 
    } else {
        $Flag = 1;
    }
    
    if($Self->{Subaction} eq 'Vote' && $Flag) {
        # check needed parameters
        foreach (qw(ItemData)) {
            if (!$Param{$_}) {
                $Self->{LayoutObject}->FatalError(Message => "Need parameter $_!") 
            }
        }     
          
        # manage parameters
        my %GetParam = ();
        my @Params = qw(ItemID Rate);    
        foreach (@Params) {                               
            $GetParam{$_} = $Self->{ParamObject}->GetParam(Param => $_);
        }                        
        
        if($GetParam{Rate} eq '0' or $GetParam{Rate}) {
            $Self->{FAQObject}->VoteAdd(
                CreatedBy => $Self->{UserID},
                ItemID => $GetParam{ItemID},
                IP => $ENV{'REMOTE_ADDR'},
                Interface => $Self->{Interface}{ID},
                Rate => $GetParam{Rate},                                    
            );                         
            push(@{$Self->{Notify}}, ['Info', 'Thanks for vote!']);                         
            return;
            
        } else {                     
            push(@{$Self->{Notify}}, ['Error', 'No rate selected!']);             
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
    my $Self = shift;
    my %Param = @_;

    # check needed parameters
    # ********************************************************** #    
    foreach (qw(ItemData)) {
        if (!$Param{$_}) {
            $Self->{LayoutObject}->FatalError(Message => "Need parameter $_!") 
        }
    } 
    
    $Self->{LayoutObject}->Block(
        Name => 'VoteForm',
        Data => { %Param, %{$Param{ItemData}} }
    );          

    my %VotingRates = %{$Self->{ConfigObject}->Get('FAQ::Item::Voting::Rates')};
    foreach my $key ( sort( { $b <=> $a } keys(%VotingRates ) ) ) {
        my %Data = ("Value"=>$key, "Title"=>$VotingRates{$key} );                           
        $Self->{LayoutObject}->Block(
            Name => "VotingRateRow",
            Data => \%Data,
        );             
    }    
    
    return;
}

sub GetItemSearch {
    my $Self = shift;
    my %Param = @_;
    my %GetParam    = ();
    my %Frontend    = ();

    # get params
    foreach (qw(LanguageIDs CategoryIDs)) {
        my @Array = $Self->{ParamObject}->GetArray(Param => $_);
        if (@Array) {
            $GetParam{$_} = \@Array;
        }
    }
    foreach (qw(QuickSearch Number Title What Keyword)) {
        $GetParam{$_} = $Self->{ParamObject}->GetParam(Param => $_);
    }
    
    # quicksearch in subcategories?
    if($GetParam{QuickSearch}) {
        if($Self->{ConfigObject}->Get('FAQ::Explorer::QuickSearch::ShowSubCategoryItems')) {                
            my @SubCategoryIDs = @{$Self->{FAQObject}->CategorySubCategoryIDList(
                ParentID => $GetParam{CategoryIDs}->[0],
                ItemStates => $Self->{InterfaceStates},         
            )};                     
            push(@{$GetParam{CategoryIDs}}, @SubCategoryIDs);         
        }     
    }
  
    
    $Frontend{LanguageOption} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data => { $Self->{FAQObject}->LanguageList() },
        Size => 5,
        Name => 'LanguageIDs',
        Multiple => 1,
        SelectedIDRefArray => $GetParam{LanguageIDs} || [],
        HTMLQuote => 1,
        LanguageTranslation => 0,
    );
    
    $Frontend{CategoryOption} = $Self->{LayoutObject}->AgentFAQCategoryListOption(
        CategoryList => { %{$Self->{FAQObject}->CategoryList()} },
        Size => 5,
        Name => 'CategoryIDs',
        Multiple => 1,
        SelectedIDs => $GetParam{CategoryIDs} || [],
        HTMLQuote => 1,
        LanguageTranslation => 0,
    );    
    
    $Self->{LayoutObject}->Block(
        Name => 'Search',
        Data => { %Param, %GetParam, %Frontend },
    );
    
    # build result
    # ---------------------------------------------------------- #                
    if($Self->{ParamObject}->GetParam(Param => 'Submit')) {       
        my $CssRow = '';

        my @ItemIDs = $Self->{FAQObject}->FAQSearch(
            %Param,
            %GetParam,
            States => $Self->{InterfaceStates},
            Limit => 25,
        );
        $Self->{LayoutObject}->Block(
            Name => 'SearchResult',
            Data => { %Param, %Frontend },
        );
        foreach (@ItemIDs) {
            %Frontend = ();
            my %Data = $Self->{FAQObject}->FAQGet(ItemID => $_);
            
            if($CssRow eq 'searchpassive') {
                $CssRow = 'searchactive';
            }
            else {
                $CssRow = 'searchpassive';
            }     
            $Data{CssRow} = $CssRow;           
            
            $Frontend{CssColumnVotingResult} = 'color:'.$Self->{LayoutObject}->GetFAQItemVotingRateColor(Rate => $Data{Result}).';';                                
            
            $Self->{LayoutObject}->Block(
                Name => 'SearchResultRow',
                Data => { %Data, %Frontend },
            );
        }
    }
    return;
}

sub GetSystemHistory {
    my $Self = shift;
    my %Param = @_;
    
    my %Frontend = ();

    # store last queue screen
    $Self->{SessionObject}->UpdateSessionID(
        SessionID => $Self->{SessionID},
        Key => 'LastScreenOverview',
        Value => $Self->{RequestedURL},
    );
    # store last screen
    $Self->{SessionObject}->UpdateSessionID(
        SessionID => $Self->{SessionID},
        Key => 'LastScreenView',
        Value => $Self->{RequestedURL},
    );
    $Self->{LayoutObject}->Block(
        Name => 'SystemHistory',
        Data => { %Param },
    );
    
    $Frontend{CssRow} = '';
    my @History = @{$Self->{FAQObject}->HistoryGet()};
    foreach my $Row (@History) {
    
        # css configuration
        if($Frontend{CssRow} eq 'searchpassive') {
            $Frontend{CssRow} = 'searchactive';
        }
        else {
            $Frontend{CssRow} = 'searchpassive';
        }    
    
        my %Data = %{$Row};#$Self->{FAQObject}->FAQGet(ItemID => $Row->{ItemID});
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