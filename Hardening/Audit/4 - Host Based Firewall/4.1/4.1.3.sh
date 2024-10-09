#!/usr/bin/env bash

{
    l_output=""
    l_output2=""

    # Überprüfen, ob der UFW-Dämon aktiviert ist
    if systemctl is-enabled ufw.service &>/dev/null; then
        l_output="Der UFW-Dämon ist aktiviert."
    else
        l_output2="Der UFW-Dämon ist nicht aktiviert."
    fi

    # Überprüfen, ob der UFW-Dämon aktiv ist
    if systemctl is-active ufw.service &>/dev/null; then
        l_output+="\nDer UFW-Dämon ist aktiv."
    else
        l_output2+="\nDer UFW-Dämon ist nicht aktiv."
    fi

    # Überprüfen, ob UFW aktiv ist
    if ufw status | grep -q "Status: active"; then
        l_output+="\nUFW ist aktiv."
    else
        l_output2+="\nUFW ist nicht aktiv."
    fi

    # Ergebnisse ausgeben
    if [ -z "$l_output2" ]; then
        echo -e "\n- Audit Ergebnis:\n ** PASS **\n$l_output\n"
    else
        echo -e "\n- Audit Ergebnis:\n ** FAIL **\n - Grund für das Auditversagen:\n$l_output2\n"
    fi
}
