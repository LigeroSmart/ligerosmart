# --
# Kernel/Modules/AdminITSMChangeCIPAllocate.pm - admin frontend of criticality, impact and priority
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AdminITSMChangeCIPAllocate;

use strict;
use warnings;

use Kernel::System::GeneralCatalog;
use Kernel::System::ITSMChange::ITSMChangeCIPAllocate;
use Kernel::System::Valid;

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
    $Self->{GeneralCatalogObject} = Kernel::System::GeneralCatalog->new(%Param);
    $Self->{CIPAllocateObject}    = Kernel::System::ITSMChange::ITSMChangeCIPAllocate->new(%Param);
    $Self->{ValidObject}          = Kernel::System::Valid->new(%Param);

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # ------------------------------------------------------------ #
    # category, impact and priority allocation
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'CIPAllocate' ) {

        # get option lists
        my %ObjectOption;
        $ObjectOption{CategoryList} = $Self->{GeneralCatalogObject}->ItemList(
            Class => 'ITSM::ChangeManagement::Category',
        );
        $ObjectOption{ImpactList} = $Self->{GeneralCatalogObject}->ItemList(
            Class => 'ITSM::ChangeManagement::Impact',
        );
        $ObjectOption{PriorityList} = $Self->{GeneralCatalogObject}->ItemList(
            Class => 'ITSM::ChangeManagement::Priority',
        );

        # get all PriorityIDs of the matrix
        my $AllocateData;
        for my $ImpactID ( sort keys %{ $ObjectOption{ImpactList} } ) {

            CATEGORYID:
            for my $CategoryID ( sort keys %{ $ObjectOption{CategoryList} } ) {

                # get form param
                my $PriorityID = $Self->{ParamObject}->GetParam(
                    Param => "PriorityID" . $ImpactID . '-' . $CategoryID
                ) || '';

                next CATEGORYID if !$PriorityID;

                $AllocateData->{$ImpactID}->{$CategoryID} = $PriorityID;
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

        # get option lists
        my %ObjectOption;
        $ObjectOption{CategoryList} = $Self->{GeneralCatalogObject}->ItemList(
            Class => 'ITSM::ChangeManagement::Category',
        );
        $ObjectOption{ImpactList} = $Self->{GeneralCatalogObject}->ItemList(
            Class => 'ITSM::ChangeManagement::Impact',
        );
        $ObjectOption{PriorityList} = $Self->{GeneralCatalogObject}->ItemList(
            Class => 'ITSM::ChangeManagement::Priority',
        );

        # get allocation data
        my $AllocateData = $Self->{CIPAllocateObject}->AllocateList(
            UserID => 1,
        );

        my $AllocateMatrix;

        $AllocateMatrix->[0]->[0]->{ObjectType} =
            $Self->{LayoutObject}->{LanguageObject}->Get('Impact') . ' / '
            . $Self->{LayoutObject}->{LanguageObject}->Get('Category');
        $AllocateMatrix->[0]->[0]->{Class} = 'HeaderColumnDescription';

        # generate table description (Impact)
        my $Counter1 = 1;
        for my $Impact (
            sort { $ObjectOption{ImpactList}->{$a} cmp $ObjectOption{ImpactList}->{$b} }
            keys %{ $ObjectOption{ImpactList} }
            )
        {
            $AllocateMatrix->[$Counter1]->[0]->{ObjectType}   = 'Impact';
            $AllocateMatrix->[$Counter1]->[0]->{ImpactKey}    = $Impact;
            $AllocateMatrix->[$Counter1]->[0]->{ObjectOption} = $ObjectOption{ImpactList}{$Impact};
            $Counter1++;
        }

        # generate table description (Category)
        my $Counter2 = 1;
        for my $Category (
            sort { $ObjectOption{CategoryList}->{$a} cmp $ObjectOption{CategoryList}->{$b} }
            keys %{ $ObjectOption{CategoryList} }
            )
        {
            $AllocateMatrix->[0]->[$Counter2]->{ObjectType}  = 'Category';
            $AllocateMatrix->[0]->[$Counter2]->{CategoryKey} = $Category;
            $AllocateMatrix->[0]->[$Counter2]->{ObjectOption}
                = $ObjectOption{CategoryList}{$Category};
            $Counter2++;
        }

        # generate content
        for my $Row ( 1 .. ( $Counter1 - 1 ) ) {
            for my $Column ( 1 .. ( $Counter2 - 1 ) ) {

                # extract keys
                my $ImpactKey   = $AllocateMatrix->[$Row]->[0]->{ImpactKey};
                my $CategoryKey = $AllocateMatrix->[0]->[$Column]->{CategoryKey};

                # create option string
                my $OptionStrg = $Self->{LayoutObject}->BuildSelection(
                    Name       => 'PriorityID' . $ImpactKey . '-' . $CategoryKey,
                    Data       => $ObjectOption{PriorityList},
                    SelectedID => $AllocateData->{$ImpactKey}{$CategoryKey} || '',
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
            TemplateFile => 'AdminITSMChangeCIPAllocate',
            Data         => \%Param,
        );
        $Output .= $Self->{LayoutObject}->Footer();

        return $Output;
    }
}

1;
