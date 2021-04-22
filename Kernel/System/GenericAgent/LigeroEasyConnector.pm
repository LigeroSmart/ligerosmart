package Kernel::System::GenericAgent::LigeroEasyConnector;

use strict;
use warnings;
use Time::HiRes qw(gettimeofday);

our @ObjectDependencies = (
    'Kernel::System::Log',
    'Kernel::System::DynamicField',
    'Kernel::System::DynamicFieldBackend',
    'Kernel::System::Ticket',
    'Kernel::System::Time',
    'Kernel::System::GenericInterface::Webservice',
    'Kernel::GenericInterface::Requester',
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # 0=off; 1=on;
    $Self->{Debug} = $Param{Debug} || 0;

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;
    
    #Create system objects that will be used above
    my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');
    my $UserObject = $Kernel::OM->Get('Kernel::System::User');
    my $DynamicFieldBackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');
    my $DynamicFieldValueObject = $Kernel::OM->Get('Kernel::System::DynamicFieldValue');
    my $TimeObject = $Kernel::OM->Get('Kernel::System::Time');
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

    my @ArticleIndex = $TicketObject->ArticleGet(
        %Param,
        Order    => 'DESC', # DESC,ASC - default is ASC
        Limit    => 2,
    );

    my $ArticleID;
    my %Article;
    my $ArticleData;
    for my $FileID ( @ArticleIndex ) {
        if($FileID->{SenderType} ne 'system' && !$ArticleID){
            $ArticleID = $FileID->{ArticleID};
            %Article = $FileID;
            $ArticleData = $FileID;
        }
    }

    my $JSONObject = $Kernel::OM->Get('Kernel::System::JSON');
    my $WebServiceConfig;
    if($Param{New}->{'WebServiceConfig'}){
        $WebServiceConfig = $JSONObject->Decode(
            Data => $Param{New}->{'WebServiceConfig'},
        );
    } else {
        return 1;
    }

    my $WebServiceAditionalParams;
    if($Param{New}->{'WebServiceAditionalParams'}){
        $WebServiceAditionalParams = $JSONObject->Decode(
            Data => $Param{New}->{'WebServiceAditionalParams'},
        );
    }

    my $AditionalFilters;
    if($Param{New}->{'AditionalFilters'}){
        $AditionalFilters = $JSONObject->Decode(
            Data => $Param{New}->{'AditionalFilters'},
        );
    }

    # Verifies if it has ArticleType Filter
    if($AditionalFilters->{ArticleTypeFilter} && !$ArticleData->{ArticleType}){
        return 1;
    } elsif ($AditionalFilters->{ArticleTypeFilter} && !grep /^$ArticleData->{ArticleType}$/,split(/\|/,$AditionalFilters->{ArticleTypeFilter})) {
        return 1;
    }
    
    my %Data = (
        'TicketID' => $Param{TicketID},
        'ArticleID' => $ArticleID
    );

    my $WebService = $Kernel::OM->Get('Kernel::System::GenericInterface::Webservice')->WebserviceGet(
        Name => $WebServiceConfig->{'WebServiceName'},
    );

    # check needed param
    if ($WebServiceConfig->{'PreWebServiceInvoker'}) {

        my $Result = $Kernel::OM->Get('Kernel::GenericInterface::Requester')->Run(
            WebserviceID => $WebService->{ID},
            Invoker      => $WebServiceConfig->{'PreWebServiceInvoker'},
            Data         => \%Data
        );

        $Data{PreResult} = $Result;
    }

    # check needed param
    if ($WebServiceConfig->{'WebServiceInvoker'}) {
        

        my $Result = $Kernel::OM->Get('Kernel::GenericInterface::Requester')->Run(
            WebserviceID => $WebService->{ID},
            Invoker      => $WebServiceConfig->{'WebServiceInvoker'},
            Data         => \%Data
        );

        $Data{Result} = $Result;
    }

    # check needed param
    if ($WebServiceAditionalParams->{'WebServiceAttachmentInvoker'}) {
        
        my %Index = $TicketObject->ArticleAttachmentIndex(
            ArticleID                  => $ArticleID,
            UserID                     => 1,
            Article                    => \%Article,
            StripPlainBodyAsAttachment => 3,
        );

        FILE_UPLOAD:
        for my $FileID ( sort keys %Index ) {

            my %Attachment = $TicketObject->ArticleAttachment(
                ArticleID => $ArticleID,
                FileID    => $FileID,   # as returned by ArticleAttachmentIndex
                UserID    => 1,
            );

            if ($WebServiceAditionalParams->{'WebServiceAttachmentMaxSize'} && int($Index{$FileID}->{FilesizeRaw}) > int($WebServiceAditionalParams->{'WebServiceAttachmentMaxSize'})) {
                next FILE_UPLOAD;
            }

            my $dir = "/opt/otrs/var/tmp/";

            my $timestamp = int (gettimeofday * 1000);

            my $file = $dir.$timestamp.$Attachment{Filename};

            open(FH, '>', $file) or die $!;

            print FH $Attachment{Content};

            close(FH);

            my %UploadData = (
                'TicketID' => $Param{TicketID},
                'ArticleID' => $ArticleID,
                'FilePath' => $file,
                'FileData' => $Index{$FileID},
                'PreResult' => $Data{PreResult},
                'Result' => $Data{Result}
            );

            $Kernel::OM->Get('Kernel::GenericInterface::Requester')->Run(
                WebserviceID => $WebService->{ID},
                Invoker      => $WebServiceAditionalParams->{'WebServiceAttachmentInvoker'},
                Data         => \%UploadData
            );
        }
        
    }

    if ($WebServiceConfig->{'PostWebServiceInvoker'}) {

        my $Result = $Kernel::OM->Get('Kernel::GenericInterface::Requester')->Run(
            WebserviceID => $WebService->{ID},
            Invoker      => $WebServiceConfig->{'PostWebServiceInvoker'},
            Data         => \%Data
        );
    }

    #$Kernel::OM->Get('Kernel::System::Log')->Log(
    #    Priority => 'error',
    #    Message  => "aaaaaaaaaaaaaaaaaaaa -------",
    #);
}

1;
