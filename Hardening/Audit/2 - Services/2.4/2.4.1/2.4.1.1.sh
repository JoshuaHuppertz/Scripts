#!/usr/bin/env bash

{
    l_output=""
    l_output2=""

    # Überprüfen, ob der cron-Dienst installiert ist
    if systemctl list-unit-files | awk '$1~/^crond?\.service/{print $2}' | grep -q 'enabled'; then
        l_enabled="enabled"
    else
        l_enabled="disabled"
    fi

    # Überprüfen, ob der cron-Dienst aktiv ist
    if systemctl list-units | awk '$1~/^crond?\.service/{print $3}' | grep -q 'active'; then
        l_active="active"
    else
        l_active="inactive"
    fi

    # Zusammenstellen der Ausgaben
    if [ "$l_enabled" = "enabled" ] && [ "$l_active" = "active" ]; then
        l_output=" - cron ist aktiviert und aktiv."
    else
        l_output2=" - cron ist nicht aktiviert oder nicht aktiv."
        l_output2+="\n   Status: aktiviert: $l_enabled, aktiv: $l_active"
    fi

    # Ausgabe des Ergebnisses
    if [ -z "$l_output2" ]; then
        echo -e "\n- Audit Result:\n ** PASS **\n$l_output\n"
    else
        echo -e "\n- Audit Result:\n ** FAIL **\n - Reason(s) for audit failure:\n$l_output2\n"
    fi
}
