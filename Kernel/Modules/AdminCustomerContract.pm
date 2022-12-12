# --
# Copyright (C) 2001-2018 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AdminCustomerContract;

use strict;
use warnings;

use Kernel::System::CheckItem;
use Kernel::Language qw(Translatable);
use Data::Dumper;

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

    my $ParamObject  = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    my $Nav    = $ParamObject->GetParam( Param => 'Nav' )    || '';
    my $Source = $ParamObject->GetParam( Param => 'Source' ) || 'CustomerUser';
    my $Search = $ParamObject->GetParam( Param => 'Search' );
    $Search
        ||= $ConfigObject->Get('AdminCustomerUser::RunInitialWildcardSearch') ? '*' : '';

    # create local object
    my $CheckItemObject = $Kernel::OM->Get('Kernel::System::CheckItem');

    my $NavBar       = '';
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    if ( $Nav eq 'None' ) {
        $NavBar = $LayoutObject->Header( Type => 'Small' );
    }
    else {
        $NavBar = $LayoutObject->Header();
        $NavBar .= $LayoutObject->NavigationBar(
            Type => $Nav eq 'Agent' ? 'Customers' : 'Admin',
        );
    }

    # Get list of valid IDs.
    my @ValidIDList = $Kernel::OM->Get('Kernel::System::Valid')->ValidIDsGet();

    my $CustomerContractObject = $Kernel::OM->Get('Kernel::System::CustomerContract');
    my $MainObject         = $Kernel::OM->Get('Kernel::System::Main');

    # search user list
    if ( $Self->{Subaction} eq 'Search' ) {
        $Self->_Overview(
            Nav    => $Nav,
            Search => $Search,
        );
        my $Output = $NavBar;
        $Output .= $LayoutObject->Output(
            TemplateFile => 'AdminCustomerContract',
            Data         => \%Param,
        );

        if ( $Nav eq 'None' ) {
            $Output .= $LayoutObject->Footer( Type => 'Small' );
        }
        else {
            $Output .= $LayoutObject->Footer();
        }

        return $Output;
    }

    # ------------------------------------------------------------ #
    # change
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'Change' ) {
        my $Contract = $ParamObject->GetParam( Param => 'ID' ) || '';

        # get user data
        my $ContractData = $CustomerContractObject->CustomerContractDataGet( ID => $Contract );

        my $Output = $NavBar;
        $Output .= $Self->_Edit(
            Nav    => $Nav,
            Action => 'Change',
            Source => $Source,
            Search => $Search,
            ID     => $Contract,
            Number => $ContractData->{Number},
            CustomerID => $ContractData->{CustomerID},
            PeriodClosing => $ContractData->{PeriodClosing},
            DateType => $ContractData->{DateType},
            StartTime => $ContractData->{StartTime},
            EndTime => $ContractData->{EndTime},
            RelatedTo => $ContractData->{RelatedTo},
            RelatedToPeriod => $ContractData->{RelatedToPeriod},
            ValidID => $ContractData->{ValidID},
        );

        if ( $Nav eq 'None' ) {
            $Output .= $LayoutObject->Footer( Type => 'Small' );
        }
        else {
            $Output .= $LayoutObject->Footer();
        }       

        return $Output;
    }

    # ------------------------------------------------------------ #
    # change action
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'ChangeAction' ) {

        # challenge token check for write action
        $LayoutObject->ChallengeTokenCheck();

        my $Note = '';
        my ( %GetParam, %Errors );

            my $TimeObject = $Kernel::OM->Get('Kernel::System::Time');

            my $ID = $ParamObject->GetParam( Param => 'ID' )  || '';
            my $CustomerID = $ParamObject->GetParam( Param => 'CustomerID' )  || '';
            my $Number = $ParamObject->GetParam( Param => 'Number' )  || '';
            my $PeriodClosing = $ParamObject->GetParam( Param => 'PeriodClosing' )  || '';
            my $StartTime = $ParamObject->GetParam( Param => 'FromDateYear' ).'-'.$ParamObject->GetParam( Param => 'FromDateMonth' ).'-'.$ParamObject->GetParam( Param => 'FromDateDay' );
            my $EndTime = $ParamObject->GetParam( Param => 'ToDateYear' ).'-'.$ParamObject->GetParam( Param => 'ToDateMonth' ).'-'.$ParamObject->GetParam( Param => 'ToDateDay' );
            my $RelatedTo = $ParamObject->GetParam( Param => 'RelatedTo' )  || '0';
            my $RelatedToPeriod = $ParamObject->GetParam( Param => 'RelatedToPeriod' )  || '';
            my $ValidID = $ParamObject->GetParam( Param => 'ValidID' )  || '';
            my $DateType = $ParamObject->GetParam( Param => 'DateType' )  || '';

            if($RelatedTo eq ''){
                $RelatedTo = '0';
            }
                

            # add user
            my $Contract = $CustomerContractObject->CustomerContractUpdate(
                ID => $ID,
                CustomerID => $CustomerID,
                Number => $Number,
                PeriodClosing => $PeriodClosing,
                StartTime => $StartTime,
                EndTime => $EndTime,
                RelatedTo => $RelatedTo,
                RelatedToPeriod => $RelatedToPeriod,
                ValidID => $ValidID,
                DateType => $DateType,
            );
            my $Output;
            if ($Contract) {

                    $Self->_Overview(
                        Nav    => $Nav,
                        Search => $Search,
                    );
                    my $Output = $NavBar;
                    $Output .= $LayoutObject->Output(
                        TemplateFile => 'AdminCustomerContract',
                        Data         => \%Param,
                    );

                    if ( $Nav eq 'None' ) {
                        $Output .= $LayoutObject->Footer( Type => 'Small' );
                    }
                    else {
                        $Output .= $LayoutObject->Footer();
                    }

                    return $Output;
                
            }
            else {
                #$Note .= $LayoutObject->Notify( Priority => 'Error' );
            }
        

        # something has gone wrong
        $Output = $NavBar . $Note;
        $Output .= $Self->_Edit(
            Nav    => $Nav,
            Action => 'Add',
            Source => $Source,
            Search => $Search,
            %$Self,
        );

        if ( $Nav eq 'None' ) {
            $Output .= $LayoutObject->Footer( Type => 'Small' );
        }
        else {
            $Output .= $LayoutObject->Footer();
        }

        return $Output;
    }

    # ------------------------------------------------------------ #
    # add
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'Add' ) {
        my %GetParam;
        $GetParam{UserLogin}  = $ParamObject->GetParam( Param => 'UserLogin' )  || '';
        $GetParam{CustomerID} = $ParamObject->GetParam( Param => 'CustomerID' ) || '';
        my $Output = $NavBar;
        $Output .= $Self->_Edit(
            Nav    => $Nav,
            Action => 'Add',
            Source => $Source,
            Search => $Search,
            %GetParam,
        );

        if ( $Nav eq 'None' ) {
            $Output .= $LayoutObject->Footer( Type => 'Small' );
        }
        else {
            $Output .= $LayoutObject->Footer();
        }

        return $Output;
    }

    # ------------------------------------------------------------ #
    # add action
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'AddAction' ) {

        # challenge token check for write action
        $LayoutObject->ChallengeTokenCheck();

        my $Note = '';
        my ( %GetParam, %Errors );

            my $TimeObject = $Kernel::OM->Get('Kernel::System::Time');

            my $CustomerID = $ParamObject->GetParam( Param => 'CustomerID' )  || '';
            my $Number = $ParamObject->GetParam( Param => 'Number' )  || '';
            my $PeriodClosing = $ParamObject->GetParam( Param => 'PeriodClosing' )  || '';
            my $StartTime = $ParamObject->GetParam( Param => 'FromDateYear' ).'-'.$ParamObject->GetParam( Param => 'FromDateMonth' ).'-'.$ParamObject->GetParam( Param => 'FromDateDay' );
            my $EndTime = $ParamObject->GetParam( Param => 'ToDateYear' ).'-'.$ParamObject->GetParam( Param => 'ToDateMonth' ).'-'.$ParamObject->GetParam( Param => 'ToDateDay' );
            my $RelatedTo = $ParamObject->GetParam( Param => 'RelatedTo' )  || '0';
            my $RelatedToPeriod = $ParamObject->GetParam( Param => 'RelatedToPeriod' )  || '';
            my $ValidID = $ParamObject->GetParam( Param => 'ValidID' )  || '';
            my $DateType = $ParamObject->GetParam( Param => 'DateType' )  || '0';

            my $SystemTime = $TimeObject->SystemTime();
            if($DateType == 1){
                $StartTime = $TimeObject->CurrentTimestamp();
                if($RelatedToPeriod eq "year(s)"){
                    $SystemTime = $SystemTime + ($RelatedTo * 365 * 24 * 60 * 60);
                }
                elsif($RelatedToPeriod eq "day(s)"){
                    $SystemTime = $SystemTime + ($RelatedTo * 24 * 60 * 60);
                }
                elsif($RelatedToPeriod eq "month(s)"){
                    $SystemTime = $SystemTime + ($RelatedTo * 30 * 24 * 60 * 60);
                }
                elsif($RelatedToPeriod eq "week(s)"){
                    $SystemTime = $SystemTime + ($RelatedTo * 7 * 24 * 60 * 60);
                }
                else{
                    $SystemTime = $SystemTime + ($RelatedTo * 365 * 24 * 60 * 60);
                }
                $EndTime = $TimeObject->SystemTime2TimeStamp(
                    SystemTime => $SystemTime,
                );
            }

            # add user
            my $Contract = $CustomerContractObject->CustomerContractAdd(
                CustomerID => $CustomerID,
                Number => $Number,
                PeriodClosing => $PeriodClosing,
                StartTime => $StartTime,
                EndTime => $EndTime,
                RelatedTo => $RelatedTo,
                RelatedToPeriod => $RelatedToPeriod,
                ValidID => $ValidID,
                DateType => $DateType,
            );
            my $Output;
            if ($Contract) {
                    # get user data
                    my $ContractData = $CustomerContractObject->CustomerContractDataGet( ID => $Contract );

                    my $Output = $NavBar;
                    $Output .= $Self->_Edit(
                        Nav    => $Nav,
                        Action => 'Change',
                        Source => $Source,
                        Search => $Search,
                        ID     => $Contract,
                        Number => $ContractData->{Number},
                        CustomerID => $ContractData->{CustomerID},
                        PeriodClosing => $ContractData->{PeriodClosing},
                        StartTime => $ContractData->{StartTime},
                        EndTime => $ContractData->{EndTime},
                        RelatedTo => $ContractData->{RelatedTo},
                        RelatedToPeriod => $ContractData->{RelatedToPeriod},
                        ValidID => $ContractData->{ValidID},
                    );

                    if ( $Nav eq 'None' ) {
                        $Output .= $LayoutObject->Footer( Type => 'Small' );
                    }
                    else {
                        $Output .= $LayoutObject->Footer();
                    }       

                    return $Output;
                
            }
            else {
                #$Note .= $LayoutObject->Notify( Priority => 'Error' );
            }
        

        # something has gone wrong
        $Output = $NavBar . $Note;
        $Output .= $Self->_Edit(
            Nav    => $Nav,
            Action => 'Add',
            Source => $Source,
            Search => $Search,
            %$Self,
        );

        if ( $Nav eq 'None' ) {
            $Output .= $LayoutObject->Footer( Type => 'Small' );
        }
        else {
            $Output .= $LayoutObject->Footer();
        }

        return $Output;
    }

    elsif ( $Self->{Subaction} eq 'AddPriceRuleAction' ) {

        # challenge token check for write action
        $LayoutObject->ChallengeTokenCheck();

        my $ContractID = $ParamObject->GetParam( Param => 'ContractID' )  || '';
        my @TypeIDs = $ParamObject->GetArray( Param => 'TypeIDs' );
        my @TreatmentTypes = $ParamObject->GetArray( Param => 'TreatmentTypes' );
        my @SLAIDs = $ParamObject->GetArray( Param => 'SLAIDs' );
        my @ServiceIDs = $ParamObject->GetArray( Param => 'ServiceIDs' );
        my @HourIDs = $ParamObject->GetArray( Param => 'HourIDs' );
        my $Valor = $ParamObject->GetParam( Param => 'Valor' )  || '';

        my $RuleID =$CustomerContractObject->PriceRuleAdd(
            ContractID => $ContractID,
            Value => $Valor,
        );

        if($RuleID){
            for my $TypeID (@TypeIDs){
                $CustomerContractObject->PriceRuleTicketTypeAdd(
                    ContractPriceRuleID => $RuleID,
                    TicketTypeID => $TypeID,
                );
            }

            for my $TreatmentType (@TreatmentTypes){
                $CustomerContractObject->PriceRuleTreatmentTypeAdd(
                    ContractPriceRuleID => $RuleID,
                    TreatmentType => $TreatmentType,
                );
            }

            for my $SLAID (@SLAIDs){
                $CustomerContractObject->PriceRuleSlaAdd(
                    ContractPriceRuleID => $RuleID,
                    SLAID => $SLAID,
                );
            }

            for my $ServiceID (@ServiceIDs){
                $CustomerContractObject->PriceRuleServiceAdd(
                    ContractPriceRuleID => $RuleID,
                    ServiceID => $ServiceID,
                );
            }

            for my $Hour (@HourIDs){
                $CustomerContractObject->PriceRuleHourTypeAdd(
                    ContractPriceRuleID => $RuleID,
                    HourType => $Hour,
                );
            }
        }

        my $ContractData = $CustomerContractObject->CustomerContractDataGet( ID => $ContractID );

        my $Output = $NavBar;
        $Output .= $Self->_Edit(
            Nav    => $Nav,
            Action => 'Change',
            Source => $Source,
            Search => $Search,
            ID     => $ContractID,
            Number => $ContractData->{Number},
            CustomerID => $ContractData->{CustomerID},
            Type => $ContractData->{Type},
            DateType => $ContractData->{DateType},
            StartTime => $ContractData->{StartTime},
            EndTime => $ContractData->{EndTime},
            RelatedTo => $ContractData->{RelatedTo},
            RelatedToPeriod => $ContractData->{RelatedToPeriod},
            ValidID => $ContractData->{ValidID},
        );

        if ( $Nav eq 'None' ) {
            $Output .= $LayoutObject->Footer( Type => 'Small' );
        }
        else {
            $Output .= $LayoutObject->Footer();
        }       

        return $Output;
    }

    elsif ( $Self->{Subaction} eq 'AddFranchiseRuleAction' ) {

        # challenge token check for write action
        $LayoutObject->ChallengeTokenCheck();

        my $ContractID = $ParamObject->GetParam( Param => 'ContractID' ) || '';
        my @TypeIDs = $ParamObject->GetArray( Param => 'TypeIDs' );
        my @TreatmentTypes = $ParamObject->GetArray( Param => 'TreatmentTypes' );
        my @SLAIDs = $ParamObject->GetArray( Param => 'SLAIDs' );
        my @ServiceIDs = $ParamObject->GetArray( Param => 'ServiceIDs' );
        my @HourIDs = $ParamObject->GetArray( Param => 'HourIDs' );
        my $Recurrence = $ParamObject->GetParam( Param => 'Recurrence' )  || '';
        my $Hours = $ParamObject->GetParam( Param => 'Hours' )  || '';

        my $RuleID =$CustomerContractObject->FranchiseRuleAdd(
            ContractID => $ContractID,
            Hours => $Hours,
            Recurrence => $Recurrence
        );

        if($RuleID){
            for my $TypeID (@TypeIDs){
                $CustomerContractObject->FranchiseRuleTicketTypeAdd(
                    ContractFranchiseRuleID => $RuleID,
                    TicketTypeID => $TypeID,
                );
            }

            for my $TreatmentType (@TreatmentTypes){
                $CustomerContractObject->FranchiseRuleTreatmentTypeAdd(
                    ContractFranchiseRuleID => $RuleID,
                    TreatmentType => $TreatmentType,
                );
            }

            for my $SLAID (@SLAIDs){
                $CustomerContractObject->FranchiseRuleSlaAdd(
                    ContractFranchiseRuleID => $RuleID,
                    SLAID => $SLAID,
                );
            }

            for my $ServiceID (@ServiceIDs){
                $CustomerContractObject->FranchiseRuleServiceAdd(
                    ContractFranchiseRuleID => $RuleID,
                    ServiceID => $ServiceID,
                );
            }

            for my $Hour (@HourIDs){
                $CustomerContractObject->FranchiseRuleHourTypeAdd(
                    ContractFranchiseRuleID => $RuleID,
                    HourType => $Hour,
                );
            }
        }

        my $ContractData = $CustomerContractObject->CustomerContractDataGet( ID => $ContractID );

        my $Output = $NavBar;
        $Output .= $Self->_Edit(
            Nav    => $Nav,
            Action => 'Change',
            Source => $Source,
            Search => $Search,
            ID     => $ContractID,
            Number => $ContractData->{Number},
            CustomerID => $ContractData->{CustomerID},
            Type => $ContractData->{Type},
            DateType => $ContractData->{DateType},
            StartTime => $ContractData->{StartTime},
            EndTime => $ContractData->{EndTime},
            RelatedTo => $ContractData->{RelatedTo},
            RelatedToPeriod => $ContractData->{RelatedToPeriod},
            ValidID => $ContractData->{ValidID},
        );

        if ( $Nav eq 'None' ) {
            $Output .= $LayoutObject->Footer( Type => 'Small' );
        }
        else {
            $Output .= $LayoutObject->Footer();
        }       

        return $Output;
    }

    elsif ( $Self->{Subaction} eq 'UpdFranchiseRuleAction' ) {

        # challenge token check for write action
        $LayoutObject->ChallengeTokenCheck();

        my $ContractID = $ParamObject->GetParam( Param => 'ContractID' ) || '';
        my @TypeIDs = $ParamObject->GetArray( Param => 'TypeIDs' );
        my @TreatmentTypes = $ParamObject->GetArray( Param => 'TreatmentTypes' );
        my @SLAIDs = $ParamObject->GetArray( Param => 'SLAIDs' );
        my @ServiceIDs = $ParamObject->GetArray( Param => 'ServiceIDs' );
        my @HourIDs = $ParamObject->GetArray( Param => 'HourIDs' );
        my $Recurrence = $ParamObject->GetParam( Param => 'Recurrence' )  || '';
        my $Hours = $ParamObject->GetParam( Param => 'Hours' )  || '';
        my $RuleID = $ParamObject->GetParam( Param => 'RuleID' ) || '';   

        if($RuleID){
            $CustomerContractObject->FranchiseRuleRecurrenceUpd(
                ContractFranchiseRuleID => $RuleID,
                ContractID => $ContractID,
                Recurrence => $Recurrence,
            );

            $CustomerContractObject->FranchiseRuleHoursUpd(
                ContractFranchiseRuleID => $RuleID,
                ContractID => $ContractID,
                Hours => $Hours,
            );            

            for my $TypeID (@TypeIDs){
                $CustomerContractObject->FranchiseRuleTicketTypeUpd(
                    ContractFranchiseRuleID => $RuleID,
                    TicketTypeID => $TypeID,
                );
            }

            for my $TreatmentType (@TreatmentTypes){
                $CustomerContractObject->FranchiseRuleTreatmentTypeUpd(
                    ContractFranchiseRuleID => $RuleID,
                    TreatmentType => $TreatmentType,
                );
            }

            for my $SLAID (@SLAIDs){
                $CustomerContractObject->FranchiseRuleSlaUpd(
                    ContractFranchiseRuleID => $RuleID,
                    SLAID => $SLAID,
                );
            }

            for my $ServiceID (@ServiceIDs){
                $CustomerContractObject->FranchiseRuleServiceUpd(
                    ContractFranchiseRuleID => $RuleID,
                    ServiceID => $ServiceID,
                );
            }

            for my $Hour (@HourIDs){
                $CustomerContractObject->FranchiseRuleHourTypeUpd(
                    ContractFranchiseRuleID => $RuleID,
                    HourType => $Hour,
                );
            }
        }

        my $ContractData = $CustomerContractObject->CustomerContractDataGet( ID => $ContractID );

        my $Output = $NavBar;
        $Output .= $Self->_Edit(
            Nav    => $Nav,
            Action => 'Change',
            Source => $Source,
            Search => $Search,
            ID     => $ContractID,
            Number => $ContractData->{Number},
            CustomerID => $ContractData->{CustomerID},
            Type => $ContractData->{Type},
            DateType => $ContractData->{DateType},
            StartTime => $ContractData->{StartTime},
            EndTime => $ContractData->{EndTime},
            RelatedTo => $ContractData->{RelatedTo},
            RelatedToPeriod => $ContractData->{RelatedToPeriod},
            ValidID => $ContractData->{ValidID},
        );

        if ( $Nav eq 'None' ) {
            $Output .= $LayoutObject->Footer( Type => 'Small' );
        }
        else {
            $Output .= $LayoutObject->Footer();
        }       

        return $Output;
    }    

    elsif ( $Self->{Subaction} eq 'RemovePriceRole' ) {

        my $ContractID = $ParamObject->GetParam( Param => 'ContractID' )  || '';
        my $RuleID = $ParamObject->GetParam( Param => 'RuleID' ) || '';

        $CustomerContractObject->CustomerContractPriceRuleRemove( ID => $RuleID );

        my $ContractData = $CustomerContractObject->CustomerContractDataGet( ID => $ContractID );

        my $Output = $NavBar;
        $Output .= $Self->_Edit(
            Nav    => $Nav,
            Action => 'Change',
            Source => $Source,
            Search => $Search,
            ID     => $ContractID,
            Number => $ContractData->{Number},
            CustomerID => $ContractData->{CustomerID},
            Type => $ContractData->{Type},
            DateType => $ContractData->{DateType},
            StartTime => $ContractData->{StartTime},
            EndTime => $ContractData->{EndTime},
            RelatedTo => $ContractData->{RelatedTo},
            RelatedToPeriod => $ContractData->{RelatedToPeriod},
            ValidID => $ContractData->{ValidID},
        );

        if ( $Nav eq 'None' ) {
            $Output .= $LayoutObject->Footer( Type => 'Small' );
        }
        else {
            $Output .= $LayoutObject->Footer();
        }       

        return $Output;
    }


    elsif ( $Self->{Subaction} eq 'UpPriceRole' ) {

        my $ContractID = $ParamObject->GetParam( Param => 'ContractID' )  || '';
        my $RuleID = $ParamObject->GetParam( Param => 'RuleID' ) || '';

        $CustomerContractObject->UpPriceRule( ID => $RuleID );

        my $ContractData = $CustomerContractObject->CustomerContractDataGet( ID => $ContractID );

        my $Output = $NavBar;
        $Output .= $Self->_Edit(
            Nav    => $Nav,
            Action => 'Change',
            Source => $Source,
            Search => $Search,
            ID     => $ContractID,
            Number => $ContractData->{Number},
            CustomerID => $ContractData->{CustomerID},
            Type => $ContractData->{Type},
            DateType => $ContractData->{DateType},
            StartTime => $ContractData->{StartTime},
            EndTime => $ContractData->{EndTime},
            RelatedTo => $ContractData->{RelatedTo},
            RelatedToPeriod => $ContractData->{RelatedToPeriod},
            ValidID => $ContractData->{ValidID},
        );

        if ( $Nav eq 'None' ) {
            $Output .= $LayoutObject->Footer( Type => 'Small' );
        }
        else {
            $Output .= $LayoutObject->Footer();
        }       

        return $Output;
    }

    elsif ( $Self->{Subaction} eq 'DownPriceRole' ) {

        my $ContractID = $ParamObject->GetParam( Param => 'ContractID' )  || '';
        my $RuleID = $ParamObject->GetParam( Param => 'RuleID' ) || '';

        $CustomerContractObject->DownPriceRule( ID => $RuleID );

        my $ContractData = $CustomerContractObject->CustomerContractDataGet( ID => $ContractID );

        my $Output = $NavBar;
        $Output .= $Self->_Edit(
            Nav    => $Nav,
            Action => 'Change',
            Source => $Source,
            Search => $Search,
            ID     => $ContractID,
            Number => $ContractData->{Number},
            CustomerID => $ContractData->{CustomerID},
            Type => $ContractData->{Type},
            DateType => $ContractData->{DateType},
            StartTime => $ContractData->{StartTime},
            EndTime => $ContractData->{EndTime},
            RelatedTo => $ContractData->{RelatedTo},
            RelatedToPeriod => $ContractData->{RelatedToPeriod},
            ValidID => $ContractData->{ValidID},
        );

        if ( $Nav eq 'None' ) {
            $Output .= $LayoutObject->Footer( Type => 'Small' );
        }
        else {
            $Output .= $LayoutObject->Footer();
        }       

        return $Output;
    }

    elsif ( $Self->{Subaction} eq 'UpFranchiseRole' ) {

        my $ContractID = $ParamObject->GetParam( Param => 'ContractID' )  || '';
        my $RuleID = $ParamObject->GetParam( Param => 'RuleID' ) || '';

        $CustomerContractObject->UpFranchiseRule( ID => $RuleID );

        my $ContractData = $CustomerContractObject->CustomerContractDataGet( ID => $ContractID );

        my $Output = $NavBar;
        $Output .= $Self->_Edit(
            Nav    => $Nav,
            Action => 'Change',
            Source => $Source,
            Search => $Search,
            ID     => $ContractID,
            Number => $ContractData->{Number},
            CustomerID => $ContractData->{CustomerID},
            Type => $ContractData->{Type},
            DateType => $ContractData->{DateType},
            StartTime => $ContractData->{StartTime},
            EndTime => $ContractData->{EndTime},
            RelatedTo => $ContractData->{RelatedTo},
            RelatedToPeriod => $ContractData->{RelatedToPeriod},
            ValidID => $ContractData->{ValidID},
        );

        if ( $Nav eq 'None' ) {
            $Output .= $LayoutObject->Footer( Type => 'Small' );
        }
        else {
            $Output .= $LayoutObject->Footer();
        }       

        return $Output;
    }

    elsif ( $Self->{Subaction} eq 'DownFranchiseRole' ) {

        my $ContractID = $ParamObject->GetParam( Param => 'ContractID' )  || '';
        my $RuleID = $ParamObject->GetParam( Param => 'RuleID' ) || '';

        $CustomerContractObject->DownFranchiseRule( ID => $RuleID );

        my $ContractData = $CustomerContractObject->CustomerContractDataGet( ID => $ContractID );

        my $Output = $NavBar;
        $Output .= $Self->_Edit(
            Nav    => $Nav,
            Action => 'Change',
            Source => $Source,
            Search => $Search,
            ID     => $ContractID,
            Number => $ContractData->{Number},
            CustomerID => $ContractData->{CustomerID},
            Type => $ContractData->{Type},
            DateType => $ContractData->{DateType},
            StartTime => $ContractData->{StartTime},
            EndTime => $ContractData->{EndTime},
            RelatedTo => $ContractData->{RelatedTo},
            RelatedToPeriod => $ContractData->{RelatedToPeriod},
            ValidID => $ContractData->{ValidID},
        );

        if ( $Nav eq 'None' ) {
            $Output .= $LayoutObject->Footer( Type => 'Small' );
        }
        else {
            $Output .= $LayoutObject->Footer();
        }       

        return $Output;
    }

    elsif ( $Self->{Subaction} eq 'RemoveFranchiseRole' ) {

        my $ContractID = $ParamObject->GetParam( Param => 'ContractID' )  || '';
        my $RuleID = $ParamObject->GetParam( Param => 'RuleID' ) || '';

        $CustomerContractObject->CustomerContractFranchiseRuleRemove( ID => $RuleID );

        my $ContractData = $CustomerContractObject->CustomerContractDataGet( ID => $ContractID );

        my $Output = $NavBar;
        $Output .= $Self->_Edit(
            Nav    => $Nav,
            Action => 'Change',
            Source => $Source,
            Search => $Search,
            ID     => $ContractID,
            Number => $ContractData->{Number},
            CustomerID => $ContractData->{CustomerID},
            Type => $ContractData->{Type},
            DateType => $ContractData->{DateType},
            StartTime => $ContractData->{StartTime},
            EndTime => $ContractData->{EndTime},
            RelatedTo => $ContractData->{RelatedTo},
            RelatedToPeriod => $ContractData->{RelatedToPeriod},
            ValidID => $ContractData->{ValidID},
        );

        if ( $Nav eq 'None' ) {
            $Output .= $LayoutObject->Footer( Type => 'Small' );
        }
        else {
            $Output .= $LayoutObject->Footer();
        }       

        return $Output;
    }

    elsif ( $Self->{Subaction} eq 'ViewContracts' ) {
        my $CustomerID = $ParamObject->GetParam( Param => 'CustomerID' )  || '';

        $Self->_OverviewCustomer(
            Nav    => $Nav,
            Search => $Search,
            CustomerID => $CustomerID
        );
        my $Output = $NavBar;
        $Output .= $LayoutObject->Output(
            TemplateFile => 'AdminCustomerContract',
            Data         => \%Param,
        );

        if ( $Nav eq 'None' ) {
            $Output .= $LayoutObject->Footer( Type => 'Small' );
        }
        else {
            $Output .= $LayoutObject->Footer();
        }

        return $Output;

    }

    elsif ( $Self->{Subaction} eq 'UpContract' ) {
        my $CustomerID = $ParamObject->GetParam( Param => 'CustomerID' )  || '';
        my $ContractID = $ParamObject->GetParam( Param => 'ID' )  || '';

        $CustomerContractObject->UpContract( ID => $ContractID );

        $Self->_OverviewCustomer(
            Nav    => $Nav,
            Search => $Search,
            CustomerID => $CustomerID
        );
        my $Output = $NavBar;
        $Output .= $LayoutObject->Output(
            TemplateFile => 'AdminCustomerContract',
            Data         => \%Param,
        );

        if ( $Nav eq 'None' ) {
            $Output .= $LayoutObject->Footer( Type => 'Small' );
        }
        else {
            $Output .= $LayoutObject->Footer();
        }

        return $Output;

    }

    elsif ( $Self->{Subaction} eq 'DownContract' ) {
        my $CustomerID = $ParamObject->GetParam( Param => 'CustomerID' )  || '';
        my $ContractID = $ParamObject->GetParam( Param => 'ID' )  || '';

        $CustomerContractObject->DownContract( ID => $ContractID );

        $Self->_OverviewCustomer(
            Nav    => $Nav,
            Search => $Search,
            CustomerID => $CustomerID
        );
        my $Output = $NavBar;
        $Output .= $LayoutObject->Output(
            TemplateFile => 'AdminCustomerContract',
            Data         => \%Param,
        );

        if ( $Nav eq 'None' ) {
            $Output .= $LayoutObject->Footer( Type => 'Small' );
        }
        else {
            $Output .= $LayoutObject->Footer();
        }

        return $Output;

    }

    elsif ( $Self->{Subaction} eq 'Details' ) {
        my $ContractID = $ParamObject->GetParam( Param => 'ID' )  || '';
        my $FromSearch = $ParamObject->GetParam( Param => 'FromSearch' )  || '';
        my $ToSearch = $ParamObject->GetParam( Param => 'ToSearch' )  || '';

        $Self->_Details(
            Nav    => $Nav,
            Search => $Search,
            ContractID => $ContractID,
            FromSearch => $FromSearch,
            ToSearch => $ToSearch
        );

        my $Output = $NavBar;
        $Output .= $LayoutObject->Output(
            TemplateFile => 'AdminCustomerContract',
            Data         => \%Param,
        );

        if ( $Nav eq 'None' ) {
            $Output .= $LayoutObject->Footer( Type => 'Small' );
        }
        else {
            $Output .= $LayoutObject->Footer();
        }

        return $Output;

    }

    # ------------------------------------------------------------ #
    # overview
    # ------------------------------------------------------------ #
    else {
        $Self->_Overview(
            Nav    => $Nav,
            Search => $Search,
        );
        my $Output = $NavBar;
        $Output .= $LayoutObject->Output(
            TemplateFile => 'AdminCustomerContract',
            Data         => \%Param,
        );

        if ( $Nav eq 'None' ) {
            $Output .= $LayoutObject->Footer( Type => 'Small' );
        }
        else {
            $Output .= $LayoutObject->Footer();
        }

        return $Output;
    }
}

sub _Overview {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    $LayoutObject->Block(
        Name => 'Overview',
        Data => \%Param,
    );

    $LayoutObject->Block( Name => 'ActionList' );
    $LayoutObject->Block(
        Name => 'ActionSearch',
        Data => \%Param,
    );

    my $CustomerContractObject = $Kernel::OM->Get('Kernel::System::CustomerContract');

    $LayoutObject->Block(
        Name => 'ActionAdd',
        Data => \%Param,
    );

    # when there is no data to show, a message is displayed on the table with this colspan
    my $ColSpan = 6;

    if ( $Param{Search} ) {

        # get config object
        my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

        # same Limit as $Self->{CustomerUserMap}->{CustomerUserSearchListLimit}
        # smallest Limit from all sources
        my $Limit = 400;
        
        my $List = $CustomerContractObject->CustomerSearch(
            Search => $Param{Search},
            Valid  => 0,
        );

        $LayoutObject->Block(
            Name => 'OverviewResult',
        );

        # if there are results to show
        if ($List && scalar(@$List) > 0) {
            my %ValidList = $Kernel::OM->Get('Kernel::System::Valid')->ValidList();

            for(my $i = 0; $i < scalar(@$List); $i++){

                my $UserData = $List->[$i];                

                #$LayoutObject->Block(
                #    Name => 'OverviewResultRow',
                #    Data => {
                #        Valid => $ValidList{ $UserData->{ValidID} || '' } || '-',
                #        Search      => $Param{Search},
                #        Number => $UserData->{Number},
                #        Type => $UserData->{Type},
                #        Customer => $UserData->{Customer},
                #        StartTime => $UserData->{StartTime},
                #        EndTime => $UserData->{EndTime},
                #        ID => $UserData->{ID},
                #    },
                #);

                $LayoutObject->Block(
                    Name => 'OverviewResultRow',
                    Data => {
                        Search      => $Param{Search},
                        CustomerID => $UserData->{CustomerID},
                        CustomerName => $UserData->{CustomerName},
                        ContractQuantity => $UserData->{ContractQuantity},
                    },
                );
            }
        }

        # otherwise it displays a no data found message
        else {
            $LayoutObject->Block(
                Name => 'NoDataFoundMsg',
                Data => {
                    ColSpan => $ColSpan,
                },
            );
        }
    }

    # if there is nothing to search it shows a message
    else
    {
        $LayoutObject->Block(
            Name => 'NoSearchTerms',
            Data => {},
        );
    }

    if ( $Param{Nav} eq 'None' ) {
        $LayoutObject->Block( Name => 'BorrowedViewJS' );
    }
}

sub _OverviewCustomer {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    

    $LayoutObject->Block(
        Name => 'Overview',
        Data => \%Param,
    );

    $LayoutObject->Block(
        Name => 'CustomerID',
        Data => \%Param,
    );

    $LayoutObject->Block( Name => 'ActionList' );
    $LayoutObject->Block(
        Name => 'ActionOverview',
        Data => \%Param,
    );

    my %CustomerCompany = $Kernel::OM->Get('Kernel::System::CustomerCompany')->CustomerCompanyGet(
        CustomerID => $Param{CustomerID},
    );  

    $LayoutObject->Block(
        Name => 'CustomerData',
        Data => \%CustomerCompany,
    );

    my $CustomerContractObject = $Kernel::OM->Get('Kernel::System::CustomerContract');

    $LayoutObject->Block(
        Name => 'ActionAdd',
        Data => \%Param,
    );

    # when there is no data to show, a message is displayed on the table with this colspan
    my $ColSpan = 6;

    if ( $Param{Search} ) {

        # get config object
        my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

        # same Limit as $Self->{CustomerUserMap}->{CustomerUserSearchListLimit}
        # smallest Limit from all sources
        my $Limit = 400;
        
        my $List = $CustomerContractObject->CustomerContractsSearch(
            Search => ($Param{CustomerID} ne '') ? $Param{CustomerID} : $Param{Search},
            Valid  => 0,
        );

        $LayoutObject->Block(
            Name => 'OverviewResultContracts',
        );

        # if there are results to show
        if ($List && scalar(@$List) > 0) {
            my %ValidList = $Kernel::OM->Get('Kernel::System::Valid')->ValidList();

            for(my $i = 0; $i < scalar(@$List); $i++){

                my $UserData = $List->[$i];                

                $LayoutObject->Block(
                    Name => 'OverviewResultRowContracts',
                    Data => {
                        Valid => $ValidList{ $UserData->{ValidID} || '' } || '-',
                        Search      => $Param{Search},
                        Number => $UserData->{Number},
                        PeriodClosing => $UserData->{PeriodClosing},
                        Customer => $UserData->{Customer},
                        StartTime => $UserData->{StartTime},
                        EndTime => $UserData->{EndTime},
                        ID => $UserData->{ID},
                        OrderNumber => $UserData->{OrderNumber},
                        IsTheLast => $UserData->{OrderNumber} == @$List,
                    },
                );
            }
        }

        # otherwise it displays a no data found message
        else {
            $LayoutObject->Block(
                Name => 'NoDataFoundMsgContracts',
                Data => {
                    ColSpan => $ColSpan,
                },
            );
        }
    }

    # if there is nothing to search it shows a message
    else
    {
        $LayoutObject->Block(
            Name => 'NoSearchTerms',
            Data => {},
        );
    }

    if ( $Param{Nav} eq 'None' ) {
        $LayoutObject->Block( Name => 'BorrowedViewJS' );
    }
}

sub _Details {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $CustomerContractObject = $Kernel::OM->Get('Kernel::System::CustomerContract');

    #Get Contract Data
    my $ContractData = $CustomerContractObject->CustomerContractDataGet( ID => $Param{ContractID} );

    my $FromSearchDB = $Param{FromSearch};
    $FromSearchDB =~ s{^(\d{2})/(\d{2})/(\d{4})$}{$3-$2-$1};

    my $ToSearchDB = $Param{ToSearch};
    $ToSearchDB =~ s{^(\d{2})/(\d{2})/(\d{4})$}{$3-$2-$1};

    #Get Use Rules Data

    $LayoutObject->Block(
        Name => 'Overview',
        Data => \%Param,
    );

    $Param{CustomerID} = $ContractData->{CustomerID};
    $LayoutObject->Block(
        Name => 'CustomerID',
        Data => \%Param,
    );

    $LayoutObject->Block( Name => 'ActionList' );
    $LayoutObject->Block(
        Name => 'ActionOverview',
        Data => \%Param,
    );

    my %CustomerCompany = $Kernel::OM->Get('Kernel::System::CustomerCompany')->CustomerCompanyGet(
        CustomerID => $Param{CustomerID},
    );  

    $LayoutObject->Block(
        Name => 'CustomerData',
        Data => \%CustomerCompany,
    );

    $Param{ContractNumber} = $ContractData->{Number};
    $Param{PeriodClosing} = $ContractData->{PeriodClosing};
    $Param{StartTime} = $ContractData->{StartTime};
    $Param{EndTime} = $ContractData->{EndTime};
    $LayoutObject->Block(
        Name => 'ContractData',
        Data => \%Param,
    );

    $LayoutObject->Block(
        Name => 'ContractRulesRegistries',
        Data => \%Param,
    );
    
    #Get Rules Data
    my $ContractPriceRules = $CustomerContractObject->ContactPriceRuleList(ContractID => $Param{ContractID});

    if($ContractPriceRules && (scalar @$ContractPriceRules) > 0){
      for my $PriceRule (@$ContractPriceRules){

        my $PriceRuleTicketTypes = $CustomerContractObject->PriceRuleTicketTypeList(ContractPriceRuleID => $PriceRule->{ID});
        my $TicketTypesStr = '*';
	if (scalar @$PriceRuleTicketTypes > 0) {
		my @arr;
		foreach my $x ( @$PriceRuleTicketTypes ) {
			push @arr, $x->{TicketTypeName};
		}
		$TicketTypesStr = join(', ', @arr);
	}

        my $PriceRuleTreatmentTypes = $CustomerContractObject->PriceRuleTreatmentTypeList(ContractPriceRuleID => $PriceRule->{ID});
        my $TreatmentTypesStr = '*';
	if (scalar @$PriceRuleTreatmentTypes > 0 ) {
		my @arr;
		foreach my $x ( @$PriceRuleTreatmentTypes ) {
			push @arr, $x->{TreatmentType};
		}
		$TreatmentTypesStr = join(', ', @arr);
	}

        my $PriceRuleSLAs = $CustomerContractObject->PriceRuleSLAList(ContractPriceRuleID => $PriceRule->{ID});
        my $SLAsStr = '*';
	if (scalar @$PriceRuleSLAs > 0 ) {
		my @arr;
		foreach my $x ( @$PriceRuleSLAs ) {
			push @arr, $x->{SLAName};
		}
		$SLAsStr = join(', ', @arr);
	}

        my $PriceRuleServices = $CustomerContractObject->PriceRuleServiceList(ContractPriceRuleID => $PriceRule->{ID});
        my $ServicesStr = '*';
	if (scalar @$PriceRuleServices > 0 ) {
		my @arr;
		foreach my $x ( @$PriceRuleServices ) {
			push @arr, $x->{ServiceName};
		}
		$ServicesStr = join(', ', @arr);
	}

        my $PriceRuleHourTypes = $CustomerContractObject->PriceRuleHourTypeList(ContractPriceRuleID => $PriceRule->{ID});
        my $HourTypesStr = '*';
	if (scalar @$PriceRuleHourTypes > 0 ) {
		my @arr;
		foreach my $x ( @$PriceRuleHourTypes ) {
			push @arr, $x->{HourType};
		}
		$HourTypesStr = join(', ', @arr);
	}

        $LayoutObject->Block(
            Name => 'PriceRuleReg',
            Data => {
              RuleID => $PriceRule->{Name},
              Value => $PriceRule->{Value},
              PriceRuleTicketTypes => $TicketTypesStr,
              TreatmentTypesStr => $TreatmentTypesStr,
              SLAsStr => $SLAsStr,
              ServicesStr => $ServicesStr,
              HourTypesStr => $HourTypesStr,
            },
        );

        $LayoutObject->Block(
            Name => 'PriceRuleRegResult',
        );

        my $PriceRegistries = $CustomerContractObject->GetPriceRulesRegistry(
          ContractPriceRuleID => $PriceRule->{ID},
          FromSearch => $FromSearchDB,
          ToSearch => $ToSearchDB,
        );

        

        if(scalar(@$PriceRegistries) == 0){
          $LayoutObject->Block(
            Name => 'PriceRuleRegResultNoData',
            Data => {
              ColSpan => 5
            }
          );
        }
        else{
          my $Total = 0;

          for my $PriceReg (@$PriceRegistries){

            my %TicketData = $Kernel::OM->Get('Kernel::System::Ticket')->TicketGet(
              'TicketID' => $PriceReg->{TicketID},
	      'UserID'   => 1
            );
            my %ArticleData = $Kernel::OM->Get('Kernel::System::Ticket::Article')->BackendForArticle(
              'TicketID'  => $PriceReg->{TicketID},
	      'ArticleID' => $PriceReg->{ArticleID}
	    )->ArticleGet(
              'TicketID'  => $PriceReg->{TicketID},
	      'ArticleID' => $PriceReg->{ArticleID}
	    );
            $LayoutObject->Block(
              Name => 'PriceRuleRegResultRow',
              Data => {
                TicketID => $PriceReg->{TicketID},
                TicketNumber => $PriceReg->{TicketNumber},
                ArticleID => $PriceReg->{ArticleID},
		TicketData => \%TicketData,
		ArticleData => \%ArticleData,
                Date => $PriceReg->{Date},
                Value => $PriceReg->{Value}
              }
            );

            $Total += $PriceReg->{Value};
          }

          $LayoutObject->Block(
            Name => 'PriceRuleRegResultTotal',
            Data => {
              Total => $Total
            }
          );
        }

        
      }
    }

    my $ContractFranchiseRules = $CustomerContractObject->ContactFranchiseRuleList(ContractID => $Param{ContractID});

    if($ContractFranchiseRules && (scalar @$ContractFranchiseRules) > 0){
      for my $FranchiseRule (@$ContractFranchiseRules){

        my $FranchiseRuleTicketTypes = $CustomerContractObject->FranchiseRuleTicketTypeList(ContractFranchiseRuleID => $FranchiseRule->{ID});
	my $TicketTypesStr = '*';
	if (scalar @$FranchiseRuleTicketTypes > 0) {
		my @arr;
		foreach my $x ( @$FranchiseRuleTicketTypes ) {
			push @arr, $x->{TicketTypeName};
		}
		$TicketTypesStr = join(', ', @arr);
	}

        my $FranchiseRuleTreatmentTypes = $CustomerContractObject->FranchiseRuleTreatmentTypeList(ContractFranchiseRuleID => $FranchiseRule->{ID});
        my $TreatmentTypesStr = '*';
	if (scalar @$FranchiseRuleTreatmentTypes > 0) {
		my @arr;
		foreach my $x ( @$FranchiseRuleTreatmentTypes ) {
			push @arr, $x->{TreatmentType};
		}
		$TreatmentTypesStr = join(', ', @arr);
	}

        my $FranchiseRuleSLAs = $CustomerContractObject->FranchiseRuleSLAList(ContractFranchiseRuleID => $FranchiseRule->{ID});
        my $SLAsStr = '*';
	if (scalar @$FranchiseRuleSLAs> 0) {
		my @arr;
		foreach my $x ( @$FranchiseRuleSLAs ) {
			push @arr, $x->{SLAName};
		}
		$SLAsStr = join(', ', @arr);
	}

        my $FranchiseRuleServices = $CustomerContractObject->FranchiseRuleServiceList(ContractFranchiseRuleID => $FranchiseRule->{ID});
        my $ServicesStr = '*';
	if (scalar @$FranchiseRuleServices> 0) {
		my @arr;
		foreach my $x ( @$FranchiseRuleServices ) {
			push @arr, $x->{ServiceName};
		}
		$ServicesStr = join(', ', @arr);
	}

        my $FranchiseRuleHourTypes = $CustomerContractObject->FranchiseRuleHourTypeList(ContractFranchiseRuleID => $FranchiseRule->{ID});
        my $HourTypesStr = '*';
	if (scalar @$FranchiseRuleHourTypes > 0) {
		my @arr;
		foreach my $x ( @$FranchiseRuleHourTypes ) {
			push @arr, $x->{HourType};
		}
		$HourTypesStr = join(', ', @arr);
	}

	my $AvailableTime = $FranchiseRule->{Hours} * 3600;
	my $FranchiseRegistries = $CustomerContractObject->GetFranchiseRulesRegistry(
		ContractFranchiseRuleID => $FranchiseRule->{ID},
		FromSearch => '',
		ToSearch => '',
	);
        if (scalar @$FranchiseRegistries && $FranchiseRule->{Recurrence} ne 'ilimitado'){
		for my $FranchiseReg (@$FranchiseRegistries) {
			$AvailableTime -= $FranchiseReg->{Value};
		}
		my $secondsT = $AvailableTime;
		my $hoursT = int( $secondsT / (60*60) );
		my $minsT = ( $secondsT / 60 ) % 60;
		my $secsT = $secondsT % 60;
		$AvailableTime = sprintf("%02d:%02d:%02d", $hoursT,$minsT,$secsT);
	} else {
		$AvailableTime = '-';
	}

        $LayoutObject->Block(
            Name => 'FranchiseRuleReg',
            Data => {
              RuleID => $FranchiseRule->{Name},
              Value => $FranchiseRule->{Hours},
              Recurrence => $FranchiseRule->{Recurrence},
              FranchiseRuleTicketTypes => $TicketTypesStr,
              TreatmentTypesStr => $TreatmentTypesStr,
              SLAsStr => $SLAsStr,
              ServicesStr => $ServicesStr,
              HourTypesStr => $HourTypesStr,
              AvailableTime => $AvailableTime
            },
        );

        $LayoutObject->Block(
            Name => 'FranchiseRuleRegResult',
        );

        my $FranchiseRegistries = $CustomerContractObject->GetFranchiseRulesRegistry(
          ContractFranchiseRuleID => $FranchiseRule->{ID},
          FromSearch => $FromSearchDB,
          ToSearch => $ToSearchDB,
          );

        if(scalar(@$FranchiseRegistries) == 0){
          $LayoutObject->Block(
            Name => 'FranchiseRuleRegResultNoData',
            Data => {
              ColSpan => 5
            }
          );
        }
        else{
          my $Total = 0;

          for my $FranchiseReg (@$FranchiseRegistries){

            my $seconds = $FranchiseReg->{Value};
            my $hours = int( $seconds / (60*60) );
            my $mins = ( $seconds / 60 ) % 60;
            my $secs = $seconds % 60;

            my %TicketData = $Kernel::OM->Get('Kernel::System::Ticket')->TicketGet(
              'TicketID' => $FranchiseReg->{TicketID},
	      'UserID'   => 1
            );
            my %ArticleData = $Kernel::OM->Get('Kernel::System::Ticket::Article')->BackendForArticle(
              'TicketID'  => $FranchiseReg->{TicketID},
	      'ArticleID' => $FranchiseReg->{ArticleID}
	    )->ArticleGet(
              'TicketID'  => $FranchiseReg->{TicketID},
	      'ArticleID' => $FranchiseReg->{ArticleID}
	    );
            $LayoutObject->Block(
              Name => 'FranchiseRuleRegResultRow',
              Data => {
                TicketID => $FranchiseReg->{TicketID},
                TicketNumber => $FranchiseReg->{TicketNumber},
		TicketData => \%TicketData,
		ArticleData => \%ArticleData,
                ArticleID => $FranchiseReg->{ArticleID},
                Date => $FranchiseReg->{Date},
                Value => sprintf("%02d:%02d:%02d", $hours,$mins,$secs),
              }
            );

            $Total += $FranchiseReg->{Value};

          }

          my $secondsT = $Total;
          my $hoursT = int( $secondsT / (60*60) );
          my $minsT = ( $secondsT / 60 ) % 60;
          my $secsT = $secondsT % 60;

          $LayoutObject->Block(
            Name => 'FranchiseRuleRegResultTotal',
            Data => {
              Total => sprintf("%02d:%02d:%02d", $hoursT,$minsT,$secsT)
            }
          );

        }
      }
    }

    $LayoutObject->Block(
        Name => 'ActionAdd',
        Data => \%Param,
    );

    # when there is no data to show, a message is displayed on the table with this colspan
    my $ColSpan = 6;

    if ( $Param{Nav} eq 'None' ) {
        $LayoutObject->Block( Name => 'BorrowedViewJS' );
    }
}

sub _Edit {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    my $Output = '';

    $LayoutObject->Block(
        Name => 'Overview',
        Data => \%Param,
    );

    $LayoutObject->Block( Name => 'ActionList' );
    $LayoutObject->Block(
        Name => 'ActionOverview',
        Data => \%Param,
    );

    $LayoutObject->Block(
        Name => 'OverviewUpdate',
        Data => \%Param,
    );

    if($Param{DateType} == 1){
        $Param{RelativePeriod} = "checked=checked";
    }
    else{
        $Param{AbsolutPeriod} = "checked=checked";
    }

    # shows header
    if ( $Param{Action} eq 'Change' ) {
        $LayoutObject->Block( Name => 'HeaderEdit' );
    }
    else {
        $LayoutObject->Block( Name => 'HeaderAdd' );
    }

    my $CustomerCompanyObject = $Kernel::OM->Get('Kernel::System::CustomerCompany');
    my %CompanyList           = (
        $CustomerCompanyObject->CustomerCompanyList( Limit => 0 ),
        '' => '-',
    );

    #$Param{Number} = $Param->{Number};

    $Param{CustomerOption} = $LayoutObject->BuildSelection(
        Data       => \%CompanyList,
        Name       => "CustomerID",
        Max        => 80,
        SelectedID => $Param{CustomerID},
        Class      => "$Param{RequiredClass} Modernize " . $Param{Errors}->{ 'CustomerIDInvalid' },
    );

    my %PeriodClosing;
    $PeriodClosing{ 'mensal' } = 'mensal';
    $PeriodClosing{ 'bimestral' } = 'bimestral';
    $PeriodClosing{ 'trimestral' } = 'trimestral';
    $PeriodClosing{ 'semestral' } = 'semestral';
    $PeriodClosing{ 'anual' } = 'anual';
    $PeriodClosing{ 'periodo (pontual)' } = 'periodo (pontual)';
    my %PeriodClosingReverse = reverse %PeriodClosing;

    $Param{PeriodClosingOption} = $LayoutObject->BuildSelection(
        Data       => \%PeriodClosing,
        Name       => "PeriodClosing",
        Max        => 80,
        SelectedID => $Param{PeriodClosing} || $PeriodClosingReverse{PeriodClosing},
        Class      => "$Param{RequiredClass} Modernize " . $Param{Errors}->{ 'PeriodClosingInvalid' },
    );

    my %RelatedToPeriod;
    $RelatedToPeriod{ 'year(s)' } = 'year(s)';
    $RelatedToPeriod{ 'month(s)' } = 'month(s)';
    $RelatedToPeriod{ 'week(s)' } = 'week(s)';
    $RelatedToPeriod{ 'day(s)' } = 'day(s)';
    my %RelatedToPeriodReverse = reverse %RelatedToPeriod;

    $Param{RelatedToPeriodOption} = $LayoutObject->BuildSelection(
        Data       => \%RelatedToPeriod,
        Name       => "RelatedToPeriod",
        Max        => 80,
        SelectedID => $Param{RelatedToPeriod} || $RelatedToPeriodReverse{RelatedToPeriod},
        Class      => "$Param{RequiredClass} Modernize " . $Param{Errors}->{ 'RelatedToPeriodInvalid' },
    );

    $Param{ValidOption} = $LayoutObject->BuildSelection(
        Data       => { $Kernel::OM->Get('Kernel::System::Valid')->ValidList(), },
        Name       => "ValidID",
        SelectedID => $Param{ValidID} || 1,
        Class      => "$Param{RequiredClass} Modernize " . $Param{Errors}->{ 'ValidIdInvalid' },
    );

    

    if ( $Param{Nav} eq 'None' ) {
        $LayoutObject->Block( Name => 'BorrowedViewJS' );
    }

    if ( $Param{ID} && $Param{ID} > 0) {  

        my %Type = $Kernel::OM->Get('Kernel::System::Type')->TypeList(
            UserID => $Self->{UserID},
        );
        
        $Param{TypesStrgPrice} = $LayoutObject->BuildSelection(
            Data        => \%Type,
            Name        => 'TypeIDs',
            Sort        => 'AlphanumericValue',
            Size        => 3,
            Multiple    => 1,
            Translation => 0,
            Class       => 'Modernize',
        );

        $Param{TypesStrgFranchise} = $LayoutObject->BuildSelection(
            Data        => \%Type,
            Name        => 'TypeIDs',
            Sort        => 'AlphanumericValue',
            Size        => 3,
            Multiple    => 1,
            Translation => 0,
            Class       => 'Modernize',
        );

        $Param{UpdTypesStrgFranchise} = $LayoutObject->BuildSelection(
            Data        => \%Type,
            Name        => 'TypeIDs',
            Sort        => 'AlphanumericValue',
            Size        => 3,
            Multiple    => 1,
            Translation => 0,
            Class       => 'Modernize',
        );        

        my %SLA = $Kernel::OM->Get('Kernel::System::SLA')->SLAList(
            UserID => $Self->{UserID},
        );

        $Param{SLAsStrgPrice} = $LayoutObject->BuildSelection(
            Data        => \%SLA,
            Name        => 'SLAIDs',
            Sort        => 'AlphanumericValue',
            Size        => 5,
            Multiple    => 1,
            Translation => 0,
            Max         => 200,
            Class       => 'Modernize',
        );

        $Param{SLAsStrgFranchise} = $LayoutObject->BuildSelection(
            Data        => \%SLA,
            Name        => 'SLAIDs',
            Sort        => 'AlphanumericValue',
            Size        => 5,
            Multiple    => 1,
            Translation => 0,
            Max         => 200,
            Class       => 'Modernize',
        );

        my $DynamicFieldBackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');
        my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');
        my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

        my $TreatmentTypeDF = $DynamicFieldObject->DynamicFieldGet(
            Name => $ConfigObject->Get('CustomerContracts::DynamicField::TreatmentType'),
        );

        my $TreatmentTypePossibleValues = $DynamicFieldBackendObject->PossibleValuesGet(
            DynamicFieldConfig => $TreatmentTypeDF,       # complete config of the DynamicField
        );

        $Param{TreatmentTypesStrgPrice} = $LayoutObject->BuildSelection(
            Data        => $TreatmentTypePossibleValues,
            Name        => 'TreatmentTypes',
            Sort        => 'AlphanumericValue',
            Size        => 5,
            Multiple    => 1,
            Translation => 0,
            Max         => 200,
            Class       => 'Modernize',
        );

        $Param{TreatmentTypesStrgFranchise} = $LayoutObject->BuildSelection(
            Data        => $TreatmentTypePossibleValues,
            Name        => 'TreatmentTypes',
            Sort        => 'AlphanumericValue',
            Size        => 5,
            Multiple    => 1,
            Translation => 0,
            Max         => 200,
            Class       => 'Modernize',
        );

        my %Service = $Kernel::OM->Get('Kernel::System::Service')->ServiceList(
            Valid        => 1,
            KeepChildren => $ConfigObject->Get('Ticket::Service::KeepChildren') // 0,
            UserID       => $Self->{UserID},
        );

        $Param{ServicesStrgPrice} = $LayoutObject->BuildSelection(
            Data        => \%Service,
            Name        => 'ServiceIDs',
            Size        => 5,
            Multiple    => 1,
            TreeView    => 0,
            Translation => 0,
            Max         => 200,
            Class       => 'Modernize',
        );

        $Param{ServicesStrgFranchise} = $LayoutObject->BuildSelection(
            Data        => \%Service,
            Name        => 'ServiceIDs',
            Size        => 5,
            Multiple    => 1,
            TreeView    => 0,
            Translation => 0,
            Max         => 200,
            Class       => 'Modernize',
        );

        my %HoursList;
        $HoursList{ 'Comercial' } = 'Comercial';
        $HoursList{ 'Nao Comercial' } = 'Nao Comercial';
        $HoursList{ 'Final de Semana' } = 'Final de Semana';
        $HoursList{ 'Feriados' } = 'Feriados';

        $Param{HoursStrgPrice} = $LayoutObject->BuildSelection(
            Data        => \%HoursList,
            Name        => 'HourIDs',
            Size        => 5,
            Multiple    => 1,
            TreeView    => 0,
            Translation => 0,
            Max         => 200,
            Class       => 'Modernize',
        );

        $Param{HoursStrgFranchise} = $LayoutObject->BuildSelection(
            Data        => \%HoursList,
            Name        => 'HourIDs',
            Size        => 5,
            Multiple    => 1,
            TreeView    => 0,
            Translation => 0,
            Max         => 200,
            Class       => 'Modernize',
        );

        my %Recurrence;
        $Recurrence{ 'diario' } = 'diario';
        $Recurrence{ 'semanal' } = 'semanal';
        $Recurrence{ 'mensal' } = 'mensal';
        $Recurrence{ 'bimestral' } = 'bimestral';
        $Recurrence{ 'trimestral' } = 'trimestral';
        $Recurrence{ 'semestral' } = 'semestral';
        $Recurrence{ 'anual' } = 'anual';
        $Recurrence{ 'ilimitado' } = 'ilimitado';

        $Param{RecurrenceStrgFranchise} = $LayoutObject->BuildSelection(
            Data        => \%Recurrence,
            Name        => 'Recurrence',
            PossibleNone => 0,
            Size        => 5,
            Multiple    => 0,
            TreeView    => 0,
            Translation => 0,
            Max         => 200,
            Class       => 'Modernize Validate_Required',
        );

        $LayoutObject->Block( Name => 'RulesArea',
        Data         => \%Param, );

        my $CustomerContractObject = $Kernel::OM->Get('Kernel::System::CustomerContract');

        my $ContractPriceRules = $CustomerContractObject->ContactPriceRuleList(ContractID => $Param{ID});

        if($ContractPriceRules && (scalar @$ContractPriceRules) > 0){
            for my $PriceRule (@$ContractPriceRules){

		my $PriceRuleTicketTypes = $CustomerContractObject->PriceRuleTicketTypeList(ContractPriceRuleID => $PriceRule->{ID});
		my $TicketTypesStr = '*';
		if (scalar @$PriceRuleTicketTypes > 0) {
			my @arr;
			foreach my $x ( @$PriceRuleTicketTypes ) {
				push @arr, $x->{TicketTypeName};
			}
			$TicketTypesStr = join(', ', @arr);
		}

		my $PriceRuleTreatmentTypes = $CustomerContractObject->PriceRuleTreatmentTypeList(ContractPriceRuleID => $PriceRule->{ID});
		my $TreatmentTypesStr = '*';
		if (scalar @$PriceRuleTreatmentTypes > 0 ) {
			my @arr;
			foreach my $x ( @$PriceRuleTreatmentTypes ) {
				push @arr, $x->{TreatmentType};
			}
			$TreatmentTypesStr = join(', ', @arr);
		}

		my $PriceRuleSLAs = $CustomerContractObject->PriceRuleSLAList(ContractPriceRuleID => $PriceRule->{ID});
		my $SLAsStr = '*';
		if (scalar @$PriceRuleSLAs > 0 ) {
			my @arr;
			foreach my $x ( @$PriceRuleSLAs ) {
				push @arr, $x->{SLAName};
			}
			$SLAsStr = join(', ', @arr);
		}

		my $PriceRuleServices = $CustomerContractObject->PriceRuleServiceList(ContractPriceRuleID => $PriceRule->{ID});
		my $ServicesStr = '*';
		if (scalar @$PriceRuleServices > 0 ) {
			my @arr;
			foreach my $x ( @$PriceRuleServices ) {
				push @arr, $x->{ServiceName};
			}
			$ServicesStr = join(', ', @arr);
		}

		my $PriceRuleHourTypes = $CustomerContractObject->PriceRuleHourTypeList(ContractPriceRuleID => $PriceRule->{ID});
		my $HourTypesStr = '*';
		if (scalar @$PriceRuleHourTypes > 0 ) {
			my @arr;
			foreach my $x ( @$PriceRuleHourTypes ) {
				push @arr, $x->{HourType};
			}
			$HourTypesStr = join(', ', @arr);
		}

                $LayoutObject->Block( 
                    Name => 'PriceRuleRow',
                    Data => {
                        Types => $TicketTypesStr,
                        TreatmentTypes => $TreatmentTypesStr,
                        Slas => $SLAsStr,
                        Services => $ServicesStr,
                        Hours => $HourTypesStr,
                        Value => $PriceRule->{Value},
                        ValueTiotal => $PriceRule->{ValueTotal},
                        RuleID => $PriceRule->{ID},
                        ContractID => $Param{ID},
                        OrderNumber => $PriceRule->{OrderNumber},
                        IsTheLast => $PriceRule->{OrderNumber} == @$ContractPriceRules,
                    }
                );
            }            
        }
        else{
            $LayoutObject->Block( Name => 'NoDataFoundMsgPriceRule',);
        }

        my $ContractFranchiseRules = $CustomerContractObject->ContactFranchiseRuleList(ContractID => $Param{ID});

        if($ContractFranchiseRules && (scalar @$ContractFranchiseRules) > 0){
            for my $FranchiseRule (@$ContractFranchiseRules){

		my $FranchiseRuleTicketTypes = $CustomerContractObject->FranchiseRuleTicketTypeList(ContractFranchiseRuleID => $FranchiseRule->{ID});
		my $TicketTypesStr = '*';
		if (scalar @$FranchiseRuleTicketTypes > 0) {
			my @arr;
			foreach my $x ( @$FranchiseRuleTicketTypes ) {
				push @arr, $x->{TicketTypeName};
			}
			$TicketTypesStr = join(', ', @arr);
		}

		my $FranchiseRuleTreatmentTypes = $CustomerContractObject->FranchiseRuleTreatmentTypeList(ContractFranchiseRuleID => $FranchiseRule->{ID});
		my $TreatmentTypesStr = '*';
		if (scalar @$FranchiseRuleTreatmentTypes > 0) {
			my @arr;
			foreach my $x ( @$FranchiseRuleTreatmentTypes ) {
				push @arr, $x->{TreatmentType};
			}
			$TreatmentTypesStr = join(', ', @arr);
		}

		my $FranchiseRuleSLAs = $CustomerContractObject->FranchiseRuleSLAList(ContractFranchiseRuleID => $FranchiseRule->{ID});
		my $SLAsStr = '*';
		if (scalar @$FranchiseRuleSLAs> 0) {
			my @arr;
			foreach my $x ( @$FranchiseRuleSLAs ) {
				push @arr, $x->{SLAName};
			}
			$SLAsStr = join(', ', @arr);
		}

		my $FranchiseRuleServices = $CustomerContractObject->FranchiseRuleServiceList(ContractFranchiseRuleID => $FranchiseRule->{ID});
		my $ServicesStr = '*';
		if (scalar @$FranchiseRuleServices> 0) {
			my @arr;
			foreach my $x ( @$FranchiseRuleServices ) {
				push @arr, $x->{ServiceName};
			}
			$ServicesStr = join(', ', @arr);
		}

		my $FranchiseRuleHourTypes = $CustomerContractObject->FranchiseRuleHourTypeList(ContractFranchiseRuleID => $FranchiseRule->{ID});
		my $HourTypesStr = '*';
		if (scalar @$FranchiseRuleHourTypes > 0) {
			my @arr;
			foreach my $x ( @$FranchiseRuleHourTypes ) {
				push @arr, $x->{HourType};
			}
			$HourTypesStr = join(', ', @arr);
		}

                $LayoutObject->Block( 
                    Name => 'FranchiseRuleRow',
                    Data => {
                        Types => $TicketTypesStr,
                        TreatmentTypes => $TreatmentTypesStr,
                        Slas => $SLAsStr,
                        Services => $ServicesStr,
                        Hours => $HourTypesStr,
                        Recurrence => $FranchiseRule->{Recurrence},
                        ValueHours => $FranchiseRule->{Hours},
                        RuleID => $FranchiseRule->{ID},
                        ContractID => $Param{ID},
                        OrderNumber => $FranchiseRule->{OrderNumber},
                        IsTheLast => $FranchiseRule->{OrderNumber} == @$ContractFranchiseRules,
                    }
                );
            }            
        }
        else{
            $LayoutObject->Block( Name => 'NoDataFoundMsgFranchiseRule',);
        }

        my $TimeObject = $Kernel::OM->Get('Kernel::System::Time');
        my ($SecS, $MinS, $HourS, $DayS, $MonthS, $YearS, $WeekDayS) = $TimeObject->SystemTime2Date(
            SystemTime => $TimeObject->TimeStamp2SystemTime(String=> $Param{StartTime}),
        );

        $Param{FromDateYear} = $YearS;
        $Param{FromDateMonth} = $MonthS;
        $Param{FromDateDay} = $DayS;

        my ($Sec, $Min, $Hour, $Day, $Month, $Year, $WeekDay) = $TimeObject->SystemTime2Date(
            SystemTime => $TimeObject->TimeStamp2SystemTime(String=> $Param{EndTime}),
        );

        $Param{ToDateYear} = $Year;
        $Param{ToDateMonth} = $Month;
        $Param{ToDateDay} = $Day;

        $LayoutObject->Block( 
            Name => 'EditMode',
            Data => \%Param
        );
    }
    else{
        $Param{RelatedTo} = 0;

        my $TimeObject = $Kernel::OM->Get('Kernel::System::Time');
        my ($SecS, $MinS, $HourS, $DayS, $MonthS, $YearS, $WeekDayS) = $TimeObject->SystemTime2Date(
            SystemTime => $TimeObject->TimeStamp2SystemTime(String=> $Param{StartTime}),
        );

        $Param{FromDateString} = $LayoutObject->BuildDateSelection(
            Prefix => "FromDate",
            FromDateYear => $YearS,
            FromDateMonth => $MonthS,
            FromDateDay => $DayS,
        );

        my ($Sec, $Min, $Hour, $Day, $Month, $Year, $WeekDay) = $TimeObject->SystemTime2Date(
            SystemTime => $TimeObject->TimeStamp2SystemTime(String=> $Param{EndTime}),
        );

        $Param{ToDateString} = $LayoutObject->BuildDateSelection(
            Prefix => "ToDate",
            ToDateYear => $Year,
            ToDateMonth => $Month,
            ToDateDay => $Day,
            YearPeriodFuture        => 10,
            YearPeriodPast          => 1,
        );

        $LayoutObject->Block( 
            Name => 'AddMode',
            Data => \%Param
        );
    }

    return $LayoutObject->Output(
        TemplateFile => 'AdminCustomerContract',
        Data         => \%Param,
    );
}

1;
