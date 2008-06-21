# --
# Kernel/Modules/AgentITSMLocation.pm - the OTRS::ITSM Location module
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: AgentITSMLocation.pm,v 1.1 2008-06-21 16:50:14 ub Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::Modules::AgentITSMLocation;

use strict;
use warnings;

use Kernel::System::GeneralCatalog;
use Kernel::System::ITSMLocation;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.1 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check needed objects
    for my $Object (qw(ParamObject DBObject LayoutObject LogObject ConfigObject)) {
        if ( !$Self->{$Object} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $Object!" );
        }
    }
    $Self->{GeneralCatalogObject} = Kernel::System::GeneralCatalog->new(%Param);
    $Self->{LocationObject}       = Kernel::System::ITSMLocation->new(%Param);

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # output overview
    $Self->{LayoutObject}->Block(
        Name => 'Overview',
        Data => {%Param},
    );

    # get type list
    my $TypeList = $Self->{GeneralCatalogObject}->ItemList(
        Class => 'ITSM::Location::Type',
    );

    # get location list
    my %LocationList = $Self->{LocationObject}->LocationList(
        UserID => $Self->{UserID},
    );

    # add suffix for correct sorting
    for my $Location ( values %LocationList ) {
        $Location .= '::';
    }

    my $CssClass = '';
    for my $LocationID ( sort { $LocationList{$a} cmp $LocationList{$b} } keys %LocationList ) {

        # set output object
        $CssClass = $CssClass eq 'searchpassive' ? 'searchactive' : 'searchpassive';

        # get location data
        my %Location = $Self->{LocationObject}->LocationGet(
            LocationID => $LocationID,
            UserID     => $Self->{UserID},
        );

        # output row
        if ( $Self->{ConfigObject}->Get('Ticket::Frontend::ListType') eq 'tree' ) {
            $Self->{LayoutObject}->Block(
                Name => 'OverviewRow',
                Data => {
                    %Location,
                    Name     => $Location{NameShort},
                    Type     => $TypeList->{ $Location{TypeID} },
                    CssClass => $CssClass,
                },
            );

            my @Fragment = split '::', $Location{Name};
            pop @Fragment;

            for (@Fragment) {
                $Self->{LayoutObject}->Block(
                    Name => 'OverviewRowSpace',
                );
            }
        }
        else {
            $Self->{LayoutObject}->Block(
                Name => 'OverviewRow',
                Data => {
                    %Location,
                    Name     => $Location{NameShort},
                    Type     => $TypeList->{ $Location{TypeID} },
                    CssClass => $CssClass,
                },
            );
        }
    }

    # set last screen view
    $Self->{SessionObject}->UpdateSessionID(
        SessionID => $Self->{SessionID},
        Key       => 'ITSMLocationLastScreenOverview',
        Value     => "Action=$Self->{Action}",
    );

    # output header
    my $Output = $Self->{LayoutObject}->Header();
    $Output .= $Self->{LayoutObject}->NavigationBar();

    # generate output
    $Output .= $Self->{LayoutObject}->Output(
        TemplateFile => 'AgentITSMLocation',
        Data         => \%Param,
    );
    $Output .= $Self->{LayoutObject}->Footer();

    return $Output;
}

1;
