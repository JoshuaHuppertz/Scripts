#!/bin/bash

# Funktion zum Überprüfen der Befehlsausführung
check_command() {
    if [ "$1" -eq 0 ]; then
        echo "PASS: $2"
    else
        echo "FAIL: $2"
    fi
}

# AppArmor Status abrufen
APPARMOR_STATUS=$(apparmor_status)

# Überprüfen der geladenen Profile
if echo "$APPARMOR_STATUS" | grep -q "profiles are loaded"; then
    loaded_profiles=1
else
    loaded_profiles=0
fi

# Überprüfen, ob alle Profile im enforce Modus sind
if echo "$APPARMOR_STATUS" | grep -q "profiles in enforce mode"; then
    enforce_mode=$(echo "$APPARMOR_STATUS" | grep -oP '\d+(?= profiles in enforce mode)' | head -1)
    complain_mode=$(echo "$APPARMOR_STATUS" | grep -oP '\d+(?= profiles in complain mode)' | head -1)
    
    if [ "$complain_mode" -eq 0 ]; then
        complain_status=1
    else
        complain_status=0
    fi
else
    enforce_mode=0
    complain_status=0
fi

# Überprüfen auf unkonfined Prozesse
if echo "$APPARMOR_STATUS" | grep -q "unconfined"; then
    unconfined_processes=1
else
    unconfined_processes=0
fi

# Ergebnisse überprüfen und ausgeben
check_command "$loaded_profiles" "Profile sind geladen."
check_command "$enforce_mode" "Alle Profile sind im enforce Modus."
check_command "$complain_status" "Es sind keine Profile im complain Modus."
check_command "$unconfined_processes" "Es gibt keine unconfined Prozesse."
