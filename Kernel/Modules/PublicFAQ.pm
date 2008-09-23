# --
# Kernel/Modules/PublicFAQ.pm - faq module
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: PublicFAQ.pm,v 1.8 2008-09-23 00:33:00 ub Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::Modules::PublicFAQ;

use strict;
use warnings;

use Kernel::System::FAQ;
use Kernel::Modules::FAQ;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.8 $) [1];

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
        Name => 'public',
    );
    $Self->{InterfaceStates} = $Self->{FAQObject}->StateTypeList(
        Types => ['public'],
    );

    # check needed Objects
    # ********************************************************** #
    for (qw()) {
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

    # ---------------------------------------------------------- #
    # explorer
    # ---------------------------------------------------------- #
    if ( $Self->{Subaction} eq 'Explorer' ) {

        # add rss feed link
        $Self->{LayoutObject}->Block(
            Name => 'MetaLink',
            Data => {
                Rel   => 'alternate',
                Type  => 'application/rss+xml',
                Title => '$Text{"FAQ News (new created)"}',
                Href  => '$Env{"Baselink"}Action=$Env{"Action"}&Subaction=rss&Type=Created',
            },
        );
        $Self->{LayoutObject}->Block(
            Name => 'MetaLink',
            Data => {
                Rel   => 'alternate',
                Type  => 'application/rss+xml',
                Title => '$Text{"FAQ News (recently changed)"}',
                Href  => '$Env{"Baselink"}Action=$Env{"Action"}&Subaction=rss&Type=Changed',
            },
        );
        $Self->{LayoutObject}->Block(
            Name => 'MetaLink',
            Data => {
                Rel   => 'alternate',
                Type  => 'application/rss+xml',
                Title => '$Text{"FAQ News (Top 10)"}',
                Href  => '$Env{"Baselink"}Action=$Env{"Action"}&Subaction=rss&Type=Top10',
            },
        );
        $HeaderTitle = 'Explorer';
        $Header      = $Self->{LayoutObject}->CustomerHeader(
            Type  => $HeaderType,
            Title => $HeaderTitle
        );
        $Self->GetExplorer();
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
        $Self->GetItemSearch();
        $Content = $Self->{LayoutObject}->Output(
            TemplateFile => 'FAQ',
            Data => { %Frontend, %GetParam }
        );
    }

    # ---------------------------------------------------------- #
    # rss
    # ---------------------------------------------------------- #
    elsif ( $Self->{Subaction} eq 'rss' ) {
        my $Type = $Self->{ParamObject}->GetParam( Param => 'Type' ) || 'Changed';
        my $States = $Self->{FAQObject}->StateTypeList(
            Types => ['public']
        );

        my @IDs;
        if ( $Type eq 'Top10' ) {
            # get the top 10 articles
            my $Top10ItemIDsRef = $Self->{FAQObject}->FAQTop10Get(
                Interface => $Self->{Interface}{Name},
                Limit     => $Self->{ConfigObject}->Get('FAQ::Explorer::Top10::Limit'),
            );
            @IDs = map { $_->{ItemID} } @{ $Top10ItemIDsRef };
        }
        else {
            @IDs = $Self->{FAQObject}->FAQSearch(
                States    => $States,
                Order     => $Type,
                Sort      => 'down',
                Interface => $Self->{Interface}{Name},
                Limit     => 20,
            );
        }

        # generate rss feed
        use XML::RSS::SimpleGen;
        rss_new( "http://" . $ENV{HTTP_HOST} );
        my $Title = $Self->{ConfigObject}->Get('Product') . ' FAQ';
        rss_title($Title);

        for my $ItemID (@IDs) {
            my %Article = $Self->{FAQObject}->FAQGet(
                ItemID => $ItemID,
            );
            my $Preview = '';
            for my $Count ( 1 .. 2 ) {
                if ( $Article{"Field$Count"} ) {
                    $Preview .= $Article{"Field$Count"};
                }
            }

            # remove html tags
            $Preview =~ s/\<.+?\>//gs;

            # replace "  " with " " space
            $Preview =~ s/  / /mg;

            # reduce size of preview
            $Preview =~ s/^(.{80}).*$/$1\[\.\.\]/gs;

            rss_item(
                "http://$ENV{HTTP_HOST}$Self->{LayoutObject}->{Baselink}Action=$Self->{Action}&ItemID=$ItemID",
                $Article{Title},
                $Preview,
            );
        }
        my $Output = rss_as_string();

        if ( !$Output ) {
            return $Self->{LayoutObject}->FatalError( Message => "Can't create RSS file!" );
        }
        return $Self->{LayoutObject}->Attachment(
            Content     => $Output,
            ContentType => 'text/xml',
            Type        => 'inline',
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
        if ( $ItemData{StateTypeName} eq 'public' ) {
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
        $Header = $Self->{LayoutObject}->PrintHeader(
            Title => $Self->{ItemData}{Subject}
        );
        $Self->GetItemPrint();
        $Content = $Self->{LayoutObject}->Output(
            TemplateFile => 'FAQ',
            Data => { %Frontend, %GetParam }
        );
        $Footer = $Self->{LayoutObject}->PrintFooter();
    }

    # ---------------------------------------------------------- #
    # item view
    # ---------------------------------------------------------- #
    elsif ( $Self->{ParamObject}->GetParam( Param => 'ItemID' ) ) {
        $Self->GetItemView();
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

    $DefaultContent = $Self->{LayoutObject}->Output(
        TemplateFile => 'PublicFAQ',
        Data => { %Frontend, %GetParam }
    );
    $DefaultFooter = $Self->{LayoutObject}->CustomerFooter( Type => $FooterType );

    # OUTPUT
    $Output .= $Header || $DefaultHeader;
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
