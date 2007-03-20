# --
# Kernel/Modules/AdminITSMCIPAllocate.pm - admin frontend of criticality, impact and priority
# Copyright (C) 2003-2007 OTRS GmbH, http://otrs.com/
# --
# $Id: AdminITSMCIPAllocate.pm,v 1.1 2007-03-20 11:50:08 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AdminITSMCIPAllocate;

use strict;
use Kernel::System::Valid;
use Kernel::System::Priority;
use Kernel::System::GeneralCatalog;
use Kernel::System::ITSMCIPAllocate;

use vars qw($VERSION);
$VERSION = '$Revision: 1.1 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

sub new {
    my $Type = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {};
    bless ($Self, $Type);

    # get common opjects
    foreach (keys %Param) {
        $Self->{$_} = $Param{$_};
    }

    # check all needed objects
    foreach (qw(ConfigObject ParamObject LogObject LayoutObject)) {
        if (!$Self->{$_}) {
            $Self->{LayoutObject}->FatalError(Message => "Got no $_!");
        }
    }
    $Self->{ValidObject} = Kernel::System::Valid->new(%Param);
    $Self->{PriorityObject} = Kernel::System::Priority->new(%Param);
    $Self->{GeneralCatalogObject} = Kernel::System::GeneralCatalog->new(%Param);
    $Self->{CIPAllocateObject} = Kernel::System::ITSMCIPAllocate->new(%Param);

    return $Self;
}

sub Run {
    my $Self = shift;
    my %Param = @_;

    # ------------------------------------------------------------ #
    # criticality, impact and priority allocation
    # ------------------------------------------------------------ #
    if ($Self->{Subaction} eq 'CIPAllocate') {
        # get option lists
        my %ObjectOption;
        $ObjectOption{CriticalityList} = $Self->{GeneralCatalogObject}->ItemList(
            Class => 'ITSM::Core::Criticality',
        );
        $ObjectOption{ImpactList} = $Self->{GeneralCatalogObject}->ItemList(
            Class => 'ITSM::Core::Impact',
        );
        my %OptionPriorityList = $Self->{PriorityObject}->PriorityList(UserID => 1);
        $ObjectOption{PriorityList} = \%OptionPriorityList;

        # get all PriorityIDs of the matrix
        my $AllocateData;
        foreach my $ImpactID (sort keys %{$ObjectOption{ImpactList}}) {
            foreach my $CriticalityID (sort keys %{$ObjectOption{CriticalityList}}) {
                my $PriorityID = $Self->{ParamObject}->GetParam(
                    Param => "PriorityID" . $ImpactID .'-'. $CriticalityID,
                ) || '';

                if ($PriorityID) {
                    $AllocateData->{$ImpactID}->{$CriticalityID} = $PriorityID;
                }
            }
        }
        # update allocations
        $Self->{CIPAllocateObject}->AllocateUpdate(
            AllocateData => $AllocateData,
            UserID => 1,
        );
        return $Self->{LayoutObject}->Redirect(OP => "Action=$Self->{Action}");
    }
    # ------------------------------------------------------------ #
    # overview
    # ------------------------------------------------------------ #
    else {
        # output header and navbar
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();

        # get option lists
        my %ObjectOption;
        $ObjectOption{CriticalityList} = $Self->{GeneralCatalogObject}->ItemList(
            Class => 'ITSM::Core::Criticality',
        );
        $ObjectOption{ImpactList} = $Self->{GeneralCatalogObject}->ItemList(
            Class => 'ITSM::Core::Impact',
        );
        my %OptionPriorityList = $Self->{PriorityObject}->PriorityList(UserID => 1);
        $ObjectOption{PriorityList} = \%OptionPriorityList;

        # get allocation data
        my $AllocateData = $Self->{CIPAllocateObject}->AllocateList(UserID => 1);

        my $AllocateMatrix;
        $AllocateMatrix->[0]->[0]->{Class} = 'Description';
        # generate table description (Impact)
        my $Counter1 = 1;
        foreach (sort {$ObjectOption{ImpactList}->{$a} cmp $ObjectOption{ImpactList}->{$b}} keys %{$ObjectOption{ImpactList}}) {
            $AllocateMatrix->[$Counter1]->[0]->{ObjectType} = 'Impact';
            $AllocateMatrix->[$Counter1]->[0]->{ImpactKey} = $_;
            $AllocateMatrix->[$Counter1]->[0]->{ObjectOption} = $ObjectOption{ImpactList}{$_};
            $AllocateMatrix->[$Counter1]->[0]->{Class} = 'Description';
            $Counter1++;
        }
        # generate table description (Criticality)
        my $Counter2 = 1;
        foreach (sort {$ObjectOption{CriticalityList}->{$a} cmp $ObjectOption{CriticalityList}->{$b}} keys %{$ObjectOption{CriticalityList}}) {
            $AllocateMatrix->[0]->[$Counter2]->{ObjectType} = 'Criticality';
            $AllocateMatrix->[0]->[$Counter2]->{CriticalityKey} = $_;
            $AllocateMatrix->[0]->[$Counter2]->{ObjectOption} = $ObjectOption{CriticalityList}{$_};
            $AllocateMatrix->[0]->[$Counter2]->{Class} = 'Description';
            $Counter2++;
        }
        # generate content
        foreach my $Row (1..($Counter1-1)) {
            foreach my $Column (1..($Counter2-1)) {
                $AllocateMatrix->[$Row]->[$Column]->{Class} = 'Content';
                $AllocateMatrix->[$Row]->[$Column]->{OptionStrg} = $Self->{LayoutObject}->OptionStrgHashRef(
                    Name => 'PriorityID'.
                        $AllocateMatrix->[$Row]->[0]->{ImpactKey}.'-'.
                        $AllocateMatrix->[0]->[$Column]->{CriticalityKey},
                    Data => $ObjectOption{PriorityList},
                    SelectedID => $AllocateData->{$AllocateMatrix->[$Row]->[0]->{ImpactKey}}{$AllocateMatrix->[0]->[$Column]->{CriticalityKey}} || '',
                );
            }
        }
        # output allocation matrix
        foreach my $RowRef (@{$AllocateMatrix}) {
            $Self->{LayoutObject}->Block(
                Name => 'CIPAllocateRow',
            );
            foreach my $Cell (@{$RowRef}) {
                $Self->{LayoutObject}->Block(
                    Name => 'CIPAllocateRowColumn'. $Cell->{Class},
                    Data => $Cell,
                );
            }
        }
        # start template output
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AdminITSMCIPAllocate',
            Data => \%Param,
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
}

1;