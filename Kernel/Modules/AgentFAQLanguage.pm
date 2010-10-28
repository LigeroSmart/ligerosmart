# --
# Kernel/Modules/AgentFAQLanguage.pm - the faq language management module
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# --
# $Id: AgentFAQLanguage.pm,v 1.4 2010-10-28 21:23:29 cr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::Modules::AgentFAQLanguage;

use strict;
use warnings;

use Kernel::System::FAQ;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.4 $) [1];

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

    # create needed objects
    $Self->{FAQObject} = Kernel::System::FAQ->new(%Param);

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my %GetParam = ();

    $GetParam{UserID} = $Self->{UserID};

    # permission check
    if ( !$Self->{AccessRw} ) {
        return $Self->{LayoutObject}->NoPermission( WithHeader => 'yes' );
    }

    # ------------------------------------------------------------ #
    # change
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'Change' ) {

        $GetParam{RequiredClass}  = "Validate_Required ";

        # check required parameters
        my $ID = $Self->{ParamObject}->GetParam( Param => 'ID' ) || '';
        if (! $ID){
             $Self->{LayoutObject}->FatalError( Message => "Need ID !" );
        }

        # get language data
        my %LanguageData = $Self->{FAQObject}->LanguageGet( ID => $ID );

        # output change language screen
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Self->_Edit(
            Action => 'Change',
            %LanguageData,
        );
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AgentFAQLanguage',
            Data         => \%Param,
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }

    # ------------------------------------------------------------ #
    # change action
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'ChangeAction' ) {

        # challenge token check for write action
        $Self->{LayoutObject}->ChallengeTokenCheck();

        # set class for server validation errors
        $GetParam{RequiredClass}  = "Validate_Required ServerError";

        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();

        # check for name
        for my $ParamName (qw(ID Name)) {
            if (! ( $GetParam{$ParamName} = $Self->{ParamObject}->GetParam( Param => $ParamName ) ) ) {
                $Self->_Edit(
                    Action      => 'Change',
                    ServerError => 'The name is required',
                    %GetParam,
                );
                $Output .= $Self->{LayoutObject}->Output(
                    TemplateFile => 'AgentFAQLanguage',
                    Data         => \%Param,
                );
                $Output .= $Self->{LayoutObject}->Footer();
                return $Output;
            }
        }

        # check for duplicate name
        if ( $Self->{FAQObject}->LanguageDuplicateCheck( Name => $GetParam{Name}, ID => $GetParam{ID} ) ) {
            $Self->_Edit(
                Action      => 'Change',
                ServerError => "Language '$GetParam{Name}' already exists!",
                %GetParam,
            );
            $Output .= $Self->{LayoutObject}->Output(
                TemplateFile => 'AgentFAQLanguage',
                Data         => \%Param,
            );
            $Output .= $Self->{LayoutObject}->Footer();
            return $Output;
        }

        # create new language and return to overview
        if ( $Self->{FAQObject}->LanguageUpdate( %GetParam, UserID => $Self->{UserID}, ) ){
            $Output .= $Self->{LayoutObject}->Notify( Info => 'FAQ language updated!' );
            $Self->_Overview();
        }
        else {
            return $Self->{LayoutObject}->ErrorScreen();
        }

        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AgentFAQLanguage',
            Data         => \%Param,
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }

    # ------------------------------------------------------------ #
    # add
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'Add' ) {
        $GetParam{RequiredClass}  = "Validate_Required ";
        for my $ParamName (qw(Name)) {
            $GetParam{$ParamName} = $Self->{ParamObject}->GetParam( Param => $ParamName );
        }
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Self->_Edit(
            Action => 'Add',
            %GetParam,
        );
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AgentFAQLanguage',
            Data         => \%Param,
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }

    # ------------------------------------------------------------ #
    # add action
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'AddAction' ) {

        # challenge token check for write action
        $Self->{LayoutObject}->ChallengeTokenCheck();

        # set class for server validation errors
        $GetParam{RequiredClass}  = "Validate_Required ServerError";

        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();

        # check for name
        for my $ParamName (qw(Name)) {
            if (! ( $GetParam{$ParamName} = $Self->{ParamObject}->GetParam( Param => $ParamName ) ) ) {
                $Self->_Edit(
                    Action      => 'Add',
                    ServerError => 'The name is required',
                    %GetParam,
                );
                $Output .= $Self->{LayoutObject}->Output(
                    TemplateFile => 'AgentFAQLanguage',
                    Data         => \%Param,
                );
                $Output .= $Self->{LayoutObject}->Footer();
                return $Output;
            }
        }

        # check for duplicate name
        if ( $Self->{FAQObject}->LanguageDuplicateCheck( Name => $GetParam{Name} ) ) {
            $Self->_Edit(
                Action      => 'Add',
                ServerError => "Language '$GetParam{Name}' already exists!",
                %GetParam,
            );
            $Output .= $Self->{LayoutObject}->Output(
                TemplateFile => 'AgentFAQLanguage',
                Data         => \%Param,
            );
            $Output .= $Self->{LayoutObject}->Footer();
            return $Output;
        }

        # create new language and return to overview
        if ( $Self->{FAQObject}->LanguageAdd( %GetParam, UserID => $Self->{UserID}, ) ){
            $Output .= $Self->{LayoutObject}->Notify( Info => 'FAQ language added!' );
            $Self->_Overview();
        }
        else {
            return $Self->{LayoutObject}->ErrorScreen();
        }

        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AgentFAQLanguage',
            Data         => \%Param,
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }

    # ---------------------------------------------------------- #
    # overview
    # ---------------------------------------------------------- #
    else {
        $Self->_Overview();
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AgentFAQLanguage',
            Data         => {
                %Param,
                %GetParam,
            },
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
}

sub _Edit {
    my ( $Self, %Param ) = @_;

    $Self->{LayoutObject}->Block(
        Name => 'Overview',
        Data => \%Param,
    );

    $Param{ServerError} = 'No Error' if (! $Param{ServerError} );

    $Self->{LayoutObject}->Block( Name => 'ActionList' );
    $Self->{LayoutObject}->Block( Name => 'ActionOverview' );

    $Self->{LayoutObject}->Block(
        Name => 'OverviewUpdate',
        Data => \%Param,
    );

    # shows header
    if ( $Param{Action} eq 'Change' ) {
        $Self->{LayoutObject}->Block( Name => 'HeaderEdit' );
    }
    else {
        $Self->{LayoutObject}->Block( Name => 'HeaderAdd' );
    }

    return 1;
}

sub _Overview {
    my ( $Self, %Param ) = @_;

    my $Output = '';

    #output overview blocks
    $Self->{LayoutObject}->Block( Name => 'Overview' );
    $Self->{LayoutObject}->Block( Name => 'ActionList' );
    $Self->{LayoutObject}->Block( Name => 'ActionAdd' );
    $Self->{LayoutObject}->Block( Name => 'OverviewResult' );

    # get languages list
    my %Languages = $Self->{FAQObject}->LanguageList( UserID => $Self->{UserID} );

    # if there are any languages, they are shown
    if (%Languages){
        for my $LanguageID ( sort { $Languages{$a} cmp $Languages{$b} } keys %Languages ) {

            # get languages result
            my %LanguageData = $Self->{FAQObject}->LanguageGet( ID => $LanguageID );

            #output results
            $Self->{LayoutObject}->Block(
                Name => 'OverviewResultRow',
                Data => { %LanguageData },
            );
        }
    }

    # otherwise a no data found msg is displayed
    else {
        $Self->{LayoutObject}->Block( Name => 'NoDataFoundMsg' );
    }
}
1;
