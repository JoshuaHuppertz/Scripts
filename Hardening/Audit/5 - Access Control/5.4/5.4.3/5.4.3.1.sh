#!/usr/bin/env bash

# Überprüfen, ob nologin in /etc/shells aufgeführt ist
echo "Überprüfen der Datei /etc/shells auf nologin..."

# Überprüfen, ob nologin vorhanden ist
nologin_check=$(grep '/nologin\b' /etc/shells)

# Überprüfung des Ergebnisses
if [[ -z "$nologin_check" ]]; then
  echo "PASS: 'nologin' ist nicht in der Datei /etc/shells aufgeführt."
else
  echo -e "FAIL: 'nologin' wurde in der Datei /etc/shells gefunden:\n$nologin_check"
fi
