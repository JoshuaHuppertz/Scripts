#!/usr/bin/env bash

# Überprüfen, ob Apport installiert ist
if dpkg-query -s apport &>/dev/null; then
    # Überprüfen, ob Apport aktiviert ist
    if grep -Psi '^\h*enabled\h*=\h*[^0]\b' /etc/default/apport &>/dev/null; then
        apport_enabled="FAIL: Apport is enabled."
    else
        apport_enabled="PASS: Apport is not enabled."
    fi

    # Überprüfen, ob der Apport-Dienst aktiv ist
    if systemctl is-active apport.service | grep '^active' &>/dev/null; then
        apport_active="FAIL: Apport service is active."
    else
        apport_active="PASS: Apport service is not active."
    fi
else
    apport_enabled="FAIL: Apport is not installed."
    apport_active="FAIL: Apport service is not active."
fi

# Ausgabe der Ergebnisse
echo -e "\n- Audit Result for Apport:\n$apport_enabled\n$apport_active\n"
