# --
# Kernel/Modules/Sac.pm - public Sac
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::PublicOccurrence;

use strict;
use warnings;
use utf8;
use MIME::Base64 qw();
use Kernel::Language qw(Translatable);
use Kernel::System::VariableCheck qw(:all);

sub new{
	my ($Type, %Param) = @_;
	
	my $Self = {%Param};
	bless  ($Self, $Type);
    # get form id
    $Self->{FormID} = $Kernel::OM->Get('Kernel::System::Web::Request')->GetParam( Param => 'FormID' );

    # create form id
    if ( !$Self->{FormID} ) {
        $Self->{FormID} = $Kernel::OM->Get('Kernel::System::Web::UploadCache')->FormIDCreate();
    }


	return $Self;	

}

sub Run {
	my ( $Self, %Param ) = @_;

	my $ParamObject = $Kernel::OM->Get("Kernel::System::Web::Request");
	my $ConfigObject = $Kernel::OM->Get("Kernel::Config");
	my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
	my $DynamicFieldObject = $Kernel::OM->Get("Kernel::System::DynamicField");
	my $DynamicFieldBackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

	#Definição dos Objetos --------------------------------------------------------- END#
  

	my %GetParam;
	$GetParam{SubAction} = $ParamObject->GetParam(Param => "SubAction") || "";
	$GetParam{User} = $ParamObject->GetParam(Param	=> "User") || "";
	$GetParam{Email} = $ParamObject->GetParam(Param	=> "Email") || "";
  $GetParam{embed} = $ParamObject->GetParam(Param => "embed") || "";

	my $ConfigItens = $ConfigObject->Get("PublicFrontend::PublicCreateOccurrence");

	my $DynamicFieldConfig = $DynamicFieldObject->DynamicFieldGet(
	        ID   => $ConfigItens->{DynamicFieldLocationID},             # ID or Name must be provided
   	);		

	# get params
    for my $Key (qw(User Email Body Lang CheckAssoc Assoc)) {
        $GetParam{$Key} = $ParamObject->GetParam( Param => $Key );
    }
	$GetParam{$DynamicFieldConfig->{Name}} = $ParamObject->GetParam( Param =>  "DynamicField_".$DynamicFieldConfig->{Name});
    my $TicketObject = $Kernel::OM->Get("Kernel::System::Ticket");

	if ( $GetParam{SubAction} eq 'StoreNew' ) {
        
        # Verifica se associação deve ser feita e se o ticket existe
        if($GetParam{CheckAssoc}){
            my $TicketIDAssoc = $TicketObject->TicketIDLookup(
                TicketNumber => $GetParam{Assoc},
            );
            # Ticket existente, prosseguir com criação
            if ($TicketIDAssoc){
                $Self->_Add(%GetParam);
            } else {
                #Mensagem de erro
                # output header
                my $Output 		=   $LayoutObject->CustomerHeader();
                $Output .= $Self->_Overview(
                    AssocNotFound => 1,
                    %GetParam,	
                );
                #--------------------------------------------#
                # add footer
                $Output .= $LayoutObject->CustomerFooter();
                return $Output;                
            }
        } else {
            # Criar chamado
            $Self->_Add(%GetParam);
        }

	}else{
		# output header
		my $Output 		=   $LayoutObject->CustomerHeader();
		$Output .= $Self->_Overview(
			%GetParam,	
		);
		#--------------------------------------------#
		# add footer
		$Output .= $LayoutObject->CustomerFooter();
		return $Output;
	}
	
}
sub _Add{
	my ( $Self, %Param) = @_;
	
	my $ParamObject = $Kernel::OM->Get("Kernel::System::Web::Request");
	my $TicketObject = $Kernel::OM->Get("Kernel::System::Ticket");

	my $CustomerUserObject = $Kernel::OM->Get('Kernel::System::CustomerUser');
	my $ConfigObject = $Kernel::OM->Get("Kernel::Config");
	my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
	
	my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');
	#Verifica se os requirementos mínimos para o módulo funcionar corretamente estão sendo atendidos, caso não, Pede para que o usuário configure nas config do Sistema
	my %Error;

	# If is an action about attachments
    my $IsUpload = 0;

    # attachment delete
    my @AttachmentIDs = map {
    	my ($ID) = $_ =~ m{ \A AttachmentDelete (\d+) \z }xms;
        $ID ? $ID : ();
    } $ParamObject->GetParamNames();

    my $UploadCacheObject = $Kernel::OM->Get('Kernel::System::Web::UploadCache');
	COUNT:
    for my $Count ( reverse sort @AttachmentIDs ) {
        my $Delete = $ParamObject->GetParam( Param => "AttachmentDelete$Count" );
        next COUNT if !$Delete;
        $Error{AttachmentDelete} = 1;
        $UploadCacheObject->FormIDRemoveFile(
            FormID => $Self->{FormID},
            FileID => $Count,
        );
        $IsUpload = 1;
    }

	
    # attachment upload
    if ( $ParamObject->GetParam( Param => 'AttachmentUpload' ) ) {
        $IsUpload = 1;
        $Error{AttachmentUpload} = 1;
        my %UploadStuff = $ParamObject->GetUploadAll(
            Param => 'file_upload',
        );
        $UploadCacheObject->FormIDAddFile(
            FormID      => $Self->{FormID},
            Disposition => 'attachment',
            %UploadStuff,
        );
    }

    # get all attachments meta data
    my @Attachments = $UploadCacheObject->FormIDGetAllFilesMeta(
	    FormID => $Self->{FormID},
    );

	

	
	my $ConfigItens = $ConfigObject->Get("PublicFrontend::PublicCreateOccurrence");
	my $NewQueueID  =  $ConfigItens->{'QueueID'} 	|| '1';
	my $StateID     =  $ConfigItens->{'StateID'} 	|| "1";
	my $TypeID      =  $ConfigItens->{'TypeID"'} 	|| "1";
	my $PriorityID  =  $ConfigItens->{'PriorityID'} || "5";
	my $CustomerID	=  $ConfigItens->{'CustomerID'};
  
	my $DynamicFieldConfig = $DynamicFieldObject->DynamicFieldGet(
	        ID   => $ConfigItens->{DynamicFieldLocationID},             # ID or Name must be provided
   	);		
	
	my $User 	= $Param{User}  || "";
	my $Email	= $Param{Email} || '';
	my $CustomerUserLogin;
    if (%Error) {

        # html output
        my $Output .= $LayoutObject->CustomerHeader();
        $Output    .= $Self->_Overview(
            Attachments => \@Attachments,
            %Param,
            Errors           => \%Error,
        );
        $Output .= $LayoutObject->CustomerFooter();
        return $Output;
    }



	#Verificar se há usuário cadastrado com essas informações. Caso sim pegar o ID e utilizar Caso não criar um novo e retornar credicial ao usuário.
	if($Param{User} and $Param{Email}){
		my %List = $CustomerUserObject->CustomerSearch(
	        PostMasterSearch => $Param{Email},
    	    Valid            => 1,       # (optional) default 1
	    );	
		my @CID = keys(%List);

		if($CID[0]) {
			my %UserInfo = $CustomerUserObject->CustomerUserDataGet(
        		User => $CID[0],
		    );
				
			$CustomerUserLogin = $UserInfo{UserLogin},
		
		}
	}

	#--------------
	my $Password = "";
	if(!$CustomerUserLogin){
		$CustomerUserLogin = $Self->_GenerateValidLogin();		
		$Password = $CustomerUserObject->GenerateRandomPassword(
		    Size => 8,
		);

		if(!$Email){
			$Email = $Self->_GenerateValidEmail(Email => $CustomerUserLogin);
		}
		my $CustomerUserID = $CustomerUserObject->CustomerUserAdd(
			Source         => 'CustomerUser', # CustomerUser source config
			UserFirstname  => $User || $CustomerUserLogin,
			UserLastname   => '-',
			UserCustomerID => $CustomerUserLogin,
			UserLogin      => $CustomerUserLogin,
			UserPassword   => $Password, # not required	
		    UserEmail      => $Email,
		    ValidID        => 1,
			UserID         => 1,
		);
	}

	
	#-------------------------------------------
	my $MimeType 	= 'text/html';
	my $NewQueueID  =  $ConfigItens->{'QueueID'} 	|| '1';
	my $StateID     =  $ConfigItens->{'StateID'} 	|| "1";
	my $TypeID      =  $ConfigItens->{'TypeID'} 	|| "1";
	my $PriorityID  =  $ConfigItens->{'PriorityID'} || "5";
	my $CustomerID	=  $ConfigItens->{'CustomerID'};
  my $CustomerID	=  $ConfigItens->{'CustomerID'};
  my $ProcessID	=  $ConfigItens->{'ProcessID'} || "";
  my $ActivityID	=  $ConfigItens->{'ActivityID'} || "";

	my $NoAgentNotify = 0;

	my $Title = $Param{Body};

	$Title =~ s/\n/ /mgi;
	$Title = substr($Title,0,100);

	my $TicketID = $TicketObject->TicketCreate(
		Title			=>  $Title || " ",
		QueueID 		=>  "$NewQueueID",
		Lock  		 	=>  "unlock",
		TypeID			=>  "$TypeID",
		StateID		 	=>  "$StateID",
		CustomerID 		=> $CustomerID ,
		CustomerUser	=> $CustomerUserLogin,
		OwnerID		 	=>  "1",
		PriorityID 		=> "$PriorityID",
		UserID		 	=>  "1",
	
	);

  my $ArticleBackendObject = $Kernel::OM->Get('Kernel::System::Ticket::Article')->BackendForChannel(ChannelName => 'Email');
	
	my $ArticleID = $ArticleBackendObject->ArticleCreate(

		NoAgentNotify 		=>	$NoAgentNotify,
		TicketID			=>	$TicketID,
		ArticleType      	=>  'webrequest',                
		SenderType			=>  'customer',
		From				=>  $Email,
		To					=>	"",
		Subject				=>  '', 
		Body				=> 	$Param{Body},
		MimeType			=> 	$MimeType,
		Charset				=>	$LayoutObject->{UserCharset},
    IsVisibleForCustomer => 1,
		UserID				=>	"1",
		HistoryType			=> 	"WebRequestCustomer",
		HistoryComment			=>	'%%',
		AutoResponseType		=>  'auto reply' ,
		OrigHeader 			=> {
			From    => 'email@example.com',
			To      => "",
			Subject => ' ',
			Body    => $Param{Body},
	
		},
		Queue	=>	$Kernel::OM->Get("Kernel::System::Queue")->QueueLookup(	QueueID	=>	$NewQueueID),
	
	);

	my $True;
	#Faz a associação
	if($Param{CheckAssoc}){
	
		my $TicketIDAssoc = $TicketObject->TicketIDLookup(
		    TicketNumber => $Param{Assoc},
		);
		my $LinkObject = $Kernel::OM->Get('Kernel::System::LinkObject');
		$True = $LinkObject->LinkAdd(
	      SourceObject => 'Ticket',
		  SourceKey    => $TicketID,
		  TargetObject => 'Ticket',
		  TargetKey    => $TicketIDAssoc,
		  Type         => 'Normal',
		  State        => 'Valid',
		  UserID       => 1,
		);
	
	}
	my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');
	my $BackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');
	my $Success = $BackendObject->ValueSet(
	    DynamicFieldConfig => $DynamicFieldConfig,      
		ObjectID           => $TicketID,                
		Value              =>  $Param{$DynamicFieldConfig->{Name}},                   
		UserID             => 1,
	);

  if($ActivityID && $ProcessID) {
    my $DynamicFieldProConfig = $DynamicFieldObject->DynamicFieldGet(
	        Name   => "ProcessManagementProcessID",             # ID or Name must be provided
   	);

     my $Success = $BackendObject->ValueSet(
	    DynamicFieldConfig => $DynamicFieldProConfig,      
      ObjectID           => $TicketID,                
      Value              =>  $ProcessID,                   
      UserID             => 1,
    );

     my $DynamicFieldActConfig = $DynamicFieldObject->DynamicFieldGet(
	        Name   => "ProcessManagementActivityID",             # ID or Name must be provided
   	);

     my $Success = $BackendObject->ValueSet(
	    DynamicFieldConfig => $DynamicFieldActConfig,      
      ObjectID           => $TicketID,                
      Value              =>  $ActivityID,                   
      UserID             => 1,
    );
  }
	#ADICIONA OS CAMPOS DINAMICOS
	my $TicketNumber = $TicketObject->TicketNumberLookup(
		TicketID => $TicketID,
	);
	my $Message = $TicketNumber; 
    # get pre loaded attachment
    my @AttachmentData = $UploadCacheObject->FormIDGetAllFilesData(
        FormID => $Self->{FormID},
    );

    # get submitted attachment
    my %UploadStuff = $ParamObject->GetUploadAll(
        Param => 'file_upload',
    );
    if (%UploadStuff) {
        push @AttachmentData, \%UploadStuff;
    }

    # write attachments
    ATTACHMENT:
    for my $Attachment (@AttachmentData) {

        # skip, deleted not used inline images
        my $ContentID = $Attachment->{ContentID};
        if (
            $ContentID
            && ( $Attachment->{ContentType} =~ /image/i )
            && ( $Attachment->{Disposition} eq 'inline' )
            )
        {
            my $ContentIDHTMLQuote = $LayoutObject->Ascii2Html(
                Text => $ContentID,
            );

            # workaround for link encode of rich text editor, see bug#5053
            my $ContentIDLinkEncode = $LayoutObject->LinkEncode($ContentID);
            $Param{Body} =~ s/(ContentID=)$ContentIDLinkEncode/$1$ContentID/g;

            # ignore attachment if not linked in body
            next ATTACHMENT if $Param{Body} !~ /(\Q$ContentIDHTMLQuote\E|\Q$ContentID\E)/i;
        }

        # write existing file to backend
        $ArticleBackendObject->ArticleWriteAttachment(
            %{$Attachment},
            ArticleID => $ArticleID,
            UserID    => $ConfigObject->Get('CustomerPanelUserID'),
        );
    }

    # remove pre submitted attachments
    $UploadCacheObject->FormIDRemove( FormID => $Self->{FormID} );



	my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
	my $Output 		=   $LayoutObject->CustomerHeader();
	
	$Output .= $Self->_Overview(
		Login	 	  => $CustomerUserLogin,
		Password   	  => $Password,
		Message    	  => $Message,
		SubAction     => "Message",
		IsAssoc		  => $True,
		Email			=> $Email,
    embed => $Param{embed},
	);
	#--------------------------------------------#
	# add footer
	$Output .= $LayoutObject->CustomerFooter();
	
	return $Output;
	


}
sub _Overview{
	my ( $Self, %Param) = @_;

	#Definição dos OBJETOS 
	

    my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');
	my $TicketObject = $Kernel::OM->Get("Kernel::System::Ticket");
	my $ConfigObject = $Kernel::OM->Get("Kernel::Config");
	my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
	my $DynamicFieldObject = $Kernel::OM->Get("Kernel::System::DynamicField");
	my $DynamicFieldBackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');
	my $ConfigItens = $ConfigObject->Get("PublicFrontend::PublicCreateOccurrence");
	#Definição dos Objetos --------------------------------------------------------- END#
	
	my $DynamicFieldConfig = $DynamicFieldObject->DynamicFieldGet(
	        ID   => $ConfigItens->{DynamicFieldLocationID},             # ID or Name must be provided
   	);		

	# get params

    $Param{FormID} = $Self->{FormID};
	my $Output;
				
	if($Param{SubAction} eq "Message"){
		if($Param{IsAssoc}){
			$LayoutObject->Block(
				Name => "Associative",
					Data => \%Param,	
			);
		}
    my $CommonConfigItens = $ConfigObject->Get("PublicFrontend::Channel::Common");
    $Param{DefaultUrlReturn}  =  $CommonConfigItens->{'DefaultUrlReturn'} 	|| 'http://localhost/otrs/public.pl';
		$LayoutObject->Block(
			Name => "Alert",
			Data => \%Param,
		);
        
        # Se o email for @canaletico
		if($Param{Email}  !~ /\@canaletico.com/){
            # Bloca o known
			$LayoutObject->Block(
				Name => "Known",
				Data => \%Param,
			);
		}else{
            # se não, bloca unknow
			$LayoutObject->Block(
				Name => "Unknown",
				Data => \%Param,
			);

		}
        # Se tiver password
        if($Param{Password} ne ""){
            $Kernel::OM->Get('Kernel::Output::HTML::Layout')->Block(
                Name => 'NewPassword',
                Data => {
                    Password => $Param{Password}
                },
            );
        } else {
            $Kernel::OM->Get('Kernel::Output::HTML::Layout')->Block(
                Name => 'OldPassword',
                Data => {
                },
            );
        }
		$Output .= $LayoutObject->Output(
			TemplateFile => 'InformationMessage', 
			Data         => {
				%Param,
			},
		);

		
		return $Output;			

	}else{
		#create html strings for all dynamic fields
       	my %DynamicFieldHTML;
       	my $PossibleValuesFilter;
      	my $IsACLReducible = $DynamicFieldBackendObject->HasBehavior(
               DynamicFieldConfig => $DynamicFieldConfig,
               Behavior           => 'IsACLReducible',
	    );
	    if ($IsACLReducible) {
    		my $PossibleValues = $DynamicFieldBackendObject->PossibleValuesGet(
	    	    DynamicFieldConfig => $DynamicFieldConfig,
            );
            # check if field has PossibleValues property in its configuration
            if ( IsHashRefWithData($PossibleValues) ) {

 	        	# convert possible values key => value to key => key for ACLs using a Hash slice
		        my %AclData = %{$PossibleValues};
        	    @AclData{ keys %AclData } = keys %AclData;
            	# set possible values filter from ACLs
           		my $ACL = $TicketObject->TicketAcl(
                	CustomerUserID => '',
                    Action         => $Self->{Action},
                    ReturnType     => 'Ticket',
                    ReturnSubType  => 'DynamicField_' . $DynamicFieldConfig->{Name},
                    Data           => \%AclData,
                    UserID         => $Self->{UserID},
                );
                if ($ACL) {
     	           my %Filter = $TicketObject->TicketAclData();
                     %{$PossibleValuesFilter} = map { $_ => $PossibleValues->{$_} }
                            keys %Filter;
                }
	        }	
		}
		my $PossibleValues = $DynamicFieldBackendObject->PossibleValuesGet(
	        DynamicFieldConfig => $DynamicFieldConfig,
        );
        # check if field has PossibleValues property in its configuration
        my $ValidationResult;
        # do not validate on attachment upload
        $ValidationResult = $DynamicFieldBackendObject->EditFieldValueValidate(
	    	DynamicFieldConfig   => $DynamicFieldConfig,
            PossibleValuesFilter => $PossibleValuesFilter,
            ParamObject          => $ParamObject,
        );
        if ( !IsHashRefWithData($ValidationResult) ) {
	    	return $LayoutObject->ErrorScreen(
                        Message =>
                            $LayoutObject->{LanguageObject}
                            ->Translate( 'Could not perform validation on field %s!', $DynamicFieldConfig->{Label} ),
                        Comment => Translatable('Please contact the administrator.'),
                   );
        }
        # get field html
        $DynamicFieldHTML{ $DynamicFieldConfig->{Name} } = $DynamicFieldBackendObject->EditFieldRender(
                DynamicFieldConfig   => $DynamicFieldConfig,
                LayoutObject         => $LayoutObject,
                ParamObject          => $ParamObject,
                AJAXUpdate           => 0,
                UpdatableFields      => [],
                Mandatory            => 1,
				Class				 => "form-control",
         );
		 # get the html strings form $Param
		

		$Param{CheckAssoc} = 'checked'	if($Param{CheckAssoc});

    my $CommonConfigItens = $ConfigObject->Get("PublicFrontend::Channel::Common");
    $Param{DefaultUrlReturn}  =  $CommonConfigItens->{'DefaultUrlReturn'} 	|| 'http://localhost/otrs/public.pl';

		$LayoutObject->Block(
			Name => 'NewOcurrence',
			Data => \%Param,
		);
		$DynamicFieldHTML{$DynamicFieldConfig->{Name}}{Field} =~ s/Modernize//g;
        $LayoutObject->Block(
            Name => 'DynamicField',
            Data => {
                Name  => $DynamicFieldConfig->{Name},
                Label => $DynamicFieldConfig->{Label},
                Field => $DynamicFieldHTML{$DynamicFieldConfig->{Name}}{Field},
            },
        );
	    # show attachments
		ATTACHMENT:
	    for my $Attachment ( @{ $Param{Attachments} } ) {
        if (
            $Attachment->{ContentID}
            && $LayoutObject->{BrowserRichText}
            && ( $Attachment->{ContentType} =~ /image/i )
            && ( $Attachment->{Disposition} eq 'inline' )
            )
        {
            next ATTACHMENT;
        }
        $LayoutObject->Block(
            Name => 'Attachment',
            Data => $Attachment,
        );
	    } 

		if($Param{Message}){
			$LayoutObject->Block(
				Name => "Information",
				Data => \%Param,
			);
		}
        
		if($Param{AssocNotFound}){
			$LayoutObject->Block(
				Name => "AssocNotFound",
				Data => \%Param,
			);
		}
        
        

		$Output .= $LayoutObject->Output(
			TemplateFile => 'Occurrence',
			Data         => {
				%Param,
			},
		);


		return $Output;


	}
}
sub _GenerateValidLogin
{
	
	my $MainObject = $Kernel::OM->Get('Kernel::System::Main');
	my $UserObject = $Kernel::OM->Get('Kernel::System::User');
	my $CustomerUserLogin = $MainObject->GenerateRandomString(
		Length     => 8,
		Dictionary => [ 0..9, 'a'..'f' ], # hexadecimal
	);

	my $Exist = $UserObject->UserLoginExistsCheck(
    	UserLogin => 'Some::UserLogin',
        UserID => 1, # optional
	);
	_GenerateValidLogin() if($Exist);
	return $CustomerUserLogin;
	
}
sub _GenerateValidEmail
{

	my $CustomerUserObject = $Kernel::OM->Get('Kernel::System::CustomerUser');
	my  ( $Self, %Param) =  @_;
	
	my $Email = $Param{Email}.'@canaletico.com' ;
    my %List = $CustomerUserObject->CustomerSearch(
        PostMasterSearch => $Email,
        Valid            => 0,                    # (optional) default 1
    );
	if(%List){
		_GenerateValidEmail(_GenerateValidLogin());
	} else{

		return $Email;
	} 


	
}
1;
