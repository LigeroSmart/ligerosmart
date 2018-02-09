#6.0.5 20??-??-??

#6.0.4 2018-02-13
 - 2018-02-08 Updated translations, thanks to all translators.
 - 2018-02-07 Fixed bug#[12326](https://bugs.otrs.org/show_bug.cgi?id=12326) - FAQ Permissions not working correctly in customer frontend.

#6.0.3 2018-02-13
 - 2018-02-06 Updated translations, thanks to all translators.
 - 2018-01-07 Fixed bug#[13443](https://bugs.otrs.org/show_bug.cgi?id=13443) - Personal settings are not displayed.
 - 2017-12-15 Fixed bug#[13416](https://bugs.otrs.org/show_bug.cgi?id=13416) - Trying to enable multi-language feature from language management leads to an error.
 - 2017-12-15 Fixed bug#[13421](https://bugs.otrs.org/show_bug.cgi?id=13421) - FAQ link for ticket compose does not show for new default groups.
 - 2017-12-15 Added related FAQ articles for agents feature (for OTRS Business Solution™).
 - 2018-01-08 Fixed bug#[11446](https://bugs.otrs.org/show_bug.cgi?id=11446) - Refresh after language is added tries to add the language again.

#6.0.2 2017-12-19
 - 2017-12-12 Updated translations, thanks to all translators.
 - 2017-12-12 Fixed bug#[12063](https://bugs.otrs.org/show_bug.cgi?id=12063) - Some characters overflow in titles.
 - 2017-12-04 Improved display of 'FAQ::Default::State' setting.
 - 2017-11-14 Updated documentation (Config chapter).

#6.0.1 2017-11-21
 - 2017-11-14 Fixed upgrade from lower than 4.0.1.
 - 2017-11-14 Updated translations, thanks to all translators.
 - 2017-11-14 Fixed bug#[13311](https://bugs.otrs.org/show_bug.cgi?id=13311) - Can't insert FAQ into new ticket.

#6.0.0.rc1 2017-11-14
 - 2017-11-07 Updated translations, thanks to all translators.
 - 2017-10-31 Changed default group configuration and implemented migration path for existing systems. FAQ specific user groups will no longer be automatically created on new systems.
 - 2017-10-27 Changed access keys for several screens in order to avoid conflicts.

#6.0.0.beta1 2017-11-01
 - 2017-10-16 Initial version for OTRS 6.
 - 2016-10-16 Updated translations, thanks to all translators.
 - 2017-06-30 Replaced UserFistname, UserLastname in favor of a more flexible UserFullname, thanks to Dian Tong Software.

#5.0.10 2017-??-??
 - 2017-10-13 Fixed bug#[12900](https://bugs.otrs.org/show_bug.cgi?id=12900) - Widget "This might be helpful" does not show FAQ in subcategories.
 - 2017-09-06 Fixed bug#[12569](https://bugs.otrs.org/show_bug.cgi?id=12569) - Missing explanation users (with visual impairments) in the 'Preferences' page.
 - 2017-08-31 Fixed bug#[12433](https://bugs.otrs.org/show_bug.cgi?id=12433)(PR#67) - Dynamic Fields for FAQ don't work as Link.
 - 2017-08-04 Updated translations, thanks to all translators.
 - 2017-08-04 Fixed bug#[12964](https://bugs.otrs.org/show_bug.cgi?id=12964)(PR#73) - FAQ types are not translated, Thanks to Balázs Úr.
 - 2017-07-24 Fixed bug#[12935](https://bugs.otrs.org/show_bug.cgi?id=12935) - SQL Error in Systemlog "Server gone away" and "you have an error ".
 - 2017-07-01 Fixed bug#[11478](https://bugs.otrs.org/show_bug.cgi?id=11478) - Editing and Deleting of articles possible with RO-Permission.
 - 2017-07-01 Fixed bug#[12067](https://bugs.otrs.org/show_bug.cgi?id=12067) - FAQ Explorer shows Internal Server Error if no categories found.
 - 2017-05-05 Fixed bug#[12768](https://bugs.otrs.org/show_bug.cgi?id=12768) - Excel output is missing from the FAQ search.

#5.0.9 2017-05-09
 - 2017-05-02 Updated translations, thanks to all translators.
 - 2017-04-06 Added the new related faq article widget 'This might be helpful' for the customer ticket creation.
 - 2017-04-03 Fixed wrong operation assignment.
 - 2017-03-24 Updated translations, thanks to all translators.
 - 2017-03-24 Marked strings as translatable, thanks to Balázs Úr (PR#71).

#5.0.8 2017-03-07
 - 2016-02-27 Updated translations, thanks to all translators.
 - 2017-02-25 Fixed bug#[11122](https://bugs.otrs.org/show_bug.cgi?id=11122)(PR#52)  - Dashlet: MouseOver in a Linktitle, thanks to S7.
 - 2017-02-14 Calls to old Get() method replaced with calls to new Translate() method. Thanks to Paweł Bogusławski!
 - 2016-12-17 Fixed bug#[12406](https://bugs.otrs.org/show_bug.cgi?id=12406)(PR#12406) - Searching for keywords is not useful.
 - 2016-11-25 Updated unit tests to use Restore Database, thanks to S7 (PR#59).
 - 2016-11-04 Fixed bug#[12201](http://bugs.otrs.org/show_bug.cgi?id=12201) - RSS Feeds don't work if HTTPS is forced in OTRS. Thanks to Michiel Beijen.

#5.0.7 2016-11-01
 - 2016-10-26 Updated translations, thanks to all translators.
 - 2016-10-26 Added language English (United Kingdom), thanks to all translators.
 - 2016-09-29 Added support to choose and sort FAQ attribute columns for linked FAQ items (complex table mode).
 - 2016-09-22 Added new SysConfig setting "FAQ::Frontend::AgentFAQExplorer###ShowInvalidFAQItems" to show or hide invalid FAQ items (disabled by default).
 - 2016-09-22 Fixed bug#[11498](http://bugs.otrs.org/show_bug.cgi?id=11498)(PR#48) - FAQ items disappear from AgentFAQExplorer when invalid, thanks to S7.
 - 2016-09-21 Fixed bug#[11158](http://bugs.otrs.org/show_bug.cgi?id=11158)(PR#49) - Only ro priviledge's user cannot search FAQ, thanks to S7.
 - 2016-09-16 Updated Import console command for OTRS 5 patch level 14.

#5.0.6 2016-09-20
 - 2016-09-14 Updated translations, thanks to all translators.
 - 2016-09-02 Updated translations, thanks to all translators.
 - 2016-09-02 Added missing translations, thanks to Ur Balazs.
 - 2016-08-05 Added Chinese (Taiwan) translation, thanks to all translators.
 - 2016-08-05 Added Thai translation, thanks to all translators.
 - 2016-08-05 Added Indonesian translation, thanks to all translators.
 - 2016-08-05 Updated translations, thanks to all translators.

#5.0.5 2016-06-29
 - 2016-06-27 Fixed perl warning.

#5.0.4 2016-06-29
 - 2016-06-27 Fixed issue with not correctly quoted search parameters.
 - 2016-05-02 Added FileID attribute to the retrieved attachments using Generic Interface PublicFAQGet operation, thanks to Esteban Marin.

#5.0.3 2016-05-17
 - 2016-05-10 Updated translations, thanks to all translators.
 - 2016-05-02 Added Inline attribute to the retrieved attachments using Generic Interface PublicFAQGet operation, thanks to Esteban Marin.
 - 2016-05-01 Fixed problem with the link object widget check, if a other package change de default link object viewmode.
 - 2016-04-25 Fixed bug#[11729](http://bugs.otrs.org/show_bug.cgi?id=11729) - FAQ zoom elements are not collapsed correctly in IE if iframes are empty.
 - 2016-04-23 Small LinkObject table create improvement. Let the link table know which is the source object and the source key.
 - 2016-04-22 Fixed bug#[12028](http://bugs.otrs.org/show_bug.cgi?id=12028) - FAQ update 4 to 5 items with just an HTML table are set as plain text instead of HTML.

#5.0.2 2015-12-01
 - 2015-11-25 Updated translations, thanks to all translators.
 - 2015-11-24 Fixed bug#[11564](http://bugs.otrs.org/show_bug.cgi?id=11564) - FAQ SearchResults will not displayed.
 - 2015-11-24 Fixed bug#[11687](http://bugs.otrs.org/show_bug.cgi?id=11687) - XSS injection vulnerability in modules AgentFAQSearch and AgentFAQSearchSmall on parameter profile.
 - 2015-10-30 Fixed bug#[11195](http://bugs.otrs.org/show_bug.cgi?id=11195) - FAQ-Zoom Template contains unused links to ticket zoom.
 - 2015-10-30 Fixed bug#[11580](http://bugs.otrs.org/show_bug.cgi?id=11580) - FAQ bread crumb navigation is wrong / missing the actual item category.

#5.0.1 2015-10-20
 - 2015-10-13 Updated translation files, thanks to all translators.

#5.0.0.beta1 2015-09-01
 - 2015-08-26 Initial version for OTRS 5
 - 2015-08-25 Fixed bug#[11445](http://bugs.otrs.org/show_bug.cgi?id=11445) - Search results in Public and Customer interface can be sorted only by FAQID.
 - 2015-08-24 Fixed bug#[10719](http://bugs.otrs.org/show_bug.cgi?id=10719) - FAQ without RichTextEditor don't take paragraphes.
 - 2015-07-28 Updated look and feel of select controls.
 - 2015-07-22 Fixed wsdl validation issues.
 - 2015-07-21 Improved visualization of invalid FAQ items and categories in list screens, thanks to S7.
 - 2015-07-15 Dropped HTML print view in favor of PDF, thanks to S7.

#4.0.3 - 2015-??-??
 - 2015-07-31 Fixed bug#[10542](http://bugs.otrs.org/show_bug.cgi?id=10542) - Customer opens FAQ page with empty fields.
 - 2015-07-15 Fixed bug#[11395](http://bugs.otrs.org/show_bug.cgi?id=11395) - Communications error after closing link message in customer interface.
 - 2015-07-10 Updated translations, thanks to all translators.
 - 2015-06-29 Updated settings to FAQ group.
 - 2015-06-29 Fixed bug#[11359](http://bugs.otrs.org/show_bug.cgi?id=11359) - Setting Frontend::Output::FilterElementPost###FAQ AgentTicketActionCommon is not supported.

#4.0.2 - 2015-05-12
 - 2015-05-06 Updated translations, thanks to all translators.
 - 2015-04-29 Fixed bug#[11125](http://bugs.otrs.org/show_bug.cgi?id=11125) - Top 10 is ordered by count for all interface even in Customer Interface.
 - 2015-04-29 Added translation capabilities to field names in SysConfig.
 - 2015-04-01 Fixed bug#[10962](http://bugs.otrs.org/show_bug.cgi?id=10962) - Invalid or wrong session on FAQ dasboard link.
 - 2015-03-03 Updated translations, thanks to all translators.
 - 2015-03-03 Fixed bug#[10937](http://bugs.otrs.org/show_bug.cgi?id=10937) - Missing translation strings in FAQ (OTRS 4.0.2).
 - 2015-01-20 Added message about opening external links from FAQ item fields.
 - 2015-01-16 Fixed bug#[11008](http://bugs.otrs.org/show_bug.cgi?id=11008) - FAQ content size iframes is wrong calculated.

#4.0.1 - 2014-11-25
 - 2014-11-20 Added code to migrate DTL code in SysConfig settings to TT during package update.
 - 2014-11-20 Added Italian language.
 - 2014-11-20 Added Swahili language.
 - 2014-11-20 Added Serbian Cyrillic language.
 - 2014-11-20 Sync translation files.

#4.0.0.rc1 - 2014-11-18
 - 2014-11-13 Sync Translation files.
 - 2014-11-11 Code cleanup.
 - 2014-11-06 Fixed bug#[10851](http://bugs.otrs.org/show_bug.cgi?id=10851) - `You have already voted' by addition of link after vote.
 - 2014-11-06 Fixed bug#[10848](http://bugs.otrs.org/show_bug.cgi?id=10848) - $Env{"..."} on OTRS 4.0.
 - 2014-10-30 Fixed bug#[10661](http://bugs.otrs.org/show_bug.cgi?id=10661) - in public.pl no 'home' button or 'back' button.
 - 2014-10-29 Fixed bug#[10605](http://bugs.otrs.org/show_bug.cgi?id=10605) - subject shows only 30 characters.
 - 2014-10-15 Applied flat design in public and customer interfaces.
 - 2014-10-15 Added missing icons in public and customer interfaces.
 - 2014-10-13 Fixed bug#[10557](http://bugs.otrs.org/show_bug.cgi?id=10557) - Piece of article disappears, when using images.
 - 2014-10-08 Fixed bug#[10792](http://bugs.otrs.org/show_bug.cgi?id=10792) - Oracle DB error in VoteGet().

#4.0.0.beta1 - 2014-09-23
 - 2014-09-17 Fixed bug#[6853](http://bugs.otrs.org/show_bug.cgi?id=6853) - Access keys are conflicting with standard ticket access keys.
 - 2014-09-12 Fixed bug#[10723](http://bugs.otrs.org/show_bug.cgi?id=10723) - OutputFilterTextAutoLink###FAQ feature shows broken image.
 - 2014-07-31 Fixed bug#[10452](http://bugs.otrs.org/show_bug.cgi?id=10452) - FAQ history isn't sorted by created.
 - 2014-07-25 Added GI PublicFAQGet option to fetch or not attachment contents, thanks to Esteban Marin.
 - 2014-07-17 Fixed bug#[10583](http://bugs.otrs.org/show_bug.cgi?id=10583) - ORA-1795 by faq explorer.
 - 2014-06-24 Added Swedish translation, thanks to Andreas Berger.
 - 2014-03-12 Fixed bug#[9494](http://bugs.otrs.org/show_bug.cgi?id=9494) - The originator for a FAQ article approval ticket is unknown.
 - 2014-03-05 Added support to do not change article subject on FAQ insert. (configurable via SysConfig globally and per FAQ item if enabled globally ).
 - 2014-02-26 Added Dynamic Fields support.

#0.0.1. - 2014-XX-XX
EOF
