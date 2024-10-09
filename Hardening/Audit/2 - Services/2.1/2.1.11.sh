#!/usr/bin/env bash

{
    l_pkgoutput=""
    l_service_enabled=""
    l_service_active=""

    # Überprüfen, ob cups installiert ist
    if dpkg-query -s cups &> /dev/null; then
        l_pkgoutput+="cups is installed\n"
    fi

    # Überprüfen, ob die Dienste aktiviert sind, falls das Paket installiert ist
    if [[ -n "$l_pkgoutput" ]]; then
        l_service_enabled=$(systemctl is-enabled cups.socket cups.service 2>/dev/null)
        l_service_active=$(systemctl is-active cups.socket cups.service 2>/dev/null)
    fi

    # Ausgabe der Ergebnisse
    if [[ -n "$l_pkgoutput" ]]; then
        echo -e "\n- Audit Result:\n ** FAIL **\n - Reason(s) for audit failure:\n$l_pkgoutput"
        if [[ "$l_service_enabled" == "enabled" ]]; then
            echo -e " - cups.socket and/or cups.service are enabled"
        fi
        if [[ "$l_service_active" == "active" ]]; then
            echo -e " - cups.socket and/or cups.service are active"
        fi
    else
        echo -e "\n- Audit Result:\n ** PASS **\n - cups is not installed."
    fi
}
