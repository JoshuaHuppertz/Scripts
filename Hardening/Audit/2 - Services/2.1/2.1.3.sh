#!/usr/bin/env bash

{
    l_pkgoutput=""
    l_service_output=""
    l_service_enabled=""
    l_service_active=""

    # Überprüfen, ob isc-dhcp-server installiert ist
    if dpkg-query -s isc-dhcp-server &> /dev/null; then
        l_pkgoutput="isc-dhcp-server is installed"
        
        # Überprüfen, ob die Dienste aktiviert sind
        l_service_enabled=$(systemctl is-enabled isc-dhcp-server.service isc-dhcp-server6.service 2>/dev/null)
        
        # Überprüfen, ob die Dienste aktiv sind
        l_service_active=$(systemctl is-active isc-dhcp-server.service isc-dhcp-server6.service 2>/dev/null)
        
        if [[ "$l_service_enabled" == "enabled" ]]; then
            l_service_output+=" - isc-dhcp-server.service and/or isc-dhcp-server6.service are enabled\n"
        fi
        
        if [[ "$l_service_active" == "active" ]]; then
            l_service_output+=" - isc-dhcp-server.service and/or isc-dhcp-server6.service are active\n"
        fi
        
    fi

    # Ausgabe der Ergebnisse
    if [[ -n "$l_pkgoutput" ]]; then
        echo -e "\n- Audit Result:\n ** FAIL **\n - Reason(s) for audit failure:\n$l_pkgoutput"
        [[ -n "$l_service_output" ]] && echo -e "$l_service_output"
    else
        echo -e "\n- Audit Result:\n ** PASS **\n - isc-dhcp-server is not installed."
    fi
}
