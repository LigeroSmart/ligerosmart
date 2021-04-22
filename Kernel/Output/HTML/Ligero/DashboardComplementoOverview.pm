# --
# Kernel/Output/HTML/DashboardComplementoDouble.pm
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# --
# $Id:
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::Ligero::DashboardComplementoOverview;

use strict;
use warnings;

use Date::Pcalc
    qw(Add_Delta_YMD Add_Delta_DHMS Add_Delta_Days Days_in_Month Day_of_Week Day_of_Week_Abbreviation Day_of_Week_to_Text Monday_of_Week Week_of_Year);


use Kernel::System::ObjectManager;
local $Kernel::OM = Kernel::System::ObjectManager->new();
my $QueueObject = $Kernel::OM->Get('Kernel::System::Queue');

use vars qw($VERSION);
$VERSION = qw($Revision: 1.2 $) [1];

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );


    return $Self;
}

sub Preferences {
    my ( $Self, %Param ) = @_;

    return;
}

sub Config {
    my ( $Self, %Param ) = @_;

    return (
        %{ $Self->{Config} }
    );
}

sub Run {
    no warnings 'uninitialized';

    my ( $Self, %Param ) = @_;

    # quote Title attribute, it will be used as name="" parameter of the iframe
    my $Title = $Self->{Config}->{Title} || '';
    $Title =~ s/\s/_/smx;

    # get cache object
    my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $LocalConfig = $ConfigObject->Get($Self->{Config}->{ConfigKey});
    my $TimeObject = $Kernel::OM->Get('Kernel::System::Time');
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');
    my $QueueObject = $Kernel::OM->Get('Kernel::System::Queue');
    my %Items = %{$LocalConfig};

    my @Keys = sort keys %Items;

    my $Width = 100/(scalar @Keys);

    #######################################################################################
    # COMPLEMENTO Escalation Filter                                                       #

    # WHEN IS THE FIRST DAY OF "THIS WEEK" PERIOD (ACTUALY TOMORROW)
    my ( $Sec, $Min, $Hour, $Day, $Month, $Year ) = $TimeObject->SystemTime2Date(
        SystemTime => $TimeObject->SystemTime() + 60 * 60 * 24 * 2,
    );
    my $TimeStampNextWeekStart = "$Year-$Month-$Day 00:00:00";

    # WHEN THE "THIS WEEK" PERIOD FINISHS
    ( $Sec, $Min, $Hour, $Day, $Month, $Year ) = $TimeObject->SystemTime2Date(
        SystemTime => $TimeObject->SystemTime() + 60 * 60 * 24 * 7,
    );
    my $TimeStampNextWeekEnd = "$Year-$Month-$Day 23:59:59";

    # TOMORROW START AND TOMORROW END TIME
    ( $Sec, $Min, $Hour, $Day, $Month, $Year ) = $TimeObject->SystemTime2Date(
        SystemTime => $TimeObject->SystemTime() + 60 * 60 * 24,
    );
    my $TimeStampTomorrowStart = "$Year-$Month-$Day 00:00:00";
    my $TimeStampTomorrowEnd = "$Year-$Month-$Day 23:59:59";

    # TODAY START AND END TIME
    ( $Sec, $Min, $Hour, $Day, $Month, $Year ) = $TimeObject->SystemTime2Date(
        SystemTime => $TimeObject->SystemTime(),
    );
    my $TimeStampTodayStart = "$Year-$Month-$Day 00:00:00";
    my $TimeStampTodayEnd = "$Year-$Month-$Day 23:59:59";
    my $Now = "$Year-$Month-$Day $Hour:$Min:$Sec";

    my %EscalationFilters = (
        # ALREADY ESCALTED
        'Escalated' => {
                 TicketEscalationTimeOlderDate => $Now,
        },
        'Today' => {
                TicketEscalationTimeNewerDate => $Now,
                TicketEscalationTimeOlderDate => $TimeStampTodayEnd,
        },
        'Tomorrow' => {
                    TicketEscalationTimeNewerDate => $TimeStampTomorrowStart,
                    TicketEscalationTimeOlderDate => $TimeStampTomorrowEnd,
        },
        'Next week' => {
                    TicketEscalationTimeNewerDate => $TimeStampNextWeekStart,
                    TicketEscalationTimeOlderDate => $TimeStampNextWeekEnd,
        },
        'Solution Escalated' => {
                 TicketEscalationSolutionTimeOlderDate => $Now,
        },
        'Solution Today' => {
                TicketEscalationSolutionTimeNewerDate => $Now,
                TicketEscalationSolutionTimeOlderDate => $TimeStampTodayEnd,
        },
        'Solution Tomorrow' => {
                    TicketEscalationSolutionTimeNewerDate => $TimeStampTomorrowStart,
                    TicketEscalationSolutionTimeOlderDate => $TimeStampTomorrowEnd,
        },
        'Solution Next week' => {
                    TicketEscalationSolutionTimeNewerDate => $TimeStampNextWeekStart,
                    TicketEscalationSolutionTimeOlderDate => $TimeStampNextWeekEnd,
        },
        'Update Escalated' => {
                 TicketEscalationUpdateTimeOlderDate => $Now,
        },
        'Update Today' => {
                TicketEscalationUpdateTimeNewerDate => $Now,
                TicketEscalationUpdateTimeOlderDate => $TimeStampTodayEnd,
        },
        'Update Tomorrow' => {
                    TicketEscalationUpdateTimeNewerDate => $TimeStampTomorrowStart,
                    TicketEscalationUpdateTimeOlderDate => $TimeStampTomorrowEnd,
        },
        'Update Next week' => {
                    TicketEscalationUpdateTimeNewerDate => $TimeStampNextWeekStart,
                    TicketEscalationUpdateTimeOlderDate => $TimeStampNextWeekEnd,
        },
        'Response Escalated' => {
                 TicketEscalationResponseTimeOlderDate => $Now,
        },
        'Response Today' => {
                TicketEscalationResponseTimeNewerDate => $Now,
                TicketEscalationResponseTimeOlderDate => $TimeStampTodayEnd,
        },
        'Response Tomorrow' => {
                    TicketEscalationResponseTimeNewerDate => $TimeStampTomorrowStart,
                    TicketEscalationResponseTimeOlderDate => $TimeStampTomorrowEnd,
        },
        'Response Next week' => {
                    TicketEscalationResponseTimeNewerDate => $TimeStampNextWeekStart,
                    TicketEscalationResponseTimeOlderDate => $TimeStampNextWeekEnd,
        },

    );

    # End Expired filter

    # Current Time
    my $SystemTime = $TimeObject->SystemTime();
    my ( $s, $m, $h, $D, $M, $Y ) = $TimeObject->SystemTime2Date(
        SystemTime => $SystemTime,
    );

    # Loop on all semafors
    for my $Key (@Keys){
        my %Data = %{$Items{$Key}};

        my $CacheKey="CompDashOverview";

        # COPY FROM GENERIC TICKET DASHBOARD ###########################

        my %TicketSearch;
        my %DynamicFieldsParameters;
        my @Params = split /;/, $Data{Filter};

        STRING:
        for my $String (sort @Params) {
            next STRING if !$String;
            my ( $Key, $Value ) = split /=/, $String;

            $CacheKey .= "-$Key-$Value";

            if ( $Key eq 'CustomerID' ) {
                $Key = "CustomerIDRaw";
            }

            # push ARRAYREF attributes directly in an ARRAYREF
            if (
                $Key
                =~ /^(StateType|StateTypeIDs|Queues|QueueIDs|Types|TypeIDs|States|StateIDs|Priorities|PriorityIDs|Services|ServiceIDs|SLAs|SLAIDs|Locks|LockIDs|OwnerIDs|ResponsibleIDs|WatchUserIDs|ArchiveFlags)$/
                )
            {
                push @{ $TicketSearch{$Key} }, $Value;
            }
            #Shows only tickets that are locked by the agent
            elsif ($Key eq 'MyTickets')
            {
                    @{ $TicketSearch{'OwnerIDs'} } = $Self->{UserID};
                    $Data{Filter} =~ s/MyTickets=1/OwnerIDs=$Self->{UserID};/g;
            }
            ##### Created / Closed This Month
            elsif ($Key eq 'ClosedThisMonth')
            {
                #( $Y, $M, $D ) = Add_Delta_YMD( $Y, $M, $D, 0, 0, 0 );
                my $TimeStart = sprintf( "%04d-%02d-%02d %02d:%02d:%02d", $Y, $M, 1, 0, 0, 0 );
                my $TimeStop  = sprintf(
                                "%04d-%02d-%02d %02d:%02d:%02d",
                                $Y, $M, Days_in_Month( $Y, $M ),
                                23, 59, 59
                                );
                my $sM = sprintf "%02d",$M;
                my $sY = sprintf "%04d",$Y;
                my $sD = Days_in_Month( $Y, $M );
                $TicketSearch{'TicketCloseTimeNewerDate'} = $TimeStart;
                $TicketSearch{'TicketCloseTimeOlderDate'} = $TimeStop;
                $Data{Filter} =~ s/ClosedThisMonth/CloseTimeSearchType=TimeSlot;TicketCloseTimeStartDay=1;TicketCloseTimeStartMonth=$sM;TicketCloseTimeStartYear=$sY;TicketCloseTimeStopDay=$sD;TicketCloseTimeStopMonth=$sM;TicketCloseTimeStopYear=$sY/g;
            }
            elsif ($Key eq 'MyQueues')
            {
                    my @Queues = $QueueObject->GetAllCustomQueues( UserID => $Self->{UserID} );
                    my $RowQueueString;
                    foreach my $index (@Queues) {
                        $RowQueueString .= "QueueIDs=".$index.";";
                    }


                    @{ $TicketSearch{'QueueIDs'} } = $Kernel::OM->Get('Kernel::System::Queue')->GetAllCustomQueues( UserID => $Self->{UserID}, );

                     $Data{Filter} = $RowQueueString;
            }

            elsif ( $Key =~ m{\A (DynamicField_.+?) _ (.+?) \z}sxm ) {
                my $df = $1;
                #$Data{Filter} =~ s/$df/Ignore$df/g;
                $Data{Filter} .= ";ShownAttributes=LabelSearch_$df;Search_$df=$Value;";

                # prevent adding ProcessManagement search parameters (for ProcessWidget)
                if ( $Self->{Config}->{IsProcessWidget} ) {
                    next STRING if $2 eq $Self->{ProcessManagementProcessID};
                    next STRING if $2 eq $Self->{ProcessManagementActivityID};
                }

                push @{ $DynamicFieldsParameters{$1}->{$2} }, $Value;
            }

            elsif ( !defined $TicketSearch{$Key} ) {

                # change sort by, if needed
                if (
                    $Key eq 'SortBy'
                    && $Self->{SortBy}
                    && $Self->{ValidSortableColumns}->{ $Self->{SortBy} }
                    )
                {
                    $Value = $Self->{SortBy};
                }
                elsif ( $Key eq 'SortBy' && !$Self->{ValidSortableColumns}->{$Value} ) {
                    $Value = 'Age';
                }
                $TicketSearch{$Key} = $Value;
            }
            elsif ( !ref $TicketSearch{$Key} ) {
                my $ValueTmp = $TicketSearch{$Key};
                $TicketSearch{$Key} = [$ValueTmp];
                push @{ $TicketSearch{$Key} }, $Value;
            }
            else {
                push @{ $TicketSearch{$Key} }, $Value;
            }
        }

        # Verifica se ha filtro de expiracao
        my %ExpiredFilter;
        if ($Data{"Filter_Expired"} ne "") {
            %ExpiredFilter = %{ $EscalationFilters{ $Data{"Filter_Expired"} }};
            $CacheKey.="-Expired-".$Data{"Filter_Expired"};
        }

        $CacheKey .= "-"        ;
        $CacheKey .= $Self->{Config}->{Permission} || 'ro';
        $CacheKey .= "-".$Self->{UserID};

        %TicketSearch = (
            %TicketSearch,
            %DynamicFieldsParameters,
            %ExpiredFilter,
            Permission => $Self->{Config}->{Permission} || 'ro',
            UserID => $Self->{UserID},
        );

        # END OF COPY FROM GENERIC TICKET DASHBOARD ########################################

        my $pKey;
        my $pValue;

        # PercentageOf
        if($Data{PercentageOf}){
            my @PercentageParam = split /=/, $Data{PercentageOf};
            $pKey   = $PercentageParam[0];
            $pValue = $PercentageParam[1];

            $CacheKey.="$pKey-$pValue";
        } elsif ($Data{SumOf}){
            $CacheKey.="$Data{SumOf}";
        }

        my $Count = $CacheObject->Get(
            Type => 'Dashboard',
            Key  => $CacheKey . '-Count',
        );

        # Not in cache
        if($Count eq ''){
            if($Data{SumOf}){
                my @Tickets =$TicketObject->TicketSearch(
                            # Created Today
                            #Other Filters
                            %TicketSearch,
                            Result => 'ARRAY',
                            );
                for my $TicketID (@Tickets){
                    my %Ticket = $TicketObject->TicketGet(
                                        TicketID => $TicketID,
                                        DynamicFields => 1
                                    );

                    my $Val = $Ticket{$Data{SumOf}};
                    # You can define something like "/,/./"
                    # Sometimes maybe needed to replace , by . in order to sum
                    # You can define lots of replacements separating by 3 pipes: |||
                    if($Data{PreReplace}){
                        my @Replacements = split('\|\|\|',$Data{PreReplace});
                        for (@Replacements){
                            my $Code = '$Val =~ s'.$_;
                            eval ($Code);
                        }
                    }

                    $Count += $Val;
                }
            } else {

                $Count =$TicketObject->TicketSearch(
                            # Created Today
                            #Other Filters
                            %TicketSearch,
                            Result => 'COUNT',
                            ) || 0;

                #Check if we want to show count or Percentage of ocurrence of an attribute
                my %ExtraSearch;

                if($Data{PercentageOf}){
                    # se for campo dinamico verifica o parametro passado
                    if( $pKey =~ m{\A (DynamicField_.+?) _ (.+?) \z}sxm ) {
                        my $df = $1;

                        delete $TicketSearch{$1};
                        $ExtraSearch{$1}->{$2}=$pValue;

                        $Data{Filter} =~ s/$df/Ignore$df/g;
                        $Data{Filter} .= ";ShownAttributes=LabelSearch_$df;Search_$df=$pValue;"

                    } else {
                        delete $TicketSearch{$pKey};
                        $ExtraSearch{$pKey}=$pValue;

                        $Data{Filter} =~ s/$pKey/Ignore$pKey/g;
                        $Data{Filter} .= "$pKey=$pValue";

                    }
                    # faz a pesquisa
                    my $percCount =$TicketObject->TicketSearch(
                                # Created Today
                                #Other Filters
                                %ExtraSearch,
                                %TicketSearch,
                                Result => 'COUNT',
                                ) || 0;
                    # calcula o percentual
                    if($Count != 0){
                        $Count = $percCount*100/$Count;
                        $Count = sprintf("%.0f", $Count) . '%';
                    } else {
                        $Count = '0%';
                    }


                }
            }

            # You can use something as US$ %.2f
            if($Data{Sprintf}){
                $Count = sprintf ($Data{Sprintf} , $Count);
            }

            # You can define something like "/\./,/"
            if($Data{PostReplace}){
                my @Replacements = split('\|\|\|',$Data{PostReplace});
                for (@Replacements){
                    my $Code = '$Count =~ s'.$_;
                    eval ($Code);
                }
            }

            if ( $Self->{Config}->{CacheTTLLocal} ) {
                    $CacheObject->Set(
                        Type  => 'Dashboard',
                        Key   => $CacheKey . '-Count',
                        Value => $Count,
                        TTL   => $Self->{Config}->{CacheTTLLocal} * 60,
                    );
            }

        }

        # Check if we have a personalized URL
        $Data{URL} = $Data{URL} || "Action=AgentTicketSearch;Subaction=Search;".$Data{Filter};
        $Data{Width} = $Width;
        $Data{Count}=$Count || 0;
        $LayoutObject->Block(
            Name => 'Item',
            Data => \%Data,
        );
    }


##############################################
# Output!
##############################################
    my $Content = $LayoutObject->Output(
        TemplateFile => 'AgentDashboardComplementoOverview',
        Data         => {
            %{ $Self->{Config} },
            Title => $Title,
        },
    );

    return $Content;
}

1;
