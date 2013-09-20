# --
# Survey.pm - code to excecute during package installation
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package var::packagesetup::Survey;

use strict;
use warnings;

=head1 NAME

Survey.pm - code to excecute during package installation

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
    use var::packagesetup::Survey;

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
    my $CodeObject = var::packagesetup::Survey->new(
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
        qw(ConfigObject LogObject EncodeObject MainObject TimeObject DBObject XMLObject)
        )
    {
        $Self->{$Object} = $Param{$Object} || die "Got no $Object!";
    }

    return $Self;
}

=item CodeInstall()

run the code install part

    my $Result = $CodeObject->CodeInstall();

=cut

sub CodeInstall {
    my ( $Self, %Param ) = @_;

    return 1;
}

=item CodeReinstall()

run the code reinstall part

    my $Result = $CodeObject->CodeReinstall();

=cut

sub CodeReinstall {
    my ( $Self, %Param ) = @_;

    return 1;
}

=item CodeUpgrade()

run the code upgrade part

    my $Result = $CodeObject->CodeUpgrade();

=cut

sub CodeUpgrade {
    my ( $Self, %Param ) = @_;

    return 1;
}

=item CodeUninstall()

run the code uninstall part

    my $Result = $CodeObject->CodeUninstall();

=cut

sub CodeUninstall {
    my ( $Self, %Param ) = @_;

    return 1;
}

=item CodeUpgradeFromLowerThan_2_0_92()

This function is only executed if the installed module version is smaller than 2.0.92.

my $Result = $CodeObject->CodeUpgradeFromLowerThan_2_0_92();

=cut

sub CodeUpgradeFromLowerThan_2_0_92 {    ## no critic
    my ( $Self, %Param ) = @_;

    # SELECT all functionality values
    $Self->{DBObject}->Prepare(
        SQL => 'SELECT id, send_time FROM survey_request',
    );

    my @List;
    ROW:
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        next ROW if !$Row[1];

        push @List, \@Row;
    }

    # save entries in new table
    for my $Entry (@List) {
        $Self->{DBObject}->Do(
            SQL =>
                'UPDATE survey_request SET create_time = ? WHERE  id = ?',
            Bind => [ \$Entry->[1], \$Entry->[0] ],
        );
    }

    return 1;
}

=item CodeUpgradeFromLowerThan_2_1_5()

This function is only executed if the installed module version is smaller than 2.1.5.

my $Result = $CodeObject->CodeUpgradeFromLowerThan_2_1_5();

=cut

sub CodeUpgradeFromLowerThan_2_1_5 {    ## no critic
    my ( $Self, %Param ) = @_;

    # set all survey_question records
    # that don't have answer_required set to something
    # to 0
    $Self->_Prefill_AnswerRequiredFromSurveyQuestion_2_1_5();

    return 1;
}

=item _Prefill_AnswerRequiredFromSurveyQuestion_2_1_5()

Inserts 0 into all answer_required records of table suvey_question
where there is no entry present.

    my $Success = $PackageSetup->_Prefill_AnswerRequiredFromSurveyQuestion_2_1_5();

=cut

sub _Prefill_AnswerRequiredFromSurveyQuestion_2_1_5 {    ## no critic
    my ($Self) = @_;

    return if !$Self->{DBObject}->Prepare(
        SQL => 'SELECT id, answer_required '
            . 'FROM survey_question',
        Limit => 0,
    );
    my @IdsToUpdate;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {

        # if we had an id
        # but no answer_required or answer_required isn't 0 or 1
        # collect the ID in @IdsToUpdate
        if (
            defined $Row[0]
            && length $Row[0]
            && (
                !defined $Row[1]
                || ( $Row[1] ne '0' && $Row[1] ne '1' )
            )
            )
        {
            push @IdsToUpdate, $Row[0];
        }
    }

    for my $QuestionID (@IdsToUpdate) {
        $Self->{DBObject}->Do(
            SQL =>
                'UPDATE survey_question SET answer_required = 0 WHERE id = ?',
            Bind => [
                \$QuestionID,
            ],
        );
    }
    return 1;
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
