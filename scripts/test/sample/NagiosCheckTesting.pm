# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

%Config = (
    Search => {

        # tickets created in the last 120 minutes
        TicketID => 1,
    },

    # Declaration of thresholds
    # min_warn_treshold > Number of tickets -> WARNING
    # max_warn_treshold < Number of tickets -> WARNING
    # min_crit_treshold > Number of tickets -> ALARM
    # max_warn_treshold < Number of tickets -> ALARM

    min_warn_treshold => 0,
    max_warn_treshold => 10,
    min_crit_treshold => 0,
    max_crit_treshold => 20,

    # Information used by Nagios
    # Name of check shown in Nagios Status Information
    checkname => 'OTRS Checker',

    # Text shown in Status Information if everything is OK
    OK_TXT => 'enjoy   tickets:',

    # Text shown in Status Information if warning threshold reached
    WARN_TXT => 'number of tickets:',

    # Text shown in Status Information if critical threshold reached
    CRIT_TXT => 'critical number of tickets:',

);
