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

use vars (qw($Self));

my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # Enable the UnsetMasterSlave config.
        $Helper->ConfigSettingChange(
            Key   => 'MasterSlave::UnsetMasterSlave',
            Value => 1,
        );

        # Create test user and log in.
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users' ],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # Navigate to AdminGenericAgent screen for new job adding.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminGenericAgent;Subaction=Update");

        $Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function';" );

        # Expand appropriate widget.
        $Selenium->execute_script(
            "\$('.WidgetSimple.Collapsed:contains(\"Update/Add Ticket Attributes\") .WidgetAction.Toggle a').trigger('click');"
        );
        $Selenium->WaitFor(
            JavaScript => "return \$('.WidgetSimple.Expanded').length;"
        );

        # Add appropriate dynamic field.
        $Selenium->execute_script(
            "\$('#AddNewDynamicFields').val('DynamicField_MasterSlave').trigger('redraw.InputField').trigger('change');"
        );
        $Selenium->WaitFor(
            JavaScript => "return \$('#SelectedNewDynamicFields #DynamicField_MasterSlave').length;"
        );

        # Verify possible MasterSlave values 'UnsetMaster' and 'UnsetSlave' in 'Update/Add Ticket Attributes' widget.
        # See bug#14778 (https://bugs.otrs.org/show_bug.cgi?id=14778).
        for my $Option (qw(UnsetMaster UnsetSlave)) {
            $Self->True(
                $Selenium->execute_script("return \$('#DynamicField_MasterSlave option[value=$Option]').length;"),
                "MasterSlave option '$Option' is available."
            );
        }

        # Disable the UnsetMasterSlave config.
        $Helper->ConfigSettingChange(
            Key   => 'MasterSlave::UnsetMasterSlave',
            Value => 0,
        );

        # Refresh screen.
        $Selenium->VerifiedRefresh();

        # Expand appropriate widget.
        $Selenium->execute_script(
            "\$('.WidgetSimple.Collapsed:contains(\"Update/Add Ticket Attributes\") .WidgetAction.Toggle a').trigger('click');"
        );
        $Selenium->WaitFor(
            JavaScript => "return \$('.WidgetSimple.Expanded').length;"
        );

        # Add appropriate dynamic field.
        $Selenium->execute_script(
            "\$('#AddNewDynamicFields').val('DynamicField_MasterSlave').trigger('redraw.InputField').trigger('change');"
        );
        $Selenium->WaitFor(
            JavaScript => "return \$('#SelectedNewDynamicFields #DynamicField_MasterSlave').length;"
        );

        # Verify possible MasterSlave values 'UnsetMaster' and 'UnsetSlave' are not available
        #   in 'Update/Add Ticket Attributes' widget.
        for my $Option (qw(UnsetMaster UnsetSlave)) {
            $Self->False(
                $Selenium->execute_script("return \$('#DynamicField_MasterSlave option[value=$Option]').length;"),
                "MasterSlave option '$Option' is not available."
            );
        }
    }
);

1;
