# --
# Kernel/Modules/CustomerFAQ.pm - faq module
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: CustomerFAQ.pm,v 1.9 2008-09-23 00:33:00 ub Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::Modules::CustomerFAQ;

use strict;
use warnings;

use Kernel::System::FAQ;
use Kernel::Modules::FAQ;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.9 $) [1];

our @ISA = qw(Kernel::Modules::FAQ);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    # ********************************************************** #
    my $Self = new Kernel::Modules::FAQ(%Param);
    bless( $Self, $Type );

    # interface settings
    # ********************************************************** #
    $Self->{Interface} = $Self->{FAQObject}->StateTypeGet(
        Name => 'external',
    );
    $Self->{InterfaceStates} = $Self->{FAQObject}->StateTypeList(
        Types => [ 'external', 'public' ],
    );

    # check needed Objects
    # ********************************************************** #
    for (qw(UserObject)) {
        $Self->{LayoutObject}->FatalError( Message => "Got no $_!" ) if ( !$Self->{$_} );
    }

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # Paramter
    my @Params   = ();
    my %GetParam = ();
    my %Frontend = ();

    # Output
    my $Output      = '';
    my $Header      = '';
    my $HeaderTitle = '';
    my $HeaderType  = '';
    my $Navigation  = '';
    my $Notify      = '';
    my $Content     = '';
    my $Footer      = '';
    my $FooterType  = '';

    my $DefaultHeader     = '';
    my $DefaultNavigation = '';
    my $DefaultContent    = '';
    my $DefaultFooter     = '';

    # navigation ON/OFF
    # ********************************************************** #
    if ( $GetParam{Nav} ) {
        $HeaderType = 'Small';
    }
    else {
        $HeaderType = '';
    }

    # store nav param
    $Self->{SessionObject}->UpdateSessionID(
        SessionID => $Self->{SessionID},
        Key       => 'LastFAQNav',
        Value     => $HeaderType,
    );

    # ---------------------------------------------------------- #
    # explorer
    # ---------------------------------------------------------- #
    if ( $Self->{Subaction} eq 'Explorer' ) {
        $Self->GetExplorer(
            Mode         => 'Customer',
            CustomerUser => $Self->{UserLogin},
        );
        $HeaderTitle = 'Explorer';
        $Header      = $Self->{LayoutObject}->CustomerHeader(
            Type  => $HeaderType,
            Title => $HeaderTitle
        );
        $Content = $Self->{LayoutObject}->Output(
            TemplateFile => 'FAQ',
            Data => { %Frontend, %GetParam }
        );
    }

    # ---------------------------------------------------------- #
    # search a item
    # ---------------------------------------------------------- #
    elsif ( $Self->{Subaction} eq 'Search' ) {
        $HeaderTitle = 'Search';
        $Header      = $Self->{LayoutObject}->CustomerHeader(
            Type  => $HeaderType,
            Title => $HeaderTitle
        );
        $Self->GetItemSearch(
            Mode         => 'Customer',
            CustomerUser => $Self->{UserLogin},
        );

        $Content = $Self->{LayoutObject}->Output(
            TemplateFile => 'FAQ',
            Data => { %Frontend, %GetParam }
        );
    }

    # ---------------------------------------------------------- #
    # download item
    # ---------------------------------------------------------- #
    elsif ( $Self->{Subaction} eq 'Download' ) {

        # get param
        my $ItemID = $Self->{ParamObject}->GetParam( Param => 'ItemID' );
        my $FileID = $Self->{ParamObject}->GetParam( Param => 'FileID' );

        # db action
        my %ItemData = $Self->{FAQObject}->FAQGet( ItemID => $ItemID );
        if ( !%ItemData ) {
            return $Self->{LayoutObject}->FatalError( Message => "No FAQ found!" );
        }

        # permission check
        if ( !$ItemData{Approved} ) {
            return $Self->{LayoutObject}->FatalError( Message => "Permission denied!" );
        }

        if ( $ItemData{StateTypeName} eq 'external' || $ItemData{StateTypeName} eq 'public' ) {
            my %File = $Self->{FAQObject}->AttachmentGet(
                ItemID => $ItemID,
                FileID => $FileID,
            );
            if ( !%File ) {
                return $Self->{LayoutObject}->FatalError( Message => "No File found!" );
            }
            return $Self->{LayoutObject}->Attachment(%File);
        }
        else {
            return $Self->{LayoutObject}->FatalError( Message => "Permission denied!" );
        }
    }

    # ---------------------------------------------------------- #
    # item print
    # ---------------------------------------------------------- #
    elsif ( $Self->{Subaction} eq 'Print' && $Self->{ParamObject}->GetParam( Param => 'ItemID' ) ) {
        my %FAQArticle = $Self->{FAQObject}->FAQGet(
            FAQID => $Self->{ParamObject}->GetParam( Param => 'ItemID' ),
        );
        my $Permission = $Self->{FAQObject}->CheckCategoryCustomerPermission(
            CustomerUser => $Self->{UserLogin},
            CategoryID   => $FAQArticle{CategoryID},
        );
        if ( $Permission eq ''  || !$FAQArticle{Approved} ) {
            $Self->{LayoutObject}->FatalError( Message => "Permission denied!" );
        }

        $Self->GetItemPrint();
        $Header = $Self->{LayoutObject}->PrintHeader(
            Title => $Self->{ItemData}{Subject}
        );
        $Navigation = ' ';
        $Content    = $Self->{LayoutObject}->Output(
            TemplateFile => 'FAQ',
            Data => { %Frontend, %GetParam }
        );
        $Footer = $Self->{LayoutObject}->PrintFooter();
    }

    # ---------------------------------------------------------- #
    # item view
    # ---------------------------------------------------------- #
    elsif ( $Self->{ParamObject}->GetParam( Param => 'ItemID' ) ) {
        my %FAQArticle = $Self->{FAQObject}->FAQGet(
            FAQID => $Self->{ParamObject}->GetParam( Param => 'ItemID' ),
        );
        my $Permission = $Self->{FAQObject}->CheckCategoryCustomerPermission(
            CustomerUser => $Self->{UserLogin},
            CategoryID   => $FAQArticle{CategoryID},
        );
        if ( $Permission eq ''  || !$FAQArticle{Approved} ) {
            $Self->{LayoutObject}->FatalError( Message => "Permission denied!" );
        }

        $Self->GetItemView(
            Links      => 0,
            Permission => $Permission,
        );

        $HeaderTitle = $Self->{ItemData}{Number};
        $Header      = $Self->{LayoutObject}->CustomerHeader(
            Type  => $HeaderType,
            Title => $HeaderTitle
        );
        $Content = $Self->{LayoutObject}->Output(
            TemplateFile => 'FAQ',
            Data => { %Frontend, %GetParam }
        );

        # log access to this FAQ item
        $Self->{FAQObject}->FAQLogAdd(
            ItemID    => $Self->{ParamObject}->GetParam( Param => 'ItemID' ),
            Interface => $Self->{Interface}{Name},
        );
    }

    # ---------------------------------------------------------- #
    # redirect to explorer
    # ---------------------------------------------------------- #
    else {
        return $Self->{LayoutObject}->Redirect( OP => "Action=$Self->{Action}&Subaction=Explorer" );
    }

    # DEFAULT OUTPUT
    $DefaultHeader = $Self->{LayoutObject}->CustomerHeader(
        Type  => $HeaderType,
        Title => $HeaderTitle
    );
    $DefaultNavigation = $Self->{LayoutObject}->CustomerNavigationBar();
    $DefaultContent    = $Self->{LayoutObject}->Output(
        TemplateFile => 'CustomerFAQ',
        Data => { %Frontend, %GetParam }
    );
    $DefaultFooter = $Self->{LayoutObject}->CustomerFooter( Type => $FooterType );

    # OUTPUT
    $Output .= $Header     || $DefaultHeader;
    $Output .= $Navigation || $DefaultNavigation;
    if ( !$Notify ) {
        for my $Notify ( @{ $Self->{Notify} } ) {
            $Output .= $Self->{LayoutObject}->Notify(
                Priority => $Notify->[0],
                Info     => $Notify->[1],
            );
        }
    }
    $Output .= $Content || $DefaultContent;
    $Output .= $Footer  || $DefaultFooter;

    return $Output;
}

1;
