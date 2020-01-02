# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Modules::AdminITSMChangeCIPAllocate;

use strict;
use warnings;

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # get needed objects
    my $GeneralCatalogObject = $Kernel::OM->Get('Kernel::System::GeneralCatalog');
    my $CIPAllocateObject    = $Kernel::OM->Get('Kernel::System::ITSMChange::ITSMChangeCIPAllocate');
    my $LayoutObject         = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # ------------------------------------------------------------ #
    # category, impact and priority allocation
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'CIPAllocate' ) {

        # get option lists
        my %ObjectOption;
        $ObjectOption{CategoryList} = $GeneralCatalogObject->ItemList(
            Class => 'ITSM::ChangeManagement::Category',
        );
        $ObjectOption{ImpactList} = $GeneralCatalogObject->ItemList(
            Class => 'ITSM::ChangeManagement::Impact',
        );
        $ObjectOption{PriorityList} = $GeneralCatalogObject->ItemList(
            Class => 'ITSM::ChangeManagement::Priority',
        );

        # get all PriorityIDs of the matrix
        my $AllocateData;
        for my $ImpactID ( sort keys %{ $ObjectOption{ImpactList} } ) {

            CATEGORYID:
            for my $CategoryID ( sort keys %{ $ObjectOption{CategoryList} } ) {

                # get form param
                my $PriorityID = $Kernel::OM->Get('Kernel::System::Web::Request')->GetParam(
                    Param => "PriorityID" . $ImpactID . '-' . $CategoryID
                ) || '';

                next CATEGORYID if !$PriorityID;

                $AllocateData->{$ImpactID}->{$CategoryID} = $PriorityID;
            }
        }

        # update allocations
        $CIPAllocateObject->AllocateUpdate(
            AllocateData => $AllocateData,
            UserID       => 1,
        );

        return $LayoutObject->Redirect( OP => "Action=$Self->{Action}" );
    }

    # ------------------------------------------------------------ #
    # overview
    # ------------------------------------------------------------ #
    else {

        # get option lists
        my %ObjectOption;
        $ObjectOption{CategoryList} = $GeneralCatalogObject->ItemList(
            Class => 'ITSM::ChangeManagement::Category',
        );
        $ObjectOption{ImpactList} = $GeneralCatalogObject->ItemList(
            Class => 'ITSM::ChangeManagement::Impact',
        );
        $ObjectOption{PriorityList} = $GeneralCatalogObject->ItemList(
            Class => 'ITSM::ChangeManagement::Priority',
        );

        # get allocation data
        my $AllocateData = $CIPAllocateObject->AllocateList(
            UserID => 1,
        );

        my $AllocateMatrix;

        $AllocateMatrix->[0]->[0]->{ObjectType} =
            $LayoutObject->{LanguageObject}->Translate('Impact') . ' / '
            . $LayoutObject->{LanguageObject}->Translate('Category');
        $AllocateMatrix->[0]->[0]->{Class} = 'HeaderColumnDescription';

        # generate table description (Impact)
        my $CounterImpact = 1;
        for my $Impact (
            sort { $ObjectOption{ImpactList}->{$a} cmp $ObjectOption{ImpactList}->{$b} }
            keys %{ $ObjectOption{ImpactList} }
            )
        {
            $AllocateMatrix->[$CounterImpact]->[0]->{ObjectType}   = 'Impact';
            $AllocateMatrix->[$CounterImpact]->[0]->{ImpactKey}    = $Impact;
            $AllocateMatrix->[$CounterImpact]->[0]->{ObjectOption} = $ObjectOption{ImpactList}{$Impact};
            $CounterImpact++;
        }

        # generate table description (Category)
        my $CounterCategory = 1;
        for my $Category (
            sort { $ObjectOption{CategoryList}->{$a} cmp $ObjectOption{CategoryList}->{$b} }
            keys %{ $ObjectOption{CategoryList} }
            )
        {
            $AllocateMatrix->[0]->[$CounterCategory]->{ObjectType}   = 'Category';
            $AllocateMatrix->[0]->[$CounterCategory]->{CategoryKey}  = $Category;
            $AllocateMatrix->[0]->[$CounterCategory]->{ObjectOption} = $ObjectOption{CategoryList}{$Category};
            $CounterCategory++;
        }

        # generate content
        for my $Row ( 1 .. ( $CounterImpact - 1 ) ) {
            for my $Column ( 1 .. ( $CounterCategory - 1 ) ) {

                # extract keys
                my $ImpactKey   = $AllocateMatrix->[$Row]->[0]->{ImpactKey};
                my $CategoryKey = $AllocateMatrix->[0]->[$Column]->{CategoryKey};

                # create option string
                my $OptionStrg = $LayoutObject->BuildSelection(
                    Name       => 'PriorityID' . $ImpactKey . '-' . $CategoryKey,
                    Data       => $ObjectOption{PriorityList},
                    SelectedID => $AllocateData->{$ImpactKey}{$CategoryKey} || '',
                    Title      => 'Priority',
                    Class      => 'Modernize',
                );

                $AllocateMatrix->[$Row]->[$Column]->{OptionStrg} = $OptionStrg;
                $AllocateMatrix->[$Row]->[$Column]->{Class}      = 'Content';
            }
        }

        for my $Row ( 0 .. $#{$AllocateMatrix} ) {

            if ( $Row != 0 ) {
                $LayoutObject->Block( Name => 'Row' );
            }

            for my $Column ( 0 .. $#{ $AllocateMatrix->[$Row] } ) {

                # check if the row is header
                if ( $Row == 0 ) {

                    if ( $Column == 0 ) {
                        $LayoutObject->Block(
                            Name => 'HeaderColumnDescription',
                            Data => $AllocateMatrix->[$Row]->[$Column],
                        );
                    }
                    else {
                        $LayoutObject->Block(
                            Name => 'HeaderCell',
                            Data => $AllocateMatrix->[$Row]->[$Column],
                        );
                    }
                }

                # check if the column is description
                elsif ( $Column == 0 ) {
                    $LayoutObject->Block(
                        Name => 'DescriptionCell',
                        Data => $AllocateMatrix->[$Row]->[$Column],
                    );
                }
                else {
                    $LayoutObject->Block(
                        Name => 'ContentCell',
                        Data => $AllocateMatrix->[$Row]->[$Column],
                    );
                }
            }
        }

        # output header and navbar
        my $Output = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar();

        # generate output
        $Output .= $LayoutObject->Output(
            TemplateFile => 'AdminITSMChangeCIPAllocate',
            Data         => \%Param,
        );
        $Output .= $LayoutObject->Footer();

        return $Output;
    }
}

1;
