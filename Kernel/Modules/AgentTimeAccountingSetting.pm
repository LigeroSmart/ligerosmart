# --
# Kernel/Modules/AgentTimeAccountingSetting.pm - time accounting setting module
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentTimeAccountingSetting;

use strict;
use warnings;

use Time::Local;

use Kernel::System::TimeAccounting;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check needed Objects
    for my $Needed (
        qw(ParamObject DBObject ModuleReg LogObject UserObject
        ConfigObject TicketObject TimeObject GroupObject)
        )
    {
        $Self->{LayoutObject}->FatalError( Message => "Got no $Needed!" ) if !$Self->{$Needed};
    }

    # create required objects...
    $Self->{TimeAccountingObject} = Kernel::System::TimeAccounting->new(%Param);

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # expression add time period was pressed
    if (
        $Self->{ParamObject}->GetParam( Param => 'AddPeriod' )
        || $Self->{ParamObject}->GetParam( Param => 'SubmitUserData' )
        )
    {
        my %GetParam = ();

        $GetParam{UserID} = $Self->{ParamObject}->GetParam( Param => 'UserID' );
        my $Periods
            = $Self->{TimeAccountingObject}->UserLastPeriodNumberGet( UserID => $GetParam{UserID} );

        # check validity of periods
        my %Errors = $Self->_CheckValidityUserPeriods( Period => $Periods );

        # if the period data is OK
        if ( !%Errors ) {

            # get all parameters
            for my $Parameter (qw(Subaction Description Calendar)) {
                $GetParam{$Parameter} = $Self->{ParamObject}->GetParam( Param => $Parameter );
            }
            for my $Parameter (qw(ShowOvertime CreateProject)) {
                $GetParam{$Parameter} = $Self->{ParamObject}->GetParam( Param => $Parameter ) || 0;
            }

            my $Period = 1;
            my %PeriodData;

            my %UserData
                = $Self->{TimeAccountingObject}->SingleUserSettingsGet(
                UserID => $GetParam{UserID}
                );

            # get parameters for all registered periods
            while ( $UserData{$Period} ) {
                for my $Parameter (qw(WeeklyHours Overtime DateStart DateEnd LeaveDays)) {
                    $PeriodData{$Period}{$Parameter}
                        = $Self->{ParamObject}->GetParam( Param => $Parameter . "[$Period]" )
                        || $UserData{$Period}{$Parameter};
                }
                $PeriodData{$Period}{UserStatus}
                    = $Self->{ParamObject}->GetParam( Param => "PeriodStatus[$Period]" ) || 0;
                $Period++;
            }
            $GetParam{Period} = \%PeriodData;

            # update periods
            if ( !$Self->{TimeAccountingObject}->UserSettingsUpdate(%GetParam) ) {

                return $Self->{LayoutObject}->ErrorScreen(
                    Message => 'Unable to update user settings! Please contact your administrator.'
                );
            }
            if ( $Self->{ParamObject}->GetParam( Param => 'AddPeriod' ) ) {

                # show the edit time settings again, but now with a new empty time period line
                return $Self->{LayoutObject}->Redirect(
                    OP =>
                        "Action=AgentTimeAccountingSetting;Subaction=$GetParam{Subaction};UserID=$GetParam{UserID};"
                        . "NewTimePeriod=1",
                );
            }
            else {

                # show the overview of tasks and users
                return $Self->{LayoutObject}->Redirect(
                    OP => "Action=AgentTimeAccountingSetting;User=$Self->{Subaction}",
                );
            }
        }
    }

    # ---------------------------------------------------------- #
    # add project
    # ---------------------------------------------------------- #
    if ( $Self->{Subaction} eq 'AddProject' ) {
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Self->_ProjectSettingsEdit( Action => 'AddProject' );
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AgentTimeAccountingSetting',
            Data         => \%Param,
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }

    # ---------------------------------------------------------- #
    # add project action
    # ---------------------------------------------------------- #
    elsif ( $Self->{Subaction} eq 'AddProjectAction' ) {

        # challenge token check for write action
        $Self->{LayoutObject}->ChallengeTokenCheck();

        my $Note = '';
        my $ProjectID;
        my ( %GetParam, %Errors );

        # get parameters
        for my $Parameter (qw(Project ProjectDescription)) {
            $GetParam{$Parameter} = $Self->{ParamObject}->GetParam( Param => $Parameter ) || '';
        }
        $GetParam{ProjectStatus} = $Self->{ParamObject}->GetParam( Param => 'ProjectStatus' )
            || '0';

        # check for needed data
        if ( !$GetParam{Project} ) {
            $Errors{ProjectInvalid}   = 'ServerError';
            $Errors{ProjectErrorType} = 'ProjectMissingValue';
        }
        else {

            # check that the name is unique
            my %ExistingProject
                = $Self->{TimeAccountingObject}->ProjectGet( Project => $GetParam{Project} );
            if (%ExistingProject) {
                $Errors{ProjectInvalid}   = 'ServerError';
                $Errors{ProjectErrorType} = 'ProjectDuplicateName';
            }
        }

        # if no errors occurred
        if ( !%Errors ) {

            # add project
            $ProjectID = $Self->{TimeAccountingObject}->ProjectSettingsInsert(%GetParam);

            if ($ProjectID) {

                # build the output
                $Self->_SettingOverview();
                my $Output = $Self->{LayoutObject}->Header();
                $Output .= $Self->{LayoutObject}->NavigationBar();
                $Output .= $Self->{LayoutObject}->Notify( Info => 'Project added!' );
                $Output .= $Self->{LayoutObject}->Output(
                    TemplateFile => 'AgentTimeAccountingSetting',
                    Data         => {%GetParam},
                );
                $Output .= $Self->{LayoutObject}->Footer();

                return $Output;
            }
            else {
                $Note = $Self->{LogObject}->GetLogEntry(
                    Type => 'Error',
                    What => 'Message',
                );
            }
        }

        # something went wrong
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Output .= $Note
            ? $Self->{LayoutObject}->Notify(
            Priority => 'Error',
            Info     => $Note,
            )
            : '';
        $Self->_ProjectSettingsEdit(
            Action => 'AddProject',
            %GetParam,
            %Errors,
        );
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AgentTimeAccountingSetting',
            Data         => \%Param,
        );
        $Output .= $Self->{LayoutObject}->Footer();

        return $Output;
    }

    # ---------------------------------------------------------- #
    # edit project
    # ---------------------------------------------------------- #
    elsif ( $Self->{Subaction} eq 'EditProject' ) {
        my $ID = $Self->{ParamObject}->GetParam( Param => 'ID' );

        # get project data
        my %Project = $Self->{TimeAccountingObject}->ProjectGet( ID => $ID );

        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Self->_ProjectSettingsEdit(
            Action => 'EditProject',
            %Project,
        );
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AgentTimeAccountingSetting',
            Data         => \%Param,
        );
        $Output .= $Self->{LayoutObject}->Footer();

        return $Output;
    }

    # ---------------------------------------------------------- #
    # edit project action
    # ---------------------------------------------------------- #
    elsif ( $Self->{Subaction} eq 'EditProjectAction' ) {

        # challenge token check for write action
        $Self->{LayoutObject}->ChallengeTokenCheck();

        my $Note = '';
        my ( %GetParam, %Errors );

        # get parameters
        $GetParam{ID} = $Self->{ParamObject}->GetParam( Param => 'ID' ) || '';
        $GetParam{ProjectStatus} = $Self->{ParamObject}->GetParam( Param => 'ProjectStatus' )
            || '0';
        for my $Parameter (qw(Project ProjectDescription)) {
            $GetParam{$Parameter} = $Self->{ParamObject}->GetParam( Param => $Parameter ) || '';
        }

        # check for needed data
        if ( !$GetParam{Project} ) {
            $Errors{ProjectInvalid} = 'ServerError';
        }
        else {

            # check that the name is unique
            my %ExistingProject
                = $Self->{TimeAccountingObject}->ProjectGet( Project => $GetParam{Project} );

            # if the project name is found, check that the ID is different
            if ( %ExistingProject && $ExistingProject{ID} ne $GetParam{ID} ) {
                $Errors{ProjectInvalid}   = 'ServerError';
                $Errors{ProjectErrorType} = 'ProjectDuplicateName';
            }
        }

        # if no errors occurred
        if ( !%Errors ) {

            # edit project
            if ( $Self->{TimeAccountingObject}->ProjectSettingsUpdate(%GetParam) ) {

                $Self->_SettingOverview();
                my $Output = $Self->{LayoutObject}->Header();
                $Output .= $Self->{LayoutObject}->NavigationBar();
                $Output .= $Self->{LayoutObject}->Notify( Info => 'Project updated!' );
                $Output .= $Self->{LayoutObject}->Output(
                    TemplateFile => 'AgentTimeAccountingSetting',
                    Data         => \%Param,
                );
                $Output .= $Self->{LayoutObject}->Footer();

                return $Output;
            }
            else {
                $Note = $Self->{LogObject}->GetLogEntry(
                    Type => 'Error',
                    What => 'Message',
                );
            }
        }

        # something went wrong
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Output .= $Note
            ? $Self->{LayoutObject}->Notify(
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
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AgentTimeAccountingSetting',
            Data         => \%Param,
        );
        $Output .= $Self->{LayoutObject}->Footer();

        return $Output;
    }

    # ---------------------------------------------------------- #
    # add task
    # ---------------------------------------------------------- #
    elsif ( $Self->{Subaction} eq 'AddTask' ) {
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Self->_TaskSettingsEdit( Action => 'AddTask' );
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AgentTimeAccountingSetting',
            Data         => \%Param,
        );
        $Output .= $Self->{LayoutObject}->Footer();

        return $Output;
    }

    # ---------------------------------------------------------- #
    # add task action
    # ---------------------------------------------------------- #
    elsif ( $Self->{Subaction} eq 'AddTaskAction' ) {

        # challenge token check for write action
        $Self->{LayoutObject}->ChallengeTokenCheck();

        my $Note = '';
        my $TaskID;
        my ( %GetParam, %Errors );

        # get parameters
        $GetParam{Task} = $Self->{ParamObject}->GetParam( Param => 'Task' ) || '';
        $GetParam{TaskStatus} = $Self->{ParamObject}->GetParam( Param => 'TaskStatus' )
            || '0';

        # check for needed data
        if ( !$GetParam{Task} ) {
            $Errors{TaskInvalid}   = 'ServerError';
            $Errors{TaskErrorType} = 'TaskMissingValue';
        }
        else {

            # check that the name is unique
            my %ExistingTask
                = $Self->{TimeAccountingObject}->ActionGet( Action => $GetParam{Task} );
            if (%ExistingTask) {
                $Errors{TaskInvalid}   = 'ServerError';
                $Errors{TaskErrorType} = 'TaskDuplicateName';
            }
        }

        # if no errors occurred
        if ( !%Errors ) {

            # add task
            $TaskID = $Self->{TimeAccountingObject}->ActionSettingsInsert(
                Action       => $GetParam{Task},
                ActionStatus => $GetParam{TaskStatus},
            );

            if ($TaskID) {

                # build the output
                $Self->_SettingOverview();
                my $Output = $Self->{LayoutObject}->Header();
                $Output .= $Self->{LayoutObject}->NavigationBar();
                $Output .= $Self->{LayoutObject}->Notify( Info => 'Task added!' );
                $Output .= $Self->{LayoutObject}->Output(
                    TemplateFile => 'AgentTimeAccountingSetting',
                    Data         => {},
                );
                $Output .= $Self->{LayoutObject}->Footer();

                return $Output;
            }
            else {
                $Note = $Self->{LogObject}->GetLogEntry(
                    Type => 'Error',
                    What => 'Message',
                );
            }
        }

        # something went wrong
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Output .= $Note
            ? $Self->{LayoutObject}->Notify(
            Priority => 'Error',
            Info     => $Note,
            )
            : '';
        $Self->_TaskSettingsEdit(
            Action => 'AddTask',
            %GetParam,
            %Errors,
        );
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AgentTimeAccountingSetting',
            Data         => \%Param,
        );
        $Output .= $Self->{LayoutObject}->Footer();

        return $Output;
    }

    # ---------------------------------------------------------- #
    # edit task
    # ---------------------------------------------------------- #
    elsif ( $Self->{Subaction} eq 'EditTask' ) {
        my $ID = $Self->{ParamObject}->GetParam( Param => 'ActionID' ) || '';

        # get project data
        my %Task = $Self->{TimeAccountingObject}->ActionGet( ID => $ID );

        my %TaskData = (
            Task       => $Task{Action},
            TaskStatus => $Task{ActionStatus},
        );

        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Self->_TaskSettingsEdit(
            Action   => 'EditTask',
            ActionID => $ID,
            %TaskData,
        );
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AgentTimeAccountingSetting',
            Data         => \%Param,
        );
        $Output .= $Self->{LayoutObject}->Footer();

        return $Output;
    }

    # ---------------------------------------------------------- #
    # edit project action
    # ---------------------------------------------------------- #
    elsif ( $Self->{Subaction} eq 'EditTaskAction' ) {

        # challenge token check for write action
        $Self->{LayoutObject}->ChallengeTokenCheck();

        my $Note = '';
        my ( %GetParam, %Errors );

        # get parameters
        $GetParam{ActionID}   = $Self->{ParamObject}->GetParam( Param => 'ActionID' )   || '';
        $GetParam{TaskStatus} = $Self->{ParamObject}->GetParam( Param => 'TaskStatus' ) || '0';
        $GetParam{Task}       = $Self->{ParamObject}->GetParam( Param => 'Task' )       || '';

        # check for needed data
        if ( !$GetParam{Task} ) {
            $Errors{TaskInvalid} = 'ServerError';
        }
        else {

            # check that the name is unique
            my %ExistingTask
                = $Self->{TimeAccountingObject}->ActionGet( Action => $GetParam{Task} );

            # if the task name is found, check that the ID is different
            if ( %ExistingTask && $ExistingTask{ID} ne $GetParam{ActionID} ) {
                $Errors{TaskInvalid}   = 'ServerError';
                $Errors{TaskErrorType} = 'TaskDuplicateName';
            }
        }

        # if no errors occurred
        if ( !%Errors ) {

            # edit action (task)
            my $ActionUpdate = $Self->{TimeAccountingObject}->ActionSettingsUpdate(
                ActionID     => $GetParam{ActionID},
                Action       => $GetParam{Task},
                ActionStatus => $GetParam{TaskStatus},
            );

            if ($ActionUpdate) {
                $Self->_SettingOverview();
                my $Output = $Self->{LayoutObject}->Header();
                $Output .= $Self->{LayoutObject}->NavigationBar();
                $Output .= $Self->{LayoutObject}->Notify( Info => 'Task updated!' );
                $Output .= $Self->{LayoutObject}->Output(
                    TemplateFile => 'AgentTimeAccountingSetting',
                    Data         => \%Param,
                );
                $Output .= $Self->{LayoutObject}->Footer();

                return $Output;
            }
            else {
                $Note = $Self->{LogObject}->GetLogEntry(
                    Type => 'Error',
                    What => 'Message',
                );
            }
        }

        # something went wrong
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Output .= $Note
            ? $Self->{LayoutObject}->Notify(
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
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AgentTimeAccountingSetting',
            Data         => \%Param,
        );
        $Output .= $Self->{LayoutObject}->Footer();

        return $Output;
    }

    # ---------------------------------------------------------- #
    # add user
    # ---------------------------------------------------------- #
    elsif ( $Self->{Subaction} eq 'AddUser' ) {

        # get parameters
        my $NewUserID = $Self->{ParamObject}->GetParam( Param => 'NewUserID' )
            || $Self->{ParamObject}->GetParam( Param => 'UserID' )
            || '';
        if ( !$NewUserID ) {

            return $Self->{LayoutObject}->ErrorScreen(
                Message => 'The UserID is not valid!'
            );
        }

        my $NewTimePeriod = $Self->{ParamObject}->GetParam( Param => 'NewTimePeriod' );

        my $LastPeriodNumber = $Self->{TimeAccountingObject}->UserLastPeriodNumberGet(
            UserID => $NewUserID,
        );

        my $Success = $Self->{TimeAccountingObject}->UserSettingsInsert(
            UserID => $NewUserID,
            Period => $LastPeriodNumber + 1,
        );

        # if it is not an action about adding a new time period
        if ( !$NewTimePeriod ) {
            if ( !$Success ) {

                return $Self->{LayoutObject}->ErrorScreen(
                    Message => 'Can\'t insert user data!'
                );
            }

            my %Groups = $Self->{GroupObject}->GroupList( Valid => 1 );
            my %GroupData = $Self->{GroupObject}->GroupMemberList(
                UserID => $NewUserID,
                Type   => 'ro',
                Result => 'HASH',
            );
            for my $GroupKey ( sort keys %Groups ) {
                if ( $Groups{$GroupKey} eq 'time_accounting' && !$GroupData{$GroupKey} ) {

                    $Self->{GroupObject}->GroupMemberAdd(
                        GID        => $GroupKey,
                        UID        => $NewUserID,
                        Permission => {
                            ro        => 1,
                            move_into => 0,
                            create    => 0,
                            owner     => 0,
                            priority  => 0,
                            rw        => 0,
                        },
                        UserID => $Self->{UserID},
                    );
                }
            }
        }

        my %User = $Self->{UserObject}->GetUserData( UserID => $NewUserID );
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Self->_UserSettingsEdit(
            Action    => 'AddUser',
            Subaction => 'AddUser',
            %User,
        );
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AgentTimeAccountingSetting',
            Data         => \%Param,
        );
        $Output .= $Self->{LayoutObject}->Footer();

        return $Output;
    }

    # ---------------------------------------------------------- #
    # edit user settings
    # ---------------------------------------------------------- #
    elsif ( $Self->{Subaction} eq 'EditUser' ) {
        my $ID = $Self->{ParamObject}->GetParam( Param => 'UserID' ) || '';
        if ( !$ID ) {

            return $Self->{LayoutObject}->ErrorScreen(
                Message => 'The UserID is not valid!'
            );
        }

        my $NewTimePeriod = $Self->{ParamObject}->GetParam( Param => 'NewTimePeriod' );
        my $LastPeriodNumber = $Self->{TimeAccountingObject}->UserLastPeriodNumberGet(
            UserID => $ID,
        );

        # if it is an action about adding a new time period, insert it
        if ($NewTimePeriod) {
            my $Success = $Self->{TimeAccountingObject}->UserSettingsInsert(
                UserID => $ID,
                Period => $LastPeriodNumber + 1,
            );
            if ( !$Success ) {

                return $Self->{LayoutObject}->ErrorScreen(
                    Message => 'Unable to add time period! Please contact your administrator.',
                );
            }
        }

        my %Errors = ();

        if (
            $Self->{ParamObject}->GetParam( Param => 'AddPeriod' )
            || $Self->{ParamObject}->GetParam( Param => 'SubmitUserData' )
            )
        {

            # check validity of periods
            %Errors = $Self->_CheckValidityUserPeriods( Period => $LastPeriodNumber );
        }

        # get user data
        my %User = $Self->{UserObject}->GetUserData( UserID => $ID );

        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Self->_UserSettingsEdit(
            Action    => 'EditUser',
            Subaction => 'EditUser',
            UserID    => $ID,
            Errors    => \%Errors,
            Periods   => $LastPeriodNumber,
            %User,
        );
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AgentTimeAccountingSetting',
            Data         => \%Param,
        );
        $Output .= $Self->{LayoutObject}->Footer();

        return $Output;
    }

    # ---------------------------------------------------------- #
    # settings for handling time accounting
    # ---------------------------------------------------------- #

    # get user data
    my %UserData = $Self->{TimeAccountingObject}->UserGet(
        UserID => $Self->{UserID},
    );

    # permission check
    if ( $UserData{CreateProject} || $Self->{AccessRw} ) {

        # get the user action to show a message if an user was updated or added
        my $Note = $Self->{ParamObject}->GetParam( Param => 'User' );

        # build output
        $Self->_SettingOverview();
        my $Output = $Self->{LayoutObject}->Header( Title => 'Setting' );
        $Output .= $Self->{LayoutObject}->NavigationBar();

        # show a notification message if proper
        if ($Note) {
            $Output .= $Note eq 'EditUser'
                ? $Self->{LayoutObject}->Notify( Info => 'User updated!' )
                : $Self->{LayoutObject}->Notify( Info => 'User added!' );
        }

        $Output .= $Self->{LayoutObject}->Output(
            Data         => \%Param,
            TemplateFile => 'AgentTimeAccountingSetting'
        );
        $Output .= $Self->{LayoutObject}->Footer();

        return $Output;
    }

    # return no permission screen
    return $Self->{LayoutObject}->NoPermission( WithHeader => 'yes' );
}

sub _CheckValidityUserPeriods {
    my ( $Self, %Param ) = @_;

    my %Errors = ();
    my %GetParam;

    for ( my $Period = 1; $Period <= $Param{Period}; $Period++ ) {

        # check for needed data
        for my $Parameter (qw(DateStart DateEnd LeaveDays)) {
            $GetParam{$Parameter}
                = $Self->{ParamObject}->GetParam( Param => $Parameter . "[$Period]" );
            if ( !$GetParam{$Parameter} ) {
                $Errors{ $Parameter . '-' . $Period . 'Invalid' }   = 'ServerError';
                $Errors{ $Parameter . '-' . $Period . 'ErrorType' } = 'MissingValue';
            }
        }
        my ( $Year, $Month, $Day ) = split( '-', $GetParam{DateStart} );
        my $StartDate = $Self->{TimeObject}->Date2SystemTime(
            Year   => $Year,
            Month  => $Month,
            Day    => $Day,
            Hour   => 0,
            Minute => 0,
            Second => 0,
        );
        ( $Year, $Month, $Day ) = split( '-', $GetParam{DateEnd} );
        my $EndDate = $Self->{TimeObject}->Date2SystemTime(
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

    $Self->{LayoutObject}->Block(
        Name => 'OverviewProject',
        Data => \%Param,
    );

    $Self->{LayoutObject}->Block( Name => 'ActionListProject' );
    $Self->{LayoutObject}->Block( Name => 'ActionSettingOverview' );

    # define status list
    my %StatusList = (
        1 => 'valid',
        0 => 'invalid',
    );

    my $ProjectStatus = 1;
    if ( defined $Param{ProjectStatus} ) {
        $ProjectStatus = $Param{ProjectStatus}
    }

    $Param{StatusOption} = $Self->{LayoutObject}->BuildSelection(
        Data       => \%StatusList,
        SelectedID => $ProjectStatus,
        Name       => 'ProjectStatus',
    );

    $Self->{LayoutObject}->Block(
        Name => 'OverviewUpdateProject',
        Data => \%Param,
    );

    # shows header
    if ( $Param{Action} eq 'EditProject' ) {
        $Self->{LayoutObject}->Block( Name => 'HeaderEditProject' );
    }
    else {
        $Self->{LayoutObject}->Block( Name => 'HeaderAddProject' );
    }

    # show server error message (if any) for the project name
    if ( $Param{ProjectErrorType} ) {
        $Self->{LayoutObject}->Block( Name => $Param{ProjectErrorType} );
    }

    return 1;
}

sub _SettingOverview {
    my ( $Self, %Param ) = @_;

    my %Project = ();
    my %Data    = ();

    # build output
    $Self->{LayoutObject}->Block( Name => 'Setting', );
    $Self->{LayoutObject}->Block( Name => 'ActionListSetting' );
    $Self->{LayoutObject}->Block( Name => 'ActionAddProject' );

    # hash to save registered users
    my %User;

    if ( $Self->{AccessRw} ) {
        $Self->{LayoutObject}->Block( Name => 'ActionAddTask' );

        # get user data
        my %ShownUsers = $Self->{UserObject}->UserList(
            Type  => 'Long',
            Valid => 1,
        );

        # get list of registered users (if any)
        %User = $Self->{TimeAccountingObject}->UserList();

        USERID:
        for my $UserInfo ( sort { $ShownUsers{$a} cmp $ShownUsers{$b} } keys %ShownUsers ) {
            next USERID if !$User{$UserInfo};

            # delete already registered user from the 'new' list
            delete $ShownUsers{$UserInfo};
        }

        if (%ShownUsers) {
            my $NewUserOption = $Self->{LayoutObject}->BuildSelection(
                Data         => \%ShownUsers,
                SelectedID   => '',
                Name         => 'NewUserID',
                Translation  => 0,
                PossibleNone => 0,
                Title        => $Self->{LayoutObject}->{LanguageObject}->Translate("New User"),
            );
            $Self->{LayoutObject}->Block(
                Name => 'ActionAddUser',
                Data => { NewUserOption => $NewUserOption, },
            );
        }
    }

    $Self->{LayoutObject}->Block( Name => 'ProjectFilter' );

    if ( $Self->{AccessRw} ) {
        $Self->{LayoutObject}->Block( Name => 'TaskFilter' );
        $Self->{LayoutObject}->Block( Name => 'UserFilter' );
    }

    # Show project data
    %Project = $Self->{TimeAccountingObject}->ProjectSettingsGet();

    $Self->{LayoutObject}->Block(
        Name => 'OverviewResultProject',
        Data => \%Param,
    );

    # define status list
    my %StatusList = (
        1 => 'valid',
        0 => 'invalid',
    );

    # show list of available projects (if any)
    if ( $Project{Project} ) {

        $Self->{LayoutObject}->Block(
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

            $Self->{LayoutObject}->Block(
                Name => 'OverviewResultProjectRow',
                Data => {%Param},
            );
        }
    }

    # otherwise, show a no data found message
    else {
        $Self->{LayoutObject}->Block( Name => 'NoProjectDataFoundMsg' );
    }

    if ( $Self->{AccessRw} ) {

        # Show action data
        my %Action = $Self->{TimeAccountingObject}->ActionSettingsGet();

        $Self->{LayoutObject}->Block(
            Name => 'OverviewResultSetting',
            Data => \%Param,
        );

        # show list of available tasks/actions (if any)
        if (%Action) {

            $Self->{LayoutObject}->Block(
                Name => 'OverviewResultSettingTable',
                Data => {%Param},
            );

            for my $ActionID ( sort { $Action{$a}{Action} cmp $Action{$b}{Action} } keys %Action ) {
                $Param{Action}   = $Action{$ActionID}{Action};
                $Param{ActionID} = $ActionID;
                $Param{Status}   = $StatusList{ $Action{$ActionID}{ActionStatus} };

                $Self->{LayoutObject}->Block(
                    Name => 'OverviewResultSettingRow',
                    Data => {%Param},
                );
            }
        }

        # otherwise, show a no data found message
        else {
            $Self->{LayoutObject}->Block( Name => 'NoSettingDataFoundMsg' );
        }

        # show user data
        $Self->{LayoutObject}->Block(
            Name => 'OverviewResultUser',
            Data => \%Param,
        );

        # show list of registered users (if any)
        if (%User) {

            $Self->{LayoutObject}->Block(
                Name => 'OverviewResultUserTable',
                Data => {%Param},
            );

            for my $UserID ( sort { $User{$a} cmp $User{$b} } keys %User ) {

                # get missing user data
                my %UserData = $Self->{TimeAccountingObject}->UserGet( UserID => $UserID );
                my %UserGeneralData = $Self->{UserObject}->GetUserData( UserID => $UserID );

                $Param{User}
                    = "$UserGeneralData{UserFirstname} $UserGeneralData{UserLastname} ($UserGeneralData{UserLogin})";
                $Param{UserID}     = $UserID;
                $Param{Comment}    = $UserData{Description};
                $Param{CalendarNo} = $UserData{Calendar};
                $Param{Calendar}   = $Self->{ConfigObject}->Get(
                    "TimeZone::Calendar"
                        . ( $Param{CalendarNo} || '' ) . "Name"
                ) || 'Default';

                $Self->{LayoutObject}->Block(
                    Name => 'OverviewResultUserRow',
                    Data => {%Param},
                );
            }
        }

        # otherwise, show a no data found message
        else {
            $Self->{LayoutObject}->Block( Name => 'NoUserDataFoundMsg' );
        }
    }

    return 1;
}

sub _TaskSettingsEdit {
    my ( $Self, %Param ) = @_;

    $Self->{LayoutObject}->Block(
        Name => 'Setting',
        Data => \%Param,
    );

    $Self->{LayoutObject}->Block( Name => 'ActionListSetting' );
    $Self->{LayoutObject}->Block( Name => 'ActionOverviewSetting' );

    # define status list
    my %StatusList = (
        1 => 'valid',
        0 => 'invalid',
    );

    my $TaskStatus = 1;
    if ( defined $Param{TaskStatus} ) {
        $TaskStatus = $Param{TaskStatus}
    }

    $Param{StatusOption} = $Self->{LayoutObject}->BuildSelection(
        Data       => \%StatusList,
        SelectedID => $TaskStatus,
        Name       => 'TaskStatus',
    );

    $Self->{LayoutObject}->Block(
        Name => 'OverviewUpdateTask',
        Data => \%Param,
    );

    # shows header
    if ( $Param{Action} eq 'EditTask' ) {
        $Self->{LayoutObject}->Block( Name => 'HeaderEditTask' );
    }
    else {
        $Self->{LayoutObject}->Block( Name => 'HeaderAddTask' );
    }

    # show server error message (if any) for the task name
    if ( $Param{TaskErrorType} ) {
        $Self->{LayoutObject}->Block( Name => $Param{TaskErrorType} );
    }

    return 1;
}

sub _UserSettingsEdit {
    my ( $Self, %Param ) = @_;
    my %GetParam = ();

    # get parameters
    for my $Parameter (qw(Description ShowOvertime CreateProject Calendar)) {
        $GetParam{$Parameter} = $Self->{ParamObject}->GetParam( Param => $Parameter );
    }

# the datepicker used in this screen is non-standard
# Therefor we have to define this var in the LayoutObject for automatic config generation in the JS footer
    $Self->{LayoutObject}->{HasDatepicker} = 1;

    $Self->{LayoutObject}->Block(
        Name => 'Setting',
        Data => \%Param,
    );

    $Self->{LayoutObject}->Block( Name => 'ActionListSetting' );
    $Self->{LayoutObject}->Block( Name => 'ActionOverviewSetting' );
    $Self->{LayoutObject}->Block( Name => 'Reference' );

    # define status list
    my %StatusList = (
        1 => 'valid',
        0 => 'invalid',
    );

    # fill up the calendar list
    my $CalendarListRef = { 0 => 'Default' };
    my $CalendarIndex = 1;
    while ( $Self->{ConfigObject}->Get( "TimeZone::Calendar" . $CalendarIndex . "Name" ) ) {
        $CalendarListRef->{$CalendarIndex}
            = $Self->{ConfigObject}->Get( "TimeZone::Calendar" . $CalendarIndex . "Name" );
        $CalendarIndex++;
    }

    # get user data
    my %UserData = $Self->{TimeAccountingObject}->UserGet( UserID => $Param{UserID} );

    $Param{CalendarOption} = $Self->{LayoutObject}->BuildSelection(
        Data        => $CalendarListRef,
        Name        => 'Calendar',
        Translation => 1,
        SelectedID  => $GetParam{Calendar} || $UserData{Calendar} || 0,
    );

    $Param{Description} = $GetParam{Description} || $UserData{Description} || '';

    $Self->{LayoutObject}->Block(
        Name => 'OverviewUpdateUser',
        Data => {
            %Param,
            ShowOvertime => ( $GetParam{ShowOvertime} || $UserData{ShowOvertime} )
            ? 'checked="checked"' : '',
            CreateProject => ( $GetParam{CreateProject} || $UserData{CreateProject} )
            ? 'checked="checked"' : '',
            }
    );

    # shows header
    if ( $Param{Action} eq 'EditUser' ) {
        $Self->{LayoutObject}->Block( Name => 'HeaderEditUser' );
    }
    else {
        $Self->{LayoutObject}->Block(
            Name => 'HeaderAddUser',
            Data => \%Param,
        );
    }

    # if there are errors to show
    if ( $Param{Errors} && %{ $Param{Errors} } ) {

        # show all existing periods
        for ( my $Period = 1; $Period <= $Param{Periods}; $Period++ ) {

            for my $Parameter (qw(DateStart DateEnd LeaveDays WeeklyHours Overtime PeriodStatus )) {
                $GetParam{$Parameter}
                    = $Self->{ParamObject}->GetParam( Param => "$Parameter\[$Period\]" );
            }

            $Param{$Period}{PeriodStatusOption} = $Self->{LayoutObject}->BuildSelection(
                Data       => \%StatusList,
                SelectedID => $GetParam{PeriodStatus} || $Param{$Period}{PeriodStatus},
                Name       => "PeriodStatus[$Period]",
                ID         => "PeriodStatus-$Period",
                Title      => $Self->{LayoutObject}->{LanguageObject}->Translate("Period Status"),
            );

            $Self->{LayoutObject}->Block(
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

            $Self->{LayoutObject}->Block(
                Name => 'DateStart'
                    . (
                    $Param{Errors}->{ 'DateStart-' . $Period . 'ErrorType' }
                        || 'MissingValue'
                    ),
                Data => { Period => $Period },
            );
            $Self->{LayoutObject}->Block(
                Name => 'DateEnd'
                    . ( $Param{Errors}->{ 'DateEnd-' . $Period . 'ErrorType' } || 'MissingValue' ),
                Data => { Period => $Period },
            );
        }
    }
    else {
        my %User = $Self->{TimeAccountingObject}->SingleUserSettingsGet( UserID => $Param{UserID} );

        # show user data
        if (%User) {
            my $LastPeriodNumber
                = $Self->{TimeAccountingObject}->UserLastPeriodNumberGet(
                UserID => $Param{UserID}
                );

            for ( my $Period = 1; $Period <= $LastPeriodNumber; $Period++ ) {
                my %PeriodParam = ();

                # get all needed data to display
                for my $Parameter (qw(DateStart DateEnd LeaveDays WeeklyHours Overtime)) {
                    $PeriodParam{$Parameter} = $User{$Period}{$Parameter};
                }
                $PeriodParam{Period} = $Period;

                $PeriodParam{PeriodStatusOption} = $Self->{LayoutObject}->BuildSelection(
                    Data       => \%StatusList,
                    SelectedID => $User{$Period}{UserStatus},
                    Name       => "PeriodStatus[$Period]",
                    ID         => "PeriodStatus-$Period",
                    Title => $Self->{LayoutObject}->{LanguageObject}->Translate("Period Status"),
                );

                $Self->{LayoutObject}->Block(
                    Name => 'PeriodOverviewRow',
                    Data => \%PeriodParam,
                );
            }
        }

        # show a no data found message
        else {
            $Self->{LayoutObject}->Block( Name => 'PeriodOverviewRowNoData' );
        }
    }

    return 1;
}

1;
