# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package var::packagesetup::FAQ;

use strict;
use warnings;

use List::Util qw();
use Kernel::Output::Template::Provider;
use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Cache',
    'Kernel::System::DB',
    'Kernel::System::DynamicField',
    'Kernel::System::DynamicFieldValue',
    'Kernel::System::FAQ',
    'Kernel::System::Group',
    'Kernel::System::LinkObject',
    'Kernel::System::Main',
    'Kernel::System::Log',
    'Kernel::System::Stats',
    'Kernel::System::SysConfig',
    'Kernel::System::Valid',
);

=head1 NAME

var::packagesetup::FAQ - code to execute during package installation

=head1 DESCRIPTION

All functions

=head1 PUBLIC INTERFACE

=head2 new()

create an object

    use Kernel::System::ObjectManager;
    local $Kernel::OM = Kernel::System::ObjectManager->new();
    my $CodeObject = $Kernel::OM->Get('var::packagesetup::FAQ');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # Allocate new hash for object.
    my $Self = {};
    bless( $Self, $Type );

    # Force a reload of ZZZAuto.pm and ZZZAAuto.pm to get the fresh configuration values.
    for my $Module ( sort keys %INC ) {
        if ( $Module =~ m/ZZZAA?uto\.pm$/ ) {
            delete $INC{$Module};
        }
    }

    # Create common objects with fresh default config.
    $Kernel::OM->ObjectsDiscard();

    # Define UserID parameter for the constructor of the stats object.
    $Kernel::OM->ObjectParamAdd(
        'Kernel::System::Stats' => {
            UserID => 1,
        },
    );

    # Define file prefix.
    $Self->{FilePrefix} = 'FAQ';

    return $Self;
}

=head2 CodeInstall()

run the code install part

    my $Result = $CodeObject->CodeInstall();

=cut

sub CodeInstall {
    my ( $Self, %Param ) = @_;

    # insert the FAQ states
    $Self->_InsertFAQStates();

    # Add default groups to the category 'Misc'.
    $Self->_CategoryGroupSet(
        Category => 'Misc',
        Groups   => [ 'admin', 'users' ],
    );

    # create additional FAQ languages
    $Self->_CreateAditionalFAQLanguages();

    # install stats
    $Kernel::OM->Get('Kernel::System::Stats')->StatsInstall(
        FilePrefix => $Self->{FilePrefix},
        UserID     => 1,
    );

    return 1;
}

=head2 CodeReinstall()

run the code reinstall part

    my $Result = $CodeObject->CodeReinstall();

=cut

sub CodeReinstall {
    my ( $Self, %Param ) = @_;

    # insert the FAQ states
    $Self->_InsertFAQStates();

    # install stats
    $Kernel::OM->Get('Kernel::System::Stats')->StatsInstall(
        FilePrefix => $Self->{FilePrefix},
        UserID     => 1,
    );

    # create additional FAQ languages
    $Self->_CreateAditionalFAQLanguages();

    return 1;
}

=head2 CodeUpgrade()

run the code upgrade part

    my $Result = $CodeObject->CodeUpgrade();

=cut

sub CodeUpgrade {
    my ( $Self, %Param ) = @_;

    # install stats
    $Kernel::OM->Get('Kernel::System::Stats')->StatsInstall(
        FilePrefix => $Self->{FilePrefix},
        UserID     => 1,
    );

    # create additional FAQ languages
    $Self->_CreateAditionalFAQLanguages();

    # delete the FAQ cache (to avoid old data from previous FAQ modules)
    $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
        Type => 'FAQ',
    );

    return 1;
}

=head2 CodeUpgradeSpecial()

run special code upgrade part

    my $Result = $CodeObject->CodeUpgradeSpecial();

=cut

sub CodeUpgradeSpecial {
    my ( $Self, %Param ) = @_;

    # convert \n to <br> for existing articles
    $Self->_ConvertNewlines();

    # start normal code upgrade
    $Self->CodeUpgrade();

    return 1;
}

=head2 CodeUpgradeFromLowerThan_4_0_1()

This function is only executed if the installed module version is smaller than 4.0.1.

    my $Result = $CodeObject->CodeUpgradeFromLowerThan_4_0_1();

=cut

sub CodeUpgradeFromLowerThan_4_0_1 {    ## no critic
    my ( $Self, %Param ) = @_;

    # Migrate the DTL Content in the SysConfig.
    $Self->_MigrateDTLInSysConfig();

    return 1;
}

=head2 CodeUpgradeFromLowerThan_4_0_91()

This function is only executed if the installed module version is smaller than 4.0.91.

    my $Result = $CodeObject->CodeUpgradeFromLowerThan_4_0_91();

=cut

sub CodeUpgradeFromLowerThan_4_0_91 {    ## no critic
    my ( $Self, %Param ) = @_;

    # Change configurations to match the new module location.
    $Self->_MigrateConfigs();

    # Set content type.
    $Self->_SetContentType();

    return 1;
}

=head2 CodeUpgradeFromLowerThan_5_0_92()

This function is only executed if the installed module version is smaller than 5.0.92.

    my $Result = $CodeObject->CodeUpgradeFromLowerThan_5_0_92();

=cut

sub CodeUpgradeFromLowerThan_5_0_92 {    ## no critic
    my ( $Self, %Param ) = @_;

    # Recover the old permissions
    $Self->_MigratePermissions();

    return 1;
}

=head2 CodeUninstall()

run the code uninstall part

    my $Result = $CodeObject->CodeUninstall();

=cut

sub CodeUninstall {
    my ( $Self, %Param ) = @_;

    # remove Dynamic Fields and its values
    $Self->_DynamicFieldsDelete();

    # Deactivate the group 'faq'.
    $Self->_GroupDeactivate(
        Name => 'faq',
    );

    # Deactivate the group 'faq_admin'.
    $Self->_GroupDeactivate(
        Name => 'faq_admin',
    );

    # Deactivate the group 'faq_approval'.
    $Self->_GroupDeactivate(
        Name => 'faq_approval',
    );

    # uninstall stats
    $Kernel::OM->Get('Kernel::System::Stats')->StatsUninstall(
        FilePrefix => $Self->{FilePrefix},
        UserID     => 1,
    );

    # delete all links with FAQ articles
    $Self->_LinkDelete();

    return 1;
}

=head2 _InsertFAQStates()

inserts needed FAQ states into table

    my $Result = $CodeObject->_InsertFAQStates();

=cut

sub _InsertFAQStates {
    my ( $Self, %Param ) = @_;

    # define faq_state_types => faq_states
    my %State = (
        'internal' => 'internal (agent)',
        'external' => 'external (customer)',
        'public'   => 'public (all)',
    );

    # get FAQ object
    my $FAQObject = $Kernel::OM->Get('Kernel::System::FAQ');

    for my $Type ( sort keys %State ) {

        # get the state type
        my $StateTypeRef = $FAQObject->StateTypeGet(
            Name   => $Type,
            UserID => 1,
        );

        # add the state
        $FAQObject->StateAdd(
            Name   => $State{$Type},
            TypeID => $StateTypeRef->{StateID},
            UserID => 1,
        );
    }

    return 1;
}

=head2 _ConvertNewlines()

coverts all \n into <br> for Fields 1-6 in all existing FAQ articles

    my $Result = $CodeObject->_ConvertNewlines();

=cut

sub _ConvertNewlines {
    my ( $Self, %Param ) = @_;

    # only convert \n to <br> if HTML view is enabled
    return if !$Kernel::OM->Get('Kernel::Config')->Get('FAQ::Item::HTML');

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # get all FAQ IDs
    my @ItemIDs;
    $DBObject->Prepare(
        SQL => "SELECT id FROM faq_item",
    );
    while ( my @Row = $DBObject->FetchrowArray() ) {
        push( @ItemIDs, $Row[0] );
    }

    # get FAQ object
    my $FAQObject = $Kernel::OM->Get('Kernel::System::FAQ');

    ID:
    for my $ItemID (@ItemIDs) {

        # get FAQ data
        my %FAQ = $FAQObject->FAQGet(
            ItemID     => $ItemID,
            ItemFields => 1,
            UserID     => 1,
        );

        # get FAQ article fields 1-6
        my $FoundNewline;
        KEY:
        for my $Key (qw (Field1 Field2 Field3 Field4 Field5 Field6)) {
            next KEY if !$FAQ{$Key};

            # replace \n with <br>
            $FAQ{$Key} =~ s/\n/<br\/>\n/g;

            $FoundNewline = 1;
        }
        next ID if !$FoundNewline;

        # update FAQ data
        $FAQObject->FAQUpdate(
            %FAQ,
            UserID => 1,
        );
    }

    return 1;
}

=head2 _GroupAdd()

add a group

    my $Result = $CodeObject->_GroupAdd(
        Name        => 'the-group-name',
        Description => 'The group description.',
    );

=cut

sub _GroupAdd {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(Name Description)) {
        if ( !$Param{$Argument} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );

            return;
        }
    }

    # get valid list
    my %ValidList = $Kernel::OM->Get('Kernel::System::Valid')->ValidList(
        UserID => 1,
    );
    my %ValidListReverse = reverse %ValidList;

    # get group object
    my $GroupObject = $Kernel::OM->Get('Kernel::System::Group');

    # get list of all groups
    my %GroupList = $GroupObject->GroupList();

    # reverse the group list for easier lookup
    my %GroupListReverse = reverse %GroupList;

    # check if group already exists
    my $GroupID = $GroupListReverse{ $Param{Name} };

    # reactivate the group
    if ($GroupID) {

        # get current group data
        my %GroupData = $GroupObject->GroupGet(
            ID     => $GroupID,
            UserID => 1,
        );

        # reactivate group
        $GroupObject->GroupUpdate(
            %GroupData,
            ValidID => $ValidListReverse{valid},
            UserID  => 1,
        );

        return 1;
    }

    # add the group
    else {
        return if !$GroupObject->GroupAdd(
            Name    => $Param{Name},
            Comment => $Param{Description},
            ValidID => $ValidListReverse{valid},
            UserID  => 1,
        );
    }

    # lookup the new group id
    my $NewGroupID = $GroupObject->GroupLookup(
        Group  => $Param{Name},
        UserID => 1,
    );

    # add user root to the group
    $GroupObject->GroupMemberAdd(
        GID        => $NewGroupID,
        UID        => 1,
        Permission => {
            ro        => 1,
            move_into => 1,
            create    => 1,
            owner     => 1,
            priority  => 1,
            rw        => 1,
        },
        UserID => 1,
    );

    return 1;
}

=head2 _GroupDeactivate()

deactivate a group

    my $Result = $CodeObject->_GroupDeactivate(
        Name => 'the-group-name',
    );

=cut

sub _GroupDeactivate {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{Name} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need Name!',
        );

        return;
    }

    # get group object
    my $GroupObject = $Kernel::OM->Get('Kernel::System::Group');

    # lookup group id
    my $GroupID = $GroupObject->GroupLookup(
        Group => $Param{Name},
    );

    return if !$GroupID;

    # get valid list
    my %ValidList = $Kernel::OM->Get('Kernel::System::Valid')->ValidList(
        UserID => 1,
    );
    my %ValidListReverse = reverse %ValidList;

    # get current group data
    my %GroupData = $GroupObject->GroupGet(
        ID     => $GroupID,
        UserID => 1,
    );

    # deactivate group
    $GroupObject->GroupUpdate(
        %GroupData,
        ValidID => $ValidListReverse{invalid},
        UserID  => 1,
    );

    return 1;
}

=head2 _LinkDelete()

delete all existing links to FAQ articles

    my $Result = $CodeObject->_LinkDelete();

=cut

sub _LinkDelete {
    my ( $Self, %Param ) = @_;

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # get all FAQ article ids
    my @ItemIDs = ();
    $DBObject->Prepare(
        SQL => 'SELECT id FROM faq_item'
    );
    while ( my @Row = $DBObject->FetchrowArray() ) {
        push @ItemIDs, $Row[0];
    }
    return if !@ItemIDs;

    # delete the FAQ article links
    for my $ItemID (@ItemIDs) {
        $Kernel::OM->Get('Kernel::System::LinkObject')->LinkDeleteAll(
            Object => 'FAQ',
            Key    => $ItemID,
            UserID => 1,
        );
    }

    return 1;
}

=head2 _CreateAditionalFAQLanguages()

creates additional FAQ languages for system default language and user language

    my $Result = $CodeObject->_CreateAditionalFAQLanguages();

=cut

sub _CreateAditionalFAQLanguages {
    my ( $Self, %Param ) = @_;

    # get system default language
    my $Language = $Kernel::OM->Get('Kernel::Config')->Get('DefaultLanguage');
    if ($Language) {

        # get FAQ object
        my $FAQObject = $Kernel::OM->Get('Kernel::System::FAQ');

        # get current FAQ languages
        my %CurrentLanguages = $FAQObject->LanguageList(
            UserID => 1,
        );

        # use reverse hash for easy lookup
        my %ReverseLanguages = reverse %CurrentLanguages;

        # check if language is already defined
        if ( !$ReverseLanguages{$Language} ) {

            # add language
            my $Success = $FAQObject->LanguageAdd(
                Name   => $Language,
                UserID => 1,
            );
        }
    }

    return 1;
}

=head2 _CategoryGroupSet()

Adds the given group permissions to the given category.

    my $Result = $CodeObject->_CategoryGroupSet(
        Category => 'Misc',
        Groups   => [ 'admin', 'users' ],
    );

=cut

sub _CategoryGroupSet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(Category Groups)) {
        if ( !$Param{$Argument} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );

            return;
        }
    }

    # check needed stuff
    if ( ref $Param{Groups} ne 'ARRAY' ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Groups must be an array reference!",
        );

        return;
    }

    # get FAQ object
    my $FAQObject = $Kernel::OM->Get('Kernel::System::FAQ');

    # get all categories and their ids
    my $CategoryTree = $FAQObject->CategoryTreeList(
        Valid  => 1,
        UserID => 1,
    );

    # create lookup hash for the category id
    my %FAQ2ID = reverse %{$CategoryTree};

    # lookup the category id
    my $CategoryID = $FAQ2ID{ $Param{Category} };

    # lookup the group ids
    my @GroupIDs;
    for my $Group ( @{ $Param{Groups} } ) {
        my $GroupID = $Kernel::OM->Get('Kernel::System::Group')->GroupLookup(
            Group => $Group,
        );
        push @GroupIDs, $GroupID;
    }

    # set category group
    $FAQObject->SetCategoryGroup(
        CategoryID => $CategoryID,
        GroupIDs   => \@GroupIDs,
        UserID     => 1,
    );

    return 1;
}

=head2 _DynamicFieldsDelete()

delete all existing dynamic fields for FAQ

    my $Result = $CodeObject->_DynamicFieldsDelete();

=cut

sub _DynamicFieldsDelete {
    my ( $Self, %Param ) = @_;

    my $DynamicFieldObject      = $Kernel::OM->Get('Kernel::System::DynamicField');
    my $DynamicFieldValueObject = $Kernel::OM->Get('Kernel::System::DynamicFieldValue');

    # get the list of FAQ dynamic fields (valid and invalid ones)
    my $DynamicFieldList = $DynamicFieldObject->DynamicFieldListGet(
        Valid      => 0,
        ObjectType => ['FAQ'],
    );

    # delete the dynamic fields
    DYNAMICFIELD:
    for my $DynamicField ( @{$DynamicFieldList} ) {

        # delete all field values
        my $ValuesDeleteSuccess = $DynamicFieldValueObject->AllValuesDelete(
            FieldID => $DynamicField->{ID},
            UserID  => 1,
        );

        # values could be deleted
        if ($ValuesDeleteSuccess) {

            # delete field
            my $Success = $DynamicFieldObject->DynamicFieldDelete(
                ID     => $DynamicField->{ID},
                UserID => 1,
            );

            # check error
            if ( !$Success ) {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  => "Could not delete dynamic field '$DynamicField->{Name}'!",
                );
            }
        }

        # values could not be deleted
        else {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Could not delete values for dynamic field '$DynamicField->{Name}'!",
            );
        }
    }

    return 1;
}

sub _MigrateDTLInSysConfig {

    my $ConfigObject    = $Kernel::OM->Get('Kernel::Config');
    my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');
    my $ProviderObject  = Kernel::Output::Template::Provider->new();

    # Get setting's content.
    my $Setting = $ConfigObject->Get('FAQ::Frontend::MenuModule');
    return if !$Setting;

    my @NewSettings;

    MENUMODULE:
    for my $MenuModule ( sort keys %{$Setting} ) {

        SETTINGITEM:
        for my $SettingItem ( sort keys %{ $Setting->{$MenuModule} } ) {

            my $SettingContent = $Setting->{$MenuModule}->{$SettingItem};

            # Do nothing no value for migrating.
            next SETTINGITEM if !$SettingContent;

            my $TTContent;
            eval {
                $TTContent = $ProviderObject->MigrateDTLtoTT( Content => $SettingContent );
            };
            if ($@) {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  => "$MenuModule->$SettingItem : $@!",
                );
            }
            else {
                $Setting->{$MenuModule}->{$SettingItem} = $TTContent;
            }
        }

        push @NewSettings, {
            Name           => "FAQ::Frontend::MenuModule###$MenuModule",
            EffectiveValue => $Setting->{$MenuModule},
            IsValid        => 1,
        };
    }

    my $Success = $SysConfigObject->SettingsSet(
        UserID   => 1,
        Comments => 'Deploy FAQ menu module.',
        Settings => \@NewSettings,
    );

    return 1;
}

sub _MigrateConfigs {

    my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');
    my $ConfigObject    = $Kernel::OM->Get('Kernel::Config');

    # Migrate FAQ menu modules.
    # Get setting content for FAQ menu modules.
    my $Setting = $ConfigObject->Get('FAQ::Frontend::MenuModule');

    my @NewSettings;
    MENUMODULE:
    for my $MenuModule ( sort keys %{$Setting} ) {

        # Update module location.
        my $Module = $Setting->{$MenuModule}->{'Module'};
        if ( $Module !~ m{Kernel::Output::HTML::FAQMenu(\w+)} ) {
            next MENUMODULE;
        }

        $Setting->{$MenuModule}->{Module} = "Kernel::Output::HTML::FAQMenu::Generic";

        # Build new setting.
        push @NewSettings, {
            Name           => 'FAQ::Frontend::MenuModule###' . $MenuModule,
            EffectiveValue => $Setting->{$MenuModule},
        };
    }

    # Migrate FAQ config items.
    my @Configs = (
        {
            Name       => 'Frontend::HeaderMetaModule',
            ConfigItem => '3-FAQSearch',
            Module     => 'Kernel::Output::HTML::HeaderMeta::AgentFAQSearch',
        },
        {
            Name       => 'CustomerFrontend::HeaderMetaModule',
            ConfigItem => '3-FAQSearch',
            Module     => 'Kernel::Output::HTML::HeaderMeta::CustomerFAQSearch',
        },
        {
            Name       => 'PublicFrontend::HeaderMetaModule',
            ConfigItem => '3-FAQSearch',
            Module     => 'Kernel::Output::HTML::HeaderMeta::PublicFAQSearch',
        },
        {
            Name       => 'Frontend::Output::FilterElementPost',
            ConfigItem => 'FAQ',
            Module     => 'Kernel::Output::HTML::FilterElementPost::FAQ',
        },
        {
            Name       => 'FAQ::Frontend::Overview',
            ConfigItem => 'Small',
            Module     => 'Kernel::Output::HTML::FAQOverview::Small',
        },
        {
            Name       => 'FAQ::Frontend::JournalOverview',
            ConfigItem => 'Small',
            Module     => 'Kernel::Output::HTML::FAQJournalOverview::Small',
        },
        {
            Name       => 'PreferencesGroups',
            ConfigItem => 'FAQOverviewSmallPageShown',
            Module     => 'Kernel::Output::HTML::Preferences::Generic',
        },
        {
            Name       => 'PreferencesGroups',
            ConfigItem => 'FAQJournalOverviewSmallPageShown',
            Module     => 'Kernel::Output::HTML::Preferences::Generic',
        },
        {
            Name       => 'DashboardBackend',
            ConfigItem => '0398-FAQ-LastChange',
            Module     => 'Kernel::Output::HTML::Dashboard::FAQ',
        },
        {
            Name       => 'DashboardBackend',
            ConfigItem => '0399-FAQ-LastCreate',
            Module     => 'Kernel::Output::HTML::Dashboard::FAQ',
        },
        {
            Name       => 'Frontend::ToolBarModule',
            ConfigItem => '90-FAQ::AgentFAQAdd',
            Module     => 'Kernel::Output::HTML::ToolBar::Link',
        },
    );

    CONFIGITEM:
    for my $Config (@Configs) {

        # Get setting content for header meta FAQ search.
        my $Setting = $ConfigObject->Get( $Config->{Name} );
        next CONFIGITEM if !$Setting;

        my $ConfigItem = $Config->{ConfigItem};
        next CONFIGITEM if !$Setting->{$ConfigItem}->{'Module'};

        # Set module.
        $Setting->{$ConfigItem}->{'Module'} = $Config->{Module};

        # Build new setting.
        push @NewSettings, {
            Name           => $Config->{Name} . '###' . $ConfigItem,
            EffectiveValue => $Setting->{$ConfigItem},
        };
    }

    return 1 if !@NewSettings;

    # Write new setting.
    $SysConfigObject->SettingsSet(
        UserID   => 1,
        Comments => 'FAQ - package setup function: _MigrateConfigs',
        Settings => \@NewSettings,
    );

    return 1;
}

sub _SetContentType {

    return $Kernel::OM->Get('Kernel::System::FAQ')->FAQContentTypeSet();
}

sub _GetOTRS5ConfigBackup {
    my $Config = {};

    my $FileClass = 'Kernel::Config::Backups::ZZZAutoOTRS5';
    delete $INC{$FileClass};

    if (
        $Kernel::OM->Get('Kernel::System::Main')->Require(
            $FileClass,
            Silent => 1,
        )
        )
    {
        $FileClass->Load($Config);
    }

    return $Config;
}

sub _MigratePermissions {
    my ( $Self, %Param ) = @_;

    my $OldConfig = $Self->_GetOTRS5ConfigBackup();
    my $NewConfig = $Kernel::OM->Get('Kernel::Config');

    my $GetConfig = sub {
        my $Source      = shift;
        my $SettingName = shift;

        my $Config = $Source;
        my @Keys   = split '###', $SettingName;
        while ( my $Key = shift @Keys ) {
            $Config = $Config->{$Key};
        }

        return $Config;
    };

    my @NewSettings       = ();
    my @SettingsToMigrate = (
        {
            Name     => 'Frontend::Module###AgentFAQExplorer',
            Defaults => {
                Group   => ['faq'],
                GroupRo => ['faq'],
                NavBar  => [
                    {
                        Name    => 'FAQ',
                        Block   => 'ItemArea',
                        GroupRo => ['faq']
                    },
                    {
                        Name    => 'Explorer',
                        Block   => '',
                        GroupRo => ['faq']
                    },
                ],
            },
        },

        {
            Name     => 'Frontend::Module###AgentFAQLanguage',
            Defaults => {
                Group  => ['faq_admin'],
                NavBar => [
                    {
                        Name  => 'Language Management',
                        Block => '',
                        Group => ['faq_admin'],
                    },
                ],
            },
        },

        {
            Name     => 'Frontend::Module###AgentFAQEdit',
            Defaults => {
                Group => ['faq'],
            },
        },

        {
            Name     => 'Frontend::Module###AgentFAQAdd',
            Defaults => {
                Group  => ['faq'],
                NavBar => [
                    {
                        Name  => 'New',
                        Block => '',
                        Group => ['faq'],
                    },
                ],
            },
        },

        {
            Name     => 'Frontend::Module###AgentFAQCategory',
            Defaults => {
                Group  => ['faq_admin'],
                NavBar => [
                    {
                        Name  => 'Category Management',
                        Block => '',
                        Group => ['faq_admin'],
                    },
                ],
            },
        },

        {
            Name     => 'Frontend::Module###AgentFAQSearch',
            Defaults => {
                Group   => ['faq'],
                GroupRo => ['faq'],
                NavBar  => [
                    {
                        Name    => 'Search',
                        Block   => '',
                        GroupRo => ['faq'],
                    },
                ],
            },
        },

        {
            Name     => 'Frontend::Module###AgentFAQSearchSmall',
            Defaults => {
                Group   => ['faq'],
                GroupRo => ['faq'],
            },
        },

        {
            Name     => 'Frontend::Module###AgentFAQZoom',
            Defaults => {
                Group   => ['faq'],
                GroupRo => ['faq'],
            },
        },

        {
            Name     => 'Frontend::Module###AgentFAQRichText',
            Defaults => {
                Group   => ['faq'],
                GroupRo => ['faq'],
            },
        },

        {
            Name     => 'Frontend::Module###AgentFAQPrint',
            Defaults => {
                Group => ['faq'],
            },
        },

        {
            Name     => 'Frontend::Module###AgentFAQJournal',
            Defaults => {
                Group   => ['faq'],
                GroupRo => ['faq'],
                NavBar  => [
                    {
                        Name    => 'Journal',
                        Block   => '',
                        GroupRo => ['faq'],
                    }
                ],
            },
        },

        {
            Name     => 'Frontend::Module###AgentFAQHistory',
            Defaults => {
                Group   => ['faq'],
                GroupRo => ['faq'],
            },
        },

        {
            Name     => 'Frontend::Module###AgentFAQDelete',
            Defaults => {
                Group => ['faq'],
            },
        },

        {
            Name     => 'DashboardBackend###0398-FAQ-LastChange',
            Defaults => {
                Group => 'faq',
            },
        },

        {
            Name     => 'DashboardBackend###0399-FAQ-LastCreate',
            Defaults => {
                Group => 'faq',
            },
        },

        {
            Name     => 'FAQ::ApprovalGroup',
            Defaults => 'faq_approval',
        },
    );

    my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

    SETTING:
    for my $Setting (@SettingsToMigrate) {
        my $SettingOldConfig = $GetConfig->( $OldConfig, $Setting->{Name}, );
        my $SettingDefaults  = $Setting->{Defaults};

        if ( $Setting->{Name} eq 'FAQ::ApprovalGroup' ) {

            my $EffectiveValue = $SettingOldConfig // $SettingDefaults;

            push @NewSettings, {
                Name           => $Setting->{Name},
                EffectiveValue => $EffectiveValue,
                IsValid        => 1,
            };

            next SETTING;
        }

        my @GroupGroupRo = qw( Group GroupRo );

        {
            my $NewSetting = $GetConfig->( $NewConfig, $Setting->{Name} );

            # Check for GroupGroupRo.
            for my $Key (@GroupGroupRo) {
                if ( defined $SettingOldConfig->{$Key} || defined $SettingDefaults->{$Key} ) {
                    $NewSetting->{$Key} = $SettingOldConfig->{$Key} // $SettingDefaults->{$Key};
                }
            }

            push @NewSettings, {
                Name           => $Setting->{Name},
                EffectiveValue => $NewSetting,
                IsValid        => 1,
            };
        }

        # Check for NavBar => Navigation.
        if ( $SettingOldConfig->{NavBar} || $SettingDefaults->{NavBar} ) {
            my ( undef, $Frontend ) = split '###', $Setting->{Name};
            my $NewSetting = $GetConfig->( $NewConfig, "Frontend::Navigation###${ Frontend }" );

            for my $Index ( sort keys %{$NewSetting} ) {
                my $NewItems = $NewSetting->{$Index};
                for my $NewItem ( @{$NewItems} ) {

                    SOURCE:
                    for my $Source ( ( $SettingOldConfig->{NavBar}, $SettingDefaults->{NavBar} ) ) {
                        my $OldItem
                            = List::Util::first { $_->{Name} eq $NewItem->{Name} && $_->{Block} eq $NewItem->{Block} }
                        @{$Source};
                        next SOURCE if !$OldItem;

                        for my $Key (@GroupGroupRo) {
                            if ( defined $OldItem->{$Key} ) {
                                $NewItem->{$Key} = $OldItem->{$Key};
                            }
                        }
                        last SOURCE;
                    }
                }

                push @NewSettings, {
                    Name           => "Frontend::Navigation###${ Frontend }###${ Index }",
                    EffectiveValue => $NewSetting->{$Index},
                    IsValid        => 1,
                };
            }
        }
    }

    # Deploy the new settings.
    my $SettingsDeployed = $SysConfigObject->SettingsSet(
        UserID   => 1,
        Comments => 'FAQ - package setup function: _MigratePermissions',
        Settings => \@NewSettings,
    );
    if ( !$SettingsDeployed ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Message  => "Error while deploying the migrated permissions!",
            Priority => 'error',
        );
    }

    return 1;
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<https://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
