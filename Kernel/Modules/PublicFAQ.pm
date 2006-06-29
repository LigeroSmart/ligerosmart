# --
# Kernel/Modules/CustomerFAQ.pm - faq module
# Copyright (C) 2001-2005 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: PublicFAQ.pm,v 1.1.1.1 2006-06-29 09:29:51 ct Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::PublicFAQ;

use strict;
use Kernel::System::FAQ;
use Kernel::Modules::FAQ;

use vars qw($VERSION);
$VERSION = '$Revision: 1.1.1.1 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

our @ISA = qw(Kernel::Modules::FAQ);

# --
sub new {
    my $Type = shift;
    my %Param = @_;
        
    # allocate new hash for object
    # ********************************************************** #            
    my $Self = new Kernel::Modules::FAQ(%Param);    
    bless ($Self, $Type);    

    # interface settings
    # ********************************************************** # 
    $Self->{Interface} = $Self->{FAQObject}->StateTypeGet(
        Name => 'public'
    );      
    $Self->{InterfaceStates} = $Self->{FAQObject}->StateTypeList(
        Types => ['public']
    );

    # check needed Opjects
    # ********************************************************** #            
    foreach (qw()) {
        $Self->{LayoutObject}->FatalError(Message => "Got no $_!") if (!$Self->{$_});
    }

    return $Self;
}
# --
sub Run {
    my $Self = shift;
    my %Param = @_;    
    
    # Paramter
    my @Params = ();
    my %GetParam = ();
    my %Frontend = ();
    
    # Output
    my $Output = '';
    my $Header = '';    
    my $HeaderTitle =  '';    
    my $HeaderType =  '';        
    my $Navigation = '';    
    my $Notify = '';    
    my $Content = '';       
    my $Footer = '';
    my $FooterType =  '';      
    
    my $DefaultHeader = '';
    my $DefaultNavigation = '';       
    my $DefaultContent = '';       
    my $DefaultFooter = '';   
    
    # ---------------------------------------------------------- #
    # explorer
    # ---------------------------------------------------------- #
    if ($Self->{Subaction} eq 'Explorer') {                        
        $HeaderTitle = 'Explorer';  
        $Header = $Self->{LayoutObject}->CustomerHeader(
            Type => $HeaderType, 
            Title => $HeaderTitle
        );  
        $Self->GetExplorer();          
        $Content = $Self->{LayoutObject}->Output(
            TemplateFile => 'FAQ',
            Data => {%Frontend , %GetParam }
        ); 
    }
    
    # ---------------------------------------------------------- #
    # search a item
    # ---------------------------------------------------------- #
    elsif ($Self->{Subaction} eq 'Search') { 
        $HeaderTitle = 'Search';
        $Header = $Self->{LayoutObject}->CustomerHeader(
            Type => $HeaderType, 
            Title => $HeaderTitle
        );   
        $Self->GetItemSearch();        
        $Content = $Self->{LayoutObject}->Output(
            TemplateFile => 'FAQ',
            Data => {%Frontend , %GetParam }
        );        
    }    
    
    
    # ---------------------------------------------------------- #
    # item print
    # ---------------------------------------------------------- #
    elsif ($Self->{Subaction} eq 'Print' && $Self->{ParamObject}->GetParam(Param => 'ItemID')) {                     
        $Header = $Self->{LayoutObject}->PrintHeader(
            Title => $Self->{ItemData}{Subject}
        );
        $Self->GetItemPrint();          
        $Content = $Self->{LayoutObject}->Output(
            TemplateFile => 'FAQ',
            Data => { %Frontend , %GetParam }
        );        
        $Footer = $Self->{LayoutObject}->PrintFooter();
    }      
    
    # ---------------------------------------------------------- #
    # item view
    # ---------------------------------------------------------- #
    elsif ($Self->{ParamObject}->GetParam(Param => 'ItemID')) {        
        $Self->GetItemView();             
        $HeaderTitle = $Self->{ItemData}{Number};   
        $Header = $Self->{LayoutObject}->CustomerHeader(
            Type => $HeaderType, 
            Title => $HeaderTitle
        );           
        $Content = $Self->{LayoutObject}->Output(
            TemplateFile => 'FAQ',
            Data => {%Frontend , %GetParam }
        ); 
    }      
    
    # ---------------------------------------------------------- #
    # redirect to explorer
    # ---------------------------------------------------------- #
    else {
        return $Self->{LayoutObject}->Redirect(OP => "Action=$Self->{Action}&Subaction=Explorer");
    }

    # DEFAULT OUTPUT    
    $DefaultHeader = $Self->{LayoutObject}->CustomerHeader(
        Type => $HeaderType, 
        Title => $HeaderTitle
    );
    
    $DefaultContent = $Self->{LayoutObject}->Output(
        TemplateFile => 'PublicFAQ', 
        Data => { %Frontend , %GetParam }
    );
    $DefaultFooter = $Self->{LayoutObject}->CustomerFooter(Type => $FooterType);

    # OUTPUT      
    $Output .= $Header || $DefaultHeader;      
    if(!$Notify) {
        foreach my $Notify (@{$Self->{Notify}}) {
            $Output .= $Self->{LayoutObject}->Notify(
                Priority => $Notify->[0],
                Info => $Notify->[1],
            );  
        }     
    }
    $Output .= $Content || $DefaultContent;       
    $Output .= $Footer || $DefaultFooter; 
             
    return $Output;
}
# --

1;
