# Change log of DynamicFieldRemoteDB
* Copyright (C) 2006-2016 c.a.p.e. IT GmbH, http://www.cape-it.de/
* $Id: CHANGES_DynamicFieldRemoteDB.md,v 1.57 2016/09/06 11:07:14 millinger Exp $

# ROADMAP TASKS
* (2016/??/??) - CR: T () (LOGIN)
* (2016/??/??) - Bugfix: T () (LOGIN)

# r5.0.3 (2016/09/06)
* (2016/09/06) - Bugfix: T2016080390000871 (fixed undefined variable) (millinger)
* (2016/08/30) - Bugfix: T2016082190000444 (changed layout of field to match conditions of KIX4OTRS) (millinger)
* (2016/08/23) - Bugfix: T2016082290000504 (missing method StatsSearchFieldParameterBuild) (millinger)
* (2016/07/26) - Bugfix: T2016072690000848 (failed to add value by script) (millinger)

# r5.0.2 (2016/06/30)
* (2016/06/30) - Bugfix: T2016063090000752 (edit field does not handle removed values correctly) (millinger)
* (2016/06/30) - Bugfix: T2016063090000752 (internal server error if constricted array value gets removed) (millinger)
* (2016/06/30) - Bugfix: T2016063090000449 (unescaped left brace in regexp is deprecated) (millinger)
* (2016/06/28) - Bugfix: T2016062890000748 (unnecessary ajax request triggered) (millinger)
* (2016/06/16) - Bugfix: T2016060390000464 (added additional check for valid value) (fjacquemin)
* (2016/05/30) - Bugfix: T2016053090000816 (MaxQueryResult is not used by ajaxhandler) (millinger)

# r5.0.1 (2016/05/18)
* (2016/05/18) - Bugfix: T2016051890000591 (invalid sql-statement for empty optional constrictions) (millinger)
* (2016/04/20) - Bugfix: T2016022590000724 (can not use ticket template with mandatory field) (millinger)
* (2016/03/08) - Bugfix: (fixed undefined value as an ARRAY reference) (millinger)
* (2016/03/01) - CR: T2016021590000341 (DatabaseFieldSearch can comma separated refere to multiple columns) (millinger)
* (2016/03/01) - CR: T2016021590000341 (configurable pre-/suffix for searchinput) (millinger)
* (2016/03/01) - Bugfix: (mandatory fields were not marked correctly) (millinger)
* (2016/03/01) - Bugfix: (async ajax calls caused problems with running conditions) (millinger)

# r5.0.0 (2016/01/29)
* (2016/01/21) - Bugfix: T2016011890001221 (jobs of generic agents have to be checked on upgrade) (millinger)
* (2016/01/21) - Bugfix: T2016011890001221 (correct bind for autocomplete search in AdminGenericAgent) (millinger)

# r4.99.82 (2016/01/12)
* (2016/01/12) - Bugfix: T2016011290000625 (Fixed generation of cache key) (millinger)
* (2016/01/12) - Bugfix: T2016011290000018 (Migration of configured links didnt matched every obsolete placeholder) (millinger)

# r4.99.81 (2016/01/08)
* (2016/01/08) - CR: T2015082690000615 (Removed obsolete objects) (millinger)
* (2016/01/08) - CR: T2015082690000615 (Added trigger for removed values) (millinger)
* (2016/01/08) - CR: T2015082690000615 (Updated documentation) (millinger)

# r4.99.80 (2016/01/01)
* (2016/01/01) - CR: T2015082690000615 (reworked layout and handling) (millinger)
* (2016/01/01) - CR: T2015082690000615 (changes for use with 5.0.x) (millinger)

# r4.0.2 (2015/09/19)
* (2014/09/11) - CR: T2015091090000661 (fields are deleted on uninstall) (millinger)
* (2014/09/11) - Bugfix: T2015091090000661 (fixed field definitions for AdminDynamicFieldRemoteDBArray) (millinger)
* (2014/09/11) - Bugfix: T2015091090000634 (fixed deprecated regular expressions) (millinger)

# r4.0.1 (2015/09/07)
* (2014/09/07) - Bugfix: T2015090790001283 (handling of empty query conditions) (tto)
* (2014/06/29) - Bugfix: T2014102390001055 (keys instead of values shown in column filters) (alitvinova)
* (2015/05/12) - CR: T2015050890000431 (added update for display value if value is changed by scripts) (millinger)
* (2015/05/12) - CR: T2015050890000431 (added definitions for dependencies) (millinger)
* (2014/12/08) - Bugfix: T2014102390001046 (<OTRS_TICKET_DynamicField_*_Value> doesn't work for RemotrDBArray DFs) (alitvinova)

# r1.3.0 (2014/12/01)
* (2014/12/01) - Bugfix: T2014102390000841 (added sub StatsSearchFieldParameterBuild) (alitvinova)

# r1.2.80 (2014/10/17)
* (2014/10/17) - CR: T2014100890000272 (changes for use with OTRS 4.0.x) (alitvinova)

# r1.2.3 (2014/05/11)
* (2014/12/08) - Bugfix: T2014102390001046 (<OTRS_TICKET_DynamicField_*_Value> doesn't work for RemotrDBArray DFs) (alitvinova)
* (2014/10/23) - Bugfix: T2014102390000841 (added sub StatsSearchFieldParameterBuild) (alitvinova)

# r1.2.2 (2014/10/08)
* (2014/07/18) - Bugfix: T2014071890000518 (MinQueryLength was ignored) (smehlig)

# r1.2.1 (2014/07/03)
* (2014/07/03) - Bugfix: T2014070390000466 (fixed case sensitive issue with id as key) (tto)

# r1.2.0 (2014/05/07)
* (2014/05/05) - Bugfix: T2014042590000626 (verified solution in T2014032890000462) (millinger)
* (2014/04/02) - Bugfix: T2014022190000235 (field type not displayed in dynamic field list) (millinger)
* (2014/04/01) - Bugfix: T2014032890000462 (UTF8 issue when using MySQL - implemented DFRemoteDBObject) (millinger)
* (2014/02/27) - Bugfix: T2014021890000705 (cache for possible values as separate option) (millinger)
* (2014/02/18) - CR: T2014021890000278 (configurable case sensitive search) (smehlig)

# r1.1.0 (2013/11/14)
* (2013/10/22) - CR: changes for use with OTRS 3.3.x (millinger)
* (2013/10/22) - CR: fixed behavior for AJAXUpdate (millinger)
* (2013/10/22) - CR: unified creation of links (millinger)

# r1.0.0 (2013/10/17)
* (2013/10/17) - First release for productive use (tto)
* (2013/10/17) - CR: Added package install code frame (tto)
* (2013/10/07) - CR: Added trigger 'change' for autocomplete (millinger)
* (2013/10/07) - CR: Added array-support (millinger)

# r0.4.0 (2013/10/02)
* (2013/10/01) - CR: custom link-url for agent- and customerfrontend (millinger)
* (2013/10/01) - Bugfix: corrected utf-8-encoding (millinger)
* (2013/10/01) - Bugfix: enable to set empty value in autocomplete (millinger)
* (2013/09/30) - Bugfix: prevent search for empty string (millinger)

# r0.3.0 (2013/09/27)
* (2013/09/27) - Bugfix: spinner doesnt disappear executing intersecting requests (millinger)
* (2013/09/26) - CR: renamed and moved CHANGES-file to doc-directory (tto)
* (2013/09/26) - CR: clean up in documentation (tto)

# r0.2.0 (2013/09/26)
* (2013/09/26) - CR: T2013091290000296 (implemented cache for requests) (millinger)
* (2013/09/26) - CR: T2013091290000296 (implemented * as wildcard) (millinger)
* (2013/09/26) - CR: T2013091290000296 (migrated ajax-search to dynamicfield-backend) (millinger)
* (2013/09/26) - CR: T2013091290000296 (implemented linkurl for displayed values) (millinger)

# r0.1.0 (2013/09/23)
* (2013/09/23) - First Release for pre-productive testing. (millinger)
