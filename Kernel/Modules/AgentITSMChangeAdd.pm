# --
# Kernel/Modules/AgentITSMChangeAdd.pm - the OTRS::ITSM::ChangeManagement change add module
# Copyright (C) 2003-2009 OTRS AG, http://otrs.com/
# --
# $Id: AgentITSMChangeAdd.pm,v 1.9 2009-11-02 15:26:09 bes Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentITSMChangeAdd;

use strict;
use warnings;

use Kernel::System::ITSMChange;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.9 $) [1];

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
    $Self->{ChangeObject} = Kernel::System::ITSMChange->new(%Param);

    # get config of frontend module
    $Self->{Config} = $Self->{ConfigObject}->Get("ITSMChangeManagement::Frontend::$Self->{Action}");

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # check permissions
    my $Access = $Self->{ChangeObject}->Permission(
        Type   => $Self->{Config}->{Permission},
        UserID => $Self->{UserID}
    );

    # error screen, don't show ticket
    if ( !$Access ) {
        return $Self->{LayoutObject}->NoPermission(
            Message    => "You need $Self->{Config}->{Permission} permissions!",
            WithHeader => 'yes',
        );
    }

    # store all needed parameters in %GetParam to make it reloadable
    my %GetParam;
    for my $ParamName (qw(ChangeTitle Description Justification)) {
        $GetParam{$ParamName} = $Self->{ParamObject}->GetParam( Param => $ParamName );
    }

    # store time related fields in %GetParam
    for my $TimePart (qw(Year Month Day Hour Minute Used)) {
        my $ParamName = 'RealizeTime' . $TimePart;
        $GetParam{$ParamName} = $Self->{ParamObject}->GetParam( Param => $ParamName );
    }

    my $CheckTime = $GetParam{RealizeTimeYear} && $GetParam{RealizeTimeMonth}
        && $GetParam{RealizeTimeDay} && $GetParam{RealizeTimeHour}
        && $GetParam{RealizeTimeMinute} && $GetParam{RealizeTimeUsed};
    my $DoSave = 1;

    # update change
    if ( $Self->{Subaction} eq 'Save' ) {

        # check whether complete times are passed and build the time stamps
        my %SystemTime;

        # if the parameters are set
        if ($CheckTime) {

            # format as timestamp
            $GetParam{RealizeTime} = sprintf '%04d-%02d-%02d %02d:%02d:00',
                $GetParam{RealizeTimeYear},
                $GetParam{RealizeTimeMonth},
                $GetParam{RealizeTimeDay},
                $GetParam{RealizeTimeHour},
                $GetParam{RealizeTimeMinute};

            # sanity check the assembled timestamp
            $SystemTime{RealizeTime} = $Self->{TimeObject}->TimeStamp2SystemTime(
                String => $GetParam{RealizeTime},
            );

            # do not save when time is invalid
            if ( !$SystemTime{RealizeTime} ) {
                $DoSave = 0;
            }
        }

        # add only if ChangeTitle is given
        if ( $GetParam{ChangeTitle} && $DoSave ) {
            my $ChangeID = $Self->{ChangeObject}->ChangeAdd(
                Description   => $GetParam{Description},
                Justification => $GetParam{Justification},
                ChangeTitle   => $GetParam{ChangeTitle},
                RealizeTime   => $GetParam{RealizeTime},
                UserID        => $Self->{UserID},
            );

            if ( !$ChangeID ) {

                # show error message
                return $Self->{LayoutObject}->ErrorScreen(
                    Message => 'Was not able to add Change!',
                    Comment => 'Please contact the admin.',
                );
            }
            else {

                # redirect to zoom mask
                return $Self->{LayoutObject}->Redirect(
                    OP => "Action=AgentITSMChangeZoom&ChangeID=$ChangeID",
                );
            }
        }
        else {

            # no title given
            if ( !$Param{ChangeTitle} ) {

                # show invalid message
                $Self->{LayoutObject}->Block(
                    Name => 'InvalidTitle',
                );
            }

            # time has invalid format
            if ( $CheckTime && !$SystemTime{RealizeTime} ) {

                # show invalid message
                $Self->{LayoutObject}->Block(
                    Name => 'InvalidRealizeTime',
                );
            }
        }
    }

    # build template dropdown
    # TODO: fill dropdown with data
    my $TemplateDropDown = $Self->{LayoutObject}->BuildSelection(
        Name => 'ChangeTemplate',
        Data => {},
    );

    # show block with template dropdown
    $Self->{LayoutObject}->Block(
        Name => 'ChangeTemplate',
        Data => {
            TemplatesStrg => $TemplateDropDown,
        },
    );

    # output header
    my $Output = $Self->{LayoutObject}->Header(
        Title => 'Add',
    );
    $Output .= $Self->{LayoutObject}->NavigationBar();

    # add rich text editor
    if ( $Self->{ConfigObject}->Get('Frontend::RichText') ) {
        $Self->{LayoutObject}->Block(
            Name => 'RichText',
        );
    }

    # time period that can be selected from the GUI
    my %TimePeriod = %{ $Self->{ConfigObject}->Get('ITSMWorkOrder::TimePeriod') };

    # add selection for the time
    my $TimeSelectionString = $Self->{LayoutObject}->BuildDateSelection(
        %GetParam,
        Format              => 'DateInputFormatLong',
        Prefix              => 'RealizeTime',
        RealizeTimeOptional => 1,
        %TimePeriod,
    );

    # show time fields
    $Self->{LayoutObject}->Block(
        Name => 'RealizeTime',
        Data => {
            'RealizeTimeString' => $TimeSelectionString,
        },
    );

    # start template output
    $Output .= $Self->{LayoutObject}->Output(
        TemplateFile => 'AgentITSMChangeAdd',
        Data         => {
            %Param,
            %GetParam,
        },
    );

    # add footer
    $Output .= $Self->{LayoutObject}->Footer();

    return $Output;
}

1;
