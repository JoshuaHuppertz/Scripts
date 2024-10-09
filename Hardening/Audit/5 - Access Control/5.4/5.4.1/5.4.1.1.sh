#!/bin/bash

# Überprüfen der PASS_MAX_DAYS in /etc/login.defs
LOGIN_DEFS="/etc/login.defs"
SHADOW_FILE="/etc/shadow"
MAX_DAYS=365

# Überprüfen, ob die Datei /etc/login.defs existiert
if [[ ! -f "$LOGIN_DEFS" ]]; then
  echo "FAIL: Die Datei $LOGIN_DEFS existiert nicht."
  exit 1
fi

# Überprüfen von PASS_MAX_DAYS
pass_max_days=$(grep -Pi -- '^\h*PASS_MAX_DAYS\h+\d+\b' "$LOGIN_DEFS" | awk '{print $2}')

if [[ "$pass_max_days" -le "$MAX_DAYS" && "$pass_max_days" -gt 0 ]]; then
  echo "PASS: PASS_MAX_DAYS ist auf $pass_max_days gesetzt und entspricht der lokalen Richtlinie."
else
  echo "FAIL: PASS_MAX_DAYS ist entweder größer als $MAX_DAYS oder weniger als 1: $pass_max_days."
fi

# Überprüfen der PASS_MAX_DAYS für alle Benutzer in /etc/shadow
echo "Überprüfen der PASS_MAX_DAYS für alle Benutzer in $SHADOW_FILE..."

invalid_users=$(awk -F: '($2~/^\$.+\$/) {if($5 > 365 || $5 < 1)print "User: " $1 " PASS_MAX_DAYS: " $5}' "$SHADOW_FILE")

if [[ -z "$invalid_users" ]]; then
  echo "PASS: Alle Benutzer haben PASS_MAX_DAYS von $MAX_DAYS oder weniger und mehr als 0."
else
  echo "FAIL: Folgende Benutzer haben ungültige PASS_MAX_DAYS:"
  echo "$invalid_users"
fi
