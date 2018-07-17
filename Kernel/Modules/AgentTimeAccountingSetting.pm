# --
# Copyright (C) 2001-2018 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentTimeAccountingSetting;

use strict;
use warnings;

use Kernel::Language qw(Translatable);

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # get needed objects
    my $ParamObject          = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $TimeAccountingObject = $Kernel::OM->Get('Kernel::System::TimeAccounting');
    my $LayoutObject         = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $LogObject            = $Kernel::OM->Get('Kernel::System::Log');
    my $UserObject           = $Kernel::OM->Get('Kernel::System::User');

    # expression add time period was pressed
    if (
        $ParamObject->GetParam( Param => 'AddPeriod' )
        || $ParamObject->GetParam( Param => 'SubmitUserData' )
        )
    {

        my %GetParam = ();

        $GetParam{UserID} = $ParamObject->GetParam( Param => 'UserID' );
        my $Periods = $TimeAccountingObject->UserLastPeriodNumberGet(
            UserID => $GetParam{UserID},
        );

        # check validity of periods
        my %Errors = $Self->_CheckValidityUserPeriods(
            Period => $Periods,
        );

        # if the period data is OK
        if ( !%Errors ) {

            # get all parameters
            for my $Parameter (qw(Subaction Description Calendar)) {
                $GetParam{$Parameter} = $ParamObject->GetParam( Param => $Parameter );
            }
            for my $Parameter (qw(ShowOvertime CreateProject AllowSkip)) {
                $GetParam{$Parameter} = $ParamObject->GetParam( Param => $Parameter ) || 0;
            }

            my $Period = 1;
            my %PeriodData;

            my %UserData = $TimeAccountingObject->SingleUserSettingsGet(
                UserID => $GetParam{UserID}
            );

            # get parameters for all registered periods
            while ( $UserData{$Period} ) {
                for my $Parameter (qw(WeeklyHours Overtime DateStart DateEnd LeaveDays)) {
                    $PeriodData{$Period}{$Parameter} = $ParamObject->GetParam( Param => $Parameter . "[$Period]" )
                        || $UserData{$Period}{$Parameter};
                }
                $PeriodData{$Period}{UserStatus} = $ParamObject->GetParam( Param => "PeriodStatus[$Period]" ) || 0;
                $Period++;
            }
            $GetParam{Period} = \%PeriodData;

            # update periods
            if ( !$TimeAccountingObject->UserSettingsUpdate(%GetParam) ) {

                return $LayoutObject->ErrorScreen(
                    Message => Translatable('Unable to update user settings!'),
                    Comment => Translatable('Please contact the administrator.'),
                );
            }
            if ( $ParamObject->GetParam( Param => 'AddPeriod' ) ) {

                # show the edit time settings again, but now with a new empty time period line
                return $LayoutObject->Redirect(
                    OP =>
                        "Action=AgentTimeAccountingSetting;Subaction=$GetParam{Subaction};UserID=$GetParam{UserID};"
                        . "NewTimePeriod=1",
                );
            }
            else {

                # show the overview of tasks and users
                return $LayoutObject->Redirect(
                    OP => "Action=AgentTimeAccountingSetting;User=$Self->{Subaction}",
                );
            }
        }
    }

    # ---------------------------------------------------------- #
    # add project
    # ---------------------------------------------------------- #
    if ( $Self->{Subaction} eq 'AddProject' ) {
        my $Output = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar();
        $Self->_ProjectSettingsEdit( Action => 'AddProject' );
        $Output .= $LayoutObject->Output(
            TemplateFile => 'AgentTimeAccountingSetting',
            Data         => \%Param,
        );
        $Output .= $LayoutObject->Footer();
        return $Output;
    }

    # ---------------------------------------------------------- #
    # add project action
    # ---------------------------------------------------------- #
    elsif ( $Self->{Subaction} eq 'AddProjectAction' ) {

        # challenge token check for write action
        $LayoutObject->ChallengeTokenCheck();

        my $Note = '';
        my $ProjectID;
        my ( %GetParam, %Errors );

        # get parameters
        for my $Parameter (qw(Project ProjectDescription)) {
            $GetParam{$Parameter} = $ParamObject->GetParam( Param => $Parameter ) || '';
        }
        $GetParam{ProjectStatus} = $ParamObject->GetParam( Param => 'ProjectStatus' )
            || '0';

        # check for needed data
        if ( !$GetParam{Project} ) {
            $Errors{ProjectInvalid}   = 'ServerError';
            $Errors{ProjectErrorType} = 'ProjectMissingValue';
        }
        else {

            # check that the name is unique
            my %ExistingProject = $TimeAccountingObject->ProjectGet(
                Project => $GetParam{Project},
            );
            if (%ExistingProject) {
                $Errors{ProjectInvalid}   = 'ServerError';
                $Errors{ProjectErrorType} = 'ProjectDuplicateName';
            }
        }

        # if no errors occurred
        if ( !%Errors ) {

            # add project
            $ProjectID = $TimeAccountingObject->ProjectSettingsInsert(
                %GetParam,
            );

            if ($ProjectID) {

                # build the output
                $Self->_SettingOverview();
                my $Output = $LayoutObject->Header();
                $Output .= $LayoutObject->NavigationBar();
                $Output .= $LayoutObject->Notify(
                    Info => Translatable('Project added!'),
                );
                $Output .= $LayoutObject->Output(
                    TemplateFile => 'AgentTimeAccountingSetting',
                    Data         => {%GetParam},
                );
                $Output .= $LayoutObject->Footer();

                return $Output;
            }
            else {
                $Note = $LogObject->GetLogEntry(
                    Type => 'Error',
                    What => 'Message',
                );
            }
        }

        # something went wrong
        my $Output = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar();
        $Output .= $Note
            ? $LayoutObject->Notify(
            Priority => 'Error',
            Info     => $Note,
            )
            : '';
        $Self->_ProjectSettingsEdit(
            Action => 'AddProject',
            %GetParam,
            %Errors,
        );
        $Output .= $LayoutObject->Output(
            TemplateFile => 'AgentTimeAccountingSetting',
            Data         => \%Param,
        );
        $Output .= $LayoutObject->Footer();

        return $Output;
    }

    # ---------------------------------------------------------- #
    # edit project
    # ---------------------------------------------------------- #
    elsif ( $Self->{Subaction} eq 'EditProject' ) {
        my $ID = $ParamObject->GetParam( Param => 'ID' );

        # get project data
        my %Project = $TimeAccountingObject->ProjectGet(
            ID => $ID,
        );

        my $Output = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar();
        $Self->_ProjectSettingsEdit(
            Action => 'EditProject',
            %Project,
        );
        $Output .= $LayoutObject->Output(
            TemplateFile => 'AgentTimeAccountingSetting',
            Data         => \%Param,
        );
        $Output .= $LayoutObject->Footer();

        return $Output;
    }

    # ---------------------------------------------------------- #
    # edit project action
    # ---------------------------------------------------------- #
    elsif ( $Self->{Subaction} eq 'EditProjectAction' ) {

        # challenge token check for write action
        $LayoutObject->ChallengeTokenCheck();

        my $Note = '';
        my ( %GetParam, %Errors );

        # get parameters
        $GetParam{ID} = $ParamObject->GetParam( Param => 'ID' ) || '';
        $GetParam{ProjectStatus} = $ParamObject->GetParam( Param => 'ProjectStatus' )
            || '0';
        for my $Parameter (qw(Project ProjectDescription)) {
            $GetParam{$Parameter} = $ParamObject->GetParam( Param => $Parameter ) || '';
        }

        # check for needed data
        if ( !$GetParam{Project} ) {
            $Errors{ProjectInvalid} = 'ServerError';
        }
        else {

            # check that the name is unique
            my %ExistingProject = $TimeAccountingObject->ProjectGet(
                Project => $GetParam{Project},
            );

            # if the project name is found, check that the ID is different
            if ( %ExistingProject && $ExistingProject{ID} ne $GetParam{ID} ) {
                $Errors{ProjectInvalid}   = 'ServerError';
                $Errors{ProjectErrorType} = 'ProjectDuplicateName';
            }
        }

        # if no errors occurred
        if ( !%Errors ) {

            # edit project
            if ( $TimeAccountingObject->ProjectSettingsUpdate(%GetParam) ) {

                $Self->_SettingOverview();
                my $Output = $LayoutObject->Header();
                $Output .= $LayoutObject->NavigationBar();
                $Output .= $LayoutObject->Notify(
                    Info => Translatable('Project updated!'),
                );
                $Output .= $LayoutObject->Output(
                    TemplateFile => 'AgentTimeAccountingSetting',
                    Data         => \%Param,
                );
                $Output .= $LayoutObject->Footer();

                return $Output;
            }
            else {
                $Note = $LogObject->GetLogEntry(
                    Type => 'Error',
                    What => 'Message',
                );
            }
        }

        # something went wrong
        my $Output = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar();
        $Output .= $Note
            ? $LayoutObject->Notify(
            Priority => 'Error',
            Info     => $Note,
            )
            : '';
        $Self->_ProjectSettingsEdit(
            Action => 'EditProject',
            %GetParam,
            %Param,
            %Errors,
        );
        $Output .= $LayoutObject->Output(
            TemplateFile => 'AgentTimeAccountingSetting',
            Data         => \%Param,
        );
        $Output .= $LayoutObject->Footer();

        return $Output;
    }

    # ---------------------------------------------------------- #
    # add task
    # ---------------------------------------------------------- #
    elsif ( $Self->{Subaction} eq 'AddTask' ) {
        my $Output = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar();
        $Self->_TaskSettingsEdit( Action => 'AddTask' );
        $Output .= $LayoutObject->Output(
            TemplateFile => 'AgentTimeAccountingSetting',
            Data         => \%Param,
        );
        $Output .= $LayoutObject->Footer();

        return $Output;
    }

    # ---------------------------------------------------------- #
    # add task action
    # ---------------------------------------------------------- #
    elsif ( $Self->{Subaction} eq 'AddTaskAction' ) {

        # challenge token check for write action
        $LayoutObject->ChallengeTokenCheck();

        my $Note = '';
        my $TaskID;
        my ( %GetParam, %Errors );

        # get parameters
        $GetParam{Task} = $ParamObject->GetParam( Param => 'Task' ) || '';
        $GetParam{TaskStatus} = $ParamObject->GetParam( Param => 'TaskStatus' )
            || '0';

        # check for needed data
        if ( !$GetParam{Task} ) {
            $Errors{TaskInvalid}   = 'ServerError';
            $Errors{TaskErrorType} = 'TaskMissingValue';
        }
        else {

            # check that the name is unique
            my %ExistingTask = $TimeAccountingObject->ActionGet(
                Action => $GetParam{Task},
            );
            if (%ExistingTask) {
                $Errors{TaskInvalid}   = 'ServerError';
                $Errors{TaskErrorType} = 'TaskDuplicateName';
            }
        }

        # if no errors occurred
        if ( !%Errors ) {

            # add task
            $TaskID = $TimeAccountingObject->ActionSettingsInsert(
                Action       => $GetParam{Task},
                ActionStatus => $GetParam{TaskStatus},
            );

            if ($TaskID) {

                # build the output
                $Self->_SettingOverview();
                my $Output = $LayoutObject->Header();
                $Output .= $LayoutObject->NavigationBar();
                $Output .= $LayoutObject->Notify(
                    Info => Translatable('Task added!'),
                );
                $Output .= $LayoutObject->Output(
                    TemplateFile => 'AgentTimeAccountingSetting',
                    Data         => {},
                );
                $Output .= $LayoutObject->Footer();

                return $Output;
            }
            else {
                $Note = $LogObject->GetLogEntry(
                    Type => 'Error',
                    What => 'Message',
                );
            }
        }

        # something went wrong
        my $Output = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar();
        $Output .= $Note
            ? $LayoutObject->Notify(
            Priority => 'Error',
            Info     => $Note,
            )
            : '';
        $Self->_TaskSettingsEdit(
            Action => 'AddTask',
            %GetParam,
            %Errors,
        );
        $Output .= $LayoutObject->Output(
            TemplateFile => 'AgentTimeAccountingSetting',
            Data         => \%Param,
        );
        $Output .= $LayoutObject->Footer();

        return $Output;
    }

    # ---------------------------------------------------------- #
    # edit task
    # ---------------------------------------------------------- #
    elsif ( $Self->{Subaction} eq 'EditTask' ) {
        my $ID = $ParamObject->GetParam( Param => 'ActionID' ) || '';

        # get project data
        my %Task = $TimeAccountingObject->ActionGet(
            ID => $ID,
        );

        my %TaskData = (
            Task       => $Task{Action},
            TaskStatus => $Task{ActionStatus},
        );

        my $Output = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar();
        $Self->_TaskSettingsEdit(
            Action   => 'EditTask',
            ActionID => $ID,
            %TaskData,
        );
        $Output .= $LayoutObject->Output(
            TemplateFile => 'AgentTimeAccountingSetting',
            Data         => \%Param,
        );
        $Output .= $LayoutObject->Footer();

        return $Output;
    }

    # ---------------------------------------------------------- #
    # edit project action
    # ---------------------------------------------------------- #
    elsif ( $Self->{Subaction} eq 'EditTaskAction' ) {

        # challenge token check for write action
        $LayoutObject->ChallengeTokenCheck();

        my $Note = '';
        my ( %GetParam, %Errors );

        # get parameters
        $GetParam{ActionID}   = $ParamObject->GetParam( Param => 'ActionID' )   || '';
        $GetParam{TaskStatus} = $ParamObject->GetParam( Param => 'TaskStatus' ) || '0';
        $GetParam{Task}       = $ParamObject->GetParam( Param => 'Task' )       || '';

        # check for needed data
        if ( !$GetParam{Task} ) {
            $Errors{TaskInvalid} = 'ServerError';
        }
        else {

            # check that the name is unique
            my %ExistingTask = $TimeAccountingObject->ActionGet(
                Action => $GetParam{Task},
            );

            # if the task name is found, check that the ID is different
            if ( %ExistingTask && $ExistingTask{ID} ne $GetParam{ActionID} ) {
                $Errors{TaskInvalid}   = 'ServerError';
                $Errors{TaskErrorType} = 'TaskDuplicateName';
            }
        }

        # if no errors occurred
        if ( !%Errors ) {

            # edit action (task)
            my $ActionUpdate = $TimeAccountingObject->ActionSettingsUpdate(
                ActionID     => $GetParam{ActionID},
                Action       => $GetParam{Task},
                ActionStatus => $GetParam{TaskStatus},
            );

            if ($ActionUpdate) {
                $Self->_SettingOverview();
                my $Output = $LayoutObject->Header();
                $Output .= $LayoutObject->NavigationBar();
                $Output .= $LayoutObject->Notify(
                    Info => Translatable('Task updated!'),
                );
                $Output .= $LayoutObject->Output(
                    TemplateFile => 'AgentTimeAccountingSetting',
                    Data         => \%Param,
                );
                $Output .= $LayoutObject->Footer();

                return $Output;
            }
            else {
                $Note = $LogObject->GetLogEntry(
                    Type => 'Error',
                    What => 'Message',
                );
            }
        }

        # something went wrong
        my $Output = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar();
        $Output .= $Note
            ? $LayoutObject->Notify(
            Priority => 'Error',
            Info     => $Note,
            )
            : '';
        $Self->_TaskSettingsEdit(
            Action => 'EditTask',
            %GetParam,
            %Param,
            %Errors,
        );
        $Output .= $LayoutObject->Output(
            TemplateFile => 'AgentTimeAccountingSetting',
            Data         => \%Param,
        );
        $Output .= $LayoutObject->Footer();

        return $Output;
    }

    # ---------------------------------------------------------- #
    # add user
    # ---------------------------------------------------------- #
    elsif ( $Self->{Subaction} eq 'AddUser' ) {

        # get parameters
        my $NewUserID = $ParamObject->GetParam( Param => 'NewUserID' )
            || $ParamObject->GetParam( Param => 'UserID' )
            || '';
        if ( !$NewUserID ) {

            return $LayoutObject->ErrorScreen(
                Message => Translatable('The UserID is not valid!'),
            );
        }

        my $NewTimePeriod = $ParamObject->GetParam( Param => 'NewTimePeriod' );

        my $LastPeriodNumber = $TimeAccountingObject->UserLastPeriodNumberGet(
            UserID => $NewUserID,
        );

        my $Success = $TimeAccountingObject->UserSettingsInsert(
            UserID => $NewUserID,
            Period => $LastPeriodNumber + 1,
        );

        # if it is not an action about adding a new time period
        if ( !$NewTimePeriod && !$Success ) {
            return $LayoutObject->ErrorScreen(
                Message => Translatable('Can\'t insert user data!'),
            );
        }

        my %User = $UserObject->GetUserData(
            UserID => $NewUserID,
        );
        my $Output = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar();
        $Self->_UserSettingsEdit(
            Action    => 'AddUser',
            Subaction => 'AddUser',
            %User,
        );
        $Output .= $LayoutObject->Output(
            TemplateFile => 'AgentTimeAccountingSetting',
            Data         => \%Param,
        );
        $Output .= $LayoutObject->Footer();

        return $Output;
    }

    # ---------------------------------------------------------- #
    # edit user settings
    # ---------------------------------------------------------- #
    elsif ( $Self->{Subaction} eq 'EditUser' ) {
        my $ID = $ParamObject->GetParam( Param => 'UserID' ) || '';
        if ( !$ID ) {

            return $LayoutObject->ErrorScreen(
                Message => Translatable('The UserID is not valid!'),
            );
        }

        my $NewTimePeriod = $ParamObject->GetParam( Param => 'NewTimePeriod' );
        my $LastPeriodNumber = $TimeAccountingObject->UserLastPeriodNumberGet(
            UserID => $ID,
        );

        # if it is an action about adding a new time period, insert it
        if ($NewTimePeriod) {
            my $Success = $TimeAccountingObject->UserSettingsInsert(
                UserID => $ID,
                Period => $LastPeriodNumber + 1,
            );
            if ( !$Success ) {

                return $LayoutObject->ErrorScreen(
                    Message => Translatable('Unable to add time period!'),
                    Comment => Translatable('Please contact the administrator.'),
                );
            }
        }

        my %Errors = ();

        if (
            $ParamObject->GetParam( Param => 'AddPeriod' )
            || $ParamObject->GetParam( Param => 'SubmitUserData' )
            )
        {

            # check validity of periods
            %Errors = $Self->_CheckValidityUserPeriods(
                Period => $LastPeriodNumber,
            );
        }

        # get user data
        my %User = $UserObject->GetUserData(
            UserID => $ID,
        );

        my $Output = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar();
        $Self->_UserSettingsEdit(
            Action    => 'EditUser',
            Subaction => 'EditUser',
            UserID    => $ID,
            Errors    => \%Errors,
            Periods   => $LastPeriodNumber,
            %User,
        );
        $Output .= $LayoutObject->Output(
            TemplateFile => 'AgentTimeAccountingSetting',
            Data         => \%Param,
        );
        $Output .= $LayoutObject->Footer();

        return $Output;
    }

    # ---------------------------------------------------------- #
    # settings for handling time accounting
    # ---------------------------------------------------------- #

    # get user data
    my %UserData = $TimeAccountingObject->UserGet(
        UserID => $Self->{UserID},
    );

    # permission check
    if ( !$UserData{CreateProject} && !$Self->{AccessRw} ) {

        # return no permission screen
        return $LayoutObject->NoPermission(
            WithHeader => 'yes',
        );
    }

    # get the user action to show a message if an user was updated or added
    my $Note = $ParamObject->GetParam( Param => 'User' );

    # build output
    $Self->_SettingOverview();
    my $Output = $LayoutObject->Header(
        Title => Translatable('Setting'),
    );
    $Output .= $LayoutObject->NavigationBar();

    # show a notification message if proper
    if ($Note) {
        $Output .= $Note eq 'EditUser'
            ? $LayoutObject->Notify(
            Info => Translatable('User updated!'),
            )
            : $LayoutObject->Notify(
            Info => Translatable('User added!'),
            );
    }

    $Output .= $LayoutObject->Output(
        Data         => \%Param,
        TemplateFile => 'AgentTimeAccountingSetting'
    );
    $Output .= $LayoutObject->Footer();

    return $Output;

}

sub _CheckValidityUserPeriods {
    my ( $Self, %Param ) = @_;

    my %Errors = ();
    my %GetParam;

    my $TimeAccountingObject = $Kernel::OM->Get('Kernel::System::TimeAccounting');

    for ( my $Period = 1; $Period <= $Param{Period}; $Period++ ) {

        # check for needed data
        for my $Parameter (qw(DateStart DateEnd LeaveDays)) {
            $GetParam{$Parameter}
                = $Kernel::OM->Get('Kernel::System::Web::Request')->GetParam( Param => $Parameter . "[$Period]" );
            if ( !$GetParam{$Parameter} ) {
                $Errors{ $Parameter . '-' . $Period . 'Invalid' }   = 'ServerError';
                $Errors{ $Parameter . '-' . $Period . 'ErrorType' } = 'MissingValue';
            }
        }
        my ( $Year, $Month, $Day ) = split( '-', $GetParam{DateStart} );
        my $StartDate = $TimeAccountingObject->Date2SystemTime(
            Year   => $Year,
            Month  => $Month,
            Day    => $Day,
            Hour   => 0,
            Minute => 0,
            Second => 0,
        );
        ( $Year, $Month, $Day ) = split( '-', $GetParam{DateEnd} );
        my $EndDate = $TimeAccountingObject->Date2SystemTime(
            Year   => $Year,
            Month  => $Month,
            Day    => $Day,
            Hour   => 0,
            Minute => 0,
            Second => 0,
        );
        if ( !$StartDate ) {
            $Errors{ 'DateStart-' . $Period . 'Invalid' }   = 'ServerError';
            $Errors{ 'DateStart-' . $Period . 'ErrorType' } = 'Invalid';
        }
        if ( !$EndDate ) {
            $Errors{ 'DateEnd-' . $Period . 'Invalid' }   = 'ServerError';
            $Errors{ 'DateEnd-' . $Period . 'ErrorType' } = 'Invalid';
        }
        if ( $StartDate && $EndDate && $StartDate >= $EndDate ) {
            $Errors{ 'DateEnd-' . $Period . 'Invalid' }   = 'ServerError';
            $Errors{ 'DateEnd-' . $Period . 'ErrorType' } = 'BeforeDateStart';
        }
    }

    return %Errors;
}

sub _ProjectSettingsEdit {
    my ( $Self, %Param ) = @_;

    # get layout object
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    $LayoutObject->Block(
        Name => 'OverviewProject',
        Data => \%Param,
    );

    $LayoutObject->Block(
        Name => 'ActionListProject',
        Data => {},
    );
    $LayoutObject->Block(
        Name => 'ActionSettingOverview',
        Data => {},
    );

    # define status list
    my %StatusList = (
        1 => Translatable('valid'),
        0 => Translatable('invalid'),
    );

    my $ProjectStatus = 1;
    if ( defined $Param{ProjectStatus} ) {
        $ProjectStatus = $Param{ProjectStatus};
    }

    $Param{StatusOption} = $LayoutObject->BuildSelection(
        Data       => \%StatusList,
        SelectedID => $ProjectStatus,
        Name       => 'ProjectStatus',
        Class      => 'Modernize',
    );

    $LayoutObject->Block(
        Name => 'OverviewUpdateProject',
        Data => \%Param,
    );

    # shows header
    if ( $Param{Action} eq 'EditProject' ) {
        $LayoutObject->Block(
            Name => 'HeaderEditProject',
            Data => {},
        );
    }
    else {
        $LayoutObject->Block(
            Name => 'HeaderAddProject',
            Data => {},
        );
    }

    # show server error message (if any) for the project name
    if ( $Param{ProjectErrorType} ) {
        $LayoutObject->Block(
            Name => $Param{ProjectErrorType},
            Data => {},
        );
    }

    return 1;
}

sub _SettingOverview {
    my ( $Self, %Param ) = @_;

    my %Project = ();
    my %Data    = ();

    # get layout object
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # build output
    $LayoutObject->Block(
        Name => 'Setting',
        Data => {},
    );
    $LayoutObject->Block(
        Name => 'ActionListSetting',
        Data => {},
    );
    $LayoutObject->Block(
        Name => 'ActionAddProject',
        Data => {},
    );

    # hash to save registered users
    my %User;

    # get needed objects
    my $TimeAccountingObject = $Kernel::OM->Get('Kernel::System::TimeAccounting');
    my $UserObject           = $Kernel::OM->Get('Kernel::System::User');

    if ( $Self->{AccessRw} ) {
        $LayoutObject->Block(
            Name => 'ActionAddTask',
            Data => {},
        );

        # get user data
        my %ShownUsers = $UserObject->UserList(
            Type  => 'Long',
            Valid => 1,
        );

        # get list of registered users (if any)
        %User = $TimeAccountingObject->UserList();

        USERINFO:
        for my $UserInfo ( sort { $ShownUsers{$a} cmp $ShownUsers{$b} } keys %ShownUsers ) {
            next USERINFO if !$User{$UserInfo};

            # delete already registered user from the 'new' list
            delete $ShownUsers{$UserInfo};
        }

        $ShownUsers{'-'} = $LayoutObject->{LanguageObject}->Translate("Add a user to time accounting...");

        if ( scalar keys %ShownUsers > 1 ) {
            my $NewUserOption = $LayoutObject->BuildSelection(
                Data         => \%ShownUsers,
                SelectedID   => '',
                Name         => 'NewUserID',
                Translation  => 0,
                PossibleNone => 0,
                Title        => $LayoutObject->{LanguageObject}->Translate("New User"),
                Class        => 'Modernize',
            );
            $LayoutObject->Block(
                Name => 'ActionAddUser',
                Data => {
                    NewUserOption => $NewUserOption,
                },
            );
        }
    }

    # Show project data
    %Project = $TimeAccountingObject->ProjectSettingsGet();

    $LayoutObject->Block(
        Name => 'OverviewResultProject',
        Data => \%Param,
    );

    # define status list
    my %StatusList = (
        1 => Translatable('valid'),
        0 => Translatable('invalid'),
    );

    # show list of available projects (if any)
    if ( $Project{Project} ) {

        $LayoutObject->Block(
            Name => 'OverviewResultProjectTable',
            Data => {%Param},
        );

        for my $ProjectID (
            sort { $Project{Project}{$a} cmp $Project{Project}{$b} }
            keys %{ $Project{Project} }
            )
        {
            $Param{Project}            = $Project{Project}{$ProjectID};
            $Param{ProjectDescription} = $Project{ProjectDescription}{$ProjectID};
            $Param{ProjectID}          = $ProjectID;
            $Param{Status}             = $StatusList{ $Project{ProjectStatus}{$ProjectID} };

            $LayoutObject->Block(
                Name => 'OverviewResultProjectRow',
                Data => {%Param},
            );
        }
    }

    # otherwise, show a no data found message
    else {
        $LayoutObject->Block(
            Name => 'NoProjectDataFoundMsg',
        );
    }

    if ( $Self->{AccessRw} ) {

        # Show action data
        my %Action = $TimeAccountingObject->ActionSettingsGet();

        $LayoutObject->Block(
            Name => 'OverviewResultSetting',
            Data => \%Param,
        );

        # show list of available tasks/actions (if any)
        if (%Action) {

            $LayoutObject->Block(
                Name => 'OverviewResultSettingTable',
                Data => {%Param},
            );

            for my $ActionID ( sort { $Action{$a}{Action} cmp $Action{$b}{Action} } keys %Action ) {
                $Param{Action}   = $Action{$ActionID}{Action};
                $Param{ActionID} = $ActionID;
                $Param{Status}   = $StatusList{ $Action{$ActionID}{ActionStatus} };

                $LayoutObject->Block(
                    Name => 'OverviewResultSettingRow',
                    Data => {%Param},
                );
            }
        }

        # otherwise, show a no data found message
        else {
            $LayoutObject->Block(
                Name => 'NoSettingDataFoundMsg',
                Data => {},
            );
        }

        # show user data
        $LayoutObject->Block(
            Name => 'OverviewResultUser',
            Data => \%Param,
        );

        # show list of registered users (if any)
        if (%User) {

            $LayoutObject->Block(
                Name => 'OverviewResultUserTable',
                Data => {%Param},
            );

            for my $UserID ( sort { $User{$a} cmp $User{$b} } keys %User ) {

                # get missing user data
                my %UserData = $TimeAccountingObject->UserGet(
                    UserID => $UserID,
                );
                my %UserGeneralData = $UserObject->GetUserData(
                    UserID => $UserID,
                );

                $Param{User}       = "$UserGeneralData{UserFullname} ($UserGeneralData{UserLogin})";
                $Param{UserID}     = $UserID;
                $Param{Comment}    = $UserData{Description};
                $Param{CalendarNo} = $UserData{Calendar};
                $Param{Calendar}   = $Kernel::OM->Get('Kernel::Config')->Get(
                    "TimeZone::Calendar"
                        . ( $Param{CalendarNo} || '' ) . "Name"
                ) || 'Default';

                $LayoutObject->Block(
                    Name => 'OverviewResultUserRow',
                    Data => {%Param},
                );
            }
        }

        # otherwise, show a no data found message
        else {
            $LayoutObject->Block(
                Name => 'NoUserDataFoundMsg',
                Data => {},
            );
        }
    }

    return 1;
}

sub _TaskSettingsEdit {
    my ( $Self, %Param ) = @_;

    # get layout object
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    $LayoutObject->Block(
        Name => 'Setting',
        Data => \%Param,
    );

    $LayoutObject->Block(
        Name => 'ActionListSetting',
        Data => {},
    );
    $LayoutObject->Block(
        Name => 'ActionOverviewSetting',
        Data => {},
    );

    # define status list
    my %StatusList = (
        1 => Translatable('valid'),
        0 => Translatable('invalid'),
    );

    my $TaskStatus = 1;
    if ( defined $Param{TaskStatus} ) {
        $TaskStatus = $Param{TaskStatus};
    }

    $Param{StatusOption} = $LayoutObject->BuildSelection(
        Data       => \%StatusList,
        SelectedID => $TaskStatus,
        Name       => 'TaskStatus',
        Class      => 'Modernize',
    );

    $LayoutObject->Block(
        Name => 'OverviewUpdateTask',
        Data => \%Param,
    );

    # shows header
    if ( $Param{Action} eq 'EditTask' ) {
        $LayoutObject->Block(
            Name => 'HeaderEditTask',
            Data => {},
        );
    }
    else {
        $LayoutObject->Block(
            Name => 'HeaderAddTask',
            Data => {},
        );
    }

    # show server error message (if any) for the task name
    if ( $Param{TaskErrorType} ) {
        $LayoutObject->Block(
            Name => $Param{TaskErrorType},
            Data => {},
        );
    }

    return 1;
}

sub _UserSettingsEdit {
    my ( $Self, %Param ) = @_;
    my %GetParam = ();

    # get param object
    my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');

    # get parameters
    for my $Parameter (qw(Description ShowOvertime CreateProject AllowSkip Calendar)) {
        $GetParam{$Parameter} = $ParamObject->GetParam( Param => $Parameter );
    }

    # get layout object
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    $LayoutObject->Block(
        Name => 'Setting',
        Data => \%Param,
    );

    $LayoutObject->Block(
        Name => 'ActionListSetting',
        Data => {},
    );
    $LayoutObject->Block(
        Name => 'ActionOverviewSetting',
        Data => {},
    );
    $LayoutObject->Block(
        Name => 'Reference',
        Data => {},
    );

    # define status list
    my %StatusList = (
        1 => Translatable('valid'),
        0 => Translatable('invalid'),
    );

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # fill up the calendar list
    my $CalendarListRef = { 0 => 'Default' };
    my $CalendarIndex = 1;
    while ( $ConfigObject->Get( "TimeZone::Calendar" . $CalendarIndex . "Name" ) ) {
        $CalendarListRef->{$CalendarIndex} = $ConfigObject->Get( "TimeZone::Calendar" . $CalendarIndex . "Name" );
        $CalendarIndex++;
    }

    # get time accounting object
    my $TimeAccountingObject = $Kernel::OM->Get('Kernel::System::TimeAccounting');

    # get user data
    my %UserData = $TimeAccountingObject->UserGet(
        UserID => $Param{UserID},
    );

    $Param{CalendarOption} = $LayoutObject->BuildSelection(
        Data        => $CalendarListRef,
        Name        => 'Calendar',
        Translation => 1,
        SelectedID  => $GetParam{Calendar} || $UserData{Calendar} || 0,
        Class       => 'Modernize',
    );

    $Param{Description} = $GetParam{Description} || $UserData{Description} || '';

    $LayoutObject->Block(
        Name => 'OverviewUpdateUser',
        Data => {
            %Param,
            ShowOvertime => ( $GetParam{ShowOvertime} || $UserData{ShowOvertime} )
            ? 'checked="checked"'
            : '',
            CreateProject => ( $GetParam{CreateProject} || $UserData{CreateProject} )
            ? 'checked="checked"'
            : '',
            AllowSkip => ( $GetParam{AllowSkip} || $UserData{AllowSkip} )
            ? 'checked="checked"'
            : '',
            }
    );

    # if there are errors to show
    if ( $Param{Errors} && %{ $Param{Errors} } ) {

        # show all existing periods
        for ( my $Period = 1; $Period <= $Param{Periods}; $Period++ ) {

            for my $Parameter (qw(DateStart DateEnd LeaveDays WeeklyHours Overtime PeriodStatus )) {
                $GetParam{$Parameter} = $ParamObject->GetParam( Param => "$Parameter\[$Period\]" );
            }

            $Param{$Period}{PeriodStatusOption} = $LayoutObject->BuildSelection(
                Data       => \%StatusList,
                SelectedID => $GetParam{PeriodStatus} || $Param{$Period}{PeriodStatus},
                Name       => "PeriodStatus[$Period]",
                ID         => "PeriodStatus-$Period",
                Title      => $LayoutObject->{LanguageObject}->Translate("Period Status"),
                Class      => 'Modernize',
            );

            $LayoutObject->Block(
                Name => 'PeriodOverviewRow',
                Data => {
                    Period           => $Period,
                    DateStartInvalid => $Param{Errors}->{ 'DateStart-' . $Period . 'Invalid' }
                        || '',
                    DateEndInvalid => $Param{Errors}->{ 'DateEnd-' . $Period . 'Invalid' } || '',
                    LeaveDaysInvalid => $Param{Errors}->{ 'LeaveDays-' . $Period . 'Invalid' }
                        || '',
                    DateStart          => $GetParam{DateStart},
                    DateEnd            => $GetParam{DateEnd},
                    LeaveDays          => $GetParam{LeaveDays},
                    WeeklyHours        => $GetParam{WeeklyHours},
                    Overtime           => $GetParam{Overtime},
                    PeriodStatusOption => $Param{$Period}{PeriodStatusOption},
                },
            );

            $LayoutObject->Block(
                Name => 'DateStart'
                    . (
                    $Param{Errors}->{ 'DateStart-' . $Period . 'ErrorType' }
                        || 'MissingValue'
                    ),
                Data => { Period => $Period },
            );
            $LayoutObject->Block(
                Name => 'DateEnd'
                    . ( $Param{Errors}->{ 'DateEnd-' . $Period . 'ErrorType' } || 'MissingValue' ),
                Data => { Period => $Period },
            );
        }
    }
    else {
        my %User = $TimeAccountingObject->SingleUserSettingsGet(
            UserID => $Param{UserID},
        );

        # show user data
        if (%User) {
            my $LastPeriodNumber = $TimeAccountingObject->UserLastPeriodNumberGet(
                UserID => $Param{UserID}
            );

            for ( my $Period = 1; $Period <= $LastPeriodNumber; $Period++ ) {
                my %PeriodParam = ();

                # get all needed data to display
                for my $Parameter (qw(DateStart DateEnd LeaveDays WeeklyHours Overtime)) {
                    $PeriodParam{$Parameter} = $User{$Period}{$Parameter};
                }
                $PeriodParam{Period} = $Period;

                $PeriodParam{PeriodStatusOption} = $LayoutObject->BuildSelection(
                    Data       => \%StatusList,
                    SelectedID => $User{$Period}{UserStatus},
                    Name       => "PeriodStatus[$Period]",
                    ID         => "PeriodStatus-$Period",
                    Title      => $LayoutObject->{LanguageObject}->Translate("Period Status"),
                    Class      => 'Modernize',
                );

                $LayoutObject->Block(
                    Name => 'PeriodOverviewRow',
                    Data => \%PeriodParam,
                );
            }
        }

        # show a no data found message
        else {
            $LayoutObject->Block(
                Name => 'PeriodOverviewRowNoData',
                Data => {},
            );
        }
    }

    return 1;
}

1;
