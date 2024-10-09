#!/usr/bin/env bash

{
    l_pkgoutput=""
    l_service_enabled=""
    l_service_active=""

    # Überprüfen, ob vsftpd installiert ist
    if dpkg-query -s vsftpd &> /dev/null; then
        l_pkgoutput="vsftpd is installed"
        
        # Überprüfen, ob der Dienst aktiviert ist
        l_service_enabled=$(systemctl is-enabled vsftpd.service 2>/dev/null)
        
        # Überprüfen, ob der Dienst aktiv ist
        l_service_active=$(systemctl is-active vsftpd.service 2>/dev/null)
        
    fi

    # Ausgabe der Ergebnisse
    if [[ -n "$l_pkgoutput" ]]; then
        echo -e "\n- Audit Result:\n ** FAIL **\n - Reason(s) for audit failure:\n$l_pkgoutput"
        if [[ "$l_service_enabled" == "enabled" ]]; then
            echo -e " - vsftpd.service is enabled"
        fi
        if [[ "$l_service_active" == "active" ]]; then
            echo -e " - vsftpd.service is active"
        fi
    else
        echo -e "\n- Audit Result:\n ** PASS **\n - vsftpd is not installed."
    fi
}
