# --
# --
package Kernel::System::GenericAgent::TimeCount;

use strict;
use warnings;
use CGI ":standard";
use URI;
use URI::QueryParam;
use POSIX;
use Data::Dumper;
use Kernel::System::DynamicField;
use Kernel::System::DynamicField::Backend;

# use Kernel::System::Priority;

our @ObjectDependencies = (
    'Kernel::System::Log',
    'Kernel::System::DynamicField',
    'Kernel::System::DynamicFieldBackend',
    'Kernel::System::DynamicFieldValue',
    'Kernel::System::Ticket',
    'Kernel::System::Time',
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    $Self->{DynamicFieldObject}         = $Kernel::OM->Get('Kernel::System::DynamicField');
    $Self->{LogObject}                  = $Kernel::OM->Get('Kernel::System::Log');
    $Self->{TimeObject}                 = $Kernel::OM->Get('Kernel::System::Time');
    $Self->{TicketObject}               = $Kernel::OM->Get('Kernel::System::Ticket');
    $Self->{DynamicFieldBackendObject}  = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

    # 0=off; 1=on;
    $Self->{Debug} = $Param{Debug} || 0;

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $DynamicFieldValueObject = $Kernel::OM->Get('Kernel::System::DynamicFieldValue');

    # Input Parameters
    # - Start
    # - End - Optional - If not set, current time will be used
    # - Calendar - Optional - Calendar to be used to count Business Days.
    #                         If not set, queue or SLA calendar will be used
    # - MaxWorkingDays - Number of max loops looking for Working Days count
    #
    # Output Parameters
    # - DaysDF
    # - WorkingDaysDF
    # - MinutesDF
    # - WorkingMinutesDF
    # - ReadableTimeDF
    # - WorkingReadableTimeDF

    # Get All params
    my $ParamsString;
    for my $Params ( grep {$_ =~ "^ParamValue"} keys %{$Param{New}}){
        $ParamsString .= $Param{New}->{$Params}.';' if $Param{New}->{$Params};
    }

    return if !$ParamsString;

    my $TemplateGeneratorObject = $Kernel::OM->Get('Kernel::System::TemplateGenerator');
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

    my %Ticket = $TicketObject->TicketGet(
            TicketID      => $Param{TicketID},
            DynamicFields => 1,
            UserID        => 1,
        );

    my $GetParam = URI->new( CGI::url() );
    $GetParam->query( $ParamsString );

    my %Parameters;
    for my $P ( qw(Start End Calendar DaysDF WorkingDaysDF MinutesDF WorkingMinutesDF ReadableTimeDF WorkingReadableTimeDF MaxWorkingDays)){
        $Parameters{$P} = $GetParam->query_param( $P );
        $Parameters{$P} = $TemplateGeneratorObject->_Replace(
            RichText   => 0,
            Text       => $Parameters{$P},
            Data       => {},
            TicketData => \%Ticket,
            UserID     => 1,
        ) if $Parameters{$P};        
    };
    return if !$Parameters{Start};

    my $Calendar = 0;
    if($Parameters{Calendar}){
        $Calendar = $Parameters{Calendar};
    } else {
        my %Escalation = $TicketObject->TicketEscalationPreferences(
            Ticket => \%Ticket,
            UserID => 1,
        );
        $Calendar = $Escalation{Calendar} || 0;
    }

    # Init counters
    my %Counters;
    $Counters{Days}                = 0;
    $Counters{WorkingDays}         = 0;
    $Counters{Minutes}             = 0;
    $Counters{WorkingMinutes}      = 0;
    $Counters{ReadableTime}        = 0;
    $Counters{WorkingReadableTime} = 0;

    # create datetime object
    my $NowObj = $Kernel::OM->Create('Kernel::System::DateTime');

    my $StartTimeObj = $NowObj->Clone();
    $StartTimeObj->Set(
        String => $Parameters{Start}
    );

    my $EndTimeObj = $NowObj->Clone();
    $EndTimeObj->Set(
        String => $Parameters{End}
    ) if $Parameters{End};

    return if ($StartTimeObj->Compare(DateTimeObject => $EndTimeObj) == 1);

    my $DeltaWorkingObj = $StartTimeObj->Delta(
        DateTimeObject => $EndTimeObj,
        ForWorkingTime => 1,
        Calendar       => $Calendar,
    );
    
    my $DeltaObj = $StartTimeObj->Delta(
        DateTimeObject => $EndTimeObj,
        ForWorkingTime => 0,
        Calendar       => $Calendar,
    );
    
    # Obtem tempo em pausa
    my $StoppedSeconds = 0;
    if($TicketObject->can('GetTotalNonEscalationRelevantBusinessTime')){
        $StoppedSeconds = $TicketObject->GetTotalNonEscalationRelevantBusinessTime(
            TicketID       => $Param{TicketID},
            StartTimestamp => $StartTimeObj->ToString(),
            StopTimestamp  => $EndTimeObj->ToString(),
        );
    }

    #Minutos
    $Counters{Minutes} = ($DeltaObj->{AbsoluteSeconds}/60) if $DeltaObj->{AbsoluteSeconds};
    $Counters{Minutes} = floor($Counters{Minutes}) if $Counters{Minutes};

    # Minutos Úteis
    $Counters{WorkingMinutes} = (($DeltaWorkingObj->{AbsoluteSeconds} - $StoppedSeconds)/60) if $DeltaWorkingObj->{AbsoluteSeconds};
    $Counters{WorkingMinutes} = floor($Counters{WorkingMinutes}) if $Counters{WorkingMinutes};

    # Readable Time
    $Counters{ReadableTime} = (floor($DeltaObj->{AbsoluteSeconds}/3600))."h ".
                    (sprintf("%02d",($DeltaObj->{AbsoluteSeconds}%3600)/60))."m" if $DeltaObj->{AbsoluteSeconds};

    # Readable Working Time
    $Counters{WorkingReadableTime} = (floor(($DeltaWorkingObj->{AbsoluteSeconds} - $StoppedSeconds)/3600))."h ".
                    (sprintf("%02d",(($DeltaWorkingObj->{AbsoluteSeconds} - $StoppedSeconds)%3600)/60))."m" if $DeltaWorkingObj->{AbsoluteSeconds};

    # Dias Corridos
    # - Temos que calcular dividindo pelo número de segundos, já que a cada 7 dias ele 
    #   reinicia o contador e incrementa o contador de semanas
    $Counters{Days} = floor($DeltaObj->{AbsoluteSeconds}/86400) if $DeltaObj->{AbsoluteSeconds};

    # Dias Úteis
    if($Parameters{WorkingDaysDF}){
        my $MaxWorkingDays = $Parameters{MaxWorkingDays} || 365;
        my $WDTimeObj = $StartTimeObj->Clone();

        # Find the next working hour to start count
        my $WDTestObj = $WDTimeObj->Clone();
        $WDTestObj->Add(
            Seconds       => 1,
            AsWorkingTime => 1,
            Calendar      => $Calendar,
        );
        my $TestDelta = $WDTimeObj->Delta( 
            DateTimeObject => $WDTestObj,
            ForWorkingTime => 0,
        );
        if($TestDelta->{AbsoluteSeconds}>1){
            # Not an workin hour. Take WDTestObj as the new time (and subtract 1 second that was added)
            $WDTimeObj = $WDTestObj->Clone();
            $WDTimeObj->Subtract(
                Seconds       => 1,
                AsWorkingTime => 0,
            );
        }

        DAY:
        while(1){
            last if $Counters{WorkingDays}>$MaxWorkingDays;
            if($EndTimeObj->Compare(DateTimeObject => $WDTimeObj)<1){
                            last;
            }

            # Check if this is a working day
            my $WDTimeObjStart = $WDTimeObj->Clone();
            $WDTimeObjStart->Set(Hour => 0, Minute => 0, Second => 0);

            my $WDTimeObjEnd = $WDTimeObj->Clone();
            $WDTimeObjEnd->Set(Hour => 23, Minute => 59, Second => 59);

            my $WorkingDelta = $WDTimeObjStart->Delta(
                DateTimeObject => $WDTimeObjEnd,
                ForWorkingTime => 1,
                Calendar => $Calendar,
            );

            if($WorkingDelta->{AbsoluteSeconds} == 0){
                $WDTimeObj->Add(
                    Days          => 1,
                    AsWorkingTime => 0,
                );
                next DAY;
            }

            my $Delta = $WDTimeObj->Delta( 
                DateTimeObject => $EndTimeObj,
                ForWorkingTime => 0,
            );

            if($Delta->{AbsoluteSeconds}>=86460){
                $Counters{WorkingDays}++;
            }

            $WDTimeObj->Add(
                Days          => 1,
                AsWorkingTime => 0,
            );

        }
    }
    # #Armazena no campo dinamico se necessario
    for my $DynamicFieldName ( qw(Days WorkingDays Minutes WorkingMinutes ReadableTime WorkingReadableTime)){
        if ($Parameters{$DynamicFieldName."DF"}) {
            my $DynamicField = $Self->{DynamicFieldObject}->DynamicFieldGet(
                Name => $Parameters{$DynamicFieldName."DF"},
            );
            
            # Use Dynamic Field Value instead of backend to avoid
            # lots of unecessary Ticket History lines
            my $Success = $DynamicFieldValueObject->ValueSet(
                FieldID => $DynamicField->{ID},
                ObjectID => $Param{TicketID},
                Value => [
                    {
                        ValueText => $Counters{$DynamicFieldName}||0
                    }
                ],
                UserID => 1
            );

            my $OldValue=$Ticket{"DynamicField_".$DynamicField->{Name}};
            my $NewValue=$Counters{$DynamicFieldName}||0;
            if($NewValue ne $OldValue) {
                $TicketObject->EventHandler(
                    Event => 'TicketDynamicFieldUpdate_' . $DynamicField->{Name},
                    Data  => {
                        FieldName => $DynamicField->{Name},
                        Value     => $NewValue,
                        OldValue  => $OldValue,
                        TicketID  => $Param{TicketID},
                        UserID    => 1,
                    },
                    UserID => 1,
                );
            }
        }
    };

    my $Success=1;

    return $Success;
}

1;