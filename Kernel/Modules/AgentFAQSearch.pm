# --
# Kernel/Modules/AgentFAQSearch.pm - module for FAQ search
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentFAQSearch;

use strict;
use warnings;

use Kernel::System::FAQ;
use Kernel::System::SearchProfile;
use Kernel::System::CSV;
use Kernel::System::Valid;
use Kernel::System::VariableCheck qw(:all);

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
    $Self->{CSVObject}           = Kernel::System::CSV->new(%Param);
    $Self->{ValidObject}         = Kernel::System::Valid->new(%Param);

    # get config for frontend
    $Self->{Config} = $Self->{ConfigObject}->Get("FAQ::Frontend::$Self->{Action}");

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

    # build output for open search description by FAQ number
    if ( $Self->{Subaction} eq 'OpenSearchDescriptionFAQNumber' ) {
        my $Output = $Self->{LayoutObject}->Output(
            TemplateFile => 'AgentFAQSearchOpenSearchDescriptionFAQNumber',
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
            TemplateFile => 'AgentFAQSearchOpenSearchDescriptionFulltext',
            Data         => \%Param,
        );
        return $Self->{LayoutObject}->Attachment(
            Filename    => 'OpenSearchDescriptionFulltext.xml',
            ContentType => 'text/xml',
            Content     => $Output,
            Type        => 'inline',
        );
    }

    # search with a saved template
    if ( $Self->{ParamObject}->GetParam( Param => 'SearchTemplate' ) && $Self->{Profile} ) {
        return $Self->{LayoutObject}->Redirect(
            OP =>
                "Action=AgentFAQSearch;Subaction=Search;TakeLastSearch=1;SaveProfile=1;Profile=$Self->{Profile}"
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
        for my $ParamName (
            qw(Number Title Keyword Fulltext ResultForm VoteSearch VoteSearchType RateSearch
            RateSearchType ApprovedSearch
            TimeSearchType ChangeTimeSearchType
            ItemCreateTimePointFormat ItemCreateTimePoint
            ItemCreateTimePointStart
            ItemCreateTimeStart ItemCreateTimeStartDay ItemCreateTimeStartMonth
            ItemCreateTimeStartYear
            ItemCreateTimeStop ItemCreateTimeStopDay ItemCreateTimeStopMonth
            ItemCreateTimeStopYear
            ItemChangeTimePointFormat ItemChangeTimePoint
            ItemChangeTimePointStart
            ItemChangeTimeStart ItemChangeTimeStartDay ItemChangeTimeStartMonth
            ItemChangeTimeStartYear
            ItemChangeTimeStop ItemChangeTimeStopDay ItemChangeTimeStopMonth
            ItemChangeTimeStopYear
            )
            )
        {
            $GetParam{$ParamName} = $Self->{ParamObject}->GetParam( Param => $ParamName );

            # remove whitespace on the start and end
            if ( $GetParam{$ParamName} ) {
                $GetParam{$ParamName} =~ s{ \A \s+ }{}xms;
                $GetParam{$ParamName} =~ s{ \s+ \z }{}xms;
            }
        }

        # get array search params
        for my $SearchParam (
            qw(CategoryIDs LanguageIDs ValidIDs StateIDs CreatedUserIDs LastChangedUserIDs)
            )
        {
            my @Array = $Self->{ParamObject}->GetArray( Param => $SearchParam );
            if (@Array) {
                $GetParam{$SearchParam} = \@Array;
            }
        }
    }

    # get approved option
    if ( $GetParam{ApprovedSearch} && $GetParam{ApprovedSearch} eq 'Yes' ) {
        $GetParam{Approved} = 1;
    }
    elsif ( $GetParam{ApprovedSearch} && $GetParam{ApprovedSearch} eq 'No' ) {
        $GetParam{Approved} = 0;
    }

    # get create time option
    if ( !$GetParam{TimeSearchType} ) {
        $GetParam{'TimeSearchType::None'} = 1;
    }
    elsif ( $GetParam{TimeSearchType} eq 'TimePoint' ) {
        $GetParam{'TimeSearchType::TimePoint'} = 1;
    }
    elsif ( $GetParam{TimeSearchType} eq 'TimeSlot' ) {
        $GetParam{'TimeSearchType::TimeSlot'} = 1;
    }

    # get change time option
    if ( !$GetParam{ChangeTimeSearchType} ) {
        $GetParam{'ChangeTimeSearchType::None'} = 1;
    }
    elsif ( $GetParam{ChangeTimeSearchType} eq 'TimePoint' ) {
        $GetParam{'ChangeTimeSearchType::TimePoint'} = 1;
    }
    elsif ( $GetParam{ChangeTimeSearchType} eq 'TimeSlot' ) {
        $GetParam{'ChangeTimeSearchType::TimeSlot'} = 1;
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

        # store last overview screen
        my $URL
            = "Action=AgentFAQSearch;Subaction=Search;Profile=$Self->{Profile};SortBy=$Self->{SortBy}"
            . ";OrderBy=$Self->{OrderBy};TakeLastSearch=1;StartHit=$Self->{StartHit}";
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
            for my $Key ( sort keys %GetParam ) {
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

        my %TimeMap = (
            ItemCreate => 'Time',
            ItemChange => 'ChangeTime',
        );

        for my $TimeType ( sort keys %TimeMap ) {

            # get create time settings
            if ( !$GetParam{ $TimeMap{$TimeType} . 'SearchType' } ) {

                # do nothing with time stuff
            }
            elsif ( $GetParam{ $TimeMap{$TimeType} . 'SearchType' } eq 'TimeSlot' ) {
                for my $Key (qw(Month Day)) {
                    $GetParam{ $TimeType . 'TimeStart' . $Key }
                        = sprintf( "%02d", $GetParam{ $TimeType . 'TimeStart' . $Key } );
                    $GetParam{ $TimeType . 'TimeStop' . $Key }
                        = sprintf( "%02d", $GetParam{ $TimeType . 'TimeStop' . $Key } );
                }
                if (
                    $GetParam{ $TimeType . 'TimeStartDay' }
                    && $GetParam{ $TimeType . 'TimeStartMonth' }
                    && $GetParam{ $TimeType . 'TimeStartYear' }
                    )
                {
                    $GetParam{ $TimeType . 'TimeNewerDate' }
                        = $GetParam{ $TimeType . 'TimeStartYear' } . '-'
                        . $GetParam{ $TimeType . 'TimeStartMonth' } . '-'
                        . $GetParam{ $TimeType . 'TimeStartDay' }
                        . ' 00:00:00';
                }
                if (
                    $GetParam{ $TimeType . 'TimeStopDay' }
                    && $GetParam{ $TimeType . 'TimeStopMonth' }
                    && $GetParam{ $TimeType . 'TimeStopYear' }
                    )
                {
                    $GetParam{ $TimeType . 'TimeOlderDate' }
                        = $GetParam{ $TimeType . 'TimeStopYear' } . '-'
                        . $GetParam{ $TimeType . 'TimeStopMonth' } . '-'
                        . $GetParam{ $TimeType . 'TimeStopDay' }
                        . ' 23:59:59';
                }
            }
            elsif ( $GetParam{ $TimeMap{$TimeType} . 'SearchType' } eq 'TimePoint' ) {
                if (
                    $GetParam{ $TimeType . 'TimePoint' }
                    && $GetParam{ $TimeType . 'TimePointStart' }
                    && $GetParam{ $TimeType . 'TimePointFormat' }
                    )
                {
                    my $Time = 0;
                    if ( $GetParam{ $TimeType . 'TimePointFormat' } eq 'minute' ) {
                        $Time = $GetParam{ $TimeType . 'TimePoint' };
                    }
                    elsif ( $GetParam{ $TimeType . 'TimePointFormat' } eq 'hour' ) {
                        $Time = $GetParam{ $TimeType . 'TimePoint' } * 60;
                    }
                    elsif ( $GetParam{ $TimeType . 'TimePointFormat' } eq 'day' ) {
                        $Time = $GetParam{ $TimeType . 'TimePoint' } * 60 * 24;
                    }
                    elsif ( $GetParam{ $TimeType . 'TimePointFormat' } eq 'week' ) {
                        $Time = $GetParam{ $TimeType . 'TimePoint' } * 60 * 24 * 7;
                    }
                    elsif ( $GetParam{ $TimeType . 'TimePointFormat' } eq 'month' ) {
                        $Time = $GetParam{ $TimeType . 'TimePoint' } * 60 * 24 * 30;
                    }
                    elsif ( $GetParam{ $TimeType . 'TimePointFormat' } eq 'year' ) {
                        $Time = $GetParam{ $TimeType . 'TimePoint' } * 60 * 24 * 365;
                    }
                    if ( $GetParam{ $TimeType . 'TimePointStart' } eq 'Before' ) {

                        # more than ... ago
                        $GetParam{ $TimeType . 'TimeOlderMinutes' } = $Time;
                    }
                    elsif ( $GetParam{ $TimeType . 'TimePointStart' } eq 'Next' ) {

                        # within next
                        $GetParam{ $TimeType . 'TimeNewerMinutes' } = 0;
                        $GetParam{ $TimeType . 'TimeOlderMinutes' } = -$Time;
                    }
                    else {
                        # within last ...
                        $GetParam{ $TimeType . 'TimeOlderMinutes' } = 0;
                        $GetParam{ $TimeType . 'TimeNewerMinutes' } = $Time;
                    }
                }
            }
        }

        # prepare fulltext search
        if ( $GetParam{Fulltext} ) {
            $GetParam{ContentSearch} = 'OR';
            $GetParam{What}          = $GetParam{Fulltext};
        }

        # get valid list
        my %ValidList   = $Self->{ValidObject}->ValidList();
        my @AllValidIDs = keys %ValidList;

        # prepare search states
        my $SearchStates;
        if ( !IsArrayRefWithData( $GetParam{StateIDs} ) ) {
            $SearchStates = $Self->{InterfaceStates};
        }
        else {
            STATETYPEID:
            for my $StateTypeID ( @{ $GetParam{StateIDs} } ) {
                next STATETYPEID if !$StateTypeID;
                next STATETYPEID if !$Self->{InterfaceStates}->{$StateTypeID};
                $SearchStates->{$StateTypeID} = $Self->{InterfaceStates}->{$StateTypeID};
            }
        }

        if ( IsNumber( $GetParam{VoteSearch} ) ) {
            $GetParam{Votes} = {
                $GetParam{VoteSearchType} => $GetParam{VoteSearch}
            };
        }

        if ( IsNumber( $GetParam{RateSearch} ) ) {
            $GetParam{Rate} = {
                $GetParam{RateSearchType} => $GetParam{RateSearch}
            };
        }

        # perform FAQ search
        # default search on all valid ids, this can be overwritten by %GetParam
        my @ViewableFAQIDs = $Self->{FAQObject}->FAQSearch(
            OrderBy             => [ $Self->{SortBy} ],
            OrderByDirection    => [ $Self->{OrderBy} ],
            Limit               => $Self->{SearchLimit},
            UserID              => $Self->{UserID},
            States              => $SearchStates,
            Interface           => $Self->{Interface},
            ContentSearchPrefix => '*',
            ContentSearchSuffix => '*',
            ValidIDs            => \@AllValidIDs,
            %GetParam,
        );

        # CSV output
        if ( $GetParam{ResultForm} eq 'CSV' ) {
            my @CSVHead;
            my @CSVData;

            for my $FAQID (@ViewableFAQIDs) {

                # get FAQ data details
                my %FAQData = $Self->{FAQObject}->FAQGet(
                    ItemID     => $FAQID,
                    ItemFields => 0,
                    UserID     => $Self->{UserID},
                );

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

                # inssert data
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

            my @PDFData;
            for my $FAQID (@ViewableFAQIDs) {

                # get FAQ data details
                my %FAQData = $Self->{FAQObject}->FAQGet(
                    ItemID     => $FAQID,
                    ItemFields => 0,
                    UserID     => $Self->{UserID},
                );

                # create PDFObject
                use Kernel::System::PDF;
                $Self->{PDFObject} = Kernel::System::PDF->new( %{$Self} );

                # set change date to long format
                if ( $Self->{PDFObject} ) {
                    my $Changed = $Self->{LayoutObject}->Output(
                        Template => '$TimeLong{"$Data{"Changed"}"}',
                        Data     => \%FAQData,
                    );

                    # create PDF Rows
                    my @PDFRow;
                    push @PDFRow, $FAQData{Number};
                    push @PDFRow, $FAQData{Title};
                    push @PDFRow, $FAQData{CategoryName};

                    # create language row
                    if ( $Self->{MultiLanguage} ) {
                        push @PDFRow, $FAQData{Language};
                    }

                    push @PDFRow,  $FAQData{State};
                    push @PDFRow,  $Changed;
                    push @PDFData, \@PDFRow;
                }
                else {

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
            }

            # PDF Output
            if ( $Self->{PDFObject} ) {
                my $Title = $Self->{LayoutObject}->{LanguageObject}->Get('FAQ') . ' '
                    . $Self->{LayoutObject}->{LanguageObject}->Get('Search');
                my $PrintedBy = $Self->{LayoutObject}->{LanguageObject}->Get('printed by');
                my $Page      = $Self->{LayoutObject}->{LanguageObject}->Get('Page');
                my $Time      = $Self->{LayoutObject}->Output( Template => '$Env{"Time"}' );
                my $Url       = '';
                if ( $ENV{REQUEST_URI} ) {
                    $Url
                        = $Self->{ConfigObject}->Get('HttpType') . '://'
                        . $Self->{ConfigObject}->Get('FQDN')
                        . $ENV{REQUEST_URI};
                }

                # get maximum number of pages
                my $MaxPages = $Self->{ConfigObject}->Get('PDF::MaxPages');
                if ( !$MaxPages || $MaxPages < 1 || $MaxPages > 1000 ) {
                    $MaxPages = 100;
                }

                # create the header
                my $CellData;
                $CellData->[0]->[0]->{Content} = $Self->{ConfigObject}->Get('FAQ::FAQHook');
                $CellData->[0]->[0]->{Font}    = 'ProportionalBold';
                $CellData->[0]->[1]->{Content}
                    = $Self->{LayoutObject}->{LanguageObject}->Get('Title');
                $CellData->[0]->[1]->{Font} = 'ProportionalBold';
                $CellData->[0]->[2]->{Content}
                    = $Self->{LayoutObject}->{LanguageObject}->Get('Category');
                $CellData->[0]->[2]->{Font} = 'ProportionalBold';

                # store the correct header index
                my $NextHeaderIndex = 3;

                # add language header
                if ( $Self->{MultiLanguage} ) {
                    $CellData->[0]->[3]->{Content}
                        = $Self->{LayoutObject}->{LanguageObject}->Get('Language');
                    $CellData->[0]->[3]->{Font} = 'ProportionalBold';
                    $NextHeaderIndex = 4;
                }

                $CellData->[0]->[$NextHeaderIndex]->{Content}
                    = $Self->{LayoutObject}->{LanguageObject}->Get('State');
                $CellData->[0]->[$NextHeaderIndex]->{Font} = 'ProportionalBold';

                $CellData->[0]->[ $NextHeaderIndex + 1 ]->{Content}
                    = $Self->{LayoutObject}->{LanguageObject}->Get('Changed');
                $CellData->[0]->[ $NextHeaderIndex + 1 ]->{Font} = 'ProportionalBold';

                # create the content array
                my $CounterRow = 1;
                for my $Row (@PDFData) {
                    my $CounterColumn = 0;
                    for my $Content ( @{$Row} ) {
                        $CellData->[$CounterRow]->[$CounterColumn]->{Content} = $Content;
                        $CounterColumn++;
                    }
                    $CounterRow++;
                }

                # output 'No Result', if no content was given
                if ( !$CellData->[0]->[0] ) {
                    $CellData->[0]->[0]->{Content}
                        = $Self->{LayoutObject}->{LanguageObject}->Get('No Result!');
                }

                # page params
                my %PageParam;
                $PageParam{PageOrientation} = 'landscape';
                $PageParam{MarginTop}       = 30;
                $PageParam{MarginRight}     = 40;
                $PageParam{MarginBottom}    = 40;
                $PageParam{MarginLeft}      = 40;
                $PageParam{HeaderRight}     = $Title;
                $PageParam{FooterLeft}      = $Url;
                $PageParam{HeadlineLeft}    = $Title;
                $PageParam{HeadlineRight}   = $PrintedBy . ' '
                    . $Self->{UserFirstname} . ' '
                    . $Self->{UserLastname} . ' ('
                    . $Self->{UserEmail} . ') '
                    . $Time;

                # table params
                my %TableParam;
                $TableParam{CellData}            = $CellData;
                $TableParam{Type}                = 'Cut';
                $TableParam{FontSize}            = 6;
                $TableParam{Border}              = 0;
                $TableParam{BackgroundColorEven} = '#AAAAAA';
                $TableParam{BackgroundColorOdd}  = '#DDDDDD';
                $TableParam{Padding}             = 1;
                $TableParam{PaddingTop}          = 3;
                $TableParam{PaddingBottom}       = 3;

                # create new pdf document
                $Self->{PDFObject}->DocumentNew(
                    Title  => $Self->{ConfigObject}->Get('Product') . ': ' . $Title,
                    Encode => $Self->{LayoutObject}->{UserCharset},
                );

                # start table output
                $Self->{PDFObject}->PageNew( %PageParam, FooterRight => $Page . ' 1', );
                for ( 2 .. $MaxPages ) {

                    # output table (or a fragment of it)
                    %TableParam = $Self->{PDFObject}->Table( %TableParam, );

                    # stop output or another page
                    if ( $TableParam{State} ) {
                        last;
                    }
                    else {
                        $Self->{PDFObject}->PageNew( %PageParam, FooterRight => $Page . ' ' . $_, );
                    }
                }

                # return the pdf document
                my $Filename = 'FAQ_search';
                my ( $s, $m, $h, $D, $M, $Y )
                    = $Self->{TimeObject}->SystemTime2Date(
                    SystemTime => $Self->{TimeObject}->SystemTime(),
                    );
                $M = sprintf( "%02d", $M );
                $D = sprintf( "%02d", $D );
                $h = sprintf( "%02d", $h );
                $m = sprintf( "%02d", $m );
                my $PDFString = $Self->{PDFObject}->DocumentOutput();
                return $Self->{LayoutObject}->Attachment(
                    Filename    => $Filename . "_" . "$Y-$M-$D" . "_" . "$h-$m.pdf",
                    ContentType => "application/pdf",
                    Content     => $PDFString,
                    Type        => 'attachment',
                );
            }
            else {
                $Output = $Self->{LayoutObject}->PrintHeader( Width => 800 );
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
                    TemplateFile => 'AgentFAQSearchResultPrint',
                    Data         => \%Param,
                );

                # add footer
                $Output .= $Self->{LayoutObject}->PrintFooter();

                # return output
                return $Output;
            }
        }
        else {

            # start html page
            my $Output = $Self->{LayoutObject}->Header();
            $Output .= $Self->{LayoutObject}->NavigationBar();
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
                . ';';
            my $LinkSort = 'Filter='
                . $Self->{LayoutObject}->LinkEncode( $Self->{Filter} )
                . ';View=' . $Self->{LayoutObject}->LinkEncode( $Self->{View} )
                . ';Profile=' . $Self->{Profile} . ';TakeLastSearch=1;Subaction=Search'
                . ';';
            my $LinkFilter = 'TakeLastSearch=1;Subaction=Search;Profile='
                . $Self->{LayoutObject}->LinkEncode( $Self->{Profile} )
                . ';';
            my $LinkBack = 'Subaction=LoadProfile;Profile='
                . $Self->{LayoutObject}->LinkEncode( $Self->{Profile} )
                . ';TakeLastSearch=1;';

            my $FilterLink
                = 'SortBy=' . $Self->{LayoutObject}->LinkEncode( $Self->{SortBy} )
                . ';OrderBy=' . $Self->{LayoutObject}->LinkEncode( $Self->{OrderBy} )
                . ';View=' . $Self->{LayoutObject}->LinkEncode( $Self->{View} )
                . ';Profile=' . $Self->{Profile} . ';TakeLastSearch=1;Subaction=Search'
                . ';';

            # find out which columns should be shown
            my @ShowColumns;
            if ( $Self->{Config}->{ShowColumns} ) {

                # get all possible columns from config
                my %PossibleColumn = %{ $Self->{Config}->{ShowColumns} };

                # get the column names that should be shown
                COLUMNNAME:
                for my $Name ( sort keys %PossibleColumn ) {
                    next COLUMNNAME if !$PossibleColumn{$Name};
                    push @ShowColumns, $Name;
                }

                # enforce FAQ number column since is the link MasterAction hook
                if ( !$PossibleColumn{'Number'} ) {
                    push @ShowColumns, 'Number';
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
            );

            # build footer
            $Output .= $Self->{LayoutObject}->Footer();
            return $Output;
        }
    }

    elsif ( $Self->{Subaction} eq 'AJAXProfileDelete' ) {
        my $Profile = $Self->{ParamObject}->GetParam( Param => 'Profile' );

        # remove old profile stuff
        $Self->{SearchProfileObject}->SearchProfileDelete(
            Base      => 'FAQSearch',
            Name      => $Profile,
            UserLogin => $Self->{UserLogin},
        );
        my $Output = $Self->{LayoutObject}->JSONEncode(
            Data => 1,
        );
        return $Self->{LayoutObject}->Attachment(
            NoCache     => 1,
            ContentType => 'text/html',
            Content     => $Output,
            Type        => 'inline',
        );
    }

    elsif ( $Self->{Subaction} eq 'AJAX' ) {

        # create output
        my $Output .= $Self->_MaskForm(
            %GetParam,
        );

        return $Self->{LayoutObject}->Attachment(
            NoCache     => 1,
            ContentType => 'text/html',
            Charset     => $Self->{LayoutObject}->{UserCharset},
            Content     => $Output,
            Type        => 'inline',
        );
    }

    # show default search screen
    $Output = $Self->{LayoutObject}->Header();
    $Output .= $Self->{LayoutObject}->NavigationBar();
    $Self->{LayoutObject}->Block(
        Name => 'Search',
        Data => \%Param,
    );
    $Output .= $Self->{LayoutObject}->Output(
        TemplateFile => 'AgentFAQSearch',
        Data         => \%Param,
    );
    $Output .= $Self->{LayoutObject}->Footer();
    return $Output;

}

sub _MaskForm {
    my ( $Self, %Param ) = @_;

    # get list type
    my $TreeView = 0;
    if ( $Self->{ConfigObject}->Get('Ticket::Frontend::ListType') eq 'tree' ) {
        $TreeView = 1;
    }

    my $Profile = $Self->{Profile};
    my $EmptySearch = $Self->{ParamObject}->GetParam( Param => 'EmptySearch' );
    if ( !$Profile ) {
        $EmptySearch = 1;
    }

    my %GetParam = $Self->{SearchProfileObject}->SearchProfileGet(
        Base      => 'FAQSearch',
        Name      => $Profile,
        UserLogin => $Self->{UserLogin},
    );

    # if no profile is used, set default params of default attributes
    if ( !$Profile ) {
        if ( $Self->{Config}->{Defaults} ) {
            ATTRIBUTE:
            for my $Attribute ( sort keys %{ $Self->{Config}->{Defaults} } ) {
                next ATTRIBUTE if !$Self->{Config}->{Defaults}->{$Attribute};
                $GetParam{$Attribute} = $Self->{Config}->{Defaults}->{$Attribute};
            }
        }
    }

    # set attributes string
    my @Attributes = (
        {
            Key   => 'Number',
            Value => 'FAQ Number',
        },
        {
            Key   => 'Fulltext',
            Value => 'Fulltext',
        },
        {
            Key   => 'Title',
            Value => 'Title',
        },
        {
            Key   => 'Keyword',
            Value => 'Keyword',
        },
    );

    # show Languages attribute
    if ( $Self->{MultiLanguage} ) {
        push @Attributes, (
            {
                Key   => 'LanguageIDs',
                Value => 'Language',
            },
        );
    }

    push @Attributes, (
        {
            Key   => 'CategoryIDs',
            Value => 'Category',
        },
        {
            Key   => 'ValidIDs',
            Value => 'Validity',
        },
        {
            Key   => 'StateIDs',
            Value => 'State',
        },
        {
            Key   => 'VoteSearchType',
            Value => 'Votes',
        },
        {
            Key   => 'RateSearchType',
            Value => 'Rate',
        },
        {
            Key   => 'ApprovedSearch',
            Value => 'Approved',
        },
        {
            Key   => 'CreatedUserIDs',
            Value => 'Created by',
        },
        {
            Key   => 'LastChangedUserIDs',
            Value => 'Last Changed by',
        },
        {
            Key   => 'ItemCreateTimePoint',
            Value => 'FAQ Item Create Time (before/after)',
        },
        {
            Key   => 'ItemCreateTimeSlot',
            Value => 'FAQ Item Create Time (between)',
        },
        {
            Key   => 'ItemChangeTimePoint',
            Value => 'FAQ Item Change Time (before/after)',
        },
        {
            Key   => 'ItemChangeTimeSlot',
            Value => 'FAQ Item Change Time (between)',
        },
    );

    # dropdown menu for 'attributes'
    $Param{AttributesStrg} = $Self->{LayoutObject}->BuildSelection(
        Data     => \@Attributes,
        Name     => 'Attribute',
        Multiple => 0,
    );
    $Param{AttributesOrigStrg} = $Self->{LayoutObject}->BuildSelection(
        Data     => \@Attributes,
        Name     => 'AttributeOrig',
        Multiple => 0,
    );

    # get languages list
    my %Languages = $Self->{FAQObject}->LanguageList(
        UserID => $Self->{UserID},
    );

    # dropdown menu for 'languages'
    $Param{LanguagesSelectionStrg} = $Self->{LayoutObject}->BuildSelection(
        Data       => \%Languages,
        Name       => 'LanguageIDs',
        Size       => 5,
        Multiple   => 1,
        SelectedID => $GetParam{LanguageIDs} || [],
    );

    # get categories (with category long names) where user has rights
    my $UserCategoriesLongNames = $Self->{FAQObject}->GetUserCategoriesLongNames(
        Type   => 'rw',
        UserID => $Self->{UserID},
    );

    # build the category selection
    $Param{CategoriesSelectionStrg} = $Self->{LayoutObject}->BuildSelection(
        Data        => $UserCategoriesLongNames,
        Name        => 'CategoryIDs',
        SelectedID  => $GetParam{CategoryIDs} || [],
        Size        => 5,
        Translation => 0,
        Multiple    => 1,
        TreeView    => $TreeView,
    );

    # get valid list
    my %ValidList = $Self->{ValidObject}->ValidList();

    # build the valid selection
    $Param{ValidSelectionStrg} = $Self->{LayoutObject}->BuildSelection(
        Data        => \%ValidList,
        Name        => 'ValidIDs',
        SelectedID  => $GetParam{ValidIDs} || [],
        Size        => 5,
        Translation => 0,
        Multiple    => 1,
    );

    # create a mix of state and state types hash in order to have the state type IDs with state
    # names
    my %StateList = $Self->{FAQObject}->StateList(
        UserID => $Self->{UserID},
    );

    my %States;
    for my $StateID ( sort keys %StateList ) {
        my %StateData = $Self->{FAQObject}->StateGet(
            StateID => $StateID,
            UserID  => $Self->{UserID},
        );
        $States{ $StateData{TypeID} } = $StateData{Name}
    }

    $Param{StateSelectionStrg} = $Self->{LayoutObject}->BuildSelection(
        Data        => \%States,
        Name        => 'StateIDs',
        SelectedID  => $GetParam{StateIDs} || [],
        Size        => 3,
        Translation => 1,
        Multiple    => 1,
    );

    my %VotingOperators = (
        Equals            => 'Equals',
        GreaterThan       => 'GreaterThan',
        GreaterThanEquals => 'GreaterThanEquals',
        SmallerThan       => 'SmallerThan',
        SmallerThanEquals => 'SmallerThanEquals',
    );

    $Param{VoteSearchTypeSelectionStrg} = $Self->{LayoutObject}->BuildSelection(
        Data        => \%VotingOperators,
        Name        => 'VoteSearchType',
        SelectedID  => $GetParam{VoteSearchType} || '',
        Size        => 1,
        Translation => 1,
        Multiple    => 0,
    );

    $Param{RateSearchTypeSelectionStrg} = $Self->{LayoutObject}->BuildSelection(
        Data        => \%VotingOperators,
        Name        => 'RateSearchType',
        SelectedID  => $GetParam{RateSearchType} || '',
        Size        => 1,
        Translation => 1,
        Multiple    => 0,
    );
    $Param{RateSearchSelectionStrg} = $Self->{LayoutObject}->BuildSelection(
        Data => {
            0   => '0%',
            25  => '25%',
            50  => '50%',
            75  => '75%',
            100 => '100%',
        },
        Sort        => 'NumericKey',
        Name        => 'RateSearch',
        SelectedID  => $GetParam{RateSearch} || '',
        Size        => 1,
        Translation => 0,
        Multiple    => 0,
    );

    $Param{ApprovedStrg} = $Self->{LayoutObject}->BuildSelection(
        Data => {
            No  => 'No',
            Yes => 'Yes',
        },
        Name        => 'ApprovedSearch',
        SelectedID  => $GetParam{ApprovedSearch} || 'Yes',
        Multiple    => 0,
        Translation => 1,
    );

    # get a list of all users to display
    my %ShownUsers = $Self->{UserObject}->UserList(
        Type  => 'Long',
        Valid => 1,
    );

    # get the UserIDs from faq and faq_admin members
    my %GroupUsers;
    for my $Group (qw(faq faq_admin)) {
        my $GroupID = $Self->{GroupObject}->GroupLookup( Group => $Group );
        my %Users = $Self->{GroupObject}->GroupMemberList(
            GroupID => $GroupID,
            Type    => 'rw',
            Result  => 'HASH',
        );
        %GroupUsers = ( %GroupUsers, %Users );
    }

    # remove all users that are not in the faq or faq_admin groups
    for my $UserID ( sort keys %ShownUsers ) {
        if ( !$GroupUsers{$UserID} ) {
            delete $ShownUsers{$UserID};
        }
    }
    $Param{CreatedUserStrg} = $Self->{LayoutObject}->BuildSelection(
        Data       => \%ShownUsers,
        Name       => 'CreatedUserIDs',
        Multiple   => 1,
        Size       => 5,
        SelectedID => $GetParam{CreatedUserIDs},
    );
    $Param{LastChangedUserStrg} = $Self->{LayoutObject}->BuildSelection(
        Data       => \%ShownUsers,
        Name       => 'LastChangedUserIDs',
        Multiple   => 1,
        Size       => 5,
        SelectedID => $GetParam{LastChangedUserIDs},
    );

    $Param{ItemCreateTimePointStrg} = $Self->{LayoutObject}->BuildSelection(
        Data       => [ 1 .. 59 ],
        Name       => 'ItemCreateTimePoint',
        SelectedID => $GetParam{ItemCreateTimePoint},
    );
    $Param{ItemCreateTimePointStartStrg} = $Self->{LayoutObject}->BuildSelection(
        Data => {
            'Last'   => 'within the last ...',
            'Before' => 'more than ... ago',
        },
        Name => 'ItemCreateTimePointStart',
        SelectedID => $GetParam{ItemCreateTimePointStart} || 'Last',
    );
    $Param{ItemCreateTimePointFormatStrg} = $Self->{LayoutObject}->BuildSelection(
        Data => {
            minute => 'minute(s)',
            hour   => 'hour(s)',
            day    => 'day(s)',
            week   => 'week(s)',
            month  => 'month(s)',
            year   => 'year(s)',
        },
        Name       => 'ItemCreateTimePointFormat',
        SelectedID => $GetParam{ItemCreateTimePointFormat},
    );
    $Param{ItemCreateTimeStartStrg} = $Self->{LayoutObject}->BuildDateSelection(
        %GetParam,
        Prefix   => 'ItemCreateTimeStart',
        Format   => 'DateInputFormat',
        DiffTime => -( ( 60 * 60 * 24 ) * 30 ),
    );
    $Param{ItemCreateTimeStopStrg} = $Self->{LayoutObject}->BuildDateSelection(
        %GetParam,
        Prefix => 'ItemCreateTimeStop',
        Format => 'DateInputFormat',
    );

    $Param{ItemChangeTimePointStrg} = $Self->{LayoutObject}->BuildSelection(
        Data       => [ 1 .. 59 ],
        Name       => 'ItemChangeTimePoint',
        SelectedID => $GetParam{ItemChangeTimePoint},
    );
    $Param{ItemChangeTimePointStartStrg} = $Self->{LayoutObject}->BuildSelection(
        Data => {
            'Last'   => 'within the last ...',
            'Before' => 'more than ... ago',
        },
        Name => 'ItemChangeTimePointStart',
        SelectedID => $GetParam{ItemChangeTimePointStart} || 'Last',
    );
    $Param{ItemChangeTimePointFormatStrg} = $Self->{LayoutObject}->BuildSelection(
        Data => {
            minute => 'minute(s)',
            hour   => 'hour(s)',
            day    => 'day(s)',
            week   => 'week(s)',
            month  => 'month(s)',
            year   => 'year(s)',
        },
        Name       => 'ItemChangeTimePointFormat',
        SelectedID => $GetParam{ItemChangeTimePointFormat},
    );
    $Param{ItemChangeTimeStartStrg} = $Self->{LayoutObject}->BuildDateSelection(
        %GetParam,
        Prefix   => 'ItemChangeTimeStart',
        Format   => 'DateInputFormat',
        DiffTime => -( ( 60 * 60 * 24 ) * 30 ),
    );
    $Param{ItemChangeTimeStopStrg} = $Self->{LayoutObject}->BuildDateSelection(
        %GetParam,
        Prefix => 'ItemChangeTimeStop',
        Format => 'DateInputFormat',
    );

    my %Profiles = $Self->{SearchProfileObject}->SearchProfileList(
        Base      => 'FAQSearch',
        UserLogin => $Self->{UserLogin},
    );
    delete $Profiles{''};
    delete $Profiles{'last-search'};
    if ($EmptySearch) {
        $Profiles{''} = '-';
    }
    else {
        $Profiles{'last-search'} = '-';
    }
    $Param{ProfilesStrg} = $Self->{LayoutObject}->BuildSelection(
        Data       => \%Profiles,
        Name       => 'Profile',
        ID         => 'SearchProfile',
        SelectedID => $Profile,
    );

    $Param{ResultFormStrg} = $Self->{LayoutObject}->BuildSelection(
        Data => {
            Normal => 'Normal',
            Print  => 'Print',
            CSV    => 'CSV',
        },
        Name => 'ResultForm',
        SelectedID => $GetParam{ResultForm} || 'Normal',
    );

    # html search mask output
    $Self->{LayoutObject}->Block(
        Name => 'SearchAJAX',
        Data => {
            %Param,
            %GetParam,
            EmptySearch => $EmptySearch,
        },
    );

    # show attributes
    my %AlreadyShown;
    ITEM:
    for my $Item (@Attributes) {
        my $Key = $Item->{Key};
        next ITEM if !$Key;
        next ITEM if !defined $GetParam{$Key};
        next ITEM if $GetParam{$Key} eq '';

        next ITEM if $AlreadyShown{$Key};
        $AlreadyShown{$Key} = 1;
        $Self->{LayoutObject}->Block(
            Name => 'SearchAJAXShow',
            Data => {
                Attribute => $Key,
            },
        );
    }

    # if no attribute is shown, show fulltext search
    if ( !$Profile ) {
        if ( $Self->{Config}->{Defaults} ) {
            KEY:
            for my $Key ( sort keys %{ $Self->{Config}->{Defaults} } ) {
                next KEY if $AlreadyShown{$Key};
                $AlreadyShown{$Key} = 1;
                $Self->{LayoutObject}->Block(
                    Name => 'SearchAJAXShow',
                    Data => {
                        Attribute => $Key,
                    },
                );
            }
        }
        else {
            $Self->{LayoutObject}->Block(
                Name => 'SearchAJAXShow',
                Data => {
                    Attribute => 'Fulltext',
                },
            );
        }
    }

    # build output
    my $Output = $Self->{LayoutObject}->Output(
        TemplateFile => 'AgentFAQSearch',
        Data         => {%Param},
    );

    return $Output;
}

1;
