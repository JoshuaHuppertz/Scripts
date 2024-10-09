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

# Überprüfen, ob Profile im enforce oder complain Modus sind
if echo "$APPARMOR_STATUS" | grep -q "profiles in enforce mode"; then
    enforce_mode=1
else
    enforce_mode=0
fi

if echo "$APPARMOR_STATUS" | grep -q "profiles in complain mode"; then
    complain_mode=1
else
    complain_mode=0
fi

# Überprüfen auf unkonfined Prozesse
if echo "$APPARMOR_STATUS" | grep -q "unconfined"; then
    unconfined_processes=1
else
    unconfined_processes=0
fi

# Ergebnisse überprüfen und ausgeben
check_command "$loaded_profiles" "Profile sind geladen."
check_command "$enforce_mode" "Mindestens ein Profil ist im enforce Modus."
check_command "$complain_mode" "Mindestens ein Profil ist im complain Modus."
check_command "$unconfined_processes" "Es gibt keine unconfined Prozesse."
