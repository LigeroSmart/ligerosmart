# --
# Copyright (C) 2001-2016 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Console::Command::Maint::AutoTicket::AutoTicketCron;

use strict;
use warnings;

use base qw(Kernel::System::Console::BaseCommand);
use MIME::Base64;
use HTTP::Cookies;
use LWP::UserAgent;
use Date::Pcalc qw(Day_of_Week Day_of_Week_Abbreviation);
use POSIX qw/ceil floor/;

use Data::Dumper;

our @ObjectDependencies = (
    'Kernel::System::Loader',
);

my $TNSecuritySecs = 0;

sub trim { my $s = shift; $s =~ s/^\s+|\s+$//g; return $s };

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('Add AutoTicket Future Tasks .');

    return;
}

sub Run {
	my ( $Self, %Param ) = @_;

	$Self->Print("<yellow>Start read tasks...</yellow>\n");

	#$TNSecuritySecs = 0;

	# Obtain the list of all valids AutoTickets
	my %AutoTicketData = $Kernel::OM->Get('Kernel::System::AutoTicket')->AutoTicketList( Valid => 1 );
	my $ConfigObject   = $Kernel::OM->Get('Kernel::Config');
	my $DateTimeObject = $Kernel::OM->Create('Kernel::System::DateTime');

	# For each of AutoTickets Check if it needs to be created today and 
	# store the correct time for the action
	for ( keys %AutoTicketData ) {
		# Get the SLA from this AutoTicket if exists
		my %AutoTicket = $Kernel::OM->Get("Kernel::System::AutoTicket")->AutoTicketGet(ID=> $_,);
		my %SLA;
		if ($AutoTicket{SLAID}){
			%SLA = $Kernel::OM->Get("Kernel::System::SLA")->SLAGet(SLAID=> $AutoTicket{SLAID},UserID=>1);
		}
		my %Queue;
		if ($AutoTicket{QueueID}){
			%Queue = $Kernel::OM->Get("Kernel::System::Queue")->QueueGet( ID => $AutoTicket{QueueID} );
		}

		# Calculate time-shift based on SLA Calendar Time Zone > Queue Calendar Time Zone > System Calendar Time Zone
		my $slaTimeZone        = (%SLA && defined($SLA{Calendar})) ? $ConfigObject->Get('TimeZone::Calendar' . $SLA{Calendar}) : undef;
		my $queueTimeZone      = (%Queue && defined($Queue{Calendar})) ? $ConfigObject->Get('TimeZone::Calendar' . $Queue{Calendar}) : undef;
		my $systemTimeZone     = $DateTimeObject->OTRSTimeZoneGet();
		my $autoTicketTimeZone = $slaTimeZone || $queueTimeZone || $systemTimeZone;

		# Check if it has weekly or daily repetition
		my @weekdays = split(/;/, $AutoTicket{Weekday});

		for my $wday (@weekdays){
			my $d=0;
			# Weekdays repetitions:
			# For Each one of the WeekDays Repetions defined:
			#     Check the date of the next occourrency of this week day, for example,
			#     the next friday will be Aug 3th 2012.

			# Get "today" o.O
			my ( $Sec, $Min, $Hour, $Day, $Month, $Year, $Wday ) = $Kernel::OM->Get("Kernel::System::Time")->SystemTime2Date(
				SystemTime => $Kernel::OM->Get("Kernel::System::Time")->SystemTime(),
			);

			# Search for the next occouring of this weekday (0 .. 6)
			while ($wday!=$Wday){
				# Increase one day on each repetition
				$d++;
				( $Sec, $Min, $Hour, $Day, $Month, $Year, $Wday ) = $Kernel::OM->Get("Kernel::System::Time")->SystemTime2Date(
					SystemTime => $Kernel::OM->Get("Kernel::System::Time")->SystemTime() + $d * 60 * 60 * 24,
				);
			}

			#print STDOUT "\n\nNext $wday will be on $Year / $Month / $Day";

			# Make all verifications and see if it should be schedule.
			# If yes, schedule it!
			#print Dumper( "$Sec, $Min, $Hour, $Day, $Month, $Year, $Wday" );
			_scheduleIt(
				day        => $Kernel::OM->Get("Kernel::System::Time")->SystemTime() + $d * 60 * 60 * 24,
				AutoTicket => \%AutoTicket,
				SLA        => \%SLA,
				TZ         => $autoTicketTimeZone
			);

		} # end of for each week day

		# Monthday repetitions:
		if ($AutoTicket{Monthday}) {
			my @mdays = split(/;/, $AutoTicket{Monthday});

			my @months;
			# Try to catch the months.
			@months = split(/;/, $AutoTicket{Months});
			if (!@months) {
				#If no one define, it means that we want to create on all months
				@months = (1..12);
			}

			# For each month and day select, check if its the day to schedule the tasks        
			for my $month (@months){
				for my $mday (@mdays){

					$mday = trim($mday);
					my $y=0;

					# Get "today" o.O
					my ( $Sec, $Min, $Hour, $Day, $Month, $Year, $Wday ) = $Kernel::OM->Get("Kernel::System::Time")->SystemTime2Date(
						SystemTime => $Kernel::OM->Get("Kernel::System::Time")->SystemTime(),
					);

					if($month eq "02" or $month eq "2" and $mday > 27){
						if($Year % 4 != 0) {
							$mday = 28
						}elsif($Year % 400 == 0) {
							$mday = 29;
						}elsif($Year % 100 == 0){
							$mday = 28;
						}else{
							$mday = 29;
						}
					}

					# Search for the next occouring of this monthday
					my $nmday= $Kernel::OM->Get("Kernel::System::Time")->TimeStamp2SystemTime(
						String => "$Year-$month-$mday $AutoTicket{Hour}:$AutoTicket{Minutes}:00",
					);

					# Check if this month day passed this year
					if ($nmday<$Kernel::OM->Get("Kernel::System::Time")->SystemTime()){
						$Year++;
						$nmday= $Kernel::OM->Get("Kernel::System::Time")->TimeStamp2SystemTime(
						String => "$Year-$month-$mday $AutoTicket{Hour}:$AutoTicket{Minutes}:00",
						)
					}	

					_scheduleIt(
						day        => $nmday,
						AutoTicket => \%AutoTicket,
						SLA        => \%SLA,
						TZ         => $autoTicketTimeZone
					);            
				}
			}
		}

		# Increase security seconds:
		$TNSecuritySecs = $TNSecuritySecs+2;
        
		# For Each one of the Monthday Repetions defined (day X Month matrix):
		# 0 - Check the date of the next occourrency of this day, for example,
		#     today is Jul 28 2012, so the next July 7 will be on 2013.
		# 1 - check if the defined hour is an working hour (Get Sla and it's calendar)
		# 2 - If no, find the next Working Day as defined on NWD field
		#     and define it as the correct day for this task
		# 3 - Rewind the SLA Solution time (Need to create this function)
		#     Hour:Minutes from this day, less the service solution time (in working hours only)
		#     defined on the sla field.
		# 4 - Check if it's today And Schedule it

	} 	# end for each AutoTicket

	$Self->Print("<green>Done.</green>\n");

	return $Self->ExitCodeOk();
}


sub _scheduleIt{
    my %ParamObject = @_;

    my ( $Sec, $Min, $Hour, $Day, $Month, $Year, $Wday )
        = $Kernel::OM->Get("Kernel::System::Time")->SystemTime2Date(
        SystemTime => $ParamObject{day},
    );

    #
    # Convert schedule timestamp to the correct TZ
    #
    my $TimeObject     = $Kernel::OM->Get('Kernel::System::Time');
    my $DateTimeObject = $Kernel::OM->Create(
        'Kernel::System::DateTime',
        ObjectParams => {
            Year     => $Year,
            Month    => $Month,
            Day      => $Day,
            Hour     => $Hour,
            Minute   => $Min,
            Second   => $Sec,
            TimeZone => Kernel::System::DateTime->OTRSTimeZoneGet()
        }
    );
    $DateTimeObject->ToTimeZone( TimeZone => $ParamObject{TZ} );
    #print Dumper( $ParamObject{TZ} . ": " . $ParamObject{day} . " to " . $TimeObject->TimeStamp2SystemTime( String => $DateTimeObject->ToString() ));

    $ParamObject{day} = $TimeObject->TimeStamp2SystemTime( String => $DateTimeObject->ToString() );
    ( $Sec, $Min, $Hour, $Day, $Month, $Year, $Wday )
        = $Kernel::OM->Get("Kernel::System::Time")->SystemTime2Date(
        SystemTime => $ParamObject{day},
    );

    #
    # Convert system time to the correct TZ
    #
    my $CurrentDateTimeObject = $Kernel::OM->Create('Kernel::System::DateTime');
    $CurrentDateTimeObject->ToTimeZone( TimeZone => $ParamObject{TZ} );
    my $SystemTime     = $Kernel::OM->Get("Kernel::System::Time")->TimeStamp2SystemTime( String => $CurrentDateTimeObject->ToString() );
    #print Dumper( $Kernel::OM->Get("Kernel::System::Time")->SystemTime() . " to $SystemTime" );

    my $nonBday = $Kernel::OM->Get("Kernel::System::Time")->WorkingTime(
        StartTime => $Kernel::OM->Get("Kernel::System::Time")->TimeStamp2SystemTime(
           String => _ConvertToTimeZone(Date => "$Year-$Month-$Day $ParamObject{AutoTicket}->{Hour}:$ParamObject{AutoTicket}->{Minutes}:00", TZ => $ParamObject{TZ}),
            ) - 1,
        StopTime =>  $Kernel::OM->Get("Kernel::System::Time")->TimeStamp2SystemTime(
           String => _ConvertToTimeZone(Date => "$Year-$Month-$Day $ParamObject{AutoTicket}->{Hour}:$ParamObject{AutoTicket}->{Minutes}:00", TZ => $ParamObject{TZ}),
            ) + 1,
        Calendar => $ParamObject{SLA}->{Calendar}||''
    );
    if (!$nonBday) {
    
        # It's not a business hour or day
    
        my $i=0;
        my $wm=0; # Working minutes
        # print STDOUT "\nIt's HollyDay\n";
        # 2 - If yes, find the next Working Day as defined on NWD field
        #     and define it as the correct day for this task
        if($ParamObject{AutoTicket}->{Nwd} == 1){
                # Next B Day
                # loop 60 days maximum
                while($wm<1 && $i<60){
                    $i++;
                    # increment one day
                    $ParamObject{day}=$ParamObject{day} + 24*60*60;
                    ( $Sec, $Min, $Hour, $Day, $Month, $Year, $Wday )
                        = $Kernel::OM->Get("Kernel::System::Time")->SystemTime2Date(
                        SystemTime => $ParamObject{day},
                    );
                    $wm = $Kernel::OM->Get("Kernel::System::Time")->WorkingTime(
                        StartTime => $Kernel::OM->Get("Kernel::System::Time")->TimeStamp2SystemTime(
                           String => _ConvertToTimeZone(Date => "$Year-$Month-$Day $ParamObject{AutoTicket}->{Hour}:$ParamObject{AutoTicket}->{Minutes}:00", TZ => $ParamObject{TZ}),
                            ) - 1,
                        StopTime =>  $Kernel::OM->Get("Kernel::System::Time")->TimeStamp2SystemTime(
                           String => _ConvertToTimeZone(Date => "$Year-$Month-$Day $ParamObject{AutoTicket}->{Hour}:$ParamObject{AutoTicket}->{Minutes}:00", TZ => $ParamObject{TZ}),
                            ) + 1,
                        Calendar => $ParamObject{SLA}->{Calendar}||''
                    );
                }
                
                # something is wrong with this job.. 60 days without been create?
                if ($i==60) {
                    print STDOUT "\n\nPlease check AutoTicket $ParamObject{AutoTicket}->{Name} since it will not be create 60 days in the future.\n\n";
                } else {
                    print STDOUT "\nAuto Ticket $ParamObject{AutoTicket}->{Name} will be schedule to the next Business Day\n";
                }
            }
            elsif($ParamObject{AutoTicket}->{Nwd} == 2){
                # Previous B Day
                while($wm<1 && $i<60){
                    $i++;
                    # decrement one day
                    $ParamObject{day}=$ParamObject{day} - 24*60*60;
                    ( $Sec, $Min, $Hour, $Day, $Month, $Year, $Wday )
                        = $Kernel::OM->Get("Kernel::System::Time")->SystemTime2Date(
                        SystemTime => $ParamObject{day},
                    );
                        
                    $wm = $Kernel::OM->Get("Kernel::System::Time")->WorkingTime(
                        StartTime => $Kernel::OM->Get("Kernel::System::Time")->TimeStamp2SystemTime(
                           String => "$Year-$Month-$Day $ParamObject{AutoTicket}->{Hour}:$ParamObject{AutoTicket}->{Minutes}:00",
                            ) - 1,
                        StopTime =>  $Kernel::OM->Get("Kernel::System::Time")->TimeStamp2SystemTime(
                           String => "$Year-$Month-$Day $ParamObject{AutoTicket}->{Hour}:$ParamObject{AutoTicket}->{Minutes}:00",
                            ),
                        Calendar => $ParamObject{SLA}->{Calendar}||''
                    );
                }
                
                # something is wrong with this job.. 60 days without been create?
                if ($i==60) {
                    print STDOUT "\n\nPlease check AutoTicket $ParamObject{AutoTicket}->{Name} since it will not be create 60 days in the past.\n\n";
                } else {
                    print STDOUT "\nAuto Ticket $ParamObject{AutoTicket}->{Name} will be schedule to the previous Business Day\n";
                }
                
            }
            elsif($ParamObject{AutoTicket}->{Nwd} == 3){
                # Go ahead respecting the SLA
                
            }
            elsif($ParamObject{AutoTicket}->{Nwd} == 4){
                # Don't Create, pass by
                return;
            }

    } # end of holiday checking

    # 3 - Rewind the SLA Solution time
    #     Hour:Minutes from this day, less the service solution time (in working hours only)
    #     defined on the sla field.

    # Solution Time is in minutos
    my $SlaSolutionTime = $ParamObject{SLA}->{SolutionTime} || 0;
    my $WorkingMins=0;
    my $secsToRewind = 0;

	# Check if it should be created based on SLA
    if($ParamObject{AutoTicket}->{Nwd} != 5){
		# Check First Run
		my $WorkingSecs = $Kernel::OM->Get("Kernel::System::Time")->WorkingTime(
			StartTime => $Kernel::OM->Get("Kernel::System::Time")->TimeStamp2SystemTime(
			   String => "$Year-$Month-$Day $ParamObject{AutoTicket}->{Hour}:$ParamObject{AutoTicket}->{Minutes}:00",
				) - ( $secsToRewind ),
			StopTime =>  $Kernel::OM->Get("Kernel::System::Time")->TimeStamp2SystemTime(
			   String => "$Year-$Month-$Day $ParamObject{AutoTicket}->{Hour}:$ParamObject{AutoTicket}->{Minutes}:00",
				),
			Calendar => $ParamObject{SLA}->{Calendar}||''
		);
		$WorkingMins = $WorkingSecs / 60;

		# Loop until we find the correct time this ticket should be created
		# Maybe we can find a better way to make this calc in the future =/
		while ($WorkingMins<$SlaSolutionTime){
			# Increase one hour on each repetition
			$secsToRewind=$secsToRewind + 60 * 60;
			$WorkingSecs = $Kernel::OM->Get("Kernel::System::Time")->WorkingTime(
				StartTime => $Kernel::OM->Get("Kernel::System::Time")->TimeStamp2SystemTime(
				   String => "$Year-$Month-$Day $ParamObject{AutoTicket}->{Hour}:$ParamObject{AutoTicket}->{Minutes}:00",
					) - ( $secsToRewind ),
				StopTime =>  $Kernel::OM->Get("Kernel::System::Time")->TimeStamp2SystemTime(
				   String => "$Year-$Month-$Day $ParamObject{AutoTicket}->{Hour}:$ParamObject{AutoTicket}->{Minutes}:00",
					),
				Calendar => $ParamObject{SLA}->{Calendar}||''
			);
			$WorkingMins = $WorkingSecs / 60;
		}
		# ceil or floor?
		#print STDOUT "\n we need to rewind $secsToRewind or ".ceil($secsToRewind/60) , " minutes ";
	}
	
    # 4 - Check if the creation date is today And Schedule it
    my ( $NSec, $NMin, $NHour, $NDay, $NMonth, $NYear, $NWday )
        = $Kernel::OM->Get("Kernel::System::Time")->SystemTime2Date(
        SystemTime => $Kernel::OM->Get("Kernel::System::Time")->TimeStamp2SystemTime(
               String => "$Year-$Month-$Day $ParamObject{AutoTicket}->{Hour}:$ParamObject{AutoTicket}->{Minutes}:00",
                ) - ( $secsToRewind ) + $TNSecuritySecs,
        );

    my $create_time_unix=$Kernel::OM->Get("Kernel::System::Time")->TimeStamp2SystemTime(
               String => "$Year-$Month-$Day $ParamObject{AutoTicket}->{Hour}:$ParamObject{AutoTicket}->{Minutes}:00",
                ) - ( $secsToRewind );
                
    #print STDOUT "\n Ticket should be create on $NDay/$NMonth/$NYear $NHour:$NMin $NWday";

    # Get "today" o.O again!
    ( $Sec, $Min, $Hour, $Day, $Month, $Year, $Wday )
        = $Kernel::OM->Get("Kernel::System::Time")->SystemTime2Date(
        #SystemTime => $Kernel::OM->Get("Kernel::System::Time")->SystemTime(),
        SystemTime => $SystemTime
    );
    
    # Compare dates and check if it's today
    #if (($Year==$NYear) && ($Month==$NMonth) && ($Day==$NDay) && ($create_time_unix > $Kernel::OM->Get("Kernel::System::Time")->SystemTime())) {
    if (($Year==$NYear) && ($Month==$NMonth) && ($Day==$NDay) && ($create_time_unix > $SystemTime)) {
        #print STDOUT "\n e isto é hoje!";
#        my %CustomerIDs = $Kernel::OM->Get("Kernel::System::AutoTicket")->GetCustomerIDAutoTicket(
#                                AutoTicketID=>$ParamObject{AutoTicket}->{ID},
#                                );
#        # Schedule on Ticket Creation for each Customer ID
#        for (keys %CustomerIDs){
            print STDOUT "\nScheduling $ParamObject{AutoTicket}->{Name} for $_ on $NHour:$NMin:$NSec $NDay/$NMonth/$NYear [$ParamObject{TZ}]\n\n";

            #
            # Convert create_time_unix back to system time
            #
            my $DateTimeObject = $Kernel::OM->Create(
                'Kernel::System::DateTime',
                ObjectParams => {
                    Year     => $NYear,
                    Month    => $NMonth,
                    Day      => $NDay,
                    Hour     => $NHour,
                    Minute   => $NMin,
                    Second   => $NSec,
                    TimeZone => $ParamObject{TZ}
                }
            );
            $DateTimeObject->ToTimeZone( TimeZone => Kernel::System::DateTime->OTRSTimeZoneGet() );
            print Dumper( $create_time_unix . " -> " . $TimeObject->TimeStamp2SystemTime( String => $DateTimeObject->ToString() ));
            $create_time_unix = $TimeObject->TimeStamp2SystemTime( String => $DateTimeObject->ToString() );
            ( $NSec, $NMin, $NHour, $NDay, $NMonth, $NYear, $NWday ) = $Kernel::OM->Get("Kernel::System::Time")->SystemTime2Date(
                SystemTime => $create_time_unix
            );

	    my $TaskID = $Kernel::OM->Get("Kernel::System::Daemon::SchedulerDB")->FutureTaskAdd(    
                Type => 'AutoTicket',
                Data     => {
                    create_time   => $create_time_unix,
                    %{$ParamObject{AutoTicket}},
#                    Title         => $ParamObject{AutoTicket}->{Title},
#                    QueueID       => $ParamObject{AutoTicket}->{QueueID},
#                    PriorityID    => $ParamObject{AutoTicket}->{PriorityID},
#                    StateID       => $ParamObject{AutoTicket}->{StateID},
#                    TypeID        => $ParamObject{AutoTicket}->{TypeID},
#                    ServiceID     => $ParamObject{AutoTicket}->{ServiceID},
#                    SLAID         => $ParamObject{AutoTicket}->{SLAID},
#                    CustomerID    => $ParamObject{AutoTicket}->{CustomerID},
#                    IsVisibleForCustomer   => $ParamObject{AutoTicket}->{IsVisibleForCustomer},
                    CustomerUser  => $ParamObject{AutoTicket}->{Customer},
                    Subject       => $ParamObject{AutoTicket}->{Title},
                    Body          => $ParamObject{AutoTicket}->{Message},
                    Lock          => 'unlock',
                    OwnerID       => 1,
                    UserID        => 1,
                    SenderType    => 'agent',
                    From          => 'System',
                    Success       => 1,
                    ReSchedule    => 0,
                },
                ExecutionTime  => "$NYear-$NMonth-$NDay $NHour:$NMin:$NSec",
            );
            
            # Now we are going to check if this Task was already scheduleit,
            # If yes, remove it (Maybe, in the future, we could find a way to do it before
            # scheduling the task)
            _checkTask(
                TaskID => $TaskID,
            )

#        } # end for each customer ID schedule ticket

       
    } #end this ticket should be created today

}

sub _checkTask{
    my %TaskParam = @_;
    my $SchedulerDBObject = $Kernel::OM->Get('Kernel::System::Daemon::SchedulerDB');

 
    # Get information about the recently created task
    my %Task = $SchedulerDBObject->FutureTaskGet(TaskID => $TaskParam{TaskID});
    
    my @AllTasks = $SchedulerDBObject->FutureTaskList();
    
    for my $OldTaskID (@AllTasks){
    
        my %OldTask = $SchedulerDBObject->FutureTaskGet(TaskID => $OldTaskID->{TaskID});
        # An ancient way to compare hashs:
        if (_compareTask( Task1=>\%Task, Task2=>\%OldTask ) eq 1) {
            print STDOUT "\n\nThis task already exists, removing it.\n";
           $SchedulerDBObject->FutureTaskDelete(TaskID => $TaskParam{TaskID});
            return;
        }
        
    
    }
    
#    print "\n\n Tarefa Criada $TaskParam{TaskID} \n\n";
}

sub _compareTask{
    my %cTasks = @_;
    
    my $differences=0;


    # Check if it is not the same we have just create
    #print STDOUT "\n\nThis $cTasks{Task1}->{TaskID} and $cTasks{Task2}->{TaskID}\n";
    if ($cTasks{Task1}->{TaskID} eq $cTasks{Task2}->{TaskID}) {
        return 0;
    }
    
    # Check if it has the same size
    if (keys %{$cTasks{Task1}->{Data}} == keys %{$cTasks{Task2}->{Data}} ) {
        #print STDOUT "\nmesmo numero de elementos\n";
        
        #Check if it has the same keys
        foreach my $key (keys %{$cTasks{Task1}->{Data}}){
	       if (!defined $cTasks{Task2}->{Data}->{$key}){
	          return 0;
	       }
	    }
        foreach my $key (keys %{$cTasks{Task2}->{Data}}){
	       if (!defined $cTasks{Task1}->{Data}->{$key}){
	          return 0;
	       }
	    }
       
       if ($differences > 0) {
           return 0;
       }
       
       # Compare Values
        foreach my $key (keys %{$cTasks{Task1}->{Data}}){
	       if ($cTasks{Task1}->{Data}->{$key} ne $cTasks{Task2}->{Data}->{$key}){
	          return 0;
	       }
	    }
        
        # We compared evererything but and find no diferrences, so 
        # those hashes are equals. We must return 1;
        return 1;
    } else {
        return 0;
    }
    
}

sub _ConvertToTimeZone {
  my %ParamObject = @_;



  my $DateTimeObject = $Kernel::OM->Create(
        'Kernel::System::DateTime',
        ObjectParams => {
            String   => $ParamObject{Date},
            TimeZone => $ParamObject{TZ},        # optional, defaults to setting of SysConfig OTRSTimeZone
        }
    );
  use Data::Dumper;
  $DateTimeObject->ToTimeZone(TimeZone =>'UTC');
  
  return $DateTimeObject->ToString();
}


1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
