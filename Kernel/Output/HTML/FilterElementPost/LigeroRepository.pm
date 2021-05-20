# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::FilterElementPost::LigeroRepository;

use strict;
use warnings;
use Data::Dumper;
our @ObjectDependencies = (
    'Kernel::Output::HTML::Layout',
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

	if ($LayoutObject->{Action} eq 'Admin') {
		${ $Param{Data} } =~ s/Action=AdminLigeroSubscription/Action=AdminSystemConfigurationGroup;RootNavigation=Ligero%3A%3ASubscription/;
		return 1;
	}

    return if $LayoutObject->{Action} ne 'AdminPackageManager';

    # REPLACE UNAUTHORIZED MESSAGE FOR LIGERO ADDONS
    my $ErrorText = $LayoutObject->{LanguageObject}->Translate('An error occurred.');

    my $ErrorTextBack = $LayoutObject->{LanguageObject}->Translate('Back to your OTRS Package Manager');
    my $ErrorTextNew = $LayoutObject->{LanguageObject}->Translate('Your Ligero Account is not working yet!');

    my $ErrorMessage = $LayoutObject->{LanguageObject}->Translate('No such package!');
    
    # Verifies if we have available languages on Ligero websites:
    my %Available;
    $Available{pt_BR} = 'index_pt_BR.html';
    $Available{pt}    = 'index_pt_BR.html';
    my $LanguagePage = $Available{$LayoutObject->{UserLanguage}} || '';

	my $ref = $Kernel::OM->Get('Kernel::Config')->Get('LigeroSubscriptionAffiliate');
    
    if(${$Param{Data}} =~ /Can't perform GET on \E.*?addons.ligerosmart.com\/AddOns\/(.+?)\/.*Ligero\/(.*)\/.*?\Q401 Unauthorized\E/){
        ${$Param{Data}} = '<div style="width:100%;padding:20px;"><a href="?Action=AdminPackageManager" style="font-size:12pt;font-weight:normal;">'.$ErrorTextBack.'</a></div>
        <style type="text/css">
            #Footer,#ResponsiveFooter {display:none}
        </style>
            <iframe src="http://addons.ligerosmart.com/AddOns/'.$1.'/AddOnsPages/'.$2."/$LanguagePage?ref=$ref".'" 
            frameborder="0" height="100%" width="100%" style="position: fixed"></iframe>';
    }

    # replace logo in packlage list
    ${ $Param{Data} } =~ s{
        (<img [^>]* src="([^"]+ \Qotrs-verify-small.png\E)" [^>]* class="OTRSVerifyLogo" [^>]* >) \s* <a [^>]* >([^<]+)<\/a> \s* <\/td> \s*
        <td> .*? <\/td> \s*
        <td> .*? <\/td> \s*
        <td><a [^>]* >([^>]+)<\/a><\/td>
    }
    {
        my $HTML = $&;
        my $ImageHTML = $1;
        my $ImageSource = $2;
        my $PackageName = $3;
        my $Vendor = $4;

        if ( $Vendor =~ /(ligero|complemento)/xmsi ) {
            my $HTMLNew = $HTML;

            $HTMLNew =~ s{\Qotrs-verify-small.png\E}{ligero-verify-small.png}xmsi;

            $HTMLNew;
        } else {
            $HTML;
        }

    }xmsgei;

    # replace logo in package view
    ${ $Param{Data} } =~ s{
        <img [^>]* class="OTRSVerifyLogoBig" [^>]* >
    }
    {}xmsgi;

    return 1;
}

1;
