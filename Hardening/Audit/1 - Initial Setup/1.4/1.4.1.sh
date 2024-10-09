#!/bin/bash

# Funktion zum Überprüfen der Befehlsausführung
check_command() {
    if [ "$1" -eq 0 ]; then
        echo "PASS: $2"
    else
        echo "FAIL: $2"
    fi
}

# Überprüfen auf set superusers
SUPERUSER_CHECK=$(grep "^set superusers" /boot/grub/grub.cfg)
EXPECTED_SUPERUSER="set superusers=\"<username>\""

if [ "$SUPERUSER_CHECK" == "$EXPECTED_SUPERUSER" ]; then
    check_command 0 "Superuser ist korrekt gesetzt."
else
    check_command 1 "Superuser ist nicht korrekt gesetzt."
fi

# Überprüfen auf password
PASSWORD_CHECK=$(awk -F. '/^\s*password/ {print $1"."$2"."$3}' /boot/grub/grub.cfg)
EXPECTED_PASSWORD="password_pbkdf2 <username> grub.pbkdf2.sha512"

if [ "$PASSWORD_CHECK" == "$EXPECTED_PASSWORD" ]; then
    check_command 0 "Password ist korrekt gesetzt."
else
    check_command 1 "Password ist nicht korrekt gesetzt."
fi
