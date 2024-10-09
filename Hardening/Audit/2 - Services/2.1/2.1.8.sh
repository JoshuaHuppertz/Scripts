#!/usr/bin/env bash

{
    l_pkgoutput=""
    l_service_enabled=""
    l_service_active=""

    # Überprüfen, ob dovecot-imapd installiert ist
    if dpkg-query -s dovecot-imapd &> /dev/null; then
        l_pkgoutput+="dovecot-imapd is installed\n"
    fi

    # Überprüfen, ob dovecot-pop3d installiert ist
    if dpkg-query -s dovecot-pop3d &> /dev/null; then
        l_pkgoutput+="dovecot-pop3d is installed\n"
    fi

    # Überprüfen, ob die Dienste aktiviert sind, falls eines der Pakete installiert ist
    if [[ -n "$l_pkgoutput" ]]; then
        l_service_enabled=$(systemctl is-enabled dovecot.socket dovecot.service 2>/dev/null)
        l_service_active=$(systemctl is-active dovecot.socket dovecot.service 2>/dev/null)
    fi

    # Ausgabe der Ergebnisse
    if [[ -n "$l_pkgoutput" ]]; then
        echo -e "\n- Audit Result:\n ** FAIL **\n - Reason(s) for audit failure:\n$l_pkgoutput"
        if [[ "$l_service_enabled" == "enabled" ]]; then
            echo -e " - dovecot.socket and/or dovecot.service are enabled"
        fi
        if [[ "$l_service_active" == "active" ]]; then
            echo -e " - dovecot.socket and/or dovecot.service are active"
        fi
    else
        echo -e "\n- Audit Result:\n ** PASS **\n - dovecot-imapd and dovecot-pop3d are not installed."
    fi
}
