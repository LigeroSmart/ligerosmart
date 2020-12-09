package Kernel::Modules::CustomerTopService;

use strict;
use warnings;
use utf8;

sub new { 
	my ($Type, %Param) = @_;

	# allocate new hash for object
	my $Self = {%Param};
	bless ($Self, $Type);
	 
	return $Self;
}
sub Run {
	my ( $Self, %Param) = @_;

	
    my $LayoutObject       = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $ParamObject        = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $UserObject 		   = $Kernel::OM->Get('Kernel::System::User');
	my $LogObject 		   = $Kernel::OM->Get("Kernel::System::Log");
	my $TicketObject	   = $Kernel::OM->Get("Kernel::System::Ticket");
	my $ConfigObject	   = $Kernel::OM->Get("Kernel::Config");
	my $LigeroSmartObject  = $Kernel::OM->Get("Kernel::System::LigeroSmart");
	my $ServiceObject 	   = $Kernel::OM->Get("Kernel::System::Service");
	if($Self->{Subaction} eq 'AjaxTopService'){
		my $CategoryTitle = $ParamObject->GetParam(Param => "CategoryTitle");
		my %HashQuery;
		my $Config  = $Self->{Config} = $Kernel::OM->Get('Kernel::Config')->Get("ServiceCatalog")||{};

		my $Index = $Kernel::OM->Get('Kernel::Config')->Get('LigeroSmart::Index');
		$Index .= "_*_search";
		$Index = lc($Index);
						
		my $ConfigTopHitsDays = $Config->{TopHitsDays} || 30;
		$HashQuery{query} = {
			     "range" => {
           			 "Ticket.Created" => {
						"gte" => "now-".$ConfigTopHitsDays."d",
		                "lte" =>  "now" 
		             }
		         }	
		};
		$HashQuery{size} = 0;
		$HashQuery{aggs} = {
			servico => {
	            terms => { 	field => "Ticket.ServiceID" },
        	}
		};
		my %SearchResultsHash = $LigeroSmartObject->Search(
            Indexes => $Index,
            Types   => 'ticket',
            Data    => \%HashQuery,
 
	    );
		
		my %JsonHash;
		my @AOH;

		my %TypesColor = %{$Config->{TypeColors}};
		my %TypesLabel = %{$Config->{TypeLabels}};
			
		foreach my $Keys( @{$SearchResultsHash{aggregations}{servico}{buckets}}) {

			#my $ServiceName = $Keys->{key};
	   		#my $ServiceID = $ServiceObject->ServiceLookup(
    	    	#Name => $ServiceName,

    		#);

			my $ServiceID = $Keys->{key};
	   		my $ServiceName = $ServiceObject->ServiceLookup(
    	    	ServiceID => $ServiceID,

    		);

			my %ServicePreferences = $ServiceObject->ServicePreferencesGet(
			   ServiceID => $ServiceID,
			   UserID    => 1,
			);		

			my $ServiceTypeID = $ServicePreferences{TicketType} || '';

			if($CategoryTitle){
				next if($ServiceName !~ /.*\Q$CategoryTitle/);
			}
			my %TopHash;
			$TopHash{value} = $Keys->{doc_count};
			
			$TopHash{name} = $ServiceName;
			# Ronaldo: Robert, vou ver se consigo pegar o nome do serviço traduzido
			#my %Service = $ServiceObject->ServiceGet(
			   #ServiceID => $ServiceID,
			   #UserID    => 1,
			#);		
			#$TopHash{name} = $Service{Name};
			
			$TopHash{LayoutTypeDescription} = $TypesLabel{$ServiceTypeID} || $TypesLabel{'0'} || '';

			$TopHash{backColor} = $TypesColor{$TopHash{LayoutTypeDescription}};

            $TopHash{LayoutTypeDescription} = $LayoutObject->{LanguageObject}->Translate($TopHash{LayoutTypeDescription});

			$TopHash{id} = $ServiceID;
			push @AOH, \%TopHash;
		}
		$JsonHash{Servico} = \@AOH;
		my $JsonString = $Kernel::OM->Get('Kernel::System::JSON')->Encode(Data => \%JsonHash);
        return $LayoutObject->Attachment(
            ContentType => 'application/json; charset=' . $LayoutObject->{Charset},
            Content     => $JsonString,
            Type        => 'inline',
            NoCache     => 1,
			Sandbox => 1	
        );
	}
}
1;
