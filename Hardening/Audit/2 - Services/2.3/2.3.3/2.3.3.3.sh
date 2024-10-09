#!/usr/bin/env bash

{
    l_output=""
    l_output2=""

    # Überprüfung, ob der chrony-Dienst aktiviert ist
    if systemctl is-enabled chrony.service >/dev/null 2>&1; then
        l_enabled="enabled"
    else
        l_enabled="disabled"
    fi

    # Überprüfung, ob der chrony-Dienst aktiv ist
    if systemctl is-active chrony.service >/dev/null 2>&1; then
        l_active="active"
    else
        l_active="inactive"
    fi

    # Zusammenstellen der Ausgaben
    if [ "$l_enabled" = "enabled" ] && [ "$l_active" = "active" ]; then
        l_output=" - chrony.service ist aktiviert und aktiv."
    else
        l_output2=" - chrony.service ist nicht aktiviert oder nicht aktiv."
        l_output2+="\n   Status: aktiviert: $l_enabled, aktiv: $l_active"
    fi

    # Ausgabe des Ergebnisses
    if [ -z "$l_output2" ]; then
        echo -e "\n- Audit Result:\n ** PASS **\n$l_output\n"
    else
        echo -e "\n- Audit Result:\n ** FAIL **\n - Reason(s) for audit failure:\n$l_output2\n"
    fi
}
