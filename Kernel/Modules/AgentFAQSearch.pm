# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Modules::AgentFAQSearch;

use strict;
use warnings;

use Kernel::Language qw(Translatable);
use Kernel::System::VariableCheck qw(:all);

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;

    # Allocate new hash for object.
    my $Self = {%Param};
    bless( $Self, $Type );

    # Get config for frontend.
    $Self->{Config} = $Kernel::OM->Get('Kernel::Config')->Get("FAQ::Frontend::$Self->{Action}");

    # Get the dynamic fields for FAQ object.
    $Self->{DynamicField} = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldListGet(
        Valid       => 1,
        ObjectType  => 'FAQ',
        FieldFilter => $Self->{Config}->{DynamicField} || {},
    );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $Output;

    my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');

    # Get config from constructor.
    my $Config = $Self->{Config};

    # Get config data.
    my $StartHit    = int( $ParamObject->GetParam( Param => 'StartHit' ) || 1 );
    my $SearchLimit = $Config->{SearchLimit} || 500;
    my $SortBy      = $ParamObject->GetParam( Param => 'SortBy' )
        || $Config->{'SortBy::Default'}
        || 'FAQID';
    my $OrderBy = $ParamObject->GetParam( Param => 'OrderBy' )
        || $Config->{'Order::Default'}
        || 'Down';
    my $Profile        = $ParamObject->GetParam( Param => 'Profile' )        || '';
    my $SaveProfile    = $ParamObject->GetParam( Param => 'SaveProfile' )    || '';
    my $TakeLastSearch = $ParamObject->GetParam( Param => 'TakeLastSearch' ) || '';
    my $EraseTemplate  = $ParamObject->GetParam( Param => 'EraseTemplate' )  || '';

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # Build output for open search description by FAQ number.
    if ( $Self->{Subaction} eq 'OpenSearchDescriptionFAQNumber' ) {
        my $Output = $LayoutObject->Output(
            TemplateFile => 'AgentFAQSearchOpenSearchDescriptionFAQNumber',
            Data         => \%Param,
        );
        return $LayoutObject->Attachment(
            Filename    => 'OpenSearchDescriptionFAQNumber.xml',
            ContentType => 'application/opensearchdescription+xml',
            Content     => $Output,
            Type        => 'inline',
        );
    }

    # Build output for open search description by full-text.
    if ( $Self->{Subaction} eq 'OpenSearchDescriptionFulltext' ) {
        my $Output = $LayoutObject->Output(
            TemplateFile => 'AgentFAQSearchOpenSearchDescriptionFulltext',
            Data         => \%Param,
        );
        return $LayoutObject->Attachment(
            Filename    => 'OpenSearchDescriptionFulltext.xml',
            ContentType => 'application/opensearchdescription+xml',
            Content     => $Output,
            Type        => 'inline',
        );
    }

    # Search with a saved template.
    if ( $ParamObject->GetParam( Param => 'SearchTemplate' ) && $Profile ) {
        return $LayoutObject->Redirect(
            OP =>
                "Action=AgentFAQSearch;Subaction=Search;TakeLastSearch=1;SaveProfile=1;Profile=$Profile",
        );
    }

    my %GetParam;

    my $DynamicFieldBackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');
    my $SearchProfileObject       = $Kernel::OM->Get('Kernel::System::SearchProfile');

    # Load profiles string params (press load profile).
    if ( ( $Self->{Subaction} eq 'LoadProfile' && $Profile ) || $TakeLastSearch ) {
        %GetParam = $SearchProfileObject->SearchProfileGet(
            Base      => 'FAQSearch',
            Name      => $Profile,
            UserLogin => $Self->{UserLogin},
        );
    }

    # Get search string params (get submitted params).
    else {

        # Get scalar search parameters from web request.
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
            $GetParam{$ParamName} = $ParamObject->GetParam( Param => $ParamName );

            # Remove whitespace on the start and end.
            if ( $GetParam{$ParamName} ) {
                $GetParam{$ParamName} =~ s{ \A \s+ }{}xms;
                $GetParam{$ParamName} =~ s{ \s+ \z }{}xms;
            }
        }

        # Get array search parameters from web request.
        for my $SearchParam (
            qw(CategoryIDs LanguageIDs ValidIDs StateIDs CreatedUserIDs LastChangedUserIDs)
            )
        {
            my @Array = $ParamObject->GetArray( Param => $SearchParam );
            if (@Array) {
                $GetParam{$SearchParam} = \@Array;
            }
        }

        # Get Dynamic fields from param object.
        DYNAMICFIELD:
        for my $DynamicFieldConfig ( @{ $Self->{DynamicField} } ) {
            next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

            # Get search field preferences.
            my $SearchFieldPreferences = $DynamicFieldBackendObject->SearchFieldPreferences(
                DynamicFieldConfig => $DynamicFieldConfig,
            );

            next DYNAMICFIELD if !IsArrayRefWithData($SearchFieldPreferences);

            PREFERENCE:
            for my $Preference ( @{$SearchFieldPreferences} ) {

                # Extract the dynamic field value from the web request.
                my $DynamicFieldValue = $DynamicFieldBackendObject->SearchFieldValueGet(
                    DynamicFieldConfig     => $DynamicFieldConfig,
                    ParamObject            => $ParamObject,
                    ReturnProfileStructure => 1,
                    LayoutObject           => $LayoutObject,
                    Type                   => $Preference->{Type},
                );

                # Set the complete value structure in GetParam to store it later in the search profile.
                if ( IsHashRefWithData($DynamicFieldValue) ) {
                    %GetParam = ( %GetParam, %{$DynamicFieldValue} );
                }
            }
        }
    }

    # Get approved option.
    if ( $GetParam{ApprovedSearch} && $GetParam{ApprovedSearch} eq 'Yes' ) {
        $GetParam{Approved} = 1;
    }
    elsif ( $GetParam{ApprovedSearch} && $GetParam{ApprovedSearch} eq 'No' ) {
        $GetParam{Approved} = 0;
    }

    # Get create time option.
    if ( !$GetParam{TimeSearchType} ) {
        $GetParam{'TimeSearchType::None'} = 1;
    }
    elsif ( $GetParam{TimeSearchType} eq 'TimePoint' ) {
        $GetParam{'TimeSearchType::TimePoint'} = 1;
    }
    elsif ( $GetParam{TimeSearchType} eq 'TimeSlot' ) {
        $GetParam{'TimeSearchType::TimeSlot'} = 1;
    }

    # Get change time option.
    if ( !$GetParam{ChangeTimeSearchType} ) {
        $GetParam{'ChangeTimeSearchType::None'} = 1;
    }
    elsif ( $GetParam{ChangeTimeSearchType} eq 'TimePoint' ) {
        $GetParam{'ChangeTimeSearchType::TimePoint'} = 1;
    }
    elsif ( $GetParam{ChangeTimeSearchType} eq 'TimeSlot' ) {
        $GetParam{'ChangeTimeSearchType::TimeSlot'} = 1;
    }

    # Set result form ENV.
    if ( !$GetParam{ResultForm} ) {
        $GetParam{ResultForm} = '';
    }

    my $FAQObject = $Kernel::OM->Get('Kernel::System::FAQ');

    # Show result site.
    if ( $Self->{Subaction} eq 'Search' && !$EraseTemplate ) {

        # Fill up profile name (e.g. with last-search).
        if ( !$Profile || !$SaveProfile ) {
            $Profile = 'last-search';
        }

        my $SessionObject = $Kernel::OM->Get('Kernel::System::AuthSession');

        # Store last overview screen.
        my $URL = "Action=AgentFAQSearch;Subaction=Search"
            . ";Profile=" . $LayoutObject->LinkEncode($Profile)
            . ";SortBy=" . $LayoutObject->LinkEncode($SortBy)
            . ";OrderBy=" . $LayoutObject->LinkEncode($OrderBy)
            . ";TakeLastSearch=1"
            . ";StartHit=" . $LayoutObject->LinkEncode($StartHit);

        $SessionObject->UpdateSessionID(
            SessionID => $Self->{SessionID},
            Key       => 'LastScreenOverview',
            Value     => $URL,
        );
        $SessionObject->UpdateSessionID(
            SessionID => $Self->{SessionID},
            Key       => 'LastScreenView',
            Value     => $URL,
        );

        # Save search profile (under last-search or real profile name).
        $SaveProfile = 1;

        # Remember last search values.
        if ( $SaveProfile && $Profile ) {

            # Remove old profile stuff.
            $SearchProfileObject->SearchProfileDelete(
                Base      => 'FAQSearch',
                Name      => $Profile,
                UserLogin => $Self->{UserLogin},
            );

            # Insert new profile parameters.
            for my $Key ( sort keys %GetParam ) {
                if ( $GetParam{$Key} ) {
                    $SearchProfileObject->SearchProfileAdd(
                        Base      => 'FAQSearch',
                        Name      => $Profile,
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

            if ( !$GetParam{ $TimeMap{$TimeType} . 'SearchType' } ) {

                # Do nothing with time stuff
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
                    $GetParam{ $TimeType . 'TimeNewerDate' } = $GetParam{ $TimeType . 'TimeStartYear' } . '-'
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
                    $GetParam{ $TimeType . 'TimeOlderDate' } = $GetParam{ $TimeType . 'TimeStopYear' } . '-'
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

                        # More than ... ago.
                        $GetParam{ $TimeType . 'TimeOlderMinutes' } = $Time;
                    }
                    elsif ( $GetParam{ $TimeType . 'TimePointStart' } eq 'Next' ) {

                        # Within next.
                        $GetParam{ $TimeType . 'TimeNewerMinutes' } = 0;
                        $GetParam{ $TimeType . 'TimeOlderMinutes' } = -$Time;
                    }
                    else {
                        # Within last ...
                        $GetParam{ $TimeType . 'TimeOlderMinutes' } = 0;
                        $GetParam{ $TimeType . 'TimeNewerMinutes' } = $Time;
                    }
                }
            }
        }

        # Dynamic fields search parameters for FAQ search.
        my %DynamicFieldSearchParameters;

        DYNAMICFIELD:
        for my $DynamicFieldConfig ( @{ $Self->{DynamicField} } ) {
            next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

            # Get search field preferences.
            my $SearchFieldPreferences = $DynamicFieldBackendObject->SearchFieldPreferences(
                DynamicFieldConfig => $DynamicFieldConfig,
            );

            next DYNAMICFIELD if !IsArrayRefWithData($SearchFieldPreferences);

            PREFERENCE:
            for my $Preference ( @{$SearchFieldPreferences} ) {

                my $DynamicFieldValue = $DynamicFieldBackendObject->SearchFieldValueGet(
                    DynamicFieldConfig     => $DynamicFieldConfig,
                    ParamObject            => $ParamObject,
                    Type                   => $Preference->{Type},
                    ReturnProfileStructure => 1,
                );

                # Set the complete value structure in %DynamicFieldValues to discard those where the
                #   value will not be possible to get.
                next PREFERENCE if !IsHashRefWithData($DynamicFieldValue);

                # Extract the dynamic field value from the profile.
                my $SearchParameter = $DynamicFieldBackendObject->SearchFieldParameterBuild(
                    DynamicFieldConfig => $DynamicFieldConfig,
                    Profile            => \%GetParam,
                    LayoutObject       => $LayoutObject,
                    Type               => $Preference->{Type},
                );

                # Set search parameter.
                if ( defined $SearchParameter ) {
                    $DynamicFieldSearchParameters{ 'DynamicField_' . $DynamicFieldConfig->{Name} }
                        = $SearchParameter->{Parameter};
                }
            }
        }

        # Prepare full-text search.
        if ( $GetParam{Fulltext} ) {
            $GetParam{ContentSearch} = 'OR';
            $GetParam{What}          = $GetParam{Fulltext};
        }

        my %ValidList   = $Kernel::OM->Get('Kernel::System::Valid')->ValidList();
        my @AllValidIDs = keys %ValidList;

        my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

        # Set default interface settings.
        my $Interface = $FAQObject->StateTypeGet(
            Name   => 'internal',
            UserID => $Self->{UserID},
        );
        my $InterfaceStates = $FAQObject->StateTypeList(
            Types  => $ConfigObject->Get('FAQ::Agent::StateTypes'),
            UserID => $Self->{UserID},
        );

        # Prepare search states.
        my $SearchStates;
        if ( !IsArrayRefWithData( $GetParam{StateIDs} ) ) {
            $SearchStates = $InterfaceStates;
        }
        else {
            STATETYPEID:
            for my $StateTypeID ( @{ $GetParam{StateIDs} } ) {
                next STATETYPEID if !$StateTypeID;
                next STATETYPEID if !$InterfaceStates->{$StateTypeID};
                $SearchStates->{$StateTypeID} = $InterfaceStates->{$StateTypeID};
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

        # Get UserCategoryGroup Hash.
        # This returns a Hash of the following sample data structure:
        #
        # $UserCatGroup = {
        #   '1' => {
        #          '3' => 'MiscSub'
        #        },
        #   '3' => {},
        #   '0' => {
        #            '1' => 'Misc',
        #            '2' => 'secret'
        #          },
        #   '2' => {}
        # };
        #
        # Keys of the outer hash inform about subcategories.
        #   0 Shows top level CategoryIDs.
        #   1 Shows the SubcategoryIDs of Category 1.
        #   2 and 3 are empty hashes because these categories don't have subcategories.
        #
        # Keys of the inner hashes are CategoryIDs a user is allowed to have ro access to.
        # Values are the Category names.

        my $UserCatGroup = $FAQObject->GetUserCategories(
            Type   => 'ro',
            UserID => $Self->{UserID},
        );

        # Find CategoryIDs the current User is allowed to view.
        my %AllowedCategoryIDs = ();

        if ( $UserCatGroup && ref $UserCatGroup eq 'HASH' ) {

            # So now we have to extract all Category ID's of the "inner hashes"
            #   -> Loop through the outer category ID's.
            for my $Level ( sort keys %{$UserCatGroup} ) {

                # Check if the Value of the current hash key is a hash ref.
                if ( $UserCatGroup->{$Level} && ref $UserCatGroup->{$Level} eq 'HASH' ) {

                    # Map the keys of the inner hash to a TempIDs hash.
                    # Original Data structure:
                    #   {
                    #       '1' => 'Misc',
                    #       '2' => 'secret'
                    #   }
                    #
                    #   after mapping:
                    #
                    #   {
                    #       '1' => 1,
                    #       '2' => 1'
                    #   }

                    my %TempIDs = map { $_ => 1 } keys %{ $UserCatGroup->{$Level} };

                    # Put the TempIDs over the formally found AllowedCategorys to produce a hash
                    #   that holds all CategoryID as keys and the number 1 as values.
                    %AllowedCategoryIDs = (
                        %AllowedCategoryIDs,
                        %TempIDs
                    );
                }
            }
        }

        # For the database query it's necessary to have an array of CategoryIDs.
        my @CategoryIDs = ();

        if (%AllowedCategoryIDs) {
            @CategoryIDs = sort keys %AllowedCategoryIDs;
        }

        # Categories got from the web request could include a not allowed category if the user
        #    temper with the categories drop-box, a check is needed.
        #
        # "Map" copy from one array to another, while "grep" will only let pass the categories
        #    that are defined in the %AllowedCategoryIDs hash.
        if ( IsArrayRefWithData( $GetParam{CategoryIDs} ) ) {
            @{ $GetParam{CategoryIDs} } = map {$_} grep { $AllowedCategoryIDs{$_} } @{ $GetParam{CategoryIDs} };
        }

        # Just search if we do have categories, we have access to.
        # If we don't have access to any category, a search with no CategoryIDs
        #   would result in finding all categories.
        #
        # It is not possible to create FAQ's without categories
        #   so at least one category has to be present

        my @ViewableItemIDs = ();

        if (@CategoryIDs) {

            # Perform FAQ search.
            # Default search on all valid ids, this can be overwritten by %GetParam.
            @ViewableItemIDs = $FAQObject->FAQSearch(
                OrderBy             => [$SortBy],
                OrderByDirection    => [$OrderBy],
                Limit               => $SearchLimit,
                UserID              => $Self->{UserID},
                States              => $SearchStates,
                Interface           => $Interface,
                ContentSearchPrefix => '*',
                ContentSearchSuffix => '*',
                ValidIDs            => \@AllValidIDs,
                CategoryIDs         => \@CategoryIDs,
                %GetParam,
                %DynamicFieldSearchParameters,
            );
        }

        my $MultiLanguage = $ConfigObject->Get('FAQ::MultiLanguage');

        # CSV and Excel output.
        if (
            $GetParam{ResultForm} eq 'CSV'
            || $GetParam{ResultForm} eq 'Excel'
            )
        {
            my @TmpCSVHead;
            my @CSVHead;
            my @CSVData;

            # Get the FAQ dynamic fields for CSV display.
            my $CSVDynamicField = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldListGet(
                Valid       => 1,
                ObjectType  => 'FAQ',
                FieldFilter => $Config->{SearchCSVDynamicField} || {},
            );

            for my $ItemID (@ViewableItemIDs) {

                # Get FAQ data details.
                my %FAQData = $FAQObject->FAQGet(
                    ItemID        => $ItemID,
                    ItemFields    => 0,
                    DynamicFields => 1,
                    UserID        => $Self->{UserID},
                );

                # Get info for CSV output.
                my %CSVInfo = (%FAQData);

                $CSVInfo{Changed} = $LayoutObject->{LanguageObject}->FormatTimeString(
                    $FAQData{Changed},
                    'DateFormat',
                );

                # CSV quote.
                if ( !@CSVHead ) {
                    @TmpCSVHead = qw( FAQNumber Title Category);
                    @CSVHead    = qw( FAQNumber Title Category);

                    # Insert language header.
                    if ($MultiLanguage) {
                        push @TmpCSVHead, 'Language';
                        push @CSVHead,    'Language';
                    }

                    push @TmpCSVHead, qw(State Changed);
                    push @CSVHead,    qw(State Changed);

                    # Include the selected dynamic fields on CVS results.
                    DYNAMICFIELD:
                    for my $DynamicFieldConfig ( @{$CSVDynamicField} ) {
                        next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);
                        next DYNAMICFIELD if !$DynamicFieldConfig->{Name};
                        next DYNAMICFIELD if $DynamicFieldConfig->{Name} eq '';

                        push @TmpCSVHead, 'DynamicField_' . $DynamicFieldConfig->{Name};
                        push @CSVHead,    $DynamicFieldConfig->{Label};
                    }
                }

                # Insert data.
                my @Data;
                for my $Header (@TmpCSVHead) {

                    # Check if header is a dynamic field and get the value from dynamic field backend
                    if ( $Header =~ m{\A DynamicField_ ( [a-zA-Z\d]+ ) \z}xms ) {

                        # Loop over the dynamic fields configured for CSV output.
                        DYNAMICFIELD:
                        for my $DynamicFieldConfig ( @{$CSVDynamicField} ) {
                            next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);
                            next DYNAMICFIELD if !$DynamicFieldConfig->{Name};

                            # Skip all fields that does not match with current field name ($1)
                            #   with out the 'DynamicField_' prefix.
                            next DYNAMICFIELD if $DynamicFieldConfig->{Name} ne $1;

                            # Get the value as for print (to correctly display).
                            my $ValueStrg = $DynamicFieldBackendObject->DisplayValueRender(
                                DynamicFieldConfig => $DynamicFieldConfig,
                                Value              => $CSVInfo{$Header},
                                HTMLOutput         => 0,
                                LayoutObject       => $LayoutObject,
                            );
                            push @Data, $ValueStrg->{Value};

                            last DYNAMICFIELD;
                        }
                    }

                    # Otherwise retrieve data from FAQ item.
                    else {
                        if ( $Header eq 'FAQNumber' ) {
                            push @Data, $CSVInfo{'Number'};
                        }
                        elsif ( $Header eq 'Category' ) {
                            push @Data, $CSVInfo{'CategoryName'};
                        }
                        else {
                            push @Data, $CSVInfo{$Header};
                        }
                    }
                }
                push @CSVData, \@Data;
            }

            # CSV quote.
            # Translate non existing header may result in a garbage file.
            if ( !@CSVHead ) {
                @TmpCSVHead = qw(FAQNumber Title Category);
                @CSVHead    = qw(FAQNumber Title Category);

                # Insert language header.
                if ($MultiLanguage) {
                    push @TmpCSVHead, 'Language';
                    push @CSVHead,    'Language';
                }

                push @TmpCSVHead, qw(State Changed);
                push @CSVHead,    qw(State Changed);

                # Include the selected dynamic fields on CVS results.
                DYNAMICFIELD:
                for my $DynamicFieldConfig ( @{$CSVDynamicField} ) {
                    next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);
                    next DYNAMICFIELD if !$DynamicFieldConfig->{Name};
                    next DYNAMICFIELD if $DynamicFieldConfig->{Name} eq '';

                    push @TmpCSVHead, 'DynamicField_' . $DynamicFieldConfig->{Name};
                    push @CSVHead,    $DynamicFieldConfig->{Label};
                }
            }

            # Get Separator from language file.
            my $UserCSVSeparator = $LayoutObject->{LanguageObject}->{Separator};

            if ( $ConfigObject->Get('PreferencesGroups')->{CSVSeparator}->{Active} ) {
                my %UserData = $Kernel::OM->Get('Kernel::System::User')->GetUserData(
                    UserID => $Self->{UserID},
                );
                if ( $UserData{UserCSVSeparator} ) {
                    $UserCSVSeparator = $UserData{UserCSVSeparator};
                }
            }

            # Translate headers.
            for my $Header (@CSVHead) {

                # Replace FAQNumber header with the current FAQHook from config.
                if ( $Header eq 'FAQNumber' ) {
                    $Header = $ConfigObject->Get('FAQ::FAQHook');
                }
                else {
                    $Header = $LayoutObject->{LanguageObject}->Translate($Header);
                }
            }

            # Return CSV to download.
            my $FileName = 'FAQ_search';

            my $DateTimeObject = $Kernel::OM->Create('Kernel::System::DateTime');
            my $DateTime       = $DateTimeObject->Get();
            my $Y              = $DateTime->{Year};
            my $M              = sprintf( "%02d", $DateTime->{Month} );
            my $D              = sprintf( "%02d", $DateTime->{Day} );
            my $h              = sprintf( "%02d", $DateTime->{Hour} );
            my $m              = sprintf( "%02d", $DateTime->{Minute} );

            my $CSVObject = $Kernel::OM->Get('Kernel::System::CSV');

            # Generate CSV output.
            if ( $GetParam{ResultForm} eq 'CSV' ) {

                my $CSV = $CSVObject->Array2CSV(
                    Head      => \@CSVHead,
                    Data      => \@CSVData,
                    Separator => $UserCSVSeparator,
                );

                # Return CSV to download,
                return $LayoutObject->Attachment(
                    Filename    => $FileName . "_" . "$Y-$M-$D" . "_" . "$h-$m.csv",
                    ContentType => "text/csv; charset=" . $LayoutObject->{UserCharset},
                    Content     => $CSV,
                );
            }

            # Generate Excel output.
            elsif ( $GetParam{ResultForm} eq 'Excel' ) {
                my $Excel = $CSVObject->Array2CSV(
                    Head   => \@CSVHead,
                    Data   => \@CSVData,
                    Format => 'Excel',
                );

                # Return Excel to download.
                return $LayoutObject->Attachment(
                    Filename => $FileName . "_" . "$Y-$M-$D" . "_" . "$h-$m.xlsx",
                    ContentType =>
                        "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
                    Content => $Excel,
                );
            }
        }
        elsif ( $GetParam{ResultForm} eq 'Print' ) {

            my $PDFObject = $Kernel::OM->Get('Kernel::System::PDF');

            my @PDFData;
            for my $ItemID (@ViewableItemIDs) {

                my %FAQData = $FAQObject->FAQGet(
                    ItemID     => $ItemID,
                    ItemFields => 0,
                    UserID     => $Self->{UserID},
                );

                # Set change date to long format.
                my $Changed = $LayoutObject->{LanguageObject}->FormatTimeString(
                    $FAQData{Changed},
                    'DateFormatLong',
                );

                # Create PDF Rows.
                my @PDFRow;
                push @PDFRow, $FAQData{Number};
                push @PDFRow, $FAQData{Title};
                push @PDFRow, $FAQData{CategoryName};

                # Create language row.
                if ($MultiLanguage) {
                    push @PDFRow, $FAQData{Language};
                }

                push @PDFRow,  $FAQData{State};
                push @PDFRow,  $Changed;
                push @PDFData, \@PDFRow;
            }

            # PDF Output.
            my $Title = $LayoutObject->{LanguageObject}->Translate('FAQ') . ' '
                . $LayoutObject->{LanguageObject}->Translate('Search');
            my $PrintedBy = $LayoutObject->{LanguageObject}->Translate('printed by');
            my $Page      = $LayoutObject->{LanguageObject}->Translate('Page');
            my $Time      = $LayoutObject->{Time};

            # Get maximum number of pages.
            my $MaxPages = $ConfigObject->Get('PDF::MaxPages');
            if ( !$MaxPages || $MaxPages < 1 || $MaxPages > 1000 ) {
                $MaxPages = 100;
            }

            # Create the header.
            my $CellData;

            # Output 'No Result', if no content was given.
            if (@PDFData) {

                $CellData->[0]->[0]->{Content} = $ConfigObject->Get('FAQ::FAQHook');
                $CellData->[0]->[0]->{Font}    = 'ProportionalBold';
                $CellData->[0]->[1]->{Content} = $LayoutObject->{LanguageObject}->Translate('Title');
                $CellData->[0]->[1]->{Font}    = 'ProportionalBold';
                $CellData->[0]->[2]->{Content} = $LayoutObject->{LanguageObject}->Translate('Category');
                $CellData->[0]->[2]->{Font}    = 'ProportionalBold';

                # Store the correct header index.
                my $NextHeaderIndex = 3;

                # Add language header.
                if ($MultiLanguage) {
                    $CellData->[0]->[3]->{Content} = $LayoutObject->{LanguageObject}->Translate('Language');
                    $CellData->[0]->[3]->{Font}    = 'ProportionalBold';
                    $NextHeaderIndex               = 4;
                }

                $CellData->[0]->[$NextHeaderIndex]->{Content} = $LayoutObject->{LanguageObject}->Translate('State');
                $CellData->[0]->[$NextHeaderIndex]->{Font}    = 'ProportionalBold';

                $CellData->[0]->[ $NextHeaderIndex + 1 ]->{Content}
                    = $LayoutObject->{LanguageObject}->Translate('Changed');
                $CellData->[0]->[ $NextHeaderIndex + 1 ]->{Font} = 'ProportionalBold';

                # Create the content array.
                my $CounterRow = 1;
                for my $Row (@PDFData) {
                    my $CounterColumn = 0;
                    for my $Content ( @{$Row} ) {
                        $CellData->[$CounterRow]->[$CounterColumn]->{Content} = $Content;
                        $CounterColumn++;
                    }
                    $CounterRow++;
                }
            }
            else {
                $CellData->[0]->[0]->{Content} = $LayoutObject->{LanguageObject}->Translate('No Result!');

            }

            # Page params.
            my %PageParam;
            $PageParam{PageOrientation} = 'landscape';
            $PageParam{MarginTop}       = 30;
            $PageParam{MarginRight}     = 40;
            $PageParam{MarginBottom}    = 40;
            $PageParam{MarginLeft}      = 40;
            $PageParam{HeaderRight}     = $Title;
            $PageParam{HeadlineLeft}    = $Title;

            # Table params.
            my %TableParam;
            $TableParam{CellData}            = $CellData;
            $TableParam{Type}                = 'Cut';
            $TableParam{FontSize}            = 6;
            $TableParam{Border}              = 0;
            $TableParam{BackgroundColorEven} = '#DDDDDD';
            $TableParam{Padding}             = 1;
            $TableParam{PaddingTop}          = 3;
            $TableParam{PaddingBottom}       = 3;

            # Create new PDF document.
            $PDFObject->DocumentNew(
                Title  => $ConfigObject->Get('Product') . ': ' . $Title,
                Encode => $LayoutObject->{UserCharset},
            );

            # Start table output.
            $PDFObject->PageNew(
                %PageParam,
                FooterRight => $Page . ' 1',
            );

            $PDFObject->PositionSet(
                Move => 'relativ',
                Y    => -6,
            );

            # Output title.
            $PDFObject->Text(
                Text     => $Title,
                FontSize => 13,
            );

            $PDFObject->PositionSet(
                Move => 'relativ',
                Y    => -6,
            );

            # Output "printed by".
            $PDFObject->Text(
                Text => $PrintedBy . ' '
                    . $Self->{UserFullname} . ' ('
                    . $Self->{UserEmail} . ')'
                    . ', ' . $Time,
                FontSize => 9,
            );

            $PDFObject->PositionSet(
                Move => 'relativ',
                Y    => -14,
            );

            PAGE:
            for ( 2 .. $MaxPages ) {

                # Output table (or a fragment of it).
                %TableParam = $PDFObject->Table( %TableParam, );

                # Stop output or another page.
                if ( $TableParam{State} ) {
                    last PAGE;
                }
                else {
                    $PDFObject->PageNew(
                        %PageParam,
                        FooterRight => $Page . ' ' . $_,
                    );
                }
            }

            # Return the PDF document.
            my $Filename = 'FAQ_search';

            my $DateTimeObject = $Kernel::OM->Create('Kernel::System::DateTime');
            my $DateTime       = $DateTimeObject->Get();
            my $Y              = $DateTime->{Year};
            my $M              = sprintf( "%02d", $DateTime->{Month} );
            my $D              = sprintf( "%02d", $DateTime->{Day} );
            my $h              = sprintf( "%02d", $DateTime->{Hour} );
            my $m              = sprintf( "%02d", $DateTime->{Minute} );

            my $PDFString = $PDFObject->DocumentOutput();
            return $LayoutObject->Attachment(
                Filename    => $Filename . "_" . "$Y-$M-$D" . "_" . "$h-$m.pdf",
                ContentType => "application/pdf",
                Content     => $PDFString,
                Type        => 'inline',
            );
        }
        else {

            # Start HTML page.
            my $Output = $LayoutObject->Header();
            $Output .= $LayoutObject->NavigationBar();
            $LayoutObject->Print(
                Output => \$Output,
            );
            $Output = '';

            my $Filter = $ParamObject->GetParam( Param => 'Filter' ) || '';
            my $View   = $ParamObject->GetParam( Param => 'View' )   || '';

            # Show FAQ's.
            my $LinkPage = 'Filter='
                . $LayoutObject->LinkEncode($Filter)
                . ';View=' . $LayoutObject->LinkEncode($View)
                . ';SortBy=' . $LayoutObject->LinkEncode($SortBy)
                . ';OrderBy=' . $LayoutObject->LinkEncode($OrderBy)
                . ';Profile=' . $LayoutObject->LinkEncode($Profile) . ';TakeLastSearch=1;Subaction=Search'
                . ';';
            my $LinkSort = 'Filter='
                . $LayoutObject->LinkEncode($Filter)
                . ';View=' . $LayoutObject->LinkEncode($View)
                . ';Profile=' . $LayoutObject->LinkEncode($Profile) . ';TakeLastSearch=1;Subaction=Search'
                . ';';
            my $LinkFilter = 'TakeLastSearch=1;Subaction=Search;Profile='
                . $LayoutObject->LinkEncode($Profile)
                . ';';
            my $LinkBack = 'Subaction=LoadProfile;Profile='
                . $LayoutObject->LinkEncode($Profile)
                . ';TakeLastSearch=1;';

            my $FilterLink = 'SortBy=' . $LayoutObject->LinkEncode($SortBy)
                . ';OrderBy=' . $LayoutObject->LinkEncode($OrderBy)
                . ';View=' . $LayoutObject->LinkEncode($View)
                . ';Profile=' . $LayoutObject->LinkEncode($Profile) . ';TakeLastSearch=1;Subaction=Search'
                . ';';

            # Find out which columns should be shown.
            my @ShowColumns;
            if ( $Config->{ShowColumns} ) {

                # Get all possible columns from config.
                my %PossibleColumn = %{ $Config->{ShowColumns} };

                # Get the column names that should be shown.
                COLUMNNAME:
                for my $Name ( sort keys %PossibleColumn ) {
                    next COLUMNNAME if !$PossibleColumn{$Name};
                    push @ShowColumns, $Name;
                }

                # Enforce FAQ number column since is the link MasterAction hook.
                if ( !$PossibleColumn{'Number'} ) {
                    push @ShowColumns, 'Number';
                }
            }

            $Output .= $LayoutObject->FAQListShow(
                FAQIDs => \@ViewableItemIDs,
                Total  => scalar @ViewableItemIDs,

                View => $View,

                Env        => $Self,
                LinkPage   => $LinkPage,
                LinkSort   => $LinkSort,
                LinkFilter => $LinkFilter,
                LinkBack   => $LinkBack,
                Profile    => $Profile,

                TitleName => Translatable('Search Result'),
                Limit     => $SearchLimit,

                Filter     => $Filter,
                FilterLink => $FilterLink,

                OrderBy => $OrderBy,
                SortBy  => $SortBy,

                ShowColumns  => \@ShowColumns,
                FAQTitleSize => $Config->{TitleSize},
            );

            $Output .= $LayoutObject->Footer();
            return $Output;
        }
    }

    elsif ( $Self->{Subaction} eq 'AJAXProfileDelete' ) {
        my $Profile = $ParamObject->GetParam( Param => 'Profile' );

        # Remove old profile stuff.
        $SearchProfileObject->SearchProfileDelete(
            Base      => 'FAQSearch',
            Name      => $Profile,
            UserLogin => $Self->{UserLogin},
        );
        my $Output = $LayoutObject->JSONEncode(
            Data => 1,
        );
        return $LayoutObject->Attachment(
            NoCache     => 1,
            ContentType => 'text/html',
            Content     => $Output,
            Type        => 'inline',
        );
    }

    elsif ( $Self->{Subaction} eq 'AJAX' ) {

        my $Output = $Self->_MaskForm(
            %GetParam,
        );

        return $LayoutObject->Attachment(
            NoCache     => 1,
            ContentType => 'text/html',
            Charset     => $LayoutObject->{UserCharset},
            Content     => $Output,
            Type        => 'inline',
        );
    }

    # Show default search screen.
    $Output = $LayoutObject->Header();
    $Output .= $LayoutObject->NavigationBar();

    # Send data to JS.
    $LayoutObject->AddJSData(
        Key   => 'AgentFAQSearch',
        Value => 1,
    );

    $Output .= $LayoutObject->Output(
        TemplateFile => 'AgentFAQSearch',
        Data         => \%Param,
    );
    $Output .= $LayoutObject->Footer();
    return $Output;

}

sub _MaskForm {
    my ( $Self, %Param ) = @_;

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    my $TreeView = 0;
    if ( $ConfigObject->Get('Ticket::Frontend::ListType') eq 'tree' ) {
        $TreeView = 1;
    }

    my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');

    my $Profile     = $ParamObject->GetParam( Param => 'Profile' ) || '';
    my $EmptySearch = $ParamObject->GetParam( Param => 'EmptySearch' );
    if ( !$Profile ) {
        $EmptySearch = 1;
    }

    my $SearchProfileObject = $Kernel::OM->Get('Kernel::System::SearchProfile');

    my %GetParam = $SearchProfileObject->SearchProfileGet(
        Base      => 'FAQSearch',
        Name      => $Profile,
        UserLogin => $Self->{UserLogin},
    );

    # Get config from constructor.
    my $Config = $Self->{Config};

    # If no profile is used, set default params of default attributes.
    if ( !$Profile ) {
        if ( $Config->{Defaults} ) {
            ATTRIBUTE:
            for my $Attribute ( sort keys %{ $Config->{Defaults} } ) {
                next ATTRIBUTE if !$Config->{Defaults}->{$Attribute};
                next ATTRIBUTE if $Attribute eq 'DynamicField';
                $GetParam{$Attribute} = $Config->{Defaults}->{$Attribute};
            }
        }
    }

    # Set attributes string.
    my @Attributes = (
        {
            Key   => 'Number',
            Value => Translatable('FAQ Number'),
        },
        {
            Key   => 'Fulltext',
            Value => Translatable('Fulltext'),
        },
        {
            Key   => 'Title',
            Value => Translatable('Title'),
        },
        {
            Key   => 'Keyword',
            Value => Translatable('Keyword'),
        },
    );

    # Show Languages attribute.
    my $MultiLanguage = $ConfigObject->Get('FAQ::MultiLanguage');
    if ($MultiLanguage) {
        push @Attributes, (
            {
                Key   => 'LanguageIDs',
                Value => Translatable('Language'),
            },
        );
    }

    push @Attributes, (
        {
            Key   => 'CategoryIDs',
            Value => Translatable('Category'),
        },
        {
            Key   => 'ValidIDs',
            Value => Translatable('Validity'),
        },
        {
            Key   => 'StateIDs',
            Value => Translatable('State'),
        },
        {
            Key   => 'VoteSearchType',
            Value => Translatable('Votes'),
        },
        {
            Key   => 'RateSearchType',
            Value => Translatable('Rate'),
        },
        {
            Key   => 'ApprovedSearch',
            Value => Translatable('Approved'),
        },
        {
            Key   => 'CreatedUserIDs',
            Value => Translatable('Created by'),
        },
        {
            Key   => 'LastChangedUserIDs',
            Value => Translatable('Last Changed by'),
        },
        {
            Key   => 'ItemCreateTimePoint',
            Value => Translatable('FAQ Item Create Time (before/after)'),
        },
        {
            Key   => 'ItemCreateTimeSlot',
            Value => Translatable('FAQ Item Create Time (between)'),
        },
        {
            Key   => 'ItemChangeTimePoint',
            Value => Translatable('FAQ Item Change Time (before/after)'),
        },
        {
            Key   => 'ItemChangeTimeSlot',
            Value => Translatable('FAQ Item Change Time (between)'),
        },
    );

    my $DynamicFieldSeparator = 1;

    my $DynamicFieldBackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');
    my $LayoutObject              = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # Create dynamic fields search options for attribute select.
    DYNAMICFIELD:
    for my $DynamicFieldConfig ( @{ $Self->{DynamicField} } ) {
        next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);
        next DYNAMICFIELD if !$DynamicFieldConfig->{Name};
        next DYNAMICFIELD if $DynamicFieldConfig->{Name} eq '';

        # Create a separator for dynamic fields attributes.
        if ($DynamicFieldSeparator) {
            push @Attributes, (
                {
                    Key      => '',
                    Value    => '-',
                    Disabled => 1,
                },
            );

            $DynamicFieldSeparator = 0;
        }

        my $SearchFieldPreferences = $DynamicFieldBackendObject->SearchFieldPreferences(
            DynamicFieldConfig => $DynamicFieldConfig,
        );

        next DYNAMICFIELD if !IsArrayRefWithData($SearchFieldPreferences);

        my $TranslatedDynamicFieldLabel = $LayoutObject->{LanguageObject}->Translate(
            $DynamicFieldConfig->{Label},
        );

        PREFERENCE:
        for my $Preference ( @{$SearchFieldPreferences} ) {

            my $TranslatedSuffix = $LayoutObject->{LanguageObject}->Translate(
                $Preference->{LabelSuffix},
            ) || '';

            if ($TranslatedSuffix) {
                $TranslatedSuffix = ' (' . $TranslatedSuffix . ')';
            }

            push @Attributes, (
                {
                    Key => 'Search_DynamicField_'
                        . $DynamicFieldConfig->{Name}
                        . $Preference->{Type},
                    Value => $TranslatedDynamicFieldLabel . $TranslatedSuffix,
                },
            );
        }
    }

    # Create a separator if a dynamic field attribute was pushed.
    if ( !$DynamicFieldSeparator ) {
        push @Attributes, (
            {
                Key      => '',
                Value    => '-',
                Disabled => 1,
            },
        );
    }

    # Create HTML strings for all dynamic fields.
    my %DynamicFieldHTML;

    DYNAMICFIELD:
    for my $DynamicFieldConfig ( @{ $Self->{DynamicField} } ) {
        next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

        my $SearchFieldPreferences = $DynamicFieldBackendObject->SearchFieldPreferences(
            DynamicFieldConfig => $DynamicFieldConfig,
        );

        next DYNAMICFIELD if !IsArrayRefWithData($SearchFieldPreferences);

        PREFERENCE:
        for my $Preference ( @{$SearchFieldPreferences} ) {

            # Get field HTML.
            $DynamicFieldHTML{ $DynamicFieldConfig->{Name} . $Preference->{Type} }
                = $DynamicFieldBackendObject->SearchFieldRender(
                DynamicFieldConfig => $DynamicFieldConfig,
                Profile            => \%GetParam,
                DefaultValue =>
                    $Config->{Defaults}->{DynamicField}
                    ->{ $DynamicFieldConfig->{Name} },
                LayoutObject => $LayoutObject,
                Type         => $Preference->{Type},
                );
        }
    }

    # Drop-down menu for 'attributes'.
    $Param{AttributesStrg} = $LayoutObject->BuildSelection(
        PossibleNone => 1,
        Data         => \@Attributes,
        Name         => 'Attribute',
        Multiple     => 0,
        Class        => 'Modernize',
    );
    $Param{AttributesOrigStrg} = $LayoutObject->BuildSelection(
        PossibleNone => 1,
        Data         => \@Attributes,
        Name         => 'AttributeOrig',
        Multiple     => 0,
        Class        => 'Modernize',
    );

    my $FAQObject = $Kernel::OM->Get('Kernel::System::FAQ');

    my %Languages = $FAQObject->LanguageList(
        UserID => $Self->{UserID},
    );

    # Drop-down menu for 'languages'.
    $Param{LanguagesSelectionStrg} = $LayoutObject->BuildSelection(
        Data       => \%Languages,
        Name       => 'LanguageIDs',
        Size       => 5,
        Multiple   => 1,
        SelectedID => $GetParam{LanguageIDs} || [],
        Class      => 'Modernize',
    );

    # Get categories (with category long names) where user has rights.
    my $UserCategoriesLongNames = $FAQObject->GetUserCategoriesLongNames(
        Type   => 'ro',
        UserID => $Self->{UserID},
    );

    # Build the category selection.
    $Param{CategoriesSelectionStrg} = $LayoutObject->BuildSelection(
        Data        => $UserCategoriesLongNames,
        Name        => 'CategoryIDs',
        Size        => 5,
        SelectedID  => $GetParam{CategoryIDs} || [],
        Translation => 0,
        Multiple    => 1,
        TreeView    => $TreeView,
        Class       => 'Modernize',
    );

    my %ValidList = $Kernel::OM->Get('Kernel::System::Valid')->ValidList();

    # Build the valid selection.
    $Param{ValidSelectionStrg} = $LayoutObject->BuildSelection(
        Data        => \%ValidList,
        Name        => 'ValidIDs',
        Size        => 5,
        SelectedID  => $GetParam{ValidIDs} || [],
        Translation => 0,
        Multiple    => 1,
        Class       => 'Modernize',
    );

    # Create a mix of state and state types hash in order to have the state type IDs with state names.
    my %StateList = $FAQObject->StateList(
        UserID => $Self->{UserID},
    );

    my %States;
    for my $StateID ( sort keys %StateList ) {
        my %StateData = $FAQObject->StateGet(
            StateID => $StateID,
            UserID  => $Self->{UserID},
        );
        $States{ $StateData{TypeID} } = $StateData{Name};
    }

    $Param{StateSelectionStrg} = $LayoutObject->BuildSelection(
        Data        => \%States,
        Name        => 'StateIDs',
        Size        => 3,
        SelectedID  => $GetParam{StateIDs} || [],
        Translation => 1,
        Multiple    => 1,
        Class       => 'Modernize',
    );

    my %VotingOperators = (
        Equals            => Translatable('Equals'),
        GreaterThan       => Translatable('Greater than'),
        GreaterThanEquals => Translatable('Greater than equals'),
        SmallerThan       => Translatable('Smaller than'),
        SmallerThanEquals => Translatable('Smaller than equals'),
    );

    $Param{VoteSearchTypeSelectionStrg} = $LayoutObject->BuildSelection(
        Data        => \%VotingOperators,
        Name        => 'VoteSearchType',
        Size        => 1,
        SelectedID  => $GetParam{VoteSearchType} || '',
        Translation => 1,
        Multiple    => 0,
        Class       => 'Modernize',
    );

    $Param{RateSearchTypeSelectionStrg} = $LayoutObject->BuildSelection(
        Data        => \%VotingOperators,
        Name        => 'RateSearchType',
        Size        => 1,
        SelectedID  => $GetParam{RateSearchType} || '',
        Translation => 1,
        Multiple    => 0,
        Class       => 'Modernize',
    );
    $Param{RateSearchSelectionStrg} = $LayoutObject->BuildSelection(
        Data => {
            0   => '0%',
            25  => '25%',
            50  => '50%',
            75  => '75%',
            100 => '100%',
        },
        Sort        => 'NumericKey',
        Name        => 'RateSearch',
        Size        => 1,
        SelectedID  => $GetParam{RateSearch} || '',
        Translation => 0,
        Multiple    => 0,
        Class       => 'Modernize',
    );

    $Param{ApprovedStrg} = $LayoutObject->BuildSelection(
        Data => {
            No  => Translatable('No'),
            Yes => Translatable('Yes'),
        },
        Name        => 'ApprovedSearch',
        SelectedID  => $GetParam{ApprovedSearch} || 'Yes',
        Multiple    => 0,
        Translation => 1,
        Class       => 'Modernize',
    );

    # Get a list of all users to display.
    my %ShownUsers = $Kernel::OM->Get('Kernel::System::User')->UserList(
        Type  => 'Long',
        Valid => 1,
    );

    my $FrontendConfig = $ConfigObject->Get('Frontend::Module');
    my $FAQAddGroups   = $FrontendConfig->{AgentFAQAdd}->{Group} || [];

    my %FAQAddUsers = %ShownUsers;
    if ( IsArrayRefWithData($FAQAddGroups) ) {

        my %GroupUsers;
        for my $Group ( @{$FAQAddGroups} ) {

            my $GroupObject = $Kernel::OM->Get('Kernel::System::Group');

            my $GroupID = $GroupObject->GroupLookup( Group => $Group );
            my %Users   = $GroupObject->GroupMemberList(
                GroupID => $GroupID,
                Type    => 'rw',
                Result  => 'HASH',
            );
            %GroupUsers = ( %GroupUsers, %Users );
        }

        # Remove all users that are not in the FAQ or faq_admin groups.
        for my $UserID ( sort keys %FAQAddUsers ) {
            if ( !$GroupUsers{$UserID} ) {
                delete $FAQAddUsers{$UserID};
            }
        }
    }
    $Param{CreatedUserStrg} = $LayoutObject->BuildSelection(
        Data       => \%FAQAddUsers,
        Name       => 'CreatedUserIDs',
        Size       => 5,
        Multiple   => 1,
        SelectedID => $GetParam{CreatedUserIDs},
        Class      => 'Modernize',
    );

    my $FAQEditGroups = $FrontendConfig->{AgentFAQEdit}->{Group} || [];

    my %FAQEditUsers = %ShownUsers;
    if ( IsArrayRefWithData($FAQEditGroups) ) {

        my %GroupUsers;
        for my $Group ( @{$FAQEditGroups} ) {

            my $GroupObject = $Kernel::OM->Get('Kernel::System::Group');

            my $GroupID = $GroupObject->GroupLookup( Group => $Group );
            my %Users   = $GroupObject->GroupMemberList(
                GroupID => $GroupID,
                Type    => 'rw',
                Result  => 'HASH',
            );
            %GroupUsers = ( %GroupUsers, %Users );
        }

        # Remove all users that are not in the FAQ or faq_admin groups.
        for my $UserID ( sort keys %FAQEditUsers ) {
            if ( !$GroupUsers{$UserID} ) {
                delete $FAQEditUsers{$UserID};
            }
        }
    }

    $Param{LastChangedUserStrg} = $LayoutObject->BuildSelection(
        Data       => \%FAQEditUsers,
        Name       => 'LastChangedUserIDs',
        Size       => 5,
        Multiple   => 1,
        SelectedID => $GetParam{LastChangedUserIDs},
        Class      => 'Modernize',
    );

    $Param{ItemCreateTimePointStrg} = $LayoutObject->BuildSelection(
        Data       => [ 1 .. 59 ],
        Name       => 'ItemCreateTimePoint',
        SelectedID => $GetParam{ItemCreateTimePoint},
    );
    $Param{ItemCreateTimePointStartStrg} = $LayoutObject->BuildSelection(
        Data => {
            'Last'   => Translatable('within the last ...'),
            'Before' => Translatable('more than ... ago'),
        },
        Name       => 'ItemCreateTimePointStart',
        SelectedID => $GetParam{ItemCreateTimePointStart} || 'Last',
    );
    $Param{ItemCreateTimePointFormatStrg} = $LayoutObject->BuildSelection(
        Data => {
            minute => Translatable('minute(s)'),
            hour   => Translatable('hour(s)'),
            day    => Translatable('day(s)'),
            week   => Translatable('week(s)'),
            month  => Translatable('month(s)'),
            year   => Translatable('year(s)'),
        },
        Name       => 'ItemCreateTimePointFormat',
        SelectedID => $GetParam{ItemCreateTimePointFormat},
    );
    $Param{ItemCreateTimeStartStrg} = $LayoutObject->BuildDateSelection(
        %GetParam,
        Prefix   => 'ItemCreateTimeStart',
        Format   => 'DateInputFormat',
        DiffTime => -( ( 60 * 60 * 24 ) * 30 ),
    );
    $Param{ItemCreateTimeStopStrg} = $LayoutObject->BuildDateSelection(
        %GetParam,
        Prefix => 'ItemCreateTimeStop',
        Format => 'DateInputFormat',
    );

    $Param{ItemChangeTimePointStrg} = $LayoutObject->BuildSelection(
        Data       => [ 1 .. 59 ],
        Name       => 'ItemChangeTimePoint',
        SelectedID => $GetParam{ItemChangeTimePoint},
    );
    $Param{ItemChangeTimePointStartStrg} = $LayoutObject->BuildSelection(
        Data => {
            'Last'   => Translatable('within the last ...'),
            'Before' => Translatable('more than ... ago'),
        },
        Name       => 'ItemChangeTimePointStart',
        SelectedID => $GetParam{ItemChangeTimePointStart} || 'Last',
    );
    $Param{ItemChangeTimePointFormatStrg} = $LayoutObject->BuildSelection(
        Data => {
            minute => Translatable('minute(s)'),
            hour   => Translatable('hour(s)'),
            day    => Translatable('day(s)'),
            week   => Translatable('week(s)'),
            month  => Translatable('month(s)'),
            year   => Translatable('year(s)'),
        },
        Name       => 'ItemChangeTimePointFormat',
        SelectedID => $GetParam{ItemChangeTimePointFormat},
    );
    $Param{ItemChangeTimeStartStrg} = $LayoutObject->BuildDateSelection(
        %GetParam,
        Prefix   => 'ItemChangeTimeStart',
        Format   => 'DateInputFormat',
        DiffTime => -( ( 60 * 60 * 24 ) * 30 ),
    );
    $Param{ItemChangeTimeStopStrg} = $LayoutObject->BuildDateSelection(
        %GetParam,
        Prefix => 'ItemChangeTimeStop',
        Format => 'DateInputFormat',
    );

    my %Profiles = $SearchProfileObject->SearchProfileList(
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
    $Param{ProfilesStrg} = $LayoutObject->BuildSelection(
        Data       => \%Profiles,
        Name       => 'Profile',
        ID         => 'SearchProfile',
        SelectedID => $Profile,
        Class      => 'Modernize',
    );

    $Param{ResultFormStrg} = $LayoutObject->BuildSelection(
        Data => {
            Normal => Translatable('Normal'),
            Print  => Translatable('Print'),
            CSV    => Translatable('CSV'),
            Excel  => Translatable('Excel'),
        },
        Name       => 'ResultForm',
        SelectedID => $GetParam{ResultForm} || 'Normal',
        Class      => 'Modernize',
    );

    $LayoutObject->Block(
        Name => 'SearchAJAX',
        Data => {
            %Param,
            %GetParam,
            EmptySearch => $EmptySearch,
        },
    );

    # Output Dynamic fields blocks.
    DYNAMICFIELD:
    for my $DynamicFieldConfig ( @{ $Self->{DynamicField} } ) {
        next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

        # Get search field preferences.
        my $SearchFieldPreferences = $DynamicFieldBackendObject->SearchFieldPreferences(
            DynamicFieldConfig => $DynamicFieldConfig,
        );

        next DYNAMICFIELD if !IsArrayRefWithData($SearchFieldPreferences);

        PREFERENCE:
        for my $Preference ( @{$SearchFieldPreferences} ) {

            # skip fields that HTML could not be retrieved
            next PREFERENCE if !IsHashRefWithData(
                $DynamicFieldHTML{ $DynamicFieldConfig->{Name} . $Preference->{Type} }
            );

            $LayoutObject->Block(
                Name => 'DynamicField',
                Data => {
                    Label =>
                        $DynamicFieldHTML{ $DynamicFieldConfig->{Name} . $Preference->{Type} }
                        ->{Label},
                    Field =>
                        $DynamicFieldHTML{ $DynamicFieldConfig->{Name} . $Preference->{Type} }
                        ->{Field},
                },
            );
        }
    }

    # Show attributes.
    my @SearchAttributes;
    my %AlreadyShown;
    if ($Profile) {
        $LayoutObject->AddJSData(
            Key   => 'FAQSearchProfile',
            Value => $Profile,
        );
    }

    ITEM:
    for my $Item (@Attributes) {
        my $Key = $Item->{Key};
        next ITEM if !$Key;
        next ITEM if !defined $GetParam{$Key};
        next ITEM if $GetParam{$Key} eq '';

        next ITEM if $AlreadyShown{$Key};
        $AlreadyShown{$Key} = 1;
        push @SearchAttributes, $Key;
    }

    # if no attribute is shown, show full-text search.
    if ( !$Profile ) {

        # Merge regular show/hide settings and the settings for the dynamic fields.
        my %Defaults = %{ $Config->{Defaults} || {} };

        delete $Defaults{DynamicField};

        for my $DynamicFieldItem ( sort keys %{ $Config->{DynamicField} || {} } ) {
            if ( $Config->{DynamicField}->{$DynamicFieldItem} == 2 ) {
                $Defaults{"Search_DynamicField_$DynamicFieldItem"} = 1;
            }
        }

        if (%Defaults) {
            DEFAULT:
            for my $Key ( sort keys %Defaults ) {
                next DEFAULT if $Key eq 'DynamicField';    # ignore entry for DF config
                next DEFAULT if $AlreadyShown{$Key};
                $AlreadyShown{$Key} = 1;
                push @SearchAttributes, $Key;
            }
        }
        else {

            # If no attribute is shown, show full-text search.
            if ( !keys %AlreadyShown ) {
                push @SearchAttributes, 'Fulltext';
            }
        }
    }

    $LayoutObject->AddJSData(
        Key   => 'SearchAttributes',
        Value => \@SearchAttributes,
    );

    my $Output = $LayoutObject->Output(
        TemplateFile => 'AgentFAQSearch',
        Data         => \%Param,
        AJAX         => 1,
    );
    return $Output;
}

1;
