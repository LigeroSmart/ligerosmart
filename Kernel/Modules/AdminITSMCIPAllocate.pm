# --
# Kernel/Modules/AdminITSMCIPAllocate.pm - admin frontend of criticality, impact and priority
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AdminITSMCIPAllocate;

use strict;
use warnings;

use Kernel::System::DynamicField;
use Kernel::System::ITSMCIPAllocate;
use Kernel::System::Priority;
use Kernel::System::Valid;
use Kernel::System::VariableCheck qw(:all);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check needed objects
    for my $Object (qw(ConfigObject ParamObject LogObject LayoutObject)) {
        if ( !$Self->{$Object} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $Object!" );
        }
    }
    $Self->{CIPAllocateObject}  = Kernel::System::ITSMCIPAllocate->new(%Param);
    $Self->{DynamicFieldObject} = Kernel::System::DynamicField->new(%Param);
    $Self->{PriorityObject}     = Kernel::System::Priority->new(%Param);
    $Self->{ValidObject}        = Kernel::System::Valid->new(%Param);

    # get the dynamic fields for ITSMCriticality and ITSMImpact
    my $DynamicFieldConfigArrayRef = $Self->{DynamicFieldObject}->DynamicFieldListGet(
        Valid       => 1,
        ObjectType  => ['Ticket'],
        FieldFilter => {
            ITSMCriticality => 1,
            ITSMImpact      => 1,
        },
    );

    # get the dynamic field value for ITSMCriticality and ITSMImpact
    my %PossibleValues;
    DYNAMICFIELD:
    for my $DynamicFieldConfig ( @{$DynamicFieldConfigArrayRef} ) {
        next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

        # get PossibleValues
        $PossibleValues{ $DynamicFieldConfig->{Name} }
            = $DynamicFieldConfig->{Config}->{PossibleValues} || {};
    }

    # set the criticality list
    $Self->{CriticalityList} = $PossibleValues{ITSMCriticality};

    # set the impact list
    $Self->{ImpactList} = $PossibleValues{ITSMImpact};

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # get the priority list
    my %PriorityList = $Self->{PriorityObject}->PriorityList(
        UserID => 1,
    );

    # ------------------------------------------------------------ #
    # criticality, impact and priority allocation
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'CIPAllocate' ) {

        # get all PriorityIDs of the matrix
        my $AllocateData;
        for my $Impact ( sort keys %{ $Self->{ImpactList} } ) {

            CRITICALITY:
            for my $Criticality ( sort keys %{ $Self->{CriticalityList} } ) {

                # build field name for priority id
                my $FieldName = "PriorityID" . $Impact . '-' . $Criticality;

                # clean up all whitespaces because they are not allowed in HTML ID-Attributes
                $FieldName =~ s{ \s+ }{}gxms;

                # get form param for priority id
                my $PriorityID = $Self->{ParamObject}->GetParam(
                    Param => $FieldName,
                ) || '';

                next CRITICALITY if !$PriorityID;

                $AllocateData->{$Impact}->{$Criticality} = $PriorityID;
            }
        }

        # update allocations
        $Self->{CIPAllocateObject}->AllocateUpdate(
            AllocateData => $AllocateData,
            UserID       => 1,
        );

        return $Self->{LayoutObject}->Redirect( OP => "Action=$Self->{Action}" );
    }

    # ------------------------------------------------------------ #
    # overview
    # ------------------------------------------------------------ #
    else {

        # get allocation data
        my $AllocateData = $Self->{CIPAllocateObject}->AllocateList(
            UserID => 1,
        );

        my $AllocateMatrix;
        $AllocateMatrix->[0]->[0]->{ObjectType} =
            $Self->{LayoutObject}->{LanguageObject}->Get('Impact') . ' / '
            . $Self->{LayoutObject}->{LanguageObject}->Get('Criticality');
        $AllocateMatrix->[0]->[0]->{Class} = 'HeaderColumnDescription';

        # generate table description (Impact)
        my $Counter1 = 1;
        for my $Impact (
            sort { $Self->{ImpactList}->{$a} cmp $Self->{ImpactList}->{$b} }
            keys %{ $Self->{ImpactList} }
            )
        {
            $AllocateMatrix->[$Counter1]->[0]->{ObjectType}   = 'Impact';
            $AllocateMatrix->[$Counter1]->[0]->{ImpactKey}    = $Impact;
            $AllocateMatrix->[$Counter1]->[0]->{ObjectOption} = $Self->{ImpactList}->{$Impact};
            $Counter1++;
        }

        # generate table description (Criticality)
        my $Counter2 = 1;
        for my $Criticality (
            sort { $Self->{CriticalityList}->{$a} cmp $Self->{CriticalityList}->{$b} }
            keys %{ $Self->{CriticalityList} }
            )
        {
            $AllocateMatrix->[0]->[$Counter2]->{ObjectType}     = 'Criticality';
            $AllocateMatrix->[0]->[$Counter2]->{CriticalityKey} = $Criticality;
            $AllocateMatrix->[0]->[$Counter2]->{ObjectOption}
                = $Self->{CriticalityList}->{$Criticality};
            $Counter2++;
        }

        # generate content
        for my $Row ( 1 .. ( $Counter1 - 1 ) ) {
            for my $Column ( 1 .. ( $Counter2 - 1 ) ) {

                # extract keys
                my $ImpactKey      = $AllocateMatrix->[$Row]->[0]->{ImpactKey};
                my $CriticalityKey = $AllocateMatrix->[0]->[$Column]->{CriticalityKey};

                # build field name for priority id
                my $FieldName = "PriorityID" . $ImpactKey . '-' . $CriticalityKey;

                # clean up all whitespaces because they are not allowed in HTML ID-Attributes
                $FieldName =~ s{ \s+ }{}gxms;

                # create option string
                my $OptionStrg = $Self->{LayoutObject}->BuildSelection(
                    Name       => $FieldName,
                    Data       => \%PriorityList,
                    SelectedID => $AllocateData->{$ImpactKey}->{$CriticalityKey} || '',
                    Title      => 'Priority',
                );

                $AllocateMatrix->[$Row]->[$Column]->{OptionStrg} = $OptionStrg;
                $AllocateMatrix->[$Row]->[$Column]->{Class}      = 'Content';
            }
        }

        for my $Row ( 0 .. $#{$AllocateMatrix} ) {

            if ( $Row != 0 ) {
                $Self->{LayoutObject}->Block( Name => 'Row' )
            }

            for my $Column ( 0 .. $#{ $AllocateMatrix->[$Row] } ) {

                # check if the row is header
                if ( $Row == 0 ) {

                    if ( $Column == 0 ) {
                        $Self->{LayoutObject}->Block(
                            Name => 'HeaderColumnDescription',
                            Data => $AllocateMatrix->[$Row]->[$Column],
                        );
                    }
                    else {
                        $Self->{LayoutObject}->Block(
                            Name => 'HeaderCell',
                            Data => $AllocateMatrix->[$Row]->[$Column],
                        );
                    }
                }

                # check if the column is description
                elsif ( $Column == 0 ) {
                    $Self->{LayoutObject}->Block(
                        Name => 'DescriptionCell',
                        Data => $AllocateMatrix->[$Row]->[$Column],
                    );
                }
                else {
                    $Self->{LayoutObject}->Block(
                        Name => 'ContentCell',
                        Data => $AllocateMatrix->[$Row]->[$Column],
                    );
                }
            }
        }

        # output header and navbar
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();

        # generate output
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AdminITSMCIPAllocate',
            Data         => \%Param,
        );
        $Output .= $Self->{LayoutObject}->Footer();

        return $Output;
    }
}

1;
