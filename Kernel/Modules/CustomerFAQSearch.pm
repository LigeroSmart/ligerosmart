# --
# Kernel/Modules/CustomerFAQSearch.pm - customer FAQ search
# Copyright (C) 2001-2012 OTRS AG, http://otrs.org/
# --
# $Id: CustomerFAQSearch.pm,v 1.24 2012-05-08 20:30:41 cr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::CustomerFAQSearch;

use strict;
use warnings;

use Kernel::System::FAQ;
use Kernel::System::SearchProfile;
use Kernel::System::CSV;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.24 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check needed objects
    for (qw(ParamObject DBObject LayoutObject LogObject ConfigObject)) {
        if ( !$Self->{$_} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $_!" );
        }
    }

    # create additional objects
    $Self->{FAQObject}           = Kernel::System::FAQ->new(%Param);
    $Self->{SearchProfileObject} = Kernel::System::SearchProfile->new(%Param);
    $Self->{CSVObject}           = Kernel::System::CSV->new(%Param);

    # get config for frontend
    $Self->{Config} = $Self->{ConfigObject}->Get("FAQ::Frontend::$Self->{Action}");

    # set default interface settings
    $Self->{Interface} = $Self->{FAQObject}->StateTypeGet(
        Name   => 'external',
        UserID => $Self->{UserID},
    );
    $Self->{InterfaceStates} = $Self->{FAQObject}->StateTypeList(
        Types  => $Self->{ConfigObject}->Get('FAQ::Customer::StateTypes'),
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
    $Self->{SearchLimit}     = $Self->{Config}->{SearchLimit}     || 200;
    $Self->{SearchPageShown} = $Self->{Config}->{SearchPageShown} || 40;
    $Self->{SortBy} = $Self->{ParamObject}->GetParam( Param => 'SortBy' )
        || $Self->{Config}->{'SortBy::Default'}
        || 'FAQID';
    $Self->{OrderBy} = $Self->{ParamObject}->GetParam( Param => 'Order' )
        || $Self->{Config}->{'Order::Default'}
        || 'Down';

    $Self->{Profile}        = $Self->{ParamObject}->GetParam( Param => 'Profile' )        || '';
    $Self->{SaveProfile}    = $Self->{ParamObject}->GetParam( Param => 'SaveProfile' )    || '';
    $Self->{TakeLastSearch} = $Self->{ParamObject}->GetParam( Param => 'TakeLastSearch' ) || '';
    $Self->{SelectTemplate} = $Self->{ParamObject}->GetParam( Param => 'SelectTemplate' ) || '';
    $Self->{EraseTemplate}  = $Self->{ParamObject}->GetParam( Param => 'EraseTemplate' )  || '';

    # search with a saved template
    if ( $Self->{ParamObject}->GetParam( Param => 'SearchTemplate' ) && $Self->{Profile} ) {
        return $Self->{LayoutObject}->Redirect(
            OP =>
                "Action=CustomerFAQSearch;Subaction=Search;TakeLastSearch=1;SaveProfile=1;Profile=$Self->{Profile}",
        );
    }

    # build output for open search description by FAQ number
    if ( $Self->{Subaction} eq 'OpenSearchDescriptionFAQNumber' ) {
        my $Output = $Self->{LayoutObject}->Output(
            TemplateFile => 'CustomerFAQSearchOpenSearchDescriptionFAQNumber',
            Data         => \%Param,
        );
        return $Self->{LayoutObject}->Attachment(
            Filename    => 'OpenSearchDescriptionFAQNumber.xml',
            ContentType => 'text/xml',
            Content     => $Output,
            Type        => 'inline',
        );
    }

    # build output for open search description by fulltext
    if ( $Self->{Subaction} eq 'OpenSearchDescriptionFulltext' ) {
        my $Output = $Self->{LayoutObject}->Output(
            TemplateFile => 'CustomerFAQSearchOpenSearchDescriptionFullText',
            Data         => \%Param,
        );
        return $Self->{LayoutObject}->Attachment(
            Filename    => 'OpenSearchDescriptionFulltext.xml',
            ContentType => 'text/xml',
            Content     => $Output,
            Type        => 'inline',
        );
    }

    # remember exclude attributes
    my @Excludes = $Self->{ParamObject}->GetArray( Param => 'Exclude' );

    # get single params
    my %GetParam;

    # load profiles string params (press load profile)
    if ( ( $Self->{Subaction} eq 'LoadProfile' && $Self->{Profile} ) || $Self->{TakeLastSearch} ) {
        %GetParam = $Self->{SearchProfileObject}->SearchProfileGet(
            Base      => 'CustomerFAQSearch',
            Name      => $Self->{Profile},
            UserLogin => $Self->{UserLogin},
        );
    }

    # get search string params (get submitted params)
    else {
        for my $ParamName (qw(Number Title Keyword Fulltext ResultForm)) {

            # get search string params (get submitted params)
            $GetParam{$ParamName} = $Self->{ParamObject}->GetParam( Param => $ParamName );

            # remove whitespace on the start and end
            if ( $GetParam{$ParamName} ) {
                $GetParam{$ParamName} =~ s{ \A \s+ }{}xms;
                $GetParam{$ParamName} =~ s{ \s+ \z }{}xms;
            }

            # db quote to prevent SQL injection
            $GetParam{$ParamName} = $Self->{DBObject}->Quote( $GetParam{$ParamName} );

        }

        # get array params
        for my $ParamName (qw(CategoryIDs LanguageIDs )) {

            # get search array params (get submitted params)
            my @Array = $Self->{ParamObject}->GetArray( Param => $ParamName );
            if (@Array) {
                $GetParam{$ParamName} = \@Array;
            }
        }
    }

    # check if item need to get excluded
    for my $Exclude (@Excludes) {
        if ( $GetParam{$Exclude} ) {
            delete $GetParam{$Exclude};
        }
    }

    # set result form env
    if ( !$GetParam{ResultForm} ) {
        $GetParam{ResultForm} = '';
    }
    if ( $GetParam{ResultForm} eq 'Print' ) {
        $Self->{SearchPageShown} = $Self->{SearchLimit};
    }

    # check request
    if ( $Self->{Subaction} eq 'OpenSearchDescription' ) {
        my $Output = $Self->{LayoutObject}->Output(
            TemplateFile => 'CustomerFAQSearchOpenSearchDescription',
            Data         => {%Param},
        );
        return $Self->{LayoutObject}->Attachment(
            Filename    => 'OpenSearchDescription.xml',
            ContentType => 'text/xml',
            Content     => $Output,
            Type        => 'inline',
        );
    }

    # show result page
    if ( $Self->{Subaction} eq 'Search' && !$Self->{EraseTemplate} ) {

        # fill up profile name (e.g. with last-search)
        if ( !$Self->{Profile} || !$Self->{SaveProfile} ) {
            $Self->{Profile} = 'last-search';
        }

        # store last overview screen
        my $URL
            = "Action=CustomerFAQSearch;Subaction=Search;Profile=$Self->{Profile}"
            . ";SortBy=$Self->{SortBy};OrderBy=$Self->{OrderBy};TakeLastSearch=1"
            . ";StartHit=$Self->{StartHit}";

        # store last screen
        $Self->{SessionObject}->UpdateSessionID(
            SessionID => $Self->{SessionID},
            Key       => 'LastScreenView',
            Value     => $URL,
        );
        $Self->{SessionObject}->UpdateSessionID(
            SessionID => $Self->{SessionID},
            Key       => 'LastScreenOverview',
            Value     => $URL,
        );

        # save search profile (under last-search or real profile name)
        $Self->{SaveProfile} = 1;

        # remember last search values
        if ( $Self->{SaveProfile} && $Self->{Profile} ) {

            # remove old profile stuff
            $Self->{SearchProfileObject}->SearchProfileDelete(
                Base      => 'CustomerFAQSearch',
                Name      => $Self->{Profile},
                UserLogin => $Self->{UserLogin},
            );

            # insert new profile params
            for my $ParamName ( keys %GetParam ) {
                if ( $GetParam{$ParamName} ) {
                    $Self->{SearchProfileObject}->SearchProfileAdd(
                        Base      => 'CustomerFAQSearch',
                        Name      => $Self->{Profile},
                        Key       => $ParamName,
                        Value     => $GetParam{$ParamName},
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

        # CSV output
        if ( $GetParam{ResultForm} eq 'CSV' ) {
            my @CSVHead;
            my @CSVData;

            for my $FAQID (@ViewableFAQIDs) {

                # get FAQ data details
                my %FAQData = $Self->{FAQObject}->FAQGet(
                    FAQID  => $FAQID,
                    UserID => $Self->{UserID},
                );

                # format the change time
                my $Changed = $Self->{LayoutObject}->Output(
                    Template => '$TimeLong{"$Data{"Changed"}"}',
                    Data     => \%FAQData,
                );

                # get info for CSV output
                my %CSVInfo = (
                    FAQNumber => $FAQData{Number},
                    Title     => $FAQData{Title},
                    Category  => $FAQData{CategoryName},
                    Language  => $FAQData{Language},
                    State     => $FAQData{State},
                    Changed   => $Changed,
                );

                # csv quote
                if ( !@CSVHead ) {
                    @CSVHead = qw( FAQNumber Title Category);

                    # insert language header
                    if ( $Self->{MultiLanguage} ) {
                        push @CSVHead, 'Language';
                    }

                    push @CSVHead, qw(State Changed);
                }
                my @Data;
                for my $Header (@CSVHead) {
                    push @Data, $CSVInfo{$Header};
                }
                push @CSVData, \@Data;
            }

            # csv quote
            # translate non existing header may result in a garbage file
            if ( !@CSVHead ) {
                @CSVHead = qw(FAQNumber Title Category);

                # insert language header
                if ( $Self->{MultiLanguage} ) {
                    push @CSVHead, 'Language';
                }

                push @CSVHead, qw(State Changed);
            }

            # translate headers
            for my $Header (@CSVHead) {

                # replace FAQNumber header with the current FAQHook from config
                if ( $Header eq 'FAQNumber' ) {
                    $Header = $Self->{ConfigObject}->Get('FAQ::FAQHook');
                }
                else {
                    $Header = $Self->{LayoutObject}->{LanguageObject}->Get($Header);
                }
            }

            # assable CSV data
            my $CSV = $Self->{CSVObject}->Array2CSV(
                Head      => \@CSVHead,
                Data      => \@CSVData,
                Separator => $Self->{UserCSVSeparator},
            );

            # return csv to download
            my $CSVFile = 'FAQ_search';
            my ( $s, $m, $h, $D, $M, $Y ) = $Self->{TimeObject}->SystemTime2Date(
                SystemTime => $Self->{TimeObject}->SystemTime(),
            );
            $M = sprintf( "%02d", $M );
            $D = sprintf( "%02d", $D );
            $h = sprintf( "%02d", $h );
            $m = sprintf( "%02d", $m );
            return $Self->{LayoutObject}->Attachment(
                Filename    => $CSVFile . "_" . "$Y-$M-$D" . "_" . "$h-$m.csv",
                ContentType => "text/csv; charset=" . $Self->{LayoutObject}->{UserCharset},
                Content     => $CSV,
            );
        }
        elsif ( $GetParam{ResultForm} eq 'Print' ) {
            for my $FAQID (@ViewableFAQIDs) {

                # get FAQ data details
                my %FAQData = $Self->{FAQObject}->FAQGet(
                    FAQID  => $FAQID,
                    UserID => $Self->{UserID},
                );

                # add table block
                $Self->{LayoutObject}->Block(
                    Name => 'Record',
                    Data => {%FAQData},
                );

                # add language data
                if ( $Self->{MultiLanguage} ) {
                    $Self->{LayoutObject}->Block(
                        Name => 'RecordLanguage',
                        Data => {%FAQData},
                    );
                }

            }

            # output header
            my $Output = $Self->{LayoutObject}->PrintHeader( Width => 800 );
            if ( scalar @ViewableFAQIDs == $Self->{SearchLimit} ) {
                $Param{Warning} = '$Text{"Reached max. count of %s search hits!", "'
                    . $Self->{SearchLimit} . '"}';
            }

            # add language header
            if ( $Self->{MultiLanguage} ) {
                $Self->{LayoutObject}->Block(
                    Name => 'HeaderLanguage',
                    Data => {},
                );
            }

            $Output .= $Self->{LayoutObject}->Output(
                TemplateFile => 'CustomerFAQSearchResultPrint',
                Data         => \%Param,
            );

            # add footer
            $Output .= $Self->{LayoutObject}->PrintFooter();

            # return output
            return $Output;

        }

        my $Counter = 0;

        # if there are results to show
        if (@ViewableFAQIDs) {
            for my $FAQID (@ViewableFAQIDs) {

                $Counter++;

                # build search result
                if (
                    $Counter >= $Self->{StartHit}
                    && $Counter < ( $Self->{SearchPageShown} + $Self->{StartHit} )
                    )
                {

                    # get FAQ data details
                    my %FAQData = $Self->{FAQObject}->FAQGet(
                        FAQID  => $FAQID,
                        UserID => $Self->{UserID},
                    );

                    # add blocks to template
                    $Self->{LayoutObject}->Block(
                        Name => 'Record',
                        Data => {
                            %FAQData,
                        },
                    );

                    # add language data
                    if ( $Self->{MultiLanguage} ) {
                        $Self->{LayoutObject}->Block(
                            Name => 'RecordLanguage',
                            Data => {%FAQData},
                        );
                    }
                }
            }
        }

        # otherwise show a no data found msg
        else {
            $Self->{LayoutObject}->Block( Name => 'NoDataFoundMsg' );
        }

        # create a lookup table for attribute settings
        my %AttributeMap = (
            Number => {
                Name         => $Self->{ConfigObject}->Get('FAQ::FAQHook'),
                Translatable => 0,
            },
            Title => {
                Name         => 'Title',
                Translatable => 1,
            },
            Keyword => {
                Name         => 'Keyword',
                Translatable => 1,
            },
            Fulltext => {
                Name         => 'Fulltext',
                Translatable => 1,
            },
            CategoryIDs => {
                Name         => 'Category',
                Translatable => 1,
            },
            LanguageIDs => {
                Name         => 'Language',
                Translatable => 1,
            },

        );

        # print each attribute in search results area.
        for my $Attribute ( keys %AttributeMap ) {

            # check if the attribute was defined by the user
            if ( $GetParam{$Attribute} ) {

                # set attribute name and translate it if applies
                my $AttributeName = $AttributeMap{$Attribute}->{Name};
                if ( $AttributeMap{$Attribute}->{Translatable} ) {
                    $AttributeName = $Self->{LayoutObject}->{LanguageObject}->Get($AttributeName);
                }

                my $AttributeValue;

                # check if the values is an array to parse each value
                if ( ref $GetParam{$Attribute} eq 'ARRAY' ) {

                    # Category attribute
                    if ( $Attribute eq 'CategoryIDs' ) {

                        # get the long name for all customer categories
                        my $CategoryList = $Self->{FAQObject}->GetCustomerCategoriesLongNames(
                            CustomerUser => $Self->{UserID},
                            Type         => 'rw',
                            UserID       => 1,
                        );

                        # convert each category id to category long name
                        my @CategoryNames;
                        CATEGORYID:
                        for my $CatedoryID ( @{ $GetParam{$Attribute} } ) {
                            next CATEGORYID if !$CategoryList->{$CatedoryID};
                            push @CategoryNames, $CategoryList->{$CatedoryID};
                        }

                        # create a string with all selected category names
                        $AttributeValue = join( " + ", @CategoryNames );
                    }

                    # LanguageIDs
                    elsif ( $Attribute eq 'LanguageIDs' ) {

                        # convert each language id to language name
                        my @LanguageNames;
                        LANGUAGEID:
                        for my $LanguageID ( @{ $GetParam{$Attribute} } ) {
                            my $LanguageName = $Self->{FAQObject}->LanguageLookup(
                                LanguageID => $LanguageID,
                            );
                            next LANGUAGEID if !$LanguageName;
                            push @LanguageNames, $LanguageName
                        }

                        # create a string with all selected language names
                        $AttributeValue = join( " + ", @LanguageNames );
                    }
                }

                # otherwise is an scalar and can be set directly
                else {
                    $AttributeValue = $GetParam{$Attribute}
                }

                $Self->{LayoutObject}->Block(
                    Name => 'SearchTerms',
                    Data => {
                        Attribute => $AttributeName,
                        Value     => $AttributeValue,
                    },
                );
            }
        }

        my $Link = 'Profile=' . $Self->{LayoutObject}->LinkEncode( $Self->{Profile} ) . ';';
        $Link .= 'SortBy=' . $Self->{LayoutObject}->LinkEncode( $Self->{SortBy} ) . ';';
        $Link .= 'Order=' . $Self->{LayoutObject}->LinkEncode( $Self->{OrderBy} ) . ';';
        $Link .= 'TakeLastSearch=1;';

        # build search navigation bar
        my %PageNav = $Self->{LayoutObject}->PageNavBar(
            Limit     => $Self->{SearchLimit},
            StartHit  => $Self->{StartHit},
            PageShown => $Self->{SearchPageShown},
            AllHits   => $Counter,
            Action    => "Action=CustomerFAQSearch;Subaction=Search",
            Link      => $Link,
            IDPrefix  => "CustomerFAQSearch",
        );

        # show footer filter - show only if more the one page is available
        if ( defined $PageNav{TotalHits} && ( $PageNav{TotalHits} > $Self->{SearchPageShown} ) ) {
            $Self->{LayoutObject}->Block(
                Name => 'Pagination',
                Data => {
                    %Param,
                    %PageNav,
                },
            );
        }

        # start html page
        my $Output = $Self->{LayoutObject}->CustomerHeader();
        $Output .= $Self->{LayoutObject}->CustomerNavigationBar();

        # Set the SortBy Class
        my $SortClass;

        # this sets the opposit to the OrderBy parameter
        if ( $Self->{OrderBy} eq 'Down' ) {
            $SortClass = 'SortAscending';
        }
        elsif ( $Self->{OrderBy} eq 'Up' ) {
            $SortClass = 'SortDescending';
        }

        # set the SortBy Class to the correct field
        my %CSSSort;
        my $SortBy = $Self->{SortBy} . 'Sort';
        $CSSSort{$SortBy} = $SortClass;

        my %NewOrder = (
            Down => 'Up',
            Up   => 'Down',
        );

        # show language header
        if ( $Self->{MultiLanguage} ) {
            $Self->{LayoutObject}->Block(
                Name => 'HeaderLanguage',
                Data => {
                    %Param,
                    %CSSSort,
                    Order => $NewOrder{ $Self->{OrderBy} },
                },
            );
        }

        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'CustomerFAQSearchResultShort',
            Data         => {
                %Param,
                %PageNav,
                %CSSSort,
                Order   => $NewOrder{ $Self->{OrderBy} },
                Profile => $Self->{Profile},
            },
        );

        # build footer
        $Output .= $Self->{LayoutObject}->CustomerFooter();
        return $Output;
    }

    # empty search site
    else {

        # delete profile
        if ( $Self->{EraseTemplate} && $Self->{Profile} ) {

            # remove old profile stuff
            $Self->{SearchProfileObject}->SearchProfileDelete(
                Base      => 'CustomerFAQSearch',
                Name      => $Self->{Profile},
                UserLogin => $Self->{UserLogin},
            );
            %GetParam = ();
            $Self->{Profile} = '';
        }

        # generate search mask
        my $Output = $Self->{LayoutObject}->CustomerHeader();
        $Output .= $Self->{LayoutObject}->CustomerNavigationBar();
        $Output .= $Self->MaskForm(
            %GetParam,
            Profile => $Self->{Profile},
            Area    => 'Customer',
        );
        $Output .= $Self->{LayoutObject}->CustomerFooter();
        return $Output;
    }
}

sub MaskForm {
    my ( $Self, %Param ) = @_;

    # set output formats list
    my %ResultForm = (
        Normal => 'Normal',
        Print  => 'Print',
        CSV    => 'CSV',
    );

    # build output formats list
    $Param{ResultFormStrg} = $Self->{LayoutObject}->BuildSelection(
        Data       => {%ResultForm},
        Name       => 'ResultForm',
        SelectedID => $Param{ResultForm} || 'Normal',
    );

    # get profiles list
    my %Profiles = $Self->{SearchProfileObject}->SearchProfileList(
        Base      => 'CustomerFAQSearch',
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
    my $Categories = $Self->{FAQObject}->GetCustomerCategoriesLongNames(
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
        TemplateFile => 'CustomerFAQSearch',
        Data         => {%Param},
    );
}

1;
