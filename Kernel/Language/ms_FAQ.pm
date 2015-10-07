# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::ms_FAQ;

use strict;
use warnings;
use utf8;

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
    $Self->{Translation}->{'Explorer'} = 'Peneroka';
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
    $Self->{Translation}->{'Symptom'} = 'Simptom';
    $Self->{Translation}->{'Solution'} = 'Penyelesaian';

    # Template: AgentFAQAdd
    $Self->{Translation}->{'Add FAQ Article'} = 'Tambah artikel FAQ';
    $Self->{Translation}->{'Keywords'} = 'Kata kunci';
    $Self->{Translation}->{'A category is required.'} = 'Kategori diperlukan.';
    $Self->{Translation}->{'Approval'} = 'Pengesahan';

    # Template: AgentFAQCategory
    $Self->{Translation}->{'FAQ Category Management'} = 'Pengurusan Kategori FAQ';
    $Self->{Translation}->{'Add category'} = 'Tambah kategori';
    $Self->{Translation}->{'Delete Category'} = 'Padam kategori';
    $Self->{Translation}->{'Ok'} = 'Ok';
    $Self->{Translation}->{'Add Category'} = 'Tambah kategori';
    $Self->{Translation}->{'Edit Category'} = 'Audit Kategori';
    $Self->{Translation}->{'Please select at least one permission group.'} = 'Sila pilih sekurang-kurangnya satu permintaan kumpulan.';
    $Self->{Translation}->{'Agent groups that can access articles in this category.'} = 'Kumpulan ejen boleh mengakses artikel dalam kategori ini.';
    $Self->{Translation}->{'Will be shown as comment in Explorer.'} = 'Akan dipaparkan sebagai komen dalam Explorer.';
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
    $Self->{Translation}->{'Wildcards are allowed.'} = 'Wildcards adalah dibenarkan.';
    $Self->{Translation}->{'Advanced Search'} = 'Carian Terperinci';
    $Self->{Translation}->{'Subcategories'} = 'Sub-kategori';
    $Self->{Translation}->{'FAQ Articles'} = 'Artiket FAQ';
    $Self->{Translation}->{'No subcategories found.'} = 'Tiada sub-kategori ditemui.';

    # Template: AgentFAQJournalOverviewSmall
    $Self->{Translation}->{'No FAQ Journal data found.'} = 'Tiada data Jurnal FAQ ditemui.';

    # Template: AgentFAQLanguage
    $Self->{Translation}->{'FAQ Language Management'} = 'Pengurusan Bahasa FAQ';
    $Self->{Translation}->{'Use this feature if you want to work with multiple languges.'} =
        'Guna kaedah ini jika anda ingin bekerja dengan pelbagai bahasa.';
    $Self->{Translation}->{'Add language'} = 'Tambah bahasa';
    $Self->{Translation}->{'Delete Language %s'} = 'Padam bahasa %s';
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

    # Template: AgentFAQPrint
    $Self->{Translation}->{'FAQ-Info'} = 'Informasi FAQ';
    $Self->{Translation}->{'Votes'} = 'Undian';
    $Self->{Translation}->{'Last update'} = 'Kemaskini kali terakhir';

    # Template: AgentFAQSearch
    $Self->{Translation}->{'Keyword'} = 'Kata kunci';
    $Self->{Translation}->{'Vote (e. g. Equals 10 or GreaterThan 60)'} = 'Undi (contoh: Bersamaan 10 atau lebih besar daripada 60)';
    $Self->{Translation}->{'Rate (e. g. Equals 25% or GreaterThan 75%)'} = 'Kadar (contoh: Bersamaan 25% atau lebih besar daripada 75%)';
    $Self->{Translation}->{'Approved'} = 'Diluluskan';
    $Self->{Translation}->{'Last changed by'} = 'Terakhir diubah oleh';
    $Self->{Translation}->{'FAQ Article Create Time (before/after)'} = 'Waktu cipta artikel FAQ (sebelum/selepas)';
    $Self->{Translation}->{'FAQ Article Create Time (between)'} = 'Waktu cipta artikel FAQ (di antara)';
    $Self->{Translation}->{'FAQ Article Change Time (before/after)'} = 'Waktu perubahan artikel FAQ (sebelum/selepas)';
    $Self->{Translation}->{'FAQ Article Change Time (between)'} = 'Waktu perubahan artikel FAQ (di antara)';

    # Template: AgentFAQSearchOpenSearchDescriptionFulltext
    $Self->{Translation}->{'FAQFulltext'} = 'FAQTeksPenuh';

    # Template: AgentFAQSearchSmall
    $Self->{Translation}->{'FAQ Search'} = 'Carian FAQ';
    $Self->{Translation}->{'Profile Selection'} = 'Pilihan profil';
    $Self->{Translation}->{'Vote'} = 'Undi';
    $Self->{Translation}->{'No vote settings'} = 'Tiada tetapan undi';
    $Self->{Translation}->{'Specific votes'} = 'Undi spesifik';
    $Self->{Translation}->{'e. g. Equals 10 or GreaterThan 60'} = 'contoh: Sama dengan 10 atau Lebih besar daripada 60';
    $Self->{Translation}->{'Rate'} = 'Kadar';
    $Self->{Translation}->{'No rate settings'} = 'Tiada tetapan kadar';
    $Self->{Translation}->{'Specific rate'} = 'Kadar spesifik';
    $Self->{Translation}->{'e. g. Equals 25% or GreaterThan 75%'} = 'contoh: Sama dengan 25% atau lebih besar daripada 75%';
    $Self->{Translation}->{'FAQ Article Create Time'} = 'Waktu cipta artikel FAQ';
    $Self->{Translation}->{'Specific date'} = 'Tarikh spesifik';
    $Self->{Translation}->{'Date range'} = 'Jarak tarikh';
    $Self->{Translation}->{'FAQ Article Change Time'} = 'Waktu perubahan artikel FAQ';

    # Template: AgentFAQZoom
    $Self->{Translation}->{'FAQ Information'} = 'Informasi FAQ';
    $Self->{Translation}->{'Rating'} = 'Menilai';
    $Self->{Translation}->{'out of 5'} = 'daripada 5';
    $Self->{Translation}->{'No votes found!'} = 'Tiada undian ditemui!';
    $Self->{Translation}->{'No votes found! Be the first one to rate this FAQ article.'} = 'Tiada undian ditemui! Jadilah orang pertama menilai aritl FAQ ini.';
    $Self->{Translation}->{'Download Attachment'} = 'Muat turun lampiran';
    $Self->{Translation}->{'To open links in the following description blocks, you might need to press Ctrl or Cmd or Shift key while clicking the link (depending on your browser and OS).'} =
        'Untuk membuka pautan dalam keterangan blok berikut, anda mungkin perlu menekan kekunci Ctrl atau Cmd atau Shift semasa menekan pautan (bergantung kepada pelayar dan sistem operasi anda).';
    $Self->{Translation}->{'How helpful was this article? Please give us your rating and help to improve the FAQ Database. Thank You!'} =
        'Berapa banyak arikel ini membantu? Sila beri kami penilaian anda dan bantu untuk meningkatkan pangkalan data FAQ. Terima Kasih!';
    $Self->{Translation}->{'not helpful'} = 'Tidak membantu';
    $Self->{Translation}->{'very helpful'} = 'Sangat membantu';

    # Template: AgentFAQZoomSmall
    $Self->{Translation}->{'Add FAQ title to article subject'} = 'Tambah tajuk FAQ pada subjek artikel';
    $Self->{Translation}->{'Insert FAQ Text'} = 'Masuk Teks FAQ';
    $Self->{Translation}->{'Insert Full FAQ'} = 'Masukkan FAQ penuh';
    $Self->{Translation}->{'Insert FAQ Link'} = 'Masuk pautan FAQ';
    $Self->{Translation}->{'Insert FAQ Text & Link'} = 'Masuk Teks FAQ & Pautan';
    $Self->{Translation}->{'Insert Full FAQ & Link'} = 'Masukkan FAQ penuh dan pautan';

    # Template: CustomerFAQExplorer
    $Self->{Translation}->{'No FAQ articles found.'} = 'Tiada artikel FAQ dijumpai.';

    # Template: CustomerFAQSearch
    $Self->{Translation}->{'Fulltext search in FAQ articles (e. g. "John*n" or "Will*")'} = 'Carian Teks penuh dalam artikel FAQ (contoh. "John*n" or "Will*")';
    $Self->{Translation}->{'Vote restrictions'} = 'Sekatan undi';
    $Self->{Translation}->{'Only FAQ articles with votes...'} = 'Hanya artikel FAQ berserta undi';
    $Self->{Translation}->{'Rate restrictions'} = 'Sekatan kadar';
    $Self->{Translation}->{'Only FAQ articles with rate...'} = 'Hanya artikel FAQ berserta kadar';
    $Self->{Translation}->{'Only FAQ articles created'} = 'Hanya artikel FAQ yang dicipta';
    $Self->{Translation}->{'Only FAQ articles created between'} = 'Hanya artikel FAQ yang dicipta di antara';
    $Self->{Translation}->{'Search-Profile as Template?'} = 'Carian berprofil sebagai templat?';

    # Template: CustomerFAQZoom
    $Self->{Translation}->{'Article Number'} = '';
    $Self->{Translation}->{'Search for articles with keyword'} = 'Carian untuk artikel dengan kekunci perkataan';

    # Template: PublicFAQSearchOpenSearchDescriptionFAQNumber
    $Self->{Translation}->{'Public'} = 'Umum';

    # Template: PublicFAQSearchResultShort
    $Self->{Translation}->{'Back to FAQ Explorer'} = 'Balik kepada peneroka FAQ';

    # SysConfig
    $Self->{Translation}->{'A filter for HTML output to add links behind a defined string. The element Image allows two input kinds. First the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possibility is to insert the link to the image.'} =
        'Asingan untuk hasil keluaran untuk menambah pautan dibelakang jaringan string. Elemen gambar dibenarkan dua input. pertama nama gambar tersebut (faq.png). Dalam kes ini, jalan gambar OTRS akan digunakan. keduanya kemungkinan adalah untuk memasukkan pautan pada gambar.';
    $Self->{Translation}->{'CSS color for the voting result.'} = 'Warna CSS untuk keputusan undian.';
    $Self->{Translation}->{'Cache Time To Leave for FAQ items.'} = 'Waktu cache untuk meninggalkan bagi item FAQ';
    $Self->{Translation}->{'Category Management'} = 'Pengurusan kategori';
    $Self->{Translation}->{'Decimal places of the voting result.'} = 'Titik perpuluhan daripada keputusan undian.';
    $Self->{Translation}->{'Default category name.'} = 'Kategori nama sedia ada.';
    $Self->{Translation}->{'Default language for FAQ articles on single language mode.'} = 'Bahasa sedia ada untuk artikel FAQ pada satu mod bahasa.';
    $Self->{Translation}->{'Default maximum size of the titles in a FAQ article to be shown.'} =
        'Saiz maksimum tetapan awal daripada tajuk dalam artikel FAQ untuk ditunjukkan.';
    $Self->{Translation}->{'Default priority of tickets for the approval of FAQ articles.'} =
        'Keutamaan sedia ada tiket untuk pengesahan artikel FAQ.';
    $Self->{Translation}->{'Default state for FAQ entry.'} = 'Keadaan sedia ada untuk kemasukan FAQ.';
    $Self->{Translation}->{'Default state of tickets for the approval of FAQ articles.'} = 'Keadaan sedia ada tiket untuk pengesahan daripada artikel FAQ.';
    $Self->{Translation}->{'Default type of tickets for the approval of FAQ articles.'} = 'Jenis tetapan awal tiket untuk kelulusan artikel FAQ.';
    $Self->{Translation}->{'Default value for the Action parameter for the public frontend. The Action parameter is used in the scripts of the system.'} =
        'Nilai sedia ada untuk tindakan parameter kepada depanakhir umum. Tindakan parameter digunakan dalam skrip sistem tersebut.';
    $Self->{Translation}->{'Define if the FAQ title should be concatenated to article subject.'} =
        'Tentukan jika tajuk FAQ perlu dirangkaikan kepada artikel subjek.';
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
        'Mentakrifkan tetapan awal sifat FAQ untuk susunan FAQ dalam peneroka FAQ antara muka pelanggan';
    $Self->{Translation}->{'Defines the default FAQ attribute for FAQ sorting in the FAQ Explorer of the public interface.'} =
        'Mentakrifkan tetapan awal sifat FAQ untuk susunan FAQ dalam peneroka FAQ antara muka orang awam';
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
    $Self->{Translation}->{'Defines the default shown FAQ search attribute for FAQ search screen.'} =
        '';
    $Self->{Translation}->{'Defines the information to be inserted in a FAQ based Ticket. "Full FAQ" includes text, attachments and inline images.'} =
        '';
    $Self->{Translation}->{'Defines the parameters for the dashboard backend. "Limit" defines the number of entries displayed by default. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually.'} =
        '';
    $Self->{Translation}->{'Defines the shown columns in the FAQ Explorer. This option has no effect on the position of the column.'} =
        'Mentakrifkan lajur menunjukkan di Explorer FAQ. Pilihan ini tidak mempunyai kesan ke atas kedudukan tiang.';
    $Self->{Translation}->{'Defines the shown columns in the FAQ journal. This option has no effect on the position of the column.'} =
        'Mentakrifkan ruangan yang ditunjukkan dalam jurnal FAQ. Pilihan ini tidak mempunyai kesan ke atas kedudukan tiang.';
    $Self->{Translation}->{'Defines the shown columns in the FAQ search. This option has no effect on the position of the column.'} =
        'Mentakrifkan ruangan yang ditunjukkan dalam carian FAQ. Pilihan ini tidak mempunyai kesan ke atas kedudukan tiang.';
    $Self->{Translation}->{'Defines where the \'Insert FAQ\' link will be displayed.'} = '';
    $Self->{Translation}->{'Definition of FAQ item free text field.'} = 'Definisi item FAQ percuma bidang teks.';
    $Self->{Translation}->{'Delete this FAQ'} = 'Padam FAQ ini!';
    $Self->{Translation}->{'Dynamic fields shown in the FAQ add screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.'} =
        '';
    $Self->{Translation}->{'Dynamic fields shown in the FAQ edit screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.'} =
        '';
    $Self->{Translation}->{'Dynamic fields shown in the FAQ overview screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.'} =
        '';
    $Self->{Translation}->{'Dynamic fields shown in the FAQ overview screen of the public interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.'} =
        '';
    $Self->{Translation}->{'Dynamic fields shown in the FAQ print screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled.'} =
        '';
    $Self->{Translation}->{'Dynamic fields shown in the FAQ print screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled.'} =
        '';
    $Self->{Translation}->{'Dynamic fields shown in the FAQ print screen of the public interface. Possible settings: 0 = Disabled, 1 = Enabled.'} =
        '';
    $Self->{Translation}->{'Dynamic fields shown in the FAQ search screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and shown by default.'} =
        '';
    $Self->{Translation}->{'Dynamic fields shown in the FAQ search screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and shown by default.'} =
        '';
    $Self->{Translation}->{'Dynamic fields shown in the FAQ search screen of the public interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and shown by default.'} =
        '';
    $Self->{Translation}->{'Dynamic fields shown in the FAQ small format overview screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled.'} =
        '';
    $Self->{Translation}->{'Dynamic fields shown in the FAQ zoom screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled.'} =
        '';
    $Self->{Translation}->{'Dynamic fields shown in the FAQ zoom screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled.'} =
        '';
    $Self->{Translation}->{'Dynamic fields shown in the FAQ zoom screen of the public interface. Possible settings: 0 = Disabled, 1 = Enabled.'} =
        '';
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
    $Self->{Translation}->{'Field4'} = 'Medan4';
    $Self->{Translation}->{'Field5'} = 'Medan5';
    $Self->{Translation}->{'Frontend module registration for the public interface.'} = 'Frontend pendaftaran modul untuk antara muka awam.';
    $Self->{Translation}->{'Group for the approval of FAQ articles.'} = 'Kumpulan bagi kelulusan artikel FAQ.';
    $Self->{Translation}->{'History of this FAQ'} = 'Sejarah FAQ ini';
    $Self->{Translation}->{'Include internal fields on a FAQ based Ticket.'} = 'Termasuk bidang dalaman Tiket berasaskan FAQ.';
    $Self->{Translation}->{'Include the name of each field in a FAQ based Ticket.'} = 'Termasuk nama setiap bidang dalam Tiket berasaskan FAQ.';
    $Self->{Translation}->{'Interfaces where the quick search should be shown.'} = 'Antara muka di mana carian cepat hendaklah ditunjukkan.';
    $Self->{Translation}->{'Journal'} = 'Jurnal';
    $Self->{Translation}->{'Language Management'} = 'Pengurusan Bahasa';
    $Self->{Translation}->{'Link another object to this FAQ item'} = 'FAQ pautan ini kepada objek lain';
    $Self->{Translation}->{'List of state types which can be used in the agent interface.'} =
        'Senarai jenis keadaan yang boleh digunakan dalam ruang antara muka ejen.';
    $Self->{Translation}->{'List of state types which can be used in the customer interface.'} =
        'Senarai jenis keadaan yang boleh digunakan dalam ruang antara muka pelanggan.';
    $Self->{Translation}->{'List of state types which can be used in the public interface.'} =
        'Senarai jenis keadaan yang boleh digunakan dalam antara muka awam.';
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
    $Self->{Translation}->{'Maximum size of the titles in a FAQ article to be shown in the FAQ Explorer in the agent interface.'} =
        '';
    $Self->{Translation}->{'Maximum size of the titles in a FAQ article to be shown in the FAQ Explorer in the customer interface.'} =
        '';
    $Self->{Translation}->{'Maximum size of the titles in a FAQ article to be shown in the FAQ Explorer in the public interface.'} =
        '';
    $Self->{Translation}->{'Maximum size of the titles in a FAQ article to be shown in the FAQ Search in the agent interface.'} =
        '';
    $Self->{Translation}->{'Maximum size of the titles in a FAQ article to be shown in the FAQ Search in the customer interface.'} =
        '';
    $Self->{Translation}->{'Maximum size of the titles in a FAQ article to be shown in the FAQ Search in the public interface.'} =
        '';
    $Self->{Translation}->{'Maximum size of the titles in a FAQ article to be shown in the FAQ journal in the agent interface.'} =
        '';
    $Self->{Translation}->{'Module to generate HTML OpenSearch profile for short FAQ search in the public interface.'} =
        '';
    $Self->{Translation}->{'Module to generate HTML OpenSearch profile for short faq search in the customer interface.'} =
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

}

1;
