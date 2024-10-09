#!/bin/bash

# Funktion zum Überprüfen der Befehlsausführung
check_command() {
    if [ $? -eq 0 ]; then
        echo "PASS: $1"
    else
        echo "FAIL: $1"
    fi
}

# Aktualisieren der Paketinformationen
echo "Aktualisiere die Paketinformationen..."
apt update
check_command "Paketinformationen erfolgreich aktualisiert."

# Überprüfen auf verfügbare Updates im simulativen Modus
echo "Überprüfe auf verfügbare Updates..."
UPGRADE_OUTPUT=$(apt -s upgrade)

# Ausgabe der Upgrade-Informationen
echo "$UPGRADE_OUTPUT"

# Überprüfen, ob Updates verfügbar sind
if echo "$UPGRADE_OUTPUT" | grep -q "0 upgraded"; then
    check_command "Es sind keine Updates oder Patches zu installieren."
else
    echo "FAIL: Es sind verfügbare Updates oder Patches gefunden."
fi
