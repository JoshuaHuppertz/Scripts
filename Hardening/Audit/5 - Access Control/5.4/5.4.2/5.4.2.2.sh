#!/bin/bash

# Überprüfen der primären GID für den Benutzer "root" und andere Benutzer mit GID 0
echo "Überprüfen der primären GID für den Benutzer 'root' und andere Benutzer..."

# Überprüfen der primären GID
users_with_gid_zero=$(awk -F: '($1 !~ /^(sync|shutdown|halt|operator)/ && $4=="0") {print $1":"$4}' /etc/passwd)

# Überprüfung des Ergebnisses
if [[ "$users_with_gid_zero" == "root:0" ]]; then
  echo "PASS: Nur der Benutzer 'root' hat die primäre GID 0."
else
  echo "FAIL: Folgende Benutzer haben die primäre GID 0:\n$users_with_gid_zero"
fi
