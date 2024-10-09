#!/bin/bash

# Überprüfen der Benutzer mit UID 0 in /etc/passwd
echo "Überprüfen der Benutzer mit UID 0..."

# Benutzer mit UID 0 ermitteln
users_with_uid_zero=$(awk -F: '($3 == 0) { print $1 }' /etc/passwd)

# Überprüfung des Ergebnisses
if [[ "$users_with_uid_zero" == "root" ]]; then
  echo "PASS: Nur 'root' wurde gefunden als Benutzer mit UID 0."
else
  echo "FAIL: Folgende Benutzer wurden mit UID 0 gefunden:\n$users_with_uid_zero"
fi
