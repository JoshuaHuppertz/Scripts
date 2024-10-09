#!/usr/bin/env bash

{
    l_pkgoutput=""
    l_service_enabled=""
    l_service_active=""

    # Überprüfen, ob slapd installiert ist
    if dpkg-query -s slapd &> /dev/null; then
        l_pkgoutput="slapd is installed"
        
        # Überprüfen, ob der Dienst aktiviert ist
        l_service_enabled=$(systemctl is-enabled slapd.service 2>/dev/null)
        
        # Überprüfen, ob der Dienst aktiv ist
        l_service_active=$(systemctl is-active slapd.service 2>/dev/null)
        
    fi

    # Ausgabe der Ergebnisse
    if [[ -n "$l_pkgoutput" ]]; then
        echo -e "\n- Audit Result:\n ** FAIL **\n - Reason(s) for audit failure:\n$l_pkgoutput"
        if [[ "$l_service_enabled" == "enabled" ]]; then
            echo -e " - slapd.service is enabled"
        fi
        if [[ "$l_service_active" == "active" ]]; then
            echo -e " - slapd.service is active"
        fi
    else
        echo -e "\n- Audit Result:\n ** PASS **\n - slapd is not installed."
    fi
}
