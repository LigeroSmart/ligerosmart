# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::DynamicField::Driver::TextMask;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);

use base qw(Kernel::System::DynamicField::Driver::BaseText);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::DynamicFieldValue',
    'Kernel::System::Main',
);

=head1 NAME

Kernel::System::DynamicField::Driver::Text

=head1 SYNOPSIS

DynamicFields Text Driver delegate

=head1 PUBLIC INTERFACE

This module implements the public interface of L<Kernel::System::DynamicField::Backend>.
Please look there for a detailed reference of the functions.

=over 4

=item new()

usually, you want to create an instance of this
by using Kernel::System::DynamicField::Backend->new();

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # set field behaviors
    $Self->{Behaviors} = {
        'IsACLReducible'               => 0,
        'IsNotificationEventCondition' => 1,
        'IsSortable'                   => 1,
        'IsFiltrable'                  => 0,
        'IsStatsCondition'             => 1,
        'IsCustomerInterfaceCapable'   => 1,
    };

    # get the Dynamic Field Backend custom extensions
    my $DynamicFieldDriverExtensions
        = $Kernel::OM->Get('Kernel::Config')->Get('DynamicFields::Extension::Driver::TextMask');

    EXTENSION:
    for my $ExtensionKey ( sort keys %{$DynamicFieldDriverExtensions} ) {

        # skip invalid extensions
        next EXTENSION if !IsHashRefWithData( $DynamicFieldDriverExtensions->{$ExtensionKey} );

        # create a extension config shortcut
        my $Extension = $DynamicFieldDriverExtensions->{$ExtensionKey};

        # check if extension has a new module
        if ( $Extension->{Module} ) {

            # check if module can be loaded
            if (
                !$Kernel::OM->Get('Kernel::System::Main')->RequireBaseClass( $Extension->{Module} )
                )
            {
                die "Can't load dynamic fields backend module"
                    . " $Extension->{Module}! $@";
            }
        }

        # check if extension contains more behaviors
        if ( IsHashRefWithData( $Extension->{Behaviors} ) ) {

            %{ $Self->{Behaviors} } = (
                %{ $Self->{Behaviors} },
                %{ $Extension->{Behaviors} }
            );
        }
    }

    return $Self;
}

sub EditFieldRender {
    my ( $Self, %Param ) = @_;

    # take config from field config
    my $FieldConfig = $Param{DynamicFieldConfig}->{Config};
    my $FieldName   = 'DynamicField_' . $Param{DynamicFieldConfig}->{Name};
    my $FieldLabel  = $Param{DynamicFieldConfig}->{Label};

    my $Value = '';

    # set the field value or default
    if ( $Param{UseDefaultValue} ) {
        $Value = ( defined $FieldConfig->{DefaultValue} ? $FieldConfig->{DefaultValue} : '' );
    }
    $Value = $Param{Value} // $Value;

    # extract the dynamic field value form the web request
    my $FieldValue = $Self->EditFieldValueGet(
        %Param,
    );

    # set values from ParamObject if present
    if ( defined $FieldValue ) {
        $Value = $FieldValue;
    }

    # check and set class if necessary
    my $FieldClass = 'DynamicFieldText W50pc';
    if ( defined $Param{Class} && $Param{Class} ne '' ) {
        $FieldClass .= ' ' . $Param{Class};
    }

    # set field as mandatory
    if ( $Param{Mandatory} ) {
        $FieldClass .= ' Validate_Required';
    }

    # set error css class
    if ( $Param{ServerError} ) {
        $FieldClass .= ' ServerError';
    }

    my $ValueEscaped = $Param{LayoutObject}->Ascii2Html(
        Text => $Value,
    );

    my $FieldLabelEscaped = $Param{LayoutObject}->Ascii2Html(
        Text => $FieldLabel,
    );
    
	my $Masks = $Kernel::OM->Get('Kernel::Config')->Get('DynamicFieldTextMask::Masks');
        
	my $Mask = $Masks->{$FieldConfig->{Mask}} || '';
	if ($Mask ne '') {
		$Mask = $Mask.",'clearMaskOnLostFocus':$FieldConfig->{clearMaskOnLostFocus},'removeMaskOnSubmit':$FieldConfig->{removeMaskOnSubmit}";
		$Mask = $Mask.",'clearIncomplete':$FieldConfig->{clearIncomplete}";
	}

    my $MaxChars      = ($FieldConfig->{MaxChars}) ? "maxlength='$FieldConfig->{MaxChars}'" : "";
    my $CaseType      = ($FieldConfig->{CaseType} == 0) ? "none" : (($FieldConfig->{CaseType} == 1) ? "uppercase" : "lowercase");
    my $CaseFunction  = ""; 
    if ($FieldConfig->{CaseType} == 1) { 
        $CaseFunction = " onkeyup=\"\$('#$FieldName').val(\$('#$FieldName').val().toUpperCase());\" ";
    } elsif ($FieldConfig->{CaseType} == 2) {
        $CaseFunction = " onkeyup=\"\$('#$FieldName').val(\$('#$FieldName').val().toLowerCase());\" ";
    }

    my $HTMLString    = <<"EOF";
<input type="text" class="$FieldClass" $CaseFunction id="$FieldName" name="$FieldName" title="$FieldLabelEscaped" value="$ValueEscaped" $MaxChars data-inputmask="$Mask"
 />
EOF

    if ($FieldConfig->{InputType} == 1) {
        $HTMLString = <<"EOF";
<textarea class="$FieldClass" id="$FieldName" $CaseFunction name="$FieldName" title="$FieldLabelEscaped" $MaxChars data-inputmask="$Mask">$ValueEscaped</textarea>
EOF
    }

    $HTMLString .= <<"EOF";
<style>
#$FieldName { text-transform: $CaseType !important; }
</style>
<script>
var inputMaskDelayed = ( typeof inputMaskDelayed != 'undefined' && inputMaskDelayed instanceof Array ) ? inputMaskDelayed : [];
inputMaskDelayed.push(
    function(){
        \$('#$FieldName').inputmask({
          oncleared: function() {
            \$(this).val('');
          }
        });
    }
)
</script>
EOF

    if ( $Param{Mandatory} ) {
        my $DivID = $FieldName . 'Error';

        my $FieldRequiredMessage = $Param{LayoutObject}->{LanguageObject}->Translate("This field is required.");

        # for client side validation
        $HTMLString .= <<"EOF";
<div id="$DivID" class="TooltipErrorMessage">
    <p>
        $FieldRequiredMessage
    </p>
</div>
EOF
    }

    if ( $Param{ServerError} ) {

        my $ErrorMessage = $Param{ErrorMessage} || 'This field is required.';
        $ErrorMessage = $Param{LayoutObject}->{LanguageObject}->Translate($ErrorMessage);
        my $DivID = $FieldName . 'ServerError';

        # for server side validation
        $HTMLString .= <<"EOF";
<div id="$DivID" class="TooltipErrorMessage">
    <p>
        $ErrorMessage
    </p>
</div>
EOF
    }

    # call EditLabelRender on the common Driver
    my $LabelString = $Self->EditLabelRender(
        %Param,
        Mandatory => $Param{Mandatory} || '0',
        FieldName => $FieldName,
    );

    my $Data = {
        Field => $HTMLString,
        Label => $LabelString,
    };

    return $Data;
}
1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
