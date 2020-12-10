# --
# Copyright (C) 2001-2017 Complemento, http://complemento.net.br/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Ticket::Event::NotificationEvent::Transport::SmsNotify;
## nofilter(TidyAll::Plugin::OTRS::Perl::LayoutObject)
## nofilter(TidyAll::Plugin::OTRS::Perl::ParamObject)

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);
use Kernel::Language qw(Translatable);

use base qw(Kernel::System::Ticket::Event::NotificationEvent::Transport::Email);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::Output::HTML::Layout',
    'Kernel::System::CustomerUser',
    'Kernel::System::Email',
    'Kernel::System::Log',
    'Kernel::System::Main',
    'Kernel::System::Queue',
    'Kernel::System::SystemAddress',
    'Kernel::System::Ticket',
    'Kernel::System::User',
    'Kernel::System::Web::Request',
    'Kernel::System::Crypt::PGP',
    'Kernel::System::Crypt::SMIME',
    'Kernel::System::DynamicField',
    'Kernel::System::DynamicField::Backend',
);

=head1 NAME

Kernel::System::Ticket::Event::NotificationEvent::Transport::SmsNotify - sms transport layer

=head1 SYNOPSIS

Notification event transport layer.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create a notification transport object. Do not use it directly, instead use:

    use Kernel::System::ObjectManager;
    local $Kernel::OM = Kernel::System::ObjectManager->new('');
    my $TransportObject = $Kernel::OM->Get('Kernel::System::Ticket::Event::NotificationEvent::Transport::SmsNotify');

=cut

#sub new {
    #my ( $Type, %Param ) = @_;

    ## allocate new hash for object
    #my $Self = {};
    #bless( $Self, $Type );

    #return $Self;
#}

sub SendNotification {
    my ( $Self, %Param ) = @_;

    

    # check needed stuff
    for my $Needed (qw(TicketID UserID Notification Recipient)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => 'Need $Needed!',
            );
            return;
        }
    }

    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');
    my %Ticket = $TicketObject->TicketGet(
        TicketID      => $Param{TicketID},
        DynamicFields => 1,         # Optional, default 0. To include the dynamic field values for this ticket on the return structure.
        UserID        => 1,
    );
    
    #for my $Needed (qw(TicketNumber DynamicField_IdKaizala DynamicField_TelefoneKaizala)){
    #    if(!$Param{$Needed}) {
    #        return;
    #    }
    #}
    #$Ticket{TicketNumber}
    #$Ticket{DynamicField_IdKaizala}
    #$Ticket{DynamicField_TelefoneKaizala}

    #my @ArticleIDs = $TicketObject->ArticleIndex(
    #    TicketID => $Param{TicketID},
    #);

    #my %Article = $TicketObject->ArticleGet(
    #    ArticleID     => @ArticleIDs[scalar(@ArticleIDs)-1],
    #    UserID        => 1,
    #);
    my $ArticleObject = $Kernel::OM->Get('Kernel::System::Ticket::Article');
    my @Articles      = $ArticleObject->ArticleList( TicketID => $Param{TicketID}, OnlyLast => 1 );
    my %Article       = $ArticleObject->BackendForArticle( %{$Articles[0]} )->ArticleGet( %{$Articles[0]} );

    #$Article{Subject}

    # cleanup event data
    $Self->{EventData} = undef;

    # get needed objects
    my $ConfigObject        = $Kernel::OM->Get('Kernel::Config');
    my $SystemAddressObject = $Kernel::OM->Get('Kernel::System::SystemAddress');
    my $LayoutObject        = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # get recipient data
    my %Recipient = %{ $Param{Recipient} };

    # Verify a customer have an Mobile
    if ( $Recipient{Type} eq 'Customer' && $Recipient{UserID} && !$Recipient{UserMobile} ) {

        my %CustomerUser = $Kernel::OM->Get('Kernel::System::CustomerUser')->CustomerUserDataGet(
            User => $Recipient{UserID},
        );

        if ( !$CustomerUser{UserMobile} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'info',
                Message  => "Send no customer notification because of missing "
                    . "customer mobile!",
            );
            return;
        }

        # Set calculated mobile.
        $Recipient{UserMobile} = $CustomerUser{UserMobile};
    }

    return if !$Recipient{UserMobile};

    # create new array to prevent attachment growth (see bug#5114)
    #my @Attachments = @{ $Param{Attachments} };

    my %Notification = %{ $Param{Notification} };

	my %Gws;
	if ( ref $ConfigObject->Get('SmsNotify::Gateway') eq 'HASH' ) {
		%Gws = %{ $ConfigObject->Get('SmsNotify::Gateway') };
	} else {
		$Self->{LogObject}->Log(
			 Priority => 'notice',
			 Message  => "Can't get SMS Gateways information",
		);
	}
	my %GatewayData = %{$Gws{$Notification{Data}->{RecipientGateway}->[0]}};
	
    # send notification
    if ( $Recipient{Type} eq 'Agent' ) {

        # send notification
		my $Sent = $Self->_SendSms(
						Gateway    => \%GatewayData,
						To         => $Recipient{UserMobile},
						Body       => $Notification{Body},
                        TicketID   => $Param{TicketID},
						);

        if ( !$Sent ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "'$Notification{Name}' notification could not be sent to agent '$Recipient{UserMobile} ",
            );
            return;
        }

        # log event
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'info',
            Message  => "Sent agent '$Notification{Name}' notification to '$Recipient{UserMobile}'.",
        );

        # set event data
        $Self->{EventData} = {
            Event => 'ArticleAgentNotification',
            Data  => {
                TicketID => $Param{TicketID},
            },
            UserID => $Param{UserID},
        };
    }
    else { # If it's not agent
		
        # get queue object
        my $QueueObject = $Kernel::OM->Get('Kernel::System::Queue');

        my $QueueID;

        # get article
        my %Article = $TicketObject->ArticleLastCustomerArticle(
            TicketID      => $Param{TicketID},
            DynamicFields => 0,
        );

        # set "From" address from Article if exist, otherwise use ticket information, see bug# 9035
        if (%Article) {
            $QueueID = $Article{QueueID};
        }
        else {
            # get ticket data
            my %Ticket = $TicketObject->TicketGet(
                TicketID => $Param{TicketID},
            );
            $QueueID = $Ticket{QueueID};
        }
        my %Address = $QueueObject->GetSystemAddress( QueueID => $QueueID );

        # get queue
        my %Queue = $QueueObject->QueueGet(
            ID => $QueueID,
        );

        my $ArticleType = 'sms';

        if ( IsArrayRefWithData( $Param{Notification}->{Data}->{NotificationArticleTypeID} ) ) {

            # get notification article type
            $ArticleType = $TicketObject->ArticleTypeLookup(
                ArticleTypeID => $Param{Notification}->{Data}->{NotificationArticleTypeID}->[0],
            );
        }
        
		my $Sent = $Self->_SendSms(
				Gateway    => \%GatewayData,
				To         => $Recipient{UserMobile},
				Body       => $Notification{Body},
                TicketID   => $Param{TicketID},
			);

        if ( !$Sent ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "'$Notification{Name}' notification could not be sent to agent '$Recipient{UserMobile} ",
            );
            return;
        }

        # log event
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'info',
            Message  => "Sent agent '$Notification{Name}' notification to '$Recipient{UserMobile}'.",
        );
        
		## Store sms as an Article (use ArticleCreate instead of ArticleSend)?
        my $ArticleID = $TicketObject->ArticleCreate(
            ArticleType    => $ArticleType,
            SenderType     => 'system',
            TicketID       => $Param{TicketID},
            HistoryType    => 'SendCustomerNotification',
            HistoryComment => "\%\%$Recipient{UserMobile}",
            From           => "$Address{RealName} <$Address{Email}>",
            To             => $Recipient{UserMobile},
            Subject        => $Notification{Subject},
            Body           => $Notification{Body},
            MimeType       => $Notification{ContentType},
            Type           => $Notification{ContentType},
            Charset        => 'utf-8',
            UserID         => $Param{UserID},
            Loop           => 1,
            #Attachment     => $Param{Attachments},
        );

        # write history
        $TicketObject->HistoryAdd(
            TicketID     => $Param{TicketID},
            HistoryType  => 'SendCustomerNotification',
            Name         => "\%\%$Notification{Name}\%\%$Recipient{UserMobile}",
            CreateUserID => $Param{UserID},
        );

        if ( !$ArticleID ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "'$Notification{Name}' notification could not be sent to customer '$Recipient{UserMobile} ",
            );

            return;
        }

        # log event
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'info',
            Message  => "Sent customer '$Notification{Name}' notification to '$Recipient{UserMobile}'.",
        );

        # set event data
        $Self->{EventData} = {
            Event => 'ArticleCustomerNotification',
            Data  => {
                TicketID  => $Param{TicketID},
                ArticleID => $ArticleID,
            },
            UserID => $Param{UserID},
        };
    }

    return 1;
}

sub GetTransportRecipients {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(Notification)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed",
            );
        }
    }

    my @Recipients;

    # get recipients by RecipientMobile
    if ( $Param{Notification}->{Data}->{RecipientMobile} ) {
        if ( $Param{Notification}->{Data}->{RecipientMobile}->[0] ) {
            my $RecipientMobile = $Param{Notification}->{Data}->{RecipientMobile}->[0];

            # replace OTRSish attributes in recipient Mobile
            $RecipientMobile = $Self->_ReplaceTicketAttributes(
                Ticket => $Param{Ticket},
                Field  => $RecipientMobile,
            );

			my @MobileList = split /,/, $RecipientMobile;
			
			for my $Mob (@MobileList){
				my %Recipient;
				$Recipient{Realname}  = '';
				$Recipient{Type}      = 'Customer';
				$Recipient{UserMobile} = $Mob;

				# check if we have a specified article type
				if ( $Param{Notification}->{Data}->{NotificationArticleTypeID} ) {
					$Recipient{NotificationArticleType} = $Kernel::OM->Get('Kernel::System::Ticket')->ArticleTypeLookup(
						ArticleTypeID => $Param{Notification}->{Data}->{NotificationArticleTypeID}->[0]
					) || 'sms';
				}

				# check recipients
				if ( $Recipient{UserMobile} ) {
					push @Recipients, \%Recipient;
				}
			}
        }
    }

    return @Recipients;
}

sub TransportSettingsDisplayGet {
    my ( $Self, %Param ) = @_;

    KEY:
    for my $Key (qw(RecipientMobile RecipientGateway)) {
        next KEY if !$Param{Data}->{$Key};
        next KEY if !defined $Param{Data}->{$Key}->[0];
        $Param{$Key} = $Param{Data}->{$Key}->[0];
    }

    # get layout object
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    #my %NotificationArticleTypes = $Kernel::OM->Get('Kernel::System::Ticket')->ArticleTypeList( Result => 'HASH' );

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my %GwList;
	# Load list of Gateway Modules
    if ( ref $ConfigObject->Get('SmsNotify::Gateway') eq 'HASH' ) {
        my %Gws = %{ $ConfigObject->Get('SmsNotify::Gateway') };
        for my $Gw ( sort keys %Gws ) {
                $GwList{$Gw}=$Gws{$Gw}->{Name};
        }
    }
    $Param{TransportSmsNotifyGatewayStrg} = $LayoutObject->BuildSelection(
        Data        => \%GwList,
        Name        => 'RecipientGateway',
        SelectedID  => $Param{Data}->{RecipientGateway} || 0,
        Translation => 1,
        Max         => 200,
        Class       => 'Modernize W50pc',
    );
    
    # generate HTML
    my $Output = $LayoutObject->Output(
        TemplateFile => 'AdminNotificationEventTransportSmsNotifySettings',
        Data         => \%Param,
    );

    return $Output;
}

sub TransportParamSettingsGet {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(GetParam)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed",
            );
        }
    }

    # get param object
    my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');

    PARAMETER:
    for my $Parameter (
        qw(RecipientMobile RecipientGateway NotificationArticleTypeID)
        )
    {
        my @Data = $ParamObject->GetArray( Param => $Parameter );
        next PARAMETER if !@Data;
        $Param{GetParam}->{Data}->{$Parameter} = \@Data;
    }

    # Note: Example how to set errors and use them
    # on the normal AdminNotificationEvent screen
    # # set error
    # $Param{GetParam}->{$Parameter.'ServerError'} = 'ServerError';

    return 1;
}

sub _SendSms {
    my ( $Self, %Param ) = @_;

	# For Asynchronous sending
	my $TaskName = substr "SmsNotify".rand().$Param{To}, 0, 255;
	
	# create a new task
	my $TaskID = $Kernel::OM->Get('Kernel::System::Scheduler')->TaskAdd(
		Type                     => 'AsynchronousExecutor',
		Name                     => $TaskName,
		Attempts                 =>  1,
		MaximumParallelInstances =>  0,
		Data                     => {
			Object   => $Param{Gateway}->{Module},
			Function => 'SendSms',
			Params   => {
						Gateway    => $Param{Gateway},
						To         => $Param{To},
						Body       => $Param{Body},
                        TicketID   => $Param{TicketID},
					},
		},
	);

}

sub _ReplaceTicketAttributes {
    my ( $Self, %Param ) = @_;

    return if !$Param{Field};

    # get needed objects
    my $DynamicFieldObject        = $Kernel::OM->Get('Kernel::System::DynamicField');
    my $DynamicFieldBackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

    # replace ticket attributes such as <OTRS_Ticket_DynamicField_Name1> or
    # <OTRS_TICKET_DynamicField_Name1>
    # <OTRS_Ticket_*> is deprecated and should be removed in further versions of OTRS
    my $Count = 0;
    REPLACEMENT:
    while (
        $Param{Field}
        && $Param{Field} =~ m{<OTRS_TICKET_([A-Za-z0-9_]+)>}msxi
        && $Count++ < 1000
        )
    {
        my $TicketAttribute = $1;

        if ( $TicketAttribute =~ m{DynamicField_(\S+?)_Value} ) {
            my $DynamicFieldName = $1;

            my $DynamicFieldConfig = $DynamicFieldObject->DynamicFieldGet(
                Name => $DynamicFieldName,
            );
            next REPLACEMENT if !$DynamicFieldConfig;

            # get the display value for each dynamic field
            my $DisplayValue = $DynamicFieldBackendObject->ValueLookup(
                DynamicFieldConfig => $DynamicFieldConfig,
                Key                => $Param{Ticket}->{"DynamicField_$DynamicFieldName"},
            );

            my $DisplayValueStrg = $DynamicFieldBackendObject->ReadableValueRender(
                DynamicFieldConfig => $DynamicFieldConfig,
                Value              => $DisplayValue,
            );

            $Param{Field} =~ s{<OTRS_TICKET_$TicketAttribute>}{$DisplayValueStrg->{Value} // ''}ige;

            next REPLACEMENT;
        }

        # if ticket value is scalar substitute all instances (as strings)
        # this will allow replacements for "<OTRS_TICKET_Title> <OTRS_TICKET_Queue"
        if ( !ref $Param{Ticket}->{$TicketAttribute} ) {
            $Param{Field} =~ s{<OTRS_TICKET_$TicketAttribute>}{$Param{Ticket}->{$TicketAttribute} // ''}ige;
        }
        else {
            # if the value is an array (e.g. a multiselect dynamic field) set the value directly
            # this unfortunately will not let a combination of values to be replaced
            $Param{Field} = $Param{Ticket}->{$TicketAttribute};
        }
    }

    return $Param{Field};
}

1;

=back

=head1 TERMS AND CONDITIONS

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
