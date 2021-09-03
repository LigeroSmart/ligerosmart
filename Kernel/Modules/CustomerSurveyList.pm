# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Modules::CustomerSurveyList;
## nofilter(TidyAll::Plugin::OTRS::Perl::DBObject)

use strict;
use warnings;

our $ObjectManagerDisabled = 1;

use Kernel::System::VariableCheck qw(:all);
use Kernel::Language qw(Translatable);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my $ParamObject  = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $SurveyExtendObject = $Kernel::OM->Get('Kernel::System::Survey::RequestExtend');
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

    # check subaction
    if ( !$Self->{Subaction} ) {
        return $LayoutObject->Redirect(
            OP => 'Action=CustomerSurveyList;Subaction=MySurveys',
        );
    }

    # check needed CustomerID
    if ( !$Self->{UserCustomerID} ) {
        my $Output = $LayoutObject->CustomerHeader(
            Title => Translatable('Error'),
        );
        $Output .= $LayoutObject->CustomerError(
            Message => Translatable('Need CustomerID!'),
        );
        $Output .= $LayoutObject->CustomerFooter();
        return $Output;
    }

    my @RequestData = $SurveyExtendObject->RequestListByUserEmail(
        UserEmail => $Self->{UserEmail},
    );

    SURVEY:
    for my $Survey ( @RequestData ) {
        next SURVEY if !!$Survey->{VoteTime};
        my %Ticket = $TicketObject->TicketGet(
            TicketID      => $Survey->{TicketID},
            UserID        => 1,
        );
        use Data::Dumper;
        #die Dumper($Survey);
        $LayoutObject->Block(
          Name => 'Record',
          Data => {
              %$Survey,
              %Ticket,
          },
      );
    }


    

    # create & return output
    my $Title = $Self->{Subaction};
    if ( $Title eq 'MySurveys' ) {
        $Title = Translatable('My Surveys');
    }
    my $Refresh = '';
    if ( $Self->{UserRefreshTime} ) {
        $Refresh = 60 * $Self->{UserRefreshTime};
    }
    my $Output = $LayoutObject->CustomerHeader(
        Title   => $Title,
        Refresh => $Refresh,
    );

    # build NavigationBar
    $Output .= $LayoutObject->CustomerNavigationBar();
    $Output .= $LayoutObject->Output(
        TemplateFile => 'CustomerSurveyList',
        Data         => {
          Count => scalar @RequestData
        },
    );

    # get page footer
    $Output .= $LayoutObject->CustomerFooter();

    # return page
    return $Output;
}

1;
