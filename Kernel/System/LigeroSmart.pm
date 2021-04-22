# --
# Copyright (C) 2010-2017 Complemento - Liberdade e Tecnologia - http://www.complemento.net.br
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::LigeroSmart;

use Try::Tiny;
use strict;
use warnings;
use Data::Dumper;

use Encode;
use MIME::Base64;
use Kernel::System::VariableCheck qw(IsArrayRefWithData IsHashRefWithData IsStringWithData);

use JSON;		

# Ligero Complemento
use Search::Elasticsearch;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::SysConfig',
    'Kernel::System::Cache',
    'Kernel::System::DB',
    'Kernel::System::Log',
    'Kernel::System::Valid',
    'Kernel::Output::HTML::Layout',
    'Kernel::System::JSON',
);

=head1 NAME

Kernel::System::LigeroSmart - LigeroSmart lib

=head1 SYNOPSIS

LigeroSmart functions

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create an object

    use Kernel::System::ObjectManager;
    local $Kernel::OM = Kernel::System::ObjectManager->new();
    my $LigeroSmartObject = $Kernel::OM->Get('Kernel::System::LigeroSmart');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    $Self->{CacheType} = 'LigeroSmart';
    $Self->{CacheTTL}  = 60 * 60 * 24 * 20;
    
    $Self->{Config}    = $Kernel::OM->Get('Kernel::Config')->Get('LigeroSmart');

    return $Self;
}




=item Search

Return a hash containing all informations returned by Ligero Smart Server 

    my @Results = $LigeroSmartObject->Search(
        Indexes => 'publicfaq,publicblog', # Optional
        Types => 'posts,pages',          # Optional
        Data => @$%   # Encoded perl data structure that carries json query structure
    );

Returns:

{
   "took": 2,
   "timed_out": false,
   "_shards": {
      "total": 15,
      "successful": 15,
      "failed": 0
   },
   "hits": {
      "total": 1,
      "max_score": 2.8078485,
      "hits": [
         {
            "_index": "sitesmartfit",
            "_type": "sitesmartfit",
            "_id": "AVPuLJGwDa-I-9YdvgAN",
            "_score": 2.8078485,
            "_source": {
               "fieldX": "Complemento is Beatiful",
               "fieldy": "my body bla bla bla"
            }
         }
      ]
   }
}
    
Usage Example:
        my %SearchResultsHash = $Kernel::OM->Get('Kernel::System::LigeroSmart')->Search(
            Indexes => $Indexes,
            Types   => $Types,
            Data    => \%Search,
        );
        
        my @Results = @{ $SearchResultsHash{hits}->{hits} };
        
        for my $Result (@Results){
            $LayoutObject->Block(
                Name => 'Result',
                Data => {
                    %{$Result->{"_source"}},
                },
            );
        }


=cut

sub Search {
    my ( $Self, %Param ) = @_;

    if (!$Self->{Config}->{Nodes}){
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "You must specify at least one node"
        );
        return;
    }

    my $Indexes = $Param{Indexes} || '';
    my $Types   = $Param{Types} || '';

    # Connect
    my @Nodes = @{$Self->{Config}->{Nodes}};
    
    my $e = Search::Elasticsearch->new(
        nodes => @Nodes,
        # (trace_to => ['File','/opt/otrs/var/tmp/ligerosearch.log'])
    );    
    
    my @SearchResults;
    
    try {
        @SearchResults = $e->search(
            'index' => $Types.'_'.$Indexes,
            'type'  => 'doc',
            'body'  => {
                %{$Param{Data}}
            }
        );
    } catch {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "error"
        );
    
    }

    
    my %SearchResultsHash;
    
    if(@SearchResults){
        %SearchResultsHash = %{ $SearchResults[0] };    
    }

    return %SearchResultsHash;
}

sub SearchTemplate {
    my ( $Self, %Param ) = @_;

    if (!$Self->{Config}->{Nodes}){
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "You must specify at least one node"
        );
        return;
    }

    my $Indexes = $Param{Indexes} || '';
    my $Types   = $Param{Types} || '';

    # Connect
    my @Nodes = @{$Self->{Config}->{Nodes}};
    
    my $e = Search::Elasticsearch->new(
        nodes => @Nodes,
        # (trace_to => ['File','/opt/otrs/var/tmp/ligerosearch.log'])
    );
    
    my @SearchResults;
    
    try {
        @SearchResults = $e->search_template(
            'index' => $Types.'_'.$Indexes,
            'type'  => 'doc',
            'body'  => {
                %{$Param{Data}}
            }
        );
    } catch {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "error"
        );
    
    }

    
    my %SearchResultsHash;
    
    if(@SearchResults){
        %SearchResultsHash = %{ $SearchResults[0] };    
    }

    return %SearchResultsHash;
}


=item DeleteByQuery

Return a hash containing all informations returned by Ligero Smart Server 

    my @Results = $LigeroSmartObject->DeleteByQuery(
        Indexes => 'publicfaq,publicblog', # Optional
        Types => 'posts,pages',          # Optional
        Data => @$%   # Encoded perl data structure that carries json query structure
    );

Returns:

{
   "took": 2,
   "timed_out": false,
   "total": 0,
   "deleted": 0,
   "batches": 0,
   "version_conflicts": 0,
   "noops": 0,
   "retries": {
      "bulk": 0,
      "search": 0
   },
   "throttled_millis": 0,
   "requests_per_second": -1,
   "throttled_until_millis": 0,
   "failures": []
}
    
Usage Example:
        my %DeletedInformation = $Kernel::OM->Get('Kernel::System::LigeroSmart')->DeleteByQuery(
            Indexes => $Indexes,
            Types   => $Types,
            Data    => \%Search,
        );
        

=cut

sub DeleteByQuery {
    my ( $Self, %Param ) = @_;

    if (!$Self->{Config}->{Nodes}){
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "You must specify at least one node"
        );
        return;
    }

    my $Indexes = $Param{Indexes} || '';
    my $Types   = $Param{Types} || '';

    # Connect
    my @Nodes = @{$Self->{Config}->{Nodes}};
    
    my $e = Search::Elasticsearch->new(
        nodes => @Nodes,
        # (trace_to => ['File','/opt/otrs/var/tmp/ligerosearch.log'])
    );    
    
    my $DeletedInformation;
    
    $DeletedInformation = $e->delete_by_query(
            'index' => $Types.'_'.$Indexes,
            'type'  => 'doc',
            'body'  => {
                %{$Param{Body}}
            }
        );

    return $DeletedInformation;
}



=item Index

Index documents on Elasticsearch

    my @Results = $LigeroSmartObject->Index(
        Index   => 'ligero', # Optional
        Type    => 'servicecatalogsearch',          # Optional
        Id      => 'service-xxx' # ID for this object on elasticsearch
        Body    => @$%           # Encoded perl data structure reference which will be used as document body
    );

Returns:

@TODO: Check the return object
    
Usage Example:



=cut

sub Index {
    my ( $Self, %Param ) = @_;

    if (!$Self->{Config}->{Nodes}){
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "You must specify at least one node"
        );
        return;
    }

    for my $Key (qw(Index Type Id Body)) {
        if ( !$Param{$Key} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Key!",
            );
            return;
        }
    }

    my $Index = $Param{Index};
    my $Type  = $Param{Type};
    my $Id    = $Param{Id};
    my $Body  = $Param{Body};

    my %AdditionalOptions;
    if (defined $Param{Pipeline}) 
    {
        $AdditionalOptions{pipeline} = $Param{Pipeline};
    }
    

    # Connect
    my @Nodes = @{$Self->{Config}->{Nodes}};
    
    my $e = Search::Elasticsearch->new(
        nodes => @Nodes,
        # (trace_to => ['File','/opt/otrs/var/tmp/ligerosearch.log'])
    );    
    
    my $Result;
    
#    try {
    $Result = $e->index(
        'index'    => $Type.'_'.$Index,
        'type'     => 'doc',
        'id'       => $Id,
        'body'     => {
            %{$Body}
        },
        %AdditionalOptions
    );

}

=item IndexCreate

Create a new Index on Elasticsearch

    my $Result  = $LigeroSmartObject->IndexCreate(
        Index   => 'ligero',   # Required
        Language => 'pt_BR', # Required
        Body    => @$%       # Required Encoded perl data structure reference which will be used as document body (settings, analyser, mapping)
    );

Returns:

@TODO: Check the return object
    
Usage Example:



=cut

sub IndexCreate {
    my ( $Self, %Param ) = @_;

    if (!$Self->{Config}->{Nodes}){
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "You must specify at least one node"
        );
        return;
    }

    for my $Key (qw(Index Language)) {
        if ( !$Param{$Key} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Key!",
            );
            return;
        }
    }

    my $IndexPrefix	= $Param{Index};
    my $Language    = $Param{Language};
	
    # Connect
    my @Nodes = @{$Self->{Config}->{Nodes}};
    
    my $e = Search::Elasticsearch->new(
        nodes => @Nodes,
        # (trace_to => ['File','/opt/otrs/var/tmp/ligerosearch.log'])
    );    
    
	# Check if theres is an index version for this prefix and language
	# Extract version if it exists
	my $CurrentVersion = $Self->CheckCurrentIndexVersion(
		Index => $IndexPrefix,
		Language => $Language
	);

	# Increase one to the version
	my $NewVersion = $CurrentVersion+1;

	my $CurrentIndex 	= lc($IndexPrefix . "_" . $Language. "_v" . $CurrentVersion);
	my $NewIndex    	= lc($IndexPrefix . "_" . $Language. "_v" . $NewVersion);
	my $SearchAlias = lc($IndexPrefix . "_" . $Language. "_search");
	my $IndexAlias  = lc($IndexPrefix . "_" . $Language. "_index");

	# create json object - We cannot use LIGERO Json object directly because it sanitize true and false and we get errors from elasticsearch
	my $JSONObject = JSON->new();
	$JSONObject->allow_nonref(1);

	my %LanguagesMappings = %{$Kernel::OM->Get('Kernel::Config')->Get('LigeroSmart::Mappings')};
	# decode JSON encoded to perl structure
	my $Body;
	# use eval here, as JSON::XS->decode() dies when providing a malformed JSON string
	if ( !eval { $Body = $JSONObject->decode( $LanguagesMappings{$Language} ) } ) {
		$Kernel::OM->Get('Kernel::System::Log')->Log(
			Priority => 'error',
			Message  => 'Decoding the JSON string failed: ' . $@,
		);
		return;
	}

	my $Result;
	my $Error;
	try {
		$Result = $e->indices->create(
			'index'    => $NewIndex,
			'body'     => {
				%{$Body}
			},
		);	

		my @Actions;
		if ($CurrentVersion){
			push @Actions, {
					remove => {
					   index => $CurrentIndex,
					   alias => $IndexAlias
					}
				};
		}

		push @Actions, {
					add => {
						index => $NewIndex,
						alias => $IndexAlias 
					}
		};
		push @Actions, {
					add => {
						index => $NewIndex,
						alias => $SearchAlias 
					}
		};


		my $AliasResponseIndex = $e->indices->update_aliases(
			  body=> {
				actions=> \@Actions
			  }
		);

	} catch {
		$Error = $_;
		$Kernel::OM->Get('Kernel::System::Log')->Log( Priority => 'error', Message => "$_" );
		return $_;
	};

	if($Result->{acknowledged}){
		return $NewIndex;
	} else {
		return 0;
	}
	
}


=item IndexDelete

Delete Elasticsearch Index

    my $Result  = $LigeroSmartObject->IndexDelete(
        Index   => 'companyname_langcode_vX',   # Required
    );

Returns:
	1 or 0
    


=cut

sub IndexDelete {
    my ( $Self, %Param ) = @_;

    if (!$Self->{Config}->{Nodes}){
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "You must specify at least one node"
        );
        return;
    }

    for my $Key (qw(Index)) {
        if ( !$Param{$Key} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Key!",
            );
            return;
        }
    }
	
    # Connect
    my @Nodes = @{$Self->{Config}->{Nodes}};
    
    my $e = Search::Elasticsearch->new(
        nodes => @Nodes,
        # (trace_to => ['File','/opt/otrs/var/tmp/ligerosearch.log'])
    );    
    
	my $Result;
	my $Error;
	try {
		$Result = $e->indices->delete(
			'index'    => $Param{Index},

		);	
	} catch {
		$Error = $_;
		$Kernel::OM->Get('Kernel::System::Log')->Log( Priority => 'error', Message => "$_" );
		return $_;
	};

	return $Result;

}

=item IngestPipelineInstall

Configure Ingest Attachment plugin. If it's already exists, just return true

    my $Result  = $LigeroSmartObject->IngestPipelineInstall();

Returns:

	0 - error
	1 - installed
	2 - already exists
    

=cut

sub IngestPipelineInstall {
    my ( $Self, %Param ) = @_;

    if (!$Self->{Config}->{Nodes}){
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "You must specify at least one node"
        );
        return;
    }
	
    # Connect
    my @Nodes = @{$Self->{Config}->{Nodes}};
    
    my $e = Search::Elasticsearch->new(
        nodes => @Nodes,
        # (trace_to => ['File','/opt/otrs/var/tmp/ligerosearch.log'])
    );    
    
	# create json object - We cannot use LIGERO Json object directly because it sanitize true and false and we get errors from elasticsearch
	my $JSONObject = JSON->new();
	$JSONObject->allow_nonref(1);

	my %IngestPipelines = %{$Kernel::OM->Get('Kernel::Config')->Get('LigeroSmart::IngestPipeline')};
	# decode JSON encoded to perl structure
	my $Body;

	my $Return;
	my $Result;
	my $Error;
	
	for my $pipeline (keys %IngestPipelines){
		my $Exists = 1;
		
		try {
			$e->ingest->get_pipeline(
				'id'    => $pipeline,
			);
			$Return = 2;
		} catch {
			$Exists = 0;
		};
		
		if (!$Exists){
			try {
				my $Body;
				# use eval here, as JSON::XS->decode() dies when providing a malformed JSON string
				if ( !eval { $Body = $JSONObject->decode( $IngestPipelines{$pipeline} ) } ) {
					$Kernel::OM->Get('Kernel::System::Log')->Log(
						Priority => 'error',
						Message  => 'Decoding the JSON string failed: ' . $@,
					);
					return 0;
				}

				$Result = $e->ingest->put_pipeline(
					'id'    => $pipeline,
					'body'     => {
						%{$Body}
					},
				);	
				$Return = 1;
			} catch {
				$Error = $_;
				$Kernel::OM->Get('Kernel::System::Log')->Log( Priority => 'error', Message => "$_" );
				return 0;
			};
			
		}
		
	}

	return $Return;

}



=item Reindex

Create a new Index on Elasticsearch for a specific language, copy all content of old Index,
recreate links and delete old Index

    my $Result  = $LigeroSmartObject->Reindex(
        Index   => 'ligero',   # Required
        Language => 'pt_BR', # Required
        RequestsPerSecond => 50
    );

Returns:
	{
		CurrentIndex, - The name of the old index
		NewIndex, - The name of new index created
		TaskID   - A string containing task id of reindex process on Elasticsearch
	}

=cut

sub Reindex {
    my ( $Self, %Param ) = @_;

	my $RequestsPerSecond = $Param{RequestsPerSecond} || 50;

    if (!$Self->{Config}->{Nodes}){
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "You must specify at least one node"
        );
        return;
    }

    for my $Key (qw(Index Language)) {
        if ( !$Param{$Key} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Key!",
            );
            return;
        }
    }

    my $IndexPrefix	= $Param{Index};
    my $Language    = $Param{Language};

	# Check if theres is an index version for this prefix and language
	# Extract version if it exists
	my $CurrentVersion = $Self->CheckCurrentIndexVersion(
		Index => $IndexPrefix,
		Language => $Language
	);
	
	my $NewIndex = $Self->IndexCreate(
		Index	 => $IndexPrefix,
		Language => $Language,
	);
	
	my $CurrentIndex 	= lc($IndexPrefix . "_" . $Language. "_v" . $CurrentVersion);
	
    # Connect
    my @Nodes = @{$Self->{Config}->{Nodes}};
    my $e = Search::Elasticsearch->new(
        nodes => @Nodes,
        # (trace_to => ['File','/opt/otrs/var/tmp/ligerosearch.log'])
    );

	my $Task;
	my $Error;
	try {
		$Task = $e->reindex(
			body => 
				{
				  source => {
					index=> $CurrentIndex
				  },
				  'dest'   => {
					index => $NewIndex
				  }
				},
			wait_for_completion => JSON::false,
			requests_per_second => $RequestsPerSecond
		);
	} catch {
		$Error = $_;
		$Kernel::OM->Get('Kernel::System::Log')->Log( Priority => 'error', Message => "$_" );
		return $_;
	};

	my %Return;
	
	$Return{CurrentIndex} = $CurrentIndex;
	$Return{NewIndex} = $NewIndex;

	if($Task->{task}){
		$Return{TaskID} = $Task->{task};
		return %Return;
	} else {
		return "Error";
	}
	
}

=item CheckReindexStatus

Check Reindex Task Status
    
    my %Result  = $LigeroSmartObject->CheckReindexStatus(
        EsTaskID   => 'Elasticsearch TASK ID',   # Required
    );

Returns:

	%Result = {
		Completed => 1 or 0,
		Progress  => 0 to 100,
		Created   => Number of created documents on new index,
	}


=cut

sub CheckReindexStatus {
    my ( $Self, %Param ) = @_;

    if (!$Self->{Config}->{Nodes}){
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "You must specify at least one node"
        );
        return;
    }

    for my $Key (qw(EsTaskID)) {
        if ( !$Param{$Key} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Key!",
            );
            return;
        }
    }

    my $EsTaskID	= $Param{EsTaskID};
	
    my @Nodes = @{$Self->{Config}->{Nodes}};
    my $e = Search::Elasticsearch->new(
        nodes => @Nodes,
        # (trace_to => ['File','/opt/otrs/var/tmp/ligerosearch.log'])
    );

	my %Result;
	my $Task;
	my $Error;
	try {
		$Task = $e->tasks->get(
			task_id => $EsTaskID
		);
		$Result{Completed} = $Task->{completed};
		if($Task->{task}->{status}->{total} == 0  && !$Task->{completed}){
			$Result{Progress} = 0;
		} elsif ($Task->{task}->{status}->{total} == 0 && $Task->{completed}){
			$Result{Progress} = 100;
		} elsif($Task->{task}->{status}->{created} == 0){
			$Result{Progress} = 0;
		} else {
			$Result{Progress}  = int( $Task->{task}->{status}->{created} / ( $Task->{task}->{status}->{total} / 100 ) );
		}
		$Result{Created}   = $Task->{task}->{status}->{created};
		
	} catch {
		$Error = $_;
		$Kernel::OM->Get('Kernel::System::Log')->Log( Priority => 'error', Message => "$_" );
		return $_;
	};

	#if($Task->{task}){
	return %Result;
	#} else {
		#return "Error";
	#}
	
}


=item CheckCurrentIndexVersion()

Check which is current Index Version for a Language

    my $CurrentVersion = $LigeroElasticsearch->CheckCurrentIndexVersion(
        Index    => companyindex, # required (Company Prefix)
        Language => 'pt_BR' $ required
    );

    returns a Number or 0 if not created yet.

=cut
sub CheckCurrentIndexVersion {
    my ( $Self, %Param ) = @_;

	
    if (!$Self->{Config}->{Nodes}){
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "You must specify at least one node"
        );
        return;
    }

    for my $Key (qw(Index Language)) {
        if ( !$Param{$Key} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Key!",
            );
            return;
        }
    }

    my $IndexPrefix	= $Param{Index};
    my $Language    = $Param{Language};

	my $Index       = $IndexPrefix . "_" . $Language."_index";
	
    # Connect
    my @Nodes = @{$Self->{Config}->{Nodes}};
    
    my $e = Search::Elasticsearch->new(
        nodes => @Nodes,
        # (trace_to => ['File','/opt/otrs/var/tmp/ligerosearch.log'])
    );    

	my $Result;
	
	my $Error=0;
	try {
		$Result = $e->indices->get_alias(
			'index'    => lc($Index),
		);
	} catch {
		# Probably index was never create
		$Error=1;
	};
	
	my $Version=0;
	if(!$Error){
		my @Indexes = keys %{$Result};
		my @Versions;

		my $IndexVersion;
		for (@Indexes){
			($IndexVersion) = $_ =~ /(\d+)/;
			push @Versions,$IndexVersion;
		}
		@Versions = reverse sort { $a <=> $b } @Versions;

		if ($IndexVersion){
			$Version = $Versions[0];
		}
	}
	
	return $Version;
}

=item FullTicketGet()

Get whole ticket, articles and it's attachments

    my %Ticket = $LigeroElasticsearch->FullTicketGet(
        TicketID    => 12323213, # required
        Attachments => 0 or 1 (default 1)
    );

    returns
    (
        HASH containing whole Ticket structure
    )

=cut

sub FullTicketGet {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(TicketID)) {
        if ( !defined $Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "FullTicketGet: $Needed is Required!"
            );
            return \{}; # return empty hash
        }
    }

    my $Attachments = $Param{Attachments} || 'Yes';
    
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

    #get ticket
    my %Ticket = $TicketObject->TicketGet(
        TicketID      => $Param{TicketID},
        DynamicFields => 1,
        Extended      => 1,
        UserID        => 1,
    );

    #encode ticket stuff and remove undefined attributes
    for my $key (keys %Ticket){
     #   $Ticket{$key}=encode("utf-8", $Ticket{$key});
        delete $Ticket{$key} unless defined($Ticket{$key});
    }

    # get all articles
    my @ArticleBoxRaw = $Kernel::OM->Get('Kernel::System::Ticket::Article')->ArticleList(
        TicketID          => $Param{TicketID}
    );

    use Data::Dumper;
  
    if (@ArticleBoxRaw) {
        my @ArticleBox;
        for my $ArticleRawI (@ArticleBoxRaw) {
            my %Article;
            my @DynamicFields;

            my %ArticleRaw = $Kernel::OM->Get('Kernel::System::Ticket::Article')->BackendForArticle( %{$ArticleRawI} )->ArticleGet( %{$ArticleRawI} );
            
            # encode everything and remove undefined stuff
            ATTRIBUTE:
            for my $Attribute ( sort keys %ArticleRaw ) {   
                $Article{$Attribute} = encode("utf-8", $ArticleRaw{$Attribute});
                delete $Article{$Attribute} if defined($Ticket{$Attribute});
                delete $Article{$Attribute} unless defined($Article{$Attribute});
            }
            
            if($Attachments eq 'Yes'){
                $Self->{RichText} = $Kernel::OM->Get('Kernel::Config')->Get('Ticket::Frontend::ZoomRichTextForce')
                || $Kernel::OM->Get('Kernel::Output::HTML::Layout')->{BrowserRichText}
                || 0;
                # get attachment index (without attachments)
                my %AtmIndex = $Kernel::OM->Get('Kernel::System::Ticket::Article')->BackendForArticle( %{$ArticleRawI} )->ArticleAttachmentIndex(
                    ContentPath                => $Article{ContentPath},
                    ArticleID                  => $Article{ArticleID},
                    ExcludePlainText           => 1,
                    ExcludeHTMLBody            => $Self->{RichText},
                    ExcludeInline              => $Self->{RichText},
                );

                if (IsHashRefWithData( \%AtmIndex )){
                    my @Attachments;
                    ATTACHMENT:
                    for my $FileID ( sort keys %AtmIndex ) {
                        
                        next ATTACHMENT if !$FileID;
                        my %Attachment = $Kernel::OM->Get('Kernel::System::Ticket::Article')->BackendForArticle( %{$ArticleRawI} )->ArticleAttachment(
                            ArticleID => $Article{ArticleID},
                            FileID    => $FileID,                 # as returned by ArticleAttachmentIndex
                            UserID    => 1,
                        );

                        

                        next ATTACHMENT if !IsHashRefWithData( \%Attachment );

                        # convert content to base64
                        $Attachment{Content} = encode_base64( $Attachment{Content} , '' );
                        push @Attachments, {%Attachment};
                    }

                    # set Attachments data
                    $Article{Attachment} = \@Attachments;            
                }
            }
            push @ArticleBox, \%Article;
        }
        $Ticket{Article} = \@ArticleBox;
    }

    # Force UTF-8
    ## @TODO: Check if it is working right...
    my $JSONObject = $Kernel::OM->Get('Kernel::System::JSON');
    my $JSONString = $JSONObject->Encode(
       Data     => \%Ticket,
    );
    #$JSONString = encode("utf-8", $JSONString);
    my $TicketUtf8 = $JSONObject->Decode(
       Data => $JSONString,
    );

    return $TicketUtf8;

}

1;
