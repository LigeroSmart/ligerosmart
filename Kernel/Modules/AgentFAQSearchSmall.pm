# --
# Kernel/Modules/AgentFAQSearchSmall.pm - module for FAQ search
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: AgentFAQSearchSmall.pm,v 1.3 2011-05-16 15:57:53 ub Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentFAQSearchSmall;

use strict;
use warnings;

use Kernel::System::FAQ;
use Kernel::System::SearchProfile;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.3 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check needed objects
    for my $Object (
        qw(ParamObject DBObject LayoutObject LogObject UserObject GroupObject ConfigObject MainObject EncodeObject)
        )
    {
        if ( !$Self->{$Object} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $Object!" );
        }
    }

    # create additional objects
    $Self->{FAQObject}           = Kernel::System::FAQ->new(%Param);
    $Self->{SearchProfileObject} = Kernel::System::SearchProfile->new(%Param);

    # get config for frontend
    $Self->{Config} = $Self->{ConfigObject}->Get("FAQ::Frontend::AgentFAQSearch");

    # set default interface settings
    $Self->{Interface} = $Self->{FAQObject}->StateTypeGet(
        Name   => 'internal',
        UserID => $Self->{UserID},
    );
    $Self->{InterfaceStates} = $Self->{FAQObject}->StateTypeList(
        Types  => $Self->{ConfigObject}->Get('FAQ::Agent::StateTypes'),
        UserID => $Self->{UserID},
    );

    $Self->{MultiLanguage} = $Self->{ConfigObject}->Get('FAQ::MultiLanguage');

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $Output;

    # get config data
    $Self->{StartHit} = int( $Self->{ParamObject}->GetParam( Param => 'StartHit' ) || 1 );
    $Self->{SearchLimit} = $Self->{Config}->{SearchLimit} || 500;
    $Self->{SortBy} = $Self->{ParamObject}->GetParam( Param => 'SortBy' )
        || $Self->{Config}->{'SortBy::Default'}
        || 'FAQID';
    $Self->{OrderBy} = $Self->{ParamObject}->GetParam( Param => 'OrderBy' )
        || $Self->{Config}->{'Order::Default'}
        || 'Down';
    $Self->{Profile}        = $Self->{ParamObject}->GetParam( Param => 'Profile' )        || '';
    $Self->{SaveProfile}    = $Self->{ParamObject}->GetParam( Param => 'SaveProfile' )    || '';
    $Self->{TakeLastSearch} = $Self->{ParamObject}->GetParam( Param => 'TakeLastSearch' ) || '';
    $Self->{SelectTemplate} = $Self->{ParamObject}->GetParam( Param => 'SelectTemplate' ) || '';
    $Self->{EraseTemplate}  = $Self->{ParamObject}->GetParam( Param => 'EraseTemplate' )  || '';
    my $Nav = $Self->{ParamObject}->GetParam( Param => 'Nav' ) || '';

    # search with a saved template
    if ( $Self->{ParamObject}->GetParam( Param => 'SearchTemplate' ) && $Self->{Profile} ) {
        return $Self->{LayoutObject}->Redirect(
            OP =>
                "Action=AgentFAQSearchSmall;Subaction=Search;TakeLastSearch=1;SaveProfile=1;Profile=$Self->{Profile};Nav=$Nav"
        );
    }

    # get single params
    my %GetParam;

    # load profiles string params (press load profile)
    if ( ( $Self->{Subaction} eq 'LoadProfile' && $Self->{Profile} ) || $Self->{TakeLastSearch} ) {
        %GetParam = $Self->{SearchProfileObject}->SearchProfileGet(
            Base      => 'FAQSearch',
            Name      => $Self->{Profile},
            UserLogin => $Self->{UserLogin},
        );
    }

    # get search string params (get submitted params)
    else {

        # get scalar search params
        for my $ParamName (qw(Number Title Keyword Fulltext ResultForm)) {
            $GetParam{$ParamName} = $Self->{ParamObject}->GetParam( Param => $ParamName );

            # remove whitespace on the start and end
            if ( $GetParam{$ParamName} ) {
                $GetParam{$ParamName} =~ s{ \A \s+ }{}xms;
                $GetParam{$ParamName} =~ s{ \s+ \z }{}xms;
            }
        }

        # get array search params
        for my $SearchParam (qw( CategoryIDs LanguageIDs )) {
            my @Array = $Self->{ParamObject}->GetArray( Param => $SearchParam );
            if (@Array) {
                $GetParam{$SearchParam} = \@Array;
            }
        }
    }

    # set result form env
    if ( !$GetParam{ResultForm} ) {
        $GetParam{ResultForm} = '';
    }

    # show result site
    if ( $Self->{Subaction} eq 'Search' && !$Self->{EraseTemplate} ) {

        # fill up profile name (e.g. with last-search)
        if ( !$Self->{Profile} || !$Self->{SaveProfile} ) {
            $Self->{Profile} = 'last-search';
        }

        # store last queue screen
        my $URL
            = "Action=AgentFAQSearchSmall;Subaction=Search;Profile=$Self->{Profile};SortBy=$Self->{SortBy}"
            . ";OrderBy=$Self->{OrderBy};TakeLastSearch=1;StartHit=$Self->{StartHit};Nav=$Nav";
        $Self->{SessionObject}->UpdateSessionID(
            SessionID => $Self->{SessionID},
            Key       => 'LastScreenOverview',
            Value     => $URL,
        );
        $Self->{SessionObject}->UpdateSessionID(
            SessionID => $Self->{SessionID},
            Key       => 'LastScreenView',
            Value     => $URL,
        );

        # save search profile (under last-search or real profile name)
        $Self->{SaveProfile} = 1;

        # remember last search values
        if ( $Self->{SaveProfile} && $Self->{Profile} ) {

            # remove old profile stuff
            $Self->{SearchProfileObject}->SearchProfileDelete(
                Base      => 'FAQSearch',
                Name      => $Self->{Profile},
                UserLogin => $Self->{UserLogin},
            );

            # insert new profile params
            for my $Key ( keys %GetParam ) {
                if ( $GetParam{$Key} ) {
                    $Self->{SearchProfileObject}->SearchProfileAdd(
                        Base      => 'FAQSearch',
                        Name      => $Self->{Profile},
                        Key       => $Key,
                        Value     => $GetParam{$Key},
                        UserLogin => $Self->{UserLogin},
                    );
                }
            }
        }

        # prepare fulltext search
        if ( $GetParam{Fulltext} ) {
            $GetParam{ContentSearch} = 'OR';
            $GetParam{What}          = $GetParam{Fulltext};
        }

        # perform FAQ search
        my @ViewableFAQIDs = $Self->{FAQObject}->FAQSearch(
            OrderBy             => [ $Self->{SortBy} ],
            OrderByDirection    => [ $Self->{OrderBy} ],
            Limit               => $Self->{SearchLimit},
            UserID              => $Self->{UserID},
            States              => $Self->{InterfaceStates},
            Interface           => $Self->{Interface},
            ContentSearchPrefix => '*',
            ContentSearchSuffix => '*',
            %GetParam,
        );

        # start html page
        my $Output = $Self->{LayoutObject}->Header( Type => 'Small' );
        $Self->{LayoutObject}->Print( Output => \$Output );
        $Output = '';

        $Self->{Filter} = $Self->{ParamObject}->GetParam( Param => 'Filter' ) || '';
        $Self->{View}   = $Self->{ParamObject}->GetParam( Param => 'View' )   || '';

        # show FAQ's
        my $LinkPage = 'Filter='
            . $Self->{LayoutObject}->LinkEncode( $Self->{Filter} )
            . ';View=' . $Self->{LayoutObject}->LinkEncode( $Self->{View} )
            . ';SortBy=' . $Self->{LayoutObject}->LinkEncode( $Self->{SortBy} )
            . ';OrderBy=' . $Self->{LayoutObject}->LinkEncode( $Self->{OrderBy} )
            . ';Profile=' . $Self->{Profile} . ';TakeLastSearch=1;Subaction=Search'
            . ';Nav=' . $Nav
            . ';';
        my $LinkSort = 'Filter='
            . $Self->{LayoutObject}->LinkEncode( $Self->{Filter} )
            . ';View=' . $Self->{LayoutObject}->LinkEncode( $Self->{View} )
            . ';Profile=' . $Self->{Profile} . ';TakeLastSearch=1;Subaction=Search'
            . ';Nav=' . $Nav

            . ';';
        my $LinkFilter = 'TakeLastSearch=1;Subaction=Search;Profile='
            . $Self->{LayoutObject}->LinkEncode( $Self->{Profile} )
            . ';Nav=' . $Nav
            . ';';
        my $LinkBack = 'Subaction=LoadProfile;Profile='
            . $Self->{LayoutObject}->LinkEncode( $Self->{Profile} )
            . ';Nav=' . $Nav
            . ';TakeLastSearch=1;';

        my $FilterLink
            = 'SortBy=' . $Self->{LayoutObject}->LinkEncode( $Self->{SortBy} )
            . ';OrderBy=' . $Self->{LayoutObject}->LinkEncode( $Self->{OrderBy} )
            . ';View=' . $Self->{LayoutObject}->LinkEncode( $Self->{View} )
            . ';Profile=' . $Self->{Profile} . ';TakeLastSearch=1;Subaction=Search'
            . ';Nav=' . $Nav
            . ';';

        # find out which columns should be shown
        my @ShowColumns;
        if ( $Self->{Config}->{ShowColumns} ) {

            # get all possible columns from config
            my %PossibleColumn = %{ $Self->{Config}->{ShowColumns} };

            # get the column names that should be shown
            COLUMNNAME:
            for my $Name ( keys %PossibleColumn ) {
                next COLUMNNAME if !$PossibleColumn{$Name};
                push @ShowColumns, $Name;
            }
        }

        $Output .= $Self->{LayoutObject}->FAQListShow(
            FAQIDs => \@ViewableFAQIDs,
            Total  => scalar @ViewableFAQIDs,

            View => $Self->{View},

            Env        => $Self,
            LinkPage   => $LinkPage,
            LinkSort   => $LinkSort,
            LinkFilter => $LinkFilter,
            LinkBack   => $LinkBack,
            Profile    => $Self->{Profile},

            TitleName => 'Search Result',
            Limit     => $Self->{SearchLimit},

            Filter     => $Self->{Filter},
            FilterLink => $FilterLink,

            OrderBy => $Self->{OrderBy},
            SortBy  => $Self->{SortBy},

            ShowColumns => \@ShowColumns,
            Nav         => $Nav,
        );

        # build footer
        $Output .= $Self->{LayoutObject}->Footer( Type => 'Small' );
        return $Output;
    }

    else {
        $Output = $Self->{LayoutObject}->Header( Type => 'Small' );

        # create output
        $Output .= $Self->_MaskForm(
            Nav => $Nav,
            %GetParam,
        );
        $Output .= $Self->{LayoutObject}->Footer( Type => 'Small' );

        return $Output;
    }
}

sub _MaskForm {
    my ( $Self, %Param ) = @_;

    # get profiles list
    my %Profiles = $Self->{SearchProfileObject}->SearchProfileList(
        Base      => 'FAQSearch',
        UserLogin => $Self->{UserLogin},
    );

    # build profiles output list
    $Param{ProfilesStrg} = $Self->{LayoutObject}->BuildSelection(
        Data         => {%Profiles},
        PossibleNone => 1,
        Name         => 'Profile',
        SelectedID   => $Param{Profile},
    );

    # get languages list
    my %Languages = $Self->{FAQObject}->LanguageList(
        UserID => $Self->{UserID},
    );

    # build languages output list
    $Param{LanguagesStrg} = $Self->{LayoutObject}->BuildSelection(
        Data       => {%Languages},
        Name       => 'LanguageIDs',
        Multiple   => 1,
        Size       => 5,
        SelectedID => $Param{LanguageIDs},
    );

    # get categories list
    my $Categories = $Self->{FAQObject}->GetUserCategoriesLongNames(
        CustomerUser => $Self->{UserLogin},
        Type         => 'rw',
        UserID       => $Self->{UserID},
    );

    # build categories output list
    $Param{CategoriesStrg} = $Self->{LayoutObject}->BuildSelection(
        Data       => $Categories,
        Name       => 'CategoryIDs',
        Multiple   => 1,
        Size       => 5,
        SelectedID => $Param{CategoryIDs},
    );

    # html search mask output
    $Self->{LayoutObject}->Block(
        Name => 'Search',
        Data => {%Param},
    );

    # show languages select
    if ( $Self->{MultiLanguage} ) {
        $Self->{LayoutObject}->Block(
            Name => 'Language',
            Data => {%Param},
        );
    }

    # html search mask output
    return $Self->{LayoutObject}->Output(
        TemplateFile => 'AgentFAQSearchSmall',
        Data         => {%Param},
    );
}

1;
