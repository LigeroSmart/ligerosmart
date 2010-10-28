# --
# Kernel/Output/HTML/LayoutFAQ.pm - provides generic agent HTML output
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# --
# $Id: LayoutFAQ.pm,v 1.9 2010-10-28 20:57:15 cr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::Output::HTML::LayoutFAQ;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.9 $) [1];

sub AgentFAQCategoryListOption {

    my ( $Self, %Param ) = @_;

    my $Output         = '';
    my $Size           = defined( $Param{Size} ) ? "size='$Param{Size}'" : '';
    my $MaxLevel       = defined( $Param{MaxLevel} ) ? $Param{MaxLevel} : 10;
    my $Selected       = defined( $Param{Selected} ) ? $Param{Selected} : '';
    my $SelectedIDs    = $Param{SelectedIDs} || [];
    my $SelectedID     = defined( $Param{SelectedID} ) ? $Param{SelectedID} : '';
    my $Multiple       = $Param{Multiple} ? 'multiple' : '';
    my $OnChangeSubmit = defined( $Param{OnChangeSubmit} ) ? $Param{OnChangeSubmit} : '';
    if ($OnChangeSubmit) {
        $OnChangeSubmit = " onchange=\"submit()\"";
    }
    if ( $Param{OnChange} ) {
        $OnChangeSubmit = " onchange=\"$Param{OnChange}\"";
    }

    if ( defined( $Param{SelectedID} ) ) {
        $SelectedIDs = [$SelectedID];
    }

    my %CategoryList = %{ $Param{CategoryList} };

    # build tree list
    $Output .= '<select name="' . $Param{Name} . "\" id=\"" . $Param{Name} . "\" $Size $Multiple $OnChangeSubmit>";

    if ( $Param{RootElement} ) {
        $Output .= '<option value="0">-</option>';
    }

    if (
        $Param{CategoryList}
        && ref( $Param{CategoryList} ) eq 'HASH'
        && %{ $Param{CategoryList} }
        )
    {
        $Output .= $Self->AgentFAQCategoryListOptionElement(
            CategoryList => \%CategoryList,
            LevelCounter => 0,
            ParentID     => 0,
            SelectedIDs  => $SelectedIDs,
        );
    }
    $Output .= '</select>';

    return $Output;
}

sub AgentFAQCategoryListOptionElement {
    my ( $Self, %Param ) = @_;

    my $Output = '';

    my $LevelCounter = $Param{LevelCounter} || 0;
    my $ParentID     = $Param{ParentID};

    my %ParentNames;

    my %CategoryList       = %{ $Param{CategoryList} };
    my %CategoryLevelList  = %{ $CategoryList{ $ParentID } };
    my %SelectedIDs        = map { $_ => 1 } @{ $Param{SelectedIDs} };

    my @TempSubCategoryIDs = map  { "Level:$LevelCounter" . "ParentID:$ParentID", $_ }
                             sort { $CategoryLevelList{$a} cmp $CategoryLevelList{$b} }
                             keys %CategoryLevelList;

    SUBCATEGORYID:
    while ( @TempSubCategoryIDs ) {

        # add level counter id to subcategory array
        if ( $TempSubCategoryIDs[0] =~ m{ Level : ( \d+ ) ParentID : ( \d+ ) }xms ) {
            $LevelCounter = $1;
            $ParentID     = $2;
            shift @TempSubCategoryIDs;
        }

        # get next subcategory id
        my $SubCategoryID = shift @TempSubCategoryIDs;

        # get new category level list
        %CategoryLevelList = %{ $CategoryList{ $ParentID } };

        # create output
        $Output .= '<option value="' . $SubCategoryID . '"';
        if ( $SelectedIDs{ $SubCategoryID } ) {
            $Output .= ' selected';
        }
        $Output .= '>';

        # get category name
        my $CategoryName = $CategoryLevelList{$SubCategoryID};

        # append parent name to child category name
        if ( $ParentNames{$ParentID} ) {
            $CategoryName = $ParentNames{$ParentID} . '::' . $CategoryName;
        }

        # set current child complete name to ParentNames hash for further use
        $ParentNames{$SubCategoryID} = $CategoryName;

        $Output .= $CategoryName;
        $Output .= '</option>';

        # check if subcategory has own subcategories
        next SUBCATEGORYID if !$CategoryList{ $SubCategoryID };

        # increase level
        my $NextLevel = $LevelCounter + 1;

        # get new subcategory ids
        my %NewCategoryLevelList = %{ $CategoryList{ $SubCategoryID } };
        my @NewSubcategoryIDs = map  { "Level:$NextLevel" . "ParentID:$SubCategoryID", $_ }
                                sort { $NewCategoryLevelList{$a} cmp $NewCategoryLevelList{$b} }
                                keys %NewCategoryLevelList;

        # add new subcategory ids at beginning of temp array
        unshift @TempSubCategoryIDs, @NewSubcategoryIDs;
    }

    return $Output;
}

sub GetFAQItemVotingRateColor {
    my ( $Self, %Param ) = @_;

    if ( !defined $Param{Rate} ) {
        return $Self->FatalError(
            Message => 'Need rate!'
        );
    }
    my $CssTmp = '';
    my %VotingResultColors
        = %{ $Self->{ConfigObject}->Get('FAQ::Explorer::ItemList::VotingResultColors') };
    for my $Key ( sort( { $b <=> $a } keys(%VotingResultColors) ) ) {
        if ( $Param{Rate} <= $Key ) {
            $CssTmp = $VotingResultColors{$Key};
        }
    }
    return $CssTmp;
}

1;
