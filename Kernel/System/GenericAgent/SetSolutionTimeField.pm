package Kernel::System::GenericAgent::SetSolutionTimeField;

use strict;
use warnings;

use Kernel::System::DynamicField;
use Kernel::System::DynamicField::Backend;

#use Kernel::System::Priority;

our @ObjectDependencies = (
    'Kernel::System::Log',
    'Kernel::System::DynamicField',
    'Kernel::System::DynamicFieldBackend',
    'Kernel::System::Ticket',
    'Kernel::System::Time',
);


sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # 0=off; 1=on;
    $Self->{Debug} = $Param{Debug} || 0;

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;
    
    #Create system objects that will be used above
    my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');
    my $UserObject = $Kernel::OM->Get('Kernel::System::User');
    my $DynamicFieldBackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');
    my $DynamicFieldValueObject = $Kernel::OM->Get('Kernel::System::DynamicFieldValue');
    my $TimeObject = $Kernel::OM->Get('Kernel::System::Time');
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

    # get ticket data
    my %Ticket = $TicketObject->TicketGet(
        %Param,
        DynamicFields => 0,
        Extended => 1,
    );

    #Get Dynamic Field Configuration to SolutionTime
    #this dynamic field is used to receive the total time
    #spend to resolve a ticket or the total time passed from
    #the maximum time permited to do that
    my $DynamicField = $DynamicFieldObject->DynamicFieldGet(
       Name => 'SolutionTime'
    );

    #Get Dynamic Field Configuration to ResponseTime
    #this dynamic field is used to receive the first response time
    #spend to resolve a ticket or the total time passed from
    #the maximum time permited to do that
    my $DynamicFieldDeltaResponseTime = $DynamicFieldObject->DynamicFieldGet(
       Name => 'DeltaResponseTime'
    );

    #Get Dynamic Field Configuration to IsSolutionTimeSLAStoppedCalculated
    #This dynamic field was created to control the calculation when the
    #ticket is SLA Paused
    my $DynamicFieldIsCalc = $DynamicFieldObject->DynamicFieldGet(
       Name => 'IsSolutionTimeSLAStoppedCalculated'
    );

    #Get Dynamic Field Configuration to TotalTime
    #this dynamic field is used to receive the total time worked on the
    #ticket in minutes of work time.
    my $DynamicFieldTotalTime = $DynamicFieldObject->DynamicFieldGet(
       Name => 'TotalTime'
    );

    #Get Dynamic Field Configuration to TotalResponseTime
    #this dynamic field is used to receive the total time worked on the
    #ticket in minutes of work time.
    my $DynamicFieldTotalResponseTime = $DynamicFieldObject->DynamicFieldGet(
       Name => 'TotalResponseTime'
    );

    #Get Dynamic Field Configuration to PercentualScaleSLA
    #this dynamic field is a Dropbox field. It contains severals options of
    #percentual range of total time to resolve a ticket in relation of expected
    #time to do this defined into the SLA configuration.
    my $DynamicFieldPercentualScaleSLA = $DynamicFieldObject->DynamicFieldGet(
		Name => "PercentualScaleSLA",
	);

    #Get Dynamic Field Configuration to PercentualScaleResponseTime
    #this dynamic field is a Dropbox field. It contains severals options of
    #percentual range of total time to resolve a ticket in relation of expected
    #time to do this defined into the SLA configuration.
    my $DynamicFieldPercentualScaleResponseTime = $DynamicFieldObject->DynamicFieldGet(
		Name => "PercentualScaleResponseTime",
	);

    my $Success;
    
    #This generic agent will be executed when the ticket has a SLA configurated
	if(defined $Ticket{SLA}){
		
		#Verify if the ticket is closed
        if($Ticket{StateType} eq 'closed'){
            #Get the time that the ticket was paused by SLA
            my $PendSumTime = $TicketObject->GetTotalNonEscalationRelevantBusinessTime(
                TicketID => $Ticket{TicketID},
            )||0;

            #Get the data of Ticket Escalation 
            my %Escalation = $TicketObject->TicketEscalationPreferences(
                Ticket => \%Ticket,
                UserID => 1,
            );

            #When the ticket is closed the SolutionTime value is got from
            #SolutionDiffInMin Extend Field from Ticket object.
            #$Success = $DynamicFieldBackendObject->ValueSet(
            #    DynamicFieldConfig  => $DynamicField,
            #    ObjectID => $Ticket{TicketID},
            #    Value    => $Ticket{SolutionDiffInMin}||0,
            #    UserID   => 1,
            #);

            $Success = $DynamicFieldValueObject->ValueSet(
                FieldID => $DynamicField->{ID},
                ObjectID => $Param{TicketID},
                Value => [
                    {
                        ValueText => $Ticket{SolutionDiffInMin}||0
                    }
                ],
                UserID => 1
            );
            $TicketObject->EventHandler(
                Event => 'TicketDynamicFieldUpdate_' . $DynamicField->{Name},
                Data  => {
                    FieldName => $DynamicField->{Name},
                    Value     => $Ticket{SolutionDiffInMin}||0,
                    OldValue  => "",
                    TicketID  => $Param{TicketID},
                    UserID    => 1,
                },
                UserID => 1,
            );

            #When the ticket is closed the ResponseTime value is got from
            #SolutionDiffInMin Extend Field from Ticket object.
            #$Success = $DynamicFieldBackendObject->ValueSet(
            #    DynamicFieldConfig  => $DynamicFieldTotalResponseTime,
            #    ObjectID => $Ticket{TicketID},
            #    Value    => $Ticket{FirstResponseInMin}||0,
            #    UserID   => 1,
            #);
            $Success = $DynamicFieldValueObject->ValueSet(
                FieldID => $DynamicFieldTotalResponseTime->{ID},
                ObjectID => $Param{TicketID},
                Value => [
                    {
                        ValueText => $Ticket{FirstResponseInMin}||0
                    }
                ],
                UserID => 1
            );
            $TicketObject->EventHandler(
                Event => 'TicketDynamicFieldUpdate_' . $DynamicFieldTotalResponseTime->{Name},
                Data  => {
                    FieldName => $DynamicFieldTotalResponseTime->{Name},
                    Value     => $Ticket{FirstResponseInMin}||0,
                    OldValue  => "",
                    TicketID  => $Param{TicketID},
                    UserID    => 1,
                },
                UserID => 1,
            );

            #When the ticket is closed the ResponseTime value is got from
            #SolutionDiffInMin Extend Field from Ticket object.
            #$Success = $DynamicFieldBackendObject->ValueSet(
            #    DynamicFieldConfig  => $DynamicFieldDeltaResponseTime,
            #    ObjectID => $Ticket{TicketID},
            #    Value    => $Ticket{FirstResponseDiffInMin}||0,
            #    UserID   => 1,
            #);
            $Success = $DynamicFieldValueObject->ValueSet(
                FieldID => $DynamicFieldDeltaResponseTime->{ID},
                ObjectID => $Param{TicketID},
                Value => [
                    {
                        ValueText => $Ticket{FirstResponseDiffInMin}||0
                    }
                ],
                UserID => 1
            );
            $TicketObject->EventHandler(
                Event => 'TicketDynamicFieldUpdate_' . $DynamicFieldDeltaResponseTime->{Name},
                Data  => {
                    FieldName => $DynamicFieldDeltaResponseTime->{Name},
                    Value     => $Ticket{FirstResponseDiffInMin}||0,
                    OldValue  => "",
                    TicketID  => $Param{TicketID},
                    UserID    => 1,
                },
                UserID => 1,
            );

            #When the ticket is closed the TotalTime value is got from
            #SolutionInMin Extend Field from Ticket object subtracting the ticket stopped time
            #$Success = $DynamicFieldBackendObject->ValueSet(
            #    DynamicFieldConfig  => $DynamicFieldTotalTime,
            #    ObjectID => $Ticket{TicketID},
            #    Value    => ($Escalation{SolutionTime}||0)-($Ticket{SolutionDiffInMin}||0),
            #    UserID   => 1,
            #);
            my $WorkingTime = ($Escalation{SolutionTime}||0)-($Ticket{SolutionDiffInMin}||0);
            $WorkingTime = $WorkingTime * 60;
            $WorkingTime = $WorkingTime -$PendSumTime;
            $WorkingTime = $WorkingTime / 60;
            $Success = $DynamicFieldValueObject->ValueSet(
                FieldID => $DynamicFieldTotalTime->{ID},
                ObjectID => $Param{TicketID},
                Value => [
                    {
                        ValueText => $WorkingTime
                    }
                ],
                UserID => 1
            );
            $TicketObject->EventHandler(
                Event => 'TicketDynamicFieldUpdate_' . $DynamicFieldTotalTime->{Name},
                Data  => {
                    FieldName => $DynamicFieldTotalTime->{Name},
                    Value     => $WorkingTime,
                    OldValue  => "",
                    TicketID  => $Param{TicketID},
                    UserID    => 1,
                },
                UserID => 1,
            );

            #Calcule the percentual of time spended to resolve the ticket in relationship
            #with the time defined in SLA configuration
            my $percent = 0;
            if($Escalation{SolutionTime} != 0){
                $percent = ($WorkingTime * 100) / $Escalation{SolutionTime};

                $Success = $DynamicFieldValueObject->ValueSet(
                    FieldID => $DynamicFieldPercentualScaleSLA->{ID},
                    ObjectID => $Param{TicketID},
                    Value => [
                        {
                            ValueText => $Self->ConvertPercentualSLAScale(Value=>$percent)
                        }
                    ],
                    UserID => 1
                );
                

            } else {
              $Success = $DynamicFieldValueObject->ValueDelete(
                  FieldID => $DynamicFieldPercentualScaleSLA->{ID},
                  ObjectID => $Param{TicketID},
                  UserID             => 1,
              );
            }

            $TicketObject->EventHandler(
                Event => 'TicketDynamicFieldUpdate_' . $DynamicFieldPercentualScaleSLA->{Name},
                Data  => {
                    FieldName => $DynamicFieldPercentualScaleSLA->{Name},
                    Value     => $Self->ConvertPercentualSLAScale(Value=>$percent),
                    OldValue  => "",
                    TicketID  => $Param{TicketID},
                    UserID    => 1,
                },
                UserID => 1,
            );
            

            #Calcule the percentual of time spended to resolve the ticket in relationship
            #with the time defined in SLA configuration
            my $percentResponseTime = 0;
            if((($Ticket{FirstResponseInMin}||0)+($Ticket{FirstResponseDiffInMin}||0)) > 0 && $Escalation{FirstResponseTime} != 0){
                $percentResponseTime = ($Ticket{FirstResponseInMin} * 100) / ($Ticket{FirstResponseInMin}+$Ticket{FirstResponseDiffInMin});
                $Success = $DynamicFieldValueObject->ValueSet(
                    FieldID => $DynamicFieldPercentualScaleResponseTime->{ID},
                    ObjectID => $Param{TicketID},
                    Value => [
                        {
                            ValueText => $Self->ConvertPercentualResponseTimeScale(Value=>$percentResponseTime)
                        }
                    ],
                    UserID => 1
                );
            }
            else {
              $Success = $DynamicFieldValueObject->ValueDelete(
                  FieldID => $DynamicFieldPercentualScaleResponseTime->{ID},
                  ObjectID => $Param{TicketID},
                  UserID             => 1,
              );
            }
            
            $TicketObject->EventHandler(
                Event => 'TicketDynamicFieldUpdate_' . $DynamicFieldPercentualScaleResponseTime->{Name},
                Data  => {
                    FieldName => $DynamicFieldPercentualScaleResponseTime->{Name},
                    Value     => $Self->ConvertPercentualResponseTimeScale(Value=>$percentResponseTime),
                    OldValue  => "",
                    TicketID  => $Param{TicketID},
                    UserID    => 1,
                },
                UserID => 1,
            );
        }
        else{
            #If the ticket is open yet verify if it is in SLA stop
            my $notIsSLAStopped = ($TimeObject->TimeStamp2SystemTime(
                String => $Ticket{SolutionTimeDestinationDate},
            ) != 1767139200);

            #Get the time that the ticket was paused by SLA
            my $PendSumTime = $TicketObject->GetTotalNonEscalationRelevantBusinessTime(
                TicketID => $Ticket{TicketID},
            )||0;

            #Rules for no SLA Stopped Tickets
            if($notIsSLAStopped){
                #When the ticket is open and no SLA Stopped get the solution time from
                #SolutionTimeWorkingTime Field
                #my $Success = $DynamicFieldBackendObject->ValueSet(
                #    DynamicFieldConfig  => $DynamicField,
                #    ObjectID => $Ticket{TicketID},
                #    Value    => int($Ticket{SolutionTimeWorkingTime}/60),
                #    UserID   => 1,
                #);
                $Success = $DynamicFieldValueObject->ValueSet(
                    FieldID => $DynamicField->{ID},
                    ObjectID => $Param{TicketID},
                    Value => [
                        {
                            ValueText => int($Ticket{SolutionTimeWorkingTime}/60)
                        }
                    ],
                    UserID => 1
                );
                $TicketObject->EventHandler(
                    Event => 'TicketDynamicFieldUpdate_' . $DynamicField->{Name},
                    Data  => {
                        FieldName => $DynamicField->{Name},
                        Value     => int($Ticket{SolutionTimeWorkingTime}/60),
                        OldValue  => "",
                        TicketID  => $Param{TicketID},
                        UserID    => 1,
                    },
                    UserID => 1,
                );

                #When the ticket is open and no SLA Stopped get the solution time from
                #FirstResponseTimeWorkingTime Field
                #my $Success = $DynamicFieldBackendObject->ValueSet(
                #    DynamicFieldConfig  => $DynamicFieldTotalResponseTime,
                #    ObjectID => $Ticket{TicketID},
                #    Value    => $Ticket{FirstResponseInMin}||0,
                #    UserID   => 1,
                #);
                $Success = $DynamicFieldValueObject->ValueSet(
                    FieldID => $DynamicFieldTotalResponseTime->{ID},
                    ObjectID => $Param{TicketID},
                    Value => [
                        {
                            ValueText => $Ticket{FirstResponseInMin}||0
                        }
                    ],
                    UserID => 1
                );
                $TicketObject->EventHandler(
                    Event => 'TicketDynamicFieldUpdate_' . $DynamicFieldTotalResponseTime->{Name},
                    Data  => {
                        FieldName => $DynamicFieldTotalResponseTime->{Name},
                        Value     => $Ticket{FirstResponseInMin}||0,
                        OldValue  => "",
                        TicketID  => $Param{TicketID},
                        UserID    => 1,
                    },
                    UserID => 1,
                );

                #When the ticket is closed the ResponseTime value is got from
                #SolutionDiffInMin Extend Field from Ticket object.
                #my $Success = $DynamicFieldBackendObject->ValueSet(
                #    DynamicFieldConfig  => $DynamicFieldDeltaResponseTime,
                #    ObjectID => $Ticket{TicketID},
                #    Value    => $Ticket{FirstResponseDiffInMin}||0,
                #    UserID   => 1,
                #);
                $Success = $DynamicFieldValueObject->ValueSet(
                    FieldID => $DynamicFieldDeltaResponseTime->{ID},
                    ObjectID => $Param{TicketID},
                    Value => [
                        {
                            ValueText => $Ticket{FirstResponseDiffInMin}||0
                        }
                    ],
                    UserID => 1
                );
                $TicketObject->EventHandler(
                    Event => 'TicketDynamicFieldUpdate_' . $DynamicFieldDeltaResponseTime->{Name},
                    Data  => {
                        FieldName => $DynamicFieldDeltaResponseTime->{Name},
                        Value     => $Ticket{FirstResponseDiffInMin}||0,
                        OldValue  => "",
                        TicketID  => $Param{TicketID},
                        UserID    => 1,
                    },
                    UserID => 1,
                );

                #Get the data of Ticket Escalation 
                my %Escalation = $TicketObject->TicketEscalationPreferences(
                    Ticket => \%Ticket,
                    UserID => 1,
                );

                #When the ticket is open and no SLA Stopped the Total WorkingTime 
                #is calculated with the Ticket Creation Date and the Actual Date
                #subtracting the Stopped Time.
                my $WorkingTime = $TimeObject->WorkingTime(
                    StartTime => $TimeObject->TimeStamp2SystemTime(
                        String => $Ticket{Created},
                    ),
                    StopTime  => $TimeObject->SystemTime(),
                    Calendar  => $Escalation{Calendar},
                )-$PendSumTime;

                #$DynamicFieldBackendObject->ValueSet(
                #    DynamicFieldConfig  => $DynamicFieldTotalTime,
                #    ObjectID => $Ticket{TicketID},
                #    Value    => int($WorkingTime/60),
                #    UserID   => 1,
                #);
                $Success = $DynamicFieldValueObject->ValueSet(
                    FieldID => $DynamicFieldTotalTime->{ID},
                    ObjectID => $Param{TicketID},
                    Value => [
                        {
                            ValueText => int($WorkingTime/60)
                        }
                    ],
                    UserID => 1
                );
                $TicketObject->EventHandler(
                    Event => 'TicketDynamicFieldUpdate_' . $DynamicFieldTotalTime->{Name},
                    Data  => {
                        FieldName => $DynamicFieldTotalTime->{Name},
                        Value     => int($WorkingTime/60),
                        OldValue  => "",
                        TicketID  => $Param{TicketID},
                        UserID    => 1,
                    },
                    UserID => 1,
                );

                #Calcule the percentual of time spended to resolve the ticket in relationship
                #with the time defined in SLA configuration
                my $percent = 0;
                if($Escalation{SolutionTime} != 0){
                    $percent = (($WorkingTime/60) * 100) / $Escalation{SolutionTime};

                    $Success = $DynamicFieldValueObject->ValueSet(
                        FieldID => $DynamicFieldPercentualScaleSLA->{ID},
                        ObjectID => $Param{TicketID},
                        Value => [
                            {
                                ValueText => $Self->ConvertPercentualSLAScale(Value=>$percent)
                            }
                        ],
                        UserID => 1
                    );

                } else {
                  $Success = $DynamicFieldValueObject->ValueDelete(
                      FieldID => $DynamicFieldPercentualScaleSLA->{ID},
                      ObjectID => $Param{TicketID},
                      UserID             => 1,
                  );
                }
                
                $TicketObject->EventHandler(
                    Event => 'TicketDynamicFieldUpdate_' . $DynamicFieldPercentualScaleSLA->{Name},
                    Data  => {
                        FieldName => $DynamicFieldPercentualScaleSLA->{Name},
                        Value     => $Self->ConvertPercentualSLAScale(Value=>$percent),
                        OldValue  => "",
                        TicketID  => $Param{TicketID},
                        UserID    => 1,
                    },
                    UserID => 1,
                );

                #Calcule the percentual of time spended to resolve the ticket in relationship
                #with the time defined in SLA configuration
                my $percentResponseTime = 0;
                if(( ($Ticket{FirstResponseInMin}+$Ticket{FirstResponseDiffInMin}) > 0 || $WorkingTime > 0) && $Escalation{FirstResponseTime} != 0){

                    if($Ticket{FirstResponseInMin} == 0){
                      $percentResponseTime = ($WorkingTime * 100) / $Escalation{FirstResponseTime};
                    }
                    else {
                      $percentResponseTime = ($Ticket{FirstResponseInMin} * 100) / ($Ticket{FirstResponseInMin}+$Ticket{FirstResponseDiffInMin});
                    }
                    

                    $Success = $DynamicFieldValueObject->ValueSet(
                        FieldID => $DynamicFieldPercentualScaleResponseTime->{ID},
                        ObjectID => $Param{TicketID},
                        Value => [
                            {
                                ValueText => $Self->ConvertPercentualResponseTimeScale(Value=>$percentResponseTime)
                            }
                        ],
                        UserID => 1
                    );

                } else {
                  $Success = $DynamicFieldValueObject->ValueDelete(
                      FieldID => $DynamicFieldPercentualScaleResponseTime->{ID},
                      ObjectID => $Param{TicketID},
                      UserID             => 1,
                  );
                }
                $TicketObject->EventHandler(
                    Event => 'TicketDynamicFieldUpdate_' . $DynamicFieldPercentualScaleResponseTime->{Name},
                    Data  => {
                        FieldName => $DynamicFieldPercentualScaleResponseTime->{Name},
                        Value     => $Self->ConvertPercentualResponseTimeScale(Value=>$percentResponseTime),
                        OldValue  => "",
                        TicketID  => $Param{TicketID},
                        UserID    => 1,
                    },
                    UserID => 1,
                );

                #When the ticket is oppened and no SLA Stopped, update the IsSolutionTimeSLAStoppedCalculated
                #dynamic field to false (0)
                #$DynamicFieldBackendObject->ValueSet(
                #    DynamicFieldConfig  => $DynamicFieldIsCalc,
                #    ObjectID => $Ticket{TicketID},
                #    Value    => 0,
                #    UserID   => 1,
                #);
                $Success = $DynamicFieldValueObject->ValueSet(
                    FieldID => $DynamicFieldIsCalc->{ID},
                    ObjectID => $Param{TicketID},
                    Value => [
                        {
                            ValueText => 0
                        }
                    ],
                    UserID => 1
                );
                $TicketObject->EventHandler(
                    Event => 'TicketDynamicFieldUpdate_' . $DynamicFieldIsCalc->{Name},
                    Data  => {
                        FieldName => $DynamicFieldIsCalc->{Name},
                        Value     => 0,
                        OldValue  => "",
                        TicketID  => $Param{TicketID},
                        UserID    => 1,
                    },
                    UserID => 1,
                );
            }
            else{
                #Whe the ticket is open and SLA Stopped verify IsSolutionTimeSLAStoppedCalculated
                #dynamic field
                my $ValueIsCalc = $DynamicFieldValueObject->ValueGet(
                    FieldID            => $DynamicFieldIsCalc->{ID},
                    ObjectID           => $Ticket{TicketID},               
                );

                my $isCalculated = 0;

                if(defined $ValueIsCalc->[0]->{ValueInt}){
                    $isCalculated = $ValueIsCalc->[0]->{ValueInt};
                }

                #if IsSolutionTimeSLAStoppedCalculated dynamic field is false (0)
                #make the calculations
                if($isCalculated == 0){

                    #Get the data of Ticket Escalation 
                    my %Escalation = $TicketObject->TicketEscalationPreferences(
                        Ticket => \%Ticket,
                        UserID => 1,
                    );

                    #When the ticket is SLA Stopped is necessary to calculate the last
                    #destination time value to make the next values
                    my $DestinationTime = $TimeObject->DestinationTime(
                        StartTime => $TimeObject->TimeStamp2SystemTime(
                            String => $Ticket{Created},
                        ),
                        # 
                        # Time     => $Escalation{SolutionTime} * 60,
                        Time     => $Escalation{SolutionTime} * 60 + $PendSumTime,
                        # 
                        Calendar => $Escalation{Calendar},
                    );

                    #if the last destination time valid is bigger than the actual date
                    #the solution time is from actual date to last destination date
                    my $SolutionTime = 0;
                    if($TimeObject->SystemTime() < $DestinationTime){
                        $SolutionTime = $TimeObject->WorkingTime(
                            StartTime => $TimeObject->SystemTime(),
                            StopTime  => $DestinationTime,
                            Calendar  => $Escalation{Calendar},
                        );
                    }
                    else{
                        #if the last destination time valid is smaller than the actual date
                        #the solution time is from last destination date to actual date
                        $SolutionTime = $TimeObject->WorkingTime(
                            StartTime => $DestinationTime,
                            StopTime  => $TimeObject->SystemTime(),
                            Calendar  => $Escalation{Calendar},
                        )*-1;
                    }

                    #my $Success = $DynamicFieldBackendObject->ValueSet(
                    #    DynamicFieldConfig  => $DynamicField,
                    #    ObjectID => $Ticket{TicketID},
                    #    Value    => int($SolutionTime/60),
                    #    UserID   => 1,
                    #);
                    $Success = $DynamicFieldValueObject->ValueSet(
                        FieldID => $DynamicField->{ID},
                        ObjectID => $Param{TicketID},
                        Value => [
                            {
                                ValueText => int($SolutionTime/60)
                            }
                        ],
                        UserID => 1
                    );
                    $TicketObject->EventHandler(
                        Event => 'TicketDynamicFieldUpdate_' . $DynamicField->{Name},
                        Data  => {
                            FieldName => $DynamicField->{Name},
                            Value     => int($SolutionTime/60),
                            OldValue  => "",
                            TicketID  => $Param{TicketID},
                            UserID    => 1,
                        },
                        UserID => 1,
                    );

                    #my $Success = $DynamicFieldBackendObject->ValueSet(
                    #    DynamicFieldConfig  => $DynamicFieldTotalResponseTime,
                    #    ObjectID => $Ticket{TicketID},
                    #    Value    => $Ticket{FirstResponseInMin}||0,
                    #    UserID   => 1,
                    #);
                    $Success = $DynamicFieldValueObject->ValueSet(
                        FieldID => $DynamicFieldTotalResponseTime->{ID},
                        ObjectID => $Param{TicketID},
                        Value => [
                            {
                                ValueText => $Ticket{FirstResponseInMin}||0
                            }
                        ],
                        UserID => 1
                    );
                    $TicketObject->EventHandler(
                        Event => 'TicketDynamicFieldUpdate_' . $DynamicFieldTotalResponseTime->{Name},
                        Data  => {
                            FieldName => $DynamicFieldTotalResponseTime->{Name},
                            Value     => $Ticket{FirstResponseInMin}||0,
                            OldValue  => "",
                            TicketID  => $Param{TicketID},
                            UserID    => 1,
                        },
                        UserID => 1,
                    );

                    #When the ticket is closed the ResponseTime value is got from
                    #SolutionDiffInMin Extend Field from Ticket object.
                    #my $Success = $DynamicFieldBackendObject->ValueSet(
                    #    DynamicFieldConfig  => $DynamicFieldDeltaResponseTime,
                    #    ObjectID => $Ticket{TicketID},
                    #    Value    => $Ticket{FirstResponseDiffInMin}||0,
                    #    UserID   => 1,
                    #);
                    $Success = $DynamicFieldValueObject->ValueSet(
                        FieldID => $DynamicFieldDeltaResponseTime->{ID},
                        ObjectID => $Param{TicketID},
                        Value => [
                            {
                                ValueText => $Ticket{FirstResponseDiffInMin}||0
                            }
                        ],
                        UserID => 1
                    );
                    $TicketObject->EventHandler(
                        Event => 'TicketDynamicFieldUpdate_' . $DynamicFieldDeltaResponseTime->{Name},
                        Data  => {
                            FieldName => $DynamicFieldDeltaResponseTime->{Name},
                            Value     => $Ticket{FirstResponseDiffInMin}||0,
                            OldValue  => "",
                            TicketID  => $Param{TicketID},
                            UserID    => 1,
                        },
                        UserID => 1,
                    );

                    #When the ticket is SLA Stopped the Total WorkingTime 
                    #is calculated with the Ticket Creation Date and the Actual Date
                    #subtracting the Stopped Time.
                    my $WorkingTime = $TimeObject->WorkingTime(
                        StartTime => $TimeObject->TimeStamp2SystemTime(
                            String => $Ticket{Created},
                        ),
                        StopTime  => $TimeObject->SystemTime(),
                        Calendar  => $Escalation{Calendar},
                    )-$PendSumTime;

                    #$DynamicFieldBackendObject->ValueSet(
                    #    DynamicFieldConfig  => $DynamicFieldTotalTime,
                    #    ObjectID => $Ticket{TicketID},
                    #    Value    => int($WorkingTime/60),
                    #    UserID   => 1,
                    #);
                    $Success = $DynamicFieldValueObject->ValueSet(
                        FieldID => $DynamicFieldTotalTime->{ID},
                        ObjectID => $Param{TicketID},
                        Value => [
                            {
                                ValueText => int($WorkingTime/60)
                            }
                        ],
                        UserID => 1
                    );
                    $TicketObject->EventHandler(
                        Event => 'TicketDynamicFieldUpdate_' . $DynamicFieldTotalTime->{Name},
                        Data  => {
                            FieldName => $DynamicFieldTotalTime->{Name},
                            Value     => int($WorkingTime/60),
                            OldValue  => "",
                            TicketID  => $Param{TicketID},
                            UserID    => 1,
                        },
                        UserID => 1,
                    );

                    #Calcule the percentual of time spended to resolve the ticket in relationship
                    #with the time defined in SLA configuration
                    my $percent = 0;
                    if($Escalation{SolutionTime} != 0){
                        $percent = (($WorkingTime/60) * 100) / $Escalation{SolutionTime};

                        $Success = $DynamicFieldValueObject->ValueSet(
                            FieldID => $DynamicFieldPercentualScaleSLA->{ID},
                            ObjectID => $Param{TicketID},
                            Value => [
                                {
                                    ValueText => $Self->ConvertPercentualSLAScale(Value=>$percent)
                                }
                            ],
                            UserID => 1
                        );

                    } else {

                        $Success = $DynamicFieldValueObject->ValueDelete(
                            FieldID => $DynamicFieldPercentualScaleSLA->{ID},
                            ObjectID => $Param{TicketID},
                            UserID             => 1,
                        );

                    }

                    $TicketObject->EventHandler(
                        Event => 'TicketDynamicFieldUpdate_' . $DynamicFieldPercentualScaleSLA->{Name},
                        Data  => {
                            FieldName => $DynamicFieldPercentualScaleSLA->{Name},
                            Value     => $Self->ConvertPercentualSLAScale(Value=>$percent),
                            OldValue  => "",
                            TicketID  => $Param{TicketID},
                            UserID    => 1,
                        },
                        UserID => 1,
                    );

                    #Calcule the percentual of time spended to resolve the ticket in relationship
                    #with the time defined in SLA configuration
                    my $percentResponseTime = 0;
                    if(( ($Ticket{FirstResponseInMin}+$Ticket{FirstResponseDiffInMin}) > 0 || $WorkingTime > 0) && $Escalation{FirstResponseTime} != 0){

                        if($Ticket{FirstResponseInMin} == 0){
                          $percentResponseTime = ($WorkingTime * 100) / $Escalation{FirstResponseTime};
                        }
                        else {
                          $percentResponseTime = ($Ticket{FirstResponseInMin} * 100) / ($Ticket{FirstResponseInMin}+$Ticket{FirstResponseDiffInMin});
                        }

                        $Success = $DynamicFieldValueObject->ValueSet(
                            FieldID => $DynamicFieldPercentualScaleResponseTime->{ID},
                            ObjectID => $Param{TicketID},
                            Value => [
                                {
                                    ValueText => $Self->ConvertPercentualResponseTimeScale(Value=>$percentResponseTime)
                                }
                            ],
                            UserID => 1
                        );

                    } else {

                        $Success = $DynamicFieldValueObject->ValueDelete(
                            FieldID => $DynamicFieldPercentualScaleResponseTime->{ID},
                            ObjectID => $Param{TicketID},
                            UserID             => 1,
                        );

                    }

                    #Select the combo box PercentualScaleResponseTime value in relationship with
                    #percentual
                    #$Success = $DynamicFieldBackendObject->ValueSet(
                    #    DynamicFieldConfig  => $DynamicFieldPercentualScaleResponseTime,
                    #    ObjectID => $Ticket{TicketID},
                    #    Value    => $Self->ConvertPercentualResponseTimeScale(Value=>$percentResponseTime),
                    #    UserID   => 1,
                    #);
                    
                    $TicketObject->EventHandler(
                        Event => 'TicketDynamicFieldUpdate_' . $DynamicFieldPercentualScaleResponseTime->{Name},
                        Data  => {
                            FieldName => $DynamicFieldPercentualScaleResponseTime->{Name},
                            Value     => $Self->ConvertPercentualResponseTimeScale(Value=>$percentResponseTime),
                            OldValue  => "",
                            TicketID  => $Param{TicketID},
                            UserID    => 1,
                        },
                        UserID => 1,
                    );

                    #When the ticket is SLA Stopped, update the IsSolutionTimeSLAStoppedCalculated
                    #dynamic field to true (1). This ensures that this calcule will be made just one
                    #time while this ticket is stopped 
                    #$DynamicFieldBackendObject->ValueSet(
                    #    DynamicFieldConfig  => $DynamicFieldIsCalc,
                    #    ObjectID => $Ticket{TicketID},
                    #    Value    => 1,
                    #    UserID   => 1,
                    #);
                    $Success = $DynamicFieldValueObject->ValueSet(
                        FieldID => $DynamicFieldIsCalc->{ID},
                        ObjectID => $Param{TicketID},
                        Value => [
                            {
                                ValueText => 1
                            }
                        ],
                        UserID => 1
                    );
                    $TicketObject->EventHandler(
                        Event => 'TicketDynamicFieldUpdate_' . $DynamicFieldIsCalc->{Name},
                        Data  => {
                            FieldName => $DynamicFieldIsCalc->{Name},
                            Value     => 1,
                            OldValue  => "",
                            TicketID  => $Param{TicketID},
                            UserID    => 1,
                        },
                        UserID => 1,
                    );
                }
            }
        }
	}
	
}

#This function convert one percentual to any scale configured in the dynamic field PercentualScaleSLA
#The rules are: 
#   * if the option have "-" signal the system will consider that the value have an init and an end and
#the value will be major or equal and minor.
#   * if the option have ">" signal the system will consider that the value have to be major of it;
#   * if the option have "<" signal the system will consider that the value have to be minor of it;
#   * if none of values will be found the function will return empty string;
sub ConvertPercentualSLAScale{
    my ( $Self, %Param ) = @_;

    my $DynamicFieldBackendObject  = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');
    my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');

    my $DynamicFieldPercentualScaleSLA = $DynamicFieldObject->DynamicFieldGet(
		Name => "PercentualScaleSLA",
	);

    my $PossibleValues = $DynamicFieldBackendObject->PossibleValuesGet(
       DynamicFieldConfig => $DynamicFieldPercentualScaleSLA,
    );

    foreach my $key (keys %{$PossibleValues}){
        my $indexOf = index($key,'-');
        if($indexOf > -1){
            my $min = substr $key, 0, $indexOf;
            my $max = substr $key, $indexOf+1;

            if($Param{Value} >= $min && $Param{Value} < $max){
                return $key;
            }
        }
        $indexOf = index($key,'>');
        if($indexOf > -1){
            my $number = substr $key, $indexOf+1;
            if($Param{Value} > $number){
                return $key;
            }
        }
        $indexOf = index($key,'<');
        if($indexOf > -1){
            my $number = substr $key, $indexOf+1;
            if($Param{Value} < $number){
                return $key;
            }
        }
    }
    
    return "";
}

#This function convert one percentual to any scale configured in the dynamic field PercentualScaleResponseTime
#The rules are: 
#   * if the option have "-" signal the system will consider that the value have an init and an end and
#the value will be major or equal and minor.
#   * if the option have ">" signal the system will consider that the value have to be major of it;
#   * if the option have "<" signal the system will consider that the value have to be minor of it;
#   * if none of values will be found the function will return empty string;
sub ConvertPercentualResponseTimeScale{
    my ( $Self, %Param ) = @_;

    my $DynamicFieldBackendObject  = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');
    my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');

    my $DynamicFieldPercentualScaleResponseTime = $DynamicFieldObject->DynamicFieldGet(
		Name => "PercentualScaleResponseTime",
	);

    my $PossibleValues = $DynamicFieldBackendObject->PossibleValuesGet(
       DynamicFieldConfig => $DynamicFieldPercentualScaleResponseTime,
    );

    foreach my $key (keys %{$PossibleValues}){
        my $indexOf = index($key,'-');
        if($indexOf > -1){
            my $min = substr $key, 0, $indexOf;
            my $max = substr $key, $indexOf+1;

            if($Param{Value} >= $min && $Param{Value} < $max){
                return $key;
            }
        }
        $indexOf = index($key,'>');
        if($indexOf > -1){
            my $number = substr $key, $indexOf+1;
            if($Param{Value} > $number){
                return $key;
            }
        }
        $indexOf = index($key,'<');
        if($indexOf > -1){
            my $number = substr $key, $indexOf+1;
            if($Param{Value} < $number){
                return $key;
            }
        }
    }
    
    return "";
}

1;
