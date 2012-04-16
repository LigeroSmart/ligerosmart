# --
# ITSMIncidentProblemManagement.pm - code to excecute during package installation
# Copyright (C) 2001-2012 OTRS AG, http://otrs.org/
# --
# $Id: ITSMIncidentProblemManagement.pm,v 1.18 2012-04-16 17:48:27 cr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package var::packagesetup::ITSMIncidentProblemManagement;

use strict;
use warnings;

use Kernel::Config;
use Kernel::System::SysConfig;
use Kernel::System::CSV;
use Kernel::System::Group;
use Kernel::System::State;
use Kernel::System::Stats;
use Kernel::System::Type;
use Kernel::System::User;
use Kernel::System::Valid;
use Kernel::System::DynamicField;

use vars qw(@ISA $VERSION);
$VERSION = qw($Revision: 1.18 $) [1];

=head1 NAME

ITSMIncidentProblemManagement.pm - code to excecute during package installation

=head1 SYNOPSIS

All functions

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create an object

    use Kernel::Config;
    use Kernel::System::Encode;
    use Kernel::System::Log;
    use Kernel::System::Main;
    use Kernel::System::Time;
    use Kernel::System::DB;
    use Kernel::System::XML;
    use var::packagesetup::ITSMIncidentProblemManagement;

    my $ConfigObject = Kernel::Config->new();
    my $EncodeObject = Kernel::System::Encode->new(
        ConfigObject => $ConfigObject,
    );
    my $LogObject    = Kernel::System::Log->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
    );
    my $MainObject = Kernel::System::Main->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
    );
    my $TimeObject = Kernel::System::Time->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
    );
    my $DBObject = Kernel::System::DB->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
        MainObject   => $MainObject,
    );
    my $XMLObject = Kernel::System::XML->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
        DBObject     => $DBObject,
        MainObject   => $MainObject,
    );
    my $CodeObject = var::packagesetup::ITSMIncidentProblemManagement->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
        MainObject   => $MainObject,
        TimeObject   => $TimeObject,
        DBObject     => $DBObject,
        XMLObject    => $XMLObject,
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for my $Object (
        qw(ConfigObject EncodeObject LogObject MainObject TimeObject DBObject XMLObject)
        )
    {
        $Self->{$Object} = $Param{$Object} || die "Got no $Object!";
    }

    # create needed sysconfig object
    $Self->{SysConfigObject} = Kernel::System::SysConfig->new( %{$Self} );

    # rebuild ZZZ* files
    $Self->{SysConfigObject}->WriteDefault();

    # define the ZZZ files
    my @ZZZFiles = (
        'ZZZAAuto.pm',
        'ZZZAuto.pm',
    );

    # reload the ZZZ files (mod_perl workaround)
    for my $ZZZFile (@ZZZFiles) {

        PREFIX:
        for my $Prefix (@INC) {
            my $File = $Prefix . '/Kernel/Config/Files/' . $ZZZFile;
            next PREFIX if !-f $File;
            do $File;
            last PREFIX;
        }
    }

    # create needed objects
    $Self->{ConfigObject}       = Kernel::Config->new();
    $Self->{CSVObject}          = Kernel::System::CSV->new( %{$Self} );
    $Self->{GroupObject}        = Kernel::System::Group->new( %{$Self} );
    $Self->{UserObject}         = Kernel::System::User->new( %{$Self} );
    $Self->{StateObject}        = Kernel::System::State->new( %{$Self} );
    $Self->{TypeObject}         = Kernel::System::Type->new( %{$Self} );
    $Self->{ValidObject}        = Kernel::System::Valid->new( %{$Self} );
    $Self->{DynamicFieldObject} = Kernel::System::DynamicField->new( %{$Self} );
    $Self->{StatsObject}        = Kernel::System::Stats->new(
        %{$Self},
        UserID => 1,
    );

    # define file prefix for stats
    $Self->{FilePrefix} = 'ITSMStats';

    return $Self;
}

=item CodeInstall()

run the code install part

    my $Result = $CodeObject->CodeInstall();

=cut

sub CodeInstall {
    my ( $Self, %Param ) = @_;

    # set new ticket states to valid
    {
        my @StateNames = (
            'closed with workaround',
        );

        # set states to valid
        $Self->_SetStateValid(
            StateNames => \@StateNames,
            Valid      => 1,
        );
    }

    # set new ticket types to valid
    {
        my @TypeNames = (
            'Incident',
            'Incident::ServiceRequest',
            'Incident::Disaster',
            'Problem',
            'Problem::KnownError',
            'Problem::PendingRfC',
        );

        # set types to valid
        $Self->_SetTypeValid(
            TypeNames => \@TypeNames,
            Valid     => 1,
        );
    }

    # create dynamic fields for ITSM
    $Self->_CreateITSMDynamicFields();

    # install stats
    $Self->{StatsObject}->StatsInstall(
        FilePrefix => $Self->{FilePrefix},
    );

    return 1;
}

=item CodeReinstall()

run the code reinstall part

    my $Result = $CodeObject->CodeReinstall();

=cut

sub CodeReinstall {
    my ( $Self, %Param ) = @_;

    # set new ticket states to valid
    {
        my @StateNames = (
            'closed with workaround',
        );

        # set states to valid
        $Self->_SetStateValid(
            StateNames => \@StateNames,
            Valid      => 1,
        );
    }

    # set new ticket types to valid
    {
        my @TypeNames = (
            'Incident',
            'Incident::ServiceRequest',
            'Incident::Disaster',
            'Problem',
            'Problem::KnownError',
            'Problem::PendingRfC',
        );

        # set types to valid
        $Self->_SetTypeValid(
            TypeNames => \@TypeNames,
            Valid     => 1,
        );
    }

    # install stats
    $Self->{StatsObject}->StatsInstall(
        FilePrefix => $Self->{FilePrefix},
    );

    return 1;
}

=item CodeUpgrade()

run the code upgrade part

    my $Result = $CodeObject->CodeUpgrade();

=cut

sub CodeUpgrade {
    my ( $Self, %Param ) = @_;

    # install stats
    $Self->{StatsObject}->StatsInstall(
        FilePrefix => $Self->{FilePrefix},
    );

    return 1;
}

=item CodeUpgradeFromLowerThan_3_0_93()

This function is only executed if the installed module version is smaller than 3.0.93.

my $Result = $CodeObject->CodeUpgradeFromLowerThan_3_0_93();

=cut

sub CodeUpgradeFromLowerThan_3_0_93 {
    my ( $Self, %Param ) = @_;

    # get the definition for all dynamic fields for ITSM
    my @DynamicFields = $Self->_GetITSMDynamicFieldsDefinition();

    # clean up the migrated freetext and freetime fields
    # e.g. delete the possible values for fields that use the general catalog
    DYNAMICFIELD:
    for my $DynamicFieldNew (@DynamicFields) {

        # get existing dynamic field data
        my $DynamicFieldOld = $Self->{DynamicFieldObject}->DynamicFieldGet(
            Name => $DynamicFieldNew->{Name},
        );

        # update the dynamic field
        my $Success = $Self->{DynamicFieldObject}->DynamicFieldUpdate(
            ID         => $DynamicFieldOld->{ID},
            FieldOrder => $DynamicFieldOld->{FieldOrder},
            Name       => $DynamicFieldNew->{Name},
            Label      => $DynamicFieldNew->{Label},
            FieldType  => $DynamicFieldNew->{FieldType},
            ObjectType => $DynamicFieldNew->{ObjectType},
            Config     => $DynamicFieldNew->{Config},
            ValidID    => 1,
            Reorder    => 0,
            UserID     => 1,
        );
    }

    # define the enabled dynamic fields for each screen
    # (taken from sysconfig of ITSMIncidentProblemManagement)
    my %ScreenDynamicFieldConfig = (
        AgentTicketAddtlITSMField => {
            TicketFreeTime3 => 1,
            TicketFreeTime4 => 1,
            TicketFreeTime6 => 1,
        },
        AgentTicketDecision => {
            TicketFreeText16 => 1,
            TicketFreeTime5  => 1,
        },
        AgentTicketPhone => {
            TicketFreeText14 => 1,
            TicketFreeTime6  => 1,
        },
        AgentTicketEmail => {
            TicketFreeText14 => 1,
            TicketFreeTime6  => 1,
        },
        AgentTicketSearch => {
            TicketFreeText15 => 1,
            TicketFreeText16 => 1,
            TicketFreeTime3  => 1,
            TicketFreeTime4  => 1,
            TicketFreeTime5  => 1,
            TicketFreeTime6  => 1,
        },
        AgentTicketZoom => {
            TicketFreeText15 => 1,
            TicketFreeText16 => 1,
            TicketFreeTime3  => 1,
            TicketFreeTime4  => 1,
            TicketFreeTime5  => 1,
            TicketFreeTime6  => 1,
        },
        AgentTicketPriority => {
            TicketFreeText14 => 1,
        },
        AgentTicketClose => {
            TicketFreeText15 => 1,
        },
        AgentTicketCompose => {
            TicketFreeText15 => 1,
        },
    );

    for my $Screen ( keys %ScreenDynamicFieldConfig ) {

        # get existing config for each screen
        my $Config = $Self->{ConfigObject}->Get("Ticket::Frontend::$Screen");

        # get existing dynamic field config
        my %ExistingSetting = %{ $Config->{DynamicField} || {} };

        # add the new settings
        my %NewSetting = ( %ExistingSetting, %{ $ScreenDynamicFieldConfig{$Screen} } );

        # update the sysconfig
        my $Success = $Self->{SysConfigObject}->ConfigItemUpdate(
            Valid => 1,
            Key   => 'Ticket::Frontend::' . $Screen . '###DynamicField',
            Value => \%NewSetting,
        );
    }

    # install stats
    $Self->{StatsObject}->StatsInstall(
        FilePrefix => $Self->{FilePrefix},
    );

    return 1;
}

=item CodeUninstall()

run the code uninstall part

    my $Result = $CodeObject->CodeUninstall();

=cut

sub CodeUninstall {
    my ( $Self, %Param ) = @_;

    # set new ticket states to invalid
    {
        my @StateNames = (
            'closed with workaround',
        );

        # set states to invalid
        $Self->_SetStateValid(
            StateNames => \@StateNames,
            Valid      => 0,
        );
    }

    # set new ticket types to invalid
    {
        my @TypeNames = (
            'Incident',
            'Incident::ServiceRequest',
            'Incident::Disaster',
            'Problem',
            'Problem::KnownError',
            'Problem::PendingRfC',
        );

        # set types to invalid
        $Self->_SetTypeValid(
            TypeNames => \@TypeNames,
            Valid     => 0,
        );
    }

    return 1;
}

=item _SetStateValid()

sets states to valid|invalid

    my $Result = $CodeObject->_SetStateValid(
        StateNames => [ 'new', 'open' ],
        Valid      => 1,
    );

=cut

sub _SetStateValid {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{StateNames} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need StateNames!' );
        return;
    }

    # lookup valid id
    my %ValidList = $Self->{ValidObject}->ValidList();
    %ValidList = reverse %ValidList;
    my $ValidID = $Param{Valid} ? $ValidList{valid} : $ValidList{invalid};

    STATENAME:
    for my $StateName ( @{ $Param{StateNames} } ) {

        # get state
        my %State = $Self->{StateObject}->StateGet(
            Name => $StateName,
        );

        next STATENAME if !%State;

        # set state
        $Self->{StateObject}->StateUpdate(
            %State,
            ValidID => $ValidID,
            UserID  => 1,
        );
    }

    return 1;
}

=item _SetTypeValid()

sets types to valid|invalid

    my $Result = $CodeObject->_SetTypeValid(
        TypeNames => [ 'Incident', 'Problem' ],
        Valid     => 1,
    );

=cut

sub _SetTypeValid {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{TypeNames} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need TypeNames!' );
        return;
    }

    # lookup valid id
    my %ValidList = $Self->{ValidObject}->ValidList();
    %ValidList = reverse %ValidList;
    my $ValidID = $Param{Valid} ? $ValidList{valid} : $ValidList{invalid};

    # get list of all types
    my %TypeList = $Self->{TypeObject}->TypeList(
        Valid => 0,
    );

    # reverse the type list for easier lookup
    my %TypeListReverse = reverse %TypeList;

    TYPENAME:
    for my $TypeName ( @{ $Param{TypeNames} } ) {

        # lookup type id
        my $TypeID = $TypeListReverse{$TypeName};

        next TYPENAME if !$TypeID;

        # get type
        my %Type = $Self->{TypeObject}->TypeGet(
            ID => $TypeID,
        );

        # set type
        $Self->{TypeObject}->TypeUpdate(
            %Type,
            ValidID => $ValidID,
            UserID  => 1,
        );
    }

    return 1;
}

=item _CreateITSMDynamicFields()

creates all dynamic fields that are necessary for ITSM

    my $Result = $CodeObject->_CreateITSMDynamicFields();

=cut

sub _CreateITSMDynamicFields {
    my ( $Self, %Param ) = @_;

    my $ValidID = $Self->{ValidObject}->ValidLookup(
        Valid => 'valid',
    );

    # get all current dynamic fields
    my $DynamicFieldList = $Self->{DynamicFieldObject}->DynamicFieldListGet(
        Valid => 0,
    );

    # get the list of order numbers (is already sorted).
    my @DynamicfieldOrderList;
    for my $Dynamicfield ( @{$DynamicFieldList} ) {
        push @DynamicfieldOrderList, $Dynamicfield->{FieldOrder};
    }

    # get the last element from the order list and add 1
    my $NextOrderNumber = 1;
    if (@DynamicfieldOrderList) {
        $NextOrderNumber = $DynamicfieldOrderList[-1] + 1;
    }

    # get the definition for all dynamic fields for ITSM
    my @DynamicFields = $Self->_GetITSMDynamicFieldsDefinition();

    # create a dynamic fields lookup table
    my %DynamicFieldLookup;
    for my $DynamicField ( @{$DynamicFieldList} ) {
        next if ref $DynamicField ne 'HASH';
        $DynamicFieldLookup{ $DynamicField->{Name} } = $DynamicField;
    }

    # get current post master x-headers
    my %PostMasterHeaders
        = map { $_ => 1 } @{ $Self->{ConfigObject}->Get('PostmasterX-Header') };

    my @PostMasterValuesToSet;

    # create or update dynamic fields
    DYNAMICFIELD:
    for my $DynamicField (@DynamicFields) {

        my $CreateDynamicField;

        # check if the dynamic field already exists
        if ( ref $DynamicFieldLookup{ $DynamicField->{Name} } ne 'HASH' ) {
            $CreateDynamicField = 1;
        }

        # if the field exists check if the type match with the needed type
        elsif (
            $DynamicFieldLookup{ $DynamicField->{Name} }->{FieldType}
            ne $DynamicField->{FieldType}
            )
        {

            # rename the field and create a new one
            my $Success = $Self->{DynamicFieldObject}->DynamicFieldUpdate(
                %{ $DynamicFieldLookup{ $DynamicField->{Name} } },
                Name   => $DynamicFieldLookup{ $DynamicField->{Name} }->{Name} . 'Old',
                UserID => 1,
            );

            $CreateDynamicField = 1;
        }

        # otherwise if the field exists and the type match, update it to the ITSM definition
        else {
            my $Success = $Self->{DynamicFieldObject}->DynamicFieldUpdate(
                %{$DynamicField},
                ID         => $DynamicFieldLookup{ $DynamicField->{Name} }->{ID},
                FieldOrder => $DynamicFieldLookup{ $DynamicField->{Name} }->{FieldOrder},
                ValidID    => $ValidID,
                Reorder    => 0,
                UserID     => 1,
            );
        }

        # check if new field has to be created
        if ($CreateDynamicField) {

            # create a new field
            my $FieldID = $Self->{DynamicFieldObject}->DynamicFieldAdd(
                Name       => $DynamicField->{Name},
                Label      => $DynamicField->{Label},
                FieldOrder => $NextOrderNumber,
                FieldType  => $DynamicField->{FieldType},
                ObjectType => $DynamicField->{ObjectType},
                Config     => $DynamicField->{Config},
                ValidID    => $ValidID,
                UserID     => 1,
            );
            next DYNAMICFIELD if !$FieldID;

            # increase the order number
            $NextOrderNumber++;
        }

        # check if x-header for the dynamic field already exists
        if ( !$PostMasterHeaders{ 'X-OTRS-DynamicField-' . $DynamicField->{Name} } ) {
            $PostMasterHeaders{ 'X-OTRS-DynamicField-' . $DynamicField->{Name} } = 1;
        }
        if ( !$PostMasterHeaders{ 'X-OTRS-FollowUp-DynamicField-' . $DynamicField->{Name} } ) {
            $PostMasterHeaders{ 'X-OTRS-FollowUp-DynamicField-' . $DynamicField->{Name} } = 1;
        }
    }

    # revert values from hash into an array
    @PostMasterValuesToSet = sort keys %PostMasterHeaders;

    # execute the update action in sysconfig
    my $Success = $Self->{SysConfigObject}->ConfigItemUpdate(
        Valid => 1,
        Key   => 'PostmasterX-Header',
        Value => \@PostMasterValuesToSet,
    );

    return 1;
}

=item _GetITSMDynamicFieldsDefinition()

returns the definition for ITSM related dynamic fields

    my $Result = $CodeObject->_GetITSMDynamicFieldsDefinition();

=cut

sub _GetITSMDynamicFieldsDefinition {
    my ( $Self, %Param ) = @_;

    # define all dynamic fields for ITSM
    my @DynamicFields = (
        {
            Name       => 'TicketFreeText13',
            Label      => 'Criticality',
            FieldType  => 'Text',
            ObjectType => 'Ticket',
            Config     => {
                TranslatableValues => 1,
            },
        },
        {
            Name       => 'TicketFreeText14',
            Label      => 'Impact',
            FieldType  => 'Dropdown',
            ObjectType => 'Ticket',
            Config     => {
                DefaultValue       => '3 normal',
                TranslatableValues => 1,
            },
        },
        {
            Name       => 'TicketFreeText15',
            Label      => 'Review Required',
            FieldType  => 'Dropdown',
            ObjectType => 'Ticket',
            Config     => {
                DefaultValue   => 'No',
                Link           => '',
                PossibleNone   => 0,
                PossibleValues => {
                    No  => 'No',
                    Yes => 'Yes',
                },
                TranslatableValues => 1,
            },
        },
        {
            Name       => 'TicketFreeText16',
            Label      => 'Decision Result',
            FieldType  => 'Dropdown',
            ObjectType => 'Ticket',
            Config     => {
                DefaultValue       => 'Pending',
                Link               => '',
                TranslatableValues => 1,
                PossibleNone       => 1,
                PossibleValues     => {
                    'Approved'     => 'Approved',
                    'Pending'      => 'Pending',
                    'Postponed'    => 'Postponed',
                    'Pre-approved' => 'Pre-approved',
                    'Rejected'     => 'Rejected',
                },
            },
        },
        {
            Name       => 'TicketFreeTime3',
            Label      => 'Repair Start Time',
            FieldType  => 'DateTime',
            ObjectType => 'Ticket',
            Config     => {
                DefaultValue  => 0,
                Link          => '',
                YearsInFuture => 5,
                YearsInPast   => 5,
                YearsPeriod   => 1,
            },
        },
        {
            Name       => 'TicketFreeTime4',
            Label      => 'Recovery Start Time',
            FieldType  => 'DateTime',
            ObjectType => 'Ticket',
            Config     => {
                DefaultValue  => 0,
                Link          => '',
                YearsInFuture => 5,
                YearsInPast   => 5,
                YearsPeriod   => 1,
            },
        },
        {
            Name       => 'TicketFreeTime5',
            Label      => 'Decision Date',
            FieldType  => 'DateTime',
            ObjectType => 'Ticket',
            Config     => {
                DefaultValue  => 0,
                Link          => '',
                YearsInFuture => 5,
                YearsInPast   => 5,
                YearsPeriod   => 1,
            },
        },
        {
            Name       => 'TicketFreeTime6',
            Label      => 'Due Date',
            FieldType  => 'DateTime',
            ObjectType => 'Ticket',
            Config     => {
                DefaultValue  => 259200,
                Link          => '',
                YearsInFuture => 1,
                YearsInPast   => 9,
                YearsPeriod   => 1,
            },
        },
    );

    return @DynamicFields;
}

1;

=back

=head1 TERMS AND CONDITIONS

This Software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/gpl-2.0.txt>.

=cut

=head1 VERSION

$Revision: 1.18 $ $Date: 2012-04-16 17:48:27 $

=cut
