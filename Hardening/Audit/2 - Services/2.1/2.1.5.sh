#!/usr/bin/env bash

{
    l_pkgoutput=""
    l_service_output=""
    l_service_enabled=""
    l_service_active=""

    # Überprüfen, ob dnsmasq installiert ist
    if dpkg-query -s dnsmasq &> /dev/null; then
        l_pkgoutput="dnsmasq is installed"
        
        # Überprüfen, ob der Dienst aktiviert ist
        l_service_enabled=$(systemctl is-enabled dnsmasq.service 2>/dev/null)
        
        # Überprüfen, ob der Dienst aktiv ist
        l_service_active=$(systemctl is-active dnsmasq.service 2>/dev/null)
        
        if [[ "$l_service_enabled" == "enabled" ]]; then
            l_service_output+=" - dnsmasq.service is enabled\n"
        fi
        
        if [[ "$l_service_active" == "active" ]]; then
            l_service_output+=" - dnsmasq.service is active\n"
        fi
        
    fi

    # Ausgabe der Ergebnisse
    if [[ -n "$l_pkgoutput" ]]; then
        echo -e "\n- Audit Result:\n ** FAIL **\n - Reason(s) for audit failure:\n$l_pkgoutput"
        [[ -n "$l_service_output" ]] && echo -e "$l_service_output"
    else
        echo -e "\n- Audit Result:\n ** PASS **\n - dnsmasq is not installed."
    fi
}
