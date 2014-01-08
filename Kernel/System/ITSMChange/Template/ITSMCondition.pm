# --
# Kernel/System/ITSMChange/Template/ITSMCondition.pm - all template functions for conditions
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::ITSMChange::Template::ITSMCondition;

use strict;
use warnings;

use Kernel::System::ITSMChange::ITSMCondition;
use Kernel::System::Valid;

## nofilter(TidyAll::Plugin::OTRS::Perl::Dumper)
use Data::Dumper;

=head1 NAME

Kernel::System::ITSMChange::Template::ITSMCondition - all template functions for conditions

=head1 SYNOPSIS

All functions for condition templates in ITSMChangeManagement.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create an object

    use Kernel::Config;
    use Kernel::System::Encode;
    use Kernel::System::Log;
    use Kernel::System::DB;
    use Kernel::System::Main;
    use Kernel::System::Time;
    use Kernel::System::ITSMChange::Template::ITSMCondition;

    my $ConfigObject = Kernel::Config->new();
    my $EncodeObject = Kernel::System::Encode->new(
        ConfigObject => $ConfigObject,
    );
    my $LogObject = Kernel::System::Log->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
    );
    my $MainObject = Kernel::System::Main->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
    );
    my $TimeObject = Kernel::System::Time->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
    );
    my $DBObject = Kernel::System::DB->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
        MainObject   => $MainObject,
    );
    my $TemplateObject = Kernel::System::ITSMChange::Template::ITSMCondition->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
        DBObject     => $DBObject,
        TimeObject   => $TimeObject,
        MainObject   => $MainObject,
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for my $Object (
        qw(DBObject ConfigObject EncodeObject LogObject UserObject GroupObject MainObject TimeObject)
        )
    {
        $Self->{$Object} = $Param{$Object} || die "Got no $Object!";
    }

    # set the debug flag
    $Self->{Debug} = $Param{Debug} || 0;

    # create additional objects
    $Self->{ConditionObject} = Kernel::System::ITSMChange::ITSMCondition->new( %{$Self} );
    $Self->{ValidObject}     = Kernel::System::Valid->new( %{$Self} );

    return $Self;
}

=item Serialize()

Serialize a condition. This is done with Data::Dumper. It returns
a serialized string of the datastructure. The condition actions
are "wrapped" within a hashreference...

    my $TemplateString = $TemplateObject->Serialize(
        ConditionID => 1,
        UserID      => 1,
        Return      => 'HASH', # (optional) HASH|STRING default 'STRING'
    );

returns

    '{ConditionAdd => { ... }}'

If parameter C<Return> is set to C<HASH>, the Perl datastructure
is returned

    {
        ConditionAdd => { ... },
        Children     => [ ... ],
    }

=cut

sub Serialize {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(UserID ConditionID)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # set default value for 'Return'
    $Param{Return} ||= 'STRING';

    # get condition
    my $Condition = $Self->{ConditionObject}->ConditionGet(
        ConditionID => $Param{ConditionID},
        UserID      => $Param{UserID},
    );

    return if !$Condition;

    # templates have to be an array reference;
    my $OriginalData = { ConditionAdd => $Condition };

    # get expressions
    my $Expressions = $Self->{ConditionObject}->ExpressionList(
        ConditionID => $Param{ConditionID},
        UserID      => $Param{UserID},
    ) || [];

    # add each expression to condition data
    for my $ExpressionID ( @{$Expressions} ) {
        my $Expression = $Self->{ConditionObject}->ExpressionGet(
            ExpressionID => $ExpressionID,
            UserID       => $Param{UserID},
        );

        push @{ $OriginalData->{Children} }, { ExpressionAdd => $Expression };
    }

    # get actions
    my $Actions = $Self->{ConditionObject}->ActionList(
        ConditionID => $Param{ConditionID},
        UserID      => $Param{UserID},
    ) || [];

    # add each action to condition data
    for my $ActionID ( @{$Actions} ) {
        my $Action = $Self->{ConditionObject}->ActionGet(
            ActionID => $ActionID,
            UserID   => $Param{UserID},
        );

        push @{ $OriginalData->{Children} }, { ActionAdd => $Action };
    }

    if ( $Param{Return} eq 'HASH' ) {
        return $OriginalData;
    }

    # no indentation (saves space)
    local $Data::Dumper::Indent = 0;

    # do not use cross-referencing
    local $Data::Dumper::Deepcopy = 1;

    # serialize the data (do not use $VAR1, but $TemplateData for Dumper output)
    my $SerializedData = $Self->{MainObject}->Dump( $OriginalData, 'binary' );

    return $SerializedData;
}

=item DeSerialize()

DeSerialize() is a wrapper for all the _XXXAdd methods.

    my %Info = $TemplateObject->DeSerialize(
        Data => {
            # ... Params for ConditionAdd
        },
        ChangeID => 1,
        UserID   => 1,
        Method   => 'ConditionAdd',
    );

=cut

sub DeSerialize {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(UserID Method Data)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # dispatch table
    my %Method2Sub = (
        ConditionAdd  => '_ConditionAdd',
        ExpressionAdd => '_ExpressionAdd',
        ActionAdd     => '_ActionAdd',
    );

    my $Sub = $Method2Sub{ $Param{Method} };

    if ( !$Sub ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Invalid Methodname!',
        );
        return;
    }

    return $Self->$Sub(%Param);
}

=begin Internal:

=item _ConditionAdd()

Creates new conditions for a change based on the given template. It
returns a hash of information (change id it was created for, id is
the condition id)

    my %Info = $TemplateObject->_ConditionAdd(
        Data => {
            # ... Params for ConditionAdd
        },
        ChangeID => 1,
        UserID   => 1,
    );

=cut

sub _ConditionAdd {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(UserID ChangeID Data)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    my %Data = %{ $Param{Data} };

    # delete attributes
    delete $Data{ConditionID};

    # add condition
    my $ConditionID = $Self->{ConditionObject}->ConditionAdd(
        %Data,
        ChangeID => $Param{ChangeID},
        UserID   => $Param{UserID},
    );

    my %Info = (
        ID          => $ConditionID,
        ChangeID    => $Param{ChangeID},
        ConditionID => $ConditionID,
    );

    return %Info;
}

=item _ExpressionAdd()

Creates new expressions for a condition based on the given template. It
returns a hash of information (change id it was created for, id is
the expression id)

    my %Info = $TemplateObject->_ExpressionAdd(
        Data => {
            # ... Params for ExpressionAdd
        },
        ChangeID => 1,
        UserID   => 1,
    );

=cut

sub _ExpressionAdd {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(UserID ChangeID Data ConditionID)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    my %Data = %{ $Param{Data} };

    # delete attributes that are not needed
    delete $Data{ExpressionID};

    # replace old ids with new ids
    $Data{ConditionID} = $Param{ConditionID};

    # replace old id only if it is an ID
    if ( $Data{Selector} =~ m{ \A \d+ \z }xms ) {
        my $Object = $Self->{ConditionObject}->ObjectGet(
            ObjectID => $Data{ObjectID},
            UserID   => $Param{UserID},
        );

        if ( $Object->{Name} eq 'ITSMChange' ) {
            $Data{Selector} = $Param{ChangeID};
        }
        elsif ( $Object->{Name} eq 'ITSMWorkOrder' ) {
            $Data{Selector} = $Param{OldWorkOrderIDs}->{ $Data{Selector} };
        }
    }

    # add expression
    my $ExpressionID = $Self->{ConditionObject}->ExpressionAdd(
        %Data,
        UserID => $Param{UserID},
    );

    my %Info = (
        ID           => $ExpressionID,
        ChangeID     => $Param{ChangeID},
        ExpressionID => $ExpressionID,
    );

    return %Info;
}

=item _ActionAdd()

Creates new actions for a condition based on the given template. It
returns a hash of information (change id it was created for, id is
the action id)

    my %Info = $TemplateObject->_ActionAdd(
        Data => {
            # ... Params for ActionAdd
        },
        ChangeID => 1,
        UserID   => 1,
    );

=cut

sub _ActionAdd {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(UserID ChangeID Data ConditionID)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    my %Data = %{ $Param{Data} };

    # delete attributes that are not needed
    delete $Data{ActionID};

    # replace old ids with new ids
    $Data{ConditionID} = $Param{ConditionID};

    # replace old id only if it is an ID
    if ( $Data{Selector} =~ m{ \A \d+ \z }xms ) {
        my $Object = $Self->{ConditionObject}->ObjectGet(
            ObjectID => $Data{ObjectID},
            UserID   => $Param{UserID},
        );

        if ( $Object->{Name} eq 'ITSMChange' ) {
            $Data{Selector} = $Param{ChangeID};
        }
        elsif ( $Object->{Name} eq 'ITSMWorkOrder' ) {
            $Data{Selector} = $Param{OldWorkOrderIDs}->{ $Data{Selector} };
        }
    }

    # add action
    my $ActionID = $Self->{ConditionObject}->ActionAdd(
        %Data,
        UserID => $Param{UserID},
    );

    my %Info = (
        ID       => $ActionID,
        ChangeID => $Param{ChangeID},
        ActionID => $ActionID,
    );

    return %Info;
}

1;

=end Internal:

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (http://otrs.org/).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
