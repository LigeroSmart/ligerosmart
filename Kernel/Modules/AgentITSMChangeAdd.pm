# --
# Kernel/Modules/AgentITSMChangeAdd.pm - the OTRS::ITSM::ChangeManagement change add module
# Copyright (C) 2003-2009 OTRS AG, http://otrs.com/
# --
# $Id: AgentITSMChangeAdd.pm,v 1.15 2009-11-12 17:08:19 bes Exp $
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
$VERSION = qw($Revision: 1.15 $) [1];

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
    $Self->{Config} = $Self->{ConfigObject}->Get("ITSMChange::Frontend::$Self->{Action}");

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # check permissions
    my $Access = $Self->{ChangeObject}->Permission(
        Type   => $Self->{Config}->{Permission},
        UserID => $Self->{UserID},
    );

    # error screen, don't show change add mask
    if ( !$Access ) {
        return $Self->{LayoutObject}->NoPermission(
            Message    => "You need $Self->{Config}->{Permission} permissions!",
            WithHeader => 'yes',
        );
    }

    # store needed parameters in %GetParam to make it reloadable
    my %GetParam;
    for my $ParamName (qw(ChangeTitle Description Justification TicketID)) {
        $GetParam{$ParamName} = $Self->{ParamObject}->GetParam( Param => $ParamName );
    }

    # store time related fields in %GetParam
    for my $TimePart (qw(Year Month Day Hour Minute Used)) {
        my $ParamName = 'RealizeTime' . $TimePart;
        $GetParam{$ParamName} = $Self->{ParamObject}->GetParam( Param => $ParamName );
    }

    # The TicketID can be validated even without the Subaction 'Save',
    # as it is passed as GET-param or in a hidden field.
    if ( $GetParam{TicketID} ) {
        my %Ticket = $Self->{TicketObject}->TicketGet(
            TicketID => $GetParam{TicketID},
        );
        $Self->{LayoutObject}->Block(
            Name => 'Ticket',
            Data => {%Ticket},
        );

        my $TicketIsInvalid;
        TICKETISINVALID:
        {
            if ( $GetParam{TicketID} !~ m{ \A \d+ \z }xms ) {
                $TicketIsInvalid = 'TicketID must be an integer';
                last TICKETISINVALID;
            }

            if ( !%Ticket ) {
                $TicketIsInvalid = 'No ticket found';
                last TICKETISINVALID;
            }

            # get and check the list of relevant ticket types
            my $AddChangeLinkTicketTypes
                = $Self->{ConfigObject}->Get('ITSMChange::AddChangeLinkTicketTypes');

            if ( !$AddChangeLinkTicketTypes || ref $AddChangeLinkTicketTypes ne 'ARRAY' ) {
                $TicketIsInvalid = q{Missing config entry 'ITSMChange::AddChangeLinkTicketTypes'};
                last TICKETISINVALID;
            }

            # check whether the ticket's type is relevant
            my %IsRelevant = map { $_ => 1 } @{$AddChangeLinkTicketTypes};

            if ( !$IsRelevant{ $Ticket{Type} } ) {
                $TicketIsInvalid = 'Invalid ticket type';
                last TICKETISINVALID;
            }
        }

        if ($TicketIsInvalid) {
            $Self->{LayoutObject}->Block(
                Name => 'InvalidTicketID',
                Data => {
                    TicketID => $GetParam{TicketID},
                    Reason   => $TicketIsInvalid,
                },
            );
        }
    }

    # Remember the reason why saving was not attempted.
    # This entries are the names of the dtl validation error blocks.
    my @ValidationErrors;

    # update change
    if ( $Self->{Subaction} eq 'Save' ) {

        # check the title
        if ( !$GetParam{ChangeTitle} ) {
            push @ValidationErrors, 'InvalidTitle';
        }

        # check the realize time
        if (
            $GetParam{RealizeTimeYear}
            && $GetParam{RealizeTimeMonth}
            && $GetParam{RealizeTimeDay}
            && $GetParam{RealizeTimeHour}
            && $GetParam{RealizeTimeMinute}
            && $GetParam{RealizeTimeUsed}
            )
        {

            # format as timestamp, when all required time param were passed
            $GetParam{RealizeTime} = sprintf '%04d-%02d-%02d %02d:%02d:00',
                $GetParam{RealizeTimeYear},
                $GetParam{RealizeTimeMonth},
                $GetParam{RealizeTimeDay},
                $GetParam{RealizeTimeHour},
                $GetParam{RealizeTimeMinute};

            # sanity check of the assembled timestamp
            my $SystemTime = $Self->{TimeObject}->TimeStamp2SystemTime(
                String => $GetParam{RealizeTime},
            );

            # do not save when time is invalid
            if ( !$SystemTime ) {
                push @ValidationErrors, 'InvalidRealizeTime';
            }
        }
        elsif ( $GetParam{RealizeTimeUser} ) {

            # it was indicated that the realize time should be set,
            # but at least one of the required time params is missing
            push @ValidationErrors, 'InvalidRealizeTime';
        }

        # add only when there are no input validation errors
        if ( !@ValidationErrors ) {
            my $ChangeID = $Self->{ChangeObject}->ChangeAdd(
                Description   => $GetParam{Description},
                Justification => $GetParam{Justification},
                ChangeTitle   => $GetParam{ChangeTitle},
                RealizeTime   => $GetParam{RealizeTime},
                UserID        => $Self->{UserID},
            );

            if ($ChangeID) {

                # redirect to zoom mask
                return $Self->{LayoutObject}->Redirect(
                    OP => "Action=AgentITSMChangeZoom&ChangeID=$ChangeID",
                );
            }
            else {

                # show error message
                return $Self->{LayoutObject}->ErrorScreen(
                    Message => 'Was not able to add Change!',
                    Comment => 'Please contact the admin.',
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

    # Add the validation error messages as late as possible
    # as the enclosing blocks, e.g. 'RealizeTime' muss first be set.
    for my $BlockName (@ValidationErrors) {

        # show validation error message
        $Self->{LayoutObject}->Block(
            Name => $BlockName,
        );
    }

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
