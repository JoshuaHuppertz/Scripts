#!/bin/bash

# Funktion zum Überprüfen der Befehlsausführung
check_command() {
    if [ "$1" -eq 0 ]; then
        echo "PASS: $2"
    else
        echo "FAIL: $2"
    fi
}

# Statistiken der Datei abrufen
STAT_OUTPUT=$(stat -Lc 'Access: (%#a/%A) Uid: (%u/%U) Gid: (%g/%G)' /boot/grub/grub.cfg)

# Überprüfen der Zugriffsrechte, Uid und Gid
ACCESS=$(echo "$STAT_OUTPUT" | awk '{print $2}' | tr -d '()')
UID=$(echo "$STAT_OUTPUT" | awk '{print $4}' | tr -d '()')
GID=$(echo "$STAT_OUTPUT" | awk '{print $6}' | tr -d '()')

# Überprüfen, ob der Access-Wert 0600 oder restriktiver ist
if [ "$ACCESS" -ge 600 ]; then
    access_check=0
else
    access_check=1
fi

# Überprüfen, ob Uid und Gid beide 0 sind
if [ "$UID" -eq 0 ] && [ "$GID" -eq 0 ]; then
    uid_gid_check=0
else
    uid_gid_check=1
fi

# Ergebnisse überprüfen und ausgeben
check_command "$access_check" "Zugriffsrechte sind 0600 oder restriktiver."
check_command "$uid_gid_check" "Uid und Gid sind beide 0/root."
