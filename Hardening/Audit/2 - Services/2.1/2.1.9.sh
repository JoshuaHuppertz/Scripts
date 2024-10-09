#!/usr/bin/env bash

{
    l_pkgoutput=""
    l_service_enabled=""
    l_service_active=""

    # Überprüfen, ob nfs-kernel-server installiert ist
    if dpkg-query -s nfs-kernel-server &> /dev/null; then
        l_pkgoutput+="nfs-kernel-server is installed\n"
    fi

    # Überprüfen, ob die Dienste aktiviert sind, falls das Paket installiert ist
    if [[ -n "$l_pkgoutput" ]]; then
        l_service_enabled=$(systemctl is-enabled nfs-server.service 2>/dev/null)
        l_service_active=$(systemctl is-active nfs-server.service 2>/dev/null)
    fi

    # Ausgabe der Ergebnisse
    if [[ -n "$l_pkgoutput" ]]; then
        echo -e "\n- Audit Result:\n ** FAIL **\n - Reason(s) for audit failure:\n$l_pkgoutput"
        if [[ "$l_service_enabled" == "enabled" ]]; then
            echo -e " - nfs-server.service is enabled"
        fi
        if [[ "$l_service_active" == "active" ]]; then
            echo -e " - nfs-server.service is active"
        fi
    else
        echo -e "\n- Audit Result:\n ** PASS **\n - nfs-kernel-server is not installed."
    fi
}
