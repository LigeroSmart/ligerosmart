# --
# Copyright (C) 2001-2016 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::Followers;

use strict;
use warnings;

# COMPLEMENTO
use URI::Escape qw(uri_escape);
use Digest::MD5 qw(md5_hex);


our $ObjectManagerDisabled = 1;

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
	if($Self->{Subaction} eq 'AgentUsersAjax'){
		my $TicketID = $ParamObject->GetParam(Param => 'TicketID');
		my $PartUser = $ParamObject->GetParam(Param => 'PartUser');
		my %Watch = $TicketObject->TicketWatchGet(
	        TicketID => $TicketID,
	    );
		my %List = $UserObject->UserSearch(
     		Search        => "*".$PartUser."*", # Short|Long, default Short
		    Valid         => 1,       # default 1
		);
		
		# $LogObject->Dumper(%List);	
		my $JSON = "[" ;
		my $count  =0;

		#Enable or not Gravatar
		my $EnableGravatar = $ConfigObject->Get("Followers::EnableGravatar") || "Yes";

		#-----------------------
		foreach my $ID (keys %List){
			next if($Watch{$ID});
			my %User = $UserObject->GetUserData(
		       UserID => $ID,
			);
			my $UserEmail = $User{UserEmail}; 
			my $Size = 20;
			my $Grav_url = "http://www.gravatar.com/avatar/".md5_hex(lc $UserEmail)."?&s=".$Size."&d=mm";

			$JSON .= "{ \"value\": \"$ID\" ,";
			$JSON .= " \"label\" : \"$User{UserFullname}\"";
				$JSON .= " ,\"grav_url\" : \"$Grav_url\" },";
		}
		chop($JSON);
		$JSON  .= "]";
        return $LayoutObject->Attachment(
            ContentType => 'application/json; charset=' . $LayoutObject->{Charset},
            Content     => $JSON,
            Type        => 'inline',
            NoCache     => 1,
			Sandbox => 1	
        );
    }elsif($Self->{Subaction} eq 'AddAgentMonitor'){
		my $AgentID = $ParamObject->GetParam(Param => 'AgentID');
		my $TicketID = $ParamObject->GetParam(Param => 'TicketID');
		
		my $Success = $TicketObject->TicketWatchSubscribe(
      		TicketID    => $TicketID,
	        WatchUserID => $AgentID,
    	    UserID      => $Self->{UserID},
       );
		return $LayoutObject->Attachment(
			ContentType => 'text/html; charset= '. $LayoutObject->{Charset},
			Content		=>  $Success,
			Type		=> 'inline',
			NoCache		=> 1,
			Sandbox => 1
		);
	}elsif($Self->{Subaction} eq 'RemoveAgentMonitor'){
		my $AgentID = $ParamObject->GetParam(Param => 'AgentID');
		my $TicketID = $ParamObject->GetParam(Param => 'TicketID');
		my $Success = $TicketObject->TicketWatchUnsubscribe(
      		TicketID    => $TicketID,
	        WatchUserID => $AgentID,
    	    UserID      => $Self->{UserID},
       );
		return $LayoutObject->ttachment(
			ContentType => 'text/html; charset= '. $LayoutObject->{Charset},
			Content		=>  $Success,
			Type		=> 'inline',
			NoCache		=> 1,
			dbox => 1,	
			Sandbox => 1	
		);

	}elsif($Self->{Subaction} eq 'FastNote'){
   		my $TicketID = $ParamObject->GetParam(Param => 'TicketID');
		my $FastNote = $ParamObject->GetParam(Param => 'FastNote');

		my @AgentNotify = split( /,/, $ParamObject->GetParam(Param => 'AgentNotify'));
		
		my $ArticleType = $ConfigObject->Get("Followers::ArticleType") || "note-internal"; 
		my $ArticleSubject = $ConfigObject->Get("Followers::ArticleSubject") || "Subject";
		if(!$FastNote){
			return;
		}
		if(!$TicketID){
			return $LayoutObject->ErrorScreen(
	            Message => Translatable('No TicketID !'),
    	        Comment => Translatable('Please contact your administrator'),
	        );

		}
		my $Emails = "";
		my %User = $UserObject->GetUserData(
	       UserID => $Self->{UserID},
		);
		my $UserEmail = $User{UserEmail}; 
		
		my $ArticleObject = $Kernel::OM->Get('Kernel::System::Ticket::Article');
		my $ArticleBackendObject = $ArticleObject->BackendForChannel( ChannelName => 'Phone' );
		my $ArticleID = $ArticleBackendObject->ArticleCreate(
        	TicketID         => $TicketID,
	        ArticleType      => $ArticleType,                        # email-external|email-internal|phone|fax|...
	        SenderType       => 'agent',                                # agent|system|customer
		    Subject          => $ArticleSubject, 	              # required
			From		 	 => $UserEmail,
			MimeType         => 'text/plain',
	        Body             => $FastNote ,                     # required
            Charset          => $LayoutObject->{UserCharset},
	        HistoryType      => 'AddNote',                          # EmailCustomer|Move|AddNote|PriorityUpdate|WebRequestCustomer|...
		    HistoryComment   => 'New Note from Followers Module',
		    UserID           => $Self->{UserID},
	        ForceNotificationToUserID   => \@AgentNotify,               # if you want to force somebody
			IsVisibleForCustomer => 1,
		);
		
		return $LayoutObject->Attachment(
			ContentType => 'text/plain; charset= '. $LayoutObject->{Charset},
			Content		=>  $ArticleID,
			Type		=> 'inline',
			NoCache		=> 1,
			Sandbox => 1
		);

	}
	

}
sub AddNewMonitor {
	

}
1;