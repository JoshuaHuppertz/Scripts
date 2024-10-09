#!/usr/bin/env bash

{
    l_pkgoutput=""
    l_service_output=""
    l_service_enabled=""
    l_service_active=""
    
    # Überprüfen, ob avahi-daemon installiert ist
    if dpkg-query -s avahi-daemon &> /dev/null; then
        l_pkgoutput="avahi-daemon is installed"
        
        # Überprüfen, ob der Socket und der Dienst aktiviert sind
        l_service_enabled=$(systemctl is-enabled avahi-daemon.socket avahi-daemon.service 2>/dev/null)
        
        # Überprüfen, ob der Socket und der Dienst aktiv sind
        l_service_active=$(systemctl is-active avahi-daemon.socket avahi-daemon.service 2>/dev/null)
        
        if [[ "$l_service_enabled" == "enabled" ]]; then
            l_service_output+=" - avahi-daemon.socket and/or avahi-daemon.service are enabled\n"
        fi
        
        if [[ "$l_service_active" == "active" ]]; then
            l_service_output+=" - avahi-daemon.socket and/or avahi-daemon.service are active\n"
        fi
        
    fi

    # Ausgabe der Ergebnisse
    if [[ -n "$l_pkgoutput" ]]; then
        echo -e "\n- Audit Result:\n ** FAIL **\n - Reason(s) for audit failure:\n$l_pkgoutput"
        [[ -n "$l_service_output" ]] && echo -e "$l_service_output"
    else
        echo -e "\n- Audit Result:\n ** PASS **\n - avahi-daemon is not installed."
    fi
}
