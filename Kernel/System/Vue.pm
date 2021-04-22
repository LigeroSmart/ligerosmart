package Kernel::System::Vue;

use Try::Tiny;
use strict;
use warnings;
use Data::Dumper;

use Encode;
use MIME::Base64;
use Kernel::System::VariableCheck qw(IsArrayRefWithData IsHashRefWithData IsStringWithData);

use JSON;	

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::SysConfig',
    'Kernel::System::Cache',
    'Kernel::System::DB',
    'Kernel::System::Log',
    'Kernel::System::Valid',
    'Kernel::Output::HTML::Layout',
    'Kernel::System::JSON',
);

=head1 NAME

Kernel::System::Vue - Vue lib

=head1 SYNOPSIS

Vue functions

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create an object

    use Kernel::System::ObjectManager;
    local $Kernel::OM = Kernel::System::ObjectManager->new();
    my $VueObject = $Kernel::OM->Get('Kernel::System::Vue');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

sub VuetifyData {
    my ( $Self, %Param ) = @_;

    my $DataHashRef = $Param{Data};

    my @ReturnArray;
    my %DataHash = %{$DataHashRef};
    for my $Key (sort { lc($DataHash{$a}) cmp lc($DataHash{$b}) } keys %DataHash){
        push @ReturnArray, {
            value => $Key,
            text  => $DataHash{$Key}
        }
    }
    return \@ReturnArray;
}