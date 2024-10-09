#!/usr/bin/env bash

{
    l_pkgoutput=""
    l_service_enabled=""
    l_service_active=""

    # Überprüfen, ob xinetd installiert ist
    if dpkg-query -s xinetd &> /dev/null; then
        l_pkgoutput+="xinetd is installed\n"
    fi

    # Überprüfen, ob der Dienst aktiviert ist, falls das Paket installiert ist
    if [[ -n "$l_pkgoutput" ]]; then
        l_service_enabled=$(systemctl is-enabled xinetd.service 2>/dev/null | grep 'enabled')
        l_service_active=$(systemctl is-active xinetd.service 2>/dev/null | grep '^active')
    fi

    # Ausgabe der Ergebnisse
    if [[ -n "$l_pkgoutput" ]]; then
        echo -e "\n- Audit Result:\n ** FAIL **\n - Reason(s) for audit failure:\n$l_pkgoutput"
        if [[ -n "$l_service_enabled" ]]; then
            echo -e " - Service enabled: $l_service_enabled"
        fi
        if [[ -n "$l_service_active" ]]; then
            echo -e " - Service active: $l_service_active"
        fi
    else
        echo -e "\n- Audit Result:\n ** PASS **\n - xinetd is not installed."
    fi
}
