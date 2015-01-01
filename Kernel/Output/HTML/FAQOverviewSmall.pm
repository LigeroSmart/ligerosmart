# --
# Kernel/Output/HTML/FAQOverviewSmall.pm.pm
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::FAQOverviewSmall;

use strict;
use warnings;

use Kernel::System::DynamicField;
use Kernel::System::DynamicField::Backend;
use Kernel::System::VariableCheck qw(:all);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # get needed objects
    for my $Object (
        qw(ConfigObject LogObject DBObject LayoutObject UserID UserObject MainObject)
        )
    {
        $Self->{$Object} = $Param{$Object} || die "Got no $Object!";
    }

    $Self->{DynamicFieldObject} = Kernel::System::DynamicField->new(%Param);
    $Self->{BackendObject}      = Kernel::System::DynamicField::Backend->new(%Param);

    $Self->{MultiLanguage} = $Self->{ConfigObject}->Get('FAQ::MultiLanguage');

    # get dynamic field config for frontend module
    $Self->{DynamicFieldFilter} = $Self->{ConfigObject}->Get("FAQ::Frontend::OverviewSmall")->{DynamicField};

    # get the dynamic fields for this screen
    $Self->{DynamicField} = $Self->{DynamicFieldObject}->DynamicFieldListGet(
        Valid       => 1,
        ObjectType  => ['FAQ'],
        FieldFilter => $Self->{DynamicFieldFilter} || {},
    );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $Output;
    my @ShowColumns;

    # check needed stuff
    for my $Needed (qw(PageShown StartHit)) {
        if ( !$Param{$Needed} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    # need FAQIDs
    if ( !$Param{FAQIDs} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need the FAQIDs!',
        );
        return;
    }

    # store the FAQIDs
    my @IDs;
    if ( $Param{FAQIDs} && ref $Param{FAQIDs} eq 'ARRAY' ) {
        @IDs = @{ $Param{FAQIDs} };
    }

    if (@IDs) {

        # check ShowColumns parameter
        if ( $Param{ShowColumns} && ref $Param{ShowColumns} eq 'ARRAY' ) {
            @ShowColumns = @{ $Param{ShowColumns} };
        }

        # build column header blocks
        if (@ShowColumns) {

            # call main block
            $Self->{LayoutObject}->Block( Name => 'RecordForm' );

            COLUMN:
            for my $Column (@ShowColumns) {

                next COLUMN if ( $Column eq 'Language' && !$Self->{MultiLanguage} );

                # create needed variables
                my $CSS = 'OverviewHeader';
                my $OrderBy;

                # remove ID if necessary
                if ( $Param{SortBy} ) {
                    $Param{SortBy} = $Param{SortBy} eq 'PriorityID'
                        ? 'Priority'
                        : $Param{SortBy} eq 'CategoryID' ? 'Category'
                        : $Param{SortBy} eq 'LanguageID' ? 'Language'
                        : $Param{SortBy} eq 'StateID'    ? 'State'
                        : $Param{SortBy} eq 'FAQID'      ? 'Number'
                        :                                  $Param{SortBy};
                }

                # set the correct Set CSS class and order by link
                if ( $Param{SortBy} && ( $Param{SortBy} eq $Column ) ) {
                    if ( $Param{OrderBy} && ( $Param{OrderBy} eq 'Up' ) ) {
                        $OrderBy = 'Down';
                        $CSS .= ' SortDescendingLarge';
                    }
                    else {
                        $OrderBy = 'Up';
                        $CSS .= ' SortAscendingLarge';
                    }
                }
                else {
                    $OrderBy = 'Up';
                }

                $Self->{LayoutObject}->Block(
                    Name => 'Record' . $Column . 'Header',
                    Data => {
                        %Param,
                        CSS     => $CSS,
                        OrderBy => $OrderBy,
                    },
                );
            }

            # Dynamic fields
            # cycle trough the activated Dynamic Fields for this screen
            DYNAMICFIELD:
            for my $DynamicFieldConfig ( @{ $Self->{DynamicField} } ) {
                next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

                my $Label = $DynamicFieldConfig->{Label};

                # get field sortable condition
                my $IsSortable = $Self->{BackendObject}->HasBehavior(
                    DynamicFieldConfig => $DynamicFieldConfig,
                    Behavior           => 'IsSortable',
                );

                if ($IsSortable) {
                    my $CSS = '';
                    my $OrderBy;
                    if (
                        $Param{SortBy}
                        && ( $Param{SortBy} eq ( 'DynamicField_' . $DynamicFieldConfig->{Name} ) )
                        )
                    {
                        if ( $Param{OrderBy} && ( $Param{OrderBy} eq 'Up' ) ) {
                            $OrderBy = 'Down';
                            $CSS .= ' SortDescending';
                        }
                        else {
                            $OrderBy = 'Up';
                            $CSS .= ' SortAscending';
                        }
                    }

                    $Self->{LayoutObject}->Block(
                        Name => 'RecordDynamicFieldHeader',
                        Data => {
                            %Param,
                            CSS => $CSS,
                        },
                    );

                    $Self->{LayoutObject}->Block(
                        Name => 'RecordDynamicFieldHeaderSortable',
                        Data => {
                            %Param,
                            OrderBy          => $OrderBy,
                            Label            => $Label,
                            DynamicFieldName => $DynamicFieldConfig->{Name},
                        },
                    );

                    # example of dynamic fields order customization
                    $Self->{LayoutObject}->Block(
                        Name => 'RecordDynamicField_' . $DynamicFieldConfig->{Name} . 'Header',
                        Data => {
                            %Param,
                            CSS => $CSS,
                        },
                    );

                    $Self->{LayoutObject}->Block(
                        Name => 'RecordDynamicField_'
                            . $DynamicFieldConfig->{Name}
                            . 'HeaderSortable',
                        Data => {
                            %Param,
                            OrderBy          => $OrderBy,
                            Label            => $Label,
                            DynamicFieldName => $DynamicFieldConfig->{Name},
                        },
                    );
                }
                else {

                    $Self->{LayoutObject}->Block(
                        Name => 'RecordDynamicFieldHeader',
                        Data => {
                            %Param,
                        },
                    );

                    $Self->{LayoutObject}->Block(
                        Name => 'RecordDynamicFieldHeaderNotSortable',
                        Data => {
                            %Param,
                            Label => $Label,
                        },
                    );

                    # example of dynamic fields order customization
                    $Self->{LayoutObject}->Block(
                        Name => 'RecordDynamicField_' . $DynamicFieldConfig->{Name} . 'Header',
                        Data => {
                            %Param,
                        },
                    );

                    $Self->{LayoutObject}->Block(
                        Name => 'RecordDynamicField_'
                            . $DynamicFieldConfig->{Name}
                            . 'HeaderNotSortable',
                        Data => {
                            %Param,
                            Label => $Label,
                        },
                    );
                }
            }
        }

        my $Counter = 0;

        ID:
        for my $ID (@IDs) {
            $Counter++;
            if (
                $Counter >= $Param{StartHit}
                && $Counter < ( $Param{PageShown} + $Param{StartHit} )
                )
            {

                # to store all data
                my %Data;

                # get FAQ data
                my %FAQ = $Self->{FAQObject}->FAQGet(
                    ItemID     => $ID,
                    ItemFields => 0,
                    UserID     => $Self->{UserID},
                );

                $FAQ{CleanTitle} = $Self->{FAQObject}->FAQArticleTitleClean(
                    Title => $FAQ{Title},
                    Size  => $Param{TitleSize},
                );

                next ID if !%FAQ;

                # add FAQ data
                %Data = ( %Data, %FAQ );

                # build record block
                $Self->{LayoutObject}->Block(
                    Name => 'Record',
                    Data => {
                        %Param,
                        %Data,
                    },
                );

                # build column record blocks
                if (@ShowColumns) {
                    COLUMN:
                    for my $Column (@ShowColumns) {

                        next COLUMN if ( $Column eq 'Language' && !$Self->{MultiLanguage} );
                        $Self->{LayoutObject}->Block(
                            Name => 'Record' . $Column,
                            Data => {
                                %Param,
                                %Data,
                            },
                        );

                        # do not display columns as links in the customer frontend
                        next COLUMN if $Param{Frontend} eq 'Customer';

                        # show links if available
                        $Self->{LayoutObject}->Block(
                            Name => 'Record' . $Column . 'LinkStart',
                            Data => {
                                %Param,
                                %Data,
                            },
                        );
                        $Self->{LayoutObject}->Block(
                            Name => 'Record' . $Column . 'LinkEnd',
                            Data => {
                                %Param,
                                %Data,
                            },
                        );
                    }
                }

                # Dynamic fields
                # cycle trough the activated Dynamic Fields for this screen
                DYNAMICFIELD:
                for my $DynamicFieldConfig ( @{ $Self->{DynamicField} } ) {
                    next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

                    # get field value
                    my $Value = $Self->{BackendObject}->ValueGet(
                        DynamicFieldConfig => $DynamicFieldConfig,
                        ObjectID           => $ID,
                    );

                    my $ValueStrg = $Self->{BackendObject}->DisplayValueRender(
                        DynamicFieldConfig => $DynamicFieldConfig,
                        Value              => $Value,
                        ValueMaxChars      => 20,
                        LayoutObject       => $Self->{LayoutObject},
                    );

                    $Self->{LayoutObject}->Block(
                        Name => 'RecordDynamicField',
                        Data => {
                            Value => $ValueStrg->{Value},
                            Title => $ValueStrg->{Title},
                        },
                    );

                    if ( $ValueStrg->{Link} ) {
                        $Self->{LayoutObject}->Block(
                            Name => 'RecordDynamicFieldLink',
                            Data => {
                                Value                       => $ValueStrg->{Value},
                                Title                       => $ValueStrg->{Title},
                                Link                        => $ValueStrg->{Link},
                                $DynamicFieldConfig->{Name} => $ValueStrg->{Title},
                            },
                        );
                    }
                    else {
                        $Self->{LayoutObject}->Block(
                            Name => 'RecordDynamicFieldPlain',
                            Data => {
                                Value => $ValueStrg->{Value},
                                Title => $ValueStrg->{Title},
                            },
                        );
                    }

                    # example of dynamic fields order customization
                    $Self->{LayoutObject}->Block(
                        Name => 'RecordDynamicField_' . $DynamicFieldConfig->{Name},
                        Data => {
                            Value => $ValueStrg->{Value},
                            Title => $ValueStrg->{Title},
                        },
                    );

                    if ( $ValueStrg->{Link} ) {
                        $Self->{LayoutObject}->Block(
                            Name => 'RecordDynamicField_' . $DynamicFieldConfig->{Name} . '_Link',
                            Data => {
                                Value                       => $ValueStrg->{Value},
                                Title                       => $ValueStrg->{Title},
                                Link                        => $ValueStrg->{Link},
                                $DynamicFieldConfig->{Name} => $ValueStrg->{Title},
                            },
                        );
                    }
                    else {
                        $Self->{LayoutObject}->Block(
                            Name => 'RecordDynamicField_' . $DynamicFieldConfig->{Name} . '_Plain',
                            Data => {
                                Value => $ValueStrg->{Value},
                                Title => $ValueStrg->{Title},
                            },
                        );
                    }
                }
            }
        }
    }
    else {
        $Self->{LayoutObject}->Block( Name => 'NoFAQFound' );
    }

    # use template
    $Output .= $Self->{LayoutObject}->Output(
        TemplateFile => 'AgentFAQOverviewSmall',
        Data         => {
            %Param,
            Type        => $Self->{ViewType},
            ColumnCount => scalar @ShowColumns,
        },
    );

    return $Output;
}

1;
