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

    #use Data::Dumper;
    #$Kernel::OM->Get('Kernel::System::Log')->Log(
    #    Priority => 'error',
    #    Message  => "SELF ".Dumper($Self->{UserID}),
    #);

    my %AreasList = (
        "Ticket::Frontend::AgentTicketPhone###DynamicField" => 0,
        "Ticket::Frontend::CustomerTicketMessage###DynamicField" => 0,
        "Ticket::Frontend::AgentTicketZoom###DynamicField" => 0,
        "Ticket::Frontend::CustomerTicketZoom###DynamicField" => 0,
        "Ticket::Frontend::AgentTicketZoom###ProcessWidgetDynamicField" => 0,
        "Ticket::Frontend::AgentTicketEmail###DynamicField" => 0,
        "Ticket::Frontend::AgentTicketSearch###DynamicField" => 0,
        "Ticket::Frontend::OverviewSmall###DynamicField" => 0,
        "Ticket::Frontend::AgentTicketFreeText###DynamicField" => 0,
        "Ticket::Frontend::AgentTicketNote###DynamicField" => 0,
        "Ticket::Frontend::AgentTicketClose###DynamicField" => 0,
    );

    # ------------------------------------------------------------ #
    # AllocateDynamicField
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
            );

            foreach my $key2 (sort keys %{$Setting{EffectiveValue}}){
                if($key2 eq $DataReceived->{dynamicFieldName}){
                    push $ValRetorno->{areas}, $key;
                    $ValRetorno->{visibilities}->{$key} = $Setting{EffectiveValue}->{$key2};
                }
            }

            my %SettingGroup = $SysConfigObject->SettingGet(
                Name    => "Ticket::Frontend::AgentTicketZoom###ProcessWidgetDynamicFieldGroups",
            );

            foreach my $key2 (sort keys %{$SettingGroup{EffectiveValue}}){
                my @values = split(',', $SettingGroup{EffectiveValue}->{$key2});
                my @newValues;
                foreach my $val (@values) {
                    if($val eq $DataReceived->{dynamicFieldName}){
                        $ValRetorno->{widgetGroup} = $key2;
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
                    Name    => $key,
                    Deployed        => 1,
                );

                $Setting{EffectiveValue}->{$DataReceived->{dynamicFieldName}} = $DataReceived->{visibilities}->{$key};

                my $ExclusiveLockGUID = $SysConfigObject->SettingLock(
                    UserID    => $Self->{UserID},
                    Force     => 1,
                    DefaultID => $Setting{DefaultID},
                );

                my %Success = $Kernel::OM->Get("Kernel::System::SysConfig")->SettingUpdate(
                    Name              => $key,
                    EffectiveValue    => $Setting{EffectiveValue},
                    ExclusiveLockGUID => $ExclusiveLockGUID,
                    UserID            => $Self->{UserID},
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
                        Name    => "Ticket::Frontend::AgentTicketZoom###ProcessWidgetDynamicFieldGroups",
                        Deployed        => 1,
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

                    if($DataReceived->{widgetGroup}){
                        my @values = split(',', $SettingGroup{EffectiveValue}->{$DataReceived->{widgetGroup}});
                        push @values,$DataReceived->{dynamicFieldName};
                        $SettingGroup{EffectiveValue}->{$DataReceived->{widgetGroup}} = join(',', @values);
                    }

                    $ExclusiveLockGUID = $SysConfigObject->SettingLock(
                        UserID    => $Self->{UserID},
                        Force     => 1,
                        DefaultID => $SettingGroup{DefaultID},
                    );

                    %Success = $Kernel::OM->Get("Kernel::System::SysConfig")->SettingUpdate(
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

            } else{
                #Remover campo dos campos dinamicos
                my %Setting = $SysConfigObject->SettingGet(
                    Name    => $key,
                    Deployed        => 1,
                );

                delete $Setting{EffectiveValue}->{$DataReceived->{dynamicFieldName}};

                my $ExclusiveLockGUID = $SysConfigObject->SettingLock(
                    UserID    => $Self->{UserID},
                    Force     => 1,
                    DefaultID => $Setting{DefaultID},
                );

                my $Success = $Kernel::OM->Get("Kernel::System::SysConfig")->SettingUpdate(
                    Name              => $key,
                    EffectiveValue    => $Setting{EffectiveValue},
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

                if($key eq "Ticket::Frontend::AgentTicketZoom###ProcessWidgetDynamicField"){
                    my %SettingGroup = $SysConfigObject->SettingGet(
                        Name    => "Ticket::Frontend::AgentTicketZoom###ProcessWidgetDynamicFieldGroups",
                        Deployed        => 1,
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