#!/bin/bash

# Überprüfen der PASS_WARN_AGE in /etc/login.defs
LOGIN_DEFS="/etc/login.defs"
SHADOW_FILE="/etc/shadow"
MIN_WARN_AGE=7

# Überprüfen, ob die Datei /etc/login.defs existiert
if [[ ! -f "$LOGIN_DEFS" ]]; then
  echo "FAIL: Die Datei $LOGIN_DEFS existiert nicht."
  exit 1
fi

# Überprüfen von PASS_WARN_AGE
pass_warn_age=$(grep -Pi -- '^\h*PASS_WARN_AGE\h+\d+\b' "$LOGIN_DEFS" | awk '{print $2}')

if [[ "$pass_warn_age" -ge "$MIN_WARN_AGE" ]]; then
  echo "PASS: PASS_WARN_AGE ist auf $pass_warn_age gesetzt und entspricht der lokalen Richtlinie."
else
  echo "FAIL: PASS_WARN_AGE ist weniger als $MIN_WARN_AGE: $pass_warn_age."
fi

# Überprüfen der PASS_WARN_AGE für alle Benutzer in /etc/shadow
echo "Überprüfen der PASS_WARN_AGE für alle Benutzer in $SHADOW_FILE..."

invalid_users=$(awk -F: '($2~/^\$.+\$/) {if($6 < 7)print "User: " $1 " PASS_WARN_AGE: " $6}' "$SHADOW_FILE")

if [[ -z "$invalid_users" ]]; then
  echo "PASS: Alle Benutzer haben PASS_WARN_AGE von $MIN_WARN_AGE oder mehr."
else
  echo "FAIL: Folgende Benutzer haben ungültige PASS_WARN_AGE:"
  echo "$invalid_users"
fi
