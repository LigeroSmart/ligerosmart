package var::processes::examples::LGPDRelatorioDadosPessoais_post;
## nofilter(TidyAll::Plugin::OTRS::Perl::PerlCritic)

use strict;
use warnings;
use utf8;

our @ObjectDependencies = (
    "Kernel::Config",
    "Kernel::System::SysConfig",
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my %Response = (
        Success => 1,
    );

    my $SettingName = "Ticket::Frontend::AgentTicketZoom###ProcessWidgetDynamicField";
    my %Setting = $Kernel::OM->Get("Kernel::System::SysConfig")->SettingGet(
        Name     => $SettingName,
        Deployed => 1,
    );

    my $EffectiveValue = $Setting{EffectiveValue};
    my %Data = (

				'LGPDStatusEnvioDadosPessoais' => '1',
			);
    for my $Field(keys %Data){
        $EffectiveValue->{$Field} = $Data{$Field};
    }
    my $ExclusiveLockGUID = $Kernel::OM->Get("Kernel::System::SysConfig")->SettingLock(
        UserID    => 1,
        Force     => 1,
        DefaultID => $Setting{DefaultID},
    );
    $Kernel::OM->Get("Kernel::System::SysConfig")->SettingUpdate(
        Name              => $SettingName,
        EffectiveValue    => $EffectiveValue,
        ExclusiveLockGUID => $ExclusiveLockGUID,
        UserID            => 1,
    );

    my %NewSingleSettings = (
    );

    for my $SName (keys %NewSingleSettings){
        %Setting = $Kernel::OM->Get("Kernel::System::SysConfig")->SettingGet(
            Name     => $SName,
            Deployed => 1,
        );
        $EffectiveValue = $NewSingleSettings{$SName};
        $ExclusiveLockGUID = $Kernel::OM->Get("Kernel::System::SysConfig")->SettingLock(
            UserID    => 1,
            Force     => 1,
            DefaultID => $Setting{DefaultID},
        );
        $Kernel::OM->Get("Kernel::System::SysConfig")->SettingUpdate(
            Name              => $SName,
            EffectiveValue    => $EffectiveValue,
            ExclusiveLockGUID => $ExclusiveLockGUID,
            UserID            => 1,
        );
    }
    return %Response;
}

1;
