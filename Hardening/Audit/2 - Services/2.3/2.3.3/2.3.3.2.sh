#!/usr/bin/env bash

{
    l_output=""
    l_output2=""

    # Überprüfung, ob der chronyd-Dienst nicht als _chrony ausgeführt wird
    l_non_chrony_users=$(ps -ef | awk '(/[c]hronyd/ && $1!="_chrony") { print $1 }')

    if [ -z "$l_non_chrony_users" ]; then
        l_output=" - chronyd läuft korrekt als _chrony Benutzer."
    else
        l_output2=" - chronyd läuft nicht als _chrony Benutzer, sondern als: $l_non_chrony_users"
    fi

    # Ausgabe des Ergebnisses
    if [ -z "$l_output2" ]; then
        echo -e "\n- Audit Result:\n ** PASS **\n$l_output\n"
    else
        echo -e "\n- Audit Result:\n ** FAIL **\n - Reason(s) for audit failure:\n$l_output2\n"
    fi
}
