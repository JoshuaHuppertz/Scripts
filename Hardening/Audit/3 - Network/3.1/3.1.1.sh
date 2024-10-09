#!/usr/bin/env bash

# Initialisieren der Ausgabewerte
l_output=""
l_output2=""

# Überprüfen, ob IPv6 aktiviert ist
if grep -Pqs '^\h*0\b' /sys/module/ipv6/parameters/disable; then
    l_output=" - IPv6 ist aktiviert."
else
    l_output2=" - IPv6 ist nicht aktiviert."
fi

# Ergebnisse ausgeben
if [ -z "$l_output2" ]; then
    echo -e "\n- Audit Ergebnis:\n ** PASS **"
    echo -e "\n$l_output"
else
    echo -e "\n- Audit Ergebnis:\n ** FAIL **"
    echo -e "\n$l_output2"
fi
