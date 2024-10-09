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

    # Überprüfe die Medienverwaltungs-Einstellungen
    l_desktop_media_handling=$(grep -Psir -- '^\h*\[org/gnome/desktop/media-handling\]' /etc/dconf/db/*)

    if [[ -n "$l_desktop_media_handling" ]]; then
        # Suche nach autorun-never-Einstellungen
        l_autorun_setting=$(grep -Psir -- '^\h*autorun-never=true\b' /etc/dconf/db/local.d/*)

        # Überprüfe die autorun-never-Einstellung
        if [[ -n "$l_autorun_setting" ]]; then
            l_output="$l_output\n - \"autorun-never\" setting found"
        else
            l_output2="$l_output2\n - \"autorun-never\" setting not found"
        fi
    else
        l_output="$l_output\n - [org/gnome/desktop/media-handling] setting not found in /etc/dconf/db/*"
    fi

    # Berichte über die Ergebnisse
    [ -n "$l_pkgoutput" ] && echo -e "\n$l_pkgoutput"
    
    if [ -z "$l_output2" ]; then
        echo -e "\n- Audit Result:\n ** PASS **\n$l_output\n"
    else
        echo -e "\n- Audit Result:\n ** FAIL **\n - Reason(s) for audit failure:\n$l_output2\n"
        [ -n "$l_output" ] && echo -e "\n- Correctly set:\n$l_output\n"
    fi
}
