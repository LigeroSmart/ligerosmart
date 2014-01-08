# --
# Kernel/Modules/AgentITSMChangeConditionEdit.pm - the OTRS ITSM ChangeManagement condition edit module
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
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

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check needed objects
    for my $Object (
        qw(ConfigObject ParamObject DBObject LayoutObject LogObject UserObject GroupObject)
        )
    {
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
        ChangeID ConditionID Name Comment ExpressionConjunction ValidID DeleteExpressionID DeleteActionID
        Save AddAction AddExpression NewExpression NewAction ElementChanged UpdateDivName)
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
        Action   => $Self->{Action},
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
            Message => "Change '$GetParam{ChangeID}' not found in database!",
            Comment => 'Please contact the admin.',
        );
    }

    # get valid list
    my %ValidList = $Self->{ValidObject}->ValidList();

    my $ExpressionIDsRef = [];
    my $ActionIDsRef     = [];

    # only get expression list and action list if condition exists already
    if ( $GetParam{ConditionID} ne 'NEW' ) {

        # get all expression ids for the given condition id
        $ExpressionIDsRef = $Self->{ConditionObject}->ExpressionList(
            ConditionID => $GetParam{ConditionID},
            UserID      => $Self->{UserID},
        );

        # get all action ids for the given condition id
        $ActionIDsRef = $Self->{ConditionObject}->ActionList(
            ConditionID => $GetParam{ConditionID},
            UserID      => $Self->{UserID},
        );
    }

    # Remember the reason why saving was not attempted.
    # These entries are the names of the dtl validation error blocks.
    my @ValidationErrors;

    # ---------------------------------------------------------------- #
    # condition save (also add/delete expression and add/delete action)
    # ---------------------------------------------------------------- #
    if ( $Self->{Subaction} eq 'Save' ) {

        # update only if ConditionName is given
        if ( !$GetParam{Name} ) {
            $Param{InvalidName} = 'ServerError';
            push @ValidationErrors, 'InvalidName';
        }

        # check if condition name is already used
        else {

            # check if condition name exists already for this change
            my $ConditionID = $Self->{ConditionObject}->ConditionLookup(
                Name     => $GetParam{Name},
                ChangeID => $GetParam{ChangeID},
            );

            # it is only an error if another condition of this change uses this name
            # changing the name of a condition is still possible
            if ( $ConditionID && ( $GetParam{ConditionID} ne $ConditionID ) ) {
                $Param{DuplicateName} = 'ServerError';
                push @ValidationErrors, 'DuplicateName';
            }
        }

        # if all passed data is valid
        if ( !@ValidationErrors ) {

            # add a new condition
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
                        Param => 'ExpressionID-' . $ExpressionID . '-' . $Field,
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
                        CompareValue => defined $ExpressionData{CompareValue}
                        ? $ExpressionData{CompareValue}
                        : '',
                        UserID => $Self->{UserID},
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
                    Param => 'ExpressionID-NEW-' . $Field,
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
                    CompareValue => defined $ExpressionData{CompareValue}
                    ? $ExpressionData{CompareValue}
                    : '',
                    UserID => $Self->{UserID},
                );

                # check error
                if ( !$ExpressionID ) {
                    return $Self->{LayoutObject}->ErrorScreen(
                        Message => "Could not add new Expression!",
                        Comment => 'Please contact the admin.',
                    );
                }
            }

            # save all existing action fields
            for my $ActionID ( @{$ActionIDsRef} ) {

                # get action fields
                my %ActionData;
                for my $Field (qw(ObjectID Selector AttributeID OperatorID ActionValue)) {
                    $ActionData{$Field} = $Self->{ParamObject}->GetParam(
                        Param => 'ActionID-' . $ActionID . '-' . $Field,
                    );
                }

                # check if existing action is complete
                # (all required fields must be filled, ActionValue can be empty)
                my $FieldsOk = 1;
                FIELD:
                for my $Field (qw(ObjectID Selector AttributeID OperatorID)) {

                    # new action is not complete
                    if ( !$ActionData{$Field} ) {
                        $FieldsOk = 0;
                        last FIELD;
                    }
                }

                # update existing action only if all fields are complete
                if ($FieldsOk) {

                    # update the action
                    my $Success = $Self->{ConditionObject}->ActionUpdate(
                        ActionID    => $ActionID,
                        ObjectID    => $ActionData{ObjectID},
                        AttributeID => $ActionData{AttributeID},
                        OperatorID  => $ActionData{OperatorID},
                        Selector    => $ActionData{Selector},
                        ActionValue => $ActionData{ActionValue} || '',
                        UserID      => $Self->{UserID},
                    );

                    # check error
                    if ( !$Success ) {
                        return $Self->{LayoutObject}->ErrorScreen(
                            Message => "Could not update ActionID $ActionID!",
                            Comment => 'Please contact the admin.',
                        );
                    }
                }
            }

            # get new action fields
            my %ActionData;
            for my $Field (qw(ObjectID Selector AttributeID OperatorID ActionValue)) {
                $ActionData{$Field} = $Self->{ParamObject}->GetParam(
                    Param => 'ActionID-NEW-' . $Field,
                );
            }

            # check if new action is complete
            # (all required fields must be filled, ActionValue can be empty)
            $FieldsOk = 1;
            FIELD:
            for my $Field (qw(ObjectID Selector AttributeID OperatorID)) {

                # new action is not complete
                if ( !$ActionData{$Field} ) {
                    $FieldsOk = 0;
                    last FIELD;
                }
            }

            # add new action
            if ($FieldsOk) {

                # add new action
                my $ActionID = $Self->{ConditionObject}->ActionAdd(
                    ConditionID => $GetParam{ConditionID},
                    ObjectID    => $ActionData{ObjectID},
                    AttributeID => $ActionData{AttributeID},
                    OperatorID  => $ActionData{OperatorID},
                    Selector    => $ActionData{Selector},
                    ActionValue => $ActionData{ActionValue} || '',
                    UserID      => $Self->{UserID},
                );

                # check error
                if ( !$ActionID ) {
                    return $Self->{LayoutObject}->ErrorScreen(
                        Message => "Could not add new Action!",
                        Comment => 'Please contact the admin.',
                    );
                }
            }

            # just the save button was pressed, redirect to condition overview
            if ( $GetParam{Save} ) {
                return $Self->{LayoutObject}->Redirect(
                    OP => "Action=AgentITSMChangeCondition;ChangeID=$GetParam{ChangeID}",
                );
            }

            # expression add button was pressed
            elsif ( $GetParam{AddExpression} ) {

                # show the edit view again, but now with a new empty expression line
                return $Self->{LayoutObject}->Redirect(
                    OP => "Action=AgentITSMChangeConditionEdit;ChangeID=$GetParam{ChangeID};"
                        . "ConditionID=$GetParam{ConditionID};NewExpression=1",
                );
            }

            # action add button was pressed
            elsif ( $GetParam{AddAction} ) {

                # show the edit view again, but now with a new empty action line
                return $Self->{LayoutObject}->Redirect(
                    OP => "Action=AgentITSMChangeConditionEdit;ChangeID=$GetParam{ChangeID};"
                        . "ConditionID=$GetParam{ConditionID};NewAction=1",
                );
            }

            # check if an expression should be deleted
            if ( $GetParam{DeleteExpressionID} && $GetParam{DeleteExpressionID} ne 'NEW' ) {

                # delete the expression
                my $Success = $Self->{ConditionObject}->ExpressionDelete(
                    ExpressionID => $GetParam{DeleteExpressionID},
                    UserID       => $Self->{UserID},
                );

                # check error
                if ( !$Success ) {
                    return $Self->{LayoutObject}->ErrorScreen(
                        Message => "Could not delete ExpressionID $GetParam{DeleteExpressionID}!",
                        Comment => 'Please contact the admin.',
                    );
                }

                # show the edit view again
                return $Self->{LayoutObject}->Redirect(
                    OP => "Action=AgentITSMChangeConditionEdit;ChangeID=$GetParam{ChangeID};"
                        . "ConditionID=$GetParam{ConditionID}",
                );
            }

            # check if an action should be deleted
            if ( $GetParam{DeleteActionID} && $GetParam{DeleteActionID} ne 'NEW' ) {

                # delete the action
                my $Success = $Self->{ConditionObject}->ActionDelete(
                    ActionID => $GetParam{DeleteActionID},
                    UserID   => $Self->{UserID},
                );

                # check error
                if ( !$Success ) {
                    return $Self->{LayoutObject}->ErrorScreen(
                        Message => "Could not delete ActionID $GetParam{DeleteActionID}!",
                        Comment => 'Please contact the admin.',
                    );
                }

                # show the edit view again
                return $Self->{LayoutObject}->Redirect(
                    OP => "Action=AgentITSMChangeConditionEdit;ChangeID=$GetParam{ChangeID};"
                        . "ConditionID=$GetParam{ConditionID}",
                );
            }

            # show the edit view again
            return $Self->{LayoutObject}->Redirect(
                OP => "Action=AgentITSMChangeConditionEdit;ChangeID=$GetParam{ChangeID};"
                    . "ConditionID=$GetParam{ConditionID}",
            );
        }
    }

    # ------------------------------------------------------------ #
    # handle AJAXUpdate (change the content of dropdownlists)
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'AJAXUpdate' ) {

        # to store the JSON output
        my $JSON;

        # expression or action field was changed
        if ( $GetParam{ElementChanged} =~ m{ \A ( ExpressionID | ActionID ) - ( \d+ | NEW ) }xms )
        {

            # get id name of the involved element ( 'ExpressionID' or 'ActionID' )
            my $IDName = $1;

            # get id of the involved element
            my $ID = $2;

            # get value field name
            my $ValueFieldName;
            if ( $IDName eq 'ExpressionID' ) {
                $ValueFieldName = 'CompareValue';
            }
            elsif ( $IDName eq 'ActionID' ) {
                $ValueFieldName = 'ActionValue';
            }

            # get expression or action fields
            for my $Field (qw(ObjectID Selector AttributeID OperatorID CompareValue ActionValue)) {
                $GetParam{$Field} = $Self->{ParamObject}->GetParam(
                    Param => $IDName . '-' . $ID . '-' . $Field,
                );
            }

            # get object selection list
            my $ObjectList = $Self->_GetObjectSelection();

            # get selector selection list
            my $SelectorList = $Self->_GetSelectorSelection(
                ObjectID    => $GetParam{ObjectID},
                ConditionID => $GetParam{ConditionID},
                $IDName     => $ID,
            );

            # get attribute selection list
            my $AttributeList = $Self->_GetAttributeSelection(
                ObjectID => $GetParam{ObjectID},
                Selector => $GetParam{Selector},
                $IDName  => $ID,
            );

            # get operator selection list
            my $OperatorList = $Self->_GetOperatorSelection(
                ObjectID    => $GetParam{ObjectID},
                AttributeID => $GetParam{AttributeID},
                $IDName     => $ID,
            );

            # add an empty selector selection if no list is available or nothing is selected
            my $PossibleNoneSelector = 0;
            if (
                !$SelectorList
                || !ref $SelectorList eq 'HASH'
                || !%{$SelectorList}
                || $GetParam{ElementChanged} eq $IDName . '-' . $ID . '-ObjectID'
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
                || $GetParam{ElementChanged} eq $IDName . '-' . $ID . '-ObjectID'
                || $GetParam{ElementChanged} eq $IDName . '-' . $ID . '-Selector'
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
                || $GetParam{ElementChanged} eq $IDName . '-' . $ID . '-ObjectID'
                || $GetParam{ElementChanged} eq $IDName . '-' . $ID . '-Selector'
                || $GetParam{ElementChanged} eq $IDName . '-' . $ID . '-AttributeID'
                )
            {
                $PossibleNoneOperatorID = 1;
            }

            # if object was changed, reset the attribute and operator list
            if ( $GetParam{ElementChanged} eq $IDName . '-' . $ID . '-ObjectID' ) {
                $AttributeList = {};
                $OperatorList  = {};
            }

            # build json
            $JSON = $Self->{LayoutObject}->BuildSelectionJSON(
                [
                    {
                        Name         => $IDName . '-' . $ID . '-ObjectID',
                        Data         => $ObjectList,
                        SelectedID   => $GetParam{ObjectID},
                        PossibleNone => 0,
                        Translation  => 1,
                        Max          => 100,
                    },
                    {
                        Name         => $IDName . '-' . $ID . '-Selector',
                        Data         => $SelectorList,
                        SelectedID   => $PossibleNoneSelector ? '' : $GetParam{Selector},
                        PossibleNone => $PossibleNoneSelector,
                        Translation  => 1,
                        Max          => 100,
                    },
                    {
                        Name         => $IDName . '-' . $ID . '-AttributeID',
                        Data         => $AttributeList,
                        SelectedID   => $GetParam{AttributeID} || '',
                        PossibleNone => $PossibleNoneAttributeID,
                        Translation  => 1,
                        Max          => 100,
                    },
                    {
                        Name         => $IDName . '-' . $ID . '-OperatorID',
                        Data         => $OperatorList,
                        SelectedID   => $GetParam{OperatorID} || '',
                        PossibleNone => $PossibleNoneOperatorID,
                        Translation  => 1,
                        Max          => 100,
                    },
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

    # ------------------------------------------------------------------------------------- #
    # handle AJAXUpdate (replace the field type, e.g. replace a text field with a selection
    # ------------------------------------------------------------------------------------- #
    elsif ( $Self->{Subaction} eq 'AJAXContentUpdate' ) {

        # to store the HTML string which is returned to the browser
        my $HTMLString;

        # expression or action field was changed
        if ( $GetParam{ElementChanged} =~ m{ \A ( ExpressionID | ActionID ) \- ( \d+ | NEW ) }xms )
        {

            # get id name of the involved element ( 'ExpressionID' or 'ActionID' )
            my $IDName = $1;

            # get id of the involved element
            my $ID = $2;

            # get value field name
            my $ValueFieldName;
            if ( $IDName eq 'ExpressionID' ) {
                $ValueFieldName = 'CompareValue';
            }
            elsif ( $IDName eq 'ActionID' ) {
                $ValueFieldName = 'ActionValue';
            }

            # get expression or action fields
            for my $Field (qw(ObjectID Selector AttributeID OperatorID CompareValue ActionValue)) {
                $GetParam{$Field} = $Self->{ParamObject}->GetParam(
                    Param => $IDName . '-' . $ID . '-' . $Field,
                );
            }

            # get compare value field type
            my $FieldType = $Self->_GetCompareValueFieldType(%GetParam);

            # build CompareValue selection
            if ( $FieldType eq 'Selection' ) {

                # get compare value selection list
                my $CompareValueList = $Self->_GetCompareValueSelection(%GetParam);

                # add an empty selection if no list is available or nothing is selected
                my $PossibleNone = 0;
                if (
                    $Param{PossibleNone}
                    || !$Param{$ValueFieldName}
                    || !$CompareValueList
                    || ( ref $CompareValueList eq 'HASH'  && !%{$CompareValueList} )
                    || ( ref $CompareValueList eq 'ARRAY' && !@{$CompareValueList} )
                    )
                {
                    $PossibleNone = 1;
                }

                # generate ValueOptionString
                $HTMLString = $Self->{LayoutObject}->BuildSelection(
                    Data         => $CompareValueList,
                    Name         => $IDName . '-' . $ID . '-' . $ValueFieldName,
                    SelectedID   => $GetParam{$ValueFieldName},
                    PossibleNone => $PossibleNone,
                    Translation  => 1,
                );
            }

            # build text input field
            elsif ( $FieldType eq 'Text' ) {

                # build an empty input field
                $HTMLString = ''
                    . '<input type="text" '
                    . 'id="' . $IDName . '-' . $ID . '-' . $ValueFieldName . '" '
                    . 'name="' . $IDName . '-' . $ID . '-' . $ValueFieldName . '" '
                    . 'value="" clas="W75pc" maxlength="250" />';
            }

            # show error for unknown field type
            else {
                $HTMLString = "<span><b>Error: Unknown field type '$FieldType'!</b></span>";
            }
        }

        # return HTML
        return $Self->{LayoutObject}->Attachment(
            ContentType => 'text/html',
            Charset     => $Self->{LayoutObject}->{UserCharset},
            Content     => $HTMLString,
            Type        => 'inline',
            NoCache     => 1,
        );
    }

    # ------------------------------------------------------------ #
    # condition edit view
    # ------------------------------------------------------------ #

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
                Message => "ConditionID $ConditionData{ConditionID} does not belong to"
                    . " the given ChangeID $GetParam{ChangeID}!",
                Comment => 'Please contact the administrator.',
            );
        }

        # add data from condition
        %ConditionData = ( %ConditionData, %{$Condition} );

        # show existing expressions
        $Self->_ExpressionOverview(
            %{$ChangeData},
            %ConditionData,
            ExpressionIDs => $ExpressionIDsRef,
            NewExpression => $GetParam{NewExpression},
        );

        # show existing actions
        $Self->_ActionOverview(
            %{$ChangeData},
            %ConditionData,
            ActionIDs => $ActionIDsRef,
            NewAction => $GetParam{NewAction},
        );
    }
    else {
        $Self->{LayoutObject}->Block( Name => 'ExpressionOverviewRowNoData' );
        $Self->{LayoutObject}->Block( Name => 'ActionOverviewRowNoData' );
    }

    # get expression conjunction from condition
    if ( !$GetParam{ExpressionConjunction} ) {
        $GetParam{ExpressionConjunction} = $ConditionData{ExpressionConjunction} || '';
    }

    # set radio buttons for expression conjunction
    if ( $GetParam{ExpressionConjunction} eq 'all' ) {
        $ConditionData{allselected} = 'checked="checked"';
    }
    else {
        $ConditionData{anyselected} = 'checked="checked"';
    }

    # output header
    my $Output = $Self->{LayoutObject}->Header( Type => 'Small' );

    # generate ValidOptionString
    $ConditionData{ValidOptionString} = $Self->{LayoutObject}->BuildSelection(
        Data        => \%ValidList,
        Name        => 'ValidID',
        SelectedID  => $ConditionData{ValidID} || ( $Self->{ValidObject}->ValidIDsGet() )[0],
        Sort        => 'NumericKey',
        Translation => 1,
    );

    # add the validation error messages
    for my $BlockName (@ValidationErrors) {
        $Self->{LayoutObject}->Block(
            Name => $BlockName,
            Data => {
                %GetParam,
            },
        );
    }

    # generate output
    $Output .= $Self->{LayoutObject}->Output(
        TemplateFile => 'AgentITSMChangeConditionEdit',
        Data         => {
            %Param,
            %{$ChangeData},
            %ConditionData,
        },
    );
    $Output .= $Self->{LayoutObject}->Footer( Type => 'Small', );

    return $Output;
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

    if ( !@ExpressionIDs ) {
        $Self->{LayoutObject}->Block( Name => 'ExpressionOverviewRowNoData' );
        return;
    }

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
                %Param,
                %{$ExpressionData},
            },
        );

        # show object selection
        $Self->_ShowObjectSelection(
            %Param,
            %{$ExpressionData},
        );

        # show selecor selection
        $Self->_ShowSelectorSelection(
            %Param,
            %{$ExpressionData},
        );

        # show attribute selection
        $Self->_ShowAttributeSelection(
            %Param,
            %{$ExpressionData},
        );

        # show operator selection
        $Self->_ShowOperatorSelection(
            %Param,
            %{$ExpressionData},
        );

        # show compare value field
        $Self->_ShowCompareValueField(
            %Param,
            %{$ExpressionData},
        );
    }

    return 1;
}

# show existing actions
sub _ActionOverview {
    my ( $Self, %Param ) = @_;

    return if !$Param{ActionIDs};
    return if ref $Param{ActionIDs} ne 'ARRAY';

    my @ActionIDs = @{ $Param{ActionIDs} };

    # also show a new empty action line
    if ( $Param{NewAction} ) {
        push @ActionIDs, 'NEW';
    }

    if ( !@ActionIDs ) {
        $Self->{LayoutObject}->Block( Name => 'ActionOverviewRowNoData' );
        return;
    }

    ActionID:
    for my $ActionID ( sort { $a cmp $b } @ActionIDs ) {

        # to store the date of an action
        my $ActionData = {};

        # set action id to 'NEW' for further function calls
        if ( $ActionID eq 'NEW' ) {
            $ActionData->{ActionID} = $ActionID;
        }

        # get data for an existing action
        else {

            # get condition data
            $ActionData = $Self->{ConditionObject}->ActionGet(
                ActionID => $ActionID,
                UserID   => $Self->{UserID},
            );

            next ActionID if !$ActionData;
        }

        # output overview row
        $Self->{LayoutObject}->Block(
            Name => 'ActionOverviewRow',
            Data => {
                %Param,
                %{$ActionData},
            },
        );

        # show object selection
        $Self->_ShowObjectSelection(
            %Param,
            %{$ActionData},
        );

        # show selecor selection
        $Self->_ShowSelectorSelection(
            %Param,
            %{$ActionData},
        );

        # show attribute selection
        $Self->_ShowAttributeSelection(
            %Param,
            %{$ActionData},
        );

        # show operator selection
        $Self->_ShowOperatorSelection(
            %Param,
            %{$ActionData},
        );

        # show compare value field
        $Self->_ShowCompareValueField(
            %Param,
            %{$ActionData},
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

    # name of the div that should be updated
    my $UpdateDivName;

    # id name of the involved element ( 'ExpressionID' or 'ActionID' )
    my $IDName;

    # block name for the output layout block
    my $BlockName;

    # for expression elements
    if ( $Param{ExpressionID} ) {
        $UpdateDivName = "ExpressionID-$Param{ExpressionID}-CompareValue-Div";
        $IDName        = 'ExpressionID';
        $BlockName     = 'ExpressionOverviewRowElementObject';
    }

    # for action elements
    elsif ( $Param{ActionID} ) {
        $UpdateDivName = "ActionID-$Param{ActionID}-ActionValue-Div";
        $IDName        = 'ActionID';
        $BlockName     = 'ActionOverviewRowElementObject';
    }

    # parameters for ajax
    $Param{ObjectOptionName} = $IDName . '-' . $Param{$IDName} . '-ObjectID';
    $Param{IDName}           = $IDName;

    # generate ObjectOptionString
    my $ObjectOptionString = $Self->{LayoutObject}->BuildSelection(
        Data         => $ObjectList,
        Name         => $Param{ObjectOptionName},
        SelectedID   => $Param{ObjectID},
        PossibleNone => $PossibleNone,
        Translation  => 1,
    );

    # output object selection
    $Self->{LayoutObject}->Block(
        Name => $BlockName,
        Data => {
            %Param,
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

    # id name of the involved element ( 'ExpressionID' or 'ActionID' )
    my $IDName;

    # block name for the output layout block
    my $BlockName;

    # for expression elements
    if ( $Param{ExpressionID} ) {
        $IDName    = 'ExpressionID';
        $BlockName = 'ExpressionOverviewRowElementSelector';
    }

    # for action elements
    elsif ( $Param{ActionID} ) {
        $IDName    = 'ActionID';
        $BlockName = 'ActionOverviewRowElementSelector';
    }

    # parameters for ajax
    $Param{ObjectOptionName} = $IDName . '-' . $Param{$IDName} . '-Selector';
    $Param{IDName}           = $IDName;

    # generate SelectorOptionString
    my $SelectorOptionString = $Self->{LayoutObject}->BuildSelection(
        Data         => $SelectorList,
        Name         => $Param{ObjectOptionName},
        SelectedID   => $Param{Selector},
        PossibleNone => $PossibleNone,
        Translation  => 1,
    );

    # output selector selection
    $Self->{LayoutObject}->Block(
        Name => $BlockName,
        Data => {
            %Param,
            SelectorOptionString => $SelectorOptionString,
        },
    );

    return 1;
}

# show attribute dropdown field
sub _ShowAttributeSelection {
    my ( $Self, %Param ) = @_;

    # name of the div that should be updated
    my $UpdateDivName;

    # id name of the involved element ( 'ExpressionID' or 'ActionID' )
    my $IDName;

    # block name for the output layout block
    my $BlockName;

    # name of the value field ( CompareValue or ActionValue )
    my $ValueFieldName;

    # for expression elements
    if ( $Param{ExpressionID} ) {
        $UpdateDivName  = "ExpressionID-$Param{ExpressionID}-CompareValue-Div";
        $IDName         = 'ExpressionID';
        $BlockName      = 'ExpressionOverviewRowElementAttribute';
        $ValueFieldName = 'CompareValue';
    }

    # for action elements
    elsif ( $Param{ActionID} ) {
        $UpdateDivName  = "ActionID-$Param{ActionID}-ActionValue-Div";
        $IDName         = 'ActionID';
        $BlockName      = 'ActionOverviewRowElementAttribute';
        $ValueFieldName = 'ActionValue';
    }

    # get attribute selection list
    my $AttributeList = $Self->_GetAttributeSelection(
        ObjectID => $Param{ObjectID},
        Selector => $Param{Selector},
        $IDName  => $Param{$IDName},
    );

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

    # parameters for ajax
    $Param{ObjectOptionName} = $IDName . '-' . $Param{$IDName} . '-AttributeID';
    $Param{IDName}           = $IDName;

    # generate AttributeOptionString
    my $AttributeOptionString = $Self->{LayoutObject}->BuildSelection(
        Data         => $AttributeList,
        Name         => $Param{ObjectOptionName},
        SelectedID   => $Param{AttributeID},
        PossibleNone => $PossibleNone,
        Translation  => 1,
    );

    # output attribute selection
    $Self->{LayoutObject}->Block(
        Name => $BlockName,
        Data => {
            %Param,
            AttributeOptionString => $AttributeOptionString,
        },
    );

    return 1;
}

# show operator dropdown field
sub _ShowOperatorSelection {
    my ( $Self, %Param ) = @_;

    # id name of the involved element ( 'ExpressionID' or 'ActionID' )
    my $IDName;

    # block name for the output layout block
    my $BlockName;

    # for expression elements
    if ( $Param{ExpressionID} ) {
        $IDName    = 'ExpressionID';
        $BlockName = 'ExpressionOverviewRowElementOperator';
    }

    # for action elements
    elsif ( $Param{ActionID} ) {
        $IDName    = 'ActionID';
        $BlockName = 'ActionOverviewRowElementOperator';
    }

    # get operator selection list
    my $OperatorList = $Self->_GetOperatorSelection(
        ObjectID    => $Param{ObjectID},
        AttributeID => $Param{AttributeID},
        $IDName     => $Param{$IDName},
    );

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

    # parameters for ajax
    $Param{ObjectOptionName} = $IDName . '-' . $Param{$IDName} . '-OperatorID';
    $Param{IDName}           = $IDName;

    # generate OperatorOptionString
    my $OperatorOptionString = $Self->{LayoutObject}->BuildSelection(
        Data         => $OperatorList,
        Name         => $Param{ObjectOptionName},
        SelectedID   => $Param{OperatorID},
        PossibleNone => $PossibleNone,
        Translation  => 1,
    );

    # output operator selection
    $Self->{LayoutObject}->Block(
        Name => $BlockName,
        Data => {
            %Param,
            OperatorOptionString => $OperatorOptionString,
        },
    );

    return 1;
}

# show compare value field
sub _ShowCompareValueField {
    my ( $Self, %Param ) = @_;

    # get compare value field type
    my $FieldType = $Self->_GetCompareValueFieldType(%Param);

    # id name of the involved element ( 'ExpressionID' or 'ActionID' )
    my $IDName;

    # block names for the output layout block
    my $BlockNameText;
    my $BlockNameSelection;

    my $ValueFieldName;

    # for expression elements
    if ( $Param{ExpressionID} ) {
        $IDName             = 'ExpressionID';
        $BlockNameText      = 'ExpressionOverviewRowElementCompareValueText';
        $BlockNameSelection = 'ExpressionOverviewRowElementCompareValueSelection';
        $ValueFieldName     = 'CompareValue';
    }

    # for action elements
    elsif ( $Param{ActionID} ) {
        $IDName             = 'ActionID';
        $BlockNameText      = 'ActionOverviewRowElementActionValueText';
        $BlockNameSelection = 'ActionOverviewRowElementActionValueSelection';
        $ValueFieldName     = 'ActionValue';
    }

    # compare value is a text field
    if ( $FieldType eq 'Text' ) {
        $Self->{LayoutObject}->Block(
            Name => $BlockNameText,
            Data => {
                %Param,
            },
        );
    }

    # compare value is a selection field
    elsif ( $FieldType eq 'Selection' ) {

        # get compare value selection list
        my $CompareValueList = $Self->_GetCompareValueSelection(%Param);

        my $AttributeName;
        if ( $Param{AttributeID} ) {

            # lookup attribute name
            $AttributeName = $Self->{ConditionObject}->AttributeLookup(
                AttributeID => $Param{AttributeID},
            );
        }

        # add an empty selection if no list is available or nothing is selected
        # or the list is the workorder agent list
        my $PossibleNone = 0;
        if (
            $Param{PossibleNone}
            || !$Param{$ValueFieldName}
            || !$CompareValueList
            || ( ref $CompareValueList eq 'HASH'  && !%{$CompareValueList} )
            || ( ref $CompareValueList eq 'ARRAY' && !@{$CompareValueList} )
            || (
                $ValueFieldName eq 'ActionValue'
                && $AttributeName
                && $AttributeName eq 'WorkOrderAgentID'
            )
            )
        {
            $PossibleNone = 1;
        }

        # generate ValueOptionString
        my $ValueOptionString = $Self->{LayoutObject}->BuildSelection(
            Data         => $CompareValueList,
            Name         => $IDName . '-' . $Param{$IDName} . '-' . $ValueFieldName,
            SelectedID   => $Param{$ValueFieldName},
            PossibleNone => $PossibleNone,
            Translation  => 1,
        );

        # output selection
        $Self->{LayoutObject}->Block(
            Name => $BlockNameSelection,
            Data => {
                %Param,
                ValueOptionString => $ValueOptionString,
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

    # show empty block if field type is unknown
    else {

        # output empty block
        $Self->{LayoutObject}->Block(
            Name => $BlockNameSelection,
            Data => {
                %Param,
            },
        );
    }

    return 1;
}

# get compare value field type
sub _GetCompareValueFieldType {
    my ( $Self, %Param ) = @_;

    # set default field type
    my $FieldType = 'Selection';

    # if an attribute is set
    if ( $Param{AttributeID} ) {

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

        # get the field type
        $FieldType = $Self->{ConditionObject}->ConditionCompareValueFieldType(
            ObjectID    => $Param{ObjectID},
            AttributeID => $Param{AttributeID},
            UserID      => $Self->{UserID},
        );

        return if !$FieldType;
    }

    # Workaround for not yet implemented field types
    # TODO: implement these field types later!
    if ( $FieldType eq 'Date' ) {
        $FieldType = 'Text';
    }
    elsif ( $FieldType eq 'Autocomplete' ) {
        $FieldType = 'Selection';
    }

    return $FieldType;
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
            ObjectID     => $Param{ObjectID},
            ConditionID  => $Param{ConditionID},
            ExpressionID => $Param{ExpressionID},
            ActionID     => $Param{ActionID},
            UserID       => $Self->{UserID},
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
        my $ObjectAttributeMapping;

        # get mapping config for expressions or actions
        if ( $Param{ExpressionID} ) {
            $ObjectAttributeMapping = $Self->{ConfigObject}->Get(
                $ObjectName . '::Mapping::Expression::Object::Attribute',
            );
        }
        elsif ( $Param{ActionID} ) {
            $ObjectAttributeMapping = $Self->{ConfigObject}->Get(
                $ObjectName . '::Mapping::Action::Object::Attribute',
            );
        }

        # get maximum number of change and workorder freetext fields
        my $ChangeFreeTextMaxNumber = $Self->{ConfigObject}->Get('ITSMChange::FreeText::MaxNumber');
        my $WorkOrderFreeTextMaxNumber
            = $Self->{ConfigObject}->Get('ITSMWorkOrder::FreeText::MaxNumber');

        # get the valid attributes for the given object
        ATTRIBUTEID:
        for my $AttributeID ( sort keys %{$AllAttributes} ) {

            # check if attribute is in the mapping
            if ( $ObjectAttributeMapping->{ $AllAttributes->{$AttributeID} } ) {
                $Attributes{$AttributeID} = $AllAttributes->{$AttributeID};
            }
            else {

                # get attribute name
                my $AttributeName = $AllAttributes->{$AttributeID};

                # check if it is a change or workorder freetext field
                if ( $AttributeName =~ m{ \A ( (Change|WorkOrder) Free (?: Key|Text) ) (\d+) }xms )
                {

                    # remove the ID from the attribute name to check the mapping
                    my $AttributeWithoutNumber = $1;
                    my $Type                   = $2;
                    my $FieldNumber            = $3;

                    # do not use fields with a higher number than the max number
                    if ( $Type eq 'Change' ) {
                        next ATTRIBUTEID if $FieldNumber > $ChangeFreeTextMaxNumber;
                    }
                    elsif ( $Type eq 'WorkOrder' ) {
                        next ATTRIBUTEID if $FieldNumber > $WorkOrderFreeTextMaxNumber;
                    }

                    # check the mapping without ID, but add the the field with ID
                    if ( $ObjectAttributeMapping->{$AttributeWithoutNumber} ) {
                        $Attributes{$AttributeID} = $AllAttributes->{$AttributeID};
                    }
                }
            }
        }

        for my $Attribute ( values %Attributes ) {

            # remove 'ID' at the end of the attribute name for nicer display
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
        my $MappingConfig;

        # get mapping config for expressions or actions
        if ( $Param{ExpressionID} ) {
            $MappingConfig = $Self->{ConfigObject}->Get(
                $ObjectName . '::Mapping::Expression::Attribute::Operator'
            );
        }
        elsif ( $Param{ActionID} ) {
            $MappingConfig = $Self->{ConfigObject}->Get(
                $ObjectName . '::Mapping::Action::Attribute::Operator'
            );
        }

        # remove the ID from change or workorder freetext fields
        $AttributeName =~ s{ \A (( Change | WorkOrder ) Free ( Key | Text )) ( \d+ ) }{$1}xms;

        my $AttributeOperatorMapping;
        if ($MappingConfig) {
            $AttributeOperatorMapping = $MappingConfig->{$AttributeName} || {};
        }

        # get allowed operators for the given attribute
        OPERATORID:
        for my $OperatorID ( sort keys %{$AllOperators} ) {

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

    # if an attribute is set
    if ( $Param{AttributeID} ) {

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

        # get compare value list
        $CompareValueList = $Self->{ConditionObject}->ObjectCompareValueList(
            ObjectID      => $Param{ObjectID},
            AttributeName => $AttributeName,
            UserID        => $Self->{UserID},
        );
    }

    return $CompareValueList;
}

1;
