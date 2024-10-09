#!/usr/bin/env bash

{
    # Initialisiere Variablen
    l_pkgoutput=""
    l_output=""
    l_output2=""

    # Bestimme das Paketverwaltungssystem
    if command -v dpkg-query &> /dev/null; then
        l_pq="dpkg-query -s"
    elif command -v rpm &> /dev/null; then
        l_pq="rpm -q"
    fi

    # Überprüfe, ob GDM installiert ist
    l_pcl="gdm gdm3"  # Liste der zu überprüfenden Pakete
    for l_pn in $l_pcl; do
        if $l_pq "$l_pn" &> /dev/null; then
            l_pkgoutput="$l_pkgoutput\n - Package: \"$l_pn\" exists on the system\n - Checking configuration"
        fi
    done

    # Überprüfe die Konfiguration, falls GDM installiert ist
    if [ -n "$l_pkgoutput" ]; then
        echo -e "$l_pkgoutput"

        # Suche nach Automount-Einstellungen
        l_automount_setting=$(grep -Psir -- '^\h*automount=false\b' /etc/dconf/db/local.d/*)
        l_automount_open_setting=$(grep -Psir -- '^\h*automount-open=false\b' /etc/dconf/db/local.d/*)

        # Überprüfe die Automount-Einstellung
        if [[ -n "$l_automount_setting" ]]; then
            l_output="$l_output\n - \"automount\" setting found"
        else
            l_output2="$l_output2\n - \"automount\" setting not found"
        fi

        # Überprüfe die Automount-Öffnungs-Einstellung
        if [[ -n "$l_automount_open_setting" ]]; then
            l_output="$l_output\n - \"automount-open\" setting found"
        else
            l_output2="$l_output2\n - \"automount-open\" setting not found"
        fi
    else
        l_output="$l_output\n - GNOME Desktop Manager package is not installed on the system\n - Recommendation is not applicable"
    fi

    # Berichte über die Ergebnisse
    if [ -z "$l_output2" ]; then
        echo -e "\n- Audit Result:\n ** PASS **\n$l_output\n"
    else
        echo -e "\n- Audit Result:\n ** FAIL **\n - Reason(s) for audit failure:\n$l_output2\n"
        [ -n "$l_output" ] && echo -e "\n- Correctly set:\n$l_output\n"
    fi
}
