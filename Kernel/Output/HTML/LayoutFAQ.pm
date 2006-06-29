# --
# Kernel/Output/HTML/Agent.pm - provides generic agent HTML output
# Copyright (C) 2001-2006 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: LayoutFAQ.pm,v 1.1.1.1 2006-06-29 09:29:51 ct Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Output::HTML::LayoutFAQ;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.1.1.1 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

# --

sub AgentFAQCategoryListOption {

    my $Self = shift;
    my %Param = @_;
    my $Output = '';
    my $Size = defined($Param{Size}) ? "size='$Param{Size}'" : '';
    my $MaxLevel = defined($Param{MaxLevel}) ? $Param{MaxLevel} : 10;
    my $Selected = defined($Param{Selected}) ? $Param{Selected} : '';
    my $SelectedIDs = $Param{SelectedIDs} || [];
    my $SelectedID = defined($Param{SelectedID}) ? $Param{SelectedID} : '';
    my $Multiple = $Param{Multiple} ? 'multiple' : '';
    my $OnChangeSubmit = defined($Param{OnChangeSubmit}) ? $Param{OnChangeSubmit} : 0;
    if ($OnChangeSubmit) {
        $OnChangeSubmit = " onchange=\"submit()\"";
    }
    if ($Param{OnChange}) {
        $OnChangeSubmit = " onchange=\"$Param{OnChange}\"";
    }

    if (defined($Param{SelectedID})) {
        $SelectedIDs = [$SelectedID];
    }

    my %CategoryList = %{$Param{CategoryList}};
    #if (!($Param{CategoryList} && ref($Param{CategoryList}) eq 'HASH' && %{$Param{CategoryList}})) {
    #    return $Self->FatalError(
    #        Message => 'Need CategoryList as hash ref '
    #    );
    #}

    # build tree list
    $Output .= '<select name="'.$Param{Name}."\" $Size $Multiple $OnChangeSubmit>";

    if($Param{RootElement}) {
        $Output .= '<option value="0">-</option>';
    }

    if ($Param{CategoryList} && ref($Param{CategoryList}) eq 'HASH' && %{$Param{CategoryList}}) {
        $Output .= $Self->AgentFAQCategoryListOptionElement(
            CategoryList => \%CategoryList,
            LevelCounter => 0,
            ParentID => 0,
            SelectedIDs => $SelectedIDs
        );
    }
    $Output .= '</select>';

    return $Output;
}


sub AgentFAQCategoryListOptionElement {
    my $Self = shift;
    my %Param = @_;
    my $Output = '';

    my %CategoryList = %{ $Param{CategoryList} };
    my %CategoryLevelList = % { $CategoryList{$Param{ParentID}}};
    my @SelectedIDs = @{$Param{SelectedIDs}};
    my $Flag = 0;

    foreach my $CategoryID (sort( { $CategoryLevelList{$a} cmp $CategoryLevelList{$b} } keys(%CategoryLevelList))) {
        $Output .= '<option value="'.$CategoryID.'"';
        for(my $i=0;$i<@SelectedIDs;$i++) {
           if($Param{SelectedIDs}[$i] eq $CategoryID) {
               $Output .= ' selected';
           }           
        }
        $Output .= '>';
        for(my $i=0;$i<$Param{LevelCounter};$i++) {
            $Output .= '&nbsp;&nbsp;';
        }
        $Output .= $CategoryLevelList{$CategoryID};
        $Output .= '</option>';
        if(exists($CategoryList{$CategoryID})) {
            $Output .= $Self->AgentFAQCategoryListOptionElement(
                CategoryList => \%CategoryList,
                LevelCounter => $Param{LevelCounter}+1,
                ParentID => $CategoryID,
                SelectedIDs => \@SelectedIDs
            );
        }
    }
    return $Output;
}



sub GetFAQItemVotingRateColor {
    my $Self = shift;
    my %Param = @_;

    if (!$Param{Rate}) {
        return $Self->FatalError(
            Message => 'Need rate!'
        );
    }
    my $CssTmp = '';
    my %VotingResultColors = %{$Self->{ConfigObject}->Get('FAQ::Explorer::ItemList::VotingResultColors')};
    foreach my $Key (sort( { $b <=> $a } keys(%VotingResultColors))) {
        if($Param{Rate} <= $Key) {
            $CssTmp = $VotingResultColors{$Key};
        }
    }
    return $CssTmp;
}


1;
