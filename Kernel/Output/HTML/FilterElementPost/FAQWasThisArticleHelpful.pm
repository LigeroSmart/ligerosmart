# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# Copyright (C) 2017-2018 Complemento, http://complemento.net.br/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::FilterElementPost::FAQWasThisArticleHelpful;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::Output::HTML::Layout',
    'Kernel::System::FAQ',
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

    my $TemplateName = $Param{TemplateFile} || '';

    return 1 if !$TemplateName;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $Config = $Kernel::OM->Get('Kernel::Config')->Get("WasThisArticleHelpful")||{};
    
    return 1 if $Config->{Enabled} eq 'disabled';
    
    my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');
    
    my $KeyPrimary = $ParamObject->GetParam(Param => 'KeyPrimary') || '';
    my $FAQID = $ParamObject->GetParam(Param => 'ItemID') || '';
    my $ServiceID = $ParamObject->GetParam(Param => 'ServiceID') || '';
    
    my %Options;

    my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');
	my $BackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

    my $DynamicFieldConfig = $DynamicFieldObject->DynamicFieldGet(
        Name   => 'FaqButtons',             # ID or Name must be provided
    );

    my $Value = $BackendObject->ValueGet(
        DynamicFieldConfig => $DynamicFieldConfig,      # complete config of the DynamicField
        ObjectID           => $FAQID,                # ID of the current object that the field
                                                            # must be linked to, e. g. TicketID
    );

    if(!$Value){
        if($KeyPrimary){
            # User came by browsing
            %Options = %{$Config->{OptionsWhenBrowsing}};
        } else {
            # User came by searching
            %Options = %{$Config->{OptionsWhenSearching}};
        }

        # Which block will be used (buttons or links)
        my $Block = $Config->{Enabled};

        for my $Key (sort keys %Options){
            # Clean number of Key ("0:","1:"...)
            my $Option = $Key;
            $Option =~ s/^.*\://;
            
            # Replace link tags
            my $Link = $Options{$Key};
            $Link =~ s/_FAQID_/$FAQID/;
            $Link =~ s/_ServiceID_/$ServiceID/;
            $Link =~ s/_Service_/$KeyPrimary/;
            
            $Kernel::OM->Get('Kernel::Output::HTML::Layout')->Block(
                Name => $Block,
                Data => {
                    Option => $Option,
                    Link   => $Link
                },
            );
            
        }
        
        my $Output = ''.
            $LayoutObject->Output(
                TemplateFile => 'CustomerFAQWasThisArticleHelpful',
                Data => {
                    WasThisArticleHelpfulText => $Config->{WasThisArticleHelpfulText} || "Was this article helpful?",
                    AdditionalClass => 'Wtah'.$Block,
                }
                #Data         => \%Data,
            ) . "</ul><div id=\"ZoomSidebar\">";
            

        ${ $Param{Data} } =~ s/<\/ul>.*(\r\n|\r|\n).*<div id="ZoomSidebar">/$Output/;
    }
    else{
        my $Block = "buttons";

        for my $Link (sort @$Value){
            
            my $Option = $DynamicFieldConfig->{Config}->{PossibleValues}->{$Link};
            $Option =~ s/^.*\://;
            
            # Replace link tags
            # Clean number of Key ("0:","1:"...)
            $Link =~ s/^.*\://;
            $Link =~ s/_FAQID_/$FAQID/;
            $Link =~ s/_ServiceID_/$ServiceID/;
            $Link =~ s/_Service_/$KeyPrimary/;
            
            $Kernel::OM->Get('Kernel::Output::HTML::Layout')->Block(
                Name => $Block,
                Data => {
                    Option => $Option,
                    Link   => $Link
                },
            );
            
        }

        my $Output = ''.
            $LayoutObject->Output(
                TemplateFile => 'CustomerFAQWasThisArticleHelpful',
                Data => {
                    WasThisArticleHelpfulText => $Config->{WasThisArticleHelpfulText} || "Was this article helpful?",
                    AdditionalClass => 'Wtah'.$Block,
                }
                #Data         => \%Data,
            ) . "</ul><div id=\"ZoomSidebar\">";
            

        ${ $Param{Data} } =~ s/<\/ul>.*(\r\n|\r|\n).*<div id="ZoomSidebar">/$Output/;

    }
    

}

1;