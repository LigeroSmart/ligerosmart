package Kernel::Config::Files::ZZZZZLigeroSettings;
use strict;
use warnings;
no warnings 'redefine';
use utf8;
use Kernel::System::VariableCheck qw(:all);

sub Load {
    my ($File, $Self) = @_;

    $Self->{'Frontend::ToolBarModule'}->{'110-Ticket::AgentTicketQueue'} =  {
        'AccessKey' => 'q',
        'Action' => 'AgentTicketQueue',
        'CssClass' => 'QueueView',
        'Icon' => 'fa fa-folder',
        'Link' => 'Action=AgentTicketQueue',
        'Module' => 'Kernel::Output::HTML::ToolBar::Link',
        'Name' => 'Queue view',
        'Priority' => '1010010'
    };
    $Self->{'Frontend::ToolBarModule'}->{'120-Ticket::AgentTicketStatus'} =  {
        'AccessKey' => '',
        'Action' => 'AgentTicketStatusView',
        'CssClass' => 'StatusView',
        'Icon' => 'fa fa-list-ol',
        'Link' => 'Action=AgentTicketStatusView',
        'Module' => 'Kernel::Output::HTML::ToolBar::Link',
        'Name' => 'Status view',
        'Priority' => '1010020'
    };
    $Self->{'Frontend::ToolBarModule'}->{'130-Ticket::AgentTicketEscalation'} =  {
        'AccessKey' => 'w',
        'Action' => 'AgentTicketEscalationView',
        'CssClass' => 'EscalationView',
        'Icon' => 'fa fa-exclamation',
        'Link' => 'Action=AgentTicketEscalationView',
        'Module' => 'Kernel::Output::HTML::ToolBar::Link',
        'Name' => 'Escalation view',
        'Priority' => '1010030'
    };
    $Self->{'Frontend::ToolBarModule'}->{'140-Ticket::AgentTicketPhone'} =  {
        'AccessKey' => '',
        'Action' => 'AgentTicketPhone',
        'CssClass' => 'PhoneTicket',
        'Icon' => 'fa fa-phone',
        'Link' => 'Action=AgentTicketPhone',
        'Module' => 'Kernel::Output::HTML::ToolBar::Link',
        'Name' => 'New phone ticket',
        'Priority' => '1020010'
    };
    $Self->{'Frontend::ToolBarModule'}->{'150-Ticket::AgentTicketEmail'} =  {
        'AccessKey' => '',
        'Action' => 'AgentTicketEmail',
        'CssClass' => 'EmailTicket',
        'Icon' => 'fa fa-envelope',
        'Link' => 'Action=AgentTicketEmail',
        'Module' => 'Kernel::Output::HTML::ToolBar::Link',
        'Name' => 'New email ticket',
        'Priority' => '1020020'
    };
    $Self->{'Frontend::ToolBarModule'}->{'160-Ticket::AgentTicketProcess'} =  {
        'AccessKey' => '',
        'Action' => 'AgentTicketProcess',
        'CssClass' => 'ProcessTicket',
        'Icon' => 'fa fa-sitemap',
        'Link' => 'Action=AgentTicketProcess',
        'Module' => 'Kernel::Output::HTML::ToolBar::Link',
        'Name' => 'New process ticket',
        'Priority' => '1020030'
    };
    $Self->{'Frontend::ToolBarModule'}->{'200-Ticket::AgentTicketService'} =  {
        'CssClass' => 'ServiceView',
        'Icon' => 'fa fa-wrench',
        'Module' => 'Kernel::Output::HTML::ToolBar::TicketService',
        'Priority' => '1030035'
    };
    $Self->{'Frontend::ToolBarModule'}->{'210-Ticket::TicketSearchProfile'} =  {
        'Block' => 'ToolBarSearchProfile',
        'Description' => 'Search template',
        'MaxWidth' => '40',
        'Module' => 'Kernel::Output::HTML::ToolBar::TicketSearchProfile',
        'Name' => 'Search template',
        'Priority' => '1990010'
    };
    $Self->{'Frontend::ToolBarModule'}->{'220-Ticket::TicketSearchFulltext'} =  {
        'Block' => 'ToolBarSearchFulltext',
        'Description' => 'Fulltext search',
        'Module' => 'Kernel::Output::HTML::ToolBar::Generic',
        'Name' => 'Fulltext',
        'Priority' => '1990020',
        'Size' => '10'
    };
    $Self->{'Frontend::ToolBarModule'}->{'230-CICSearchCustomerID'} =  {
        'Block' => 'ToolBarCICSearchCustomerID',
        'Description' => 'CustomerID search',
        'Module' => 'Kernel::Output::HTML::ToolBar::Generic',
        'Name' => 'CustomerID',
        'Priority' => '1990030',
        'Size' => '10'
    };
    $Self->{'Frontend::ToolBarModule'}->{'240-CICSearchCustomerUser'} =  {
        'Block' => 'ToolBarCICSearchCustomerUser',
        'Description' => 'Customer user search',
        'Module' => 'Kernel::Output::HTML::ToolBar::Generic',
        'Name' => 'Customer User',
        'Priority' => '1990040',
        'Size' => '10'
    };
    $Self->{'Frontend::ToolBarModule'}->{'90-FAQ::AgentFAQAdd'} =  {
        'AccessKey' => '',
        'Action' => 'AgentFAQAdd',
        'CssClass' => 'FAQ',
        'Icon' => 'fa fa-question',
        'Link' => 'Action=AgentFAQAdd',
        'Module' => 'Kernel::Output::HTML::ToolBar::Link',
        'Name' => 'Add FAQ article',
        'Priority' => '1020090'
    };

    $Self->{'CustomerLogo'} =  {
        'StyleHeight' => '45px',
        'StyleRight' => '25px',
        'StyleTop' => '9px',
        'StyleWidth' => '300px',
        'URL' => 'skins/Customer/default/img/logo.png'
    };

    $Self->{'CloudServices::Disabled'} =  '1';

    # Disable Agents to Groups direct relation
    delete $Self->{"Frontend::Module"}->{"AdminUserGroup"};

    # Disables FAQ::Voting as we use our own system
    $Self->{'FAQ::Voting'} =  0;

}

1;