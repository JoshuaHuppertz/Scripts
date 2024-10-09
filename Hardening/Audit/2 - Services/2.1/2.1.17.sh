#!/usr/bin/env bash

{
    l_pkgoutput=""
    l_service_enabled=""
    l_service_active=""

    # Überprüfen, ob squid installiert ist
    if dpkg-query -s squid &> /dev/null; then
        l_pkgoutput+="squid is installed\n"
    fi

    # Überprüfen, ob der Dienst aktiviert ist, falls das Paket installiert ist
    if [[ -n "$l_pkgoutput" ]]; then
        l_service_enabled=$(systemctl is-enabled squid.service 2>/dev/null)
        l_service_active=$(systemctl is-active squid.service 2>/dev/null)
    fi

    # Ausgabe der Ergebnisse
    if [[ -n "$l_pkgoutput" ]]; then
        echo -e "\n- Audit Result:\n ** FAIL **\n - Reason(s) for audit failure:\n$l_pkgoutput"
        if [[ "$l_service_enabled" == "enabled" ]]; then
            echo -e " - squid.service is enabled"
        fi
        if [[ "$l_service_active" == "active" ]]; then
            echo -e " - squid.service is active"
        fi
    else
        echo -e "\n- Audit Result:\n ** PASS **\n - squid is not installed."
    fi
}
