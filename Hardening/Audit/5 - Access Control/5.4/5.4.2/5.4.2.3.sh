#!/bin/bash

# Überprüfen der Gruppen mit GID 0
echo "Überprüfen der Gruppen mit GID 0..."

# Überprüfen der Gruppen mit GID 0
groups_with_gid_zero=$(awk -F: '$3=="0"{print $1":"$3}' /etc/group)

# Überprüfung des Ergebnisses
if [[ "$groups_with_gid_zero" == "root:0" ]]; then
  echo "PASS: Nur die Gruppe 'root' hat die GID 0."
else
  echo "FAIL: Folgende Gruppen haben die GID 0:\n$groups_with_gid_zero"
fi
