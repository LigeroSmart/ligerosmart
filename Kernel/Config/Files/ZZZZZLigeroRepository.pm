# OTRS config file (automatically generated)
# VERSION:1.1
package Kernel::Config::Files::ZZZZZLigeroRepository;
use strict;
use warnings;
no warnings 'redefine';
use utf8;
use Kernel::System::VariableCheck qw(:all);

sub Load {
    my ($File, $Self) = @_;

    # add the Ligero repository to the repository list
    my $RepositoryList = $Self->{'Package::RepositoryList'};
    if ( !IsHashRefWithData($RepositoryList) ) {
        $RepositoryList = {};
    }

    my $Login='';
    my $EnterpriseRepository = $Self->{'LigeroSubscription'};
    if ( IsHashRefWithData($EnterpriseRepository) ) {
        $Login = $EnterpriseRepository->{'API-CUSTOMER'}.':'.$EnterpriseRepository->{'API-KEY'}.'@';
    }

    my $RepositoryURL = "https://".$Login."addons.ligerosmart.com/AddOns/6.0";

    # Remove old repositories
    REPOSITORY:
    for my $Key (keys %{ $RepositoryList }){
        next REPOSITORY if $RepositoryList->{$Key} ne ':: AddOns - Ligero ::';
        delete $RepositoryList->{$Key};
    }

    # add public repository
    $RepositoryList->{ $RepositoryURL } = ':: AddOns - Ligero ::';

    # set temporary config entry
    $Self->{'Package::RepositoryList'} = $RepositoryList;
}

1;
