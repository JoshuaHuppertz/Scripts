#!/usr/bin/env bash

{
    l_pkgoutput=""
    l_service_enabled=""
    l_service_active=""

    # Überprüfen, ob apache2 installiert ist
    if dpkg-query -s apache2 &> /dev/null; then
        l_pkgoutput+="apache2 is installed\n"
    fi

    # Überprüfen, ob nginx installiert ist
    if dpkg-query -s nginx &> /dev/null; then
        l_pkgoutput+="nginx is installed\n"
    fi

    # Überprüfen, ob Dienste aktiviert sind, falls ein Paket installiert ist
    if [[ -n "$l_pkgoutput" ]]; then
        l_service_enabled=$(systemctl is-enabled apache2.socket apache2.service nginx.service 2>/dev/null | grep 'enabled')
        l_service_active=$(systemctl is-active apache2.socket apache2.service nginx.service 2>/dev/null | grep '^active')
    fi

    # Ausgabe der Ergebnisse
    if [[ -n "$l_pkgoutput" ]]; then
        echo -e "\n- Audit Result:\n ** FAIL **\n - Reason(s) for audit failure:\n$l_pkgoutput"
        if [[ -n "$l_service_enabled" ]]; then
            echo -e " - Services enabled: $l_service_enabled"
        fi
        if [[ -n "$l_service_active" ]]; then
            echo -e " - Services active: $l_service_active"
        fi
    else
        echo -e "\n- Audit Result:\n ** PASS **\n - Neither apache2 nor nginx are installed."
    fi
}
