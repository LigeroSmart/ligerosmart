# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Modules::DevelFred;

use strict;
use warnings;

our $ObjectManagerDisabled = 1;

use Kernel::Language qw(Translatable);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    $Self->{Subaction} = $Kernel::OM->Get('Kernel::System::Web::Request')->GetParam( Param => 'Subaction' );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $ParamObject  = $Kernel::OM->Get('Kernel::System::Web::Request');

    # ---------------------------------------------------------- #
    # show the overview
    # ---------------------------------------------------------- #

    if ( !$Self->{Subaction} ) {
        my $Version = $ConfigObject->Get('Version');

        $LayoutObject->FatalError(
            Message => 'Sorry, this page is currently under development!',
        );
    }

    # ---------------------------------------------------------- #
    # fast handle for fred settings
    # ---------------------------------------------------------- #
    elsif ( $Self->{Subaction} eq 'Setting' ) {

        # get hashref with all Fred-plugins
        my $ModuleForRef = $ConfigObject->Get('Fred::Module');

        # The Console can't be deactivated
        delete $ModuleForRef->{Console};

        # loop over Modules which can be activated and deactivated
        for my $Module ( sort keys %{$ModuleForRef} ) {
            my $Checked = $ModuleForRef->{$Module}->{Active} ? 'checked="checked"' : '';
            $LayoutObject->Block(
                Name => 'FredModule',
                Data => {
                    FredModule  => $Module,
                    Checked     => $Checked,
                    Description => $ModuleForRef->{$Module}->{Description} || '',
                },
            );

            # Provide a link to the SysConfig only for plugins that have config options
            if ( $ConfigObject->Get("Fred::$Module") ) {
                $LayoutObject->Block(
                    Name => 'Config',
                    Data => {
                        ModuleName => $Module,
                    }
                );
            }
        }

        # build output
        my $Output = $LayoutObject->Header(
            Title => 'Fred-Setting',
            Type  => 'Small',
        );
        $Output .= $LayoutObject->Output(
            Data         => {%Param},
            TemplateFile => 'DevelFredSetting',
        );
        $Output .= $LayoutObject->Footer(
            Type => 'Small',
        );

        return $Output;
    }

    # ---------------------------------------------------------- #
    # fast handle for fred settings
    # ---------------------------------------------------------- #
    elsif ( $Self->{Subaction} eq 'SettingAction' ) {
        my $ModuleForRef        = $ConfigObject->Get('Fred::Module');
        my @SelectedFredModules = $ParamObject->GetArray( Param => 'FredModule' );
        my %SelectedModules     = map { $_ => 1; } @SelectedFredModules;
        my $UpdateFlag;
        delete $ModuleForRef->{Console};

        for my $Module ( sort keys %{$ModuleForRef} ) {

            # update the sysconfig settings
            if (
                $ModuleForRef->{$Module}->{Active} && !$SelectedModules{$Module}
                ||
                !$ModuleForRef->{$Module}->{Active} && $SelectedModules{$Module}
                )
            {
                # update certain values
                $ModuleForRef->{$Module}->{Active} = $SelectedModules{$Module} || 0;

                $Self->_SettingUpdate(
                    Valid => 1,
                    Key   => "Fred::Module###$Module",
                    Value => $ModuleForRef->{$Module},
                );
                $UpdateFlag = 1;
            }
        }

        return $LayoutObject->PopupClose(
            Reload => 1,
        );
    }

    # ---------------------------------------------------------- #
    # handle for config switch
    # ---------------------------------------------------------- #
    elsif ( $Self->{Subaction} eq 'ConfigSwitchAJAX' ) {

        my $ItemKey   = $ParamObject->GetParam( Param => 'Key' );
        my $ItemValue = $ParamObject->GetParam( Param => 'Value' );

        my $Success = 0;

        if ($ItemKey) {

            # the value which is passed is the current value, so we
            # need to switch it.
            if ( $ItemValue == 1 ) {
                $ItemValue = 0;
            }
            else {
                $ItemValue = 1;
            }

            $Self->_SettingUpdate(
                Valid => 1,
                Key   => $ItemKey,
                Value => $ItemValue,
            );
            $Success = 1;
        }

        return $LayoutObject->Attachment(
            ContentType => 'application/json; charset=' . $LayoutObject->{Charset},
            Content     => $Success,
            Type        => 'inline',
            NoCache     => 1,
        );
    }

    return 1;
}

sub _SettingUpdate {
    my ( $Self, %Param ) = @_;

    my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

    # OTRS 5 SysConfig API
    if ( $SysConfigObject->can('ConfigItemUpdate') ) {
        ## nofilter(TidyAll::Plugin::OTRS::Migrations::OTRS6::SysConfig)
        $SysConfigObject->ConfigItemUpdate(%Param);
    }

    # OTRS 6+ SysConfig API
    else {
        my $SettingName = 'SecureMode';

        my $ExclusiveLockGUID = $SysConfigObject->SettingLock(
            Name   => $Param{Key},
            Force  => 1,
            UserID => 1,
        );

        # Update config item via SysConfig object.
        my $Result = $SysConfigObject->SettingUpdate(
            Name              => $Param{Key},
            IsValid           => $Param{Valid},
            EffectiveValue    => $Param{Value},
            ExclusiveLockGUID => $ExclusiveLockGUID,
            UserID            => 1,
        );

        if ( !$Result ) {
            $Kernel::OM->Get('Kernel::Output::HTML::Layout')->FatalError(
                Message => Translatable('Can\'t write Config file!'),
            );
        }

        # There is no need to unlock the setting as it was already unlocked in the update.

        # 'Rebuild' the configuration.
        my $Success = $SysConfigObject->ConfigurationDeploy(
            Comments    => "Installer deployment",
            AllSettings => 1,
            Force       => 1,
            UserID      => 1,
        );
    }

    return 1;
}

1;
