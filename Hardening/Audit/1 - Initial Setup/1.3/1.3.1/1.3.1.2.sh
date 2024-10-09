#!/bin/bash

# Funktion zum Überprüfen der Befehlsausführung
check_command() {
    if [ "$1" -eq 0 ]; then
        echo "PASS: $2"
    else
        echo "FAIL: $2"
    fi
}

# Überprüfen auf apparmor=1
APPARMOR_CHECK=$(grep "^\s*linux" /boot/grub/grub.cfg | grep -v "apparmor=1")
check_command "$(echo -z "$APPARMOR_CHECK" | wc -c)" "Alle 'linux'-Zeilen haben 'apparmor=1' gesetzt."

# Überprüfen auf security=apparmor
SECURITY_CHECK=$(grep "^\s*linux" /boot/grub/grub.cfg | grep -v "security=apparmor")
check_command "$(echo -z "$SECURITY_CHECK" | wc -c)" "Alle 'linux'-Zeilen haben 'security=apparmor' gesetzt."
