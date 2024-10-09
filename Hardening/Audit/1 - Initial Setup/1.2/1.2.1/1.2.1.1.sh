#!/bin/bash

# Funktion zum Überprüfen der Befehlsausführung
check_command() {
    if [ $? -eq 0 ]; then
        echo "PASS: $1"
    else
        echo "FAIL: $1"
    fi
}

# Überprüfen, ob GPG-Schlüssel für APT korrekt konfiguriert sind
echo "Überprüfe GPG-Schlüssel für den Paketmanager..."
GPG_OUTPUT=$(apt-key list)

if [ -n "$GPG_OUTPUT" ]; then
    echo "$GPG_OUTPUT"
    check_command "GPG-Schlüssel sind korrekt konfiguriert."
else
    echo "FAIL: Keine GPG-Schlüssel gefunden. Überprüfung fehlgeschlagen."
    exit 1
fi
