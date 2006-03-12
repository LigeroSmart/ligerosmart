
package Kernel::Language::de_PublicSurvey;

use strict;

sub Data {
    my $Self = shift;

    $Self->{Translation}->{'Survey'} = 'Umfrage';
    $Self->{Translation}->{'Questions'} = 'Fragen';
    $Self->{Translation}->{'Question'} = 'Frage';
    $Self->{Translation}->{'Finish'} = 'Fertigstellen';
    $Self->{Translation}->{'finished'} = 'fertiggestellt';
    $Self->{Translation}->{'This Survey-Key is invalid!'} = 'Dieser Umfrage-Schlüssel ist nicht (mehr) gültig!';
    $Self->{Translation}->{'Thank you for your feedback.'} = 'Sie haben diese Umfrage abgeschlossen. Vielen Dank.';
}
1;
