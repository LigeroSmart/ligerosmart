# --
# Kernel/Modules/AgentITSMChangeConditionEdit.pm - the OTRS::ITSM::ChangeManagement condition edit module
# Copyright (C) 2003-2010 OTRS AG, http://otrs.com/
# --
# $Id: AgentITSMChangeConditionEdit.pm,v 1.13 2010-01-28 03:15:34 ub Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentITSMChangeConditionEdit;

use strict;
use warnings;

use Kernel::System::ITSMChange;
use Kernel::System::ITSMChange::ITSMCondition;
use Kernel::System::Valid;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.13 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check needed objects
    for my $Object (qw(ConfigObject ParamObject DBObject LayoutObject LogObject)) {
        if ( !$Self->{$Object} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $Object!" );
        }
    }

    # create needed objects
    $Self->{ChangeObject}    = Kernel::System::ITSMChange->new(%Param);
    $Self->{ConditionObject} = Kernel::System::ITSMChange::ITSMCondition->new(%Param);
    $Self->{ValidObject}     = Kernel::System::Valid->new(%Param);

    # get config of frontend module
    $Self->{Config} = $Self->{ConfigObject}->Get("ITSMChange::Frontend::$Self->{Action}");

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # store needed parameters in %GetParam
    my %GetParam;
    for my $ParamName (
        qw(
        ChangeID ConditionID Name Comment ExpressionConjunction ValidID
        Save AddAction AddExpression NewExpression NewAction ElementChanged)
        )
    {
        $GetParam{$ParamName} = $Self->{ParamObject}->GetParam( Param => $ParamName );
    }

    # check needed stuff
    for my $Needed (qw(ChangeID ConditionID)) {
        if ( !$GetParam{$Needed} ) {
            $Self->{LayoutObject}->ErrorScreen(
                Message => "No $Needed is given!",
                Comment => 'Please contact the admin.',
            );
            return;
        }
    }

    # check permissions
    my $Access = $Self->{ChangeObject}->Permission(
        Type     => $Self->{Config}->{Permission},
        ChangeID => $GetParam{ChangeID},
        UserID   => $Self->{UserID},
    );

    # error screen
    if ( !$Access ) {
        return $Self->{LayoutObject}->NoPermission(
            Message    => "You need $Self->{Config}->{Permission} permissions!",
            WithHeader => 'yes',
        );
    }

    # get change data
    my $ChangeData = $Self->{ChangeObject}->ChangeGet(
        ChangeID => $GetParam{ChangeID},
        UserID   => $Self->{UserID},
    );

    # check if change exists
    if ( !$ChangeData ) {
        return $Self->{LayoutObject}->ErrorScreen(
            Message => "Change $GetParam{ChangeID} not found in database!",
            Comment => 'Please contact the admin.',
        );
    }

    # get valid list
    my %ValidList = $Self->{ValidObject}->ValidList();

    # get all expression ids for the given condition id
    my $ExpressionIDsRef = $Self->{ConditionObject}->ExpressionList(
        ConditionID => $GetParam{ConditionID},
        UserID      => $Self->{UserID},
    );

    # ------------------------------------------------------------ #
    # condition save (also add expression / add action)
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'Save' ) {

        # if this is a new condition
        if ( $GetParam{ConditionID} eq 'NEW' ) {

            # create a new condition
            $GetParam{ConditionID} = $Self->{ConditionObject}->ConditionAdd(
                ChangeID              => $GetParam{ChangeID},
                Name                  => $GetParam{Name},
                ExpressionConjunction => $GetParam{ExpressionConjunction},
                Comment               => $GetParam{Comment},
                ValidID               => $GetParam{ValidID},
                UserID                => $Self->{UserID},
            );

            # check error
            if ( !$GetParam{ConditionID} ) {
                $Self->{LayoutObject}->ErrorScreen(
                    Message => 'Could not create new condition!',
                    Comment => 'Please contact the admin.',
                );
                return;
            }
        }

        # update an existing condition
        else {

            # update the condition
            my $Success = $Self->{ConditionObject}->ConditionUpdate(
                ConditionID           => $GetParam{ConditionID},
                Name                  => $GetParam{Name},
                ExpressionConjunction => $GetParam{ExpressionConjunction},
                Comment               => $GetParam{Comment},
                ValidID               => $GetParam{ValidID},
                UserID                => $Self->{UserID},
            );

            # check error
            if ( !$Success ) {
                $Self->{LayoutObject}->ErrorScreen(
                    Message => "Could not update ConditionID $GetParam{ConditionID}!",
                    Comment => 'Please contact the admin.',
                );
                return;
            }
        }

        # save all existing expression fields
        for my $ExpressionID ( @{$ExpressionIDsRef} ) {

            # get expression fields
            my %ExpressionData;
            for my $Field (qw(ObjectID Selector AttributeID OperatorID CompareValue)) {
                $ExpressionData{$Field} = $Self->{ParamObject}->GetParam(
                    Param => 'ExpressionID::' . $ExpressionID . '::' . $Field,
                );
            }

            # check if existing expression is complete
            # (all required fields must be filled, CompareValue can be empty)
            my $FieldsOk = 1;
            FIELD:
            for my $Field (qw(ObjectID Selector AttributeID OperatorID)) {

                # new expression is not complete
                if ( !$ExpressionData{$Field} ) {
                    $FieldsOk = 0;
                    last FIELD;
                }
            }

            # update existing expression only if all fields are complete
            if ($FieldsOk) {

                # update the expression
                my $Success = $Self->{ConditionObject}->ExpressionUpdate(
                    ExpressionID => $ExpressionID,
                    ObjectID     => $ExpressionData{ObjectID},
                    AttributeID  => $ExpressionData{AttributeID},
                    OperatorID   => $ExpressionData{OperatorID},
                    Selector     => $ExpressionData{Selector},
                    CompareValue => $ExpressionData{CompareValue} || '',
                    UserID       => $Self->{UserID},
                );

                # check error
                if ( !$Success ) {
                    return $Self->{LayoutObject}->ErrorScreen(
                        Message => "Could not update ExpressionID $ExpressionID!",
                        Comment => 'Please contact the admin.',
                    );
                }
            }
        }

        # get new expression fields
        my %ExpressionData;
        for my $Field (qw(ObjectID Selector AttributeID OperatorID CompareValue)) {
            $ExpressionData{$Field} = $Self->{ParamObject}->GetParam(
                Param => 'ExpressionID::NEW::' . $Field,
            );
        }

        # check if new expression is complete
        # (all required fields must be filled, CompareValue can be empty)
        my $FieldsOk = 1;
        FIELD:
        for my $Field (qw(ObjectID Selector AttributeID OperatorID)) {

            # new expression is not complete
            if ( !$ExpressionData{$Field} ) {
                $FieldsOk = 0;
                last FIELD;
            }
        }

        # add new expression
        if ($FieldsOk) {

            # add new expression
            my $ExpressionID = $Self->{ConditionObject}->ExpressionAdd(
                ConditionID  => $GetParam{ConditionID},
                ObjectID     => $ExpressionData{ObjectID},
                AttributeID  => $ExpressionData{AttributeID},
                OperatorID   => $ExpressionData{OperatorID},
                Selector     => $ExpressionData{Selector},
                CompareValue => $ExpressionData{CompareValue} || '',
                UserID       => $Self->{UserID},
            );

            # check error
            if ( !$ExpressionID ) {
                return $Self->{LayoutObject}->ErrorScreen(
                    Message => "Could not add new Expression!",
                    Comment => 'Please contact the admin.',
                );
            }
        }

        # TODO
        # save all action fields

        # if just the save button was pressed, redirect to condition overview
        if ( $GetParam{Save} ) {
            return $Self->{LayoutObject}->Redirect(
                OP => "Action=AgentITSMChangeCondition;ChangeID=$GetParam{ChangeID}",
            );
        }

        # if expression add button was pressed
        elsif ( $GetParam{AddExpression} ) {

            # show the edit view again, but now with a new empty expression line
            return $Self->{LayoutObject}->Redirect(
                OP => "Action=AgentITSMChangeConditionEdit;ChangeID=$GetParam{ChangeID};"
                    . "ConditionID=$GetParam{ConditionID};NewExpression=1",
            );
        }

        # if action add button was pressed
        elsif ( $GetParam{AddAction} ) {

        }

        # check if an expression should be deleted
        for my $ExpressionID ( @{$ExpressionIDsRef} ) {
            if ( $Self->{ParamObject}->GetParam( Param => 'DeleteExpressionID::' . $ExpressionID ) )
            {

                # delete the expression
                my $Success = $Self->{ConditionObject}->ExpressionDelete(
                    ExpressionID => $ExpressionID,
                    UserID       => $Self->{UserID},
                );

                # check error
                if ( !$Success ) {
                    return $Self->{LayoutObject}->ErrorScreen(
                        Message => "Could not delete ExpressionID $ExpressionID!",
                        Comment => 'Please contact the admin.',
                    );
                }

                # show the edit view again
                return $Self->{LayoutObject}->Redirect(
                    OP => "Action=AgentITSMChangeConditionEdit;ChangeID=$GetParam{ChangeID};"
                        . "ConditionID=$GetParam{ConditionID}",
                );
            }
        }

        # show the edit view again
        return $Self->{LayoutObject}->Redirect(
            OP => "Action=AgentITSMChangeConditionEdit;ChangeID=$GetParam{ChangeID};"
                . "ConditionID=$GetParam{ConditionID}",
        );
    }

    # handle AJAXUpdate
    elsif ( $Self->{Subaction} eq 'AJAXUpdate' ) {

        # any expression field was changed
        if ( $GetParam{ElementChanged} =~ m{ \A ExpressionID :: ( \d+ | NEW ) }xms ) {

            # get expression id
            my $ExpressionID = $1;

            # get expression fields
            for my $Field (qw(ObjectID Selector AttributeID OperatorID CompareValue)) {
                $GetParam{$Field} = $Self->{ParamObject}->GetParam(
                    Param => 'ExpressionID::' . $ExpressionID . '::' . $Field,
                );
            }

            # get object selection list
            my $ObjectList = $Self->_GetObjectSelection();

            # get selector selection list
            my $SelectorList = $Self->_GetSelectorSelection(
                ObjectID    => $GetParam{ObjectID},
                ConditionID => $GetParam{ConditionID},
            );

            # get attribute selection list
            my $AttributeList = $Self->_GetAttributeSelection(
                ObjectID => $GetParam{ObjectID},
                Selector => $GetParam{Selector},
            );

            # get operator selection list
            my $OperatorList = $Self->_GetOperatorSelection(
                ObjectID    => $GetParam{ObjectID},
                AttributeID => $GetParam{AttributeID},
            );

            # add an empty selector selection if no list is available or nothing is selected
            my $PossibleNoneSelector = 0;
            if (
                !$SelectorList
                || !ref $SelectorList eq 'HASH'
                || !%{$SelectorList}
                || $GetParam{ElementChanged} eq 'ExpressionID::' . $ExpressionID . '::ObjectID'
                )
            {
                $PossibleNoneSelector = 1;
            }

            # add an empty attribute selection if no list is available or nothing is selected
            my $PossibleNoneAttributeID = 0;
            if (
                !$AttributeList
                || !ref $AttributeList eq 'HASH'
                || !%{$AttributeList}
                || $GetParam{ElementChanged} eq 'ExpressionID::' . $ExpressionID . '::ObjectID'
                || $GetParam{ElementChanged} eq 'ExpressionID::' . $ExpressionID . '::Selector'
                )
            {
                $PossibleNoneAttributeID = 1;
            }

            # add an empty operator selection if no list is available or nothing is selected
            my $PossibleNoneOperatorID = 0;
            if (
                !$OperatorList
                || !ref $OperatorList eq 'HASH'
                || !%{$OperatorList}
                || $GetParam{ElementChanged} eq 'ExpressionID::' . $ExpressionID . '::ObjectID'
                || $GetParam{ElementChanged} eq 'ExpressionID::' . $ExpressionID . '::Selector'
                || $GetParam{ElementChanged} eq 'ExpressionID::' . $ExpressionID . '::AttributeID'
                )
            {
                $PossibleNoneOperatorID = 1;
            }

            # delete all following lists, but do not delete the directly following list
            if ( $GetParam{ElementChanged} eq 'ExpressionID::' . $ExpressionID . '::ObjectID' ) {
                $AttributeList = {};
                $OperatorList  = {};

                #            $CompareValueList = {};
            }
            elsif ( $GetParam{ElementChanged} eq 'ExpressionID::' . $ExpressionID . '::Selector' ) {
                $OperatorList = {};

                #            $CompareValueList = {};
            }
            elsif (
                $GetParam{ElementChanged} eq 'ExpressionID::' . $ExpressionID . '::AttributeID'
                )
            {

                #            $CompareValueList = {};
            }

            # build json
            my $JSON = $Self->{LayoutObject}->BuildJSON(
                [
                    {
                        Name         => 'ExpressionID::' . $ExpressionID . '::ObjectID',
                        Data         => $ObjectList,
                        SelectedID   => $GetParam{ObjectID},
                        PossibleNone => 0,
                        Translation  => 1,
                        Max          => 100,
                    },
                    {
                        Name         => 'ExpressionID::' . $ExpressionID . '::Selector',
                        Data         => $SelectorList,
                        SelectedID   => $PossibleNoneSelector ? '' : $GetParam{Selector},
                        PossibleNone => $PossibleNoneSelector,
                        Translation  => 1,
                        Max          => 100,
                    },
                    {
                        Name         => 'ExpressionID::' . $ExpressionID . '::AttributeID',
                        Data         => $AttributeList,
                        SelectedID   => $PossibleNoneAttributeID ? '' : $GetParam{AttributeID},
                        PossibleNone => $PossibleNoneAttributeID,
                        Translation  => 1,
                        Max          => 100,
                    },
                    {
                        Name         => 'ExpressionID::' . $ExpressionID . '::OperatorID',
                        Data         => $OperatorList,
                        SelectedID   => $PossibleNoneOperatorID ? '' : $GetParam{OperatorID},
                        PossibleNone => $PossibleNoneOperatorID,
                        Translation  => 1,
                        Max          => 100,
                    },
                ],
            );
        }

        # any action field was changed
        elsif ( $GetParam{ElementChanged} =~ m{ \A ActionID :: ( \d+ | NEW ) }xms ) {

            # get action id
            my $ActionID = $1;

            # TODO Add AJAX stuff for actions here...

            my $JSON = $Self->{LayoutObject}->BuildJSON(
                [

                   #                    {
                   #                        Name         => 'ActionID::' . $ActionID . '::ObjectID',
                   #                        Data         => $ObjectList,
                   #                        SelectedID   => $GetParam{ObjectID},
                   #                        PossibleNone => 0,
                   #                        Translation  => 1,
                   #                        Max          => 100,
                   #                    },
                ],
            );
        }

        # return json
        return $Self->{LayoutObject}->Attachment(
            ContentType => 'text/plain; charset=' . $Self->{LayoutObject}->{Charset},
            Content     => $JSON,
            Type        => 'inline',
            NoCache     => 1,
        );
    }

    # ------------------------------------------------------------ #
    # condition edit view
    # ------------------------------------------------------------ #
    elsif ( !$Self->{Subaction} ) {

        my %ConditionData;

        # get ConditionID
        $ConditionData{ConditionID} = $GetParam{ConditionID};

        # if this is an existing condition
        if ( $ConditionData{ConditionID} ne 'NEW' ) {

            # get condition data
            my $Condition = $Self->{ConditionObject}->ConditionGet(
                ConditionID => $ConditionData{ConditionID},
                UserID      => $Self->{UserID},
            );

            # check if the condition belongs to the given change
            if ( $Condition->{ChangeID} ne $GetParam{ChangeID} ) {
                return $Self->{LayoutObject}->ErrorScreen(
                    Message => "ConditionID $ConditionData{ConditionID} belongs to "
                        . " ChangeID $Condition->{ChangeID} and not to the given $GetParam{ChangeID}!",
                    Comment => 'Please contact the admin.',
                );
            }

            # add data from condition
            %ConditionData = ( %ConditionData, %{$Condition} );

            # show existing expressions
            $Self->_ExpressionOverview(
                %ConditionData,
                ExpressionIDs => $ExpressionIDsRef,
                NewExpression => $GetParam{NewExpression},
            );

            # TODO
            # show existing actions
            #$Self->_ShowActionOverview(
            #    %ConditionData,
            #);

        }

        # output header
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();

        # generate ValidOptionString
        $ConditionData{ValidOptionString} = $Self->{LayoutObject}->BuildSelection(
            Data       => \%ValidList,
            Name       => 'ValidID',
            SelectedID => $ConditionData{ValidID} || ( $Self->{ValidObject}->ValidIDsGet() )[0],
            Sort       => 'NumericKey',
        );

        # generate output
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AgentITSMChangeConditionEdit',
            Data         => {
                %Param,
                %{$ChangeData},
                %ConditionData,
            },
        );
        $Output .= $Self->{LayoutObject}->Footer();

        return $Output;
    }
}

# show existing expressions
sub _ExpressionOverview {
    my ( $Self, %Param ) = @_;

    return if !$Param{ExpressionIDs};
    return if ref $Param{ExpressionIDs} ne 'ARRAY';

    my @ExpressionIDs = @{ $Param{ExpressionIDs} };

    # also show a new empty expression line
    if ( $Param{NewExpression} ) {
        push @ExpressionIDs, 'NEW';
    }

    return if !@ExpressionIDs;

    EXPRESSIONID:
    for my $ExpressionID ( sort { $a cmp $b } @ExpressionIDs ) {

        # to store the date of an expression
        my $ExpressionData = {};

        # set expression id to 'NEW' for further function calls
        if ( $ExpressionID eq 'NEW' ) {
            $ExpressionData->{ExpressionID} = $ExpressionID;
        }

        # get data for an existing expression
        else {

            # get condition data
            $ExpressionData = $Self->{ConditionObject}->ExpressionGet(
                ExpressionID => $ExpressionID,
                UserID       => $Self->{UserID},
            );

            next EXPRESSIONID if !$ExpressionData;
        }

        # output overview row
        $Self->{LayoutObject}->Block(
            Name => 'ExpressionOverviewRow',
            Data => {
                %{$ExpressionData},
            },
        );

        # show object selection
        $Self->_ShowObjectSelection(
            %{$ExpressionData},
        );

        # show selecor selection
        $Self->_ShowSelectorSelection(
            %{$ExpressionData},
        );

        # show attribute selection
        $Self->_ShowAttributeSelection(
            %{$ExpressionData},
        );

        # show operator selection
        $Self->_ShowOperatorSelection(
            %{$ExpressionData},
        );

        # show compare value field
        $Self->_ShowCompareValueField(
            %{$ExpressionData},
        );
    }

    return 1;
}

# show object dropdown field
sub _ShowObjectSelection {
    my ( $Self, %Param ) = @_;

    # get object selection list
    my $ObjectList = $Self->_GetObjectSelection(%Param);

    # add an empty selection if no list is available or nothing is selected
    my $PossibleNone = 0;
    if (
        !$ObjectList
        || !ref $ObjectList eq 'HASH'
        || !%{$ObjectList}
        || !$Param{ObjectID}
        )
    {
        $PossibleNone = 1;
    }

    # generate ObjectOptionString
    my $ObjectOptionString = $Self->{LayoutObject}->BuildSelection(
        Data         => $ObjectList,
        Name         => 'ExpressionID::' . $Param{ExpressionID} . '::ObjectID',
        SelectedID   => $Param{ObjectID},
        PossibleNone => $PossibleNone,
        Ajax         => {
            Update => [
                'ExpressionID::' . $Param{ExpressionID} . '::ObjectID',
                'ExpressionID::' . $Param{ExpressionID} . '::Selector',
                'ExpressionID::' . $Param{ExpressionID} . '::AttributeID',
                'ExpressionID::' . $Param{ExpressionID} . '::OperatorID',
                'ExpressionID::' . $Param{ExpressionID} . '::CompareValue',
            ],
            Depend => [
                'ChangeID',
                'ConditionID',
                'ExpressionID::' . $Param{ExpressionID} . '::ObjectID',
            ],
            Subaction => 'AJAXUpdate',
        },
    );

    # remove AJAX-Loading images in selection field to avoid jitter effect
    $ObjectOptionString =~ s{ <a [ ] id="AJAXImage [^<>]+ "></a> }{}xmsg;

    # output object selection
    $Self->{LayoutObject}->Block(
        Name => 'ExpressionOverviewRowElementObject',
        Data => {
            ObjectOptionString => $ObjectOptionString,
        },
    );

    return 1;
}

# show selector dropdown field
sub _ShowSelectorSelection {
    my ( $Self, %Param ) = @_;

    # get selector selection list
    my $SelectorList = $Self->_GetSelectorSelection(%Param);

    # add an empty selection if no list is available or nothing is selected
    my $PossibleNone = 0;
    if (
        !$SelectorList
        || !ref $SelectorList eq 'HASH'
        || !%{$SelectorList}
        || !$Param{Selector}
        )
    {
        $PossibleNone = 1;
    }

    # generate SelectorOptionString
    my $SelectorOptionString = $Self->{LayoutObject}->BuildSelection(
        Data         => $SelectorList,
        Name         => 'ExpressionID::' . $Param{ExpressionID} . '::Selector',
        SelectedID   => $Param{Selector},
        PossibleNone => $PossibleNone,
        Ajax         => {
            Update => [
                'ExpressionID::' . $Param{ExpressionID} . '::Selector',
                'ExpressionID::' . $Param{ExpressionID} . '::AttributeID',
                'ExpressionID::' . $Param{ExpressionID} . '::OperatorID',
                'ExpressionID::' . $Param{ExpressionID} . '::CompareValue',
            ],
            Depend => [
                'ChangeID',
                'ConditionID',
                'ExpressionID::' . $Param{ExpressionID} . '::ObjectID',
                'ExpressionID::' . $Param{ExpressionID} . '::Selector',
            ],
            Subaction => 'AJAXUpdate',
        },
    );

    # remove AJAX-Loading images in selection field to avoid jitter effect
    $SelectorOptionString =~ s{ <a [ ] id="AJAXImage [^<>]+ "></a> }{}xmsg;

    # output selector selection
    $Self->{LayoutObject}->Block(
        Name => 'ExpressionOverviewRowElementSelector',
        Data => {
            SelectorOptionString => $SelectorOptionString,
        },
    );

    return 1;
}

# show attribute dropdown field
sub _ShowAttributeSelection {
    my ( $Self, %Param ) = @_;

    # get attribute selection list
    my $AttributeList = $Self->_GetAttributeSelection(%Param);

    # add an empty selection if no list is available or nothing is selected
    my $PossibleNone = 0;
    if (
        !$AttributeList
        || !ref $AttributeList eq 'HASH'
        || !%{$AttributeList}
        || !$Param{AttributeID}
        )
    {
        $PossibleNone = 1;
    }

    # generate AttributeOptionString
    my $AttributeOptionString = $Self->{LayoutObject}->BuildSelection(
        Data         => $AttributeList,
        Name         => 'ExpressionID::' . $Param{ExpressionID} . '::AttributeID',
        SelectedID   => $Param{AttributeID},
        PossibleNone => $PossibleNone,
        Ajax         => {
            Update => [
                'ExpressionID::' . $Param{ExpressionID} . '::AttributeID',
                'ExpressionID::' . $Param{ExpressionID} . '::OperatorID',
                'ExpressionID::' . $Param{ExpressionID} . '::CompareValue',
            ],
            Depend => [
                'ChangeID',
                'ConditionID',
                'ExpressionID::' . $Param{ExpressionID} . '::ObjectID',
                'ExpressionID::' . $Param{ExpressionID} . '::Selector',
                'ExpressionID::' . $Param{ExpressionID} . '::AttributeID',
            ],
            Subaction => 'AJAXUpdate',
        },
    );

    # remove AJAX-Loading images in date selection fields to avoid jitter effect
    $AttributeOptionString =~ s{ <a [ ] id="AJAXImage [^<>]+ "></a> }{}xmsg;

    # output attribute selection
    $Self->{LayoutObject}->Block(
        Name => 'ExpressionOverviewRowElementAttribute',
        Data => {
            AttributeOptionString => $AttributeOptionString,
        },
    );

    return 1;
}

# show operator dropdown field
sub _ShowOperatorSelection {
    my ( $Self, %Param ) = @_;

    # get operator selection list
    my $OperatorList = $Self->_GetOperatorSelection(%Param);

    # add an empty selection if no list is available or nothing is selected
    my $PossibleNone = 0;
    if (
        !$OperatorList
        || !ref $OperatorList eq 'HASH'
        || !%{$OperatorList}
        || !$Param{OperatorID}
        )
    {
        $PossibleNone = 1;
    }

    # generate OperatorOptionString
    my $OperatorOptionString = $Self->{LayoutObject}->BuildSelection(
        Data         => $OperatorList,
        Name         => 'ExpressionID::' . $Param{ExpressionID} . '::OperatorID',
        SelectedID   => $Param{OperatorID},
        PossibleNone => $PossibleNone,
        Ajax         => {
            Update => [
                'ExpressionID::' . $Param{ExpressionID} . '::OperatorID',
                'ExpressionID::' . $Param{ExpressionID} . '::CompareValue',
            ],
            Depend => [
                'ChangeID',
                'ConditionID',
                'ExpressionID::' . $Param{ExpressionID} . '::ObjectID',
                'ExpressionID::' . $Param{ExpressionID} . '::Selector',
                'ExpressionID::' . $Param{ExpressionID} . '::AttributeID',
                'ExpressionID::' . $Param{ExpressionID} . '::OperatorID',
            ],
            Subaction => 'AJAXUpdate',
        },
    );

    # remove AJAX-Loading images in selection field to avoid jitter effect
    $OperatorOptionString =~ s{ <a [ ] id="AJAXImage [^<>]+ "></a> }{}xmsg;

    # output operator selection
    $Self->{LayoutObject}->Block(
        Name => 'ExpressionOverviewRowElementOperator',
        Data => {
            OperatorOptionString => $OperatorOptionString,
        },
    );

    return 1;
}

# show compare value field
sub _ShowCompareValueField {
    my ( $Self, %Param ) = @_;

    # set default field type
    my $FieldType = 'Selection';

    # if an operator is set
    if ( $Param{OperatorID} ) {

        # lookup attribute name
        $Param{AttributeName} = $Self->{ConditionObject}->AttributeLookup(
            AttributeID => $Param{AttributeID},
        );

        # check error
        if ( !$Param{AttributeName} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "AttributeID $Param{AttributeID} does not exist!",
            );
            return;
        }

        # get the field type
        $FieldType = $Self->{ConditionObject}->ConditionCompareValueFieldType(
            ObjectID    => $Param{ObjectID},
            AttributeID => $Param{AttributeID},
            UserID      => $Self->{UserID},
        );

        return if !$FieldType;
    }

    # TODO: Build date selection based on type: Date.
    # Temporarily display Dates as text.
    if ( $FieldType eq 'Date' ) {
        $FieldType = 'Text';
    }

    # compare value is a text field
    if ( $FieldType eq 'Text' ) {
        $Self->{LayoutObject}->Block(
            Name => 'ExpressionOverviewRowElementCompareValueText',
            Data => {
                %Param,
            },
        );
    }

    # compare value is a selection field
    elsif ( $FieldType eq 'Selection' ) {

        # get compare value selection list
        my $CompareValueOptionString = $Self->_GetCompareValueSelection(
            %Param,
        );

        # output selection
        $Self->{LayoutObject}->Block(
            Name => 'ExpressionOverviewRowElementCompareValueSelection',
            Data => {
                CompareValueOptionString => $CompareValueOptionString,
            },
        );
    }

    # compare value is a date field
    elsif ( $FieldType eq 'Date' ) {

        # TODO : Implement date selection later!
    }

    # compare value is an autocomplete field
    elsif ( $FieldType eq 'Autocomplete' ) {

        # TODO : Implement autocomplete selection later!
    }

    # error if field type is unknown
    else {

        # TODO : Error message
        return;
    }

    return 1;
}

# get object dropdown field data
sub _GetObjectSelection {
    my ( $Self, %Param ) = @_;

    # get object list
    my $ObjectList = $Self->{ConditionObject}->ObjectList(
        UserID => $Self->{UserID},
    );

    return $ObjectList;
}

# get selector dropdown field data
sub _GetSelectorSelection {
    my ( $Self, %Param ) = @_;

    my $SelectorList = {};

    # if an object is set
    if ( $Param{ObjectID} ) {

        # get selector list
        $SelectorList = $Self->{ConditionObject}->ObjectSelectorList(
            ObjectID    => $Param{ObjectID},
            ConditionID => $Param{ConditionID},
            UserID      => $Self->{UserID},
        );
    }

    return $SelectorList;
}

# get attribute selection list data
sub _GetAttributeSelection {
    my ( $Self, %Param ) = @_;

    # to store the attriutes
    my %Attributes;

    # if a selector is set
    if ( $Param{Selector} ) {

        # get list of all attribute
        my $AllAttributes = $Self->{ConditionObject}->AttributeList(
            UserID => $Self->{UserID},
        );

        # lookup object name
        my $ObjectName = $Self->{ConditionObject}->ObjectLookup(
            ObjectID => $Param{ObjectID},
        );

        # check error
        if ( !$ObjectName ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "ObjectID $Param{ObjectID} does not exist!",
            );
            return;
        }

        # get object attribute mapping from sysconfig
        my $ObjectAttributeMapping
            = $Self->{ConfigObject}->Get( $ObjectName . '::Mapping::Object::Attribute' );

        # get the valid attributes for the given object
        ATTRIBUTEID:
        for my $AttributeID ( keys %{$AllAttributes} ) {
            next ATTRIBUTEID if !$ObjectAttributeMapping->{ $AllAttributes->{$AttributeID} };
            $Attributes{$AttributeID} = $AllAttributes->{$AttributeID};
        }

        # remove 'ID' at the end of the attribute name for nicer display
        for my $Attribute ( values %Attributes ) {
            $Attribute =~ s{ ID \z }{}xms;
        }
    }

    return \%Attributes;
}

# get operator list data
sub _GetOperatorSelection {
    my ( $Self, %Param ) = @_;

    # to store the operators
    my %Operators;

    # if an atribute is set
    if ( $Param{AttributeID} ) {

        # lookup object name
        my $ObjectName = $Self->{ConditionObject}->ObjectLookup(
            ObjectID => $Param{ObjectID},
        );

        # check error
        if ( !$ObjectName ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "ObjectID $Param{ObjectID} does not exist!",
            );
            return;
        }

        # lookup attribute name
        my $AttributeName = $Self->{ConditionObject}->AttributeLookup(
            AttributeID => $Param{AttributeID},
        );

        # check error
        if ( !$AttributeName ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "AttributeID $Param{AttributeID} does not exist!",
            );
            return;
        }

        # get list of all operators
        my $AllOperators = $Self->{ConditionObject}->OperatorList(
            UserID => $Self->{UserID},
        );

        # get attribute operator mapping from sysconfig
        my $AttributeOperatorMapping;
        if ( $Self->{ConfigObject}->Get( $ObjectName . '::Mapping::Attribute::Operator' ) ) {
            $AttributeOperatorMapping
                = $Self->{ConfigObject}->Get( $ObjectName . '::Mapping::Attribute::Operator' )
                ->{$AttributeName} || {};
        }

        # get allowed operators for the given attribute
        OPERATORID:
        for my $OperatorID ( keys %{$AllOperators} ) {

            # get operator name
            my $OperatorName = $AllOperators->{$OperatorID};

            # check if operator is allowed for this attribute
            next OPERATORID if !$AttributeOperatorMapping->{$OperatorName};

            # remember the operator
            $Operators{$OperatorID} = $OperatorName;
        }
    }

    return \%Operators;
}

# get compare value list
sub _GetCompareValueSelection {
    my ( $Self, %Param ) = @_;

    # to store the compare value list
    my $CompareValueList = {};

    # if an operator is set
    if ( $Param{OperatorID} ) {

        # get compare value list
        $CompareValueList = $Self->{ConditionObject}->ObjectCompareValueList(
            ObjectID      => $Param{ObjectID},
            AttributeName => $Param{AttributeName},
            UserID        => $Self->{UserID},
        );
    }

    # add an empty selection if no list is available or nothing is selected
    my $PossibleNone = 0;
    if (
        !$Param{CompareValue}
        || !$CompareValueList
        || ( ref $CompareValueList eq 'HASH'  && !%{$CompareValueList} )
        || ( ref $CompareValueList eq 'ARRAY' && !@{$CompareValueList} )
        )
    {
        $PossibleNone = 1;
    }

    # generate CompareValueOptionString
    my $CompareValueOptionString = $Self->{LayoutObject}->BuildSelection(
        Data         => $CompareValueList,
        Name         => 'ExpressionID::' . $Param{ExpressionID} . '::CompareValue',
        SelectedID   => $Param{CompareValue},
        PossibleNone => $PossibleNone,
    );

    # remove AJAX-Loading images in selection field to avoid jitter effect
    $CompareValueOptionString =~ s{ <a [ ] id="AJAXImage [^<>]+ "></a> }{}xmsg;

    return $CompareValueOptionString;
}

1;
