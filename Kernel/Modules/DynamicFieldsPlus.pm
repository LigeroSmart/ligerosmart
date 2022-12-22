package Kernel::Modules::DynamicFieldsPlus;

use strict;
use warnings;
use Data::Dumper;
use vars qw($VERSION);
$VERSION = qw($Revision: 1.20 $) [1];

sub new {
    my ( $Integrations, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Integrations );


    #$Integrations  = $Kernel::OM->Get('Kernel::System::SubscriptionPlan');
    $Self->{ValidObject} = $Kernel::OM->Get('Kernel::System::Valid');

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;
    my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');
    my $TranslateObject = $Kernel::OM->Get('Kernel::Language');
    my $JSONObject = $Kernel::OM->Get('Kernel::System::JSON');

    my %AreasList = (
        "Ticket::Frontend::CustomerTicketMessage###DynamicField" => 0,
        "Ticket::Frontend::CustomerTicketZoom###DynamicField" => 0,
        "Ticket::Frontend::CustomerTicketOverview###DynamicField" => 0,      
        "Ticket::Frontend::AgentTicketPhone###DynamicField" => 0,
        "Ticket::Frontend::AgentTicketZoom###DynamicField" => 0,
        "Ticket::Frontend::AgentTicketZoom###ProcessWidgetDynamicField" => 0,
        "Ticket::Frontend::AgentTicketEmail###DynamicField" => 0,
        "Ticket::Frontend::AgentTicketSearch###DynamicField" => 0,
        "Ticket::Frontend::AgentTicketFreeText###DynamicField" => 0,
        "Ticket::Frontend::AgentTicketNote###DynamicField" => 0,
        "Ticket::Frontend::AgentTicketClose###DynamicField" => 0,
        "Ticket::Frontend::AgentTicketCompose###DynamicField" => 0,
        "Ticket::Frontend::OverviewSmall###DynamicField" => 0,
        "Ticket::Frontend::AgentTicketLigeroSmartClassification###DynamicField" => 0,
        "Ticket::Frontend::AgentTicketAddtlITSMField###DynamicField" => 0,
        "Ticket::Frontend::AgentTicketArticleEdit###DynamicField" => 0,
        "Ticket::Frontend::AgentTicketDecision###DynamicField" => 0,
        "Ticket::Frontend::AgentTicketEmailOutbound###DynamicField" => 0,
        "Ticket::Frontend::AgentTicketForward###DynamicField" => 0,
        "Ticket::Frontend::AgentTicketMove###DynamicField" => 0,
        "Ticket::Frontend::AgentTicketOwner###DynamicField" => 0,
        "Ticket::Frontend::AgentTicketPending###DynamicField" => 0,
        "Ticket::Frontend::AgentTicketPhoneInbound###DynamicField" => 0,
        "Ticket::Frontend::AgentTicketPhoneOutbound###DynamicField" => 0,
        "Ticket::Frontend::AgentTicketPrint###DynamicField" => 0,
        "Ticket::Frontend::AgentTicketPriority###DynamicField" => 0,
        "Ticket::Frontend::AgentTicketResponsible###DynamicField" => 0,
        "Ticket::Frontend::CustomerTicketSearch###DynamicField" => 0,
        "Ticket::Frontend::CustomerTicketPrint###DynamicField" => 0,
    );

    # ------------------------------------------------------------ #
    # Get Field display areas and process groups
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'GetAllocateDynamicField' ) {

        my $Value = $ParamObject->GetParam( Param => 'Data' ) || '';

        my $DataReceived = $JSONObject->Decode(
            Data => $Value,
        );

        my $ValRetorno = {
            dynamicFieldName => $DataReceived->{dynamicFieldName},
            areas => [],
            visibilities => {}
        };

        foreach my $key (sort keys %AreasList) {

            my %Setting = $SysConfigObject->SettingGet(
                Name    => $key,
                NoCache => 1,
                Deployed        => 0,
            );

            foreach my $key2 (sort keys %{$Setting{EffectiveValue}}){
                if($key2 eq $DataReceived->{dynamicFieldName}){
                    push @{$ValRetorno->{areas}}, $key;
                    $ValRetorno->{visibilities}->{$key} = $Setting{EffectiveValue}->{$key2};
                }
            }

            my %SettingGroup = $SysConfigObject->SettingGet(
                Name    => "Ticket::Frontend::AgentTicketZoom###ProcessWidgetDynamicFieldGroups",
                NoCache => 1,
                Deployed        => 0,
            );

            # Get all groups where the dynamic field is allocated
            for my $group ( sort keys %{$SettingGroup{EffectiveValue}} ) {
                my @values = split( ',', $SettingGroup{EffectiveValue}->{$group} );
                for my $value (@values) {
                    if ( $value eq $DataReceived->{dynamicFieldName} ) {
                        push @{$ValRetorno->{widgetGroup}}, $group;
                    }
                }
            }
        }

        my $JSON = $LayoutObject->JSONEncode(
            Data => $ValRetorno,
        );

        return $LayoutObject->Attachment(
            ContentType => 'application/json; charset=utf8',
            Content     => $JSON || '',
            Type        => 'inline',
            NoCache     => 1,
        );
    }

     # ------------------------------------------------------------ #
    # AllocateDynamicField
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'AllocateDynamicField' ) {

        my $Value = $ParamObject->GetParam( Param => 'Data' ) || '';

        my $DataReceived = $JSONObject->Decode(
            Data => $Value,
        );

        foreach my $area (@{$DataReceived->{areas}}){
            $AreasList{$area} = 1;
        }

        NEXT_AREA:
        foreach my $key (sort keys %AreasList) {

            next NEXT_AREA if !$key;

            my $value = $AreasList{$key};

            if($value == 1){
                my %Setting = $SysConfigObject->SettingGet(
                    Name        => $key,
                    Deployed    => 0,
                );

                my %EffectiveValue = (
                    %{$Setting{EffectiveValue}},
                    $DataReceived->{dynamicFieldName} => $DataReceived->{visibilities}->{$key},
                );

                my $ExclusiveLockGUID = $SysConfigObject->SettingLock(
                    UserID    => $Self->{UserID},
                    Force     => 1,
                    DefaultID => $Setting{DefaultID},
                );

                my %Success = $Kernel::OM->Get("Kernel::System::SysConfig")->SettingUpdate(
                    Name              => $key,
                    IsValid           => 1,
                    EffectiveValue    => \%EffectiveValue,
                    ExclusiveLockGUID => $ExclusiveLockGUID,
                    UserID            => $Self->{UserID},
                    # TargetUserID      => $Self->{UserID},
                );

                my $Success = $Kernel::OM->Get("Kernel::System::SysConfig")->SettingUnlock(
                    UserID    => $Self->{UserID},
                    DefaultID => $Setting{DefaultID},
                );

                #my %DeploymentResult = $Kernel::OM->Get("Kernel::System::SysConfig")->ConfigurationDeploy(
                #    Comments      => "Add Dynamic Field 2",
                #    UserID        => 1,
                #    Force         => 1,
                #    DirtySettings => [$key],
                #);
                if($key eq "Ticket::Frontend::AgentTicketZoom###ProcessWidgetDynamicField"){
                    my %SettingGroup = $SysConfigObject->SettingGet(
                        Name     => "Ticket::Frontend::AgentTicketZoom###ProcessWidgetDynamicFieldGroups",
                        Deployed => 0,
                        NoCache  => 1,
                    );

                    my %EffectiveValueGroups;
                    foreach my $keya (sort keys %{$SettingGroup{EffectiveValue}}) {
                        my @values = split(',', $SettingGroup{EffectiveValue}->{$keya});
                        my @newValues;
                        foreach my $val (@values) {
                            if($val ne $DataReceived->{dynamicFieldName}){
                                push @newValues,$val;
                            }
                        }
                        $EffectiveValueGroups{$keya} = join(',', @newValues);
                    }

                    if($DataReceived->{widgetGroup}){
                        # for each group in widgetGroup
                        foreach my $group (@{$DataReceived->{widgetGroup}}){
                            if($EffectiveValueGroups{$group}){
                                my @values = split(',', $EffectiveValueGroups{$group});
                                push @values,$DataReceived->{dynamicFieldName};
                                $EffectiveValueGroups{$group} = join(',', @values);
                            }else{
                                $EffectiveValueGroups{$group} = $DataReceived->{dynamicFieldName};
                            }
                        }
                    }

                    my $ExclusiveLockGUID = $SysConfigObject->SettingLock(
                        UserID    => $Self->{UserID},
                        Force     => 1,
                        DefaultID => $SettingGroup{DefaultID},
                    );

                    my %Success = $Kernel::OM->Get("Kernel::System::SysConfig")->SettingUpdate(
                        Name              => 'Ticket::Frontend::AgentTicketZoom###ProcessWidgetDynamicFieldGroups',
                        EffectiveValue    => \%EffectiveValueGroups,
                        ExclusiveLockGUID => $ExclusiveLockGUID,
                        UserID            => $Self->{UserID},
                        NoValidation      => 1,
                        # UserModificationActive => 1,
                    );

                    my $Success = $Kernel::OM->Get("Kernel::System::SysConfig")->SettingUnlock(
                        UserID    => $Self->{UserID},
                        DefaultID => $SettingGroup{DefaultID},
                    );

                    #%DeploymentResult = $Kernel::OM->Get("Kernel::System::SysConfig")->ConfigurationDeploy(
                    #    Comments      => "Add Dynamic Field 2",
                    #    UserID        => 1,
                    #    Force         => 1,
                    #    DirtySettings => ["Ticket::Frontend::AgentTicketZoom###ProcessWidgetDynamicFieldGroups"],
                    #);
                }

            } else{
                #Remover campo dos campos dinamicos
                my %Setting = $SysConfigObject->SettingGet(
                    Name    => $key,
                    Deployed        => 0,
                );

                my %EffectiveValue = (
                    %{$Setting{EffectiveValue}},
                );

                delete $EffectiveValue{$DataReceived->{dynamicFieldName}};

                my $ExclusiveLockGUID = $SysConfigObject->SettingLock(
                    UserID    => $Self->{UserID},
                    Force     => 1,
                    DefaultID => $Setting{DefaultID},
                );

                my $Success = $Kernel::OM->Get("Kernel::System::SysConfig")->SettingUpdate(
                    Name              => $key,
                    EffectiveValue    => \%EffectiveValue,
                    ExclusiveLockGUID => $ExclusiveLockGUID,
                    UserID            => $Self->{UserID},
                );

                $Success = $Kernel::OM->Get("Kernel::System::SysConfig")->SettingUnlock(
                    UserID    => $Self->{UserID},
                    DefaultID => $Setting{DefaultID},
                );

                #my %DeploymentResult = $Kernel::OM->Get("Kernel::System::SysConfig")->ConfigurationDeploy(
                #    Comments      => "Add Dynamic Field",
                #    UserID        => 1,
                #    Force         => 1,
                #    DirtySettings => [$key],
                #);

                # Check for ProcessWidgetDynamicFieldGroups
                if($key eq "Ticket::Frontend::AgentTicketZoom###ProcessWidgetDynamicField"){
                    my %SettingGroup = $SysConfigObject->SettingGet(
                        Name    => "Ticket::Frontend::AgentTicketZoom###ProcessWidgetDynamicFieldGroups",
                        Deployed        => 0,
                        NoCache         => 1,
                    );

                    foreach my $keya (sort keys %{$SettingGroup{EffectiveValue}}) {
                        my @values = split(',', $SettingGroup{EffectiveValue}->{$keya});
                        my @newValues;
                        foreach my $val (@values) {
                            if($val ne $DataReceived->{dynamicFieldName}){
                                push @newValues,$val;
                            }
                        }
                        $SettingGroup{EffectiveValue}->{$keya} = join(',', @newValues);
                    }

                    $ExclusiveLockGUID = $SysConfigObject->SettingLock(
                        UserID    => $Self->{UserID},
                        Force     => 1,
                        DefaultID => $SettingGroup{DefaultID},
                    );

                    my %Success = $Kernel::OM->Get("Kernel::System::SysConfig")->SettingUpdate(
                        Name              => "Ticket::Frontend::AgentTicketZoom###ProcessWidgetDynamicFieldGroups",
                        EffectiveValue    => $SettingGroup{EffectiveValue},
                        ExclusiveLockGUID => $ExclusiveLockGUID,
                        UserID            => $Self->{UserID},
                    );

                    $Success = $Kernel::OM->Get("Kernel::System::SysConfig")->SettingUnlock(
                        UserID    => $Self->{UserID},
                        DefaultID => $SettingGroup{DefaultID},
                    );

                    #%DeploymentResult = $Kernel::OM->Get("Kernel::System::SysConfig")->ConfigurationDeploy(
                    #    Comments      => "Add Dynamic Field 2",
                    #    UserID        => 1,
                    #    Force         => 1,
                    #    DirtySettings => ["Ticket::Frontend::AgentTicketZoom###ProcessWidgetDynamicFieldGroups"],
                    #);
                    

                }
            }
        }

        return $LayoutObject->Attachment(
            ContentType => 'application/json; charset=utf8',
            Content     => '1',
            Type        => 'inline',
            NoCache     => 1,
        );
    }

    return $LayoutObject->Attachment(
            ContentType => 'application/json; charset=utf8',
            Content     => '0',
            Type        => 'inline',
            NoCache     => 1,
        );
}

1;