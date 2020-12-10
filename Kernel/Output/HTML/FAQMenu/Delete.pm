# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Output::HTML::FAQMenu::Delete;

use strict;
use warnings;

# Prevent used only once warning
use Kernel::System::ObjectManager;

our @ObjectDependencies = (
    'Kernel::Output::HTML::Layout',
);

sub new {
    my ( $Type, %Param ) = @_;

    # Allocate new hash for object.
    my $Self = {};
    bless( $Self, $Type );

    # Get UserID param.
    $Self->{UserID} = $Param{UserID} || die "Got no UserID!";

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # Run Kernel::Output::HTML::FAQMenu::Generic.
    my $GenericObject = Kernel::Output::HTML::FAQMenu::Generic->new( UserID => $Self->{UserID} );
    $GenericObject->Run(
        %Param,
    );

    # Create structure for JS.
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my %JSData;
    $JSData{ $Param{MenuID} } = {
        ElementID                  => $Param{MenuID},
        ElementSelector            => '#' . $Param{MenuID},
        DialogContentQueryString   => 'Action=AgentFAQDelete;ItemID=' . $Param{FAQItem}->{ItemID},
        ConfirmedActionQueryString => 'Action=AgentFAQDelete;Subaction=Delete;ItemID=' . $Param{FAQItem}->{ItemID},
        DialogTitle                => $LayoutObject->{LanguageObject}->Translate('Delete'),
    };

    # Send data to JS.
    $LayoutObject->AddJSData(
        Key   => 'FAQData',
        Value => \%JSData,
    );

    $Param{Counter}++;

    return $Param{Counter};
}

1;
