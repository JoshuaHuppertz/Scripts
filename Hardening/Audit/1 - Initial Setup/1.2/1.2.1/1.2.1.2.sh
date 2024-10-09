#!/bin/bash

# Funktion zum Überprüfen der Befehlsausführung
check_command() {
    if [ $? -eq 0 ]; then
        echo "PASS: $1"
    else
        echo "FAIL: $1"
    fi
}

# Überprüfen der Paket-Repository-Konfiguration
echo "Überprüfe die Paket-Repository-Konfiguration..."
APT_POLICY_OUTPUT=$(apt-cache policy)

# Ausgabe der APT-Policy anzeigen
echo "$APT_POLICY_OUTPUT"

# Überprüfen, ob Repositorys konfiguriert sind
if echo "$APT_POLICY_OUTPUT" | grep -q "500"; then
    check_command "Paket-Repositories sind korrekt konfiguriert."
else
    echo "FAIL: Keine korrekt konfigurierten Paket-Repositories gefunden."
    exit 1
fi
