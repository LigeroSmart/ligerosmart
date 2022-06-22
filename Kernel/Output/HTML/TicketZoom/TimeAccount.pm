# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::TicketZoom::TimeAccount;

use strict;
use warnings;
use Kernel::Language qw(Translatable);
use Kernel::System::VariableCheck qw(IsHashRefWithData);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );
	
    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my %Ticket    = %{ $Param{Ticket} };

 	$Self->{DSN}  = $Kernel::OM->Get('Kernel::Config')->Get('DatabaseDSN');

	my $DBObject = $Kernel::OM->Get('Kernel::System::DB');
	my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
	my $TicketObject = $Kernel::OM->Get("Kernel::System::Ticket");
	my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');
	my $BackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');
 	my $ConfigObject = $Kernel::OM->Get('Kernel::Config');


	$Param{WidgetTitle} = Translatable($Param{Config}->{WidgetTitle});

	my $TicketID = $Param{Ticket}->{"TicketID"};

	# show total accounted time if feature is active:
	if ($Param{Config}->{ShowAccountedTime} &&  $ConfigObject->Get('Ticket::Frontend::AccountTime') ) {
		$Ticket{TicketTimeUnits} = $LayoutObject->CustomerAge(
                         Age   => $TicketObject->TicketAccountedTimeGet(%Ticket) * 60,
						 Space => ' '
                     );
		$LayoutObject->Block(
			Name => 'TotalAccountedTime',
			Data => \%Ticket,
		);
	}


	### Accounted Time In Minutos and Hour based
    # get dynamic field config for frontend module
	my %DynamicFieldFilter;
    $DynamicFieldFilter{'AccountedTimeInMin'} = 1 if $Param{Config}->{ShowAlsoAccountedTimeInMinutes};
    $DynamicFieldFilter{'AccountedTime'} = 1 if $Param{Config}->{ShowAlsoAccountedTimeInHourFormat};

    # get the dynamic fields for ticket object
    my $DynamicField = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldListGet(
        Valid       => 1,
        ObjectType  => ['Ticket'],
        FieldFilter => \%DynamicFieldFilter || {},
    );
    my $DynamicFieldBeckendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

    # to store dynamic fields to be displayed in the process widget and in the sidebar
    my (@FieldsSidebar);

    # cycle trough the activated Dynamic Fields for ticket object
    DYNAMICFIELD:
    for my $DynamicFieldConfig ( @{$DynamicField} ) {
        next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);
        next DYNAMICFIELD if !defined $Ticket{ 'DynamicField_' . $DynamicFieldConfig->{Name} };
        next DYNAMICFIELD if $Ticket{ 'DynamicField_' . $DynamicFieldConfig->{Name} } eq '';

        # use translation here to be able to reduce the character length in the template
        my $Label = $LayoutObject->{LanguageObject}->Translate( $DynamicFieldConfig->{Label} );

        my $ValueStrg = $DynamicFieldBeckendObject->DisplayValueRender(
            DynamicFieldConfig => $DynamicFieldConfig,
            Value              => $Ticket{ 'DynamicField_' . $DynamicFieldConfig->{Name} },
            LayoutObject       => $LayoutObject,
            ValueMaxChars      => $ConfigObject->
                Get('Ticket::Frontend::DynamicFieldsZoomMaxSizeSidebar')
                || 18,    # limit for sidebar display
        );

		push @FieldsSidebar, {
			$DynamicFieldConfig->{Name} => $ValueStrg->{Title},
			Name                        => $DynamicFieldConfig->{Name},
			Title                       => $ValueStrg->{Title},
			Value                       => $ValueStrg->{Value},
			Label                       => $Label,
			Link                        => $ValueStrg->{Link},
			LinkPreview                 => $ValueStrg->{LinkPreview},

			# Include unique parameter with dynamic field name in case of collision with others.
			#   Please see bug#13362 for more information.
			"DynamicField_$DynamicFieldConfig->{Name}" => $ValueStrg->{Title},
		};

        # example of dynamic fields order customization
        $LayoutObject->Block(
            Name => 'TicketDynamicField_' . $DynamicFieldConfig->{Name},
            Data => {
                Label => $Label,
            },
        );

        $LayoutObject->Block(
            Name => 'TicketDynamicField_' . $DynamicFieldConfig->{Name} . '_Plain',
            Data => {
                Value => $ValueStrg->{Value},
                Title => $ValueStrg->{Title},
            },
        );
    }

    # output dynamic fields in the sidebar
    for my $Field (@FieldsSidebar) {

        $LayoutObject->Block(
            Name => 'TicketDynamicField',
            Data => {
                Label => $Field->{Label},
            },
        );

        if ( $Field->{Link} ) {
            $LayoutObject->Block(
                Name => 'TicketDynamicFieldLink',
                Data => {
                    $Field->{Name} => $Field->{Title},
                    %Ticket,

                    # alias for ticket title, Title will be overwritten
                    TicketTitle => $Ticket{Title},
                    Value       => $Field->{Value},
                    Title       => $Field->{Title},
                    Link        => $Field->{Link},
                    LinkPreview => $Field->{LinkPreview},

                    # Include unique parameter with dynamic field name in case of collision with others.
                    #   Please see bug#13362 for more information.
                    "DynamicField_$Field->{Name}" => $Field->{Title},
                },
            );
        }
        else {
            $LayoutObject->Block(
                Name => 'TicketDynamicFieldPlain',
                Data => {
                    Value => $Field->{Value},
                    Title => $Field->{Title},
                },
            );
        }
    }

	# Custom Accounted Time based on additional initial and final 
	# Article Date and Time Dynamic Fields
	if($Param{Config}->{'z-ExtraInformation01'} && 
		$Param{Config}->{'z-ExtraInformation01'}->{'1-Enabled'} eq '1'){

		my $Ini = $Param{Config}->{'z-ExtraInformation01'}->{'3-DynamicFieldIDWorkHoursStart'};
		my $End = $Param{Config}->{'z-ExtraInformation01'}->{'4-DynamicFieldIDWorkHoursEnd'};
		
		# get database type (auto detection)
		if ( $Self->{DSN} =~ /:mysql/i ) {

			return if !$Kernel::OM->Get('Kernel::System::DB')->Prepare(
			SQL  => "select TIME_TO_SEC(TIMEDIFF(f.fim,i.inicio))/60 as time_unit from 
				(SELECT object_id, value_date as inicio FROM dynamic_field_value where field_id=?) i
				left join
				(SELECT object_id, value_date as fim FROM dynamic_field_value where field_id=?) f
				on i.object_id=f.object_id
				left join article a on i.object_id = a.id where a.ticket_id = ?",
			Bind => [ \$Ini, \$End, \$TicketID ],
			);
		}
		elsif ( $Self->{DSN} =~ /:pg/i ) {

			return if !$Kernel::OM->Get('Kernel::System::DB')->Prepare(
					SQL  => "select extract (epoch from ( f.fim - i.inicio))::integer/60 as time_unit from 
						(SELECT object_id, value_date as inicio FROM dynamic_field_value where field_id=?) i
						left join
						(SELECT object_id, value_date as fim FROM dynamic_field_value where field_id=?) f
						on i.object_id=f.object_id
						left join article a on i.object_id = a.id where a.ticket_id = ?",
					Bind => [ \$Ini, \$End, \$TicketID ],
			);
		}
		# db query

		my $Total = 0;
		my $Text = "";
		while ( my @Row = $Kernel::OM->Get('Kernel::System::DB')->FetchrowArray() ) {
			$Row[0] =~ s/,/./g;
			$Total += $Row[0];
		}

		if ( $Param{Format} ) {
			return $Total;
		}
		$Text = sprintf("%dh %dm", $Total/60, $Total%60);

		## generate block ##
		$LayoutObject->Block(
			Name => 'TicketDynamicField',
			Data => {
				%{ $Param{Config}->{'z-ExtraInformation01'} },
				Label => $Param{Config}->{'z-ExtraInformation01'}->{'2-Label'},
				Key => $Param{Config}->{'z-ExtraInformation01'}->{'2-Label'},
			},
		);
		$LayoutObject->Block(
			Name => 'TicketDynamicFieldPlain',
			Data => {
				Value =>  $Text,
			},
		);
	}
	my $Output = $LayoutObject->Output(
		TemplateFile => 'AgentTicketZoom/AccountedTime',
		Data         => { %Param },
	);

	return {
		Output => $Output,
	};

}

1;
