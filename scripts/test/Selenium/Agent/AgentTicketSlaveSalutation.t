# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

## no critic (Modules::RequireExplicitPackage)
use strict;
use warnings;
use utf8;

use Kernel::System::VariableCheck qw(:all);

use vars (qw($Self));

my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {
        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        my $TicketObject       = $Kernel::OM->Get('Kernel::System::Ticket');
        my $ArticleObject      = $Kernel::OM->Get('Kernel::System::Ticket::Article');
        my $QueueObject        = $Kernel::OM->Get('Kernel::System::Queue');
        my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');

        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'CheckMXRecord',
            Value => 0,
        );
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'CheckEmailAddresses',
            Value => 0,
        );
        $Helper->ConfigSettingChange(
            Key   => 'SendmailModule',
            Value => 'Kernel::System::Email::Test',
        );
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'MasterSlave::ForwardSlaves',
            Value => 1,
        );

        my $RandomID = $Helper->GetRandomID();

        # Create test salutation using rich text.
        my $SalutationText = "<strong>Test Bold ${RandomID} </strong>";
        my $SalutationID   = $Kernel::OM->Get('Kernel::System::Salutation')->SalutationAdd(
            Name        => "New Salutation $RandomID",
            Text        => $SalutationText,
            ContentType => 'text/html',
            Comment     => 'some comment',
            ValidID     => 1,
            UserID      => 1,
        );
        $Self->True(
            $SalutationID,
            "SalutationID $SalutationID is created.",
        );

        # Create test queue.
        my $QueueName = "Salutation $RandomID";
        my $QueueID   = $QueueObject->QueueAdd(
            Name            => $QueueName,
            Group           => 'admin',
            ValidID         => 1,
            GroupID         => 1,
            SystemAddressID => 1,
            SalutationID    => $SalutationID,
            SignatureID     => 1,
            Comment         => 'Some comment',
            UserID          => 1

        );
        $Self->True(
            $QueueID,
            "QueueID $QueueID is created.",
        );

        # Assign answer templates to queue.
        for my $TemplateID ( 1 .. 2 ) {
            my $Success = $QueueObject->QueueStandardTemplateMemberAdd(
                QueueID            => $QueueID,
                StandardTemplateID => $TemplateID,
                Active             => 1,
                UserID             => 1,
            );
            $Self->True(
                $Success,
                "TemplateID '$TemplateID' is assigned to QueueID '$QueueID'.",
            );
        }

        my $TestCustomerUserLogin = $Helper->TestCustomerUserCreate();
        my %TestCustomerUser      = $Kernel::OM->Get('Kernel::System::CustomerUser')->CustomerUserDataGet(
            User => $TestCustomerUserLogin,
        );

        # Create master ticket.
        my $MasterTicketNumber = $TicketObject->TicketCreateNumber();
        my $MasterTicketID     = $TicketObject->TicketCreate(
            TN           => $MasterTicketNumber,
            Title        => "Master $RandomID",
            QueueID      => $QueueID,
            Lock         => 'unlock',
            Priority     => '3 normal',
            State        => 'new',
            CustomerNo   => $TestCustomerUserLogin,
            CustomerUser => $TestCustomerUserLogin,
            OwnerID      => 1,
            UserID       => 1,
        );
        $Self->True(
            $MasterTicketID,
            "TicketID $MasterTicketID is created (master).",
        );

        my $ArticleID = $ArticleObject->BackendForChannel( ChannelName => 'Phone' )->ArticleCreate(
            TicketID             => $MasterTicketID,
            IsVisibleForCustomer => 1,
            SenderType           => 'agent',
            Subject              => 'Master Article',
            Body                 => 'Unit test MasterTicket',
            ContentType          => 'text/plain; charset=ISO-8859-15',
            HistoryType          => 'PhoneCallCustomer',
            HistoryComment       => 'Unit test article',
            UserID               => 1,
        );
        $Self->True(
            $ArticleID,
            "ArticleID $ArticleID is created.",
        );

        # Get master/slave dynamic field data.
        my $MasterSlaveDynamicField     = $Kernel::OM->Get('Kernel::Config')->Get('MasterSlave::DynamicField');
        my $MasterSlaveDynamicFieldData = $DynamicFieldObject->DynamicFieldGet(
            Name => $MasterSlaveDynamicField,
        );

        my $DynamicField = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldGet(
            ID => $MasterSlaveDynamicFieldData->{ID},
        );

        my $DynamicFieldBackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

        # Set test ticket as master ticket.
        my $Success = $DynamicFieldBackendObject->ValueSet(
            DynamicFieldConfig => $DynamicField,
            ObjectID           => $MasterTicketID,
            Value              => 'Master',
            UserID             => 1,
        );
        $Self->True(
            $Success,
            "TicketID $MasterTicketID, DynamicField '$MasterSlaveDynamicField' is updated as MasterTicket.",
        );

        # Create slave ticket.
        my $SlaveTicketID = $TicketObject->TicketCreate(
            Title        => "Slave $RandomID",
            QueueID      => $QueueID,
            Lock         => 'unlock',
            Priority     => '3 normal',
            State        => 'new',
            CustomerID   => $TestCustomerUserLogin,
            CustomerUser => $TestCustomerUserLogin,
            OwnerID      => 1,
            UserID       => 1,
        );
        $Self->True(
            $SlaveTicketID,
            "TicketID $SlaveTicketID is created (slave).",
        );

        # Set test ticket to slave.
        $Success = $DynamicFieldBackendObject->ValueSet(
            DynamicFieldConfig => $DynamicField,
            ObjectID           => $SlaveTicketID,
            Value              => "SlaveOf:$MasterTicketNumber",
            UserID             => 1,
        );
        $Self->True(
            $Success,
            "TicketID $SlaveTicketID, DynamicField '$MasterSlaveDynamicField' is updated as SlaveTicket.",
        );

        # Create test user.
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users' ],
        );

        # Get test user ID.
        my $TestUserID = $Kernel::OM->Get('Kernel::System::User')->UserLookup(
            UserLogin => $TestUserLogin,
        );

        # Login as test user.
        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # Navigate to AgentTicketCompose screen.
        $Selenium->VerifiedGet(
            "${ScriptAlias}index.pl?Action=AgentTicketCompose;TicketID=$MasterTicketID;ArticleID=$ArticleID;ReplyAll=;ResponseID=1"
        );

        $Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function' && \$('#submitRichText').length;" );
        $Selenium->find_element( "#ToCustomer",     'css' )->send_keys( $TestCustomerUser{UserEmail} );
        $Selenium->find_element( "#submitRichText", 'css' )->VerifiedClick();

        $Selenium->VerifiedGet(
            "${ScriptAlias}index.pl?Action=AgentTicketZoom;TicketID=$SlaveTicketID"
        );

        # Wait for the iframe to show up.
        $Selenium->WaitFor(
            JavaScript =>
                "return typeof(\$) === 'function' && \$('.ArticleMailContent iframe').contents().length == 1;"
        );

        $Selenium->SwitchToFrame(
            FrameSelector => '.ArticleMailContent iframe',
            WaitForLoad   => 0,
        );

        # Check if slave ticket article hes salutation in rich text format. See bug#14983.
        $Self->True(
            index( $Selenium->get_page_source(), $SalutationText ) > -1,
            "Slave article contains rich text '$SalutationText'. ",
        );

        # Cleanup.
        my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

        # Delete test created tickets.
        for my $TicketID ( $MasterTicketID, $SlaveTicketID ) {
            $Success = $TicketObject->TicketDelete(
                TicketID => $TicketID,
                UserID   => 1,
            );

            # Ticket deletion could fail if apache still writes to ticket history. Try again in this case.
            if ( !$Success ) {
                sleep 3;
                $Success = $TicketObject->TicketDelete(
                    TicketID => $TicketID,
                    UserID   => 1,
                );
            }
            $Self->True(
                $Success,
                "TicketID $TicketID is deleted."
            );
        }

        $Success = $DBObject->Do(
            SQL  => "DELETE FROM queue_standard_template WHERE queue_id = ?",
            Bind => [ \$QueueID, ],
        );
        $Self->True(
            $Success,
            "Standard_template_queue relation for QueueID $QueueID is deleted."
        );

        # Delete queues.
        $Success = $DBObject->Do(
            SQL  => "DELETE FROM queue WHERE id = ?",
            Bind => [ \$QueueID, ],
        );
        $Self->True(
            $Success,
            "QueueID $QueueID is deleted.",
        );

        # Delete salutation.
        $Success = $DBObject->Do(
            SQL  => "DELETE FROM salutation WHERE id = ?",
            Bind => [ \$SalutationID, ],
        );
        $Self->True(
            $Success,
            "SalutationID $SalutationID is deleted.",
        );

    }
);

1;
