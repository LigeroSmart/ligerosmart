# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Modules::AgentFAQHistory;

use strict;
use warnings;

use Kernel::Language qw(Translatable);

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;

    # Allocate new hash for object.
    my $Self = {%Param};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # Permission check.
    if ( !$Self->{AccessRo} ) {
        return $LayoutObject->NoPermission(
            Message    => Translatable('You need ro permission!'),
            WithHeader => 'yes',
        );
    }

    my %GetParam;

    # Get needed ItemID
    $GetParam{ItemID} = $Kernel::OM->Get('Kernel::System::Web::Request')->GetParam( Param => 'ItemID' );

    if ( !$GetParam{ItemID} ) {
        return $LayoutObject->ErrorScreen(
            Message => Translatable('Can\'t show history, as no ItemID is given!'),
            Comment => Translatable('Please contact the administrator.'),
        );
    }

    my $FAQObject = $Kernel::OM->Get('Kernel::System::FAQ');

    my %FAQData = $FAQObject->FAQGet(
        ItemID     => $GetParam{ItemID},
        ItemFields => 0,
        UserID     => $Self->{UserID},
    );
    if ( !%FAQData ) {
        return $LayoutObject->ErrorScreen();
    }

    # Check user permission.
    my $Permission = $FAQObject->CheckCategoryUserPermission(
        UserID     => $Self->{UserID},
        CategoryID => $FAQData{CategoryID},
        Type       => 'ro',
    );
    if ( !$Permission ) {
        return $LayoutObject->NoPermission(
            Message    => Translatable('You have no permission for this category!'),
            WithHeader => 'yes',
        );
    }

    my $History = $FAQObject->FAQHistoryGet(
        ItemID => $FAQData{ItemID},
        UserID => $Self->{UserID},
    );

    for my $HistoryEntry ( @{$History} ) {

        # Replace ID with full user name on CreatedBy key
        my %User = $Kernel::OM->Get('Kernel::System::User')->GetUserData(
            UserID => $HistoryEntry->{CreatedBy},
            Cached => 1,
        );
        $HistoryEntry->{CreatedBy} = "$User{UserLogin} ($User{UserFullname})";

        $LayoutObject->Block(
            Name => 'Row',
            Data => {
                %{$HistoryEntry},
            },
        );
    }

    my $Output = $LayoutObject->Header(
        Type  => 'Small',
        Title => Translatable('FAQ History'),
    );
    $Output .= $LayoutObject->Output(
        TemplateFile => 'AgentFAQHistory',
        Data         => {
            %GetParam,
            %FAQData,
        },
    );
    $Output .= $LayoutObject->Footer(
        Type => 'Small',
    );

    return $Output;
}

1;
