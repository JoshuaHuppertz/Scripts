#!/bin/bash

# Überprüfen der letzten Passwortänderung für alle Benutzer
echo "Überprüfen der letzten Passwortänderung für alle Benutzer..."

invalid_users=""

# Durchlaufen der Benutzer in /etc/shadow
while IFS= read -r l_user; do
  # Ermitteln des letzten Passwortänderungsdatums
  l_change=$(date -d "$(chage --list "$l_user" | grep '^Last password change' | cut -d: -f2 | grep -v 'never$')" +%s 2>/dev/null)
  
  # Prüfen, ob das Datum gültig ist und in der Zukunft liegt
  if [[ "$l_change" -gt "$(date +%s)" ]]; then
    invalid_users+="User: \"$l_user\" last password change was \"$(chage --list "$l_user" | grep '^Last password change' | cut -d: -f2)\"\n"
  fi
done < <(awk -F: '$2~/^\$.+\$/{print $1}' /etc/shadow)

# Überprüfung der Ergebnisse
if [[ -z "$invalid_users" ]]; then
  echo "PASS: Alle Benutzer haben gültige letzte Passwortänderungen."
else
  echo -e "FAIL: Folgende Benutzer haben ungültige letzte Passwortänderungen:\n$invalid_users"
fi
