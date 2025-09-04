# --
# Kernel/Output/HTML/LayoutKIX4OTRS.pm - provides additional or changed HTML output
# Copyright (C) 2006-2011 c.a.p.e. IT GmbH, http://www.cape-it.de
#
# written/edited by:
# * Martin(dot)Balzarek(at)cape(dash)it(dot)de
# * Rene(dot)Boehm(at)cape(dash)it(dot)de
# * Martin(dot)Balzarek(at)cape(dash)it(dot)de
# * Stefan(dot)Mehlig(at)cape(dash)it(dot)de
# * Frank(dot)Oberender(at)cape(dash)it(dot)de
# * Dorothea(dot)Doerffel(at)cape(dash)it(dot)de
#
# --
# $Id: LayoutKIX4OTRS.pm,v 1.21.2.11 2012-02-09 12:51:36 ddoerffel Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::Layout::LayoutKIX4OTRS;

use strict;
use warnings;

use Kernel::System::CustomerUser;

use vars qw(@ISA $VERSION);
$VERSION = qw($Revision: 1.21.2.11 $) [1];

#sub BuildNotifyKIX4OTRSHTML {
#    my ( $Self, %Param ) = @_;

#    my $Type        = $Param{Type}        || '';
#    my $Translation = $Param{Translation} || 1;
#    my $ReturnType  = $Param{ReturnType}  || '';
#    my $Result      = $Param{Result}      || 1;
#    my $Message     = '';
#    my $Class       = $Param{Class}       || '';
#    $Class .= $Result ? ' Success' : ' Error';

#    # set output style
#    if ( $ReturnType eq 'Text' ) {

#        # generate message
#        if ( $Type eq 'TicketFreeText' ) {
#            $Message =
#                'TicketFreeText-field '
#                . ( $Result ? 'successfully' : 'could not be' )
#                . ' updated!';
#        }
#        elsif ( $Type eq 'TicketFreeTime' ) {
#            $Message =
#                'TicketFreeTime-field '
#                . ( $Result ? 'successfully' : 'could not be' )
#                . ' updated!';
#        }
#        elsif ( $Type eq 'TicketData' ) {
#            $Message = 'Ticket data ' . ( $Result ? 'successfully' : 'could not be' ) . ' updated!';
#        }
#        elsif ( $Type eq 'TicketRemarks' ) {
#            $Message = 'Remarks ' . ( $Result ? 'successfully' : 'could not be' ) . ' saved!';
#        }
#        else {
#            $Message = $Type . ( $Result ? ' successfully' : ' could not be' ) . ' saved!';
#        }

#        $Self->Block(
#            Name => ($Translation) ? 'Text' : 'QData',
#            Data => {
#                Data => $Message,
#            },
#        );
#    }
#    elsif ( $ReturnType eq 'Direct' ) {
#        $Self->Block(
#            Name => 'Data',
#            Data => \%Param,
#        );
#    }
#    else {
#        $Self->Block(
#            Name => 'QData',
#            Data => \%Param,
#        );
#    }

#    # add div to HTML
#    if ( $Param{Div} ) {
#        $Self->Block(
#            Name => 'DivStart',
#            Data => {},
#        );
#        $Self->Block(
#            Name => 'DivStop',
#            Data => {},
#        );
#    }

#    # add link to notify
#    if ( $Param{Link} ) {
#        $Self->Block(
#            Name => 'LinkStart',
#            Data => \%Param,
#        );
#        $Self->Block(
#            Name => 'LinkStop',
#            Data => \%Param,
#        );
#    }

#    # build and return HTML
#    return $Self->Output(
#        TemplateFile => 'NotifyKIX4OTRS',
#        Data         => {
#            Class => $Class,
#        },
#    );
#}

#sub HasDatepickerDirectSet {
#    my ( $Self, %Param ) = @_;

#    $Self->{HasDatepicker} = 1;
#    return;
#}

#sub IsBlockDefined {
#    my ( $Self, %Param ) = @_;
#    my $Found = 0;

#    foreach my $BlockDef ( @{ $Self->{BlockData} } ) {
#        if ( $BlockDef->{Name} eq $Param{Name} ) {
#            $Found = 1;
#            last;
#        }
#    }

#    return $Found;
#}

sub CustomerAssignedCustomerIDsTable {
    my ( $Self, %Param ) = @_;

    $Self->{CustomerUserObject} ||= $Kernel::OM->Get('Kernel::System::CustomerUser');

    for my $CurrKey (qw(CustomerUserID)) {
        return '' if !$Param{$CurrKey};
    }

    # get customer IDs for current user...
    my %CustomerData = $Self->{CustomerUserObject}->CustomerUserDataGet(
        User => $Param{CustomerUserID},
    );
    my @CustomerIDs = $Self->{CustomerUserObject}->CustomerIDs(
        User => $Param{CustomerUserID},
    );
    
    # procura pela empresa principal na lista de empresas e remove
    # para adicionar a mesma no topo no bloco a seguir
    for (0..$#CustomerIDs) {
 	   if ($CustomerIDs[$_] eq $CustomerData{UserCustomerID}) {
	        delete $CustomerIDs[$_];
	   }
    }
    #adiciona a empresa principal no topo da listagem
    unshift( @CustomerIDs, $CustomerData{UserCustomerID} );

    #return '' if !@CustomerIDs || scalar(@CustomerIDs) == 1;

    # build customer IDs table
    for my $CustomerID (@CustomerIDs) {

        $Self->Block(
            Name => 'CustomerIDRow',
            Data => {
                ID => $CustomerID,
            },
        );
    }
    return $Self->Output(
        TemplateFile   => 'CustomerAssignedCustomerIDsList',
        Data           => \%Param,
        KeepScriptTags => $Param{AJAX} || 0,
    );
}

sub AgentCustomerDetailsViewTable {
    my ( $Self, %Param ) = @_;

    $Self->Block(
        Name => 'CustomerDetails',
    );

    my @MapNew;
    my $Map = $Param{Data}->{Config}->{Map};
    if ($Map) {
        @MapNew = ( @{$Map} );
    }

    # check if customer company support is enabled
    if ( $Param{Data}->{Config}->{CustomerCompanySupport} ) {
        my $Map2 = $Param{Data}->{CompanyConfig}->{Map};
        if ($Map2) {
            push( @MapNew, @{$Map2} );
        }
    }

    # build table
    for my $Field (@MapNew) {
        if ( $Field->[3] && $Field->[3] >= 1 && $Param{Data}->{ $Field->[0] } ) {
            my %Record = (
                %{ $Param{Data} },
                Key   => $Field->[1],
                Value => $Param{Data}->{ $Field->[0] },
            );
            if ( $Field->[6] ) {
                $Record{LinkStart} = "<a href=\"$Field->[6]\"";
                if ( $Field->[8] ) {
                    $Record{LinkStart} .= " target=\"$Field->[8]\"";
                }
                $Record{LinkStart} .= "\">";
                $Record{LinkStop} = "</a>";
            }
            if ( $Field->[0] ) {
                $Record{ValueShort} = $Self->Ascii2Html(
                    Text => $Record{Value},
                    Max  => 25,
                );
            }
            $Self->Block(
                Name => 'CustomerDetailsRow',
                Data => \%Record,
            );
        }
    }

    return $Self->Output(
        TemplateFile   => 'AgentCustomerTableView',
        Data           => \%Param,
        KeepScriptTags => $Param{AJAX} || 0,
    );
}

#sub AgentKIXSidebar {
#    my ( $Self, %Param ) = @_;
#    my $Output;

#    my $Config =
#        $Kernel::OM->Get('Kernel::Config')
#        ->Get(
#        'Ticket::Frontend::' . ( $Param{Action} || $Self->{Action} ) . '::KIXSidebarBackend'
#        );
#    return if !$Config;

#    # get shown backends
#    BACKEND:
#    for my $Backend ( sort keys %{$Config} ) {

#        # check permissions
#        if ( $Config->{$Backend}->{Group} ) {
#            my @Groups = split( ';', $Config->{$Backend}->{Group} );
#            for my $Group (@Groups) {
#                my $Backend = 'UserIsGroup[' . $Group . ']';
#                next BACKEND if !$Self->{$Backend};
#                next BACKEND if $Self->{$Backend} ne 'Yes';
#            }
#        }

#        # load backend module
#        next BACKEND if !$Kernel::OM->Get('Kernel::System::Main')->Require( $Config->{$Backend}->{Module} );

#        # execute event backend
#        my $Generic = $Config->{$Backend}->{Module}->new(
#            %{$Self},
#            %Param,
#            %{ $Config->{$Backend} },
#            Frontend     => 'Agent',
#            Config       => $Config->{$Backend},
#            LayoutObject => $Self,
#        );

#        $Output .= $Generic->Run(
#            %{$Self},
#            %Param,
#            %{ $Config->{$Backend} },
#            Frontend => 'Agent',
#            Config   => $Config->{$Backend},
#        );
#    }

#    return $Output;
#}

#sub CustomerKIXSidebar {
#    my ( $Self, %Param ) = @_;
#    my $Output;

#    my $Config =
#        $Kernel::OM->Get('Kernel::Config')
#        ->Get( 'Ticket::CustomerFrontend::' . $Self->{Action} . '::KIXSidebarBackend' );
#    return if !$Config;

#    # get shown backends
#    BACKEND:
#    for my $Backend ( sort keys %{$Config} ) {

#        # load backend module
#        next BACKEND if !$Kernel::OM->Get('Kernel::System::Main')->Require( $Config->{$Backend}->{Module} );

#        # execute event backend
#        my $Generic = $Config->{$Backend}->{Module}->new(
#            %{$Self},
#            %Param,
#            %{ $Config->{$Backend} },
#            Frontend     => 'Customer',
#            Config       => $Config->{$Backend},
#            LayoutObject => $Self,
#        );

#        $Output .= $Generic->Run(
#            %{$Self},
#            %Param,
#            %{ $Config->{$Backend} },
#            Frontend => 'Customer',
#            Config   => $Config->{$Backend},
#        );
#    }

#    return $Output;
#}

#=item AgentQueueListOptionJSON()

#build a output with DisabledOption witch can be used for JSON data for pull downs

#    my $DataHash = $LayoutObject->AgentQueueListOptionJSON(
#        [
#            Data          => $ArrayRef,      # use $HashRef, $ArrayRef or $ArrayHashRef (see below)
#            Name          => 'TheName',      # name of element
#            MaxLevel      => $IntegerValue,  # recursion depth of QueueTree
#        ],
#        [
#            # ...
#        ]
#    );

#=cut

#sub AgentQueueListOptionJSON {

#    my ( $Self, $Array, %Param ) = @_;
# 
#    my %DataHash;
#    
#    my $MaxLevel   = defined( $Param{MaxLevel} )   ? $Param{MaxLevel}      : 10;
#      
#    for my $Data ( @{$Array} ) {
#        %Param = %{$Data};
#        
#        my %TempDataHash;
#    
#        # check needed stuff
#        for (qw(Name Data)) {
#            if ( !defined $Param{$_} ) {
#                $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
#                return;
#            }
#        }
#        
#        my $Name  = $Param{Name};
#        my %Data;
#        my %UsedData;
#        
#        
#        if ( $Param{Data} && ref $Param{Data} eq 'HASH' ) {
#            %Data = %{ $Param{Data} };
#        }
#        else {
#            return 'Need Data Ref in AgentQueueListOptionJSON()!';
#        }    
#        
#        # add suffix for correct sorting
#        for ( sort { $Data{$a} cmp $Data{$b} } keys %Data ) {
#            $Data{$_} .= '::';
#        }
#        
#        # to show disabled queues only one time in the selection tree
#        my %DisabledQueueAlreadyUsed;
#        
#        # create hash
#        my %NewHash;
#        my %DisabledOptions;
#         
#        my @DataArray;
#        for ( sort { $Data{$a} cmp $Data{$b} } keys %Data ) { 
#            
#            my @Queue       = split( /::/, $Param{Data}->{$_} );
#            my $QueueSize   = scalar(@Queue);
#            
#            $UsedData{ $Param{Data}->{$_} } = 1;
#            my $UpQueue = $Param{Data}->{$_};
#            $UpQueue =~ s/^(.*)::.+?$/$1/g;
#    
#            if ( !$Queue[$MaxLevel] && $Queue[-1] ne '' ) { 
#                if ( !$UsedData{ $UpQueue } ) {
#                    my $Value  = '';
#                    for my $Index ( 0 .. $QueueSize -2 ) { 
#                    	    
#                        if ( !$DisabledQueueAlreadyUsed{ $UpQueue } ) { 
#                            my $Key    = '-';  
#                            # build value-string                     
#                            if ($Index) {
#                                $Value .= '::'.$Queue[$Index];
#                            }
#                            else {
#                                $Value .= $Queue[$Index];
#                            }
#                            # do not disable used queues
#                            if ( !$UsedData{ $Value } ) {
#                                $NewHash{$Key."||".$Value} = $Value;
#	                            $DisabledOptions{$Key."||".$Value} = $Value;
#	                            $DisabledQueueAlreadyUsed{ $Value } = 1;
#                            }
#                        } 
#                    } 
#                } 
#    
#                my $Key         = $_;
#                my $Value       = '';
#                my $Separator   = '';
#                    for my $Index ( 0 .. $QueueSize - 1 ) {
#                        $Value .= $Separator.$Queue[$Index];
#                        $Separator = "::";            
#                    }
#              
#                $NewHash{$Key} = $Value;
#                       
#            } 
#        }
#        
#        $TempDataHash{DisabledOptions}  = \%DisabledOptions;
#        $TempDataHash{Data}             = \%NewHash;  
#        
#        $DataHash{ $Param{Name} } = \%TempDataHash;
#    }
#        

#    return \%DataHash;
#   
#}


# disable redefine warnings in this scope
{
    no warnings 'redefine';

    # overwrite sub BuildDateSelection to provide further layout for date selections
#    sub Kernel::Output::HTML::Layout::BuildDateSelection {
#        my ( $Self, %Param ) = @_;

#        # KIX4OTRS-capeIT
#        my $SmartStyleDate
#            = ( defined $Param{SmartDateInput} )
#            ? $Param{SmartDateInput}
#            : $Kernel::OM->Get('Kernel::Config')->Get('DateSelection::Layout::SmartDateInput');
#        my $SmartStyleTime
#            = ( defined $Param{SmartTimeInput} )
#            ? $Param{SmartTimeInput}
#            : $Kernel::OM->Get('Kernel::Config')->Get('DateSelection::Layout::SmartTimeInput');
#        my $MinuteIntervall
#            = ( defined $Param{TimeInputIntervall} )
#            ? $Param{TimeInputIntervall}
#            : $Kernel::OM->Get('Kernel::Config')->Get('DateSelection::Layout::TimeInputIntervall');

#        # EO KIX4OTRS-capeIT

#        my $DateInputStyle = $Kernel::OM->Get('Kernel::Config')->Get('TimeInputFormat');
#        my $Prefix         = $Param{Prefix} || '';
#        my $DiffTime       = $Param{DiffTime} || 0;
#        my $Format         = defined( $Param{Format} ) ? $Param{Format} : 'DateInputFormatLong';
#        my $Area           = $Param{Area} || 'Agent';
#        my $Optional       = $Param{ $Prefix . 'Optional' } || 0;
#        my $Required       = $Param{ $Prefix . 'Required' } || 0;
#        my $Used           = $Param{ $Prefix . 'Used' } || 0;
#        my $Class          = $Param{ $Prefix . 'Class' } || '';

#        # Defines, if the date selection should be validated on client side with JS
#        my $Validate = $Param{Validate} || 0;

#        # Validate that the date is in the future (e. g. pending times)
#        my $ValidateDateInFuture = $Param{ValidateDateInFuture} || 0;

#        my ( $s, $m, $h, $D, $M, $Y ) = $Self->{UserTimeObject}->SystemTime2Date(
#            SystemTime => $Self->{UserTimeObject}->SystemTime() + $DiffTime,
#        );
#        my $DatepickerHTML = '';

#        # time zone translation
#        if (
#            $Kernel::OM->Get('Kernel::Config')->Get('TimeZoneUser')
#            && $Self->{UserTimeZone}
#            && $Param{ $Prefix . 'Year' }
#            && $Param{ $Prefix . 'Month' }
#            && $Param{ $Prefix . 'Day' }
#            )
#        {
#            my $TimeStamp = $Self->{TimeObject}->TimeStamp2SystemTime(
#                String => $Param{ $Prefix . 'Year' } . '-'
#                    . $Param{ $Prefix . 'Month' } . '-'
#                    . $Param{ $Prefix . 'Day' } . ' '
#                    . ( $Param{ $Prefix . 'Hour' }   || 0 ) . ':'
#                    . ( $Param{ $Prefix . 'Minute' } || 0 )
#                    . ':00',
#            );
#            $TimeStamp = $TimeStamp + ( $Self->{UserTimeZone} * 3600 );
#            (
#                $Param{ $Prefix . 'Secunde' },
#                $Param{ $Prefix . 'Minute' },
#                $Param{ $Prefix . 'Hour' },
#                $Param{ $Prefix . 'Day' },
#                $Param{ $Prefix . 'Month' },
#                $Param{ $Prefix . 'Year' }
#            ) = $Self->{UserTimeObject}->SystemTime2Date( SystemTime => $TimeStamp );
#        }

#        # KIX4OTRS-capeIT
#        my $DateValidateClasses = '';
#        if ($Validate) {
#            $DateValidateClasses
#                .= "Validate_DateDay Validate_DateYear_${Prefix}Year Validate_DateMonth_${Prefix}Month";
#            if ($ValidateDateInFuture) {
#                $DateValidateClasses .= " Validate_DateInFuture";
#            }
#        }
#        if ($SmartStyleDate) {
#            $DateValidateClasses = "Validate_DateFull";
#            if ($ValidateDateInFuture) {
#                $DateValidateClasses .= " Validate_DateFullInFuture";
#            }
#        }
#        my $DateFormat = $Self->{LanguageObject}->{DateInputFormat};
#        $DateFormat =~ s/\%D/dd/g;
#        $DateFormat =~ s/\%M/mm/g;
#        $DateFormat =~ s/\%Y/yy/g;

#        # EO KIX4OTRS-capeIT

#        # year
#        # KIX4OTRS-capeIT
#        if ($SmartStyleDate) {
#            my $Date = $Self->{LanguageObject}->FormatTimeString(
#                sprintf( "%04d", ( $Param{ $Prefix . 'Year' } || $Y ) ) .
#                    '-' .
#                    sprintf( "%02d", ( $Param{ $Prefix . 'Month' } || $M ) ) .
#                    '-' .
#                    sprintf( "%02d", ( $Param{ $Prefix . 'Day' } || $D ) ) .
#                    ' 00:00:00',
#                'DateFormatShort',
#            );
#            $Param{DateStr} = "<input type=\"text\" "
#                . ( $Validate ? "class=\"$DateValidateClasses $Class\" " : "class=\"$Class\" " )
#                . "name=\"${Prefix}Date\" id=\"${Prefix}Date\" size=\"10\" maxlength=\"10\" "
#                . "title=\""
#                . $Self->{LanguageObject}->Get('Date')
#                . "\" value=\""
#                . ( $Param{ $Prefix . 'Date' } || $Date ) . "\"/>";
#            $Param{DateStr} .= "<input type=\"hidden\" "
#                . "class=\"$Class\" "
#                . "name=\"${Prefix}Year\" id=\"${Prefix}Year\" size=\"4\" maxlength=\"4\" "
#                . "value=\""
#                . sprintf( "%04d", ( $Param{ $Prefix . 'Year' } || $Y ) ) . "\"/>";
#        }

#        #if ( $DateInputStyle eq 'Option' ) {
#        elsif ( $DateInputStyle eq 'Option' ) {

#            # EO KIX4OTRS-capeIT

#            my %Year;
#            if ( defined $Param{YearPeriodPast} && defined $Param{YearPeriodFuture} ) {
#                for ( $Y - $Param{YearPeriodPast} .. $Y + $Param{YearPeriodFuture} ) {
#                    $Year{$_} = $_;
#                }
#            }
#            else {
#                for ( $Y - 10 .. $Y + 1 + ( $Param{YearDiff} || 0 ) ) {
#                    $Year{$_} = $_;
#                }
#            }
#            $Param{Year} = $Self->BuildSelection(
#                Name                => $Prefix . 'Year',
#                Data                => \%Year,
#                SelectedID          => int( $Param{ $Prefix . 'Year' } || $Y ),
#                LanguageTranslation => 0,
#                Class               => $Validate ? 'Validate_DateYear' : '',
#                Title               => $Self->{LanguageObject}->Get('Year'),
#            );
#        }
#        else {
#            $Param{Year} = "<input type=\"text\" "
#                . ( $Validate ? "class=\"Validate_DateYear $Class\" " : "class=\"$Class\" " )
#                . "name=\"${Prefix}Year\" id=\"${Prefix}Year\" size=\"4\" maxlength=\"4\" "
#                . "title=\""
#                . $Self->{LanguageObject}->Get('Year')
#                . "\" value=\""
#                . sprintf( "%02d", ( $Param{ $Prefix . 'Year' } || $Y ) ) . "\"/>";
#        }

#        # month
#        # KIX4OTRS-capeIT
#        if ($SmartStyleDate) {
#            $Param{DateStr} .= "<input type=\"hidden\" "
#                . "class=\"$Class\" "
#                . "name=\"${Prefix}Month\" id=\"${Prefix}Month\" size=\"2\" maxlength=\"2\" "
#                . "value=\""
#                . sprintf( "%02d", ( $Param{ $Prefix . 'Month' } || $M ) ) . "\"/>";

#        }

#        #if ( $DateInputStyle eq 'Option' ) {
#        elsif ( $DateInputStyle eq 'Option' ) {

#            # EO KIX4OTRS-capeIT

#            my %Month;
#            for ( 1 .. 12 ) {
#                my $Tmp = sprintf( "%02d", $_ );
#                $Month{$_} = $Tmp;
#            }
#            $Param{Month} = $Self->BuildSelection(
#                Name                => $Prefix . 'Month',
#                Data                => \%Month,
#                SelectedID          => int( $Param{ $Prefix . 'Month' } || $M ),
#                LanguageTranslation => 0,
#                Class               => $Validate ? 'Validate_DateMonth' : '',
#                Title               => $Self->{LanguageObject}->Get('Month'),
#            );
#        }
#        else {
#            $Param{Month}
#                = "<input type=\"text\" "
#                . ( $Validate ? "class=\"Validate_DateMonth $Class\" " : "class=\"$Class\" " )
#                . "name=\"${Prefix}Month\" id=\"${Prefix}Month\" size=\"2\" maxlength=\"2\" "
#                . "title=\""
#                . $Self->{LanguageObject}->Get('Month')
#                . "\" value=\""
#                . sprintf( "%02d", ( $Param{ $Prefix . 'Month' } || $M ) ) . "\"/>";
#        }

#        # KIX4OTRS-capeIT
#        # moved content upwards
#        # EO KIX4OTRS-capeIT

#        # day
#        # KIX4OTRS-capeIT
#        if ($SmartStyleDate) {
#            $Param{DateStr} .= "<input type=\"hidden\" "
#                . "class=\"$Class\" "
#                . "name=\"${Prefix}Day\" id=\"${Prefix}Day\" size=\"2\" maxlength=\"2\" "
#                . "value=\""
#                . sprintf( "%02d", ( $Param{ $Prefix . 'Day' } || $D ) ) . "\"/>";
#        }

#        #if ( $DateInputStyle eq 'Option' ) {
#        elsif ( $DateInputStyle eq 'Option' ) {

#            # EO KIX4OTRS-capeIT

#            my %Day;
#            for ( 1 .. 31 ) {
#                my $Tmp = sprintf( "%02d", $_ );
#                $Day{$_} = $Tmp;
#            }
#            $Param{Day} = $Self->BuildSelection(
#                Name                => $Prefix . 'Day',
#                Data                => \%Day,
#                SelectedID          => int( $Param{ $Prefix . 'Day' } || $D ),
#                LanguageTranslation => 0,
#                Class               => "$DateValidateClasses $Class",
#                Title               => $Self->{LanguageObject}->Get('Day'),
#            );
#        }
#        else {
#            $Param{Day} = "<input type=\"text\" "
#                . "class=\"$DateValidateClasses $Class\" "
#                . "name=\"${Prefix}Day\" id=\"${Prefix}Day\" size=\"2\" maxlength=\"2\" "
#                . "title=\""
#                . $Self->{LanguageObject}->Get('Day')
#                . "\" value=\""
#                . sprintf( "%02d", ( $Param{ $Prefix . 'Day' } || $D ) ) . "\"/>";
#        }

#        if ( $Format eq 'DateInputFormatLong' ) {

#            # hour
#            # KIX4OTRS-capeIT
#            if ($SmartStyleTime) {
#                $h = defined( $Param{ $Prefix . 'Hour' } ) ? int( $Param{ $Prefix . 'Hour' } ) : $h;
#                $m
#                    = defined( $Param{ $Prefix . 'Minute' } )
#                    ? int( $Param{ $Prefix . 'Minute' } )
#                    : $m;

#                if ( $m != 0 && ( $m % $MinuteIntervall ) != 0 ) {
#                    my $Minute = $MinuteIntervall;
#                    while ( ( $Minute / $m ) < 1 && ( $Minute < 60 ) ) {
#                        $Minute += $MinuteIntervall;
#                    }
#                    if ( $Minute >= 60 && $h >= 23 ) {
#                        $h = 23;
#                        $m = 59;
#                    }
#                    elsif ( $Minute >= 60 ) {
#                        $h = $h + 1;
#                        $m = 0;
#                    }
#                    else {
#                        $m = $Minute;
#                    }
#                }
#                $h = sprintf( "%02d", $h );
#                $m = sprintf( "%02d", $m );

#                my %TimeDef = (
#                    '23:59' => '23:59',
#                );
#                my $HourParts = 60 / $MinuteIntervall - 1;
#                for my $CurrHour ( 0 .. 23 ) {
#                    for my $CurrPart ( 0 .. $HourParts ) {
#                        my $Tmp
#                            = sprintf( "%02d:%02d", $CurrHour, ( $MinuteIntervall * $CurrPart ) );
#                        $TimeDef{$Tmp} = $Tmp;
#                    }
#                }

#                $Param{TimeStr} = $Self->BuildSelection(
#                    Name                => $Prefix . 'Time',
#                    Data                => \%TimeDef,
#                    SelectedID          => $h . ':' . $m,
#                    LanguageTranslation => 0,
#                    Class               => $Validate ? ( 'Validate_DateTime ' . $Class ) : $Class,
#                    Title               => $Self->{LanguageObject}->Get('Time'),
#                );

#                $Param{TimeStr} .= "<input type=\"hidden\" "
#                    . ( $Validate ? "class=\"Validate_DateHour $Class\" " : "class=\"$Class\" " )
#                    . "name=\"${Prefix}Hour\" id=\"${Prefix}Hour\" size=\"2\" maxlength=\"2\" "
#                    . "value=\""
#                    . $h
#                    . "\"/>";
#            }

#            #if ( $DateInputStyle eq 'Option' ) {
#            elsif ( $DateInputStyle eq 'Option' ) {

#                # EO KIX4OTRS-capeIT

#                my %Hour;
#                for ( 0 .. 23 ) {
#                    my $Tmp = sprintf( "%02d", $_ );
#                    $Hour{$_} = $Tmp;
#                }
#                $Param{Hour} = $Self->BuildSelection(
#                    Name       => $Prefix . 'Hour',
#                    Data       => \%Hour,
#                    SelectedID => defined( $Param{ $Prefix . 'Hour' } )
#                    ? int( $Param{ $Prefix . 'Hour' } )
#                    : int($h),
#                    LanguageTranslation => 0,
#                    Class               => $Validate ? ( 'Validate_DateHour ' . $Class ) : $Class,
#                    Title               => $Self->{LanguageObject}->Get('Hours'),
#                );
#            }
#            else {
#                $Param{Hour} = "<input type=\"text\" "
#                    . ( $Validate ? "class=\"Validate_DateHour $Class\" " : "class=\"$Class\" " )
#                    . "name=\"${Prefix}Hour\" id=\"${Prefix}Hour\" size=\"2\" maxlength=\"2\" "
#                    . "title=\""
#                    . $Self->{LanguageObject}->Get('Hours')
#                    . "\" value=\""
#                    . sprintf(
#                    "%02d",
#                    (
#                        defined( $Param{ $Prefix . 'Hour' } )
#                        ? int( $Param{ $Prefix . 'Hour' } )
#                        : $h
#                        )
#                    )
#                    . "\"/>";
#            }

#            # minute
#            # KIX4OTRS-capeIT
#            if ($SmartStyleTime) {
#                $Param{TimeStr} .= "<input type=\"hidden\" "
#                    . ( $Validate ? "class=\"Validate_DateMinute $Class\" " : "class=\"$Class\" " )
#                    . "name=\"${Prefix}Minute\" id=\"${Prefix}Minute\" size=\"2\" maxlength=\"2\" "
#                    . " value=\""
#                    . $m
#                    . "\"/>";
#            }

#            #if ( $DateInputStyle eq 'Option' ) {
#            elsif ( $DateInputStyle eq 'Option' ) {

#                # EO KIX4OTRS-capeIT

#                my %Minute;
#                for ( 0 .. 59 ) {
#                    my $Tmp = sprintf( "%02d", $_ );
#                    $Minute{$_} = $Tmp;
#                }
#                $Param{Minute} = $Self->BuildSelection(
#                    Name       => $Prefix . 'Minute',
#                    Data       => \%Minute,
#                    SelectedID => defined( $Param{ $Prefix . 'Minute' } )
#                    ? int( $Param{ $Prefix . 'Minute' } )
#                    : int($m),
#                    LanguageTranslation => 0,
#                    Class               => $Validate ? ( 'Validate_DateMinute ' . $Class ) : $Class,
#                    Title               => $Self->{LanguageObject}->Get('Minutes'),
#                );
#            }
#            else {
#                $Param{Minute} = "<input type=\"text\" "
#                    . ( $Validate ? "class=\"Validate_DateMinute $Class\" " : "class=\"$Class\" " )
#                    . "name=\"${Prefix}Minute\" id=\"${Prefix}Minute\" size=\"2\" maxlength=\"2\" "
#                    . "title=\""
#                    . $Self->{LanguageObject}->Get('Minutes')
#                    . "\" value=\""
#                    . sprintf(
#                    "%02d",
#                    (
#                        defined( $Param{ $Prefix . 'Minute' } )
#                        ? int( $Param{ $Prefix . 'Minute' } )
#                        : $m
#                        )
#                    ) . "\"/>";
#            }
#        }

#        # Get first day of the week
#        my $WeekDayStart = $Kernel::OM->Get('Kernel::Config')->Get('CalendarWeekDayStart') || 1;

#     	# KIX4OTRS-capeIT
#     	# meta-characters must be escaped with two backslashes (such as !"#$%&'()*+,./:;<=>?@[\]^`{|}~)
#        $Prefix =~ s/([\.,;:\+\*[\]\]\(\)<=>])/\\\\$1/g;

#        # EO KIX4OTRS-capeIT

#        # Datepicker
#        $DatepickerHTML
#            = '<!--dtl:js_on_document_complete--><script type="text/javascript">//<![CDATA[
#        Core.UI.Datepicker.Init({
#            // KIX4OTRS-capeIT
#            Date: $(\'#' . $Prefix . 'Date\'),
#            Time: $(\'#' . $Prefix . 'Time\'),
#            Format: \'' . $DateFormat . '\',
#            // EO KIX4OTRS-capeIT

#            Day: $(\'#' . $Prefix . 'Day\'),
#            Month: $(\'#' . $Prefix . 'Month\'),
#            Year: $(\'#' . $Prefix . 'Year\'),
#            Hour: $(\'#' . $Prefix . 'Hour\'),
#            Minute: $(\'#' . $Prefix . 'Minute\'),
#            DateInFuture: ' . ( $ValidateDateInFuture ? 'true' : 'false' ) . ',
#            WeekDayStart: ' . $WeekDayStart . '
#        });
#    //]]></script>
#    <!--dtl:js_on_document_complete-->';

#        my $Output;

#        # optional checkbox
#        if ($Optional) {
#            my $Checked       = '';
#            my $ValidateClass = '';
#            if ($Used) {
#                $Checked = ' checked="checked"';
#            }
#            if ($Required) {
#                $ValidateClass = ' class="Validate_Required"';
#            }
#            $Output .= "<input type=\"checkbox\" name=\""
#                . $Prefix
#                . "Used\" id=\"" . $Prefix . "Used\" value=\"1\""
#                . $Checked
#                . $ValidateClass
#                . " title=\""
#                . $Self->{LanguageObject}->Get('Check to activate this date')
#                . "\" />&nbsp;";
#        }

#        # date format
#        # KIX4OTRS-capeIT
#        if ($SmartStyleDate) {
#            $Output .= $Param{DateStr};
#            if ( $Param{TimeStr} || $Param{Hour} ) {
#                $Output .= ' - ';
#                $Output .= $Param{TimeStr} || ( $Param{Hour} . ':' . $Param{Minute} );
#            }
#        }
#        else {

#            # EO KIX4OTRS-capeIT
#            $Output .= $Self->{LanguageObject}->Time(
#                Action => 'Return',
#                Format => 'DateInputFormat',
#                Mode   => 'NotNumeric',
#                %Param,
#            );

#            # KIX4OTRS-capeIT
#        }

#        # EO KIX4OTRS-capeIT

#        # add Datepicker HTML to output
#        $Output .= $DatepickerHTML;

#        # set global var to true to add a block to the footer later
#        $Self->{HasDatepicker} = 1;

#        return $Output;
#    }

    # overwrite sub AgentFreeText from LayoutTicket.pm to provide translations
#    sub Kernel::Output::HTML::Layout::AgentFreeText {
#        my ( $Self, %Param ) = @_;

#        my %NullOption;
#        my %SelectData;
#        my %Ticket;
#        my %Config;
#        my $Class = '';
#        if ( $Param{NullOption} ) {

#            #        $NullOption{''} = '-';
#            $SelectData{Size}     = 3;
#            $SelectData{Multiple} = 1;
#        }
#        if ( $Param{Ticket} ) {
#            %Ticket = %{ $Param{Ticket} };
#        }
#        if ( $Param{Config} ) {
#            %Config = %{ $Param{Config} };
#        }
#        if ( $Param{Class} ) {
#            $Class = $Param{Class};
#        }
#        my %Data;

#        # KIX4OTRS-capeIT
#        my $KeyTranslation = $Kernel::OM->Get('Kernel::Config')->Get('TicketFreeKey::LanguageTranslation')
#            || 0;
#        my $TextTranslation = $Kernel::OM->Get('Kernel::Config')->Get('TicketFreeText::LanguageTranslation')
#            || 0;

#        if ( $Param{PossibleNone} ) {
#            $SelectData{PossibleNone} = 1;
#        }

##        my $TicketFreeTextCount = $Self->{TicketObject}->GetTicketFreeTextCount();
#        my $TicketFreeTextCount = 0;
#        for ( 1 .. $TicketFreeTextCount ) {

#            # EO KIX4OTRS-capeIT

#            # key
#            if ( ref $Config{"TicketFreeKey$_"} eq 'HASH' && %{ $Config{"TicketFreeKey$_"} } ) {
#                my $Counter = 0;
#                my $LastKey = '';
#                for ( keys %{ $Config{"TicketFreeKey$_"} } ) {
#                    $Counter++;
#                    $LastKey = $_;
#                }
#                if ( $Counter == 1 && $Param{NullOption} ) {
#                    if ($LastKey) {

#                        # KIX4OTRS-capeIT
#                        if ($KeyTranslation) {
#                            $Config{"TicketFreeKey$_"}->{$LastKey} =
#                                $Self->{LanguageObject}
#                                ->Get( $Config{"TicketFreeKey$_"}->{$LastKey} );
#                        }

#                        # EO KIX4OTRS-capeIT

#                        $Data{"TicketFreeKeyField$_"} = $Config{"TicketFreeKey$_"}->{$LastKey};
#                    }
#                }
#                elsif ( $Counter > 1 ) {
#                    $Data{"TicketFreeKeyField$_"} = $Self->BuildSelection(
#                        Data => { %NullOption, %{ $Config{"TicketFreeKey$_"} }, },
#                        Name => "TicketFreeKey$_",
#                        SelectedID => $Ticket{"TicketFreeKey$_"},

#                        # KIX4OTRS-capeIT
#                        #Translation => 0,
#                        Translation => $KeyTranslation,

#                        # EO KIX4OTRS-capeIT

#                        Class     => 'TicketFreeKey',
#                        HTMLQuote => 1,
#                        %SelectData,
#                    );
#                }
#                else {
#                    if ($LastKey) {

#                        # KIX4OTRS-capeIT
#                        if ($KeyTranslation) {
#                            $Config{"TicketFreeKey$_"}->{$LastKey} =
#                                $Self->{LanguageObject}
#                                ->Get( $Config{"TicketFreeKey$_"}->{$LastKey} );
#                        }

#                        # EO KIX4OTRS-capeIT

#                        $Data{"TicketFreeKeyField$_"}
#                            = $Config{"TicketFreeKey$_"}->{$LastKey}
#                            . '<input type="hidden" name="TicketFreeKey'
#                            . $_
#                            . '" value="'
#                            . $Self->Ascii2Html( Text => $LastKey ) . '"/>';
#                    }
#                }
#            }
#            else {
#                if ( defined $Ticket{"TicketFreeKey$_"} ) {
#                    if ( ref $Ticket{"TicketFreeKey$_"} eq 'ARRAY' ) {
#                        if ( $Ticket{"TicketFreeKey$_"}->[0] ) {
#                            $Ticket{"TicketFreeKey$_"} = $Ticket{"TicketFreeKey$_"}->[0];
#                        }
#                        else {
#                            $Ticket{"TicketFreeKey$_"} = '';
#                        }
#                    }

#                    # KIX4OTRS-capeIT
#                    if ($KeyTranslation) {
#                        $Ticket{"TicketFreeKey$_"} =
#                            $Self->{LanguageObject}->Get( $Ticket{"TicketFreeKey$_"} );
#                    }

#                    # EO KIX4OTRS-capeIT

#                    $Data{"TicketFreeKeyField$_"}
#                        = '<input type="text" class="TicketFreeKey" name="TicketFreeKey'
#                        . $_
#                        . '" value="'
#                        . $Self->Ascii2Html( Text => $Ticket{"TicketFreeKey$_"} )
#                        . '" />';
#                }
#                else {
#                    $Data{"TicketFreeKeyField$_"}
#                        = '<input type="text" class="TicketFreeKey" name="TicketFreeKey' . $_
#                        . '" value="" />';
#                }
#            }

#            # Add Validate and Error classes
#            my $ClassParam = "$Class ";
#            my $DataParam  = "";
#            if ( $Config{"Required"}->{$_} ) {
#                $ClassParam .= 'Validate_Required';
#                if ( ref $Config{"TicketFreeText$_"} eq 'HASH' ) {
#                    $ClassParam .= 'Dropdown';
#                }
#                $ClassParam .= ' ';

#                $DataParam
#                    .= '<div id="TicketFreeText'
#                    . $_
#                    . 'Error" class="TooltipErrorMessage"><p>$Text{"This field is required."}</p></div>';

#                # for TicketFreeKeyFields
#                $Data{"TicketFreeKeyField$_"} =
#                    '<label id="LabelTicketFreeText' . $_
#                    . '" class="Mandatory"><span class="Marker">*</span> '
#                    . $Data{"TicketFreeKeyField$_"}
#                    . ':</label>';
#            }
#            else {

#                # for TicketFreeKeyFields
#                $Data{"TicketFreeKeyField$_"} =
#                    '<label id="LabelTicketFreeText' . $_ . '">'
#                    . $Data{"TicketFreeKeyField$_"}
#                    . ':</label>';
#            }

#            if ( $Config{"Error"}->{$_} ) {
#                $ClassParam .= 'ServerError ';
#                $DataParam
#                    .= '<div id="TicketFreeText'
#                    . $_
#                    . 'ServerError" class="TooltipErrorMessage"><p>$Text{"This field is required."}</p></div>';
#            }

#            # value
#            if ( ref $Config{"TicketFreeText$_"} eq 'HASH' ) {
#                $Data{"TicketFreeTextField$_"} = $Self->BuildSelection(
#                    Data => { %NullOption, %{ $Config{"TicketFreeText$_"} }, },
#                    Name => "TicketFreeText$_",
#                    SelectedID => $Ticket{"TicketFreeText$_"},

#                    # KIX4OTRS-capeIT
#                    #Translation => 0,
#                    Translation => $TextTranslation,

#                    # EO KIX4OTRS-capeIT

#                    HTMLQuote => 1,
#                    Class     => "TicketFreeText $ClassParam",
#                    %SelectData,
#                );

#                $Data{"TicketFreeTextField$_"} .= $DataParam;

#            }
#            else {
#                if ( defined $Ticket{"TicketFreeText$_"} ) {
#                    if ( ref $Ticket{"TicketFreeText$_"} eq 'ARRAY' ) {
#                        if ( $Ticket{"TicketFreeText$_"}->[0] ) {
#                            $Ticket{"TicketFreeText$_"} = $Ticket{"TicketFreeText$_"}->[0];
#                        }
#                        else {
#                            $Ticket{"TicketFreeText$_"} = '';
#                        }
#                    }

#                    # KIX4OTRS-capeIT
#                    if ($TextTranslation) {
#                        $Ticket{"TicketFreeText$_"} =
#                            $Self->{LanguageObject}->Get( $Ticket{"TicketFreeText$_"} );
#                    }

#                    # EO KIX4OTRS-capeIT

#                    $Data{"TicketFreeTextField$_"}
#                        = '<input type="text" class="TicketFreeText '
#                        . $ClassParam
#                        . '" name="TicketFreeText'
#                        . $_
#                        . '" id="TicketFreeText'
#                        . $_
#                        . '" value="'
#                        . $Self->Ascii2Html( Text => $Ticket{"TicketFreeText$_"} )
#                        . '" />';

#                    $Data{"TicketFreeTextField$_"} .= $DataParam;

#                }
#                else {
#                    $Data{"TicketFreeTextField$_"}
#                        = '<input type="text" class="TicketFreeText ' . $ClassParam
#                        . '" name="TicketFreeText'
#                        . $_
#                        . '" id="TicketFreeText'
#                        . $_
#                        . '" value="" />';

#                    $Data{"TicketFreeTextField$_"} .= $DataParam;
#                }
#            }
#        }
#        return %Data;
#    }

    # overwrite sub AgentFreeDate from LayoutTicket.pm to provide translations
#    sub Kernel::Output::HTML::Layout::AgentFreeDate {
#        my ( $Self, %Param ) = @_;

#        my %NullOption;
#        my %SelectData;
#        my %Ticket;
#        my %Config;
#        my $Class = '';
#        if ( $Param{NullOption} ) {
#            $SelectData{Size}     = 3;
#            $SelectData{Multiple} = 1;
#        }
#        if ( $Param{Ticket} ) {
#            %Ticket = %{ $Param{Ticket} };
#        }
#        if ( $Param{Config} ) {
#            %Config = %{ $Param{Config} };
#        }
#        if ( $Param{Class} ) {
#            $Class = $Param{Class};
#        }
#        my %Data;

#        # KIX4OTRS-capeIT
#        my $Translation = $Kernel::OM->Get('Kernel::Config')->Get('TicketFreeTime::LanguageTranslation')
#            || 0;

#        # EO KIX4OTRS-capeIT

#        for my $Count ( 1 .. 6 ) {
#            my %TimePeriod;
#            if ( $Kernel::OM->Get('Kernel::Config')->Get( 'TicketFreeTimePeriod' . $Count ) ) {
#                %TimePeriod
#                    = %{ $Kernel::OM->Get('Kernel::Config')->Get( 'TicketFreeTimePeriod' . $Count ) };
#            }

#            $Data{ 'TicketFreeTime' . $Count } = $Self->BuildDateSelection(
#                %Param,
#                %Ticket,
#                Prefix                              => 'TicketFreeTime' . $Count,
#                Format                              => 'DateInputFormatLong',
#                'TicketFreeTime' . $Count . 'Class' => $Class,
#                DiffTime => $Kernel::OM->Get('Kernel::Config')->Get( 'TicketFreeTimeDiff' . $Count ) || 0,
#                %TimePeriod,
#                Validate => 1,
#                Required => $Param{'Ticket'}->{ 'TicketFreeTime' . $Count . 'Required' } ? 1 : 0,
#            );

#            # KIX4OTRS-capeIT
#            # use translation according to SysConfig
#            my $TicketFreeTimeKeyName
#                = $Kernel::OM->Get('Kernel::Config')->Get( 'TicketFreeTimeKey' . $Count );
#            if ($Translation) {
#                $TicketFreeTimeKeyName = $Self->{LanguageObject}->Get($TicketFreeTimeKeyName);
#            }

#            # EO KIX4OTRS-capeIT

#            if ( $Param{'Ticket'}->{ 'TicketFreeTime' . $Count . 'Required' } ) {
#                $Data{ 'TicketFreeTimeKey' . $Count } =
#                    '<label class="Mandatory" id="LabelTicketFreeTime'
#                    . $Count
#                    . '"'
#                    . ' for="TicketFreeTime'
#                    . $Count
#                    . 'Used">'
#                    . '<span class="Marker">*</span> '

#                    # KIX4OTRS-capeIT
#                    #. $Kernel::OM->Get('Kernel::Config')->Get( 'TicketFreeTimeKey' . $Count )
#                    . $TicketFreeTimeKeyName

#                    # EO KIX4OTRS-capeIT
#                    . ':</label>';
#            }
#            else {
#                $Data{ 'TicketFreeTimeKey' . $Count } =
#                    '<label id="LabelTicketFreeTime'
#                    . $Count
#                    . '"'
#                    . ' for="TicketFreeTime'
#                    . $Count
#                    . 'Used">'

#                    # KIX4OTRS-capeIT
#                    #. $Kernel::OM->Get('Kernel::Config')->Get( 'TicketFreeTimeKey' . $Count )
#                    . $TicketFreeTimeKeyName

#                    # EO KIX4OTRS-capeIT
#                    . ':</label>';
#            }
#        }
#        return %Data;
#    }

    # overwrite sub TicketArticleFreeText from LayoutTicket.pm to provide translations
#    sub Kernel::Output::HTML::Layout::TicketArticleFreeText {
#        my ( $Self, %Param ) = @_;

#        my %NullOption;
#        my %SelectData;
#        my %Article;
#        my %Config;
#        my $Class = '';
#        if ( $Param{NullOption} ) {
#            $SelectData{Size}     = 3;
#            $SelectData{Multiple} = 1;
#        }
#        if ( $Param{Article} ) {
#            %Article = %{ $Param{Article} };
#        }
#        if ( $Param{Config} ) {
#            %Config = %{ $Param{Config} };
#        }
#        if ( $Param{Class} ) {
#            $Class = $Param{Class};
#        }
#        my %Data;

#        # KIX4OTRS-capeIT
#        my $KeyTranslation = $Kernel::OM->Get('Kernel::Config')->Get('ArticleFreeKey::LanguageTranslation')
#            || 0;
#        my $TextTranslation = $Kernel::OM->Get('Kernel::Config')->Get('ArticleFreeText::LanguageTranslation')
#            || 0;

#        # EO KIX4OTRS-capeIT

#        for ( 1 .. 3 ) {

#            # key
#            if ( ref $Config{"ArticleFreeKey$_"} eq 'HASH' && %{ $Config{"ArticleFreeKey$_"} } )
#            {
#                my $Counter = 0;
#                my $LastKey = '';
#                for ( keys %{ $Config{"ArticleFreeKey$_"} } ) {
#                    $Counter++;
#                    $LastKey = $_;
#                }
#                if ( $Counter == 1 && $Param{NullOption} ) {
#                    if ($LastKey) {
#                        $Data{"ArticleFreeKeyField$_"}
#                            = $Config{"ArticleFreeKey$_"}->{$LastKey};
#                    }
#                }
#                elsif ( $Counter > 1 ) {
#                    $Data{"ArticleFreeKeyField$_"} = $Self->BuildSelection(
#                        Data => { %NullOption, %{ $Config{"ArticleFreeKey$_"} }, },
#                        Name => "ArticleFreeKey$_",
#                        SelectedID => $Article{"ArticleFreeKey$_"},

#                        # KIX4OTRS-capeIT
#                        #Translation => 0,
#                        Translation => $KeyTranslation,

#                        # EO KIX4OTRS-capeIT

#                        Class     => 'ArticleFreeKey',
#                        HTMLQuote => 1,
#                        %SelectData,
#                    );
#                }
#                else {
#                    if ($LastKey) {

#                        # KIX4OTRS-capeIT
#                        if ($KeyTranslation) {
#                            $Config{"ArticleFreeKey$_"}->{$LastKey} =
#                                $Self->{LanguageObject}
#                                ->Get( $Config{"ArticleFreeKey$_"}->{$LastKey} );
#                        }

#                        # EO KIX4OTRS-capeIT

#                        $Data{"ArticleFreeKeyField$_"}
#                            = $Config{"ArticleFreeKey$_"}->{$LastKey}
#                            . '<input type="hidden" name="ArticleFreeKey'
#                            . $_
#                            . '" value="'
#                            . $Self->Ascii2Html( Text => $LastKey ) . '"/>';
#                    }
#                }
#            }
#            else {
#                if ( defined $Article{"ArticleFreeKey$_"} ) {
#                    if ( ref $Article{"ArticleFreeKey$_"} eq 'ARRAY' ) {
#                        if ( $Article{"ArticleFreeKey$_"}->[0] ) {
#                            $Article{"ArticleFreeKey$_"} = $Article{"ArticleFreeKey$_"}->[0];
#                        }
#                        else {
#                            $Article{"ArticleFreeKey$_"} = '';
#                        }
#                    }

#                    # KIX4OTRS-capeIT
#                    if ($KeyTranslation) {
#                        $Article{"ArticleFreeKey$_"} =
#                            $Self->{LanguageObject}->Get( $Article{"ArticleFreeKey$_"} );
#                    }

#                    # EO KIX4OTRS-capeIT

#                    $Data{"ArticleFreeKeyField$_"}
#                        = '<input type="text" class="ArticleFreeKey" name="ArticleFreeKey'
#                        . $_
#                        . '" value="'
#                        . $Self->Ascii2Html( Text => $Article{"ArticleFreeKey$_"} )
#                        . '" />';
#                }
#                else {
#                    $Data{"ArticleFreeKeyField$_"}
#                        = '<input type="text" class="ArticleFreeKey" name="ArticleFreeKey' . $_
#                        . '" value="" />';
#                }
#            }

#            # Add Validate and Error classes
#            my $ClassParam = "$Class ";
#            my $DataParam  = "";
#            if ( $Config{"Required"}->{$_} ) {
#                $ClassParam .= 'Validate_Required';
#                if ( ref $Config{"ArticleFreeText$_"} eq 'HASH' ) {
#                    $ClassParam .= 'Dropdown';
#                }
#                $ClassParam .= ' ';

#                $DataParam
#                    .= '<div id="ArticleFreeText'
#                    . $_
#                    . 'Error" class="TooltipErrorMessage"><p>$Text{"This field is required."}</p></div>';

#                # for ArticleFreeKeyField
#                $Data{"ArticleFreeKeyField$_"} =
#                    '<label id="LabelArticleFreeText' . $_
#                    . '" class="Mandatory"><span class="Marker">*</span> '
#                    . $Data{"ArticleFreeKeyField$_"}
#                    . ':</label>';
#            }
#            else {

#                # for ArticleFreeKeyField
#                $Data{"ArticleFreeKeyField$_"} =
#                    '<label id="LabelArticleFreeText' . $_ . '">'
#                    . $Data{"ArticleFreeKeyField$_"}
#                    . ':</label>';
#            }

#            if ( $Config{"Error"}->{$_} ) {
#                $ClassParam .= 'ServerError ';
#                $DataParam
#                    .= '<div id="ArticleFreeText'
#                    . $_
#                    . 'ServerError" class="TooltipErrorMessage"><p>$Text{"This field is required."}</p></div>';
#            }

#            # value
#            if ( ref $Config{"ArticleFreeText$_"} eq 'HASH' ) {
#                $Data{"ArticleFreeTextField$_"} = $Self->BuildSelection(
#                    Data => { %NullOption, %{ $Config{"ArticleFreeText$_"} }, },
#                    Name => "ArticleFreeText$_",
#                    SelectedID => $Article{"ArticleFreeText$_"},

#                    # KIX4OTRS-capeIT
#                    #Translation => 0,
#                    Translation => $TextTranslation,

#                    # EO KIX4OTRS-capeIT

#                    HTMLQuote => 1,
#                    Class     => "ArticleFreeText $ClassParam",
#                    %SelectData,
#                );

#                $Data{"ArticleFreeTextField$_"} .= $DataParam;
#            }
#            else {
#                if ( defined $Article{"ArticleFreeText$_"} ) {
#                    if ( ref $Article{"ArticleFreeText$_"} eq 'ARRAY' ) {
#                        if ( $Article{"ArticleFreeText$_"}->[0] ) {
#                            $Article{"ArticleFreeText$_"} = $Article{"ArticleFreeText$_"}->[0];
#                        }
#                        else {
#                            $Article{"ArticleFreeText$_"} = '';
#                        }
#                    }

#                    # KIX4OTRS-capeIT
#                    if ($TextTranslation) {
#                        $Article{"ArticleFreeText$_"} =
#                            $Self->{LanguageObject}->Get( $Article{"ArticleFreeText$_"} );
#                    }

#                    # EO KIX4OTRS-capeIT

#                    $Data{"ArticleFreeTextField$_"}
#                        = '<input type="text" class="ArticleFreeText '
#                        . $ClassParam
#                        . '" name="ArticleFreeText'
#                        . $_
#                        . '" id="ArticleFreeText'
#                        . $_
#                        . '" value="'
#                        . $Self->Ascii2Html( Text => $Article{"ArticleFreeText$_"} )
#                        . '" />';

#                    $Data{"ArticleFreeTextField$_"} .= $DataParam;
#                }
#                else {
#                    $Data{"ArticleFreeTextField$_"}
#                        = '<input type="text" class="ArticleFreeText ' . $ClassParam
#                        . '" name="ArticleFreeText'
#                        . $_
#                        . '" id="ArticleFreeText'
#                        . $_
#                        . '" value="" />';

#                    $Data{"ArticleFreeTextField$_"} .= $DataParam;
#                }
#            }
#        }
#        return %Data;
#    }

    # overwrite sub CustomerFreeDate from LayoutTicket.pm to provide translations
#    sub Kernel::Output::HTML::Layout::CustomerFreeDate {
#        my ( $Self, %Param ) = @_;

#        my %NullOption;
#        my %SelectData;
#        my %Ticket;
#        my %Config;
#        if ( $Param{NullOption} ) {
#            $SelectData{Size}     = 3;
#            $SelectData{Multiple} = 1;
#        }
#        if ( $Param{Ticket} ) {
#            %Ticket = %{ $Param{Ticket} };
#        }
#        if ( $Param{Config} ) {
#            %Config = %{ $Param{Config} };
#        }
#        my %Data;
#        for my $Count ( 1 .. 6 ) {
#            my %TimePeriod;
#            if ( $Kernel::OM->Get('Kernel::Config')->Get( 'TicketFreeTimePeriod' . $Count ) ) {
#                %TimePeriod
#                    = %{ $Kernel::OM->Get('Kernel::Config')->Get( 'TicketFreeTimePeriod' . $Count ) };
#            }

#            $Data{ 'TicketFreeTime' . $Count } = $Self->BuildDateSelection(
#                Area => 'Customer',
#                %Param,
#                %Ticket,
#                Prefix   => 'TicketFreeTime' . $Count,
#                Format   => 'DateInputFormatLong',
#                DiffTime => $Kernel::OM->Get('Kernel::Config')->Get( 'TicketFreeTimeDiff' . $Count ) || 0,
#                "TicketFreeTime${Count}Class" => 'DateSelection',
#                %TimePeriod,
#                Validate => 1,
#                Required => $Param{'Ticket'}->{ 'TicketFreeTime' . $Count . 'Required' } ? 1 : 0,
#            );

#            # KIX4OTRS-capeIT
#            # use translation according to SysConfig
#            my $CurrLabelText =
#                $Kernel::OM->Get('Kernel::Config')->Get('TicketFreeTime::LanguageTranslation')
#                ? $Self->{LanguageObject}
#                ->Get( $Kernel::OM->Get('Kernel::Config')->Get( 'TicketFreeTimeKey' . $Count ) )
#                : $Kernel::OM->Get('Kernel::Config')->Get( 'TicketFreeTimeKey' . $Count );

#            # EO KIX4OTRS-capeIT

#            if ( $Param{'Ticket'}->{ 'TicketFreeTime' . $Count . 'Required' } ) {
#                $Data{ 'TicketFreeTimeKey' . $Count } =
#                    '<label class="Mandatory" id="LabelTicketFreeTime'
#                    . $Count
#                    . '" for="TicketFreeTime'
#                    . $Count
#                    . 'Used">'
#                    . '<span class="Marker">*</span> '

#                    # KIX4OTRS-capeIT
#                    #. $Kernel::OM->Get('Kernel::Config')->Get( 'TicketFreeTimeKey' . $Count )
#                    . $CurrLabelText

#                    # EO KIX4OTRS-capeIT
#                    . ':</label>';
#            }
#            else {
#                $Data{ 'TicketFreeTimeKey' . $Count } =
#                    '<label id="LabelTicketFreeTime'
#                    . $Count
#                    . '" for="TicketFreeTime'
#                    . $Count
#                    . 'Used">'

#                    # KIX4OTRS-capeIT
#                    #. $Kernel::OM->Get('Kernel::Config')->Get( 'TicketFreeTimeKey' . $Count )
#                    . $CurrLabelText

#                    # EO KIX4OTRS-capeIT
#                    . ':</label>';
#            }
#        }
#        return %Data;
#    }

    # overwrite sub AgentCustomerViewTable from LayoutTicket.pm to use CustomerUserInfoString
    sub Kernel::Output::HTML::Layout::AgentCustomerViewTable {
        my ( $Self, %Param ) = @_;

        # check customer params
        if ( ref $Param{Data} ne 'HASH' ) {
            $Self->FatalError( Message => 'Need Hash ref in Data param' );
        }
        elsif ( ref $Param{Data} eq 'HASH' && !%{ $Param{Data} } ) {
            return $Self->{LanguageObject}->Translate('none');
        }

        # add ticket params if given
        if ( $Param{Ticket} ) {
            %{ $Param{Data} } = ( %{ $Param{Data} }, %{ $Param{Ticket} } );
        }

        my @MapNew;
        my $Map = $Param{Data}->{Config}->{Map};
        if ($Map) {
            @MapNew = ( @{$Map} );
        }

        # check if customer company support is enabled
        if ( $Param{Data}->{Config}->{CustomerCompanySupport} ) {
            my $Map2 = $Param{Data}->{CompanyConfig}->{Map};
            if ($Map2) {
                push( @MapNew, @{$Map2} );
            }
        }

        my $ShownType = 1;
        if ( $Param{Type} && $Param{Type} eq 'Lite' ) {
            $ShownType = 2;

            # check if min one lite view item is configured, if not, use
            # the normal view also
            my $Used = 0;
            for my $Field (@MapNew) {
                if ( $Field->[3] == 2 ) {
                    $Used = 1;
                }
            }
            if ( !$Used ) {
                $ShownType = 1;
            }
        }

        # build html table
        $Self->Block(
            Name => 'Customer',
            Data => $Param{Data},
        );

        # check Frontend::CustomerUser::Image
        my $CustomerImage = $Kernel::OM->Get('Kernel::Config')->Get('Frontend::CustomerUser::Image');
        if ($CustomerImage) {
            my %Modules = %{$CustomerImage};
            for my $Module ( sort keys %Modules ) {
                if ( !$Kernel::OM->Get('Kernel::System::Main')->Require( $Modules{$Module}->{Module} ) ) {
                    $Self->FatalDie();
                }

                my $Object = $Modules{$Module}->{Module}->new(
                    %{$Self},
                    LayoutObject => $Self,
                );

                # run module
                next if !$Object;

                $Object->Run(
                    Config => $Modules{$Module},
                    Data   => $Param{Data},
                );
            }
        }

        # use CustomerInfoString
        my $CustomerInfoString = $Param{Data}->{Config}->{CustomerInfoString}
            || $Kernel::OM->Get('Kernel::Config')->Get('DefaultCustomerInfoString');
        my $CustomerData = $Param{Data};
        if ($CustomerInfoString) {

            while ( $CustomerInfoString =~ /\$CustomerData\-\>\{(.+?)}/ ) {
                my $Tag = $1;
                if ( $CustomerData->{$Tag} ) {
                    $CustomerInfoString =~ s/\$CustomerData\-\>\{$Tag\}/$CustomerData->{$Tag}/;
                }
                else {
                    $CustomerInfoString =~ s/\$CustomerData\-\>\{$Tag\}//;
                }
            }

            $Param{CustomerInfoString} = $CustomerInfoString;

            $Self->Block(
                Name => 'CustomerInfoString',
                Data => \%Param,
            );

        }
        else {

            # build table
            for my $Field (@MapNew) {
                if ( $Field->[3] && $Field->[3] >= $ShownType && $Param{Data}->{ $Field->[0] } ) {
                    my %Record = (
                        %{ $Param{Data} },
                        Key   => $Field->[1],
                        Value => $Param{Data}->{ $Field->[0] },
                    );
                    if ( $Field->[6] ) {
                        $Record{LinkStart} = "<a href=\"$Field->[6]\"";
                        if ( $Field->[8] ) {
                            $Record{LinkStart} .= " target=\"$Field->[8]\"";
                        }
                        $Record{LinkStart} .= "\">";
                        $Record{LinkStop} = "</a>";
                    }
                    if ( $Field->[0] ) {
                        $Record{ValueShort} = $Self->Ascii2Html(
                            Text => $Record{Value},
                            Max  => $Param{Max}
                        );
                    }
                    $Self->Block(
                        Name => 'CustomerRow',
                        Data => \%Record,
                    );
                }
            }
        }

        # check Frontend::CustomerUser::Item
        my $CustomerItem      = $Kernel::OM->Get('Kernel::Config')->Get('Frontend::CustomerUser::Item');
        my $CustomerItemCount = 0;
        if ($CustomerItem) {
            $Self->Block(
                Name => 'CustomerItem',
            );
            my %Modules = %{$CustomerItem};
            for my $Module ( sort keys %Modules ) {
                if ( !$Kernel::OM->Get('Kernel::System::Main')->Require( $Modules{$Module}->{Module} ) ) {
                    $Self->FatalDie();
                }
                
                my $Object = $Modules{$Module}->{Module}->new(
                    %{$Self},
                    LayoutObject => $Self,
                );

                # run module
                next if !$Object;

                my $Run = $Object->Run(
                    Config          => $Modules{$Module},
                    Data            => $Param{Data},
                    CallingAction   => $Param{CallingAction}
                );
                
                next if !$Run;

                $CustomerItemCount++;
            }
        }

        # Acivity Index: History
        # CTI
        # vCard
        # Bugzilla Status
        # create & return output

        # KIX4OTRS-capeIT
        #return $Self->Output( TemplateFile => 'AgentCustomerTableView', Data => \%Param );
        return $Self->Output(
            TemplateFile   => 'AgentCustomerTableView',
            Data           => \%Param,
            KeepScriptTags => $Param{Data}->{AJAX} || 0,
        );

        # EO KIX4OTRS-capeIT
    }

#    sub Kernel::Output::HTML::Layout::_BuildSelectionOutput {
#        my ( $Self, %Param ) = @_;

#        my $String;
#        my $Name = $Param{Name} || '';

#        # start generation, if AttributeRef and DataRef was found
#        if ( $Param{AttributeRef} && $Param{DataRef} ) {

## rbo-110721: disabled in agreement with tto, because this will result in some strange things
## (i.e. when a queue or ticket type list should be shown and only one entry is available)
##            # KIX4OTRS-capeIT
##            # checkbox
##            if (
##                scalar( @{ $Param{DataRef} } ) == 1
##                && ( ${ $Param{DataRef} }[0]{Key} eq '1' || ${ $Param{DataRef} }[0]{Key} eq 'yes' )
##                )
##            {
##                $String .=
##                    '  <input type="checkbox" name="'
##                    . $Param{AttributeRef}->{name}
##                    . '" value="'
##                    . ${ $Param{DataRef} }[0]{Key} . '"> ';
##                return $String;
##            }
##
##            elsif (
##                scalar( @{ $Param{DataRef} } ) == 2 && (
##                    (
##                        ${ $Param{DataRef} }[0]{Key} eq 'no'
##                        && ${ $Param{DataRef} }[1]{Key} eq 'yes'
##                    )
##                    ||
##                    ( ${ $Param{DataRef} }[0]{Key} eq '' && ${ $Param{DataRef} }[1]{Key} eq 'yes' )
##                )
##                )
##            {
##                $String .=
##                    '  <input type="checkbox" name="'
##                    . $Param{AttributeRef}->{name}
##                    . '" value="'
##                    . ${ $Param{DataRef} }[1]{Key} . '"> ';
##                return $String;
##            }
##
##            # EO KIX4OTRS-capeIT

#            # generate <select> row
#            $String = '<select';
#            for my $Key ( keys %{ $Param{AttributeRef} } ) {
#                if ( $Key && defined $Param{AttributeRef}->{$Key} ) {
#                    $String .= " $Key=\"$Param{AttributeRef}->{$Key}\"";
#                }
#                elsif ($Key) {
#                    $String .= " $Key";
#                }
#            }
#            $String .= ">\n";

#            # generate <option> rows
#            for my $Row ( @{ $Param{DataRef} } ) {
#                my $Key = '';
#                if ( defined $Row->{Key} ) {
#                    $Key = $Row->{Key};
#                }
#                my $Value = '';
#                if ( defined $Row->{Value} ) {
#                    $Value = $Row->{Value};
#                }
#                my $SelectedDisabled = '';
#                if ( $Row->{Selected} ) {
#                    $SelectedDisabled = ' selected';
#                }
#                elsif ( $Row->{Disabled} ) {
#                    $SelectedDisabled = ' disabled';
#                }
#                $String .= "  <option value=\"$Key\"$SelectedDisabled>$Value</option>\n";
#            }
#            $String .= '</select>';
#        }
#        return $String;
#    }

#    sub Kernel::Output::HTML::Layout::BuildSelectionJSON {
#    
#        my ( $Self, $Array ) = @_;
#        my %DataHash;
#       
#        for my $Data ( @{$Array} ) {
#            my %Param = %{$Data};
#    
#            # check needed stuff
#            for (qw(Name Data)) {
#                if ( !defined $Param{$_} ) {
#                    $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
#                    return;
#                }
#            }
#            
#            my $Disabled = 0;
#            my $DisabledOptions;
#             
#            if ( defined $Param{DisabledOptions} && ref $Param{DisabledOptions} eq 'HASH') {
#                $Disabled = 1;
#                $DisabledOptions = $Param{DisabledOptions};
#            }
#    
#            if ( ref $Param{Data} eq '') {
#                $DataHash{ $Param{Name} } = $Param{Data};
#            }
#            else {
#    
#                # create OptionRef
#                my $OptionRef = $Self->_BuildSelectionOptionRefCreate(
#                    %Param,
#                    HTMLQuote => 0,
#                );
#    
#                # create AttributeRef
#                my $AttributeRef = $Self->_BuildSelectionAttributeRefCreate(%Param);
#    
#                # create DataRef
#                my $DataRef = $Self->_BuildSelectionDataRefCreate(
#                    Data         => $Param{Data},
#                    AttributeRef => $AttributeRef,
#                    OptionRef    => $OptionRef,
#                );
#                
#                # create data structure
#                if ( $AttributeRef && $DataRef ) {
#                    my @DataArray;
#                    
#                    
#                    for my $Row ( @{$DataRef} ) {
#                        my $Key = '';
#                        if ( defined $Row->{Key} ) {
#                            $Key = $Row->{Key};
#                        }
#                        my $Value = '';
#                        if ( defined $Row->{Value} ) {
#                            $Value = $Row->{Value};
#                        }
#                        
#                        my $SelectedOption = Kernel::System::JSON::False();
#                        if ( $Row->{Selected} ) {
#                            $SelectedOption = Kernel::System::JSON::True();
#                        }
#                        
#                        my $DisabledOption = Kernel::System::JSON::False();
#                        if ($Disabled) {
#                            if ( $DisabledOptions->{$Key} ) {
#                                $DisabledOption = Kernel::System::JSON::True();
#                            }
#                        }
#    
#                        push @DataArray, [ $Key, $Value, $SelectedOption, $SelectedOption, $DisabledOption ];
#                    }
#                    $DataHash{ $AttributeRef->{name} } = \@DataArray;
#                }
#            }
#        }
#    
#        return $Self->JSONEncode(
#            Data => \%DataHash,
#        );
#    }



    # reset all warnings
}

1;