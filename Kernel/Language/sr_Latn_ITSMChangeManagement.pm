# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Language::sr_Latn_ITSMChangeManagement;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AdminITSMChangeCIPAllocate
    $Self->{Translation}->{'Category ↔ Impact ↔ Priority'} = 'Kategorija ↔ uticaj ↔ prioritet';
    $Self->{Translation}->{'Manage the priority result of combinating Category ↔ Impact.'} =
        'Upravljanje rezultatom prioriteta kombinacijom kategorija ↔ uticaj.';
    $Self->{Translation}->{'Priority allocation'} = 'Raspodela prioriteta';

    # Template: AdminITSMChangeNotification
    $Self->{Translation}->{'ITSM ChangeManagement Notification Management'} = 'Upravljanje obaveštenjima u ITSM upravljanju promenama';
    $Self->{Translation}->{'Add Notification Rule'} = 'Dodaj pravilo obaveštavanja';
    $Self->{Translation}->{'Edit Notification Rule'} = 'Uredi pravilo obaveštavanja';
    $Self->{Translation}->{'A notification should have a name!'} = 'Obaveštenje treba da ima ime!';
    $Self->{Translation}->{'Name is required.'} = 'Ime je obavezno.';

    # Template: AdminITSMStateMachine
    $Self->{Translation}->{'Admin State Machine'} = 'Administarcija mašine stanja';
    $Self->{Translation}->{'Select a catalog class!'} = 'Izbor klase kataloga!';
    $Self->{Translation}->{'A catalog class is required!'} = 'Klasa kataloga je obavezna!';
    $Self->{Translation}->{'Add a state transition'} = 'Dodaj tranziciju statusa';
    $Self->{Translation}->{'Catalog Class'} = 'Klasa';
    $Self->{Translation}->{'Object Name'} = 'Naziv objekta';
    $Self->{Translation}->{'Overview over state transitions for'} = 'Pregled preko tranzicije statusa za';
    $Self->{Translation}->{'Delete this state transition'} = 'Obriši ovu tranziciju statusa';
    $Self->{Translation}->{'Add a new state transition for'} = 'Dodaj novu tranziciju statusa za';
    $Self->{Translation}->{'Please select a state!'} = 'Molimo da odaberete stanje!';
    $Self->{Translation}->{'Please select a next state!'} = 'Molimo da odaberete sledeće stanje!';
    $Self->{Translation}->{'Edit a state transition for'} = 'Uredi tranziciju statusa za';
    $Self->{Translation}->{'Do you really want to delete the state transition'} = 'Da li zaista želite da obrišete ovu tranziciju statusa?';

    # Template: AgentITSMChangeAdd
    $Self->{Translation}->{'Add Change'} = 'Dodaj promenu';
    $Self->{Translation}->{'ITSM Change'} = 'ITSM promena';
    $Self->{Translation}->{'Justification'} = 'Opravdanje';
    $Self->{Translation}->{'Input invalid.'} = 'Neispravan unos.';
    $Self->{Translation}->{'Impact'} = 'Uticaj';
    $Self->{Translation}->{'Requested Date'} = 'Traženi datum';

    # Template: AgentITSMChangeAddFromTemplate
    $Self->{Translation}->{'Select Change Template'} = 'Izaberi šablon promene';
    $Self->{Translation}->{'Time type'} = 'Tip vremena';
    $Self->{Translation}->{'Invalid time type.'} = 'Neispravan tip vremena.';
    $Self->{Translation}->{'New time'} = 'Novo vreme';

    # Template: AgentITSMChangeCABTemplate
    $Self->{Translation}->{'Save Change CAB as template'} = 'Sačuvaj promenu CAB kao šablon';
    $Self->{Translation}->{'go to involved persons screen'} = 'idi na ekran uključenih osoba';
    $Self->{Translation}->{'Invalid Name'} = 'Pogrešno ime';

    # Template: AgentITSMChangeCondition
    $Self->{Translation}->{'Conditions and Actions'} = 'Uslovi i akcije';
    $Self->{Translation}->{'Delete Condition'} = 'Uslov brisanja';
    $Self->{Translation}->{'Add new condition'} = 'Dodaj novi uslov';

    # Template: AgentITSMChangeConditionEdit
    $Self->{Translation}->{'Edit Condition'} = 'Uredi uslov';
    $Self->{Translation}->{'Need a valid name.'} = 'Potrebno je ispravno ime.';
    $Self->{Translation}->{'A valid name is needed.'} = 'Neophodno je važeće ime.';
    $Self->{Translation}->{'Duplicate name:'} = 'Duplikat imena:';
    $Self->{Translation}->{'This name is already used by another condition.'} = 'ovo ime je već upotrebljeno za drugi uslov.';
    $Self->{Translation}->{'Matching'} = 'Podudaranje';
    $Self->{Translation}->{'Any expression (OR)'} = 'Svaki izraz (OR)';
    $Self->{Translation}->{'All expressions (AND)'} = 'Svi izrazi (AND)';
    $Self->{Translation}->{'Expressions'} = 'Izrazi';
    $Self->{Translation}->{'Selector'} = 'Birač';
    $Self->{Translation}->{'Operator'} = 'Operator';
    $Self->{Translation}->{'Delete Expression'} = 'Obriši izraz';
    $Self->{Translation}->{'No Expressions found.'} = 'Nije pronađen nijedan izraz.';
    $Self->{Translation}->{'Add new expression'} = 'Dodaj nov izraz';
    $Self->{Translation}->{'Delete Action'} = 'Obriši akciju';
    $Self->{Translation}->{'No Actions found.'} = 'Nije pronađena nijedna akcija.';
    $Self->{Translation}->{'Add new action'} = 'Dodaj novu akciju';

    # Template: AgentITSMChangeDelete
    $Self->{Translation}->{'Do you really want to delete this change?'} = 'Da li zaista želite da izbrišete ovu promenu?';

    # Template: AgentITSMChangeEdit
    $Self->{Translation}->{'Edit %s%s'} = 'Uredi %s%s';

    # Template: AgentITSMChangeHistory
    $Self->{Translation}->{'History of %s%s'} = 'Istorijat od %s%s';
    $Self->{Translation}->{'History Content'} = 'Sadržaj istorijata';
    $Self->{Translation}->{'Workorder'} = 'Radni nalog';
    $Self->{Translation}->{'Createtime'} = 'Vreme kreiranja';
    $Self->{Translation}->{'Show details'} = 'Prikaži detalje';
    $Self->{Translation}->{'Show workorder'} = 'Prikaži radni nalog';

    # Template: AgentITSMChangeHistoryZoom
    $Self->{Translation}->{'Detailed history information of %s'} = 'Detaljni istorijat za %s';
    $Self->{Translation}->{'Modified'} = 'Promenjeno';
    $Self->{Translation}->{'Old Value'} = 'Stara vrednost';
    $Self->{Translation}->{'New Value'} = 'Nova vrednost';

    # Template: AgentITSMChangeInvolvedPersons
    $Self->{Translation}->{'Edit Involved Persons of %s%s'} = 'Uredi uključene osobe za %s%s';
    $Self->{Translation}->{'Involved Persons'} = 'Uključene osobe';
    $Self->{Translation}->{'ChangeManager'} = 'Upravljač promenama';
    $Self->{Translation}->{'User invalid.'} = 'Neispravan korisnik.';
    $Self->{Translation}->{'ChangeBuilder'} = 'Graditelj promene';
    $Self->{Translation}->{'Change Advisory Board'} = 'Savetodavni odbor za promene';
    $Self->{Translation}->{'CAB Template'} = 'CAB šablon';
    $Self->{Translation}->{'Apply Template'} = 'Primeni šablon';
    $Self->{Translation}->{'NewTemplate'} = 'Novi šablon';
    $Self->{Translation}->{'Save this CAB as template'} = 'Sačuvaj ovo kao CAB šablon';
    $Self->{Translation}->{'Add to CAB'} = 'Dodaj u CAB';
    $Self->{Translation}->{'Invalid User'} = 'Pogrešan korisnik';
    $Self->{Translation}->{'Current CAB'} = 'Aktuelni CAB';

    # Template: AgentITSMChangeOverviewNavBar
    $Self->{Translation}->{'Context Settings'} = 'Podešavanje konteksta';
    $Self->{Translation}->{'Changes per page'} = 'Promena po strani';

    # Template: AgentITSMChangeOverviewSmall
    $Self->{Translation}->{'Workorder Title'} = 'Naslov radnog naloga';
    $Self->{Translation}->{'Change Title'} = 'Naslov promene';
    $Self->{Translation}->{'Workorder Agent'} = 'Operater za radni nalog';
    $Self->{Translation}->{'Change Builder'} = 'Graditelj promene';
    $Self->{Translation}->{'Change Manager'} = 'Upravljanje promenama';
    $Self->{Translation}->{'Workorders'} = 'Radni nalozi';
    $Self->{Translation}->{'Change State'} = 'Stanje promene';
    $Self->{Translation}->{'Workorder State'} = 'Stanje radnog naloga';
    $Self->{Translation}->{'Workorder Type'} = 'Tip radnog naloga';
    $Self->{Translation}->{'Requested Time'} = 'Traženo vreme';
    $Self->{Translation}->{'Planned Start Time'} = 'Planirano vreme početka';
    $Self->{Translation}->{'Planned End Time'} = 'Planirano vreme završetka';
    $Self->{Translation}->{'Actual Start Time'} = 'Stvarno vreme početka';
    $Self->{Translation}->{'Actual End Time'} = 'Stvarno vreme završetka';

    # Template: AgentITSMChangeReset
    $Self->{Translation}->{'Do you really want to reset this change?'} = 'Da li zaista želite da poništite ovu promenu?';

    # Template: AgentITSMChangeSearch
    $Self->{Translation}->{'(e.g. 10*5155 or 105658*)'} = '(npr 10*5155 ili 105658*)';
    $Self->{Translation}->{'CAB Agent'} = 'Operater CAB';
    $Self->{Translation}->{'e.g.'} = 'npr.';
    $Self->{Translation}->{'CAB Customer'} = 'CAB klijent';
    $Self->{Translation}->{'ITSM Workorder Instruction'} = 'Uputstvo ITSM radnog naloga';
    $Self->{Translation}->{'ITSM Workorder Report'} = 'Izveštaj ITSM radnog naloga';
    $Self->{Translation}->{'ITSM Change Priority'} = 'Prioritet ITSM promene';
    $Self->{Translation}->{'ITSM Change Impact'} = 'Uticaj ITSM promene';
    $Self->{Translation}->{'Change Category'} = 'Kategorija promene';
    $Self->{Translation}->{'(before/after)'} = '(pre/posle)';
    $Self->{Translation}->{'(between)'} = '(između)';

    # Template: AgentITSMChangeTemplate
    $Self->{Translation}->{'Save Change as Template'} = 'Sačuvaj promenu kao šablon';
    $Self->{Translation}->{'A template should have a name!'} = 'Šablon treba da ima ime!';
    $Self->{Translation}->{'The template name is required.'} = 'Ime šablona je obavezno.';
    $Self->{Translation}->{'Reset States'} = 'Poništi stanja';
    $Self->{Translation}->{'Overwrite original template'} = 'Prepiši preko originalnog šablona';
    $Self->{Translation}->{'Delete original change'} = 'Obriši originalnu promenu';

    # Template: AgentITSMChangeTimeSlot
    $Self->{Translation}->{'Move Time Slot'} = 'Pomeri vremenski termin';

    # Template: AgentITSMChangeZoom
    $Self->{Translation}->{'Change Information'} = 'Informacija o promeni';
    $Self->{Translation}->{'Planned Effort'} = 'Planirani napor';
    $Self->{Translation}->{'Accounted Time'} = 'Obračunato vreme';
    $Self->{Translation}->{'Change Initiator(s)'} = 'Inicijator(i) promene';
    $Self->{Translation}->{'CAB'} = 'CAB';
    $Self->{Translation}->{'Last changed'} = 'Zadnji put promenjeno';
    $Self->{Translation}->{'Last changed by'} = 'Promenio';
    $Self->{Translation}->{'To open links in the following description blocks, you might need to press Ctrl or Cmd or Shift key while clicking the link (depending on your browser and OS).'} =
        'Da biste otvorili veze u sledećim blokovima opisa, možda ćete trebati da pritisnete "Ctrl" ili "Cmd" ili "Shift" taster dok istovremeno kliknete na vezu (zavisi od vašeg operativnog sistema i pretraživača).';
    $Self->{Translation}->{'Download Attachment'} = 'Preuzmi prilog';

    # Template: AgentITSMTemplateEditCAB
    $Self->{Translation}->{'Edit CAB Template'} = 'Uredi CAB šablon';

    # Template: AgentITSMTemplateEditContent
    $Self->{Translation}->{'This will create a new change from this template, so you can edit and save it.'} =
        'Ovo će kreirati novu promenu od ovog šablona, pa je možete izmeniti i sačuvati.';
    $Self->{Translation}->{'The new change will be deleted automatically after it has been saved as template.'} =
        'Nova promena će automatski biti obrisana, kad bude sačuvana kao šablon.';
    $Self->{Translation}->{'This will create a new workorder from this template, so you can edit and save it.'} =
        'Ovo će kreirati nov radni nalog od ovog šablona, pa ga možete izmeniti i sačuvati.';
    $Self->{Translation}->{'A temporary change will be created which contains the workorder.'} =
        'Biće kreirana privremena promena koja sadrži radni nalog.';
    $Self->{Translation}->{'The temporary change and new workorder will be deleted automatically after the workorder has been saved as template.'} =
        'Privremana promena i novi radni nalog će automatski biti obrisani, kad radni nalog bude sačuvan kao šablon.';
    $Self->{Translation}->{'Do you want to proceed?'} = 'Da li želite da nastavite?';

    # Template: AgentITSMTemplateOverviewSmall
    $Self->{Translation}->{'Template ID'} = 'ID šablona';
    $Self->{Translation}->{'Edit Content'} = 'Uredi sadržaj';
    $Self->{Translation}->{'Create by'} = 'Kreirao';
    $Self->{Translation}->{'Change by'} = 'Izmenio';
    $Self->{Translation}->{'Change Time'} = 'Vreme promene';

    # Template: AgentITSMWorkOrderAdd
    $Self->{Translation}->{'Add Workorder to %s%s'} = 'Dodaj radni nalog u %s%s';
    $Self->{Translation}->{'Instruction'} = 'Instrukcija';
    $Self->{Translation}->{'Invalid workorder type.'} = 'Neispravan tip radnog naloga.';
    $Self->{Translation}->{'The planned start time must be before the planned end time!'} = 'Planirano vreme početka mora biti pre planiranog vremena završetka!';
    $Self->{Translation}->{'Invalid format.'} = 'Neispravan format.';

    # Template: AgentITSMWorkOrderAddFromTemplate
    $Self->{Translation}->{'Select Workorder Template'} = 'Izaberi šablon radnog naloga';

    # Template: AgentITSMWorkOrderAgent
    $Self->{Translation}->{'Edit Workorder Agent of %s%s'} = 'Uredi korisnika radnog naloga za %s%s';

    # Template: AgentITSMWorkOrderDelete
    $Self->{Translation}->{'Do you really want to delete this workorder?'} = 'Da li zaista želite da izbrišete ovaj radni nalog?';
    $Self->{Translation}->{'You can not delete this Workorder. It is used in at least one Condition!'} =
        'Ne možete obrisati ovaj radni nalog. Upotrebljen je u bar jednom uslovu';
    $Self->{Translation}->{'This Workorder is used in the following Condition(s)'} = 'Ovaj radni nalog je upotrebljen u sledećim uslovima';

    # Template: AgentITSMWorkOrderEdit
    $Self->{Translation}->{'Edit %s%s-%s'} = 'Uredi %s%s-%s';
    $Self->{Translation}->{'Move following workorders accordingly'} = 'Pomerite adekvatno sledeće radne naloge';
    $Self->{Translation}->{'If the planned end time of this workorder is changed, the planned start times of all following workorders will be changed accordingly'} =
        'Planirano vreme završetka ovog radnog naloga je promenjeno, planirana vremena početka svih narednih radnih naloga će biti adekvatno usklađena';

    # Template: AgentITSMWorkOrderHistory
    $Self->{Translation}->{'History of %s%s-%s'} = 'Istorijat za %s%s-%s';

    # Template: AgentITSMWorkOrderReport
    $Self->{Translation}->{'Edit Report of %s%s-%s'} = 'Uredi izveštaj za %s%s-%s';
    $Self->{Translation}->{'Report'} = 'Izveštaj';
    $Self->{Translation}->{'The actual start time must be before the actual end time!'} = 'Aktuelno vreme početka mora biti pre aktuelnog vremena završetka!';
    $Self->{Translation}->{'The actual start time must be set, when the actual end time is set!'} =
        'Aktuelno vreme početka mora biti podešeno kada je podešeno i aktuelno vreme završetka!';

    # Template: AgentITSMWorkOrderTake
    $Self->{Translation}->{'Current Agent'} = 'Aktuelni operater';
    $Self->{Translation}->{'Do you really want to take this workorder?'} = 'Da li zaista želite da preuzmete ovaj radni nalog?';

    # Template: AgentITSMWorkOrderTemplate
    $Self->{Translation}->{'Save Workorder as Template'} = 'Sačuvaj radni nalog kao šablon';
    $Self->{Translation}->{'Delete original workorder (and surrounding change)'} = 'Obriši originalni radni nalog (i promenu u kojoj je)';

    # Template: AgentITSMWorkOrderZoom
    $Self->{Translation}->{'Workorder Information'} = 'Informacija o radnom nalogu';

    # Perl Module: Kernel/Modules/AdminITSMChangeNotification.pm
    $Self->{Translation}->{'Notification Added!'} = 'Dodato obaveštenje!';
    $Self->{Translation}->{'Unknown notification %s!'} = 'Nepoznato obaveštenje %s!';
    $Self->{Translation}->{'There was an error creating the notification.'} = 'Došlo je do greške prilikom kreiranja obaveštenja.';

    # Perl Module: Kernel/Modules/AdminITSMStateMachine.pm
    $Self->{Translation}->{'State Transition Updated!'} = 'Ažurirano tranziciono stanje!';
    $Self->{Translation}->{'State Transition Added!'} = 'Dodato tranziciono stanje!';

    # Perl Module: Kernel/Modules/AgentITSMChange.pm
    $Self->{Translation}->{'Overview: ITSM Changes'} = 'Pregled: ITSM promene';

    # Perl Module: Kernel/Modules/AgentITSMChangeAdd.pm
    $Self->{Translation}->{'Ticket with TicketID %s does not exist!'} = 'Tiket sa TicketID %s ne postoji!';
    $Self->{Translation}->{'Missing sysconfig option "ITSMChange::AddChangeLinkTicketTypes"!'} =
        'Nedostaje opcija sistemske konfiguracije "ITSMChange::AddChangeLinkTicketTypes"!';
    $Self->{Translation}->{'Was not able to add change!'} = 'Nije bilo moguće dodati promenu!';

    # Perl Module: Kernel/Modules/AgentITSMChangeAddFromTemplate.pm
    $Self->{Translation}->{'Was not able to create change from template!'} = 'Nije bilo moguće kreirati promenu iz šablona!';

    # Perl Module: Kernel/Modules/AgentITSMChangeCABTemplate.pm
    $Self->{Translation}->{'No ChangeID is given!'} = 'Nije dat ChangeID!';
    $Self->{Translation}->{'No change found for changeID %s.'} = 'Nije pronađena promena za ChangeID %s.';
    $Self->{Translation}->{'The CAB of change "%s" could not be serialized.'} = 'CAB promene %s se ne može serijalizovati.';
    $Self->{Translation}->{'Could not add the template.'} = 'Nije moguće dodati šablon.';

    # Perl Module: Kernel/Modules/AgentITSMChangeCondition.pm
    $Self->{Translation}->{'Change "%s" not found in database!'} = 'Promena "%s" nije nađena u bazi podataka!';
    $Self->{Translation}->{'Could not delete ConditionID %s!'} = 'Nije moguće obrisati ConditionID %s!';

    # Perl Module: Kernel/Modules/AgentITSMChangeConditionEdit.pm
    $Self->{Translation}->{'No %s is given!'} = 'Nije dat %s!';
    $Self->{Translation}->{'Could not create new condition!'} = 'Nije moguće kreirati novi uslov!';
    $Self->{Translation}->{'Could not update ConditionID %s!'} = 'Nije moguće ažurirati ConditionID %s!';
    $Self->{Translation}->{'Could not update ExpressionID %s!'} = 'Nije moguće ažurirati ExpressionID %s!';
    $Self->{Translation}->{'Could not add new Expression!'} = 'Nije moguće dodati novi Expression!';
    $Self->{Translation}->{'Could not update ActionID %s!'} = 'Nije moguće ažurirati ActionID %s!';
    $Self->{Translation}->{'Could not add new Action!'} = 'Nije moguće dodati novi Action!';
    $Self->{Translation}->{'Could not delete ExpressionID %s!'} = 'Nije moguće obrisati ExpressionID %s!';
    $Self->{Translation}->{'Could not delete ActionID %s!'} = 'Nije moguće obrisati ActionID %s!';
    $Self->{Translation}->{'Error: Unknown field type "%s"!'} = 'Greška: Nepoznat tip polja "%s"!';
    $Self->{Translation}->{'ConditionID %s does not belong to the given ChangeID %s!'} = 'ConditionID %s ne pripada datom ChangeID %s!';

    # Perl Module: Kernel/Modules/AgentITSMChangeDelete.pm
    $Self->{Translation}->{'Change "%s" does not have an allowed change state to be deleted!'} =
        'Promena "%s" nije u dozvoljenom stanju da bi bila obrisana!';
    $Self->{Translation}->{'Was not able to delete the changeID %s!'} = 'Nije bilo moguće obrisati ChangeID %s!';

    # Perl Module: Kernel/Modules/AgentITSMChangeEdit.pm
    $Self->{Translation}->{'Was not able to update Change!'} = 'Nije bilo moguće ažurirati promenu!';

    # Perl Module: Kernel/Modules/AgentITSMChangeHistory.pm
    $Self->{Translation}->{'Can\'t show history, as no ChangeID is given!'} = 'Ne može se prikazati istorijat, jer nije dat ChangeID!';
    $Self->{Translation}->{'Change "%s" not found in the database!'} = 'Promena "%s" nije nađena u bazi podataka!';
    $Self->{Translation}->{'Unknown type "%s" encountered!'} = 'Nepoznat tip "%s"!';
    $Self->{Translation}->{'Change History'} = 'Istorijat promene';

    # Perl Module: Kernel/Modules/AgentITSMChangeHistoryZoom.pm
    $Self->{Translation}->{'Can\'t show history zoom, no HistoryEntryID is given!'} = 'Ne mogu se prikazati detalji istorijata jer nije dat HistoryEntryID!';
    $Self->{Translation}->{'HistoryEntry "%s" not found in database!'} = 'Stavka istorijata "%s" nije nađena u bazi podataka!';

    # Perl Module: Kernel/Modules/AgentITSMChangeInvolvedPersons.pm
    $Self->{Translation}->{'Was not able to update Change CAB for Change %s!'} = 'Nije bilo moguće ažurirati CAB promen za promenu %s!';
    $Self->{Translation}->{'Was not able to update Change %s!'} = 'Nije bilo moguće ažurirati promenu %s!';

    # Perl Module: Kernel/Modules/AgentITSMChangeManager.pm
    $Self->{Translation}->{'Overview: ChangeManager'} = 'Pregled: Upravljač promenama';

    # Perl Module: Kernel/Modules/AgentITSMChangeMyCAB.pm
    $Self->{Translation}->{'Overview: My CAB'} = 'Pregled: Moj CAB';

    # Perl Module: Kernel/Modules/AgentITSMChangeMyChanges.pm
    $Self->{Translation}->{'Overview: My Changes'} = 'Pregled: Moje promene';

    # Perl Module: Kernel/Modules/AgentITSMChangeMyWorkOrders.pm
    $Self->{Translation}->{'Overview: My Workorders'} = 'Pregled: Moji radni nalozi';

    # Perl Module: Kernel/Modules/AgentITSMChangePIR.pm
    $Self->{Translation}->{'Overview: PIR'} = 'Pregled: PIR';

    # Perl Module: Kernel/Modules/AgentITSMChangePSA.pm
    $Self->{Translation}->{'Overview: PSA'} = 'Pregled: PSA';

    # Perl Module: Kernel/Modules/AgentITSMChangePrint.pm
    $Self->{Translation}->{'WorkOrder "%s" not found in database!'} = 'Radni nalog "%s" nije nađen u bazi podataka!';
    $Self->{Translation}->{'Can\'t create output, as the workorder is not attached to a change!'} =
        'Ne može se krirati izlaz jer radni nalog nije pridodat promeni!';
    $Self->{Translation}->{'Can\'t create output, as no ChangeID is given!'} = 'Ne može se krirati izlaz jer nije dat ChangeID!';
    $Self->{Translation}->{'unknown change title'} = 'nepoznat naslov promene';
    $Self->{Translation}->{'ITSM Workorder'} = 'ITSM radni nalog';
    $Self->{Translation}->{'WorkOrderNumber'} = 'Broj radnog naloga';
    $Self->{Translation}->{'WorkOrderTitle'} = 'Radni nalog - naslov';
    $Self->{Translation}->{'unknown workorder title'} = 'nepoznat naslov radnog naloga';
    $Self->{Translation}->{'ChangeState'} = 'Promena - status';
    $Self->{Translation}->{'PlannedEffort'} = 'Planirani napor';
    $Self->{Translation}->{'CAB Agents'} = 'Operateri CAB';
    $Self->{Translation}->{'CAB Customers'} = 'CAB klijenti';
    $Self->{Translation}->{'RequestedTime'} = 'Traženo vreme';
    $Self->{Translation}->{'PlannedStartTime'} = 'Planirano vreme početka';
    $Self->{Translation}->{'PlannedEndTime'} = 'Planirano vreme završetka';
    $Self->{Translation}->{'ActualStartTime'} = 'Stvarno vreme početka';
    $Self->{Translation}->{'ActualEndTime'} = 'Stvarno vreme završetka';
    $Self->{Translation}->{'ChangeTime'} = 'Vreme promene';
    $Self->{Translation}->{'ChangeNumber'} = 'Broj promene';
    $Self->{Translation}->{'WorkOrderState'} = 'Radni nalog - status';
    $Self->{Translation}->{'WorkOrderType'} = 'Radni nalog - tip';
    $Self->{Translation}->{'WorkOrderAgent'} = 'Radni nalog - operater';
    $Self->{Translation}->{'ITSM Workorder Overview (%s)'} = 'Pregled ITSM radnog naloga (%s)';

    # Perl Module: Kernel/Modules/AgentITSMChangeReset.pm
    $Self->{Translation}->{'Was not able to reset WorkOrder %s of Change %s!'} = 'Nije bilo moguće poništiti radni nalog %s za promenu %s!';
    $Self->{Translation}->{'Was not able to reset Change %s!'} = 'Nije bilo moguće poništiti promenu %s!';

    # Perl Module: Kernel/Modules/AgentITSMChangeSchedule.pm
    $Self->{Translation}->{'Overview: Change Schedule'} = 'Pregled: Planer promena';

    # Perl Module: Kernel/Modules/AgentITSMChangeSearch.pm
    $Self->{Translation}->{'Change Search'} = 'Pretraga promena';
    $Self->{Translation}->{'ChangeTitle'} = 'Promena - naslov';
    $Self->{Translation}->{'WorkOrders'} = 'Radni nalozi';
    $Self->{Translation}->{'Change Search Result'} = 'Rezultat pretrage promena';
    $Self->{Translation}->{'Change Number'} = 'Broj promene';
    $Self->{Translation}->{'Work Order Title'} = 'Naslov radnog naloga';
    $Self->{Translation}->{'Change Description'} = 'Opis promene';
    $Self->{Translation}->{'Change Justification'} = 'Opravdanost promene';
    $Self->{Translation}->{'WorkOrder Instruction'} = 'Uputsvo za radni nalog';
    $Self->{Translation}->{'WorkOrder Report'} = 'Izveštaj radnog naloga';
    $Self->{Translation}->{'Change Priority'} = 'Prioritet promene';
    $Self->{Translation}->{'Change Impact'} = 'Uticaj promene';
    $Self->{Translation}->{'Created By'} = 'Kreirao';
    $Self->{Translation}->{'WorkOrder State'} = 'Stanje radnog naloga';
    $Self->{Translation}->{'WorkOrder Type'} = 'Tip radnog naloga';
    $Self->{Translation}->{'WorkOrder Agent'} = 'Operater za radni nalog';
    $Self->{Translation}->{'before'} = 'pre';

    # Perl Module: Kernel/Modules/AgentITSMChangeTemplate.pm
    $Self->{Translation}->{'The change "%s" could not be serialized.'} = 'Promena %s se ne može serijalizovati.';
    $Self->{Translation}->{'Could not update the template "%s".'} = 'Nije moguće ažurirati šablon "%s".';
    $Self->{Translation}->{'Could not delete change "%s".'} = 'Nije moguće obrisati promenu "%s".';

    # Perl Module: Kernel/Modules/AgentITSMChangeTimeSlot.pm
    $Self->{Translation}->{'The change can\'t be moved, as it has no workorders.'} = 'Promena se ne može pomeriti jer nema radne naloge.';
    $Self->{Translation}->{'Add a workorder first.'} = 'Prvo dodaj radni nalog.';
    $Self->{Translation}->{'Can\'t move a change which already has started!'} = 'Promena koja je već pokrenuta se ne može pomerati!';
    $Self->{Translation}->{'Please move the individual workorders instead.'} = 'Molimo da umesto toga pomerite pojedine radne naloge.';
    $Self->{Translation}->{'The current %s could not be determined.'} = 'Aktuelna %s se ne može odrediti.';
    $Self->{Translation}->{'The %s of all workorders has to be defined.'} = '%s svih radnih naloga treba da bude definisan.';
    $Self->{Translation}->{'Was not able to move time slot for workorder #%s!'} = 'Nije bilo moguće premestiti termin za radni nalog #%s!';

    # Perl Module: Kernel/Modules/AgentITSMTemplateDelete.pm
    $Self->{Translation}->{'You need %s permission!'} = 'Potrebna vam je %s dozvola!';
    $Self->{Translation}->{'No TemplateID is given!'} = 'Nije dat TemplateID!';
    $Self->{Translation}->{'Template "%s" not found in database!'} = 'Šablon "%s" nije nađen u bazi podataka!';
    $Self->{Translation}->{'Was not able to delete the template %s!'} = 'Nije bilo moguće obrisati šablon %s!';

    # Perl Module: Kernel/Modules/AgentITSMTemplateEdit.pm
    $Self->{Translation}->{'Was not able to update Template %s!'} = 'Nije bilo moguće ažurirati šablon %s!';

    # Perl Module: Kernel/Modules/AgentITSMTemplateEditCAB.pm
    $Self->{Translation}->{'Was not able to update Template "%s"!'} = 'Nije bilo moguće ažurirati šablon "%s"!';

    # Perl Module: Kernel/Modules/AgentITSMTemplateEditContent.pm
    $Self->{Translation}->{'Was not able to create change!'} = 'Nije bilo moguće kreirati promenu!';
    $Self->{Translation}->{'Was not able to create workorder from template!'} = 'Nije bilo moguće kreirati radni nalog iz promene!';

    # Perl Module: Kernel/Modules/AgentITSMTemplateOverview.pm
    $Self->{Translation}->{'Overview: Template'} = 'Pregled: Šablon';

    # Perl Module: Kernel/Modules/AgentITSMWorkOrderAdd.pm
    $Self->{Translation}->{'You need %s permissions on the change!'} = 'Potrebne su vam %s dozvole za promenu!';
    $Self->{Translation}->{'Was not able to add workorder!'} = 'Nije bilo moguće dodati radni nalog!';

    # Perl Module: Kernel/Modules/AgentITSMWorkOrderAgent.pm
    $Self->{Translation}->{'No WorkOrderID is given!'} = 'Nije dat WorkOrderID!';
    $Self->{Translation}->{'Was not able to set the workorder agent of the workorder "%s" to empty!'} =
        'Nije bilo moguće podesiti radni nalog "%s" bez operatera!';
    $Self->{Translation}->{'Was not able to update the workorder "%s"!'} = 'Nije bilo moguće ažurirati radni nalog "%s"!';
    $Self->{Translation}->{'Could not find Change for WorkOrder %s!'} = 'Nije moguće pronaći promenu za radni nalog %s!';

    # Perl Module: Kernel/Modules/AgentITSMWorkOrderDelete.pm
    $Self->{Translation}->{'Was not able to delete the workorder %s!'} = 'Nije bilo moguće obrisati radni nalog %s!';

    # Perl Module: Kernel/Modules/AgentITSMWorkOrderEdit.pm
    $Self->{Translation}->{'Was not able to update WorkOrder %s!'} = 'Nije bilo moguće ažurirati radni nalog %s!';

    # Perl Module: Kernel/Modules/AgentITSMWorkOrderHistory.pm
    $Self->{Translation}->{'Can\'t show history, as no WorkOrderID is given!'} = 'Ne može se prikazati istorijat jer nije dat WorkOrderID!';
    $Self->{Translation}->{'WorkOrder "%s" not found in the database!'} = 'Radni nalog "%s" nije nađen u bazi podataka!';
    $Self->{Translation}->{'WorkOrder History'} = 'Istorijat radnog naloga';

    # Perl Module: Kernel/Modules/AgentITSMWorkOrderHistoryZoom.pm
    $Self->{Translation}->{'History entry "%s" not found in the database!'} = 'Stavka istorijata "%s" nije nađena u bazi podataka!';
    $Self->{Translation}->{'WorkOrder History Zoom'} = 'Detalji istorijata radnog naloga';

    # Perl Module: Kernel/Modules/AgentITSMWorkOrderTake.pm
    $Self->{Translation}->{'Was not able to take the workorder %s!'} = 'Nije bilo moguće preuzeti radni nalog %s!';

    # Perl Module: Kernel/Modules/AgentITSMWorkOrderTemplate.pm
    $Self->{Translation}->{'The workorder "%s" could not be serialized.'} = 'Radni nalog "%s" se ne može serijalizovati.';

    # Perl Module: Kernel/Output/HTML/Layout/ITSMChange.pm
    $Self->{Translation}->{'Need config option %s!'} = 'Potrebna konfiguraciona opcija %s!';
    $Self->{Translation}->{'Config option %s needs to be a HASH ref!'} = 'Konfiguraciona opcija %s mora biti HASH referenca!';
    $Self->{Translation}->{'No config option found for the view "%s"!'} = 'Nije pronađena konfiguraciona stavka za pregled "%s"!';
    $Self->{Translation}->{'Title: %s | Type: %s'} = 'Naslov: %s | Tip: %s';

    # Perl Module: Kernel/Output/HTML/ToolBar/MyCAB.pm
    $Self->{Translation}->{'My CABs'} = 'Moji CAB';

    # Perl Module: Kernel/Output/HTML/ToolBar/MyChanges.pm
    $Self->{Translation}->{'My Changes'} = 'Moje promene';

    # Perl Module: Kernel/Output/HTML/ToolBar/MyWorkOrders.pm
    $Self->{Translation}->{'My Work Orders'} = 'Moji radni nalozi';

    # Perl Module: Kernel/System/ITSMChange/History.pm
    $Self->{Translation}->{'%s: %s'} = '%s: %s';
    $Self->{Translation}->{'New Action (ID=%s)'} = 'Nova akcija (ID=%s)';
    $Self->{Translation}->{'Action (ID=%s) deleted'} = 'Obrisana akcija (ID=%s)';
    $Self->{Translation}->{'All Actions of Condition (ID=%s) deleted'} = 'Obrisane sve akcije uslova (ID=%s)';
    $Self->{Translation}->{'Action (ID=%s) executed: %s'} = 'Izvršena akcija (ID=%s): %s';
    $Self->{Translation}->{'%s (Action ID=%s): (new=%s, old=%s)'} = '%s (akcija ID=%s): (novo=%s, staro=%s)';
    $Self->{Translation}->{'Change (ID=%s) reached actual end time.'} = 'Promena (ID=%s) je dostigla stvarno vreme završetka.';
    $Self->{Translation}->{'Change (ID=%s) reached actual start time.'} = 'Promena (ID=%s) je dostigla stvarno vreme početka.';
    $Self->{Translation}->{'New Change (ID=%s)'} = 'Nova promena (ID=%s)';
    $Self->{Translation}->{'New Attachment: %s'} = 'Nov prilog: %s';
    $Self->{Translation}->{'Deleted Attachment %s'} = 'Obrisan prilog %s';
    $Self->{Translation}->{'CAB Deleted %s'} = 'Obrisan CAB %s';
    $Self->{Translation}->{'%s: (new=%s, old=%s)'} = '%s: (novo=%s, staro=%s)';
    $Self->{Translation}->{'Link to %s (ID=%s) added'} = 'Povezano sa %s (ID=%s)';
    $Self->{Translation}->{'Link to %s (ID=%s) deleted'} = 'Obrisana veza sa %s (ID=%s)';
    $Self->{Translation}->{'Notification sent to %s (Event: %s)'} = 'Poslato obaveštenje %s (događaj: %s)';
    $Self->{Translation}->{'Change (ID=%s) reached planned end time.'} = 'Promena (ID=%s) je dostigla planirano vreme završetka.';
    $Self->{Translation}->{'Change (ID=%s) reached planned start time.'} = 'Promena (ID=%s) je dostigla planirano vreme početka.';
    $Self->{Translation}->{'Change (ID=%s) reached requested time.'} = 'Promena (ID=%s) je dostigla traženo vreme.';
    $Self->{Translation}->{'New Condition (ID=%s)'} = 'Nov uslov (ID=%s)';
    $Self->{Translation}->{'Condition (ID=%s) deleted'} = 'Obrisan uslov (ID=%s)';
    $Self->{Translation}->{'All Conditions of Change (ID=%s) deleted'} = 'Obrisani svi uslovi promene (ID=%s)';
    $Self->{Translation}->{'%s (Condition ID=%s): (new=%s, old=%s)'} = '%s (uslov ID=%s): (novo=%s, staro=%s)';
    $Self->{Translation}->{'New Expression (ID=%s)'} = 'Nov izraz (ID=%s)';
    $Self->{Translation}->{'Expression (ID=%s) deleted'} = 'Obrisan izraz (ID=%s)';
    $Self->{Translation}->{'All Expressions of Condition (ID=%s) deleted'} = 'Obrisani svi izrazi uslova (ID=%s)';
    $Self->{Translation}->{'%s (Expression ID=%s): (new=%s, old=%s)'} = '%s (izraz ID=%s): (novo=%s, staro=%s)';
    $Self->{Translation}->{'Workorder (ID=%s) reached actual end time.'} = 'Radni nalog (ID=%s) je dostigao stvarno vreme završetka.';
    $Self->{Translation}->{'Workorder (ID=%s) reached actual start time.'} = 'Radni nalog (ID=%s) je dostigao stvarno vreme početka.';
    $Self->{Translation}->{'New Workorder (ID=%s)'} = 'Novi radni nalog (ID=%s)';
    $Self->{Translation}->{'New Attachment for WorkOrder: %s'} = 'Nov prilog za radni nalog: %s';
    $Self->{Translation}->{'(ID=%s) New Attachment for WorkOrder: %s'} = '(ID=%s) Nov prilog za radni nalog: %s';
    $Self->{Translation}->{'Deleted Attachment from WorkOrder: %s'} = 'Obrisan prilog za radni nalog: %s';
    $Self->{Translation}->{'(ID=%s) Deleted Attachment from WorkOrder: %s'} = '(ID=%s) Obrisan prilog za radni nalog: %s';
    $Self->{Translation}->{'New Report Attachment for WorkOrder: %s'} = 'Nov prilog izveštaja za radni nalog: %s';
    $Self->{Translation}->{'(ID=%s) New Report Attachment for WorkOrder: %s'} = '(ID=%s) Nov prilog izveštaja za radni nalog: %s';
    $Self->{Translation}->{'Deleted Report Attachment from WorkOrder: %s'} = 'Obrisan prilog izveštaja za radni nalog: %s';
    $Self->{Translation}->{'(ID=%s) Deleted Report Attachment from WorkOrder: %s'} = '(ID=%s) Obrisan prilog izveštaja za radni nalog: %s';
    $Self->{Translation}->{'Workorder (ID=%s) deleted'} = 'Obrisan radni nalog (ID=%s)';
    $Self->{Translation}->{'(ID=%s) Link to %s (ID=%s) added'} = '(ID=%s) Povezano sa %s (ID=%s)';
    $Self->{Translation}->{'(ID=%s) Link to %s (ID=%s) deleted'} = '(ID=%s) Obrisana veza sa %s (ID=%s)';
    $Self->{Translation}->{'(ID=%s) Notification sent to %s (Event: %s)'} = '(ID=%s) Poslato obaveštenje %s (događaj: %s)';
    $Self->{Translation}->{'Workorder (ID=%s) reached planned end time.'} = 'Radni nalog (ID=%s) je dostigao planirano vreme završetka.';
    $Self->{Translation}->{'Workorder (ID=%s) reached planned start time.'} = 'Radni nalog (ID=%s) je dostigao planirano vreme početka.';
    $Self->{Translation}->{'(ID=%s) %s: (new=%s, old=%s)'} = '(ID=%s) %s: (novo=%s, staro=%s)';

    # Perl Module: Kernel/System/ITSMChange/ITSMCondition/Object/ITSMWorkOrder.pm
    $Self->{Translation}->{'all'} = 'sve';
    $Self->{Translation}->{'any'} = 'svaki';

    # Perl Module: Kernel/System/ITSMChange/Notification.pm
    $Self->{Translation}->{'Previous Change Builder'} = 'Prethodni graditelj promene';
    $Self->{Translation}->{'Previous Change Manager'} = 'Prethodni upravnih promene';
    $Self->{Translation}->{'Workorder Agents'} = 'Operateri radnog naloga';
    $Self->{Translation}->{'Previous Workorder Agent'} = 'Prethodni operater radnog naloga';
    $Self->{Translation}->{'Change Initiators'} = 'Inicijatori promene';
    $Self->{Translation}->{'Group ITSMChange'} = 'Grupa ITSMChange';
    $Self->{Translation}->{'Group ITSMChangeBuilder'} = 'Grupa ITSMChangeBuilder';
    $Self->{Translation}->{'Group ITSMChangeManager'} = 'Grupa ITSMChangeManager';

    # Database XML Definition: ITSMChangeManagement.sopm
    $Self->{Translation}->{'requested'} = 'zahtevano';
    $Self->{Translation}->{'pending approval'} = 'odobrenje na čekanju';
    $Self->{Translation}->{'rejected'} = 'odbijeno';
    $Self->{Translation}->{'approved'} = 'odobreno';
    $Self->{Translation}->{'in progress'} = 'u toku';
    $Self->{Translation}->{'pending pir'} = 'PIR na čekanju';
    $Self->{Translation}->{'successful'} = 'uspešno';
    $Self->{Translation}->{'failed'} = 'neuspešno';
    $Self->{Translation}->{'canceled'} = 'otkazano';
    $Self->{Translation}->{'retracted'} = 'povučeno';
    $Self->{Translation}->{'created'} = 'kreirano';
    $Self->{Translation}->{'accepted'} = 'prihvaćeno';
    $Self->{Translation}->{'ready'} = 'spremno';
    $Self->{Translation}->{'approval'} = 'odobrenje';
    $Self->{Translation}->{'workorder'} = 'radni nalog';
    $Self->{Translation}->{'backout'} = 'odustanak';
    $Self->{Translation}->{'decision'} = 'odluka';
    $Self->{Translation}->{'pir'} = 'PIR';
    $Self->{Translation}->{'ChangeStateID'} = 'ChangeStateID';
    $Self->{Translation}->{'CategoryID'} = 'ID Kategorije';
    $Self->{Translation}->{'ImpactID'} = 'ID uticaja';
    $Self->{Translation}->{'PriorityID'} = 'ID prioriteta';
    $Self->{Translation}->{'ChangeManagerID'} = 'ChangeManagerID';
    $Self->{Translation}->{'ChangeBuilderID'} = 'ChangeBuilderID';
    $Self->{Translation}->{'WorkOrderStateID'} = 'WorkOrderStateID';
    $Self->{Translation}->{'WorkOrderTypeID'} = 'WorkOrderTypeID';
    $Self->{Translation}->{'WorkOrderAgentID'} = 'WorkOrderAgentID';
    $Self->{Translation}->{'is'} = 'je';
    $Self->{Translation}->{'is not'} = 'nije';
    $Self->{Translation}->{'is empty'} = 'je prazno';
    $Self->{Translation}->{'is not empty'} = 'nije prazno';
    $Self->{Translation}->{'is greater than'} = 'je veće od';
    $Self->{Translation}->{'is less than'} = 'je manje od';
    $Self->{Translation}->{'is before'} = 'je pre';
    $Self->{Translation}->{'is after'} = 'je posle';
    $Self->{Translation}->{'contains'} = 'sadrži';
    $Self->{Translation}->{'not contains'} = 'ne sadrži';
    $Self->{Translation}->{'begins with'} = 'počinje sa';
    $Self->{Translation}->{'ends with'} = 'završava sa';
    $Self->{Translation}->{'set'} = 'podesi';

    # JS File: ITSM.Agent.ChangeManagement.Condition
    $Self->{Translation}->{'Do you really want to delete this expression?'} = 'Da li stvarno želite da obrišete ovaj izraz?';
    $Self->{Translation}->{'Do you really want to delete this action?'} = 'Da li stvarno želite da obrišete ovu akciju?';
    $Self->{Translation}->{'Do you really want to delete this condition?'} = 'Da li zaista želite da obrišete ovaj uslov?';

    # JS File: ITSM.Agent.ChangeManagement.ConfirmDialog
    $Self->{Translation}->{'Ok'} = 'U redu';

    # SysConfig
    $Self->{Translation}->{'A list of the agents who have permission to take workorders. Key is a login name. Content is 0 or 1.'} =
        'Lista operatera koji imaju dozvolu preuzimanja radnih naloga. Ključ je korisničko ime. Sadržaj je 0 ili 1.';
    $Self->{Translation}->{'A list of workorder states, at which the ActualStartTime of a workorder will be set if it was empty at this point.'} =
        'Lista statusa radnog naloga, pri kojima će aktuelno vreme početka radnog naloga, biti postavljeno ako je prazno u ovom momentu. ';
    $Self->{Translation}->{'Actual end time'} = 'Stvarno vreme završetka';
    $Self->{Translation}->{'Actual start time'} = 'Stvarno vreme početka';
    $Self->{Translation}->{'Add Workorder'} = 'Dodaj radni nalog';
    $Self->{Translation}->{'Add Workorder (from Template)'} = 'Dodaj radni nalog (od šablona)';
    $Self->{Translation}->{'Add a change from template.'} = 'Dodaj promenu iz šablona.';
    $Self->{Translation}->{'Add a change.'} = 'Dodaj promenu.';
    $Self->{Translation}->{'Add a workorder (from template) to the change.'} = 'Dodaj radni nalog promeni (od šablona).';
    $Self->{Translation}->{'Add a workorder to the change.'} = 'Dodaj radni nalog promeni.';
    $Self->{Translation}->{'Add from template'} = 'Dodaj iz šablona';
    $Self->{Translation}->{'Admin of the CIP matrix.'} = 'Administracija CIP matrice.';
    $Self->{Translation}->{'Admin of the state machine.'} = 'Administracija mašine stanja';
    $Self->{Translation}->{'Agent interface notification module to see the number of change advisory boards.'} =
        'Modul interfejsa operatera za obaveštavanje, pregled broja Savetodavnih Odbora za Promene.';
    $Self->{Translation}->{'Agent interface notification module to see the number of changes managed by the user.'} =
        'Modul interfejsa operatera za obaveštavanje, pregled broja promena kojima upravlja korisnik.';
    $Self->{Translation}->{'Agent interface notification module to see the number of changes.'} =
        'Modul interfejsa operatera za obaveštavanje, pregled broja promena.';
    $Self->{Translation}->{'Agent interface notification module to see the number of workorders.'} =
        'Modul obaveštavanja u interfejsu operatera za prikaz broja radnih naloga.';
    $Self->{Translation}->{'CAB Member Search'} = 'Pretraga članova CAB';
    $Self->{Translation}->{'Cache time in minutes for the change management toolbars. Default: 3 hours (180 minutes).'} =
        'Vreme keširanja u minutama za alatne trake upravljača promenama. Podrazumevano 3 sata (180 minuta).';
    $Self->{Translation}->{'Cache time in minutes for the change management. Default: 5 days (7200 minutes).'} =
        'Vreme keširanja u minutima za upravljanje promenama. Podrazumevano: 5 dana (7200 minuta).';
    $Self->{Translation}->{'Change CAB Templates'} = 'Šabloni promena CAB';
    $Self->{Translation}->{'Change History.'} = 'Istorijat promene.';
    $Self->{Translation}->{'Change Involved Persons.'} = 'Osobe uključene u promenu.';
    $Self->{Translation}->{'Change Overview "Small" Limit'} = 'Ograničenje pregleda promena malog formata';
    $Self->{Translation}->{'Change Overview.'} = 'Pregled promene.';
    $Self->{Translation}->{'Change Print.'} = 'Štampa promene.';
    $Self->{Translation}->{'Change Schedule'} = 'Planer promena';
    $Self->{Translation}->{'Change Schedule.'} = 'Planer promena.';
    $Self->{Translation}->{'Change Settings'} = 'Promeni podešavanja';
    $Self->{Translation}->{'Change Zoom'} = 'Detalji promene.';
    $Self->{Translation}->{'Change Zoom.'} = 'Detalji promene.';
    $Self->{Translation}->{'Change and Workorder Templates'} = 'Izmeni šablone radnog naloga';
    $Self->{Translation}->{'Change and workorder templates edited by this user.'} = 'Šabloni promena i radnih naloga koje je menjao ovaj korisnik.';
    $Self->{Translation}->{'Change area.'} = 'Prostor promene.';
    $Self->{Translation}->{'Change involved persons of the change.'} = 'Izmeni osobe uključene u ovu promenu.';
    $Self->{Translation}->{'Change limit per page for Change Overview "Small".'} = 'Ograničenje broja promena po stranici za pregled malog formata.';
    $Self->{Translation}->{'Change number'} = 'Broj promene';
    $Self->{Translation}->{'Change search backend router of the agent interface.'} = 'Pozadinski modul pretrage za promene u interfejsu operatera';
    $Self->{Translation}->{'Change state'} = 'Stanje promene';
    $Self->{Translation}->{'Change time'} = 'Vreme promene';
    $Self->{Translation}->{'Change title'} = 'Naslov promene';
    $Self->{Translation}->{'Condition Edit'} = 'Uredi uslov';
    $Self->{Translation}->{'Condition Overview'} = 'Pregled uslova';
    $Self->{Translation}->{'Configure which screen should be shown after a new workorder has been created.'} =
        'Konfiguriše koji ekran bi trebalo prikazati nakon kreiranja novog radnog naloga.';
    $Self->{Translation}->{'Configures how often the notifications are sent when planned the start time or other time values have been reached/passed.'} =
        'Definiše koliko često se šalju obaveštenja kada su planirana vremena početka ili druge vremenske vrednosti dostignuta/prošla.';
    $Self->{Translation}->{'Create Change'} = 'Napravi promenu';
    $Self->{Translation}->{'Create Change (from Template)'} = 'Napravi promenu (od šablona)';
    $Self->{Translation}->{'Create a change (from template) from this ticket.'} = 'Napravi promenu (od šablona) iz ovog tiketa.';
    $Self->{Translation}->{'Create a change from this ticket.'} = 'Napravi promenu iz ovog tiketa.';
    $Self->{Translation}->{'Create and manage ITSM Change Management notifications.'} = 'Kreiranje i upravljanje obaveštenjima ITSM upravljanjem promenama.';
    $Self->{Translation}->{'Create and manage change notifications.'} = 'Kreiranje i upravljanje obaveštenjima o promeni.';
    $Self->{Translation}->{'Default type for a workorder. This entry must exist in general catalog class \'ITSM::ChangeManagement::WorkOrder::Type\'.'} =
        'Podrazumeveni tip radnog naloga. Ovaj unos mora da postoji u klasi opšteg kataloga \'ITSM::ChangeManagement::WorkOrder::Type\'.';
    $Self->{Translation}->{'Define Actions where a settings button is available in the linked objects widget (LinkObject::ViewMode = "complex"). Please note that these Actions must have registered the following JS and CSS files: Core.AllocationList.css, Core.UI.AllocationList.js, Core.UI.Table.Sort.js, Core.Agent.TableFilters.js and Core.Agent.LinkObject.js.'} =
        'Definiše akcije gde je dugme postavki dostupno u povezanom grafičkom elementu objekta (LinkObject::ViewMode = "complex"). Molimo da imate na umu da ove Akcije moraju da budu registrovane u sledećim JS i CSS datotekama: Core.AllocationList.css, Core.UI.AllocationList.js, Core.UI.Table.Sort.js, Core.Agent.TableFilters.js i Core.Agent.LinkObject.js.';
    $Self->{Translation}->{'Define the signals for each workorder state.'} = 'Definiše signale za svaki status radnog naloga.';
    $Self->{Translation}->{'Define which columns are shown in the linked Changes widget (LinkObject::ViewMode = "complex"). Note: Only Change attributes are allowed for DefaultColumns. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default.'} =
        'Definiše koje kolone su prikazane u povezanom grafičkom elementu promena (LinkObject::ViewMode = "complex"). Napomena: Samo atributi promene su dozvoljeni za podrazumevane kolone. Moguće postavke: 0 = onemogućeno, 1 = dostupno, 2 = podrazumevano aktivirano.';
    $Self->{Translation}->{'Define which columns are shown in the linked Workorder widget (LinkObject::ViewMode = "complex"). Note: Only Workorder attributes are allowed for DefaultColumns. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default.'} =
        'Definiše koje kolone su prikazane u povezanom grafičkom elementu Radnog naloga (LinkObject::ViewMode = "complex"). Napomena: Samo atributi radnog naloga su dozvoljeni za podrazumevane kolone. Moguće postavke: 0 = onemogućeno, 1 = dostupno, 2 = podrazumevano aktivirano.';
    $Self->{Translation}->{'Defines an overview module to show the small view of a change list.'} =
        'Određuje modul pregleda za mali prikaz liste promena. ';
    $Self->{Translation}->{'Defines an overview module to show the small view of a template list.'} =
        'Određuje modul pregleda za mali prikaz liste šablona. ';
    $Self->{Translation}->{'Defines if it will be possible to print the accounted time.'} = 'Definiše da li jemoguće štampanje obračunatog vremena.';
    $Self->{Translation}->{'Defines if it will be possible to print the planned effort.'} = 'Određuje da li će biti moguće štampanje planiranih napora.';
    $Self->{Translation}->{'Defines if reachable (as defined by the state machine) change end states should be allowed if a change is in a locked state.'} =
        'Određuje da li dostupne (kao što je određeno u mašini stanja) promene i statusi treba da budu dozvoljeni ako je promena u zaključanom statusu.';
    $Self->{Translation}->{'Defines if reachable (as defined by the state machine) workorder end states should be allowed if a workorder is in a locked state.'} =
        'Određuje da li dostupni (kao što je određeno u mašini stanja) radni nalozi i statusi treba da budu dozvoljeni ako je radni nalog u zaključanom statusu.';
    $Self->{Translation}->{'Defines if the accounted time should be shown.'} = 'Definiše da li obračunato vreme treba da bude prikazano.';
    $Self->{Translation}->{'Defines if the actual start and end times should be set.'} = 'Definiše da li aktuelna vremena početka i završetka treba da se podese.';
    $Self->{Translation}->{'Defines if the change search and the workorder search functions could use the mirror DB.'} =
        'Određuje da li funkcije pretrage promena i pretrage radnih naloga mogu da koriste preslikanu bazu podataka.';
    $Self->{Translation}->{'Defines if the change state can be set in the change edit screen of the agent interface.'} =
        'Definiše da li stanje promene može biti postavljenu u ekranu izmena u interfejsu operatera.';
    $Self->{Translation}->{'Defines if the planned effort should be shown.'} = 'Određuje da li planirani napor treba da bude prikazan.';
    $Self->{Translation}->{'Defines if the requested date should be print by customer.'} = 'Definiše da li klijent treba da štampa traženi datum.';
    $Self->{Translation}->{'Defines if the requested date should be searched by customer.'} =
        'Definiše da li klijent može da pretražuje traženi datum.';
    $Self->{Translation}->{'Defines if the requested date should be set by customer.'} = 'Definiše da li klijent može da podesi traženi datum.';
    $Self->{Translation}->{'Defines if the requested date should be shown by customer.'} = 'Definiše da li klijent može da prikaže traženi datum.';
    $Self->{Translation}->{'Defines if the workorder state should be shown.'} = 'Definiše da li će status radnog naloga biti prikazan.';
    $Self->{Translation}->{'Defines if the workorder title should be shown.'} = 'Definiše da li će naslov radnog naloga biti prikazan.';
    $Self->{Translation}->{'Defines shown graph attributes.'} = 'Definiše atribute prikazanog grafikona.';
    $Self->{Translation}->{'Defines that only changes containing Workorders linked with services, which the customer user has permission to use will be shown. Any other changes will not be displayed.'} =
        'Definiše da će biti prikazane samo promene koje sadrže radne naloge povezane sa servisima, za koje klijent korisnik ima dozvolu upotrebe. Sve druge promene neće biti prikazane.';
    $Self->{Translation}->{'Defines the change states that will be allowed to delete.'} = 'Definiše stanja promena koja je dozvoljeno da se obrišu.';
    $Self->{Translation}->{'Defines the change states that will be used as filters in the Change PSA overview.'} =
        'Definiše statuse promena koji će biti korišteni kao filteri u PDS pregledu promena.';
    $Self->{Translation}->{'Defines the change states that will be used as filters in the Change Schedule overview.'} =
        'Određuje statuse promena koje će biti korištene kao filteri u pregledu planera promena.';
    $Self->{Translation}->{'Defines the change states that will be used as filters in the MyCAB overview.'} =
        'Definiše statuse promena koji će biti korišteni kao filteri u pregledu mojih promena.';
    $Self->{Translation}->{'Defines the change states that will be used as filters in the MyChanges overview.'} =
        'Određuje statuse promena koje će biti korištene kao filteri u pregledu mojih promena.';
    $Self->{Translation}->{'Defines the change states that will be used as filters in the change manager overview.'} =
        'Određuje statuse promena koje će biti korištene kao filteri u pregledu upravljača promenama.';
    $Self->{Translation}->{'Defines the change states that will be used as filters in the change overview.'} =
        'Određuje statuse promena koje će biti korištene kao filteri u pregledu promena.';
    $Self->{Translation}->{'Defines the change states that will be used as filters in the customer change schedule overview.'} =
        'Određuje statuse promena koje će biti korištene kao filteri u pregledu klijentskog planera promena.';
    $Self->{Translation}->{'Defines the default change title for a dummy change which is needed to edit a workorder template.'} =
        'Određuje podrazumevani naslov prazne promene koja je potrebna za izmenu šablona radnog naloga.';
    $Self->{Translation}->{'Defines the default sort criteria in the change PSA overview.'} =
        'Definiše podrazumevani kriterijum sortiranja u PSA pregledu promena.';
    $Self->{Translation}->{'Defines the default sort criteria in the change manager overview.'} =
        'Određuje podrazumevane uslove sortiranja u pregledu upravljača promenama.';
    $Self->{Translation}->{'Defines the default sort criteria in the change overview.'} = 'Definiše podrazumevani kriterijum sortiranja u pregledu promena.';
    $Self->{Translation}->{'Defines the default sort criteria in the change schedule overview.'} =
        'Definiše podrazumevani kriterijum sortiranja u pregledu planera promena.';
    $Self->{Translation}->{'Defines the default sort criteria of the changes in the MyCAB overview.'} =
        'Definiše podrazumevani kriterijum sortiranja u pregledu promena mojih CAB.';
    $Self->{Translation}->{'Defines the default sort criteria of the changes in the MyChanges overview.'} =
        'Određuje podrazumevane uslove sortiranja promena u pregledu mojih promena.';
    $Self->{Translation}->{'Defines the default sort criteria of the changes in the MyWorkorders overview.'} =
        'Određuje podrazumevane uslove sortiranja promena u pregledu mojih radnih naloga.';
    $Self->{Translation}->{'Defines the default sort criteria of the changes in the PIR overview.'} =
        'Definiše podrazumevani kriterijum sortiranja u pregledu PIR promena.';
    $Self->{Translation}->{'Defines the default sort criteria of the changes in the customer change schedule overview.'} =
        'Određuje podrazumevane uslove sortiranja promena u pregledu klijentskog planera promena.';
    $Self->{Translation}->{'Defines the default sort criteria of the changes in the template overview.'} =
        'Definiše podrazumevani kriterijum sortiranja promena u pregledu šablona.';
    $Self->{Translation}->{'Defines the default sort order in the MyCAB overview.'} = 'Definiše podrazumevani kriterijum sortiranja u pregledu mojih CAB.';
    $Self->{Translation}->{'Defines the default sort order in the MyChanges overview.'} = 'Određuje podrazumevane uslove sortiranja u pregledu mojih promena.';
    $Self->{Translation}->{'Defines the default sort order in the MyWorkorders overview.'} =
        'Određuje podrazumevane uslove sortiranja u pregledu mojih radnih naloga.';
    $Self->{Translation}->{'Defines the default sort order in the PIR overview.'} = 'Definiše podrazumevani kriterijum sortiranja u pregledu PIR.';
    $Self->{Translation}->{'Defines the default sort order in the change PSA overview.'} = 'Definiše podrazumevani kriterijum sortiranja u pregledu PSA promena.';
    $Self->{Translation}->{'Defines the default sort order in the change manager overview.'} =
        'Određuje podrazumevane uslove sortiranja u pregledu upravljača promenama.';
    $Self->{Translation}->{'Defines the default sort order in the change overview.'} = 'Definiše podrazumevani redosled u pregledu promena.';
    $Self->{Translation}->{'Defines the default sort order in the change schedule overview.'} =
        'Definiše podrazumevani redosled u pregledu planera promena.';
    $Self->{Translation}->{'Defines the default sort order in the customer change schedule overview.'} =
        'Određuje podrazumevane uslove sortiranja u pregledu klijentskog planera promena.';
    $Self->{Translation}->{'Defines the default sort order in the template overview.'} = 'Definiše podrazumevani redosled u pregledu šablona.';
    $Self->{Translation}->{'Defines the default value for the category of a change.'} = 'Definiše podrazumevanu vrednost za kategoriju promene.';
    $Self->{Translation}->{'Defines the default value for the impact of a change.'} = 'Definiše podrazumevanu vrednost za uticaj promene.';
    $Self->{Translation}->{'Defines the field type of CompareValue fields for change attributes used in the change condition edit screen of the agent interface. Valid values are Selection, Text and Date. If a type is not defined, the field will not be shown.'} =
        'Definiše tip polja za CompareValue atribute promena u ekranu izmena uslova promena u interfejsu operatera. Ispravne vrednosti su Selection, Text i Date. Ukoliko tip nije definisan, polje neće biti prikazano.';
    $Self->{Translation}->{'Defines the field type of CompareValue fields for workorder attributes used in the change condition edit screen of the agent interface. Valid values are Selection, Text and Date. If a type is not defined, the field will not be shown.'} =
        'Definiše tip polja za CompareValue atribute radnih naloga u ekranu izmena uslova promena u interfejsu operatera. Ispravne vrednosti su Selection, Text i Date. Ukoliko tip nije definisan, polje neće biti prikazano.';
    $Self->{Translation}->{'Defines the object attributes that are selectable for change objects in the change condition edit screen of the agent interface.'} =
        'Određuje koje atribute objekta je moguće izabrati za objekat promene u ekranu izmena uslova promene u interfejsu operatera.';
    $Self->{Translation}->{'Defines the object attributes that are selectable for workorder objects in the change condition edit screen of the agent interface.'} =
        'Određuje koje atribute objekta je moguće izabrati za objekat radnog naloga u ekranu izmena uslova promene u interfejsu operatera.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute AccountedTime in the change condition edit screen of the agent interface.'} =
        'Određuje koje operatore je moguće izabrati za atribut AccountedTime u ekranu izmena uslova promena u interfejsu operatera.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute ActualEndTime in the change condition edit screen of the agent interface.'} =
        'Određuje koje operatore je moguće izabrati za atribut ActualEndTime u ekranu izmena uslova promene u interfejsu operatera.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute ActualStartTime in the change condition edit screen of the agent interface.'} =
        'Određuje koje operatore je moguće izabrati za atribut ActualStartTime u ekranu izmena uslova promene u interfejsu operatera.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute CategoryID in the change condition edit screen of the agent interface.'} =
        'Određuje koje operatore je moguće izabrati za atribut CategoryID u ekranu izmena uslova promene u interfejsu operatera.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute ChangeBuilderID in the change condition edit screen of the agent interface.'} =
        'Određuje koje operatore je moguće izabrati za atribut ChangeBuilderID u ekranu izmena uslova promene u interfejsu operatera.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute ChangeManagerID in the change condition edit screen of the agent interface.'} =
        'Određuje koje operatore je moguće izabrati za atribut ChangeManagerID u ekranu izmena uslova promene u interfejsu operatera.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute ChangeStateID in the change condition edit screen of the agent interface.'} =
        'Određuje koje operatore je moguće izabrati za atribut ChangeStateID u ekranu izmena uslova promene u interfejsu operatera.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute ChangeTitle in the change condition edit screen of the agent interface.'} =
        'Određuje koje operatore je moguće izabrati za atribut ChangeTitle u ekranu izmena uslova promene u interfejsu operatera.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute DynamicField in the change condition edit screen of the agent interface.'} =
        'Određuje koje operatore je moguće izabrati za atribut DynamicField u ekranu izmena uslova promene u interfejsu operatera.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute ImpactID in the change condition edit screen of the agent interface.'} =
        'Određuje koje operatore je moguće izabrati za atribut ImpactID u ekranu izmena uslova promene u interfejsu operatera.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute PlannedEffort in the change condition edit screen of the agent interface.'} =
        'Određuje koje operatore je moguće izabrati za atribut PlannedEffort u ekranu izmena uslova promene u interfejsu operatera.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute PlannedEndTime in the change condition edit screen of the agent interface.'} =
        'Određuje koje operatore je moguće izabrati za atribut PlannedEndTime u ekranu izmena uslova promene u interfejsu operatera.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute PlannedStartTime in the change condition edit screen of the agent interface.'} =
        'Određuje koje operatore je moguće izabrati za atribut PlannedStartTime u ekranu izmena uslova promene u interfejsu operatera.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute PriorityID in the change condition edit screen of the agent interface.'} =
        'Određuje koje operatore je moguće izabrati za atribut PriorityID u ekranu izmena uslova promene u interfejsu operatera.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute RequestedTime in the change condition edit screen of the agent interface.'} =
        'Određuje koje operatore je moguće izabrati za atribut RequestedTime u ekranu izmena uslova promene u interfejsu operatera.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute WorkOrderAgentID in the change condition edit screen of the agent interface.'} =
        'Određuje koje operatore je moguće izabrati za atribut WorkOrderAgentID u ekranu izmena uslova promene u interfejsu operatera.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute WorkOrderNumber in the change condition edit screen of the agent interface.'} =
        'Određuje koje operatore je moguće izabrati za atribut WorkOrderNumber u ekranu izmena uslova promene u interfejsu operatera.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute WorkOrderStateID in the change condition edit screen of the agent interface.'} =
        'Određuje koje operatore je moguće izabrati za atribut WorkOrderStateID u ekranu izmena uslova promene u interfejsu operatera.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute WorkOrderTitle in the change condition edit screen of the agent interface.'} =
        'Određuje koje operatore je moguće izabrati za atribut WorkOrderTitle u ekranu izmena uslova promene u interfejsu operatera.';
    $Self->{Translation}->{'Defines the operators that are selectable for the attribute WorkOrderTypeID in the change condition edit screen of the agent interface.'} =
        'Određuje koje operatore je moguće izabrati za atribut WorkOrderTypeID u ekranu izmena uslova promene u interfejsu operatera.';
    $Self->{Translation}->{'Defines the period (in years), in which start and end times can be selected.'} =
        'Određuje period (u godinama), unutar kog je moguće izabrati vremena početka i završetka.';
    $Self->{Translation}->{'Defines the shown attributes of a workorder in the tooltip of the workorder graph in the change zoom. To show workorder dynamic fields in the tooltip, they must be specified like DynamicField_WorkOrderFieldName1, DynamicField_WorkOrderFieldName2, etc.'} =
        'Definiše prikazane atribute u porukama na grafiku radnih naloga u detaljnom ekranu promena. Za prikaz dinamičkih polja radnih naloga u porukama, moraju biti definisani kao DynamicField_WorkOrderFieldName1, DynamicField_WorkOrderFieldName2, itd.';
    $Self->{Translation}->{'Defines the shown columns in the Change PSA overview. This option has no effect on the position of the column.'} =
        'Određuje kolone prikazane u pregledu PSA promena. Ova opcija nema uticaj na pozicije kolona.';
    $Self->{Translation}->{'Defines the shown columns in the Change Schedule overview. This option has no effect on the position of the column.'} =
        'Određuje kolone prikazane u pregledu planera promena. Ova opcija nema uticaj na pozicije kolona.';
    $Self->{Translation}->{'Defines the shown columns in the MyCAB overview. This option has no effect on the position of the column.'} =
        'Određuje kolone prikazane u pregledu mojih CAB. Ova opcija nema uticaj na pozicije kolona.';
    $Self->{Translation}->{'Defines the shown columns in the MyChanges overview. This option has no effect on the position of the column.'} =
        'Određuje kolone prikazane u pregledu mojih promena. Ova opcija nema uticaj na pozicije kolona.';
    $Self->{Translation}->{'Defines the shown columns in the MyWorkorders overview. This option has no effect on the position of the column.'} =
        'Određuje kolone prikazane u pregledu mojih radnih naloga. Ova opcija nema uticaj na pozicije kolona.';
    $Self->{Translation}->{'Defines the shown columns in the PIR overview. This option has no effect on the position of the column.'} =
        'Definiše prikazane kolone u pregledu PIR. Ova opcije nema uticaj na pozicije kolona.';
    $Self->{Translation}->{'Defines the shown columns in the change manager overview. This option has no effect on the position of the column.'} =
        'Određuje prikazane kolone u pregledu upravljača promenama. Ova opcije nema uticaj na pozicije kolona.';
    $Self->{Translation}->{'Defines the shown columns in the change overview. This option has no effect on the position of the column.'} =
        'Određuje prikazane kolone u pregledu promena. Ova opcije nema uticaj na pozicije kolona.';
    $Self->{Translation}->{'Defines the shown columns in the change search. This option has no effect on the position of the column.'} =
        'Određuje prikazane kolone u pretrazi promena. Ova opcije nema uticaj na pozicije kolona.';
    $Self->{Translation}->{'Defines the shown columns in the customer change schedule overview. This option has no effect on the position of the column.'} =
        'Određuje prikazane kolone u pregledu klijentskog planera promena. Ova opcije nema uticaj na pozicije kolona.';
    $Self->{Translation}->{'Defines the shown columns in the template overview. This option has no effect on the position of the column.'} =
        'Određuje prikazane kolone u pregledu šablona. Ova opcije nema uticaj na pozicije kolona.';
    $Self->{Translation}->{'Defines the signals for each ITSM change state.'} = 'Određuje signale za svaki status ITSM promene.';
    $Self->{Translation}->{'Defines the template types that will be used as filters in the template overview.'} =
        'Određuje tipove šablona koji će biti korišteni kao filteri u pregledu šablona.';
    $Self->{Translation}->{'Defines the workorder states that will be used as filters in the MyWorkorders overview.'} =
        'Određuje statuse radnih naloga koji će biti korišteni kao filteri u pregledu mojih radnih naloga.';
    $Self->{Translation}->{'Defines the workorder states that will be used as filters in the PIR overview.'} =
        'Određuje statuse radnih naloga koji će se koristiti kao filteri u pregledu PIR.';
    $Self->{Translation}->{'Defines the workorder types that will be used to show the PIR overview.'} =
        'Određuje tipove radnih naloga koji će se koristiti za prikaz PIR pregleda.';
    $Self->{Translation}->{'Defines whether notifications should be sent.'} = 'Određuje da li će obaveštenja biti poslata.';
    $Self->{Translation}->{'Delete a change.'} = 'Obriši promenu.';
    $Self->{Translation}->{'Delete the change.'} = 'Obriši promenu.';
    $Self->{Translation}->{'Delete the workorder.'} = 'Obriši radni nalog.';
    $Self->{Translation}->{'Details of a change history entry.'} = 'Detalji stavke istorijata promene.';
    $Self->{Translation}->{'Determines if an agent can exchange the X-axis of a stat if he generates one.'} =
        'Utvrđuje da li operater može da zameni X osu statistike ako je generiše';
    $Self->{Translation}->{'Determines if the common stats module may generate stats about changes done for config item classes.'} =
        'Utvrđuje da li zajednički modul statistike može da generiše statistiku promena urađenih za konfiguracione stavke klasa.';
    $Self->{Translation}->{'Determines if the common stats module may generate stats about changes regarding change state updates within a timeperiod.'} =
        'Utvrđuje da li zajednički modul statistike može da generiše statistiku promena prema ažuriranju promena stanja u vremenskom periodu.';
    $Self->{Translation}->{'Determines if the common stats module may generate stats about changes regarding the relation between changes and incident tickets.'} =
        'Utvrđuje da li zajednički modul statistike može da generiše statistiku promena prema vezi između promena i tiketa incidenata.';
    $Self->{Translation}->{'Determines if the common stats module may generate stats about changes.'} =
        'Utvrđuje da li zajednički modul statistike može da generiše statistiku o promenama.';
    $Self->{Translation}->{'Determines if the common stats module may generate stats about the number of Rfc tickets a requester created.'} =
        'Utvrđuje da li zajednički modul statistike može da generiše statistiku o broju Rfc tiketa koje je kreirao tražilac.';
    $Self->{Translation}->{'Dynamic fields (for changes and workorders) shown in the change print screen of the agent interface.'} =
        'Dinamička polja (za promene i radne naloge) prikazana u ekranu štampe promene u interfejsu operatera.';
    $Self->{Translation}->{'Dynamic fields shown in the change add screen of the agent interface.'} =
        'Dinamička polja prikazana u ekranu dodavanja promene u interfejsu operatera.';
    $Self->{Translation}->{'Dynamic fields shown in the change edit screen of the agent interface.'} =
        'Dinamička polja prikazana u ekranu izmene promene u interfejsu operatera.';
    $Self->{Translation}->{'Dynamic fields shown in the change search screen of the agent interface.'} =
        'Dinamička polja prikazana u ekranu pretrage promena u interfejsu operatera.';
    $Self->{Translation}->{'Dynamic fields shown in the change zoom screen of the agent interface.'} =
        'Dinamička polja prikazana u detaljnom pregledu promene u interfejsu operatera.';
    $Self->{Translation}->{'Dynamic fields shown in the workorder add screen of the agent interface.'} =
        'Dinamička polja prikazana u ekranu dodavanja radnog naloga u interfejsu operatera.';
    $Self->{Translation}->{'Dynamic fields shown in the workorder edit screen of the agent interface.'} =
        'Dinamička polja prikazana u ekranu izmene radnog naloga u interfejsu operatera.';
    $Self->{Translation}->{'Dynamic fields shown in the workorder report screen of the agent interface.'} =
        'Dinamička polja prikazana u ekranu izveštaja radnog naloga u interfejsu operatera.';
    $Self->{Translation}->{'Dynamic fields shown in the workorder zoom screen of the agent interface.'} =
        'Dinamička polja prikazana u detaljnom pregledu radnog naloga u interfejsu operatera.';
    $Self->{Translation}->{'DynamicField event module to handle the update of conditions if dynamic fields are added, updated or deleted.'} =
        'Modul događaja dinamičkih polja za baratanje sa ažuriranjem uslova ako se dinamička polja dodaju, ažuriraju ili brišu.';
    $Self->{Translation}->{'Edit a change.'} = 'Uredi promenu.';
    $Self->{Translation}->{'Edit the change.'} = 'Uredi promenu.';
    $Self->{Translation}->{'Edit the conditions of the change.'} = 'Uredi uslove za promenu.';
    $Self->{Translation}->{'Edit the workorder.'} = 'Uredi radni nalog.';
    $Self->{Translation}->{'Enables the minimal change counter size (if "Date" was selected as ITSMChange::NumberGenerator).'} =
        'Aktivira minimalnu veličinu brojača promena (ako je izabran datum za ITSMChange::NumberGenerator).';
    $Self->{Translation}->{'Forward schedule of changes. Overview over approved changes.'} =
        'Prosledi raspored promena. Pregled odobrenih promena.';
    $Self->{Translation}->{'History Zoom'} = 'Detalji istorijata';
    $Self->{Translation}->{'ITSM Change CAB Templates.'} = 'ITSM šabloni promena CAB';
    $Self->{Translation}->{'ITSM Change Condition Edit.'} = 'ITSM uređivanje uslova promene.';
    $Self->{Translation}->{'ITSM Change Condition Overview.'} = 'ITSM pregled uslova promene.';
    $Self->{Translation}->{'ITSM Change Manager Overview.'} = 'ITSM pregled promena.';
    $Self->{Translation}->{'ITSM Change Notifications'} = 'Obaveštenja o ITSM promenama';
    $Self->{Translation}->{'ITSM Change PIR Overview.'} = 'ITSM pregled PIR promena.';
    $Self->{Translation}->{'ITSM Change notification rules'} = 'ITSM pravila obaveštavanja o promeni.';
    $Self->{Translation}->{'ITSM Changes'} = 'ITSM promene';
    $Self->{Translation}->{'ITSM MyCAB Overview.'} = 'ITSM pregled mojih CAB.';
    $Self->{Translation}->{'ITSM MyChanges Overview.'} = 'ITSM pregled mojih promena.';
    $Self->{Translation}->{'ITSM MyWorkorders Overview.'} = 'ITSM pregled mojih radnih naloga.';
    $Self->{Translation}->{'ITSM Template Delete.'} = 'ITSM brisanje šablona.';
    $Self->{Translation}->{'ITSM Template Edit CAB.'} = 'ITSM uređivanje CAB šablona.';
    $Self->{Translation}->{'ITSM Template Edit Content.'} = 'ITSM sadržaj uređivanja šablona.';
    $Self->{Translation}->{'ITSM Template Edit.'} = 'ITSM uređivanje šablona.';
    $Self->{Translation}->{'ITSM Template Overview.'} = 'Pregled ITSM šablona.';
    $Self->{Translation}->{'ITSM event module that cleans up conditions.'} = 'ITSM modul događaja koji čisti uslove.';
    $Self->{Translation}->{'ITSM event module that deletes the cache for a toolbar.'} = 'ITSM modul događaja koji briše keš alatne trake.';
    $Self->{Translation}->{'ITSM event module that deletes the history of changes.'} = 'ITSM modul događaja koji briše istorijat promena.';
    $Self->{Translation}->{'ITSM event module that matches conditions and executes actions.'} =
        'ITSM modul događaja koji uparuje uslove i izvršava akcije.';
    $Self->{Translation}->{'ITSM event module that sends notifications.'} = 'ITSM modul događaja koji šalje obaveštenja.';
    $Self->{Translation}->{'ITSM event module that updates the history of changes.'} = 'ITSM modul događaja koji ažurira istorijat promena.';
    $Self->{Translation}->{'ITSM event module that updates the history of conditions.'} = 'ITSM modul događaja ažurira istorijat uslova.';
    $Self->{Translation}->{'ITSM event module that updates the history of workorders.'} = 'ITSM modul događaja ažurira istorijat radnih naloga.';
    $Self->{Translation}->{'ITSM event module to recalculate the workorder numbers.'} = 'ITSM modul događaja koji preračunava brojeve radnih naloga.';
    $Self->{Translation}->{'ITSM event module to set the actual start and end times of workorders.'} =
        'ITSM modul događaja koji podešava aktuelna vremena početka i završetka radnih naloga.';
    $Self->{Translation}->{'ITSMChange'} = 'ITSM promena';
    $Self->{Translation}->{'ITSMWorkOrder'} = 'ITSM radni nalog';
    $Self->{Translation}->{'If frequency is \'regularly\', you can configure how often the notifications are sent (every X hours).'} =
        'Ako je učestalost \'redovno\', možete podesiti koliko često se šalju obaveštenja (na svakih X sati).';
    $Self->{Translation}->{'Link another object to the change.'} = 'Poveži drugi objekat sa promenom.';
    $Self->{Translation}->{'Link another object to the workorder.'} = 'Poveži drugi objekat sa radnim nalogom.';
    $Self->{Translation}->{'List of all change events to be displayed in the GUI.'} = 'Lista svih događaja na promenama koja će biti prikazana u grafičkom interfejsu.';
    $Self->{Translation}->{'List of all workorder events to be displayed in the GUI.'} = 'Lista svih događaja na radnim nalozima koja će biti prikazana u grafičkom interfejsu.';
    $Self->{Translation}->{'Lookup of CAB members for autocompletion.'} = 'Potraži članove CAB radi automatskog dovršavanja.';
    $Self->{Translation}->{'Lookup of agents, used for autocompletion.'} = 'Potraži operatere, upotrebljene za automatsko dovršavanje.';
    $Self->{Translation}->{'Manage ITSM Change Management state machine.'} = 'Uređivanje mašine stanja ITSM upravljanja promenama.';
    $Self->{Translation}->{'Manage the category ↔ impact ↔ priority matrix.'} = 'Upravljanje matricom Kategorija - Uticaj - Prioritet.';
    $Self->{Translation}->{'Module to check if WorkOrderAdd or WorkOrderAddFromTemplate should be permitted.'} =
        'Modul za proveru da li dodavanje radnog naloga ili dodavanje radnog naloga iz šablona treba da bude dozvoljeno.';
    $Self->{Translation}->{'Module to check the CAB members.'} = 'Modul za proveru članova CAB.';
    $Self->{Translation}->{'Module to check the agent.'} = 'Modul za proveru operatera.';
    $Self->{Translation}->{'Module to check the change builder.'} = 'Modul za proveru graditelja promena.';
    $Self->{Translation}->{'Module to check the change manager.'} = 'Modul za proveru upravljača promenama.';
    $Self->{Translation}->{'Module to check the workorder agent.'} = 'Modul za proveru operatera radnog naloga.';
    $Self->{Translation}->{'Module to check whether no workorder agent is set.'} = 'Modul za proveru da li je određen operater za radni nalog.';
    $Self->{Translation}->{'Module to check whether the agent is contained in the configured list.'} =
        'Modul za proveru da li se operater nalazi u konfigurisanoj listi.';
    $Self->{Translation}->{'Module to show a link to create a change from this ticket. The ticket will be automatically linked with the new change.'} =
        'Modul za prikaz veze za kreiranje promene iz ovog tiketa. Tiket će automatski biti povezan sa novom promenom.';
    $Self->{Translation}->{'Move Time Slot.'} = 'Pomeri vremenski termin.';
    $Self->{Translation}->{'Move all workorders in time.'} = 'Pomeri sve radne naloge u vremenu.';
    $Self->{Translation}->{'New (from template)'} = 'Novo (od šablona)';
    $Self->{Translation}->{'Only users of these groups have the permission to use the ticket types as defined in "ITSMChange::AddChangeLinkTicketTypes" if the feature "Ticket::Acl::Module###200-Ticket::Acl::Module" is enabled.'} =
        'Samo korisnici ovih grupa imaće dozvolu za korišćenje tipova tiketa definisanih u "ITSMChange::AddChangeLinkTicketTypes" ukoliko je funkcija "Ticket::Acl::Module###200-Ticket::Acl::Module" omogućena.';
    $Self->{Translation}->{'Other Settings'} = 'Druga podešavanja';
    $Self->{Translation}->{'Overview over all Changes.'} = 'Pregled svih promena.';
    $Self->{Translation}->{'PIR'} = 'PIR';
    $Self->{Translation}->{'PIR (Post Implementation Review)'} = 'PIR (recenzija posle sprovođenja)';
    $Self->{Translation}->{'PSA'} = 'PSA';
    $Self->{Translation}->{'Parameters for the UserCreateWorkOrderNextMask object in the preference view of the agent interface.'} =
        'Parametri za UserCreateWorkOrderNextMask objekat u prikazu podešavanja u interfejsu operatera.';
    $Self->{Translation}->{'Parameters for the pages (in which the changes are shown) of the small change overview.'} =
        'Parametri stranica (na kojima su promene vidljive) smanjenog pregleda tiketa.';
    $Self->{Translation}->{'Performs the configured action for each event (as an Invoker) for each configured Webservice.'} =
        'Izvršava podešenu akciju za svaki događaj (kao pozivalac) za svaki konfigurisan veb servis.';
    $Self->{Translation}->{'Planned end time'} = 'Planirano vreme završetka';
    $Self->{Translation}->{'Planned start time'} = 'Planirano vreme početka';
    $Self->{Translation}->{'Print the change.'} = 'Odštampaj promenu.';
    $Self->{Translation}->{'Print the workorder.'} = 'Odštampaj radni nalog.';
    $Self->{Translation}->{'Projected Service Availability'} = 'Projektovana dostupnost servisa';
    $Self->{Translation}->{'Projected Service Availability (PSA)'} = 'Projektovana dostupnost servisa (PSA)';
    $Self->{Translation}->{'Projected Service Availability (PSA) of changes. Overview of approved changes and their services.'} =
        'Projektovana dostupnost servisa (PSA) promena. Pregled odobrenih promena i ljihovih servisa.';
    $Self->{Translation}->{'Requested time'} = 'Traženo vreme';
    $Self->{Translation}->{'Required privileges in order for an agent to take a workorder.'} =
        'Potrebna prava za dodavanje redosleda rada.';
    $Self->{Translation}->{'Required privileges to access the overview of all changes.'} = 'Potrebna prava za pristup pregledu svih promena.';
    $Self->{Translation}->{'Required privileges to add a workorder.'} = 'Potrebna prava za dodavanje radnih naloga.';
    $Self->{Translation}->{'Required privileges to change the workorder agent.'} = 'Potrebna prava za izmenu operatera radnog naloga.';
    $Self->{Translation}->{'Required privileges to create a template from a change.'} = 'Potrebna prava za kreiranje šablona od promene.';
    $Self->{Translation}->{'Required privileges to create a template from a changes\' CAB.'} =
        'Potrebna prava za kreiranje šablona od promene CAB.';
    $Self->{Translation}->{'Required privileges to create a template from a workorder.'} = 'Potrebna prava za kreiranje šablona od radnog naloga.';
    $Self->{Translation}->{'Required privileges to create changes from templates.'} = 'Potrebna prava za kreiranje promena od šablona.';
    $Self->{Translation}->{'Required privileges to create changes.'} = 'Potrebna prava za kreiranje promena.';
    $Self->{Translation}->{'Required privileges to delete a template.'} = 'Potrebna prava za brisanje šablona.';
    $Self->{Translation}->{'Required privileges to delete a workorder.'} = 'Potrebna prava za brisanje radnog naloga.';
    $Self->{Translation}->{'Required privileges to delete changes.'} = 'Potrebna prava za brisanje promena.';
    $Self->{Translation}->{'Required privileges to edit a template.'} = 'Potrebna prava za uređenje šablona.';
    $Self->{Translation}->{'Required privileges to edit a workorder.'} = 'Potrebna prava za uređenje radnog naloga.';
    $Self->{Translation}->{'Required privileges to edit changes.'} = 'Potrebna prava za uređenje promena.';
    $Self->{Translation}->{'Required privileges to edit the conditions of changes.'} = 'Potrebna prava za uređenje uslova za promene.';
    $Self->{Translation}->{'Required privileges to edit the content of a template.'} = 'Potrebna prava za uređenje sadržaja šablona.';
    $Self->{Translation}->{'Required privileges to edit the involved persons of a change.'} =
        'Potrebna prava za uređenje osoba uključenih u promenu.';
    $Self->{Translation}->{'Required privileges to move changes in time.'} = 'Potrebna prava za pomeranje promena u vremenu.';
    $Self->{Translation}->{'Required privileges to print a change.'} = 'Potrebna prava za štampu promene.';
    $Self->{Translation}->{'Required privileges to reset changes.'} = 'Potrebna prava za poništenje promena.';
    $Self->{Translation}->{'Required privileges to view a workorder.'} = 'Potrebna prava za prikaz radnog naloga.';
    $Self->{Translation}->{'Required privileges to view changes.'} = 'Potrebna prava za prikaz promena.';
    $Self->{Translation}->{'Required privileges to view list of changes where the user is a CAB member.'} =
        'Potrebna prava za prikaz liste promena gde je korisnik član CAB.';
    $Self->{Translation}->{'Required privileges to view list of changes where the user is the change manager.'} =
        'Potrebna prava za prikaz liste promena gde korisnik upravlja promenom.';
    $Self->{Translation}->{'Required privileges to view overview over all templates.'} = 'Potrebna prava za prikaz pregleda svih šablona.';
    $Self->{Translation}->{'Required privileges to view the conditions of changes.'} = 'Potrebna prava za prikaz uslova za promene.';
    $Self->{Translation}->{'Required privileges to view the history of a change.'} = 'Potrebna prava za prikaz istorijata promene.';
    $Self->{Translation}->{'Required privileges to view the history of a workorder.'} = 'Potrebna prava za prikaz istorijata radnog naloga.';
    $Self->{Translation}->{'Required privileges to view the history zoom of a change.'} = 'Potrebna prava za detaljan prikaz istorijata promene.';
    $Self->{Translation}->{'Required privileges to view the history zoom of a workorder.'} =
        'Potrebna prava za detaljan prikaz istorijata radnog naloga';
    $Self->{Translation}->{'Required privileges to view the list of Change Schedule.'} = 'Potrebna prava za prikaz liste Planera promena.';
    $Self->{Translation}->{'Required privileges to view the list of change PSA.'} = 'Potrebna prava za prikaz liste promena PSA.';
    $Self->{Translation}->{'Required privileges to view the list of changes with an upcoming PIR (Post Implementation Review).'} =
        'Potrebna prava za prikaz liste promena sa predstojećim PIR (recenzija posle sprovođenja).';
    $Self->{Translation}->{'Required privileges to view the list of own changes.'} = 'Potrebna prava za prikaz liste sopstvenih promena.';
    $Self->{Translation}->{'Required privileges to view the list of own workorders.'} = 'Potrebna prava za prikaz liste sopstvenih radnih naloga.';
    $Self->{Translation}->{'Required privileges to write a report for the workorder.'} = 'Potrebna prava za pisnje izveštaja za radni nalog.';
    $Self->{Translation}->{'Reset a change and its workorders.'} = 'Reset promene i njenih radnih naloga.';
    $Self->{Translation}->{'Reset change and its workorders.'} = 'Reset promene i njenih radnih naloga.';
    $Self->{Translation}->{'Run task to check if specific times have been reached in changes and workorders.'} =
        'Pokreni zadatak radi provere da li su u promenama i radnim nalozima dostignuta određena vremena.';
    $Self->{Translation}->{'Save change as a template.'} = 'Sačuvaj promenu kao šablon.';
    $Self->{Translation}->{'Save workorder as a template.'} = 'Sačuvaj radni nalog kao šablon.';
    $Self->{Translation}->{'Schedule'} = 'Raspored';
    $Self->{Translation}->{'Screen after creating a workorder'} = 'Ekran posle kreiranja radnog naloga';
    $Self->{Translation}->{'Search Changes'} = 'Pretraži promene';
    $Self->{Translation}->{'Search Changes.'} = 'Pretraži promene.';
    $Self->{Translation}->{'Selects the change number generator module. "AutoIncrement" increments the change number, the SystemID and the counter are used with SystemID.counter format (e.g. 100118, 100119). With "Date", the change numbers will be generated by the current date and a counter; this format looks like Year.Month.Day.counter, e.g. 2010062400001, 2010062400002. With "DateChecksum", the counter will be appended as checksum to the string of date plus the SystemID. The checksum will be rotated on a daily basis. This format looks like Year.Month.Day.SystemID.Counter.CheckSum, e.g. 2010062410000017, 2010062410000026.'} =
        'Bira modul za generisanje broja promena. "AutoIncrement" uvećava broj promena, SystemID i brojač se koriste u SystemID.brojač formatu (npr. 100118, 100119). Sa "Date" brojevi promena će biti generisani preko trenutnog datuma i brojača. Format će izgledati kao godina.mesec.dan.brojač (npr. 2010062400001, 2010062400002). Sa "DateChecksum" brojač će biti dodat kao kontrolni zbir nizu sačinjenom od datuma i SystemID. Kontrolni zbir će se smenjivati na dnevnom nivou. Format izgleda ovako: godina.mesec.dan.SystemID.brojač.kontrolni_zbir, npr. 2010062410000017, 2002070110101535.';
    $Self->{Translation}->{'Set the agent for the workorder.'} = 'Odredi operatera za radni nalog.';
    $Self->{Translation}->{'Set the default height (in pixels) of inline HTML fields in the change zoom screen and workorder zoom screen of the agent interface.'} =
        'Definiše podrazumevanu visinu reda (u pikselima) HTML polja u ekranu detalja promene i radnog naloga u interfejsu operatera.';
    $Self->{Translation}->{'Set the maximum height (in pixels) of inline HTML fields in the change zoom screen and workorder zoom screen of the agent interface.'} =
        'Definiše maksimalnu visinu reda (u pikselima) HTML polja u ekranu detalja promene i radnog naloga u interfejsu operatera.';
    $Self->{Translation}->{'Sets the minimal change counter size (if "AutoIncrement" was selected as ITSMChange::NumberGenerator). Default is 5, this means the counter starts from 10000.'} =
        'Podešava minimalnu veličinu brojača promena (ako je izabran "AutoIncrement" za ITSMChange::NumberGenerator). Podrazumevano je 5, što znači da brojač počinje od 10000.';
    $Self->{Translation}->{'Sets up the state machine for changes.'} = 'Podesi mašinu stanja za promene.';
    $Self->{Translation}->{'Sets up the state machine for workorders.'} = 'Podesi mašinu stanja za radne naloge.';
    $Self->{Translation}->{'Shows a checkbox in the workorder edit screen of the agent interface that defines if the the following workorders should also be moved if a workorder is modified and the planned end time has changed.'} =
        'Prikazuje polje za potvrdu u ekranu izmena radnog naloga u interfejsu operatera koje definiše da li će sledeći radni nalozi takođe biti premešteni ukoliko je radni nalog izmenjen i planirano vreme završetka promenjeno.';
    $Self->{Translation}->{'Shows a link in the menu that allows changing the workorder agent, in the zoom view of the workorder of the agent interface.'} =
        'U meniju prikazuje vezu koja omogućava izmenu operatera radnog naloga, u detaljnom prikazu tog naloga u interfejsu operatera.';
    $Self->{Translation}->{'Shows a link in the menu that allows defining a change as a template in the zoom view of the change, in the agent interface.'} =
        'U meniju prikazuje vezu koja omogućava definisanje promene kao šablona na detaljnom prikazu u interfejsu operatera.';
    $Self->{Translation}->{'Shows a link in the menu that allows defining a workorder as a template in the zoom view of the workorder, in the agent interface.'} =
        'U meniju prikazuje vezu koja omogućava definisanje radnog naloga kao šablona na detaljnom prikazu u interfejsu operatera.';
    $Self->{Translation}->{'Shows a link in the menu that allows editing the report of a workorder, in the zoom view of the workorder of the agent interface.'} =
        'U meniju prikazuje vezu koja omogućava izmenu izveštaja radnog naloga, u detaljnom prikazu tog naloga u interfejsu operatera.';
    $Self->{Translation}->{'Shows a link in the menu that allows linking a change with another object in the change zoom view of the agent interface.'} =
        'U meniju prikazuje vezu koja omogućavapovezivanje promene sa drugim objektom na detaljnom prikazu promene u interfejsu operatera.';
    $Self->{Translation}->{'Shows a link in the menu that allows linking a workorder with another object in the zoom view of the workorder of the agent interface.'} =
        'U meniju prikazuje vezu koja omogućava povezivanje radnog naloga sa drugim objektom u detaljnom prikazu tog naloga u interfejsu operatera.';
    $Self->{Translation}->{'Shows a link in the menu that allows moving the time slot of a change in its zoom view of the agent interface.'} =
        'U meniju prikazuje vezu koja omogućava pomeranje vremenskog termina promene na detaljnom prikazu u interfejsu operatera.';
    $Self->{Translation}->{'Shows a link in the menu that allows taking a workorder in the its zoom view of the agent interface.'} =
        'U meniju prikazuje vezu koja omogućava preuzimanje radnog naloga na detaljnom prikazu u interfejsu operatera.';
    $Self->{Translation}->{'Shows a link in the menu to access the conditions of a change in the its zoom view of the agent interface.'} =
        'U meniju prikazuje vezu koja omogućava pristup uslovima promene na detaljnom prikazu u interfejsu operatera.';
    $Self->{Translation}->{'Shows a link in the menu to access the history of a change in the its zoom view of the agent interface.'} =
        'U meniju prikazuje vezu koja omogućava pristup istorijatu promene na detaljnom prikazu u interfejsu operatera.';
    $Self->{Translation}->{'Shows a link in the menu to access the history of a workorder in the its zoom view of the agent interface.'} =
        'U meniju prikazuje vezu za pristup istorijatu radnog naloga na detaljnom prikazu u interfejsu operatera.';
    $Self->{Translation}->{'Shows a link in the menu to add a workorder in the change zoom view of the agent interface.'} =
        'U meniju prikazuje vezu za dodavanje radnog naloga na detaljnom prikazu promene u interfejsu operatera.';
    $Self->{Translation}->{'Shows a link in the menu to delete a change in its zoom view of the agent interface.'} =
        'U meniju prikazuje vezu za brisanje promene na detaljnom prikazu u interfejsu operatera.';
    $Self->{Translation}->{'Shows a link in the menu to delete a workorder in its zoom view of the agent interface.'} =
        'U meniju prikazuje vezu za brisanje radnog naloga na detaljnom prikazu u interfejsu operatera.';
    $Self->{Translation}->{'Shows a link in the menu to edit a change in the its zoom view of the agent interface.'} =
        'U meniju prikazuje vezu za izmenu promene na detaljnom prikazu u interfejsu operatera.';
    $Self->{Translation}->{'Shows a link in the menu to edit a workorder in the its zoom view of the agent interface.'} =
        'U meniju prikazuje vezu za izmenu radnog naloga na detaljnom prikazu u interfejsu operatera.';
    $Self->{Translation}->{'Shows a link in the menu to go back in the change zoom view of the agent interface.'} =
        'U meniju prikazuje vezu za povratak na detaljni prikaz promene u interfejsu operatera.';
    $Self->{Translation}->{'Shows a link in the menu to go back in the workorder zoom view of the agent interface.'} =
        'U meniju prikazuje vezu za povratak na detaljni prikaz radnog naloga u interfejsu operatera.';
    $Self->{Translation}->{'Shows a link in the menu to print a change in the its zoom view of the agent interface.'} =
        'U meniju prikazuje vezu za štampanje promene na detaljnom prikazu u interfejsu operatera.';
    $Self->{Translation}->{'Shows a link in the menu to print a workorder in the its zoom view of the agent interface.'} =
        'U meniju prikazuje vezu za štampanje radnog naloga na detaljnom prikazu u interfejsu operatera.';
    $Self->{Translation}->{'Shows a link in the menu to reset a change and its workorders in its zoom view of the agent interface.'} =
        'U meniju prikazuje vezu za poništavanje promene i pripadajućih radnih naloga na detaljnom prikazu u interfejsu operatera.';
    $Self->{Translation}->{'Shows a link in the menu to show the involved persons in a change, in the zoom view of the change in the agent interface.'} =
        'U meniju prikazuje vezu koja omogućava prikaz osoba uključenih u promenu u detaljnom prikazu u interfejsu operatera.';
    $Self->{Translation}->{'Shows the change history (reverse ordered) in the agent interface.'} =
        'Prikazuje istorijat tiketa (obrnut redosled) u interfejsu operatera.';
    $Self->{Translation}->{'State Machine'} = 'Mašina stanja';
    $Self->{Translation}->{'Stores change and workorder ids and their corresponding template id, while a user is editing a template.'} =
        'Čuva identifikacije promena i radnih naloga i pripadajuće identifikacije šablona, za vreme dok korisnik uređuje šablon.';
    $Self->{Translation}->{'Take Workorder'} = 'Preuzmi radni nalog';
    $Self->{Translation}->{'Take Workorder.'} = 'Preuzmi radni nalog.';
    $Self->{Translation}->{'Take the workorder.'} = 'Preuzmi radni nalog.';
    $Self->{Translation}->{'Template Overview'} = 'Pregled šablona';
    $Self->{Translation}->{'Template type'} = 'Tip šablona';
    $Self->{Translation}->{'Template.'} = 'Šablon.';
    $Self->{Translation}->{'The identifier for a change, e.g. Change#, MyChange#. The default is Change#.'} =
        'Identifikator za promenu, npr. Change#, MyChange#. Podrazumevano je Change#.';
    $Self->{Translation}->{'The identifier for a workorder, e.g. Workorder#, MyWorkorder#. The default is Workorder#.'} =
        'Identifikator za radni nalog, npr. Workorder#, MyWorkorder#. Podrazumevano je Workorder#.';
    $Self->{Translation}->{'This ACL module restricts the usuage of the ticket types that are defined in the sysconfig option \'ITSMChange::AddChangeLinkTicketTypes\', to users of the groups as defined in "ITSMChange::RestrictTicketTypes::Groups". As this ACL could collide with other ACLs which are also related to the ticket type, this sysconfig option is disabled by default and should only be activated if needed.'} =
        'Ovaj ACL modul ograničava mogućnost korišćenja tipova tiketa koji su definisani u podešavanju \'ITSMChange::AddChangeLinkTicketTypes\', i to korisnicima grupa definisanim u "ITSMChange::RestrictTicketTypes::Groups". Kako ovaj ACL može da se sukobi sa drugim ACL-ovima koji se isto odnose na tip tiketa, podešavanje je podrazumevano isključeno i treba ga aktivirati samo ukoliko je neophodno.';
    $Self->{Translation}->{'Time Slot'} = 'Vremenski termin';
    $Self->{Translation}->{'Types of tickets, where in the ticket zoom view a link to add a change will be displayed.'} =
        'Tipovi tiketa, kod kojih će u detaljnom prikazu biti vidljiva veza za dodavanje promene.';
    $Self->{Translation}->{'User Search'} = 'Pretraga korisnika';
    $Self->{Translation}->{'Workorder Add (from template).'} = 'Dodaj radni nalog (iz šablona)';
    $Self->{Translation}->{'Workorder Add.'} = 'Dodaj radni nalog.';
    $Self->{Translation}->{'Workorder Agent.'} = 'Operater za radni nalog.';
    $Self->{Translation}->{'Workorder Delete.'} = 'Brisanje radnog naloga.';
    $Self->{Translation}->{'Workorder Edit.'} = 'Uređenje radnog naloga.';
    $Self->{Translation}->{'Workorder History Zoom.'} = 'Detalji istorijata radnog naloga.';
    $Self->{Translation}->{'Workorder History.'} = 'Istorijat radnog naloga.';
    $Self->{Translation}->{'Workorder Report.'} = 'Izveštaj radnog naloga.';
    $Self->{Translation}->{'Workorder Zoom'} = 'Detalji radnog naloga';
    $Self->{Translation}->{'Workorder Zoom.'} = 'Detalji radnog naloga.';
    $Self->{Translation}->{'once'} = 'jednom';
    $Self->{Translation}->{'regularly'} = 'redovno';


    push @{ $Self->{JavaScriptStrings} // [] }, (
    'Do you really want to delete this action?',
    'Do you really want to delete this condition?',
    'Do you really want to delete this expression?',
    'Do you really want to delete this notification language?',
    'Do you really want to delete this notification?',
    'No',
    'Ok',
    'Please enter at least one search value or * to find anything.',
    'Settings',
    'Submit',
    'Yes',
    );

}

1;
