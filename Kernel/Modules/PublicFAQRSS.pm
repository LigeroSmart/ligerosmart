# --
# Kernel/Modules/PublicFAQRSS.pm - public FAQ explorer
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::PublicFAQRSS;

use strict;
use warnings;

use Kernel::System::FAQ;
use Kernel::System::HTMLUtils;
use XML::RSS::SimpleGen qw();

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check needed objects
    for my $Object (
        qw(ParamObject DBObject LayoutObject LogObject ConfigObject)
        )
    {
        if ( !$Self->{$Object} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $Object!" );
        }
    }

    # set UserID to root because in public interface there is no user
    $Self->{UserID} = 1;

    # create needed objects
    $Self->{FAQObject}       = Kernel::System::FAQ->new(%Param);
    $Self->{HTMLUtilsObject} = Kernel::System::HTMLUtils->new(%Param);
    $Self->{RSSObject}       = XML::RSS::SimpleGen->new( 'http://' . $ENV{HTTP_HOST} );

    # get config of frontend module
    $Self->{Config} = $Self->{ConfigObject}->Get("FAQ::Frontend::$Self->{Action}");

    # set default interface settings
    $Self->{Interface} = $Self->{FAQObject}->StateTypeGet(
        Name   => 'public',
        UserID => $Self->{UserID},
    );
    $Self->{InterfaceStates} = $Self->{FAQObject}->StateTypeList(
        Types  => $Self->{ConfigObject}->Get('FAQ::Public::StateTypes'),
        UserID => $Self->{UserID},
    );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # get RSS type
    my $Type = $Self->{ParamObject}->GetParam( Param => 'Type' );

    # check needed stuff
    if ( !$Type ) {
        return $Self->{LayoutObject}->ErrorScreen(
            Message => 'No Type is given!',
            Comment => 'Please contact the admin.',
        );
    }

    # check type
    if ( $Type !~ m{ Created | Changed | Top10 }xms ) {
        return $Self->{LayoutObject}->FatalError(
            Message => "Type must be either LastCreate or LastChange or Top10!"
        );
    }

    my @ItemIDs;
    my $Title;

    # get the Top-10 FAQ articles
    if ( $Type eq 'Top10' ) {

        # interface needs to be the interface name
        my $Top10ItemIDsRef = $Self->{FAQObject}->FAQTop10Get(
            Interface => $Self->{Interface}->{Name},
            Limit     => $Self->{ConfigObject}->Get('FAQ::Explorer::Top10::Limit') || 10,
            UserID    => $Self->{UserID},
        ) || [];

        @ItemIDs = map { $_->{ItemID} } @{$Top10ItemIDsRef};

        # build the title
        $Title = $Self->{LayoutObject}->{LanguageObject}->Translate('FAQ Articles (Top 10)');
    }

    # search the FAQ articles
    else {

        # interface needs to be complete interface hash
        @ItemIDs = $Self->{FAQObject}->FAQSearch(
            States           => $Self->{InterfaceStates},
            OrderBy          => [$Type],
            OrderByDirection => ['Down'],
            Interface        => $Self->{Interface},
            Limit            => 20,
            UserID           => $Self->{UserID},
        );

        # build the title
        if ( $Type eq 'Created' ) {
            $Title = $Self->{LayoutObject}->{LanguageObject}->Translate('FAQ Articles (new created)');
        }
        elsif ( $Type eq 'Changed' ) {
            $Title = $Self->{LayoutObject}->{LanguageObject}->Translate(
                'FAQ Articles (recently changed)'
            );
        }
    }

    # generate the RSS title
    $Title = $Self->{ConfigObject}->Get('ProductName') . ' ' . $Title;
    $Self->{RSSObject}->title($Title);

    # get the FAQ data
    for my $ItemID (@ItemIDs) {

        my %ItemData = $Self->{FAQObject}->FAQGet(
            ItemID     => $ItemID,
            ItemFields => 1,
            UserID     => $Self->{UserID},
        );

        # build a preview of the first two fields
        my $Preview = '';
        for my $Count ( 1 .. 2 ) {
            if ( $ItemData{"Field$Count"} ) {
                $Preview .= $ItemData{"Field$Count"};
            }
        }

        # convert preview to ASCII
        $Preview = $Self->{HTMLUtilsObject}->ToAscii( String => $Preview );

        # reduce size of preview
        $Preview =~ s{ \A ( .{80} ) .* \z }{$1\[\.\.\]}gxms;

        # build the RSS item
        $Self->{RSSObject}->item(
            "http://$ENV{HTTP_HOST}$Self->{LayoutObject}->{Baselink}Action=PublicFAQZoom&ItemID=$ItemID",
            $ItemData{Title},
            $Preview,
        );
    }

    # convert to string
    my $Output = $Self->{RSSObject}->as_string();

    # check error
    if ( !$Output ) {
        return $Self->{LayoutObject}->FatalError( Message => "Can't create RSS file!" );
    }

    # return the RSS feed
    return $Self->{LayoutObject}->Attachment(
        Content     => $Output,
        ContentType => 'text/xml',
        Type        => 'inline',
    );
}

1;
