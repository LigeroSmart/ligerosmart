# --
# Copyright (C) 2001-2018 Complemento - Liberdade e Tecnologia http://www.complemento.net.br
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --
package Kernel::Modules::CustomerServiceCatalog;

use Kernel::System::VariableCheck (qw(:all));
use strict;
use warnings;
use utf8;
use Kernel::System::VariableCheck qw(:all);
use JSON;
use Data::Dumper;
sub new {
	my ( $Type, %Param ) = @_;
	# allocate new hash for object
	my $Self = {%Param};
	bless( $Self, $Type );
	return $Self;
}

sub Run {
	my ( $Self, %Param ) = @_;

	# get params
	my %GetParam;
	my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');
	my $LayoutObject  = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
	my $Config  = $Self->{Config} = $Kernel::OM->Get('Kernel::Config')->Get("ServiceCatalog")||{};
	my $LigeroSmartObject = $Kernel::OM->Get('Kernel::System::LigeroSmart');	
	my %TypesColor = %{$Config->{TypeColors}};
	for my $Key (qw(KeyPrimary FAQID ServiceID Service StateID State CustomParam0 CustomParam1 CustomParam2 CustomParam3 CustomParam4 CustomParam5 CustomParam6 CustomParam7 CustomParam8 CustomParam9)) {
		$GetParam{$Key} = $ParamObject->GetParam( Param => $Key );
        delete $GetParam{$Key} if (!$GetParam{$Key});
	}

	# Get all services that are visible by this customer
	my %Services;
	use Try::Tiny;

	try {
		$Kernel::OM->Get('Kernel::System::SubscriptionPlan');
		%Services = %{$Self->_GetServicesSP(CustomerUserID => $Self->{UserID})};
	} catch {
		%Services = %{$Self->_GetServices(CustomerUserID => $Self->{UserID})};
	};
	
	my %DataParam = (
		Name         => 'Service',
        Data         => \%Services,
		Translation  => 0,
        PossibleNone => 0,
        TreeView     => 0,
	);
	my $OptionRef = $LayoutObject->_BuildSelectionOptionRefCreate(%DataParam);
	
	$OptionRef->{Sort} = 'TreeView';
	$OptionRef->{Max}=0;
		
	my $AttributeRef = $LayoutObject->_BuildSelectionAttributeRefCreate(%DataParam);
	my $DataRef = $LayoutObject->_BuildSelectionDataRefCreate(
        Data         => \%Services,
        AttributeRef => $AttributeRef,
        OptionRef    => $OptionRef,
    );
	my $ServiceObject = $Kernel::OM->Get("Kernel::System::Service");
    # Creates array of searchable services IDs for elasticsearch filter
	my @SearchableServiceIDS;
	foreach my $dataKey ( @{$DataRef}){
		my $ServiceName = $dataKey->{Value};
		my $ServiceID = $dataKey->{Key};
		if(!$ServiceID or $ServiceID eq "-"){
			 $ServiceID = $ServiceObject->ServiceLookup(
		        Name => $ServiceName,
		    );
		}
        
		push @SearchableServiceIDS, "$ServiceID";
			
	}

	if($Self->{Subaction} eq  'VerifyOpenTickets'){
		my $ServiceIDRecovered = $ParamObject->GetParam(Param => 'ServiceID') || '';

		if($ServiceIDRecovered){

			my $JustOneTicketConfig = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldGet(
				Name   => 'JustOneTicket',             # ID or Name must be provided
			);
			my $JustOneTicket = $Kernel::OM->Get('Kernel::System::DynamicField::Backend')->ValueGet(
				DynamicFieldConfig => $JustOneTicketConfig,      # complete config of the DynamicField
				ObjectID           => $ServiceIDRecovered,                # ID of the current object that the field
			) || '';

			return $LayoutObject->Attachment(
				ContentType => 'application/json; charset=utf8',
				Content     => '0',
				Type        => 'inline',
				NoCache     => 1,
			) if !$JustOneTicket;

			my @TicketIDs = $Kernel::OM->Get('Kernel::System::Ticket')->TicketSearch(
				ServiceIDs => [$ServiceIDRecovered],
				#CustomerUserLogin     => $Self->{UserID},
				StateType    => ['new','open'],
				Result              => 'ARRAY',
				CustomerUserLogin => $Self->{UserID},
				CustomerUserID => $Self->{UserID},
				Permission     => 'rw',
			);

			return $LayoutObject->Attachment(
				ContentType => 'application/json; charset=utf8',
				Content     => @TicketIDs[0],
				Type        => 'inline',
				NoCache     => 1,
			) if(scalar(@TicketIDs) > 0);
		}

		return $LayoutObject->Attachment(
            ContentType => 'application/json; charset=utf8',
            Content     => '0',
            Type        => 'inline',
            NoCache     => 1,
        );
	}
    elsif($Self->{Subaction} eq  'SelfAnswered'){
        # User is satisfied with some FAQ Article. Let's create a ticket for that
        
        # First, get all information we need
        $GetParam{ServiceID} = $ServiceObject->ServiceLookup(
                            Name => $GetParam{Service},
                        );
        $GetParam{CustomerUser} = $Self->{UserID};
        my %CustomerUser = $Kernel::OM->Get('Kernel::System::CustomerUser')->CustomerUserDataGet(
            User => $Self->{UserID},
        );
        $GetParam{CustomerID} = $CustomerUser{UserCustomerID};
        my %FAQ;
        if ($GetParam{FAQID}){
            %FAQ = $Kernel::OM->Get("Kernel::System::FAQ")->FAQGet(
                        ItemID => $GetParam{FAQID},
                        UserID	=> 1,
                        ItemFields => 0,
                    );
            $GetParam{FAQTitle} = $FAQ{Title};
        }

        my $WtahConfig = $Kernel::OM->Get('Kernel::Config')->Get("WasThisArticleHelpful");
        
        my %TicketAttributes = %{$WtahConfig->{SelfAnsweredTicketAttributes}};
        for my $Key(keys %TicketAttributes){
            for my $Param(keys %GetParam){
                $TicketAttributes{$Key} =~ s/_${Param}_/$GetParam{$Param}/gm;
            }
        }
        
        my %Article = %{$WtahConfig->{SelfAnsweredArticle}};
        for my $Key(keys %Article){
            for my $Param(keys %GetParam){
                $Article{$Key} =~ s/_${Param}_/$GetParam{$Param}/gm;
            }
        }
        # Create Ticket
        my $TicketID = $Kernel::OM->Get('Kernel::System::Ticket')->TicketCreate(
            %TicketAttributes,
            %GetParam
        );
        
        my %DynamicFields = %{$WtahConfig->{SelfAnsweredTicketDynamicFields}};
        # get dynamic field backend object
        my $DynamicFieldBackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');
        
        # Set Dynamic Fields
        for my $Key(keys %DynamicFields){
            for my $Param(keys %GetParam){
                $DynamicFields{$Key} =~ s/_${Param}_/$GetParam{$Param}/gm;
            }
            ## get config for criticality dynamic field
            my $DynamicFieldConfig = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldGet(
                Name => $Key,
            );

            $DynamicFieldBackendObject->ValueSet(
                DynamicFieldConfig => $DynamicFieldConfig,
                ObjectID           => $TicketID,
                Value              => $DynamicFields{$Key} || '' ,
                UserID             => 1,
            );
        }
        
        # Create Article
        my $ArticleObject = $Kernel::OM->Get('Kernel::System::Ticket::Article');
        my $ArticleBackendObject = $ArticleObject->BackendForChannel( ChannelName => 'Phone' );
        my $ArticleID = $ArticleBackendObject->ArticleCreate(

            TicketID => $TicketID,
            %Article,
            %GetParam

        );

        # Redirect User to the Service Catalog
        my $Redirect = $LayoutObject->{Baselink}
                            . 'Action=CustomerServiceCatalog';
        return $LayoutObject->Redirect( OP => $Redirect );

    }
    # Subaction for searching on customer portal (services and other objects)
	elsif($Self->{Subaction} eq  'AjaxCustomerService'){
		
		my $Index = $Kernel::OM->Get('Kernel::Config')->Get('LigeroSmart::Index');

		my $Lang = $Self->{UserLanguage} || $ENV{UserLanguage} || '*';
		$Index .= "_".$Lang."_search";

		$Index = lc($Index);
		
		my $Term = $ParamObject->GetParam(Param => 'Term');
 	    my $StartHit = int( $ParamObject->GetParam( Param => 'StartHit' ));
		 $StartHit = 0	if($StartHit == 1);
				
        my $EndHit = $ParamObject->GetParam( Param => 'EndHit') || 10;
		if($StartHit > 0){
			$EndHit = $StartHit + 10;
		} 
		my $JSON; 

        # Construct Template Query
		my %HashQuery;

		$HashQuery{source}->{from} = $StartHit ;
		$HashQuery{source}->{size} = $EndHit;

        $HashQuery{params}->{pesquisa}   = $Term;
        $HashQuery{params}->{ServiceIDs} = [@SearchableServiceIDS];
        $HashQuery{params}->{Language} = $Self->{UserLanguage};

        $HashQuery{source}->{query} = 
            $Kernel::OM->Get('Kernel::System::JSON')->Decode(Data => $Config->{InlineQueryTemplate});

		$HashQuery{source}->{highlight} = {
			require_field_match => JSON::false,
			fields => {
	            Title => {
            	    pre_tags => ["<mark class=\"elasticHightlightTitle\">"],
	                post_tags => ["</mark>"],
	                fragment_size=> 10000
    	        },
	            Description =>{
            	    pre_tags => ["<mark class=\"elasticHightlightDesc\">"],
	                post_tags => ["</mark>"],

					fragment_size=> $Kernel::OM->Get('Kernel::Config')->Get("ServiceCatalog::CharLimiteSizeDescription") || 100
				}

        	}
		};
		my %SearchResultsHash = $LigeroSmartObject->SearchTemplate(
            Indexes => $Index,
            Types   => 'portallinks',
            Data    => \%HashQuery,
	    );
		my %ViewHash;
		my $AllHits = $SearchResultsHash{hits}{total};
		my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
		my $SplitTimes = $ConfigObject->Get("ServiceCatalog::SplitFirstLvl") || 0;

		$LayoutObject->Block( Name => "NumberOfRows", 
							  Data =>{ NumberOfRows => $AllHits} 
						    );
	
 		foreach my $document (@{$SearchResultsHash{hits}->{hits}}){

			my $TruncateSizeDesc = $ConfigObject->Get("ServiceCatalog::CharLimiteSizeDescription") || 100;
			# If there is a highlight then changes what's shown to the user (_source Title and Description)
			#
			if(defined($document->{highlight}->{Title}) and scalar $document->{highlight}->{Title} > 0){
				$document->{_source}->{Title} = $document->{highlight}->{Title}[0];
			} 
			if(defined($document->{highlight}->{Description}) and scalar $document->{highlight}->{Description} > 0){
				$document->{_source}->{Description} = $document->{highlight}->{Description}[0];
			} 
	
		   	$document->{_source}->{backColor} = $TypesColor{$document->{_source}->{Subtitle}}; 	
			#$TruncateSizeDesc = _CountTruncate($TruncateSizeDesc, $document->{_source}->{Description});
			#$document->{_source}->{TruncateSizeDesc} = $TruncateSizeDesc;

			# Check if we need to split "::"
			my $c = $document->{_source}->{Title} =~ tr/:://;
			if ($c > 1 and $SplitTimes > 0){
				
				my @fields = split("::",$document->{_source}->{Title},2);
				$document->{_source}->{Title} = $fields[1];
			}

			if($document->{_source}->{Object} eq "Service"){
				my $DynamicFieldConfig = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldGet(
					Name   => 'ForwardToUrl',             # ID or Name must be provided
				);
				my $ForwardToUrl = $Kernel::OM->Get('Kernel::System::DynamicField::Backend')->ValueGet(
					DynamicFieldConfig => $DynamicFieldConfig,      # complete config of the DynamicField
					ObjectID           => $document->{_source}->{ObjectID},                # ID of the current object that the field
																		# must be linked to, e. g. TicketID
				)||'';

				$DynamicFieldConfig = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldGet(
					Name   => 'UrlTarget',             # ID or Name must be provided
				);
				my $UrlTarget = $Kernel::OM->Get('Kernel::System::DynamicField::Backend')->ValueGet(
					DynamicFieldConfig => $DynamicFieldConfig,      # complete config of the DynamicField
					ObjectID           => $document->{_source}->{ObjectID},                # ID of the current object that the field
																		# must be linked to, e. g. TicketID
				)||'';

				if($ForwardToUrl eq ''){
					$LayoutObject->Block( Name => "Result", Data=> $document->{_source});
				}
				else{
					$document->{_source}->{Url}=$ForwardToUrl;
					$document->{_source}->{UrlTarget}=$UrlTarget;
					$LayoutObject->Block( Name => "ResultUrl", Data=> $document->{_source});
				}
			}
			else{
				$LayoutObject->Block( Name => "Result", 
								  Data => $document->{_source}
							    );
			}			
		}
    	my $PageShown = 10;
        my $Link =  'Subaction=' . $LayoutObject->Ascii2Html( Text => $Self->{Subaction} )
			.';Term=' . $LayoutObject->Ascii2Html( Text => $Term )
            . ';';

        my %PageNav = $LayoutObject->PageNavBar(
            Limit     => 10000,
            StartHit  => $StartHit,
            PageShown => $PageShown,
            AllHits   => $AllHits,
            Action    => 'Action=CustomerServiceCatalog',
            Link      => $Link,
            IDPrefix  => 'CustomerServiceCatalog',
        );
        $LayoutObject->Block(
                Name => 'FilterFooter',
                Data => {
                    %Param,
                    %PageNav,
                },
            );
	   my $SessionObject = $Kernel::OM->Get('Kernel::System::AuthSession');
       $SessionObject->UpdateSessionID(
                SessionID => $Self->{SessionID},
                Key       => "LastScreenOverview",
                Value     => "Action=CustomerServiceCatalog;",
            );
	
	    ### GENERATE OUTPUT for search
	 	my $HTML = $LayoutObject->Output(
	        TemplateFile => 'CustomerServiceCatalogResult',
	        Data         => \%Param,
	    );
		return $LayoutObject->Attachment(
        	ContentType => 'text/html; charset=' . $LayoutObject->{Charset},
            Content     => $HTML,
            Type        => 'inline',
            NoCache     => 1,
        );
		
	}
	else{
		
		# Check if we got a Service
		if ( $GetParam{KeyPrimary} ){
			$GetParam{ServiceID} = $ServiceObject->ServiceLookup(
										Name => $GetParam{KeyPrimary},
									);

			my $LinksDescription = $Kernel::OM->Get('Kernel::System::LinkObject')->LinkList(
				Object => 'Service',
				Object2 => 'FAQ',
				Key    => $GetParam{ServiceID},
				State  => 'Valid',
				Type   => 'ServiceDescriptionArticle',
				UserID => 1,
			);

			my @FAQsDesc;
			if ($LinksDescription->{FAQ}){
				my %LinkedFaqIDsDesc = %{$LinksDescription->{FAQ}->{ServiceDescriptionArticle}->{Source}};
				my @FaqIDsDesc = keys %LinkedFaqIDsDesc;
				my $FAQObjectDesc = $Kernel::OM->Get("Kernel::System::FAQ") if @FaqIDsDesc;

				foreach my $FaqIDDesc (@FaqIDsDesc){
					my %FAQDesc = $FAQObjectDesc->FAQGet(
						ItemID => $FaqIDDesc,
						UserID	=> 1,
						ItemFields => 1,
					);
					
					next if($FAQDesc{Language} ne $ENV{UserLanguage});
					next if($FAQDesc{Valid} ne 'valid');

					$LayoutObject->Block( Name => "CategoryFaqDesc", Data=> { FaqTitle => $FAQDesc{Title}, FaqDescription => $FAQDesc{Field1}." ".$FAQDesc{Field2}." ".$FAQDesc{Field3}." ".$FAQDesc{Field4}." ".$FAQDesc{Field5}." ".$FAQDesc{Field6} });
				}

			}

			
			# Last level of service. Check if are there linked FAQ articles or if we should redirect
            # to the create ticket screen
			if(!_HasParent($DataRef,$GetParam{KeyPrimary})){
                # Check if there are one or more FAQs attacheds as ServiceArticle with same language
                my $Links = $Kernel::OM->Get('Kernel::System::LinkObject')->LinkList(
                    Object => 'Service',
                    Object2 => 'FAQ',
                    Key    => $GetParam{ServiceID},
                    State  => 'Valid',
                    Type   => 'ServiceArticle',
                    UserID => 1,
                );

                my @FAQs;
                # if we find some articles
                if ($Links->{FAQ}){
                    my %LinkedFaqIDs = %{$Links->{FAQ}->{ServiceArticle}->{Source}};
                    my @FaqIDs = keys %LinkedFaqIDs;
                    my $FAQObject = $Kernel::OM->Get("Kernel::System::FAQ") if @FaqIDs;
                    
                    foreach my $FaqID (@FaqIDs){
                        my %FAQ = $FAQObject->FAQGet(
                            ItemID => $FaqID,
                            UserID	=> 1,
                            ItemFields => 1,
                        );
                        
                        next if($FAQ{Language} ne $ENV{UserLanguage});
                        next if($FAQ{Valid} ne 'valid');
                        
                        push @FAQs, \%FAQ;
                    }
                   
                    # If there is only one FAQ Attached, redirect user to it
                    if(scalar @FAQs == 1){
                        my $Redirect = $LayoutObject->{Baselink}
                        . 'Action=CustomerFAQZoom;ItemID='.$FAQs[0]->{ItemID}
                        . ';ServiceID='.$GetParam{ServiceID}
                        . ';KeyPrimary='.$GetParam{KeyPrimary};
                        return $LayoutObject->Redirect( OP => $Redirect );
                        
                    } elsif (scalar @FAQs > 1){

                        # If there are more FAQs attacheds, show the list
                        # Sort by Title
                        my @SortedFAQs = sort {$$a{"Title"} cmp $$b{"Title"} } @FAQs;

                        ############################# MASK FAQs
                        for my $FAQ(@SortedFAQs){
                            my %Datas;
                            $Datas{KeyPrimary} = $GetParam{ServiceID};
                            $Datas{LayoutServiceLink} = $LayoutObject->{Baselink}
                                . 'Action=CustomerFAQZoom;ItemID='.$FAQ->{ItemID}
                                . ';ServiceID='.$GetParam{ServiceID}
                                . ';KeyPrimary='.$GetParam{KeyPrimary};
                        
                            $Datas{LayoutServiceName} = $FAQ->{Title};
                            #$Datas{LayoutServiceID}	  = $ServiceID;
                            $Datas{LayoutServiceDescription} = $Kernel::OM->Get("Kernel::System::HTMLUtils")->ToAscii( String => $FAQ->{$Config->{ServiceArticleDescriptionField}});
                                
                            #my $ServiceTypeID = $ServicePreferences{TicketType} || '';

                            $Datas{LayoutTypeDescription} = 'FAQ Article';
                            $Datas{backColor} = $TypesColor{$Datas{LayoutTypeDescription}};
                            
                            ## Get CSS style
                            $LayoutObject->Block( Name => "LayoutServiceArticle", Data=> { %Datas});

                        }
                    }
                } else {
                    my $Redirect = $LayoutObject->{Baselink}
                    . 'Action=CustomerTicketMessage'
                    . ';ServiceID='.$GetParam{ServiceID};
                    return $LayoutObject->Redirect( OP => $Redirect );
                }

			}
			$GetParam{FirstLvl} = 0;
		} else {
			# No service selected, so check if there is a default first level configured
			if($Config->{DefaultServiceID}){
				$GetParam{ServiceID}  = $Config->{DefaultServiceID};
				$GetParam{KeyPrimary} = $ServiceObject->ServiceLookup(
											ServiceID => $Config->{DefaultServiceID},
										);
				$Self->{Subaction}= 'NextLevel';
				$GetParam{DefaultServiceID}=$Config->{DefaultServiceID};
				$LayoutObject->Block( Name => "FirstLvl");
			}
			$GetParam{FirstLvl} = 1;
		}
	
		my $Output .= $LayoutObject->CustomerHeader();
		$Output    .= $LayoutObject->CustomerNavigationBar();
		$Output    .= $Self->_MaskNew(
			%GetParam,
			DataRef => $DataRef,
			AllServices => \%Services,
		);
		$Output .= $LayoutObject->CustomerFooter();
		return $Output;

	}
}
sub _GetServices {
	my ( $Self, %Param ) = @_;
	# get service
	my %Service;
	%Service = $Kernel::OM->Get('Kernel::System::Service')->CustomerUserServiceMemberList(
		Result            => 'HASH',
		CustomerUserLogin => $Self->{UserID},
		UserID            => 1,
	);
	my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');
    my $ACL = $TicketObject->TicketAcl(
        %Param,
        Action         => $Self->{Action},
        CustomerUserID => $Self->{UserID},
        ReturnType    => 'Ticket',
        ReturnSubType => 'Service',
        Data          => \%Service,
    );
	if($ACL){
		my %Services = $TicketObject->TicketAclData();
		return \%Services;
	}
	return \%Service;

}

sub _GetServicesSP {
	my ( $Self, %Param ) = @_;
	# get service
	# COMPLEMENTO
	my $CustomerID = $Param{CustomerID}||$Kernel::OM->Get('Kernel::System::Web::Request')->GetParam( Param => 'CustomerID' );
	# EO COMPLEMENTO
$Kernel::OM->Get('Kernel::System::Log')->Log(
        Priority => 'error',
        Message  => "CHEGOU AQUI  sdsds",
    );
	if(!$CustomerID){
			my @CustomerIDs = $Kernel::OM->Get('Kernel::System::CustomerUser')->CustomerIDs(
					User => $Param{CustomerUserID},
			);
			$CustomerID = $CustomerIDs[0];
	}

	# get service
	my %Service;

	# get options for default services for unknown customers
	my $DefaultServiceUnknownCustomer
		= $Kernel::OM->Get('Kernel::Config')->Get('Ticket::Service::Default::UnknownCustomer');

	# get service list
	if ( $Param{CustomerUserID} || $DefaultServiceUnknownCustomer ) {
		%Service = $Kernel::OM->Get('Kernel::System::Ticket')->TicketServiceList(
			%Param,
			Action => 'CustomerTicketMessage',
			UserID => $Self->{UserID},
			# COMPLEMENTO
			CustomerID => $CustomerID,
			# EO COMPLEMENTO
		);
	}

	my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');
    my $ACL = $TicketObject->TicketAcl(
        %Param,
        Action         => $Self->{Action},
        CustomerUserID => $Self->{UserID},
        ReturnType    => 'Ticket',
        ReturnSubType => 'Service',
        Data          => \%Service,
    );
	if($ACL){
		my %Services = $TicketObject->TicketAclData();
		return \%Services;
	}

	return \%Service;

}

sub _MaskNew {
	my ( $Self, %Param ) = @_;

	my $ParamObject  = $Kernel::OM->Get('Kernel::System::Web::Request');
	my $ServiceObject = $Kernel::OM->Get("Kernel::System::Service");
	my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
	my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');
	my $BackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');
	my $Config  = $Self->{Config} = $Kernel::OM->Get('Kernel::Config')->Get("ServiceCatalog")||{};
	my $Services;

	if ( !$Param{KeyPrimary} ) {
		$Services = _GetParents($Param{DataRef});
		$LayoutObject->Block( Name => "FirstLvl");
	} else {
		$LayoutObject->Block( Name => "BreadcrumbStart");
		$Services = _GetChildren($Param{DataRef},$Param{KeyPrimary});
	}

	my $Needs=0;
	my $Categories=0;
	foreach my $dataKey ( @{$Services}){
		my $ServiceName = $dataKey->{Value};
		my $ServiceID = $dataKey->{Key};
		if(!$ServiceID or $ServiceID eq "-"){
			 $ServiceID = $ServiceObject->ServiceLookup(
		        Name => $ServiceName,
		    );
		}
		my @ServiceArray = split("::",$ServiceName);
		my $DynamicFieldConfig = $DynamicFieldObject->DynamicFieldGet(
			Name   => 'ServiceImage',             # ID or Name must be provided
		);
		my $Value = $BackendObject->ValueGet(
			DynamicFieldConfig => $DynamicFieldConfig,      # complete config of the DynamicField
			ObjectID           => $ServiceID,                # ID of the current object that the field
																# must be linked to, e. g. TicketID
		);
		my %DynamicFieldHTML;
		# get field HTML
		$DynamicFieldHTML{ $DynamicFieldConfig->{Name} } =
		$BackendObject->EditFieldRender(
			 ParamObject          => $ParamObject,
			 DynamicFieldConfig => $DynamicFieldConfig,
			 LayoutObject => $LayoutObject,
			 Value => $Value
		);
		# get the HTML strings form $Param
		my $newDynamicFieldHTML = $DynamicFieldHTML{ $DynamicFieldConfig->{Name} };
		my $Url = $newDynamicFieldHTML->{Field};
		my $Link =  _GetUrlHref($Url);
		$Link = "#" if(!$Link);
		my @Names =  split("::",$ServiceName);
		my $LayoutServiceName = $Names[-1];

		# Output Services categories and activities
		my %Datas;
		$Datas{KeyPrimary} = "$ServiceName";
		$Datas{LayoutServiceLink} = $Link;
		$Datas{LayoutServiceName} = "$LayoutServiceName";
		$Datas{LayoutServiceID}	  = $ServiceID;
		my %ServicePreferences = $ServiceObject->ServicePreferencesGet(
		   ServiceID => $ServiceID,
		   UserID    => 1,
		);

		#$Param{ServiceID} = $ServiceObject->ServiceLookup(
		#								Name => $Param{KeyPrimary},
		#							);

		$DynamicFieldConfig = $DynamicFieldObject->DynamicFieldGet(
			Name   => 'ShowAsCategory',             # ID or Name must be provided
		);
		my $ShowAsCategory = $BackendObject->ValueGet(
			DynamicFieldConfig => $DynamicFieldConfig,      # complete config of the DynamicField
			ObjectID           => $ServiceID,                # ID of the current object that the field
		) || '';
		$DynamicFieldConfig = $DynamicFieldObject->DynamicFieldGet(
			Name   => 'ServiceType',             # ID or Name must be provided
		);
		my $ServiceType = $BackendObject->ValueGet(
			DynamicFieldConfig => $DynamicFieldConfig,      # complete config of the DynamicField
			ObjectID           => $ServiceID,                # ID of the current object that the field
		) || '';


		$DynamicFieldConfig = $DynamicFieldObject->DynamicFieldGet(
			Name   => 'ForwardToUrl',             # ID or Name must be provided
		);
		my $ForwardToUrl = $BackendObject->ValueGet(
			DynamicFieldConfig => $DynamicFieldConfig,      # complete config of the DynamicField
			ObjectID           => $ServiceID,                # ID of the current object that the field
																# must be linked to, e. g. TicketID
		)||'';

		$DynamicFieldConfig = $DynamicFieldObject->DynamicFieldGet(
			Name   => 'UrlTarget',             # ID or Name must be provided
		);
		my $UrlTarget = $BackendObject->ValueGet(
			DynamicFieldConfig => $DynamicFieldConfig,      # complete config of the DynamicField
			ObjectID           => $ServiceID,                # ID of the current object that the field
																# must be linked to, e. g. TicketID
		)||'';

		$DynamicFieldConfig = $DynamicFieldObject->DynamicFieldGet(
			Name   => 'ServiceDescription',             # ID or Name must be provided
		);
		my $Value = $BackendObject->ValueGet(
			DynamicFieldConfig => $DynamicFieldConfig,      # complete config of the DynamicField
			ObjectID           => $ServiceID,                # ID of the current object that the field
																# must be linked to, e. g. TicketID
		)||'';
		$Datas{LayoutServiceDescription} =   $Kernel::OM->Get("Kernel::System::HTMLUtils")->ToHTML( String => $Value);
		$Datas{ShowAsCategory} = $ShowAsCategory || '0';
		$Datas{ServiceType} = $ServiceType || '0';

		if(!_HasChildren($Param{AllServices},$ServiceName) && $Datas{ShowAsCategory} eq '0'){

			## Needs (last service level)
			$Needs++;
		
			my $ServiceTypeID = $ServicePreferences{TicketType} || '';
			my %TypesColor = %{$Config->{TypeColors}};
			my %TypesLabel = %{$Config->{TypeLabels}};

			$Datas{LayoutTypeDescription} = $TypesLabel{$ServiceTypeID} || '';

			$Datas{backColor} = $TypesColor{$Datas{LayoutTypeDescription}};
			
			# Get CSS style
			if($ForwardToUrl eq ''){
				$LayoutObject->Block( Name => "LayoutActivity", Data=> { %Datas});
				$Datas{Layout} = "LayoutActivity";
			}
			else{
				$Datas{Url}=$ForwardToUrl;
				$Datas{UrlTarget}=$UrlTarget;
				$LayoutObject->Block( Name => "LayoutActivityUrl", Data=> { %Datas});
				$Datas{Layout} = "LayoutActivityUrl";
			}

		}else{
			$Categories++;	

			## Categories and Subcategories
			$Datas{Color}=$ServicePreferences{ServiceImageBackground};
			if($ForwardToUrl eq ''){
				$LayoutObject->Block( Name => "LayoutCategory", Data=> { %Datas});
				$Datas{Layout} = "LayoutCategory";
			}
			else{
				$Datas{Url}=$ForwardToUrl;
				$Datas{UrlTarget}=$UrlTarget;
				$LayoutObject->Block( Name => "LayoutCategoryUrl", Data=> { %Datas});
				$Datas{Layout} = "LayoutCategoryUrl";
			}

		}
	}

	####MOUNT FOOTER######
	my @ServicesFooter = $Kernel::OM->Get("Kernel::System::ServiceDF")->ServiceListFooter(UserID=>1);

	#$Kernel::OM->Get('Kernel::System::Log')->Log(
    #    Priority => 'error',
    #    Message  => "CHEGOU AQUI  ".Dumper(@ServicesFooter),
    #);

	foreach my $dataKey ( @ServicesFooter){
		my $ServiceName = $dataKey->{Name};
		my $ServiceID = $dataKey->{ServiceID};
		if(!$ServiceID or $ServiceID eq "-"){
			 $ServiceID = $ServiceObject->ServiceLookup(
		        Name => $ServiceName,
		    );
		}
		my @ServiceArray = split("::",$ServiceName);
		my $DynamicFieldConfig = $DynamicFieldObject->DynamicFieldGet(
			Name   => 'ServiceImage',             # ID or Name must be provided
		);
		my $Value = $BackendObject->ValueGet(
			DynamicFieldConfig => $DynamicFieldConfig,      # complete config of the DynamicField
			ObjectID           => $ServiceID,                # ID of the current object that the field
																# must be linked to, e. g. TicketID
		);
		my %DynamicFieldHTML;
		# get field HTML
		$DynamicFieldHTML{ $DynamicFieldConfig->{Name} } =
		$BackendObject->EditFieldRender(
			 ParamObject          => $ParamObject,
			 DynamicFieldConfig => $DynamicFieldConfig,
			 LayoutObject => $LayoutObject,
			 Value => $Value
		);
		# get the HTML strings form $Param
		my $newDynamicFieldHTML = $DynamicFieldHTML{ $DynamicFieldConfig->{Name} };
		my $Url = $newDynamicFieldHTML->{Field};
		my $Link =  _GetUrlHref($Url);
		$Link = "#" if(!$Link);
		my @Names =  split("::",$ServiceName);
		my $LayoutServiceName = $Names[-1];

		# Output Services categories and activities
		my %Datas;
		$Datas{KeyPrimary} = "$ServiceName";
		$Datas{LayoutServiceLink} = $Link;
		$Datas{LayoutServiceName} = "$LayoutServiceName";
		$Datas{LayoutServiceID}	  = $ServiceID;
		my %ServicePreferences = $ServiceObject->ServicePreferencesGet(
		   ServiceID => $ServiceID,
		   UserID    => 1,
		);

		#$Param{ServiceID} = $ServiceObject->ServiceLookup(
		#								Name => $Param{KeyPrimary},
		#							);

		$DynamicFieldConfig = $DynamicFieldObject->DynamicFieldGet(
			Name   => 'ShowAsCategory',             # ID or Name must be provided
		);
		my $ShowAsCategory = $BackendObject->ValueGet(
			DynamicFieldConfig => $DynamicFieldConfig,      # complete config of the DynamicField
			ObjectID           => $ServiceID,                # ID of the current object that the field
		) || '';
		$DynamicFieldConfig = $DynamicFieldObject->DynamicFieldGet(
			Name   => 'ServiceType',             # ID or Name must be provided
		);
		my $ServiceType = $BackendObject->ValueGet(
			DynamicFieldConfig => $DynamicFieldConfig,      # complete config of the DynamicField
			ObjectID           => $ServiceID,                # ID of the current object that the field
		) || '';


		$DynamicFieldConfig = $DynamicFieldObject->DynamicFieldGet(
			Name   => 'ForwardToUrl',             # ID or Name must be provided
		);
		my $ForwardToUrl = $BackendObject->ValueGet(
			DynamicFieldConfig => $DynamicFieldConfig,      # complete config of the DynamicField
			ObjectID           => $ServiceID,                # ID of the current object that the field
																# must be linked to, e. g. TicketID
		)||'';

		$DynamicFieldConfig = $DynamicFieldObject->DynamicFieldGet(
			Name   => 'UrlTarget',             # ID or Name must be provided
		);
		my $UrlTarget = $BackendObject->ValueGet(
			DynamicFieldConfig => $DynamicFieldConfig,      # complete config of the DynamicField
			ObjectID           => $ServiceID,                # ID of the current object that the field
																# must be linked to, e. g. TicketID
		)||'';

		$DynamicFieldConfig = $DynamicFieldObject->DynamicFieldGet(
			Name   => 'ServiceDescription',             # ID or Name must be provided
		);
		my $Value = $BackendObject->ValueGet(
			DynamicFieldConfig => $DynamicFieldConfig,      # complete config of the DynamicField
			ObjectID           => $ServiceID,                # ID of the current object that the field
																# must be linked to, e. g. TicketID
		)||'';
		$Datas{LayoutServiceDescription} =   $Kernel::OM->Get("Kernel::System::HTMLUtils")->ToHTML( String => $Value);
		$Datas{ShowAsCategory} = $ShowAsCategory || '0';
		$Datas{ServiceType} = $ServiceType || '0';

		if(!_HasChildren($Param{AllServices},$ServiceName) && $Datas{ShowAsCategory} eq '0'){
		
			my $ServiceTypeID = $ServicePreferences{TicketType} || '';
			my %TypesColor = %{$Config->{TypeColors}};
			my %TypesLabel = %{$Config->{TypeLabels}};

			$Datas{LayoutTypeDescription} = $TypesLabel{$ServiceTypeID} || '';

			$Datas{backColor} = $TypesColor{$Datas{LayoutTypeDescription}};
			
			# Get CSS style
			if($ForwardToUrl eq ''){
				$Datas{Layout} = "LayoutActivity";
			}
			else{
				$Datas{Url}=$ForwardToUrl;
				$Datas{UrlTarget}=$UrlTarget;
				$Datas{Layout} = "LayoutActivityUrl";
			}

		}else{

			## Categories and Subcategories
			$Datas{Color}=$ServicePreferences{ServiceImageBackground};
			if($ForwardToUrl eq ''){
				$Datas{Layout} = "LayoutCategory";
			}
			else{
				$Datas{Url}=$ForwardToUrl;
				$Datas{UrlTarget}=$UrlTarget;
				$Datas{Layout} = "LayoutCategoryUrl";
			}

		}
		if ($Param{FirstLvl} == 1) {
			$LayoutObject->Block( Name => "ServiceFooter", Data=> { %Datas});
	                $Param{ServiceFooter} = 1;
		}
	}
	####MOUNT FOOTER######
	
	if($Needs>0){
		$LayoutObject->Block( Name => "NeedMessage");
	}

	if($Needs>0 && $Categories>0){
		$LayoutObject->Block( Name => "MoreServices");
	}

	######## Bread Crumbs #####

	my @Breads = _CreateBreadcrumb($Param{KeyPrimary});
	my $FullPrevService;
	foreach my $crumbs(@Breads){
		if($crumbs eq $Breads[-1]){

			# Get the service description
			my $DynamicFieldConfig = $DynamicFieldObject->DynamicFieldGet( Name => 'ServiceDescription' );
			my $CategoryDescription = $BackendObject->ValueGet(
				DynamicFieldConfig => $DynamicFieldConfig,
				ObjectID           => $Param{ServiceID},
			) ||'';

			# Category title
			$LayoutObject->Block( Name => "CategorySearch",  Data=> {}) if($ParamObject->GetParam(Param => 'Subaction'));
			$LayoutObject->Block( Name => "CategoryTitle", Data=> { CategoryTitle => $crumbs, CategoryDescription => $Kernel::OM->Get("Kernel::System::HTMLUtils")->ToHTML( String => $CategoryDescription) });
		} else {
			# navigation
			if(!defined( $FullPrevService)){
				$FullPrevService = $crumbs;  
			}else{
				$FullPrevService .="::".$crumbs;
			}
			my $links = $LayoutObject->{Baselink}
		        . 'Action=CustomerServiceCatalog'
				. ';KeyPrimary='.$FullPrevService;
			$LayoutObject->Block( Name => "BreadcrumbServices", Data=> { BreadcrumbLink => $links, BreadcrumbTitle => $crumbs });
		}

	}
    
    # Block sidebar widgets
	my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my %SideBarWidgets       = %{ $ConfigObject->Get('LigeroServiceCatalog::SidebarWidget') ||{} };
	foreach my $SideBar(sort keys %SideBarWidgets){
		my $WidgetsGroup = $SideBarWidgets{$SideBar};

		next if(!$WidgetsGroup);
		next if( ref $WidgetsGroup ne 'HASH');

		my $Module = $WidgetsGroup->{Module};
        if ( !$Kernel::OM->Get('Kernel::System::Main')->Require($Module) ) {
            return $LayoutObject->FatalError();
        }
		my $Object = $Module->new();

		my $WidgetContent = $Object->Run(
			 GetParam => \%Param,
			 ConfigItem => $WidgetsGroup,
			 UserID => $Self->{UserID},
			);

			$LayoutObject->Block( Name => "SidebarWidget", Data=> { WidgetContent => $WidgetContent }) if $WidgetContent;
 		
	}	
    
	# Get CSS config
	my $AgentCss = " .Category:hover {". $Config->{CategoryCssOnMousehover} ."}";
	$LayoutObject->Block( Name => "LayoutStyleCategoryShadow",  Data=> { LayoutClassStyleCategory => $AgentCss });
	my $Link =  'Subaction=' . $LayoutObject->Ascii2Html( Text => $Self->{Subaction} );
	$Link .= ";KeyPrimary=". $Param{KeyPrimary} if($Param{KeyPrimary} );
	 my $SessionObject = $Kernel::OM->Get('Kernel::System::AuthSession');
		
       $SessionObject->UpdateSessionID(
                SessionID => $Self->{SessionID},
                Key       => "LastScreenOverview",
                Value     => "Action=CustomerServiceCatalog;".$Link,
            );
	

    ### GENERATE OUTPUT
    return $LayoutObject->Output(
        TemplateFile => 'CustomerServiceCatalog',
        Data         => \%Param,
    );
}

sub _GetUrlHref{

	my $String = shift;
	my $Link;
	if($String){
		if($String =~ /<a[^>]*?href=\'([^>]*?)\'[^>]*?>\s*([\w\W]*?)\s*<\/a>/g){
			$Link = $1;
		}
		return $Link;	
	}
	return "";
}
sub _HasParent{ 
	my $Para = shift;
	my $AllServices = $Para;
	my $Name = ""|| shift;
	my  $Regex;
	$Regex="^".quotemeta($Name)."::";
	my @matching_items = grep {	  $_->{Value} =~ /$Regex/} @{$AllServices};
	if(scalar @matching_items){
		return 1;	
	}else{
		return 0;
	}

}
sub _GetParents{ 
	my $Para = shift;
	my $AllServices = $Para;
	my $Name = ""|| shift;
	@{$AllServices} = grep { $_->{Value} =~ /^(?!.*::).*$/} @{$AllServices};

	return $AllServices;	
}
sub _HasChildren{ 
	my $Para = shift;
	my $AllServices = $Para;
	my $Name = ""|| shift;
	my $Regex="^".quotemeta($Name)."::";

	my @matching_items = grep {	  $AllServices->{$_} =~ /$Regex/} keys %{$AllServices};

	if(scalar @matching_items){
		return 1;	
	}else{
		return 0;
	}

}
sub _GetChildren{ 
	my $Para = shift;
	my $AllServices = $Para;
	my $Name = ""|| shift;
		
	my $Regex = "^".quotemeta($Name)."::"; 
	@{$AllServices} = grep { $_->{Value} =~ /^$Regex+(?!.*::).*$/} @{$AllServices};

	return $AllServices;	

}
sub _CreateBreadcrumb{
	my $ServiceName = shift||'';
	my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');  	
	my @breadcrumbs;
	my @TempName = split("::",$ServiceName);
	my $Redirect;
	return @TempName;	
}
sub _CountTruncate{
	my ($TruncateSize ,$StringDesc)   = @_;
	
	my $TruncateString = substr($StringDesc,0,$TruncateSize);
	my $c1 = () = $TruncateString =~ /<mark/g;
	my $c2 = () = $TruncateString =~ /<\/mark>/g;
	if($c1 ne $c2){
		 $TruncateSize = $TruncateSize + 10;
		_CountTruncate($TruncateSize,$StringDesc);
	}
	return $TruncateSize;
	
	
	
}
1;
