# --
# Copyright (C) 2001-2018 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::CustomerContract;

use strict;
use warnings;
use Data::Dumper;

use base qw(Kernel::System::EventHandler);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::Language',
    'Kernel::System::CustomerCompany',
    'Kernel::System::DB',
    'Kernel::System::Log',
    'Kernel::System::Main',
);

=head1 NAME

Kernel::System::CustomerUser - customer user lib

=head1 SYNOPSIS

All customer user functions. E. g. to add and update customer users.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create an object. Do not use it directly, instead use:

    use Kernel::System::ObjectManager;
    local $Kernel::OM = Kernel::System::ObjectManager->new();
    my $CustomerUserObject = $Kernel::OM->Get('Kernel::System::CustomerUser');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # load generator customer preferences module
    my $GeneratorModule = $ConfigObject->Get('CustomerPreferences')->{Module}
        || 'Kernel::System::CustomerUser::Preferences::DB';

    # get main object
    my $MainObject = $Kernel::OM->Get('Kernel::System::Main');

    if ( $MainObject->Require($GeneratorModule) ) {
        $Self->{PreferencesObject} = $GeneratorModule->new();
    }

    # load customer user backend module
    SOURCE:
    for my $Count ( '', 1 .. 10 ) {

        next SOURCE if !$ConfigObject->Get("CustomerUser$Count");

        my $GenericModule = $ConfigObject->Get("CustomerUser$Count")->{Module};
        if ( !$MainObject->Require($GenericModule) ) {
            $MainObject->Die("Can't load backend module $GenericModule! $@");
        }
        $Self->{"CustomerUser$Count"} = $GenericModule->new(
            Count             => $Count,
            PreferencesObject => $Self->{PreferencesObject},
            CustomerUserMap   => $ConfigObject->Get("CustomerUser$Count"),
        );
    }

    # init of event handler
    $Self->EventHandlerInit(
        Config => 'CustomerUser::EventModulePost',
    );

    #NEW CODE
    $Self->{DBObject}       = $Kernel::OM->Get('Kernel::System::DB');
    $Self->{LogObject}      = $Kernel::OM->Get('Kernel::System::Log');
    $Self->{DateTimeObject} = $Kernel::OM->Create('Kernel::System::DateTime');

    return $Self;
}

=item CustomerSourceList()

return customer source list

    my %List = $CustomerUserObject->CustomerSourceList(
        ReadOnly => 0 # optional, 1 returns only RO backends, 0 returns writable, if not passed returns all backends
    );

=cut

sub CustomerSourceList {
    my ( $Self, %Param ) = @_;

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    my %Data;
    SOURCE:
    for my $Count ( '', 1 .. 10 ) {

        next SOURCE if !$ConfigObject->Get("CustomerUser$Count");
        if ( defined $Param{ReadOnly} ) {
            my $CustomerBackendConfig = $ConfigObject->Get("CustomerUser$Count");
            if ( $Param{ReadOnly} ) {
                next SOURCE if !$CustomerBackendConfig->{ReadOnly};
            }
            else {
                next SOURCE if $CustomerBackendConfig->{ReadOnly};
            }
        }
        $Data{"CustomerUser$Count"} = $ConfigObject->Get("CustomerUser$Count")->{Name}
            || "No Name $Count";
    }
    return %Data;
}

=item CustomerSearch()

to search users

    # text search
    my %List = $CustomerUserObject->CustomerSearch(
        Search => '*some*', # also 'hans+huber' possible
        Valid  => 1,        # (optional) default 1
        Limit  => 100,      # (optional) overrides limit of the config
    );

    # username search
    my %List = $CustomerUserObject->CustomerSearch(
        UserLogin => '*some*',
        Valid     => 1,         # (optional) default 1
    );

    # email search
    my %List = $CustomerUserObject->CustomerSearch(
        PostMasterSearch => 'email@example.com',
        Valid            => 1,                    # (optional) default 1
    );

    # search by CustomerID
    my %List = $CustomerUserObject->CustomerSearch(
        CustomerID       => 'CustomerID123',
        Valid            => 1,                # (optional) default 1
    );

=cut

sub CustomerSearch {
    my ( $Self, %Param ) = @_;

    if($Param{Search} eq '*'){
        $Param{Search} = '';
    }

    # remove leading and ending spaces
    if ( $Param{Search} ) {
        $Param{Search} =~ s/^\s+//;
        $Param{Search} =~ s/\s+$//;
    }
    
    return if !$Self->{DBObject}->Prepare(
        SQL => 'SELECT 
                cco.customer_id,
                cco.name,
                count(cc.id)
            	FROM customer_company cco 
                INNER JOIN customer_contract cc on cc.customer_id = cco.customer_id
                WHERE cc.customer_id like ?
                group by cco.customer_id, cco.name', 
        Bind => [\('%'.$Param{Search}.'%')]               
    );

    my $Data = [];

    while ( my @Data = $Self->{DBObject}->FetchrowArray() ) {
        push @{ $Data },{
            CustomerID            => $Data[0],
            CustomerName          => $Data[1],
            ContractQuantity      => $Data[2]
        };
    }
    
    return $Data;
}

=item CustomerContractsSearch()

to search users

    # text search
    my %List = $CustomerUserObject->CustomerSearch(
        Search => '*some*', # also 'hans+huber' possible
        Valid  => 1,        # (optional) default 1
        Limit  => 100,      # (optional) overrides limit of the config
    );

    # username search
    my %List = $CustomerUserObject->CustomerSearch(
        UserLogin => '*some*',
        Valid     => 1,         # (optional) default 1
    );

    # email search
    my %List = $CustomerUserObject->CustomerSearch(
        PostMasterSearch => 'email@example.com',
        Valid            => 1,                    # (optional) default 1
    );

    # search by CustomerID
    my %List = $CustomerUserObject->CustomerSearch(
        CustomerID       => 'CustomerID123',
        Valid            => 1,                # (optional) default 1
    );

=cut

sub CustomerContractsSearch {
    my ( $Self, %Param ) = @_;

    if($Param{Search} eq '*'){
        $Param{Search} = '';
    }

    # remove leading and ending spaces
    if ( $Param{Search} ) {
        $Param{Search} =~ s/^\s+//;
        $Param{Search} =~ s/\s+$//;
    }
    
    return if !$Self->{DBObject}->Prepare(
        SQL => 'SELECT 
                cc.id,
                cc.number,
                cc.valid_id,
                cc.period_closing,
                cc.customer_id,
                cc.start_time,
                cc.end_time,
                cc.order_number 
            	FROM customer_contract cc 
                INNER JOIN customer_company cco on cc.customer_id = cco.customer_id
                WHERE cc.customer_id like ? 
                GROUP BY cc.id ORDER BY order_number', 
        Bind => [\('%'.$Param{Search}.'%')]               
    );

    my $Data = [];

    while ( my @Data = $Self->{DBObject}->FetchrowArray() ) {
        push @{ $Data },{
            ID            => $Data[0],
            Number          => $Data[1],
            ValidID          => $Data[2],
            PeriodClosing => $Data[3],
            Customer => $Data[4],
            StartTime => $Data[5],
            EndTime => $Data[6],
            OrderNumber => $Data[7],
        };
    }
    
    return $Data;
}

=item ContactPriceRuleList()

#

=cut

sub ContactPriceRuleList {
    my ( $Self, %Param ) = @_;
    
    return if !$Self->{DBObject}->Prepare(
        SQL => 'SELECT 
                id,
                contract_id,
                name,
                value,
                value_total,
                order_number 
            	FROM contract_price_rule
                where contract_id = ? 
                ORDER BY order_number', 
        Bind => [\$Param{ContractID}]               
    );

    my $Data = [];

    while ( my @Data = $Self->{DBObject}->FetchrowArray() ) {
        push @{ $Data },{
            ID            => $Data[0],
            ContractID          => $Data[1],
            Name          => $Data[2],
            Value => $Data[3],
            ValueTotal => $Data[4],
            OrderNumber => $Data[5],
        };
    }
    
    return $Data;
}

=item PriceRuleTicketTypeList()

#

=cut

sub PriceRuleTicketTypeList {
    my ( $Self, %Param ) = @_;
    
    return if !$Self->{DBObject}->Prepare(
        SQL => 'SELECT 
                prtt.id,
                prtt.contract_price_rule_id,
                prtt.ticket_type_id,
                tt.name
                from price_rule_ticket_type prtt
                inner join ticket_type tt on prtt.ticket_type_id = tt.id
                where prtt.contract_price_rule_id = ?', 
        Bind => [\$Param{ContractPriceRuleID}]               
    );

    my $Data = [];

    while ( my @Data = $Self->{DBObject}->FetchrowArray() ) {
        push @{ $Data },{
            ID            => $Data[0],
            ContractPriceRuleID          => $Data[1],
            TicketTypeID          => $Data[2],
            TicketTypeName          => $Data[3]
        };
    }
    
    return $Data;
}

=item PriceRuleTicketTypeList()

#

=cut

sub PriceRuleTreatmentTypeList {
    my ( $Self, %Param ) = @_;
    
    return if !$Self->{DBObject}->Prepare(
        SQL => 'SELECT 
                prtt.id,
                prtt.contract_price_rule_id,
                prtt.treatment_type
                from price_rule_treatment_type prtt
                where prtt.contract_price_rule_id = ?', 
        Bind => [\$Param{ContractPriceRuleID}]               
    );

    my $Data = [];

    while ( my @Data = $Self->{DBObject}->FetchrowArray() ) {
        push @{ $Data },{
            ID            => $Data[0],
            ContractPriceRuleID          => $Data[1],
            TreatmentType          => $Data[2]
        };
    }
    
    return $Data;
}

=item PriceRuleSLAList()

#

=cut

sub PriceRuleSLAList {
    my ( $Self, %Param ) = @_;
    
    return if !$Self->{DBObject}->Prepare(
        SQL => 'SELECT 
                prs.id,
                prs.contract_price_rule_id,
                prs.sla_id,
                s.name
                from price_rule_sla prs
                inner join sla s on prs.sla_id = s.id
                where prs.contract_price_rule_id = ?', 
        Bind => [\$Param{ContractPriceRuleID}]               
    );

    my $Data = [];

    while ( my @Data = $Self->{DBObject}->FetchrowArray() ) {
        push @{ $Data },{
            ID            => $Data[0],
            ContractPriceRuleID          => $Data[1],
            SLAID          => $Data[2],
            SLAName          => $Data[3]
        };
    }
    
    return $Data;
}

=item PriceRuleServiceList()

#

=cut

sub PriceRuleServiceList {
    my ( $Self, %Param ) = @_;
    
    return if !$Self->{DBObject}->Prepare(
        SQL => 'SELECT 
                prs.id,
                prs.contract_price_rule_id,
                prs.service_id,
                s.name
                from price_rule_service prs
                inner join service s on prs.service_id = s.id
                where prs.contract_price_rule_id = ?', 
        Bind => [\$Param{ContractPriceRuleID}]               
    );

    my $Data = [];

    while ( my @Data = $Self->{DBObject}->FetchrowArray() ) {
        push @{ $Data },{
            ID            => $Data[0],
            ContractPriceRuleID          => $Data[1],
            ServiceID          => $Data[2],
            ServiceName          => $Data[3]
        };
    }
    
    return $Data;
}

=item PriceRuleHourTypeList()

#

=cut

sub PriceRuleHourTypeList {
    my ( $Self, %Param ) = @_;
    
    return if !$Self->{DBObject}->Prepare(
        SQL => 'SELECT 
                prs.id,
                prs.contract_price_rule_id,
                prs.hour_type
                from price_rule_hour_type prs
                where prs.contract_price_rule_id = ?', 
        Bind => [\$Param{ContractPriceRuleID}]               
    );

    my $Data = [];

    while ( my @Data = $Self->{DBObject}->FetchrowArray() ) {
        push @{ $Data },{
            ID            => $Data[0],
            ContractPriceRuleID          => $Data[1],
            HourType          => $Data[2]
        };
    }
    
    return $Data;
}

=item ContactFranchiseRuleList()

#

=cut

sub ContactFranchiseRuleList {
    my ( $Self, %Param ) = @_;
    
    return if !$Self->{DBObject}->Prepare(
        SQL => 'SELECT 
                id,
                contract_id,
                name,
                recurrence,
                hours,
                order_number 
            	FROM contract_franchise_rule
                where contract_id = ? 
                ORDER BY order_number ', 
        Bind => [\$Param{ContractID}]               
    );

    my $Data = [];

    while ( my @Data = $Self->{DBObject}->FetchrowArray() ) {
        push @{ $Data },{
            ID            => $Data[0],
            ContractID          => $Data[1],
            Name          => $Data[2],
            Recurrence => $Data[3],
            Hours => $Data[4],
            OrderNumber => $Data[5]
        };
    }
    
    return $Data;
}

=item FranchiseRuleTicketTypeList()

#

=cut

sub FranchiseRuleTicketTypeList {
    my ( $Self, %Param ) = @_;
    
    return if !$Self->{DBObject}->Prepare(
        SQL => 'SELECT 
                prtt.id,
                prtt.contract_franchise_rule_id,
                prtt.ticket_type_id,
                tt.name
                from franchise_rule_ticket_type prtt
                inner join ticket_type tt on prtt.ticket_type_id = tt.id
                where prtt.contract_franchise_rule_id = ?', 
        Bind => [\$Param{ContractFranchiseRuleID}]               
    );

    my $Data = [];

    while ( my @Data = $Self->{DBObject}->FetchrowArray() ) {
        push @{ $Data },{
            ID            => $Data[0],
            ContractFranchiseRuleID          => $Data[1],
            TicketTypeID          => $Data[2],
            TicketTypeName          => $Data[3]
        };
    }
    
    return $Data;
}

=item FranchiseRuleTicketTypeList()

#

=cut

sub FranchiseRuleTreatmentTypeList {
    my ( $Self, %Param ) = @_;
    
    return if !$Self->{DBObject}->Prepare(
        SQL => 'SELECT 
                prtt.id,
                prtt.contract_franchise_rule_id,
                prtt.treatment_type
                from franchise_rule_treatment_type prtt
                where prtt.contract_franchise_rule_id = ?', 
        Bind => [\$Param{ContractFranchiseRuleID}]               
    );

    my $Data = [];

    while ( my @Data = $Self->{DBObject}->FetchrowArray() ) {
        push @{ $Data },{
            ID            => $Data[0],
            ContractFranchiseRuleID          => $Data[1],
            TreatmentType          => $Data[2]
        };
    }
    
    return $Data;
}

=item FranchiseRuleSLAList()

#

=cut

sub FranchiseRuleSLAList {
    my ( $Self, %Param ) = @_;
    
    return if !$Self->{DBObject}->Prepare(
        SQL => 'SELECT 
                prs.id,
                prs.contract_franchise_rule_id,
                prs.sla_id,
                s.name
                from franchise_rule_sla prs
                inner join sla s on prs.sla_id = s.id
                where prs.contract_franchise_rule_id = ?', 
        Bind => [\$Param{ContractFranchiseRuleID}]               
    );

    my $Data = [];

    while ( my @Data = $Self->{DBObject}->FetchrowArray() ) {
        push @{ $Data },{
            ID            => $Data[0],
            ContractFranchiseRuleID          => $Data[1],
            SLAID          => $Data[2],
            SLAName          => $Data[3]
        };
    }
    
    return $Data;
}

=item FranchiseRuleServiceList()

#

=cut

sub FranchiseRuleServiceList {
    my ( $Self, %Param ) = @_;
    
    return if !$Self->{DBObject}->Prepare(
        SQL => 'SELECT 
                prs.id,
                prs.contract_franchise_rule_id,
                prs.service_id,
                s.name
                from franchise_rule_service prs
                inner join service s on prs.service_id = s.id
                where prs.contract_franchise_rule_id = ?', 
        Bind => [\$Param{ContractFranchiseRuleID}]               
    );

    my $Data = [];

    while ( my @Data = $Self->{DBObject}->FetchrowArray() ) {
        push @{ $Data },{
            ID            => $Data[0],
            ContractFranchiseRuleID          => $Data[1],
            ServiceID          => $Data[2],
            ServiceName          => $Data[3]
        };
    }
    
    return $Data;
}

=item FranchiseRuleHourTypeList()

#

=cut

sub FranchiseRuleHourTypeList {
    my ( $Self, %Param ) = @_;
    
    return if !$Self->{DBObject}->Prepare(
        SQL => 'SELECT 
                prs.id,
                prs.contract_franchise_rule_id,
                prs.hour_type
                from franchise_rule_hour_type prs
                where prs.contract_franchise_rule_id = ?', 
        Bind => [\$Param{ContractFranchiseRuleID}]               
    );

    my $Data = [];

    while ( my @Data = $Self->{DBObject}->FetchrowArray() ) {
        push @{ $Data },{
            ID            => $Data[0],
            ContractFranchiseRuleID          => $Data[1],
            HourType          => $Data[2]
        };
    }
    
    return $Data;
}

=item CustomerUserList()

return a hash with all users (depreciated)

    my %List = $CustomerUserObject->CustomerUserList(
        Valid => 1, # not required
    );

=cut

sub CustomerUserList {
    my ( $Self, %Param ) = @_;

    my %Data;
    SOURCE:
    for my $Count ( '', 1 .. 10 ) {

        next SOURCE if !$Self->{"CustomerUser$Count"};

        # get customer list result of backend and merge it
        my %SubData = $Self->{"CustomerUser$Count"}->CustomerUserList(%Param);
        %Data = ( %Data, %SubData );
    }
    return %Data;
}

=item CustomerIDList()

return a list of with all known unique CustomerIDs of the registered customers users (no SearchTerm),
or a filtered list where the CustomerIDs must contain a search term.

    my @CustomerIDs = $CustomerUserObject->CustomerIDList(
        SearchTerm  => 'somecustomer',    # optional
        Valid       => 1,                 # optional
    );

=cut

sub CustomerIDList {
    my ( $Self, %Param ) = @_;

    my @Data;
    SOURCE:
    for my $Count ( '', 1 .. 10 ) {

        next SOURCE if !$Self->{"CustomerUser$Count"};

        # get customer list result of backend and merge it
        push @Data, $Self->{"CustomerUser$Count"}->CustomerIDList(%Param);
    }

    # make entries unique
    my %Tmp;
    @Tmp{@Data} = undef;
    @Data = sort { lc $a cmp lc $b } keys %Tmp;

    return @Data;
}

=item CustomerName()

get customer user name

    my $Name = $CustomerUserObject->CustomerName(
        UserLogin => 'some-login',
    );

=cut

sub CustomerName {
    my ( $Self, %Param ) = @_;

    SOURCE:
    for my $Count ( '', 1 .. 10 ) {

        next SOURCE if !$Self->{"CustomerUser$Count"};

        # get customer name and return it
        my $Name = $Self->{"CustomerUser$Count"}->CustomerName(%Param);
        if ($Name) {
            return $Name;
        }
    }
    return;
}

=item CustomerIDs()

get customer user customer ids

    my @CustomerIDs = $CustomerUserObject->CustomerIDs(
        User => 'some-login',
    );

=cut

sub CustomerIDs {
    my ( $Self, %Param ) = @_;

    SOURCE:
    for my $Count ( '', 1 .. 10 ) {

        next SOURCE if !$Self->{"CustomerUser$Count"};

        # get customer id's and return it
        my @CustomerIDs = $Self->{"CustomerUser$Count"}->CustomerIDs(%Param);
        if (@CustomerIDs) {
            return @CustomerIDs;
        }
    }
    return;
}

=item CustomerContractDataGet()

get user data (UserLogin, UserFirstname, UserLastname, UserEmail, ...)

    my %User = $CustomerUserObject->CustomerUserDataGet(
        User => 'franz',
    );

=cut

sub CustomerContractDataGet {
    my ( $Self, %Param ) = @_;

    if ( !$Param{ID} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need ID!' );
        return;
    }

    return if !$Self->{DBObject}->Prepare(
        SQL => 'SELECT customer_id,
				number,
				period_closing,
				start_time,
				end_time,
                related_to,
                related_to_period,
                valid_id,
                order_number
            	FROM customer_contract WHERE id = ?',
        Bind => [ \$Param{ID} ],
    );

    my $RetData;
    
    while ( my @Data = $Self->{DBObject}->FetchrowArray() ) {
        $RetData = {
            ID                  => $Param{ID},
            CustomerID          => $Data[0],
            Number              => $Data[1],
            PeriodClosing       => $Data[2],
            StartTime           => $Data[3],
            EndTime             => $Data[4],
            RelatedTo           => $Data[5],
            RelatedToPeriod     => $Data[6],
            ValidID             => $Data[7],
            OrderNumber         => $Data[8],
        };
    }

    return $RetData;
}

=item CustomerContractAdd()

to add new customer users

    my $UserLogin = $CustomerContractObject->CustomerUserAdd(
        Source         => 'CustomerUser', # CustomerUser source config
        UserFirstname  => 'Huber',
        UserLastname   => 'Manfred',
        UserCustomerID => 'A124',
        UserLogin      => 'mhuber',
        UserPassword   => 'some-pass', # not required
        UserEmail      => 'email@example.com',
        ValidID        => 1,
        UserID         => 123,
    );

=cut

sub CustomerContractAdd {
    my ( $Self, %Param ) = @_;

    for (qw(CustomerID Number PeriodClosing ValidID DateType)) {
        if ( !defined( $Param{$_} ) ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    my $existName;
    return if  !$Self->{DBObject}->Prepare(
        SQL => 'SELECT id FROM customer_contract WHERE customer_id = ? and number = ?',
        Bind => [\$Param{CustomerID},\$Param{Number},],
    );
    while ( my @Row = $Self->{DBObject}->FetchrowArray()){
        $existName = $Row[0];
    }
    
	
	if($existName){
		return ;
	}

    return if !$Self->{DBObject}->Do(
        SQL => 'insert into customer_contract  ('
            . ' customer_id, number, start_time, end_time, related_to, related_to_period, valid_id, period_closing, order_number )'
            . ' VALUES (?,?,?,?,?,?,?,?, (SELECT ifnull(MAX(c.order_number),0)+1 FROM customer_contract c where c.customer_id = ?))',
        Bind => [
            \$Param{CustomerID},\$Param{Number},\$Param{StartTime},\$Param{EndTime},\$Param{RelatedTo},\$Param{RelatedToPeriod},\$Param{ValidID},\$Param{PeriodClosing},\$Param{CustomerID},
        ],
    );

    my $ID;
    return if !$Self->{DBObject}->Prepare(
        SQL => 'SELECT id FROM customer_contract WHERE customer_id = ? and number = ?',
        Bind => [ \$Param{CustomerID},\$Param{Number}, ],
    );
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $ID = $Row[0];
    }
    
    return $ID;

}

=item PriceRuleAdd()

###

=cut

sub PriceRuleAdd {
    my ( $Self, %Param ) = @_;

    for (qw(ContractID Value)) {
        if ( !defined( $Param{$_} ) ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    my $Name;
    return if !$Self->{DBObject}->Prepare(
        SQL => 'SELECT UUID()',
    );
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $Name = $Row[0];
    }

    return if !$Self->{DBObject}->Do(
        SQL => 'insert into contract_price_rule  ('
            . ' contract_id, name, value, value_total, order_number )'
            . ' VALUES (?,?,?,?, (SELECT ifnull(MAX(c.order_number),0)+1 FROM contract_price_rule c where c.contract_id = ?))',
        Bind => [
            \$Param{ContractID},\$Name,\$Param{Value},\0,\$Param{ContractID},
        ],
    );
    
     my $ID;
    return if !$Self->{DBObject}->Prepare(
        SQL => 'SELECT id FROM contract_price_rule WHERE name = ?',
        Bind => [ \$Name, ],
    );
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $ID = $Row[0];
    }
    
    return $ID;

}

=item PriceRuleTicketTypeAdd()

###

=cut

sub PriceRuleTicketTypeAdd {
    my ( $Self, %Param ) = @_;

    for (qw(ContractPriceRuleID TicketTypeID)) {
        if ( !defined( $Param{$_} ) ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    return if !$Self->{DBObject}->Do(
        SQL => 'insert into price_rule_ticket_type  ('
            . ' contract_price_rule_id, ticket_type_id )'
            . ' VALUES (?,?)',
        Bind => [
            \$Param{ContractPriceRuleID},\$Param{TicketTypeID},
        ],
    );
    
    return 1;

}

=item PriceRuleTreatmentTypeAdd()

###

=cut

sub PriceRuleTreatmentTypeAdd {
    my ( $Self, %Param ) = @_;

    for (qw(ContractPriceRuleID TreatmentType)) {
        if ( !defined( $Param{$_} ) ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    return if !$Self->{DBObject}->Do(
        SQL => 'insert into price_rule_treatment_type  ('
            . ' contract_price_rule_id, treatment_type )'
            . ' VALUES (?,?)',
        Bind => [
            \$Param{ContractPriceRuleID},\$Param{TreatmentType},
        ],
    );
    
    return 1;

}

=item PriceRuleSlaAdd()

###

=cut

sub PriceRuleSlaAdd {
    my ( $Self, %Param ) = @_;

    for (qw(ContractPriceRuleID SLAID)) {
        if ( !defined( $Param{$_} ) ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    return if !$Self->{DBObject}->Do(
        SQL => 'insert into price_rule_sla  ('
            . ' contract_price_rule_id, sla_id )'
            . ' VALUES (?,?)',
        Bind => [
            \$Param{ContractPriceRuleID},\$Param{SLAID},
        ],
    );
    
    return 1;

}

=item PriceRuleServiceAdd()

###

=cut

sub PriceRuleServiceAdd {
    my ( $Self, %Param ) = @_;

    for (qw(ContractPriceRuleID ServiceID)) {
        if ( !defined( $Param{$_} ) ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    return if !$Self->{DBObject}->Do(
        SQL => 'insert into price_rule_service  ('
            . ' contract_price_rule_id, service_id )'
            . ' VALUES (?,?)',
        Bind => [
            \$Param{ContractPriceRuleID},\$Param{ServiceID},
        ],
    );
    
    return 1;

}

=item PriceRuleHourTypeAdd()

###

=cut

sub PriceRuleHourTypeAdd {
    my ( $Self, %Param ) = @_;

    for (qw(ContractPriceRuleID HourType)) {
        if ( !defined( $Param{$_} ) ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    return if !$Self->{DBObject}->Do(
        SQL => 'insert into price_rule_hour_type  ('
            . ' contract_price_rule_id, hour_type )'
            . ' VALUES (?,?)',
        Bind => [
            \$Param{ContractPriceRuleID},\$Param{HourType},
        ],
    );
    
    return 1;

}

=item FranchiseRuleAdd()

###

=cut

sub FranchiseRuleAdd {
    my ( $Self, %Param ) = @_;

    for (qw(ContractID Recurrence Hours)) {
        if ( !defined( $Param{$_} ) ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    my $Name;
    return if !$Self->{DBObject}->Prepare(
        SQL => 'SELECT UUID()',
    );
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $Name = $Row[0];
    }

    return if !$Self->{DBObject}->Do(
        SQL => 'insert into contract_franchise_rule  ('
            . ' contract_id, name, recurrence, hours,valid_id, order_number )'
            . ' VALUES (?,?,?,?,1, (SELECT ifnull(MAX(c.order_number),0)+1 FROM contract_franchise_rule c where c.contract_id = ?))',
        Bind => [
            \$Param{ContractID},\$Name,\$Param{Recurrence},\$Param{Hours},\$Param{ContractID},
        ],
    );
    
     my $ID;
    return if !$Self->{DBObject}->Prepare(
        SQL => 'SELECT id FROM contract_franchise_rule WHERE name = ?',
        Bind => [ \$Name, ],
    );
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $ID = $Row[0];
    }
    
    return $ID;

}

=item FranchiseRuleTicketTypeAdd()

###

=cut

sub FranchiseRuleTicketTypeAdd {
    my ( $Self, %Param ) = @_;

    for (qw(ContractFranchiseRuleID TicketTypeID)) {
        if ( !defined( $Param{$_} ) ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    return if !$Self->{DBObject}->Do(
        SQL => 'insert into franchise_rule_ticket_type  ('
            . ' contract_franchise_rule_id, ticket_type_id )'
            . ' VALUES (?,?)',
        Bind => [
            \$Param{ContractFranchiseRuleID},\$Param{TicketTypeID},
        ],
    );
    
    return 1;

}

=item FranchiseRuleTreatmentTypeAdd()

###

=cut

sub FranchiseRuleTreatmentTypeAdd {
    my ( $Self, %Param ) = @_;

    for (qw(ContractFranchiseRuleID TreatmentType)) {
        if ( !defined( $Param{$_} ) ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    return if !$Self->{DBObject}->Do(
        SQL => 'insert into franchise_rule_treatment_type  ('
            . ' contract_franchise_rule_id, treatment_type )'
            . ' VALUES (?,?)',
        Bind => [
            \$Param{ContractFranchiseRuleID},\$Param{TreatmentType},
        ],
    );
    
    return 1;

}

=item FranchiseRuleSlaAdd()

###

=cut

sub FranchiseRuleSlaAdd {
    my ( $Self, %Param ) = @_;

    for (qw(ContractFranchiseRuleID SLAID)) {
        if ( !defined( $Param{$_} ) ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    return if !$Self->{DBObject}->Do(
        SQL => 'insert into franchise_rule_sla  ('
            . ' contract_franchise_rule_id, sla_id )'
            . ' VALUES (?,?)',
        Bind => [
            \$Param{ContractFranchiseRuleID},\$Param{SLAID},
        ],
    );
    
    return 1;

}

=item FranchiseRuleServiceAdd()

###

=cut

sub FranchiseRuleServiceAdd {
    my ( $Self, %Param ) = @_;

    for (qw(ContractFranchiseRuleID ServiceID)) {
        if ( !defined( $Param{$_} ) ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    return if !$Self->{DBObject}->Do(
        SQL => 'insert into franchise_rule_service  ('
            . ' contract_franchise_rule_id, service_id )'
            . ' VALUES (?,?)',
        Bind => [
            \$Param{ContractFranchiseRuleID},\$Param{ServiceID},
        ],
    );
    
    return 1;

}

=item FranchiseRuleHourTypeAdd()

###

=cut

sub FranchiseRuleHourTypeAdd {
    my ( $Self, %Param ) = @_;

    for (qw(ContractFranchiseRuleID HourType)) {
        if ( !defined( $Param{$_} ) ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    return if !$Self->{DBObject}->Do(
        SQL => 'insert into franchise_rule_hour_type  ('
            . ' contract_franchise_rule_id, hour_type )'
            . ' VALUES (?,?)',
        Bind => [
            \$Param{ContractFranchiseRuleID},\$Param{HourType},
        ],
    );
    
    return 1;

}

=item FranchiseRuleRecurrenceUpd()

###

=cut

sub FranchiseRuleRecurrenceUpd {
    my ( $Self, %Param ) = @_;

    for (qw(ContractFranchiseRuleID Recurrence ContractID)) {
        if ( !defined( $Param{$_} ) ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }
	
	# update FranchiseRuleRecurrence
	return if !$Self->{DBObject}->Do(
		SQL =>
			'UPDATE contract_franchise_rule SET recurrence = ?'
			. ' WHERE id = ?'
			. ' AND contract_id = ?',
		Bind => [ \$Param{Recurrence}, \$Param{ContractFranchiseRuleID}, \$Param{ContractID}, ]
	);
    
    return 1;

}

=item FranchiseRuleHoursUpd()

###

=cut

sub FranchiseRuleHoursUpd {
    my ( $Self, %Param ) = @_;

    for (qw(ContractFranchiseRuleID Hours ContractID)) {
        if ( !defined( $Param{$_} ) ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }
	
	# update FranchiseRuleRecurrence
	return if !$Self->{DBObject}->Do(
		SQL =>
			'UPDATE contract_franchise_rule SET hours = ?'
			. ' WHERE id = ?'
			. ' AND contract_id = ?',
		Bind => [ \$Param{Hours}, \$Param{ContractFranchiseRuleID}, \$Param{ContractID}, ]
	);
    
    return 1;

}

=item FranchiseRuleTicketTypeUpd()

###

=cut

sub FranchiseRuleTicketTypeUpd {
    my ( $Self, %Param ) = @_;

    for (qw(ContractFranchiseRuleID TicketTypeID)) {
        if ( !defined( $Param{$_} ) ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }
	
	# update FranchiseRuleTicketType
	return if !$Self->{DBObject}->Do(
		SQL =>
			'UPDATE franchise_rule_ticket_type SET ticket_type_id = ?'
			. ' WHERE contract_franchise_rule_id = ?',
		Bind => [ \$Param{TicketTypeID}, \$Param{ContractFranchiseRuleID}, ]
	);
    
    return 1;

}

=item FranchiseRuleTreatmentTypeUpd()

###

=cut

sub FranchiseRuleTreatmentTypeUpd {
    my ( $Self, %Param ) = @_;

    for (qw(ContractFranchiseRuleID TreatmentType)) {
        if ( !defined( $Param{$_} ) ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }
	
	# update FranchiseRuleTreatmentType
	return if !$Self->{DBObject}->Do(
		SQL =>
			'UPDATE franchise_rule_treatment_type SET treatment_type = ?'
			. ' WHERE contract_franchise_rule_id = ?',
		Bind => [ \$Param{TreatmentType}, \$Param{ContractFranchiseRuleID}, ]
	);
    
    return 1;

}

=item FranchiseRuleSlaUpd()

###

=cut

sub FranchiseRuleSlaUpd {
    my ( $Self, %Param ) = @_;

    for (qw(ContractFranchiseRuleID SLAID)) {
        if ( !defined( $Param{$_} ) ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }
	
	# update FranchiseRuleSLA
	return if !$Self->{DBObject}->Do(
		SQL =>
			'UPDATE franchise_rule_sla SET sla_id = ?'
			. ' WHERE contract_franchise_rule_id = ?',
		Bind => [ \$Param{SLAID}, \$Param{ContractFranchiseRuleID}, ]
	);
    
    return 1;

}

=item FranchiseRuleServiceUpd()

###

=cut

sub FranchiseRuleServiceUpd {
    my ( $Self, %Param ) = @_;

    for (qw(ContractFranchiseRuleID ServiceID)) {
        if ( !defined( $Param{$_} ) ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }
	
	# update FranchiseRuleService
	return if !$Self->{DBObject}->Do(
		SQL =>
			'UPDATE franchise_rule_service SET service_id = ?'
			. ' WHERE contract_franchise_rule_id = ?',
		Bind => [ \$Param{ServiceID}, \$Param{ContractFranchiseRuleID}, ]
	);
    
    return 1;

}

=item FranchiseRuleHourTypeUpd()

###

=cut

sub FranchiseRuleHourTypeUpd {
    my ( $Self, %Param ) = @_;

    for (qw(ContractFranchiseRuleID HourType)) {
        if ( !defined( $Param{$_} ) ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }
	
	# update FranchiseRuleHourType
	return if !$Self->{DBObject}->Do(
		SQL =>
			'UPDATE franchise_rule_hour_type SET hour_type = ?'
			. ' WHERE contract_franchise_rule_id = ?',
		Bind => [ \$Param{HourType}, \$Param{ContractFranchiseRuleID}, ]
	);
    
    return 1;

}

=item CustomerContractUpdate()

to update customer users

    $CustomerUserObject->CustomerUserUpdate(
        Source        => 'CustomerUser', # CustomerUser source config
        ID            => 'mh'            # current user login
        UserLogin     => 'mhuber',       # new user login
        UserFirstname => 'Huber',
        UserLastname  => 'Manfred',
        UserPassword  => 'some-pass',    # not required
        UserEmail     => 'email@example.com',
        ValidID       => 1,
        UserID        => 123,
    );

=cut

sub CustomerContractUpdate {
    my ( $Self, %Param ) = @_;

    for (qw(ID CustomerID Number PeriodClosing ValidID)) {
        if ( !defined( $Param{$_} ) ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    my $existName;
    return 0 if  !$Self->{DBObject}->Prepare(
        SQL => 'SELECT id FROM customer_contract WHERE number = ? and customer_id = ? and ID <> ?',
        Bind => [\$Param{Number},\$Param{CustomerID},\$Param{ID},],
    );
    while ( my @Row = $Self->{DBObject}->FetchrowArray()){
        $existName = $Row[0];
    }
	
	if($existName){
		return 0;
	}

    return if !$Self->{DBObject}->Do(
        SQL => ' UPDATE customer_contract SET '
        	.' customer_id = ? ,'
        	.' number = ? ,'
        	.' period_closing = ? ,'
        	.' start_time = ? ,'
        	.' end_time = ? ,'
            .' related_to = ? ,'
            .' related_to_period = ? ,'
            .' valid_id = ? '
            . ' WHERE id = ? ',
        Bind => [
            \$Param{CustomerID},\$Param{Number},\$Param{PeriodClosing},\$Param{StartTime},\$Param{EndTime}, \$Param{RelatedTo}, \$Param{RelatedToPeriod}, \$Param{ValidID},
            \$Param{ID},
        ],
    );

    return 1;

}

=item CustomerContractPriceRuleRemove()

#

=cut

sub CustomerContractPriceRuleRemove {
    my ( $Self, %Param ) = @_;

    for (qw(ID)) {
        if ( !defined( $Param{$_} ) ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

   return if !$Self->{DBObject}->Prepare(
        SQL => 'SELECT contract_id, order_number from contract_price_rule where id = ?',
        Bind => [ \$Param{ID} ],
    );

    my $RetData;
    
    while ( my @Data = $Self->{DBObject}->FetchrowArray() ) {
        $RetData = {
            ContractID          => $Data[0],
            OrderNumber              => $Data[1],
        };
    }

    $Self->{DBObject}->Do(
        SQL => 'UPDATE contract_price_rule set order_number = order_number - 1 where contract_id = ? and order_number > ?;',
        Bind => [
            \$RetData->{ContractID},\$RetData->{OrderNumber},
        ],
    );

    $Self->{DBObject}->Do(
        SQL => ' delete from registry_contract_price where contract_price_rule_id = ?',
        Bind => [
            \$Param{ID},
        ],
    );

    $Self->{DBObject}->Do(
        SQL => ' delete from price_rule_treatment_type where contract_price_rule_id = ?',
        Bind => [
            \$Param{ID},
        ],
    );

    $Self->{DBObject}->Do(
        SQL => ' delete from price_rule_sla where contract_price_rule_id = ?',
        Bind => [
            \$Param{ID},
        ],
    );

    $Self->{DBObject}->Do(
        SQL => ' delete from price_rule_service where contract_price_rule_id = ?',
        Bind => [
            \$Param{ID},
        ],
    );

    $Self->{DBObject}->Do(
        SQL => ' delete from price_rule_ticket_type where contract_price_rule_id = ?',
        Bind => [
            \$Param{ID},
        ],
    );
 
    $Self->{DBObject}->Do(
        SQL => ' delete from price_rule_hour_type where contract_price_rule_id = ?',
        Bind => [
            \$Param{ID},
        ],
    );

    $Self->{DBObject}->Do(
        SQL => ' delete from contract_price_rule where id = ?',
        Bind => [
            \$Param{ID},
        ],
    );

    return 1;

}

=item CustomerContractFranchiseRuleRemove()

#

=cut

sub CustomerContractFranchiseRuleRemove {
    my ( $Self, %Param ) = @_;

    for (qw(ID)) {
        if ( !defined( $Param{$_} ) ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    return if !$Self->{DBObject}->Prepare(
        SQL => 'SELECT contract_id, order_number from contract_franchise_rule where id = ?',
        Bind => [ \$Param{ID} ],
    );

    my $RetData;
    
    while ( my @Data = $Self->{DBObject}->FetchrowArray() ) {
        $RetData = {
            ContractID          => $Data[0],
            OrderNumber              => $Data[1],
        };
    }

    $Self->{DBObject}->Do(
        SQL => 'UPDATE contract_franchise_rule set order_number = order_number - 1 where contract_id = ? and order_number > ?;',
        Bind => [
            \$RetData->{ContractID},\$RetData->{OrderNumber},
        ],
    );

    $Self->{DBObject}->Do(
        SQL => 'delete from registry_contract_franchise where contract_franchise_rule_id = ?',
        Bind => [
            \$Param{ID},
        ],
    );

    $Self->{DBObject}->Do(
        SQL => 'delete from franchise_rule_ticket_type where contract_franchise_rule_id = ?',
        Bind => [
            \$Param{ID},
        ],
    );

    $Self->{DBObject}->Do(
        SQL => 'delete from franchise_rule_treatment_type where contract_franchise_rule_id = ?',
        Bind => [
            \$Param{ID},
        ],
    );

    $Self->{DBObject}->Do(
        SQL => 'delete from franchise_rule_sla where contract_franchise_rule_id = ?',
        Bind => [
            \$Param{ID},
        ],
    );

    $Self->{DBObject}->Do(
        SQL => 'delete from franchise_rule_service where contract_franchise_rule_id = ?',
        Bind => [
            \$Param{ID},
        ],
    );

    $Self->{DBObject}->Do(
        SQL => 'delete from franchise_rule_hour_type where contract_franchise_rule_id = ?',
        Bind => [
            \$Param{ID},
        ],
    );

    $Self->{DBObject}->Do(
        SQL => 'delete from contract_franchise_rule where id = ?',
        Bind => [
            \$Param{ID},
        ],
    );

    return 1;

}

=item UpPriceRule()

#

=cut

sub UpPriceRule {
    my ( $Self, %Param ) = @_;

    for (qw(ID)) {
        if ( !defined( $Param{$_} ) ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    return if !$Self->{DBObject}->Prepare(
        SQL => 'SELECT contract_id, order_number from contract_price_rule where id = ?',
        Bind => [ \$Param{ID} ],
    );

    my $RetData;
    
    while ( my @Data = $Self->{DBObject}->FetchrowArray() ) {
        $RetData = {
            ContractID          => $Data[0],
            OrderNumber              => $Data[1],
        };
    }

    my $LastOrderNumber = $RetData->{OrderNumber}-1;

    return if !$Self->{DBObject}->Do(
        SQL => 'UPDATE contract_price_rule set order_number = order_number + 1 where contract_id = ? and order_number = ?;',
        Bind => [
            \$RetData->{ContractID},\$LastOrderNumber,
        ],
    );

    return if !$Self->{DBObject}->Do(
        SQL => 'UPDATE contract_price_rule set order_number = order_number - 1 where id = ?;',
        Bind => [
            \$Param{ID},
        ],
    );

    return 1;

}

=item DownPriceRule()

#

=cut

sub DownPriceRule {
    my ( $Self, %Param ) = @_;

    for (qw(ID)) {
        if ( !defined( $Param{$_} ) ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    return if !$Self->{DBObject}->Prepare(
        SQL => 'SELECT contract_id, order_number from contract_price_rule where id = ?',
        Bind => [ \$Param{ID} ],
    );

    my $RetData;
    
    while ( my @Data = $Self->{DBObject}->FetchrowArray() ) {
        $RetData = {
            ContractID          => $Data[0],
            OrderNumber              => $Data[1],
        };
    }

    my $LastOrderNumber = $RetData->{OrderNumber}+1;

    return if !$Self->{DBObject}->Do(
        SQL => 'UPDATE contract_price_rule set order_number = order_number - 1 where contract_id = ? and order_number = ?;',
        Bind => [
            \$RetData->{ContractID},\$LastOrderNumber,
        ],
    );

    return if !$Self->{DBObject}->Do(
        SQL => 'UPDATE contract_price_rule set order_number = order_number + 1 where id = ?;',
        Bind => [
            \$Param{ID},
        ],
    );

    return 1;

}

=item UpFranchiseRule()

#

=cut

sub UpFranchiseRule {
    my ( $Self, %Param ) = @_;

    for (qw(ID)) {
        if ( !defined( $Param{$_} ) ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    return if !$Self->{DBObject}->Prepare(
        SQL => 'SELECT contract_id, order_number from contract_franchise_rule where id = ?',
        Bind => [ \$Param{ID} ],
    );

    my $RetData;
    
    while ( my @Data = $Self->{DBObject}->FetchrowArray() ) {
        $RetData = {
            ContractID          => $Data[0],
            OrderNumber              => $Data[1],
        };
    }

    my $LastOrderNumber = $RetData->{OrderNumber}-1;

    return if !$Self->{DBObject}->Do(
        SQL => 'UPDATE contract_franchise_rule set order_number = order_number + 1 where contract_id = ? and order_number = ?;',
        Bind => [
            \$RetData->{ContractID},\$LastOrderNumber,
        ],
    );

    return if !$Self->{DBObject}->Do(
        SQL => 'UPDATE contract_franchise_rule set order_number = order_number - 1 where id = ?;',
        Bind => [
            \$Param{ID},
        ],
    );

    return 1;

}

=item DownFranchiseRule()

#

=cut

sub DownFranchiseRule {
    my ( $Self, %Param ) = @_;

    for (qw(ID)) {
        if ( !defined( $Param{$_} ) ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    return if !$Self->{DBObject}->Prepare(
        SQL => 'SELECT contract_id, order_number from contract_franchise_rule where id = ?',
        Bind => [ \$Param{ID} ],
    );

    my $RetData;
    
    while ( my @Data = $Self->{DBObject}->FetchrowArray() ) {
        $RetData = {
            ContractID          => $Data[0],
            OrderNumber              => $Data[1],
        };
    }

    my $LastOrderNumber = $RetData->{OrderNumber}+1;

    return if !$Self->{DBObject}->Do(
        SQL => 'UPDATE contract_franchise_rule set order_number = order_number - 1 where contract_id = ? and order_number = ?;',
        Bind => [
            \$RetData->{ContractID},\$LastOrderNumber,
        ],
    );

    return if !$Self->{DBObject}->Do(
        SQL => 'UPDATE contract_franchise_rule set order_number = order_number + 1 where id = ?;',
        Bind => [
            \$Param{ID},
        ],
    );

    return 1;

}

=item UpContract()

#

=cut

sub UpContract {
    my ( $Self, %Param ) = @_;

    for (qw(ID)) {
        if ( !defined( $Param{$_} ) ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    return if !$Self->{DBObject}->Prepare(
        SQL => 'SELECT customer_id, order_number from customer_contract where id = ?',
        Bind => [ \$Param{ID} ],
    );

    my $RetData;
    
    while ( my @Data = $Self->{DBObject}->FetchrowArray() ) {
        $RetData = {
            CustomerID          => $Data[0],
            OrderNumber              => $Data[1],
        };
    }

    my $LastOrderNumber = $RetData->{OrderNumber}-1;

    return if !$Self->{DBObject}->Do(
        SQL => 'UPDATE customer_contract set order_number = order_number + 1 where customer_id = ? and order_number = ?;',
        Bind => [
            \$RetData->{CustomerID},\$LastOrderNumber,
        ],
    );

    return if !$Self->{DBObject}->Do(
        SQL => 'UPDATE customer_contract set order_number = order_number - 1 where id = ?;',
        Bind => [
            \$Param{ID},
        ],
    );

    return 1;

}

=item DownContract()

#

=cut

sub DownContract {
    my ( $Self, %Param ) = @_;

    for (qw(ID)) {
        if ( !defined( $Param{$_} ) ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    return if !$Self->{DBObject}->Prepare(
        SQL => 'SELECT customer_id, order_number from customer_contract where id = ?',
        Bind => [ \$Param{ID} ],
    );

    my $RetData;
    
    while ( my @Data = $Self->{DBObject}->FetchrowArray() ) {
        $RetData = {
            CustomerID          => $Data[0],
            OrderNumber              => $Data[1],
        };
    }

    my $LastOrderNumber = $RetData->{OrderNumber}+1;

    return if !$Self->{DBObject}->Do(
        SQL => 'UPDATE customer_contract set order_number = order_number - 1 where customer_id = ? and order_number = ?;',
        Bind => [
            \$RetData->{CustomerID},\$LastOrderNumber,
        ],
    );

    return if !$Self->{DBObject}->Do(
        SQL => 'UPDATE customer_contract set order_number = order_number + 1 where id = ?;',
        Bind => [
            \$Param{ID},
        ],
    );

    return 1;

}

=item SetPassword()

to set customer users passwords

    $CustomerUserObject->SetPassword(
        UserLogin => 'some-login',
        PW        => 'some-new-password'
    );

=cut

sub SetPassword {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{UserLogin} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'User UserLogin!'
        );
        return;
    }

    # check if user exists
    my %User = $Self->CustomerUserDataGet( User => $Param{UserLogin} );
    if ( !%User ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "No such user '$Param{UserLogin}'!",
        );
        return;
    }
    return $Self->{ $User{Source} }->SetPassword(%Param);
}

=item GenerateRandomPassword()

generate a random password

    my $Password = $CustomerUserObject->GenerateRandomPassword();

    or

    my $Password = $CustomerUserObject->GenerateRandomPassword(
        Size => 16,
    );

=cut

sub GenerateRandomPassword {
    my ( $Self, %Param ) = @_;

    return $Self->{CustomerUser}->GenerateRandomPassword(%Param);
}

=item SetPreferences()

set customer user preferences

    $CustomerUserObject->SetPreferences(
        Key    => 'UserComment',
        Value  => 'some comment',
        UserID => 'some-login',
    );

=cut

sub SetPreferences {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{UserID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need UserID!'
        );
        return;
    }

    # check if user exists
    my %User = $Self->CustomerUserDataGet( User => $Param{UserID} );
    if ( !%User ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "No such user '$Param{UserID}'!",
        );
        return;
    }

    # call new api (2.4.8 and higher)
    if ( $Self->{ $User{Source} }->can('SetPreferences') ) {
        return $Self->{ $User{Source} }->SetPreferences(%Param);
    }

    # call old api
    return $Self->{PreferencesObject}->SetPreferences(%Param);
}

=item GetPreferences()

get customer user preferences

    my %Preferences = $CustomerUserObject->GetPreferences(
        UserID => 'some-login',
    );

=cut

sub GetPreferences {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{UserID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need UserID!'
        );
        return;
    }

    # check if user exists
    my %User = $Self->CustomerUserDataGet( User => $Param{UserID} );
    if ( !%User ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "No such user '$Param{UserID}'!",
        );
        return;
    }

    # call new api (2.4.8 and higher)
    if ( $Self->{ $User{Source} }->can('GetPreferences') ) {
        return $Self->{ $User{Source} }->GetPreferences(%Param);
    }

    # call old api
    return $Self->{PreferencesObject}->GetPreferences(%Param);
}

=item TokenGenerate()

generate a random token

    my $Token = $UserObject->TokenGenerate(
        UserID => 123,
    );

=cut

sub TokenGenerate {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{UserID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need UserID!"
        );
        return;
    }

    my $Token = $Kernel::OM->Get('Kernel::System::Main')->GenerateRandomString(
        Length => 14,
    );

    # save token in preferences
    $Self->SetPreferences(
        Key    => 'UserToken',
        Value  => $Token,
        UserID => $Param{UserID},
    );

    return $Token;
}

=item TokenCheck()

check password token

    my $Valid = $UserObject->TokenCheck(
        Token  => $Token,
        UserID => 123,
    );

=cut

sub TokenCheck {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{Token} || !$Param{UserID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need Token and UserID!"
        );
        return;
    }

    # get preferences token
    my %Preferences = $Self->GetPreferences(
        UserID => $Param{UserID},
    );

    # check requested vs. stored token
    return if !$Preferences{UserToken};
    return if $Preferences{UserToken} ne $Param{Token};

    # reset password token
    $Self->SetPreferences(
        Key    => 'UserToken',
        Value  => '',
        UserID => $Param{UserID},
    );

    return 1;
}

=item CalculateContract()

calculate contract values

    my $Valid = $UserObject->CalculateContract(
        TicketID  => 123,
        ArticleID => 123,
    );

=cut

sub CalculateContract {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{TicketID} || !$Param{ArticleID} || !$Param{UserID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need TicketID, ArticleID and UserID!"
        );
        return;
    }

    $Self->RegistryContractFranchiseRemove(
        TicketID       => $Param{TicketID},
        ArticleID      => $Param{ArticleID},
    );

    $Self->RegistryContractPriceRemove(
        TicketID       => $Param{TicketID},
        ArticleID      => $Param{ArticleID},
    );

    my $TreatmentTypeFieldName = $Kernel::OM->Get('Kernel::Config')->Get('CustomerContracts::DynamicField::TreatmentType');
    my $DynamicFieldStartName = $Kernel::OM->Get('Kernel::Config')->Get('Ticket::Complemento::AccountedTime::DynamicFieldStart');
    my $DynamicFieldEndName = $Kernel::OM->Get('Kernel::Config')->Get('Ticket::Complemento::AccountedTime::DynamicFieldEnd');

    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');
    my $ArticleObject = $Kernel::OM->Get('Kernel::System::Ticket::Article');
    my $ArticleBackendObject = $ArticleObject->BackendForArticle( TicketID => $Param{TicketID}, ArticleID => $Param{ArticleID} );
    my $UserObject = $Kernel::OM->Get('Kernel::System::User');
    my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');

    my $DynamicFieldStart = $DynamicFieldObject->DynamicFieldGet(
        Name   => $DynamicFieldStartName,
    );

    my $DynamicFieldEnd = $DynamicFieldObject->DynamicFieldGet(
        Name   => $DynamicFieldEndName,
    );

    #Pegar dados do Ticket e do Artigo -OK
        #id do customer -OK
        #tipo de ticket - OK
        #tipo de tratamento - OK
        #sla - OK
        #serviço - OK
        #tipo horas -OK
    my %Ticket = $TicketObject->TicketGet(
        TicketID      => $Param{TicketID},
        DynamicFields => 1,        
        UserID        => 1,
    );

    my %Article = $ArticleBackendObject->ArticleGet(
        TicketID      => $Param{TicketID},
        ArticleID     => $Param{ArticleID},
        DynamicFields => 1
    );

    my %Preferences = $UserObject->GetPreferences(
        UserID => $Param{UserID},
    );

    my $CustomerID = $Ticket{CustomerID};
    my $TypeID = $Ticket{TypeID};
    my $TreatmentType = $Ticket{"DynamicField_".$TreatmentTypeFieldName};
    my $SLAID = $Ticket{SLAID};
    my $ServiceID = $Ticket{ServiceID};
    my $UserTimeZone = $Preferences{UserTimeZone};
    my $CreateTime = $Kernel::OM->Create(
        'Kernel::System::DateTime',
        ObjectParams => {
            String   => $Article{CreateTime},
        }
    );

    #$Self->{LogObject}->Log( Priority => 'error', Message => Dumper( \%Param ));
    #$Self->{LogObject}->Log( Priority => 'error', Message => Dumper( \%Preferences ));
    #$Self->{LogObject}->Log( Priority => 'error', Message => Dumper( \$UserTimeZone ));
    $CreateTime->ToTimeZone(
        TimeZone => $UserTimeZone || $Self->{DateTimeObject}->OTRSTimeZoneGet() || $Self->{DateTimeObject}->SystemTimeZoneGet(),
    );
    
    my $CreateTimeSettings = $CreateTime->Get();
    my $TimeType = "Comercial";

    if($CreateTime->IsVacationDay()){
        $TimeType = "Feriados";
    }

    if($CreateTimeSettings->{DayOfWeek} == 6 || $CreateTimeSettings->{DayOfWeek} == 7){
        $TimeType = "Final de Semana";
    }

    if($CreateTimeSettings->{Hour} < 8 || $CreateTimeSettings->{Hour} == 18){
        $TimeType = "Nao Comercial";
    }
    
    #Pegar tempo gasto no artigo criado - OK
    return 1 if (!$Article{"DynamicField_".$DynamicFieldStart->{Name}});
    return 1 if (!$Article{"DynamicField_".$DynamicFieldEnd->{Name}});

    my $ArticleStartDate = $Kernel::OM->Create(
        'Kernel::System::DateTime',
        ObjectParams => {
            String   => $Article{"DynamicField_".$DynamicFieldStart->{Name}},
        }
    );
    my $ArticleEndDate = $Kernel::OM->Create(
        'Kernel::System::DateTime',
        ObjectParams => {
            String   => $Article{"DynamicField_".$DynamicFieldEnd->{Name}},
        }
    );
    my $Delta = $ArticleEndDate->Delta( DateTimeObject => $ArticleStartDate );
    my $TimeUsedInSeconds = $Delta->{AbsoluteSeconds};

    #buscar franquia disponível com o script abaixo para implementar a busca
    #select distinct * from
    #(select cfr.*,
    #ifnull((select sum(CAST(rcf.value AS UNSIGNED)) from registry_contract_franchise rcf where rcf.date between '2020-07-30 00:00:00' and '2020-07-30 23:59:59' and rcf.contract_franchise_rule_id = cfr.id),0) as total_day_used,
    #ifnull((select sum(CAST(rcf.value AS UNSIGNED)) from registry_contract_franchise rcf where rcf.date between '2020-07-26 00:00:00' and '2020-08-01 23:59:59' and rcf.contract_franchise_rule_id = cfr.id),0) as total_week_used,
    #ifnull((select sum(CAST(rcf.value AS UNSIGNED)) from registry_contract_franchise rcf where rcf.date between '2020-07-01 00:00:00' and '2020-07-31 23:59:59' and rcf.contract_franchise_rule_id = cfr.id),0) as total_month_used
    #from customer_contract cc
    #inner join contract_franchise_rule cfr on cfr.contract_id = cc.id
    #left join franchise_rule_ticket_type frtt on frtt.contract_franchise_rule_id = cfr.id
    #left join franchise_rule_treatment_type frty on frty.contract_franchise_rule_id = cfr.id
    #left join franchise_rule_sla frs on frs.contract_franchise_rule_id = cfr.id
    #left join franchise_rule_service frse on frse.contract_franchise_rule_id = cfr.id
    #left join franchise_rule_hour_type frht on frht.contract_franchise_rule_id = cfr.id
    #where cc.start_time <= '2020-07-30' and cc.end_time >= '2020-07-30' and cc.valid_id = 1 and
    #(frtt.ticket_type_id is null or frtt.ticket_type_id = 1) and
    #(frty.treatment_type is null or frty.treatment_type = 'Type1') and
    #(frs.sla_id is null or frs.sla_id = 1) and
    #(frse.service_id is null or frse.service_id = 1) and
    #(frht.hour_type is null or frht.hour_type = 'Comercial')
    #order by cfr.id desc) as result;
    my $ListFranchise = $Self->GetFranchaseRulesAvaliable(
        StartDate       => $CreateTime,
        CustomerID      => $CustomerID,
        TicketTypeID    => $TypeID,        
        TreatmentType   => $TreatmentType,      
        SLAID           => $SLAID,
        ServiceID       => $ServiceID,
        HourType        => $TimeType,
    );

    #subtrair tempo gasto de franquia
    #$Self->{LogObject}->Log( Priority => 'error', Message => Dumper( \$ListFranchise ));
    #$Self->{LogObject}->Log( Priority => 'error', Message => Dumper( \$TimeUsedInSeconds ));
    my $QtFranchise = scalar(@$ListFranchise);
    my $FranchiseIndex = 0;
    while($TimeUsedInSeconds > 0 && $QtFranchise > 0 && $FranchiseIndex < $QtFranchise){

      my $FranchiseInUse = @$ListFranchise[$FranchiseIndex];
      my $FranchiseAvailable = 0;

      if($FranchiseInUse->{Recurrence} eq 'diario'){
        $FranchiseAvailable = scalar($FranchiseInUse->{Seconds})-scalar($FranchiseInUse->{TotalDayUsed});
      }

      elsif($FranchiseInUse->{Recurrence} eq 'semanal'){
        $FranchiseAvailable = scalar($FranchiseInUse->{Seconds})-scalar($FranchiseInUse->{TotalWeekUsed});
      }

      elsif($FranchiseInUse->{Recurrence} eq 'mensal'){
        $FranchiseAvailable = scalar($FranchiseInUse->{Seconds})-scalar($FranchiseInUse->{TotalMonthUsed});
      }

      elsif($FranchiseInUse->{Recurrence} eq 'bimestral'){
        $FranchiseAvailable = scalar($FranchiseInUse->{Seconds})-scalar($FranchiseInUse->{Total2MonthUsed});
      }

      elsif($FranchiseInUse->{Recurrence} eq 'trimestral'){
        $FranchiseAvailable = scalar($FranchiseInUse->{Seconds})-scalar($FranchiseInUse->{Total3MonthUsed});
      }

      elsif($FranchiseInUse->{Recurrence} eq 'semestral'){
        $FranchiseAvailable = scalar($FranchiseInUse->{Seconds})-scalar($FranchiseInUse->{Total6MonthUsed});
      }

      elsif($FranchiseInUse->{Recurrence} eq 'anual'){
        $FranchiseAvailable = scalar($FranchiseInUse->{Seconds})-scalar($FranchiseInUse->{TotalYearUsed});
      }

      if($FranchiseAvailable >= $TimeUsedInSeconds || $FranchiseInUse->{Recurrence} eq 'ilimitado'){
        #Do the save
        $Self->RegistryContractFranchiseAdd(
          ContractFranchiseRuleID   => $FranchiseInUse->{ID},
          TicketID                  => $Param{TicketID},
          ArticleID                 => $Param{ArticleID},
          Value                     => $TimeUsedInSeconds
        );
        $TimeUsedInSeconds = 0;
      }

      else{
        #Do the save
        $Self->RegistryContractFranchiseAdd(
          ContractFranchiseRuleID   => $FranchiseInUse->{ID},
          TicketID                  => $Param{TicketID},
          ArticleID                 => $Param{ArticleID},
          Value                     => $FranchiseAvailable
        );
        $TimeUsedInSeconds = $TimeUsedInSeconds - $FranchiseAvailable;
        $FranchiseIndex = $FranchiseIndex + 1;
      }
    }

    #repetir enquanto houver tempo gasto e franquia disponível
    $CreateTime = $Kernel::OM->Create(
        'Kernel::System::DateTime',
        ObjectParams => {
            String   => $Article{CreateTime},
        }
    );

    #buscar regra de preço disponivel
    my $ListPrice = $Self->GetPriceRulesAvaliable(
        StartDate       => $CreateTime,
        CustomerID      => $CustomerID,
        TicketTypeID    => $TypeID,        
        TreatmentType   => $TreatmentType,      
        SLAID           => $SLAID,
        ServiceID       => $ServiceID,
        HourType        => $TimeType,
    );

    #subtrair e gerar registro de gasto de preço dentro das regras
    if(scalar(@$ListPrice) > 0 && $TimeUsedInSeconds > 0){
      my $PriceRuleInUse = @$ListPrice[0];

      my $calculateValue = $TimeUsedInSeconds * $PriceRuleInUse->{Value} / 3600;

      #Do the save
      $Self->RegistryContractPriceAdd(
        ContractPriceRuleID       => $PriceRuleInUse->{ID},
        TicketID                  => $Param{TicketID},
        ArticleID                 => $Param{ArticleID},
        Value                     => $calculateValue
      );
    }

    return 1;
}

=item GetFranchaseRulesAvaliable()

to search users

    # text search
    my $List = $CustomerUserObject->GetFranchaseRulesAvaliable(
        StartDate       => DateTime   
        CustomerID      => 1
        TicketTypeID    => 1,        
        TreatmentType   => 'Type1',      
        SLAID           => 1
        ServiceID       => 1
        HourType        => 'Comercial'
    );

=cut

sub GetFranchaseRulesAvaliable {
    my ( $Self, %Param ) = @_;

    my $actualDate = $Param{StartDate}->Format( Format => '%Y-%m-%d' );

    $Param{StartDate}->Set(
        Year     => $Param{StartDate}->Get()->{Year},
        Month    => $Param{StartDate}->Get()->{Month},
        Day      => $Param{StartDate}->Get()->{Day},
        Hour     => 00,
        Minute   => 00,
        Second   => 00,
    );
    my $startDayDate = $Param{StartDate}->Format( Format => '%Y-%m-%d %H:%M:%S' );
    
    $Param{StartDate}->Set(
        Year     => $Param{StartDate}->Get()->{Year},
        Month    => $Param{StartDate}->Get()->{Month},
        Day      => $Param{StartDate}->Get()->{Day},
        Hour     => 23,
        Minute   => 59,
        Second   => 59,
    );
    my $endDayDate = $Param{StartDate}->Format( Format => '%Y-%m-%d %H:%M:%S' );

    $Param{StartDate}->Subtract(
        Days      => $Param{StartDate}->Get()->{DayOfWeek},
    );

    $Param{StartDate}->Set(
        Year     => $Param{StartDate}->Get()->{Year},
        Month    => $Param{StartDate}->Get()->{Month},
        Day      => $Param{StartDate}->Get()->{Day},
        Hour     => 00,
        Minute   => 00,
        Second   => 00,
    );
    my $startWeekDate = $Param{StartDate}->Format( Format => '%Y-%m-%d %H:%M:%S' );
    $Param{StartDate}->Add(
        Days      => 6,
    );
    $Param{StartDate}->Set(
        Year     => $Param{StartDate}->Get()->{Year},
        Month    => $Param{StartDate}->Get()->{Month},
        Day      => $Param{StartDate}->Get()->{Day},
        Hour     => 23,
        Minute   => 59,
        Second   => 59,
    );
    my $endWeekDate = $Param{StartDate}->Format( Format => '%Y-%m-%d %H:%M:%S' );

    $Param{StartDate}->Subtract(
        Days      => $Param{StartDate}->Get()->{Day}-1,
    );
    $Param{StartDate}->Set(
        Year     => $Param{StartDate}->Get()->{Year},
        Month    => $Param{StartDate}->Get()->{Month},
        Day      => $Param{StartDate}->Get()->{Day},
        Hour     => 00,
        Minute   => 00,
        Second   => 00,
    );
    my $startMonthDate = $Param{StartDate}->Format( Format => '%Y-%m-%d %H:%M:%S' );

    my $LastDayOfMonth = $Param{StartDate}->LastDayOfMonthGet();
    $Param{StartDate}->Add(
        Days      => $LastDayOfMonth->{Day}-1,
    );
    $Param{StartDate}->Set(
        Year     => $Param{StartDate}->Get()->{Year},
        Month    => $Param{StartDate}->Get()->{Month},
        Day      => $Param{StartDate}->Get()->{Day},
        Hour     => 23,
        Minute   => 59,
        Second   => 59,
    );
    my $endMonthDate = $Param{StartDate}->Format( Format => '%Y-%m-%d %H:%M:%S' );

    # Get the start of 6 months ago
    $Param{StartDate}->Subtract( Months => 5 ); # Current month - 5 = 6 months
    my $start6MonthDate = $Param{StartDate}->Format( Format => '%Y-%m-01 00:00:00' );

    # Get the start of 3 months ago
    $Param{StartDate}->Add( Months => 3 );
    my $start3MonthDate = $Param{StartDate}->Format( Format => '%Y-%m-01 00:00:00' );

    # Get the start of 2 months ago
    $Param{StartDate}->Add( Months => 1 );
    my $start2MonthDate = $Param{StartDate}->Format( Format => '%Y-%m-01 00:00:00' );

    # Reset date object
    $Param{StartDate}->Add( Months => 1 );

    #AQUI CALCULA YEAR

    $Param{StartDate}->Subtract(
        Days      => $LastDayOfMonth->{Day}-1,
    );

    $Param{StartDate}->Set(
        Year     => $Param{StartDate}->Get()->{Year},
        Month    => $Param{StartDate}->Get()->{Month},
        Day      => $Param{StartDate}->Get()->{Day},
        Hour     => 00,
        Minute   => 00,
        Second   => 00,
    );
    #my $startYearDate = $Param{StartDate}->Format( Format => '%Y-%m-%d %H:%M:%S' );
    my $startYearDate = $Param{StartDate}->Format( Format => '%Y-01-01 00:00:00' );
    #$Param{StartDate}->Add(
    #    Days      => 365,
    #);
    #$Param{StartDate}->Set(
    #    Year     => $Param{StartDate}->Get()->{Year},
    #    Month    => $Param{StartDate}->Get()->{Month},
    #    Day      => $Param{StartDate}->Get()->{Day},
    #    Hour     => 23,
    #    Minute   => 59,
    #    Second   => 59,
    #);
    #my $endYearDate = $Param{StartDate}->Format( Format => '%Y-%m-%d %H:%M:%S' );
    my $endYearDate = $Param{StartDate}->Format( Format => '%Y-12-31 23:59:59' );
    #$Self->{LogObject}->Log( Priority => 'error', Message => Dumper( "$startYearDate - $endYearDate" ));
    
    return if !$Self->{DBObject}->Prepare(
        SQL => 'select distinct * from
                (select cfr.id, cfr.contract_id, cfr.name, cfr.recurrence, cfr.valid_id, 
                (ifnull(CAST(cfr.hours AS UNSIGNED),0)*60*60) as seconds,
                ifnull((select sum(CAST(rcf.value AS UNSIGNED)) from registry_contract_franchise rcf where rcf.date between ? and ? and rcf.contract_franchise_rule_id = cfr.id),0) as total_day_used,
                ifnull((select sum(CAST(rcf.value AS UNSIGNED)) from registry_contract_franchise rcf where rcf.date between ? and ? and rcf.contract_franchise_rule_id = cfr.id),0) as total_week_used,
                ifnull((select sum(CAST(rcf.value AS UNSIGNED)) from registry_contract_franchise rcf where rcf.date between ? and ? and rcf.contract_franchise_rule_id = cfr.id),0) as total_month_used,
                ifnull((select sum(CAST(rcf.value AS UNSIGNED)) from registry_contract_franchise rcf where rcf.date between ? and ? and rcf.contract_franchise_rule_id = cfr.id),0) as total_2month_used,
                ifnull((select sum(CAST(rcf.value AS UNSIGNED)) from registry_contract_franchise rcf where rcf.date between ? and ? and rcf.contract_franchise_rule_id = cfr.id),0) as total_3month_used,
                ifnull((select sum(CAST(rcf.value AS UNSIGNED)) from registry_contract_franchise rcf where rcf.date between ? and ? and rcf.contract_franchise_rule_id = cfr.id),0) as total_6month_used,
                ifnull((select sum(CAST(rcf.value AS UNSIGNED)) from registry_contract_franchise rcf where rcf.date between ? and ? and rcf.contract_franchise_rule_id = cfr.id),0) as total_year_used
                from customer_contract cc
                inner join contract_franchise_rule cfr on cfr.contract_id = cc.id
                left join franchise_rule_ticket_type frtt on frtt.contract_franchise_rule_id = cfr.id
                left join franchise_rule_treatment_type frty on frty.contract_franchise_rule_id = cfr.id
                left join franchise_rule_sla frs on frs.contract_franchise_rule_id = cfr.id
                left join franchise_rule_service frse on frse.contract_franchise_rule_id = cfr.id
                left join franchise_rule_hour_type frht on frht.contract_franchise_rule_id = cfr.id
                where cc.start_time <= ? and cc.end_time >= ? and cc.valid_id = 1 and cc.customer_id = ? and
                (frtt.ticket_type_id is null or frtt.ticket_type_id = ?) and
                (frty.treatment_type is null or frty.treatment_type = ?) and
                (frs.sla_id is null or frs.sla_id = ?) and
                (frse.service_id is null or frse.service_id = ?) and
                (frht.hour_type is null or frht.hour_type = ?)
                order by cc.order_number, cfr.order_number) as result
                where (result.recurrence = \'mensal\' and seconds > total_month_used) or
                (result.recurrence = \'semanal\' and seconds > total_week_used) or
                (result.recurrence = \'diario\' and seconds > total_day_used) or 
                (result.recurrence = \'bimestral\' and seconds > total_2month_used) or 
                (result.recurrence = \'trimestral\' and seconds > total_3month_used) or 
                (result.recurrence = \'semestral\' and seconds > total_6month_used) or 
                (result.recurrence = \'anual\' and seconds > total_year_used) or 
		(result.recurrence = \'ilimitado\') ', 
        Bind => [
          \$startDayDate,
          \$endDayDate,
          \$startWeekDate,
          \$endWeekDate,
          \$startMonthDate,
          \$endMonthDate,
          \$start2MonthDate,
          \$endMonthDate,
          \$start3MonthDate,
          \$endMonthDate,
          \$start6MonthDate,
          \$endMonthDate,
          \$startYearDate,
          \$endYearDate,
          \$actualDate,
          \$actualDate,
          \$Param{CustomerID},
          \$Param{TicketTypeID},
          \$Param{TreatmentType},
          \$Param{SLAID},
          \$Param{ServiceID},
          \$Param{HourType}
        ]               
    );

    my $Data = [];

    while ( my @Data = $Self->{DBObject}->FetchrowArray() ) {
        push @{ $Data },{
            ID             => $Data[0],
            ContractID     => $Data[1],
            Name           => $Data[2],
            Recurrence     => $Data[3],
            ValidID        => $Data[4],
            Seconds        => $Data[5],
            TotalDayUsed   => $Data[6],
            TotalWeekUsed  => $Data[7],
            TotalMonthUsed => $Data[8],
            Total2MonthUsed => $Data[9],
            Total3MonthUsed => $Data[10],
            Total6MonthUsed => $Data[11],
            TotalYearUsed  => $Data[12]
        };
    }
    
    return $Data;
}

=item GetPriceRulesAvaliable()

to search users

    # text search
    my $List = $CustomerUserObject->GetPriceRulesAvaliable(
        StartDate       => DateTime   
        CustomerID      => 1
        TicketTypeID    => 1,        
        TreatmentType   => 'Type1',      
        SLAID           => 1
        ServiceID       => 1
        HourType        => 'Comercial'
    );

=cut

sub GetPriceRulesAvaliable {
    my ( $Self, %Param ) = @_;

    my $actualDate = $Param{StartDate}->Format( Format => '%Y-%m-%d' );
    
    return if !$Self->{DBObject}->Prepare(
        SQL => 'select cfr.id, cfr.contract_id, cfr.name, cfr.value, cfr.value_total
                from customer_contract cc
                inner join contract_price_rule cfr on cfr.contract_id = cc.id
                left join price_rule_ticket_type frtt on frtt.contract_price_rule_id = cfr.id
                left join price_rule_treatment_type frty on frty.contract_price_rule_id = cfr.id
                left join price_rule_sla frs on frs.contract_price_rule_id = cfr.id
                left join price_rule_service frse on frse.contract_price_rule_id = cfr.id
                left join price_rule_hour_type frht on frht.contract_price_rule_id = cfr.id
                where cc.start_time <= ? and cc.end_time >= ? and cc.valid_id = 1 and cc.customer_id = ? and
                (frtt.ticket_type_id is null or frtt.ticket_type_id = ?) and
                (frty.treatment_type is null or frty.treatment_type = ?) and
                (frs.sla_id is null or frs.sla_id = ?) and
                (frse.service_id is null or frse.service_id = ?) and
                (frht.hour_type is null or frht.hour_type = ?)
                order by cc.order_number, cfr.order_number', 
        Bind => [
          \$actualDate,
          \$actualDate,
          \$Param{CustomerID},
          \$Param{TicketTypeID},
          \$Param{TreatmentType},
          \$Param{SLAID},
          \$Param{ServiceID},
          \$Param{HourType}
        ]               
    );

    my $Data = [];

    while ( my @Data = $Self->{DBObject}->FetchrowArray() ) {
        push @{ $Data },{
            ID              => $Data[0],
            ContractID      => $Data[1],
            Name            => $Data[2],
            Value           => $Data[3],
            ValueTotal      => $Data[4],
        };
    }
    
    return $Data;
}

sub RegistryContractFranchiseAdd {
    my ( $Self, %Param ) = @_;

    for (qw(ContractFranchiseRuleID TicketID ArticleID Value)) {
        if ( !defined( $Param{$_} ) ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    return if !$Self->{DBObject}->Do(
        SQL => 'insert into registry_contract_franchise  ('
            . ' contract_franchise_rule_id, ticket_id, article_id, time, date, value )'
            . ' VALUES (?,?,?, 0, now(), ?)',
        Bind => [
            \$Param{ContractFranchiseRuleID},
            \$Param{TicketID},
            \$Param{ArticleID},
            \$Param{Value},
        ],
    );
    
    return 1;

}

sub RegistryContractPriceAdd {
    my ( $Self, %Param ) = @_;

    for (qw(ContractPriceRuleID TicketID ArticleID Value)) {
        if ( !defined( $Param{$_} ) ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    return if !$Self->{DBObject}->Do(
        SQL => 'insert into registry_contract_price  ('
            . ' contract_price_rule_id, ticket_id, article_id, date, value )'
            . ' VALUES (?,?,?, now(), ?)',
        Bind => [
            \$Param{ContractPriceRuleID},
            \$Param{TicketID},
            \$Param{ArticleID},
            \$Param{Value},
        ],
    );
    
    return 1;

}

sub RegistryContractFranchiseRemove {
    my ( $Self, %Param ) = @_;

    for (qw(TicketID ArticleID)) {
        if ( !defined( $Param{$_} ) ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    return if !$Self->{DBObject}->Do(
        SQL => 'delete from registry_contract_franchise where ticket_id = ? and article_id = ?',
        Bind => [
            \$Param{TicketID},
            \$Param{ArticleID},
        ],
    );
    
    return 1;

}

sub RegistryContractPriceRemove {
    my ( $Self, %Param ) = @_;

    for (qw(TicketID ArticleID)) {
        if ( !defined( $Param{$_} ) ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    return if !$Self->{DBObject}->Do(
        SQL => 'delete from registry_contract_price where ticket_id = ? and article_id = ?',
        Bind => [
            \$Param{TicketID},
            \$Param{ArticleID},
        ],
    );
    
    return 1;

}

sub GetPriceRulesRegistry {
    my ( $Self, %Param ) = @_;
    
    
    return if !$Self->{DBObject}->Prepare(
        SQL => 'select rcf.id, 
                rcf.contract_price_rule_id,
                rcf.ticket_id,
                t.tn,
                rcf.article_id,
                rcf.date,
                rcf.value
                from registry_contract_price rcf
                inner join ticket t on t.id = rcf.ticket_id
                where rcf.contract_price_rule_id = ? 
                and (? = \'\' or rcf.date >= ?)
                and (? = \'\' or rcf.date <= ?)
                order by rcf.date desc', 
        Bind => [
          \$Param{ContractPriceRuleID},
          \$Param{FromSearch},
          \$Param{FromSearch},
          \$Param{ToSearch},
          \$Param{ToSearch},
        ]               
    );

    my $Data = [];

    while ( my @Data = $Self->{DBObject}->FetchrowArray() ) {
        push @{ $Data },{
            ID                  => $Data[0],
            ContractPriceRuleID => $Data[1],
            TicketID            => $Data[2],
            TicketNumber        => $Data[3],
            ArticleID           => $Data[4],
            Date                => $Data[5],
            Value               => $Data[6],
        };
    }
    
    return $Data;
}

sub GetFranchiseRulesRegistry {
    my ( $Self, %Param ) = @_;
    
    
    return if !$Self->{DBObject}->Prepare(
        SQL => 'select rcf.id, 
                rcf.contract_franchise_rule_id,
                rcf.ticket_id,
                t.tn,
                rcf.article_id,
                rcf.date,
                rcf.value
                from registry_contract_franchise rcf
                inner join ticket t on t.id = rcf.ticket_id
                where rcf.contract_franchise_rule_id = ?
                and (? = \'\' or rcf.date >= ?)
                and (? = \'\' or rcf.date <= ?)
                order by rcf.date desc', 
        Bind => [
          \$Param{ContractFranchiseRuleID},
          \$Param{FromSearch},
          \$Param{FromSearch},
          \$Param{ToSearch},
          \$Param{ToSearch},
        ]               
    );

    my $Data = [];

    while ( my @Data = $Self->{DBObject}->FetchrowArray() ) {
        push @{ $Data },{
            ID                      => $Data[0],
            ContractFranchiseRuleID => $Data[1],
            TicketID                => $Data[2],
            TicketNumber            => $Data[3],
            ArticleID               => $Data[4],
            Date                    => $Data[5],
            Value                   => $Data[6],
        };
    }
    
    return $Data;
}

sub CustomerServiceListGet {
    my ( $Self, %Param ) = @_;

    if ( !$Param{CustomerID} ) {
      return;
    }

=cut
    # create SQL query
    my $SQL = 'select distinct s.id 
                from service s
                inner join franchise_rule_service frs on frs.service_id = s.id
                inner join contract_franchise_rule cfr on frs.contract_franchise_rule_id = cfr.id
                inner join customer_contract cc on cfr.contract_id = cc.id and cc.valid_id = 1 and cc.start_time <= now() and cc.end_time >= now()
                inner join price_rule_service prs on prs.service_id = s.id
                inner join contract_price_rule cpr on prs.contract_price_rule_id = cpr.id
                inner join customer_contract cc1 on cpr.contract_id = cc1.id and cc1.valid_id = 1 and cc1.start_time <= now() and cc1.end_time >= now()
                where cc.customer_id = \'' . $Param{CustomerID} . '\' and cc1.customer_id = \'' . $Param{CustomerID} . '\'';

    # ask database
    $Self->{DBObject}->Prepare(
        SQL => $SQL,
    );

    # fetch the result
    my @CustomerServiceList;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        my %CustomerServiceData;
        $CustomerServiceData{CustomerID}  = $Param{CustomerID};
        $CustomerServiceData{ServiceID}   = $Row[0];
        push @CustomerServiceList, \%CustomerServiceData;
    }
=cut

	my $CustomerContract = $Self->CustomerContractsSearch( Search => $Param{CustomerID} );
	if ( scalar @{$CustomerContract} ) {

		my @CustomerServiceList;
		foreach my $Contract ( @{$CustomerContract} ) {
			next if $Contract->{ValidID} != 1;
			my $CurrentDateTime = $Kernel::OM->Create('Kernel::System::DateTime');
			my $ContractStart   = $Kernel::OM->Create('Kernel::System::DateTime', ObjectParams => { String => $Contract->{StartTime} });
			my $ContractEnd     = $Kernel::OM->Create('Kernel::System::DateTime', ObjectParams => { String => $Contract->{EndTime} });
			next if ($CurrentDateTime->Compare( DateTimeObject => $ContractStart ) < 0);
			next if ($CurrentDateTime->Compare( DateTimeObject => $ContractEnd ) > 0);
			my $ContractFranchiseRules = $Self->ContactFranchiseRuleList(ContractID => $Contract->{ID});
			if ($ContractFranchiseRules && (scalar @$ContractFranchiseRules) > 0) {
				for my $FranchiseRule (@$ContractFranchiseRules) {
					my $FranchiseRuleServices = $Self->FranchiseRuleServiceList(ContractFranchiseRuleID => $FranchiseRule->{ID});
					if (scalar @$FranchiseRuleServices> 0) {
						my @arr;
						foreach my $x ( @$FranchiseRuleServices ) {
        						my %CustomerServiceData;
						        $CustomerServiceData{CustomerID}  = $Param{CustomerID};
						        $CustomerServiceData{ServiceID}   = $x->{ServiceName};
						        push @CustomerServiceList, \%CustomerServiceData;
						}
					} else {
						foreach my $n ( 1..9999 ) {
	        					my %CustomerServiceData;
						        $CustomerServiceData{CustomerID}  = $Param{CustomerID};
						        $CustomerServiceData{ServiceID}   = $n;
						        push @CustomerServiceList, \%CustomerServiceData;
						}
					}
				}
			}
			my $ContractPriceRules = $Self->ContactPriceRuleList(ContractID => $Contract->{ID});
			if($ContractPriceRules && (scalar @$ContractPriceRules) > 0){
				for my $PriceRule (@$ContractPriceRules) {
					my $PriceRuleServices = $Self->PriceRuleServiceList(ContractPriceRuleID => $PriceRule->{ID});
					if (scalar @$PriceRuleServices > 0 ) {
						my @arr;
						foreach my $x ( @$PriceRuleServices ) {
        						my %CustomerServiceData;
						        $CustomerServiceData{CustomerID}  = $Param{CustomerID};
						        $CustomerServiceData{ServiceID}   = $x->{ServiceName};
						        push @CustomerServiceList, \%CustomerServiceData;
						}
					} else {
						foreach my $n ( 1..9999 ) {
	        					my %CustomerServiceData;
						        $CustomerServiceData{CustomerID}  = $Param{CustomerID};
						        $CustomerServiceData{ServiceID}   = $n;
						        push @CustomerServiceList, \%CustomerServiceData;
						}
					}
				}
			}
		} 
		
		return \@CustomerServiceList;

	} else {
	
		my @CustomerServiceList;
		return \@CustomerServiceList;

	}
}

sub CustomerSLAListGet {
    my ( $Self, %Param ) = @_;

    if ( !$Param{CustomerID} ) {
      return;
    }

=cut
    # create SQL query
    my $SQL = 'select distinct s.id 
                from sla s
                inner join franchise_rule_sla frs on frs.sla_id = s.id
                inner join contract_franchise_rule cfr on frs.contract_franchise_rule_id = cfr.id
                inner join customer_contract cc on cfr.contract_id = cc.id and cc.valid_id = 1 and cc.start_time <= now() and cc.end_time >= now()
                inner join price_rule_sla prs on prs.sla_id = s.id
                inner join contract_price_rule cpr on prs.contract_price_rule_id = cpr.id
                inner join customer_contract cc1 on cpr.contract_id = cc1.id and cc1.valid_id = 1 and cc1.start_time <= now() and cc1.end_time >= now()
                where cc.customer_id = \'' . $Param{CustomerID} . '\' and cc1.customer_id = \'' . $Param{CustomerID} . '\'';

    # ask database
    $Self->{DBObject}->Prepare(
        SQL => $SQL,
    );

    # fetch the result
    my @CustomerServiceList;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        my %CustomerServiceData;
        $CustomerServiceData{CustomerID}  = $Param{CustomerID};
        $CustomerServiceData{SLAID}   = $Row[0];
        push @CustomerServiceList, \%CustomerServiceData;
    }

    return \@CustomerServiceList;

=cut

	my $CustomerContract = $Self->CustomerContractsSearch( Search => $Param{CustomerID} );
	if ( scalar @{$CustomerContract} ) {

		my $FilterByService = ($Param{ServiceID}) ? 1 : 0;
		my %FranchiseIgnore;
		my %PriceIgnore;
		if ($FilterByService) {

			foreach my $Contract ( @{$CustomerContract} ) {
				next if $Contract->{ValidID} != 1;
				my $CurrentDateTime = $Kernel::OM->Create('Kernel::System::DateTime');
				my $ContractStart   = $Kernel::OM->Create('Kernel::System::DateTime', ObjectParams => { String => $Contract->{StartTime} });
				my $ContractEnd     = $Kernel::OM->Create('Kernel::System::DateTime', ObjectParams => { String => $Contract->{EndTime} });
				next if ($CurrentDateTime->Compare( DateTimeObject => $ContractStart ) < 0);
				next if ($CurrentDateTime->Compare( DateTimeObject => $ContractEnd ) > 0);

				# Filter franchise rules
				my $ContractFranchiseRules = $Self->ContactFranchiseRuleList(ContractID => $Contract->{ID});
				if ($ContractFranchiseRules && (scalar @$ContractFranchiseRules) > 0) {
					for my $FranchiseRule (@$ContractFranchiseRules) {
						my $FranchiseRuleServices = $Self->FranchiseRuleServiceList(ContractFranchiseRuleID => $FranchiseRule->{ID});
						foreach my $x ( @$FranchiseRuleServices ) {
							if ($x->{ServiceID} != $Param{ServiceID}) {
									$FranchiseIgnore{ $x->{ContractFranchiseRuleID} } = 1;
							} else {
									delete $FranchiseIgnore{ $x->{ContractFranchiseRuleID} };
							}
						}	
					}
				}

				# Filter price rules
				my $ContractPriceRules = $Self->ContactPriceRuleList(ContractID => $Contract->{ID});
				if($ContractPriceRules && (scalar @$ContractPriceRules) > 0){
					for my $PriceRule (@$ContractPriceRules) {
						my $PriceRuleServices = $Self->PriceRuleServiceList(ContractPriceRuleID => $PriceRule->{ID});
						foreach my $x ( @$PriceRuleServices ) {
							if ($x->{ServiceID} != $Param{ServiceID}) {
									$PriceIgnore{ $x->{ContractPriceRuleID} } = 1;
							} else {
									delete $PriceIgnore{ $x->{ContractPriceRuleID} };
							}
						}
					}
				}

			}
		}
		#$Self->{LogObject}->Log( Priority => 'error', Message => Dumper( \%FranchiseIgnore ));
		#$Self->{LogObject}->Log( Priority => 'error', Message => Dumper( \%PriceIgnore ));

		my @CustomerServiceList;
		foreach my $Contract ( @{$CustomerContract} ) {
			next if $Contract->{ValidID} != 1;
			my $CurrentDateTime = $Kernel::OM->Create('Kernel::System::DateTime');
			my $ContractStart   = $Kernel::OM->Create('Kernel::System::DateTime', ObjectParams => { String => $Contract->{StartTime} });
			my $ContractEnd     = $Kernel::OM->Create('Kernel::System::DateTime', ObjectParams => { String => $Contract->{EndTime} });
			next if ($CurrentDateTime->Compare( DateTimeObject => $ContractStart ) < 0);
			next if ($CurrentDateTime->Compare( DateTimeObject => $ContractEnd ) > 0);
			my $ContractFranchiseRules = $Self->ContactFranchiseRuleList(ContractID => $Contract->{ID});
			if ($ContractFranchiseRules && (scalar @$ContractFranchiseRules) > 0) {
				for my $FranchiseRule (@$ContractFranchiseRules) {
					next if ( $FilterByService && $FranchiseIgnore{ $FranchiseRule->{ID} } == 1);
					my $FranchiseRuleSLAs = $Self->FranchiseRuleSLAList(ContractFranchiseRuleID => $FranchiseRule->{ID});
					if (scalar @$FranchiseRuleSLAs > 0) {
						my @arr;
						foreach my $x ( @$FranchiseRuleSLAs ) {
	       						my %CustomerServiceData;
						        $CustomerServiceData{CustomerID}  = $Param{CustomerID};
						        $CustomerServiceData{SLAID}   = $x->{SLAName};
						        push @CustomerServiceList, \%CustomerServiceData;
						}
					} else {
						foreach my $n ( 1..9999 ) {
	        					my %CustomerServiceData;
						        $CustomerServiceData{CustomerID}  = $Param{CustomerID};
						        $CustomerServiceData{SLAID}   = $n;
						        push @CustomerServiceList, \%CustomerServiceData;
						}
					}
				}
			}
			my $ContractPriceRules = $Self->ContactPriceRuleList(ContractID => $Contract->{ID});
			if($ContractPriceRules && (scalar @$ContractPriceRules) > 0){
				for my $PriceRule (@$ContractPriceRules) {
					next if ( $FilterByService && $PriceIgnore{ $PriceRule->{ID} } == 1);
					my $PriceRuleSLAs = $Self->PriceRuleSLAList(ContractPriceRuleID => $PriceRule->{ID});
					if (scalar @$PriceRuleSLAs > 0 ) {
						my @arr;
						foreach my $x ( @$PriceRuleSLAs ) {
        						my %CustomerServiceData;
						        $CustomerServiceData{CustomerID}  = $Param{CustomerID};
						        $CustomerServiceData{SLAID}   = $x->{SLAName};
						        push @CustomerServiceList, \%CustomerServiceData;
						}
					} else {
						foreach my $n ( 1..9999 ) {
	        					my %CustomerServiceData;
						        $CustomerServiceData{CustomerID}  = $Param{CustomerID};
						        $CustomerServiceData{SLAID}   = $n;
						        push @CustomerServiceList, \%CustomerServiceData;
						}
					}
				}
			}
		} 
		
		return \@CustomerServiceList;

	} else {
	
		my @CustomerServiceList;
		return \@CustomerServiceList;

	}
}

sub DESTROY {
    my $Self = shift;

    # execute all transaction events
    $Self->EventHandlerTransaction();

    return 1;
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
