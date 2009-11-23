# --
# Kernel/System/ITSMChangeCIPAllocate.pm - all criticality, impact and priority allocation functions
# Copyright (C) 2003-2009 OTRS AG, http://otrs.com/
# --
# $Id: ITSMChangeCIPAllocate.pm,v 1.2 2009-11-23 13:30:43 bes Exp $
# $OldId: ITSMCIPAllocate.pm,v 1.13 2009/08/18 22:20:52 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

# ---
# ITSM Change Management
# ---
#package Kernel::System::ITSMCIPAllocate;
package Kernel::System::ITSMChangeCIPAllocate;
# ---

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.2 $) [1];

=head1 NAME

# ---
# ITSM Change Management
# ---
#Kernel::System::CIPAllocate - criticality, impact and priority allocation lib
Kernel::System::ITSMChangeCIPAllocate - category, impact and priority allocation lib
# ---

=head1 SYNOPSIS

# ---
# ITSM Change Management
# ---
#All criticality, impact and priority allocation functions.
All category, impact and priority allocation functions.
# ---

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create an object

    use Kernel::Config;
    use Kernel::System::Encode;
    use Kernel::System::Log;
# ---
# ITSM Change Management
# ---
#    use Kernel::System::CIPAllocate;
    use Kernel::System::ITSMChangeCIPAllocate;
# ---
    use Kernel::System::DB;
    use Kernel::System::Main;

    my $ConfigObject = Kernel::Config->new();
    my $EncodeObject = Kernel::System::Encode->new(
        ConfigObject => $ConfigObject,
    );
    my $LogObject = Kernel::System::Log->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
    );
    my $MainObject = Kernel::System::Main->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
    );
    my $DBObject = Kernel::System::DB->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
        MainObject   => $MainObject,
    );
# ---
# ITSM Change Management
# ---
#    my $CIPAllocateObject = Kernel::System::CIPAllocate->new(
    my $CIPAllocateObject = Kernel::System::ITSMChangeCIPAllocate->new(
# ---
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
        DBObject     => $DBObject,
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for my $Object (qw(DBObject ConfigObject LogObject)) {
        $Self->{$Object} = $Param{$Object} || die "Got no $Object!";
    }

    return $Self;
}

=item AllocateList()

return a 2d hash reference of allocations

    my $ListRef = $CIPAllocateObject->AllocateList(
        UserID => 1,
    );

=cut

sub AllocateList {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{UserID} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Need UserID!',
        );
        return;
    }

    # ask database
# ---
# ITSM Change Management
# ---
#    $Self->{DBObject}->Prepare(
#        SQL => 'SELECT criticality_id, impact_id, priority_id FROM cip_allocate',
    return if !$Self->{DBObject}->Prepare(
        SQL => 'SELECT category_id, impact_id, priority_id FROM change_cip_allocate',
# ---
    );

    # result list
    my %AllocateData;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $AllocateData{ $Row[1] }{ $Row[0] } = $Row[2];
    }

    return \%AllocateData;
}

=item AllocateUpdate()

# ---
# ITSM Change Management
# ---
#update the allocation of criticality, impact and priority
update the allocation of category, impact and priority
# ---

    my $True = $CIPAllocateObject->AllocateUpdate(
        AllocateData => $DataRef,  # 2D hash reference
        UserID       => 1,
    );

=cut

sub AllocateUpdate {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(AllocateData UserID)) {
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # check if allocate data is a hash reference
    if ( ref $Param{AllocateData} ne 'HASH' ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'AllocateData must be a 2D hash reference!',
        );
        return;
    }

    # check if allocate data is a 2D hash reference
    IMPACTID:
    for my $ImpactID ( keys %{ $Param{AllocateData} } ) {

        next IMPACTID if ref $Param{AllocateData}->{$ImpactID} eq 'HASH';

        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'AllocateData must be a 2D hash reference!',
        );
        return;
    }

    # delete old allocations
# ---
# ITSM Change Management
# ---
#    $Self->{DBObject}->Do( SQL => 'DELETE FROM cip_allocate' );
    return if !$Self->{DBObject}->Do( SQL => 'DELETE FROM change_cip_allocate' );
# ---

    # insert new allocations
    for my $ImpactID ( keys %{ $Param{AllocateData} } ) {

# ---
# ITSM Change Management
# ---
#        for my $CriticalityID ( keys %{ $Param{AllocateData}->{$ImpactID} } ) {
        for my $CategoryID ( keys %{ $Param{AllocateData}->{$ImpactID} } ) {
# ---

            # extract priority
# ---
# ITSM Change Management
# ---
#            my $PriorityID = $Param{AllocateData}->{$ImpactID}->{$CriticalityID};
            my $PriorityID = $Param{AllocateData}->{$ImpactID}->{$CategoryID};
# ---

            # insert new allocation
# ---
# ITSM Change Management
# ---
#            $Self->{DBObject}->Do(
#                SQL => 'INSERT INTO cip_allocate '
#                    . '(criticality_id, impact_id, priority_id, '
            return if !$Self->{DBObject}->Do(
                SQL => 'INSERT INTO change_cip_allocate '
                    . '(category_id, impact_id, priority_id, '
# ---
                    . 'create_time, create_by, change_time, change_by) VALUES '
                    . '(?, ?, ?, current_timestamp, ?, current_timestamp, ?)',
                Bind => [
# ---
# ITSM Change Management
# ---
#                    \$CriticalityID, \$ImpactID, \$PriorityID,
                    \$CategoryID, \$ImpactID, \$PriorityID,
# ---
                    \$Param{UserID}, \$Param{UserID},
                ],
            );
        }
    }

    return 1;
}

=item PriorityAllocationGet()

# ---
# ITSM Change Management
# ---
#return the priority id of a criticality and an impact
return the priority id for given category and impact
# ---

    my $PriorityID = $CIPAllocateObject->PriorityAllocationGet(
# ---
# ITSM Change Management
# ---
#        CriticalityID => 321,
#        ImpactID      => 123,
        CategoryID => 321,
        ImpactID   => 123,
# ---
    );

=cut

sub PriorityAllocationGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
# ---
# ITSM Change Management
# ---
#    for my $Argument (qw(CriticalityID ImpactID)) {
    for my $Argument (qw(CategoryID ImpactID)) {
# ---
        if ( !$Param{$Argument} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );
            return;
        }
    }

    # get priority id from db
# ---
# ITSM Change Management
# ---
#    $Self->{DBObject}->Prepare(
#        SQL => 'SELECT priority_id FROM cip_allocate '
#            . 'WHERE criticality_id = ? AND impact_id = ?',
#        Bind => [ \$Param{CriticalityID}, \$Param{ImpactID} ],
    return if !$Self->{DBObject}->Prepare(
        SQL => 'SELECT priority_id FROM change_cip_allocate '
            . 'WHERE category_id = ? AND impact_id = ?',
        Bind => [ \$Param{CategoryID}, \$Param{ImpactID} ],
# ---
        Limit => 1,
    );

    # fetch result
    my $PriorityID;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $PriorityID = $Row[0];
    }

    return $PriorityID;
}

1;

=back

=head1 TERMS AND CONDITIONS

This Software is part of the OTRS project (http://otrs.org/).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
# ---
# ITSM Change Management
# ---
#did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
did not receive this file, see L<http://www.gnu.org/licenses/gpl-2.0.txt>.
# ---

=cut

=head1 VERSION

$Revision: 1.2 $ $Date: 2009-11-23 13:30:43 $

=cut
