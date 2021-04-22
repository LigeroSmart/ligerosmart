# --
# Kernel/Modules/AgentTicketArticleEdit.pm - common file for several modules
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentTicketArticleEdit;

use strict;
use warnings;

use Kernel::System::Web::UploadCache;
use Kernel::System::DynamicField;
use Kernel::System::DynamicField::Backend;
use Kernel::System::VariableCheck qw(:all);
use Kernel::System::HTMLUtils;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $ParamObject  = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $UserObject   = $Kernel::OM->Get('Kernel::System::User');

    my $UploadCacheObject  = $Kernel::OM->Get('Kernel::System::Web::UploadCache');
    my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');
    my $DynamicFieldBackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');
    my $HTMLUtilsObject    = $Kernel::OM->Get('Kernel::System::HTMLUtils');
    my $ConfigObject	   = $Kernel::OM->Get('Kernel::Config');
    my $QueueObject 	   = $Kernel::OM->Get('Kernel::System::Queue');
    my $ServiceObject	   = $Kernel::OM->Get('Kernel::System::Service');
     # get form id
	
    $Self->{FormID} = $ParamObject->GetParam( Param => 'FormID' );

    # COMPLEMENTO - ARTICLE ID
    $Self->{ArticleID} = $ParamObject->GetParam( Param => 'ArticleID' );

    # get inform user list
    my @InformUserID = $ParamObject->GetArray( Param => 'InformUserID' );
    $Self->{InformUserID} = \@InformUserID;

    # get involved user list
    my @InvolvedUserID = $ParamObject->GetArray( Param => 'InvolvedUserID' );
    $Self->{InvolvedUserID} = \@InvolvedUserID;

    # create form id
    if ( !$Self->{FormID} ) {
        $Self->{FormID} = $UploadCacheObject->FormIDCreate();
    }

    # get config of frontend module
    $Self->{Config} = $ConfigObject->Get("Ticket::Frontend::$Self->{Action}");

    # define the dynamic fields to show based on the object type
    # COMPLEMENTO
    my $ObjectType = [ 'Article','Ticket' ];

    # get the dynamic fields for this screen
    $Self->{DynamicField} = $DynamicFieldObject->DynamicFieldListGet(
        Valid       => 1,
        ObjectType  => $ObjectType,
        FieldFilter => $Self->{Config}->{DynamicField} || {},
    );



    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $ParamObject  = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $UserObject   = $Kernel::OM->Get('Kernel::System::User');

    my $UploadCacheObject  = $Kernel::OM->Get('Kernel::System::Web::UploadCache');
    my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');
    my $DynamicFieldBackendObject      = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');
    my $HTMLUtilsObject    = $Kernel::OM->Get('Kernel::System::HTMLUtils');
    my $ConfigObject	   = $Kernel::OM->Get('Kernel::Config');
    my $TicketObject	   = $Kernel::OM->Get('Kernel::System::Ticket');
    # check needed stuff
    if ( !$Self->{TicketID} ) {
        return $LayoutObject->ErrorScreen(
            Message => 'No TicketID is given!',
            Comment => 'Please contact the admin.',
        );
    }
    if ( !$Self->{ArticleID} ) {
        return $LayoutObject->ErrorScreen(
            Message => 'No ArticleID is given!',
            Comment => 'Please contact the admin.',
        );
    }

    # check permissions
    my $Access = $TicketObject->TicketPermission(
        Type     => $Self->{Config}->{Permission},
        TicketID => $Self->{TicketID},
        UserID   => $Self->{UserID}
    );

    # error screen, don't show ticket
    if ( !$Access ) {
        return $LayoutObject->NoPermission(
            Message    => "You need $Self->{Config}->{Permission} permissions!",
            WithHeader => 'yes',
        );
    }

    # get ACL restrictions
    $TicketObject->TicketAcl(
        Data          => '-',
        TicketID      => $Self->{TicketID},
        ReturnType    => 'Action',
        ReturnSubType => '-',
        UserID        => $Self->{UserID},
    );

    my %AclAction = $TicketObject->TicketAclActionData();

    # check if ACL restrictions exist
    if ( IsHashRefWithData( \%AclAction ) ) {

        # show error screen if ACL prohibits this action
        if ( defined $AclAction{ $Self->{Action} } && $AclAction{ $Self->{Action} } eq '0' ) {
            return $LayoutObject->NoPermission( WithHeader => 'yes' );
        }
    }

    my %Ticket = $TicketObject->TicketGet(
        TicketID      => $Self->{TicketID},
        DynamicFields => 1,
    );

    # COMPLEMENTO
    my $ArticleObject = $Kernel::OM->Get('Kernel::System::Ticket::Article');
	my $ArticleBackendObject = $ArticleObject->BackendForArticle(
		TicketID  => $Self->{TicketID},
		ArticleID => $Self->{ArticleID},
	);

	my %ArticleTemp = $ArticleBackendObject->ArticleGet(
		TicketID      => $Self->{TicketID},
		ArticleID     => $Self->{ArticleID},
		RealNames     => 1,
		DynamicFields => 1,
	);

	my %Article =(%ArticleTemp, %Ticket);

    # EO COMPLEMENTO
    $LayoutObject->Block(
        Name => 'Properties',
        Data => {
            FormID => $Self->{FormID},
            %Ticket,
            %Param,
            ArticleID => $Self->{ArticleID},
        },
    );

    # show right header
    $LayoutObject->Block(
        Name => 'Header' . $Self->{Action},
    );

    # get lock state
    if ( $Self->{Config}->{RequiredLock} ) {

        if ( !$TicketObject->TicketLockGet( TicketID => $Self->{TicketID} ) ) {
            $TicketObject->TicketLockSet(
                TicketID => $Self->{TicketID},
                Lock     => 'lock',
                UserID   => $Self->{UserID}
            );
            my $Success = $TicketObject->TicketOwnerSet(
                TicketID  => $Self->{TicketID},
                UserID    => $Self->{UserID},
                NewUserID => $Self->{UserID},
            );

            # show lock state
            if ($Success) {
                $LayoutObject->Block(
                    Name => 'PropertiesLock',
                    Data => {
                        %Param,
                        TicketID => $Self->{TicketID},
                    },
                );
            }
        }
        else {
            my $AccessOk = $TicketObject->OwnerCheck(
                TicketID => $Self->{TicketID},
                OwnerID  => $Self->{UserID},
            );
            if ( !$AccessOk ) {
                my $Output = $LayoutObject->Header(
                    Type  => 'Small',
                    Value => $Ticket{Number},
					BodyClass => 'Popup',
                );
                $Output .= $LayoutObject->Warning(
                    Message => $LayoutObject->{LanguageObject}->Get('Sorry, you need to be the ticket owner to perform this action.'),
                    Comment => $LayoutObject->{LanguageObject}->Get('Please change the owner first.'),
                );
                $Output .= $LayoutObject->Footer(
                    Type => 'Small',
                );
                return $Output;
            }

            # show back link
            $LayoutObject->Block(
                Name => 'TicketBack',
                Data => {
                    %Param,
                    TicketID => $Self->{TicketID},
					ArticleID => $Self->{ArticleID},
                },
            );
        }
    }
    else {
        $LayoutObject->Block(
            Name => 'TicketBack',
            Data => {
                %Param,
                %Ticket,
				ArticleID => $Self->{ArticleID},     
            },
        );
    }

    # get params
    my %GetParam;

    $GetParam{Expand} = $ParamObject->GetParam( Param => 'Expand' );
        
    my $GetFromDB = (
                        ($Self->{Subaction} ne 'Store' ) &&
                        (!$GetParam{Expand} )
                    )?1:0;
                    
	if($Self->{Subaction} eq 'AJAXUpdate'){
		$GetFromDB = 0;
	}
    for my $Key (
        qw(
        TimeUnits IsVisibleForCustomer Subject )
        )
    {
        $GetParam{$Key} = $GetFromDB?$Article{$Key}:$ParamObject->GetParam( Param => $Key );
    }

    $GetParam{IsVisibleForCustomer} = $GetParam{IsVisibleForCustomer} ? 1 : 0;
    
    # Complemento - Take body from db is a litle more complex
    if($GetFromDB){
        my %Atts = $ArticleBackendObject->ArticleAttachmentIndex(
			TicketID => $Self->{TicketID},
            ArticleID => $Self->{ArticleID},
            UserID    => 1,
        );
        my $Body;
        for my $At (keys %Atts){
            my %Attachment = $ArticleBackendObject->ArticleAttachment(
				TicketID => $Self->{TicketID},
                ArticleID => $Self->{ArticleID},
                FileID    => $At,
                UserID    => 1,
            );
            if ($Atts{$At}->{Filename} eq 'file-2'){
                $Body = $Attachment{Content};
                ($Body) = $Body =~ /<body.*?>(.*?)<\/body>/s;
#                last ATTACHMENTS;
            } else {
                $UploadCacheObject->FormIDAddFile(
                    FormID => $Self->{FormID},
                    %Attachment,
                );
            }
        }
        
	 $Article{Body} = $LayoutObject->Ascii2Html(
            NewLine        => $ConfigObject->Get('DefaultViewNewLine'),
            Text           => $Article{Body},
            VMax           => $ConfigObject->Get('DefaultViewLines') || 5000,
            HTMLResultMode => 1,
            LinkFeature    => 1,
        );

 	  $GetParam{Body}= $Article{Body};
   
    } else {
        $GetParam{Body} = $ParamObject->GetParam( Param => 'Body' );
    }

    # get pre loaded attachment
    my @Attachments = $UploadCacheObject->FormIDGetAllFilesData(
        FormID => $Self->{FormID},
    );

	my $DynamicFieldFilter = {
        %{ $ConfigObject->Get("Ticket::Frontend::AgentTicketArticleEdit")->{DynamicField} || {} },
        %{
            $ConfigObject->Get("Ticket::Frontend::AgentTicketArticleEdit")
                ->{ProcessWidgetDynamicField}
                || {}
        },
    };

    # get the dynamic fields for article object
    my $DynamicField = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldListGet(
        Valid       => 1,
        ObjectType  => ['Article','Ticket'],
        FieldFilter => $DynamicFieldFilter || {},
    );

    # get dynamic field values form http request
    my %DynamicFieldValues;

    # cycle trough the activated Dynamic Fields for this screen
    DYNAMICFIELD:
    for my $DynamicFieldConfig ( @{$DynamicField} ) {
        next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

        # extract the dynamic field value form the web request
        $DynamicFieldValues{ $DynamicFieldConfig->{Name} }
            = $GetFromDB?
            $Article{ "DynamicField_".$DynamicFieldConfig->{Name} }:
            $DynamicFieldBackendObject->EditFieldValueGet(
            DynamicFieldConfig => $DynamicFieldConfig,
            ParamObject        => $ParamObject,
            LayoutObject       => $LayoutObject,
            );

    }
    # convert dynamic field values into a structure for ACLs
    my %DynamicFieldACLParameters;
    DYNAMICFIELD:
    for my $DynamicField ( sort keys %DynamicFieldValues ) {
    
        next DYNAMICFIELD if !$DynamicField;
        next DYNAMICFIELD if !$DynamicFieldValues{$DynamicField};

        $DynamicFieldACLParameters{ 'DynamicField_' . $DynamicField }
            = $DynamicFieldValues{$DynamicField};
    }
    $GetParam{DynamicField} = \%DynamicFieldACLParameters;


    # rewrap body if no rich text is used
    if ( $GetParam{Body} && !$LayoutObject->{BrowserRichText} ) {
        my $Size = $ConfigObject->Get('Ticket::Frontend::TextAreaNote') || 70;
        $GetParam{Body} =~ s/(^>.+|.{4,$Size})(?:\s|\z)/$1\n/gm;

    }


    if ( $Self->{Subaction} eq 'Store' ) {

        # challenge token check for write action
        $LayoutObject->ChallengeTokenCheck();

        # store action
        my %Error;

        # If is an action about attachments
        my $IsUpload = 0;

        # attachment delete
        COUNT:
        for my $Count ( 1 .. 32 ) {
            my $Delete = $ParamObject->GetParam( Param => "AttachmentDelete$Count" );
            next COUNT if !$Delete;
            %Error = ();
            $Error{AttachmentDelete} = 1;
            $UploadCacheObject->FormIDRemoveFile(
                FormID => $Self->{FormID},
                FileID => $Count,
            );
            $IsUpload = 1;
        }

        # attachment upload
        if ( $ParamObject->GetParam( Param => 'AttachmentUpload' ) ) {
            $IsUpload                = 1;
            %Error                   = ();
            $Error{AttachmentUpload} = 1;
            my %UploadStuff = $ParamObject->GetUploadAll(
                Param  => 'FileUpload',
                Source => 'string',
            );
            $UploadCacheObject->FormIDAddFile(
                FormID => $Self->{FormID},
                %UploadStuff,
            );
        }

        # get all attachments meta data
        my @Attachments = $UploadCacheObject->FormIDGetAllFilesMeta(
            FormID => $Self->{FormID},
        );

        if ( !$IsUpload ) {
            if ( $Self->{Config}->{Note} ) {

                # check subject
                if ( !$GetParam{Subject} ) {
                    $Error{'SubjectInvalid'} = 'ServerError';
                }

                # check body
                if ( !$GetParam{Body} ) {
                    $Error{'BodyInvalid'} = 'ServerError';
                }
            }


        }

        # check expand
        if ( $GetParam{Expand} ) {
            %Error = ();
            $Error{Expand} = 1;
        }

        # create html strings for all dynamic fields
        my %DynamicFieldHTML;

        # cycle trough the activated Dynamic Fields for this screen
        DYNAMICFIELD:
        for my $DynamicFieldConfig ( @{ $Self->{DynamicField} } ) {
            next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

            my $PossibleValuesFilter;

            # check if field has PossibleValues property in its configuration
            if ( IsHashRefWithData( $DynamicFieldConfig->{Config}->{PossibleValues} ) ) {

                # convert possible values key => value to key => key for ACLs usign a Hash slice
                my %AclData = %{ $DynamicFieldConfig->{Config}->{PossibleValues} };
                @AclData{ keys %AclData } = keys %AclData;

                # set possible values filter from ACLs
                my $ACL = $TicketObject->TicketAcl(
                    %GetParam,
                    Action        => $Self->{Action},
                    TicketID      => $Self->{TicketID},
                    ReturnType    => 'Ticket',
                    ReturnSubType => 'DynamicField_' . $DynamicFieldConfig->{Name},
                    Data          => \%AclData,
                    UserID        => $Self->{UserID},
                );
                if ($ACL) {
                    my %Filter = $TicketObject->TicketAclData();

                    # convert Filer key => key back to key => value using map
                    %{$PossibleValuesFilter}
                        = map { $_ => $DynamicFieldConfig->{Config}->{PossibleValues}->{$_} }
                        keys %Filter;
                }
            }

            my $ValidationResult;

            # do not validate on attachment upload
            if ( !$IsUpload ) {

                $ValidationResult = $DynamicFieldBackendObject->EditFieldValueValidate(
                    DynamicFieldConfig   => $DynamicFieldConfig,
                    PossibleValuesFilter => $PossibleValuesFilter,
                    ParamObject          => $ParamObject,
                    Mandatory =>
                        $Self->{Config}->{DynamicField}->{ $DynamicFieldConfig->{Name} } == 2,
                );

                if ( !IsHashRefWithData($ValidationResult) ) {
                    return $LayoutObject->ErrorScreen(
                        Message =>
                            "Could not perform validation on field $DynamicFieldConfig->{Label}!",
                        Comment => 'Please contact the admin.',
                    );
                }

                # propagate validation error to the Error variable to be detected by the frontend
                if ( $ValidationResult->{ServerError} ) {
                    $Error{ $DynamicFieldConfig->{Name} } = ' ServerError';
                }
            }

            # get field html
            $DynamicFieldHTML{ $DynamicFieldConfig->{Name} } =
                $DynamicFieldBackendObject->EditFieldRender(
                DynamicFieldConfig   => $DynamicFieldConfig,
                PossibleValuesFilter => $PossibleValuesFilter,
                Mandatory =>
                    $Self->{Config}->{DynamicField}->{ $DynamicFieldConfig->{Name} } == 2,
                ServerError  => $ValidationResult->{ServerError}  || '',
                ErrorMessage => $ValidationResult->{ErrorMessage} || '',
                LayoutObject => $LayoutObject,
                ParamObject  => $ParamObject,
                AJAXUpdate   => 1,
                UpdatableFields => $Self->_GetFieldsToUpdate(),
                );
        }

        # check errors
        if (%Error) {

            my $Output = $LayoutObject->Header(
                Type  => 'Small',
                Value => $Ticket{TicketNumber},
				BodyClass => 'Popup',
            );
            $Output .= $Self->_Mask(
                Attachments       => \@Attachments,
                %Ticket,
                DynamicFieldHTML => \%DynamicFieldHTML,
                %GetParam,
                %Error,
            );
            $Output .= $LayoutObject->Footer(
                Type => 'Small',
            );
            return $Output;
        }

        # set new owner
        my @NotifyDone;

        # COMPLEMENTO
#                my $ArticleID = '';        
        my $ArticleID = $Self->{ArticleID};
        #EO COMPLEMENTO

        if ( $Self->{Config}->{Note} ) {
            #~ # if there is no IsVisibleForCustomer, use the default value
            #~ if ( !defined $GetParam{IsVisibleForCustomer} ) {
                #~ $GetParam{ArticleType} = $Self->{Config}->{ArticleTypeDefault};
            #~ }

            my $MimeType = 'text/plain';
            if ( $LayoutObject->{BrowserRichText} ) {
                $MimeType = 'text/html';

                # verify html document
                $GetParam{Body} = $LayoutObject->RichTextDocumentComplete(
                    String => $GetParam{Body},
                );
            }

            my $From = "\"$Self->{UserFirstname} $Self->{UserLastname}\" <$Self->{UserEmail}>";
            my @NotifyUserIDs = ( @{ $Self->{InformUserID} }, @{ $Self->{InvolvedUserID} } );

            # COMPLEMENTO - UPDATE SUBJECT
            my $Success = $ArticleBackendObject->ArticleUpdate(
                ArticleID => $ArticleID,
                Key       => 'Subject',
                Value     => $GetParam{Subject},
                UserID    => $Self->{UserID},
                TicketID  => $Self->{TicketID},
            );

            # COMPLEMENTO - UPDATE ARTICLE TYPE
			$Success = $ArticleBackendObject->ArticleUpdate(
                ArticleID => $ArticleID,
                Key       => 'IsVisibleForCustomer',
                Value     => $GetParam{IsVisibleForCustomer},
                UserID    => $Self->{UserID},
                TicketID  => $Self->{TicketID},
            );

#            my %PreUploadFiles;
            # COMPLEMENTO - UPDATE BODY
            if($MimeType eq 'text/html'){
                my %AtmIndex = $ArticleBackendObject->ArticleAttachmentIndex(
										TicketID  => $Self->{TicketID},
                                        ArticleID                  => $ArticleID,
                                        UserID                     => $Self->{UserID},
                                    );
                # add block for attachments
                ATTACHMENT:
                for my $FileID ( sort keys %AtmIndex ) {
                     my %UploadFiles = $ArticleBackendObject->ArticleAttachment(
						TicketID  => $Self->{TicketID},
                	    ArticleID => ${ArticleID},
                        FileID    => $FileID,   # as returned by ArticleAttachmentIndex
                        UserID    => 1,
                    );



                }


                # COMPLEMENTO - WE NEED TO DELETE ALL ATTACHMENTS AND RECREATE file-2 IF 
                # NOTE BODY IS HTML
                $ArticleBackendObject->ArticleDeleteAttachment(
					TicketID  => $Self->{TicketID},
                    ArticleID => $ArticleID,
                    UserID    => 1,
                );
                $ArticleBackendObject->ArticleWriteAttachment(
					TicketID  => $Self->{TicketID},
                    Content            => $GetParam{Body},
                    ContentType        => "$MimeType; charset=\"".$LayoutObject->{UserCharset}."\"",
                    Filename           => 'file-2',
                    ArticleID          => $ArticleID,
                    UserID             => $Self->{UserID},
                );
                $GetParam{Body} = $HTMLUtilsObject->ToAscii(
                    String => $GetParam{Body},
                );
            };
            $Success = $ArticleBackendObject->ArticleUpdate(
                ArticleID => $ArticleID,
                Key       => 'Body',
                Value     => $GetParam{Body},
                UserID    => $Self->{UserID},
                TicketID  => $Self->{TicketID},
            );
            # EO COMPLEMENTO - UPDATE BODY            
 
            # get attachment index (without attachments)

            # get pre loaded attachment
            my @Attachments = $UploadCacheObject->FormIDGetAllFilesData(
                FormID => $Self->{FormID},
            );


            # get submit attachment
            my %UploadStuff = $ParamObject->GetUploadAll(
                Param  => 'FileUpload',
                Source => 'String',
            );
            if (%UploadStuff) {
                push @Attachments, \%UploadStuff;
            }
            # write attachments
            ATTACHMENT:
            for my $Attachment (@Attachments) {
		
                # skip, deleted not used inline images
                my $ContentID = $Attachment->{ContentID};
                if ($ContentID) {
                    my $ContentIDHTMLQuote = $LayoutObject->Ascii2Html(
                        Text => $ContentID,
                    );

                    # workaround for link encode of rich text editor, see bug#5053
                    my $ContentIDLinkEncode = $LayoutObject->LinkEncode($ContentID);
                    $GetParam{Body} =~ s/(ContentID=)$ContentIDLinkEncode/$1$ContentID/g;

                    # ignore attachment if not linked in body
                    next ATTACHMENT
                        if $GetParam{Body} !~ /(\Q$ContentIDHTMLQuote\E|\Q$ContentID\E)/i;
                }

                # write existing file to backend
                $ArticleBackendObject->ArticleWriteAttachment(
                    %{$Attachment},
					TicketID  => $Self->{TicketID},
                    ArticleID => $ArticleID,
                    UserID    => $Self->{UserID},
                );
            }

            # remove pre submitted attachments
            $UploadCacheObject->FormIDRemove( FormID => $Self->{FormID} );
        }

        # set dynamic fields
        # cycle through the activated Dynamic Fields for this screen
        DYNAMICFIELD:
        for my $DynamicFieldConfig ( @{ $Self->{DynamicField} } ) {
            next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);
 
            # set the object ID (TicketID or ArticleID) depending on the field configration
            my $ObjectID;
            if ($DynamicFieldConfig->{ObjectType} eq 'Ticket') {
				$ObjectID = $Self->{TicketID};
			} else {
				$ObjectID = $ArticleID;
			}
                

            # set the value
        	my $ValueBeforeChange = $DynamicFieldBackendObject->ValueGet(
		   		DynamicFieldConfig => $DynamicFieldConfig,      # complete config of the DynamicField
		        ObjectID           => $ObjectID,                # ID of the current object that the field
                                                        # must be linked to, e. g. TicketID
            );
			
            my $Success = $DynamicFieldBackendObject->ValueSet(
                DynamicFieldConfig => $DynamicFieldConfig,
                ObjectID           => $ObjectID,
                Value              => $DynamicFieldValues{ $DynamicFieldConfig->{Name} },
                UserID             => $Self->{UserID},
            );
			my $SuccessHistory = $TicketObject->HistoryAdd(
		        Name         => "DynamicField_" .$DynamicFieldConfig->{Name}. ": $ValueBeforeChange value changed to $DynamicFieldValues{ $DynamicFieldConfig->{Name} }",
		        HistoryType  => 'TicketDynamicFieldUpdate', # see system tables
		        TicketID     => $Self->{TicketID},
		        ArticleID    => $ArticleID , # not required!
		        CreateUserID =>  $Self->{UserID},
		    );
        }

        # set priority
        if ( $Self->{Config}->{Priority} && $GetParam{NewPriorityID} ) {
            $TicketObject->TicketPrioritySet(
                TicketID   => $Self->{TicketID},
                PriorityID => $GetParam{NewPriorityID},
                UserID     => $Self->{UserID},
            );
        }

        # load new URL in parent window and close popup
        return $LayoutObject->PopupClose(
            URL => "Action=AgentTicketZoom;TicketID=$Self->{TicketID};ArticleID=$ArticleID",
        );
    }
    elsif ( $Self->{Subaction} eq 'AJAXUpdate' ) {
        my %Ticket = $TicketObject->TicketGet( TicketID => $Self->{TicketID} );
        my $CustomerUser = $Ticket{CustomerUserID};

        my $ServiceID;

        # get service value from param if field is visible in the screen
        if ( $ConfigObject->Get('Ticket::Service') && $Self->{Config}->{Service} ) {
            $ServiceID = $GetParam{ServiceID} || '';
        }

        # otherwise use ticket service value since it can't be changed
        elsif ( $ConfigObject->Get('Ticket::Service') ) {
            $ServiceID = $Ticket{ServiceID} || '';
        }

        my $QueueID = $GetParam{NewQueueID} || $Ticket{QueueID};

        # convert dynamic field values into a structure for ACLs
        my %DynamicFieldACLParameters;
        DYNAMICFIELD:
        for my $DynamicField ( sort keys %DynamicFieldValues ) {
            next DYNAMICFIELD if !$DynamicField;
            next DYNAMICFIELD if !$DynamicFieldValues{$DynamicField};

            $DynamicFieldACLParameters{ 'DynamicField_' . $DynamicField }
                = $DynamicFieldValues{$DynamicField};
        }

        # get list type
        my $TreeView = 0;
        if ( $ConfigObject->Get('Ticket::Frontend::ListType') eq 'tree' ) {
            $TreeView = 1;
        }

        my $Owners = $Self->_GetOwners(
            %GetParam,
            QueueID  => $QueueID,
            AllUsers => $GetParam{OwnerAll},
        );
        my $OldOwners = $Self->_GetOldOwners(
            %GetParam,
            QueueID  => $QueueID,
            AllUsers => $GetParam{OwnerAll},
        );
        my $ResponsibleUsers = $Self->_GetResponsible(
            %GetParam,
            QueueID  => $QueueID,
            AllUsers => $GetParam{OwnerAll},
        );
        my $Priorities = $Self->_GetPriorities(
            %GetParam,
        );
        my $Services = $Self->_GetServices(
            %GetParam,
            CustomerUserID => $CustomerUser,
            QueueID        => $QueueID,
        );

        # reset previous ServiceID to reset SLA-List if no service is selected
        if ( !defined $ServiceID || !$Services->{$ServiceID} ) {
            $ServiceID = '';
        }
        my $SLAs = $Self->_GetSLAs(
            %GetParam,
            CustomerUserID => $CustomerUser,
            QueueID        => $QueueID,
            ServiceID      => $ServiceID,
        );
#        my $NextStates = $Self->_GetNextStates(
#            %GetParam,
#            CustomerUserID => $CustomerUser || '',
#            QueueID => $QueueID,
#        );

        # update Dynamic Fields Possible Values via AJAX
        my @DynamicFieldAJAX;

        # cycle trough the activated Dynamic Fields for this screen
        DYNAMICFIELD:
        for my $DynamicFieldConfig ( @{ $Self->{DynamicField} } ) {
            next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

            my $IsACLReducible = $DynamicFieldBackendObject->HasBehavior(
                DynamicFieldConfig => $DynamicFieldConfig,
                Behavior           => 'IsACLReducible',
            );
            next DYNAMICFIELD if !$IsACLReducible;

            my $PossibleValues = $DynamicFieldBackendObject->PossibleValuesGet(
                DynamicFieldConfig => $DynamicFieldConfig,
            );

            # convert possible values key => value to key => key for ACLs using a Hash slice
            my %AclData = %{$PossibleValues};
            @AclData{ keys %AclData } = keys %AclData;

            # set possible values filter from ACLs
            my $ACL = $TicketObject->TicketAcl(
                %GetParam,
                #~ %ACLCompatGetParam,
                CustomerUserID => $CustomerUser || '',
                Action         => $Self->{Action},
                QueueID        => $QueueID      || 0,
                ReturnType     => 'Ticket',
                ReturnSubType  => 'DynamicField_' . $DynamicFieldConfig->{Name},
                Data           => \%AclData,
                UserID         => $Self->{UserID},
            );
            if ($ACL) {
                my %Filter = $TicketObject->TicketAclData();

                # convert Filer key => key back to key => value using map
                %{$PossibleValues} = map { $_ => $PossibleValues->{$_} } keys %Filter;
            }

            my $DataValues = $DynamicFieldBackendObject->BuildSelectionDataGet(
                DynamicFieldConfig => $DynamicFieldConfig,
                PossibleValues     => $PossibleValues,
                Value              => $DynamicFieldValues{ $DynamicFieldConfig->{Name} },
            ) || $PossibleValues;

            # add dynamic field to the list of fields to update
            push(
                @DynamicFieldAJAX,
                {
                    Name        => 'DynamicField_' . $DynamicFieldConfig->{Name},
                    Data        => $DataValues,
                    SelectedID  => $DynamicFieldValues{ $DynamicFieldConfig->{Name} },
                    Translation => $DynamicFieldConfig->{Config}->{TranslatableValues} || 0,
                    Max         => 100,
                }
            );
        }

        my $JSON = $LayoutObject->BuildSelectionJSON(
            [

                {
                    Name         => 'NewOwnerID',
                    Data         => $Owners,
                    SelectedID   => $GetParam{NewOwnerID},
                    Translation  => 0,
                    PossibleNone => 1,
                    Max          => 100,
                },
                {
                    Name         => 'OldOwnerID',
                    Data         => $OldOwners,
                    SelectedID   => $GetParam{OldOwnerID},
                    Translation  => 0,
                    PossibleNone => 1,
                    Max          => 100,
                },
                {
                    Name         => 'NewResponsibleID',
                    Data         => $ResponsibleUsers,
                    SelectedID   => $GetParam{NewResponsibleID},
                    Translation  => 0,
                    PossibleNone => 1,
                    Max          => 100,
                },
#                {
#                    Name         => 'NewStateID',
#                    Data         => $NextStates,
#                    SelectedID   => $GetParam{NewStateID},
#                    Translation  => 1,
#                    PossibleNone => $Self->{Config}->{StateDefault} ? 0 : 1,
#                    Max          => 100,
#                },
                {
                    Name         => 'NewPriorityID',
                    Data         => $Priorities,
                    SelectedID   => $GetParam{NewPriorityID},
                    PossibleNone => 0,
                    Translation  => 1,
                    Max          => 100,
                },
                {
                    Name         => 'ServiceID',
                    Data         => $Services,
                    SelectedID   => $GetParam{ServiceID},
                    PossibleNone => 1,
                    Translation  => 0,
                    TreeView     => $TreeView,
                    Max          => 100,
                },
                {
                    Name         => 'SLAID',
                    Data         => $SLAs,
                    SelectedID   => $GetParam{SLAID},
                    PossibleNone => 1,
                    Translation  => 0,
                    Max          => 100,
                },
                @DynamicFieldAJAX,
            ],
        );
        return $LayoutObject->Attachment(
            ContentType => 'application/json; charset=' . $LayoutObject->{Charset},
            Content     => $JSON,
            Type        => 'inline',
            NoCache     => 1,
        );
    }
    else {

        # fillup configured default vars
        if ( !defined $GetParam{Body} && $Self->{Config}->{Body} ) {
            $GetParam{Body} = $LayoutObject->Output(
                Template => $Self->{Config}->{Body},
            );

            # make sure body is rich text
            if ( $LayoutObject->{BrowserRichText} ) {
                $GetParam{Body} = $LayoutObject->Ascii2RichText(
                    String => $GetParam{Body},
                );
            }
        }
        if ( !defined $GetParam{Subject} && $Self->{Config}->{Subject} ) {
            $GetParam{Subject} = $LayoutObject->Output(
                Template => $Self->{Config}->{Subject},
            );
        }

        # create html strings for all dynamic fields
        my %DynamicFieldHTML;

        # cycle trough the activated Dynamic Fields for this screen
        DYNAMICFIELD:
        for my $DynamicFieldConfig ( @{ $Self->{DynamicField} } ) {
            next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

            my $PossibleValuesFilter;

            # check if field has PossibleValues property in its configuration
            if ( IsHashRefWithData( $DynamicFieldConfig->{Config}->{PossibleValues} ) ) {

                # convert possible values key => value to key => key for ACLs usign a Hash slice
                my %AclData = %{ $DynamicFieldConfig->{Config}->{PossibleValues} };
                @AclData{ keys %AclData } = keys %AclData;

                # set possible values filter from ACLs
                my $ACL = $TicketObject->TicketAcl(
                    %GetParam,
                    Action        => $Self->{Action},
                    TicketID      => $Self->{TicketID},
                    ReturnType    => 'Ticket',
                    ReturnSubType => 'DynamicField_' . $DynamicFieldConfig->{Name},
                    Data          => \%AclData,
                    UserID        => $Self->{UserID},
                );
                if ($ACL) {
                    my %Filter = $TicketObject->TicketAclData();

                    # convert Filer key => key back to key => value using map
                    %{$PossibleValuesFilter}
                        = map { $_ => $DynamicFieldConfig->{Config}->{PossibleValues}->{$_} }
                        keys %Filter;
                }
            }

            # to store dynamic field value from database (or undefined)
            my $Value;

            # COMPLEMENTO
            # only get values for Ticket fields (all screens based on AgentTickeActionCommon
            # generates a new article, then article fields will be always empty at the beginning)
#            if ( $DynamicFieldConfig->{ObjectType} eq 'Ticket' ) {

#                # get value stored on the database from Ticket
#                $Value = $Ticket{ 'DynamicField_' . $DynamicFieldConfig->{Name} };
#            };
                $Value = $Article{ 'DynamicField_' . $DynamicFieldConfig->{Name} };
            #EO COmplemento
            
            # get field html
            $DynamicFieldHTML{ $DynamicFieldConfig->{Name} } =
                $DynamicFieldBackendObject->EditFieldRender(
                DynamicFieldConfig   => $DynamicFieldConfig,
                PossibleValuesFilter => $PossibleValuesFilter,
                Value                => $Value,
                Mandatory =>
                    $Self->{Config}->{DynamicField}->{ $DynamicFieldConfig->{Name} } == 2,
                LayoutObject    => $LayoutObject,
                ParamObject     => $ParamObject,
                AJAXUpdate      => 1,
                UpdatableFields => $Self->_GetFieldsToUpdate(),
                );
        }

        # print form ...
        my $Output = $LayoutObject->Header(
            Type  => 'Small',
            Value => $Ticket{TicketNumber},
			BodyClass => 'Popup',

        );
        $Output .= $Self->_Mask(
            Attachments       => \@Attachments,
            %GetParam,
            %Ticket,
            DynamicFieldHTML => \%DynamicFieldHTML,
        );
        $Output .= $LayoutObject->Footer(
            Type => 'Small',
        );
        return $Output;
    }
}

sub _Mask {
    my ( $Self, %Param ) = @_;
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $ParamObject  = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $TicketObject 	  = $Kernel::OM->Get('Kernel::System::Ticket');
    my $UploadCacheObject  = $Kernel::OM->Get('Kernel::System::Web::UploadCache');
    my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');
    my $DynamicFieldBackendObject      = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');
    my $HTMLUtilsObject    = $Kernel::OM->Get('Kernel::System::HTMLUtils');
    my $ConfigObject	   = $Kernel::OM->Get('Kernel::Config');
    my $QueueObject 	   = $Kernel::OM->Get('Kernel::System::Queue');
    my $ServiceObject	   = $Kernel::OM->Get('Kernel::System::Service');
    my $UserObject	   = $Kernel::OM->Get('Kernel::System::User');
    my $GroupObject	   = $Kernel::OM->Get('Kernel::System::Group');
    # get list type
    my $TreeView = 0;
    if ( $ConfigObject->Get('Ticket::Frontend::ListType') eq 'tree' ) {
        $TreeView = 1;
    }
    my %Ticket = $TicketObject->TicketGet( TicketID => $Self->{TicketID} );

    if ( $Self->{Config}->{Title} ) {
        $LayoutObject->Block(
            Name => 'Title',
            Data => \%Param,
        );
    }

    my $DynamicFieldNames = $Self->_GetFieldsToUpdate(
        OnlyDynamicFields => 1,
    );

    # create a string with the quoted dynamic field names separated by a commas
    if ( IsArrayRefWithData($DynamicFieldNames) ) {
        my $FirstItem = 1;
        FIELD:
        for my $Field ( @{$DynamicFieldNames} ) {
            if ($FirstItem) {
                $FirstItem = 0;
            }
            else {
                $Param{DynamicFieldNamesStrg} .= ', ';
            }
            $Param{DynamicFieldNamesStrg} .= "'" . $Field . "'";
        }
    }

    # types
    if ( $ConfigObject->Get('Ticket::Type') && $Self->{Config}->{TicketType} ) {
        my %Type = $TicketObject->TicketTypeList(
            %Param,
            Action => $Self->{Action},
            UserID => $Self->{UserID},
        );
        $Param{TypeStrg} = $LayoutObject->BuildSelection(
            Class => 'Validate_Required' . ( $Param{Errors}->{TypeIDInvalid} || ' ' ),
            Data  => \%Type,
            Name  => 'TypeID',
            SelectedID   => $Param{TypeID},
            PossibleNone => 1,
            Sort         => 'AlphanumericValue',
            Translation  => 0,
        );
        $LayoutObject->Block(
            Name => 'Type',
            Data => {%Param},
        );
    }

    # services
    if ( $ConfigObject->Get('Ticket::Service') && $Self->{Config}->{Service} ) {

        my $Services = $Self->_GetServices(
            %Param,
            Action         => $Self->{Action},
            CustomerUserID => $Ticket{CustomerUserID},
            UserID         => $Self->{UserID},
        );

        # reset previous ServiceID to reset SLA-List if no service is selected
        if ( !$Param{ServiceID} || !$Services->{ $Param{ServiceID} } ) {
            $Param{ServiceID} = '';
        }

        $Param{ServiceStrg} = $LayoutObject->BuildSelection(
            Data         => $Services,
            Name         => 'ServiceID',
            SelectedID   => $Param{ServiceID},
            Class        =>  'Modernize ' . $Param{ServiceInvalid} || ' ',
            PossibleNone => 1,
            TreeView     => $TreeView,
            Sort         => 'TreeView',
            Translation  => 0,
            Max          => 200,
        );
	
        $LayoutObject->Block(
            Name => 'Service',
            Data => {%Param},
        );
        my %SLA = $TicketObject->TicketSLAList(
            %Param,
            Action => $Self->{Action},
            UserID => $Self->{UserID},
        );
        $Param{SLAStrg} = $LayoutObject->BuildSelection(
            Data         => \%SLA,
            Name         => 'SLAID',
            SelectedID   => $Param{SLAID},
            PossibleNone => 1,
            Sort         => 'AlphanumericValue',
            Translation  => 0,
            Max          => 200,
        );
        $LayoutObject->Block(
            Name => 'SLA',
            Data => {%Param},
        );
    }

    if ( $Self->{Config}->{Queue} ) {

        # fetch all queues
        my %MoveQueues = $TicketObject->TicketMoveList(
            TicketID => $Self->{TicketID},
            UserID   => $Self->{UserID},
            Action   => $Self->{Action},
            Type     => 'move_into',
        );

        # set move queues
        $Param{QueuesStrg} = $LayoutObject->AgentQueueListOption(
            Data => { %MoveQueues, '' => '-' },
            Multiple       => 0,
            Size           => 0,
            Class          => 'NewQueueID',
            Name           => 'NewQueueID',
            SelectedID     => $Param{NewQueueID},
            CurrentQueueID => $Param{QueueID},
            OnChangeSubmit => 0,
        );

        $LayoutObject->Block(
            Name => 'Queue',
            Data => {%Param},
        );
    }

    if ( $Self->{Config}->{Owner} ) {

        # get user of own groups
        my %ShownUsers;
        my %AllGroupsMembers = $UserObject->UserList(
            Type  => 'Long',
            Valid => 1,
        );
        if ( $ConfigObject->Get('Ticket::ChangeOwnerToEveryone') ) {
            %ShownUsers = %AllGroupsMembers;
        }
        else {
            my $GID = $QueueObject->GetQueueGroupID( QueueID => $Ticket{QueueID} );
            my %MemberList = $GroupObject->GroupMemberList(
                GroupID => $GID,
                Type    => 'owner',
                Result  => 'HASH',
                Cached  => 1,
            );
            for my $UserID ( sort keys %MemberList ) {
                $ShownUsers{$UserID} = $AllGroupsMembers{$UserID};
            }
        }

        # get old owner
        my @OldUserInfo = $TicketObject->TicketOwnerList( TicketID => $Self->{TicketID} );
        $Param{OwnerStrg} = $LayoutObject->BuildSelection(
            Data         => \%ShownUsers,
            SelectedID   => $Param{NewOwnerID},
            Name         => 'NewOwnerID',
            Class        => $Param{NewOwnerInvalid} || ' ',
            Size         => 1,
            PossibleNone => 1,
        );
        my %UserHash;
        if (@OldUserInfo) {
            my $Counter = 1;
            for my $User ( reverse @OldUserInfo ) {
                next if $UserHash{ $User->{UserID} };
                $UserHash{ $User->{UserID} } = "$Counter: $User->{UserLastname} "
                    . "$User->{UserFirstname} ($User->{UserLogin})";
                $Counter++;
            }
        }

        my $OldOwnerSelectedID = '';
        if ( $Param{OldOwnerID} ) {
            $OldOwnerSelectedID = $Param{OldOwnerID};
        }
        elsif ( $OldUserInfo[0]->{UserID} ) {
            $OldOwnerSelectedID = $OldUserInfo[0]->{UserID} . '1';
        }

        # build string
        $Param{OldOwnerStrg} = $LayoutObject->BuildSelection(
            Data         => \%UserHash,
            SelectedID   => $OldOwnerSelectedID,
            Name         => 'OldOwnerID',
            Class        => $Param{OldOwnerInvalid} || ' ',
            PossibleNone => 1,
        );
        if ( $Param{NewOwnerType} && $Param{NewOwnerType} eq 'Old' ) {
            $Param{'NewOwnerType::Old'} = 'checked = "checked"';
        }
        else {
            $Param{'NewOwnerType::New'} = 'checked = "checked"';
        }

        $LayoutObject->Block(
            Name => 'Owner',
            Data => \%Param,
        );
    }
    if ( $ConfigObject->Get('Ticket::Responsible') && $Self->{Config}->{Responsible} ) {
	
        # get user of own groups
        my %ShownUsers;
        my %AllGroupsMembers = $UserObject->UserList(
            Type  => 'Long',
            Valid => 1,
        );
        if ( $ConfigObject->Get('Ticket::ChangeOwnerToEveryone') ) {
            %ShownUsers = %AllGroupsMembers;
        }
        else {
            my $GID = $QueueObject->GetQueueGroupID( QueueID => $Ticket{QueueID} );
            my %MemberList = $GroupObject->GroupMemberList(
                GroupID => $GID,
                Type    => 'responsible',
                Result  => 'HASH',
                Cached  => 1,
            );
            for my $UserID ( sort keys %MemberList ) {
                $ShownUsers{$UserID} = $AllGroupsMembers{$UserID};
            }
        }

        # get responsible
        $Param{ResponsibleStrg} = $LayoutObject->BuildSelection(
            Data         => \%ShownUsers,
            SelectedID   => $Param{NewResponsibleID},
            Name         => 'NewResponsibleID',
            PossibleNone => 1,
            Size         => 1,
        );
        $LayoutObject->Block(
            Name => 'Responsible',
            Data => \%Param,
        );
    }

    # get priority
    if ( $Self->{Config}->{Priority} ) {
        my %Priority;
        my %PriorityList = $TicketObject->TicketPriorityList(
            UserID   => $Self->{UserID},
            TicketID => $Self->{TicketID},
        );
        if ( !$Self->{Config}->{PriorityDefault} ) {
            $PriorityList{''} = '-';
        }
        if ( !$Param{NewPriorityID} ) {
            if ( $Self->{Config}->{PriorityDefault} ) {
                $Priority{SelectedValue} = $Self->{Config}->{PriorityDefault};
            }
        }
        else {
            $Priority{SelectedID} = $Param{NewPriorityID};
        }
        $Priority{SelectedID} ||= $Param{PriorityID};
        $Param{PriorityStrg} = $LayoutObject->BuildSelection(
            Data => \%PriorityList,
            Name => 'NewPriorityID',
            %Priority,
        );
        $LayoutObject->Block(
            Name => 'Priority',
            Data => \%Param,
        );
    }

    if ( $Self->{Config}->{Note} ) {
        $LayoutObject->Block(
            Name => 'Note',
            Data => {%Param},
        );

        # add rich text editor
        if ( $LayoutObject->{BrowserRichText} ) {

            # use height/width defined for this screen
            $Param{RichTextHeight} = $Self->{Config}->{RichTextHeight} || 0;
            $Param{RichTextWidth}  = $Self->{Config}->{RichTextWidth}  || 0;

            $LayoutObject->Block(
                Name => 'RichText',
                Data => \%Param, 
            );
        }

        # agent list
        if ( $Self->{Config}->{InformAgent} ) {
            my %ShownUsers;
            my %AllGroupsMembers = $UserObject->UserList(
                Type  => 'Long',
                Valid => 1,
            );
            my $GID = $QueueObject->GetQueueGroupID( QueueID => $Ticket{QueueID} );
            my %MemberList = $GroupObject->GroupMemberList(
                GroupID => $GID,
                Type    => 'note',
                Result  => 'HASH',
                Cached  => 1,
            );
            for my $UserID ( sort keys %MemberList ) {
                $ShownUsers{$UserID} = $AllGroupsMembers{$UserID};
            }
            my $InformAgentSize = $ConfigObject->Get('Ticket::Frontend::InformAgentMaxSize')
                || 3;
            $Param{OptionStrg} = $LayoutObject->BuildSelection(
                Data       => \%ShownUsers,
                SelectedID => $Self->{InformUserID},
                Name       => 'InformUserID',
                Multiple   => 1,
                Size       => $InformAgentSize,
            );
            $LayoutObject->Block(
                Name => 'InformAgent',
                Data => \%Param,
            );
        }

        # get involved
        if ( $Self->{Config}->{InvolvedAgent} ) {

            my @UserIDs = $TicketObject->TicketInvolvedAgentsList(
                TicketID => $Self->{TicketID},
            );

            my %UserHash;
            my $Counter = 1;

            USER:
            for my $User ( reverse @UserIDs ) {

                next USER if $UserHash{ $User->{UserID} };

                $UserHash{ $User->{UserID} }
                    = "$Counter: $User->{UserLastname} $User->{UserFirstname} ($User->{UserLogin})";
            }
            continue {
                $Counter++;
            }

            my $InvolvedAgentSize
                = $ConfigObject->Get('Ticket::Frontend::InvolvedAgentMaxSize') || 3;
            $Param{InvolvedAgentStrg} = $LayoutObject->BuildSelection(
                Data       => \%UserHash,
                SelectedID => $Self->{InvolvedUserID},
                Name       => 'InvolvedUserID',
                Multiple   => 1,
                Size       => $InvolvedAgentSize,
            );
            $LayoutObject->Block(
                Name => 'InvolvedAgent',
                Data => \%Param,
            );
        }

        # show spell check
        if ( $LayoutObject->{BrowserSpellChecker} ) {
            $LayoutObject->Block(
                Name => 'TicketOptions',
            );
            $LayoutObject->Block(
                Name => 'SpellCheck',
            );
        }


        # show attachments
        ATTACHMENT:
        for my $Attachment ( @{ $Param{Attachments} } ) {
            next ATTACHMENT if $Attachment->{ContentID} && $LayoutObject->{BrowserRichText};

            $LayoutObject->Block(
                Name => 'Attachment',
                Data => $Attachment,
            );
        }

        # build IsVisibleForCustomer string

        #~ if ( !$Param{IsVisibleForCustomer} ) {
            #~ $ArticleType{SelectedValue} = $Self->{Config}->{ArticleTypeDefault};
        #~ }
        #~ else {
            #~ $ArticleType{SelectedID} = $Param{IsVisibleForCustomer};
        #~ }

        # get possible notes
        #~ if ( $Self->{Config}->{ArticleTypes} ) {
            #~ my %DefaultNoteTypes = %{ $Self->{Config}->{ArticleTypes} };
            #~ my %NoteTypes = $TicketObject->ArticleTypeList( Result => 'HASH' );
            #~ for my $KeyNoteType ( sort keys %NoteTypes ) {
                #~ if ( !$DefaultNoteTypes{ $NoteTypes{$KeyNoteType} } ) {
                    #~ delete $NoteTypes{$KeyNoteType};
                #~ }
            #~ }


            #~ $LayoutObject->Block(
                #~ Name => 'ArticleType',
                #~ Data => \%Param,
            #~ );
        #~ }

        # show time accounting box
#        if ( $ConfigObject->Get('Ticket::Frontend::AccountTime') ) {
#            if ( $ConfigObject->Get('Ticket::Frontend::NeedAccountedTime') ) {
#                $LayoutObject->Block(
#                    Name => 'TimeUnitsLabelMandatory',
#                    Data => \%Param,
#                );
#            }
#            else {
#                $LayoutObject->Block(
#                    Name => 'TimeUnitsLabel',
#                    Data => \%Param,
#                );
#            }
#            $LayoutObject->Block(
#                Name => 'TimeUnits',
#                Data => \%Param,
#            );
#        }
    }

    # Dynamic fields
    # cycle trough the activated Dynamic Fields for this screen
    DYNAMICFIELD:
    for my $DynamicFieldConfig ( @{ $Self->{DynamicField} } ) {

        next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

        # skip fields that HTML could not be retrieved
        next DYNAMICFIELD if !IsHashRefWithData(
            $Param{DynamicFieldHTML}->{ $DynamicFieldConfig->{Name} }
        );

        # get the html strings form $Param
        my $DynamicFieldHTML = $Param{DynamicFieldHTML}->{ $DynamicFieldConfig->{Name} };

        $LayoutObject->Block(
            Name => 'DynamicField',
            Data => {
                Name  => $DynamicFieldConfig->{Name},
                Label => $DynamicFieldHTML->{Label},
                Field => $DynamicFieldHTML->{Field},
            },
        );

        # example of dynamic fields order customization
        $LayoutObject->Block(
            Name => 'DynamicField_' . $DynamicFieldConfig->{Name},
            Data => {
                Name  => $DynamicFieldConfig->{Name},
                Label => $DynamicFieldHTML->{Label},
                Field => $DynamicFieldHTML->{Field},
            },
        );
    }


    # get output back
    return $LayoutObject->Output( TemplateFile => $Self->{Action}, Data => \%Param );
}

#sub _GetNextStates {
#    my ( $Self, %Param ) = @_;

#    my %NextStates = $TicketObject->TicketStateList(
#        TicketID => $Self->{TicketID},
#        Action   => $Self->{Action},
#        UserID   => $Self->{UserID},
#        %Param,
#    );

#    return \%NextStates;
#}

sub _GetResponsible {
my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $ParamObject  = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $UserObject   = $Kernel::OM->Get('Kernel::System::User');
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');
    my $ConfigObject	   = $Kernel::OM->Get('Kernel::Config');
    my $QueueObject 	   = $Kernel::OM->Get('Kernel::System::Queue');
    my $ServiceObject	   = $Kernel::OM->Get('Kernel::System::Service');
    my $GroupObject	   = $Kernel::OM->Get('Kernel::System::Group');
    my ( $Self, %Param ) = @_;
    my %ShownUsers;
    my %AllGroupsMembers = $UserObject->UserList(
        Type  => 'Long',
        Valid => 1,
    );

    # show all users
    if ( $ConfigObject->Get('Ticket::ChangeOwnerToEveryone') ) {
        %ShownUsers = %AllGroupsMembers;
    }

    # show only users with responsible or rw pemissions in the queue
    elsif ( $Param{QueueID} && !$Param{AllUsers} ) {
        my $GID = $QueueObject->GetQueueGroupID(
            QueueID => $Param{NewQueueID} || $Param{QueueID}
        );
        my %MemberList = $GroupObject->GroupMemberList(
            GroupID => $GID,
            Type    => 'responsible',
            Result  => 'HASH',
            Cached  => 1,
        );
        for my $UserID ( sort keys %MemberList ) {
            $ShownUsers{$UserID} = $AllGroupsMembers{$UserID};
        }
    }

    # workflow
    my $ACL = $TicketObject->TicketAcl(
        %Param,
        ReturnType    => 'Ticket',
        ReturnSubType => 'Responsible',
        Data          => \%ShownUsers,
        UserID        => $Self->{UserID},
    );

    return { $TicketObject->TicketAclData() } if $ACL;

    return \%ShownUsers;
}

sub _GetOwners {
    my $ParamObject  = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $UserObject   = $Kernel::OM->Get('Kernel::System::User');
    my $ConfigObject	   = $Kernel::OM->Get('Kernel::Config');
    my $ServiceObject	   = $Kernel::OM->Get('Kernel::System::Service');
    my $QueueObject 	   = $Kernel::OM->Get('Kernel::System::Queue');
    my $TicketObject        =  $Kernel::OM->Get('Kernel::System::Ticket');
 my $GroupObject	   = $Kernel::OM->Get('Kernel::System::Group');
    my ( $Self, %Param ) = @_;
    my %ShownUsers;
    my %AllGroupsMembers = $UserObject->UserList(
        Type  => 'Long',
        Valid => 1,
    );

    # show all users
    if ( $ConfigObject->Get('Ticket::ChangeOwnerToEveryone') ) {
        %ShownUsers = %AllGroupsMembers;
    }

    # show only users with owner or rw pemissions in the queue
    elsif ( $Param{QueueID} && !$Param{AllUsers} ) {
        my $GID = $QueueObject->GetQueueGroupID(
            QueueID => $Param{NewQueueID} || $Param{QueueID}
        );
        my %MemberList = $GroupObject->GroupMemberList(
            GroupID => $GID,
            Type    => 'owner',
            Result  => 'HASH',
            Cached  => 1,
        );
        for my $UserID ( sort keys %MemberList ) {
            $ShownUsers{$UserID} = $AllGroupsMembers{$UserID};
        }
    }

    # workflow
    my $ACL = $TicketObject->TicketAcl(
        %Param,
        ReturnType    => 'Ticket',
        ReturnSubType => 'NewOwner',
        Data          => \%ShownUsers,
        UserID        => $Self->{UserID},
    );

    return { $TicketObject->TicketAclData() } if $ACL;

    return \%ShownUsers;
}

sub _GetOldOwners {
    my ( $Self, %Param ) = @_;
    my $TicketObject = $Kernel::OM->Get("Kernel::System::Ticket");
    my @OldUserInfo = $TicketObject->TicketOwnerList( TicketID => $Self->{TicketID} );
    my %UserHash;
    if (@OldUserInfo) {
        my $Counter = 1;
        USER:
        for my $User ( reverse @OldUserInfo ) {

            next USER if $UserHash{ $User->{UserID} };

            $UserHash{ $User->{UserID} }
                = "$Counter: $User->{UserLastname} $User->{UserFirstname} ($User->{UserLogin})";
        }
        continue {
            $Counter++;
        }
    }

    # workflow
    my $ACL = $TicketObject->TicketAcl(
        %Param,
        ReturnType    => 'Ticket',
        ReturnSubType => 'OldOwner',
        Data          => \%UserHash,
        UserID        => $Self->{UserID},
    );

    return { $TicketObject->TicketAclData() } if $ACL;

    return \%UserHash;
}

sub _GetServices {
    my ( $Self, %Param ) = @_;
    my $TicketObject = $Kernel::OM->Get("Kernel::System::Ticket");
    my $ConfigObject = $Kernel::OM->Get("Kernel::Config");
    # get service
    my %Service;

    # get options for default services for unknown customers
    my $DefaultServiceUnknownCustomer
        = $ConfigObject->Get('Ticket::Service::Default::UnknownCustomer');

    # check if no CustomerUserID is selected
    # if $DefaultServiceUnknownCustomer = 0 leave CustomerUserID empty, it will not get any services
    # if $DefaultServiceUnknownCustomer = 1 set CustomerUserID to get default services
    if ( !$Param{CustomerUserID} && $DefaultServiceUnknownCustomer ) {
        $Param{CustomerUserID} = '<DEFAULT>';
    }

    # get service list
    if ( $Param{CustomerUserID} ) {
        %Service = $TicketObject->TicketServiceList(
            %Param,
            Action => $Self->{Action},
            UserID => $Self->{UserID},
        );
    }
    return \%Service;
}

sub _GetSLAs {
    my ( $Self, %Param ) = @_;
    my $TicketObject = $Kernel::OM->Get("Kernel::System::Ticket");
    my %SLA;
    if ( $Param{ServiceID} ) {
        %SLA = $TicketObject->TicketSLAList(
            %Param,
            Action => $Self->{Action},
        );
    }
    return \%SLA;
}

sub _GetPriorities {
    my ( $Self, %Param ) = @_;
    my $TicketObject = $Kernel::OM->Get("Kernel::System::Ticket");
    my %Priorities = $TicketObject->TicketPriorityList(
        %Param,
        Action   => $Self->{Action},
        UserID   => $Self->{UserID},
        TicketID => $Self->{TicketID},
    );
    if ( !$Self->{Config}->{PriorityDefault} ) {
        $Priorities{''} = '-';
    }
    return \%Priorities;
}

sub _GetFieldsToUpdate {
    my ( $Self, %Param ) = @_;
 my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');
     my $DynamicFieldBackendObject      = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');
    my @UpdatableFields;

    # set the fields that can be updateable via AJAXUpdate
#    if ( !$Param{OnlyDynamicFields} ) {
#        @UpdatableFields
#            = qw(
#            TypeID ServiceID SLAID NewOwnerID OldOwnerID NewResponsibleID 
#            NewPriorityID
#        );
#    }

    # cycle through the activated Dynamic Fields for this screen
    DYNAMICFIELD:
    for my $DynamicFieldConfig ( @{ $Self->{DynamicField} } ) {
        next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);
		my $Updateable = $DynamicFieldBackendObject->HasBehavior(  DynamicFieldConfig => $DynamicFieldConfig,       # complete config of the DynamicField
       Behavior           => 'IsACLReducible',           # 'IsACLReducible' to be reduded by ACLs
                                                        #    and updatable via AJAX
                                                        # 'IsNotificationEventCondition' to be used
                                                        #     in the notification events as a
                                                        #     ticket condition
                                                        # 'IsSortable' to sort by this field in
                                                        #     "Small" overviews
                                                        # 'IsStatsCondition' to be used in
                                                        #     Statistics as a condition
                                                        # 'IsCustomerInterfaceCapable' to make
                                                        #     the field usable in the customer
                                                        #     interface
   );

        next DYNAMICFIELD if !$Updateable;
        push @UpdatableFields, 'DynamicField_' . $DynamicFieldConfig->{Name};
    }

    return \@UpdatableFields;
}

1;
