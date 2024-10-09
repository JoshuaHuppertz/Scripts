#!/usr/bin/env bash

{
    l_output=""
    l_output2=""

    # Überprüfen, ob UFW installiert ist
    if dpkg-query -s ufw &>/dev/null; then
        l_output="UFW ist installiert."
    else
        l_output2="UFW ist nicht installiert."
    fi

    # Ergebnisse ausgeben
    if [ -z "$l_output2" ]; then
        echo -e "\n- Audit Ergebnis:\n ** PASS **\n$l_output\n"
    else
        echo -e "\n- Audit Ergebnis:\n ** FAIL **\n - Grund für das Auditversagen:\n$l_output2\n"
    fi
}
