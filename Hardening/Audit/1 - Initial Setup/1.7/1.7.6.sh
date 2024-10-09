#!/usr/bin/env bash

{
    # Initialisiere Variablen
    l_pkgoutput=""
    l_output=""
    l_output2=""

    # Bestimme das Paketverwaltungssystem
    if command -v dpkg-query > /dev/null 2>&1; then
        l_pq="dpkg-query -s"
    elif command -v rpm > /dev/null 2>&1; then
        l_pq="rpm -q"
    fi

    # Überprüfe, ob GDM installiert ist
    l_pcl="gdm gdm3"  # Liste der zu überprüfenden Pakete
    for l_pn in $l_pcl; do
        if $l_pq "$l_pn" > /dev/null 2>&1; then
            l_pkgoutput="$l_pkgoutput\n - Package: \"$l_pn\" exists on the system\n - checking configuration"
        fi
    done

    # Überprüfe die Konfiguration, falls GDM installiert ist
    if [ -n "$l_pkgoutput" ]; then
        echo -e "$l_pkgoutput"

        # Suche nach bestehenden Einstellungen
        l_kfile="$(grep -Prils -- '^\h*automount\b' /etc/dconf/db/*.d)"
        l_kfile2="$(grep -Prils -- '^\h*automount-open\b' /etc/dconf/db/*.d)"

        # Setze den Profilnamen basierend auf dem dconf-Datenbankverzeichnis
        if [ -f "$l_kfile" ]; then
            l_gpname="$(awk -F/ '{split($(NF-1),a,".");print a[1]}' <<< "$l_kfile")"
        elif [ -f "$l_kfile2" ]; then
            l_gpname="$(awk -F/ '{split($(NF-1),a,".");print a[1]}' <<< "$l_kfile2")"
        fi

        # Wenn der Profilname existiert, fahre mit den Überprüfungen fort
        if [ -n "$l_gpname" ]; then
            l_gpdir="/etc/dconf/db/$l_gpname.d"

            # Überprüfe, ob die Profildatei existiert
            if grep -Pq -- "^\h*system-db:$l_gpname\b" /etc/dconf/profile/*; then
                l_output="$l_output\n - dconf database profile file \"$(grep -Pl -- "^\h*system-db:$l_gpname\b" /etc/dconf/profile/*)\" exists"
            else
                l_output2="$l_output2\n - dconf database profile isn't set"
            fi

            # Überprüfe, ob die dconf-Datenbankdatei existiert
            if [ -f "/etc/dconf/db/$l_gpname" ]; then
                l_output="$l_output\n - The dconf database \"$l_gpname\" exists"
            else
                l_output2="$l_output2\n - The dconf database \"$l_gpname\" doesn't exist"
            fi

            # Überprüfe, ob das dconf-Datenbankverzeichnis existiert
            if [ -d "$l_gpdir" ]; then
                l_output="$l_output\n - The dconf directory \"$l_gpdir\" exists"
            else
                l_output2="$l_output2\n - The dconf directory \"$l_gpdir\" doesn't exist"
            fi

            # Überprüfe die Automount-Einstellungen
            if grep -Pqrs -- '^\h*automount\h*=\h*false\b' "$l_kfile"; then
                l_output="$l_output\n - \"automount\" is set to false in: \"$l_kfile\""
            else
                l_output2="$l_output2\n - \"automount\" is not set correctly"
            fi

            # Überprüfe die Automount-Öffnungs-Einstellung
            if grep -Pqs -- '^\h*automount-open\h*=\h*false\b' "$l_kfile2"; then
                l_output="$l_output\n - \"automount-open\" is set to false in: \"$l_kfile2\""
            else
                l_output2="$l_output2\n - \"automount-open\" is not set correctly"
            fi
        else
            # Einstellungen existieren nicht
            l_output2="$l_output2\n - neither \"automount\" nor \"automount-open\" is set"
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
