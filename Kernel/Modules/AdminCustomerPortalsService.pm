# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Modules::AdminCustomerPortalsService;

use strict;
use warnings;

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

    my $ParamObject            = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $LayoutObject           = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $ServiceObject          = $Kernel::OM->Get('Kernel::System::Service');
    my $CustomerPortalObject   = $Kernel::OM->Get('Kernel::System::CustomerPortal');

    # ------------------------------------------------------------ #
    # template <-> queues 1:n
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'CustomerPortal' ) {


        # get template data
        my $ID                   = $ParamObject->GetParam( Param => 'ID' );
        my %CustomerPortalData = $CustomerPortalObject->CustomerPortalGet( ID => $ID );

        # get queues
        my %ServiceData = $ServiceObject->ServiceList( Valid => 1, UserID => 1 );


        # get assigned queues
        my %Member = $ServiceObject->ServiceCustomerPortalMemberList(
            CustomerPortalID => $ID,
        );

        my $Output = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar();
        $Output .= $Self->_Change(
            Selected => \%Member,
            Data     => \%ServiceData,
            ID       => $CustomerPortalData{ID},
            Name     => $CustomerPortalData{Name},
            Type     => 'CustomerPortal',
        );
        $Output .= $LayoutObject->Footer();
        return $Output;
    }

    # ------------------------------------------------------------ #
    # templates <-> Queue n:1
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'Service' ) {

        # get queue data
        my $ID          = $ParamObject->GetParam( Param => 'ID' );
        my %ServiceData = $ServiceObject->ServiceGet( ID => $ID );

        # get templates
        my %CustomerPortalData = $CustomerPortalObject->CustomerPortalList(
            Valid => 1,
        );

        # get assigned templates
        my %Member = $ServiceObject->ServiceCustomerPortalMemberList(
            ServiceID => $ID,
        );

        my $Output = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar();
        $Output .= $Self->_Change(
            Selected => \%Member,
            Data     => \%CustomerPortalData,
            ID       => $ServiceData{QueueID},
            Name     => $ServiceData{Name},
            Type     => 'Service',
        );
        $Output .= $LayoutObject->Footer();
        return $Output;
    }

    # ------------------------------------------------------------ #
    # add templates to queue
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'ChangeService' ) {

        # challenge token check for write action
        $LayoutObject->ChallengeTokenCheck();

        # get new templates
        my @CustomerPortalsSelected = $ParamObject->GetArray( Param => 'ItemsSelected' );
        my @CustomerPortalsAll      = $ParamObject->GetArray( Param => 'ItemsAll' );

        my $ServiceID = $ParamObject->GetParam( Param => 'ID' );

        # create hash with selected templates
        my %CustomerPortalsSelected = map { $_ => 1 } @CustomerPortalsSelected;

        # check all used templates
        for my $CustomerPortalID (@CustomerPortalsAll) {
            my $Active = $CustomerPortalsSelected{$CustomerPortalID} ? 1 : 0;

            # set customer user service member
            $ServiceObject->ServiceCustomerPortalMemberAdd(
                ServiceID          => $ServiceID,
                CustomerPortalID   => $CustomerPortalID,
                Active             => $Active,
                UserID             => $Self->{UserID},
            );
        }

        # if the user would like to continue editing the templates - queue relation just redirect to the edit screen
        # otherwise return to relations overview
        if (
            defined $ParamObject->GetParam( Param => 'ContinueAfterSave' )
            && ( $ParamObject->GetParam( Param => 'ContinueAfterSave' ) eq '1' )
            )
        {
            return $LayoutObject->Redirect(
                OP => "Action=$Self->{Action};Subaction=Service;ID=$ServiceID"
            );
        }
        else {
            return $LayoutObject->Redirect(
                OP => "Action=$Self->{Action}"
            );
        }
    }

    # ------------------------------------------------------------ #
    # add queues to template
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'ChangeCustomerPortal' ) {

        # challenge token check for write action
        $LayoutObject->ChallengeTokenCheck();

        # get new queues
        my @ServicesSelected = $ParamObject->GetArray( Param => 'ItemsSelected' );
        my @ServicesAll      = $ParamObject->GetArray( Param => 'ItemsAll' );

        my $CustomerPortalID = $ParamObject->GetParam( Param => 'ID' );

        # create hash with selected queues
        my %ServicesSelected = map { $_ => 1 } @ServicesSelected;

        # check all used queues
        for my $ServiceID (@ServicesAll) {
            my $Active = $ServicesSelected{$ServiceID} ? 1 : 0;

            # set customer user service member
            $ServiceObject->ServiceCustomerPortalMemberAdd(
                ServiceID          => $ServiceID,
                CustomerPortalID   => $CustomerPortalID,
                Active             => $Active,
                UserID             => $Self->{UserID},
            );
        }

        # if the user would like to continue editing the queue - templates relation just redirect to the edit screen
        # otherwise return to relations overview
        if (
            defined $ParamObject->GetParam( Param => 'ContinueAfterSave' )
            && ( $ParamObject->GetParam( Param => 'ContinueAfterSave' ) eq '1' )
            )
        {
            return $LayoutObject->Redirect(
                OP => "Action=$Self->{Action};Subaction=CustomerPortal;ID=$CustomerPortalID"
            );
        }
        else {
            return $LayoutObject->Redirect(
                OP => "Action=$Self->{Action}"
            );
        }
    }

    # ------------------------------------------------------------ #
    # overview
    # ------------------------------------------------------------ #
    my $Output = $LayoutObject->Header();
    $Output .= $LayoutObject->NavigationBar();
    $Output .= $Self->_Overview();
    $Output .= $LayoutObject->Footer();
    return $Output;
}

sub _Change {
    my ( $Self, %Param ) = @_;

    my %Data   = %{ $Param{Data} };
    my $Type   = $Param{Type} || 'CustomerPortal';
    my $NeType = $Type eq 'Service' ? 'CustomerPortal' : 'Service';

    my %VisibleType = (
        CustomerPortal => 'CustomerPortal',
        Service    => 'Service',
    );

    my $MyType       = $VisibleType{$Type};
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    my $BreadcrumbTitle = $LayoutObject->{LanguageObject}->Translate('Change Service Relations for Customer Portal');

    if ( $VisibleType{$Type} eq 'Service' ) {
        $BreadcrumbTitle = $LayoutObject->{LanguageObject}->Translate('Change Customer Portal Relations for Service');
    }

    $LayoutObject->Block(
        Name => 'Overview',
        Data => {
            Name            => $Param{Name},
            BreadcrumbTitle => $BreadcrumbTitle,
        },
    );
    $LayoutObject->Block( Name => 'ActionList' );
    $LayoutObject->Block( Name => 'ActionOverview' );
    $LayoutObject->Block( Name => 'Filter' );

    #fixed link
    my $ServiceTag;

    $ServiceTag = $Type eq 'Service' ? 'Service' : '';

    $LayoutObject->Block(
        Name => 'Change',
        Data => {
            %Param,
            ActionHome      => 'Admin' . $Type,
            NeType          => $NeType,
            VisibleType     => $VisibleType{$Type},
            VisibleNeType   => $VisibleType{$NeType},
            Service         => $ServiceTag,
            BreadcrumbTitle => $BreadcrumbTitle,
        },
    );

    # check if there are queue/template
    if ( !%Data ) {
        $LayoutObject->Block(
            Name => 'NoDataFoundMsgList',
            Data => {
                ColSpan => 2,
            },
        );
    }

    $LayoutObject->Block(
        Name => 'ChangeHeader',
        Data => {
            %Param,
            Type          => $Type,
            NeType        => $NeType,
            VisibleType   => $VisibleType{$Type},
            VisibleNeType => $VisibleType{$NeType},
        },
    );

    for my $ID ( sort { uc( $Data{$a} ) cmp uc( $Data{$b} ) } keys %Data ) {

        # set output class
        my $Selected = $Param{Selected}->{$ID} ? ' checked="checked"' : '';

        $ServiceTag = $Type ne 'Service' ? 'Service' : '';

        $LayoutObject->Block(
            Name => 'ChangeRow',
            Data => {
                %Param,
                Name          => $Param{Data}->{$ID},
                NeType        => $NeType,
                Type          => $Type,
                ID            => $ID,
                Selected      => $Selected,
                VisibleType   => $VisibleType{$Type},
                VisibleNeType => $VisibleType{$NeType},
                Queue         => $ServiceTag,
            },
        );
    }

    return $LayoutObject->Output(
        TemplateFile => 'AdminCustomerPortalsService',
        Data         => \%Param,
        VisibleType  => $MyType,
    );
}

sub _Overview {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    $LayoutObject->Block(
        Name => 'Overview',
        Data => {},
    );

    # no actions in action list
    #    $LayoutObject->Block(Name=>'ActionList');
    $LayoutObject->Block( Name => 'FilterCustomerPortal' );
    $LayoutObject->Block( Name => 'FilterService' );
    $LayoutObject->Block( Name => 'OverviewResult' );

    my $CustomerPortalObject = $Kernel::OM->Get('Kernel::System::CustomerPortal');

    # get std template list
    my %CustomerPortalData = $CustomerPortalObject->CustomerPortalList(
        Valid => 1,
    );

    # if there are results to show
    if (%CustomerPortalData) {
        for my $CustomerPortalID ( sort keys %CustomerPortalData ) {
            my %Data = $CustomerPortalObject->CustomerPortalGet(
                ID => $CustomerPortalID,
            );
            $CustomerPortalData{$CustomerPortalID}
                = $Data{Name};
        }
        for my $CustomerPortalID (
            sort { uc( $CustomerPortalData{$a} ) cmp uc( $CustomerPortalData{$b} ) }
            keys %CustomerPortalData
            )
        {

            # set output class
            $LayoutObject->Block(
                Name => 'List1n',
                Data => {
                    Name      => $CustomerPortalData{$CustomerPortalID},
                    Subaction => 'CustomerPortal',
                    ID        => $CustomerPortalID,
                },
            );
        }
    }

    # otherwise it displays a no data found message
    else {
        $LayoutObject->Block(
            Name => 'NoCustomerPortalsFoundMsg',
            Data => {},
        );
    }

    # get queue data
    my %ServiceData = $Kernel::OM->Get('Kernel::System::Service')->ServiceList( Valid => 1, UserID => 1 );

    # if there are results to show
    if (%ServiceData) {
        for my $ServiceID ( sort { uc( $ServiceData{$a} ) cmp uc( $ServiceData{$b} ) } keys %ServiceData ) {

            # set output class
            $LayoutObject->Block(
                Name => 'Listn1',
                Data => {
                    Name      => $ServiceData{$ServiceID},
                    Subaction => 'Service',
                    ID        => $ServiceID,
                },
            );
        }
    }

    # otherwise it displays a no data found message
    else {
        $LayoutObject->Block(
            Name => 'NoServicesFoundMsg',
            Data => {},
        );
    }

    # return output
    return $LayoutObject->Output(
        TemplateFile => 'AdminCustomerPortalsService',
        Data         => \%Param,
    );
}

1;
