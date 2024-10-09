#!/bin/bash

# Überprüfen, ob das Passwort für den Benutzer "root" gesetzt ist
echo "Überprüfen, ob das Passwort für den Benutzer 'root' gesetzt ist..."

# Überprüfen des Passwortstatus
password_status=$(passwd -S root | awk '$2 ~ /^P/ {print "User: \"" $1 "\" Password is set"}')

# Überprüfung des Ergebnisses
if [[ -n "$password_status" ]]; then
  echo "PASS: $password_status"
else
  echo "FAIL: Das Passwort für den Benutzer 'root' ist NICHT gesetzt."
fi
