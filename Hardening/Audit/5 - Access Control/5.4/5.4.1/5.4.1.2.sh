#!/bin/bash

# Überprüfen der PASS_MIN_DAYS in /etc/login.defs
LOGIN_DEFS="/etc/login.defs"
SHADOW_FILE="/etc/shadow"

# Überprüfen, ob die Datei /etc/login.defs existiert
if [[ ! -f "$LOGIN_DEFS" ]]; then
  echo "FAIL: Die Datei $LOGIN_DEFS existiert nicht."
  exit 1
fi

# Überprüfen von PASS_MIN_DAYS
pass_min_days=$(grep -Pi -- '^\h*PASS_MIN_DAYS\h+\d+\b' "$LOGIN_DEFS" | awk '{print $2}')

if [[ "$pass_min_days" -gt 0 ]]; then
  echo "PASS: PASS_MIN_DAYS ist auf $pass_min_days gesetzt und entspricht der lokalen Richtlinie."
else
  echo "FAIL: PASS_MIN_DAYS ist kleiner oder gleich 0: $pass_min_days."
fi

# Überprüfen der PASS_MIN_DAYS für alle Benutzer in /etc/shadow
echo "Überprüfen der PASS_MIN_DAYS für alle Benutzer in $SHADOW_FILE..."

invalid_users=$(awk -F: '($2~/^\$.+\$/) {if($4 < 1)print "User: " $1 " PASS_MIN_DAYS: " $4}' "$SHADOW_FILE")

if [[ -z "$invalid_users" ]]; then
  echo "PASS: Alle Benutzer haben PASS_MIN_DAYS größer als 0."
else
  echo "FAIL: Folgende Benutzer haben ungültige PASS_MIN_DAYS:"
  echo "$invalid_users"
fi
