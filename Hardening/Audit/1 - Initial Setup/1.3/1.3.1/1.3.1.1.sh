#!/bin/bash

# Funktion zum Überprüfen der Befehlsausführung
check_command() {
    if [ $? -eq 0 ]; then
        echo "PASS: $1"
    else
        echo "FAIL: $1"
    fi
}

# Überprüfen, ob apparmor installiert ist
dpkg-query -s apparmor &>/dev/null
check_command "apparmor ist installiert."

# Überprüfen, ob apparmor-utils installiert ist
dpkg-query -s apparmor-utils &>/dev/null
check_command "apparmor-utils ist installiert."
