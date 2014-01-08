# --
# Kernel/Language/ms_FAQ.pm - translation file
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::ms_FAQ;

use strict;
use warnings;

sub Data {
    my $Self = shift;

    # Template: AAAFAQ
    $Self->{Translation}->{'internal'} = 'dalaman';
    $Self->{Translation}->{'public'} = 'umum';
    $Self->{Translation}->{'external'} = 'luaran';
    $Self->{Translation}->{'FAQ Number'} = 'Nombor FAQ';
    $Self->{Translation}->{'Latest updated FAQ articles'} = 'Kemaskini Artikel FAQ terbaru';
    $Self->{Translation}->{'Latest created FAQ articles'} = 'Mencipta aritkel FAQ terbaru';
    $Self->{Translation}->{'Top 10 FAQ articles'} = 'Aritkel FAQ 10 terbaik';
    $Self->{Translation}->{'Subcategory of'} = 'Sub-kategori daripada';
    $Self->{Translation}->{'No rate selected!'} = 'Tiada kadar dipilih!';
    $Self->{Translation}->{'Explorer'} = '';
    $Self->{Translation}->{'public (all)'} = 'Umum (Semua)';
    $Self->{Translation}->{'external (customer)'} = 'luaran (pelanggan)';
    $Self->{Translation}->{'internal (agent)'} = 'dalaman (ejen)';
    $Self->{Translation}->{'Start day'} = 'Hari mula';
    $Self->{Translation}->{'Start month'} = 'Bulan mula';
    $Self->{Translation}->{'Start year'} = 'Tahun mula';
    $Self->{Translation}->{'End day'} = 'Hari akhir';
    $Self->{Translation}->{'End month'} = 'Bulan akhir';
    $Self->{Translation}->{'End year'} = 'Tahun akhir';
    $Self->{Translation}->{'Thanks for your vote!'} = 'Terima kasih untuk undian anda!';
    $Self->{Translation}->{'You have already voted!'} = 'And sudah mengundi!';
    $Self->{Translation}->{'FAQ Article Print'} = 'Artikel FAQ dicetak';
    $Self->{Translation}->{'FAQ Articles (Top 10)'} = 'Artikel FAQ (10 terbaik)';
    $Self->{Translation}->{'FAQ Articles (new created)'} = 'Artikel FAQ (baru dicipta)';
    $Self->{Translation}->{'FAQ Articles (recently changed)'} = 'Artikel FAQ (baru diubah)';
    $Self->{Translation}->{'FAQ category updated!'} = 'Kategori FAQ dikemaskini!';
    $Self->{Translation}->{'FAQ category added!'} = 'kategori FAQ ditambah!';
    $Self->{Translation}->{'A category should have a name!'} = 'Kategori perlu mempunyai nama!';
    $Self->{Translation}->{'This category already exists'} = 'kategori ini sudah wujud!';
    $Self->{Translation}->{'FAQ language added!'} = 'Bahasa FAQ ditambah!';
    $Self->{Translation}->{'FAQ language updated!'} = 'Bahasa FAQ dikemaskini!';
    $Self->{Translation}->{'The name is required!'} = 'Nama diperlukan!';
    $Self->{Translation}->{'This language already exists!'} = 'Bahasa ini sudah wujud!';

    # Template: AgentDashboardFAQOverview

    # Template: AgentFAQAdd
    $Self->{Translation}->{'Add FAQ Article'} = 'Tambah artikel FAQ';
    $Self->{Translation}->{'Keywords'} = '';
    $Self->{Translation}->{'A category is required.'} = 'Kategori diperlukan.';
    $Self->{Translation}->{'Approval'} = 'Pengesahan';

    # Template: AgentFAQCategory
    $Self->{Translation}->{'FAQ Category Management'} = 'Pengurusan Kategori FAQ';
    $Self->{Translation}->{'Add category'} = 'Tambah kategori';
    $Self->{Translation}->{'Delete Category'} = 'Padam kategori';
    $Self->{Translation}->{'Ok'} = 'Ok';
    $Self->{Translation}->{'Add Category'} = 'Tambah kategori';
    $Self->{Translation}->{'Edit Category'} = 'Audit Kategori';
    $Self->{Translation}->{'Will be shown as comment in Explorer.'} = 'Akan dipaparkan sebagai komen dalam Explorer.';
    $Self->{Translation}->{'Please select at least one permission group.'} = 'Sila pilih sekurang-kurangnya satu permintaan kumpulan.';
    $Self->{Translation}->{'Agent groups that can access articles in this category.'} = 'Kumpulan ejen boleh mengakses artikel dalam kategori ini.';
    $Self->{Translation}->{'Do you really want to delete this category?'} = 'Adakah anda ingin memadam kategori ini?';
    $Self->{Translation}->{'You can not delete this category. It is used in at least one FAQ article and/or is parent of at least one other category'} =
        'Anda tidak boleh memadam kategori ini. Ia digunakan dalam sekurang-kurangnya satu atikel FAQ dan/atau adalah ibubapa kepada sekurang-kurangnya satu kategori lain!';
    $Self->{Translation}->{'This category is used in the following FAQ article(s)'} = 'Kategori ini digunakan dalam atiket FAQ berikut';
    $Self->{Translation}->{'This category is parent of the following subcategories'} = 'Kategori ini adalah ibubapa kepada sub-kategori berikut';

    # Template: AgentFAQDelete
    $Self->{Translation}->{'Do you really want to delete this FAQ article?'} = 'Adakah anda ingin memadam artikel FAQ ini?';

    # Template: AgentFAQEdit
    $Self->{Translation}->{'FAQ'} = 'FAQ';

    # Template: AgentFAQExplorer
    $Self->{Translation}->{'FAQ Explorer'} = 'FAQ-Explorer';
    $Self->{Translation}->{'Quick Search'} = 'Carian Pantas';
    $Self->{Translation}->{'Wildcards are allowed.'} = '';
    $Self->{Translation}->{'Advanced Search'} = 'Carian Terperinci';
    $Self->{Translation}->{'Subcategories'} = 'Sub-kategori';
    $Self->{Translation}->{'FAQ Articles'} = 'Artiket FAQ';
    $Self->{Translation}->{'No subcategories found.'} = 'Tiada sub-kategori ditemui.';

    # Template: AgentFAQHistory

    # Template: AgentFAQJournalOverviewSmall
    $Self->{Translation}->{'No FAQ Journal data found.'} = 'Tiada data Jurnal FAQ ditemui.';

    # Template: AgentFAQLanguage
    $Self->{Translation}->{'FAQ Language Management'} = 'Pengurusan Bahasa FAQ';
    $Self->{Translation}->{'Use this feature if you want to work with multiple languges.'} =
        'Guna kaedah ini jika anda ingin bekerja dengan pelbagai bahasa.';
    $Self->{Translation}->{'Add language'} = 'Tambah bahasa';
    $Self->{Translation}->{'Delete Language'} = 'Padam bahasa';
    $Self->{Translation}->{'Add Language'} = 'Tambah bahasa';
    $Self->{Translation}->{'Edit Language'} = 'Audit bahasa';
    $Self->{Translation}->{'Do you really want to delete this language?'} = 'Adakah anda ingin memadamkan bahasa ini?';
    $Self->{Translation}->{'You can not delete this language. It is used in at least one FAQ article!'} =
        'Anda tidak boleh memadam bahasa ini. Ia digunakan sekurang-kurangnya satu artikel FAQ!';
    $Self->{Translation}->{'This language is used in the following FAQ Article(s)'} = 'Bahasa ini digunakan dalam Artikel FAQ yang berikut';

    # Template: AgentFAQOverviewNavBar
    $Self->{Translation}->{'Context Settings'} = 'Aturan konteks';
    $Self->{Translation}->{'FAQ articles per page'} = 'Artikel FAQ per muka surat';

    # Template: AgentFAQOverviewSmall
    $Self->{Translation}->{'No FAQ data found.'} = 'Tiada data FAQ ditemui.';
    $Self->{Translation}->{'A generic FAQ table'} = '';
    $Self->{Translation}->{'","50'} = '';

    # Template: AgentFAQPrint
    $Self->{Translation}->{'FAQ-Info'} = 'Informasi FAQ';
    $Self->{Translation}->{'Votes'} = 'Undian';
    $Self->{Translation}->{'Last update'} = '';

    # Template: AgentFAQSearch
    $Self->{Translation}->{'Keyword'} = '';
    $Self->{Translation}->{'Vote (e. g. Equals 10 or GreaterThan 60)'} = '';
    $Self->{Translation}->{'Rate (e. g. Equals 25% or GreaterThan 75%)'} = '';
    $Self->{Translation}->{'Approved'} = '';
    $Self->{Translation}->{'Last changed by'} = '';
    $Self->{Translation}->{'FAQ Article Create Time (before/after)'} = '';
    $Self->{Translation}->{'FAQ Article Create Time (between)'} = '';
    $Self->{Translation}->{'FAQ Article Change Time (before/after)'} = '';
    $Self->{Translation}->{'FAQ Article Change Time (between)'} = '';
    $Self->{Translation}->{'Run Search'} = '';

    # Template: AgentFAQSearchOpenSearchDescriptionFAQNumber

    # Template: AgentFAQSearchOpenSearchDescriptionFulltext
    $Self->{Translation}->{'FAQFulltext'} = 'FAQTeksPenuh';

    # Template: AgentFAQSearchResultPrint

    # Template: AgentFAQSearchSmall
    $Self->{Translation}->{'FAQ Search'} = 'Carian FAQ';
    $Self->{Translation}->{'Profile Selection'} = '';
    $Self->{Translation}->{'Vote'} = '';
    $Self->{Translation}->{'No vote settings'} = '';
    $Self->{Translation}->{'Specific votes'} = '';
    $Self->{Translation}->{'e. g. Equals 10 or GreaterThan 60'} = '';
    $Self->{Translation}->{'Rate'} = '';
    $Self->{Translation}->{'No rate settings'} = '';
    $Self->{Translation}->{'Specific rate'} = '';
    $Self->{Translation}->{'e. g. Equals 25% or GreaterThan 75%'} = '';
    $Self->{Translation}->{'FAQ Article Create Time'} = '';
    $Self->{Translation}->{'Specific date'} = '';
    $Self->{Translation}->{'Date range'} = '';
    $Self->{Translation}->{'FAQ Article Change Time'} = '';

    # Template: AgentFAQZoom
    $Self->{Translation}->{'FAQ Information'} = 'Informasi FAQ';
    $Self->{Translation}->{'","25'} = '';
    $Self->{Translation}->{'Rating'} = 'Menilai';
    $Self->{Translation}->{'Rating %'} = 'Menilai %';
    $Self->{Translation}->{'out of 5'} = 'daripada 5';
    $Self->{Translation}->{'No votes found!'} = 'Tiada undian ditemui!';
    $Self->{Translation}->{'No votes found! Be the first one to rate this FAQ article.'} = 'Tiada undian ditemui! Jadilah orang pertama menilai aritl FAQ ini.';
    $Self->{Translation}->{'Download Attachment'} = 'Muat turun lampiran';
    $Self->{Translation}->{'How helpful was this article? Please give us your rating and help to improve the FAQ Database. Thank You!'} =
        'Berapa banyak arikel ini membantu? Sila beri kami penilaian anda dan bantu untuk meningkatkan pangkalan data FAQ. Terima Kasih!';
    $Self->{Translation}->{'not helpful'} = 'Tidak membantu';
    $Self->{Translation}->{'very helpful'} = 'Sangat membantu';

    # Template: AgentFAQZoomSmall
    $Self->{Translation}->{'Insert FAQ Text'} = 'Masuk Teks FAQ';
    $Self->{Translation}->{'Insert Full FAQ'} = '';
    $Self->{Translation}->{'Insert FAQ Link'} = 'Masuk pautan FAQ';
    $Self->{Translation}->{'Insert FAQ Text & Link'} = 'Masuk Teks FAQ & Pautan';
    $Self->{Translation}->{'Insert Full FAQ & Link'} = '';

    # Template: CustomerFAQExplorer
    $Self->{Translation}->{'No FAQ articles found.'} = 'Tiada artikel FAQ dijumpai.';

    # Template: CustomerFAQPrint

    # Template: CustomerFAQSearch
    $Self->{Translation}->{'Fulltext search in FAQ articles (e. g. "John*n" or "Will*")'} = 'Carian Teks penuh dalam artikel FAQ (contoh. "John*n" or "Will*")';
    $Self->{Translation}->{'Vote restrictions'} = '';
    $Self->{Translation}->{'Only FAQ articles with votes...'} = '';
    $Self->{Translation}->{'Rate restrictions'} = '';
    $Self->{Translation}->{'Only FAQ articles with rate...'} = '';
    $Self->{Translation}->{'Only FAQ articles created'} = '';
    $Self->{Translation}->{'Only FAQ articles created between'} = '';
    $Self->{Translation}->{'Search-Profile as Template?'} = '';

    # Template: CustomerFAQSearchOpenSearchDescriptionFAQNumber

    # Template: CustomerFAQSearchOpenSearchDescriptionFullText

    # Template: CustomerFAQSearchResultPrint

    # Template: CustomerFAQSearchResultShort

    # Template: CustomerFAQZoom
    $Self->{Translation}->{'Article Number'} = '';
    $Self->{Translation}->{'Search for articles with keyword'} = 'Carian untuk artikel dengan kekunci perkataan';

    # Template: PublicFAQExplorer

    # Template: PublicFAQPrint

    # Template: PublicFAQSearch

    # Template: PublicFAQSearchOpenSearchDescriptionFAQNumber
    $Self->{Translation}->{'Public'} = 'Umum';

    # Template: PublicFAQSearchOpenSearchDescriptionFullText

    # Template: PublicFAQSearchResultPrint

    # Template: PublicFAQSearchResultShort

    # Template: PublicFAQZoom

    # SysConfig
    $Self->{Translation}->{'A filter for HTML output to add links behind a defined string. The element Image allows two input kinds. First the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possibility is to insert the link to the image.'} =
        'Asingan untuk hasil keluaran untuk menambah pautan dibelakang jaringan string. Elemen gambar dibenarkan dua input. pertama nama gambar tersebut (faq.png). Dalam kes ini, jalan gambar OTRS akan digunakan. keduanya kemungkinan adalah untuk memasukkan pautan pada gambar.';
    $Self->{Translation}->{'CSS color for the voting result.'} = 'Warna CSS untuk keputusan undian.';
    $Self->{Translation}->{'Cache Time To Leave for FAQ items.'} = '';
    $Self->{Translation}->{'Category Management'} = 'Pengurusan kategori';
    $Self->{Translation}->{'Decimal places of the voting result.'} = 'Titik perpuluhan daripada keputusan undian.';
    $Self->{Translation}->{'Default category name.'} = 'Kategori nama sedia ada.';
    $Self->{Translation}->{'Default language for FAQ articles on single language mode.'} = 'Bahasa sedia ada untuk artikel FAQ pada satu mod bahasa.';
    $Self->{Translation}->{'Default priority of tickets for the approval of FAQ articles.'} =
        'Keutamaan sedia ada tiket untuk pengesahan artikel FAQ.';
    $Self->{Translation}->{'Default state for FAQ entry.'} = 'Keadaan sedia ada untuk kemasukan FAQ.';
    $Self->{Translation}->{'Default state of tickets for the approval of FAQ articles.'} = 'Keadaan sedia ada tiket untuk pengesahan daripada artikel FAQ.';
    $Self->{Translation}->{'Default type of tickets for the approval of FAQ articles.'} = '';
    $Self->{Translation}->{'Default value for the Action parameter for the public frontend. The Action parameter is used in the scripts of the system.'} =
        'Nilai sedia ada untuk tindakan parameter kepada depanakhir umum. Tindakan parameter digunakan dalam skrip sistem tersebut.';
    $Self->{Translation}->{'Defines an overview module to show the small view of a FAQ journal.'} =
        'Kenalpasti lihat semula modul untuk papar paparan kecil dari Jurnal FAQ.';
    $Self->{Translation}->{'Defines an overview module to show the small view of a FAQ list.'} =
        'Kenalpasti lihat semula modul untuk papar paparan kecil dari senarai FAQ.';
    $Self->{Translation}->{'Defines the default FAQ attribute for FAQ sorting in a FAQ search of the agent interface.'} =
        'Kenalpasti sifat sedia ada FAQ menyusun dalam carian FAQ daripada interface ejen.';
    $Self->{Translation}->{'Defines the default FAQ attribute for FAQ sorting in a FAQ search of the customer interface.'} =
        'Kenalpasti sifat sedia ada FAQ menyusun dalam carian FAQ daripada interface pelanggan.';
    $Self->{Translation}->{'Defines the default FAQ attribute for FAQ sorting in a FAQ search of the public interface.'} =
        'Kenalpasti sifat sedia ada FAQ menyusun dalam carian FAQ daripada interface umum.';
    $Self->{Translation}->{'Defines the default FAQ attribute for FAQ sorting in the FAQ Explorer of the agent interface.'} =
        'Kenalpasti sifat sedia ada FAQ menyusun dalam carian FAQ daripada ejen interface';
    $Self->{Translation}->{'Defines the default FAQ attribute for FAQ sorting in the FAQ Explorer of the customer interface.'} =
        '';
    $Self->{Translation}->{'Defines the default FAQ attribute for FAQ sorting in the FAQ Explorer of the public interface.'} =
        '';
    $Self->{Translation}->{'Defines the default FAQ order in the FAQ Explorer result of the agent interface. Up: oldest on top. Down: latest on top.'} =
        '';
    $Self->{Translation}->{'Defines the default FAQ order in the FAQ Explorer result of the customer interface. Up: oldest on top. Down: latest on top.'} =
        '';
    $Self->{Translation}->{'Defines the default FAQ order in the FAQ Explorer result of the public interface. Up: oldest on top. Down: latest on top.'} =
        '';
    $Self->{Translation}->{'Defines the default FAQ order of a search result in the agent interface. Up: oldest on top. Down: latest on top.'} =
        'Mentakrifkan perintah lalai FAQ hasil carian dalam antara muka ejen. Atas: tertua di atas. Bawah: terbaru di atas.';
    $Self->{Translation}->{'Defines the default FAQ order of a search result in the customer interface. Up: oldest on top. Down: latest on top.'} =
        'Mentakrifkan perintah lalai FAQ hasil carian dalam antara muka pelanggan. Atas: tertua di atas. Bawah: terbaru di atas.';
    $Self->{Translation}->{'Defines the default FAQ order of a search result in the public interface. Up: oldest on top. Down: latest on top.'} =
        'Mentakrifkan perintah lalai FAQ hasil carian dalam antara muka awam. Atas: tertua di atas. Bawah: terbaru di atas.';
    $Self->{Translation}->{'Defines the information to be inserted in a FAQ based Ticket. "Full FAQ" includes text, attachments and inline images.'} =
        '';
    $Self->{Translation}->{'Defines the shown columns in the FAQ Explorer. This option has no effect on the position of the column.'} =
        'Mentakrifkan lajur menunjukkan di Explorer FAQ. Pilihan ini tidak mempunyai kesan ke atas kedudukan tiang.';
    $Self->{Translation}->{'Defines the shown columns in the FAQ journal. This option has no effect on the position of the column.'} =
        'Mentakrifkan ruangan yang ditunjukkan dalam jurnal FAQ. Pilihan ini tidak mempunyai kesan ke atas kedudukan tiang.';
    $Self->{Translation}->{'Defines the shown columns in the FAQ search. This option has no effect on the position of the column.'} =
        'Mentakrifkan ruangan yang ditunjukkan dalam carian FAQ. Pilihan ini tidak mempunyai kesan ke atas kedudukan tiang.';
    $Self->{Translation}->{'Defines where the \'Insert FAQ\' link will be displayed. Note: AgentTicketActionCommon includes AgentTicketNote, AgentTicketClose, AgentTicketFreeText, AgentTicketOwner, AgentTicketPending, AgentTicketPriority and AgentTicketResponsible.'} =
        'Mentakrifkan mana pautan \'Masukkan FAQ \' akan dipaparkan. Nota: AgentTicketActionCommon termasuk AgentTicketNote, AgentTicketClose, AgentTicketFreeText, AgentTicketOwner, AgentTicketPending, AgentTicketPriority dan AgentTicketResponsible.';
    $Self->{Translation}->{'Definition of FAQ item free text field.'} = 'Definisi item FAQ percuma bidang teks.';
    $Self->{Translation}->{'Delete this FAQ'} = 'Padam FAQ ini!';
    $Self->{Translation}->{'Edit this FAQ'} = 'Audit FAQ ini';
    $Self->{Translation}->{'Enable multiple languages on FAQ module.'} = 'Aktifkan pelbagai bahasa pada modul FAQ.';
    $Self->{Translation}->{'Enable voting mechanism on FAQ module.'} = 'Aktifkan undian mekanisma pada modul FAQ.';
    $Self->{Translation}->{'FAQ Journal'} = 'jurnal FAQ';
    $Self->{Translation}->{'FAQ Journal Overview "Small" Limit'} = 'Jurnal FAQ lihat semula "Kecil" had';
    $Self->{Translation}->{'FAQ Overview "Small" Limit'} = 'Lihat semula FAQ had "kecil"';
    $Self->{Translation}->{'FAQ limit per page for FAQ Journal Overview "Small"'} = 'Soalan Lazim had bagi setiap halaman untuk Tinjauan Jurnal FAQ "Kecil".';
    $Self->{Translation}->{'FAQ limit per page for FAQ Overview "Small"'} = 'Had FAQ setiap halaman untuk Tinjauan FAQ "Kecil".';
    $Self->{Translation}->{'FAQ path separator.'} = 'Laluan pemisah FAQ.';
    $Self->{Translation}->{'FAQ search backend router of the agent interface.'} = 'Carian Soalan Lazim backend router muka ejen.';
    $Self->{Translation}->{'FAQ-Area'} = 'Kawasan FAQ';
    $Self->{Translation}->{'Frontend module registration for the public interface.'} = 'Frontend pendaftaran modul untuk antara muka awam.';
    $Self->{Translation}->{'Group for the approval of FAQ articles.'} = 'Kumpulan bagi kelulusan artikel FAQ.';
    $Self->{Translation}->{'History of this FAQ'} = 'Sejarah FAQ ini';
    $Self->{Translation}->{'Include internal fields on a FAQ based Ticket.'} = 'Termasuk bidang dalaman Tiket berasaskan FAQ.';
    $Self->{Translation}->{'Include the name of each field in a FAQ based Ticket.'} = 'Termasuk nama setiap bidang dalam Tiket berasaskan FAQ.';
    $Self->{Translation}->{'Interfaces where the quicksearch should be shown.'} = 'Antaramuka mana dengan Pantas hendaklah ditunjukkan.';
    $Self->{Translation}->{'Journal'} = 'Jurnal';
    $Self->{Translation}->{'Language Management'} = 'Pengurusan Bahasa';
    $Self->{Translation}->{'Link another object to this FAQ item'} = 'FAQ pautan ini kepada objek lain';
    $Self->{Translation}->{'List of state types which can be used in the agent interface.'} =
        '';
    $Self->{Translation}->{'List of state types which can be used in the customer interface.'} =
        '';
    $Self->{Translation}->{'List of state types which can be used in the public interface.'} =
        '';
    $Self->{Translation}->{'Maximum number of FAQ articles to be displayed in the FAQ Explorer result of the agent interface.'} =
        'Bilangan maksimum artikel FAQ akan dipaparkan dalam hasil FAQ Explorer muka ejen';
    $Self->{Translation}->{'Maximum number of FAQ articles to be displayed in the FAQ Explorer result of the customer interface.'} =
        'Bilangan maksimum artikel FAQ akan dipaparkan dalam hasil FAQ Explorer muka pelanggan';
    $Self->{Translation}->{'Maximum number of FAQ articles to be displayed in the FAQ Explorer result of the public interface.'} =
        '';
    $Self->{Translation}->{'Maximum number of FAQ articles to be displayed in the FAQ journal in the agent interface.'} =
        'Bilangan maksimum FAQ artikel untuk dipaparkan dalam jurnal FAQ di muka ejen.';
    $Self->{Translation}->{'Maximum number of FAQ articles to be displayed in the result of a search in the agent interface.'} =
        'Bilangan maksimum artikel FAQ untuk dipaparkan dalam hasil carian dalam antara muka ejen.';
    $Self->{Translation}->{'Maximum number of FAQ articles to be displayed in the result of a search in the customer interface.'} =
        'Bilangan maksimum artikel FAQ untuk dipaparkan dalam hasil carian dalam antara muka pelanggan.';
    $Self->{Translation}->{'Maximum number of FAQ articles to be displayed in the result of a search in the public interface.'} =
        'Bilangan maksimum artikel FAQ untuk dipaparkan dalam hasil carian dalam antara muka awam.';
    $Self->{Translation}->{'Module to generate html OpenSearch profile for short faq search in the customer interface.'} =
        '';
    $Self->{Translation}->{'Module to generate html OpenSearch profile for short faq search in the public interface.'} =
        '';
    $Self->{Translation}->{'Module to generate html OpenSearch profile for short faq search.'} =
        'Modul untuk menjana html profil opensearch untuk carian faq ringkas.';
    $Self->{Translation}->{'New FAQ Article'} = 'Perkara Baru FAQ';
    $Self->{Translation}->{'New FAQ articles need approval before they get published.'} = 'Artikel baru FAQ perlu kelulusan sebelum mereka mendapat diterbitkan.';
    $Self->{Translation}->{'Number of FAQ articles to be displayed in the FAQ Explorer of the customer interface.'} =
        'Bilangan artikel FAQ untuk dipaparkan dalam Explorer FAQ antara muka pelanggan';
    $Self->{Translation}->{'Number of FAQ articles to be displayed in the FAQ Explorer of the public interface.'} =
        'Bilangan artikel FAQ untuk dipaparkan dalam Explorer FAQ antara muka awam';
    $Self->{Translation}->{'Number of FAQ articles to be displayed on each page of a search result in the customer interface.'} =
        'Bilangan artikel FAQ untuk dipaparkan pada setiap halaman hasil carian dalam antara muka pelanggan';
    $Self->{Translation}->{'Number of FAQ articles to be displayed on each page of a search result in the public interface.'} =
        'Bilangan artikel FAQ akan dipaparkan pada setiap halaman hasil carian dalam antara muka awam.';
    $Self->{Translation}->{'Number of shown items in last changes.'} = 'Bilangan item yang ditunjukkan dalam perubahan terakhir.';
    $Self->{Translation}->{'Number of shown items in last created.'} = 'Bilangan item yang ditunjukkan dalam terakhir dicipta.';
    $Self->{Translation}->{'Number of shown items in the top 10 feature.'} = 'Bilangan item yang ditunjukkan dalam 10 teratas ciri.';
    $Self->{Translation}->{'Parameters for the pages (in which the FAQ items are shown) of the small FAQ journal overview.'} =
        'Parameter untuk muka surat (di mana item FAQ ditunjukkan) gambaran kecil jurnal FAQ.';
    $Self->{Translation}->{'Parameters for the pages (in which the FAQ items are shown) of the small FAQ overview.'} =
        'Parameter untuk muka surat (di mana item FAQ ditunjukkan) gambaran keseluruhan FAQ kecil.';
    $Self->{Translation}->{'Print this FAQ'} = 'Cetak halaman FAQ ini';
    $Self->{Translation}->{'Queue for the approval of FAQ articles.'} = 'Beratur untuk kelulusan artikel FAQ.';
    $Self->{Translation}->{'Rates for voting. Key must be in percent.'} = 'Kadar untuk mengundi. Kunci mestilah dalam peratus.';
    $Self->{Translation}->{'Search FAQ'} = 'Carian FAQ';
    $Self->{Translation}->{'Set the default height (in pixels) of inline HTML fields in AgentFAQZoom.'} =
        '';
    $Self->{Translation}->{'Set the default height (in pixels) of inline HTML fields in CustomerFAQZoom (and PublicFAQZoom).'} =
        '';
    $Self->{Translation}->{'Set the maximum height (in pixels) of inline HTML fields in AgentFAQZoom.'} =
        '';
    $Self->{Translation}->{'Set the maximum height (in pixels) of inline HTML fields in CustomerFAQZoom (and PublicFAQZoom).'} =
        '';
    $Self->{Translation}->{'Show "Insert FAQ Link" Button in AgentFAQZoomSmall for public FAQ Articles.'} =
        'Tunjukkan "Sisipan FAQ Link" Butang di AgentFAQZoomSmall untuk awam FAQ Artikel.';
    $Self->{Translation}->{'Show "Insert FAQ Text & Link" / "Insert Full FAQ & Link" Button in AgentFAQZoomSmall for public FAQ Articles.'} =
        '';
    $Self->{Translation}->{'Show "Insert FAQ Text" / "Insert Full FAQ" Button in AgentFAQZoomSmall.'} =
        '';
    $Self->{Translation}->{'Show FAQ Article with HTML.'} = 'Papar FAQ Perkara dengan HTML.';
    $Self->{Translation}->{'Show FAQ path yes/no.'} = 'Papar FAQ jalan ya / tidak.';
    $Self->{Translation}->{'Show items of subcategories.'} = 'Papar item subkategori.';
    $Self->{Translation}->{'Show last change items in defined interfaces.'} = 'Menunjukkan item perubahan terakhir dalam antara muka yang ditakrifkan.';
    $Self->{Translation}->{'Show last created items in defined interfaces.'} = 'Tunjukkan akhir mencipta item dalam antara muka yang ditakrifkan.';
    $Self->{Translation}->{'Show top 10 items in defined interfaces.'} = 'Papar top 10 item dalam antara muka yang ditakrifkan.';
    $Self->{Translation}->{'Show voting in defined interfaces.'} = 'Papar mengundi dalam antara muka yang ditakrifkan.';
    $Self->{Translation}->{'Shows a link in the menu that allows linking a FAQ with another object in the zoom view of such FAQ of the agent interface.'} =
        'Menunjukkan pautan dalam menu yang membolehkan menghubungkan FAQ dengan objek lain dalam pandangan zoom FAQ muka ejen.';
    $Self->{Translation}->{'Shows a link in the menu that allows to delete a FAQ in its zoom view in the agent interface.'} =
        'Menunjukkan pautan di bar menu dalam pandangan dizum dalam antara muka pelanggan yang membolehkan untuk memadam artikel FAQ.';
    $Self->{Translation}->{'Shows a link in the menu to access the history of a FAQ in its zoom view of the agent interface.'} =
        'Menunjukkan pautan di bar menu dalam pandangan dizum dalam ejen untuk melihat sejarah artikel FAQ.';
    $Self->{Translation}->{'Shows a link in the menu to edit a FAQ in the its zoom view of the agent interface.'} =
        'Menunjukkan pautan di bar menu dalam pandangan dizum dalam antara muka pelanggan yang membolehkan untuk mengedit artikel FAQ.';
    $Self->{Translation}->{'Shows a link in the menu to go back in the FAQ zoom view of the agent interface.'} =
        'Menunjukkan pautan di bar menu dalam pandangan dizum dalam antara muka pelanggan yang membolehkan untuk kembali ke halaman sebelumnya.';
    $Self->{Translation}->{'Shows a link in the menu to print a FAQ in the its zoom view of the agent interface.'} =
        'Menunjukkan pautan di bar menu dalam pandangan dizum dalam antara muka ejen, yang membolehkan untuk mencetak artikel FAQ.';
    $Self->{Translation}->{'The identifier for a FAQ, e.g. FAQ#, KB#, MyFAQ#. The default is FAQ#.'} =
        'Pengecam untuk item FAQ, seperti FAQ #, # KB, MyFAQ #. Nilai lalai adalah # FAQ.';
    $Self->{Translation}->{'This setting defines that a \'FAQ\' object can be linked with other \'FAQ\' objects using the \'Normal\' link type.'} =
        '';
    $Self->{Translation}->{'This setting defines that a \'FAQ\' object can be linked with other \'FAQ\' objects using the \'ParentChild\' link type.'} =
        '';
    $Self->{Translation}->{'This setting defines that a \'FAQ\' object can be linked with other \'Ticket\' objects using the \'Normal\' link type.'} =
        'Mentakrifkan bahawa \' FAQ\' objek dengan jenis pautan \'biasa\' lain \'Tiket\' boleh dikaitkan dengan objek.';
    $Self->{Translation}->{'This setting defines that a \'FAQ\' object can be linked with other \'Ticket\' objects using the \'ParentChild\' link type.'} =
        '';
    $Self->{Translation}->{'Ticket body for approval of FAQ article.'} = 'Badan tiket untuk melepaskan artikel FAQ.';
    $Self->{Translation}->{'Ticket subject for approval of FAQ article.'} = 'Tertakluk kepada tiket untuk melepaskan artikel FAQ.';

    #
    # OBSOLETE ENTRIES FOR REFERENCE, DO NOT TRANSLATE!
    #
    $Self->{Translation}->{'Defines the default FAQ attribute for FAQ sorting in a FAQ Explorer of the agent interface.'} =
        'Mentakrifkan sifat lalai FAQ untuk menyusun Explorer FAQ ejen.';
    $Self->{Translation}->{'Defines the default FAQ attribute for FAQ sorting in the explorer in the customer interface.'} =
        'Mentakrifkan sifat lalai FAQ untuk menyusun Explorer FAQ dalam antara muka pelanggan.';
    $Self->{Translation}->{'Defines the default FAQ attribute for FAQ sorting in the explorer in the public interface.'} =
        'Mentakrifkan sifat lalai FAQ untuk menyusun Explorer FAQ dalam antaramuka Awam.';
    $Self->{Translation}->{'Defines the default FAQ order in the explorer in the customer interface. Up: oldest on top. Down: latest on top.'} =
        'Mentakrifkan sorting lalai Explorer FAQ dalam antara muka pelanggan. In: Elder FAQ artikel di atas. From: Artikel FAQ Newest atas.';
    $Self->{Translation}->{'Defines the default FAQ order in the explorer in the public interface. Up: oldest on top. Down: latest on top.'} =
        'Mentakrifkan sorting lalai Explorer FAQ muka Awam. In: Elder FAQ artikel di atas. From: Artikel FAQ Newest atas.';
    $Self->{Translation}->{'Defines the default FAQ order of a Explorer result in the agent interface. Up: oldest on top. Down: latest on top.'} =
        'Mentakrifkan sorting lalai Explorer FAQ di antara muka pelanggan. In: Elder FAQ artikel di atas. From: Artikel FAQ terbaru atas.';
    $Self->{Translation}->{'Delete: '} = 'Padam: ';
    $Self->{Translation}->{'Languagekey which is defined in the language file *_FAQ.pm.'} = 'Kunci bahasa yang ditakrifkan dalam fail bahasa * _FAQ.pm.';
    $Self->{Translation}->{'Maximum number of FAQ articles to be displayed in the explorer in the customer interface.'} =
        'Bilangan maksimum FAQ artikel yang muncul di Explorer FAQ dalam antara muka pelanggan.';
    $Self->{Translation}->{'Maximum number of FAQ articles to be displayed in the explorer in the public interface.'} =
        'Bilangan maksimum FAQ artikel yang muncul di Explorer FAQ di Muka Awam.';
    $Self->{Translation}->{'Maximum number of FAQ articles to be displayed in the result of a Explorer in the agent interface.'} =
        'Bilangan maksimum artikel FAQ yang muncul dalam Explorer FAQ di ejen.';
    $Self->{Translation}->{'Number of FAQ articles to be displayed in each page of a search result in the customer interface.'} =
        'Bilangan artikel FAQ yang muncul dalam carian FAQ dalam antara muka pelanggan setiap halaman.';
    $Self->{Translation}->{'Number of FAQ articles to be displayed in each page of a search result in the public interface.'} =
        'Bilangan artikel FAQ yang muncul dalam carian FAQ dalam antara muka Awam per halaman.';
    $Self->{Translation}->{'Number of FAQ articles to be displayed in the explorer in the customer interface.'} =
        'Bilangan artikel FAQ yang muncul dalam Explorer FAQ dalam antara muka pelanggan.';
    $Self->{Translation}->{'Number of FAQ articles to be displayed in the explorer in the public interface.'} =
        'Bilangan artikel FAQ yang muncul dalam Explorer FAQ di Muka Awam.';
    $Self->{Translation}->{'Show "Insert FAQ Text & Link" Button in AgentFAQZoomSmall for public FAQ Articles.'} =
        'Papar "Sisipan FAQ Teks & Link" Button di AgentFAQZoomSmall untuk Artikel FAQ awam.';
    $Self->{Translation}->{'Show "Insert FAQ Text" Button in AgentFAQZoomSmall.'} = 'Papar "Sisipan FAQ Teks" Button dalam AgentFAQZoomSmall.';
    $Self->{Translation}->{'Show "Insert Link" Button in AgentFAQZoomSmall for public FAQ Articles.'} =
        'Lihat "Masukkan Pautan" butang di AgentFAQZoomSmall untuk artikel FAQ awam.';
    $Self->{Translation}->{'Show "Insert Text & Link" Button in AgentFAQZoomSmall for public FAQ Articles.'} =
        'Lihat "Teks & Paste Link" butang di AgentFAQZoomSmall untuk artikel FAQ awam.';
    $Self->{Translation}->{'Show "Insert Text" Button in AgentFAQZoomSmall.'} = 'Lihat "Masukkan teks" butang di AgentFAQZoomSmall untuk artikel FAQ awam.';
    $Self->{Translation}->{'Show WYSIWYG editor in agent interface.'} = 'Papar editor WYSIWYG dalam antara muka ejen.';
    $Self->{Translation}->{'This setting defines that a \'FAQ\'object can be linked with other \'FAQ\'objects using the \'Normal\'link type.'} =
        'Mentakrifkan bahawa \'FAQ\'objek dengan jenis pautan \'biasa \'lain \'FAQ\'objek boleh dikaitkan.';
    $Self->{Translation}->{'This setting defines that an \'FAQ\'object can be linked with other \'FAQ\'objects using the \'ParentChild\'link type.'} =
        'Mentakrifkan bahawa \'FAQ\'objek dengan jenis pautan \'Ibu Bapa Kanak-kanak \'lain \'FAQ\'objek itu boleh dikaitkan.';
    $Self->{Translation}->{'This setting defines that an \'FAQ\'object can be linked with other \'Ticket\'objects using the \'ParentChild\'link type.'} =
        'Mentakrifkan bahawa \'FAQ\'objek dengan jenis pautan \'Ibu Bapa Kanak-kanak \'lain \'Tiket \'boleh dikaitkan dengan objek.';

}

1;
