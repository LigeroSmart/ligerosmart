# OTRS config file (automatically generated)
# VERSION:1.1

# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Config::Files::AAAFred;

use strict;
use warnings;
no warnings 'redefine';    ## no critic

use vars qw($Self);

use Kernel::Config::Defaults;
use Kernel::Language;
use Kernel::System::Fred::ConfigLog;
use Kernel::System::Fred::SQLLog;
use Kernel::System::Fred::TranslationDebug;

our $ObjectManagerDisabled = 1;

sub Load {
    my ( $File, $Self ) = @_;

    if ( $ENV{HTTP_USER_AGENT} ) {

        # check if the needed path is available
        my $Path = $Self->{Home} . '/var/fred';
        if ( !-e $Path ) {
            mkdir $Path;
        }

        my $File = $Self->{Home} . '/var/fred/STDERR.log';

        # check log file size
        if ( -s $File > 20 * 1024 * 1024 ) {
            unlink $File;
        }

        # move STDOUT to tmp file
        if ( !open STDERR, '>>', $File ) {    ## no critic
            print STDERR "ERROR: Can't write $File!";
        }
    }

    # disable redefine warnings in this scope
    {
        no warnings 'redefine';               ## no critic

        # Override Kernel::Language::Get() method to intercept missing translations
        if ( Kernel::Language->can('Get') && !Kernel::Language->can('GetOriginal') ) {
            *Kernel::Language::GetOriginal = \&Kernel::Language::Get;
            *Kernel::Language::Get         = sub {
                my ( $Self, $What ) = @_;

                return    if !defined $What;
                return '' if $What eq '';

                my $Result = $Self->GetOriginal($What);

                if ( $What && $What =~ /^(.+?)",\s{0,1}"(.*?)$/ ) {
                    $What = $1;
                }

                if ( !$Self->{Translation}->{$What} ) {
                    $Self->{TranslationDebugObject} ||= Kernel::System::Fred::TranslationDebug->new();
                    $Self->{TranslationDebugObject}->InsertWord( What => $What );
                }

                return $Result;
            };
        }

        # Override Kernel::Language::Translate() method to intercept missing translations
        if ( Kernel::Language->can('Translate') && !Kernel::Language->can('TranslateOriginal') ) {
            *Kernel::Language::TranslateOriginal = \&Kernel::Language::Translate;
            *Kernel::Language::Translate         = sub {
                my ( $Self, $Text, @Parameters ) = @_;

                if ( $Text && !$Self->{Translation}->{$Text} ) {
                    $Self->{TranslationDebugObject} ||= Kernel::System::Fred::TranslationDebug->new();
                    $Self->{TranslationDebugObject}->InsertWord( What => $Text );
                }

                return $Self->TranslateOriginal( $Text, @Parameters );
            };
        }

        # Override Kernel::System::DB::Prepare() method to intercept database calls
        if ( Kernel::System::DB->can('Prepare') && !Kernel::System::DB->can('PrepareOriginal') ) {
            *Kernel::System::DB::PrepareOriginal = \&Kernel::System::DB::Prepare;
            *Kernel::System::DB::Prepare         = sub {
                my ( $Self, %Param ) = @_;

                $Self->{SQLLogObject} ||= Kernel::System::Fred::SQLLog->new();
                $Self->{SQLLogObject}->PreStatement(%Param);
                my $Result = $Self->PrepareOriginal(%Param);
                $Self->{SQLLogObject}->PostStatement(%Param);

                return $Result;
            };
        }

        # Override Kernel::System::DB::Do() method to intercept database calls
        if ( Kernel::System::DB->can('Do') && !Kernel::System::DB->can('DoOriginal') ) {
            *Kernel::System::DB::DoOriginal = \&Kernel::System::DB::Do;
            *Kernel::System::DB::Do         = sub {
                my ( $Self, %Param ) = @_;

                $Self->{SQLLogObject} ||= Kernel::System::Fred::SQLLog->new();
                $Self->{SQLLogObject}->PreStatement(%Param);
                my $Result = $Self->DoOriginal(%Param);
                $Self->{SQLLogObject}->PostStatement(%Param);

                return $Result;
            };
        }

        # Override Kernel::Config::Get() method to intercept config strings
        if ( Kernel::Config::Defaults->can('Get') && !Kernel::Config::Defaults->can('GetOriginal') ) {
            *Kernel::Config::Defaults::GetOriginal = \&Kernel::Config::Defaults::Get;
            *Kernel::Config::Defaults::Get         = sub {
                my ( $Self, $What ) = @_;

                $Self->{ConfigLogObject} ||= Kernel::System::Fred::ConfigLog->new();
                my $Caller = caller();
                if ( $Self->{$What} ) {
                    $Self->{ConfigLogObject}->InsertWord(
                        What => "$What;True;$Caller;",
                        Home => $Self->{Home}
                    );
                }
                else {
                    $Self->{ConfigLogObject}->InsertWord(
                        What => "$What;False;$Caller;",
                        Home => $Self->{Home}
                    );
                }

                return $Self->GetOriginal($What);
            };
        }
    }
    return;
}

1;
