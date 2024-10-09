#!/usr/bin/env bash

{
    l_output=""
    l_output2=""

    # Überprüfen, ob cron installiert ist
    if dpkg-query -s cron &>/dev/null; then
        # Überprüfen der Berechtigungen, Uid und Gid von /etc/cron.weekly/
        stat_output=$(stat -Lc 'Access: (%a/%A) Uid: (%u/%U) Gid: (%g/%G)' /etc/cron.weekly/)

        # Bedingungen für Pass oder Fail
        if [[ "$stat_output" == "Access: (700/drwx------) Uid: ( 0/ root) Gid: ( 0/ root)" ]]; then
            l_output=" - Berechtigungen und Benutzer für /etc/cron.weekly/ sind korrekt."
        else
            l_output2=" - Berechtigungen oder Benutzer für /etc/cron.weekly/ sind nicht korrekt:\n   $stat_output"
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
