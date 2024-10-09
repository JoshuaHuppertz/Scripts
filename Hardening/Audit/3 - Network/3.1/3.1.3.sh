#!/usr/bin/env bash

# Initialisieren der Ausgabewerte
l_output=""
l_output2=""

# Überprüfen, ob das bluez-Paket installiert ist
if dpkg-query -s bluez &>/dev/null; then
    l_output2=" - Das Paket 'bluez' ist installiert."
else
    l_output=" - Das Paket 'bluez' ist nicht installiert."
fi

# Wenn bluez installiert ist, überprüfen wir den Status des bluetooth.service
if [ -n "$l_output2" ]; then
    # Überprüfen, ob bluetooth.service aktiviert ist
    if systemctl is-enabled bluetooth.service 2>/dev/null | grep -q 'enabled'; then
        l_output2="$l_output2\n - bluetooth.service ist aktiviert."
    fi

    # Überprüfen, ob bluetooth.service aktiv ist
    if systemctl is-active bluetooth.service 2>/dev/null | grep -q '^active'; then
        l_output2="$l_output2\n - bluetooth.service ist aktiv."
    fi
fi

# Ergebnisse ausgeben
if [ -z "$l_output2" ]; then
    echo -e "\n- Audit Ergebnis:\n ** PASS **"
    if [ -z "$l_output" ]; then
        echo -e "\n - Das Paket 'bluez' ist nicht installiert und der Dienst 'bluetooth' ist nicht aktiv."
    else
        echo -e "\n$l_output\n"
    fi
else
    echo -e "\n- Audit Ergebnis:\n ** FAIL **\n - Gründe für das Auditversagen:\n$l_output2\n"
    if [ -z "$l_output" ]; then
        echo -e "\n - Das Paket 'bluez' ist nicht installiert."
    fi
fi
