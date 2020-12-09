# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::CustomFields;

use strict;
use warnings;
use POSIX;

use Kernel::System::VariableCheck qw(:all);
use Kernel::Language qw(Translatable);

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
	
	my $JSONObject = $Kernel::OM->Get('Kernel::System::JSON');
	my $ParamObject =  $Kernel::OM->Get("Kernel::System::Web::Request");
	my $LayoutObject = $Kernel::OM->Get("Kernel::Output::HTML::Layout");
    my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');
	my $BackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');	
	my $Ini = $Kernel::OM->Get('Kernel::Config')->Get('Ticket::Complemento::AccountedTime::DynamicFieldStartID');
    my $End = $Kernel::OM->Get('Kernel::Config')->Get('Ticket::Complemento::AccountedTime::DynamicFieldEndID');

    my $DynamicFieldIni = $DynamicFieldObject->DynamicFieldGet(
    	ID   => $Ini,             # ID or Name must be provided
    );
    my $DynamicFieldEnd = $DynamicFieldObject->DynamicFieldGet(
    	ID   => $End,             # ID or Name must be provided
    );

	my $Subaction = $ParamObject->GetParam(Param => 'Subaction');
	if($Subaction eq 'CustomFieldsAjax'){
		my $ArticleID = $ParamObject->GetParam(Param => 'ArticleID');
		my $ValueIni = $BackendObject->ValueGet(
        	DynamicFieldConfig => $DynamicFieldIni,      # complete config of the DynamicField
	        ObjectID           => $ArticleID,                # ID of the current object that the field
                                                        # must be linked to, e. g. TicketID
        );	
		my $ValueEnd = $BackendObject->ValueGet(
        	DynamicFieldConfig => $DynamicFieldEnd,      # complete config of the DynamicField
	        ObjectID           => $ArticleID,                # ID of the current object that the field
                                                        # must be linked to, e. g. TicketID
        );	
		if($ValueIni){
			my $DateTimeInit = $Kernel::OM->Create(
				'Kernel::System::DateTime',
				ObjectParams => {
					String   => $ValueIni,
					TimeZone => 'UTC',        # optional, defaults to setting of SysConfig OTRSTimeZone
				}
			);
			$DateTimeInit->ToTimeZone(TimeZone => $Self->{UserTimeZone});
			$ValueIni = $DateTimeInit->Format( Format => '%d/%m/%Y %H:%M:%S' );
		}
		if($ValueEnd){
			my $DateTimeEnd = $Kernel::OM->Create(
				'Kernel::System::DateTime',
				ObjectParams => {
					String   => $ValueEnd,
					TimeZone => 'UTC',        # optional, defaults to setting of SysConfig OTRSTimeZone
				}
			);
			$DateTimeEnd->ToTimeZone(TimeZone => $Self->{UserTimeZone});
			$ValueEnd = $DateTimeEnd->Format( Format => '%d/%m/%Y %H:%M:%S' );
		}
		$ValueIni = 0 if(!$ValueIni);	
		$ValueEnd = 0 if(!$ValueEnd);
		my	 $HTML ='<td class="Start"><a href="#">'.$ValueIni.' </a><input type="hidden" class="SortData" value="'.$ValueIni.'"></td>	<td class="End"><a href="#"> '.$ValueEnd.' </a><input type="hidden" class="SortData" value=" '.$ValueEnd.'"></td>';	
		
		return $LayoutObject->Attachment(
            ContentType => 'application/html; charset=' . $LayoutObject->{Charset},
            Content     => $HTML	,
            Type        => 'inline',
            NoCache     => 1,
			Sandbox => 1	
        );	
	}elsif($Subaction eq 'AjaxFields'){
		my %JsonFields = (
			Ini => $DynamicFieldIni->{Name},
			End => $DynamicFieldEnd->{Name}
		);
		my $JSON = $JSONObject->Encode(
			Data => \%JsonFields
		);			
		return $LayoutObject->Attachment(
            ContentType => 'application/json; charset=' . $LayoutObject->{Charset},
            Content     => $JSON	,
            Type        => 'inline',
            NoCache     => 1,
			Sandbox => 1	
        );	

	}

    	
}
sub _OrderDate {

	my $OldDate = shift;
	my ($Year,$Month,$Rest) = split("-", $OldDate);
	my ($Day, $Time) = split(" ", $Rest);
	my ($Hour, $Min, $Sec) = split(":", $Time);
	$Year = substr($Year,2);
	my $NewDate = $Day."/".$Month."/".$Year." ".$Hour.":".$Min;	
	return $NewDate
	
}


1;
