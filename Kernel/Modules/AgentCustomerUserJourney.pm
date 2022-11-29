# --
# Copyright (C) 2001-2022 Complemento, https://ligerosmart.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Modules::AgentCustomerUserJourney;
## nofilter(TidyAll::Plugin::OTRS::Perl::DBObject)

use strict;
use warnings;

use Kernel::Language qw(Translatable);
use Kernel::System::VariableCheck qw(:all);

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # get needed objects
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $MainObject = $Kernel::OM->Get('Kernel::System::Main');
    my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');

    my %ContentBlockData;

    # Display Customer User information sidebar
    my $CustomerInfoConfig = {
            Async => 0,
            Location => "Sidebar",
            Module => "Kernel::Output::HTML::TicketZoom::CustomerInformation"
    };
    my $CustomerInfoSuccess = eval { $MainObject->Require( $CustomerInfoConfig->{Module} ) };

    # Get Customer parameter from URL
    my $CustomerUser = $ParamObject->GetParam( Param => 'CustomerUser' );

    # Check if CustomerUser is defined
    if ( !$CustomerUser ) {
        $LayoutObject->FatalError(
            Message => Translatable('Need CustomerUser!'),
        );
    }
    # Get customer user information
    my %CustomerUserInformation = $Kernel::OM->Get('Kernel::System::CustomerUser')->CustomerUserDataGet(
        User => $CustomerUser,
    );
    # Check if customer user information is defined
    if ( !%CustomerUserInformation) {
        $LayoutObject->FatalError(
            Message => Translatable('CustomerUser not found!'),
        );
    }

    my $CustomerInfoWidgetOutput = Kernel::Output::HTML::TicketZoom::CustomerInformation->Run(
        Ticket    => {
            CustomerUserID => $CustomerUser,
        }
    );

    $ContentBlockData{CustomerInfoWidget} = $CustomerInfoWidgetOutput->{Output};
    
    # get needed objects
    my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');
    my $SessionObject      = $Kernel::OM->Get('Kernel::System::AuthSession');
    my $UserObject         = $Kernel::OM->Get('Kernel::System::User');

    # store last queue screen
    $SessionObject->UpdateSessionID(
        SessionID => $Self->{SessionID},
        Key       => 'LastScreenOverview',
        Value     => $Self->{RequestedURL},
    );
   # show dashboard
    $LayoutObject->Block(
        Name => 'Content',
        Data => \%ContentBlockData,
    );
    
    # Get last 5 tickets from customer user
    my @TicketIDs = $Kernel::OM->Get('Kernel::System::Ticket')->TicketSearch(
        Result => 'ARRAY',
        Limit  => 5,
        UserID => 1,
        CustomerUserLogin => $CustomerUser,
        SortBy => 'Age',
        OrderBy => 'Down',
    );

    # Check if there are tickets, if not, render no tickets found block
    if ( !@TicketIDs ) {
        $LayoutObject->Block(
            Name => 'NoTicketsFound',
        );
    }
    # For each ticket, get ticket information, and output to the block
    foreach my $TicketID (@TicketIDs) {
        my %Ticket = $Kernel::OM->Get('Kernel::System::Ticket')->TicketGet(
            TicketID => $TicketID,
            UserID   => 1,
            # with dynamicfields
            DynamicFields => 1,
            # all data
            Extended => 1,
        );
        # Add ticket create date localized without minutes
        $Ticket{CreatedNoTimezone} = $LayoutObject->{LanguageObject}->FormatTimeString(
            $Ticket{Created},
            'DateFormat',
        );
        # remove the timezone from the date
        $Ticket{CreatedNoTimezone} =~ s{ \s+ \( \s* [^)]+ \s* \) }{}xms;

        # If ticket dynamic field channel is not defined, set it to Unknown
        if ( !defined $Ticket{DynamicField_JourneyChannel} ) {
            $Ticket{DynamicField_JourneyChannel} = 'Unknown';
        }
        # Create a Hash to Set action description according to the channel, such as "Email received", "Web form submitted", etc. for the following channels:
        # Email, Web, Phone, Chat, Social Media, Whatsapp, SMS, Facebook, Twitter, Instagram, Telegram, Unknown
        my %ChannelActionDescription = (
            Email => 'Email received',
            Web => 'Web form submitted',
            Phone => 'Phone call received',
            Chat => 'Chat received',
            SocialMedia => 'Social media message received',
            Whatsapp => 'Whatsapp message received',
            SMS => 'SMS received',
            Facebook => 'Facebook message received',
            Twitter => 'Twitter message received',
            Instagram => 'Instagram message received',
            Telegram => 'Telegram message received',
            Unknown => 'Action not specified',
        );
        # Set channel description according to the channel
        $Ticket{ChannelDescription} = $ChannelActionDescription{$Ticket{DynamicField_JourneyChannel}};

        # Check if it is the first or the last Ticket in the loop and add the appropriate class
        if ( $TicketID eq $TicketIDs[-1] ) {
            $Ticket{AdditionalClass} = 'item--last';
        } elsif ( $TicketID eq $TicketIDs[0] ) {
            $Ticket{AdditionalClass} = 'item--first';
        }
        
        $LayoutObject->Block(
            Name => 'Ticket',
            Data => \%Ticket,
        );
    }    

    my $Output = $LayoutObject->Header();
    $Output .= $LayoutObject->NavigationBar();
    $Output .= $LayoutObject->Output(
        TemplateFile => $Self->{Action},
        Data         => \%Param
    );
    $Output .= $LayoutObject->Footer();
    return $Output;
}

1;
