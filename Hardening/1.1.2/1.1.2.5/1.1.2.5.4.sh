#!/bin/bash

# Funktion zum Überprüfen der Befehlsausführung
check_command() {
    if [ $? -eq 0 ]; then
        echo "PASS: $1"
    else
        echo "FAIL: $1"
    fi
}

# Überprüfen, ob /var/tmp gemountet ist
echo "Überprüfe, ob /var/tmp gemountet ist..."
MOUNT_OUTPUT=$(findmnt -kn /var/tmp)
echo "$MOUNT_OUTPUT"

if [[ $MOUNT_OUTPUT == *"/var/tmp"* ]]; then
    check_command "Findmnt zeigt, dass /var/tmp gemountet ist."
else
    echo "FAIL: /var/tmp ist nicht gemountet."
    exit 1
fi

# Überprüfen, ob die noexec-Option gesetzt ist
echo "Überprüfe, ob die noexec-Option für /var/tmp gesetzt ist..."
NOEXEC_CHECK=$(findmnt -kn /var/tmp | grep -v noexec)

if [ -z "$NOEXEC_CHECK" ]; then
    check_command "Die noexec-Option ist für /var/tmp gesetzt."
else
    echo "FAIL: Die noexec-Option ist nicht für /var/tmp gesetzt."
fi
