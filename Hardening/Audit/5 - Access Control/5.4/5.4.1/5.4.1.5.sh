#!/bin/bash

# Überprüfen der INACTIVE-Einstellung
USERADD_D=$(useradd -D)
SITE_POLICY_INACTIVE=45

# Überprüfen, ob INACTIVE korrekt gesetzt ist
inactive_value=$(echo "$USERADD_D" | grep -Pi '^\h*INACTIVE' | awk '{print $2}')

if [[ "$inactive_value" -le "$SITE_POLICY_INACTIVE" && "$inactive_value" -ge 0 ]]; then
  echo "PASS: INACTIVE ist auf $inactive_value Tage gesetzt und entspricht der lokalen Richtlinie."
else
  echo "FAIL: INACTIVE ist nicht korrekt gesetzt: $inactive_value."
fi

# Überprüfen der INACTIVE-Werte für alle Benutzer in /etc/shadow
echo "Überprüfen der INACTIVE-Werte für alle Benutzer in /etc/shadow..."

invalid_users=$(awk -F: '($2~/^\$.+\$/) {if($7 > 45 || $7 < 0)print "User: " $1 " INACTIVE: " $7}' /etc/shadow)

if [[ -z "$invalid_users" ]]; then
  echo "PASS: Alle Benutzer haben INACTIVE von $SITE_POLICY_INACTIVE oder weniger."
else
  echo "FAIL: Folgende Benutzer haben ungültige INACTIVE-Werte:"
  echo "$invalid_users"
fi
