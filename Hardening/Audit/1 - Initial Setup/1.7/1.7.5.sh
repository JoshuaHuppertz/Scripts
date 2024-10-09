#!/usr/bin/env bash

{
    # Initialisiere Variablen
    l_pkgoutput=""
    
    # Bestimme das Paketverwaltungssystem
    if command -v dpkg-query > /dev/null 2>&1; then
        l_pq="dpkg-query -s"
    elif command -v rpm > /dev/null 2>&1; then
        l_pq="rpm -q"
    fi

    # Überprüfe, ob GDM installiert ist
    l_pcl="gdm gdm3" # Liste der zu überprüfenden Pakete
    for l_pn in $l_pcl; do
        if $l_pq "$l_pn" > /dev/null 2>&1; then
            l_pkgoutput="$l_pkgoutput\n - Package: \"$l_pn\" exists on the system\n - checking configuration"
        fi
    done

    # Überprüfe die Konfiguration, falls GDM installiert ist
    if [ -n "$l_pkgoutput" ]; then
        l_output="" 
        l_output2=""
        
        # Überprüfe, ob idle-delay gesperrt ist
        if grep -Psrilq '^\h*idle-delay\h*=\h*uint32\h+\d+\b' /etc/dconf/db/*/; then
            if grep -Prilq '\/org\/gnome\/desktop\/session\/idle-delay\b' /etc/dconf/db/*/locks; then
                l_output="$l_output\n - \"idle-delay\" is locked"
            else
                l_output2="$l_output2\n - \"idle-delay\" is not locked"
            fi
        else
            l_output2="$l_output2\n - \"idle-delay\" is not set so it cannot be locked"
        fi
        
        # Überprüfe, ob lock-delay gesperrt ist
        if grep -Psrilq '^\h*lock-delay\h*=\h*uint32\h+\d+\b' /etc/dconf/db/*/; then
            if grep -Prilq '\/org\/gnome\/desktop\/screensaver\/lock-delay\b' /etc/dconf/db/*/locks; then
                l_output="$l_output\n - \"lock-delay\" is locked"
            else
                l_output2="$l_output2\n - \"lock-delay\" is not locked"
            fi
        else
            l_output2="$l_output2\n - \"lock-delay\" is not set so it cannot be locked"
        fi
    else
        l_output="$l_output\n - GNOME Desktop Manager package is not installed on the system\n - Recommendation is not applicable"
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
