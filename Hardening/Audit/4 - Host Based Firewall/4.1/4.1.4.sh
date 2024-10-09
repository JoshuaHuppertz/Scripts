#!/usr/bin/env bash

{
    l_output=""
    l_output2=""
    rules=(
        "Anywhere on lo ALLOW IN Anywhere"
        "Anywhere DENY IN 127.0.0.0/8"
        "Anywhere (v6) on lo ALLOW IN Anywhere (v6)"
        "Anywhere (v6) DENY IN ::1"
        "Anywhere ALLOW OUT Anywhere on lo"
        "Anywhere (v6) ALLOW OUT Anywhere (v6) on lo"
    )

    # UFW-Status überprüfen
    ufw_status=$(ufw status verbose 2>/dev/null)

    # Überprüfen, ob die Regeln in der richtigen Reihenfolge vorhanden sind
    for rule in "${rules[@]}"; do
        if ! echo "$ufw_status" | grep -qF "$rule"; then
            l_output2+="Regel fehlt oder nicht korrekt: \"$rule\"\n"
        fi
    done

    # Ergebnisse ausgeben
    if [ -z "$l_output2" ]; then
        l_output="Alle erforderlichen Regeln sind korrekt gesetzt."
        echo -e "\n- Audit Ergebnis:\n ** PASS **\n$l_output\n"
    else
        echo -e "\n- Audit Ergebnis:\n ** FAIL **\n - Grund für das Auditversagen:\n$l_output2\n"
    fi
}
