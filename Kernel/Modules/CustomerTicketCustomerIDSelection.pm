# --
# Kernel/Modules/CustomerTicketCustomerIDSelection.pm - to handle customer messages
# Copyright (C) 2006-2016 c.a.p.e. IT GmbH, http://www.cape-it.de
#
# written/edited by:
# * Torsten(dot)Thau(at)cape(dash)it(dot)de
# * Martin(dot)Balzarek(at)cape(dash)it(dot)de
# * Frank(dot)Oberender(at)cape(dash)it(dot)de
# * Dorothea(dot)Doerffel(at)cape(dash)it(dot)de
# * Rene(dot)Boehm(at)cape(dash)it(dot)de
#
# --
# $Id: CustomerTicketCustomerIDSelection.pm,v 1.13.2.1 2016/01/20 15:48:30 ddoerffel Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::CustomerTicketCustomerIDSelection;

use strict;
use warnings;
use Data::Dumper;

our $ObjectManagerDisabled = 1;

our @ObjectDependencies = (
    'System::Config',
    'Kernel::System::CustomerUser',
    'Kernel::System::CustomerCompany',
    'Kernel::System::Log',
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # COMPLEMENTO
    my $ParamObject  = $Kernel::OM->Get('Kernel::System::Web::Request');
    # EO COMPLEMENTO
    
    # get form id
    $Self->{FormID} = $ParamObject->GetParam( Param => 'FormID' );

    # create form id
    if ( !$Self->{FormID} ) {
        $Self->{FormID} = $Kernel::OM->Get('Kernel::System::Web::UploadCache')->FormIDCreate();
    }

    $Self->{Config} = $Kernel::OM->Get('Kernel::Config')->Get("Ticket::Frontend::$Self->{Action}");

    return $Self;
}

sub PreRun {
    my ( $Self, %Param ) = @_;

    my $Output;
    
    return if ( $Self->{Action} ne 'CustomerTicketMessage' );

    # COMPLEMENTO
    my $ParamObject  = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    # EO COMPLEMENTO

    for my $CurrParam (qw{SelectedCustomerID DefaultSet}) {
        $Param{$CurrParam} = $ParamObject->GetParam( Param => $CurrParam ) || '';
    }
    return if $Param{SelectedCustomerID};

    # get all customer ids
    my @CustomerIDArray = $Kernel::OM->Get('Kernel::System::CustomerUser')->CustomerIDs(
        User => $Self->{UserID},
    );

    if ( ( grep { $_ eq $Self->{UserCustomerID}; } @CustomerIDArray ) == 0 ) {
        push( @CustomerIDArray, $Self->{UserCustomerID} );
    }

    if ( scalar(@CustomerIDArray) > 1 ) {
        return $LayoutObject->Redirect(
            OP => "Action=CustomerTicketCustomerIDSelection;DefaultSet=" . $Param{DefaultSet},
        );
    }

    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # COMPLEMENTO
    my $ParamObject  = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    # EO COMPLEMENTO
    
    my %GetParam = ();
    for my $CurrParam (qw{SelectedCustomerID DefaultSet}) {
        $GetParam{$CurrParam} = $ParamObject->GetParam( Param => $CurrParam );
    }

    if ( !$Self->{Subaction} ) {
        my @CustomerIDArray = $Kernel::OM->Get('Kernel::System::CustomerUser')->CustomerIDs(
            User => $Self->{UserID},
        );

        if ( ( grep { $_ eq $Self->{UserCustomerID}; } @CustomerIDArray ) == 0 ) {
            push( @CustomerIDArray, $Self->{UserCustomerID} );
        }

        if ( scalar(@CustomerIDArray) < 2 ) {
            return $LayoutObject->Redirect(
                OP => "Action=CustomerTicketMessage"
                    . ";SelectedCustomerID=" . $Self->{UserCustomerID}
                    . ";DefaultSet=" . $GetParam{DefaultSet}
            );
        }

        my $Output .= $LayoutObject->CustomerHeader();
        $Output .= $LayoutObject->CustomerNavigationBar();
        $Output .= $Self->_MaskNew( %Param, %GetParam, CustomerIDArray => \@CustomerIDArray );
        $Output .= $LayoutObject->CustomerFooter();
        return $Output;
    }
    elsif ( $Self->{Subaction} eq 'NewTicket' ) {

        # pass selected CustomerID and product and redirect to ticket creation mask...
        return $LayoutObject->Redirect(
            OP => "Action=CustomerTicketMessage"
                . ";SelectedCustomerID=" . $GetParam{SelectedCustomerID}
                . ";DefaultSet=" . $GetParam{DefaultSet}
        );

    }

    # this should never happen, however...
    my $Output = $LayoutObject->CustomerHeader( Title => 'Error' );
    $Output .= $LayoutObject->CustomerError(
        Message => 'No valid subaction!',
        Comment => 'Please contact your administrator',
    );
    $Output .= $LayoutObject->CustomerFooter();
    return $Output;
}

sub _MaskNew {
    my ( $Self, %Param ) = @_;

    # COMPLEMENTO
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    # EO COMPLEMENTO
    
    my @ItemList;
    my @CustomerIDArray = @{ $Param{CustomerIDArray} };
    for my $CurrCustomerID ( sort(@CustomerIDArray) ) {

        # get customer data
        my %CustomerData = $Kernel::OM->Get('Kernel::System::CustomerCompany')->CustomerCompanyGet(
            CustomerID => $CurrCustomerID,
        );

        my @ItemColumns = (
            {
                Type         => 'Radiobutton',
                Name         => 'SelectedCustomerRadio',
                ID           => 'SelectedCustomerRadio' . $CurrCustomerID,
                Content      => $CurrCustomerID,
                Title        => 'Select customer ID: %s',
                TitleContent => $CurrCustomerID,
                Css          => 'SelectedCustomerRadio',
            },
            {
                Type         => 'Label',
                LabelRef     => 'SelectedCustomerRadio' . $CurrCustomerID,
                Title        => 'Select customer ID: %s',
                TitleContent => $CurrCustomerID,
                Content      => "$CustomerData{CustomerCompanyName} ($CurrCustomerID)",
                MaxLength    => 100,
                Css          => 'SelectedCustomerRadioLabel',
            },
        );
        push @ItemList, \@ItemColumns;
    }

#    # define table headline...
    my %Block = (

#        Headline => [
#            {
#                Content => 'Selection',
#            },
#            {
#                Content => 'CustomerID',
#            },
#        ],
        ItemList => \@ItemList,
    );
    $LayoutObject->Block(
        Name => 'CustomerIDSelection',
        Data => \%Param,
    );

    for my $HeadlineColumn ( @{ $Block{Headline} } ) {
        $LayoutObject->Block(
            Name => 'TableBlockColumn',
            Data => $HeadlineColumn,
        );
    }

    for my $Row ( @{ $Block{ItemList} } ) {
        $LayoutObject->Block(
            Name => 'TableBlockRow',
            Data => $Row,
        );
        for my $Column ( @{$Row} ) {


            my $Content = $Self->_LinkObjectContentStringCreate(
                LayoutObject => $LayoutObject,
                ContentHash  => $Column,
            );


#            $LayoutObject->Block(
#                Name => 'TableBlockRowColumn',
#                Data => {
#                    Content => $Content,
#                },
#            );
        }
    }



    my $out= $LayoutObject->Output(
        TemplateFile => 'CustomerTicketCustomerIDSelection',
        Data         => \%Param,
    );

#    $Kernel::OM->Get('Kernel::System::Log')->Log(
#        Priority => 'error',
#        Message  => "aaaaaaaa ".$out
#    );    
    
    return $out;

    
}

#-------------------------------------------------------------------------------
# internal methods....

sub _LinkObjectContentStringCreate {
    my ( $Self, %Param ) = @_;
    my $Blockname = '';

    # COMPLEMENTO
    my $LayoutObject = $Param{LayoutObject};
    # EO COMPLEMENTO
    
    for my $Argument (qw(ContentHash)) {
        if ( !$Param{$Argument} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    $Blockname = $Param{ContentHash}->{Type} || 'Plain';

    # run block
            $LayoutObject->Block(
                Name => 'TableBlockRowColumn',
                Data => {
#                    Content => 'a',
                },
            );

    $LayoutObject->Block(
        Name => $Blockname,
        Data => $Param{ContentHash},
    );

    return;
#    return $LayoutObject->Output(
#        TemplateFile => 'CustomerTicketCustomerIDSelection',
#    );
}

# EO internal methods
#-------------------------------------------------------------------------------

1;