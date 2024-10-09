#!/usr/bin/env bash

{
    l_pkgoutput=""
    l_service_enabled=""
    l_service_active=""

    # Überprüfen, ob rpcbind installiert ist
    if dpkg-query -s rpcbind &> /dev/null; then
        l_pkgoutput+="rpcbind is installed\n"
    fi

    # Überprüfen, ob die Dienste aktiviert sind, falls das Paket installiert ist
    if [[ -n "$l_pkgoutput" ]]; then
        l_service_enabled=$(systemctl is-enabled rpcbind.socket rpcbind.service 2>/dev/null)
        l_service_active=$(systemctl is-active rpcbind.socket rpcbind.service 2>/dev/null)
    fi

    # Ausgabe der Ergebnisse
    if [[ -n "$l_pkgoutput" ]]; then
        echo -e "\n- Audit Result:\n ** FAIL **\n - Reason(s) for audit failure:\n$l_pkgoutput"
        if [[ "$l_service_enabled" == "enabled" ]]; then
            echo -e " - rpcbind.socket and/or rpcbind.service are enabled"
        fi
        if [[ "$l_service_active" == "active" ]]; then
            echo -e " - rpcbind.socket and/or rpcbind.service are active"
        fi
    else
        echo -e "\n- Audit Result:\n ** PASS **\n - rpcbind is not installed."
    fi
}
