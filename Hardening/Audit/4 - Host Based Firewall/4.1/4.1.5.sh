#!/usr/bin/env bash

{
    l_output=""
    l_output2=""
    
    # Hier definieren Sie die erwarteten Regeln für ausgehende Verbindungen
    expected_rules=(
        "ALLOW OUT"
        "DENY OUT"
        # Füge hier weitere spezifische Regeln hinzu, die der Site-Policy entsprechen
    )

    # UFW-Status (nummeriert) abrufen
    ufw_status=$(ufw status numbered 2>/dev/null)

    # Überprüfen, ob alle erwarteten Regeln in der Ausgabe vorhanden sind
    for rule in "${expected_rules[@]}"; do
        if ! echo "$ufw_status" | grep -qF "$rule"; then
            l_output2+="Regel fehlt oder nicht korrekt: \"$rule\"\n"
        fi
    done

    # Ergebnisse ausgeben
    if [ -z "$l_output2" ]; then
        l_output="Alle erforderlichen ausgehenden Verbindungsregeln entsprechen der Site-Policy."
        echo -e "\n- Audit Ergebnis:\n ** PASS **\n$l_output\n"
    else
        echo -e "\n- Audit Ergebnis:\n ** FAIL **\n - Grund für das Auditversagen:\n$l_output2\n"
    fi
}
