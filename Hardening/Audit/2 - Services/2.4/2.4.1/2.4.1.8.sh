#!/usr/bin/env bash

{
    l_output=""
    l_output2=""

    # Überprüfen, ob cron installiert ist
    if dpkg-query -s cron &>/dev/null; then
        # Überprüfen der Datei /etc/cron.allow
        if [ -e "/etc/cron.allow" ]; then
            stat_allow=$(stat -Lc 'Access: (%a/%A) Owner: (%U) Group: (%G)' /etc/cron.allow)

            if [[ "$stat_allow" == "Access: (640/-rw-r-----) Owner: (root) Group: (root)" ]]; then
                l_output=" - /etc/cron.allow ist korrekt gesetzt."
            else
                l_output2=" - /etc/cron.allow ist nicht korrekt:\n   $stat_allow"
            fi
        else
            l_output2=" - /etc/cron.allow existiert nicht."
        fi

        # Überprüfen der Datei /etc/cron.deny
        if [ -e "/etc/cron.deny" ]; then
            stat_deny=$(stat -Lc 'Access: (%a/%A) Owner: (%U) Group: (%G)' /etc/cron.deny)

            if [[ "$stat_deny" == "Access: (640/-rw-r-----) Owner: (root) Group: (root)" ]]; then
                l_output+="\n - /etc/cron.deny ist korrekt gesetzt."
            else
                l_output2+="\n - /etc/cron.deny ist nicht korrekt:\n   $stat_deny"
            fi
        fi

    else
        l_output2=" - cron ist nicht installiert."
    fi

    # Ausgabe des Ergebnisses
    if [ -z "$l_output2" ]; then
        echo -e "\n- Audit Result:\n ** PASS **\n$l_output\n"
    else
        echo -e "\n- Audit Result:\n ** FAIL **\n - Reason(s) for audit failure:\n$l_output2\n"
    fi
}
