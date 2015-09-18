# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));

# get selenium object
my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        # get helper object
        $Kernel::OM->ObjectParamAdd(
            'Kernel::System::UnitTest::Helper' => {
                RestoreSystemConfiguration => 1,
            },
        );
        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # get sysconfig object
        my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

        # do not check RichText
        $SysConfigObject->ConfigItemUpdate(
            Valid => 1,
            Key   => 'Frontend::RichText',
            Value => 0
        );

        # make sure type and service are enabled
        $SysConfigObject->ConfigItemUpdate(
            Valid => 1,
            Key   => 'Ticket::Service',
            Value => 1
        );
        $SysConfigObject->ConfigItemUpdate(
            Valid => 1,
            Key   => 'Ticket::Type',
            Value => 1
        );

        # create and log in test user
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users', 'itsm-service' ],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        # get service object
        my $ServiceObject = $Kernel::OM->Get('Kernel::System::Service');

        # create test service
        my $ServiceName = "Selenium" . $Helper->GetRandomID();
        my $ServiceID   = $ServiceObject->ServiceAdd(
            Name        => $ServiceName,
            ValidID     => 1,
            Comment     => 'Selenium Test Service',
            TypeID      => 2,
            Criticality => '5 very high',
            UserID      => 1,
        );

        # create test customer
        my $TestCustomer = 'Customer' . $Helper->GetRandomID();
        my $UserLogin    = $Kernel::OM->Get('Kernel::System::CustomerUser')->CustomerUserAdd(
            Source         => 'CustomerUser',
            UserFirstname  => $TestCustomer,
            UserLastname   => $TestCustomer,
            UserCustomerID => $TestCustomer,
            UserLogin      => $TestCustomer,
            UserEmail      => "$TestCustomer\@localhost.com",
            ValidID        => 1,
            UserID         => 1,
        );

        # link test service with test customer
        $ServiceObject->CustomerUserServiceMemberAdd(
            CustomerUserLogin => $TestCustomer,
            ServiceID         => $ServiceID,
            Active            => 1,
            UserID            => 1,
        );

        # navigate to AgentTicketPhone
        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');
        $Selenium->get("${ScriptAlias}index.pl?Action=AgentTicketPhone");

        # check for ITSM fields
        for my $ID (
            qw(TypeID ServiceID OptionLinkTicket DynamicField_ITSMImpact)
            )
        {
            my $Element = $Selenium->find_element( "#$ID", 'css' );
            $Element->is_enabled();
            $Element->is_displayed();
        }

        # test phone ticket ITSM features and create test ticket
        my $AutoCompleteString = "\"$TestCustomer $TestCustomer\" <$TestCustomer\@localhost.com> ($TestCustomer)";
        $Selenium->execute_script("\$('#TypeID').val('1').trigger('redraw.InputField').trigger('change');");
        $Selenium->find_element( "#FromCustomer", 'css' )->send_keys($TestCustomer);
        $Selenium->WaitFor( JavaScript => 'return $("li.ui-menu-item:visible").length' );

        $Selenium->find_element("//*[text()='$AutoCompleteString']")->click();
        $Selenium->WaitFor( JavaScript => 'return $("#ServiceIncidentState").length' );

        $Selenium->find_element( "#Subject",  'css' )->send_keys("Selenium Ticket");
        $Selenium->find_element( "#RichText", 'css' )->send_keys("Selenium body test");
        $Selenium->execute_script("\$('#Dest').val('2||Raw').trigger('redraw.InputField').trigger('change');");
        $Selenium->execute_script("\$('#ServiceID').val('$ServiceID').trigger('redraw.InputField').trigger('change');");
        $Selenium->WaitFor( JavaScript => "return \$('#PriorityID option[value=\"4\"]').length;" );

        # check for service incident state field
        my $Element = $Selenium->find_element( "#ServiceIncidentState", 'css' );
        $Element->is_enabled();
        $Element->is_displayed();

        # test priority update based on impact value
        $Self->Is(
            $Selenium->find_element( '#PriorityID', 'css' )->get_value(),
            '4',
            "#PriorityID stored value",
        );

        $Selenium->execute_script(
            "\$('#DynamicField_ITSMImpact').val('1 very low').trigger('redraw.InputField').trigger('change');");
        $Selenium->WaitFor( JavaScript => "return \$('#PriorityID option[value=\"3\"]').length;" );

        $Self->Is(
            $Selenium->find_element( '#PriorityID', 'css' )->get_value(),
            '3',
            "#PriorityID updated value",
        );

        # submit phone ticket
        $Selenium->find_element( "#submitRichText", 'css' )->click();

        # get ticket object
        my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

        # get test ticket ID
        my %TicketIDs = $TicketObject->TicketSearch(
            Result         => 'HASH',
            Limit          => 1,
            CustomerUserID => $TestCustomer,
        );
        my $TicketID = (%TicketIDs)[0];

        $Self->True(
            $TicketID,
            "Ticket was created",
        );

        # navigate to AgentTicketZoom of created test ticket and click on history
        $Selenium->get("${ScriptAlias}index.pl?Action=AgentTicketZoom;TicketID=$TicketID");

        # force sub menus to be visible in order to be able to click one of the links
        $Selenium->execute_script("\$('.Cluster ul ul').addClass('ForceVisible');");

        # click on history and switch window
        $Selenium->find_element("//*[text()='History']")->click();

        my $Handles = $Selenium->get_window_handles();
        $Selenium->switch_to_window( $Handles->[1] );

        # check for ITSM updated fields
        for my $UpdateText (qw(Impact Criticality)) {
            $Self->True(
                index( $Selenium->get_page_source(), "Updated: FieldName=ITSM$UpdateText" ) > -1,
                "DynamicFieldUpdate $UpdateText - found",
            );
        }

        # delete created test ticket
        my $Success = $TicketObject->TicketDelete(
            TicketID => $TicketID,
            UserID   => 1,
        );
        $Self->True(
            $Success,
            "Delete ticket ID - $TicketID"
        );

        # get DB object
        my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

        # delete test service - test customer connection
        $Success = $DBObject->Do(
            SQL => "DELETE FROM service_customer_user WHERE service_id = $ServiceID",
        );
        $Self->True(
            $Success,
            "Delete service-customer connection",
        );

        # delete test service preferences
        $Success = $DBObject->Do(
            SQL => "DELETE FROM service_preferences WHERE service_id = $ServiceID",
        );
        $Self->True(
            $Success,
            "Deleted Service preferences - $ServiceID",
        );

        # delete created test service
        $Success = $DBObject->Do(
            SQL => "DELETE FROM service WHERE id = $ServiceID",
        );
        $Self->True(
            $Success,
            "Delete service ID - $ServiceID",
        );

        # delete created test customer user
        $TestCustomer = $DBObject->Quote($TestCustomer);
        $Success      = $DBObject->Do(
            SQL  => "DELETE FROM customer_user WHERE login = ?",
            Bind => [ \$TestCustomer ],
        );
        $Self->True(
            $Success,
            "Delete customer user - $TestCustomer",
        );

        # make sure the cache is correct.
        for my $Cache (
            qw (Ticket CustomerUser Service)
            )
        {
            $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
                Type => $Cache,
            );
        }
    }
);

1;
