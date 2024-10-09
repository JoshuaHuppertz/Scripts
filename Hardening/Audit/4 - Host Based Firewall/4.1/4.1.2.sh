#!/usr/bin/env bash

{
    l_output=""
    l_output2=""

    # Überprüfen, ob iptables-persistent installiert ist
    if dpkg-query -s iptables-persistent &>/dev/null; then
        l_output2="iptables-persistent ist installiert."
    else
        l_output="iptables-persistent ist nicht installiert."
    fi

    # Ergebnisse ausgeben
    if [ -z "$l_output2" ]; then
        echo -e "\n- Audit Ergebnis:\n ** PASS **\n$l_output\n"
    else
        echo -e "\n- Audit Ergebnis:\n ** FAIL **\n - Grund für das Auditversagen:\n$l_output2\n"
    fi
}
