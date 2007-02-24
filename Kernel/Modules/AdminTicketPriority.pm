# --
# Kernel/Modules/AdminTicketPriority.pm - admin frontend of ticket priority
# Copyright (C) 2003-2007 OTRS GmbH, http://otrs.com/
# --
# $Id: AdminTicketPriority.pm,v 1.1.1.1 2007-02-24 11:37:48 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AdminTicketPriority;

use strict;
use Kernel::System::Valid;
use Kernel::System::Priority;

use vars qw($VERSION);
$VERSION = '$Revision: 1.1.1.1 $';
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

    return $Self;
}

sub Run {
    my $Self = shift;
    my %Param = @_;

    # ------------------------------------------------------------ #
    # priority edit
    # ------------------------------------------------------------ #
    if ($Self->{Subaction} eq 'PriorityEdit') {
        my %PriorityData;
        # get params
        $PriorityData{PriorityID} = $Self->{ParamObject}->GetParam(Param => "PriorityID");
        if ($PriorityData{PriorityID} eq 'NEW') {
            $PriorityData{Name} = $Self->{ParamObject}->GetParam(Param => "Name");
        }
        else {
            %PriorityData = $Self->{PriorityObject}->PriorityGet(
                PriorityID => $PriorityData{PriorityID},
                UserID => $Self->{UserID},
            );
            $PriorityData{PriorityID} = $PriorityData{ID};
        }
        # output header
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();

        # output overview
        $Self->{LayoutObject}->Block(
            Name => 'Overview',
            Data => {
                %Param,
            },
        );
        # generate ValidOptionStrg
        my %ValidList = $Self->{ValidObject}->ValidList();
        $PriorityData{ValidOptionStrg} = $Self->{LayoutObject}->BuildSelection(
            Data => \%ValidList,
            Name => 'ValidID',
            SelectedID => $PriorityData{ValidID},
        );
        # output service edit
        $Self->{LayoutObject}->Block(
            Name => 'PriorityEdit',
            Data => {
                %Param,
                %PriorityData,
                
            },
        );
        # generate output
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AdminTicketPriority',
            Data => \%Param,
        );
        $Output .= $Self->{LayoutObject}->Footer();

        return $Output;
    }
    # ------------------------------------------------------------ #
    # priority save
    # ------------------------------------------------------------ #
    elsif ($Self->{Subaction} eq 'PrioritySave') {
        my $ErrorNotify = '';
        my %PriorityData;
        # get params
        foreach (qw(PriorityID Name ValidID)) {
            $PriorityData{$_} = $Self->{ParamObject}->GetParam(Param => "$_") || '';
        }
        $PriorityData{ID} = $PriorityData{PriorityID};
        # save to database
        if ($PriorityData{PriorityID} eq 'NEW') {
            my $Success = $Self->{PriorityObject}->PriorityAdd(
                %PriorityData,
                UserID => $Self->{UserID},
            );
            if (!$Success) {
                $ErrorNotify .= "&ErrorAdd=1";
            }
        }
        else {
            my $Success = $Self->{PriorityObject}->PriorityUpdate(
                %PriorityData,
                UserID => $Self->{UserID},
            );
            if (!$Success) {
                $ErrorNotify .= "&ErrorUpdate=1";
            }
        }
        # redirect to overview
        return $Self->{LayoutObject}->Redirect(OP => "Action=$Self->{Action}$ErrorNotify");
    }
    # ------------------------------------------------------------ #
    # overview
    # ------------------------------------------------------------ #
    else {
        # output header and navbar
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        
        # output error notify
        if ($Self->{ParamObject}->GetParam(Param => "ErrorAdd")) {
            $Output .= $Self->{LayoutObject}->Notify(
                Priority => 'Error',
                Data => '$Text{"Add new priority failed! See System Log for details."}',
            );
        }
        elsif ($Self->{ParamObject}->GetParam(Param => "ErrorUpdate")) {
            $Output .= $Self->{LayoutObject}->Notify(
                Priority => 'Error',
                Data => '$Text{"Update priority faild! See System Log for details."}',
            );
        }
        # output overview
        $Self->{LayoutObject}->Block(
            Name => 'Overview',
            Data => {
                %Param,
            },
        );
        # output overview result
        $Self->{LayoutObject}->Block(
            Name => 'OverviewList',
            Data => {
                %Param,
            },
        );
        # get priority list
        my %PriorityList = $Self->{PriorityObject}->PriorityList(
            Valid => 0,
            UserID => $Self->{UserID},
        );
        # get valid list
        my %ValidList = $Self->{ValidObject}->ValidList();

        my $CssClass;
        foreach my $PriorityID (sort {$PriorityList{$a} cmp $PriorityList{$b}} keys %PriorityList) {
            # set output class
            if ($CssClass && $CssClass eq 'searchactive') {
                $CssClass = 'searchpassive';
            }
            else {
                $CssClass = 'searchactive';
            }
            # get priority data
            my %PriorityData = $Self->{PriorityObject}->PriorityGet(
                PriorityID => $PriorityID,
                UserID => $Self->{UserID},
            );
            $Self->{LayoutObject}->Block(
                Name => 'OverviewListRow',
                Data => {
                    %PriorityData,
                    PriorityID => $PriorityID,
                    CssClass => $CssClass,
                    Valid => $ValidList{$PriorityData{ValidID}},
                },
            );
        }

        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AdminTicketPriority',
            Data => \%Param,
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
}

1;